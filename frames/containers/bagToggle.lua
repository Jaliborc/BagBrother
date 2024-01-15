--[[
	A style agnostic bag toggle button.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local Sushi = LibStub('Sushi-3.2')
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local BagToggle = Addon.Tipped:NewClass('BagToggle', 'CheckButton', true)


--[[ Construct ]]--

function BagToggle:New(...)
	local b = self:Super(BagToggle):New(...)
	b:SetScript('OnHide', b.UnregisterAll)
	b:SetScript('OnClick', b.OnClick)
	b:SetScript('OnEnter', b.OnEnter)
	b:SetScript('OnLeave', b.OnLeave)
	b:SetScript('OnShow', b.OnShow)
	b:RegisterForClicks('anyUp')
	b:Update()
	return b
end


--[[ Events ]]--

function BagToggle:OnShow()
	self:RegisterFrameSignal('OWNER_CHANGED', 'Update')
	self:Update()
end

function BagToggle:OnEnter()
	self:ShowTooltip(L.Bags,
		'|L ' .. (self:IsBagGroupShown() and L.HideSlots or L.ViewSlots),
		'|R ' .. AREA_NAME_FONT_COLOR:WrapTextInColorCode(self:IsFocusingTrade() and L.FocusNormal or L.FocusTrade) .. '|A:NPE_ExclamationPoint:12:18|a')
end

function BagToggle:OnClick(button)
	if button == 'LeftButton' then
		local profile = self:GetProfile()
		profile.showBags = not profile.showBags or nil
		self:SendFrameSignal('BAG_FRAME_TOGGLED')
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
