--[[
	The inventory's item grid, pre-creating buttons so that none are created during combat lockdown.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local Items = Addon.ContainerGroup:NewClass('InventoryItemGroup')
Items.MaxSlots = {
	[LE_EXPANSION_CLASSIC]                = 18,
	[LE_EXPANSION_BURNING_CRUSADE]        = 28,
	[LE_EXPANSION_WRATH_OF_THE_LICH_KING] = 32
}


--[[ Startup ]]--

function Items:New(...)
	local f = self:Super(Items):New(...)
	f:EnsureButtons()
	return f
end

function Items:EnsureButtons()
	local maxSlots = self.MaxSlots[LE_EXPANSION_LEVEL_CURRENT]
		or (LE_EXPANSION_LEVEL_CURRENT <= LE_EXPANSION_MISTS_OF_PANDARIA and 36 or 40)

	for _, bag in ipairs(self.bags) do
		maxSlots = max(maxSlots, self:NumSlots(bag.id))
	end

	for _, bag in ipairs(self.bags) do
		local slots = self.byBag[bag.id]
		for slot = 1, maxSlots do
			if not slots[slot] then
				slots[slot] = self.Button(bag, bag.id, slot)
			end
		end
	end
end


--[[ Events ]]--

function Items:RegisterEvents()
	self:Super(Items):RegisterEvents()
	self:UnregisterEvent('PLAYER_REGEN_DISABLED')
end

function Items:UnregisterAll()
	self:Super(Items):UnregisterAll()
	self:RegisterEvent('PLAYER_REGEN_DISABLED', 'EnsureButtons')
end
