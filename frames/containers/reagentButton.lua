--[[
	A style agnostic reagents deposit button.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local ReagentButton = Addon.Tipped:NewClass('ReagentButton', 'Button', true)

function ReagentButton:New(...)
	local b = self:Super(ReagentButton):New(...)
	b:SetScript('OnClick', b.OnClick)
	b:SetScript('OnEnter', b.OnEnter)
	b:SetScript('OnLeave', b.OnLeave)
	b:RegisterForClicks('anyUp')
	return b
end

function ReagentButton:OnEnter()
	self:ShowTooltip('Deposit Reagents')
end

function ReagentButton:OnClick()
	DepositReagentBank()
end