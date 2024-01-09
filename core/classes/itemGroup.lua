--[[
	A frame that organizes item buttons in a grid and manages updating them.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local Items = Addon.Parented:NewClass('ItemGroup', 'Frame')


--[[ Construct ]]--

function Items:New(parent, bags)
	local f = self:Super(Items):New(parent)
	f.buttons, f.order = {}, {}
	f.bags = {}

	for i, bag in ipairs(bags) do
		f.bags[i] = CreateFrame('Frame', nil, f)
		f.bags[i]:SetID(tonumber(bag) or 1)
		f.bags[i].id = bag
	end

	f:SetScript('OnHide', f.UnregisterAll)
	f:SetScript('OnShow', f.Update)
	f:SetSize(1,1)
	f:Update()
	return f
end

function Items:Update()
	self:RegisterEvents()
	self:Layout()
end


--[[ Events ]]--

function Items:RegisterEvents()
	self:UnregisterAll()
	self:RegisterSignal('UPDATE_ALL', 'Layout')
	self:RegisterFrameSignal('OWNER_CHANGED', 'Update')
	self:RegisterFrameSignal('FILTERS_CHANGED', 'Layout')
	self:RegisterFrameSignal('FOCUS_BAG', 'ForAll', 'UpdateFocus')
	self:RegisterSignal('SEARCH_CHANGED', 'ForAll', 'UpdateSearch')
	self:RegisterSignal('SEARCH_TOGGLED', 'ForAll', 'UpdateSearch')
	self:RegisterEvent('GET_ITEM_INFO_RECEIVED')
	self:RegisterSignal('LOCKING_TOGGLED')
	self:RegisterSignal('FLASH_ITEM')

	if not self:IsCached() then
		self:RegisterEvent('UNIT_INVENTORY_CHANGED', 'ForAll', 'UpdateUpgradeIcon')

		if C_SpecializationInfo then
			self:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED', 'ForAll', 'UpdateUpgradeIcon')
		end
		if C_EquipmentSet then
			self:RegisterEvent('EQUIPMENT_SETS_CHANGED', 'ForAll', 'UpdateBorder')
		end
	end
end

function Items:GET_ITEM_INFO_RECEIVED(_,itemID)
	for i, button in ipairs(self.order) do
		if button.info.itemID == itemID then
			button:Update()
		end
	end
end

function Items:FLASH_ITEM(_,itemID)
	for i, button in ipairs(self.order) do
		button.FlashFind:Stop()
		if button.info.itemID == itemID then
			button.FlashFind:Play()
		end
	end
end

function Items:LOCKING_TOGGLED()
	local locks = self:GetProfile().lockedSlots
	for bag, slots in pairs(self.buttons) do
		for slot, button in pairs(self.buttons[bag]) do
			button.IgnoredOverlay:SetShown(Addon.lockMode and locks[bag] and locks[bag][slot])
		end
	end
end


--[[ Management ]]--

function Items:Layout()
	self:ForAll('Release')
	wipe(self.buttons)
	wipe(self.order)

	-- Acquire slots
	for i, frame in ipairs(self.bags) do
		local bag = frame.id
		if self.frame:IsShowingBag(bag) then
			for slot = 1, self.frame:NumSlots(bag) do
				if self.frame:IsShowingItem(bag, slot) then
					local button = self.Button(frame, bag, slot)
					self.buttons[bag] = self.buttons[bag] or {}
					self.buttons[bag][slot] = button
					tinsert(self.order, button)
				end
			end
		end
	end

	-- Position slots
	local profile = self:GetProfile()
	local columns, scale, size = self:LayoutTraits()
	local revBags, revSlots = profile.reverseBags, profile.reverseSlots

	local x, y = 0,0
	local group = 0

	for k = revBags and #self.bags or 1, revBags and 1 or #self.bags, revBags and -1 or 1 do
		local bag = self.bags[k].id
		local slots = self.buttons[bag]
		local family = self.frame:GetBagFamily(bag)

		if x > 0 and (profile.bagBreak > 1 or profile.bagBreak > 0 and (family == 0) ~= (group == 0)) then
			group = family
			y = y + 1
			x = 0
		end

		if slots then
			local numSlots = self.frame:NumSlots(bag)
			for slot = revSlots and numSlots or 1, revSlots and 1 or numSlots, revSlots and -1 or 1 do
				local button = slots[slot]
				if button then
					if x == columns then
						y = y + 1
						x = 0
					end

					button:ClearAllPoints()
					button:SetPoint('TOPLEFT', self, 'TOPLEFT', size * (self.Transposed and y or x), -size * (self.Transposed and x or y))
					button:SetScale(scale)

					x = x + 1
				end
			end
		end
	end

	-- Resize frame
	if x > 0 then
		y = y + 1
	end

	local width, height = max(columns * size * scale, 1), max(y * size * scale, 1)
	self:SetSize(self.Transposed and height or width, self.Transposed and width or height)
	self:SendFrameSignal('ELEMENT_RESIZED')
end

function Items:ForAll(method, ...)
	for i, button in ipairs(self.order) do
		button[method](button, ...)
	end
end

function Items:ForBag(bag, method, ...)
	if self.buttons[bag] then
		for slot, button in pairs(self.buttons[bag]) do
			button[method](button, ...)
		end
	end
end

function Items:LayoutTraits()
	local profile = self:GetProfile()
	return profile.columns, profile.itemScale, 37 + profile.spacing
end