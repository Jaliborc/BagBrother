--[[
	Methods for creating and browsing item rulesets.
	See https://github.com/Jaliborc/BagBrother/wiki/Rules-API for details.
	All Rights Reserved
--]]


local ADDON, Addon = ...
local C = LibStub('C_Everywhere')
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
	self:Delay('SendSignal', 'RULES_CHANGED')
end

function Rules:Unregister(id)
	assert(self.Registry[id], 'id not registered')

	self.Registry[id] = nil
	self:Delay('SendSignal', 'RULES_CHANGED')
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
	return icon, C.Texture.GetAtlasExists(icon)
end

function Rules:Compile()
	local macro = self.macro and loadstring(format('return function(frame, bag, slot, family, info) %s end', self.macro))
	local search = self.search and function(frame, bag, slot, _, info)
		return frame:SearchItem(self.search, bag, slot, info)
	end

	return macro and macro() or search or self.filter
end