--[[
	A specialized version of the window frame for the bank
	All Rights Reserved
--]]

local ADDON, Addon = (...):match('%w+'), _G[(...):match('%w+')]
local Sushi = LibStub('Sushi-3.2')
local C = LibStub('C_Everywhere')

local Bank = Addon.Frame:NewClass('Bank')
Bank.Title = LibStub('AceLocale-3.0'):GetLocale(ADDON).TitleBank
Bank.MoneyFrame = Addon.AccountMoney
Bank.BagButton = Addon.BankBag
Bank.Bags = Addon.BankBags

for _,k in ipairs {'ItemGroup', 'PickupItem', 'GetItemInfo', 'GetItemQuery', 'GetBagFamily', 'NumSlots'} do
	Bank[k] = Addon.Inventory[k]
end


--[[ General API  ]]--

function Bank:OnShow()
	self:Super(Bank):OnShow()
	self:RegisterFrameSignal('FILTERS_CHANGED', 'UpdateBankType')
	self:UpdateBankType()
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

function Bank:GetExtraButtons()
	return {
		self.profile.bagToggle and self:GetWidget('BagToggle'),
		Addon.DepositButton and self.profile.deposit and self:GetWidget('DepositButton')
	}
end

do
	local sortAPI = C.Container.SortReagentBankBags and {C.Container.SortReagentBankBags, C.Container.SortBankBags} or 
					C.Container.SortBank and {GenerateClosure(C.Container.SortBank, 2), GenerateClosure(C.Container.SortBank, 0)}

	if sortAPI then
		function Bank:ServerSort()
			local calls = CopyTable(sortAPI)
			local function queue()
				local sort = tremove(calls)
				if sort then
					self:ContinueOn('ITEM_UNLOCKED', function() RunNextFrame(queue) end)
					sort()
				else
					self:SendSignal('SORTING_STATUS')
				end
			end

			PlaySound(SOUNDKIT.UI_BAG_SORTING_01)
			queue() -- callback chain
		end
	end
end


--[[ Warband Support ]]--

function Bank:UpdateBankType()
	if not C.Bank.CanUseBank(2) then
		return Addon_SetBankType(0)
	elseif not C.Bank.CanUseBank(0) then
		return Addon_SetBankType(2)
	end

	for set, rule in pairs(self.rules) do
		local type = rule.data.bankType
		if type and self.profile[set] then
			return Addon_SetBankType(type)
		end
	end
	
	Addon_SetBankType(0)
end

function Bank:GetBagInfo(bag)
	local owner = bag > Addon.LastBankBag and BrotherBags.account or self:GetOwner()
	return owner[bag]
end

function Bank:IsCached(bag)
	if not Addon.Events.AtBank then
		return true
	elseif bag then
		if bag <= Addon.LastBankBag then
			return self:GetOwner().offline or not C.Bank.CanViewBank(0)
		else
			return not C.Bank.CanViewBank(2)
		end
	end
end