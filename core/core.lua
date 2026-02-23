--[[
	core.lua
		Computes global constants and sets up config loading
		All Rights Reserved
--]]

local ADDON, Addon = ...
local C = LibStub('C_Everywhere')
local Addon = LibStub('WildAddon-1.1'):NewAddon(ADDON, Addon, 'StaleCheck-1.0')

Addon.IsRetail = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
Addon.IsClassic = LE_EXPANSION_LEVEL_CURRENT == LE_EXPANSION_CLASSIC
Addon.IsModern = LE_EXPANSION_LEVEL_CURRENT >= LE_EXPANSION_CATACLYSM

Addon.NumBags = NUM_TOTAL_EQUIPPED_BAG_SLOTS or NUM_BAG_SLOTS
Addon.LastBankBag = Addon.NumBags + (NUM_BANKBAGSLOTS or Constants.InventoryConstants.NumCharacterBankSlots)
Addon.LastAccountBag = Addon.LastBankBag + (Constants.InventoryConstants.NumAccountBankSlots or 0)
Addon.CurrencyLimit = 30  -- safety tracking limit
Addon.InventoryBags = {}
Addon.BankBags = {}

for i = BACKPACK_CONTAINER, Addon.NumBags do
	tinsert(Addon.InventoryBags, i)
end

if HasKey then
	tinsert(Addon.InventoryBags, KEYRING_CONTAINER)
end

if BANK_CONTAINER then
	tinsert(Addon.BankBags, BANK_CONTAINER)
end

for i = Addon.NumBags + 1, Addon.LastBankBag do
	tinsert(Addon.BankBags, i)
end

if REAGENTBANK_CONTAINER then
	tinsert(Addon.BankBags, REAGENTBANK_CONTAINER)
end

if C.Bank.AreAnyBankTypesViewable then
	for i = Addon.LastBankBag + 1, Addon.LastAccountBag do
		tinsert(Addon.BankBags, i)
	end
end

function Addon_SetBankType(type)
	Addon.BankType = type
end

function Addon_GetBankType()
	return Addon.BankType or 0
end

if not GameFontNormalCenter then
	local font = CreateFont('GameFontNormalCenter')
	font:SetFontObject(GameFontNormal)
	font:SetJustifyH('CENTER')
end

function Addon:OnLoad()
	SettingsPanel.CategoryList:HookScript('OnShow', function() C.AddOns.LoadAddOn(ADDON .. '_Config') end)
	if AddonCompartmentFrame then
		AddonCompartmentFrame:RegisterAddon {
			text = ADDON, keepShownOnClick = true, notCheckable = true,
			icon = 'interface/addons/bagbrother/art/' ..ADDON .. '-small',
			func = function() self:ShowOptions() end
		}
	end

	self:ContinueOn('PLAYER_ENTERING_WORLD', function()
		self:CheckForUpdates(ADDON, self.sets, 'interface/addons/bagbrother/art/'..ADDON..'-big')
		
		local inv = self.Frames:New('inventory') -- prevent combat block
		if inv then
			inv:Update()
		end
	end)
end

function Addon:ShowOptions()
	if C.AddOns.LoadAddOn(ADDON .. '_Config') then
		Addon.GeneralOptions:Open()
	end
end