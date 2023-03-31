--[[
	main.lua
		Starts the guild bank frame on demand
--]]

local MODULE = ...
local ADDON, Addon = MODULE:match('[^_]+'), _G[MODULE:match('[^_]+')]
local Guild = Addon:NewModule('Guild')

function Guild:OnEnable()
	self:RegisterSignal('GUILD_OPEN', 'OnOpen')
	self:RegisterSignal('GUILD_CLOSE', 'OnClose')
end

function Guild:OnOpen()
	QueryGuildBankTab(GetCurrentGuildBankTab())
	Addon.Frames:Show('guild')
end

function Guild:OnClose()
	Addon.Frames:Hide('guild')
end
