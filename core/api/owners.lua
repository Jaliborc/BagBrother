--[[
	owners.lua
		Maintains a list of owner objects
--]]

local ADDON, Addon = ...
local Owners = Addon:NewModule('Owners')


--[[ Events ]]--

function Owners:OnEnable()
	self:RegisterEvent('REALMS_READY')
	self:RegisterEvent('GUILD_CHANGED', 'REALMS_READY')

	self.__index = function(t, k) return t.data[k] or self[k] end
	self.player = self:New(UnitFullName('player'))
	self.available = {player}
end

function Owners:REALMS_READY()
	self.available = {}

	for i, realm in ipairs(GetAutoCompleteRealms()) do
		for name, data in pairs(BrotherBags[realm]) do
			tinsert(self.available, self:New(name, realm, data))
		end
	end

	sort(self.available, function(a, b)
		return not b.cached or a.isguild
	end)
end


--[[ Object API ]]--

function Owners:New(name, realm, data)
	local player, server = UnitFullName('player')
	local isguild = name:find('*$')
	if isguild then
		name = name:sub(1,-2)
	end

	return setmetatable({
		cached = realm ~= server or name ~= (isguild and GetGuildInfo('player') or player),
		name = name, realm = realm,
		isguild = isguild,
		data = data or {},
	}, self)
end

function Owners:Delete()
	BrotherBags[self.realm][self.name] = nil
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
	if self.cached then
		return self.money
	elseif self.isguild then
		return GetGuildBankMoney() or 0
	else
		return (GetMoney() or 0) - GetCursorMoney() - GetPlayerTradeMoney()
	end
end
