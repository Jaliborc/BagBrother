--[[
	Abstract class that all others derive from.
	All Rights Reserved
--]]

local ADDON, Addon = ...
local Base = Addon:NewModule('Base', LibStub('Poncho-2.0')(), 'MutexDelay-1.0')

Base.Scripts = {
	'OnShow', 'OnHide',
	'OnEnter', 'OnLeave',
	'OnDragStart', 'OnReceiveDrag',
	'OnMouseDown', 'OnMouseUp', 'OnMouseWheel',
	'OnClick', 'PostClick', 'PreClick', 'OnDoubleClick', 'OnHyperlinkClick',
	'OnTextChanged', 'OnEscapePressed', 'OnEnterPressed',
}

function Base:NewClass(name, type, template, global)
	local class = self:Super(Base):NewClass(type, (global or self:GetClassName()) and (ADDON .. name), template == true and (ADDON .. name .. 'Template') or template)
	Addon[name] = class
	return class
end

function Base:Construct()
	local f = self:Super(Base):Construct()
	f:Hide()
	
	for i, script in ipairs(self.Scripts) do
		if f.__index[script] then
			f:SetScript(script, f[script])
		end
	end
	return f
end

function Base:RegisterFrameSignal(event, call, ...)
	self:RegisterSignal(self:GetFrameID() .. '.' .. event, call or event, ...)
end

function Base:UnregisterFrameSignal(event)
	self:UnregisterSignal(self:GetFrameID() .. '.' .. event)
end

function Base:SendFrameSignal(event, ...)
	self:SendSignal(self:GetFrameID() .. '.' .. event, ...)
end

function Base:UnregisterAll() -- remove on wildaddon 1.1
	self:UnregisterAllMessages()
	self:UnregisterAllEvents()
end