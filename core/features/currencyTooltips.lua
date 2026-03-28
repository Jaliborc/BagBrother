--[[
	Adds counts to currency tooltips and reorganizes meta info for better readability.
	All Rights Reserved
]]--

local ADDON, Addon = ...
local C = LibStub('C_Everywhere').CurrencyInfo
local TipCounts = Addon:NewModule('CurrencyTooltipCounts')

local SILVER = '|cffc7c7cf%s|r'
local WEEKLY = CURRENCY_WEEKLY_CAP:match('[^:]+')
local MAXIMUM = CURRENCY_TOTAL_CAP:match('[^:]+')


--[[ Startup ]]--

function TipCounts:OnLoad()
	if Addon.sets.countCurrency then
		if C_TooltipInfo then
			TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Currency,  self.OnCurrency)
		else
			for _,frame in pairs {UIParent:GetChildren()} do
				if not frame:IsForbidden() and frame:GetObjectType() == 'GameTooltip' then
					hooksecurefunc(frame, 'SetBackpackToken', self.OnTracked)
					hooksecurefunc(frame, 'SetCurrencyTokenByID', self.OnID)
				end
			end
		end

		self:UnregisterSignal('UPDATE_ALL')
	else
		self:RegisterSignal('UPDATE_ALL', 'OnLoad')
	end
end


--[[ Events ]]--

function TipCounts.OnCurrency(tip)
    local data = tip:GetPrimaryTooltipData()
    local id = data and data.id

    if id then
        TipCounts.OnID(tip, id)
    end
end

function TipCounts.OnTracked(tip, index)
    TipCounts.OnID(tip, C.GetBackpackCurrencyInfo(index).currencyTypesID)
end

local function CleanTotalLine(tip)
	local data = tip:GetTooltipData()
	if not data or not data.lines then return end

	for i = #data.lines, 1, -1 do
		local lineText = data.lines[i].leftText
		if lineText and lineText:find(TOTAL) then
			local fontString = _G['GameTooltipTextLeft'..i]
			if fontString then
				fontString:SetText('')
			end
			if i > 1 then
				local prevText = data.lines[i-1].leftText
				if prevText and prevText:match('^%s*$') then
					local prevFontString = _G['GameTooltipTextLeft'..(i-1)]
					if prevFontString then
						prevFontString:SetText('')
					end
				end
			end
			break
		end
	end
end

function TipCounts.OnID(tip, id)
	if Addon.sets.countCurrency and not C.IsAccountWideCurrency(id) then
		CleanTotalLine(tip)

		local info = C.GetCurrencyInfo(id)
		local left, right = {}, {}
		local total = 0

		for i, owner in Addon.Owners:Iterate() do
			local count
			if owner.offline then
				count = owner.currency and owner.currency[id]
			elseif not owner.isguild then
				count = info.quantity
			end

			if count and count > 0 then
				local color = owner:GetColorMarkup()
				total = total + count
			
				tinsert(left, owner:GetIconMarkup(12,0,0) ..' '.. color:format(owner.name))
				tinsert(right, color:format(FormatLargeNumber(count)))
			end
		end

		if info.isAccountTransferable and total > 0 then
			tip:AddLine(format('|n%s: |cffffffff%s|r', TOTAL, FormatLargeNumber(total)))
		end

		for i, who in ipairs(left) do
			tip:AddDoubleLine(who, right[i])
		end

		if info.maxWeeklyQuantity > 0 then
			tip:AddDoubleLine(SILVER:format(WEEKLY), SILVER:format(FormatLargeNumber(info.maxWeeklyQuantity)))
		end
		if info.maxQuantity > 0 then
			tip:AddDoubleLine(SILVER:format(MAXIMUM), SILVER:format(FormatLargeNumber(info.maxQuantity)))
		end

		tip:Show()
	end
end