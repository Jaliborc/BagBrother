--[[
Copyright 2011-2020 João Cardoso
BagBrother is distributed under the terms of the GNU General Public License (Version 3).
As a special exception, the copyright holders of this addon do not give permission to
redistribute and/or modify it.

This addon is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with the addon. If not, see <http://www.gnu.org/licenses/gpl-3.0.txt>.

This file is part of BagBrother.
--]]

local _, addon = ...

local FIRST_BAG_SLOT = BACKPACK_CONTAINER
local LAST_BAG_SLOT = FIRST_BAG_SLOT + NUM_BAG_SLOTS
local LAST_BANK_SLOT = NUM_BAG_SLOTS + NUM_BANKBAGSLOTS
local FIRST_BANK_SLOT = NUM_BAG_SLOTS + 1
local BAG_TYPE_BANK = 'bank'
local BAG_TYPE_BAG = 'bags'
local BAG_TYPE_EQUIP = 'equip' -- not used

local itemCountCache = {}
local playerRealmCache
local playerCache

local function getBagType (bag)
  if (type(bag) ~= 'number') then
    return bag
  end

  if (bag >= FIRST_BAG_SLOT and bag <= LAST_BAG_SLOT) then
    return BAG_TYPE_BAG
  end

  if (bag == BANK_CONTAINER) then
    return BAG_TYPE_BANK
  end

  if (bag >= FIRST_BANK_SLOT and bag <= LAST_BANK_SLOT) then
    return BAG_TYPE_BANK
  end

  if (REAGENTBANK_CONTAINER ~= nil and bag == REAGENTBANK_CONTAINER) then
    return BAG_TYPE_BANK
  end

  -- this part should never be reached
  return BAG_TYPE_BAG
end

local function initSlotItemCountCache (bagCounts, slot, item)
  if (type(slot) ~= 'number' or type(item) ~= 'string') then
    return
  end

  local link, count = strsplit(';', item)
  local id = strsplit(':', link)

  id = tonumber(id)
  count = tonumber(count or 1)

  bagCounts[id] = (bagCounts[id] or 0) + count
end

local function initBagItemCountCache (ownerCache, bag, bagData)
  if (type(bagData) ~= 'table') then
    return
  end

  local bagCounts

  bag = getBagType(bag)
  bagCounts = ownerCache[bag] or {}

  for slot, item in pairs(bagData) do
    initSlotItemCountCache(bagCounts, slot, item)
  end

  ownerCache[bag] = bagCounts
end

local function initItemCountCache(realm, owner)
  local BrotherBags = _G.BrotherBags or {}
  local realmData = BrotherBags[realm]
  local ownerData = realmData and realmData[owner]

  if (ownerData == nil) then
    return false
  end

  local realmCache = itemCountCache[realm] or {}
  local ownerCache = realmCache[owner] or {}

  if (realmData == addon.BagBrother.Realm) then
    playerRealmCache = realmCache
  end

  if (ownerData == addon.BagBrother.Player) then
    playerCache = ownerCache
  end

  for bag, bagData in pairs(ownerData) do
    initBagItemCountCache(ownerCache, bag, bagData);
  end

  itemCountCache[realm] = realmCache
  realmCache[owner] = ownerCache

  return true
end

function addon:UnCachePlayerBag (bag)
  if (not playerCache) then return end

  playerCache[getBagType(bag)] = false
end

function addon:UnCacheRealmOwner (owner)
  if (not playerRealmCache) then return end

  playerRealmCache[owner] = false
end

function addon:GetItemCount (realm, owner, bag, itemId)
  local data = itemCountCache[realm]

  data = data and data[owner]
  bag = getBagType(bag)

  if ((not data or data[bag] == false) and not initItemCountCache(realm, owner)) then
    return 0
  end

  data = itemCountCache[realm][owner][bag]

  return (data and data[itemId]) or 0
end
