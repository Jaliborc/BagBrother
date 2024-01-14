--[[
	Abstract class with utility methods for managing tooltips.
  All Rights Reserved
--]]

local ADDON, Addon = ...
local Tipped = Addon.Parented:NewClass('Tipped')

function Tipped:OnLeave()
  if GameTooltip:IsOwned(self) then
    GameTooltip:Hide()
  end

  if BattlePetTooltip then
    BattlePetTooltip:Hide()
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
  return text:gsub('|L', '|A:NPE_LeftClick:14:14|a'):gsub('|R', '|A:NPE_RightClick:14:14|a'), nil
end

function Tipped:GetTipAnchor()
  return self, self:IsFarLeft() and 'ANCHOR_LEFT' or 'ANCHOR_RIGHT'
end

function Tipped:IsFarLeft()
  return self:GetRight() > (GetScreenWidth() / 2)
end