--[[
	Initializes the settings, checks for version updates and provides the necessary API for profile management.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local VAR = ADDON .. '_Sets'
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Settings = Addon:NewModule('Settings')


--[[ Startup ]]--

function Settings:OnLoad()
	BrotherBags = self:SetDefaults(BrotherBags or {}, {account = {}})
	Addon.sets = self:SetDefaults(_G[VAR] or {}, Mixin({
		global = self:SetDefaults({}, self.ProfileDefaults),
		profiles = {}, customRules = {},

		resetPlayer = true, flashFind = true,
		countItems = true, countGuild = true, countCurrency = true, 
		depositAccount = true, depositReagents = true,
		display = {
			banker = true, accountBanker = true, characterBanker = true, guildBanker = true, voidStorageBanker = true,
			auctioneer = true, blackMarketAuctioneer = true, mailInfo = true, merchant = true, vendor = true,
			transmogrifier = true, socketing = true, itemUpgrade = true,
			crafting = true, tradePartner = true,
			scrappingMachine = true, soulbind = true, itemInteraction = true,
		},

		glowAlpha = 0.5,
		glowQuality = true, glowNew = true, glowQuest = true, glowSets = true, glowUnusable = true, glowPoor = true,

		slotBackground = Addon.IsMainline and 3 or 2,
		colorSlots = true,
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
	}, self.GlobalDefaults))

	for realm, owners in pairs(Addon.sets.profiles) do
		for id, profile in pairs(owners) do
			self:SetDefaults(profile, self.ProfileDefaults)
		end
	end
	
	_G[VAR] = Addon.sets
	self:Upgrade()
end

function Settings:Upgrade() -- all code temporary, will be removed eventually
	xpcall(function()
		if BrotherBags.forever and Addon.IsForever then
			local old = BrotherBags.forever
			local ruleset = 
				(C_GameRules.IsGameRuleActive(Enum.GameRule.RPRuleset) and 'RP-' or '') ..
				(
					C_GameRules.IsGameRuleActive(Enum.GameRule.HardcoreRuleset) and 'Harcore' or
					C_GameRules.IsGameRuleActive(Enum.GameRule.PvPRuleset)      and 'PvP' or 'PvE'
				)

			local function move(id)
				if old[id] then
					local owners = GetOrCreateTableEntry(BrotherBags, ruleset)
					if not owners[id] then
						owners[id], old[id] = old[id], nil
					end
				end
			end

			local name, surname = UnitFullName('player')
			if name and surname then
				move(name .. ' ' .. surname)
			end

			local guild = GetGuildInfo('player')
			if guild then
				move(guild .. '*')
			end

			for realm in pairs(BrotherBags) do
				if type(realm) == 'string' and realm:match('^CAMWOW') then
					BrotherBags[realm] = nil
				end
			end

			if not next(old) then
				BrotherBags.forever = nil
			end	

			print('|cff33ff99' .. ADDON .. '|r ' .. 'Character data converted to optimize for ruleset separation. If any data is lost, please just visit the bank again.')
		end
	end, function(...)
		print('|cff33ff99' .. ADDON .. '|r ' .. L.UpgradeError)
		geterrorhandler()(...)
	end)
end


--[[ API ]]--

function Settings:SetProfile(realm, id, profile)
	realm = GetOrCreateTableEntry(Addon.sets.profiles, realm)
	realm[id] = profile and self:SetDefaults(profile, self.ProfileDefaults)
end

function Settings:GetProfile(realm, id)
	realm = Addon.sets.profiles[realm]
	return realm and realm[id] or Addon.sets.global
end
