--[[
	German Localization
--]]

local ADDON = ...
local L = LibStub('AceLocale-3.0'):NewLocale(ADDON, 'deDE')
if not L then return end

--keybindings
L.OpenBags = 'Inventar umschalten'
L.OpenBank = 'Bank umschalten'
L.OpenGuild = 'Gildenbank umschalten'
L.OpenVault = 'Leerenlager umschalten'

--terminal
L.Commands = 'Befehlsliste'
L.CmdShowInventory = 'Schaltet das Inventar um'
L.CmdShowBank = 'Schaltet die Bank um'
L.CmdShowGuild = 'Schaltet die Gildenbank um'
L.CmdShowVault = 'Schaltet das Leerenlager um'
L.CmdShowVersion = 'Zeigt die aktuelle Version an'
L.CmdShowOptions = 'Öffnet das Konfigurationsmenü'

--frame titles
L.TitleBags = 'Inventar von %s'
L.TitleBank = 'Bank von %s'
L.TitleVault = 'Leerenlager von %s'

--dropdowns
L.SelectCharacter = 'Charakter auswählen'
L.ConfirmDelete = 'Sind Sie sicher, dass Sie die zwischengespeicherten Daten von %s löschen möchten?'

--interactions
L.Click = 'Click'
L.Drag = '<Ziehen>'
L.LeftClick = '<Klicken>'
L.RightClick = '<Rechtsklick>'
L.DoubleClick = '<Doppelklick>'
L.ShiftClick = '<Shift-Klick>'

--tooltips
L.Total = 'Gesamt'
L.GuildFunds = 'Gildenkasse'
L.TipGoldOnRealm = 'Auf %s gesamt'
L.NumWithdraw = '%d abheben'
L.NumDeposit = '%d einzahlen'

--action tooltips
L.TipChangePlayer = '%s um die Gegenstände anderer Charaktere anzuzeigen.'
L.TipCleanItems = '%s um die Taschen aufräumen.'
L.TipConfigure = '%s um das Fenster zu konfigurieren.'
L.TipDepositReagents = '%s um alle Reagenzien einzulagern.'
L.TipDeposit = '%s um einzuzahlen.'
L.TipWithdraw = '%s um abzuheben (%s verbleibend).'
L.TipFrameToggle = '%s um andere Fenster umzuschalten.'
L.TipHideBag = '%s um diese Tasche zu verstecken.'
L.TipHideBags = '%s um die Taschenanzeige zu verstecken.'
L.TipHideSearch = '%s um das Suchfenster zu verstecken.'
L.TipMove = '%s um zu bewegen.'
L.TipPurchaseBag = '%s um das Bankfach zu kaufen.'
L.TipResetPlayer = '%s um auf den aktuellen Charakter zurücksetzen.'
L.TipShowBag = '%s um diese Taschen anzuzeigen.'
L.TipShowBags = '%s um das Taschenfenster anzuzeigen.'
L.TipShowBank = '%s um die Bank umzuschalten.'
L.TipShowInventory = '%s um das Inventar umzuschalten.'
L.TipShowOptions = '%s um das Konfigurationsmenü anzuzeigen.'
L.TipShowSearch = '%s zum Suchen.'

--item tooltips
L.TipCountEquip = 'Angelegt: %d'
L.TipCountBags = 'Taschen: %d'
L.TipCountBank = 'Bank: %d'
L.TipCountVault = 'Leerenlager: %d'
L.TipCountGuild = 'Gilde: %d'

--dialogs
L.AskMafia = 'Mafia fragen'
L.ConfirmTransfer = 'Einlagern von Gegenständen wird alle Modifikationen entfernen und sie nicht handelbar und nicht rückgängig machbar machen.|n|nMöchten Sie fortfahren?'
L.CannotPurchaseVault = 'Sie haben nicht genug Geld, um den Leerenlager-Service freizuschalten|n|n|cffff2020Kosten: %s|r'
L.PurchaseVault = 'Möchten Sie den Leerenlager-Service freischalten?|n|n|cffffd200Kosten:|r %s'
