--[[
	A container frame for bags.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Bags = Addon.Parented:NewClass('BagGroup', 'Frame')

function Bags:New(parent)
	local f = self:Super(Bags):New(parent)
	for i, bag in ipairs(parent.Bags) do
		local button, off = f:CreateButton(bag)
		button:SetPoint('LEFT', 36*(i-1) + (off or 0), 0)
	end

	f:SetSize(36 * #parent.Bags, 32)
	return f
end

function Bags:CreateButton(bag)
	local class = bag > Addon.LastBankBag and Addon.BankTab or Addon.Bag
	return class(self, bag), bag > Addon.LastBankBag and 10
end