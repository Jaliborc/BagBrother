--[[
	bagToggle.lua
		A style agnostic bag toggle button
--]]

local ADDON, Addon = ...
local Sushi = LibStub('Sushi-3.1')
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local BagToggle = Addon.Tipped:NewClass('BagToggle', 'CheckButton', true)
local Dropdown = CreateFrame('Frame', ADDON .. 'BagToggleDropdown', nil, 'UIDropDownMenuTemplate')


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

function BagToggle:OnClick(button)
	if button == 'LeftButton' then
		local profile = self:GetProfile()
		profile.showBags = not profile.showBags or nil

		self:SendFrameSignal('BAG_FRAME_TOGGLED')
	else
		Addon.Frames:Show(self:GetFrameID() == 'bank' and 'inventory' or 'bank', self:GetOwner())
		self:Update()
	end
end

function BagToggle:OnEnter()
	GameTooltip:SetOwner(self:GetTipAnchor())
	GameTooltip:SetText(BAGSLOTTEXT)

	if self:IsBagGroupShown() then
		GameTooltip:AddLine(L.TipHideBags:format(L.LeftClick), 1,1,1)
	else
		GameTooltip:AddLine(L.TipShowBags:format(L.LeftClick), 1,1,1)
	end

	GameTooltip:AddLine(L.TipFrameToggle:format(L.RightClick), 1,1,1)
	GameTooltip:Show()
end


--[[ API ]]--

function BagToggle:Update()
	self:SetChecked(self:IsBagGroupShown())
end

function BagToggle:IsBagGroupShown()
	return self:GetProfile().showBags
end
