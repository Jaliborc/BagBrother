--[[
	Standard item filters included with the addon.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local Rules = Addon.Rules
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)

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

Rules:Register {id = 'all', title = ALL, icon = 'Interface/Addons/BagBrother/art/achievement-guildperk-mobilebanking', static = true}
Rules:Register {id = 'normal', title = L.NormalBags, icon = 133628, macro = 'return family == 0', static = true}
Rules:Register {id = 'trade', title = L.TradeBags, icon = 133669, macro = 'return family > 0', static = true}

if Addon.IsRetail then
	Rules:Register {id = 'player', title = PLAYER, icon = function(frame) return frame:GetOwner():GetIcon() end, macro = 'return family >= 0', static = true}
	Rules:Register {id = 'account', title = ACCOUNT_QUEST_LABEL, icon = 413577, macro = 'return family < 0', static = true}
end

do
	local classes = {
		[132894] = {'Tradegoods', 'Profession', 'Reagent', 'Recipe'},
		[133126] = {'Armor', 'Weapon', 'Gem'},
		[236669] = {'Questitem'},
		[134414] = {'Miscellaneous'},
		[134756] = {'Consumable'},
	}

	for icon, ids in pairs(classes) do
		Rules:Register {id = ids[1]:lower(), title = GetItemClassInfo(Enum.ItemClass[ids[1]]), icon = icon, macro = belongsToClass(ids)}
	end
end