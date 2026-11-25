--[[
	Mixin for the guild tab edit popup.
	All Rights Reserved
--]]

local ADDON, Addon = (...):match('[^_]+'), _G[(...):match('[^_]+')]

-- WoW Forever: IconSelectorPopupFrameTemplate registers itself for controller-interface
-- transitions in OnLoad (gamepad setup, init and uninit callbacks, prompted bindings). Created by
-- an addon, those callbacks are tainted, and the next switch between mouse and controller runs
-- them inside Forever's controller code, which then blocks SetPreferredGamepadInteractTarget
-- ("ADDON_ACTION_FORBIDDEN ... Bagnon_GuildBank") until /reload. The popup is a mouse dialog, so on
-- Forever it doesn't register; other clients keep the template's behaviour.
BagBrotherGuildTabEditPopupMixin = {}

function BagBrotherGuildTabEditPopupMixin:RegisterForTransitions()
	if Addon.IsForever then
		return
	end

	local base = IconSelectorPopupFrameTemplateMixin and IconSelectorPopupFrameTemplateMixin.RegisterForTransitions
	if base then
		base(self)
	end
end
