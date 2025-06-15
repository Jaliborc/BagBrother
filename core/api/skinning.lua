--[[
	Methods for registering frame skins.
	See https://github.com/jaliborc/BagBrother/wiki/Skins-API for details.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local Skins = Addon:NewModule('Skins', 'MutexDelay-1.0')
Skins.Registry = {}

local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Meta = getmetatable(UIParent).__index
local function Error(...)
	print('|cff33ff99' .. ADDON .. '|r ' .. L.SkinError)
	geterrorhandler()(...)
end


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


--[[ Object API ]]--

function Skins:Acquire(id, parent)
	local skin = self:Get(id) or self:Get(self.Default)
	if not skin[parent] then
		local _,bg = xpcall(CreateFrame, Error, 'Frame', nil, parent, skin.template)
		skin[parent] = setmetatable(bg or CreateFrame('Frame', nil, parent), self)
	end

	local bg = skin[parent]
	bg.skin = skin
	bg:EnableMouse(true)
	bg:SetFrameLevel(0)
	bg:ClearAllPoints()
	bg:SetPoint('BOTTOMLEFT', bg.x or 0, bg.y or 0)
	bg:SetPoint('TOPRIGHT', bg.x1 or 0, bg.y1 or 0)
	bg:Show()

	return bg
end

function Skins:__call(key, ...)
	xpcall(GetValueOrCallFunction, Error, self.skin, key, self, ...)
end

function Skins:__index(key)
	return self.skin[key] or Skins[key] or Meta[key]
end

function Skins:Release()
	self('reset')
	self:Hide()
end