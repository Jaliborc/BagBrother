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

-- Patched for WoW Forever (controller UI): Bagnon took over Blizzard's bank windows by moving them
-- into a shrunken frame and removing their OnHide script. Forever's controller code touches those
-- panels whenever another panel opens or closes (Settings, Esc, mouse clicks), and anything an
-- addon changed on them makes it block SetPreferredGamepadInteractTarget ("taint from Bagnon").
-- On Forever the bank panels stay where they are with their scripts intact; they are only made
-- invisible and click-through while Bagnon shows its own window.
local mouseOff = setmetatable({}, {__mode = 'k'})
local function Conceal(frame, hidden)
	frame:SetAlpha(hidden and 0 or 1)
	if InCombatLockdown() then return end
	local function mouse(f)
		if hidden then
			if f:IsMouseEnabled() then
				mouseOff[f] = true
				f:EnableMouse(false)
			end
		elseif mouseOff[f] then
			mouseOff[f] = nil
			f:EnableMouse(true)
		end
		for _, child in ipairs({f:GetChildren()}) do
			mouse(child)
		end
	end
	mouse(frame)
end
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
	self.Tiny = CreateFrame('Frame', nil, Parent)
	self.Tiny:SetScale(0.001)

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
			hooksecurefunc(ContainerFrame1, 'UpdateCurrencyFrames', function(f)
				f.MoneyFrame:SetPoint('BOTTOMLEFT', 8, 8)
				f.MoneyFrame:SetPoint('BOTTOMRIGHT', -8, 8)

				BackpackTokenFrame:ClearAllPoints()
				BackpackTokenFrame:SetWidth(Addon.CurrencyLimit * 50)
			end)
		else
			BackpackTokenFrame:SetWidth(Addon.CurrencyLimit * 50)
		end
	end

	if ContainerFrameCombinedBags then
		hooksecurefunc('ToggleBackpack_Combined', function()
			if Addon.IsForever then
				-- Forever (controller UI): follow Blizzard's combined bag instead of toggling, so the
				-- two can't get out of step (a toggle from another hook, Bagnon's own close button)
				local handled = Addon.Frames:HasBag('inventory', 0)
				if handled then
					if ContainerFrameCombinedBags:IsShown() then
						Addon.Frames:Show('inventory')
					else
						Addon.Frames:Hide('inventory')
					end
				end
				ContainerFrameCombinedBags:SetParent(handled and self.Tiny or UIParent)
			else
				ContainerFrameCombinedBags:SetParent(Addon.Frames:ToggleBag('inventory', 0) and self.Tiny or UIParent)
			end
		end)
	end

	for i = 1, NUM_CONTAINER_FRAMES do
		hooksecurefunc(_G['ContainerFrame' .. i], 'SetID', function(frame, bag)
			if Addon.Frames:HasBag(Location(bag)) then
				frame:SetParent(self.Disabled)
			elseif frame:GetParent() == self.Disabled then
				frame:SetParent(Parent)
			end
		end)
	end

	hooksecurefunc('ToggleAllBags', function()
		if not debugstack():find('Manager') then
			Addon.Frames:Toggle('inventory')
		end
	end)

	hooksecurefunc('ToggleBackpack', function()
		-- Forever: with combined bags ToggleBackpack runs ToggleBackpack_Combined, handled above
		if Addon.IsForever and ContainerFrameCombinedBags and ContainerFrameSettingsManager
			and ContainerFrameSettingsManager:IsUsingCombinedBags() then
			return
		end
		local stack = debugstack()
    	if not stack:find('ToggleAllBags') and not stack:find('Manager') then
			Addon.Frames:ToggleBag('inventory', 0)
		end
	end)

	hooksecurefunc('ToggleBag', function(bag)
		-- Forever: with combined bags (always on in the controller UI) ToggleBag on a held bag runs
		-- ToggleBackpack_Combined, whose hook above already toggled Bagnon; toggling here as well
		-- closed it again in the same click (backpack button / B key in controller mode)
		if Addon.IsForever and ContainerFrameCombinedBags and ContainerFrameSettingsManager
			and ContainerFrameSettingsManager:IsUsingCombinedBags(bag) then
			return
		end
		local stack = debugstack()
    	if not stack:find('OpenBackpack') and not stack:find('ToggleBackpack') and not stack:find('Manager') then
			Addon.Frames:ToggleBag(Location(bag))
		end
	end)

	hooksecurefunc('ShowUIPanel', function(panel)
		local frame = panel and Panels[panel:GetName()]
		if frame and Addon.IsForever then
			Conceal(panel, Addon.Frames:Show(frame) and true or false)
		elseif frame then
			local enabled = Addon.Frames:Show(frame)
			panel.__onhide = panel.__onhide or panel:GetScript('OnHide')
			panel:SetScript('OnHide', not enabled and panel.__onhide or nil)
			panel:SetParent(enabled and self.Tiny or UIParent)

			if enabled then
				self:Delay('OnHiding') -- on 12.1 blizzard screwed up GuildBank implemenation
			end
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

function Overrides:OnHiding()
	for i = 1, select('#', self.Tiny:GetChildren()) do
		local frame = select(i, self.Tiny:GetChildren())
		if frame then
			frame:SetParent(self.Disabled)
		end
	end
end