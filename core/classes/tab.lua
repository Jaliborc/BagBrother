--[[
	A side tab to activate a rule.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local Tab = Addon.Tipped:NewClass('Tab', 'CheckButton', true)
local Search = LibStub('ItemSearch-1.3')

function Tab:SetRule(rule)
	local icon, isAtlas = rule:GetIcon(self.frame)

	self:SetChecked(rule == self.frame.rule)
	self.Icon[isAtlas and 'SetAtlas' or 'SetTexture'](self.Icon, icon)
	self.rule = rule
	self:Show()
end

function Tab:OnClick(mouse)
	if mouse == 'RightButton' then
		if C_AddOns.LoadAddOn(ADDON .. '_Config') then
			Addon.RuleEdit:OpenMenu(self:GetParent())
		end
		
		self:SetChecked(self.rule == self.frame.rule)
	else
		local macro = self.rule.macro and loadstring(format('return function(frame, bag, slot, family, info) %s end', self.rule.macro))
		local search = self.rule.search and function(_,_,_,_, info) return info.itemID and Search:Matches(info.hyperlink, self.rule.search) end

		self.frame.rule = self.rule
		self.frame.filter = search or macro and macro() or self.rule.filter
		self:SendFrameSignal('FILTERS_CHANGED')
		
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	end
end

function Tab:OnEnter()
	self:ShowTooltip(self.rule:GetValue('title', self.frame), '|R ' .. OPTIONS)
end