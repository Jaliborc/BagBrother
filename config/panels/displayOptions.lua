--[[
	Automatic display settings menu.
	All Rights Reserved
--]]

local L, ADDON, Addon = select(2, ...).Addon()
local Display = Addon.GeneralOptions:New('DisplayOptions', '|A:CrossedFlags:14:14:-2:0|a')

function Display:Populate()
	self.sets = Addon.sets.display
	self:Add('Header', L.DisplayInventory, 'GameFontHighlight', true)
	self:AddRow(35*6, function()
		self:AddOption('banker', 'accountBanker', 'characterBanker')
		self:AddOption('guildBanker')
		self:AddOption('voidStorageBanker')

		self:AddOption('auctioneer', 'blackMarketAuctioneer')
		self:AddOption('merchant', 'vendor')
		self:AddOption('mailInfo')

		self:AddOption('tradePartner')
		self:AddOption('crafting')
		self:AddOption('transmogrifier', 'socketing', 'itemUpgrade', 'itemInteraction')
		self:AddOption('character')
	end)

	self:Add('Header', L.CloseInventory, 'GameFontHighlight', true)
	self:AddRow(35*3, function()
		for i, event in ipairs {'mapFrame', 'combat', 'vehicle'} do
			self:AddOption(event)
		end
	end)
end

function Display:AddOption(...)
	self:AddCheck(...):SetWidth(250)
end