--[[
	Panel for editing custom rules. Work in-progress.
	All Rights Reserved
--]]

local ADDON, Addon = (...):match('%w+'), _G[(...):match('%w+')]
local Frame = CreateFrame('Frame', nil, nil, 'IconSelectorPopupFrameTemplate')
Addon.FilterEdit = Frame
Addon.FilterEdit:Hide()


--[[ API ]]--

function Frame:Display(parent, rule, index)
	self:Startup()
	self:SetParent(parent)
	self:SetPoint('TOPLEFT', parent, 'TOPRIGHT', 38,0)
	self:Show()

	self.rule, self.index = rule, index
	self.BorderBox.IconSelectorEditBox:SetText(rule.title)
	self.Macro.EditBox:SetText(gsub(rule.macro or '', '\t', '  '))

	self.BorderBox.SelectedIconArea.SelectedIconButton:SetIconTexture(rule.icon)
	self.IconSelector:SetSelectedIndex(self:GetIndexOfIcon(rule.icon))
	self.IconSelector:ScrollToSelectedIndex()

	self.BorderBox.DeleteButton:SetShown(not self.rule.id)
	self.BorderBox.ShareButton:SetShown(not self.rule.id)
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

	self.MacroHeader = self:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
	self.MacroHeader:SetText('Enter Macro:')
	self.MacroHeader:SetMaxLines(1)
	self.MacroHeader:SetJustifyH('LEFT')
	self.MacroHeader:SetSize(100, 0)
	self.MacroHeader:SetPoint('TOPLEFT', 21, -78)

	self.Macro = CreateFrame('ScrollFrame', nil, self, 'InputScrollFrameTemplate')
	self.Macro.EditBox:SetScript('OnTextChanged', GenerateClosure(self.Refresh, self))
	self.Macro:SetPoint('TOPLEFT', self.MacroHeader, 'BOTTOMLEFT', 7, -10)
	self.Macro:SetSize(470, 55)
	self.Macro.hideCharCount = true
	InputScrollFrame_OnLoad(self.Macro)

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
	                               and hasContent(self.Macro.EditBox)

	self.BorderBox.ShareButton:SetEnabled(valid)
	self.BorderBox.OkayButton:SetEnabled(valid)
end

function Frame:OkayButton_OnClick()
	if self.rule then
		self.rule.icon = self.BorderBox.SelectedIconArea.SelectedIconButton:GetIconTexture()
		self.rule.title = self.BorderBox.IconSelectorEditBox:GetText()
		self.rule.macro = self.Macro.EditBox:GetText()
		self:Hide()
	end
end

function Frame:OnDelete()
	tremove(Addon.sets.customRules, self.index)
	Addon:SendSignal('RULES_LOADED')
	self:Hide()
end

function Frame:OnShare()
	-- TO DO
end

function Frame:OnHide()
	print('hello')
end