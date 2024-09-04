--[[
	A static, temporary implementation of bank tabs for retail, until I'm ready to mport the more feature-complete version from Bagnonium.
    All Rights Reserved
--]]

if not (C_Bank and C_Bank.FetchPurchasedBankTabData) then
	return
end

local ADDON, Addon = ...
local TempFilters = Addon.Parented:NewClass('SideFilters', 'Frame')
TempFilters.Preset = {
    {ALL, 413587, nop},
    {PLAYER, 895888, function(bag) return bag > Addon.LastBankBag end},
    {ACCOUNT_QUEST_LABEL, 629054, function(bag) return bag <= Addon.LastBankBag end}
}

function TempFilters:New(frame)
	local f = self:Super(TempFilters):New(frame)
    f.buttons = {}

    for i, entry in ipairs(self.Preset) do 
        local b = CreateFrame('ItemButton', nil, f)
        b.icon:SetTexture(entry[2])
        b:SetPoint('TOP', 0, -i*42)
        b:SetScript('OnClick', function() 
            frame.filter = entry[3]
            frame:SendFrameSignal('FILTERS_CHANGED')
        end)
        
        MenuUtil.HookTooltipScripts(b, function(tip)
            GameTooltip_SetTitle(tip, entry[1])
        end)

        local checked = b:CreateTexture()
        checked:SetTexture('Interface/Buttons/CheckButtonHilight')
        checked:SetBlendMode('ADD')
        checked:SetAllPoints()

        b.checked = checked
        f.buttons[i] = b
    end

    f:RegisterFrameSignal('FILTERS_CHANGED', 'Update')
    f:SetPoint('BOTTOMLEFT', frame, 'BOTTOMRIGHT')
    f:SetPoint('TOPLEFT', frame, 'TOPRIGHT')
    f:SetWidth(38)
    f:SetScale(.8)
    f:Update()
    f:Show()
    return f
end


function TempFilters:Update()
    for i, entry in ipairs(self.Preset) do 
       self.buttons[i].checked:SetShown(self.frame.filter == entry[3])
    end
end

function Addon.Bank:New(...)
    local f = self:Super(Addon.Bank):New(...)
    f.filter = nop
    f.FilterGroup = TempFilters(f)
    return f
end

function Addon.Bank:IsShowingBag(bag)
	return not self:GetProfile().hiddenBags[bag] and not (self.filter or nop)(bag)
end