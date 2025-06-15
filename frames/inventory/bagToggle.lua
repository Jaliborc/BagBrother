--[[
	A style agnostic bag toggle button.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local BagToggle = Addon.Tipped:NewClass('BagToggle', 'CheckButton', true)

function BagToggle:OnShow()
	self:SetChecked(self.frame:AreBagsShown())
end

function BagToggle:OnEnter()
	self:ShowTooltip(L.Bags)
end

function BagToggle:OnClick(button)
	if button == 'LeftButton' then
		PlaySound(self:GetChecked() and 857 or 856)
		self:GetProfile().showBags = self:GetChecked() or nil
		self:SendFrameSignal('BAG_FRAME_TOGGLED')
	else
		Addon.Frames:Toggle('bank')
		self:OnShow()
	end
end