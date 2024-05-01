--[[
	Dutch Localization
--]]

local ADDON = ...
local L = LibStub('AceLocale-3.0'):NewLocale(ADDON, 'nlNL')
if not L then return end

--keybindings
L.OpenBags = 'Inventaris Wisselen'
L.OpenBank = 'Bank Wisselen'
L.OpenGuild = 'Gildebank Wisselen'
L.OpenVault = 'Lege Opslag Wisselen'

--terminal
L.Commands = 'commandolijst'
L.CmdShowInventory = 'Schakelt je inventaris'
L.CmdShowBank = 'Schakelt je bank'
L.CmdShowGuild = 'Schakelt je gildebank'
L.CmdShowVault = 'Schakelt je lege opslag'
L.CmdShowVersion = 'Toont de huidige versie'
L.CmdShowOptions = 'Opent het configuratiemenu'

--frame titles
L.TitleBags = 'Inventaris van %s'
L.TitleBank = 'Bank van %s'
L.TitleVault = 'Lege Opslag van %s'

--dropdowns
L.SelectCharacter = 'Selecteer Personage'
L.ConfirmDelete = 'Weet je zeker dat je de cachegegevens van %s wilt verwijderen?'

--interactions
L.Click = 'Klik'
L.Drag = '<Slepen>'
L.LeftClick = '<Linkermuisklik>'
L.RightClick = '<Rechtermuisklik>'
L.DoubleClick = '<Dubbelklik>'
L.ShiftClick = '<Shift-Klik>'

--tooltips
L.Total = 'Totaal'
L.GuildFunds = 'Gilde Fonds'
L.TipGoldOnRealm = 'Totaal op %s'
L.NumWithdraw = '%d Opname'
L.NumDeposit = '%d Storting'
L.NumRemaining = '%d Resterende'

--action tooltips
L.TipChangePlayer = '%s om items van een ander personage te bekijken.'
L.TipCleanItems = '%s om items op te schonen.'
L.TipConfigure = '%s om te configureren.'
L.TipDepositReagents = '%s om reagentia bij de bank te storten.'
L.TipDeposit = '%s om te storten.'
L.TipWithdraw = '%s om op te nemen (%s resterend).'
L.TipFrameToggle = '%s om andere vensters te wisselen.'
L.TipHideBag = '%s om deze tas te verbergen.'
L.TipHideBags = '%s om het tassenscherm te verbergen.'
L.TipHideSearch = '%s om te stoppen met zoeken.'
L.TipMove = '%s om te bewegen.'
L.TipPurchaseBag = '%s om deze bankplaats te kopen.'
L.TipResetPlayer = '%s om terug te keren naar het huidige personage.'
L.TipShowBag = '%s om deze tas te tonen.'
L.TipShowBags = '%s om het tassenscherm te tonen.'
L.TipShowBank = '%s om je bank te wisselen.'
L.TipShowInventory = '%s om je inventaris te wisselen.'
L.TipShowOptions = '%s om het optiemenu te openen.'
L.TipShowSearch = '%s om te zoeken.'

--item tooltips
L.TipCountEquip = 'Uitgerust: %d'
L.TipCountBags = 'Tassen: %d'
L.TipCountBank = 'Bank: %d'
L.TipCountVault = 'Lege Opslag: %d'
L.TipCountGuild = 'Gilde: %d'

--dialogs
L.AskMafia = 'Vraag de Maffia'
L.ConfirmTransfer = 'Door items te storten worden alle aanpassingen verwijderd en worden ze niet-verhandelbaar en niet-terugbetaalbaar.|n|nWilt u doorgaan?'
L.CannotPurchaseVault = 'Je hebt niet genoeg geld om de Lege Opslagdienst te ontgrendelen|n|n|cffff2020Kosten: %s|r'
L.PurchaseVault = 'Wilt u de Lege Opslagdienst ontgrendelen?|n|n|cffffd200Kosten:|r %s'