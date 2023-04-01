--[[
	itemGroup.lua
		A grid of void storage items. Three kinds, defined by the `bag` input (sweet hack):
			DEPOSIT -> items to deposit
			WITHDRAW -> items to withdraw
			nil -> deposited items
--]]

local MODULE =  ...
local ADDON, Addon = MODULE:match('[^_]+'), _G[MODULE:match('[^_]+')]
local Items = Addon.ItemGroup:NewClass('VaultItemGroup')
Items.Button = Addon.VaultItem


--[[ Overrides ]]--

function Items:New(parent, bag, title)
	local f = self:Super(Items):New(parent, bag)
	f.Transposed = f:GetType() == 'vault'

	if title then
		f.Title = f:CreateFontString(nil, nil, 'GameFontHighlight')
		f.Title:SetPoint('BOTTOMLEFT', f, 'TOPLEFT', 0, 5)
		f.Title:SetText(title)
	end
	return f
end

function Items:RegisterEvents()
	self:Super(Items):RegisterEvents()

	if self:IsCached() then
		self:RegisterSignal('VAULT_OPEN', 'RegisterEvents')
	else
		local type = self:GetType()
		if type == DEPOSIT then
			self:RegisterEvent('VOID_STORAGE_DEPOSIT_UPDATE', 'Layout')
		elseif type == WITHDRAW then
			self:RegisterEvent('VOID_STORAGE_CONTENTS_UPDATE', 'Layout')
		else
			self:RegisterEvent('VOID_STORAGE_CONTENTS_UPDATE', 'ForAll', 'Update')
			self:RegisterEvent('VOID_STORAGE_UPDATE', 'ForAll', 'Update')
			self:RegisterEvent('VOID_TRANSFER_DONE', 'ForAll', 'Update')
		end
	end
end

function Items:Layout()
	self:Super(Items):Layout()

	if self.Title then
		local anyItems = self:NumButtons() > 0
		self:SetHeight(self:GetHeight() + (anyItems and 20 or 0))
		self.Title:SetShown(anyItems)
	end
end


--[[ Properties ]]--

function Items:NumSlots()
	if self:GetType() == DEPOSIT then
		return GetNumVoidTransferDeposit()
	elseif self:GetType() == WITHDRAW then
		return GetNumVoidTransferWithdrawal()
	elseif self:GetType() == 'vault' then
		return 160
	end
end

function Items:GetType()
	return self.bags[1].id
end
