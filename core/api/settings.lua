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
	money = true, broker = true,
	bagToggle = true, sort = true, search = true, options = true,

	strata = 'HIGH', alpha = 1, scale = Addon.FrameScale or 1,
	color = {0, 0, 0, 0.5},
	x = 0, y = 0,

	hiddenBags = {}, lockedSlots = {},
	itemScale = Addon.ItemScale or 1,
	spacing = 2, bagBreak = 0,

	brokerObject = ADDON .. 'Launcher',
	rules = AsArray({
		'all', 'all/normal', 'all/trade', 'all/reagent', 'all/keys', 'all/quiver',
		'equip', 'equip/armor', 'equip/weapon', 'equip/trinket',
		'use', 'use/consume', 'use/enhance',
		'trade', 'trade/goods', 'trade/gem', 'trade/glyph', 'trade/recipe',
		'quest', 'misc',
	}),
}

local ProfileDefaults = {
	inventory = Addon:SetDefaults({
		reversedTabs = true,
		borderColor = {1, 1, 1, 1},
		currency = true, broker = true, reagents = REAGENTBANK_CONTAINER,
		point = 'BOTTOMRIGHT',
		x = -50, y = 100,
		columns = 10,
		width = 384,
		height = 200,
	}, FrameDefaults),

	bank = Addon:SetDefaults({
		borderColor = {1, 1, 0, 1},
		currency = true, reagents = NUM_TOTAL_EQUIPPED_BAG_SLOTS,
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

	----- upgrade old settings (temporary till next xpac)
	for realm, owners in pairs(Addon.sets.profiles) do
		for id, profile in pairs(owners) do
			self:SetDefaults(profile, ProfileDefaults)
			
			for frame, options in pairs(profile) do
				if type(options) == 'table' then
					if options.bagBreak == true then
						options.bagBreak = 2
					elseif not options.bagBreak then
						options.bagBreak = nil
					end
				end
			end
		end
	end

	for frame, options in pairs(Addon.sets.global) do
		if type(options) == 'table' then
			if options.bagBreak == true then
				options.bagBreak = 2
			elseif not options.bagBreak then
				options.bagBreak = nil
			end
		end
	end

	if type(Addon.sets.latest) ~= 'table' then
		Addon.sets.latest = {}
    end
	----

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