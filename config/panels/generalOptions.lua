--[[
	General settings menu.
	All Rights Reserved
--]]

local L, ADDON, Addon, Config = select(2, ...).Addon()
local General = Addon.OptionsPanel('GeneralOptions', '|TInterface/Addons/BagBrother/Art/'..ADDON..'-Small:16:16|t')

function General:Populate()
	self:Add('Header', GENERAL, 'GameFontHighlight', true)
	self:AddCheck('locked')
	self:AddCheck('displayBlizzard')
	self:AddCheck('flashFind')

	self:Add('Check', L.CharacterSpecific)
		:SetCall('OnInput', function() self:ToggleGlobals() end)
		:SetChecked(Addon.player.profile ~= Addon.sets.global)

	self:Add('Header', L.Tooltips, 'GameFontHighlight', true)
	self:AddCheck('countItems')

	if CanGuildBankRepair and self.sets.countItems then
		self:AddCheck('countGuild'):SetSmall(true).left = 20
	end

	self:AddCheck('countCurrency')
end

function General:ToggleGlobals()
	if Addon.player.profile == Addon.sets.global then
		self:SetProfile(CopyTable(Addon.sets.global))
	else
		LibStub('Sushi-3.2').Popup {
			text = L.ConfirmGlobals, showAlertGear = true, button1 = YES, button2 = NO,
			OnAccept = function()
				self:SetProfile(nil)
				self:Update()
			end
		}
	end
end

function General:SetProfile(profile)
	Addon.player:SetProfile(profile)
	Addon.Frames:Update()
end
