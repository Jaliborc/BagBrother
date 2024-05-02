--[[
	guild.lua
		A specialized version of the window frame for the guild bank
--]]

local MODULE =  ...
local ADDON, Addon = MODULE:match('[^_]+'), _G[MODULE:match('[^_]+')]
local Guild = Addon.Frame:NewClass('Guild')
local Sushi = LibStub('Sushi-3.2')

Guild.PickupItem = PickupGuildBankItem
Guild.NoGuild = setmetatable({name=RED_FONT_COLOR:WrapTextInColorCode(ERR_GUILD_PLAYER_NOT_IN_GUILD), address='', isguild=true}, {__index = Addon.player})
Guild.CloseSound = SOUNDKIT.GUILD_VAULT_CLOSE
Guild.OpenSound = SOUNDKIT.GUILD_VAULT_OPEN
Guild.MoneyFrame = Addon.GuildMoneyFrame
Guild.ItemGroup = Addon.GuildItemGroup
Guild.BagGroup = Addon.GuildTabGroup
Guild.Title = '%s'
Guild.Bags = {}

for i = 1, MAX_GUILDBANK_TABS do
	Guild.Bags[i] = i
end


--[[ Construct ]]--

function Guild:New(id)
	local f = self:Super(Guild):New(id)
	local log = Addon.LogFrame:New(f)
	log:SetPoint('BOTTOMRIGHT', -10, 35)
	log:SetPoint('TOPLEFT', 10, -70)
	log:Hide()

	f.LogToggles = Addon.LogToggle:NewSet(f)
	f.Log = log
	return f
end

function Guild:RegisterSignals()
	self:Super(Guild):RegisterSignals()
	self:RegisterFrameSignal('LOG_SELECTED', 'OnLogSelected')
end


--[[ Events ]]--

function Guild:OnLogSelected(_, logID)
	self.ItemGroup:SetShown(not logID)
	self.Log:SetShown(logID)
end

function Guild:OnHide()
	self:Super(Guild):OnHide()
	Sushi.Popup:Cancel(CONFIRM_BUY_GUILDBANK_TAB)
	Sushi.Popup:Cancel(GUILDBANK_WITHDRAW)
	Sushi.Popup:Cancel(GUILDBANK_DEPOSIT)
	CloseGuildBankFrame()
end


--[[ Properties ]]--

function Guild:GetItemInfo(bag, slot)
	if self:IsCached() then
		return self:Super(Guild):GetItemInfo(bag, slot)
	end

	local link = GetGuildBankItemLink(bag, slot)
	if link then
		local item = {hyperlink = link, itemID = GetItemInfoInstant(link)}
		item.iconFileID, item.stackCount, item.isLocked = GetGuildBankItemInfo(bag, slot)
		_, _, item.quality = GetItemInfo(link) 
		return item
	end
	return {}
end

function Guild:IsCached()
	return not C_PlayerInteractionManager.IsInteractingWithNpcOfType(Enum.PlayerInteractionType.GuildBanker) or self:GetOwner().offline
end

function Guild:GetOwner()
	return self.owner or Addon.guild or self.NoGuild
end

function Guild:NumSlots(bag)
	return self:IsShowingBag(bag) and 98 or 0
end

function Guild:IsShowingBag(bag)
	return bag == GetCurrentGuildBankTab()
end

function Guild:GetExtraButtons() return self.LogToggles end
function Guild:IsBagGroupShown() return true end
function Guild:HasOwnerSelector() end