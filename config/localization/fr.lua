--[[
	French Localization
--]]

local CONFIG = ...
local L = LibStub('AceLocale-3.0'):NewLocale(CONFIG, 'frFR')
if not L then return end

-- filters
L.InstalledFilters = 'Filtres Installés'
L.CustomFilters = 'Filtres Personnalisés'
L.NewFilter = 'Nouveau Filtre'
L.NewSearch = 'Nouvelle Recherche'
L.NewMacro = 'Nouvelle Macro'
L.Import = 'Importer'
L.EnterSearch = 'Saisir la Requête de Recherche :'
L.SharePopup = 'Copiez ces données et partagez-les :'
L.ImportPopup = 'Collez les données à importer :|n|cnERROR_COLOR:(Avertissement - n’importez que des filtres provenant de sources fiables)|r'

-- general options
L.GeneralOptionsDescription = 'Configuration des options générales de %s'

L.CountItems = 'Activer l\'Info-bulle du Compteur d\'Objets'
L.CountGuild = 'Inclure les Banques de Guilde'
L.CountCurrency = 'Activer l\'Info-bulle du Compteur d\'Monnaies'
L.CountPerFaction = 'Même Faction Uniquement'
L.CountPerFactionTip = 'Si activé, les info-bulles n\'incluront que les personnages/guildes de votre faction actuelle.'
L.ConfirmGlobals = 'Êtes-vous sûr de vouloir désactiver les paramètres spécifiques à ce personnage ? Tous les paramètres spécifiques seront perdus.'
L.CharacterSpecific = 'Paramètres Spécifiques au Personnage'
L.DisplayBlizzard = 'Afficher les Cadres de Blizzard pour les Sacs Désactivés'
L.DisplayBlizzardTip = 'Si activé, le panneau Blizzard par défaut sera affiché pour les sacs et containers de banque cachés.\n\n|cffff1919Nécessite de recharger l\'UI.|r'
L.Locked = 'Bloquer la Position des Fenêtres'
L.FlashFind = 'Activer Résultat Éclair'
L.FlashFindTip = 'Si activé, Alt+Clic sur un objet fait briller tous les emplacements contenant le même objet.'
L.Tooltips = 'Info-bulles'

-- frame options
L.FrameOptions = 'Options des Fenêtres'
L.FrameOptionsDescription = 'Configuration des options spécifiques à une fenêtre de %s'

L.Frame = 'Fenêtre'
L.Enabled = 'Activer'
L.EnabledTip = 'Si désactivé, l\'UI Blizzard par defaut ne sera pas affichée pour cette fenêtre.\n\n|cffff1919Nécessite de recharger l\'UI.|r'
L.ActPanel = 'Se Comporter comme un Panneau Standard'
L.ActPanelTip = [[
Si activé, ce panneau se positionnera
automatiquement comme les panneaux standards
le font, tels que le |cffffffffGrimoire|r ou la |cffffffffRecherche de groupe|r,
et ne pourra pas être déplacé.]]

L.BagToggle = 'Fenêtre du Sac'
L.Broker = 'Activer le DataBroker'
L.Currency = 'Suivi des Monnaies'
L.Deposit = 'Bouton de Dépôt'
L.Sidebar = 'Filtres Latéraux'
L.Sort = 'Bouton de Tri'
L.Search = 'Champ de Recherche'
L.Options = 'Affichage des Options'
L.Tabs = 'Filtres du Bas'

L.Appearance = 'Apparence'
L.Layer = 'Couche'
L.BagBreak = 'Séparation entre les Sacs'
L.BreakSpace = 'Espacement de Saut'
L.ByType = 'Par Type'
L.ReverseBags = 'Inverser Ordre des Sacs'
L.ReverseSlots = 'Inverser Ordre de Tri'

L.Color = 'Couleur de la Fenêtre'
L.BorderColor = 'Couleur de Bordure'

L.Strata = 'Couche'
L.Skin = 'Apparence'
L.Columns = 'Colonnes'
L.Scale = 'Echelle'
L.ItemScale = 'Échelle des Objets'
L.Spacing = 'Espacement'
L.Alpha = 'Opacité'

-- slot options
L.SlotOptions = 'Options de Couleur'
L.SlotOptionsDescription = 'Options de colorisation des emplacements'

L.GlowQuality = 'Surligner les Objets par Qualité'
L.GlowQuest = 'Surligner les Objets de Quête'
L.GlowUnusable = 'Surligner les Objets Inutiles'
L.GlowSets = 'Surligner les Objets d\'Ensemble'
L.GlowNew = 'Surligner les Nouveaux Objets'
L.GlowPoor = 'Surligner les Objets de Faible Qualité'
L.GlowAlpha = 'Contour Lumineux des Objets'

L.EmptySlots = 'Afficher un Fond sur les Emplacements Vides'
L.SlotBackground = 'Artwork'
L.ColorSlots = 'Colorier les Emplacements Vides par Type de Sac'
L.AccountColor = 'Couleur du Bataillon'
L.NormalColor = 'Normaux'
L.KeyColor = 'Clés'
L.QuiverColor = 'Carquois'
L.SoulColor = 'Sac d\'Âmes'
L.ReagentColor = 'Banque des Composants'
L.LeatherColor = 'Sac Travail du Cuir'
L.InscribeColor = 'Sac Calligraphie'
L.HerbColor = 'Sac Herboristerie'
L.EnchantColor = 'Sac Enchantement'
L.EngineerColor = 'Sac Ingénierie'
L.GemColor = 'Sac de Gemmes'
L.MineColor = 'Sac de Minage'
L.TackleColor = 'Sac de Pêche'
L.FridgeColor = 'Sac de Cuisine'

-- auto display
L.DisplayOptions = 'Affichage Automatique'
L.DisplayOptionsDescription = 'Options de l\'affichage automatique'

L.DisplayInventory = 'Afficher votre Inventaire'
L.Auctioneer = 'Quand vous Visitez l\'Hôtel des Ventes'
L.Banker = 'Quand vous Visitez la Banque'
L.Crafting = 'Quand vous Craftez'
L.GuildBanker = 'Quand vous Visitez votre Banque de Guilde'
L.VoidStorageBanker = 'Auprès de la Chambre du Vide'
L.MailInfo = 'Quand vous Relevez votre Courrier'
L.Merchant = 'Quand vous Quittez un Marchand'
L.Character = 'Quand vous Ouvrez la Fenêtre de votre Personnage'
L.TradePartner = 'Quand vous Parlez à un Commerçant'
L.Transmogrifier = 'Quand vous Modifiez vos Objets'

L.CloseInventory = 'Fermer votre Inventaire'
L.MapFrame = 'Quand vous Ouvrez la Carte du Monde'
L.Combat = 'Quand vous Entrez en Combat'
L.Vehicle = 'Quand vous Montez dans un Véhicule'

-- info
L.HelpDescription = 'Ici, nous répondons aux questions les plus fréquemment posées. Si aucune ne résout votre problème, vous pouvez demander de l’aide sur la communauté %s sur Discord.'
L.Patrons = 'Mécènes'
L.PatronsDescription = '%s est distribué gratuitement et financé grâce aux dons. Un immense merci à tous les soutiens sur Patreon et Paypal qui permettent au développement de continuer. Vous pouvez aussi devenir mécène sur |cFFF96854patreon.com/jaliborc|r.'
L.AskCommunity = 'Demander à la Communauté'
L.JoinUs = 'Rejoignez-nous'

L.FAQ = {
  'Comment déposer directement des objets dans la banque de la bande de guerre ?',
  'Faites Maj + clic droit sur l’emplacement de l’objet et il sera placé dans les sacs de la bande de guerre au lieu des sacs normaux.',

  'Comment voir la banque, la guilde ou un autre personnage hors ligne ?',
  'Cliquez sur le bouton "Affichage hors ligne" en haut à gauche de votre inventaire. Il ressemble au portrait du personnage que vous jouez actuellement.',

  'Comment faire pour qu’ADDON oublie un personnage supprimé ou renommé ?',
  'Cliquez sur le bouton "Affichage hors ligne" en haut à gauche de votre inventaire. Chaque nom de personnage possède un bouton de suppression à côté (une croix rouge). Cliquez sur la croix du personnage que vous souhaitez supprimer.',

  'Quelque chose ne va pas ! Les niveaux d’objet ne s’affichent pas.',
  'ADDON n’affiche pas nativement les niveaux d’objet. Vous devez utiliser un module tiers tel que |cffffd200Bagnon ItemLevel|r ou |cffffd200Bagnon ItemInfo|r. Essayez de mettre à jour vos modules, la cause la plus fréquente est une version obsolète.|n|nVeuillez signaler tout problème de module à leurs auteurs, et non à Jaliborc.',

  'Certains de mes sacs n’apparaissent pas.',
  'Vous les avez probablement cachés par accident. Cliquez sur le bouton Sacs en haut à gauche de la fenêtre pour les afficher. Vous pouvez ensuite cliquer sur un sac pour basculer sa visibilité.',

  'Comment activer/désactiver ADDON pour la banque, le vide, etc. ?',
  'Allez dans ADDON -> Paramètres des fenêtres. Les deux premières options du panneau permettent de choisir la "fenêtre" à activer et de cliquer sur "Activer la fenêtre".'
}
