--[[
	A in-porgress implementation of bank tabs for retail.
	All Rights Reserved
--]]

local ADDON, Addon = (...):match('%w+'), _G[(...):match('%w+')]
local Filter = Addon.Tipped:NewClass('SideFilter', 'ItemButton')
local Search = LibStub('ItemSearch-1.3')


--[[ Startup ]]--

function Filter:Construct()
	local b = self:Super(Filter):Construct()
	b.IconOverlay:SetTexture('Interface/Buttons/CheckButtonHilight')
	b.IconOverlay:SetBlendMode('ADD')
	b.IconBorder:SetDrawLayer('BACKGROUND')
	b.IconBorder:SetColorTexture(0,0,0)
	b.IconBorder:SetSize(35,35)
	b.IconBorder:Show()
	return b
end

function Filter:SetRule(rule)
	local icon, isAtlas = rule:GetIcon(self.frame)

	self.IconOverlay:SetShown(rule == self.frame.rule)
	self.icon[isAtlas and 'SetAtlas' or 'SetTexture'](self.icon, icon)
	self.rule = rule
	self:Show()
end


--[[ Interaction ]]--

function Filter:OnClick(mouse)
	if mouse == 'RightButton' then
		if C_AddOns.LoadAddOn(ADDON .. '_Config') then
			Addon.FilterEdit:OpenMenu(self:GetParent())
		end
	else
		local macro = self.rule.macro and loadstring(format('return function(frame, bag, slot, family, info) %s end', self.rule.macro))
		local search = self.rule.search and function(_,_,_,_, info) return info.itemID and Search:Matches(info.hyperlink, self.rule.search) end

		self.frame.rule = self.rule
		self.frame.filter = search or macro and macro() or self.rule.filter
		self:SendFrameSignal('FILTERS_CHANGED')
	end
end

function Filter:OnEnter()
	self:ShowTooltip(self.rule:GetValue('title', self.frame))
end