--[[
	Warns if out of date build detected.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local C = LibStub('C_Everywhere').AddOns
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Detection = Addon:NewModule('UpdateDetection')

local nextExpansion = 0
for k, v in pairs(_G) do
    if type(k) == 'string' and type(v) == 'number' and k:match('^LE_EXPANSION_[%u_]+$') then
        nextExpansion = max(nextExpansion, (v+2) * 10000)
    end
end

local function int(version)
    local major, minor, patch = version:match('(%d+)%.*(%d*)%.*(%d*)')
    return tonumber(major) * 10000 + (tonumber(minor) or 0) * 100 + (tonumber(patch) or 0)
end


--[[ Events ]]--

function Detection:OnEnable()
    self.Queued = {}
    self:RegisterEvent('CHAT_MSG_ADDON', 'OnMessage')
    self:RegisterUpdateEvent('PLAYER_ENTERING_WORLD', function() return IsInInstance() and 'INSTANCE_CHAT' end)
    self:RegisterUpdateEvent('GUILD_ROSTER_UPDATE', function() return IsInGuild() and 'GUILD' end)
    self:RegisterUpdateEvent('GROUP_ROSTER_UPDATE', function() return IsInGroup() and 'RAID' end)

    if Addon.sets.latest and GetServerTime() >= (Addon.sets.latestCooldown or 0) then
        Addon.sets.latestCooldown, Addon.sets.latest = GetServerTime() + 7 * 24 * 60 * 60
        self:Popup(L.OutOfDate, Addon.sets.latest)
    elseif int(Addon.Version) > nextExpansion then
        self:Popup(L.InvalidVersion)
    end

    C_ChatInfo.RegisterAddonMessagePrefix(ADDON)
    C_Timer.NewTicker(100, function() self:Broadcast() end)
end

function Detection:OnMessage(_, prefix, version, channel)
    if prefix == ADDON then
        local ours, theirs = int(Addon.sets.latest or Addon.Version), int(version)
        if theirs < ours then
            self.Queued[channel] = true
        elseif theirs > ours and theirs < nextExpansion then
            Addon.sets.latest = version
        end
    end
end

function Detection:OnUpdate(condition)
    local channel = condition()
    if channel then
        self.Queued[channel] = true
    end
end


--[[ API ]]--

function Detection:Popup(text, version)
    print(format('|cffff0000' .. text:gsub('|c%x%x%x%x%x%x%x%x', '|cffffffff'):gsub('|n', ' ') .. '|r', ADDON, version))
    xpcall(function()
        LibStub('Sushi-3.2').Popup {
            text = format(text, ADDON, version), button1 = OKAY,
            icon = format('Interface/Addons/BagBrother/art/%s-big', ADDON)
        }
    end, function() end)
end

function Detection:RegisterUpdateEvent(event, condition)
    if not C.GetAddOnMetadata(ADDON, 'x-development') then
        self:RegisterEvent(event, 'OnUpdate', condition)
        self:OnUpdate(condition)
    end
end

function Detection:Broadcast()
    for channel in pairs(self.Queued) do
        C_ChatInfo.SendAddonMessage(ADDON, Addon.Version, channel)
    end

    wipe(self.Queued)
end