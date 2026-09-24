--[[
	A container item button.
	All Rights Reserved
--]]


local ADDON, Addon = ...
local Item = Addon.Item:NewClass('ContainerItem')
local C = LibStub('C_Everywhere')

Item.BagFamilies = {
	[-1] = 'account',
	[0x0000001] = 'quiver',
	[0x0000002] = 'quiver',
	[0x0000003] = 'soul',
	[0x0000004] = 'soul',
	[0x0000006] = 'herb',
	[0x0000007] = 'enchant',
	[0x0000008] = 'leather',
	[0x0000009] = 'key',
	[0x0000010] = 'inscribe',
	[0x0000020] = 'herb',
	[0x0000040] = 'enchant',
	[0x0000080] = 'engineer',
	[0x0000200] = 'gem',
	[0x0000400] = 'mine',
 	[0x0008000] = 'tackle',
 	[0x0010000] = 'fridge',
	[0x0080000] = 'reagent', -- not official number (there is none)
	[0x2000000] = 'leather',
}


--[[ Events ]]--

function Item:Construct()
	local b = self:Super(Item):Construct()
	b.Cooldown:SetScript('OnCooldownDone', function() SetItemButtonTextureVertexColor(b, 1,1,1) end)
	return b
end

function Item:ShowTooltip()
	self:Super(Item):ShowTooltip()
	self:MarkSeen()
end

if C.Bank.AreAnyBankTypesViewable then
	function Item:PreClick(button)
		if not InCombatLockdown() and button == 'RightButton' and Addon.Events.AtBank and Addon.Frames:IsEnabled('bank') then
			local bankType = Addon_GetBankType()
			bankType = IsShiftKeyDown() and (2 - bankType) or bankType
			bankType = not C.Bank.CanUseBank(bankType) and (2 - bankType) or bankType

			C.Container.UseContainerItem(self:GetBag(), self:GetID(), nil, bankType)
		end
	end
end


--[[ Update ]]--

function Item:Update(...)
	self:Super(Item):Update(...)
	self:UpdateCooldown()

	local r,g,b = 1,1,1
	if not self.hasItem then
		local family = self:GetBagFamily(self:GetBag())
		local color = Addon.sets.colorSlots and Addon.sets.color[self.BagFamilies[family] or 'normal'] or Addon.None

		r,g,b = color[1] or 1, color[2] or 1, color[3] or 1
	end

	SetItemButtonTextureVertexColor(self, r,g,b)
	self:GetNormalTexture():SetVertexColor(r,g,b)
end

function Item:UpdateCooldown()
	if self.hasItem and not self:IsCached() then
		CooldownFrame_Set(self.Cooldown, C.Container.GetContainerItemCooldown(self:GetBag(), self:GetID()))
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
		C.NewItems.RemoveNewItem(self:GetBag(), self:GetID())
		self.info.isNew = false
		self:UpdateGlow()
	end
end

function Item:GetQuestInfo()
	if self.hasItem then
		if not self.info.cached and C.Container.GetContainerItemQuestInfo then
			local info = C.Container.GetContainerItemQuestInfo(self:GetBag(), self:GetID())
			if info then
				return info.isQuestItem, (info.questID and not info.isActive)
			end
		else
			return self:Super(Item):GetQuestInfo()
		end
	end
end

function Item:IsCached()
	return self.frame:IsCached(self:GetBag())
end