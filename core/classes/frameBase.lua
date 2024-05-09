--[[
	Useful methods to implement a class for frame objects.
	All Rights Reserved
--]]


local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Frame = Addon.Base:NewClass('Frame', 'Frame', nil, true)
Frame.OpenSound = SOUNDKIT.IG_BACKPACK_OPEN
Frame.CloseSound = SOUNDKIT.IG_BACKPACK_CLOSE
Frame.MoneyFrame = Addon.MoneyFrame
Frame.BagGroup = Addon.BagGroup

local KEYSTONE_FORMAT = '^' .. strrep('%d+:', 6) .. '%d+$'
local PET_FORMAT = '^' .. strrep('%d+:', 7) .. '%d+$'


--[[ Events ]]--

function Frame:OnShow()
	PlaySound(self.OpenSound)
	self:RegisterFrameSignal('BAG_FRAME_TOGGLED', 'Layout')
	self:RegisterFrameSignal('ELEMENT_RESIZED', 'Layout')
	self:RegisterSignal('SKINS_LOADED', 'UpdateSkin')
	self:RegisterSignal('RULES_LOADED', 'FindRules')
	self:RegisterSignal('UPDATE_ALL', 'Update')
	self:RegisterEvents()
	self:Update()
end

function Frame:OnHide()
	PlaySound(self.CloseSound)
	self:UnregisterAll()

	if Addon.sets.resetPlayer then
		self.owner = nil
	end
end


--[[ UI ]]--

function Frame:Update()
	self.profile = self:GetBaseProfile()
	self:ClearAllPoints()
	self:SetFrameStrata(self.profile.strata)
	self:SetAlpha(self.profile.alpha)
	self:SetScale(self.profile.scale)
	self:SetPoint(self:GetPosition())
	self:UpdateSkin()
	self:Layout()
end

function Frame:UpdateSkin()
	if self.bg then
		Addon.Skins:Release(self.bg)
	end

	local center = self.profile.color
	local border = self.profile.borderColor
	local bg = Addon.Skins:Acquire(self.profile.skin)
	bg:SetParent(self)
	bg:SetFrameLevel(self:GetFrameLevel())
	bg:SetPoint('BOTTOMLEFT', bg.skin.x or 0, bg.skin.y or 0)
	bg:SetPoint('TOPRIGHT', bg.skin.x1 or 0, bg.skin.y1 or 0)
	bg:EnableMouse(true)

	self.CloseButton:SetPoint('TOPRIGHT', (bg.skin.closeX or 0)-2, (bg.skin.closeY or 0)-2)
	self.Title:SetHighlightFontObject(bg.skin.fontH or self.FontH)
	self.Title:SetNormalFontObject(bg.skin.font or self.Font)
	self.bg = bg

	Addon.Skins:Call('load', bg)
	Addon.Skins:Call('borderColor', bg, border[1], border[2], border[3], border[4])
	Addon.Skins:Call('centerColor', bg, center[1], center[2], center[3], center[4])
end

function Frame:RecomputePosition()
	local x, y = self:GetCenter()
	if x and y then
		local scale = self:GetScale()
		local h = UIParent:GetHeight() / scale
		local w = UIParent:GetWidth() / scale
		local xPoint, yPoint

		if x > w/2 then
			x = self:GetRight() - w
			xPoint = 'RIGHT'
		else
			x = self:GetLeft()
			xPoint = 'LEFT'
		end

		if y > h/2 then
			y = self:GetTop() - h
			yPoint = 'TOP'
		else
			y = self:GetBottom()
			yPoint = 'BOTTOM'
		end

		self:SetPosition(yPoint..xPoint, x, y)
	end
end

function Frame:SetPosition(point, x, y)
	self.profile.x, self.profile.y = x, y
	self.profile.point = point
end

function Frame:GetPosition()
	return self.profile.point or 'CENTER', self.profile.x, self.profile.y
end

function Frame:GetExtraButtons()
	return {}
end


--[[ Filtering ]]--

function Frame:FindRules()
	for id, rule in Addon.Rules:Iterate() do
		if not tContains(self.profile.rules, id) then
			self:Delay(0.01, 'SendFrameSignal', 'RULES_UPDATED')
			tinsert(self.profile.rules, id)
		end
	end
end

function Frame:IsShowingBag(bag)
	return not self:GetProfile().hiddenBags[bag]
end

function Frame:IsShowingItem(bag, slot)
	local info = self:GetItemInfo(bag, slot)
	local rule = Addon.Rules:Get(self.subrule or self.rule)

	if rule and rule.func then
		if not rule.func(self.owner, bag, slot, self:GetBagInfo(bag), info) then
			return
		end
	end

	return self:IsShowingQuality(info.quality)
end

function Frame:IsShowingQuality(quality)
	return self.quality == 0 or (quality and bit.band(self.quality, bit.lshift(1, quality)) > 0)
end

function Frame:SortItems()
	Addon.Sorting:Start(self)
end


--[[ Properties ]]--

function Frame:GetItemInfo(bag, slot)
	local bag = self:GetOwner()[bag]
	local data = bag and bag[slot]
	if data then
		if data:find(PET_FORMAT) then
			local id, _, quality = data:match('(%d+):(%d+):(%d+)')
			local item = {itemID = tonumber(id), quality = tonumber(quality)}
			item.name, item.iconFileID = C_PetJournal.GetPetInfoBySpeciesID(item.itemID)
			item.hyperlink = format('|c%s|Hbattlepet:%sx0|h[%s]|h|r', select(4, GetItemQualityColor(item.quality)), data, item.name)
			return item
		elseif data:find(KEYSTONE_FORMAT) then
			local item = {itemID = tonumber(data:match('(%d+)'))}
			_,_,_,_, item.iconFileID = GetItemInfoInstant(item.itemID)
			_, item.hyperlink, item.quality = GetItemInfo(item.itemID)
			item.hyperlink = item.hyperlink:gsub('item[:%d]+', data, 1)
			return item
		else
			local link, count = strsplit(';', data)
			local item = {hyperlink = 'item:' .. link, stackCount = tonumber(count)}
			item.itemID, _,_,_, item.iconFileID = GetItemInfoInstant(item.hyperlink)
			_, item.hyperlink, item.quality = GetItemInfo(item.hyperlink) 
			return item
		end
	end
	return {}
end

function Frame:GetBagFamily()
	return 0
end

function Frame:IsCached()
	return self:GetOwner().offline
end

function Frame:GetProfile()
	return self:GetOwner().profile[self.id]
end

function Frame:GetBaseProfile()
	return Addon.player.profile[self.id]
end

function Frame:SetOwner(owner)
	self.owner = owner
	self:SendFrameSignal('OWNER_CHANGED', owner)
end

function Frame:GetOwner()
	return self.owner or Addon.player
end

function Frame:GetFrameID()
	return self.id
end
