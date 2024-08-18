--[[
	bank.lua
		A specialized version of the window frame for the bank
--]]

local ADDON, Addon = ...
local Sushi = LibStub('Sushi-3.2')
local C = LibStub('C_Everywhere')

local Bank = Addon.Frame:NewClass('Bank')
Bank.Title = LibStub('AceLocale-3.0'):GetLocale(ADDON).TitleBank
Bank.MoneyFrame = Addon.AccountMoney
Bank.Bags = Addon.BankBags

for _,k in ipairs {'ItemGroup', 'PickupItem', 'GetItemInfo', 'GetBagFamily', 'NumSlots'} do
	Bank[k] = Addon.Inventory[k]
end

function Bank:OnHide()
	self:Super(Bank):OnHide()
	Sushi.Popup:Cancel(CONFIRM_BUY_BANK_SLOT)
	Sushi.Popup:Cancel(CONFIRM_BUY_REAGENTBANK_TAB)
	Sushi.Popup:Cancel(CONFIRM_BUY_ACCOUNT_BANK_TAB)

	if Addon.BankTab then
		Addon.BankTab.Settings:Hide()
	end
	
	C.Bank.CloseBankFrame()
end

function Bank:SortItems()
	if Addon.sets.serverSort and C.Container.SortBankBags then
		local API = {'SortAccountBankBags', 'SortReagentBankBags', 'SortBankBags'}
		local function queue()
			local sort = C_Container[tremove(API)]
			if sort then
				EventUtil.RegisterOnceFrameEventAndCallback('ITEM_UNLOCKED', function() C_Timer.After(0, queue) end)
				sort()
			else
				self:SendSignal('SORTING_STATUS')
			end
		end

		queue() -- callback chain
	else
		self:Super(Bank):SortItems()
	end
end

function Bank:GetExtraButtons()
	return {
		self.profile.bagToggle and self:Get('BagToggle', function() return Addon.BagToggle(self) end),
		DepositReagentBank and self.profile.reagents and self:Get('ReagentButton', function() return Addon.ReagentButton(self) end)
	}
end

function Bank:IsCached()
	return not Addon.Events.AtBank or self:GetOwner().offline
end
	