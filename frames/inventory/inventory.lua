--[[
	A specialized version of the window frame for the inventory
	All Rights Reserved
--]]

local ADDON, Addon = ...
local C = LibStub('C_Everywhere').Container

local Frame = Addon.Frame:NewClass('Inventory')
Frame.Title = LibStub('AceLocale-3.0'):GetLocale(ADDON).TitleBags
Frame.ItemGroup = Addon.ContainerItemGroup
Frame.Bags = Addon.InventoryBags
Frame.PickupItem = C.PickupContainerItem
Frame.HasServerSort = C.SortBags
Frame.MainMenuButtons = {
	MainMenuBarBackpackButton,
	CharacterBag0Slot, CharacterBag1Slot, CharacterBag2Slot, CharacterBag3Slot
}

if HasKey then
	tinsert(Frame.MainMenuButtons, KeyRingButton)
end


--[[ Main Menu ]]--

function Frame:OnShow()
	self:Super(Frame):OnShow()
	self:Delay(0, 'HighlightMainMenu', true)
end

function Frame:OnHide()
	self:Super(Frame):OnHide()
	self:Delay(0, 'HighlightMainMenu', false)
end

function Frame:HighlightMainMenu(checked)
	for _, button in pairs(self.MainMenuButtons) do
		if button.SlotHighlightTexture then
			button.SlotHighlightTexture:SetShown(checked)
		elseif button.icon then
			button:SetChecked(checked)
		elseif checked then
			button:SetButtonState('PUSHED', 1)
		else
			button:SetButtonState('NORMAL')
		end
	end
end


--[[ API ]]--

function Frame:GetItemInfo(bag, slot)
	if self:IsCached(bag) then
		return self:Super(Frame):GetItemInfo(bag, slot)
	else
		local item = C.GetContainerItemInfo(bag, slot)
		if item then
			item.isNew = C_NewItems.IsNewItem(bag, slot)
			item.isPaid = C.IsBattlePayItem and C.IsBattlePayItem(bag, slot)
		end
		return item or Addon.None
	end
end

function Frame:GetBagFamily(bag)
	local family
	if bag > NUM_BAG_SLOTS and bag <= Addon.NumBags or bag == REAGENTBANK_CONTAINER then
		family = 0x80000
	elseif bag == KEYRING_CONTAINER then
		family = 9
	elseif bag > Addon.LastBankBag then
		family = -1
	elseif bag > BACKPACK_CONTAINER then
		if self:IsCached(bag) then
			local data = self:GetBagInfo(bag)
			if data and data.link then
				family = GetItemFamily('item:' .. data.link)
			end
		else
			family = select(2, C.GetContainerNumFreeSlots(bag))
		end
	end
	return family or 0
end

function Frame:NumSlots(bag)
	local size
	if bag <= BACKPACK_CONTAINER and bag ~= (KEYRING_CONTAINER or REAGENTBANK_CONTAINER) then
		size = C.GetContainerNumSlots(bag)
	elseif self:IsCached(bag) then
		local data = self:GetBagInfo(bag)
		if data then
			size = (bag > Addon.LastBankBag or bag == REAGENTBANK_CONTAINER) and 98 or data.size
		end
	elseif bag == KEYRING_CONTAINER then
		size = HasKey and HasKey() and C.GetContainerNumSlots(bag)
	elseif bag == REAGENTBANK_CONTAINER then
		size = IsReagentBankUnlocked() and C.GetContainerNumSlots(bag)
	else
		size = C.GetContainerNumSlots(bag)
	end
	return size or 0
end

function Frame:GetExtraButtons()
	return {self.profile.bagToggle and self:GetWidget('BagToggle')}
end

function Frame:SortItems()
	if C.SortBags and self.profile.serverSort then
		PlaySound(SOUNDKIT.UI_BAG_SORTING_01)
		C.SortBags()
		self:SendSignal('SORTING_STATUS')
	else
		self:Super(Frame):SortItems()
	end
end