--[[
	A container frame for bags.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Bags = Addon.Parented:NewClass('BagGroup', 'Frame')

function Bags:New(parent, from, x, y)
	local f = self:Super(Bags):New(parent)
	local button, off, k

	for i, bag in ipairs(parent.Bags) do
		k = i-1
		button, off = f:CreateButton(bag)
		button:SetPoint(from, x*k + (off or 0), y*k)
	end

	f:SetSize(k * abs(x) + button:GetWidth(), k * abs(y) + button:GetHeight())
	f:RegisterFrameSignal('BAG_FRAME_TOGGLED', 'UpdateShown')
	f:UpdateShown()
	return f
end

function Bags:CreateButton(bag)
	local class = bag > Addon.LastBankBag and Addon.BankTab or Addon.Bag
	return class(self, bag), bag > Addon.LastBankBag and 10
end

function Bags:UpdateShown()
	self:SetShown(self:GetProfile().showBags)
end
