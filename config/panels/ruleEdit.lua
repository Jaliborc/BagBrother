--[[
	Panel for editing custom rules.
	All Rights Reserved
--]]

local L, ADDON, Addon, Config = select(2, ...).Addon()
local Frame = CreateFrame('Frame', nil, nil, 'IconSelectorPopupFrameTemplate')
Addon.RuleEdit = Frame
Addon.RuleEdit:Hide()


--[[ Menu ]]--

function Frame:OpenMenu(anchor)
	MenuUtil.CreateContextMenu(anchor, function(_, drop)
		drop:SetScrollMode(600)
		drop:SetTag(ADDON .. 'RuleEdit')
		drop:CreateTitle(L.InstalledFilters)

		self:SetParent(anchor)
		self:CreateCheckboxes(drop, Addon.Rules.Registry)

		if #Addon.sets.customRules > 0 then
			drop:CreateDivider()
			drop:CreateTitle(L.CustomFilters)
			self:CreateCheckboxes(drop, Addon.sets.customRules)
		end

		drop:CreateDivider()
		
		local new = drop:CreateButton(format('%s |cnPURE_GREEN_COLOR:%s|r', CreateAtlasMarkup('editmode-new-layout-plus'), L.NewFilter))
		new:CreateButton(' ' .. SEARCH, function() self:Create {title = L.NewSearch, search = ''} end)
		new:CreateButton(' ' .. MACRO, function() self:Create {title = L.NewMacro} end)
		new:CreateButton(' ' .. L.Import, function()
			LibStub('Sushi-3.2').Popup:New {
				id = ADDON .. 'ImportFilter',
				button1 = OKAY, button2 = CANCEL,
				text = L.ImportPopup,
				editBox = '',

				OnAccept = function(_, encoded)
					local ok, rule = pcall(loadstring('return ' .. encoded))
					if ok and rule then
						self:Create(rule)
					end
				end
			}
		end)
	end)
end

function Frame:CreateCheckboxes(drop, rules)
	local parent = self:GetParent()
	local enabled, frame = parent.rules, parent.frame

	local sorted = GetPairsArray(rules)
	sort(sorted, function(a, b)
		return a.value.title < b.value.title end)

	for i, entry in pairs(sorted) do 
		local rule, id = entry.value, entry.key
		local title = rule:GetValue('title', frame)
		local icon = rule:GetIconMarkup(16, frame)

		local isEnabled = GenerateClosure(tContains, enabled, id)
		local toggle = function()
			(isEnabled() and tDeleteItem or tinsert)(enabled, id)
			frame:SendFrameSignal('FILTERS_CHANGED')
		end

		local check = drop:CreateCheckbox(icon ..' '.. title, isEnabled, toggle)
		check:SetCanSelect(function() return #enabled > 1 or not isEnabled() end)
		check:AddInitializer(function(check, _, menu)
			local edit = MenuTemplates.AttachAutoHideGearButton(check)
			edit:SetPoint('RIGHT')
			edit:SetScript('OnClick', function()
				self:Display(rule)
				menu:Close()
			end)

			MenuUtil.HookTooltipScripts(edit, function(tip)
				GameTooltip_SetTitle(tip, EDIT)
			end)
		end)
	end
end


--[[ Editing ]]--

function Frame:Create(rule)
	tinsert(Addon.sets.customRules, setmetatable(rule, Addon.Rules))
	self:Display(rule)
end

function Frame:Display(rule)
	self:ClearAllPoints()
	self:Startup()
	self:Show()

	if self:GetParent():GetParent():IsFarRight() then
		self:SetPoint('TOPRIGHT', self:GetParent():GetParent(), 'TOPLEFT', -38,0)
	else
		self:SetPoint('TOPLEFT', self:GetParent():GetParent(), 'TOPRIGHT', 38,0)
	end

	self.rule = rule
	self.BorderBox.IconSelectorEditBox:SetText(rule:GetValue('title', self:GetParent()))
	self.CodeHeader:SetText(rule.search and L.EnterSearch or ENTER_MACRO_LABEL)
	self.Code.EditBox:SetText(gsub(rule.macro or rule.search or '', '\t', '  '))

	self.BorderBox.SelectedIconArea.SelectedIconButton:SetIconTexture(rule.icon)
	self.IconSelector:SetSelectedIndex(self:GetIndexOfIcon(rule.icon))
	self.IconSelector:ScrollToSelectedIndex()

	self.BorderBox.DeleteButton:SetShown(not self.rule.id)
	self.BorderBox.ShareButton:SetShown(not self.rule.id)
end

function Frame:Done()
	Addon:SendSignal('RULES_LOADED')
	self:Hide()
end


--[[ Editing Events ]]--

function Frame:Startup()
	self.BorderBox.IconSelectionText:ClearAllPoints()
	self.BorderBox.IconSelectionText:SetPoint('BOTTOMLEFT', self.IconSelector, 'TOPLEFT', 0,10)
	self.BorderBox.IconSelectorEditBox:SetScript('OnTextChanged', GenerateClosure(self.Refresh, self))

	self.BorderBox.IconTypeDropdown:ClearAllPoints()
	self.BorderBox.IconTypeDropdown:SetPoint('BOTTOMRIGHT', self.IconSelector, 'TOPRIGHT', -33,0)
	self.BorderBox.EditBoxHeaderText:SetText('Enter Filter Name:')

	self.BorderBox.DeleteButton = CreateFrame('Button', nil, self.BorderBox, 'UIPanelButtonNoTooltipTemplate')
	self.BorderBox.DeleteButton:SetScript('OnClick', GenerateClosure(self.OnDelete, self))
	self.BorderBox.DeleteButton:SetPoint('BOTTOMLEFT', 13, 13)
	self.BorderBox.DeleteButton:SetTextToFit(DELETE)

	self.BorderBox.ShareButton = CreateFrame('Button', nil, self.BorderBox, 'UIPanelButtonNoTooltipTemplate')
	self.BorderBox.ShareButton:SetScript('OnClick', GenerateClosure(self.OnShare, self))
	self.BorderBox.ShareButton:SetPoint('LEFT', self.BorderBox.DeleteButton, 'RIGHT', 0,0)
	self.BorderBox.ShareButton:SetTextToFit(SOCIAL_SHARE_TEXT)

	self.CodeHeader = self:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
	self.CodeHeader:SetPoint('TOPLEFT', 21, -78)
	self.CodeHeader:SetJustifyH('LEFT')
	self.CodeHeader:SetSize(200, 0)
	self.CodeHeader:SetMaxLines(1)

	self.Code = CreateFrame('ScrollFrame', nil, self, 'InputScrollFrameTemplate')
	self.Code.EditBox:SetScript('OnTextChanged', GenerateClosure(self.Refresh, self))
	self.Code:SetPoint('TOPLEFT', self.CodeHeader, 'BOTTOMLEFT', 7, -10)
	self.Code:SetSize(470, 55)
	self.Code.hideCharCount = true
	InputScrollFrame_OnLoad(self.Code)

	self.Help = CreateFrame('Button', nil, self, 'UIPanelInfoButton')
	self.Help:SetScript('OnClick', GenerateClosure(self.OnHelp, self))
	self.Help:SetPoint('BOTTOMRIGHT', self.Code, 'TOPRIGHT', 0, 10)
	
	MenuUtil.HookTooltipScripts(self.Help, function(tip)
		GameTooltip_SetTitle(tip, GAMEMENU_HELP)
	end)

	self.iconDataProvider = CreateAndInitFromMixin(IconDataProviderMixin, IconDataProviderExtraType.None)
	self.IconSelector:SetSelectionsDataProvider(GenerateClosure(self.GetIconByIndex, self), GenerateClosure(self.GetNumIcons, self))
	self.IconSelector:SetPoint('TOPLEFT', self.BorderBox, 'TOPLEFT', 21, -196)
	self.IconSelector:SetSelectedCallback(function(_, icon)
		self.BorderBox.SelectedIconArea.SelectedIconButton:SetIconTexture(icon)
	end)

	self:SetSize(525, 594)
	self.Startup = nop
end

function Frame:Refresh()
	local function hasContent(box) return box:GetText():match('^%s*$') == nil end
	local valid = not self.rule.id and hasContent(self.BorderBox.IconSelectorEditBox)
	                               and hasContent(self.Code.EditBox)

	self.BorderBox.ShareButton:SetEnabled(valid)
	self.BorderBox.OkayButton:SetEnabled(valid)
end

function Frame:OkayButton_OnClick()
	if self.BorderBox.OkayButton:IsEnabled() then
		self.rule[self.rule.search and 'search' or 'macro'] = self.Code.EditBox:GetText()
		self.rule.icon = self.BorderBox.SelectedIconArea.SelectedIconButton:GetIconTexture()
		self.rule.title = self.BorderBox.IconSelectorEditBox:GetText()
		self:Done()
	else
		self:Hide()
	end
end

function Frame:OnDelete()
	tDeleteItem(Addon.sets.customRules, self.rule)
	self:Done()
end

function Frame:OnShare()
	local encoded = ''
	for key, value in pairs(self.rule) do
		encoded = encoded .. format(',%s=%s', key, (type(value) == 'string' and '"' .. value:gsub('"', '\\"') .. '"' or tostring(value)))
	end

	LibStub('Sushi-3.2').Popup:New {
		id = ADDON .. 'ShareFilter',
		text = L.SharePopup, button1 = OKAY,
		editBox = '{' .. encoded:sub(2) .. '}'
	}
end

function Frame:OnHelp()
	LibStub('Sushi-3.2').Popup:External('https://youtu.be/sie39ZW8uZo')
end