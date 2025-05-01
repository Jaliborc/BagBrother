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
		self:GetProfile().showBags = not self:GetProfile().showBags or nil
		self:SendFrameSignal('BAG_FRAME_TOGGLED')
		
		PlaySound(self.frame:AreBagsShown() and 857 or 856)
	else
		Addon.Frames:Toggle('bank')
	end
end