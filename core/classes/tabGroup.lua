--[[
	A container frame for customizable tabs.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local Tabs = Addon.Parented:NewClass('TabGroup', 'Frame')
Tabs.Button = Addon.Tab


--[[ Construct ]]--

function Tabs:New(parent, id)
	local f = self:Super(Tabs):New(parent)
	f.active = f.frame.profile.activeRules
	f.rules = f.frame.profile.rules[id]
	f.id, f.buttons = id, {}

	f:RegisterSignal('RULES_LOADED', 'Update')
	f:RegisterFrameSignal('OWNER_CHANGED', 'Update')
	f:RegisterFrameSignal('FILTERS_CHANGED', 'Update')
	f:SetActive(f:GetActive() or Addon.Rules:Get(f.rules[1]))

	return f
end

function Tabs:Update()
	local sx, sy, ox, oy = self:LayoutTraits()
	local i, x,y = 1, 0,0

	for _,id in ipairs(self.rules) do
		local rule = Addon.Rules:Get(id)
		if rule then
			local button = GetOrCreateTableEntryByCallback(self.buttons, i, GenerateClosure(self.Button, self))
			button:SetPoint('TOPLEFT', x, -y)
            button:SetRule(rule)
			button:Show()

			y = y + button:GetHeight() * sy + oy
			x = x + button:GetWidth() * sx + ox
			i = i + 1
		end
	end

	for k = i, #self.buttons do
		self.buttons[k]:Hide()
	end

	self:SetSize(max(33,x), max(33,y))
end


--[[ API ]]--

function Tabs:SetActive(rule)
	self.active[self.id] = rule.id
	self.frame.compiled[self.id] = rule:Compile()
	self:SendFrameSignal('FILTERS_CHANGED')
end

function Tabs:GetActive()
	local ruleID = self.active[self.id]
	return ruleID and Addon.Rules:Get(ruleID)
end