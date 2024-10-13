--[[
	A in-porgress implementation of bank tabs for retail.
	All Rights Reserved
--]]

if not (C_Bank and C_Bank.FetchPurchasedBankTabData) then
	return
end

local ADDON, Addon = (...):match('%w+'), _G[(...):match('%w+')]
local Filters = Addon.Parented:NewClass('FilterGroup', 'Frame')
Filters.Button = Addon.SideFilter

local TempPreset = {'all', 'player', 'account', 'consumable', 'trade', 'questitem'}


--[[ Constuct ]]--

function Filters:New(parent)
	local f = self:Super(Filters):New(parent)
	f.buttons = {}
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
	for _,id in ipairs(TempPreset) do -- temporary
	--for id in pairs(Addon.Rules.registry) do -- temporary
		local rule = Addon.Rules:Get(id)
		if rule then
			local button = GetOrCreateTableEntryByCallback(self.buttons, i, GenerateClosure(self.Button, self))
            button:SetPoint('TOP', 0, -i * 42)
            button:SetRule(rule)

			i = i + 1
		end
	end
end


--[[ Menu ]]--

function Filters:ShowMenu()
	MenuUtil.CreateContextMenu(self, function(_, drop)
		drop:SetTag(ADDON .. 'AddFilter')
		drop:CreateTitle('Installed Filters')

		for id, rule in pairs(Addon.Rules.registry) do 
			local check = drop:CreateCheckbox(rule.title,
				function() return tContains(TempPreset, rule.id) end,
				function() end)

			check:AddInitializer(function(check, _, menu)
				local edit = MenuTemplates.AttachAutoHideGearButton(check)
				edit:SetPoint('RIGHT')
				edit:SetScript('OnClick', function()
					--Addon.FilterEdit:Display(self.frame, rule)
					--menu:Close()
				end)
			
				MenuUtil.HookTooltipScripts(edit, function(tip)
					GameTooltip_SetTitle(tip, EDIT)
				end)

				if false then
					local delete = MenuTemplates.AttachAutoHideCancelButton(check)
					delete:SetPoint('RIGHT', edit, 'LEFT', -3, 0)
					delete:SetScript('OnClick', function()
						self:Delete(rule)
						menu:Close()
					end)

					MenuUtil.HookTooltipScripts(delete, function(tip)
						GameTooltip_SetTitle(tip, DELETE)
					end)
				end
			end)
		end

		drop:CreateDivider()
		drop:CreateButton(format('%s |cnPURE_GREEN_COLOR:New Filter|r', CreateAtlasMarkup('editmode-new-layout-plus')))
	end)
end

function Filters:Delete(rule)

end

-- temp hack
function Addon.Bank:New(...)
	local f = self:Super(Addon.Bank):New(...)
	f.FilterGroup = Filters(f)
	return f
end