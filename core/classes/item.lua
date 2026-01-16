--[[
	An item slot button.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local Item = Addon.Tipped:NewClass('Item', 'ItemButton', 'ContainerFrameItemButtonTemplate', true)
local Search = LibStub('ItemSearch-1.3')
local C = LibStub('C_Everywhere')

Item.UpdateSecondary = nop -- backwards support
Item.Backgrounds = {
	LAYOUT_STYLE_MODERN and 'item/weapon/1_null',
	'interface/paperdoll/ui-backpack-emptyslot'
}


--[[ Construct ]]--

function Item:New(parent, bag, slot, info)
	local b = self:Super(Item):New(parent)
	b.bag = bag
	b:SetID(slot)
	b:Update(info)
	b:Show()
	return b
end

function Item:Construct()
	local b = self:Super(Item):Construct()
	b:SetScript('OnEvent', nil)
	b:SetScript('OnShow', nil)

	if Addon.IsClassic then
		local name = b:GetName()
		b.Cooldown, b.QuestBang = _G[name .. 'Cooldown'], _G[name .. 'IconQuestTexture']
	else
		b.QuestBang = b.IconQuestTexture
	end

	b.UpdateTooltip = b.OnEnter
	b.FlashFind = b:CreateAnimationGroup()
	if b.QuestBang then
		b.QuestBang:SetTexture(TEXTURE_ITEM_QUEST_BANG)
	end
	if b.BattlepayItemTexture then b.BattlepayItemTexture:Hide() end
	if b.NewItemTexture then b.NewItemTexture:Hide() end
	
	b.IconGlow = b:CreateTexture(nil, 'OVERLAY', nil, -1)
	b.IconGlow:SetTexture('Interface/Buttons/UI-ActionButton-Border')
	b.IconGlow:SetBlendMode('ADD')
	b.IconGlow:SetPoint('CENTER')
	b.IconGlow:SetSize(67, 67)

	b.IgnoredOverlay = b:CreateTexture(nil, 'OVERLAY', nil, 1)
	b.IgnoredOverlay:SetTexture(255353)
	b.IgnoredOverlay:SetAllPoints(b)
	b.IgnoredOverlay:Hide()

	for i = 1, 3 do
		local fade = b.FlashFind:CreateAnimation('Alpha')
		fade:SetChildKey('flash')
		fade:SetOrder(i * 2)
		fade:SetDuration(.4)
		fade:SetFromAlpha(.1)
		fade:SetToAlpha(1)

		local fade = b.FlashFind:CreateAnimation('Alpha')
		fade:SetChildKey('flash')
		fade:SetOrder(i * 2 + 1)
		fade:SetDuration(.4)
		fade:SetFromAlpha(1)
		fade:SetToAlpha(.1)
	end

	return b
end

function Item:Bind(button) -- required for secure frames
	local list = rawget(self, '__bindList')
	if not list then
		list = {}
		self.__bindList = list

		local class = self
		while class do
			for k,v in pairs(class) do
				list[k] = list[k] or v
			end

			class = class:GetSuper()
		end
	end

	return Mixin(button, list)
end


--[[ Interaction ]]--

function Item:PostClick(button)
	if Addon.lockMode then
		local locked = GetOrCreateTableEntry(self:GetBagInfo(self:GetBag()), 'locked')
		locked[self:GetID()] = not locked[self:GetID()] or nil
		self:SendSignal('LOCKING_TOGGLED')
	elseif Addon.sets.flashFind and self.hasItem and IsAltKeyDown() and button == 'LeftButton' then
		self:SendSignal('FLASH_ITEM', self.info.itemID)
	end
end

function Item:OnEnter()
	if self:IsCached() or Addon.lockMode then
		self:AttachDummy()
	elseif self.hasItem then
		self:ShowTooltip()
	end
end

function Item:OnLeave()
	self:Super(Item):OnLeave()
	ResetCursor()
end


--[[ Update ]]--

function Item:Update(info)
	self.info = info or self:GetInfo()
	self.hasItem = self.info.itemID and true -- for blizzard template
	self.readable = self.info.isReadable -- for blizzard template

	self:UpdateBorder()
	self:UpdateFocus()
	self:UpdateSearch()
	self:UpdateIgnored()
	self:UpdateUpgradeIcon()
	self:UpdateSecondary()

	if self.hasItem and GameTooltip:IsOwned(self) then
		self:ShowTooltip()
	end

	SetItemButtonTexture(self, self.info.iconFileID or self.Backgrounds[Addon.sets.slotBackground])
	SetItemButtonCount(self, self.info.stackCount)
end

function Item:UpdateLocked()
	self.info = self:GetInfo()
	self:SetDesaturated(self.info.isLocked)
end

function Item:SetDesaturated(locked)
	SetItemButtonDesaturated(self, locked)
end


--[[ Secondary Highlights ]]--

function Item:UpdateBorder()
	local id, link, quality = self.info.itemID, self.info.hyperlink, self.info.quality
	local quest, bang = self:GetQuestInfo()
	local r,g,b

	SetItemButtonQuality(self, quality, link, false, self.info.isBound)

	if id then
		if Addon.sets.glowQuest and quest or bang then
			r,g,b = 1, .82, .2
		elseif Addon.sets.glowUnusable and Search:IsUnusable(id) then
			r,g,b = RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b
		elseif Addon.sets.glowSets and Search:BelongsToSet(id) then
	  		r,g,b = .2, 1, .8
		elseif Addon.sets.glowQuality and quality and quality > 1 then
			r,g,b = C.Item.GetItemQualityColor(quality)
		end

		if r then
			self.IconGlow:SetVertexColor(r,g,b, Addon.sets.glowAlpha)
			self.IconOverlay:SetVertexColor(r,g,b)
			self.IconBorder:SetVertexColor(r,g,b)
		end

		if link and Search:IsUncollected(id, link) then
			self.IconOverlay:SetAtlas('CosmeticIconFrame')
			self.IconOverlay:Show()
		end
	end

	if self.IconGlow then self.IconGlow:SetShown(r) end
	if self.IconBorder then self.IconBorder:SetShown(r) end
	if self.QuestBang then self.QuestBang:SetShown(bang) end
	if self.JunkIcon then self.JunkIcon:SetShown(Addon.sets.glowPoor and quality == 0 and not self.info.hasNoValue) end
end

function Item:UpdateFocus()
	self:SetHighlightLocked(self:GetBag() == self.frame.focusedBag)
end

function Item:UpdateSearch()
	local search = Addon.canSearch and Addon.search
	local matches = self.frame:SearchItem(search, self:GetBag(), self:GetID(), self.info)
	
	self:SetAlpha(matches and 1 or 0.3)
	self:SetDesaturated(not matches or self.info.isLocked)
end

function Item:UpdateIgnored()
	local cache = Addon.lockMode and self:GetBagInfo(self:GetBag())
	self.IgnoredOverlay:SetShown(cache and cache.locked and cache.locked[self:GetID()])
end

function Item:UpdateUpgradeIcon()
	local isUpgrade = self:IsUpgrade()
	self.UpgradeIcon:SetShown(isUpgrade)

	if isUpgrade == nil then
		self:Delay(0.5, 'UpdateUpgradeIcon')
	end
end


--[[ Tooltip ]]--

function Item:ShowTooltip()
	if self:GetRight() then -- prevents bug in blizzard code
		(self:GetInventorySlot() and BankFrameItemButton_OnEnter or
			ContainerFrameItemButtonMixin and ContainerFrameItemButtonMixin.OnUpdate or ContainerFrameItemButton_OnEnter)(self)
	end
end

function Item:AttachDummy()
	self.Dummy:SetParent(self)
	self.Dummy:SetAllPoints()
	self.Dummy:Show()
end

do
	local function cachedTip(dummy)
		local parent = dummy:GetParent()
		local link = parent.info.hyperlink
		if link then
			GameTooltip:SetOwner(parent:GetTipAnchor())
			parent:LockHighlight()
			CursorUpdate(parent)

			if link:find('battlepet:') then
				local _, specie, level, quality, health, power, speed = strsplit(':', link)
				local name = link:match('%[(.-)%]')

				BattlePetToolTip_Show(tonumber(specie), level, tonumber(quality), health, power, speed, name)
			else
				GameTooltip:SetHyperlink(link)
				GameTooltip:Show()
			end
		end
	end

	Item.Dummy = CreateFrame('Button')
	Item.Dummy:SetScript('OnEnter', cachedTip)
	Item.Dummy:SetScript('OnShow', cachedTip)
	Item.Dummy:RegisterForClicks('anyUp')
	Item.Dummy:SetToplevel(true)

	Item.Dummy:SetScript('OnClick', function(dummy, button)
		local parent = dummy:GetParent()
		if not HandleModifiedItemClick(parent.info.hyperlink) then
			parent:PostClick(button)
		end
	end)
	
	Item.Dummy:SetScript('OnLeave', function(dummy)
		dummy:GetParent():UnlockHighlight()
		dummy:GetParent():OnLeave()
		dummy:Hide()
	end)
end


--[[ Properties ]]--

function Item:GetInfo()
	return self:GetItemInfo(self:GetSlot())
end

function Item:GetQuestInfo()
	return self.hasItem and Search:IsQuestItem(self.info.itemID)
end

function Item:IsUpgrade()
	return (self.hasItem or false) and C.AddOns.IsAddOnLoaded('Pawn') and PawnShouldItemLinkHaveUpgradeArrow(self.info.hyperlink)
end

function Item:GetInventorySlot()
	local api = self.bag == BANK_CONTAINER and BankButtonIDToInvSlotID or
				self.bag == REAGENTBANK_CONTAINER and ReagentBankButtonIDToInvSlotID or
				self.bag == -2 and KeyRingButtonIDToInvSlotID
	return api and api(self:GetID())
end

function Item:GetSlot()
	return self:GetBag(), self:GetID()
end

function Item:GetBag()
	return self.bag
end
