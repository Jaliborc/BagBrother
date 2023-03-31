--[[
	settings.lua
		Initializes the settings, checks for version updates and provides the necessary API for profile management
--]]

local ADDON, Addon = ...
local VAR = ADDON .. '_Sets'
local Settings = Addon:NewModule('Settings')


--[[ Startup ]]--

function Settings:OnEnable()
	_G[VAR] = self:SetDefaults(_G[VAR] or {}, {
		global = self:SetDefaults({}, self.ProfileDefaults),
        version = Addon.Version,
		profiles = {},

		display = {banker = true, guildBanker = true, voidStorageBanker = true, crafting = true, tradePartner = true, socketing = true, auctioneer = true, merchant = true, mailInfo = true, scrappingMachine = true},
		resetPlayer = true, flashFind = true, tipCount = true, serverSort = true,

		glowAlpha = 0.5,
		glowQuality = true, glowNew = true, glowQuest = true, glowSets = true, glowUnusable = true,

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

	for owner, profile in pairs(Addon.sets.profiles) do
		self:SetDefaults(profile, self.ProfileDefaults)
	end
end


--[[ API ]]--

function Settings:SetDefaults(target, defaults)
	defaults.__index = nil

	for k, v in pairs(defaults) do
		if type(v) == 'table' then
			if getmetatable(v) == 1 then
				target[k] = target[k] or self:AsArray(CopyTable(v))
			else
				target[k] = self:SetDefaults(target[k] or {}, v)
			end
		end
	end

	defaults.__index = defaults
	return setmetatable(target, defaults)
end

function Settings:AsArray(table)
	return setmetatable(table, {__metatable = 1})
end


--[[ Constants ]]--

Settings.FrameDefaults = {
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

	rules = Settings:AsArray({
		'all', 'all/normal', 'all/trade', 'all/reagent', 'all/keys', 'all/quiver',
		'equip', 'equip/armor', 'equip/weapon', 'equip/trinket',
		'use', 'use/consume', 'use/enhance',
		'trade', 'trade/goods', 'trade/gem', 'trade/glyph', 'trade/recipe',
		'quest', 'misc',
	}),
}

Settings.ProfileDefaults = {
	inventory = Settings:SetDefaults({
		reversedTabs = true,
		borderColor = {1, 1, 1, 1},
		currency = true, broker = Addon.IsClassic,
		point = 'BOTTOMRIGHT',
		x = -50, y = 100,
		columns = 10,
		width = 384,
		height = 200,
	}, Settings.FrameDefaults),

	bank = Settings:SetDefaults({
		borderColor = {1, 1, 0, 1},
		currency = true,
		point = 'LEFT',
		columns = 14,
		width = 600,
		height = 500,
		x = 95
	}, Settings.FrameDefaults),

	vault = Settings:SetDefaults({
		borderColor = {1, 0, 0.98, 1},
		point = 'LEFT',
		columns = 10,
		x = 95
	}, Settings.FrameDefaults),

	guild = Settings:SetDefaults({
		borderColor = {0, 1, 0, 1},
		point = 'CENTER',
		columns = 7,
	}, Settings.FrameDefaults)
}
