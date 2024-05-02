--[[
	bank.lua
		A specialized version of the window frame for the bank
--]]

local ADDON, Addon = ...
local C = LibStub('C_Everywhere').Container
local Bank = Addon.Frame:NewClass('Bank')
Bank.Title = LibStub('AceLocale-3.0'):GetLocale(ADDON).TitleBank
Bank.Bags = Addon.BankBags

for _,k in ipairs {'ItemGroup', 'PickupItem', 'GetItemInfo', 'GetBagFamily', 'NumSlots'} do
	Bank[k] = Addon.Inventory[k]
end

function Bank:OnHide()
	self:Super(Bank):OnHide()
	LibStub('Sushi-3.2').Popup:Cancel(CONFIRM_BUY_REAGENTBANK_TAB)
	LibStub('Sushi-3.2').Popup:Cancel(CONFIRM_BUY_BANK_SLOT)
	CloseBankFrame()
end

function Bank:SortItems()
	if Addon.sets.serverSort and C.SortBankBags then
		C.SortBankBags()

		if REAGENTBANK_CONTAINER then
			C_Timer.After(0.3, function()
				C.SortReagentBankBags()
				self:SendSignal('SORTING_STATUS')
			end)
		end
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
	