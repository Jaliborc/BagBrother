--[[
	sortButton.lua
		A style agnostic item sorting button
--]]

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local SortButton = Addon.Tipped:NewClass('SortButton', 'CheckButton', true)


--[[ Construct ]]--

function SortButton:New(...)
	local b = self:Super(SortButton):New(...)
	b:RegisterSignal('SORTING_STATUS')
	b:SetScript('OnClick', b.OnClick)
	b:SetScript('OnEnter', b.OnEnter)
	b:SetScript('OnLeave', b.OnLeave)
	b:RegisterForClicks('anyUp')
	return b
end

function SortButton:SORTING_STATUS(_, id)
	self:SetChecked(id == self:GetFrameID())
end


--[[ Interaction ]]--

function SortButton:OnClick(button)
	if button == 'RightButton' and DepositReagentBank then
		self:SetChecked(nil)
		return DepositReagentBank()
	end

	if not self:GetChecked() then
		Addon.Sorting:Stop()
	elseif not self.frame:IsCached() then
		self.frame:SortItems()
	end
end

function SortButton:OnEnter()
	GameTooltip:SetOwner(self:GetTipAnchor())

	if DepositReagentBank then
		GameTooltip:SetText(BAG_FILTER_CLEANUP)
		GameTooltip:AddLine(L.TipCleanItems:format(L.LeftClick), 1,1,1)
		GameTooltip:AddLine(L.TipDepositReagents:format(L.RightClick), 1,1,1)
	else
		GameTooltip:SetText(L.TipCleanItems:format(L.Click))
	end

	GameTooltip:Show()
end
