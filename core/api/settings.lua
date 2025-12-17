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
		local function ensureTables(table)
			for _,key in ipairs(GetKeysArray(table)) do
				if type(table[key]) ~= 'table' then
					table[key] = nil -- old/corrupted entry? some users had invalid stuff in their saved variables
				end
			end
			return table
		end

		local function upgradeProfile(profile)
			for id, sets in pairs(ensureTables(profile)) do
				if type(sets.bagBreak) ~= 'number' then
					sets.bagBreak = nil
				end

				if sets.skin == 'Panel - Flat' then
					sets.skin = 'Bagnonium'
				elseif sets.skin == 'Panel - Marble' then
					sets.skin = 'Combuctor'
				end

				if sets.filters then
					sets.rules, sets.filters = {sidebar = sets.filters}
				end

				sets.hiddenBags, sets.lockedSlots = nil
			end
		end

		for realm, owners in pairs(ensureTables(Addon.sets.profiles)) do
			for id, profile in pairs(ensureTables(owners)) do
				upgradeProfile(profile)
			end
		end
		upgradeProfile(Addon.sets.global)

		local OLD_KEYSTONE_FORMAT = '^' .. strrep('%d+:', 6) .. '%d+$'
		local OLD_PET_FORMAT = '^' .. strrep('%d+:', 7) .. '%d+$'
		local function clean(data)
			for key, value in pairs(data) do
				local kind = type(value)
				if kind == 'table' then
					if (value.size or value.name or key == 'vault') and not value.items then
						local items = {}

						for k,v in pairs(value) do
							if type(k) ~= 'string' then
								items[k] = v
								value[k] = nil
							end
						end

						if next(items) then
							value.items = items
						end
					else
						value.tabNameEditBoxHeader, value.tabCleanupConfirmation = nil
						clean(value)
					end
				elseif kind == 'string' then
					if value:find(OLD_KEYSTONE_FORMAT) then
						data[key] = 'keystone:' .. value
					elseif value:find(OLD_PET_FORMAT) then
						data[key] = 'battlepet:' .. value
					end
				end
			end
		end

		clean(ensureTables(BrotherBags))
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