--[[
    Spanish Localization
        Credits/Blame: Phanx, Woopy
--]]

local CONFIG = ...
local L = LibStub('AceLocale-3.0'):NewLocale(CONFIG, 'esES') or LibStub('AceLocale-3.0'):NewLocale(CONFIG, 'esMX')
if not L then return end
local NEW = BATTLENET_FONT_COLOR:WrapTextInColorCode(' ' .. NEW_CAPS)

-- Spanish
L.InstalledFilters = 'Filtros instalados'
L.CustomFilters = 'Filtros personalizados'
L.NewFilter = 'Nuevo filtro'
L.NewSearch = 'Nueva búsqueda'
L.NewMacro = 'Nueva macro'
L.Import = 'Importar'
L.SharePopup = 'Copia estos datos y compártelos:'
L.ImportPopup = 'Pega los datos para importar:|n|cnERROR_COLOR:(Advertencia: solo importa filtros de fuentes en las que confíes)|r'

-- general
L.GeneralOptionsDescription = 'Funciones generales que puedes aplicar según tus preferencias.'

L.Locked = 'Bloquear ventanas'
L.CountItems = 'Contador en tooltips de objetos'
L.CountGuild = 'Incluir banco de hermandad'
L.CountCurrency = 'Contador en tooltips de moneda'
L.FlashFind = 'Búsqueda instantánea'
L.FlashFindTip = 'Si se activa, al hacer clic con Alt en un objeto, resaltarán todas las ranuras con ese mismo objeto en todas las ventanas.'
L.DisplayBlizzard = 'Mostrar ventanas de Blizzard para bolsas desactivadas'
L.DisplayBlizzardTip = 'Si se activa, se mostrará la interfaz por defecto de Blizzard para bolsas ocultas del inventario o del banco.\n\n|cffff1919Requiere recargar la IU.|r'
L.ConfirmGlobals = '¿Estás seguro de que quieres desactivar la configuración específica para este personaje? Se perderán todos los ajustes guardados.'
L.CharacterSpecific = 'Ajustes del personaje'

-- frame
L.FrameOptions = 'Opciones de ventana'
L.FrameOptionsDescription = 'Estos son ajustes específicos para la ventana %s.'

L.Frame = 'Ventana'
L.Enabled = 'Activar esta ventana'
L.EnabledTip = 'Si se desactiva, se mostrará la ventana por defecto de Blizzard.\n\n|cffff1919Requiere recargar la IU|r'
L.ActPanel = 'Actuar como panel estándar'
L.ActPanelTip = [[
Si está activado, este panel se posicionará automáticamente
a sí mismo igual que los paneles estándar, como el |cffffffffLibro de hechizos|r
o el |cffffffffBuscador de mazmorras|r, y no se podrá mover.]]

L.BagToggle = 'Mostrar bolsas'
L.Broker = 'Plugins del Databroker'
L.Sort = 'Botón para ordenar'
L.Search = 'Botón para buscar'
L.Options = 'Botón para opciones'
L.Reagents = 'Botón para componentes'
L.LeftTabs = 'Pestañas a la izquierda'
L.LeftTabsTip = [[
Si está activado, las pestañas laterales
se mostrarán en el lado izquierdo del panel.]]

L.Appearance = 'Apariencia'
L.Layer = 'Capa'
L.BagBreak = 'Espaciado entre bolsas' .. NEW
L.ByType = 'Por tipo'
L.ReverseBags = 'Invertir bolsas'
L.ReverseSlots = 'Invertir ranuras'

L.Color = 'Color del fondo'
L.BorderColor = 'Color del borde'

L.Strata = 'Capa'
L.Skin = 'Estilo' .. NEW
L.Columns = 'Columnas'
L.Scale = 'Escala'
L.ItemScale = 'Escala de objeto'
L.Spacing = 'Espaciado'
L.Alpha = 'Opacidad'

-- slots
L.SlotOptions = 'Opciones de ranuras'
L.SlotOptionsDescription = 'Estas opciones te permiten cambiar cómo se presentan las ranuras de objetos en los marcos de %s para una identificación más fácil.'

L.GlowQuality = 'Colorear por calidad'
L.GlowQuest = 'Colorear objetos de misión'
L.GlowUnusable = 'Colorear objetos no utilizables'
L.GlowSets = 'Colorear conjuntos de equipo'
L.GlowNew = 'Brillar objetos nuevos'
L.GlowPoor = 'Marcar objetos de baja calidad'
L.GlowAlpha = 'Brillo del resplandor'

L.EmptySlots = 'Mostrar fondo'
L.SlotBackground = 'Arte'
L.ColorSlots = 'Color por tipo de bolsa'
L.NormalColor = 'Color normal'
L.KeyColor = 'Color de llavero'
L.QuiverColor = 'Color de carcaj'
L.SoulColor = 'Color de bolsa de almas'
L.ReagentColor = 'Color de bolsa de componentes'
L.LeatherColor = 'Color de peletería'
L.InscribeColor = 'Color de inscripción'
L.HerbColor = 'Color de herboristería'
L.EnchantColor = 'Color de encantamiento'
L.EngineerColor = 'Color de ingeniería'
L.GemColor = 'Color de gema'
L.MineColor = 'Color de minería'
L.TackleColor = 'Color de caja de pesca'
L.FridgeColor = 'Color de refrigerador'

-- auto display
L.DisplayOptions = 'Opciones para mostrar'
L.DisplayOptionsDescription = 'Estas opciones te permiten ajustar cuándo se abre o cierra automáticamente tu inventario debido a eventos del juego.'

L.DisplayInventory = 'Mostrar inventario'
L.CloseInventory = 'Cerrar inventario'

L.Auctioneer = 'Al visitar la casa de subastas'
L.Banker = 'Al visitar el banco'
L.Combat = 'Al entrar en combate'
L.Crafting = 'Al abrir una ventana de profesión'
L.GuildBanker = 'Al abrir el banco de hermandad'
L.VoidStorageBanker = 'Al visitar el depósito del vacío'
L.MailInfo = 'Al abrir el buzón'
L.MapFrame = 'Al abrir el mapa del mundo'
L.Merchant = 'Al salir de un vendedor'
L.PlayerFrame = 'Al abrir la información del personaje'
L.ScrappingMachine = 'Al reciclar equipo'
L.Socketing = 'Al insertar gemas'
L.TradePartner = 'Al comerciar'
L.Vehicle = 'Al entrar en un vehículo'

-- rulesets
L.RuleOptions = 'Reglas de objetos'
L.RuleOptionsDescription = 'Estos ajustes permiten establecer qué reglas se aplican y en qué orden.'

-- info
L.HelpDescription = 'Aquí proporcionamos respuestas a las preguntas más frecuentes. Si ninguna resuelve tu problema, podrías considerar pedir ayuda en la comunidad de usuarios de %s en Discord.'
L.Patrons = 'Patrocinadores'
L.PatronsDescription = '%s se distribuye de forma gratuita y se sostiene a través de donaciones. Un agradecimiento masivo a todos los patrocinadores en Patreon y Paypal que mantienen el desarrollo vivo. También puedes convertirte en un patrocinador en |cFFF96854patreon.com/jaliborc|r.'
L.AskCommunity = 'Pregunta a la comunidad'
L.JoinUs = 'Unéte a nosotros'

L.FAQ = {
  '¿Cómo ver el banco, hermandad u otro personaje sin conexión?',
  'Haz clic en el botón de "Visualización sin conexión" en la parte superior izquierda de tu inventario. Se parece a un retrato del personaje que estás jugando actualmente.',

  '¿Cómo hacer que Bagnon olvide a un personaje eliminado o renombrado?',
  'Haz clic en el botón de "Visualización sin conexión" en la parte superior izquierda de tu inventario. Cada nombre de personaje tendrá una cruz roja junto a él. Haz clic en la cruz del personaje que deseas eliminar.',

  '¡Algo está mal! Los niveles de los objetos no se están mostrando sobre las ranuras.',
  'Bagnon no muestra nativamente los niveles de los objetos. Debes estar utilizando un complemento de terceros, como |cffffd200Bagnon ItemLevel|r o |cffffd200Bagnon ItemInfo|r. Intenta actualizar los complementos que estás utilizando; la causa más común es que estén desactualizados.|n|nTen en cuenta que cualquier problema con los complementos debe ser reportado a sus autores, no a Jaliborc.',

  'Bagnon está ocultando una de mis bolsas.',
  'Probablemente lo ocultaste accidentalmente. Haz clic en el botón de las ranuras de bolsas para ver tus bolsas. Luego, puedes hacer clic en cualquier bolsa para alternar su visibilidad.',

  '¿Cómo alternar Bagnon para el banco, depósito del vacío, etc.?',
  'Ve a Bagnon -> Opciones de ventana. Estás buscando las dos opciones en la parte superior del panel. Elige la "Ventana" que deseas alternar y luego haz clic en "Activar esta ventana".'
}
