--[[
	moneyFrame.lua
		A guild money display
--]]

local MODULE = ...
local ADDON, Addon = MODULE:match('[^_]+'), _G[MODULE:match('[^_]+')]
local Money = Addon.PlayerMoney:NewClass('GuildMoney')
Money.Type = 'GUILDBANK'

local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Sushi = LibStub('Sushi-3.2')

function Money:RegisterEvents()
	self:RegisterEvent('GUILDBANK_UPDATE_MONEY', 'Update')
	self:Update()
end

function Money:OnEnter()
	local allowed = CanWithdrawGuildBankMoney() and GetMoneyString(min(GetGuildBankWithdrawMoney(), GetGuildBankMoney()), true)
	self:ShowTooltip(L.GuildFunds, '|L '..DEPOSIT, allowed and ('|R '..WITHDRAW..'  '..self.Gray:format(L.NumAllowed:format(allowed))))
end

function Money:OnClick(button)
	if self:IsCached() then return end

	local money = GetCursorMoney() or 0
	if money > 0 then
		DepositGuildBankMoney(money)
		DropCursorMoney()

	elseif button == 'LeftButton' and not IsShiftKeyDown() then
		Sushi.Popup:Cancel(GUILDBANK_WITHDRAW)
		Sushi.Popup:Toggle {
			text = GUILDBANK_DEPOSIT, moneyInput = 0, button1 = ACCEPT, button2 = CANCEL,
			open = SOUNDKIT.MONEY_FRAME_OPEN, close = SOUNDKIT.MONEY_FRAME_CLOSE,
			OnAccept = function(popup, money) DepositGuildBankMoney(money) end
		}
	elseif CanWithdrawGuildBankMoney() then
		Sushi.Popup:Cancel(GUILDBANK_DEPOSIT)
		Sushi.Popup:Toggle {
			text = GUILDBANK_WITHDRAW, moneyInput = 0, button1 = ACCEPT, button2 = CANCEL,
			open = SOUNDKIT.MONEY_FRAME_OPEN, close = SOUNDKIT.MONEY_FRAME_CLOSE,
			OnAccept = function(popup, money) WithdrawGuildBankMoney(money) end
		}
	end
end