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
    self:RegisterUpdateEvent('GUILD_ROSTER_UPDATE', function() return IsInGuild() and 'GUILD' end)
    self:RegisterUpdateEvent('GROUP_ROSTER_UPDATE', function() return IsInGroup(LE_PARTY_CATEGORY_HOME) and 'PARTY' end)
    self:RegisterUpdateEvent('GROUP_ROSTER_UPDATE', function() return IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and 'INSTANCE_CHAT' end)
    self:RegisterUpdateEvent('GROUP_ROSTER_UPDATE', function() return IsInRaid(LE_PARTY_CATEGORY_HOME) and 'RAID' end)

    local latest = Addon.sets.latest
    if latest.id and GetServerTime() >= (latest.cooldown or 0) then
        self:Popup(L.OutOfDate, latest.who, latest.id)
        Addon.sets.latest = {cooldown = GetServerTime() + 7 * 24 * 60 * 60}
    elseif int(Addon.Version) > nextExpansion then
        self:Popup(L.InvalidVersion)
    end

    C_ChatInfo.RegisterAddonMessagePrefix(ADDON)
    C_Timer.NewTicker(60, function() self:Broadcast() end)
end

function Detection:OnMessage(_, prefix, version, channel, sender)
    if prefix == ADDON then
        local latest = Addon.sets.latest
        local ours, theirs = int(latest.id or Addon.Version), int(version)
        if theirs > ours and theirs < nextExpansion then
            latest.id, latest.who = version, sender
        else
            self.Queued[channel] = theirs < ours or nil
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

function Detection:Popup(text, who, version)
    print(format('|cffff0000' .. text:gsub('|c%x%x%x%x%x%x%x%x', '|cffffffff'):gsub('|n', ' ') .. '|r', ADDON, who, version))
    xpcall(function()
        LibStub('Sushi-3.2').Popup {
            text = format(text, ADDON, who, version), button1 = OKAY,
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