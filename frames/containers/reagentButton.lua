--[[
	A style agnostic reagents utilities button.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local Sushi = LibStub('Sushi-3.2')
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local ReagentButton = Addon.Tipped:NewClass('ReagentButton', 'CheckButton', true)


--[[ Construct ]]--

function ReagentButton:New(...)
	local b = self:Super(ReagentButton):New(...)
	b:RegisterFrameSignal('FILTERS_CHANGED', 'Update')
	b:RegisterFrameSignal('OWNER_CHANGED', 'Update')
	b:SetScript('OnClick', b.OnClick)
	b:SetScript('OnEnter', b.OnEnter)
	b:SetScript('OnLeave', b.OnLeave)
	b:RegisterForClicks('anyUp')
	return b
end


--[[ Events ]]--

function ReagentButton:OnClick(button)
	if button == 'LeftButton' then
		local active = self:GetChecked()
		local profile = self:GetProfile()

		for i, bag in ipairs(self.frame.Bags) do
			profile.hiddenBags[bag] = self:IsStandard(bag) == active
			self:SendFrameSignal('FILTERS_CHANGED')
		end
	elseif DepositReagentBank then
		self:SetChecked(not self:GetChecked())
		DepositReagentBank()
	end
end

function ReagentButton:OnEnter()
	GameTooltip:SetOwner(self:GetTipAnchor())
	GameTooltip:SetText(MINIMAP_TRACKING_VENDOR_REAGENT)
	GameTooltip:AddLine(L.TipToggleTrade:format(L.LeftClick), 1,1,1)

	if DepositReagentBank then
		GameTooltip:AddLine(L.TipDepositReagents:format(L.RightClick), 1,1,1)
	end

	GameTooltip:Show()
end


--[[ API ]]--

function ReagentButton:Update()
	local profile = self:GetProfile()

	for i, bag in ipairs(self.frame.Bags) do
		if profile.hiddenBags[bag] ~= self:IsStandard(bag) then
			return self:SetChecked(false)
		end
	end

	self:SetChecked(true)
end

function ReagentButton:IsStandard(bag)
	local family = self.frame:GetBagFamily(bag)
	return family == 0 or family == 9
end