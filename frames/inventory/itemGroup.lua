--[[
	A grid specialized for container items.
	All Rights Reserved
--]]

local ADDON, Addon =  ...
local Items = Addon.ItemGroup:NewClass('ContainerItemGroup')

Items.Button = Addon.ContainerItem
Items.MaxSlots = {
	[LE_EXPANSION_CLASSIC]                = 18,
	[LE_EXPANSION_BURNING_CRUSADE]        = 28,
	[LE_EXPANSION_WRATH_OF_THE_LICH_KING] = 32
}

function Items:New(parent, bags)
	local f = self:Super(Items):New(parent, bags)

	 -- prevents combat lockdown
	local maxSlots = self.MaxSlots[LE_EXPANSION_LEVEL_CURRENT] 
		or (LE_EXPANSION_LEVEL_CURRENT <= LE_EXPANSION_MISTS_OF_PANDARIA and 36 or 38)

	for _, bag in ipairs(f.bags) do
		maxSlots = max(maxSlots, f:NumSlots(bag.id)) -- just in case
	end

	for _, bag in ipairs(f.bags) do
		for slot = 1, maxSlots do
			f.byBag[bag.id][slot] = f.Button(bag, bag.id, slot)
		end
	end

	return f
end

function Items:RegisterEvents()
	self:Super(Items):RegisterEvents()

	if not self:IsCached() then
		self:RegisterEvent('ITEM_LOCK_CHANGED')
        self:RegisterEvent('UNIT_QUEST_LOG_CHANGED')
		self:RegisterSignal('BAGS_UPDATED')

		self:RegisterEvent('BAG_UPDATE_COOLDOWN', 'ForAll', 'UpdateCooldown')
		self:RegisterEvent('BAG_NEW_ITEMS_UPDATED', 'ForAll', 'UpdateBorder')
		self:RegisterEvent('QUEST_ACCEPTED', 'ForAll', 'UpdateBorder')
	else
		self:RegisterSignal('BANK_OPEN', 'RegisterEvents')
	end
end

function Items:BAGS_UPDATED(queue)
	local dynamic = self:IsDynamic()
	for i, bag in ipairs(self.bags) do
		local updated = queue[bag.id]
		if updated or dynamic and updated ~= nil then
			return self:Layout()
		end
	end

	for bag in pairs(queue) do
		self:ForBag(bag, 'Update')
	end
end

function Items:ITEM_LOCK_CHANGED(bag, slot)
	local bag = self.byBag[bag]
	local slot = bag and bag[slot]
	if slot then
		slot:UpdateLocked()
	end
end

function Items:UNIT_QUEST_LOG_CHANGED(unit)
	if unit == 'player' then
		self:ForAll('UpdateBorder')
	end
end