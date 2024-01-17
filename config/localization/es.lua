--[[
    Spanish Localization (Credits/Blame: Phanx, Woopy)
--]]

local CONFIG = ...
local L = LibStub('AceLocale-3.0'):NewLocale(CONFIG, 'esES') or LibStub('AceLocale-3.0'):NewLocale(CONFIG, 'esMX')
if not L then return end

-- general
L.GeneralOptionsDescription = 'Funciones generales que puedes aplicar según tus preferencias.'

L.Locked = 'Bloquear posiciones'
L.CountItems = 'Contador en tooltips de objetos'
L.CountGuild = 'Incluir banco de hermandad'
L.CountCurrency = 'Contador en tooltips de moneda'
L.FlashFind = 'Búsqueda instantánea'
L.FlashFindTip = 'Si se activa, al hacer clic con Alt en un objeto, resaltarán todas las ranuras con ese mismo objeto en todos los marcos.'
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
L.Money = 'Dinero'
L.Broker = 'Panel de información'
L.Currency = 'Moneda'
L.ExclusiveReagent = 'Banco de componentes separado'
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
L.BagBreak = 'Espacio entre bolsas'
L.ByType = 'Por tipo'
L.ReverseBags = 'Invertir bolsas'
L.ReverseSlots = 'Invertir ranuras'

L.Color = 'Color de fondo'
L.BorderColor = 'Color de borde'

L.Strata = 'Nivel de superposición'
L.Skin = 'Estilo'
L.Columns = 'Columnas'
L.Scale = 'Escala'
L.ItemScale = 'Escala de objetos'
L.Spacing = 'Espacio'
L.Alpha = 'Opacidad'

-- auto display
L.DisplayOptions = 'Apertura automática'
L.DisplayOptionsDescription = 'Estos ajustes permiten configurar si tu inventario se muestra o se oculta automáticamente en repuesta a ciertos eventos del juego.'

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

-- colors
L.ColorOptions = 'Opciones de color'
L.ColorOptionsDescription = 'Estas opciones te permite cambiar los colores de las ranuras en las ventanas de %s.'

L.GlowQuality = 'Colorear según la calidad'
L.GlowQuest = 'Colorear objetos de misión'
L.GlowUnusable = 'Colorear objetos inutilizables'
L.GlowSets = 'Colorear conjuntos de equipamiento'
L.GlowNew = 'Resaltar objetos nuevos'
L.GlowPoor = 'Resaltar chatarra'
L.GlowAlpha = 'Opacidad del resaltado'

L.EmptySlots = 'Mostrar fondo de ranuras vacías'
L.SlotBackground = 'Arte'
L.ColorSlots = 'Colorear ranuras vacías según tipo de bolsa'
L.NormalColor = 'Bolsa normal'
L.KeyColor = 'Bolsa de llaves'
L.QuiverColor = 'Carcaj'
L.SoulColor = 'Bolsa de almas'
L.ReagentColor = 'Banco de componentes'
L.LeatherColor = 'Bolsa de peletería'
L.InscribeColor = 'Bolsa de inscripción'
L.HerbColor = 'Bolsa de hierbas'
L.EnchantColor = 'Bolsa de encantamiento'
L.EngineerColor = 'Bolsa de ingeniería'
L.GemColor = 'Bolsa de gemas'
L.MineColor = 'Bolsa de minería'
L.TackleColor = 'Caja de aparejos'
L.FridgeColor = 'Bolsa de cocina'

-- rulesets
L.RuleSettings = 'Reglas de objetos'
L.RuleSettingsDesc = 'Estos ajustes permiten establecer qué reglas se aplican y en qué orden.'

-- info
L.Help = HELP_LABEL
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

  '¿Cómo alternar Bagnon para el banco, Depósito del Vacío, etc.?',
  'Ve a Bagnon -> Opciones de ventana. Estás buscando las dos opciones en la parte superior del panel. Elige la "Ventana" que deseas alternar y luego haz clic en "Activar esta ventana".'
}
