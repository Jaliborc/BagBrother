--[[
	Useful methods to implement a class for frame objects.
	All Rights Reserved
--]]


local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Frame = Addon.Base:NewClass('Frame', 'Frame', Addon.FrameTemplate, true)

Frame.OpenSound = SOUNDKIT.IG_BACKPACK_OPEN
Frame.CloseSound = SOUNDKIT.IG_BACKPACK_CLOSE
Frame.MoneyFrame = Addon.MoneyFrame
Frame.BagGroup = Addon.BagGroup


--[[ Frame Events ]]--

function Frame:OnShow()
	PlaySound(self.OpenSound)
	self:RegisterSignals()
end

function Frame:OnHide()
	PlaySound(self.CloseSound)
	self:UnregisterAll()

	if Addon.sets.resetPlayer then
		self.owner = nil
	end
end


--[[ UI ]]--

function Frame:UpdateAppearance()
	self:ClearAllPoints()
	self:SetFrameStrata(self.profile.strata)
	self:SetAlpha(self.profile.alpha)
	self:SetScale(self.profile.scale)
	self:SetPoint(self:GetPosition())
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

function Frame:IsShowingEmptySlots(bag)
	return not self:GetProfile().hiddenBagsSlots[bag]
end

function Frame:IsShowingItem(bag, slot)
	local info = self:GetItemInfo(bag, slot)
	local rule = Addon.Rules:Get(self.subrule or self.rule)

	if rule and rule.func then
		if not rule.func(self.owner, bag, slot, self:GetBagInfo(bag), info) then
			return
		end
	end
	if not self:IsShowingEmptySlots(bag) and info.itemID == nil then
		return
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
		local link, count = strsplit(';', data)
		local item = {hyperlink = 'item:' .. link, stackCount = tonumber(count)}
		item.itemID, _,_,_, item.iconFileID = GetItemInfoInstant(item.hyperlink)
		_, item.hyperlink, item.quality = GetItemInfo(item.hyperlink) 
		return item
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
