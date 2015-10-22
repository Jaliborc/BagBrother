--[[
Copyright 2011-2015 João Cardoso
BagBrother is distributed under the terms of the GNU General Public License (Version 3).
As a special exception, the copyright holders of this addon do not give permission to
redistribute and/or modify it.

This addon is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with the addon. If not, see <http://www.gnu.org/licenses/gpl-3.0.txt>.

This file is part of BagBrother.
--]]


function BagBrother:SaveBag(bag, onlyItems)
	local size = GetContainerNumSlots(bag)
	if size > 0 then
		local items = {}
		for slot = 1, size do
			local _, count, _,_,_,_, link = GetContainerItemInfo(bag, slot)
			items[slot] = self:ParseItem(link, count)
		end

		if not onlyItems then
			self:SaveEquip(ContainerIDToInventoryID(bag), size)
		end

		self.Player[bag] = items
	else
		self.Player[bag] = nil
	end
end

function BagBrother:SaveEquip(i, count)
	local link = GetInventoryItemLink('player', i)
	local count = count or GetInventoryItemCount('player', i)

	self.Player.equip[i] = self:ParseItem(link, count)
end

function BagBrother:ParseItem(link, count)
	if link then
	-- begin hotfix profession window
	local itemId = tonumber(string.match(link, "item:(%d+):"))	-- get itemID // itemID seems to be "0" for every reagent in profession window?!
		if (itemId == 0 and TradeSkillFrame ~= nil and TradeSkillFrame:IsVisible()) then -- some other frames show ID = 0 aswell, so limit this workaround to the profession window || IMPORTANT: TradeSkillFrame ~= nil has to be checked BEFORE TradeSkillFrame:IsVisible()
			local newItemId
			if ((GetMouseFocus():GetName()) == "TradeSkillSkillIcon") then 			--replace TradeSkill
				newItemId = tonumber(GetTradeSkillItemLink(TradeSkillFrame.selectedSkill):match("item:(%d+):"))
			else 		-- could check if a reagent is under mouse, but since we have to check it 3 lines later again...
				for i = 1, 12 do 													-- how many reagents can a reciepe have? lets assume not more than 12
					if ((GetMouseFocus():GetName()) == "TradeSkillReagent"..i) then 	--replace TradeSkillReagents
						newItemId = tonumber(GetTradeSkillReagentItemLink(TradeSkillFrame.selectedSkill, i):match("item:(%d+):"))
						break 			--end loop if correct one already found
					end
				end
			end
			_, link = GetItemInfo(newItemId) -- replace original link with our found link
		end
		-- end hotfix profession window
		if link:find('0:0:0:0:0:%d+:%d+:%d+:0:0') then
			link = link:match('|H%l+:(%d+)')
		else
			link = link:match('|H%l+:([%d:]+)')
		end
		
		if count and count > 1 then
			link = link .. ';' .. count
		end

		return link
	end
end