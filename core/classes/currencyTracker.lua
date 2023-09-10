--[[
	currencyTracker.lua
		Shows tracked currencies
		All Rights Reserved
--]]

local ADDON, Addon = ...
local C = LibStub('C_Everywhere').CurrencyInfo
local CurrencyTracker = Addon.Parented:NewClass('CurrencyTracker', 'Frame')

if BackpackTokenFrame then
	function BackpackTokenFrame:GetMaxTokensWatched() return Addon.CurrencyLimit end
end


--[[ Construct ]]--

function CurrencyTracker:New(parent)
	local f = self:Super(CurrencyTracker):New(parent)
	f.buttons = {}
	f:SetScript('OnShow', f.RegisterEvents)
	f:SetScript('OnHide', f.UnregisterAll)
	f:RegisterEvents()
	f:SetHeight(24)

	C.hooksecurefunc('SetCurrencyBackpack', function()
		if f:IsVisible() then
			f:Update()
		end
	end)
	return f
end

function CurrencyTracker:RegisterEvents()
	self:RegisterEvent('CURRENCY_DISPLAY_UPDATE', 'Update')
	self:RegisterFrameSignal('OWNER_CHANGED', 'Layout')
	self:Layout()
end


--[[ Update ]]--

function CurrencyTracker:Update()
	self:Layout()
	self:SendFrameSignal('ELEMENT_RESIZED')
end

function CurrencyTracker:Layout()
	for _,button in ipairs(self.buttons) do
		button:Hide()
	end

	local w = 0
	if not self:IsCached() then
		for i = 1, Addon.CurrencyLimit do
			local data = C.GetBackpackCurrencyInfo(i)
			if data then
				w = w + self:AddButton(i, data)
			else
				break
			end
		end
	else
		local owner = self:GetOwner()
		for i, id in ipairs(owner.currency and owner.currency.tracked or {}) do
			w = w + self:AddButton(i, {currencyTypesID = id, quantity = owner.currency[id], iconFileID = C.GetCurrencyInfo(id).iconFileID})
		end
	end

	self:SetWidth(max(w, 2))
end

function CurrencyTracker:AddButton(i, data)
	data.iconArgs = HONOR_POINT_TEXTURES and tContains(HONOR_POINT_TEXTURES, data.iconFileID) and ':64:64:0:40:0:40'
	data.index = i

	self.buttons[i] = self.buttons[i] or Addon.Currency(self)
	self.buttons[i]:SetPoint('LEFT', self.buttons[i-1] or self, i > 1 and 'RIGHT' or 'LEFT')
	self.buttons[i]:Set(data)

	return self.buttons[i]:GetWidth()
end
