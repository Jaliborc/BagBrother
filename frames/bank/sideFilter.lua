--[[
	A in-porgress implementation of bank tabs for retail.
	All Rights Reserved
--]]

if not (C_Bank and C_Bank.FetchPurchasedBankTabData) then
	return
end

local ADDON, Addon = (...):match('%w+'), _G[(...):match('%w+')]
local Filter = Addon.Tipped:NewClass('SideFilter', 'ItemButton')


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
		self:GetParent():ShowMenu()
	else
		local macro = self.rule.macro and loadstring(format('return function(frame, bag, slot, family, info) %s end', self.rule.macro))

		self.frame.rule = self.rule
		self.frame.filter = macro and macro() or self.rule.filter or self.rule.search and function(_,_,info) return Search:Matches(info.itemID, self.rule.search) end
		self:SendFrameSignal('FILTERS_CHANGED')
	end
end

function Filter:OnEnter()
	self:ShowTooltip(self.rule:GetValue('title', self.frame))
end