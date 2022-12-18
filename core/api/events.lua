--[[
	events.lua
		Custom events for better item performance and location awareness

	BAG_UPDATE_SIZE
	args: bag
		called when the size of a bag changes, bag itself probably also has changed

	BAG_UPDATE_CONTENT
	args: bag
		called when the items of a bag change
--]]

local ADDON, Addon = ...
local Events = Addon:NewModule('Events')
local C = LibStub('C_Everywhere').Container


--[[ Events ]]--

function Events:OnEnable()
	self.neverBanked = true
	self.sizes, self.types, self.queue = {}, {}, {}

	if C_PlayerInteractionManager then
			self:RegisterEvent('PLAYER_INTERACTION_MANAGER_FRAME_SHOW')
			self:RegisterEvent('PLAYER_INTERACTION_MANAGER_FRAME_HIDE')
	elseif CanGuildBankRepair then
		self:RegisterEvent('GUILDBANKFRAME_OPENED', 'UpdateLocation', {'Guild', true})
		self:RegisterEvent('GUILDBANKFRAME_CLOSED', 'UpdateLocation', {'Guild', false})

		if CanUseVoidStorage then
			self:RegisterEvent('VOID_STORAGE_OPEN', 'UpdateLocation', {'Vault', true})
			self:RegisterEvent('VOID_STORAGE_CLOSE', 'UpdateLocation', {'Vault', false})
		end

		if REAGENTBANK_CONTAINER then
			self:RegisterEvent('PLAYERREAGENTBANKSLOTS_CHANGED')
			self:RegisterEvent('REAGENTBANK_PURCHASED')
		end
	end

	self:RegisterEvent('BAG_UPDATE')
	self:RegisterEvent('BAG_UPDATE_DELAYED', 'UpdateBags')
	self:RegisterEvent('BANKFRAME_CLOSED', 'UpdateLocation', {'Bank', false})
	self:RegisterEvent('BANKFRAME_OPENED')
	self:RegisterEvent('PLAYERBANKSLOTS_CHANGED')
	self:UpdateSize(BACKPACK_CONTAINER)
	self:UpdateBags()
end

function Events:BAG_UPDATE(event, bag)
	self.queue[bag] = true
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
	self:UpdateBankBags()
	self:UpdateContent(BANK_CONTAINER)
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
	self['At' .. where[1]] = where[2]
	self:SendSignal(where[1]:upper() .. (where[2] and '_OPEN' or '_CLOSE'))
end