--[[
	Maintains a list of owner objects.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local Owners = Addon:NewModule('Owners')

local DEFAULT_COORDS = {0, 1, 0, 1}
local CLASS_COLOR = '|cff%02x%02x%02x'
local ALLIANCE_BANNER = 'Interface/Icons/Inv_BannerPvP_02'
local HORDE_BANNER = 'Interface/Icons/Inv_BannerPvP_01'
local RACE_TEXTURE, RACE_TABLE

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


--[[ Static ]]--

function Owners:OnEnable()
	self.registry, self.ordered = {}, {}
	self.__index = function(t, k) return t.cache[k] or self[k] end
	Addon.player = self:New(UnitFullName('player'))

	for i, realm in ipairs {Addon.player.realm, unpack(GetAutoCompleteRealms())} do
		for id, cache in pairs(BrotherBags[realm] or Addon.None) do
			self:New(id, realm)
		end
	end

	self:RegisterEvent('GUILD_ROSTER_UPDATE', 'OnRoster')
	self:Sort()
end

function Owners:OnRoster()
	local name, _,_, realm = GetGuildInfo('player')
	if (Addon.guild and Addon.guild.name) ~= name or (Addon.guild and Addon.guild.realm) ~= realm then
		Addon.guild = name and self:New(name..'*', realm or Addon.player.realm)
		self:Sort()
	end
end

function Owners:Sort()
	for i, owner in ipairs(self.ordered) do
		owner.offline = owner ~= Addon.player and owner ~= Addon.guild
	end

	sort(self.ordered, function(a, b)
		if a.isguild ~= b.isguild then
			return b.isguild
		elseif a.level == b.level or not (a.level and b.level) then
			return a.name < b.name
		end
		return a.level > b.level
	end)
end

function Owners:Iterate()
	return ipairs(self.ordered or Addon.None)
end

function Owners:Count()
	return #self.ordered
end


--[[ Object API ]]--

function Owners:New(id, realm)
	local cache = GetOrCreateTableEntry(GetOrCreateTableEntry(BrotherBags, realm), id)
	if not self.registry[cache] then
		local isguild = id:find('*$') and true
		local name = isguild and id:sub(1,-2) or id
		local owner = setmetatable({
			id = id, realm = realm, name = name,
			address = (isguild and '®' or '')..name..'-'..realm, -- needed for backwards support
			profile = Addon.Settings:GetProfile(realm, id),
			cache = cache, isguild = isguild,
		}, self)

		self.registry[cache] = owner
		tinsert(self.ordered, owner)
	end
	return self.registry[cache]
end

function Owners:Delete()
	Addon.Settings:SetProfile(self.realm, self.id, nil)
	BrotherBags[self.realm][self.id] = nil
	Owners.registry[self.cache] = nil
	tDeleteItem(Owners.ordered, self)
end

function Owners:SetProfile(profile)
	Addon.Settings:SetProfile(self.realm, self.id, profile)
	self.profile = Addon.Settings:GetProfile(self.realm, self.id)
end

function Owners:GetIconMarkup(size, x, y)
	local icon, coords = self:GetIcon()
	if coords then
		local u,v,w,z = unpack(coords)
		return CreateTextureMarkup(icon, 128,128, size,size, u,v,w,z, x or 0, y or 0)
	else
		return CreateAtlasMarkup(icon, size,size, x or 0, y or 0)
	end
end

function Owners:GetIcon()
	if self.race then
		if RACE_TEXTURE then
			return RACE_TEXTURE, RACE_TABLE[self.race:upper() .. '_' .. (self.sex == 3 and 'FEMALE' or 'MALE')]
		end

		local race = self.race:lower()
		return format('raceicon-%s-%s', RACE_TABLE[race] or race, self.sex == 3 and 'female' or 'male')
	end

	return self.faction and ALLIANCE_BANNER or HORDE_BANNER, DEFAULT_COORDS
end

function Owners:GetColorMarkup()
	local color = self:GetColor()
	local brightness = color.r + color.g + color.b
	local scale = max(1.8 / brightness, 1.0) * 255

	return CLASS_COLOR:format(min(color.r * scale, 255), min(color.g * scale, 255), min(color.b * scale, 255)) .. '%s|r'
end

function Owners:GetColor()
	return self.class and (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[self.class] or WHITE_FONT_COLOR
end

function Owners:GetMoney()
	if self.offline then
		return self.money or 0
	elseif self.isguild then
		return GetGuildBankMoney() or 0
	else
		return (GetMoney() or 0) - GetCursorMoney() - GetPlayerTradeMoney()
	end
end
