--[[
	A currency button.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local C = LibStub('C_Everywhere').CurrencyInfo
local Currency = Addon.Tipped:NewClass('Currency', 'Button')

function Currency:New(parent, font)
	local b = self:Super(Currency):New(parent)
	b:SetNormalFontObject(font)
	b:SetHeight(24)
	return b
end

function Currency:Set(data, index)
	local iconArgs = HONOR_POINT_TEXTURES and tContains(HONOR_POINT_TEXTURES, data.iconFileID) and ':64:64:0:40:0:40'

	self.data, self.index = data, index
	self:SetText(format('%s|T%s:14:14:2:0%s|t  ', FormatLargeNumber(data.quantity or 0), data.iconFileID or 0, iconArgs or ''))
	self:Show()
	self:SetWidth(self:GetTextWidth() + 2)
end

function Currency:OnClick()
	if not HandleModifiedItemClick(C.GetCurrencyLink(self.data.currencyTypesID, self.data.quantity)) and not self:IsCached() then
		if IsShiftKeyDown() then
			for i = 1, C.GetCurrencyListSize() do
				local info = C.GetCurrencyListInfo(i)
				if info and info.currencyID == self.data.currencyTypesID then
					return C.SetCurrencyBackpack(i, 0)
				end
			end
		else
			ToggleCharacter('TokenFrame')
		end
	end
end

function Currency:OnEnter()
	GameTooltip:SetOwner(self:GetTipAnchor())
	if self:IsCached() then
		(GameTooltip.SetCurrencyByID or GameTooltip.SetCurrencyTokenByID)(GameTooltip, self.data.currencyTypesID)
	else
		GameTooltip:SetBackpackToken(self.index)
	end
end
