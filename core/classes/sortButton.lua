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
	b:SetScript('OnClick', b.OnClick)
	b:SetScript('OnEnter', b.OnEnter)
	b:SetScript('OnLeave', b.OnLeave)
	b:RegisterForClicks('anyUp')
	return b
end

function SortButton:SORTING_STATUS(_, id)
	self:SetChecked(id == self:GetFrameID())
end


--[[ Interaction ]]--

function SortButton:OnClick(button)
	if button == 'RightButton' then
		local serverSort = Addon.IsRetail and Addon.sets.serverSort
		local drop = Sushi.Dropdown:Toggle(self)
		if drop then
			drop:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -11)
			drop:SetChildren {
				{text = L.CleanupOptions, isTitle = true},
				{
					text =  '|A:gmchat-icon-blizz:14:14|a ' .. L.ServerSorting, tooltipTitle = L.ServerSortingTip,
					func = function() Addon.sets.serverSort = not Addon.sets.serverSort end,
					checked = serverSort, disabled = not Addon.IsRetail,
					isNotRadio = true
				},
				{
					text = '     |A:legionmission-lock:14:14|a ' .. L.LockItems,
					tooltipTitle = serverSort and RED_FONT_COLOR:WrapTextInColorCode(L.RequiresClientSorting),
					func = function() self:OnLocking() end,
					notCheckable = true,
				}
			}
		end

		self:SetChecked(nil)
	elseif not self:GetChecked() then
		Addon.Sorting:Stop()
	elseif not self.frame:IsCached() then
		self.frame:SortItems()
	end
end

function SortButton:OnLocking()
	if Addon.lockMode then
		Addon.lockMode:Release()
		Addon.lockMode = nil
	else
		Addon.lockMode = Sushi.HelpTip(self.frame, 'You are now in the client-side sorting configuration mode.|n|nClick item slots to toggle if they should be locked while sorting.', 'RIGHT')
			:SetCall('OnClose', function() self:OnLocking() end)
			:SetPoint('RIGHT', self.frame, 'LEFT', -23,0)
	end

	self:SendSignal('LOCKING_TOGGLED')
end

function SortButton:OnEnter()
	GameTooltip:SetOwner(self:GetTipAnchor())
	GameTooltip:SetText(BAG_FILTER_CLEANUP)
	GameTooltip:AddLine(L.TipCleanItems:format(L.LeftClick), 1,1,1)
	GameTooltip:AddLine(('%s to configure.'):format(L.RightClick), 1,1,1)
	GameTooltip:Show()
end
