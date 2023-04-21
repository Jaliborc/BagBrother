--[[
	guild.lua
		A specialized version of the window frame for the guild bank
--]]

local MODULE =  ...
local ADDON, Addon = MODULE:match('[^_]+'), _G[MODULE:match('[^_]+')]
local Frame = Addon.Frame:NewClass('GuildFrame')

Frame.NoGuild = setmetatable({name=ERR_GUILD_PLAYER_NOT_IN_GUILD, address=''}, {__index = Addon.player})
Frame.CloseSound = SOUNDKIT.GUILD_VAULT_CLOSE
Frame.OpenSound = SOUNDKIT.GUILD_VAULT_OPEN
Frame.MoneyFrame = Addon.GuildMoneyFrame
Frame.ItemGroup = Addon.GuildItemGroup
Frame.BagGroup = Addon.GuildTabGroup
Frame.Title = '%s'
Frame.Bags = {}

for i = 1, MAX_GUILDBANK_TABS do
	Frame.Bags[i] = i
end


--[[ Construct ]]--

function Frame:New(id)
	local f = self:Super(Frame):New(id)
	local log = Addon.LogFrame:New(f)
	log:SetPoint('BOTTOMRIGHT', -10, 35)
	log:SetPoint('TOPLEFT', 10, -70)
	log:Hide()

	local edit = Addon.EditFrame:New(f)
	edit:SetPoint('BOTTOMRIGHT', -32, 35)
	edit:SetPoint('TOPLEFT', 10, -75)
	edit:Hide()

	f.LogToggles = Addon.LogToggle:NewSet(f)
	f.Log, f.EditFrame = log, edit
	return f
end

function Frame:RegisterSignals()
	self:Super(Frame):RegisterSignals()
	self:RegisterFrameSignal('LOG_SELECTED', 'OnLogSelected')
end


--[[ Events ]]--

function Frame:OnHide()
	self:Super(Frame):OnHide()

	LibStub('Sushi-3.1').Popup:Hide('GUILDBANK_WITHDRAW')
	LibStub('Sushi-3.1').Popup:Hide('GUILDBANK_DEPOSIT')
	LibStub('Sushi-3.1').Popup:Hide('CONFIRM_BUY_GUILDBANK_TAB')
	CloseGuildBankFrame()
end

function Frame:OnLogSelected(_, logID)
	self.ItemGroup:SetShown(not logID)
	self.EditFrame:SetShown(logID == 3)
	self.Log:SetShown(logID and logID < 3)
end


--[[ Proprieties ]]--

function Frame:ListMenuButtons()
	for i, toggle in ipairs(self.LogToggles) do
		tinsert(self.menuButtons, toggle)
	end

	self:Super(Frame):ListMenuButtons()
end

function Frame:SortItems()
	Addon.Sorting:Start(self.id, self:GetOwner(), {GetCurrentGuildBankTab()})
end

function Frame:IsCached()
	return not Addon.Events.AtGuild or self:GetOwner().offline
end

function Frame:GetOwner()
	return self.owner or Addon.guild or self.NoGuild
end

function Frame:IsBagGroupShown() return true end
function Frame:HasOwnerSelector() end
function Frame:HasBagToggle() end

