--[[
	A bag button object.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local Sushi = LibStub('Sushi-3.2')
local C = LibStub('C_Everywhere').Container
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Bag = Addon.Tipped:NewClass('Bag', 'CheckButton')

Bag.Size = 32
Bag.TextureSize = 64 * (Bag.Size/36)
Bag.GetBagID, Bag.GetSlot = Bag.GetID, Bag.GetID
Bag.FilterIcons = {'bags-icon-equipment', 'bags-icon-consumables', 'bags-icon-tradegoods', 'bags-icon-junk', 'bags-icon-questitem'}

Bag.StaticIcons = {
	[BACKPACK_CONTAINER] = 130716,
	[BANK_CONTAINER] = 'interface/addons/bagBrother/art/achievement-guildperk-mobilebanking',
	[KEYRING_CONTAINER or false] = 'interface/containerframe/keyring-bag-icon',
	[REAGENTBANK_CONTAINER or false] = 'interface/icons/achievement_guildperk_bountifulbags',
}

Bag.StaticNames = {
	[BACKPACK_CONTAINER] = BACKPACK_TOOLTIP,
	[BANK_CONTAINER] = BANK,
	[KEYRING_CONTAINER or false] = KEYRING,
	[REAGENTBANK_CONTAINER or false] = REAGENT_BANK,
}


--[[ Construct ]]--

function Bag:New(parent, id)
	local b = self:Super(Bag):New(parent)
	local icon = b:CreateTexture(nil, 'BORDER')
	icon:SetAllPoints(b)

	local count = b:CreateFontString(nil, 'OVERLAY')
	count:SetFontObject('NumberFontNormal')
	count:SetPoint('BOTTOMRIGHT', -4, 3)
	count:SetJustifyH('RIGHT')

	local filter = CreateFrame('Frame', nil, b)
	filter:SetPoint('TOPRIGHT', 4, 4)
	filter:SetSize(20, 20)

	local filterIcon = filter:CreateTexture()
	filterIcon:SetAllPoints()

	local normal = b:CreateTexture()
	normal:SetTexture('Interface/Buttons/UI-Quickslot2')
	normal:SetSize(self.TextureSize, self.TextureSize)
	normal:SetPoint('CENTER', 0, -1)

	local pushed = b:CreateTexture()
	pushed:SetTexture('Interface/Buttons/UI-Quickslot-Depress')
	pushed:SetAllPoints()

	local highlight = b:CreateTexture()
	highlight:SetTexture('Interface/Buttons/ButtonHilight-Square')
	highlight:SetAllPoints()

	local checked = b:CreateTexture()
	checked:SetTexture('Interface/Buttons/CheckButtonHilight')
	checked:SetBlendMode('ADD')
	checked:SetAllPoints()

	b.slot, b.owned = id > BACKPACK_CONTAINER and C.ContainerIDToInventoryID(id), true
	b.Icon, b.Count, b.FilterIcon = icon, count, filter
	b.FilterIcon.Icon = filterIcon

	b:SetID(id)
	b:SetNormalTexture(normal)
	b:SetPushedTexture(pushed)
	b:SetCheckedTexture(checked)
	b:SetHighlightTexture(highlight)
	b:SetScript('OnShow', b.RegisterEvents)
	b:SetScript('OnHide', b.UnregisterAll)
	b:SetScript('OnReceiveDrag', b.OnClick)
	b:SetScript('OnDragStart', b.OnDrag)
	b:SetScript('OnEnter', b.OnEnter)
	b:SetScript('OnLeave', b.OnLeave)
	b:SetScript('OnClick', b.OnClick)
	b:SetSize(self.Size, self.Size)
	b:RegisterForDrag('LeftButton')
	b:RegisterForClicks('anyUp')
	b:RegisterEvents()
	return b
end


--[[ Events ]]--

function Bag:RegisterEvents()
	self:Update()
	self:UnregisterAll()
	self:RegisterFrameSignal('OWNER_CHANGED', 'RegisterEvents')
	self:RegisterFrameSignal('FILTERS_CHANGED', 'UpdateToggle')

	if self:GetID() == BANK_CONTAINER or self:IsBankBag() or self:GetID() == REAGENTBANK_CONTAINER then
		self:RegisterSignal('BANK_CLOSE', 'RegisterEvents')
		self:RegisterSignal('BANK_OPEN', 'RegisterEvents')
	end

	if not self:IsCached() then
		if self:GetID() == REAGENTBANK_CONTAINER then
			self:RegisterEvent('REAGENTBANK_PURCHASED', 'Update')
		elseif self.slot then
			if self:IsBankBag() then
				self:RegisterEvent('PLAYERBANKBAGSLOTS_CHANGED', 'Update')
			end

			self:RegisterEvent('ITEM_LOCK_CHANGED', 'UpdateLock')
			self:RegisterEvent('BAG_SLOT_FLAGS_UPDATED', 'BAG_UPDATE')
			self:RegisterEvent('BAG_CLOSED', 'BAG_UPDATE')
			self:RegisterSignal('BAG_UPDATE')
		end
	elseif self.slot then
		self:RegisterEvent('GET_ITEM_INFO_RECEIVED')
	end
end

function Bag:BAG_UPDATE(_, bag)
	if bag == self:GetID() then
		self:Update()
	end
end

function Bag:GET_ITEM_INFO_RECEIVED(_, item)
	if item == self.itemID then
		self:Update()
	end
end


--[[ Interaction ]]--

function Bag:OnClick(button)
	if button == 'RightButton' then
		self:ShowFilters()
	elseif (self.owned and not CursorHasItem()) or self:IsCached() then
		self:Toggle()
	elseif CursorHasItem() then
		if self.slot then
			PutItemInBag(self.slot)
		else
			PutItemInBackpack()
		end
	else
		self:Purchase()
	end

	self:UpdateToggle()
end

function Bag:OnDrag()
	if self.slot and not self:IsCached() then
		PlaySound(SOUNDKIT.IG_BACKPACK_OPEN)
		PickupBagFromSlot(self.slot)
	end
end

function Bag:OnEnter()
	GameTooltip:SetOwner(self:GetTipAnchor())
	self:UpdateTooltip()
	self:SetFocus(true)
end

function Bag:OnLeave()
	self:Super(Bag):OnLeave()
	self:SetFocus(nil)
end


--[[ Actions ]]--

function Bag:SetFocus(focus)
	local state = focus and self:GetID()
	self.frame.focusedBag = state
	self:SendFrameSignal('FOCUS_BAG', state)
end

function Bag:Toggle()
	local slot = self:GetID()
	local profile = self:GetProfile()
	profile.hiddenBags[slot] = not profile.hiddenBags[slot]

	self:SendFrameSignal('FILTERS_CHANGED')
	self:SetFocus(true)
end

function Bag:ShowFilters()
	if self:GetID() >= BACKPACK_CONTAINER and not self:IsCached() and ContainerFrame1FilterDropDown then
		ContainerFrame1FilterDropDown:SetParent(self)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		ToggleDropDownMenu(1, nil, ContainerFrame1FilterDropDown, self, 0, 0)
	end
end

function Bag:Purchase()
	PlaySound(SOUNDKIT.IG_MAINMENU_OPEN)

	if self:GetID() == REAGENTBANK_CONTAINER then
		Sushi.Popup {
			text = CONFIRM_BUY_REAGNETBANK_TAB, button1 = YES, button2 = NO,
			money = GetReagentBankCost(),
			OnAccept = BuyReagentBank
		}
	else
		Sushi.Popup {
			text = CONFIRM_BUY_BANK_SLOT, button1 = YES, button2 = NO,
			money = GetBankSlotCost(GetNumBankSlots()),
			OnAccept = PurchaseSlot
		}
	end
end


--[[ Update ]]--

function Bag:Update()
	local bag, cached = self:GetID(), self:IsCached()
	local free = not cached and C.GetContainerNumFreeSlots(bag)
	local icon = self.StaticIcons[bag]

	if not icon then
		if cached then
			local data = self:GetOwner()[bag]
			if data and data.link then
				self.link, self.owned = 'item:' .. data.link, true
				self.itemID, _,_,_, icon = GetItemInfoInstant(self.link)
			else
				self.link, self.itemID, self.owned = nil
			end
		else
			self.owned = bag <= Addon.NumBags or (bag - Addon.NumBags) <= GetNumBankSlots()
			self.link = GetInventoryItemLink('player', self.slot)
			icon = GetInventoryItemTexture('player', self.slot)
		end
	elseif bag == REAGENTBANK_CONTAINER then
		self.owned = IsReagentBankUnlocked()
	end

	local color = self.owned and 1 or 0.1
	SetItemButtonTexture(self, icon or 'interface/paperdoll/ui-paperdoll-slot-bag')
	SetItemButtonTextureVertexColor(self, 1, color, color)

	self.Count:SetText((free or 0) > 0 and free or '')
	self:UpdateToggle()
	self:UpdateLock()

	if not cached then
		local id = self:GetID()
		for i, atlas in ipairs(self.FilterIcons) do
			local active = C_Container and (id > 0 and C_Container.GetBagSlotFlag(id, 2^i)) or
						   GetBagSlotFlag and (self:IsBankBag() and GetBankBagSlotFlag(id - NUM_BAG_SLOTS, i) or GetBagSlotFlag(id, i))
			if active then
				return self.FilterIcon.Icon:SetAtlas(atlas)
			end
		end
	end

	self.FilterIcon.Icon:SetAtlas(nil)
end

function Bag:UpdateToggle()
	self:SetChecked(self.owned and self.frame:IsShowingBag(self:GetID()))
end

function Bag:UpdateLock()
    SetItemButtonDesaturated(self, self.slot and IsInventoryItemLocked(self.slot))
end

function Bag:UpdateTooltip()
	GameTooltip:ClearLines()

	-- title/item
	local bag = self:GetID()
	local name = self.StaticNames[bag]

	if name then
		GameTooltip:SetText(name, 1, 1, 1)
	elseif self.link and self:IsCached() then
		GameTooltip:SetHyperlink(self.link)
	elseif self.link then
		GameTooltip:SetInventoryItem('player', self.slot)
	elseif self:IsBankBag() then
		if self.owned then
			GameTooltip:SetText(BANK_BAG, 1, 1, 1)
		else
			GameTooltip:AddLine(BANK_BAG_PURCHASE, 1,1,1)
			SetTooltipMoney(GameTooltip, bag == REAGENTBANK_CONTAINER and GetReagentBankCost() or GetBankSlotCost())
		end
	elseif bag > NUM_BAG_SLOTS then
		GameTooltip:SetText(EQUIP_CONTAINER_REAGENT, 1, 1, 1)
	else
		GameTooltip:SetText(EQUIP_CONTAINER, 1, 1, 1)
	end

	-- instructions
	if self.owned then
		GameTooltip:AddLine(self:GetChecked() and L.HideBag or L.ShowBag)
	end

	GameTooltip:Show()
end


--[[ Properties ]]--

function Bag:IsBankBag() return self:GetID() > Addon.NumBags end
function Bag:IsCombinedBagContainer() end -- delicious hack
