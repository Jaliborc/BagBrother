--[[
	Methods for creating and browsing item rulesets.
	See https://github.com/jaliborc/BagBrother/wiki/Ruleset-API for details.
	All Rights Reserved
--]]


local ADDON, Addon = ...
local Rules = Addon:NewModule('Rules')
Rules.registry = {}


--[[ Public API ]]--

function Rules:New(data)
	assert(type(data) == 'table', 'data must be a table')
	assert(type(data.id) == 'string', 'data.id must be a string')

	for id in pairs(self.registry) do
		assert(data.id ~= id, 'data.id must be unique, id already registered')
	end

	self.registry[data.id] = data
end

function Rules:Get(id)
	return self.registry[id] or Addon.sets.customRules[id]
end

function Rules:Iterate()
	return pairs(self.registry)
end

function Rules:IterateCustom()
	return pairs(Addon.sets.customRules)
end


--[[ Default Rulesets ]]--

Addon.Rules:New {id = 'all', title = ALL, icon = 413587}
Addon.Rules:New {id = 'player', title = PLAYER, icon = 895888, macro = 'return family >= 0'}
Addon.Rules:New {id = 'account', title = ACCOUNT_QUEST_LABEL, icon = 629054, macro = 'return family < 0'}