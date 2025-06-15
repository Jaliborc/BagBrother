--[[
	itemGroup.lua
		A grid of guild bank items
--]]

local ADDON, Addon = (...):match('[^_]+'), _G[(...):match('[^_]+')]
local Items = Addon.ItemGroup:NewClass('GuildItemGroup')
Items.Button = Addon.GuildItem
Items.Transposed = true

function Items:RegisterEvents()
	self:Super(Items):RegisterEvents()

	if self:IsCached() then
		self:RegisterSignal('GUILD_OPEN', 'RegisterEvents')
		self:RegisterSignal('GUILD_TAB_CHANGED', 'Update')
  	else
		self:QueryServer()
		self:RegisterSignal('GUILD_CLOSE', 'RegisterEvents')
		self:RegisterSignal('GUILD_TAB_CHANGED', 'QueryServer')
		self:RegisterEvent('GUILDBANKBAGSLOTS_CHANGED', 'Update')
		self:RegisterEvent('GUILDBANK_ITEM_LOCK_CHANGED', 'ForAll', 'UpdateLocked')
	end
end

function Items:QueryServer()
	QueryGuildBankTab(GetCurrentGuildBankTab())
end