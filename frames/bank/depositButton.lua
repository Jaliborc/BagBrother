--[[
	A style agnostic reagents deposit button.
	All Rights Reserved
--]]

if not REAGENTBANK_CONTAINER then
	return
end

local ADDON, Addon = (...):match('%w+'), _G[(...):match('%w+')]
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local DepositButton = Addon.Tipped:NewClass('DepositButton', 'Button', true)

function DepositButton:New(...)
	local b = self:Super(DepositButton):New(...)
	b:RegisterForClicks('anyUp')
	return b
end

function DepositButton:OnClick(button)
	if button == 'RightButton' then
		local toggle = function(var) Addon.sets[var] = not Addon.sets[var] end
		local get = function(var) return Addon.sets[var] end

		MenuUtil.CreateContextMenu(self, function(_, drop)
			drop:SetTag(ADDON .. 'DepositOptions')
			drop:CreateTitle(GUILDCONTROL_DEPOSIT_ITEMS)
			drop:CreateCheckbox(BAG_FILTER_REAGENTS, get, toggle, 'depositReagents')
			drop:CreateCheckbox(ITEM_ACCOUNTBOUND, get, toggle, 'depositAccount')
				:CreateCheckbox(L.IncludeReagents, GetCVarBool, function(cvar)
					SetCVar(cvar, GetCVarBool(cvar) and '0' or '1')
				end, 'bankAutoDepositReagents')
		end)
	else
		if Addon.sets.depositReagents and IsReagentBankUnlocked() then
			DepositReagentBank()
		end

		if Addon.sets.depositAccount then
			C_Bank.AutoDepositItemsIntoBank(2)
		end

		PlaySound(SOUNDKIT.UI_BAG_SORTING_01)
	end
end

function DepositButton:OnEnter()
	self:ShowTooltip(GUILDCONTROL_DEPOSIT_ITEMS, '|R ' .. OPTIONS)
end