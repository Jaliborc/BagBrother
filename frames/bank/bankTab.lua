--[[
	A bag on the bank frame (called tabs on retail).
	All Rights Reserved
--]]

local ADDON, Addon = (...):match('%w+'), _G[(...):match('%w+')]
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local C = LibStub('C_Everywhere').Bank
local Sushi = LibStub('Sushi-3.2')

local Bag = Addon.Bag:NewClass('BankBag', 'CheckButton')
Bag.Settings = CreateFrame('Frame', nil, nil, C.WithdrawMoney and 'BankPanelTabSettingsMenuTemplate')
Bag.Settings:Hide()
Bag.Proxies = {
	generic = BankPanel and BankPanel.PurchasePrompt.TabCostFrame.PurchaseButton,
	account = AccountBankPanel and AccountBankPanel.PurchasePrompt.TabCostFrame.PurchaseButton,
	reagents = ReagentBankFrameUnlockInfoPurchaseButton,
	player = BankFramePurchaseButton}

for name, frame in pairs(Bag.Proxies) do
	if frame then
		frame:SetScript('OnEnter', function(self) self:GetParent():Super(Bag):OnEnter() end)
		frame:SetScript('OnLeave', function(self) self:GetParent():OnLeave() end)
		frame:SetAlpha(0)
	end
end


--[[ Startup ]]--

function Bag:RegisterEvents()
	self:Update()
	self:UnregisterAll()
	self:RegisterFrameSignal('FILTERS_CHANGED', 'UpdateToggle')
	self:RegisterFrameSignal('OWNER_CHANGED', 'RegisterEvents')
	self:RegisterSignal('BANK_CLOSE', 'RegisterEvents')
	self:RegisterSignal('BANK_OPEN', 'RegisterEvents')

	if not self:IsCached() then
		if NUM_BANKBAGSLOTS and self.slot then
			self:RegisterEvent('PLAYERBANKBAGSLOTS_CHANGED', 'Update')
		elseif self:GetID() == REAGENTBANK_CONTAINER then
			self:RegisterEvent('REAGENTBANK_PURCHASED', 'Update')
		elseif C.FetchPurchasedBankTabData then
			self:RegisterEvent('BANK_TAB_SETTINGS_UPDATED', 'Update')
			self:RegisterEvent('BANK_TABS_CHANGED', 'Update')
		end
	end
end

function Bag:UpdateInfo()
	local id, type = self:GetID(), self:GetType()
	if NUM_BANKBAGSLOTS and type == 0 then
		self:Super(Bag):UpdateInfo()

		if id == REAGENTBANK_CONTAINER then
			if self:IsCached() then
				self.owned = self.frame:GetBagInfo(id) and true
			else
				self.owned = IsReagentBankUnlocked()
			end
		end
	else
		local info = (not self:IsCached() and
			FindValueInTableIf(C.FetchPurchasedBankTabData(type), function(data) return data.ID == id end) or
			self.frame:GetBagInfo(id)) or Addon.None

		self.icon, self.name, self.flags = info.icon, info.name, info.depositFlags
		self.owned = info.name ~= nil
	end
end


--[[ Tooltip ]]--

function Bag:OnEnter()
	if self.owned then
		self:Super(Bag):OnEnter()
	else
		local secure = self.Proxies.generic or
					   self:GetID() == REAGENTBANK_CONTAINER and self.Proxies.reagents or
					   self:GetType() == 0 and self.Proxies.player or self.Proxies.account

		secure:SetAttribute('overrideBankType', self:GetType())
		secure:SetAllPoints(self)
		secure:SetParent(self)

		if BankFrame then
			BankFrame.nextSlotCost = self:GetCost()
		end
	end
end

function Bag:UpdateTooltip()
	if not self.name then
		self:Super(Bag):UpdateTooltip()
	else
		GameTooltip:ClearLines()
		GameTooltip:SetText((self:IsAccountBag() and '|A:questlog-questtypeicon-account:0:0|a ' or '') .. (self.name or BANK_BAG_PURCHASE), 1, 1, 1)

		if FlagsUtil.IsSet(self.flags, Enum.BagSlotFlags.ExpansionCurrent) then
			GameTooltip:AddLine(BANK_TAB_EXPANSION_ASSIGNMENT:format(BANK_TAB_EXPANSION_FILTER_CURRENT))
		elseif FlagsUtil.IsSet(self.flags, Enum.BagSlotFlags.ExpansionLegacy) then
			GameTooltip:AddLine(BANK_TAB_EXPANSION_ASSIGNMENT:format(BANK_TAB_EXPANSION_FILTER_LEGACY))
		end

		local filters = ContainerFrameUtil_ConvertFilterFlagsToList(depositFlags)
		if filters then
			GameTooltip:AddLine(BANK_TAB_DEPOSIT_ASSIGNMENTS:format(filters), true)
		end

		GameTooltip:AddLine(self:GetChecked() and L.HideBag or L.ShowBag)
		GameTooltip:Show()
	end
end


--[[ Menu ]]--

function Bag:ShowMenu()
	if not self.name then
		self:Super(Bag):ShowMenu()
	else
		self.Settings:SetParent(self.frame)
		self.Settings:SetPoint('TOPLEFT', self.frame, 'TOPRIGHT')
		self.Settings:TriggerEvent(BankPanelTabSettingsMenuMixin.Event.OpenTabSettingsRequested, self:GetID())
	end
end

function Bag.Settings:SetSelectedTab(id)
	local data = C.FetchPurchasedBankTabData(2)
	self.selectedTabData = data[id - Addon.LastBankBag]

	if self:IsShown() then
		self:Update()
	end
end


--[[ API ]]--

function Bag:GetCost()
	if self:GetID() ~= REAGENTBANK_CONTAINER then
		return C.FetchNextPurchasableBankTabData(self:GetType()).tabCost
	end
	return GetReagentBankCost()
end

function Bag:GetType() return self:IsAccountBag() and 2 or 0 end
function Bag:IsAccountBag() return self:GetID() > Addon.LastBankBag end
function Bag:IsBankBag() return true end