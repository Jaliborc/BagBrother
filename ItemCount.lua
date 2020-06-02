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
local BagBrother = addon.BagBrother

local FIRST_BAG_SLOT = BACKPACK_CONTAINER
local LAST_BAG_SLOT = FIRST_BAG_SLOT + NUM_BAG_SLOTS
local LAST_BANK_SLOT = NUM_BAG_SLOTS + NUM_BANKBAGSLOTS
local FIRST_BANK_SLOT = NUM_BAG_SLOTS + 1
local BAG_TYPE_BANK = 'bank'
local BAG_TYPE_BAG = 'bags'

local itemCountCache = {}

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

local function initItemCountCache(realm, owner)
  local BrotherBags = _G.BrotherBags or {}
  local realmCache = itemCountCache[realm] or {}
  local realmData = BrotherBags[realm]

  if (realmData == nil) then
    itemCountCache[realm] = false
    return false
  end

  local ownerData = realmData[owner]

  itemCountCache[realm] = realmCache

  if (ownerData == nil) then
    realmCache[owner] = false
    return false
  end

  local ownerCache = {}

  realmCache[owner] = ownerCache;

  for bag, bagData in pairs (ownerData) do
    if (type(bagData) == 'table') then
      local bagCounts

      bag = getBagType(bag)
      ownerCache[bag] = ownerCache[bag] or {}
      bagCounts = ownerCache[bag]

      for slot, item in pairs(bagData) do
        if (type(slot) == 'number' and type(item) == 'string') then
          local link, count = strsplit(';', item)
          local id = strsplit(':', link)

          id = tonumber(id)
          count = count or 1
          count = tonumber(count)

          bagCounts[id] = (bagCounts[id] or 0) + count
        end
      end
    end
  end
end

function addon:GetItemCount (realm, owner, bag, itemId)
  local data = itemCountCache[realm]

  if (data == false) then
    return 0
  end

  if ((data == nil or data[owner] == nil) and not
      initItemCountCache(realm, owner)) then
    return 0
  end

  bag = getBagType(bag)
  data = itemCountCache[realm][owner][bag]

  if (data == nil) then
    return 0
  end

  return data[itemId] or 0
end
