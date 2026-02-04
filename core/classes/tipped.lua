--[[
	Abstract class with utility methods for managing tooltips.
  All Rights Reserved
--]]

local ADDON, Addon = ...
local Tipped = Addon.Parented:NewClass('Tipped')
Tipped.Markup = {
	['|S'] = WHITE_FONT_COLOR:WrapTextInColorCode('+' .. SHIFT_KEY_TEXT:sub(1,1):upper() .. SHIFT_KEY_TEXT:sub(2):lower()), --'|TInterface/AddOns/BagBrother/art/test:14:14|t'
	['|L'] = '|A:NPE_LeftClick:14:14|a',
	['|R'] = '|A:NPE_RightClick:14:14|a',
}

function Tipped:OnLeave()
	if GameTooltip:IsOwned(self) then
		GameTooltip_HideBattlePetTooltip()
		GameTooltip:Hide()
	end
end

function Tipped:ShowTooltip(title, ...)
	GameTooltip:SetOwner(self:GetTipAnchor())
	GameTooltip:AddLine(title, 1,1,1)

	for i = 1, select('#', ...) do
		if select(i, ...) then
			GameTooltip:AddLine(self.MarkupTooltip(select(i, ...)))
		end
	end

	GameTooltip:Show()
end

function Tipped.MarkupTooltip(text)
	return text:gsub('(%|.)', Tipped.Markup), nil
end

function Tipped:GetTipAnchor()
	return self, self:IsFarRight() and 'ANCHOR_LEFT' or 'ANCHOR_RIGHT'
end