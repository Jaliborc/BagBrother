--[[
	English Localization (default)
--]]

local ADDON = ...
local L = LibStub('AceLocale-3.0'):NewLocale(ADDON, 'enUS', true)

--keybindings
L.OpenBags = 'Open Inventory'
L.OpenBank = 'Open Bank'
L.OpenGuild = 'Open Guild Bank'
L.OpenVault = 'Open Void Storage'

--terminal
L.Commands = 'Command list'
L.CmdShowInventory = 'Toggles your inventory'
L.CmdShowBank = 'Toggles your bank'
L.CmdShowGuild = 'Toggles your guild bank'
L.CmdShowVault = 'Toggles your void storage'
L.CmdShowVersion = 'Prints the current version'
L.CmdShowOptions = 'Opens the configuration menu'
L.SkinError = 'Error applying skin.'
L.UpgradeError = 'Issue upgrading settings. If you run into issues, try resetting your settings.'

--titles
L.TitleBags = '%s\'s Inventory'
L.TitleBank = '%s\'s Bank'
L.TitleVault = '%s\'s Void Storage'
L.NormalBags = 'Normal Bags'
L.TradeBags = 'Trade Bags'
L.AmmoBags = 'Ammo Bags'

--tooltips
L.Bags = 'Bags'
L.Drag = 'Drag'
L.BrowseItems = 'Browse Items'
L.HideBag = 'Click to hide this bag.'
L.ShowBag = 'Click to show this bag.'
L.GuildFunds = 'Guild Funds'
L.NumAllowed = '%s Allowed'
L.NumWithdraw = '%d Withdraw'
L.NumDeposit = '%d Deposit'
L.NumRemaining = '%d Remaining'
L.WarbandMoney = 'Warband Money'
L.OfflineViewing = 'Offline Viewing'
L.Others = 'Others'

--menus
L.Characters = 'Characters'
L.Guilds = 'Guilds'
L.Locations = 'Locations'
L.EnterDescription = 'Enter Description:'
L.ServerSorting = 'Server-Side Sorting'
L.ServerSortingTip = 'Enable to let the game server sort items, instead of the addon doing it.'
L.CleanupOptions = 'Cleanup Options'
L.IncludeReagents = 'Include Reagents'
L.LockItems = 'Lock Item Slots'

--dialogs
L.AskMafia = 'Ask Mafia'
L.ConfirmDelete = 'Are you sure you want to delete %s\'s cached data?'
L.ConfirmTransfer = 'Depositing any items will remove all modifications and make them non-tradeable and non-refundable.|n|nDo you wish to continue?'
L.CannotPurchaseVault = 'You do not have enough money to unlock the Void Storage service|n|n|cffff2020Cost: %s|r'
L.PurchaseVault = 'Would you like to unlock the Void Storage service?|n|n|cffffd200Cost:|r %s'
L.ConfigurationMode = 'You are now in the client-side sorting configuration mode.|n|nClick item slots to toggle if they should be locked while sorting.'
L.OutOfDate = 'Your |cffffd200%s|r version might be outdated!|n%s reported having|n|cff82c5ff%s|r, please update if true.'
L.InvalidVersion = 'Your copy of |cffffd200%s|r is either corrupted or illegal.|nPlease download an official build for free.'