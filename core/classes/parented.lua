--[[
	Abstract class for widgets that are parented to a frame.
  All Rights Reserved
--]]

local ADDON, Addon = ...
local Parented = Addon.Base:NewClass('Parented')

function Parented:New(parent)
  local f = self:Super(Parented):New(parent)
  while parent:GetParent() ~= UIParent do
    parent = parent:GetParent()
  end

  f.frame = parent
  return f
end

function Parented:GetProfile()
  return self.frame:GetProfile()
end

function Parented:GetBaseProfile()
  return self.frame:GetBaseProfile()
end

function Parented:GetOwner()
  return self.frame:GetOwner()
end

function Parented:IsCached()
  return self.frame:IsCached()
end

function Parented:GetFrameID()
  return self.frame.id
end

function Parented:GetFrame()
  return self.frame
end