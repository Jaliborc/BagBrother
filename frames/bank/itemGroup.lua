--[[
	The bank's item grid, switches to live events when needed when the bank is opened.
	All Rights Reserved
--]]

local ADDON, Addon = (...):match('%w+'), _G[(...):match('%w+')]
local Items = Addon.ContainerGroup:NewClass('BankItemGroup')

function Items:RegisterEvents()
	self:Super(Items):RegisterEvents()
	if self:IsCached() then
		self:RegisterSignal('BANK_OPEN', 'RegisterEvents')
	end
end