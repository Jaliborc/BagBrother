--[[
	A style agnostic item sorting button.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local C = LibStub('C_Everywhere')
local Sushi = LibStub('Sushi-3.2')
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local SortButton = Addon.Tipped:NewClass('SortButton', 'CheckButton', true)


--[[ Construct ]]--

function SortButton:New(parent)
	local b = self:Super(SortButton):New(parent)
	b:RegisterSignal('SORTING_STATUS')
	return b
end

function SortButton:SORTING_STATUS(id)
	self:SetChecked(id == self:GetFrameID())
end


--[[ Interaction ]]--

function SortButton:OnEnter()
	self:ShowTooltip(BAG_FILTER_CLEANUP, '|R ' .. OPTIONS)
end

function SortButton:OnClick(button)
	if button == 'RightButton' then
		local hasServer = self.frame.ServerSort
		MenuUtil.CreateContextMenu(self, function(_, drop)
			drop:SetTag(ADDON .. 'CleanupOptions')
			drop:CreateTitle(L.CleanupOptions)

			if hasServer then
				drop:CreateCheckbox(L.ServerSorting,
					function() return self.frame.profile.serverSort end,
					function() self.frame.profile.serverSort = not self.frame.profile.serverSort end)
			end

			drop:CreateCheckbox(L.ReverseSorting,
				function()
					if hasServer and self.frame.profile.serverSort then
						return not C.Container.GetSortBagsRightToLeft()
					else
						return self.frame.profile.reverseSort
					end
				end,
				function()
					if hasServer and self.frame.profile.serverSort then
						C.Container.SetSortBagsRightToLeft(not C.Container.GetSortBagsRightToLeft())
					else
						self.frame.profile.reverseSort = not self.frame.profile.reverseSort
					end
				end)

			drop:CreateButton('|A:legionmission-lock:14:14|a ' .. L.LockItems, function() self:OnLocking() end)
		end)
	elseif not self:GetChecked() then
		return Addon.Sorting:Stop()
	elseif not self.frame:IsCached() then
		return self.frame:SortItems()
	end

	self:SetChecked(nil)
end

function SortButton:OnLocking()
	if not Addon.lockMode then
		Addon.lockMode = Sushi.HelpTip(self.frame, L.ConfigurationMode, self:IsFarRight() and 'RIGHT' or 'LEFT', self:IsFarRight() and -23 or 23,0)
							:SetCall('OnClose', function() self:OnLocking() end)
	else
		Addon.lockMode:Release()
		Addon.lockMode = nil
	end

	self:SendSignal('LOCKING_TOGGLED')
end