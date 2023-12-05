--[[
	config.lua
		Figures out which addon it has been loaded by
--]]

local CONFIG, Config = ...
local L = LibStub('AceLocale-3.0'):GetLocale(CONFIG)
local ADDON, Addon = CONFIG:match('[^_]+'), _G[CONFIG:match('[^_]+')]

function Config.Addon()
    return L, ADDON, Addon, Config
end