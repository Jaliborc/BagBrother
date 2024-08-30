--[[
	A style agnostic reagents deposit button.
	All Rights Reserved
--]]

if not REAGENTBANK_CONTAINER then
	return
end

local ADDON, Addon = ...
local DepositButton = Addon.Tipped:NewClass('DepositButton', 'Button', true)

function DepositButton:New(...)
	local b = self:Super(DepositButton):New(...)
	b:RegisterForClicks('anyUp')
	return b
end

function DepositButton:OnClick(button)
	if button == 'RightButton' then
		MenuUtil.CreateContextMenu(self, function(_, drop)
			drop:SetTag(ADDON .. 'DepositOptions')
			drop:CreateTitle('Deposit Options')
			drop:CreateCheckbox('Reagents', nop, nop)
			drop:CreateCheckbox('Warbound Items', nop, nop)
				:CreateCheckbox('Include Reagents', nop, nop)
		end)
	else
		DepositReagentBank()
		C_Bank.AutoDepositItemsIntoBank(2)
	end
end

function DepositButton:OnEnter()
	self:ShowTooltip(GUILDCONTROL_DEPOSIT_ITEMS, '|R ' .. OPTIONS)
end