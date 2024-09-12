--[[
	A style agnostic item sorting button.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local Sushi = LibStub('Sushi-3.2')
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local SortButton = Addon.Tipped:NewClass('SortButton', 'CheckButton', true)


--[[ Construct ]]--

function SortButton:New(...)
	local b = self:Super(SortButton):New(...)
	b:RegisterSignal('SORTING_STATUS')
	b:RegisterForClicks('anyUp')
	return b
end

function SortButton:SORTING_STATUS(_, id)
	self:SetChecked(id == self:GetFrameID())
end


--[[ Interaction ]]--

function SortButton:OnEnter()
	self:ShowTooltip(BAG_FILTER_CLEANUP, '|R ' .. OPTIONS)
end

function SortButton:OnClick(button)
	if button == 'RightButton' then
		local hasServer = self.frame.ServerSort
		local serverSort = hasServer and self.frame.profile.serverSort

		local drop = Sushi.Dropdown:Toggle(self)
		if drop then
			drop:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -11)
			drop:SetChildren {
				{text = L.CleanupOptions, isTitle = true},
				{
					text =  '|A:gmchat-icon-blizz:14:14|a ' .. L.ServerSorting, tooltipTitle = L.ServerSortingTip,
					func = function() self.frame.profile.serverSort = not self.frame.profile.serverSort end,
					checked = serverSort, disabled = not hasServer, isNotRadio = true
				},
				{
					text = '     |A:legionmission-lock:14:14|a ' .. L.LockItems,
					func = function() self:OnLocking() end, disabled = serverSort, notCheckable = true,
				}
			}
		end
	elseif not self:GetChecked() then
		return Addon.Sorting:Stop()
	elseif not self.frame:IsCached() then
		return self.frame:SortItems()
	end

	self:SetChecked(nil)
end

function SortButton:OnLocking()
	if not Addon.lockMode then
		Addon.lockMode = Sushi.HelpTip(self.frame, L.ConfigurationMode, self:IsFarLeft() and 'RIGHT' or 'LEFT', self:IsFarLeft() and -23 or 23,0)
							:SetCall('OnClose', function() self:OnLocking() end)
	else
		Addon.lockMode:Release()
		Addon.lockMode = nil
	end

	self:SendSignal('LOCKING_TOGGLED')
end