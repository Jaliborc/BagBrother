--[[
	Dutch Localization
--]]

local CONFIG = ...
local L = LibStub('AceLocale-3.0'):NewLocale(CONFIG, 'nlNL')
if not L then return end

-- filters
L.InstalledFilters = 'Geïnstalleerde filters'
L.CustomFilters = 'Aangepaste filters'
L.NewFilter = 'Nieuw filter'
L.NewSearch = 'Nieuwe zoekopdracht'
L.NewMacro = 'Nieuwe macro'
L.Import = 'Importeren'
L.EnterSearch = 'Voer zoekopdracht in:'
L.SharePopup = 'Kopieer deze gegevens en deel ze:'
L.ImportPopup = 'Plak gegevens om te importeren:|n|cnERROR_COLOR:(Waarschuwing - importeer alleen filters van bronnen die je vertrouwt)|r'

-- automatic. do not translate unless necessary
L.Help = HELP_LABEL
L.Money = MONEY
 
-- general options
L.GeneralOptionsDescription = 'Dit zijn algemene functies die kunnen worden in- of uitgeschakeld, afhankelijk van je voorkeuren.'

L.CountItems = 'Item Tooltip Tellingen'
L.CountGuild = 'Inclusief Gildebanken'
L.CountCurrency = 'Valuta Tooltip Tellingen'
L.CountPerFaction = 'Alleen Zelfde Fractie'
L.CountPerFactionTip = 'Indien ingeschakeld, tonen tooltips alleen personages/gilden van jouw huidige fractie.'
L.ConfirmGlobals = 'Weet je zeker dat je specifieke instellingen voor dit personage wilt uitschakelen? Alle specifieke instellingen gaan verloren.'
L.CharacterSpecific = 'Personagespecifieke Instellingen'
L.DisplayBlizzard = 'Fallback Verborgen Tassen'
L.DisplayBlizzardTip = 'Indien ingeschakeld, zullen de standaard Blizzard UI taspanelen worden weergegeven voor verborgen inventaris of bankcontainers.\n\n|cffff1919Vereist UI herladen.|r'
L.Locked = 'Vergrendel Frames'
L.FlashFind = 'Flash Vind'
L.FlashFindTip = 'Indien ingeschakeld zal alt-klikken op een item alle slots met datzelfde item over frames laten flitsen.'
L.Tooltips = 'Tooltips'

-- frame options
L.FrameOptions = 'Frame Instellingen'
L.FrameOptionsDescription = 'Dit zijn configuratie-instellingen specifiek voor een %s frame.'

L.Frame = 'Frame'
L.Enabled = 'Activeer Frame'
L.EnabledTip = 'Indien uitgeschakeld, zal de standaard Blizzard UI niet worden vervangen voor dit frame.\n\n|cffff1919Vereist UI herladen.|r'
L.ActPanel = 'Handel als Standaard Paneel'
L.ActPanelTip = [[
Indien ingeschakeld, zal dit paneel automatisch positioneren
zoals de standaard doen, zoals het |cffffffffSpreukenboek|r
of de |cffffffffDungeon Finder|r, en zal niet verplaatsbaar zijn.]]

L.BagToggle = 'Tas Wisselen'
L.Broker = 'Databroker Carrousel'
L.Currency = 'Valuta'
L.Deposit = 'Stortknop'
L.Sidebar = 'Zijfilters'
L.Sort = 'Sorteer Knop'
L.Search = 'Zoek Wisselen'
L.Options = 'Opties Knop'
L.Tabs = 'Onderste filters'

L.Appearance = 'Uiterlijk'
L.Layer = 'Laag'
L.BagBreak = 'Tas Onderbreken'
L.BreakSpace = 'Regelafstand'
L.ByType = 'Op type'
L.ReverseBags = 'Omgekeerde Tasvolgorde'
L.ReverseSlots = 'Omgekeerde Slotvolgorde'

L.Color = 'Achtergrondkleur'
L.BorderColor = 'Randkleur'

L.Strata = 'Frame Laag'
L.Skin = 'Uiterlijk'
L.Columns = 'Kolommen'
L.Scale = 'Schaal'
L.ItemScale = 'Item Schaal'
L.Spacing = 'Afstand'
L.Alpha = 'Doorzichtigheid'

-- slot options
L.SlotOptions = 'Slot Instellingen'
L.SlotOptionsDescription = 'Deze instellingen laten je veranderen hoe itemslots worden weergegeven op %s frames voor gemakkelijkere identificatie.'

L.GlowQuality = 'Kleur op basis van Kwaliteit'
L.GlowQuest = 'Kleur Quest Items'
L.GlowUnusable = 'Kleur Onbruikbare Items'
L.GlowSets = 'Kleur Uitrustingssets'
L.GlowNew = 'Flash Nieuwe Items'
L.GlowPoor = 'Markeer Slechte Items'
L.GlowAlpha = 'Gloei Helderheid'

L.EmptySlots = 'Toon Achtergrond'
L.SlotBackground = 'Artwork'
L.ColorSlots = 'Kleur op basis van Tas Type'
L.AccountColor = 'Warband-kleur'
L.NormalColor = 'Normale Kleur'
L.KeyColor = 'Sleutel Kleur'
L.QuiverColor = 'Pijlenkoker Kleur'
L.SoulColor = 'Ziel Tas Kleur'
L.ReagentColor = 'Reagens Bank Kleur'
L.LeatherColor = 'Leerwerk Kleur'
L.InscribeColor = 'Inscriptie Kleur'
L.HerbColor = 'Kruidenleer Kleur'
L.EnchantColor = 'Bezwering Kleur'
L.EngineerColor = 'Ingenieurskleur'
L.GemColor = 'Edelsteen Kleur'
L.MineColor = 'Mijnkleur'
L.TackleColor = 'Visgerei Kleur'
L.FridgeColor = 'Koelkast Kleur'

-- auto display
L.DisplayOptions = 'Automatische Weergave'
L.DisplayOptionsDescription = 'Deze instellingen laten je configureren wanneer je inventaris automatisch opent of sluit vanwege spelinstanties.'

L.DisplayInventory = 'Toon Inventaris'
L.Auctioneer = 'Bij het Veilinghuis'
L.Banker = 'Bij de Bank'
L.Crafting = 'Ambacht'
L.GuildBanker = 'Bij de Gildebank'
L.VoidStorageBanker = 'Bij Lege Opslag'
L.MailInfo = 'Bij een Brievenbus'
L.Merchant = 'Praten met Handelaar'
L.Character = 'Personage-info openen'
L.TradePartner = 'Handelen'
L.Transmogrifier = 'Items aanpassen'

L.CloseInventory = 'Sluit Inventaris'
L.MapFrame = 'Wereldkaart Openen'
L.Combat = 'Binnenkomst Gevecht'
L.Vehicle = 'Voertuig Binnenkomen'

-- info
L.HelpDescription = 'Hier bieden we antwoorden op de meest gestelde vragen. Als geen van beide je probleem oplost, kun je overwegen om hulp te vragen op de %s gebruikerscommunity op Discord.'
L.Patrons = 'Patroons'
L.PatronsDescription = '%s wordt gratis verspreid en ondersteund door donaties. Een groot dankwoord aan alle supporters op Patreon en Paypal die de ontwikkeling levend houden. Je kunt ook patroon worden op |cFFF96854patreon.com/jaliborc|r.'
L.AskCommunity = 'Vraag de Community'
L.JoinUs = 'Sluit je aan'

L.FAQ = {
  'Hoe kan ik items rechtstreeks in de Warband Bank deponeren?',
  'Je hebt twee opties:|n- |cffffd100Rechtsklik|r op een item terwijl het Warband-tabblad geopend is.|n- |cffffd100Shift + Rechtsklik|r terwijl je een ander tabblad bekijkt.|n|n|cff9d9d9dUitleg: Shift + Rechtsklik is gericht op het type bank dat je momenteel niet bekijkt.|r',

  'Hoe kan ik de bank, gilde of een ander personage offline bekijken?',
  'Klik op de knop |cffffd100Offline bekijken|r linksboven in je inventaris.|n|cff9d9d9dHet ziet eruit als een portret van het personage dat je momenteel speelt.|r',

  'Hoe zorg ik ervoor dat ADDON een verwijderd/hernoemd personage vergeet?',
  '- Klik op de knop |cffffd100Offline bekijken|r linksboven in je inventaris.|n- Beweeg de muis over de personagenaam die je wilt verwijderen.|n- Klik op het |cffff0000rode symbool|r dat aan de rechterkant verschijnt.',

  'Er is iets mis! Itemniveaus worden niet weergegeven op de vakken.',
  'ADDON geeft standaard geen itemniveaus weer. Je moet een plug-in van derden gebruiken, zoals |cffffd200Bagnon ItemLevel|r of |cffffd200Bagnon ItemInfo|r. Probeer de plug-ins die je gebruikt bij te werken, de meest voorkomende oorzaak is dat ze verouderd zijn.|n|nLet op: problemen met plug-ins moeten worden gemeld aan de auteurs ervan, niet aan Jaliborc.',

  'Sommige van mijn tassen verschijnen niet.',
  'Je hebt ze waarschijnlijk per ongeluk verborgen. Klik op de knop Tassen linksboven in het scherm om je tassen te zien. Je kunt vervolgens op een tas klikken om de zichtbaarheid ervan in of uit te schakelen.',

  'Hoe schakel ik ADDON in/uit voor Inventaris, Bank, Vault, enz.?',
  'Ga naar |cffffd100ADDON -> Frame-instellingen|r.|nKies het "Frame" dat je wilt in- of uitschakelen bovenaan het paneel, en klik vervolgens op |cffffd100Schakel Frame in|r.'
}
