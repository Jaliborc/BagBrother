--[[
	item.lua
		An item slot button
--]]

local ADDON, Addon = ...
local Item = Addon.Tipped:NewClass('Item', Addon.IsRetail and 'ItemButton' or 'Button', 'ContainerFrameItemButtonTemplate', true)
local Search = LibStub('ItemSearch-1.3')

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
	local b = self:GetBlizzard() or self:Super(Item):New(parent)
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

	for k in pairs(b) do
		if self[k] then
			b[k] = nil -- remove unwanted native variables
		end
	end

	b.Flash = b:CreateAnimationGroup()
	b.IconGlow = b:CreateTexture(nil, 'OVERLAY', nil, -1)
	b.Cooldown, b.QuestBorder = _G[name .. 'Cooldown'], _G[name .. 'IconQuestTexture']
	b.UpdateTooltip = self.OnEnter

	b.newitemglowAnim:SetLooping('NONE')
	b.IconOverlay:SetAtlas('AzeriteIconFrame')
	b.QuestBorder:SetTexture(TEXTURE_ITEM_QUEST_BANG)
	b.IconGlow:SetTexture('Interface/Buttons/UI-ActionButton-Border')
	b.IconGlow:SetBlendMode('ADD')
	b.IconGlow:SetPoint('CENTER')
	b.IconGlow:SetSize(67, 67)

	for i = 1, 3 do
		local fade = b.Flash:CreateAnimation('Alpha')
		fade:SetOrder(i * 2)
		fade:SetDuration(.2)
		fade:SetFromAlpha(.8)
		fade:SetToAlpha(0)

		local fade = b.Flash:CreateAnimation('Alpha')
		fade:SetOrder(i * 2 + 1)
		fade:SetDuration(.3)
		fade:SetFromAlpha(0)
		fade:SetToAlpha(.8)
	end

	b:SetScript('OnEvent', nil)
	b:SetScript('OnShow', b.OnShow)
	b:SetScript('OnHide', b.OnHide)
	b:SetScript('OnEnter', b.OnEnter)
	b:SetScript('OnLeave', b.OnLeave)
	b:HookScript('OnClick', b.OnPostClick)
	return b
end


--[[ Interaction ]]--

function Item:OnShow()
	self:RegisterFrameSignal('FOCUS_BAG', 'UpdateFocus')
	self:RegisterSignal('SEARCH_CHANGED', 'UpdateSearch')
	self:RegisterSignal('SEARCH_TOGGLED', 'UpdateSearch')
	self:RegisterSignal('FLASH_ITEM', 'OnItemFlashed')
	self:Update()
end

function Item:OnHide()
	if self.hasStackSplit == 1 then
		StackSplitFrame:Hide()
	end

	self:MarkSeen()
	self:UnregisterAll()
end

function Item:OnPostClick(button)
	self:FlashFind(button)
end

function Item:OnEnter()
	if self:IsCached() then
		self:AttachDummy()
	elseif self.hasItem then
		self:ShowTooltip()
		self:MarkSeen()
	end
end

function Item:OnLeave()
	self:Super(Item):OnLeave()
	ResetCursor()
end


--[[ Update ]]--

function Item:Update()
	self.info = self:GetInfo()
	self.hasItem = self.info.id and true -- for blizzard template
	self.readable = self.info.readable -- for blizzard template
	self:Delay(0.05, 'UpdateSecondary')
	self:UpdateSlotColor()
	self:UpdateCooldown()
	self:UpdateBorder()

	SetItemButtonTexture(self, self.info.icon or self.Backgrounds[Addon.sets.slotBackground])
	SetItemButtonCount(self, self.info.count)
end

function Item:UpdateSecondary()
	if self:GetFrame() then
		self:UpdateFocus()
		self:UpdateSearch()
		self:UpdateUpgradeIcon()
		self:UpdateNewItemAnimation()

		if self.hasItem and GameTooltip:IsOwned(self) then
			self:ShowTooltip()
		end
	end
end

function Item:UpdateLocked()
	self.info = self:GetInfo()
	self:SetLocked(self.info.locked)
end


--[[ Basic Appearance ]]--

function Item:UpdateBorder()
	local quality, id = self.info.quality, self.info.id
	local quest, bang = self:GetQuestInfo()
	local r,g,b

	SetItemButtonQuality(self, quality, self.info.link, false, self.info.isBound)

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
	self.QuestBorder:SetShown(bang)
	self.JunkIcon:SetShown(Addon.sets.glowPoor and quality == 0 and not self.info.worthless)
end

function Item:UpdateSlotColor()
	if not self.hasItem then
		local color = Addon.sets.colorSlots and Addon.sets[self:GetBagFamily() .. 'Color'] or {}
		local r,g,b = color[1] or 1, color[2] or 1, color[3] or 1

		SetItemButtonTextureVertexColor(self, r,g,b)
		self:GetNormalTexture():SetVertexColor(r,g,b)
	else
		self:GetNormalTexture():SetVertexColor(1,1,1)
	end
end

function Item:SetLocked(locked)
	SetItemButtonDesaturated(self, locked)
end


--[[ Secondary Highlights ]]--

function Item:UpdateSearch()
	local search = Addon.canSearch and Addon.search or ''
	local matches = search == '' or self.hasItem and Search:Matches(self:GetQuery(), search)

	self:SetAlpha(matches and 1 or 0.3)
	self:SetLocked(not matches or self.info.locked)
end

function Item:UpdateFocus()
	if self:GetBag() == self:GetFrame().focusedBag then
		self:LockHighlight()
	else
		self:UnlockHighlight()
	end
end

function Item:UpdateUpgradeIcon()
	self.UpgradeIcon:SetShown(self:IsUpgrade())
end

function Item:UpdateNewItemAnimation()
	local new = Addon.sets.glowNew and self:IsNew()

	self.BattlepayItemTexture:SetShown(new and self:IsPaid())
	self.NewItemTexture:SetShown(new)

	if new then
		self.NewItemTexture:SetAtlas(quality and NEW_ITEM_ATLAS_BY_QUALITY[quality] or 'bags-glow-white')
		self.newitemglowAnim:Play()
		self.flashAnim:Play()
	end
end

function Item:FlashFind(mouse)
	if IsAltKeyDown() and mouse == 'LeftButton' and Addon.sets.flashFind and self.info.id then
		self:SendSignal('FLASH_ITEM', self.info.id)
		return true
	end
end

function Item:OnItemFlashed(_, itemID)
	self.Flash:Stop()
	if self.info.id == itemID then
		self.Flash:Play()
	end
end


--[[ Tooltip ]]--

function Item:ShowTooltip()
	(self:GetInventorySlot() and BankFrameItemButton_OnEnter or
		ContainerFrameItemButtonMixin and ContainerFrameItemButtonMixin.OnUpdate or ContainerFrameItemButton_OnEnter)(self)
end

function Item:AttachDummy()
	if not Item.Dummy then
		local function updateTip(slot)
			local parent = slot:GetParent()
			local link = parent.info.link
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
		Item.Dummy:SetScript('OnEnter', updateTip)
		Item.Dummy:SetScript('OnShow', updateTip)
		Item.Dummy:RegisterForClicks('anyUp')
		Item.Dummy:SetToplevel(true)

		Item.Dummy:SetScript('OnClick', function(dummy, button)
			local parent = dummy:GetParent()
			if not HandleModifiedItemClick(parent.info.link) then
				parent:FlashFind(button)
			end
		end)

		Item.Dummy:SetScript('OnLeave', function(dummy)
			dummy:GetParent():UnlockHighlight()
			dummy:GetParent():OnLeave()
			dummy:Hide()
		end)
	end

	Item.Dummy:SetParent(self)
	Item.Dummy:SetAllPoints()
	Item.Dummy:Show()
end


--[[ Proprieties ]]--

function Item:GetBag()
	return self.bag
end

function Item:GetBagFamily()
	local bag = self:GetFrame():GetBagInfo(self:GetBag())
	return self.BagFamilies[bag.family] or 'normal'
end

function Item:GetInventorySlot()
	local bag = self:GetBag()
	local api = Addon:IsBank(bag) and BankButtonIDToInvSlotID or
							Addon:IsKeyring(bag) and KeyRingButtonIDToInvSlotID or
							Addon:IsReagents(bag) and ReagentBankButtonIDToInvSlotID
	return api and api(self:GetID())
end

function Item:GetQuery()
	return self.item.link
end

function Item:GetInfo()
	return self:GetFrame():GetItemInfo(self:GetBag(), self:GetID())
end

function Item:GetQuestInfo()
	return self.hasItem and Search:IsQuestItem(self.info.id)
end

function Item:IsSlot(bag, slot)
	return self:GetBag() == bag and self:GetID() == slot
end

function Item:IsUpgrade()
	return self.hasItem and IsAddOnLoaded('Pawn') and
		PawnShouldItemLinkHaveUpgradeArrow(self.info.link)
end


--[[ Virtual ]]--

function Item:GetBlizzard() end
function Item:UpdateCooldown() end
function Item:MarkSeen() end
function Item:IsPaid() end
function Item:IsNew() end
