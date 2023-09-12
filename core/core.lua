--[[
	core.lua
		Computes global constants and sets up config loading
		All Rights Reserved
--]]

local ADDON, Addon = ...
local Addon = LibStub('WildAddon-1.0'):NewAddon(ADDON, Addon, 'LibItemCache-2.0')

Addon.Version = GetAddOnMetadata(ADDON, 'Version')
Addon.IsRetail = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
Addon.IsClassic = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
Addon.NumBags = NUM_TOTAL_EQUIPPED_BAG_SLOTS or NUM_BAG_SLOTS
Addon.CurrencyLimit = 30  -- safety tracking limit

Addon.None = {}
Addon.BankBags = {BANK_CONTAINER}
Addon.InventoryBags = {}

for i = BACKPACK_CONTAINER, Addon.NumBags do
	tinsert(Addon.InventoryBags, i)
end

if HasKey then
	tinsert(Addon.InventoryBags, KEYRING_CONTAINER)
end

for i = Addon.NumBags + 1, Addon.NumBags + NUM_BANKBAGSLOTS do
	tinsert(Addon.BankBags, i)
end

if REAGENTBANK_CONTAINER then
	tinsert(Addon.BankBags, REAGENTBANK_CONTAINER)
end

function Addon:OnEnable()
	if NUM_TOTAL_EQUIPPED_BAG_SLOTS then
		C_CVar.SetCVarBitfield('closedInfoFrames', LE_FRAME_TUTORIAL_EQUIP_REAGENT_BAG, true)
	end

	CreateFrame('Frame', nil, SettingsPanel or InterfaceOptionsFrame):SetScript('OnShow', function()
		LoadAddOn(ADDON .. '_Config')
	end)
end

function Addon:ShowOptions()
	if LoadAddOn(ADDON .. '_Config') then
		Addon.GeneralOptions:Open()
	end
end