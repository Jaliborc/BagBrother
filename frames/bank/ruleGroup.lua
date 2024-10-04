--[[
	A static, temporary implementation of bank tabs for retail, until I'm ready to mport the more feature-complete version from Bagnonium.
	All Rights Reserved
--]]

if not (C_Bank and C_Bank.FetchPurchasedBankTabData) then
	return
end

local ADDON, Addon = (...):match('%w+'), _G[(...):match('%w+')]
local Rules = Addon.Parented:NewClass('RuleGroup', 'Frame')

function Rules:New(frame)
	local f = self:Super(Rules):New(frame)
	f.buttons = {}

	for i, id in ipairs(frame.profile.filters) do 
		local rule = Addon.Rules:Get(id)
		local b = CreateFrame('ItemButton', nil, f)
		b.icon:SetTexture(GetValueOrCallFunction(rule, 'icon'))
		b:SetPoint('TOP', 0, -i*42)
		b:SetScript('OnClick', function() 
			f.active = rule

			frame.filter = rule.macro and loadstring(format('return function(bag, slot, info, family) %s end', rule.macro))() or
						   rule.search and function(_,_,info) return Search:Matches(info.itemID, rule.search) end or
						   rule.func
			frame:SendFrameSignal('FILTERS_CHANGED')
		end)
		
		MenuUtil.HookTooltipScripts(b, function(tip)
			GameTooltip_SetTitle(tip, GetValueOrCallFunction(rule, 'title'))
		end)

		local checked = b:CreateTexture()
		checked:SetTexture('Interface/Buttons/CheckButtonHilight')
		checked:SetBlendMode('ADD')
		checked:SetAllPoints()

		b.rule = rule
		b.checked = checked
		f.buttons[i] = b
	end

	f:RegisterFrameSignal('FILTERS_CHANGED', 'Update')
	f:SetPoint('BOTTOMLEFT', frame, 'BOTTOMRIGHT')
	f:SetPoint('TOPLEFT', frame, 'TOPRIGHT')
	f:SetWidth(38)
	f:SetScale(.8)
	f:Update()
	f:Show()
	return f
end


function Rules:Update()
	for i, button in ipairs(self.buttons) do 
		button.checked:SetShown(button.rule == self.active)
	end
end

-- temp
function Addon.Bank:New(...)
	local f = self:Super(Addon.Bank):New(...)
	f.RuleGroup = Rules(f)
	return f
end