--[[
	settings.lua
		Initializes the settings, checks for version updates and provides the necessary API for profile management
		All Rights Reserved
--]]

local ADDON, Addon = ...
local VAR = ADDON .. '_Sets'
local Settings = Addon:NewModule('Settings')

local function AsArray(table)
	return setmetatable(table, {__metatable = 1})
end

local function SetDefaults(target, defaults)
	defaults.__index = nil

	for k, v in pairs(defaults) do
		if type(v) == 'table' then
			if getmetatable(v) == 1 then
				target[k] = target[k] or AsArray(CopyTable(v))
			else
				target[k] = SetDefaults(target[k] or {}, v)
			end
		end
	end

	defaults.__index = defaults
	return setmetatable(target, defaults)
end

local FrameDefaults = {
	enabled = true,
	money = true, broker = true,
	bagToggle = true, sort = true, search = true, options = true,

	strata = 'HIGH', alpha = 1,
	scale = Addon.FrameScale or 1,
	color = {0, 0, 0, 0.5},
	x = 0, y = 0,

	itemScale = Addon.ItemScale or 1,
	spacing = 2,

	brokerObject = Addon.Name .. 'Launcher',
	hiddenRules = {contain = true},
	hiddenBags = {},

	rules = AsArray({
		'all', 'all/normal', 'all/trade', 'all/reagent', 'all/keys', 'all/quiver',
		'equip', 'equip/armor', 'equip/weapon', 'equip/trinket',
		'use', 'use/consume', 'use/enhance',
		'trade', 'trade/goods', 'trade/gem', 'trade/glyph', 'trade/recipe',
		'quest', 'misc',
	}),
}

local ProfileDefaults = {
	inventory = SetDefaults({
		reversedTabs = true,
		borderColor = {1, 1, 1, 1},
		currency = true, broker = Addon.IsClassic,
		point = 'BOTTOMRIGHT',
		x = -50, y = 100,
		columns = 10,
		width = 384,
		height = 200,
	}, FrameDefaults),

	bank = SetDefaults({
		borderColor = {1, 1, 0, 1},
		currency = true,
		point = 'LEFT',
		columns = 14,
		width = 600,
		height = 500,
		x = 95
	}, FrameDefaults),

	vault = SetDefaults({
		borderColor = {1, 0, 0.98, 1},
		point = 'LEFT',
		columns = 16,
		x = 95
	}, FrameDefaults),

	guild = SetDefaults({
		borderColor = {0, 1, 0, 1},
		point = 'CENTER',
		columns = 7,
	}, FrameDefaults)
}


--[[ Methods ]]--

function Settings:OnEnable()
	BrotherBags = BrotherBags or {}
	_G[VAR] = SetDefaults(_G[VAR] or {}, {
		global = SetDefaults({}, ProfileDefaults),
        version = Addon.Version,
		profiles = {},

		resetPlayer = true, flashFind = true, serverSort = true,
		countItems = true, countGuild = true, countCurrency = true, 
		display = {
			banker = true, guildBanker = true, voidStorageBanker = true, crafting = true, tradePartner = true, socketing = true,
			auctioneer = true, merchant = true, mailInfo = true, scrappingMachine = true},

		glowAlpha = 0.5,
		glowQuality = true, glowNew = true, glowQuest = true, glowSets = true, glowUnusable = true, glowPoor = true,

		slotBackground = 2, colorSlots = true,
		normalColor = {1, 1, 1},
		keyColor = {1, .9, .19},
		quiverColor = {1, .87, .68},
		soulColor = {0.64, 0.39, 1},
		reagentColor = {1, .87, .68},
		leatherColor = {1, .6, .45},
		enchantColor = {0.64, 0.83, 1},
		inscribeColor = {.64, 1, .82},
		engineerColor = {0.36, 0.68, 0.52},
		tackleColor = {0.42, 0.59, 1},
		fridgeColor = {1, .5, .5},
		gemColor = {1, .65, .98},
		mineColor = {0.65, 0.53, 0.25},
		herbColor = {.5, 1, .5},
	})

	Addon.sets = _G[VAR]
    Addon.sets.version = Addon.Version

	----- convert old profiles
	for address, profile in pairs(Addon.sets.profiles) do
		local realm, name = address:match('(%w+) %- (%w+)')
		if realm and name then
			realm = GetOrCreateTableEntry(Addon.sets.profiles, realm)
			realm[name .. (address:find('^®') and '*' or '')] = profile
		end
	end
	-----

	for realm, owners in pairs(Addon.sets.profiles) do
		for id, profile in pairs(owners) do
			SetDefaults(profile, ProfileDefaults)
		end
	end
end

function Settings:SetProfile(realm, id, profile)
	realm = GetOrCreateTableEntry(Addon.sets.profiles, realm)
	realm[id] = profile and SetDefaults(profile, ProfileDefaults)
end

function Settings:GetProfile(realm, id)
	realm = Addon.sets.profiles[realm]
	return realm and realm[id] or Addon.sets.global
end