--[[
	Panel for editing custom rules. Work in-progress.
	All Rights Reserved
--]]

local ADDON, Addon = (...):match('%w+'), _G[(...):match('%w+')]
local Frame = CreateFrame('Frame', nil, nil, 'IconSelectorPopupFrameTemplate')
Addon.FilterEdit = Frame
Addon.FilterEdit:Hide()


--[[ API ]]--

function Frame:Create(parent, rule)
	tinsert(Addon.sets.customRules, rule)
	setmetatable(rule, Addon.Rules)

	Addon.FilterEdit:Display(parent, rule)
end

function Frame:Display(parent, rule)
	self:Startup()
	self:SetParent(parent)
	self:SetPoint('TOPLEFT', parent, 'TOPRIGHT', 38,0)
	self:Show()

	self.rule = rule
	self.BorderBox.IconSelectorEditBox:SetText(rule:GetValue('title', parent))
	self.CodeHeader:SetText(rule.search and 'Enter Search Query:' or ENTER_MACRO_LABEL)
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


--[[ Internal ]]--

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
	self.CodeHeader:SetSize(100, 0)
	self.CodeHeader:SetMaxLines(1)

	self.Code = CreateFrame('ScrollFrame', nil, self, 'InputScrollFrameTemplate')
	self.Code.EditBox:SetScript('OnTextChanged', GenerateClosure(self.Refresh, self))
	self.Code:SetPoint('TOPLEFT', self.CodeHeader, 'BOTTOMLEFT', 7, -10)
	self.Code:SetSize(470, 55)
	self.Code.hideCharCount = true
	InputScrollFrame_OnLoad(self.Code)

	self.iconDataProvider = CreateAndInitFromMixin(IconDataProviderMixin, IconDataProviderExtraType.None)
	self.IconSelector:SetSelectionsDataProvider(GenerateClosure(self.GetIconByIndex, self), GenerateClosure(self.GetNumIcons, self))
	self.IconSelector:SetPoint('TOPLEFT', self.BorderBox, 'TOPLEFT', 21, -196)
	self.IconSelector:SetSelectedCallback(function(_, icon)
		self.BorderBox.SelectedIconArea.SelectedIconButton:SetIconTexture(icon)
	end)

	self:SetSize(525, 594)
	self:ClearAllPoints()
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
	self.rule[self.rule.search and 'search' or 'macro'] = self.Code.EditBox:GetText()
	self.rule.icon = self.BorderBox.SelectedIconArea.SelectedIconButton:GetIconTexture()
	self.rule.title = self.BorderBox.IconSelectorEditBox:GetText()
	self:Done()
end

function Frame:OnDelete()
	tDeleteItem(Addon.sets.customRules, self.rule)
	self:Done()
end

function Frame:OnShare()
	local encoded = ''
	for key, value in pairs(self.rule) do
		encoded = encoded .. format(',%s=%s', key, (type(value) == 'string' and '"' .. value .. '"' or tostring(value)))
	end

	LibStub('Sushi-3.2').Popup:New {
		id = ADDON .. 'FilterEdit',
		text = 'Copy this data and share:',
		editBox = '{' .. encoded:sub(2) .. '}',
		button1 = OKAY
	}
end