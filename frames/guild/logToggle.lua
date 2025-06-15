--[[
	logToggle.lua
		A guild log toggle widget
--]]

local ADDON, Addon = (...):match('[^_]+'), _G[(...):match('[^_]+')]
local Toggle = Addon.Tipped:NewClass('LogToggle', 'CheckButton', true)

Toggle.Icons = {
	'Interface/Icons/INV_Crate_03',
	'Interface/Icons/INV_Misc_Coin_01'
}

Toggle.Titles = {
	GUILD_BANK_LOG,
	GUILD_BANK_MONEY_LOG
}


--[[ Construct ]]--

function Toggle:NewSet(parent)
	local set = {}
	for id in ipairs(self.Icons) do
		set[id] = self(parent, id)
	end
	return set
end

function Toggle:New(parent, id)
	local b = self:Super(Toggle):New(parent)
	b:RegisterFrameSignal('LOG_SELECTED', 'OnLogSelected')
	b.Icon:SetTexture(self.Icons[id])
	b.id = id
	return b
end


--[[ Events ]]--

function Toggle:OnLogSelected(logID)
	self:SetChecked(logID == self.id)
end

function Toggle:OnClick()
	self:SendFrameSignal('LOG_SELECTED', self:GetChecked() and self.id)
end

function Toggle:OnEnter()
	self:ShowTooltip(self.Titles[self.id])
end
