--[[
	Shows tracked currencies.
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

	local x,y,w = 0,0,2
	local function addButton(i, data)
		data.iconArgs = HONOR_POINT_TEXTURES and tContains(HONOR_POINT_TEXTURES, data.iconFileID) and ':64:64:0:40:0:40'
		data.index = i
	
		local b = self:GetButton(i)
		b:Set(data)

		if (x + b:GetWidth() + 20) > self.frame.ItemGroup:GetWidth() then
			w = max(w, x)
			x,y = 0, y + 20
		end

		b:SetPoint('TOPRIGHT', self, -x,-y)
		x = x + b:GetWidth()
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
	self.buttons[i] = self.buttons[i] or Addon.Currency(self)
	return self.buttons[i]
end