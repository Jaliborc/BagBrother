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
		self:RegisterSignal('BAG_UPDATE_SIZE')
		self:RegisterSignal('BAG_UPDATE_CONTENT')
		self:RegisterEvent('ITEM_LOCK_CHANGED')
        self:RegisterEvent('UNIT_QUEST_LOG_CHANGED')

		self:RegisterEvent('BAG_UPDATE_COOLDOWN', 'ForAll', 'UpdateCooldown')
		self:RegisterEvent('BAG_NEW_ITEMS_UPDATED', 'ForAll', 'UpdateBorder')
		self:RegisterEvent('QUEST_ACCEPTED', 'ForAll', 'UpdateBorder')
	else
		self:RegisterSignal('BANK_OPEN', 'RegisterEvents')
	end
end

function Items:BAG_UPDATE_SIZE(_, bag)
	for i, frame in ipairs(self.bags) do
		if frame.id == bag then
			return self:Layout()
		end
	end
end

function Items:BAG_UPDATE_CONTENT(_, bag)
	self:ForBag(bag, 'Update')
end

function Items:ITEM_LOCK_CHANGED(_, bag, slot)
	if not self:Delaying('Layout') then
		bag = self.buttons[bag]
		slot = bag and bag[slot]
		if slot then
			slot:UpdateLocked()
		end
	end
end

function Items:UNIT_QUEST_LOG_CHANGED(_,unit)
	if unit == 'player' then
		self:ForAll('UpdateBorder')
	end
end

function Items:NumSlots(bag)
	local size
	if bag <= BACKPACK_CONTAINER and bag ~= KEYRING_CONTAINER then
		size = C.GetContainerNumSlots(bag)
	elseif self:IsCached() then
		local data = self:GetOwner()[bag]
		if data then
			size = data.size
		end
	elseif bag == KEYRING_CONTAINER then
		size = HasKey and HasKey() and C.GetContainerNumSlots(bag)
	else
		size = C.GetContainerNumSlots(bag)
	end
	return size or 0
end