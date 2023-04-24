--[[
	frame.lua
		A specialized version of the window frame for void storage
--]]

local MODULE =  ...
local ADDON, Addon = MODULE:match('[^_]+'), _G[MODULE:match('[^_]+')]
local Vault = Addon.Frame:NewClass('VaultFrame')

local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Sushi = LibStub('Sushi-3.1')

Vault.Title = L.TitleVault
Vault.OpenSound = SOUNDKIT.UI_ETHEREAL_WINDOW_OPEN
Vault.CloseSound = SOUNDKIT.UI_ETHEREAL_WINDOW_CLOSE
Vault.ItemGroup = Addon.VaultItemGroup
Vault.MoneyFrame = Addon.TransferButton
Vault.PurchasePrice = 100 * 100 * 100
Vault.PopupID = MODULE .. 'Purchase'
Vault.MoneySpacing = -24
Vault.BrokerSpacing = -6
Vault.Bags = {'vault'}


--[[ Startup ]]--

function Vault:New(id)
	local f = self:Super(Vault):New(id)
	f.Deposit = self.ItemGroup:New(f, {DEPOSIT}, DEPOSIT)
	f.Deposit:SetPoint('TOPLEFT', 10, -55)
	f.Deposit:Hide()
	f.Withdraw = self.ItemGroup:New(f, {WITHDRAW}, WITHDRAW)
	f.Withdraw:SetPoint('TOPLEFT', f.Deposit, 'BOTTOMLEFT', 0, -5)
	f.Withdraw:Hide()
	return f
end

function Vault:RegisterSignals()
	self:Super(Vault):RegisterSignals()
	self:RegisterFrameSignal('TRANFER_TOGGLED')
	self:RegisterSignal('VAULT_CLOSE')
	self:RegisterSignal('VAULT_OPEN')
end

function Vault:OnHide()
	self:Super(Vault):OnHide()
	self:Close()
end

function Vault:Close()
	if C_PlayerInteractionManager then
		C_PlayerInteractionManager.ClearInteraction(Enum.PlayerInteractionType.VoidStorageBanker)
	elseif CloseVoidStorageFrame then
		CloseVoidStorageFrame()
	end
end


--[[ Events ]]--

function Vault:TRANFER_TOGGLED(_, transfering)
	self.Deposit:SetShown(transfering)
	self.Withdraw:SetShown(transfering)
	self.ItemGroup:SetShown(not transfering)

	if transfering then
		self.popup = Sushi.Popup {
			text = L.ConfirmTransfer,
			button1 = YES, button2 = NO,
			timeout = 0, hideOnEscape = 1,

			OnAccept = function(popup)
				ExecuteVoidTransfer()
				self:SendFrameSignal('TRANFER_TOGGLED')
			end,
			OnCancel = function(popup)
				self:SendFrameSignal('TRANFER_TOGGLED')
			end
		}
	elseif self.popup then
		self.popup:Release()
	end
end

function Vault:VAULT_OPEN()
	IsVoidStorageReady()

	if not CanUseVoidStorage() then
		if COST > GetMoney() then
			Sushi.Popup {
				id = self.PopupID,
				text = format(L.CannotPurchaseVault, GetMoneyString(self.PurchasePrice, true)),
				button1 = CHAT_LEAVE, button2 = L.AskMafia,
				timeout = 0, hideOnEscape = 1,
				OnAccept = self.Close,
				OnCancel = self.Close,
			}
		else
			Sushi.Popup {
				id = self.PopupID,
				text = format(L.PurchaseVault, GetMoneyString(self.PurchasePrice, true)),
				button1 = UNLOCK, button2 = NO,
				timeout = 0, hideOnEscape = 1,
				OnCancel = self.Close,
				OnAccept = function()
					PlaySound(SOUNDKIT.UI_VOID_STORAGE_UNLOCK)
					UnlockVoidStorage()
				end,
			}
		end
	end
end

function Vault:VAULT_CLOSE()
	Sushi.Popup:Hide(self.PopupID)
end


--[[ Properties ]]--

function Vault:GetItemInfo(bag, slot)
	if bag == 'vault' then
		return self:Super(Vault):GetItemInfo(bag, slot)
	else
		local get = bag == DEPOSIT and GetVoidTransferDepositInfo or GetVoidTransferWithdrawalInfo
		local item = {}

		for i = 1,9 do
			if get(i) then
				slot = slot - 1
				if slot == 0 then
					item.id, item.icon, item._, item.recent, item.filtered, item.quality = get(i)
					return item
				end
			end
		end

		return item
	end
end

function Vault:IsCached()
	return not Addon.Events.AtVault or self:GetOwner().offline
end

function Vault:HasMoney() return true end
function Vault:IsBagGroupShown() end
function Vault:HasBagToggle() end
