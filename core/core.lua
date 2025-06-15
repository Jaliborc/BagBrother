--[[
	core.lua
		Computes global constants and sets up config loading
		All Rights Reserved
--]]

local ADDON, Addon = ...
local C = LibStub('C_Everywhere').AddOns
local Addon = LibStub('WildAddon-1.1'):NewAddon(ADDON, Addon, 'StaleCheck-1.0')

Addon.IsRetail = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
Addon.IsClassic = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC

Addon.NumBags = NUM_TOTAL_EQUIPPED_BAG_SLOTS or NUM_BAG_SLOTS
Addon.LastBankBag = Addon.NumBags + NUM_BANKBAGSLOTS
Addon.LastAccountBag = Addon.LastBankBag + (Constants.InventoryConstants.NumAccountBankSlots or 0)
Addon.CurrencyLimit = 30  -- safety tracking limit

Addon.BankBags = {BANK_CONTAINER}
Addon.InventoryBags = {}

for i = BACKPACK_CONTAINER, Addon.NumBags do
	tinsert(Addon.InventoryBags, i)
end

if HasKey then
	tinsert(Addon.InventoryBags, KEYRING_CONTAINER)
end

for i = Addon.NumBags + 1, Addon.LastBankBag do
	tinsert(Addon.BankBags, i)
end

if REAGENTBANK_CONTAINER then
	tinsert(Addon.BankBags, REAGENTBANK_CONTAINER)
end

if C_Bank and C_Bank.FetchPurchasedBankTabIDs then
	for i = Addon.LastBankBag + 1, Addon.LastAccountBag do
		tinsert(Addon.BankBags, i)
	end
end

function Addon:OnLoad()
	if LE_FRAME_TUTORIAL_EQUIP_REAGENT_BAG then
		C_CVar.SetCVarBitfield('closedInfoFrames', LE_FRAME_TUTORIAL_EQUIP_REAGENT_BAG, true)
		C_CVar.SetCVarBitfield('closedInfoFrames', LE_FRAME_TUTORIAL_HUD_REVAMP_BAG_CHANGES, true)
		C_CVar.SetCVarBitfield('closedInfoFrames', LE_FRAME_TUTORIAL_BAG_SLOTS_AUTHENTICATOR, true)
		C_CVar.SetCVarBitfield('closedInfoFrames', LE_FRAME_TUTORIAL_MOUNT_EQUIPMENT_SLOT_FRAME, true)
		C_CVar.SetCVarBitfield('closedInfoFrames', LE_FRAME_TUTORIAL_UPGRADEABLE_ITEM_IN_SLOT, true)
	end

	SettingsPanel.CategoryList:HookScript('OnShow', function() C.LoadAddOn(ADDON .. '_Config') end)
	if AddonCompartmentFrame then
		AddonCompartmentFrame:RegisterAddon {
			text = ADDON, keepShownOnClick = true, notCheckable = true,
			icon = 'interface/addons/bagbrother/art/' ..ADDON .. '-small',
			func = function() self:ShowOptions() end
		}
	end

	self:ContinueOn('PLAYER_ENTERING_WORLD', function()
		self:CheckForUpdates(ADDON, self.sets, 'interface/addons/bagbrother/art/'..ADDON..'-big')
		self.Frames:New('inventory') -- prevent combat block
	end)
end

function Addon:ShowOptions()
	if C.LoadAddOn(ADDON .. '_Config') then
		Addon.GeneralOptions:Open()
	end
end