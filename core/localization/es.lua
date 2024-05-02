--[[
    Spanish Localization (Credits/Blame: Phanx, Woopy)
--]]

local ADDON = ...
local L = LibStub('AceLocale-3.0'):NewLocale(ADDON, 'esES') or LibStub('AceLocale-3.0'):NewLocale(ADDON, 'esMX')
if not L then return end

--keybindings
L.OpenBags = 'Mostrar inventario'
L.OpenBank = 'Mostrar banco'
L.OpenGuild = 'Mostrar banco de hermandad'
L.OpenVault = 'Mostrar depósito del vacío'

--frame titles
L.TitleBags = 'Inventario de %s'
L.TitleBank = 'Banco de %s'
L.TitleVault = 'Depósito del Vacío de %s'

--actions
L.Drag = 'Arrastrar'
L.Guilds = 'Hermandad'
L.Locations = 'Ubicación'
L.Characters = 'Personajes'
L.BrowseItems = 'Navegar objetos'
L.HideBag = 'Haz clic para ocultar esta bolsa.'
L.ShowBag = 'Haz clic para mostrar esta bolsa.'
L.HideSlots = 'Ocultar ranuras'
L.ViewSlots = 'Mostrar ranuras'
L.FocusNormal = 'Enfoque normal'
L.FocusTrade = 'Enfoque comercio'
L.GuildFunds = 'Fondos de la hermandad'
L.TipDeposit = '%s para depositar.'
L.TipWithdraw = '%s para retirar (%s restantes).'
L.NumWithdraw = 'Retirar %d'
L.NumDeposit = 'Depositar %d'
L.NumRemainingWithdrawals = '%d Restantes'

--dropdowns
L.OfflineViewing = 'Visualización sin conexión'
L.ServerSorting = 'Reordenamiento al lado del servidor'
L.ServerSortingTip = 'Si debes permitir que el servidor del juego reordena los objetos.'
L.CleanupOptions = 'Opciones de limpieza'
L.LockItems = 'Bloquear ranuras'
L.RequiresClientSorting = '¡Requiere reordenamiento al lado del cliente!'

--dialogs
L.AskMafia = 'Pregunta a La Mafia'
L.ConfirmDelete = '¿Estás seguro de querer eliminar los datos guardados de %s?'
L.ConfirmTransfer = 'Depositar estos objetos eliminará todas las modificaciones y las hará no intercambiables y no reembolsables.|n|n¿Quieres continuar?'
L.CannotPurchaseVault = 'No tienes suficiente dinero para desbloquear el servicio de Depósito del Vacío|n|n|cffff2020Precio: %s|r'
L.PurchaseVault = '¿Quieres desbloquear el servicio de Depósito del Vacío?|n|n|cffffd200Precio: |r %s'
L.ConfigurationMode = 'Ahora estás en el modo de configuración de reordenamiento al lado del cliente.|n|nHaz clic en las ranuras de objetos para alternar si deben bloquearse mientras se reordenan.'
L.OutOfDate = 'Tu versión de |cffffd200%s|r podría ser desactualizada!|n%s informó haber|n|cff82c5ff%s|r, actualice si es cierto.'
L.InvalidVersion = 'Tu copia de |cffffd200%s|r está corrupta o es ilegal..|nDescarga una versión oficial de forma gratuita.'
