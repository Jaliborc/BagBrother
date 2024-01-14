--[[
    Spanish Localization
--]]

local ADDON = ...
local L = LibStub('AceLocale-3.0'):NewLocale(ADDON, 'esES') or LibStub('AceLocale-3.0'):NewLocale(ADDON, 'esMX')
if not L then return end

--keybindings
L.ToggleBags = 'Mostrar inventario'
L.ToggleBank = 'Mostrar banco'
L.ToggleGuild = 'Mostrar banco de hermandad'
L.ToggleVault = 'Mostrar Depósito del Vacío'

--terminal
L.Commands = 'Lista de comandos'
L.CmdShowInventory = 'Muestra tu inventario'
L.CmdShowBank = 'Muestra tu banco'
L.CmdShowGuild = 'Muestra tu banco de hermandad'
L.CmdShowVault = 'Muestra tu Depósito del Vacío'
L.CmdShowVersion = 'Muestra la versión actual'
L.CmdShowOptions = 'Abre el menú de configuración'

--frame titles
L.TitleBags = 'Inventario de %s'
L.TitleBank = 'Banco de %s'
L.TitleVault = 'Depósito del Vacío de %s'

--dropdowns
L.SelectCharacter = 'Seleccionar personaje'
L.ConfirmDelete = '¿Estás seguro de querer eliminar los datos guardados de %s?'
L.OfflineViewing = 'Visualización sin conexión'
L.ConfirmDelete = '¿Estás seguro de que deseas eliminar los datos almacenados en caché de %s?'
L.ServerSorting = 'Reordenamiento al lado del servidor'
L.ServerSortingTip = 'Si debes permitir que el servidor del juego reordena los objetos.'
L.CleanupOptions = 'Opciones de limpieza'
L.LockItems = 'Bloquear ranuras'
L.RequiresClientSorting = '¡Requiere reordenamiento del lado del cliente!'

--interactions
L.Click = 'Clic'
L.Drag = '<Arrastrar>'
L.LeftClick = '<Clic Izquierdo>'
L.RightClick = '<Clic Derecho>'
L.DoubleClick = '<Doble Clic>'
L.ShiftClick = '<Mayús Clic>'

--tooltips
L.Total = 'Total'
L.GuildFunds = 'Fondos de hermandad'
L.TipGoldOnRealm = 'Total en %s'
L.NumWithdraw = 'Retirar %d'
L.NumDeposit = 'Depositar %d'
L.NumRemainingWithdrawals = 'Puedes retirar %d objetos más'

--action tooltips
L.TipChangePlayer = '%s para ver los objetos de otro personaje.'
L.TipCleanItems = '%s para reordenar objetos.'
L.TipConfigure = '%s para configurar esta ventana.'
L.TipDepositReagents = '%s para depositar todos los componentes en el banco.'
L.TipDeposit = '%s para depositar.'
L.TipWithdraw = '%s para retirar (%s restantes).'
L.TipFrameToggle = '%s para mostrar otras ventanas.'
L.TipHideBag = '%s para ocultar esta bolsa.'
L.TipHideBags = '%s para ocultar las bolsas.'
L.TipHideSearch = '%s para dejar de buscar.'
L.TipMove = '%s para mover.'
L.TipPurchaseBag = '%s para comprar esta ranura de banco.'
L.TipResetPlayer = '%s para volver al personaje actual.'
L.TipShowBag = '%s para mostrar esta bolsa.'
L.TipShowBags = '%s para mostrar las bolsas.'
L.TipShowBank = '%s para mostrar tu banco.'
L.TipShowInventory = '%s para mostrar tu inventario.'
L.TipShowOptions = '%s para abrir el menú de configuración.'
L.TipShowSearch = '%s para buscar.'
L.TipToggleBank = '%s para mostrar tu banco.'
L.TipToggleTrade = '%s para mostrar tus bolsas de profesión.'

--itemcount tooltips
L.TipCountEquip = 'Equipado: %d'
L.TipCountBags = 'Bolsas: %d'
L.TipCountBank = 'Banco: %d'
L.TipCountVault = 'Depósito: %d'
L.TipCountGuild = 'Hermandad: %d'

--dialogs
L.AskMafia = 'Pregunta a La Mafia'
L.ConfirmTransfer = 'Depositar estos objetos eliminará todas las modificaciones y las hará no intercambiables y no reembolsables.|n|n¿Quieres continuar?'
L.CannotPurchaseVault = 'No tienes suficiente dinero para desbloquear el servicio de Depósito del Vacío|n|n|cffff2020Precio: %s|r'
L.PurchaseVault = '¿Quieres desbloquear el servicio de Depósito del Vacío?|n|n|cffffd200Precio: |r %s'
L.ConfigurationMode = 'Ahora estás en el modo de configuración de reordenamiento al lado del cliente.|n|nHaz clic en las ranuras de objetos para alternar si deben bloquearse mientras se reordenan.'
L.OutOfDate = 'Tu versión de |cffffd200%s|r podría ser desactualizada!|n%s informó haber|n|cff82c5ff%s|r, actualice si es cierto.'
L.InvalidVersion = 'Tu copia de |cffffd200%s|r está corrupta o es ilegal..|nDescarga una versión oficial de forma gratuita.'
