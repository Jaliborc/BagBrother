--[[
	Dutch Localization
--]]

local CONFIG = ...
local L = LibStub('AceLocale-3.0'):NewLocale(CONFIG, 'nlNL')
if not L then return end

-- general
L.GeneralOptionsDesc = 'Dit zijn algemene functies die kunnen worden in- of uitgeschakeld, afhankelijk van je voorkeuren.'
L.Locked = 'Vergrendel Frames'
L.CountItems = 'Item Tooltip Tellingen'
L.CountGuild = 'Inclusief Gildebanken'
L.CountCurrency = 'Valuta Tooltip Tellingen'
L.FlashFind = 'Flash Vind'
L.FlashFindTip = 'Indien ingeschakeld zal alt-klikken op een item alle slots met datzelfde item over frames laten flitsen.'
L.DisplayBlizzard = 'Fallback Verborgen Tassen'
L.DisplayBlizzardTip = 'Indien ingeschakeld, zullen de standaard Blizzard UI taspanelen worden weergegeven voor verborgen inventaris of bankcontainers.\n\n|cffff1919Vereist UI herladen.|r'
L.ConfirmGlobals = 'Weet je zeker dat je specifieke instellingen voor dit personage wilt uitschakelen? Alle specifieke instellingen gaan verloren.'
L.CharacterSpecific = 'Personagespecifieke Instellingen'

-- frame
L.FrameOptions = 'Frame Instellingen'
L.FrameOptionsDesc = 'Dit zijn configuratie-instellingen specifiek voor een %s frame.'
L.Frame = 'Frame'
L.Enabled = 'Activeer Frame'
L.EnabledTip = 'Indien uitgeschakeld, zal de standaard Blizzard UI niet worden vervangen voor dit frame.\n\n|cffff1919Vereist UI herladen.|r'
L.ActPanel = 'Handel als Standaard Paneel'
L.ActPanelTip = [[
Indien ingeschakeld, zal dit paneel automatisch positioneren
zoals de standaard doen, zoals het |cffffffffSpreukenboek|r
of de |cffffffffDungeon Finder|r, en zal niet verplaatsbaar zijn.]]

L.BagToggle = 'Tas Wisselen'
L.Broker = 'Databroker Plugins'
L.Currency = 'Valuta'
L.ExclusiveReagent = 'Aparte Reagens Bank'
L.Money = 'Geld'
L.Sort = 'Sorteer Knop'
L.Search = 'Zoek Wisselen'
L.Options = 'Opties Knop'
L.LeftTabs = 'Regelsets aan Linkerzijde'
L.LeftTabsTip = [[
Indien ingeschakeld, zullen de zijtabs worden
weergegeven aan de linkerkant van het paneel.]]

L.Appearance = 'Uiterlijk'
L.Layer = 'Laag'
L.BagBreak = 'Tas Onderbreken'
L.ReverseBags = 'Omgekeerde Tasvolgorde'
L.ReverseSlots = 'Omgekeerde Slotvolgorde'

L.Color = 'Achtergrondkleur'
L.BorderColor = 'Randkleur'

L.Strata = 'Frame Laag'
L.Columns = 'Kolommen'
L.Scale = 'Schaal'
L.ItemScale = 'Item Schaal'
L.Spacing = 'Afstand'
L.Alpha = 'Doorzichtigheid'

-- auto display
L.DisplayOptions = 'Automatische Weergave'
L.DisplayOptionsDesc = 'Deze instellingen laten je configureren wanneer je inventaris automatisch opent of sluit vanwege spelinstanties.'
L.DisplayInventory = 'Toon Inventaris'
L.CloseInventory = 'Sluit Inventaris'

L.Auctioneer = 'Bij het Veilinghuis'
L.Banker = 'Bij de Bank'
L.Combat = 'Binnenkomst Gevecht'
L.Crafting = 'Ambacht'
L.GuildBanker = 'Bij de Gildebank'
L.VoidStorageBanker = 'Bij Lege Opslag'
L.MailInfo = 'Bij een Brievenbus'
L.MapFrame = 'Wereldkaart Openen'
L.Merchant = 'Praten met Handelaar'
L.PlayerFrame = 'Personage Info Openen'
L.ScrappingMachine = 'Uitrusting Verschroten'
L.Socketing = 'Uitrusting Inzetten'
L.TradePartner = 'Handelen'
L.Vehicle = 'Voertuig Binnenkomen'

-- colors
L.ColorOptions = 'Slot Instellingen'
L.ColorOptionsDesc = 'Deze instellingen laten je veranderen hoe itemslots worden weergegeven op %s frames voor gemakkelijkere identificatie.'

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

-- rulesets
L.RuleOptions = 'Item Regelsets'
L.RuleOptionsDesc = 'Deze instellingen laten je kiezen welke itemregelsets weer te geven en in welke volgorde.'