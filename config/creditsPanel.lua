--[[
	display.lua
		Automatic display settings menu
--]]

local CONFIG = ...
local ADDON, Addon = CONFIG:match('[^_]+'), _G[CONFIG:match('[^_]+')]
local PATRONS = {{},{title='Jenkins',people={'Gnare','Seventeen','Grumpyitis','Justin Hall','Debora S Ogormanw','Johnny Rabbit'}},{title='Ambassador',people={'Julia F','Lolari ','Rafael Lins','Mediocre Monk','Joanie Nelson','Dodgen','Nitro ','Guidez ','Ptsdthegamer','Denise Mckinlay','Frosted(mrp)','Burt Humburg','Adam Mann','Christie Hopkins','Kopernikus ','Bc Spear','Jury ','Oromisism','Jeff Stokes','Tigran Andrew','Jeffrey Jones','Swallow@area52','Peter Hollaubek','Daniel  Di Battis','Bobby Pagiazitis','Michael Kinasz','Lars Norberg','Sam Ramji','Dave Burlingame'}}} -- generated patron list

local Credits = LibStub('Sushi-3.1').CreditsGroup(Addon.GeneralOptions, PATRONS, 'Patrons |TInterface/Addons/BagBrother/Art/Patreon:12:12|t')
Credits:SetSubtitle(ADDON .. ' is distributed for free and supported trough donations. A massive thank you to all the supporters on Patreon and Paypal who keep development alive. You can become a patron too at |cFFF96854patreon.com/jaliborc|r.', 'http://www.patreon.com/jaliborc')
Credits:SetFooter('Copyright 2006-2023 João Cardoso and Jason Greer')
