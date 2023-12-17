--[[
	Warns if out of date build detected.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Detection = Addon:NewModule('UpdateDetection')

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

    if int(Addon.Version) >= int(Addon.sets.latest) then
        Addon.sets.latest = Addon.Version
    elseif GetServerTime() >= (Addon.sets.latestCooldown or 0) then
        print(format(L.CmdOutOfDate, ADDON, Addon.sets.latest))
        xpcall(function()
            LibStub('Sushi-3.2').Popup {
                text = format(L.OutOfDate, ADDON, Addon.sets.latest), button1 = OKAY,
                icon = format('Interface/Addons/BagBrother/art/%s-big', ADDON)
            }
        end, function() end)

        Addon.sets.latestCooldown = GetServerTime() + 3 * 24 * 60 * 60
    end

    C_ChatInfo.RegisterAddonMessagePrefix(ADDON)
    C_Timer.NewTicker(100, function() self:Spread() end)
end

function Detection:OnMessage(_, prefix, version, channel)
    if prefix == ADDON then
        local ours, theirs = int(Addon.sets.latest), int(version)
        if theirs < ours then
            self.Queued[channel] = true
        elseif theirs > ours then
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

function Detection:RegisterUpdateEvent(event, condition)
    self:RegisterEvent(event, 'OnUpdate', condition)
    self:OnUpdate(condition)
end

function Detection:Spread()
    for channel in pairs(self.Queued) do
        C_ChatInfo.SendAddonMessage(ADDON, Addon.sets.latest, channel)
    end

    wipe(self.Queued)
end