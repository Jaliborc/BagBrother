--[[
	English Localization (default)
--]]

local ADDON = ...
local L = LibStub('AceLocale-3.0'):NewLocale(ADDON, 'enUS', true)

--keybindings
L.ToggleBags = 'Toggle Inventory'
L.ToggleBank = 'Toggle Bank'
L.ToggleGuild = 'Toggle Guild Bank'
L.ToggleVault = 'Toggle Void Storage'

--terminal
L.Commands = 'command list'
L.CmdShowInventory = 'Toggles your inventory'
L.CmdShowBank = 'Toggles your bank'
L.CmdShowGuild = 'Toggles your guild bank'
L.CmdShowVault = 'Toggles your void storage'
L.CmdShowVersion = 'Prints the current version'
L.CmdShowOptions = 'Opens the configuration menu'

--frame titles
L.TitleBags = '%s\'s Inventory'
L.TitleBank = '%s\'s Bank'
L.TitleVault = '%s\'s Void Storage'

--interactions
L.Click = 'Left Click'
L.MiddleClickPhrase = 'Middle Click'
L.Drag = '<Drag>'
L.LeftClick = '<Left-Click>'
L.RightClick = '<Right-Click>'
L.DoubleClick = '<Double-Click>'
L.ShiftClick = '<Shift-Click>'

--tooltips
L.Total = 'Total'
L.GuildFunds = 'Guild Funds'
L.TipGoldOnRealm = '%s Totals'
L.NumWithdraw = '%d withdraw'
L.NumDeposit = '%d deposit'
L.NumRemainingWithdrawals = '%d Withdrawals Remaining'

--action tooltips
L.TipChangePlayer = '%s to view another character\'s items.'
L.TipCleanItems = '%s to clean items.'
L.TipConfigure = '%s to configure.'
L.TipDepositReagents = '%s to deposit reagents at the bank.'
L.TipDeposit = '%s to deposit.'
L.TipWithdraw = '%s to withdraw (%s remaining).'
L.TipHideBag = '%s to hide this bag.'
L.TipHideBags = '%s to hide the bags display.'
L.TipHideSearch = '%s to stop searching.'
L.TipMove = '%s to move.'
L.TipPurchaseBag = '%s to purchase this bank slot.'
L.TipResetPlayer = '%s to return to the current character.'
L.TipShowBag = '%s to show this bag.'
L.TipShowBags = '%s to show the bags display.'
L.TipHideEmptySlots = '%s to hide empty slots.'
L.TipShowEmptySlots = '%s to show empty slots.'
L.TipShowBank = '%s to toggle your bank.'
L.TipShowInventory = '%s to toggle your inventory.'
L.TipShowOptions = '%s to open the options menu.'
L.TipShowSearch = '%s to search.'
L.TipToggleBank = '%s to toggle bank.'
L.TipToggleTrade = '%s to toggle profession bags.'

--item tooltips
L.TipCountEquip = 'Equipped: %d'
L.TipCountBags = 'Bags: %d'
L.TipCountBank = 'Bank: %d'
L.TipCountVault = 'Vault: %d'
L.TipCountGuild = 'Guild: %d'
L.TipDelimiter = '|'

--dropdowns
L.OfflineViewing = 'Offline Viewing'
L.ConfirmDelete = 'Are you sure you want to delete %s\'s cached data?'
L.ServerSorting = 'Server-Side Sorting'
L.ServerSortingTip = 'Whether to let the game server sort items where available.'
L.CleanupOptions = 'Cleanup Options'
L.LockItems = 'Lock Item Slots'
L.RequiresClientSorting = 'Requires client-side sorting!'

--dialogs
L.AskMafia = 'Ask Mafia'
L.ConfirmTransfer = 'Depositing any items will remove all modifications and make them non-tradeable and non-refundable.|n|nDo you wish to continue?'
L.CannotPurchaseVault = 'You do not have enough money to unlock the Void Storage service|n|n|cffff2020Cost: %s|r'
L.PurchaseVault = 'Would you like to unlock the Void Storage service?|n|n|cffffd200Cost:|r %s'
L.ConfigurationMode = 'You are now in the client-side sorting configuration mode.|n|nClick item slots to toggle if they should be locked while sorting.'
L.OutOfDate = 'You might be running an outdated |cffffd200%s|r version!|nSomeone in your party or guild reported having|n|cff82c5ff%s|r, please update if true.'
L.InvalidVersion = 'Your copy of |cffffd200%s|r is either corrupted or illegal.|nPlease download an official build for free.'