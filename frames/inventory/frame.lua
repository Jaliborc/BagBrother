--[[
	inventory.lua
		A specialized version of the standard frame for the inventory
--]]

local ADDON, Addon = ...
local C = LibStub('C_Everywhere').Container
local Frame = Addon.Frame:NewClass('InventoryFrame')
Frame.Title = LibStub('AceLocale-3.0'):GetLocale(ADDON).TitleBags
Frame.Item = Addon.InventoryItem
Frame.Bags = {}
Frame.MainMenuButtons = {
	MainMenuBarBackpackButton,
	CharacterBag0Slot, CharacterBag1Slot, CharacterBag2Slot, CharacterBag3Slot
}

for slot = BACKPACK_CONTAINER, Addon.NumBags do
	tinsert(Frame.Bags, slot)
end

if HasKey then
	tinsert(Frame.Bags, KEYRING_CONTAINER)
	tinsert(Frame.MainMenuButtons, KeyRingButton)
end

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

function Frame:SortItems()
	if C.SortBags and Addon.sets.serverSort then
		C.SortBags()
	else
		self:Super(Frame):SortItems(self)
	end
end