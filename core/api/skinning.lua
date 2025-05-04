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

function Skins:Acquire(id, parent)
	local skin = self:Get(id) or self:Get(self.Default)
	local bg = skin[parent] or CreateFrame('Frame', nil, parent, skin.template)
	bg:EnableMouse(true)
	bg:SetFrameLevel(0)
	bg.skin = skin
	bg:Show()

	return bg
end

function Skins:Call(method, bg, ...)
	return GetValueOrCallFunction(bg.skin, method, bg, ...)
end

function Skins:Release(bg)
	self:Call('reset', bg)
	bg:Hide()
end