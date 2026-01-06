--[[
	Shows tracked currencies.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local C = LibStub('C_Everywhere').CurrencyInfo
local CurrencyTracker = Addon.Parented:NewClass('CurrencyTracker', 'Frame')


--[[ Construct ]]--

function CurrencyTracker:New(parent, font)
	local f = self:Super(CurrencyTracker):New(parent)
	f:SetScript('OnSizeChanged', f.OnSizeChanged)
	f:SetScript('OnHide', f.UnregisterAll)
	f.font, f.buttons = font, {}

	C.hooksecurefunc('SetCurrencyBackpack', function()
		if f:IsVisible() then
			f:Layout()
		end
	end)
	return f
end

function CurrencyTracker:OnShow()
	self:RegisterEvent('CURRENCY_DISPLAY_UPDATE', 'Layout')
	self:RegisterFrameSignal('OWNER_CHANGED', 'Layout')
	self:Layout()
end

function CurrencyTracker:OnSizeChanged()
	self:SendFrameSignal('ELEMENT_RESIZED')
end


--[[ Update ]]--

function CurrencyTracker:Layout()
	for _,button in ipairs(self.buttons) do
		button:Hide()
	end

	local x,y,w = 0,0,2
	local function addButton(i, data)
		local b = self:GetButton(i)
		b:Set(data, i)

		local width = b:GetWidth()
		if (x + width) > self:MaxWidth() then
			w = max(w, x)
			x,y = 0, y + 20
		end

		b:SetPoint('TOPRIGHT', self, -x,-y)
		x = x + width
	end

	if self:IsCached() then
		local owner = self:GetOwner()
		for i, id in ipairs(owner.currency and owner.currency.tracked or Addon.None) do
			addButton(i, {currencyTypesID = id, quantity = owner.currency[id], iconFileID = C.GetCurrencyInfo(id).iconFileID})
		end
	else
		for i = 1, Addon.CurrencyLimit do
			local data = C.GetBackpackCurrencyInfo(i)
			if data then
				addButton(i, data)
			else
				break
			end
		end
	end

	self:SetSize(max(w, x), y+22)
end

function CurrencyTracker:GetButton(i)
	return GetOrCreateTableEntryByCallback(self.buttons, i, GenerateClosure(Addon.Currency, self, self.font))
end