--[[
	Dynamically handles when to display Bagnon or Blizzard frames, taint free.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local Overrides = Addon:NewModule('Overrides', 'MutexDelay-1.0')

local function Location(bag)
	return bag > Addon.NumBags and 'bank' or 'inventory', bag
end

local Parent = ContainerFrameContainer or UIParent
local Panels = {
	BankFrame = 'bank',
	GuildBankFrame = 'guild',
	VoidStorageFrame = 'vault'
}

function Overrides:OnLoad()
	self:RegisterEvent('CVAR_UPDATE', self.Delay, 'OnCVar')
	self.Disabled = CreateFrame('Frame', nil, Parent)
	self.Disabled:SetAllPoints()
	self.Disabled:Hide()

	if LE_FRAME_TUTORIAL_EQUIP_REAGENT_BAG then
		C_CVar.SetCVarBitfield('closedInfoFrames', LE_FRAME_TUTORIAL_EQUIP_REAGENT_BAG, true)
		C_CVar.SetCVarBitfield('closedInfoFrames', LE_FRAME_TUTORIAL_HUD_REVAMP_BAG_CHANGES, true)
		C_CVar.SetCVarBitfield('closedInfoFrames', LE_FRAME_TUTORIAL_BAG_SLOTS_AUTHENTICATOR, true)
		C_CVar.SetCVarBitfield('closedInfoFrames', LE_FRAME_TUTORIAL_MOUNT_EQUIPMENT_SLOT_FRAME, true)
		C_CVar.SetCVarBitfield('closedInfoFrames', LE_FRAME_TUTORIAL_UPGRADEABLE_ITEM_IN_SLOT, true)

		if Addon.Frames:IsEnabled('inventory') then
			C_CVar.SetCVar('combinedBags', nil)
		end
	end

	if BackpackTokenFrame then
		if ContainerFrame1.UpdateCurrencyFrames then
			hooksecurefunc(ContainerFrame1, 'UpdateCurrencyFrames', function()
				BackpackTokenFrame:ClearAllPoints()
				BackpackTokenFrame:SetWidth(Addon.CurrencyLimit * 50)
			end)
		else
			BackpackTokenFrame:SetWidth(Addon.CurrencyLimit * 50)
		end
	end

	for i = 1, NUM_CONTAINER_FRAMES do
		hooksecurefunc(_G['ContainerFrame' .. i], 'SetID', function(frame, bag)
			local disabled = Addon.Frames:HasBag(Location(bag))
			frame:SetParent(disabled and self.Disabled or Parent)
		end)
	end

	hooksecurefunc('ToggleAllBags', function()
		if not debugstack():find('Manager') then
			Addon.Frames:Toggle('inventory')
		end
	end)

	hooksecurefunc('ToggleBackpack', function()
		local stack = debugstack()
    	if not stack:find('ToggleAllBags') and not stack:find('Manager') then
			Addon.Frames:ToggleBag('inventory', 0)
		end
	end)

	hooksecurefunc('ToggleBag', function(bag)
		local stack = debugstack()
    	if not stack:find('OpenBackpack') and not stack:find('ToggleBackpack') and not stack:find('Manager') then
			Addon.Frames:ToggleBag(Location(bag))
		end
	end)

	hooksecurefunc('ShowUIPanel', function(panel)
		local frame = panel and Panels[panel:GetName()]
		if frame then
			local enabled = Addon.Frames:Show(frame)
			panel.__onhide = panel.__onhide or panel:GetScript('OnHide')
			panel:SetScript('OnHide', not enabled and panel.__onhide or nil)
			panel:SetParent(enabled and self.Disabled or UIParent)
		end
	end)

	hooksecurefunc('HideUIPanel', function(panel)
		local frame = panel and Panels[panel:GetName()]
		if frame then
			Addon.Frames:Hide(frame)
		end
	end)

	hooksecurefunc('MaximizeUIPanel', function()
		self:SendSignal('HIDE_ALL')
	end)
end

function Overrides:OnCVar(var)
	if var == 'combinedBags' and not InCombatLockdown() and Addon.Frames:IsEnabled('inventory') then
		C_CVar.SetCVar('combinedBags', nil)
	end
end