--[[
	cache.lua
		The old BagBrother, now implemented as a feature within the Wildpants core, where it can take advantage of its API.
--]]


local ADDON, Addon = ...
local Cache = Addon:NewModule('Cache')
local C = LibStub('C_Everywhere').Container

local LAST_BANK_SLOT = NUM_BANKBAGSLOTS + Addon.NumBags
local FIRST_BANK_SLOT = 1 + Addon.NumBags
local NUM_VAULT_ITEMS = 80 * 2


--[[ Startup ]]--

function Cache:OnEnable()
	local player, realm = UnitFullName('player')
	BrotherBags = BrotherBags or {}
	BrotherBags[realm] = BrotherBags[realm] or {}

	self.realm = BrotherBags[realm]
	self.realm[player] = self.realm[player] or {equip = {}}
	self.player = self.realm[player]
	self.player.faction = UnitFactionGroup('player') == 'Alliance'
	self.player.race = select(2, UnitRace('player'))
	self.player.class = UnitClassBase('player')
	self.player.sex = UnitSex('player')

	self:RegisterSignal('BAG_UPDATE')
	self:RegisterSignal('BAG_UPDATE')
	self:RegisterSignal('VAULT_CLOSE')
	self:RegisterSignal('BANK_CLOSE')
	self:RegisterEvent('PLAYER_MONEY')
	self:RegisterEvent('GUILD_ROSTER_UPDATE')
	self:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')

	if CanGuildBankRepair then
		self:RegisterEvent('GUILDBANKBAGSLOTS_CHANGED')
	end

	for i = BACKPACK_CONTAINER, NUM_TOTAL_EQUIPPED_BAG_SLOTS or NUM_BAG_SLOTS do
		self:BAG_UPDATE(nil, i)
	end

	if HasKey and HasKey() then
		self:BAG_UPDATE(nil, KEYRING_CONTAINER)
	end

	for i = 1, INVSLOT_LAST_EQUIPPED do
		self:SaveEquip(i)
	end

	self:GUILD_ROSTER_UPDATE()
	self:PLAYER_MONEY()
end


--[[ Events ]]--

function Cache:BAG_UPDATE(_,bag)
	if bag <= Addon.NumBags then
  		self:SaveBag(bag, bag <= BACKPACK_CONTAINER, bag == BACKPACK_CONTAINER or bag == KEYRING_CONTAINER and HasKey and HasKey())
	end
end

function Cache:PLAYER_EQUIPMENT_CHANGED(_,slot)
	self:SaveEquip(slot)
end

function Cache:PLAYER_MONEY()
	self.player.money = GetMoney()
end

function Cache:BANK_CLOSE()
	if Addon.Events.AtBank then
		for i = FIRST_BANK_SLOT, LAST_BANK_SLOT do
			self:SaveBag(i)
		end

		if REAGENTBANK_CONTAINER and IsReagentBankUnlocked() then
			self:SaveBag(REAGENTBANK_CONTAINER, true)
		end

		self:SaveBag(BANK_CONTAINER, true)
	end
end

function Cache:VAULT_CLOSE()
	if Addon.Events.AtVault then
		self.player.vault = {}

		for i = 1, NUM_VAULT_ITEMS do
			local id = GetVoidItemInfo(1, i)
    		self.player.vault[i] = id and tostring(id) or nil
  		end
  	end
end

function Cache:GUILD_ROSTER_UPDATE()
	self.player.guild = GetGuildInfo('player')
end

function Cache:GUILDBANKBAGSLOTS_CHANGED()
	if Addon.Events.AtGuild then
		local id = GetGuildInfo('player') .. '*'
		local guild = self.realm[id] or {}
		guild.faction = UnitFactionGroup('player') == 'Alliance'

		for i = 1, GetNumGuildBankTabs() do
			guild[i] = guild[i] or {}
			guild[i].name, guild[i].icon, guild[i].view = GetGuildBankTabInfo(i)
		end

		local tab = GetCurrentGuildBankTab()
		local items = guild[tab]
		if items then
			items.deposit, items.withdraw, items.remaining = select(4, GetGuildBankTabInfo(tab))

			for i = 1, 98 do
				local link = GetGuildBankItemLink(tab, i)
				local _, count = GetGuildBankItemInfo(tab, i)

				items[i] = self:ParseItem(link, count)
			end
		end

		self.realm[id] = guild
	end
end


--[[ API ]]--

function Cache:SaveBag(bag, onlyItems, saveSize)
	local size = C.GetContainerNumSlots(bag)
	if size > 0 then
		local items = {}
		for slot = 1, size do
			local data = C.GetContainerItemInfo(bag, slot)
			if data then
				items[slot] = self:ParseItem(data.hyperlink, data.stackCount)
			end
		end

		if not onlyItems then
			self:SaveEquip(C.ContainerIDToInventoryID(bag), size)
		elseif saveSize then
			items.size = size
		end

		self.player[bag] = items
	else
		self.player[bag] = nil
	end
end

function Cache:SaveEquip(i, count)
	local link = GetInventoryItemLink('player', i)
	local count = count or GetInventoryItemCount('player', i)

	self.player.equip[i] = self:ParseItem(link, count)
end

function Cache:ParseItem(link, count)
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

		if link:find('0:0:0:0:0:%d+:%d+:%d+:0:0') then
			link = link:match('|H%l+:(%d+)')
		else
			link = link:match('|H%l+:([%d:]+)')
		end

		if count and count > 1 then
			link = link .. ';' .. count
		end

		return link
	end
end