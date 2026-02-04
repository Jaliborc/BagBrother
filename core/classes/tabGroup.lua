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
	f.rules = f.frame.profile.rules[id]
	f.sets = f.frame.profile.activeRules
	f.id, f.buttons = id, {}

	f:RegisterSignal('RULES_CHANGED', 'Update')
	f:RegisterFrameSignal('OWNER_CHANGED', 'Update')
	f:RegisterFrameSignal('FILTERS_CHANGED', 'Update')
	f:SetActive(Addon.Rules:Get(f.sets[id]) or Addon.Rules:Get(f.rules[1]))
	f:Update()

	return f
end

function Tabs:Update()
	local sx, sy, ox, oy = self:LayoutTraits()
	local active = self:GetActive()
	local i, x,y = 1, 0,0

	for _,id in ipairs(self.rules) do
		local rule = Addon.Rules:Get(id)
		if rule then
			local button = GetOrCreateTableEntryByCallback(self.buttons, i, GenerateClosure(self.Button, self))
            button:SetRule(rule, rule == active)
			button:SetPoint('TOPLEFT', x, -y)
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
	self.frame.rules[self.id] = {data = rule, compiled = rule:Compile()}
	self.sets[self.id] = rule.id
end

function Tabs:GetActive()
	return self.frame.rules[self.id].data
end