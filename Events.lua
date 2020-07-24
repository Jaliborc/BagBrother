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

local NUM_VAULT_SLOTS = 80 * 2
local FIRST_BANK_SLOT = 1 + NUM_BAG_SLOTS
local LAST_BANK_SLOT = NUM_BANKBAGSLOTS + NUM_BAG_SLOTS

local function isBankBag (bag)
  return (bag == BANK_CONTAINER or
          (bag >= FIRST_BANK_SLOT and bag <= LAST_BANK_SLOT));
end

--[[ Continuous Events ]]--

BagBrother.queue = {}

function BagBrother:BAG_UPDATE(bag)
  self.queue[bag] = true
end

function BagBrother:PLAYERBANKSLOTS_CHANGED()
  self:SaveBag(BANK_CONTAINER, true)
end

function BagBrother:BAG_UPDATE_DELAYED()
  for bag in pairs(self.queue) do
    -- BAG_UPDATE gets called when teleporting on all bags including bank bags,
    -- so they have to be checked
    if (self.atBank or not isBankBag(bag)) then
      self:SaveBag(bag, bag <= BACKPACK_CONTAINER)
    end
  end

  self.queue = {}
end

function BagBrother:PLAYER_EQUIPMENT_CHANGED(slot)
  self:SaveEquip(slot)
end

function BagBrother:BAG_CLOSED(bag)
  self:SaveBag(bag)
end

function BagBrother:PLAYER_MONEY()
  self.Player.money = GetMoney()
end


--[[ Bank Events ]]--

function BagBrother:BANKFRAME_OPENED()
  self.atBank = true

  for i = FIRST_BANK_SLOT, LAST_BANK_SLOT do
    self:SaveBag(i)
  end

  if REAGENTBANK_CONTAINER and IsReagentBankUnlocked() then
    self:SaveBag(REAGENTBANK_CONTAINER, true)
  end

  self:SaveBag(BANK_CONTAINER, true)
end

function BagBrother:BANKFRAME_CLOSED()
  self.atBank = nil
end

--[[ Void Storage Events ]]--

function BagBrother:VOID_STORAGE_OPEN()
  self.atVault = true
end

function BagBrother:VOID_STORAGE_CLOSE()
  if self.atVault then
    self.Player.vault = {}
    self.atVault = nil

    for i = 1, NUM_VAULT_SLOTS do
      local id = GetVoidItemInfo(1, i)

      self.Player.vault[i] = id and tostring(id) or nil
    end

    addon:UnCachePlayerBag('vault')
  end
end


--[[ Guild Events ]]--

function BagBrother:GUILDBANKFRAME_OPENED()
  self.atGuild = true
end

function BagBrother:GUILDBANKFRAME_CLOSED()
  self.atGuild = nil
end

function BagBrother:GUILD_ROSTER_UPDATE()
  self.Player.guild = GetGuildInfo('player')
end

function BagBrother:GUILDBANKBAGSLOTS_CHANGED()
  if self.atGuild then
    local id = GetGuildInfo('player') .. '*'
    local guild = self.Realm[id] or {}
    guild.faction = UnitFactionGroup('player') == 'Alliance'

    for i = 1, GetNumGuildBankTabs() do
      guild[i] = guild[i] or {}
      guild[i].name, guild[i].icon, guild[i].view = GetGuildBankTabInfo(i)
    end

    local tab = GetCurrentGuildBankTab()
    local items = guild[tab]
    if items then
      items.deposit, items.withdraw, items.remaining = select(4, GetGuildBankTabInfo(tab))

      for i = 1, 98 do
        local link = GetGuildBankItemLink(tab, i)
        local _, count = GetGuildBankItemInfo(tab, i)

        items[i] = self:ParseItem(link, count)
      end
    end

    self.Realm[id] = guild

    addon:UnCacheRealmOwner(id)
  end
end
