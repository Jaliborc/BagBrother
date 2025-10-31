--[[
	Italian Localization
]]--

local CONFIG = ...
local L = LibStub('AceLocale-3.0'):NewLocale(CONFIG, 'itIT')
if not L then return end
local NEW = BATTLENET_FONT_COLOR:WrapTextInColorCode(' ' .. NEW_CAPS)

-- filters
L.InstalledFilters = 'Filtri installati'
L.CustomFilters = 'Filtri personalizzati'
L.NewFilter = 'Nuovo filtro'
L.NewSearch = 'Nuova ricerca'
L.NewMacro = 'Nuova macro'
L.Import = 'Importa'
L.SharePopup = 'Copia questi dati e condividili:'
L.ImportPopup = 'Incolla i dati da importare:|n|cnERROR_COLOR:(Avviso - importa solo filtri da fonti affidabili)|r'

-- general options
L.GeneralOptionsDesc = 'Impostazioni generali di configurazioni per %s.'

L.Locked = 'Blocca la posizione della finestra.'
L.CountItems = 'Attiva conteggio degli oggetti.'
L.CountGuild = 'Includi Banca di Gilda'
L.FlashFind = 'Attiva Ricerca Veloce.'
L.DisplayBlizzard = 'Mostra le finestre di Blizzard per le borse disabilitate.'
L.DisplayBlizzardTip = 'Se abilitato, verrà utilizzata l\'interfaccia Blizzard di base per le sacche o gli inventari di banca nascosti.\n\n|cffff1919Richiede un riavvio dell\'UI.|r'
L.ConfirmGlobals = 'Sei sicuro di voler disabilitare le impostazioni specifiche per questo personaggio? Tutte le impostazioni specifiche verranno perse.'
L.CharacterSpecific = 'Impostazioni specifiche personaggio'

-- frame options
L.FrameOptions = 'Impostazioni finestre'
L.FrameOptionsDesc = 'Configurazioni specifiche per le finestre di %s.'

L.Frame = 'Finestra'
L.Enabled = 'Attiva la finestra'
L.EnabledTip = 'Se disabilitato, l\'interfaccia Blizzard predefinita non verrà sostituita per questa finestra.\n\n|cffff1919Richiede un riavvio dell\'UI.|r'
L.ActPanel = 'Considera come Finestra Standard'
L.ActPanelTip = [[
Se abilitato, questa finestra si posizionerà automaticamente come quelle standard dell\'interfaccia, come quella del |cffffffffGrimorio|r
 o della |cffffffffRicerca delle Incursioni|r, e non potrà essere spostata.]]


L.BagToggle = 'Attiva Riquadro Borse'
L.Broker = 'Plugins Databroker'
L.Sort = "Pulsante per l'Ordinamento"
L.Search = 'Pulsante di Ricerca'
L.Options = 'Pulsante delle Opzioni'
L.ExclusiveReagent = 'Separa la Banca dei Reagenti'
L.LeftTabs = 'Rulesets a Sinistra'
L.LeftTabsTip = [[
Se abilitato, i pannelli laterali verranno mostrati a sinistra della finestra]]

L.Appearance = 'Aspetto'
L.Layer = 'Livello'
L.BagBreak = 'Separazione tra Borse' .. NEW
L.ReverseBags = 'Inverti le Borse'
L.ReverseSlots = 'Inverti gli Scomparti'

L.Color = 'Colore della Finestra'
L.BorderColor = 'Colore del Bordo'

L.Strata = 'Livello'
L.Columns = 'Colonne'
L.Scale = 'Proporzione'
L.ItemScale = 'Scala di Oggetti'
L.Spacing = 'Distanza'
L.Alpha = 'Opacità'

-- auto display
L.DisplayOptions = 'Mostra Automaticamente'
L.DisplayOptionsDesc = 'Queste opzioni ti permettono di configurare quando aprire o chiudere l\'inventario automaticamente in base agli eventi in gioco.'
L.DisplayInventory = 'Mostra l\'Inventario'
L.CloseInventory = 'Chiudi l\'Inventario'

L.Banker = "Quando si visita la Banca"
L.GuildBanker = "Quando si visita la Banca di Gilda"
L.Auctioneer = "Quando si visita la Casa d'Aste"
L.MailInfo = "Quando controlli la posta"
L.TradePartner = "Quando scambi degli oggetti"
L.ScrappingMachine = 'Quando ricicli dell\'equipaggiamento'
L.Socketing = "Quando inserisci una gemma nell'Incavo di un Oggetto"
L.Crafting = "Durante la creazione di un\'Oggetto"
L.PlayerFrame = "Quando apri la Finestra del Giocatore"
L.Merchant = "Quando ti allontani da un Venditore"

L.Combat = "Quando entri in Combattimento"
L.Vehicle = "Quando entri un Veicolo"
L.MapFrame = 'Quando apri la Mappa del Mondo'

-- colors
L.ColorOptions = 'Impostazioni del Colore'
L.ColorOptionsDesc = 'Impostazione dei Colori sui vari Oggetti.'

L.GlowQuality = 'Evidenzia Oggetti per Qualità.'
L.GlowQuest = 'Evidenzia Oggetti delle Missioni.'
L.GlowUnusable = 'Evidenzia Oggetti non Utilizzabili.'
L.GlowSets = "Evidenzia l'Equipaggiamento che fa parte di un Set."
L.GlowNew = 'Evidenzia i Nuovi Oggetti.'
L.GlowPoor = 'Evidenzia Oggetti Inutili'
L.GlowAlpha = 'Brillantezza del Bagliore'

L.EmptySlots = 'Mostra Sfondo'
L.ColorSlots = 'Colora per Tipo di Borsa'
L.NormalColor = 'Colore Normale'
L.KeyColor = 'Colore Portachiavi'
L.QuiverColor = 'Colore Faretra'
L.SoulColor = 'Colore Sacche per Anime'
L.ReagentColor = 'Colore Banca dei Reagenti'
L.LeatherColor = 'Colore per Conciatori'
L.InscribeColor = 'Colore per Runografi'
L.HerbColor = 'Colore per Erbalisti'
L.EnchantColor = 'Colore per Incantatori'
L.EngineerColor = 'Colore per Ingegneri'
L.GemColor = 'Colore per Gemme'
L.MineColor = 'Colore per Minatori'
L.TackleColor = 'Colore per Sacca degli Attrezzi'
L.FridgeColor = 'Colore per Sacche da Cucina'

-- info
L.HelpDescription = 'Qui troverai le risposte alle domande più frequenti. Se nessuna risolve il tuo problema, puoi chiedere aiuto alla comunità di utenti %s su Discord.'
L.Patrons = 'Sostenitori'
L.PatronsDescription = '%s è distribuito gratuitamente e mantenuto grazie alle donazioni. Un enorme grazie a tutti i sostenitori su Patreon e Paypal che tengono vivo lo sviluppo. Puoi diventare anche tu un sostenitore su |cFFF96854patreon.com/jaliborc|r.'
L.AskCommunity = 'Chiedi alla comunità'
L.JoinUs = 'Unisciti a noi'

L.FAQ = {
  'Come depositare oggetti direttamente nella banca della banda di guerra?',
  'Fai Maiusc + clic destro sullo slot dell’oggetto e verrà posizionato nelle borse della banda di guerra invece di quelle normali.',

  'Come vedere la banca, la gilda o un altro personaggio offline?',
  'Clicca sul pulsante "Visualizzazione offline" in alto a sinistra dell’inventario. Ha l’aspetto del ritratto del personaggio attualmente in uso.',

  'Come far dimenticare ad ADDON un personaggio eliminato o rinominato?',
  'Clicca sul pulsante "Visualizzazione offline" in alto a sinistra dell’inventario. Ogni nome di personaggio ha accanto un pulsante di eliminazione (una croce rossa). Clicca sulla croce del personaggio che vuoi rimuovere.',

  'Qualcosa non va! I livelli degli oggetti non vengono mostrati.',
  'ADDON non mostra nativamente i livelli degli oggetti. Devi usare un componente aggiuntivo di terze parti, come |cffffd200Bagnon ItemLevel|r o |cffffd200Bagnon ItemInfo|r. Prova ad aggiornare i componenti aggiuntivi: la causa più comune è una versione obsoleta.|n|nEventuali problemi con i componenti aggiuntivi devono essere segnalati ai rispettivi autori, non a Jaliborc.',

  'Alcune delle mie borse non compaiono.',
  'Probabilmente le hai nascoste per errore. Clicca sul pulsante Borse in alto a sinistra della finestra per visualizzarle. Poi puoi cliccare su una borsa per alternarne la visibilità.',

  'Come attivare o disattivare ADDON per Banca, Deposito Etereo, ecc.?',
  'Vai su ADDON -> Impostazioni Finestra. Le due opzioni nella parte superiore del pannello ti permettono di scegliere la "Finestra" da attivare e di cliccare "Abilita Finestra".'
}