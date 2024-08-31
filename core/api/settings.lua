--[[
	Initializes the settings, checks for version updates and provides the necessary API for profile management.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local VAR = ADDON .. '_Sets'
local Settings = Addon:NewModule('Settings')

local function AsArray(table)
	return setmetatable(table, {__metatable = false})
end

local FrameDefaults = {
	enabled = true,
	bagToggle = true, sort = true, search = true, options = true, 
	money = true, broker = true,

	strata = 'HIGH', alpha = 1, scale = Addon.FrameScale or 1,
	color = {0, 0, 0, 0.5},
	x = 0, y = 0,

	hiddenBags = {}, lockedSlots = {},
	itemScale = 1, spacing = 2, bagBreak = 1, breakSpace = 1.3,

	brokerObject = ADDON .. 'Launcher',
	rules = AsArray({}),
}

local ProfileDefaults = {
	inventory = Addon:SetDefaults({
		borderColor = {1, 1, 1, 1},
		deposit = true, currency = true,
		point = 'BOTTOMRIGHT',
		x = -50, y = 100,
		columns = 10,
		width = 384,
		height = 200,
	}, FrameDefaults),

	bank = Addon:SetDefaults({
		borderColor = {1, 1, 0, 1},
		currency = true, serverSort = true,
		point = 'LEFT',
		columns = 14,
		width = 600,
		height = 500,
		x = 95
	}, FrameDefaults),

	vault = Addon:SetDefaults({
		borderColor = {1, 0, 0.98, 1},
		point = 'LEFT',
		columns = 16,
		x = 95
	}, FrameDefaults),

	guild = Addon:SetDefaults({
		borderColor = {0, 1, 0, 1},
		point = 'CENTER',
		columns = 7,
	}, FrameDefaults)
}


--[[ Methods ]]--

function Settings:OnEnable()
	BrotherBags = BrotherBags or {}
	Addon.sets = self:SetDefaults(_G[VAR] or {}, {
		global = self:SetDefaults({}, ProfileDefaults),
		profiles = {},

		resetPlayer = true, flashFind = true,
		countItems = true, countGuild = true, countCurrency = true, 
		depositAccount = true, depositReagents = true,
		display = {
			banker = true, guildBanker = true, voidStorageBanker = true, crafting = true, tradePartner = true, socketing = true,
			auctioneer = true, merchant = true, mailInfo = true, scrappingMachine = true},

		glowAlpha = 0.5,
		glowQuality = true, glowNew = true, glowQuest = true, glowSets = true, glowUnusable = true, glowPoor = true,

		slotBackground = 2, colorSlots = true,
		color = {
			normal = {1, 1, 1},
			account = {0.86, 1, .98},
			key = {1, .9, .19},
			quiver = {1, .87, .68},
			soul = {0.64, 0.39, 1},
			reagent = {1, .87, .68},
			leather = {1, .6, .45},
			enchant = {0.64, 0.83, 1},
			inscribe = {.64, 1, .82},
			engineer = {0.36, 0.68, 0.52},
			tackle = {0.42, 0.59, 1},
			fridge = {1, .5, .5},
			gem = {1, .65, .98},
			mine = {0.65, 0.53, 0.25},
			herb = {.5, 1, .5},
		}
	})

	for realm, owners in pairs(Addon.sets.profiles) do
		for id, profile in pairs(owners) do
			self:SetDefaults(profile, ProfileDefaults)
		end
	end

	_G[VAR] = Addon.sets
end

function Settings:SetProfile(realm, id, profile)
	realm = GetOrCreateTableEntry(Addon.sets.profiles, realm)
	realm[id] = profile and self:SetDefaults(profile, ProfileDefaults)
end

function Settings:GetProfile(realm, id)
	realm = Addon.sets.profiles[realm]
	return realm and realm[id] or Addon.sets.global
end