--[[
	A warband money display
	All Rights Reserved
--]]

if not (C_Bank and C_Bank.FetchDepositedMoney) then
	return
end

local ADDON, Addon = ...
local Sushi = LibStub('Sushi-3.2')
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)

local Money = Addon.PlayerMoney:NewClass('AccountMoney')
Money.Type = 'ACCOUNT'

function Money:RegisterEvents()
	self:RegisterEvent('ACCOUNT_MONEY', 'Update')
	self:Update()
end

function Money:OnEnter()
	self:ShowTooltip(L.WarbandMoney, '|L '..DEPOSIT, '|R '..WITHDRAW)
end

function Money:OnClick(button)
    if not C_Bank.CanViewBank(2) then return end
	
    local money = GetCursorMoney() or 0
	if money > 0 then
        C_Bank.DepositMoney(2, money)
		DropCursorMoney()

    elseif button == 'LeftButton' and not IsShiftKeyDown() then
		Sushi.Popup:Cancel(BANK_MONEY_WITHDRAW_PROMPT)
		Sushi.Popup:Toggle {
			text = BANK_MONEY_DEPOSIT_PROMPT, moneyInput = 0, button1 = ACCEPT, button2 = CANCEL,
			open = SOUNDKIT.MONEY_FRAME_OPEN, close = SOUNDKIT.MONEY_FRAME_CLOSE,
			OnAccept = function(popup, money) C_Bank.DepositMoney(2, money) end
		}
	else
		Sushi.Popup:Cancel(BANK_MONEY_DEPOSIT_PROMPT)
		Sushi.Popup:Toggle {
			text = BANK_MONEY_WITHDRAW_PROMPT, moneyInput = 0, button1 = ACCEPT, button2 = CANCEL,
			open = SOUNDKIT.MONEY_FRAME_OPEN, close = SOUNDKIT.MONEY_FRAME_CLOSE,
			OnAccept = function(popup, money) C_Bank.WithdrawMoney(2, money) end
		}
	end
end

function Money:GetMoney()
    return C_Bank.FetchDepositedMoney(2)
end