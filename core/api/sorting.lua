--[[
	sorting.lua
		Client side bag sorting algorithm.

  Start(job)
  args: an object that declares id, bags and methods for item pickup and info retrieval
    Stops any ongoing job and starts this one. The class Addon.Frame implements the requirements of this job interface.

  Stop()
    Stops any ongoing job

  SORTING_STATUS
  args: id
    event called whenever a new job starts or the ongoing job stops, at which point the argument is nil
--]]

local ADDON, Addon = ...
local Search = LibStub('ItemSearch-1.3')
local Cache = LibStub('LibItemCache-2.0')
local Sort = Addon:NewModule('Sorting', 'MutexDelay-1.0')

Sort.Properties = {
  'set',
  'class', 'subclass', 'equip',
  'quality',
  'icon',
  'level', 'name', 'id',
  'count'
}


--[[ Process ]]--

function Sort:Start(job)
  if not self:CanRun(job) then
    return
  end

  self.job = job
  self:SendSignal('SORTING_STATUS', job.id)
  self:Run()
end

function Sort:Run()
  ClearCursor()
  
  if self:CanRun(self.job) then
    self:Iterate()
  else
    self:Stop()
  end
end

function Sort:Iterate()
  local spaces = self:GetSpaces()
  local families = self:GetFamilies(spaces)

  local stackable = function(item)
    return (item.count or 1) < (item.stack or 1)
  end

  for k, target in pairs(spaces) do
    local item = target.item
    if item.id and stackable(item) then
      for j = k+1, #spaces do
        local from = spaces[j]
        local other = from.item

        if item.id == other.id and stackable(other) then
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
          if other.id == item.id and other.count == item.count then
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
  self.job = nil
  self:SendSignal('SORTING_STATUS')
end


--[[ Data Structures ]]--

function Sort:GetSpaces()
  local spaces = {}

  for i, bag in ipairs(self.job.Bags) do
    if self.job:IsShowingBag(bag) then
      local container = Cache:GetBagInfo(self.job:GetOwner().address, bag)
      for slot = 1, (container.count or 0) do
        local item = self.job:GetItemInfo(bag, slot)
        tinsert(spaces, {index = #spaces, bag = bag, slot = slot, family = container.family, item = item})

        item.class = item.id and Search:IsQuestItem(item.id) and Enum.ItemClass.Questitem or item.class
        item.set = item.id and Search:BelongsToSet(item.id) and 0 or 1
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

  sort(list, function(a, b) return a > b end)
  return list
end

function Sort:GetOrder(spaces, family)
  local order, slots = {}, {}

  for _, space in ipairs(spaces) do
    local item = space.item
    if item.id and not item.sorted and self:FitsIn(item.id, family) then
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

function Sort:CanRun(job)
  return job and not job:IsCached() and not InCombatLockdown() and not UnitIsDead('player')
end

function Sort:FitsIn(id, family)
  if family == 9 then
    return GetItemFamily(id) == 256
  end

  return family == 0 or (bit.band(GetItemFamily(id), family) > 0 and select(9, GetItemInfo(id)) ~= 'INVTYPE_BAG')
end

function Sort.Rule(a, b)
  for _,prop in pairs(Sort.Properties) do
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
  if from.locked or to.locked or (to.item.id and not self:FitsIn(to.item.id, from.family)) then
    return
  end

  self.job:PickupItem(from.bag, from.slot)
  self.job:PickupItem(to.bag, to.slot)

  from.locked = true
  to.locked = true
  return true
end
