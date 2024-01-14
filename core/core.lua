--[[
	core.lua
		Computes global constants and sets up config loading
		All Rights Reserved
--]]

local ADDON, Addon = ...
local C = LibStub('C_Everywhere').AddOns
local Addon = LibStub('WildAddon-1.0'):NewAddon(ADDON, Addon, 'LibItemCache-2.0')

Addon.Version =  C.GetAddOnMetadata(ADDON, 'version')
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

	self:RegisterEvent('PLAYER_ENTERING_WORLD', function() self.Frames:New('inventory') end)
	SettingsPanel.CategoryList:HookScript('OnShow', function() C.LoadAddOn(ADDON .. '_Config') end)
	if AddonCompartmentFrame then
		AddonCompartmentFrame:RegisterAddon {
			text = ADDON, keepShownOnClick = true, notCheckable = true,
			icon = 'interface/addons/bagbrother/art/' ..ADDON .. '-small',
			func = function() self:ShowOptions() end
		}
	end
end

function Addon:ShowOptions()
	if C.LoadAddOn(ADDON .. '_Config') then
		Addon.GeneralOptions:Open()
	end
end