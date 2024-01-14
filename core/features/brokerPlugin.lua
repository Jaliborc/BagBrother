--[[
	A databroker launcher plugin.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local LDB = LibStub('LibDataBroker-1.1')
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local C = LibStub('C_Everywhere').Container

Addon:NewModule('LDB', LDB:NewDataObject(ADDON .. 'Launcher', {
	type = 'launcher', label = ADDON,
	icon = 'Interface/Addons/BagBrother/Art/' .. ADDON .. '-Big',

	OnEnable = function(self)
		self:RegisterSignal('BAGS_UPDATED', 'OnUpdate')
	end,

	OnClick = function(self, button)
		if IsShiftKeyDown() then
			Addon:ShowOptions()
		elseif button == 'LeftButton' then
			Addon.Frames:Toggle('inventory')
		elseif button == 'RightButton' then
			Addon.Frames:Toggle('bank')
		end
	end,

	OnTooltipShow = function(tooltip)
		tooltip:AddLine(format('|TInterface/Addons/BagBrother/Art/%s-Small:18:18|t %s', ADDON, ADDON), 1,1,1)
		tooltip:AddLine(Addon.Tipped.MarkupTooltip('|L %s|n|R %s'):format(L.OpenBags, L.OpenBank))
	end,

	OnUpdate = function(self)
		local free, total = 0, 0
		for bag = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
			local numFree, family = C.GetContainerNumFreeSlots(bag)
			if family == 0 then
				total = total + C.GetContainerNumSlots(bag)
				free = free + numFree
			end
		end

		self.text = format('%d/%d', free, total)
	end
}))
