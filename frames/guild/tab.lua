--[[
	tab.lua
		A guild tab button object
--]]

local MODULE = ...
local ADDON, Addon = MODULE:match('[^_]+'), _G[MODULE:match('[^_]+')]
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)

local TabGroup = Addon.BagGroup:NewClass('GuildTabGroup')
local Tab = Addon.Bag:NewClass('GuildTab')
Tab.QuestionMark = 'Interface\\Icons\\INV_Misc_QuestionMark'
TabGroup.Button = Tab

do
	local popup = BagBrotherGuildTabEditPopup
	popup.InfoHeaderText:SetText(L.EnterDescription)
	popup.IconSelector:SetSelectedCallback(function(_, icon) popup.BorderBox.SelectedIconArea.SelectedIconButton:SetIconTexture(icon) end)
	popup:ClearAllPoints()
	popup.OkayButton_OnClick = function()
		local text = popup.BorderBox.IconSelectorEditBox:GetText()
		text = text and text ~= '' and string.gsub(text, '\"', '') or format(GUILDBANK_TAB_NUMBER, popup.tab)

		IconSelectorPopupFrameTemplateMixin.OkayButton_OnClick(popup)
		SetGuildBankText(popup.tab, popup.Info.ScrollFrame.EditBox:GetText())
		SetGuildBankTabInfo(popup.tab, text, popup.BorderBox.SelectedIconArea.SelectedIconButton:GetIconTexture())
		PlaySound(SOUNDKIT.GS_TITLE_OPTION_OK)
	end

	popup.OnHide = function()
		IconSelectorPopupFrameTemplateMixin.OnHide(popup)
		popup.iconDataProvider:Release()
	end

	Tab.EditPopup = popup
end


--[[ Events ]]--

function Tab:New(...)
	local tab = self:Super(Tab):New(...)
	tab:SetScript('OnReceiveDrag', nil)
	tab:SetScript('OnDragStart', nil)
	return tab
end

function Tab:OnClick(button)
	local info = self:GetInfo()
	if self:CanPurchase() then
		LibStub('Sushi-3.2').Popup {
			text = CONFIRM_BUY_GUILDBANK_TAB, button1 = YES, button2 = NO,
			money = GetGuildBankTabCost(),
			OnAccept = BuyGuildBankTab
		}
	elseif button == 'LeftButton' then
		if info.viewable or self:IsCached() then
			SetCurrentGuildBankTab(self:GetID())
			return self:SendSignal('GUILD_TAB_CHANGED')
		end
	elseif self:CanEdit() then
		local tab, popup = self:GetID(), self.EditPopup
		local provider = CreateAndInitFromMixin(IconDataProviderMixin, IconDataProviderExtraType.None)
		local name, texture = GetGuildBankTabInfo(tab)

		popup.tab, popup.iconDataProvider = tab, provider
		popup.IconSelector:SetSelectionsDataProvider(
			GenerateClosure(provider.GetIconByIndex, provider), GenerateClosure(provider.GetNumIcons, provider))

		popup.BorderBox.IconSelectorEditBox:SetText(name)
		popup.BorderBox.IconSelectorEditBox:HighlightText()
		popup.BorderBox.SelectedIconArea.SelectedIconButton:SetIconTexture(texture)
		popup.IconSelector:SetSelectedIndex(texture and texture ~= self.QuestionMark and popup:GetIndexOfIcon(texture) or 1)
		popup.IconSelector:ScrollToSelectedIndex()
		popup.Info.ScrollFrame.EditBox:SetText(GetGuildBankText(tab))
		popup:SetPoint('LEFT', self.frame, 'RIGHT', 5,0)
		popup:Show()
	end

	self:SetChecked(self:IsActive())
end


--[[ Update ]]--

function Tab:RegisterEvents()
	self:UnregisterAll()
	self:Update()

	if self:IsCached() then
		self:RegisterSignal('GUILD_OPEN', 'RegisterEvents')
		self:RegisterSignal('GUILD_TAB_CHANGED', 'UpdateStatus')
	else
		self:RegisterSignal('GUILD_CLOSE', 'RegisterEvents')
		self:RegisterEvent('GUILDBANK_UPDATE_TABS', 'Update')
		self:RegisterEvent('GUILDBANKBAGSLOTS_CHANGED', 'UpdateStatus')
	end
end

function Tab:Update()
	local info = self:GetInfo()
	local plus = self:CanPurchase()

	if info.icon then
		local enabled = info.viewable or self:IsCached()
		local color = enabled and 1 or 0.1

		self.Icon:SetTexture(tonumber(info.icon) or info.icon)
		self.Icon:SetVertexColor(1, color, color)
		self.Icon:SetDesaturated(not enabled)
		self:UpdateStatus()
	elseif plus then
		self.Icon:SetTexture(132071)
		self.Icon:SetVertexColor(1,1,1)
		self.Icon:SetDesaturated(false)
	end

	self:EnableMouse(info.icon or plus)
	self:SetAlpha((info.icon or plus) and 1 or 0)
end

function Tab:UpdateStatus()
	local live, active = not self:IsCached(), self:IsActive()
	local info = self:GetInfo()

	self.remaining = live and active and select(6, GetGuildBankTabInfo(self:GetID())) or self.remaining -- Blizzard API is bugged
	self.Count:SetText(live and info.viewable and self.remaining and (self.remaining >= 0 and self.remaining or '∞') or '')
	self:SetChecked(active)
end

function Tab:UpdateTooltip()
	local info = self:GetInfo()
	if info.name then
		GameTooltip:SetText(info.name, 1,1,1)

		local text = strtrim(GetGuildBankText(self:GetID()))
		if text ~= '' then
			GameTooltip:AddLine('"' .. text .. '"', _,_,_, true)
		else
			QueryGuildBankText(self:GetID())
		end 

		if not self:IsCached() then
			local withdraw, remaining = info.withdraw, self.remaining
			local permission = (not info.viewable or not info.deposit and withdraw == 0) and GUILDBANK_TAB_LOCKED or
							   (not info.deposit and withdraw and withdraw > 0) and GUILDBANK_TAB_WITHDRAW_ONLY or
							   withdraw == 0 and GUILDBANK_TAB_DEPOSIT_ONLY or
							   withdraw and GUILDBANK_TAB_FULL_ACCESS
							  
			if permission then
				if info.viewable and (withdraw or 0) > 0 and remaining and remaining >= 0 then
					GameTooltip:AddDoubleLine(permission:gsub('[\(\)]', ''), L.NumRemaining:format(remaining > 0 and remaining or NONE), _,_,_, HIGHLIGHT_FONT_COLOR:GetRGB())
				else
					GameTooltip:AddLine(permission:gsub('[\(\)]', ''))
				end
			end
		end

		GameTooltip:Show()
	elseif self:CanPurchase() then
		GameTooltip:SetText(BUY_GUILDBANK_TAB, 1,1,1)
		GameTooltip:AddLine(GetMoneyString(GetGuildBankTabCost(), true))
		GameTooltip:Show()
	end
end


--[[ Properties ]]--

function Tab:GetInfo()
	if self:IsCached() then
		return self:GetOwner()[self:GetID()] or Addon.None
	else
		local name, icon, viewable, deposit, withdraw = GetGuildBankTabInfo(self:GetID())
		return {name = name, icon = icon, viewable = viewable, deposit = deposit, withdraw = withdraw}
	end
end

function Tab:CanPurchase()
	return IsGuildLeader() and not self:IsCached() and self:GetID() <= MAX_BUY_GUILDBANK_TABS and self:GetID() == (GetNumGuildBankTabs()+1)
end

function Tab:CanEdit()
	return CanEditGuildBankTabInfo(self:GetID()) and not self:IsCached()
end

function Tab:IsActive()
	return self:GetID() == GetCurrentGuildBankTab()
end