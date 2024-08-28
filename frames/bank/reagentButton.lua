--[[
	A style agnostic reagents deposit button.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local ReagentButton = Addon.Tipped:NewClass('ReagentButton', 'Button', true)

function ReagentButton:New(...)
	local b = self:Super(ReagentButton):New(...)
	b:SetScript('OnEnter', function() b:ShowTooltip(REAGENTBANK_DEPOSIT) end)
	b:SetScript('OnClick', DepositReagentBank)
	b:SetScript('OnLeave', b.OnLeave)
	b:RegisterForClicks('anyUp')
	return b
end