--[[
	A side tab to activate a rule.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local Tab = Addon.Tipped:NewClass('Tab', 'CheckButton', true)
local C = LibStub('C_Everywhere')

function Tab:SetRule(rule, checked)
	local icon, isAtlas = rule:GetIcon(self.frame)
	local border = self.Border

	if border and self.frame.id == 'inventory' then -- kinda dirty
		border:SetPoint('TOP', -15,12)
		border:SetTexCoord(1, 0, 0, 1)
	end

	self:SetScale(.8)
	self:SetChecked(checked)
	self.Icon[isAtlas and 'SetAtlas' or 'SetTexture'](self.Icon, icon)
	self.rule = rule
end

function Tab:OnClick(mouse)
	if mouse == 'RightButton' then
		self:SetChecked(not self:GetChecked())

		if C.AddOns.LoadAddOn(ADDON .. '_Config') then
			Addon.RuleEdit:OpenMenu(self:GetParent())
		end
	elseif IsShiftKeyDown() and self.rule.equipSet then
		self:SetChecked(not self:GetChecked())
		C.EquipmentSet.UseEquipmentSet(self.rule.equipSet)
	else
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		self:GetParent():SetActive(self.rule)
		self:SendFrameSignal('FILTERS_CHANGED')
	end
end

function Tab:OnEnter()
	self:ShowTooltip(self.rule:GetValue('title', self.frame), '|R ' .. OPTIONS, self.rule.equipSet and ('|L|S ' .. EQUIPSET_EQUIP) or '')
end