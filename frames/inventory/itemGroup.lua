--[[
	itemGroup.lua
		A grid of container items
--]]

local ADDON, Addon =  ...
local C = LibStub('C_Everywhere').Container

local Items = Addon.ItemGroup:NewClass('ContainerItemGroup')
Items.Button = Addon.ContainerItem

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

function Items:BAGS_UPDATED(_, queue)
	local static = self:IsStatic()
	for i, bag in ipairs(self.bags) do
		local updated = queue[bag.id]
		if not static and updated or updated == false then
			return self:Layout()
		end
	end

	for bag in pairs(queue) do
		self:ForBag(bag, 'Update')
	end
end

function Items:ITEM_LOCK_CHANGED(_, bag, slot)
	local bag = self.buttons[bag]
	local slot = bag and bag[slot]
	if slot then
		slot:UpdateLocked()
	end
end

function Items:UNIT_QUEST_LOG_CHANGED(_, unit)
	if unit == 'player' then
		self:ForAll('UpdateBorder')
	end
end