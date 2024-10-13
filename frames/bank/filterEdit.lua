local ADDON, Addon = (...):match('%w+'), _G[(...):match('%w+')]
local Frame = CreateFrame('Frame', nil, nil, 'IconSelectorPopupFrameTemplate')

function Frame:Startup()
	self.BorderBox.IconSelectionText:ClearAllPoints()
	self.BorderBox.IconSelectionText:SetPoint('BOTTOMLEFT', self.IconSelector, 'TOPLEFT', 0, 10)

	self.BorderBox.IconTypeDropdown:ClearAllPoints()
	self.BorderBox.IconTypeDropdown:SetPoint('BOTTOMRIGHT', self.IconSelector, 'TOPRIGHT', -33, 0)
	self.BorderBox.EditBoxHeaderText:SetText('Enter Filter Name:')

	self.MacroHeader = self:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
	self.MacroHeader:SetText('Enter Macro:')
	self.MacroHeader:SetMaxLines(1)
	self.MacroHeader:SetJustifyH('LEFT')
	self.MacroHeader:SetSize(100, 0)
	self.MacroHeader:SetPoint('TOPLEFT', 21, -78)

	self.Macro = CreateFrame('ScrollFrame', nil, self, 'InputScrollFrameTemplate')
	self.Macro:SetPoint('TOPLEFT', self.MacroHeader, 'BOTTOMLEFT', 7, -10)
	self.Macro:SetSize(470, 55)
	self.Macro.CharCount:Hide()

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

function Frame:Display(parent, rule)
	self:Startup()
	self:SetParent(parent)
	self:SetPoint('TOPLEFT', parent, 'TOPRIGHT', 38,0)
	self:Show()

	self.IconSelector:SetSelectedIndex(self:GetIndexOfIcon(rule.icon))
	self.IconSelector:ScrollToSelectedIndex()
	self.BorderBox.SelectedIconArea.SelectedIconButton:SetIconTexture(rule.icon)

	self.BorderBox.IconSelectorEditBox:SetText(rule.title)
	self.Macro.EditBox:SetText(gsub(rule.macro or '', '\t', '  '))

	--self.BorderBox.IconSelectorEditBox.OnTextChanged
	--self.BorderBox.OkayButton:SetEnabled(not rule.id)
end

function Frame:OkayButton_OnClick()
	--print(self.BorderBox.IconSelectorEditBox:GetText() or '')
	--print(self.BorderBox.SelectedIconArea.SelectedIconButton:GetIconTexture() or QUESTION_MARK_ICON)
	--print(self.Macro.EditBox:GetText())
	self:Hide()
end

Addon.FilterEdit = Frame
--Frame:Hide()