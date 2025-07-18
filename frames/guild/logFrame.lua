--[[
	itemGroup.lua
		A guild bank tab log messages scrollframe
--]]

local ADDON, Addon = (...):match('[^_]+'), _G[(...):match('[^_]+')]
local Log = Addon.Parented:NewClass('LogFrame', 'ScrollingMessageFrame')

local MESSAGE_PREFIX, _ = '|cff009999   '
local MAX_TRANSACTIONS = 22
local LOG_TYPES = {
	deposit = GUILDBANK_DEPOSIT_FORMAT,
	withdraw = GUILDBANK_WITHDRAW_FORMAT,
	move = GUILDBANK_MOVE_FORMAT,
	deposit = GUILDBANK_DEPOSIT_MONEY_FORMAT,
	withdraw = GUILDBANK_WITHDRAW_MONEY_FORMAT,
	repair = GUILDBANK_REPAIR_MONEY_FORMAT,
	withdrawForTab = GUILDBANK_WITHDRAWFORTAB_MONEY_FORMAT,
	unlockTab = GUILDBANK_UNLOCKTAB_FORMAT,
	depositSummary = GUILDBANK_AWARD_MONEY_SUMMARY_FORMAT,
}


--[[ Construct ]]--

function Log:New(parent)
	local f = self:Super(Log):New(parent)
	f:RegisterFrameSignal('LOG_SELECTED', 'OnLogSelected')
	f:SetFontObject(GameFontHighlight)
	f:SetMaxLines(MAX_TRANSACTIONS)
	f:SetJustifyH('LEFT')
	f:SetFading(false)
	f:EnableMouse(true)
	return f
end


--[[ Events ]]--

function Log:OnLogSelected(logID)
	if logID == 1 or logID == 2 then
		self.isMoney = logID == 2
		self:RegisterEvent('GUILDBANKLOG_UPDATE', 'UpdateContent')
		self:RegisterSignal('GUILD_TAB_CHANGED', 'Update')
		self:Update()
	else
		self:UnregisterEvent('GUILDBANKLOG_UPDATE')
		self:UnregisterSignal('GUILD_TAB_CHANGED')
	end
end

function Log:OnMouseWheel(delta)
	if delta > 0 then
		self:ScrollUp()
	else
		self:ScrollDown()
	end
end

function Log:OnHyperlinkClick(...)
	SetItemRef(...)
end


--[[ Update ]]--

function Log:Update()
	if self.isMoney then
		QueryGuildBankLog(MAX_GUILDBANK_TABS + 1)
	else
		QueryGuildBankLog(GetCurrentGuildBankTab())
	end

	self:UpdateContent()
end

function Log:UpdateContent()
	self.numTransactions = self.isMoney and GetNumGuildBankMoneyTransactions() or GetNumGuildBankTransactions(GetCurrentGuildBankTab())
	self:Clear()

	if self.isMoney then
		self:PrintMoney()
	else
		self:PrintTransactions()
	end

	self:ScrollToBottom()
end


--[[ Write ]]--

function Log:PrintTransactions()
	for i = 1, self.numTransactions do 
		local type, name, itemLink, count, tab1, tab2, year, month, day, hour = self:ProcessLine(GetGuildBankTransaction(GetCurrentGuildBankTab(), i))
		local msg

		if type == 'deposit' then
			msg = format(GUILDBANK_DEPOSIT_FORMAT, name, itemLink)
			if count > 1 then
				msg = msg..format(GUILDBANK_LOG_QUANTITY, count)
			end
		elseif type == 'withdraw' then
			msg = format(GUILDBANK_WITHDRAW_FORMAT, name, itemLink)
			if count > 1 then
				msg = msg .. format(GUILDBANK_LOG_QUANTITY, count)
			end
		elseif type == 'move' then
			msg = format(GUILDBANK_MOVE_FORMAT, name, itemLink, count, GetGuildBankTabInfo(tab1), GetGuildBankTabInfo(tab2))
		end

		self:AddLine(msg, year, month, day, hour)
	end
end

function Log:PrintMoney()
	for i = 1, self.numTransactions do
		local type, name, amount, year, month, day, hour = self:ProcessLine(GetGuildBankMoneyTransaction(i))
		local money = GetDenominationsFromCopper(amount)

		if type == 'buyTab' then
			msg = amount > 0 and GUILDBANK_BUYTAB_MONEY_FORMAT:format(name, money) or GUILDBANK_UNLOCKTAB_FORMAT:format(name)
		else
			msg = LOG_TYPES[type]:format(name, money)
		end

		self:AddLine(msg, year, month, day, hour)
	end
end

function Log:AddLine(msg, ...)
	if msg then
		self:AddMessage(msg .. MESSAGE_PREFIX .. format(GUILD_BANK_LOG_TIME, RecentTimeDate(...)))
	end
end

function Log:ProcessLine(type, name, ...)
	return type, NORMAL_FONT_COLOR_CODE .. (name or UNKNOWN) .. FONT_COLOR_CODE_CLOSE, ...
end
