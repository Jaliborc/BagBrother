--[[
	Methods for creating and browsing item rulesets.
	See https://github.com/jaliborc/BagBrother/wiki/Ruleset-API for details.
	All Rights Reserved
--]]


local ADDON, Addon = ...
local Rules = Addon:NewModule('Rules', 'MutexDelay-1.0')
Rules.Registry = {}


--[[ Static API ]]--

function Rules:OnLoad()
	for i, rule in ipairs(Addon.sets.customRules) do
		setmetatable(rule, self)
	end

	self.GetValue = GetValueOrCallFunction
	self.__index = self
end

function Rules:Register(data)
	assert(type(data) == 'table', 'data must be a table')
	assert(type(data.id) == 'string', 'data.id must be a string')
	assert(type(data.title) == 'string', 'data.title must be a string')
	assert(not self.Registry[data.id], 'data.id must be unique, id already registered')

	self.Registry[data.id] = setmetatable(data, self)
	self:Delay(0, 'SendSignal', 'RULES_LOADED')
end

function Rules:Get(id)
	return self.Registry[id] or Addon.sets.customRules[id]
end

function Rules:Iterate()
	return pairs(self.Registry)
end


--[[ Object API ]]--

function Rules:GetIconMarkup(size, frame)
	local icon, isAtlas = self:GetIcon(frame)
	return isAtlas and CreateAtlasMarkup(icon, size,size) or
			icon and CreateSimpleTextureMarkup(icon, size)
end

function Rules:GetIcon(frame)
	local icon = self:GetValue('icon', frame) or QUESTION_MARK_ICON
	return icon, C_Texture.GetAtlasID(icon) ~= 0
end