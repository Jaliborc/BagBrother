--[[
	Abstract class for widgets that are parented to a frame.
  All Rights Reserved
--]]

local ADDON, Addon = ...
local Parented = Addon.Base:NewClass('Parented')

function Parented:New(parent)
	local f = self:Super(Parented):New(parent)
	f.frame = parent.frame or parent
	return f
end

function Parented:GetFrameID()
	return self.frame.id
end

for _, method in ipairs {'GetOwner', 'GetProfile', 'IsCached', 'GetBagFamily', 'NumSlots', 'IsShowingBag', 'IsShowingItem', 'GetBagInfo', 'GetItemInfo'} do
	Parented[method] = loadstring(format('return function(self, ...) return self.frame:%s(...) end', method))()
end