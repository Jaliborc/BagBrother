--[[
	Custom events for better item performance and location awareness.
	All Rights Reserved

	BAG_UPDATE_SIZE
	args: bag
		called when the size of a bag changes, bag itself probably also has changed

	BAG_UPDATE_CONTENT
	args: bag
		called when the items of a bag change

	BAGS_UPDATED
		called after all other bag events in the current render frame have been fired

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
	self:UpdateSize(BACKPACK_CONTAINER)
	self:UpdateBags()
end

function Events:BAG_UPDATE(event, bag)
	self.queue[bag] = true
	self:Delay(0.008, 'UpdateBags')
end

function Events:BANKFRAME_OPENED()
	self:UpdateLocation {'Bank', true}

	if self.neverBanked then
		self.neverBanked = nil
		self:UpdateSize(BANK_CONTAINER)
		self:UpdateBankBags()

		if REAGENTBANK_CONTAINER then
			self:UpdateSize(REAGENTBANK_CONTAINER)
		end
	end
end

function Events:PLAYERBANKSLOTS_CHANGED()
	self:UpdateContent(BANK_CONTAINER)
	self:UpdateBankBags()
end

function Events:PLAYERREAGENTBANKSLOTS_CHANGED()
	self:UpdateContent(REAGENTBANK_CONTAINER)
end

function Events:REAGENTBANK_PURCHASED()
	self:UpdateContent(REAGENTBANK_CONTAINER)
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

function Events:UpdateBags()
	for bag = 1, Addon.NumBags do
		if not self:UpdateSize(bag) then
			self:UpdateType(bag)
		end
	end

	for bag in pairs(self.queue) do
		self:UpdateContent(bag)
	end

	self:SendSignal('BAGS_UPDATED')
end

function Events:UpdateBankBags()
	for bag = 1, Addon.NumBags + NUM_BANKBAGSLOTS do
		if not self:UpdateSize(bag) then
			self:UpdateType(bag)
		end
	end
end

function Events:UpdateSize(bag)
	local old = self.sizes[bag]
	local new = C.GetContainerNumSlots(bag) or 0

	if old ~= new then
		local _, kind = C.GetContainerNumFreeSlots(bag)
		self.types[bag] = kind
		self.sizes[bag] = new
		self.queue[bag] = nil
		self:SendSignal('BAG_UPDATE_SIZE', bag)
		self:SendSignal('BAG_UPDATE', bag)
		return true
	end
end

function Events:UpdateType(bag)
	local old = self.types[bag]
	local _, new = C.GetContainerNumFreeSlots(bag)

	if old ~= new then
		self.types[bag] = new
		self:UpdateContent(bag)
	end
end

function Events:UpdateContent(bag)
	self.queue[bag] = nil
	self:SendSignal('BAG_UPDATE_CONTENT', bag)
	self:SendSignal('BAG_UPDATE', bag)
end

function Events:UpdateLocation(where)
	local location, state = unpack(where)
	local key = 'At' .. location
	if self[key] ~= state then -- Blizzard can fire multiple times
		self[key] = state
		self:SendSignal(location:upper() .. (state and '_OPEN' or '_CLOSE'))
	end
end
