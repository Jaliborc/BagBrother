--[[
	Manages frame creation and display.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local C = LibStub('C_Everywhere').AddOns
local Frames = Addon:NewModule('Frames')
Frames.Registry = {
	{id = 'inventory', name = INVENTORY_TOOLTIP, icon = 130716},
	{id = 'bank', name = BANK, icon = 'Interface/Addons/BagBrother/art/achievement-guildperk-mobilebanking', addon = ADDON..'_Bank'},
	{id = 'guild', name = GUILD_BANK, icon = 'Interface/Addons/BagBrother/art/vas-guildfactionchange', addon = GuildBankFrame_LoadUI and ADDON..'_GuildBank' or false},
	{id = 'vault', name = VOID_STORAGE, icon = 1711338, addon = VoidStorage_LoadUI and ADDON..'_VoidStorage' or false},
}


--[[ Frame Control ]]--

function Frames:Update()
	self:SendSignal('UPDATE_ALL')
end

function Frames:Toggle(id, owner)
	return not self:IsShown(id) and self:Show(id, owner, true) or self:Hide(id, true)
end

function Frames:Show(id, owner, manual)
	local frame = self:New(id)
	if frame then
		frame.manualShown = frame.manualShown or manual
		frame:SetOwner(owner)
		frame:Show()
	end
	return frame
end

function Frames:Hide(id, manual)
	local frame = self:Get(id)
	if frame[0] and (manual or not frame.manualShown) then
		frame.manualShown = nil
		frame:Hide()
	end
	return frame
end

function Frames:IsShown(id)
	local frame = self:Get(id)
	return frame[0] and frame:IsShown()
end


--[[ Bag Control ]]--

function Frames:ToggleBag(frame, bag)
	if self:HasBag(frame, bag) then
		return self:Toggle(frame)
	end
end

function Frames:ShowBag(frame, bag)
	if self:HasBag(frame, bag) then
		return self:Show(frame)
	end
end

function Frames:HideBag(frame, bag)
	if self:HasBag(frame, bag) then
		return self:Hide(frame)
	end
end

function Frames:HasBag(frame, bag)
	return not Addon.sets.displayBlizzard or self:IsEnabled(frame) and not Addon.player.profile[frame].hiddenBags[bag]
end


--[[ Registry ]]--

function Frames:New(id)
	if self:IsEnabled(id) then
		local frame, i = self:Get(id)
		if not frame[0] and (not frame.addon or C.LoadAddOn(frame.addon)) then
			frame = Addon[id:gsub('^.', id.upper)]:New(frame)
	 		self.Registry[i] = frame
			return frame
		end

		return frame
 	end
end

function Frames:Get(id)
	local i, frame = FindInTableIf(self.Registry, function(frame) return frame.id == id end)
	return frame, i
end

function Frames:Iterate()
	return ipairs(self.Registry)
end

function Frames:IsEnabled(id)
	local addon = self:Get(id).addon
	if addon then
		return C.GetAddOnEnableState(addon, UnitName('player')) == 2
	else
		return addon ~= false and Addon.player.profile[id].enabled
	end
end