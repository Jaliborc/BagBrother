--[[
	A button for opening offline owners or locations.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local Sushi = LibStub('Sushi-3.2')
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local OfflineSelector = Addon.Tipped:NewClass('OwnerSelector', 'Button', true)


--[[ Construct ]]--

function OfflineSelector:New(...)
	local b = self:Super(OfflineSelector):New(...)
	b:RegisterEvent('UNIT_PORTRAIT_UPDATE', 'Update')
	b:RegisterFrameSignal('OWNER_CHANGED', 'Update')
	b:SetScript('OnClick', b.OnClick)
	b:SetScript('OnEnter', b.OnEnter)
	b:SetScript('OnLeave', b.OnLeave)
	b:SetScript('OnShow', b.Update)
	b:RegisterForClicks('anyUp')
	b:Update()
	return b
end

function OfflineSelector:Update()
	local owner = self:GetOwner()
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
	else
		SetPortraitTexture(self.Icon, 'player')
		self.Icon:SetTexCoord(.05,.95,.05,.95)
	end
end


--[[ Events ]]--

function OfflineSelector:OnEnter()
	self:ShowTooltip(L.OfflineViewing, '|L '..L.BrowseItems, '|R '..L.OpenBank)
end

function OfflineSelector:OnClick(button)
	if button == 'LeftButton' then
		local left = self:IsFarLeft()
		local drop = Sushi.Dropdown:Toggle(self)
		if drop then
			drop:SetPoint(left and 'TOPRIGHT' or 'TOPLEFT', self, left and 'BOTTOMRIGHT' or 'BOTTOMLEFT', 0, -11)
			drop:SetChildren(function()
				drop:Add {text = L.Locations, isTitle = true}

				local locations = drop:Add('Group')
				locations.right = -12
				locations:SetResizing('HORIZONTAL')
				locations:SetChildren(function()
					for i, frame in Addon.Frames:Iterate() do
						if Addon.Frames:IsEnabled(frame.id) then
							self:AddLocation(locations, frame)
						end
					end

					locations:SetHeight(ceil(locations:NumChildren() / 2) * 33)
				end)

				local charHeader = drop:Add {text = L.Characters, isTitle = true}
				local guildHeader = false

				for i, owner in Addon.Owners:Iterate() do
					if not owner.isguild or Addon.Frames:IsEnabled('guild') then
						if owner.isguild and not guildHeader then
							guildHeader = drop:Add {text = L.Guilds, isTitle = true}
						end

						self:AddOwner(drop, owner)
					end
				end
			end)
		end
	elseif button == 'RightButton' then
		Addon.Frames:Toggle('bank')
	end
end


--[[ API ]]--

function OfflineSelector:AddLocation(parent, frame)
	local button = Sushi.DropButton(parent, {
		text = CreateSimpleTextureMarkup(frame.icon, 34,34) .. ' '.. frame.name,
		func = function() Addon.Frames:Show(frame.id) end,
		left = 12, right = 12,
		top = 2, bottom = 2,
		notCheckable = true,
		maxWidth = 100,
	})

	parent:Add(button)
end

function OfflineSelector:AddOwner(parent, owner)
	local name = owner:GetIconMarkup(18,-5,0) .. ' '.. owner:GetColorMarkup():format(owner.name)
	local button = Addon.DropButton:New(parent, {
		text = name,
		checked = owner == self:GetOwner(),

		func = function()
			Addon.Frames:Show(owner.isguild and 'guild' or self:GetFrameID(), owner)
		end,

		delFunc = owner.offline and function()
			Sushi.Popup {
				text = L.ConfirmDelete:format(name), button1 = OKAY, button2 = CANCEL,
				whileDead = 1, exclusive = 1, hideOnEscape = 1,
				OnAccept = function() owner:Delete() end
			}
		end
	})

	parent:Add(button)
end