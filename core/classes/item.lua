--[[
	An item slot button.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local Item = Addon.Tipped:NewClass('Item', Addon.IsRetail and 'ItemButton' or 'Button', 'ContainerFrameItemButtonTemplate', true)
local Search = LibStub('ItemSearch-1.3')
local C = LibStub('C_Everywhere')

Item.BagFamilies = {
	[-3] = 'reagent',
	[0x00001] = 'quiver',
	[0x00002] = 'quiver',
	[0x00003] = 'soul',
	[0x00004] = 'soul',
	[0x00006] = 'herb',
	[0x00007] = 'enchant',
	[0x00008] = 'leather',
	[0x00009] = 'key',
	[0x00010] = 'inscribe',
	[0x00020] = 'herb',
	[0x00040] = 'enchant',
	[0x00080] = 'engineer',
	[0x00200] = 'gem',
	[0x00400] = 'mine',
 	[0x08000] = 'tackle',
 	[0x10000] = 'fridge'
}

Item.Backgrounds = {
	LAYOUT_STYLE_MODERN and 'item/weapon/1_null',
	'interface/paperdoll/ui-backpack-emptyslot'
}


--[[ Construct ]]--

function Item:New(parent, bag, slot)
	local b = self:Super(Item):New(parent)
	b:SetID(slot)
	b.bag = bag

	if b:IsVisible() then
		b:Update()
	else
		b:Show()
	end
	return b
end

function Item:Construct()
	local b = self:Super(Item):Construct()
	local name = b:GetName()

	b.UpdateTooltip = self.OnEnter
	b.FlashFind = b:CreateAnimationGroup()
	b.Cooldown, b.QuestBang = _G[name .. 'Cooldown'], _G[name .. 'IconQuestTexture']
	b.QuestBang:SetTexture(TEXTURE_ITEM_QUEST_BANG)
	b.IconOverlay:SetAtlas('AzeriteIconFrame')
	b.BattlepayItemTexture:Hide()

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

	b:SetScript('OnEvent', nil)
	b:SetScript('OnShow', b.Update)
	b:HookScript('OnClick', b.OnPostClick)
	b:SetScript('OnEnter', b.OnEnter)
	b:SetScript('OnLeave', b.OnLeave)
	b:SetScript('OnHide', b.OnHide)
	return b
end

function Item:Bind(frame) -- required for secure frames
	for k in pairs(frame) do
		if self[k] then
			frame[k] = nil
		end
	end

	local class = self
	while class do
		for k,v in pairs(class) do
			frame[k] = frame[k] or v
		end

		class = class:GetSuper()
	end
	return frame
end


--[[ Interaction ]]--

function Item:OnPostClick(button)
	if Addon.lockMode then
		local locks = GetOrCreateTableEntry(self:GetProfile().lockedSlots, self:GetBag())
		locks[self:GetID()] = not locks[self:GetID()] or nil
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

function Item:OnHide()
	if self.hasStackSplit == 1 then
		StackSplitFrame:Hide()
	end
	self:UnregisterAll()
end


--[[ Update ]]--

function Item:Update()
	self.info = self:GetInfo()
	self.hasItem = self.info.itemID and true -- for blizzard template
	self.readable = self.info.isReadable -- for blizzard template
	self:Delay(0.05, 'UpdateSecondary')
	self:UpdateBorder()

	SetItemButtonTexture(self, self.info.iconFileID or self.Backgrounds[Addon.sets.slotBackground])
	SetItemButtonCount(self, self.info.stackCount)
end

function Item:UpdateBorder()
	local id, quality = self.info.itemID, self.info.quality
	local quest, bang = self:GetQuestInfo()
	local r,g,b

	SetItemButtonQuality(self, quality, self.info.hyperlink, false, self.info.isBound)

	if id then
		if Addon.sets.glowQuest and quest or bang then
			r,g,b = 1, .82, .2
		elseif Addon.sets.glowUnusable and Search:IsUnusable(id) then
			r,g,b = RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b
		elseif Addon.sets.glowSets and Search:BelongsToSet(id) then
	  		r,g,b = .2, 1, .8
		elseif Addon.sets.glowQuality and quality and quality > 1 then
			r,g,b = GetItemQualityColor(quality)
		end

		if r then
			self.IconGlow:SetVertexColor(r,g,b, Addon.sets.glowAlpha)
			self.IconBorder:SetVertexColor(r,g,b)
		end
	end

	self.IconGlow:SetShown(r)
	self.IconBorder:SetShown(r)
	self.QuestBang:SetShown(bang)
	self.JunkIcon:SetShown(Addon.sets.glowPoor and quality == 0 and not self.info.hasNoValue)
end

function Item:UpdateLocked()
	self.info = self:GetInfo()
	self:SetDesaturated(self.info.isLocked)
end

function Item:SetDesaturated(locked)
	SetItemButtonDesaturated(self, locked)
end


--[[ Secondary Highlights ]]--

function Item:UpdateSecondary()
	if self.frame then
		self:UpdateFocus()
		self:UpdateSearch()
		self:UpdateUpgradeIcon()

		if self.hasItem and GameTooltip:IsOwned(self) then
			self:ShowTooltip()
		end
	end
end

function Item:UpdateFocus()
	self:SetHighlightLocked(self:GetBag() == self.frame.focusedBag)
end

function Item:UpdateSearch()
	local search = Addon.canSearch and Addon.search or ''
	local matches = search == '' or self.hasItem and Search:Matches(self:GetQuery(), search)

	self:SetAlpha(matches and 1 or 0.3)
	self:SetDesaturated(not matches or self.info.isLocked)
end

function Item:UpdateUpgradeIcon()
	local isUpgrade = self:IsUpgrade()
	if isUpgrade == nil then
		self:Delay(0.5, 'UpdateUpgradeIcon')
	else
		self.UpgradeIcon:SetShown(isUpgrade)
	end
end


--[[ Tooltip ]]--

function Item:ShowTooltip()
	(self:GetInventorySlot() and BankFrameItemButton_OnEnter or
		ContainerFrameItemButtonMixin and ContainerFrameItemButtonMixin.OnUpdate or ContainerFrameItemButton_OnEnter)(self)
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
			parent:OnPostClick(button)
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
	return self.frame:GetItemInfo(self:GetSlot())
end

function Item:GetQuestInfo()
	return self.hasItem and Search:IsQuestItem(self.info.itemID)
end

function Item:GetQuery()
	return self.info.hyperlink
end

function Item:IsUpgrade()
	return (self.hasItem or false) and C.Addons.IsAddOnLoaded('Pawn') and PawnShouldItemLinkHaveUpgradeArrow(self.info.hyperlink)
end

function Item:GetInventorySlot()
	local api = Addon:IsBank(self.bag) and BankButtonIDToInvSlotID or
				Addon:IsKeyring(self.bag) and KeyRingButtonIDToInvSlotID or
				Addon:IsReagents(self.bag) and ReagentBankButtonIDToInvSlotID
	return api and api(self:GetID())
end

function Item:GetSlot()
	return self:GetBag(), self:GetID()
end

function Item:GetBag()
	return self.bag
end
