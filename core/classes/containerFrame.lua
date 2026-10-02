--[[
	API for frames that display container items.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local C = LibStub('C_Everywhere')
local Frame = Addon.Frame:NewClass('ContainerFrame')
Frame.PickupItem = C.Container.PickupContainerItem

function Frame:GetItemInfo(bag, slot)
	if self:IsCached(bag) then
		return self:Super(Frame):GetItemInfo(bag, slot)
	else
		local item = C.Container.GetContainerItemInfo(bag, slot)
		if item then
			item.isNew = C.NewItems.IsNewItem(bag, slot)
			item.isPaid = C.Container.IsBattlePayItem and C.Container.IsBattlePayItem(bag, slot)
		end
		return item or Addon.None
	end
end

function Frame:GetItemQuery(bag, slot, info)
	if self:IsCached() then
		return info.hyperlink
	elseif info.itemID then
		return {bagID = bag, slotIndex = slot}
	end
end

function Frame:GetBagFamily(bag)
	local family
	if bag == KEYRING_CONTAINER then
		family = 9
	elseif bag > Addon.LastBankBag then
		family = -1
	elseif bag > BACKPACK_CONTAINER then
		if self:IsCached(bag) then
			local data = self:GetBagInfo(bag)
			if data and data.link then
				family = C.Item.GetItemFamily('item:' .. data.link)
			end
		else
			family = select(2, C.Container.GetContainerNumFreeSlots(bag))
		end

		if family == 0 and bag > NUM_BAG_SLOTS and bag <= Addon.NumBags then
			family = 0x80000 -- retail reports reagent bags without a type
		end
	end
	return family or 0
end

function Frame:NumSlots(bag)
	local size
	if bag <= BACKPACK_CONTAINER and bag ~= (KEYRING_CONTAINER or REAGENTBANK_CONTAINER) then
		size = C.Container.GetContainerNumSlots(bag)
	elseif self:IsCached(bag) then
		local data = self:GetBagInfo(bag)
		if data then
			size = (bag > Addon.LastBankBag or bag == REAGENTBANK_CONTAINER) and 98 or data.size
		end
	elseif bag == KEYRING_CONTAINER then
		size = HasKey and HasKey() and GetKeyRingSize()
	elseif bag == REAGENTBANK_CONTAINER then
		size = IsReagentBankUnlocked() and C.Container.GetContainerNumSlots(bag)
	else
		size = C.Container.GetContainerNumSlots(bag)
	end
	return size or 0
end
