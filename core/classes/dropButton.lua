--[[
  dropButton.lua
		A dropdown button with a delete option
--]]

local ADDON, Addon = ...
local Button = Addon:NewModule('DropButton', LibStub('Sushi-3.1').DropButton:NewClass(nil, ADDON .. 'DropButton'))

function Button:Construct()
	local b = self:Super(Button):Construct()
	local del = CreateFrame('Button', nil, b)
	del:SetScript('OnClick', function() b:OnDelete() end)
	del:SetNormalAtlas('groupfinder-icon-redx')
	del:SetPoint('RIGHT', 14, 1)
	del:SetSize(10, 10)

	b.Delete = del
	return b
end

function Button:New(...)
	local b = self:Super(Button):New(...)
	b.Delete:SetShown(b.delFunc ~= nil)

	if b.Delete:IsShown() then
		b:SetCall('OnDelete', b.delFunc and function() b:delFunc() end)
		b.Delete:GetNormalTexture():SetDesaturated(not b.delFunc)
		b.Delete:SetEnabled(b.delFunc)
		b.right = b.right + 14
	end

	return b
end

function Button:OnDelete()
	self:FireCalls('OnDelete')
	self:FireCalls('OnUpdate')
end
