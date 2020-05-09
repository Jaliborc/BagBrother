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

local itemCountCache = {}

function addon:InitItemCounts ()
  local BrotherBags = _G.BrotherBags or {}

  itemCountCache = {}

  for realm, realmData in pairs(BrotherBags) do
    local realmCounts = {}

    itemCountCache[realm] = realmCounts

    for owner, ownerData in pairs(realmData) do
      local ownerCounts = {}

      realmCounts[owner] = ownerCounts

      for bag, bagData in pairs (ownerData) do
        local bagCounts = {}

        ownerCounts[bag] = bagCounts

        if (type(bagData) == 'table') then
          for slot, item in pairs(bagData) do
            if (type(slot) == 'number' and type(item) == 'string') then
              local link, count = strsplit(';', item)
              local id = strsplit(':', link)

              id = tonumber(id)
              count = count or 1

              if (bagCounts[id] == nil) then
                bagCounts[id] = count
              else
                bagCounts[id] = bagCounts[id] + count
              end
            end
          end
        end
      end
    end
  end
end

function addon:GetItemCount (realm, owner, bag, itemId)
  local data = itemCountCache[realm]
  if (data == nil) then return 0 end
  data = data[owner]
  if (data == nil) then return 0 end
  data = data[bag]
  if (data == nil) then return 0 end
  data = data[itemId]
  if (data == nil) then return 0 end
  return data
end
