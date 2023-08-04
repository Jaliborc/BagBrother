--[[
	cache.lua
		The old BagBrother, now implemented as a feature within the Wildpants core,
		where it can take advantage of Wildpants API and dependencies.
--]]


local ADDON, Addon = ...
local Cacher = Addon:NewModule('Cacher')
local C = LibStub('C_Everywhere').Container

local LAST_BANK_SLOT = NUM_BANKBAGSLOTS + Addon.NumBags
local FIRST_BANK_SLOT = 1 + Addon.NumBags
local NUM_VAULT_ITEMS = 80 * 2


--[[ Startup ]]--

function Cacher:OnEnable()
	self.player = Addon.player.cache
	self.player.equip = self.player.equip or {}
	self.player.faction = UnitFactionGroup('player') == 'Alliance'
	self.player.race = select(2, UnitRace('player'))
	self.player.class = UnitClassBase('player')
	self.player.level = UnitLevel('player')
	self.player.sex = UnitSex('player')
	--[[
		When the player interacts with the banker and the bank window opens, event BANKFRAME_OPENED fires once.
		After that, if the player closes the bank window manually, event BANKFRAME_CLOSED also fires once and bank vault data is still available for caching.
		But if the bank window closes automatically (for example when the player moves away from the banker) then event BANKFRAME_CLOSED fires twice in a row.
		When BANKFRAME_CLOSED event fires for the first time the bank data is still available, when it fires the second time the bank data is no longer available (so the player's bank cache can be overwritten with empty data).
		As of August 4, 2023, this behavior is typical for WotLK and not for Retail, where bank data remains available for caching even after the second trigger of the BANKFRAME_CLOSED event.
		
		isBankFrameOpen parameter is used to avoid caching empty data when the bank window is closed and no data is available.
	--]]
	self.isBankFrameOpen = false

	self:RegisterSignal('BAG_UPDATE')
	--[[
		Register signal BANK_OPEN for Blizzard API event BANKFRAME_OPENED
	--]]
	self:RegisterSignal('BANK_OPEN')
	self:RegisterSignal('BANK_CLOSE')
	self:RegisterSignal('VAULT_CLOSE')
	self:RegisterEvent('PLAYER_MONEY')
	self:RegisterEvent('GUILD_ROSTER_UPDATE')
	self:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')
	self:RegisterEvent('PLAYER_LEVEL_UP')

	if GetNumGuildBankTabs then
		self:RegisterEvent('GUILDBANKBAGSLOTS_CHANGED')
	end

	for i = BACKPACK_CONTAINER, Addon.NumBags do
		self:SaveBag(i)
	end

	if HasKey and HasKey() then
		self:SaveBag(KEYRING_CONTAINER)
	end

	for i = 1, INVSLOT_LAST_EQUIPPED do
		self:SaveEquip(i)
	end

	self:GUILD_ROSTER_UPDATE()
	self:PLAYER_MONEY()
end


--[[ Events ]]--

function Cacher:BAG_UPDATE(_,bag)
	if bag >= BACKPACK_CONTAINER and bag <= Addon.NumBags and (bag ~= KEYRING_CONTAINER or HasKey and HasKey()) then
  		self:SaveBag(bag)
	end
end

function Cacher:PLAYER_EQUIPMENT_CHANGED(_,slot)
	self:SaveEquip(slot)
end

function Cacher:PLAYER_MONEY()
	self.player.money = GetMoney()
end

function Cacher:PLAYER_LEVEL_UP(_, level)
	self.player.level = level
end

--[[
	Switching the state of parameter in order to further determine whether the bank window is open and whether player's data is available for caching
--]]
function Cacher:BANK_OPEN()
	self.isBankFrameOpen = true
end

function Cacher:BANK_CLOSE()
	--[[
		If the banking window is open then the player's data is available for caching
	--]]
	if self.isBankFrameOpen then
		for i = FIRST_BANK_SLOT, LAST_BANK_SLOT do
			self:SaveBag(i)
		end
		if REAGENTBANK_CONTAINER and IsReagentBankUnlocked() then
			self:SaveBag(REAGENTBANK_CONTAINER)
		end
		self:SaveBag(BANK_CONTAINER)
	end
	--[[
		Returning the state of the parameter to its default value
	--]]
	self.isBankFrameOpen = false
end

function Cacher:VAULT_CLOSE()
	self.player.vault = {}

	for i = 1, NUM_VAULT_ITEMS do
		local id = GetVoidItemInfo(1, i)
		self.player.vault[i] = id and tostring(id) or nil
	end
end

function Cacher:GUILD_ROSTER_UPDATE()
	self.player.guild = {GetGuildInfo('player')}
end

function Cacher:GUILDBANKBAGSLOTS_CHANGED()
	if Addon.Events.AtGuild then
		local guild = Addon.guild.cache
		guild.faction = self.player.faction

		for i = 1, GetNumGuildBankTabs() do
			guild[i] = guild[i] or {}
			guild[i].name, guild[i].icon = GetGuildBankTabInfo(i)
		end

		local tab = GetCurrentGuildBankTab()
		local items = guild[tab]
		if items and select(3, GetGuildBankTabInfo(tab)) then
			for i = 1, 98 do
				local link = GetGuildBankItemLink(tab, i)
				local _, count = GetGuildBankItemInfo(tab, i)

				items[i] = self:ParseItem(link, count)
			end
		end
	end
end


--[[ API ]]--

function Cacher:SaveBag(bag)
	local size = C.GetContainerNumSlots(bag)
	if size > 0 then
		local items = {}
		for slot = 1, size do
			local data = C.GetContainerItemInfo(bag, slot)
			if data then
				items[slot] = self:ParseItem(data.hyperlink, data.stackCount)
			end
		end

		if bag >= BACKPACK_CONTAINER or bag == KEYRING_CONTAINER then
			items.size = size
		end

		if bag > BACKPACK_CONTAINER then
			items.link = self:ParseItem(GetInventoryItemLink('player', C.ContainerIDToInventoryID(bag)))
		end

		self.player[bag] = items
	else
		self.player[bag] = nil
	end
end

function Cacher:SaveEquip(i)
	self.player.equip[i] = self:ParseItem(GetInventoryItemLink('player', i), GetInventoryItemCount('player', i))
end

function Cacher:ParseItem(link, count)
	if link then
		local id = tonumber(link:match('item:(%d+):')) -- check for profession window bug
		if id == 0 and TradeSkillFrame then
			local focus = GetMouseFocus():GetName()
			if focus == 'TradeSkillSkillIcon' then
				link = GetTradeSkillItemLink(TradeSkillFrame.selectedSkill)
			else
				local i = focus:match('TradeSkillReagent(%d+)')
				if i then
					link = GetTradeSkillReagentItemLink(TradeSkillFrame.selectedSkill, tonumber(i))
				end
			end
		end

		link = link:match('|H%l+:(%d+)::::::::%d+:%d+:::::::::') or link:match('|H%l+:([%d:]+)')
		if count and count > 1 then
			link = link .. ';' .. count
		end
		return link
	end
end
