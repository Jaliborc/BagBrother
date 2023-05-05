--[[
	inventory.lua
		A specialized version of the window frame for the inventory
--]]

local ADDON, Addon = ...
local C = LibStub('C_Everywhere').Container
local Frame = Addon.Frame:NewClass('Inventory')
Frame.Title = LibStub('AceLocale-3.0'):GetLocale(ADDON).TitleBags
Frame.ItemGroup = Addon.ContainerItemGroup
Frame.Bags = Addon.InventoryBags
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
	if self:IsCached() then
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

function Frame:SortItems()
	if Addon.sets.serverSort then
		C.SortBags()
		self:SendSignal('SORTING_STATUS')
	else
		self:Super(Frame):SortItems()
	end
end