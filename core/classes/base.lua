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
	for i, script in ipairs(self.Scripts) do
		if f[script] and f:HasScript(script) then
			f:SetScript(script, f[script])
		end
	end
	return f
end

function Base:RegisterFrameSignal(msg, call, ...)
	self:RegisterSignal(self:GetFrameID() .. msg, call or msg, ...)
end

function Base:UnregisterFrameSignal(msg, ...)
	self:UnregisterSignal(self:GetFrameID() .. msg, ...)
end

function Base:SendFrameSignal(msg, ...)
	self:SendSignal(self:GetFrameID() .. msg, ...)
end

function Base:UnregisterAll()
	self:UnregisterAllMessages()
	self:UnregisterAllEvents()
end