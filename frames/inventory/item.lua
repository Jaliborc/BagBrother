--[[
	A container item button.
	All Rights Reserved
--]]


local ADDON, Addon = ...
local Item = Addon.Item:NewClass('ContainerItem')
local C = LibStub('C_Everywhere').Container

Item.BagFamilies = {
	[-1] = 'account',
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
 	[0x10000] = 'fridge',
	[0x80000] = 'reagent'
}


--[[ Events ]]--

function Item:Construct()
	local b = self:Super(Item):Construct()
	b.Cooldown:SetScript('OnCooldownDone', function() SetItemButtonTextureVertexColor(b, 1,1,1) end)
	return b
end

function Item:PreClick(button)
	if self.hasItem and button == 'RightButton' and REAGENTBANK_CONTAINER then
		if (IsShiftKeyDown() or not C_Bank.CanUseBank(0)) and C_Bank.CanUseBank(2) then
			C.UseContainerItem(self:GetBag(), self:GetID(), nil, 2)

		elseif tContains(Addon.InventoryBags, self:GetBag()) and not IsModifiedClick() and C_Bank.CanUseBank(0) then
			local stackSize, _,_,_,_,_,_,_,_, isReagent = select(8, GetItemInfo(self.info.itemID))
			if isReagent and self.frame:NumSlots(REAGENTBANK_CONTAINER) > 0 then
				for _, bag in ipairs(Addon.BankBags) do
					for slot = 1, C.GetContainerNumSlots(bag) do
						if C.GetContainerItemID(bag, slot) == self.info.itemID then
							local free = stackSize - C.GetContainerItemInfo(bag, slot).stackCount
							if free > 0 then
								C.SplitContainerItem(self:GetBag(), self:GetID(), min(self.info.stackCount, free))
								C.PickupContainerItem(bag, slot)
							end
						end
					end
				end

				C.UseContainerItem(self:GetBag(), self:GetID(), nil, nil, true)
			end
		end
	end

	self.wasLocked = self.info.isLocked
end

function Item:PostClick(button)
	self:Super(Item):PostClick(button)

	if Addon.Events.AtVault and self.wasLocked and not IsModifiedClick() and button == 'RightButton' then
		for i = 10, 1, -1 do
			if GetVoidTransferDepositInfo(i) == self.info.itemID then
				ClickVoidTransferDepositSlot(i, true)
			end
		end
	end
end

function Item:OnEnter()
	self:Super(Item):OnEnter()
	self:MarkSeen()
end


--[[ Update ]]--

function Item:Update()
	self:Super(Item):Update()
	self:UpdateCooldown()

	local r,g,b = 1,1,1
	if not self.hasItem then
		local family = self.frame:GetBagFamily(self:GetBag())
		local color = Addon.sets.colorSlots and Addon.sets.color[self.BagFamilies[family] or 'normal'] or Addon.None

		r,g,b = color[1] or 1, color[2] or 1, color[3] or 1
	end

	SetItemButtonTextureVertexColor(self, r,g,b)
	self:GetNormalTexture():SetVertexColor(r,g,b)
end

function Item:UpdateCooldown()
	if self.hasItem and not self:IsCached() then
		CooldownFrame_Set(self.Cooldown, C.GetContainerItemCooldown(self:GetBag(), self:GetID()))
		local fade = self.Cooldown:IsShown() and 0.4 or 1
		SetItemButtonTextureVertexColor(self, fade,fade,fade)
	else
		CooldownFrame_Set(self.Cooldown, 0,0,0)
		self.Cooldown:Hide()
	end
end

function Item:UpdateSecondary()
	self:Super(Item):UpdateSecondary()
	if self.frame then
		self:UpdateGlow()
	end
end

function Item:UpdateGlow()
	local new = Addon.sets.glowNew and self.info.isNew
	self.BattlepayItemTexture:SetShown(new and self.info.isPaid)
	self.NewItemTexture:SetShown(new)

	if new then
		self.NewItemTexture:SetAtlas(self.info.quality and NEW_ITEM_ATLAS_BY_QUALITY[self.info.quality] or 'bags-glow-white')
		self.newitemglowAnim:Play()
		self.flashAnim:Play()
	end
end


--[[ API ]]--

function Item:MarkSeen()
	if self.NewItemTexture:IsShown() then
		C_NewItems.RemoveNewItem(self:GetBag(), self:GetID())
		self.info.isNew = false
		self:UpdateGlow()
	end
end

function Item:GetQuestInfo()
	if self.hasItem then
		if not self.info.cached and C.GetContainerItemQuestInfo then
			local info = C.GetContainerItemQuestInfo(self:GetBag(), self:GetID())
			if info then
				return info.isQuestItem, (info.questID and not info.isActive)
			end
		else
			return self:Super(Item):GetQuestInfo()
		end
	end
end

function Item:GetQuery()
	return self:IsCached() and self.info.hyperlink or {bagID = self:GetBag(), slotIndex = self:GetID()}
end

function Item:IsCached()
	return self.frame:IsCached(self:GetBag())
end