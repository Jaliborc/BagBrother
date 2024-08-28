--[[
	bankTab.lua
		A modified bag button because that seemed simpler to implement.
--]]


if not (C_Bank and C_Bank.FetchPurchasedBankTabData) then
	return
end

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Tab = Addon.Bag:NewClass('BankTab', 'CheckButton')
Tab.Settings = CreateFrame('Frame', nil, nil, 'BankPanelTabSettingsMenuTemplate')
Tab.Settings:Hide()


--[[ Interaction ]]

function Tab:OnDrag() end
function Tab:OnClick(button)
	if self.name then
		if button == 'RightButton' then
			self.Settings:SetParent(self.frame)
			self.Settings:SetPoint('TOPLEFT', self.frame, 'TOPRIGHT')
			self.Settings:TriggerEvent(BankPanelTabSettingsMenuMixin.Event.OpenTabSettingsRequested, self:GetID())
		else
			self:Toggle()
		end
	elseif not self:IsCached() then
		LibStub('Sushi-3.2').Popup {
			text = CONFIRM_BUY_ACCOUNT_BANK_TAB, button1 = YES, button2 = NO,
			money = C_Bank.FetchNextPurchasableBankTabCost(2),
			OnAccept = function() C_Bank.PurchaseBankTab(2) end,
		}
	end

	self:UpdateToggle()
end

function Tab.Settings:SetSelectedTab(id)
	local data = C_Bank.FetchPurchasedBankTabData(2)
	self.selectedTabData = data[id - Addon.LastBankBag]

	if self:IsShown() then
		self:Update()
	end
end


--[[ Update ]]--

function Tab:RegisterEvents()
	self:Update()
	self:UnregisterAll()
	self:RegisterFrameSignal('FILTERS_CHANGED', 'UpdateToggle')
	self:RegisterFrameSignal('OWNER_CHANGED', 'RegisterEvents')
	self:RegisterSignal('BANK_CLOSE', 'RegisterEvents')
	self:RegisterSignal('BANK_OPEN', 'RegisterEvents')

	if C_Bank.CanViewBank(2) then
		self:RegisterEvent('BANK_TAB_SETTINGS_UPDATED', 'Update')
		self:RegisterEvent('BANK_TABS_CHANGED', 'Update')
	end
end

function Tab:Update()
    local data = C_Bank.CanViewBank(2) and C_Bank.FetchPurchasedBankTabData(2) or BrotherBags.account
    local info = data[self:GetID() - Addon.LastBankBag]

	local color = info and 1 or 0.1
	SetItemButtonTexture(self, info and info.icon or 'interface/paperdoll/ui-paperdoll-slot-bag')
	SetItemButtonTextureVertexColor(self, 1, color, color)

	self.name, self.flags = info and info.name, info and info.depositFlags
    self.FilterIcon.Icon:SetAtlas(nil)
	self.Count:SetText('')
	self:UpdateToggle()
	self:UpdateLock()
end

function Tab:UpdateTooltip()
	GameTooltip:ClearLines()
	GameTooltip:SetText('|A:warbands-icon:0:0:0:0|a ' .. (self.name or BANK_BAG_PURCHASE), 1, 1, 1)

	if self.name then
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
	else
		SetTooltipMoney(GameTooltip, C_Bank.FetchNextPurchasableBankTabCost(2))
	end

	GameTooltip:Show()
end