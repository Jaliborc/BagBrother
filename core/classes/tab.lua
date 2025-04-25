--[[
	A side tab to activate a rule.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local Tab = Addon.Tipped:NewClass('SideTab', 'ItemButton')
local Search = LibStub('ItemSearch-1.3')


--[[ Startup ]]--

function Tab:Construct()
	local b = self:Super(Tab):Construct()
	b.IconOverlay:SetTexture('Interface/Buttons/CheckButtonHilight')
	b.IconOverlay:SetBlendMode('ADD')
	b.IconBorder:SetDrawLayer('BACKGROUND')
	b.IconBorder:SetColorTexture(0,0,0)
	b.IconBorder:SetSize(35,35)
	b.IconBorder:Show()
	b:SetScale(.8)
	return b
end

function Tab:SetRule(rule)
	local icon, isAtlas = rule:GetIcon(self.frame)

	self.IconOverlay:SetShown(rule == self.frame.rule)
	self.icon[isAtlas and 'SetAtlas' or 'SetTexture'](self.icon, icon)
	self.rule = rule
	self:Show()
end


--[[ Interaction ]]--

function Tab:OnClick(mouse)
	if mouse == 'RightButton' then
		if C_AddOns.LoadAddOn(ADDON .. '_Config') then
			Addon.RuleEdit:OpenMenu(self:GetParent())
		end
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