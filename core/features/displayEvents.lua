--[[
	Automatically toggles the inventory during certain game events and UI interactions.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local Display = Addon:NewModule('DisplayEvents')

local Interactions = {}
for name, id in pairs(Enum.PlayerInteractionType) do
	Interactions[id] = name:gsub('^.', strlower)
end

local function Callback(set, action)
	local code = format([[
		return function()
			if %s.sets.display.%s then
				%s.Frames:%s('inventory')
			end
		end
	]], ADDON, set, ADDON, action)

	return loadstring(code)()
end

function Display:OnLoad()
	self:RegisterEvent('PLAYER_INTERACTION_MANAGER_FRAME_SHOW')
	self:RegisterEvent('PLAYER_INTERACTION_MANAGER_FRAME_HIDE')
	self:RegisterEvent('TRADE_SKILL_SHOW', Callback('crafting', 'Show'))
	self:RegisterEvent('TRADE_SKILL_CLOSE', Callback('crafting', 'Hide'))
	self:RegisterEvent('PLAYER_REGEN_DISABLED', Callback('combat', 'Hide'))

	if C_ItemSocketInfo then
		self:RegisterEvent('SOCKET_INFO_UPDATE', Callback('socketing', 'Show'))
		self:RegisterEvent('SOCKET_INFO_CLOSE', Callback('socketing', 'Hide'))
	end

	if HasVehicleActionBar then
		self:RegisterEvent('UNIT_ENTERED_VEHICLE', Callback('vehicle', 'Hide'))
	end

	CharacterFrame:HookScript('OnShow', Callback('character', 'Show'))
	CharacterFrame:HookScript('OnHide', Callback('character', 'Hide'))
end

function Display:PLAYER_INTERACTION_MANAGER_FRAME_SHOW(id)
	local set = Interactions[id]
	if set and Addon.sets.display[set] then
		Addon.Frames:Show('inventory')
	end
end

function Display:PLAYER_INTERACTION_MANAGER_FRAME_HIDE(id)
	local set = Interactions[id]
	if set and Addon.sets.display[set] then
		Addon.Frames:Hide('inventory')
	end
end