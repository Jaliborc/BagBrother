--[[
	Displays the player money stack.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local C = LibStub('C_Everywhere')
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)

local Money = Addon.Tipped:NewClass('PlayerMoney', 'Button', 'SmallMoneyFrameTemplate', true)
Money.Gray = LIGHTGRAY_FONT_COLOR:WrapTextInColorCode('%s')
Money.Type = 'PLAYER'

local Stroke = CreateFrame('Frame', nil, GameTooltip)
Stroke:SetHeight(5)

local Line = Stroke:CreateLine()
Line:SetStartPoint('LEFT', 0, -5)
Line:SetEndPoint('RIGHT', 0, -5)
Line:SetColorTexture(.3, .3, .3)
Line:SetThickness(1)


--[[ Construct ]]--

function Money:New(parent)
	local f = self:Super(Money):New(parent)
	f:SetScript('OnShow', f.RegisterEvents)
	f:SetScript('OnHide', f.UnregisterAll)
	return f
end

function Money:Construct()
	local f = self:Super(Money):Construct()
	f.trialErrorButton:SetPoint('LEFT', -14, 0)
	f:SetScript('OnShow', f.RegisterEvents)
	f:SetScript('OnHide', f.UnregisterAll)
	f:SetScript('OnEvent', nil)

	local overlay = CreateFrame('Button', nil, f)
	overlay:SetScript('OnClick', function(_,...) f:OnClick(...) end)
	overlay:SetScript('OnEnter', function() f:OnEnter() end)
	overlay:SetScript('OnLeave', function() f:OnLeave() end)
	overlay:SetFrameLevel(f:GetFrameLevel() + 4)
	overlay:RegisterForClicks('anyUp')
	overlay:SetAllPoints()

	MoneyFrame_SetType(f, f.Type)
	f.overlay = overlay
	return f
end

function Money:RegisterEvents()
	self:RegisterFrameSignal('OWNER_CHANGED', 'Update')
	self:RegisterEvent('PLAYER_MONEY', 'Update')
	self:Update()
end

function Money:Update()
	local money = self:GetMoney()
	MoneyFrame_Update(self:GetName(), money, money == 0)
	self:SetHeight(24)
end


--[[ Interaction ]]--

function Money:OnClick()
	if self:IsCached() then
		return
	end

	local name = self:GetName()
	if MouseIsOver(_G[name .. 'GoldButton']) then
		OpenCoinPickupFrame(COPPER_PER_GOLD, self.info.UpdateFunc(self), self)
		self.hasPickup = 1
	elseif MouseIsOver(_G[name .. 'SilverButton']) then
		OpenCoinPickupFrame(COPPER_PER_SILVER, self.info.UpdateFunc(self), self)
		self.hasPickup = 1
	elseif MouseIsOver(_G[name .. 'CopperButton']) then
		OpenCoinPickupFrame(1, self.info.UpdateFunc(self), self)
		self.hasPickup = 1
	end

	self:OnLeave()
end

function Money:OnEnter()
	GameTooltip:SetOwner(self:GetTipAnchor())
	GameTooltip:SetText(MONEY, 1,1,1)

	local liquid = {}
	for _, owner in Addon.Owners:Iterate() do
		local money = not owner.isguild and owner:GetMoney()
		if money and money > 0 then
			tinsert(liquid, {owner: owner, money: money})
		end
	end

	sort(liquid, function(a, b)
		return a.money > b.money
	end)

	local total, overflow = 0, 0
	for _, entry in ipairs(liquid) do
		local owner, money = entry.onwer, entry.money
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

	GameTooltip:AddDoubleLine(self.Gray:format(TOTAL), self.Gray:format(GetMoneyString(total + account, true)))
	GameTooltip:Show()
end


--[[ API ]]--

function Money:GetMoney()
	return self:GetOwner():GetMoney() or 0
end

function Money:GetTipAnchor()
	return self, 'ANCHOR_TOP'
end