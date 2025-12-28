--[[
	Defines keybindings and a slash command menu.
	All Rights Reserved
--]]


local ADDON, Addon = ...
local Slash = Addon:NewModule('Commands')
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)


--[[ Keybindings ]]--

do
	local ADDON_UPPER = ADDON:upper()
	_G['BINDING_HEADER_' .. ADDON_UPPER] = ADDON
	_G['BINDING_NAME_' .. ADDON_UPPER .. '_TOGGLE'] = L.OpenBags
	_G['BINDING_NAME_' .. ADDON_UPPER .. '_BANK_TOGGLE'] = L.OpenBank
	_G['BINDING_NAME_' .. ADDON_UPPER .. '_VAULT_TOGGLE'] = L.OpenVault
	_G['BINDING_NAME_' .. ADDON_UPPER .. '_GUILD_TOGGLE'] = L.OpenGuild
end


--[[ Slash Commands ]]--

function Slash:OnLoad()
	SlashCmdList[ADDON] = self.OnSlashCommand
	_G['SLASH_'..ADDON..'1'] = '/' .. ADDON
	_G['SLASH_'..ADDON..'2'] = '/bgn'
end

function Slash.OnSlashCommand(cmd)
	local cmd = cmd and cmd:lower()
	if cmd == 'bags' or cmd == 'inventory' then
		Addon.Frames:Toggle('inventory')
	elseif cmd == 'bank' then
		Addon.Frames:Toggle('bank')
	elseif cmd == 'guild' then
		Addon.Frames:Toggle('guild')
	elseif cmd == 'vault' then
		Addon.Frames:Toggle('vault')
	elseif cmd == 'version' then
		print('|cff33ff99' .. ADDON .. '|r version ' .. LibStub('C_Everywhere').AddOns.GetAddOnMetadata(ADDON, 'version'))
	elseif cmd == 'config' or cmd == 'options' then
		Addon:ShowOptions()
	elseif cmd == 'reset' then
		Slash:ResetSettings()
	else
		Slash:PrintHelp()
	end
end

function Slash:ResetSettings()
	LibStub('Sushi-3.2').Popup {
		icon = 'Interface/Addons/BagBrother/Art/' .. ADDON .. '-big',
		text = format(L.ResetConfirm, ADDON), button1 = OKAY, button2 = CANCEL,
		whileDead = 1, exclusive = 1, hideOnEscape = 1,
		OnAccept = function()
			wipe(BrotherBags)
			wipe(Addon.sets)
			ReloadUI()
		end
	}
end

function Slash:PrintHelp()
	print('|cff33ff99' .. ADDON .. '|r ' .. L.Commands)
	self:Print('bags', L.CmdShowInventory)
	self:Print('bank', L.CmdShowBank)
	self:Print('guild', L.CmdShowGuild, Addon.LoadGuild)
	self:Print('vault', L.CmdShowVault, Addon.LoadVault)
	self:Print('config/options', L.CmdShowOptions)
	self:Print('reset', L.CmdReset)
	self:Print('version', L.CmdShowVersion)
end

function Slash:Print(cmd, desc, requirement)
	if requirement ~= false then
		print(format(' - |cFF33FF99%s|r: %s', cmd, desc))
	end
end
