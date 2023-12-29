--[[
	frame.lua
		A specialized version of the window frame for void storage
--]]

local MODULE =  ...
local ADDON, Addon = MODULE:match('[^_]+'), _G[MODULE:match('[^_]+')]
local Vault = Addon.Frame:NewClass('Vault')

local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Sushi = LibStub('Sushi-3.2')

Vault.Title = L.TitleVault
Vault.OpenSound = SOUNDKIT.UI_ETHEREAL_WINDOW_OPEN
Vault.CloseSound = SOUNDKIT.UI_ETHEREAL_WINDOW_CLOSE
Vault.PickupItem = ClickVoidStorageSlot
Vault.ItemGroup = Addon.VaultItemGroup
Vault.MoneyFrame = Addon.TransferButton
Vault.PurchasePrice = 100 * 100 * 100
Vault.MoneySpacing = -24
Vault.BrokerSpacing = -6
Vault.Bags = {1}


--[[ Startup ]]--

function Vault:New(id)
	local f = self:Super(Vault):New(id)
	f.Deposit = self.ItemGroup:New(f, {2}, DEPOSIT)
	f.Deposit:SetPoint('TOPLEFT', 10, -55)
	f.Deposit:Hide()
	f.Withdraw = self.ItemGroup:New(f, {3}, WITHDRAW)
	f.Withdraw:SetPoint('TOPLEFT', f.Deposit, 'BOTTOMLEFT', 0, -5)
	f.Withdraw:Hide()
	return f
end

function Vault:RegisterSignals()
	self:Super(Vault):RegisterSignals()
	self:RegisterFrameSignal('TRANFER_TOGGLED', 'OnTransfer')
	self:RegisterSignal('VAULT_OPEN', 'OnNPC')
end


--[[ Events ]]--

function Vault:OnNPC()
	IsVoidStorageReady()

	if not CanUseVoidStorage() then
		if COST > GetMoney() then
			Sushi.Popup {
				text = format(L.CannotPurchaseVault, GetMoneyString(self.PurchasePrice, true)),
				button1 = CHAT_LEAVE, button2 = L.AskMafia,
				OnAccept = self.Close, OnCancel = self.Close
			}
		else
			Sushi.Popup {
				text = format(L.PurchaseVault, GetMoneyString(self.PurchasePrice, true)),
				button1 = UNLOCK, button2 = NO,
				OnCancel = self.Close,
				OnAccept = function()
					PlaySound(SOUNDKIT.UI_VOID_STORAGE_UNLOCK)
					UnlockVoidStorage()
				end
			}
		end
	end
end

function Vault:OnTransfer(_, transfering)
	self.Deposit:SetShown(transfering)
	self.Withdraw:SetShown(transfering)
	self.ItemGroup:SetShown(not transfering)

	if transfering then
		Sushi.Popup {
			text = L.ConfirmTransfer, button1 = YES, button2 = NO,
			OnCancel = function() self:SendFrameSignal('TRANFER_TOGGLED') end,
			OnAccept = function()
				ExecuteVoidTransfer()
				self:SendFrameSignal('TRANFER_TOGGLED')
			end
		}
	else
		Sushi.Popup:Cancel(L.ConfirmTransfer)
	end
end

function Vault:OnHide()
	self:Super(Vault):OnHide()
	self:Close()
end


--[[ Properties ]]--

function Vault:GetItemInfo(bag, slot)
	if not self:IsCached() then
		local item = {}
		if bag == 1 then
			item.itemID, item.iconFileID, item.isLocked, _,_, item.quality = GetVoidItemInfo(bag, slot)
		else
			local get = bag == 2 and GetVoidTransferDepositInfo or GetVoidTransferWithdrawalInfo
			for i = 1,9 do
				if get(i) then
					slot = slot - 1
					if slot == 0 then
						item.itemID, item.iconFileID, _,_,_, item.quality = get(i)
						break
					end
				end
			end
		end

		if item.itemID then
			_, item.hyperlink = GetItemInfo(item.itemID) 
		end
		return item
	elseif bag == 1 then
		return self:Super(Vault):GetItemInfo('vault', slot)
	end
end

function Vault:IsCached()
	return not C_PlayerInteractionManager.IsInteractingWithNpcOfType(Enum.PlayerInteractionType.VoidStorageBanker) or self:GetOwner().offline
end

function Vault:Close()
	C_PlayerInteractionManager.ClearInteraction(Enum.PlayerInteractionType.VoidStorageBanker)
end

function Vault:NumSlots(bag)
	return (bag == 1 and 160) or (bag == 2 and GetNumVoidTransferDeposit()) or (bag == 3 and GetNumVoidTransferWithdrawal())
end

function Vault:HasMoney() return true end
function Vault:IsBagGroupShown() end
