--[[
	color.lua
		Color settings menu
--]]

local L, ADDON, Addon = select(2, ...).Addon()
local Slots = Addon.GeneralOptions:New('SlotOptions', '|TInterface/Addons/BagBrother/art/brush:16:16:-5:0|t')

function Slots:Populate()
  -- Items
	self:Add('Header', ITEMS, 'GameFontHighlight', true)
	self:AddRow(35*2, function()
		self:AddCheck('glowQuality')
		self:AddCheck('glowQuest')
		self:AddCheck('glowSets')
		self:AddCheck('glowUnusable')
		self:AddCheck('glowNew')
		self:AddCheck('glowPoor')
	end)
	self:AddPercentage('glowAlpha'):SetWidth(585)

	-- Slots
	self:Add('Header', BACKGROUND, 'GameFontHighlight', true).top = 15
	self:AddCheck('colorSlots').bottom = 11

	if Addon.sets.colorSlots then
		self:AddRow(35* ceil(#self:SlotTypes() / 3), function()
			for i, name in ipairs(self:SlotTypes()) do
				self:AddColor(name .. 'Color'):SetSmall(true)
			end
		end).left = 20
	end

	self:AddChoice {arg = 'slotBackground', LAYOUT_STYLE_MODERN and {key = 3, text = LAYOUT_STYLE_MODERN} or false, {key = 2, text = EXPANSION_NAME0}, {key = 1, text = NONE}}
end

function Slots:SlotTypes()
	local types = {}
	for bits, name in pairs(Addon.Item.BagFamilies) do
		if not tContains(types, name) then
			tinsert(types, name)
		end
	end

	for i, name in ipairs(Addon.IsRetail and {'key', 'soul', 'quiver'} or {'reagent', 'inscribe', 'tackle', 'fridge', 'gem'}) do
		tremove(types, tIndexOf(types, name))
	end

	sort(types)
	tinsert(types, 1, 'normal')
	return types
end
