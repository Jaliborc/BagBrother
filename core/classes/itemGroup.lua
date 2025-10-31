--[[
	A frame that organizes item buttons in a grid and manages updating them.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local Items = Addon.Parented:NewClass('ItemGroup', 'Frame')


--[[ Construct ]]--

function Items:New(parent, bags)
	local f = self:Super(Items):New(parent)
	f.buttons, f.byBag = {}, {}
	f.bags = {}

	for i, bag in ipairs(bags) do
		f.bags[i] = CreateFrame('Frame', nil, f)
		f.bags[i]:SetID(tonumber(bag) or 1)
		f.bags[i].id = bag
	end

	f:SetScript('OnHide', f.UnregisterAll)
	f:SetSize(1,1)
	f:Show()
	return f
end

function Items:OnShow()
	self:RegisterEvents()
	self:Layout()
end


--[[ Events ]]--

function Items:RegisterEvents()
	self:UnregisterAll()
	self:RegisterSignal('UPDATE_ALL', 'Layout')
	self:RegisterFrameSignal('OWNER_CHANGED', 'OnShow')
	self:RegisterFrameSignal('FILTERS_CHANGED', 'Layout')
	self:RegisterFrameSignal('FOCUS_BAG', 'ForAll', 'UpdateFocus')
	self:RegisterSignal('SEARCH_CHANGED', 'ForAll', 'UpdateSearch')
	self:RegisterSignal('SEARCH_TOGGLED', 'ForAll', 'UpdateSearch')
	self:RegisterSignal('LOCKING_TOGGLED', 'ForAll', 'UpdateIgnored')
	self:RegisterEvent('GET_ITEM_INFO_RECEIVED')
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

function Items:GET_ITEM_INFO_RECEIVED(itemID)
	for i, button in ipairs(self.buttons) do
		if button.info.itemID == itemID then
			button:Update()
		end
	end
end

function Items:FLASH_ITEM(itemID)
	for i, button in ipairs(self.buttons) do
		button.FlashFind:Stop()
		if button.info.itemID == itemID then
			button.FlashFind:Play()
		end
	end
end


--[[ Management ]]--

function Items:Update()
	if self:IsStatic() then
		self:ForAll('Update')
	else
		self:Layout()
	end
end

function Items:Layout()
	self:ForAll('Release')
	wipe(self.buttons)
	wipe(self.byBag)

	-- Group slots
	local profile = self:GetProfile()
	local reverseBags, reverseSlots, bagBreak = profile.reverseBags, profile.reverseSlots, profile.bagBreak
	local breaks, group = {0}, 0

	for k = reverseBags and #self.bags or 1, reverseBags and 1 or #self.bags, reverseBags and -1 or 1 do
		local frame = self.bags[k]
		local bag = frame.id
		local numSlots = self.frame:NumSlots(bag)

		if numSlots > 0 and self.frame:IsShowingBag(bag) then
			local family = self.frame:GetBagFamily(bag)
			local slots = {}

			if (bagBreak > 1 or bagBreak > 0 and family ~= group and family * group <= 0) and #self.buttons > breaks[#breaks] then
				tinsert(breaks, #self.buttons)
			end

			for slot = reverseSlots and numSlots or 1, reverseSlots and 1 or numSlots, reverseSlots and -1 or 1 do
				local info = self.frame:GetItemInfo(bag, slot)

				if self.frame:IsShowingItem(bag, slot, info, family) then
					local button = self.Button(frame, bag, slot, info)
					slots[slot] = button
					tinsert(self.buttons, button)
				end
			end

			group = family
			self.byBag[bag] = slots
		end
	end

	-- Layout items
	local columns, scale, size, transposed = self:LayoutTraits(breaks)
	local breakpoint = breaks[2] or #self.buttons
	local stage, x,y = 2, 0,0

	for i, button in ipairs(self.buttons) do
		if i > breakpoint then
			stage = stage + 1
			breakpoint = breaks[stage] or #self.buttons
			x, y = 0, y + profile.breakSpace
		elseif x == columns then
			x, y = 0, y + 1
		end

		button:SetPoint('TOPLEFT', self, 'TOPLEFT', size * (transposed and y or x), -size * (transposed and x or y))
		button:SetScale(scale)

		x = x + 1
	end

	-- Resize grid
	local width, height = max(columns * size * scale, 1), max((y+1) * size * scale, 1)
	self:SetSize(self.Transposed and height or width, self.Transposed and width or height)
	self:SendFrameSignal('ELEMENT_RESIZED')
end

function Items:ForAll(method)
	for i, button in ipairs(self.buttons) do
		button[method](button)
	end
end

function Items:ForBag(bag, method)
	for slot, button in pairs(self.byBag[bag] or Addon.None) do
		button[method](button)
	end
end

function Items:IsStatic()
	local profile = self.frame.profile
	for set, rule in pairs(profile.activeRules) do
		if profile[set] then
			rule = Addon.Rules:Get(rule)
			if rule and not rule.static then
				return false
			end
		end
	end
	return true
end