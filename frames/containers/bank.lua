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

if REAGENTBANK_CONTAINER then
	function Bank:IsShowingBag(bag)
		local profile = self:GetProfile()
		if not profile.exclusiveReagent or bag == REAGENTBANK_CONTAINER or profile.hiddenBags[REAGENTBANK_CONTAINER] then
			return not profile.hiddenBags[bag]
		end
	end
end

function Bank:IsCached()
	return not Addon.Events.AtBank or self:GetOwner().offline
end