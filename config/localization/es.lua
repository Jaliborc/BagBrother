--[[
    Spanish Localization
        Credits/Blame: Phanx, Woopy
--]]

local CONFIG = ...
local L = LibStub('AceLocale-3.0'):NewLocale(CONFIG, 'esES')
if not L then return end

-- filters
L.InstalledFilters = 'Filtros Instalados'
L.CustomFilters = 'Filtros Personalizados'
L.NewFilter = 'Nuevo Filtro'
L.NewSearch = 'Nueva Búsqueda'
L.NewMacro = 'Nueva Macro'
L.Import = 'Importar'
L.EnterSearch = 'Introducir Consulta de Búsqueda:'
L.SharePopup = 'Copia estos datos y compártelos:'
L.ImportPopup = 'Pega los datos para importar:|n|cnERROR_COLOR:(Advertencia: solo importa filtros de fuentes en las que confíes)|r'

-- general options
L.GeneralOptionsDescription = 'Funciones generales que puedes aplicar según tus preferencias.'

L.CountItems = 'Contador en Tooltips de Objetos'
L.CountGuild = 'Incluir Banco de Hermandad'
L.CountCurrency = 'Contador en Tooltips de Moneda'
L.CountPerFaction = 'Solo Misma Facción'
L.CountPerFactionTip = 'Si se activa, los tooltips solo incluirán personajes/hermandades de tu facción actual.'
L.ConfirmGlobals = '¿Estás seguro de que quieres desactivar la configuración específica para este personaje? Se perderán todos los ajustes guardados.'
L.CharacterSpecific = 'Ajustes del Personaje'
L.DisplayBlizzard = 'Mostrar Ventanas de Blizzard para Bolsas Desactivadas'
L.DisplayBlizzardTip = 'Si se activa, se mostrará la interfaz por defecto de Blizzard para bolsas ocultas del inventario o del banco.\n\n|cffff1919Requiere recargar la IU.|r'
L.Locked = 'Bloquear Ventanas'
L.FlashFind = 'Búsqueda Instantánea'
L.FlashFindTip = 'Si se activa, al hacer clic con Alt en un objeto, resaltarán todas las ranuras con ese mismo objeto en todas las ventanas.'
L.Tooltips = 'Descripciones Emergentes'

-- frame options
L.FrameOptions = 'Opciones de Ventana'
L.FrameOptionsDescription = 'Estos son ajustes específicos para la ventana %s.'

L.Frame = 'Ventana'
L.Enabled = 'Activar Esta Ventana'
L.EnabledTip = 'Si se desactiva, se mostrará la ventana por defecto de Blizzard.\n\n|cffff1919Requiere recargar la IU|r'
L.ActPanel = 'Actuar como Panel Estándar'
L.ActPanelTip = [[
Si está activado, este panel se posicionará automáticamente
a sí mismo igual que los paneles estándar, como el |cffffffffLibro de hechizos|r
o el |cffffffffBuscador de mazmorras|r, y no se podrá mover.]]

L.BagToggle = 'Mostrar Bolsas'
L.Broker = 'Plugins del Databroker'
L.Currency = 'Seguimiento de Monedas'
L.Deposit = 'Botón de Depósito'
L.Sidebar = 'Filtros Laterales'
L.Sort = 'Botón para Ordenar'
L.Search = 'Botón para Buscar'
L.Options = 'Botón para Opciones'
L.Tabs = 'Filtros Inferiores'

L.Appearance = 'Apariencia'
L.Layer = 'Capa'
L.BagBreak = 'Espaciado entre Bolsas'
L.BreakSpace = 'Espaciado de Salto'
L.BreakNormal = 'Normales vs. Especializadas'
L.ByType = 'Por Tipo'
L.ReverseBags = 'Invertir Bolsas'
L.ReverseSlots = 'Invertir Ranuras'

L.Color = 'Color del Fondo'
L.BorderColor = 'Color del Bordo'

L.Strata = 'Capa'
L.Skin = 'Estilo'
L.Columns = 'Columnas'
L.Scale = 'Escala'
L.ItemScale = 'Escala de Objeto'
L.Spacing = 'Espaciado'
L.Alpha = 'Opacidad'

-- slot options
L.SlotOptions = 'Opciones de Ranuras'
L.SlotOptionsDescription = 'Estas opciones te permiten cambiar cómo se presentan las ranuras de objetos en los marcos de %s para una identificación más fácil.'

L.GlowQuality = 'Colorear por Calidad'
L.GlowQuest = 'Colorear Objetos de Misión'
L.GlowUnusable = 'Colorear Objetos no Utilizables'
L.GlowSets = 'Colorear Conjuntos de Equipo'
L.GlowNew = 'Brillar Objetos Nuevos'
L.GlowPoor = 'Marcar Objetos de Baja Calidad'
L.GlowAlpha = 'Brillo del Resplandor'

L.EmptySlots = 'Mostrar Fondo'
L.SlotBackground = 'Arte'
L.ColorSlots = 'Color por Tipo de Bolsa'
L.AccountColor = 'Color de Banda de Guerra'
L.NormalColor = 'Color Normal'
L.KeyColor = 'Color de Llavero'
L.QuiverColor = 'Color de Carcaj'
L.SoulColor = 'Color de Bolsa de Almas'
L.ReagentColor = 'Color de Bolsa de Componentes'
L.LeatherColor = 'Color de Peletería'
L.InscribeColor = 'Color de Inscripción'
L.HerbColor = 'Color de Herboristería'
L.EnchantColor = 'Color de Encantamiento'
L.EngineerColor = 'Color de Ingeniería'
L.GemColor = 'Color de Gema'
L.MineColor = 'Color de Minería'
L.TackleColor = 'Color de Caja de Pesca'
L.FridgeColor = 'Color de Refrigerador'

-- auto display
L.DisplayOptions = 'Opciones para Mostrar'
L.DisplayOptionsDescription = 'Estas opciones te permiten ajustar cuándo se abre o cierra automáticamente tu inventario debido a eventos del juego.'

L.DisplayInventory = 'Mostrar Inventario'
L.Auctioneer = 'Al Visitar la Casa de Subastas'
L.Banker = 'Al Visitar el Banco'
L.Crafting = 'Al Abrir una Ventana de Profesión'
L.GuildBanker = 'Al Abrir el Banco de Hermandad'
L.VoidStorageBanker = 'Al Visitar el Depósito del Vacío'
L.MailInfo = 'Al Abrir el Buzón'
L.Merchant = 'Al Salir de un Vendedor'
L.Character = 'Al Abrir la Información del Personaje'
L.TradePartner = 'Al Comerciar'
L.Transmogrifier = 'Al Modificar Objetos'

L.CloseInventory = 'Cerrar Inventario'
L.MapFrame = 'Al Abrir el Mapa del Mundo'
L.Combat = 'Al Entrar en Combate'
L.Vehicle = 'Al Entrar en un Vehículo'

-- info
L.HelpDescription = 'Aquí proporcionamos respuestas a las preguntas más frecuentes. Si ninguna resuelve tu problema, podrías considerar pedir ayuda en la comunidad de usuarios de %s en Discord.'
L.Patrons = 'Patrocinadores'
L.PatronsDescription = '%s se distribuye de forma gratuita y se sostiene a través de donaciones. Un agradecimiento masivo a todos los patrocinadores en Patreon y Paypal que mantienen el desarrollo vivo. También puedes convertirte en un patrocinador en |cFFF96854patreon.com/jaliborc|r.'
L.AskCommunity = 'Pregunta a la Comunidad'
L.JoinUs = 'Unéte a Nosotros'

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
