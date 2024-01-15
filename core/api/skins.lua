--[[
	Methods for registering frame skins.
	See https://github.com/jaliborc/BagBrother/wiki/Skins-API for details.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local Skins = Addon:NewModule('Skins', 'MutexDelay-1.0')
Skins.Registry = {}


--[[ Public API ]]--

function Skins:Register(skin)
	assert(type(skin) == 'table', '#1 argument must be a table')
	assert(type(skin.id) == 'string', 'skin.id must be a string')
	assert(type(skin.template) == 'string', 'skin.template must be a string')

	self.Registry[skin.id] = skin
	self:Delay(0, 'SendSignal', 'SKINS_LOADED')
end

function Skins:Get(id)
	return type(id) == 'string' and self.Registry[id]
end

function Skins:Iterate()
	local skins = GetValuesArray(self.Registry)
	sort(skins, function(a, b) return a.id < b.id end)
	return ipairs(skins)
end


--[[ Additional Methods ]]--

function Skins:Acquire(id)
	local skin = self:Get(id) or self:Get(self.Default)
	skin.pool = skin.pool or CreateFramePool('Frame', UIParent, skin.template)

	local frame = skin.pool:Acquire()
	frame.skin = skin
	frame:Show()
	return frame
end

function Skins:Call(method, frame, ...)
	GetValueOrCallFunction(frame.skin, method, frame, ...)
end

function Skins:Release(frame)
	self:Call('reset', frame)
	frame.skin.pool:Release(frame)
end