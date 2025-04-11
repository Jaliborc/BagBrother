--[[
	Custom events for better item performance and location awareness.
	All Rights Reserved

	BAG_UPDATED
	args: bag, changed
		called whenever a bag's content is modified, second argument tells whether the bag itself has changed

	BAGS_UPDATED
	args: bags
		called after all other BAG_UPDATED events in the current render frame have been fired
		includes the arguments of those events as [bag, changed] pairs table

	BANK_OPEN, BANK_CLOSE, VAULT_OPEN, VAULT_CLOSE, GUILD_OPEN, GUILD_CLOSE
		called when the player opens or closes the given storage location by interacting with the world
--]]

local ADDON, Addon = ...
local Events = Addon:NewModule('Events', 'MutexDelay-1.0')
local C = LibStub('C_Everywhere').Container


--[[ Events ]]--

function Events:OnEnable()
	self.neverBanked = true
	self.sizes, self.types, self.queue = {}, {}, {}

	if C_PlayerInteractionManager then
		self:RegisterEvent('PLAYER_INTERACTION_MANAGER_FRAME_SHOW')
		self:RegisterEvent('PLAYER_INTERACTION_MANAGER_FRAME_HIDE')
	end

	if REAGENTBANK_CONTAINER then
		self:RegisterEvent('PLAYERREAGENTBANKSLOTS_CHANGED')
		self:RegisterEvent('REAGENTBANK_PURCHASED')
	end

	self:RegisterEvent('BAG_UPDATE')
	self:RegisterEvent('BANKFRAME_OPENED')
	self:RegisterEvent('BANKFRAME_CLOSED', 'UpdateLocation', {'Bank', false})
	self:RegisterEvent('PLAYERBANKSLOTS_CHANGED')

	for _, bag in ipairs(Addon.InventoryBags) do
		self.queue[bag] = false
	end

	self:Delay(0.08, 'UpdateBags')
end

function Events:BAG_UPDATE(event, bag)
	self:QueueBag(bag)
end

function Events:BANKFRAME_OPENED()
	self:UpdateLocation {'Bank', true}

	if self.neverBanked then
		self.neverBanked = nil
		self:QueueBank()

		if REAGENTBANK_CONTAINER then
			self.queue[REAGENTBANK_CONTAINER] = false
		end
	end
end

function Events:PLAYERBANKSLOTS_CHANGED()
	self:QueueBank()
end

function Events:PLAYERREAGENTBANKSLOTS_CHANGED()
	self:QueueBag(REAGENTBANK_CONTAINER)
end

function Events:REAGENTBANK_PURCHASED()
	self:QueueBag(REAGENTBANK_CONTAINER)
end

function Events:PLAYER_INTERACTION_MANAGER_FRAME_SHOW(event, frame)
	if frame == Enum.PlayerInteractionType.VoidStorageBanker then
		self:UpdateLocation {'Vault', true}
	elseif frame == Enum.PlayerInteractionType.GuildBanker then
		self:UpdateLocation {'Guild', true}
	end
end

function Events:PLAYER_INTERACTION_MANAGER_FRAME_HIDE(event, frame)
	if frame == Enum.PlayerInteractionType.VoidStorageBanker then
		self:UpdateLocation {'Vault', false}
	elseif frame == Enum.PlayerInteractionType.GuildBanker then
		self:UpdateLocation {'Guild', false}
	end
end


--[[ API ]]--

function Events:UpdateLocation(where)
	local location, state = unpack(where)
	local key = 'At' .. location
	if self[key] ~= state then -- server can fire multiple times
		self[key] = state
		self:SendSignal(location:upper() .. (state and '_OPEN' or '_CLOSE'))
	end
end

function Events:UpdateBags()
	for bag in pairs(self.queue) do
		local size = C.GetContainerNumSlots(bag) or 0
		local _, family = C.GetContainerNumFreeSlots(bag)

		local changed = size ~= self.sizes[bag] or family ~= self.types[bag]
		if changed then
			self.queue[bag] = true
			self.types[bag] = family
			self.sizes[bag] = size
		end

		self:SendSignal('BAG_UPDATED', bag, changed)
	end

	self:SendSignal('BAGS_UPDATED', self.queue)
	self.queue = {}
end

function Events:QueueBank()
	for i = Addon.NumBags + 1, Addon.LastBankBag do
		self.queue[i] = false
	end

	self:QueueBag(BANK_CONTAINER)
end

function Events:QueueBag(bag)
	self.queue[bag] = false
	self:Delay(0.08, 'UpdateBags')
end