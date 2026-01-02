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
	'OnSizeChanged', 'OnTextChanged', 'OnEscapePressed', 'OnEnterPressed',
}

function Base:NewClass(name, type, template, global)
	local class = self:Super(Base):NewClass(type, (global or self:GetClassName()) and (ADDON .. name), template == true and (ADDON .. name .. 'Template') or template)
	Addon[name] = class
	return class
end

function Base:Construct()
	local f = self:Super(Base):Construct()
	f:Hide()

	local autoScript = rawget(self, '__autoScript')
	if not autoScript then
		local chunks = {}
		for _, event in ipairs(self.Scripts) do
			if self[event] then
				tinsert(chunks, format('f:SetScript(%q, f[%q])', event, event))
			end
		end

		autoScript = #chunks > 0 and loadstring('return function(f)\n' .. table.concat(chunks, '\n') .. '\nend')() or nop
		self.__autoScript = autoScript
	end
	
	autoScript(f)
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

function Base:IsFarRight()
	return self:GetRight() > (GetScreenWidth() / self:GetEffectiveScale() / 2)
end