--[[
	German Localization
		Credits/Blame: Phanx
--]]

local CONFIG = ...
local L = LibStub('AceLocale-3.0'):NewLocale(CONFIG, 'deDE')
if not L then return end

-- filters
L.InstalledFilters = 'Installierte Filter'
L.CustomFilters = 'Benutzerdefinierte Filter'
L.NewFilter = 'Neuer Filter'
L.NewSearch = 'Neue Suche'
L.NewMacro = 'Neues Makro'
L.Import = 'Importieren'
L.EnterSearch = 'Suchanfrage eingeben:'
L.SharePopup = 'Diese Daten kopieren und teilen:'
L.ImportPopup = 'Daten zum Import einfügen:|n|cnERROR_COLOR:(Warnung – importiere nur Filter aus vertrauenswürdigen Quellen)|r'

-- general options
L.GeneralOptionsDescription = 'Allgemeine Einstellungen für %s anpassen'

L.CountItems = 'Ermögliche tooltip item count'
L.CountGuild = 'Include Guild Banks'
L.CountCurrency = 'Währung tooltip count'
L.CountPerFaction = 'Nur gleiche Fraktion'
L.CountPerFactionTip = 'Wenn aktiviert, enthalten Tooltips nur Charaktere/Gilden deiner aktuellen Fraktion.'
L.ConfirmGlobals = 'Möchtest du die spezifischen Einstellungen für diesen Charakter wirklich deaktivieren? Alle spezifischen Einstellungen gehen verloren.'
L.CharacterSpecific = 'Charakterspezifische Einstellungen'
L.DisplayBlizzard = 'Blizzard Fenster für die deaktivierten Taschen anzeigen'
L.DisplayBlizzardTip = 'Wenn aktiviert, werden die Standard-Blizzard-Taschenfenster für ausgeblendete Taschen angezeigt.\n\n|cffff1919Benötigt ggf. ein Neuladen des Interfaces.|r'
L.Locked = 'Fensterpositionen sperren'
L.FlashFind = 'Ermögliche Blitzsuche'
L.FlashFindTip = 'Wenn aktiviert, hebt das Klicken mit Alt auf einen Gegenstand alle Taschenplätze mit diesem Gegenstand hervor.'
L.Tooltips = 'Tooltips'

-- frame options
L.FrameOptions = 'Fenstereinstellungen'
L.FrameOptionsDescription = 'Einstellungen für ein bestimmtes %s Fenster anpassen'

L.Frame = 'Fenster'
L.Enabled = 'Aktiviert'
L.EnabledTip = 'Wenn deaktiviert, wird das Standard-Interface für dieses Fenster nicht ersetzt.\n\n|cffff1919Benötigt ggf. ein Neuladen des Interfaces.|r'
L.ActPanel = 'Standardfenster Verhalten'
L.ActPanelTip = [[
If enabled, this panel will automatically position
itself as the standard ones do, such as the |cffffffffSpellbook|r
or the |cffffffffDungeon Finder|r, and will not be movable.]]

L.BagToggle = 'Taschenschaltflächen'
L.Broker = 'Databroker'
L.Currency = 'Währungstracker'
L.Deposit = 'Einzahlungsschaltfläche'
L.Sidebar = 'Seitenfilter'
L.Sort = 'Sortierschaltfläche'
L.Search = 'Suchsschaltfläche'
L.Options = 'Optionenschaltfläche'
L.Tabs = 'Untere Filter'

L.Appearance = 'Erscheinung'
L.Layer = 'Ebene'
L.BagBreak = 'Trennen der Taschen aktivieren'
L.BreakSpace = 'Zeilenabstand'
L.ByType = 'Nach Typ'
L.ReverseBags = 'Taschen umkehren'
L.ReverseSlots = 'Slots umkehren'

L.Color = 'Farbe des Fensters'
L.BorderColor = 'Farbe des Fensterrands'

L.Strata = 'Ebene'
L.Skin = 'Skin'
L.Columns = 'Spalten'
L.Scale = 'Skalierung'
L.ItemScale = 'Gegenstandsskalierung'
L.Spacing = 'Abstand'
L.Alpha = 'Transparenz'

-- slot options
L.SlotOptions = 'Farbeinstellungen'
L.SlotOptionsDescription = 'Einstellungen für das Einfärben der Gegenstandslots'

L.GlowQuality = 'Gegenstände nach der Seltenheit hervorheben'
L.GlowQuest = 'Questgegenstände hervorheben'
L.GlowUnusable = 'Unbrauchbare Gegenstände hervorheben'
L.GlowSets = 'Ausrüstungsset-Gegenstände hervorheben'
L.GlowNew = 'Neue Gegenstände hervorheben'
L.GlowPoor = 'Qualitätsfärbung für graue Gegenstände'
L.GlowAlpha = 'Helligkeit der Gegenstandshervorhebung'

L.EmptySlots = 'Zeige einen Hintergrund für leere Gegenstandslots'
L.SlotBackground = 'Hintergrundgrafik'
L.ColorSlots = 'Leere Gegenstandslots nach der Taschen-Art einfärben'
L.AccountColor = 'Kriegsmeutenfarbe'
L.NormalColor = 'Universaltasche'
L.KeyColor = 'Schlüsselbundfarbe'
L.QuiverColor = 'Munitionsfarbe'
L.SoulColor = 'Seelentasche Farbe'
L.ReagentColor = 'Materiallager'
L.LeatherColor = 'Lederertasche'
L.InscribeColor = 'Schreibertasche'
L.HerbColor = 'Kräutertasche'
L.EnchantColor = 'Verzauberertasche'
L.EngineerColor = 'Ingnieurstasche'
L.GemColor = 'Edelsteintasche'
L.MineColor = 'Bergbautasche'
L.TackleColor = 'Anglertasche'
L.FridgeColor = 'Küchentasche'

-- auto display
L.DisplayOptions = 'Automatische Anzeige'
L.DisplayOptionsDescription = 'Einstellungen für das automatische öffnen der Fenster'

L.DisplayInventory = 'Inventar anzeigen...'
L.Auctioneer = 'beim Öffnen des Auktionshauses'
L.Banker = 'beim Öffnen der Bank'
L.Crafting = 'beim Herstellen'
L.GuildBanker = 'beim Öffnen der Gildenbank'
L.VoidStorageBanker = 'Beim Leerenlager'
L.MailInfo = 'beim Abholen der Post'
L.Merchant = 'beim Verlassen des Handlers'
L.Character = 'beim Öffnen der Charakterinfo'
L.TradePartner = 'beim Handel von Gegenständen'
L.Transmogrifier = 'beim Ändern von Gegenständen'

L.CloseInventory = 'Inventar schließen...'
L.MapFrame = 'beim Öffnen der Weltkarte'
L.Combat = 'beim Kampfbeginn'
L.Vehicle = 'beim Eintritt in ein Fahrzeugs'

-- info
L.HelpDescription = 'Hier findest du Antworten auf die am häufigsten gestellten Fragen. Wenn keine davon dein Problem löst, kannst du in der %s-Community auf Discord um Hilfe bitten.'
L.Patrons = 'Unterstützer'
L.PatronsDescription = '%s wird kostenlos verteilt und durch Spenden unterstützt. Ein großes Dankeschön an alle Unterstützer auf Patreon und Paypal, die die Entwicklung am Leben halten. Du kannst ebenfalls Unterstützer werden unter |cFFF96854patreon.com/jaliborc|r.'
L.AskCommunity = 'Community fragen'
L.JoinUs = 'Mach mit'

L.FAQ = {
  'Wie kann ich Gegenstände direkt in die Kriegsbande-Bank einzahlen?',
  'Umschalt + Rechtsklick auf das Gegenstandsfeld, und es wird in die Kriegsbande-Taschen gelegt anstatt in die normalen Taschen.',

  'Wie kann ich Bank, Gilde oder andere Charaktere offline ansehen?',
  'Klicke auf den Button "Offline-Anzeige" oben links im Inventar. Er sieht aus wie das Porträt deines aktuellen Charakters.',

  'Wie kann ich ADDON veranlassen, gelöschte/umbenannte Charaktere zu vergessen?',
  'Klicke auf den Button "Offline-Anzeige" oben links im Inventar. Neben jedem Charakternamen befindet sich ein rotes Kreuz zum Löschen.',

  'Etwas stimmt nicht! Die Gegenstandsstufen werden nicht angezeigt.',
  'ADDON zeigt keine Gegenstandsstufen von Haus aus an. Du musst ein Drittanbieter-Plugin wie |cffffd200Bagnon ItemLevel|r oder |cffffd200Bagnon ItemInfo|r verwenden. Aktualisiere deine Plugins – meist liegt es an einer veralteten Version.|n|nProbleme mit Plugins sollten deren Autoren gemeldet werden, nicht Jaliborc.',

  'Einige meiner Taschen werden nicht angezeigt.',
  'Wahrscheinlich wurden sie versehentlich ausgeblendet. Klicke auf die Taschen-Schaltfläche oben links im Fenster, um sie wieder einzublenden.',

  'Wie aktiviere/deaktiviere ich ADDON für Bank, Leerenlager usw.?',
  'Gehe zu ADDON -> Fenster-Einstellungen. Wähle den gewünschten "Frame" oben im Panel und klicke auf "Frame aktivieren".'
}
