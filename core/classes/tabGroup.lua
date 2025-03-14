--[[
	A container frame for customizable tabs.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local Tabs = Addon.Parented:NewClass('TabGroup', 'Frame')
Tabs.Button = Addon.SideTab

function Tabs:New(parent)
	local f = self:Super(Tabs):New(parent)
	f.buttons = {}
	f:RegisterSignal('RULES_LOADED', 'Update')
	f:RegisterFrameSignal('FILTERS_CHANGED', 'Update')
	f:RegisterFrameSignal('OWNER_CHANGED', 'Update')
	f:Update()
	f:Show()
	return f
end

function Tabs:Update()
	local i = 1
	for _,id in ipairs(self.frame.profile.filters) do
		local rule = Addon.Rules:Get(id)
		if rule then
			local button = GetOrCreateTableEntryByCallback(self.buttons, i, GenerateClosure(self.Button, self))
            button:SetPoint('TOPLEFT', 0, -i * 42)
            button:SetRule(rule)

			i = i + 1
		end
	end

	for k = i, #self.buttons do
		self.buttons[k]:Hide()
	end

	self:SetSize(33, i * 33)
end