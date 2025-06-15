--[[
	item.lua
		A guild item slot button
--]]

local ADDON, Addon = (...):match('[^_]+'), _G[(...):match('[^_]+')]
local Item = Addon.Item:NewClass('GuildItem')


--[[ Construct ]]--

function Item:Construct()
	local b = self:Super(Item):Construct()
	b:RegisterForDrag('LeftButton')
	b:RegisterForClicks('anyUp')
	return b
end


--[[ Events ]]--

function Item:OnClick(button)
	if HandleModifiedItemClick(self.info.hyperlink) then
		return
	elseif IsModifiedClick('SPLITSTACK') then
		if not CursorHasItem() and self.hasItem and not self.info.isLocked and self.info.stackCount > 1 then
			if OpenStackSplitFrame then
				OpenStackSplitFrame(self.info.stackCount, self, 'BOTTOMLEFT', 'TOPLEFT')
			else
				StackSplitFrame:OpenStackSplitFrame(self.info.stackCount, self, 'BOTTOMLEFT', 'TOPLEFT')
			end
		end
	else
		local type, amount = GetCursorInfo()
		if type == 'money' then
			DepositGuildBankMoney(amount)
			ClearCursor()
		elseif type == 'guildbankmoney' then
			DropCursorMoney()
			ClearCursor()
		elseif button == 'RightButton' then
			AutoStoreGuildBankItem(self:GetSlot())
		else
			PickupGuildBankItem(self:GetSlot())
		end
	end
end

function Item:OnDragStart(button)
	if not self:IsCached() then
		PickupGuildBankItem(self:GetSlot())
	end
end

function Item:OnReceiveDrag(button)
	if not self:IsCached() then
		PickupGuildBankItem(self:GetSlot())
	end
end


--[[ Overrides ]]--

function Item:ShowTooltip()
	GameTooltip:SetOwner(self:GetTipAnchor())
	GameTooltip:SetGuildBankItem(self:GetSlot())
	GameTooltip:Show()
	CursorUpdate(self)
end

function Item:SplitStack(split)
	SplitGuildBankItem(self:GetBag(), self:GetID(), split)
end

function Item:GetBag() return GetCurrentGuildBankTab() end
function Item:UpdateFocus() end
