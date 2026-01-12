--[[
	Custom events for better item performance and location awareness.
	All Rights Reserved

	BAG_UPDATED
		deprecated and no longer fired, to avoid triggering the critical issues within CallbackHandler

	BAGS_UPDATED
	args: bags
		called whenever bag contents have been modified
		argument is a key table, where if a given bag id has changed bags[id] will be true, nil otherwise

	BANK_OPEN, BANK_CLOSE, VAULT_OPEN, VAULT_CLOSE, GUILD_OPEN, GUILD_CLOSE
		called when the player opens or closes the given storage location by interacting with the world
--]]

local ADDON, Addon = ...
local Events = Addon:NewModule('Events', 'MutexDelay-1.0')
local C = LibStub('C_Everywhere').Container


--[[ Events ]]--

function Events:OnLoad()
	self.neverBanked = true
	self.queue = {}

	if C_PlayerInteractionManager then
		self:RegisterEvent('PLAYER_INTERACTION_MANAGER_FRAME_SHOW')
		self:RegisterEvent('PLAYER_INTERACTION_MANAGER_FRAME_HIDE')
	end

	if REAGENTBANK_CONTAINER then
		self:RegisterEvent('PLAYERREAGENTBANKSLOTS_CHANGED', 'QueueBag', REAGENTBANK_CONTAINER)
		self:RegisterEvent('REAGENTBANK_PURCHASED', 'QueueBag', REAGENTBANK_CONTAINER)
	end

	self:RegisterEvent('BANKFRAME_OPENED')
	self:RegisterEvent('BANKFRAME_CLOSED', 'UpdateLocation', 'Bank', false)
	self:RegisterEvent('PLAYERBANKSLOTS_CHANGED', 'QueueBank')
	self:RegisterEvent('BAG_UPDATE', 'QueueBag')
	self:RegisterEvent('BAG_CLOSED', 'QueueBag')

	for _, bag in ipairs(Addon.InventoryBags) do
		self.queue[bag] = true
	end
end

function Events:BANKFRAME_OPENED()
	self:UpdateLocation('Bank', true)

	if self.neverBanked then
		self.neverBanked = nil
		self:QueueBank()

		if REAGENTBANK_CONTAINER then
			self.queue[REAGENTBANK_CONTAINER] = true
		end
	end
end

function Events:PLAYER_INTERACTION_MANAGER_FRAME_SHOW(frame)
	if frame == Enum.PlayerInteractionType.VoidStorageBanker then
		self:UpdateLocation('Vault', true)
	elseif frame == Enum.PlayerInteractionType.GuildBanker then
		self:UpdateLocation('Guild', true)
	end
end

function Events:PLAYER_INTERACTION_MANAGER_FRAME_HIDE(frame)
	if frame == Enum.PlayerInteractionType.VoidStorageBanker then
		self:UpdateLocation('Vault', false)
	elseif frame == Enum.PlayerInteractionType.GuildBanker then
		self:UpdateLocation('Guild', false)
	end
end


--[[ API ]]--

function Events:UpdateLocation(location, state)
	local key = 'At' .. location
	if self[key] ~= state then -- server can fire multiple times
		self[key] = state
		self:SendSignal(location:upper() .. (state and '_OPEN' or '_CLOSE'))
	end
end

function Events:UpdateBags()
	self:SendSignal('BAGS_UPDATED', self.queue)
	self.queue = {}
end

function Events:QueueBank()
	for i = Addon.NumBags + 1, Addon.LastBankBag do
		self.queue[i] = true
	end

	if BANK_CONTAINER then
		self:QueueBag(BANK_CONTAINER)
	end
end

function Events:QueueBag(bag)
	self.queue[bag] = true
	self:Delay(0.08, 'UpdateBags')
end