--[[
	A button for selecting offline owners or locations.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local Sushi = LibStub('Sushi-3.2')
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local OfflineSelector = Addon.Tipped:NewClass('OwnerSelector', 'Button', true)


--[[ Construct ]]--

function OfflineSelector:New(parent)
	local b = self:Super(OfflineSelector):New(parent)
	b:RegisterEvent('UNIT_PORTRAIT_UPDATE', 'Update')
	b:RegisterFrameSignal('OWNER_CHANGED', 'Update')
	b:SetScript('OnShow', b.Update)
	return b
end

function OfflineSelector:Update()
	local owner = self:GetOwner()
	local tabard = not owner.offline and owner.isguild

	if owner.offline then
		local icon, coords = owner:GetIcon()
		if coords then
			local u,v,w,z = unpack(coords)
			local s = (v-u) * 0.06

			self.Icon:SetTexCoord(u+s, v-s, w+s, z-s)
			self.Icon:SetTexture(icon)
		else
			self.Icon:SetTexCoord(0,1,0,1)
			self.Icon:SetAtlas(icon)
		end
	elseif owner.isguild then
		SetLargeGuildTabardTextures('player', self.Emblem, self.Tabard, self.Border)
	else
		SetPortraitTexture(self.Icon, 'player')
		self.Icon:SetTexCoord(.05,.95,.05,.95)
	end

	if self.Emblem then
		self.Emblem:SetShown(tabard)
		self.Tabard:SetShown(tabard)
		self.Border:SetShown(tabard)
	end
	
	self.Icon:SetShown(not tabard)
	self:SetEnabled(not owner.isguild)
end


--[[ Events ]]--

function OfflineSelector:OnEnter()
	self:ShowTooltip(L.OfflineViewing, '|L '..L.BrowseItems, '|R '..L.OpenBank)
end

function OfflineSelector:OnClick(button)
	if button == 'LeftButton' then
		MenuUtil.CreateContextMenu(self, function(_, drop)
			drop:SetTag(ADDON .. 'OfflineView')
			drop:CreateTitle(L.Locations)

			local frames = drop:CreateFrame()
			frames:AddResetter(function(f) f.group:Release() end)
			frames:AddInitializer(function(f)
				f.group = self:AddLocations(f)
				return f.group:GetWidth() + (Addon.IsRetail and 0 or 10), f.group:GetHeight()
			end)

			drop:CreateDivider()
			drop:CreateTitle(L.Characters)

			local start, more = 1, false
			for i, owner in Addon.Owners:Iterate() do
				local overflow
				if owner.isguild and start == 1 then
					drop:CreateDivider()
					drop:CreateTitle(L.Guilds)
					start, more = i, false
				else
					overflow = (i-start) >= 8 and not owner.favorite
					if overflow and not more then
						more = drop:CreateButton('    '..FRIENDS_WOW_NAME_COLOR:WrapTextInColorCode(LFG_LIST_MORE))
						more:SetScrollMode(500)
					end
				end

				self:AddOwner(overflow and more or drop, owner)
			end
		end)
	elseif button == 'RightButton' then
		Addon.Frames:Toggle('bank')
	end
end


--[[ API ]]--

function OfflineSelector:AddLocations(parent)
	local group = Sushi.Group(parent)
	group:SetPoint('TOPLEFT')
	group:SetResizing('HORIZONTAL')
	group:SetChildren(function()
		for i, frame in Addon.Frames:Iterate() do
			if Addon.Frames:IsEnabled(frame.id) then
				self:AddLocation(group, frame)
			end
		end

		group:SetHeight(ceil(group:NumChildren() / 2) * 33)
	end, true)

	return group
end

function OfflineSelector:AddLocation(parent, frame)
	local size = Addon.IsClassic and 34 or 28
	local button = Sushi.DropButton(parent, {
		text = CreateSimpleTextureMarkup(frame.icon, size,size) .. ' '.. frame.name,
		func = function() Addon.Frames:Show(frame.id) end,
		left = 0, right = 10, top = 2, bottom = 2,
		notCheckable = true,
		maxWidth = 100,
	})

	parent:Add(button)
end

function OfflineSelector:AddOwner(parent, owner)
	local name = owner:GetIconMarkup(16) .. ' '.. owner:GetColorMarkup():format(owner.name)
	local isSelected = function() return owner == self:GetOwner() end
	local onClick = function()
		Addon.Frames:Show(owner.isguild and 'guild' or self:GetFrameID(), owner)
	end

	local check = parent:CreateRadio(name, isSelected, onClick)
	check:AddInitializer(function(check, _, menu)
		local arrow = owner.favorite and 'vignettearrow' or 'questarrow'
		local fav = MenuTemplates.AttachAutoHideButton(check, 'interface/minimap/minimap-'..arrow)
		fav:SetPoint('RIGHT')
		fav:SetSize(16, 16)
		fav:SetScript('OnClick', function()
			owner.cache.favorite = not owner.favorite or nil
			Addon.Owners:Sort()
			menu:Close()
		end)

		MenuUtil.HookTooltipScripts(fav, function(tip)
			GameTooltip_SetTitle(tip, owner.favorite and BATTLE_PET_UNFAVORITE or BATTLE_PET_FAVORITE)
		end)

		if owner.offline then
			local edit = MenuTemplates.AttachAutoHideCancelButton(check)
			edit:SetPoint('RIGHT', fav, 'LEFT', -2,0)
			edit:SetScript('OnClick', function()
				Sushi.Popup {
					text = L.ConfirmDelete:format(name), button1 = OKAY, button2 = CANCEL,
					whileDead = 1, exclusive = 1, hideOnEscape = 1,
					OnAccept = function() owner:Delete() end
				}

				menu:Close()
			end)

			MenuUtil.HookTooltipScripts(edit, function(tip)
				GameTooltip_SetTitle(tip, DELETE)
			end)
		end
	end)
end