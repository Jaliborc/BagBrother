--[[
	A dropdown button with a delete option.
	All Rights Reserved		
--]]

local ADDON, Addon = ...
local Button = Addon:NewModule('DropButton', LibStub('Sushi-3.2').DropButton:NewClass(nil, ADDON .. 'DropButton'))

function Button:Construct()
	local b = self:Super(Button):Construct()
	local del = CreateFrame('Button', nil, b)
	del:SetScript('OnEnter', function() b:OnDeleteEnter() end)
	del:SetScript('OnLeave', function() b:OnDeleteLeave() end)
	del:SetScript('OnClick', function() b:OnDelete() end)
	del:SetNormalTexture(130775)
	del:SetPoint('RIGHT', 14, 1)
	del:SetSize(10, 10)
	del:SetAlpha(.5)

	b.Delete = del
	return b
end

function Button:New(...)
	local b = self:Super(Button):New(...)
	b:SetCall('OnDelete', b.delFunc and function() b:delFunc() end)
	b.right = b.right + (b.delFunc and 14 or 0)
	b.Delete:SetShown(b.delFunc)
	return b
end

function Button:OnDelete()
	self:FireCalls('OnDelete')
	self:FireCalls('OnUpdate')
end

function Button:OnDeleteEnter()
	self.Delete:SetAlpha(1)

	GameTooltip:SetOwner(self.Delete, 'ANCHOR_LEFT')
	GameTooltip:SetText(DELETE)
	GameTooltip:Show()
end

function Button:OnDeleteLeave()
	self.Delete:SetAlpha(.5)
	GameTooltip:Hide()
end
