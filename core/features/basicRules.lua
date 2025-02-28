--[[
	Standard item filters included with the addon.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local Rules = Addon.Rules

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

Rules:Register {id = 'all', title = ALL, icon = 'Interface/Addons/BagBrother/art/achievement-guildperk-mobilebanking'}
Rules:Register {id = 'normal', title = 'Normal Bags', icon = 133628, macro = 'return family == 0'}
Rules:Register {id = 'trade', title = 'Trade Bags', icon = 133669, macro = 'return family > 0'}
Rules:Register {id = 'reagent', title = GetItemClassInfo(Enum.ItemClass.Tradegoods), icon = 132894,
				macro = format('if family > 0 then\n return true\nelse%s', belongsToClass{'Profession', 'Tradegoods', 'Reagent', 'Recipe'})}

if Addon.IsRetail then
	Rules:Register {id = 'player', title = PLAYER, icon = function(frame) return frame:GetOwner():GetIcon() end, macro = 'return family >= 0'}
	Rules:Register {id = 'account', title = ACCOUNT_QUEST_LABEL, icon = 413577, macro = 'return family < 0'}
end

do
	local classes = {
		[133126] = {'Armor', 'Weapon', 'Gem'},
		[236669] = {'Questitem'},
		[134414] = {'Miscellaneous'},
		[134756] = {'Consumable'},
	}

	for icon, ids in pairs(classes) do
		Rules:Register {id = ids[1]:lower(), title = GetItemClassInfo(Enum.ItemClass[ids[1]]), icon = icon, macro = belongsToClass(ids)}
	end
end