--[[
	Forcefully replaces Blizzard logic for money lines on tooltips, because using MoneyFrame taints the whole game.
	Directly based on `GameTooltip_OnTooltipAddMoney`, no rights reserved.
--]]

if TooltipDataProcessor then
	TooltipDataProcessor.AddLinePreCall(Enum.TooltipDataLineType.SellPrice, function(tip, data)
			if data.price and not tip.isShopping then
				if data.maxPrice and data.maxPrice >= 1 then
					tip:AddLine(format('%s:', SELL_PRICE), 1,1,1, true)
					tip:AddLine(format('    %s: %s', MINIMUM, GetMoneyString(data.price, true)), 1,1,1, true)
					tip:AddLine(format('    %s: %s', MAXIMUM, GetMoneyString(data.maxPrice, true)), 1,1,1, true)
				else
					tip:AddLine(format('%s: %s', SELL_PRICE, GetMoneyString(data.price, true)), 1,1,1, true)
				end
				return true
			end
		end)
	end
end