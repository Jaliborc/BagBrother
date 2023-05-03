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


--[[ API ]]--

function Item:Update()
	self:Super(Item):Update()

	if self.hasItem and not self:IsCached() then
		local start, duration, enable = C.GetContainerItemCooldown(self:GetBag(), self:GetID())
		local fade = duration > 0 and 0.4 or 1

		CooldownFrame_Set(self.Cooldown, start, duration, enable)
		SetItemButtonTextureVertexColor(self, fade,fade,fade)
	else
		CooldownFrame_Set(self.Cooldown, 0,0,0)
		self.Cooldown:Hide()
	end
end

function Item:MarkSeen()
	if self.NewItemTexture:IsShown() then
		C_NewItems.RemoveNewItem(self:GetBag(), self:GetID())
		self:UpdateNewItemAnimation()
	end
end


--[[ Proprieties ]]--

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
	return {bagID = self:GetBag(), slotIndex = self:GetID()}
end

function Item:GetBagFamily()
	local family = 0
	return self.BagFamilies[family] or 'normal'
end