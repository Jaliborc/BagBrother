--[[
	French Localization
--]]

local ADDON = ...
local L = LibStub('AceLocale-3.0'):NewLocale(ADDON, 'frFR')
if not L then return end

--keybindings
L.OpenBags = 'Afficher votre inventaire'
L.OpenBank = 'Afficher votre banque'
L.OpenGuild = 'Afficher votre banque de guilde'
L.OpenVault = 'Afficher votre chambre du Vide'

--terminal
L.Commands = 'Liste des commandes :'
L.CmdShowInventory = 'Affiche ou cache votre inventaire'
L.CmdShowBank = 'Affiche ou cache votre banque'
L.CmdShowGuild = 'Affiche ou cache votre banque de guilde'
L.CmdShowVault = 'Affiche ou cache votre chambre du Vide'
L.CmdShowVersion = 'Affiche la version actuelle'
L.CmdShowOptions = 'Ouvre le menu de configuration'

--frame titles
L.TitleBags = 'Inventaire |2 %s'
L.TitleBank = 'Banque |2 %s'
L.TitleVault = 'Chambre du Vide |2 %s'

--dropdowns
L.SelectCharacter = 'Choisir Personnage'
L.ConfirmDelete = 'Etes-vous sur de vouloir supprimer le cache de %s ?'

--interactions
L.Click = 'Cliquez'
L.Drag = '<Saisir>'
L.LeftClick = '<Clic Gauche>'
L.RightClick = '<Clic Droit>'
L.DoubleClick = '<Double Clic>'
L.ShiftClick = '<Shift+Clic>'

--tooltips
L.GuildFunds = 'Fonds de Guilde'
L.TipGoldOnRealm = '%s Totals'
L.NumWithdraw = '%d |4retrait:retraits;'
L.NumDeposit = '%d |4dépôt:dépôts;'

--action tooltips
L.TipChangePlayer = '%s pour afficher les objets d\'un autre personnage.'
L.TipCleanItems = 'Tri automatique'
L.TipConfigure = 'Configuration'
L.TipDepositReagents = '%s pour déposer tous les composants.'
L.TipDeposit = '%s pour déposer.'
L.TipWithdraw = '%s pour retirer (%s restant).'
L.TipFrameToggle = '%s pour afficher d\'autres fenêtres.'
L.TipHideBag = '%s pour cacher ce sac.'
L.TipHideBags = '%s pour cacher l\'affichage des sac.'
L.TipHideSearch = '%s pour cacher le champ de recherche.'
L.TipMove = '%s pour déplacer.'
L.PurchaseBag = '%s pour acheter cet emplacement de sac.'
L.TipResetPlayer = '%s pour retourner sur le personnage actuel.'
L.TipShowBag = '%s pour afficher ce sac.'
L.TipShowBags = '%s pour afficher la fenêtre de vos sacs.'
L.TipShowBank = '%s pour afficher/cacher votre banque.'
L.TipShowInventory = '%s pour afficher/cacher votre inventaire.'
L.TipShowOptions = '%s pour ouvrir le menu des options.'
L.TipShowSearch = 'Rechercher'

--item tooltips
L.TipCountEquip = 'Équipé : %d'
L.TipCountBags = 'Sacs : %d'
L.TipCountBank = 'Banque : %d'
L.TipCountVault = 'Chambre : %d'
L.TipCountGuild = 'Guilde : %d'

--dialogs
L.AskMafia = 'Demander à la Mafia'
L.ConfirmTransfer = 'Déposer un objet retirera toute modification et le rendra non échangeable et non remboursable.|n|nVoulez-vous continuer?'
L.CannotPurchaseVault = 'Pas assez d\'or pour débloquer la Chambre du Vide|n|n|cffff2020Cost: %s|r'
L.PurchaseVault = 'Souhaitez-vous débloquer la Banque du Chambre?|n|n|cffffd200Cost:|r %s'