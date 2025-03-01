--[[
	Frame-specific settings menu.
	All Rights Reserved
--]]


local C = LibStub('C_Everywhere').AddOns
local L, ADDON, Addon, Config = select(2, ...).Addon()
local Frames = Addon.GeneralOptions:New('FrameOptions', CreateAtlasMarkup('Vehicle-HammerGold-2'))

function Frames:Populate()
	-- Selection
	self.sets = Addon.player.profile[self.frame]
	self:AddFrameChoice()

	local enabled = Addon.Frames:IsEnabled(self.frame)
	local enable = self:AddCheck('enabled')
	enable:SetValue(enabled)
	enable:SetCall('OnInput', function()
		local addon = Addon.Frames:Get(self.frame).addon
		if addon then
			if enabled then
				C.DisableAddOn(addon)
			else
				C.EnableAddOn(addon)
			end
		end
	end)

	if enabled then
		-- Display
		self:Add('Header', DISPLAY, 'GameFontHighlight', true)
		self:AddRow(Config.displayRowHeight, function()
			if Config.components then
				if self.frame == 'inventory' or self.frame == 'bank' then
					self:AddCheck('bagToggle')

					if DepositReagentBank and self.frame == 'bank' then
						self:AddCheck('deposit')
					end
				end

				self:AddCheck('sort')
				self:AddCheck('search')
				self:AddCheck('options')

				if self.frame ~= 'vault' then
					self:AddCheck('money')

					if not Addon.IsClassic and self.frame ~= 'guild' then
						self:AddCheck('currency')
					end
				end

				self:AddCheck('broker')
			end

			if Config.tabs then
				self:AddCheck('leftTabs')
			end
		end)

		-- Appearance
		self:Add('Header', L.Appearance, 'GameFontHighlight', true)
		self:AddRow(300, function()
			if Config.skins then
				local skins = {arg = 'skin'}
				for i, skin in Addon.Skins:Iterate() do
					skins[i] = {key = skin.id, text = skin.title, tip = skin.tooltip}
				end
				self:AddChoice(skins).bottom = 5

				local current = Addon.Skins:Get(self.sets.skin)
				if current then
					if current.centerColor then
						self:AddColor('color'):SetKeys{left = 25, top = -5}
					end
					if current.borderColor then
						self:AddColor('borderColor'):SetKeys{left = 25, top = -5}
					end
				end
			end

			self:AddChoice{arg = 'strata', {key = 'LOW', text = LOW}, {key = 'MEDIUM', text = AUCTION_TIME_LEFT2}, {key = 'HIGH', text = HIGH}}
			self:AddPercentage('scale', 20, 300)
			self:AddPercentage('alpha')

			self:AddBreak()
			self:AddPercentage('itemScale', 20, 200)
			self:AddSlider('spacing', -15, 15)
	
			if Config.columns then
				self:AddSlider('columns', 1, 50)
			end

			
			self:AddBreak()
			self:AddCheck('reverseBags')
			self:AddCheck('reverseSlots')
			self:AddChoice{arg = 'bagBreak', {key = 0, text = NEVER}, {key = 1, text = L.ByType}, {key = 2, text = ALWAYS}}
			if self.sets.bagBreak > 0 then
				self:AddPercentage('breakSpace', 100, 200):SetSmall(true)
			end
		end)
	end
end
