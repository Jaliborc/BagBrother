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


--[[ Default Rulesets ]]--

local function belongsToClass(classes)
	local condition = ''
	for i, class in ipairs(classes) do
		condition = condition .. format(' or class == Enum.ItemClass.%s', class)
	end

	return format([[if info.itemID then
		local _,_,_,_,_, class = C_Item.GetItemInfoInstant(info.itemID)
		return %s
	end]], condition:sub(5))
end

Rules:New {id = 'all', title = ALL, icon = 413587}
Rules:New {id = 'player', title = PLAYER, icon = function(frame) return frame:GetOwner():GetIcon() end, macro = 'return family >= 0'}
Rules:New {id = 'account', title = ACCOUNT_QUEST_LABEL, icon = 413577, macro = 'return family < 0'}
Rules:New {id = 'trade', title = TRADE_SKILLS, icon = 236573, macro = format('if family > 0 then\n return true\nelse%s', belongsToClass{'Profession', 'Tradegoods', 'Reagent', 'Recipe'})}

do
	local classes = {
		[135650] = {'Armor', 'Weapon', 'Gem'},
		[236669] = {'Questitem'},
		[134414] = {'Miscellaneous'},
		[134756] = {'Consumable'},
	}

	for icon, ids in pairs(classes) do
		Rules:New {id = ids[1]:lower(), title = GetItemClassInfo(Enum.ItemClass[ids[1]]), icon = icon, macro = belongsToClass(ids)}
	end
end