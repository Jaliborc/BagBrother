--[[
	item.lua
		A container item button.
--]]


local ADDON, Addon = ...
local Item = Addon.Item:NewClass('ContainerItem')
local C = LibStub('C_Everywhere').Container


--[[ Events ]]--

function Item:Construct()
  local b = self:Super(Item):Construct()
  b.Cooldown:SetScript('OnCooldownDone', function() SetItemButtonTextureVertexColor(b, 1,1,1) end)
  b:SetScript('PreClick', b.OnPreClick)
  return b
end

function Item:OnPreClick(button)
	if not IsModifiedClick() and button == 'RightButton' then
		if REAGENTBANK_CONTAINER and Addon.Events.AtBank and IsReagentBankUnlocked() and C.GetContainerNumFreeSlots(REAGENTBANK_CONTAINER) > 0 then
			if not Addon:IsReagents(self:GetBag()) and select(17, GetItemInfo(self.info.itemID)) then
				local stackSize = select(8, GetItemInfo(self.info.itemID))
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

				C.UseContainerItem(self:GetBag(), self:GetID(), nil, true)
			end
		end
	end

	self.locked = self.info.isLocked
end

function Item:OnPostClick(button)
	self:Super(Item):OnPostClick(button)

	if Addon.Events.AtVault and self.locked and not IsModifiedClick() and button == 'RightButton' then
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

function Item:OnHide()
	self:Super(Item):OnHide()
	self:MarkSeen()
end


--[[ Update ]]--

function Item:Update()
	self:Super(Item):Update()
	self:UpdateCooldown()

	if self.hasItem then
		self:GetNormalTexture():SetVertexColor(1,1,1)
	else
		local family = self.frame:GetBagFamily(self:GetBag())
		local color = Addon.sets.colorSlots and Addon.sets[(self.BagFamilies[family] or 'normal') .. 'Color'] or Addon.None
		local r,g,b = color[1] or 1, color[2] or 1, color[3] or 1

		SetItemButtonTextureVertexColor(self, r,g,b)
		self:GetNormalTexture():SetVertexColor(r,g,b)
	end
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