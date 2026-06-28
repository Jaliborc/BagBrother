--[[
	Displays the player money stack.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local C = LibStub('C_Everywhere')
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)

local Money = Addon.Tipped:NewClass('PlayerMoney', 'Button')
Money.Gray = LIGHTGRAY_FONT_COLOR:WrapTextInColorCode('%s')
Money.moneyType = 'PLAYER'

local Stroke = CreateFrame('Frame', nil, GameTooltip)
Stroke:SetHeight(5)

local Line = Stroke:CreateLine()
Line:SetStartPoint('LEFT', 0, -5)
Line:SetEndPoint('RIGHT', 0, -5)
Line:SetColorTexture(.3, .3, .3)
Line:SetThickness(1)


--[[ Construct ]]--

function Money:New(parent)
	local b = self:Super(Money):New(parent)
	b:SetNormalFontObject(NumberFontNormal)
	b:SetScript('OnShow', b.RegisterEvents)
	b:SetScript('OnHide', b.UnregisterAll)
	b:RegisterForClicks('anyUp')
	b:SetHeight(24)
	return b
end

function Money:RegisterEvents()
	self:RegisterFrameSignal('OWNER_CHANGED', 'Update')
	self:RegisterEvent('PLAYER_MONEY', 'Update')
	self:Update()
end

function Money:Update()
	self:SetText(GetMoneyString(self:GetMoney(), true))
	self:SetWidth(self:GetTextWidth() + 8)
end


--[[ Interaction ]]--

function Money:OnClick()
	if self:IsCached() then
		return
	end

	self.hasPickup = true
	self:OnLeave()

	local limit = GetMoneyTypeInfoField(self.moneyType, 'UpdateFunc')(self)
	local money = self:GetMoney()
	if money < 100 then
		OpenCoinPickupFrame(1, limit, self)
	elseif money < 10000 then
		OpenCoinPickupFrame(COPPER_PER_SILVER, limit, self)
	else
		OpenCoinPickupFrame(COPPER_PER_GOLD, limit, self)
	end
end

function Money:OnEnter()
	GameTooltip:SetOwner(self:GetTipAnchor())
	GameTooltip:SetText(MONEY, 1,1,1)

	local liquid = {}
	for _, owner in Addon.Owners:Iterate() do
		local money = not owner.isguild and owner:GetMoney()
		if money and money > 0 then
			tinsert(liquid, {owner = owner, money = money})
		end
	end

	sort(liquid, function(a, b)
		return (a.money or 0) > (b.money or 0)
	end)

	local total, overflow = 0, 0
	for i, entry in ipairs(liquid) do
		local owner, money = entry.owner, entry.money or 0
		if i <= 10 or owner.favorite then
			local coins = GetMoneyString(money, true, true)
			local icon = owner:GetIconMarkup(12,0,0)
			local color = owner:GetColor(owner)

			GameTooltip:AddDoubleLine(icon .. ' ' .. owner.name, coins, color.r, color.g, color.b, color.r, color.g, color.b)
		else
			overflow = overflow + money
		end

		total = total + money
	end

	if overflow > 0 then
		GameTooltip:AddDoubleLine('|TInterface/Icons/INV_Misc_QuestionMark:0:0|t '..L.Others, GetMoneyString(overflow, true, true))
	end

	local account = (C.Bank.FetchDepositedMoney or nop)(2) or 0
	if account > 0 then
		GameTooltip:AddDoubleLine('|A:questlog-questtypeicon-account:0:0|a '..ACCOUNT_QUEST_LABEL, GetMoneyString(account, true, true))
	end

	GameTooltip:AddDoubleLine(' ',' ')
	Stroke:SetPoint('TOPRIGHT', 'GameTooltipTextRight'.. GameTooltip:NumLines(), 'TOPRIGHT')
	Stroke:SetPoint('TOPLEFT', 'GameTooltipTextLeft'.. GameTooltip:NumLines(), 'TOPLEFT')
	Stroke:Show()

	GameTooltip:AddDoubleLine(self.Gray:format(TOTAL), self.Gray:format(GetMoneyString(total + account, true)))
	GameTooltip:Show()
end

function Money:OnLeave()
	self:Super(Money):OnLeave()
	Stroke:Hide()
end


--[[ API ]]--

function Money:GetMoney()
	return self:GetOwner():GetMoney() or 0
end

function Money:GetTipAnchor()
	return self, 'ANCHOR_TOP'
end