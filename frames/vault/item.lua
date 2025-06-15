--[[
	vaultItem.lua
		A void storage item slot button
--]]

local ADDON, Addon = (...):match('[^_]+'), _G[(...):match('[^_]+')]
local Item = Addon.Item:NewClass('VaultItem')
local C = LibStub('C_Everywhere').Container


--[[ Interaction ]]--

function Item:OnClick(button)
	if not (HandleModifiedItemClick(self.info.hyperlink) or IsModifiedClick() or self:IsCached()) and self.bag == 1 then
		local isRight = button == 'RightButton'
		local type, _, link = GetCursorInfo()

		if not isRight and type == 'item' and link then
			for bag = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
				for slot = 1, C.GetContainerNumSlots(bag) do
					if C.GetContainerItemLink(bag, slot) == link then
						C.UseContainerItem(bag, slot)
					end
				end
			end
		elseif isRight and self.info.isLocked then
			for i = 1,9 do
				if GetVoidTransferWithdrawalInfo(i) == self.info.itemID then
					ClickVoidTransferWithdrawalSlot(i, true)
				end
			end
		else
			ClickVoidStorageSlot(1, self:GetID(), isRight)
		end
	end
end

function Item:OnDragStart()
	self:OnClick('LeftButton')
end

function Item:ShowTooltip()
	if not self:IsCached() then
		GameTooltip:SetOwner(self:GetTipAnchor())

		if self.bag == 1 then
			GameTooltip:SetVoidItem(1, self:GetID())
		elseif self.bag == 2 then
			GameTooltip:SetVoidDepositItem(self:GetID())
		elseif self.bag == 3 then
			GameTooltip:SetVoidWithdrawalItem(self:GetID())
		end

		GameTooltip:Show()
		CursorUpdate(self)

		if IsModifiedClick('DRESSUP') then
			ShowInspectCursor()
		end
	end
end


--[[ Properties ]]--

function Item:IsCached()
	return not CanUseVoidStorage() or self:Super(Item):IsCached()
end
