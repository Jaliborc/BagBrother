--[[
	Client side bag sorting algorithm.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local Search = LibStub('ItemSearch-1.3')
local Cache = LibStub('LibItemCache-2.0')
local Sort = Addon:NewModule('Sorting', 'MutexDelay-1.0')

Sort.Proprieties = {
	'set',
	'class', 'subclass', 'equip',
	'quality',
	'iconFileID', 'level', 'itemID',
	'stackCount'
}


--[[ Process ]]--

function Sort:Start(target)
	if not self:CanRun() then
		return
	end

	self:SendSignal('SORTING_STATUS', target.id)
	self.target = target
	self:Run()
end

function Sort:Run()
	if self:CanRun() then
		ClearCursor()
		self:Iterate()
	else
		self:Stop()
	end
end

function Sort:Iterate()
	local spaces = self:GetSpaces()
	local families = self:GetFamilies(spaces)

	local stackable = function(item)
		return (item.stackCount or 1) < (item.stackSize or 1)
	end

	for k, target in pairs(spaces) do
		local item = target.item
		if item.itemID and stackable(item) then
			for j = k+1, #spaces do
				local from = spaces[j]
				local other = from.item

				if item.itemID == other.itemID and stackable(other) then
					self:Move(from, target)
					self:Delay(0.05, 'Run')
				end
			end
		end
	end

	local moveDistance = function(item, goal)
		return math.abs(item.space.index - goal.index)
	end

	for _, family in ipairs(families) do
		local order, spaces = self:GetOrder(spaces, family)
		local n = min(#order, #spaces)

		for index = 1, n do
			local goal = spaces[index]
			local item = order[index]
			item.sorted = true

			if item.space ~= goal then
				local distance = moveDistance(item, goal)

				for j = index, n do
					local other = order[j]
					if other.itemID == item.itemID and other.stackCount == item.stackCount then
						local d = moveDistance(other, spaces[j])
						if d > distance then
							item = other
							distance = d
						end
					end
				end

				self:Move(item.space, goal)
				self:Delay(0.05, 'Run')
			end
		end
	end

	if not self:Delaying('Run') then
		self:Stop()
	end
end

function Sort:Stop()
	self:SendSignal('SORTING_STATUS')
end


--[[ Data Structures ]]--

function Sort:GetSpaces()
	local profile = self.target:GetProfile()
	local spaces = {}

	for _, bag in pairs(self.target.Bags) do
		local family = self.target:GetBagFamily(bag)
		local locked = profile.lockedSlots[bag]
		
		for slot = 1, self.target:NumSlots(bag) do
			if not locked or not locked[slot] then
				local item = self.target:GetItemInfo(bag, slot)
				local id = item.itemID
				if id then
					local name, _,_, level, _,_,_, stack, equip, _, _, class, subclass = GetItemInfo(id) 

					item.class = Search:IsQuestItem(id) and Enum.ItemClass.Questitem or class or 14
					item.set = (item.class < Enum.ItemClass.Weapon and 0) or Search:BelongsToSet(id) and 1 or 2
					item.subclass, item.equip, item.level, item.stackSize = subclass, equip, level, stack
					item.family = GetItemFamily(id) or 0
				end

				tinsert(spaces, {index = #spaces, bag = bag, slot = slot, family = family, item = item})
				item.space = spaces[#spaces]
			end
		end
	end

	return spaces
end

function Sort:GetFamilies(spaces)
	local set = {}
	for _, space in ipairs(spaces) do
		set[space.family] = true
	end

	local list = {}
	for family in pairs(set) do
		tinsert(list, family)
	end

	sort(list, function(a, b) return a > b or a < 0 end)
	return list
end

function Sort:GetOrder(spaces, family)
	local order, slots = {}, {}

	for _, space in ipairs(spaces) do
		local item = space.item
		if item.itemID and not item.sorted and self:FitsIn(item.itemID, family) then
			tinsert(order, space.item)
		end

		if space.family == family then
			tinsert(slots, space)
		end
	end

	sort(order, self.Rule)
	return order, slots
end


--[[ API ]]--

function Sort:CanRun()
	return not InCombatLockdown() and not UnitIsDead('player')
end

function Sort:FitsIn(id, family)
	if family == 9 then
		return GetItemFamily(id) == 256
	elseif family == -3 then
		return select(17, GetItemInfo(id))
	end
	
	return family == 0 or (bit.band(GetItemFamily(id), family) > 0 and select(9, GetItemInfo(id)) ~= 'INVTYPE_BAG')
end

function Sort.Rule(a, b)
	for _,prop in pairs(Sort.Proprieties) do
		if a[prop] ~= b[prop] then
			return a[prop] > b[prop]
		end
	end

	if a.space.family ~= b.space.family then
		return a.space.family > b.space.family
	end
	return a.space.index < b.space.index
end

function Sort:Move(from, to)
	if from.locked or to.locked or (to.item.itemID and not self:FitsIn(to.item.itemID, from.family)) then
		return
	end

	ClearCursor()
	self.target.PickupItem(from.bag, from.slot)
	self.target.PickupItem(to.bag, to.slot)

	from.locked = true
	to.locked = true
	return true
end
