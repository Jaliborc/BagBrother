--[[
	display.lua
		Automatic display settings menu
--]]

local CONFIG = ...
local ADDON, Addon = CONFIG:match('[^_]+'), _G[CONFIG:match('[^_]+')]
local PATRONS = {{},{title='Jenkins',people={'Gnare','Seventeen','Justin Hall','Debora S Ogormanw','Johnny Rabbit'}},{title='Ambassador',people={'Julia F','Lolari ','Rafael Lins','Kopernikus ','Dodgen','Kelly Wolf','Ptsdthegamer','Denise Mckinlay','Burt Humburg','Adam Mann','Christie Hopkins','Bc Spear','Jury ','Jeff Stokes','Tigran Andrew','Jeffrey Jones','Swallow@area52','Peter Hollaubek','Bobby Pagiazitis','Michael Kinasz','Sam Ramji','Syed Hamdani','Thinkdesigner '}}} -- generated patron list

local Credits = LibStub('Sushi-3.1').CreditsGroup(Addon.GeneralOptions, PATRONS, 'Patrons |TInterface/Addons/BagBrother/Art/Patreon:12:12|t')
Credits:SetSubtitle(ADDON .. ' is distributed for free and supported trough donations. A massive thank you to all the supporters on Patreon and Paypal who keep development alive. You can become a patron too at |cFFF96854patreon.com/jaliborc|r.', 'http://www.patreon.com/jaliborc')
Credits:SetFooter('Copyright 2006-2023 João Cardoso and Jason Greer')
