--[[
	A style agnostic bag toggle button.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local Sushi = LibStub('Sushi-3.2')
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local BagToggle = Addon.Tipped:NewClass('BagToggle', 'CheckButton', true)


--[[ Events ]]--

function BagToggle:New(...)
	local b = self:Super(BagToggle):New(...)
	b:SetScript('OnHide', b.UnregisterAll)
	b:RegisterForClicks('anyUp')
	return b
end

function BagToggle:OnShow()
	self:RegisterFrameSignal('OWNER_CHANGED', 'Update')
	self:Update()
end

function BagToggle:OnEnter()
	self:ShowTooltip(L.Bags,
		'|L ' .. (self:IsBagGroupShown() and L.HideSlots or L.ViewSlots),
		'|R ' .. (self:IsFocusingTrade() and L.FocusNormal or L.FocusTrade))
end

function BagToggle:OnClick(button)
	if button == 'LeftButton' then
		self:GetProfile().showBags = not self:GetProfile().showBags or nil
		self:SendFrameSignal('BAG_FRAME_TOGGLED')
		
		PlaySound(self:GetProfile().showBags and 857 or 856)
	else
		local profile = self:GetProfile()
		local focus = not self:IsFocusingTrade()

		for i, bag in ipairs(self.frame.Bags) do
			profile.hiddenBags[bag] = self:IsStandardBag(bag) == focus
			self:SendFrameSignal('FILTERS_CHANGED')
		end
	end
end


--[[ API ]]--

function BagToggle:Update()
	self:SetChecked(self:IsBagGroupShown())
end

function BagToggle:IsBagGroupShown()
	return self:GetProfile().showBags
end

function BagToggle:IsFocusingTrade()
	local profile = self:GetProfile()
	for i, bag in ipairs(self.frame.Bags) do
		if self:IsStandardBag(bag) and not profile.hiddenBags[bag] then
			return false
		end
	end
	return true
end

function BagToggle:IsStandardBag(bag)
	local family = self.frame:GetBagFamily(bag)
	return family == 0 or family == 9
end
