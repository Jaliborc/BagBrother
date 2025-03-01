--[[
	A in-progress implementation of customizable tabs.
	All Rights Reserved
--]]

local ADDON, Addon = (...):match('%w+'), _G[(...):match('%w+')]
local Filters = Addon.Parented:NewClass('FilterGroup', 'Frame')
Filters.Button = Addon.SideFilter

function Filters:New(parent)
	local f = self:Super(Filters):New(parent)
	f.buttons = {}
	f:RegisterSignal('RULES_CHANGED', 'Update')
	f:RegisterFrameSignal('FILTERS_CHANGED', 'Update')
	f:RegisterFrameSignal('OWNER_CHANGED', 'Update')
	f:SetPoint('BOTTOMLEFT', parent, 'BOTTOMRIGHT')
	f:SetPoint('TOPLEFT', parent, 'TOPRIGHT')
	f:SetWidth(38)
	f:SetScale(.8)
	f:Update()
	f:Show()
	return f
end

function Filters:Update()
	local i = 1
	for _,id in ipairs(self.frame.profile.filters) do
		local rule = Addon.Rules:Get(id)
		if rule then
			local button = GetOrCreateTableEntryByCallback(self.buttons, i, GenerateClosure(self.Button, self))
            button:SetPoint('TOP', 0, -i * 42)
            button:SetRule(rule)

			i = i + 1
		end
	end

	for i = i, #self.buttons do
		self.buttons[i]:Hide()
	end
end

-- temp hack
function Addon.Bank:New(...)
	local f = self:Super(Addon.Bank):New(...)
	f.FilterGroup = Filters(f)
	return f
end