-- Comprehensive standalone unit test suite for BagBrother client-side sorting algorithm (core/api/sorting.lua)
-- Run with: lua tests/test_sorting.lua

local passCount = 0
local failCount = 0

local function assertEqual(actual, expected, msg)
	if actual == expected then
		passCount = passCount + 1
	else
		failCount = failCount + 1
		print(string.format("  [FAIL] %s: expected '%s', got '%s'", msg or "assertion failed", tostring(expected), tostring(actual)))
	end
end

local function assertTrue(condition, msg)
	if condition then
		passCount = passCount + 1
	else
		failCount = failCount + 1
		print(string.format("  [FAIL] %s: expected true, got %s", msg or "assertion failed", tostring(condition)))
	end
end

local function assertFalse(condition, msg)
	if not condition then
		passCount = passCount + 1
	else
		failCount = failCount + 1
		print(string.format("  [FAIL] %s: expected false, got %s", msg or "assertion failed", tostring(condition)))
	end
end

-- Setup WoW Environment Mocks
tinsert = table.insert
tremove = table.remove
sort = table.sort
min = math.min
max = math.max
abs = math.abs

bit = bit or {
	band = function(a, b)
		local p, c = 1, 0
		while a > 0 and b > 0 do
			local ra, rb = a % 2, b % 2
			if ra + rb == 2 then c = c + p end
			a, b, p = (a - ra) / 2, (b - rb) / 2, p * 2
		end
		return c
	end
}

GetOrCreateTableEntry = function(t, k)
	if not t[k] then t[k] = {} end
	return t[k]
end

Enum = {
	ItemClass = {
		Consumable = 0,
		Container = 1,
		Weapon = 2,
		Gem = 3,
		Armor = 4,
		Reagent = 5,
		Tradeskill = 7,
		Questitem = 12,
		Miscellaneous = 14,
	}
}

local combatState = false
local deadState = false
InCombatLockdown = function() return combatState end
UnitIsDead = function(unit) return deadState end
ClearCursor = function() end

-- Mock Database of Item Definitions:
-- id -> { name, link, quality, level, reqLevel, class, subclass, maxStack, equipSlot, isReagent, itemFamily }
local itemDatabase = {
	-- Normal Tradeskill Cloth
	[33470] = { "Frostweave Cloth", "item:33470", 1, 70, 1, Enum.ItemClass.Tradeskill, 0, 200, "", true, 0 },
	-- Herb (Family 0x0020 = 32)
	[152510] = { "Anchor Weed", "item:152510", 1, 50, 1, Enum.ItemClass.Tradeskill, 6, 200, "", true, 0x0020 },
	-- Ore / Mining (Family 0x0008 = 8)
	[152512] = { "Monelite Ore", "item:152512", 1, 50, 1, Enum.ItemClass.Tradeskill, 7, 200, "", true, 0x0008 },
	-- Gem (Family 256)
	[153706] = { "Kraken's Eye", "item:153706", 3, 50, 1, Enum.ItemClass.Gem, 0, 20, "", true, 256 },
	-- Bag item
	[21841] = { "Netherweave Bag", "item:21841", 1, 60, 1, Enum.ItemClass.Container, 0, 1, "INVTYPE_BAG", false, 0 },
	-- Consumable potion
	[171266] = { "Potion of Spectral Agility", "item:171266", 1, 60, 50, Enum.ItemClass.Consumable, 1, 20, "", false, 0 },
	-- Weapons & Armor
	[19019] = { "Thunderfury", "item:19019", 5, 80, 60, Enum.ItemClass.Weapon, 7, 1, "INVTYPE_WEAPON", false, 0 },
	[18814] = { "Choker of the Fire Lord", "item:18814", 4, 75, 60, Enum.ItemClass.Armor, 0, 1, "INVTYPE_NECK", false, 0 },
	[12064] = { "Overlord's Crown", "item:12064", 2, 45, 40, Enum.ItemClass.Armor, 4, 1, "INVTYPE_HEAD", false, 0 },
	-- Mining Ore (Family 0x0400 = 1024)
	[171828] = { "Laestrite Ore", "item:171828", 1, 50, 1, Enum.ItemClass.Tradeskill, 7, 200, "", true, 0x0400 },
	-- Quest Item
	[33550] = { "Quest Journal", "item:33550", 1, 70, 1, Enum.ItemClass.Questitem, 0, 1, "", false, 0 },
}

local mockItemInfo = function(id)
	local d = itemDatabase[id]
	if d then
		-- return name, link, quality, level, reqLevel, class, subclass, maxStack, equipSlot, icon, sellPrice, classID, subclassID, bindType, expacID, setID, isCraftingReagent
		return d[1], d[2], d[3], d[4], d[5], nil, nil, d[8], d[9], nil, nil, d[6], d[7], nil, nil, nil, d[10]
	end
	return "Unknown Item", "item:" .. id, 1, 1, 1, nil, nil, 20, "", nil, nil, 0, 0, nil, nil, nil, false
end

local mockItemFamily = function(id)
	local d = itemDatabase[id]
	return d and d[11] or 0
end

local isSetItem = false
local mockSearch = {
	IsQuestItem = function(self, id) return id == 33550 end,
	BelongsToSet = function(self, id) return isSetItem and (id == 18814) end,
}

local mockItem = {
	GetItemInfo = mockItemInfo,
	GetItemFamily = mockItemFamily,
}

local LibStub = function(name)
	if name == 'ItemSearch-1.3' then
		return mockSearch
	elseif name == 'C_Everywhere' then
		return { Item = mockItem }
	elseif name == 'MutexDelay-1.0' then
		return {}
	end
	error("Unknown LibStub library: " .. tostring(name))
end
_G.LibStub = LibStub

local registeredModules = {}
local Addon = {
	None = {},
	NewModule = function(self, name, ...)
		local mod = {
			SendSignal = function() end,
			Delay = function() end,
			Delaying = function() return false end,
			Stop = function() end,
		}
		registeredModules[name] = mod
		return mod
	end,
}

-- Load core/api/sorting.lua
local chunk, err = loadfile("core/api/sorting.lua")
if not chunk then
	error("Failed to load core/api/sorting.lua: " .. tostring(err))
end

chunk("BagBrother", Addon)
local Sort = registeredModules['Sorting']

print("=== Running Comprehensive Standalone Sorting Unit Tests ===")

-- =========================================================================
-- Test 1: Default Sorting (Full Stacks First)
-- =========================================================================
print("\n[Test 1] Default Sorting (Full Stacks First)")
do
	local target = {
		id = "inventory",
		profile = { partialFirst = false, reverseSort = false },
		Bags = { 0 },
		GetBagInfo = function(self, bag) return {} end,
		GetBagFamily = function(self, bag) return 0 end,
		NumSlots = function(self, bag) return 2 end,
		GetItemInfo = function(self, bag, slot)
			if slot == 1 then
				return { itemID = 33470, stackCount = 5, quality = 1 }
			elseif slot == 2 then
				return { itemID = 33470, stackCount = 200, quality = 1 }
			end
			return Addon.None
		end,
	}

	Sort.target = target
	local spaces = Sort:GetSpaces()
	local order, slots = Sort:GetOrder(spaces, 0)

	assertEqual(#order, 2, "Order contains 2 items")
	assertEqual(order[1].stackCount, 200, "First sorted item is full stack (200)")
	assertEqual(order[2].stackCount, 5, "Second sorted item is partial stack (5)")
end

-- =========================================================================
-- Test 2: Partial Stacks First (partialFirst = true)
-- =========================================================================
print("\n[Test 2] Partial Stacks First (partialFirst = true)")
do
	local target = {
		id = "bank",
		profile = { partialFirst = true, reverseSort = false },
		Bags = { 1 },
		GetBagInfo = function(self, bag) return {} end,
		GetBagFamily = function(self, bag) return 0 end,
		NumSlots = function(self, bag) return 2 end,
		GetItemInfo = function(self, bag, slot)
			if slot == 1 then
				return { itemID = 33470, stackCount = 200, quality = 1 }
			elseif slot == 2 then
				return { itemID = 33470, stackCount = 5, quality = 1 }
			end
			return Addon.None
		end,
	}

	Sort.target = target
	local spaces = Sort:GetSpaces()
	local order, slots = Sort:GetOrder(spaces, 0)

	assertEqual(#order, 2, "Order contains 2 items")
	local firstCount = abs(order[1].stackCount)
	local secondCount = abs(order[2].stackCount)
	assertEqual(firstCount, 5, "First sorted item is partial stack (5)")
	assertEqual(secondCount, 200, "Second sorted item is full stack (200)")
end

-- =========================================================================
-- Test 3: Stackable / Consolidation Check with partialFirst = true
-- =========================================================================
print("\n[Test 3] Stackable & Capacity Check")
do
	local target = {
		id = "inventory",
		profile = { partialFirst = true, reverseSort = false },
		Bags = { 0 },
		GetBagInfo = function(self, bag) return {} end,
		GetBagFamily = function(self, bag) return 0 end,
		NumSlots = function(self, bag) return 3 end,
		GetItemInfo = function(self, bag, slot)
			if slot == 1 then
				return { itemID = 33470, stackCount = 5, quality = 1 }
			elseif slot == 2 then
				return { itemID = 33470, stackCount = 10, quality = 1 }
			elseif slot == 3 then
				return { itemID = 33470, stackCount = 200, quality = 1 }
			end
			return Addon.None
		end,
	}

	Sort.target = target
	local spaces = Sort:GetSpaces()

	local stackable = function(item)
		return (abs(item.stackCount or 1)) < (item.stackSize or 1)
	end

	assertTrue(spaces[1].item.stackSize > 0, "item.stackSize is a positive capacity (200)")
	assertEqual(spaces[1].item.stackSize, 200, "item.stackSize matches max stack definition (200)")
	assertTrue(stackable(spaces[1].item), "Partial stack slot 1 (5/200) is stackable")
	assertTrue(stackable(spaces[2].item), "Partial stack slot 2 (10/200) is stackable")
	assertFalse(stackable(spaces[3].item), "Full stack slot 3 (200/200) is NOT stackable")
end

-- =========================================================================
-- Test 4: Reverse Sorting (reverseSort = true)
-- =========================================================================
print("\n[Test 4] Reverse Sorting (reverseSort = true)")
do
	local target = {
		id = "inventory",
		profile = { partialFirst = false, reverseSort = true },
		Bags = { 0 },
		GetBagInfo = function(self, bag) return {} end,
		GetBagFamily = function(self, bag) return 0 end,
		NumSlots = function(self, bag) return 4 end,
		GetItemInfo = function(self, bag, slot)
			if slot == 1 then
				return { itemID = 33470, stackCount = 10, quality = 1 }
			end
			return Addon.None
		end,
	}

	Sort.target = target
	local spaces = Sort:GetSpaces()

	assertEqual(#spaces, 4, "Total spaces is 4")
	-- With reverseSort = true, slot 4 is swapped to spaces[1], and slot 1 is spaces[4]
	assertEqual(spaces[1].slot, 4, "First destination slot is slot 4 (bottom-right)")
	assertEqual(spaces[4].slot, 1, "Last destination slot is slot 1 (top-left)")
	assertEqual(spaces[1].index, 1, "First space has index 1")
	assertEqual(spaces[4].index, 4, "Last space has index 4")
end

-- =========================================================================
-- Test 5: Multi-Property Sort Rule Priority (Sort.ItemRule)
-- =========================================================================
print("\n[Test 5] Multi-Property Sort Rule Priority")
do
	local target = {
		id = "inventory",
		profile = { partialFirst = false, reverseSort = false },
		Bags = { 0 },
		GetBagInfo = function(self, bag) return {} end,
		GetBagFamily = function(self, bag) return 0 end,
		NumSlots = function(self, bag) return 6 end,
		GetItemInfo = function(self, bag, slot)
			if slot == 1 then
				return { itemID = 171266, stackCount = 20, quality = 1 } -- Consumable potion (class 0)
			elseif slot == 2 then
				return { itemID = 19019, stackCount = 1, quality = 5 } -- Legendary Weapon (class 2)
			elseif slot == 3 then
				return { itemID = 18814, stackCount = 1, quality = 4 } -- Epic Neck (class 4, set item)
			elseif slot == 4 then
				return { itemID = 12064, stackCount = 1, quality = 2 } -- Uncommon Head (class 4, non-set)
			elseif slot == 5 then
				return { itemID = 33470, stackCount = 200, quality = 1 } -- Tradeskill cloth (class 7)
			elseif slot == 6 then
				return { itemID = 33550, stackCount = 1, quality = 1 } -- Quest item (class 12)
			end
			return Addon.None
		end,
	}

	isSetItem = true
	Sort.target = target
	local spaces = Sort:GetSpaces()
	local order, slots = Sort:GetOrder(spaces, 0)
	isSetItem = false

	assertEqual(#order, 6, "Order contains 6 items")
	-- Priority in BagBrother Sort.Properties (set -> class -> subclass -> equip -> quality -> level -> itemID -> stackCount):
	-- 1. Quest item: class 12, set 2
	-- 2. Tradeskill cloth: class 7, set 2
	-- 3. Non-set armor: class 4, set 2
	-- 4. Weapon: class 2, set 2
	-- 5. Equipment set armor: class 4, set 1
	-- 6. Consumable potion: class 0, set 0
	assertEqual(order[1].itemID, 33550, "1st: Quest item (class 12, set 2)")
	assertEqual(order[2].itemID, 33470, "2nd: Tradeskill cloth (class 7, set 2)")
	assertEqual(order[3].itemID, 12064, "3rd: Non-set armor (class 4, set 2)")
	assertEqual(order[4].itemID, 19019, "4th: Weapon (class 2, set 2)")
	assertEqual(order[5].itemID, 18814, "5th: Set armor (class 4, set 1)")
	assertEqual(order[6].itemID, 171266, "6th: Consumable (class 0, set 0)")
end

-- =========================================================================
-- Test 6: Bag Family Filtering & Specialty Containers (FitsIn & GetFamilies)
-- =========================================================================
print("\n[Test 6] Bag Specialty & Family Filtering")
do
	-- Normal bag (family 0) accepts all items
	assertTrue(Sort:FitsIn(33470, 0), "Frostweave cloth fits in normal bag (family 0)")
	assertTrue(Sort:FitsIn(152510, 0), "Herb fits in normal bag (family 0)")
	assertTrue(Sort:FitsIn(21841, 0), "Netherweave Bag fits in normal bag (family 0)")

	-- Herb Bag (family 0x0020)
	assertTrue(Sort:FitsIn(152510, 0x0020), "Herb fits in herb bag (family 0x0020)")
	assertFalse(Sort:FitsIn(152512, 0x0020), "Ore does NOT fit in herb bag (family 0x0020)")

	-- Mining Bag (family 0x0008)
	assertTrue(Sort:FitsIn(152512, 0x0008), "Ore fits in mining bag (family 0x0008)")
	assertFalse(Sort:FitsIn(152510, 0x0008), "Herb does NOT fit in mining bag (family 0x0008)")

	-- Reagent Bag (family 0x80000 = 524288)
	assertTrue(Sort:FitsIn(33470, 0x80000), "Crafting reagent cloth fits in reagent bag (0x80000)")
	assertTrue(Sort:FitsIn(152510, 0x80000), "Crafting reagent herb fits in reagent bag (0x80000)")
	assertFalse(Sort:FitsIn(19019, 0x80000), "Weapon does NOT fit in reagent bag (0x80000)")

	-- Gem Bag (family 9 in WoW Classic / BagBrother specialty constant)
	assertTrue(Sort:FitsIn(153706, 9), "Gem fits in gem bag (family 9)")
	assertFalse(Sort:FitsIn(33470, 9), "Cloth does NOT fit in gem bag (family 9)")

	-- INVTYPE_BAG cannot be stored in specialty bag even if bitmask matches
	assertFalse(Sort:FitsIn(21841, 0x0020), "Equippable bag cannot be placed in herb bag")

	-- Family order sorting in GetFamilies
	local mockSpaces = {
		{ family = 0 },
		{ family = 0x0020 },
		{ family = 0x80000 },
		{ family = 0x0008 },
	}
	local families = Sort:GetFamilies(mockSpaces)
	assertEqual(#families, 4, "4 distinct families discovered")
	assertEqual(families[1], 0x0020, "1st family processed is specialty herb (0x0020)")
	assertEqual(families[2], 0x0008, "2nd family processed is specialty mining (0x0008)")
	assertEqual(families[3], 0x80000, "3rd family processed is reagent bag (0x80000)")
	assertEqual(families[4], 0, "4th family processed is general inventory (0)")
end

-- =========================================================================
-- Test 7: OptimizeOrder (Minimize In-Place Redundant Swaps)
-- =========================================================================
print("\n[Test 7] OptimizeOrder Matching")
do
	-- Create 4 spaces where slot 2 and slot 4 already contain identical items of 200 cloth
	local item1 = { itemID = 33470, stackCount = 200 }
	local item2 = { itemID = 33470, stackCount = 200 }
	local item3 = { itemID = 33470, stackCount = 200 }
	local item4 = { itemID = 33470, stackCount = 200 }

	local space1 = { bag = 0, slot = 1, item = item1 }
	local space2 = { bag = 0, slot = 2, item = item2 }
	local space3 = { bag = 0, slot = 3, item = item3 }
	local space4 = { bag = 0, slot = 4, item = item4 }

	item1.space = space1
	item2.space = space2
	item3.space = space3
	item4.space = space4

	local spaces = { space1, space2, space3, space4 }
	-- order list before optimization (e.g. from table.sort)
	local order = { item3, item2, item1, item4 }

	Sort:OptimizeOrder(order, spaces, 4)

	-- Verify that items already occupying target slots 1, 2, 3, 4 are preserved in order
	assertEqual(order[1].space.slot, 1, "Order[1] is mapped to item already in slot 1")
	assertEqual(order[2].space.slot, 2, "Order[2] is mapped to item already in slot 2")
	assertEqual(order[3].space.slot, 3, "Order[3] is mapped to item already in slot 3")
	assertEqual(order[4].space.slot, 4, "Order[4] is mapped to item already in slot 4")
end

-- =========================================================================
-- Test 8: CanRun Lifecycle & State Verification
-- =========================================================================
print("\n[Test 8] CanRun Lifecycle Conditions")
do
	local target = {
		id = "inventory",
		IsCached = function(self) return false end,
	}
	Sort.target = target

	combatState = false
	deadState = false
	assertTrue(Sort:CanRun(), "CanRun is true when target is open, player alive, not in combat")

	combatState = true
	assertFalse(Sort:CanRun(), "CanRun is false when InCombatLockdown is true")
	combatState = false

	deadState = true
	assertFalse(Sort:CanRun(), "CanRun is false when UnitIsDead is true")
	deadState = false

	target.IsCached = function(self) return true end
	assertFalse(Sort:CanRun(), "CanRun is false when target:IsCached is true")
	target.IsCached = function(self) return false end

	Sort.target = nil
	assertFalse(Sort:CanRun(), "CanRun is false when Sort.target is nil")
end

-- =========================================================================
-- Test 9: Locked Slots in GetSpaces & Move Safety
-- =========================================================================
print("\n[Test 9] Locked Slots & Move Execution")
do
	local pickupCalls = {}
	local target = {
		id = "inventory",
		profile = { partialFirst = false, reverseSort = false },
		Bags = { 0 },
		GetBagInfo = function(self, bag)
			return { locked = { [2] = true } } -- Slot 2 is locked (e.g. by user config)
		end,
		GetBagFamily = function(self, bag) return 0 end,
		NumSlots = function(self, bag) return 3 end,
		GetItemInfo = function(self, bag, slot)
			if slot == 1 then
				return { itemID = 33470, stackCount = 200, quality = 1 }
			elseif slot == 2 then
				return { itemID = 19019, stackCount = 1, quality = 5 } -- Locked slot
			elseif slot == 3 then
				return { itemID = 171266, stackCount = 20, quality = 1 }
			end
			return Addon.None
		end,
		PickupItem = function(bag, slot)
			tinsert(pickupCalls, { bag = bag, slot = slot })
		end,
	}

	Sort.target = target
	local spaces = Sort:GetSpaces()

	assertEqual(#spaces, 2, "GetSpaces excludes locked slot 2 (returns 2 spaces)")
	assertEqual(spaces[1].slot, 1, "Space 1 is slot 1")
	assertEqual(spaces[2].slot, 3, "Space 2 is slot 3 (skipping slot 2)")

	-- Test Sort:Move
	local from = { bag = 0, slot = 1, family = 0, item = { itemID = 33470 } }
	local to = { bag = 0, slot = 3, family = 0, item = { itemID = 171266 } }

	local moveResult = Sort:Move(from, to)
	assertTrue(moveResult, "Sort:Move successfully initiates swap between valid unlocked slots")
	assertEqual(#pickupCalls, 2, "PickupItem was called exactly twice (source and destination)")
	assertEqual(pickupCalls[1].slot, 1, "Picked up source slot 1")
	assertEqual(pickupCalls[2].slot, 3, "Picked up target slot 3")
	assertTrue(from.item.isLocked, "Source item marked isLocked after move")
	assertTrue(to.item.isLocked, "Destination item marked isLocked after move")

	-- Test Move with already locked item
	local lockedMove = Sort:Move(from, to)
	assertEqual(lockedMove, true, "Move returns locked status and aborts when item is already locked")
	assertEqual(#pickupCalls, 2, "No additional PickupItem calls made on locked item")
end

-- =========================================================================
-- Test 10: Sort:FitsIn Nil Family Safety (Uncached / Unknown Items)
-- =========================================================================
print("\n[Test 10] Sort:FitsIn Nil Family Safety")
do
	local origInfo = mockItem.GetItemInfo
	local origFamily = mockItem.GetItemFamily
	local uncachedID = 999999999

	mockItem.GetItemInfo = function(id)
		if id == uncachedID then return nil end
		return origInfo(id)
	end
	mockItem.GetItemFamily = function(id)
		if id == uncachedID then return nil end
		return origFamily(id)
	end

	local ok32, fit32 = pcall(Sort.FitsIn, Sort, uncachedID, 32)
	local ok1024, fit1024 = pcall(Sort.FitsIn, Sort, uncachedID, 1024)
	local ok9, fit9 = pcall(Sort.FitsIn, Sort, uncachedID, 9)
	local okReagent, fitReagent = pcall(Sort.FitsIn, Sort, uncachedID, 0x80000)
	local ok0, fit0 = pcall(Sort.FitsIn, Sort, uncachedID, 0)

	mockItem.GetItemInfo = origInfo
	mockItem.GetItemFamily = origFamily

	assertTrue(ok32, "FitsIn does not error on nil family for herb bag (32)")
	assertFalse(fit32, "Uncached item with nil family does not fit in herb bag (32)")
	assertTrue(ok1024, "FitsIn does not error on nil family for mining bag (1024)")
	assertFalse(fit1024, "Uncached item with nil family does not fit in mining bag (1024)")
	assertTrue(ok9, "FitsIn does not error on nil family for keyring (9)")
	assertFalse(fit9, "Uncached item with nil family does not fit in keyring (9)")
	assertTrue(okReagent, "FitsIn does not error on nil info for reagent bag (0x80000)")
	assertFalse(fitReagent, "Uncached item with nil info does not fit in reagent bag (0x80000)")
	assertTrue(ok0, "FitsIn does not error on nil family for normal bag (0)")
	assertTrue(fit0, "Uncached item fits in normal bag (0)")
end

-- =========================================================================
-- Test 11: Nullable Sort.Properties Defaults & Sort.ItemRule Nil Resilience
-- =========================================================================
print("\n[Test 11] Nullable Sort.Properties Defaults & Sort.ItemRule Resilience")
do
	local origInfo = mockItem.GetItemInfo
	local origFamily = mockItem.GetItemFamily
	local uncachedID = 999999999

	mockItem.GetItemInfo = function(id)
		if id == uncachedID then return nil end
		return origInfo(id)
	end
	mockItem.GetItemFamily = function(id)
		if id == uncachedID then return nil end
		return origFamily(id)
	end

	for _, partialFirst in ipairs({ false, true }) do
		local target = {
			id = "guild",
			profile = { partialFirst = partialFirst, reverseSort = false },
			Bags = { 1 },
			GetBagInfo = function(self, bag) return {} end,
			GetBagFamily = function(self, bag) return 0 end,
			NumSlots = function(self, bag) return 3 end,
			GetItemInfo = function(self, bag, slot)
				if slot == 1 then
					return { itemID = uncachedID }
				elseif slot == 2 then
					return { itemID = 33470, quality = nil, iconFileID = nil, stackCount = nil }
				elseif slot == 3 then
					return { itemID = 19019, quality = 5, iconFileID = 135349, stackCount = 1 }
				end
				return Addon.None
			end,
		}

		Sort.target = target
		local spaces = Sort:GetSpaces()
		local ok, order = pcall(Sort.GetOrder, Sort, spaces, 0)

		assertTrue(ok, "GetOrder succeeds with uncached/nil item fields (partialFirst=" .. tostring(partialFirst) .. ")")
		assertEqual(#order, 3, "All 3 items included in sorted order (partialFirst=" .. tostring(partialFirst) .. ")")

		local uncachedItem = spaces[1].item
		assertEqual(uncachedItem.equip, "", "Uncached item equip defaults to empty string")
		assertEqual(uncachedItem.level, 0, "Uncached item level defaults to 0")
		assertEqual(uncachedItem.quality, 0, "Uncached item quality defaults to 0")
		assertEqual(uncachedItem.iconFileID, 0, "Uncached item iconFileID defaults to 0")
		assertEqual(uncachedItem.stackOrder, partialFirst and -1 or 1, "Missing stackCount defaults stackOrder in both branches")
	end

	mockItem.GetItemInfo = origInfo
	mockItem.GetItemFamily = origFamily

	-- Direct Sort.ItemRule call with partial tables (issue #2229 reproduction)
	local a = { set = 2, class = 14, subclass = -1, equip = "" }
	local b = { set = 2, class = 14, subclass = -1 }
	local okAB, resAB = pcall(Sort.ItemRule, a, b)
	local okBA, resBA = pcall(Sort.ItemRule, b, a)
	assertTrue(okAB, "Direct Sort.ItemRule(a, b) does not error when equip is nil on b")
	assertTrue(resAB, "Direct Sort.ItemRule(a, b) ranks non-nil equip above nil equip")
	assertTrue(okBA, "Direct Sort.ItemRule(b, a) does not error when equip is nil on b")
	assertFalse(resBA, "Direct Sort.ItemRule(b, a) is asymmetric when equip is nil on b")
end

-- =========================================================================
-- Test 12: Transitive Sort:GetFamilies & Specialty-Before-Reagent Priority
-- =========================================================================
print("\n[Test 12] Transitive Sort:GetFamilies & Specialty Priority")
do
	local function assertFamilyOrder(input, expected, label)
		local mockSpaces = {}
		for _, f in ipairs(input) do
			tinsert(mockSpaces, { family = f })
		end
		local actual = Sort:GetFamilies(mockSpaces)
		assertEqual(#actual, #expected, label .. " count")
		for i = 1, #expected do
			assertEqual(actual[i], expected[i], string.format("%s [%d]", label, i))
		end
	end

	assertFamilyOrder({ 0, 1024, 0x80000 }, { 1024, 0x80000, 0 }, "GetFamilies {0, 1024, 0x80000}")
	assertFamilyOrder({ 0, 32, 1024, 0x80000 }, { 1024, 32, 0x80000, 0 }, "GetFamilies {0, 32, 1024, 0x80000}")
	assertFamilyOrder({ -1, 0, 1024, 0x80000 }, { 1024, 0x80000, 0, -1 }, "GetFamilies {-1, 0, 1024, 0x80000}")
	assertFamilyOrder({ -1, 0, 0x80000 }, { 0x80000, 0, -1 }, "GetFamilies {-1, 0, 0x80000}")

	-- End-to-end check: mining & herb bags claim ore/herbs before reagent bag (0x80000)
	local bagFamilies = {
		[0] = 0,       -- Backpack
		[1] = 32,      -- Herb bag
		[2] = 1024,    -- Mining bag
		[5] = 0x80000, -- Reagent bag
	}
	local target = {
		id = "inventory",
		profile = { partialFirst = false, reverseSort = false },
		Bags = { 0, 1, 2, 5 },
		GetBagInfo = function(self, bag) return {} end,
		GetBagFamily = function(self, bag) return bagFamilies[bag] end,
		NumSlots = function(self, bag) return 1 end,
		GetItemInfo = function(self, bag, slot)
			if bag == 0 then
				return { itemID = 171828, stackCount = 20, quality = 1 } -- Laestrite Ore (1024, reagent)
			elseif bag == 1 then
				return { itemID = 33470, stackCount = 20, quality = 1 } -- Frostweave Cloth (0, reagent)
			elseif bag == 2 then
				return { itemID = 152510, stackCount = 20, quality = 1 } -- Anchor Weed (32, reagent)
			end
			return Addon.None
		end,
	}

	Sort.target = target
	local spaces = Sort:GetSpaces()
	local families = Sort:GetFamilies(spaces)
	local assigned = {}

	for _, family in ipairs(families) do
		local order, slots = Sort:GetOrder(spaces, family)
		local n = min(#order, #slots)
		assigned[family] = {}
		for i = 1, n do
			order[i].sorted = true
			tinsert(assigned[family], order[i].itemID)
		end
	end

	assertEqual(#assigned[1024], 1, "Mining bag (1024) receives 1 item")
	assertEqual(assigned[1024][1], 171828, "Mining bag claims Laestrite Ore before reagent bag")
	assertEqual(#assigned[32], 1, "Herb bag (32) receives 1 item")
	assertEqual(assigned[32][1], 152510, "Herb bag claims Anchor Weed before reagent bag")
	assertEqual(#assigned[0x80000], 1, "Reagent bag (0x80000) receives remaining crafting reagent")
	assertEqual(assigned[0x80000][1], 33470, "Reagent bag receives Frostweave Cloth only")
end

-- =========================================================================
-- Final Results Summary
-- =========================================================================
print(string.format("\n=============================================="))
print(string.format("=== Final Test Results: %d Passed, %d Failed ===", passCount, failCount))
print(string.format("=============================================="))

if failCount > 0 then
	os.exit(1)
else
	os.exit(0)
end
