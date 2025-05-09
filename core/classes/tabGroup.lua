--[[
	A container frame for customizable tabs.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local Tabs = Addon.Parented:NewClass('TabGroup', 'Frame')
Tabs.From, Tabs.To, Tabs.X, Tabs.Y = 'TOPLEFT', 'BOTTOMLEFT', 0,-6
Tabs.Button = Addon.Tab


--[[ Construct ]]--

function Tabs:New(parent)
	local f = self:Super(Tabs):New(parent)
	f.buttons = {}
	f:RegisterFrameSignal('FILTERS_CHANGED', 'Update')
	f:RegisterFrameSignal('OWNER_CHANGED', 'Update')
	f:RegisterSignal('RULES_LOADED', 'Update')
	f:Update()
	return f
end

function Tabs:Update()
	local i = 1
	for _,id in self:Iterate() do
		local rule = Addon.Rules:Get(id)
		if rule then
			local button = GetOrCreateTableEntryByCallback(self.buttons, i, GenerateClosure(self.Button, self))
            button:SetRule(rule)
			button:Show()

			local anchor = self.buttons[i-1]
			if anchor then
				button:SetPoint(self.From, anchor, self.To, self.X, self.Y)
			else
				button:SetPoint(self.From)
			end

			i = i + 1
		end
	end

	for k = i, #self.buttons do
		self.buttons[k]:Hide()
	end

	self:SetSize(self:GetBounds(i))
end


--[[ Proprieties ]]--

function Tabs:Iterate()
	return ipairs(self.frame.profile.filters)
end

function Tabs:GetBounds(i)
	return 33, i*33
end