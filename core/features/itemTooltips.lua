--[[
	Adds item counts to tooltips.
	All Rights Reserved
]]--

local ADDON, Addon = ...
local TipCounts = Addon:NewModule('TooltipCounts')
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local C = LibStub('C_Everywhere').Item

local NONE = Addon.None
local EQUIP_ICON = '%d|Tinterface/addons/bagbrother/art/garrison_building_salvageyard:12:12:6:0|t'
local MAIL_ICON = '%d|Tinterface/icons/inv_letter_13:12:12:6:0|t'
local DELIMITER = ' +'

local function iterate(bag)
	return pairs(bag and (bag.items or bag) or NONE)
end

local function aggregate(counts, bag)
	for slot, data in iterate(bag) do
		if tonumber(slot) then
			local singleton = tonumber(data)
			local id = singleton or tonumber(data:match('%d+'))
			local count = not singleton and tonumber(data:match(';(%d+)$')) or 1

			counts[id] = (counts[id] or 0) + count
		end
	end
end

local function find(bag, item)
	local count = 0
	
	for slot, data in iterate(bag) do
		if tonumber(slot) then
			local singleton = tonumber(data)
			local id = singleton or tonumber(data:match('%d+'))
			if id == item then
				count = count + (not singleton and tonumber(data:match(';(%d+)$')) or 1)
			end
		end
	end
	
	return count
end

local function frameIcon(id)
	return '%d|T' .. Addon.Frames:Get(id).icon .. ':12:12:6:0|t'
end


--[[ Startup ]]--

function TipCounts:OnLoad()
	if Addon.sets.countItems then
		if C_TooltipInfo then
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
		self:RegisterSignal('UPDATE_ALL', 'OnLoad')
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
		local id = tonumber(link and C.GetItemInfoInstant(link) and link:match(':(%d+)')) -- workaround Blizzard craziness
		if id and id ~= HEARTHSTONE_ITEM_ID then
			local carrying = C.GetItemCount(id)
			local left, right = {}, {}
			local total = 0

			for i, owner in Addon.Owners:Iterate() do
				local color = owner:GetColorMarkup()
				local count, locations = 0

				if owner.offline and not owner.counts then
					self:CountItems(owner)
				end

				if not owner.isguild then
					local equip, mail, bags, bank, vault

					if not owner.offline then
						mail = find(owner.mail, id)
						equip = find(owner.equip, id)
						vault = find(owner.vault, id)
						bank = C.GetItemCount(id, true, nil, true) - carrying
						bags = carrying - equip
					else
						bags, bank, vault = owner.counts.bags[id], owner.counts.bank[id], owner.counts.vault[id]
						equip, mail = owner.counts.equip[id], owner.counts.mail[id]
					end

					count, locations = self:Format(color, EQUIP_ICON, equip, frameIcon('inventory'), bags, 
						frameIcon('bank'), bank, frameIcon('vault'), vault, MAIL_ICON, mail)

				elseif Addon.sets.countGuild then
					if not owner.offline then
						local guild = 0
						for tab = 1, MAX_GUILDBANK_TABS do
							guild = guild + find(owner[tab], id)
						end

						count, locations = self:Format(color, frameIcon('guild'), guild)
					else
						count, locations = self:Format(color, frameIcon('guild'), owner.counts[id])
					end
				end

				if count > 0 then
					tinsert(left, owner:GetIconMarkup(12) ..' '.. color:format(owner.name))
					tinsert(right, locations)
					total = total + count
				end
			end

			local account = C.GetItemCount(id, nil, nil, nil, true) - carrying
			if account > 0 then
				tinsert(left, '|A:questlog-questtypeicon-account:0:0|a ' .. ACCOUNT_QUEST_LABEL)
				tinsert(right, account)
				total = total + account
			end

			if #left > 1 then
				tip:AddLine(format('|n%s: |cffffffff%d|r', TOTAL, total))
			end

			for i, who in ipairs(left) do
				tip:AddDoubleLine(who, right[i])
			end

			tip.__hasCounters = not C_TooltipInfo
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
		owner.counts = {bags={}, bank={}, equip={}, mail={}, vault={}}

		for _, bag in ipairs(Addon.InventoryBags) do
			aggregate(owner.counts.bags, owner[bag])
		end

		for _, bag in ipairs(Addon.BankBags) do
			aggregate(owner.counts.bank, owner[bag])
		end

		aggregate(owner.counts.mail, owner.mail)
		aggregate(owner.counts.equip, owner.equip)
		aggregate(owner.counts.vault, owner.vault)
	end
end

function TipCounts:Format(color, ...)
	local total, text = 0, {}

	for i = 1, select('#', ...), 2 do
		local icon, count = select(i, ...)
		if count and count > 0 then
			tinsert(text, icon:format(count))
			total = total + count
		end
	end

	if #text > 1 then
		text = color:format(total) .. LIGHTGRAY_FONT_COLOR:WrapTextInColorCode('='.. table.concat(text, DELIMITER))
	elseif #text == 1 then
		text = color:format(text[1])
	end

	return total, total > 0 and text
end
