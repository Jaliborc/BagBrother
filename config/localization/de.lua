--[[
	German Localization
		Credits/Blame: Phanx
--]]

local CONFIG = ...
local L = LibStub('AceLocale-3.0'):NewLocale(CONFIG, 'deDE')
if not L then return end
local NEW = BATTLENET_FONT_COLOR:WrapTextInColorCode(' ' .. NEW_CAPS)

-- German
L.InstalledFilters = 'Installierte Filter'
L.CustomFilters = 'Benutzerdefinierte Filter'
L.NewFilter = 'Neuer Filter'
L.NewSearch = 'Neue Suche'
L.NewMacro = 'Neues Makro'
L.Import = 'Importieren'
L.SharePopup = 'Diese Daten kopieren und teilen:'
L.ImportPopup = 'Daten zum Import einfügen:|n|cnERROR_COLOR:(Warnung – importiere nur Filter aus vertrauenswürdigen Quellen)|r'

-- general
L.GeneralOptionsDesc = 'Allgemeine Einstellungen für %s anpassen'
L.Locked = 'Fensterpositionen sperren'
L.CountItems = 'Ermögliche tooltip item count'
L.FlashFind = 'Ermögliche Blitzsuche'
L.EmptySlots = 'Zeige einen Hintergrund für leere Gegenstandslots'
L.DisplayBlizzard = 'Blizzard Fenster für die deaktivierten Taschen anzeigen'

-- frame
L.FrameOptions = 'Fenstereinstellungen'
L.FrameOptionsDesc = 'Einstellungen für ein bestimmtes %s Fenster anpassen'
L.Frame = 'Fenster'
L.Enabled = 'Aktiviert'
L.CharacterSpecific = 'Charakterspezifische Einstellungen'
L.ExclusiveReagent = 'Getrenntes Materiallager'

L.BagToggle = 'Taschenschaltflächen'
L.Broker = 'Databroker'
L.Sort = 'Sortierschaltfläche'
L.Search = 'Suchsschaltfläche'
L.Options = 'Optionenschaltfläche'

L.Appearance = 'Erscheinung'
L.Layer = 'Ebene'
L.BagBreak = 'Trennen der Taschen aktivieren' .. NEW
L.ReverseBags = 'Taschen umkehren'
L.ReverseSlots = 'Slots umkehren'

L.Color = 'Farbe des Fensters'
L.BorderColor = 'Farbe des Fensterrands'

L.Strata = 'Ebene'
L.Columns = 'Spalten'
L.Scale = 'Skalierung'
L.ItemScale = 'Gegenstandsskalierung'
L.Spacing = 'Abstand'
L.Alpha = 'Transparenz'

-- auto display
L.DisplayOptions = 'Automatische Anzeige'
L.DisplayOptionsDesc = 'Einstellungen für das automatische öffnen der Fenster'
L.DisplayInventory = 'Inventar anzeigen...'
L.CloseInventory = 'Inventar schließen...'

L.Banker = 'beim Öffnen der Bank'
L.Auctioneer = 'beim Öffnen des Auktionshauses'
L.TradePartner = 'beim Handel von Gegenständen'
L.Crafting = 'beim Herstellen'
L.MailInfo = 'beim Abholen der Post'
L.GuildBanker = 'beim Öffnen der Gildenbank'
L.PlayerFrame = 'beim Öffnen des Spielerfensters'
L.Socketing = 'beim Gesockeln eines Gegenstands'
L.Combat = 'beim Kampfbeginn'
L.Vehicle = 'beim Eintritt in ein Fahrzeugs'
L.Merchant = 'beim Verlassen des Handlers'

-- colors
L.ColorOptions = 'Farbeinstellungen'
L.ColorOptionsDesc = 'Einstellungen für das Einfärben der Gegenstandslots'

L.GlowQuality = 'Gegenstände nach der Seltenheit hervorheben'
L.GlowNew = 'Neue Gegenstände hervorheben'
L.GlowQuest = 'Questgegenstände hervorheben'
L.GlowUnusable = 'Unbrauchbare Gegenstände hervorheben'
L.GlowSets = 'Ausrüstungsset-Gegenstände hervorheben'
L.ColorSlots = 'Leere Gegenstandslots nach der Taschen-Art einfärben'

L.NormalColor = 'Universaltasche'
L.LeatherColor = 'Lederertasche'
L.InscribeColor = 'Schreibertasche'
L.HerbColor = 'Kräutertasche'
L.EnchantColor = 'Verzauberertasche'
L.EngineerColor = 'Ingnieurstasche'
L.GemColor = 'Edelsteintasche'
L.MineColor = 'Bergbautasche'
L.TackleColor = 'Anglertasche'
L.RefrigeColor = 'Küchentasche'
L.ReagentColor = 'Materiallager'
L.GlowAlpha = 'Helligkeit der Gegenstandshervorhebung'

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