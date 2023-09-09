--[[
	itemTooltips.lua
		Adds item counts to tooltips
		All rights reserved
]]--

local ADDON, Addon = ...
local TipCounts = Addon:NewModule('TooltipCounts')
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)

local NONE = Addon.None
local SILVER = '|cffc7c7cf%s|r'
local TOTAL = SILVER:format(L.Total)

local function aggregate(counts, bag)
	for slot, data in pairs(bag or NONE) do
		if tonumber(slot) then
			local singleton = tonumber(data)
			local count = not singleton and tonumber(data:match(';(%d+)$')) or 1
			local id = singleton or tonumber(data:match('^(%d+)'))

			counts[id] = (counts[id] or 0) + count
		end
	end
end

local function find(bag, item)
	local count = 0
	
	for slot, data in pairs(bag or NONE) do
		if tonumber(slot) then
			local singleton = tonumber(data)
			local id = singleton or tonumber(data:match('^(%d+)'))
			if id == item then
				count = count + (not singleton and tonumber(data:match(';(%d+)$')) or 1)
			end
		end
	end
	
	return count
end


--[[ Startup ]]--

function TipCounts:OnEnable()
	if Addon.sets.countItems then
		if TooltipDataProcessor then
			TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item,  self.OnItem)
		else
			for _,frame in pairs {UIParent:GetChildren()} do
				if not frame:IsForbidden() and frame:GetObjectType() == 'GameTooltip' then
					hooksecurefunc(frame, 'SetQuestItem', self.OnQuest)
					hooksecurefunc(frame, 'SetQuestLogItem', self.OnQuest)
					hooksecurefunc(frame, 'SetCraftItem', self.OnSetCraftItem)
					hooksecurefunc(frame, 'SetTradeSkillItem', self.OnSetTradeSkillItem)
				
					frame:HookScript('OnTooltipCleared', self.OnClear)
					frame:HookScript('OnTooltipSetItem', self.OnItem)
				end
			end
		end
		
		self:UnregisterSignal('UPDATE_ALL')
	else
		self:RegisterSignal('UPDATE_ALL', 'OnEnable')
	end
end


--[[ Events ]]--

function TipCounts.OnItem(tip)
	local name, link = (tip.GetItem or TooltipUtil.GetDisplayedItem)(tip)
	if name ~= '' then
		TipCounts:AddOwners(tip, link)
	end
end

function TipCounts.OnQuest(tip, type, quest)
	TipCounts:AddOwners(tip, GetQuestItemLink(type, quest))
end

function TipCounts.OnSetTradeSkillItem(tip, skill, index)
	if index then
		TipCounts:AddOwners(tip, GetTradeSkillReagentItemLink(skill, index))
	else
		TipCounts:AddOwners(tip, GetTradeSkillItemLink(skill))
	end
end

function TipCounts.OnSetCraftItem(tip, ...)
	TipCounts:AddOwners(tip, GetCraftReagentItemLink(...))
end

function TipCounts.OnClear(tip)
	tip.__hasCounters = false
end


--[[ API ]]--

function TipCounts:AddOwners(tip, link)
	if not tip.__hasCounters and Addon.sets.countItems then
		local id = tonumber(link and GetItemInfoInstant(link) and link:match(':(%d+)')) -- workaround Blizzard craziness
		if id and id ~= HEARTHSTONE_ITEM_ID then
			local players = 0
			local total = 0

			for i, owner in Addon.Owners:Iterate() do
				local color = owner:GetColorMarkup()
				local count, text = 0

				if owner.offline and not owner.counts then
					self:CountItems(owner)
				end

				if not owner.isguild then
					local equip, bags, bank, vault
					if not owner.offline then
						local carrying = GetItemCount(id)

						equip = find(owner.equip, id)
						vault = find(owner.vault, id)
						bank = GetItemCount(id, true) - carrying
						bags = carrying - equip
					else
						equip, bags = owner.counts.equip[id], owner.counts.bags[id]
						bank, vault = owner.counts.bank[id], owner.counts.vault[id]
					end

					count, text = self:Format(color,
						L.TipCountEquip, equip, L.TipCountBags, bags,
						L.TipCountBank, bank, L.TipCountVault, vault)

				elseif Addon.sets.countGuild then
					if not owner.offline then
						local guild = 0
						for tab = 1, MAX_GUILDBANK_TABS do
							guild = guild + find(owner[tab], id)
						end

						count, text = self:Format(color, L.TipCountGuild, guild)
					else
						count, text = self:Format(color, L.TipCountGuild, owner.counts[id])
					end
				end

				if count > 0 then
					tip:AddDoubleLine(owner:GetIconMarkup(12,0,0) ..' '.. color:format(owner.name), text)
					total = total + count
					players = players + 1
				end
			end

			if players > 1 and total > 0 then
				tip:AddDoubleLine(TOTAL, SILVER:format(total))
			end

			tip.__hasCounters = not TooltipDataProcessor
			tip:Show()
		end
	end
end

function TipCounts:CountItems(owner)
	if owner.isguild then
		owner.counts = {}

		for tab = 1, MAX_GUILDBANK_TABS do
			aggregate(owner.counts, owner[tab])
		end
	else
		owner.counts = {bags={}, bank={}, equip={}, vault={}}

		for _, bag in ipairs(Addon.InventoryBags) do
			aggregate(owner.counts.bags, owner[bag])
		end

		for _, bag in ipairs(Addon.BankBags) do
			aggregate(owner.counts.bank, owner[bag])
		end

		aggregate(owner.counts.equip, owner.equip)
		aggregate(owner.counts.vault, owner.vault)
	end
end

function TipCounts:Format(color, ...)
	local total, places = 0, 0
	local text = ''

	for i = 1, select('#', ...), 2 do
		local title, count = select(i, ...)
		if count and count > 0 then
			text = text .. L.TipDelimiter .. title:format(count)
			total = total + count
			places = places + 1
		end
	end

	text = text:sub(#L.TipDelimiter + 1)
	if places > 1 then
		text = color:format(total) .. ' ' .. SILVER:format('('.. text .. ')')
	else
		text = color:format(text)
	end

	return total, total > 0 and text
end
