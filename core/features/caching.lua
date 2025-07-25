--[[
	The old BagBrother, now implemented as a feature within the Wildpants core,
	where it can take advantage of Wildpants API and dependencies.
	All Rights Reserved
--]]


local ADDON, Addon = ...
local Cacher = Addon:NewModule('Cacher')
local C = LibStub('C_Everywhere')

local FIRST_BANK_SLOT = 1 + Addon.NumBags
local LAST_BANK_SLOT = Addon.LastBankBag
local NUM_VAULT_ITEMS = 80 * 2


--[[ Startup ]]--

function Cacher:OnLoad()
	self.player = Addon.player.cache
	self.player.currency = {tracked = {}}
	self.player.equip = self.player.equip or {}
	self.player.faction = UnitFactionGroup('player') == 'Alliance'
	self.player.race = select(2, UnitRace('player'))
	self.player.class = UnitClassBase('player')
	self.player.level = UnitLevel('player')
	self.player.sex = UnitSex('player')

	self:RegisterEvent('PLAYER_MONEY')
	self:RegisterEvent('PLAYER_LEVEL_UP')
	self:RegisterEvent('PLAYER_EQUIPMENT_CHANGED', 'SaveEquip')
	self:RegisterEvent('CURRENCY_DISPLAY_UPDATE')
	self:RegisterEvent('GUILD_ROSTER_UPDATE')
	self:RegisterSignal('BAG_UPDATED')
	self:RegisterSignal('BANK_CLOSE')
	self:RegisterSignal('VAULT_CLOSE')

	if GetNumGuildBankTabs then
		self:RegisterEvent('GUILDBANKBAGSLOTS_CHANGED')

		if C.Bank.CanPurchaseBankTab then
			self:RegisterEvent('BANK_TABS_CHANGED', 'BANK_CLOSE')
		end
	end

	C.CurrencyInfo.hooksecurefunc('SetCurrencyBackpack', function()
		self:CURRENCY_TRACKED_CHANGED()
	end)

	for i = BACKPACK_CONTAINER, Addon.NumBags do
		self:SaveBag(i)
	end

	if HasKey and HasKey() then
		self:SaveBag(KEYRING_CONTAINER)
	end

	for i = 1, INVSLOT_LAST_EQUIPPED do
		self:SaveEquip(i)
	end

	for id = 1, 5000 do
		local data = C.CurrencyInfo.GetCurrencyInfo(id)
		if data and data.quantity > 0 and data.quality > 0 and not C.CurrencyInfo.IsAccountWideCurrency(id) then
			self.player.currency[id] = data.quantity
		end
	end

	self:CURRENCY_TRACKED_CHANGED()
	self:GUILD_ROSTER_UPDATE()
	self:PLAYER_MONEY()
end


--[[ Events ]]--

function Cacher:BAG_UPDATED(bag, ...)
	if bag >= BACKPACK_CONTAINER and bag <= Addon.NumBags and (bag ~= KEYRING_CONTAINER or HasKey and HasKey()) then
  		self:SaveBag(bag)
	end
end

function Cacher:PLAYER_LEVEL_UP(_, level)
	self.player.level = level
end

function Cacher:PLAYER_MONEY()
	self.player.money = GetMoney()
end

function Cacher:CURRENCY_DISPLAY_UPDATE(_,id)
	if id and not C.CurrencyInfo.IsAccountWideCurrency(id) then
		local info = C.CurrencyInfo.GetCurrencyInfo(id)
		if info then
			self.player.currency[id] = (info.quantity or 0) > 0 and info.quantity or nil
		end
	end
end

function Cacher:CURRENCY_TRACKED_CHANGED()
	wipe(self.player.currency.tracked)

	for i = 1, Addon.CurrencyLimit do
		local data = C.CurrencyInfo.GetBackpackCurrencyInfo(i)
		if data then
			tinsert(self.player.currency.tracked, data.currencyTypesID)
		end
	end
end

function Cacher:BANK_CLOSE()
	if C.Bank.CanViewBank(0) then
		if NUM_BANKBAGSLOTS then
			for i = FIRST_BANK_SLOT, LAST_BANK_SLOT do
				self:SaveBag(i)
			end
			if REAGENTBANK_CONTAINER and IsReagentBankUnlocked() then
				self:SaveBag(REAGENTBANK_CONTAINER)
			end
			self:SaveBag(BANK_CONTAINER)
		else
			self:SaveBank(self.player, 0)
		end
	end

	if C.Bank.CanViewBank(2) then
		self:SaveBank(BrotherBags.account, 2)
	end
end

function Cacher:VAULT_CLOSE()
	local items = {}
	for i = 1, NUM_VAULT_ITEMS do
		local id = GetVoidItemInfo(1, i)
		items[i] = id and tostring(id) or nil
	end

	GetOrCreateTableEntry(self.player, 'vault').items = items
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
		local data = guild[tab]
		if data and select(3, GetGuildBankTabInfo(tab)) then
			local items = {}
			for i = 1, 98 do
				local link = GetGuildBankItemLink(tab, i)
				local _, count = GetGuildBankItemInfo(tab, i)

				items[i] = self:ParseItem(link, count)
			end

			data.items = items
		end
	end
end


--[[ API ]]--

function Cacher:SaveBank(domain, type)
	for i, bag in pairs(C.Bank.FetchPurchasedBankTabData(type)) do
		Mixin(self:PopulateBag(domain, bag.ID), bag)
	end
end

function Cacher:SaveEquip(slot)
	self.player.equip[slot] = self:ParseItem(GetInventoryItemLink('player', slot), GetInventoryItemCount('player', slot))
end

function Cacher:SaveBag(bag)
	self:PopulateBag(self.player, bag)
end

function Cacher:PopulateBag(data, bag)
	local size = C.Container.GetContainerNumSlots(bag)
	local data = GetOrCreateTableEntry(data, bag)
	if size > 0 then
		data.link = bag > BACKPACK_CONTAINER and self:ParseItem(GetInventoryItemLink('player', C.Container.ContainerIDToInventoryID(bag))) or nil
		data.size = (bag >= BACKPACK_CONTAINER or bag == KEYRING_CONTAINER) and size or nil
		data.items = {}

		for slot = 1, size do
			local item = C.Container.GetContainerItemInfo(bag, slot)
			if item then
				data.items[slot] = self:ParseItem(item.hyperlink, item.stackCount)
			end
		end
	else
		data.items, data.link, data.size = nil
	end

	return data
end

function Cacher:ParseItem(link, count)
	if link then
		local id = tonumber(link:match('item:(%d+):')) -- check for profession window bug
		if id == 0 and TradeSkillFrame then
			local focus = GetMouseFoci and GetMouseFoci()[1] or GetMouseFocus and GetMouseFocus()
			local name = focus:GetName()
			if name == 'TradeSkillSkillIcon' then
				link = GetTradeSkillItemLink(TradeSkillFrame.selectedSkill)
			else
				local i = name:match('TradeSkillReagent(%d+)')
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
