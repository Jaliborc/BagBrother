--[[
	owners.lua
		Maintains a list of owner objects
--]]

local ADDON, Addon = ...
local Owners = Addon:NewModule('Owners')

local DEFAULT_COORDS = {0, 1, 0, 1}
local CLASS_COLOR = '|cff%02x%02x%02x'
local ALLIANCE_BANNER = 'Interface/Icons/Inv_BannerPvP_02'
local HORDE_BANNER = 'Interface/Icons/Inv_BannerPvP_01'
local RACE_TEXTURE, RACE_TABLE
local REALMS = {}

if Addon.IsClassic then
	RACE_TEXTURE = 'Interface/Glues/CharacterCreate/UI-CharacterCreate-Races'
	RACE_TABLE = {
		HUMAN_MALE		= {0, 0.25, 0, 0.25},
		DWARF_MALE		= {0.25, 0.5, 0, 0.25},
		GNOME_MALE		= {0.5, 0.75, 0, 0.25},
		NIGHTELF_MALE	= {0.75, 1.0, 0, 0.25},
		TAUREN_MALE		= {0, 0.25, 0.25, 0.5},
		SCOURGE_MALE	= {0.25, 0.5, 0.25, 0.5},
		TROLL_MALE		= {0.5, 0.75, 0.25, 0.5},
		ORC_MALE		= {0.75, 1.0, 0.25, 0.5},
		HUMAN_FEMALE	= {0, 0.25, 0.5, 0.75},
		DWARF_FEMALE	= {0.25, 0.5, 0.5, 0.75},
		GNOME_FEMALE	= {0.5, 0.75, 0.5, 0.75},
		NIGHTELF_FEMALE	= {0.75, 1.0, 0.5, 0.75},
		TAUREN_FEMALE	= {0, 0.25, 0.75, 1.0},
		SCOURGE_FEMALE	= {0.25, 0.5, 0.75, 1.0},
		TROLL_FEMALE	= {0.5, 0.75, 0.75, 1.0},
		ORC_FEMALE		= {0.75, 1.0, 0.75, 1.0},
	}
else
	RACE_TABLE = {
		highmountaintauren = 'highmountain',
		lightforgeddraenei = 'lightforged',
		scourge = 'undead',
		zandalaritroll = 'zandalari',
	}
end


--[[ Events ]]--

function Owners:OnEnable()
	self:RegisterEvent('REALMS_READY', 'UpdateList')
	self:RegisterEvent('GUILD_CHANGED', 'UpdateList')

	self.__index = function(t, k) return t.cache[k] or self[k] end 
	self.available = {self:New(GetNormalizedRealmName(), UnitName('player'))}
	self.player = self.available[1]
end

function Owners:UpdateList()
	self.available = {}

	for i, realm in ipairs(GetAutoCompleteRealms(REALMS)) do
		for id in pairs(BrotherBags[realm] or {}) do
			tinsert(self.available, self:New(realm, id))
		end
	end

	sort(self.available, function(a, b)
		return not b.offline or a.isguild and not b.isguild
	end)

	self.player = self.available[1]
end

function Owners:Iterate()
	return ipairs(self.available)
end


--[[ Object API ]]--

function Owners:New(realm, id)
	local isguild = id:find('*$')
	local address = id .. ' - ' .. realm
	local name = isguild and id:sub(1,-2) or id
	local player, server = UnitFullName('player')

	return setmetatable({
		id = id, name = name, realm = realm, address = address, 
		offline = realm ~= server or name ~= (isguild and GetGuildInfo('player') or player),
		profile = Addon.sets.profiles[address] or Addon.sets.global,
		cache = BrotherBags[realm][id],
		isguild = isguild,
	}, self)
end

function Owners:Delete()
	Addon.sets.profiles[self.address] = nil
	BrotherBags[self.realm][self.id] = nil
	Owners:SendSignal('OWNER_DELETED')
	Owners:UpdateList()
end

function Owners:SetProfile(profile)
	Addon.sets.profiles[self.address] = profile and Addon.SetDefaults(profile, ProfileDefaults)
	Owners:UpdateList()
end

function Owners:GetIconMarkup(size, x, y)
	local icon, coords = self:GetIcon()
	if coords then
		local u,v,w,z = unpack(coords)
		return CreateTextureMarkup(icon, 128,128, size,size, u,v,w,z, x,y)
	else
		return CreateAtlasMarkup(icon, size,size, x,y)
	end
end

function Owners:GetIcon()
	if sself.race then
		if RACE_TEXTURE then
			return RACE_TEXTURE, RACE_TABLE[self.race:upper() .. '_' .. (self.gender == 3 and 'FEMALE' or 'MALE')]
		end

		local race = self.race:lower()
		return format('raceicon-%s-%s', RACE_TABLE[race] or race, self.gender == 3 and 'female' or 'male')
	end

	return self.faction == 'Alliance' and ALLIANCE_BANNER or HORDE_BANNER, DEFAULT_COORDS
end

function Owners:GetColorMarkup()
	local color = self:GetColor()
	local brightness = color.r + color.g + color.b
	local scale = max(1.8 / brightness, 1.0) * 255

	return CLASS_COLOR:format(min(color.r * scale, 255), min(color.g * scale, 255), min(color.b * scale, 255)) .. '%s|r'
end

function Owners:GetColor()
	return self.class and (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[self.class] or PASSIVE_SPELL_FONT_COLOR
end

function Owners:GetMoney()
	if self.offline then
		return self.money
	elseif self.isguild then
		return GetGuildBankMoney() or 0
	else
		return (GetMoney() or 0) - GetCursorMoney() - GetPlayerTradeMoney()
	end
end
