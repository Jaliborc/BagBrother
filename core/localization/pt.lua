--[[
	Portuguese Localization
--]]

local ADDON = ...
local L = LibStub('AceLocale-3.0'):NewLocale(ADDON, 'ptBR')
if not L then return end

--keybindings
L.OpenBags = 'Abrir Mochila'
L.OpenBank = 'Abrir Banco'
L.OpenGuild = 'Abrir Banco da Guilda'
L.OpenVault = 'Abrir Cofre'

--frame titles
L.TitleBags = 'Mochila de %s'
L.TitleBank = 'Banco de %s'
L.TitleVault = 'Cofre de %s'

--actions
L.Bags = 'Bolsas'
L.Drag = 'Arrastar'
L.Guilds = 'Guildas'
L.Locations = 'Locais'
L.Characters = 'Personagens'
L.BrowseItems = 'Navegar Itens'
L.HideBag = 'Clique para esconder esta bolsa.'
L.ShowBag = 'Clique para mostrar esta bolsa.'
L.HideSlots = 'Esconder Espaços'
L.ViewSlots = 'Mostrar Espaços'
L.FocusNormal = 'Focar Normais'
L.FocusTrade = 'Focar Profissionais'
L.GuildFunds = 'Dinheiro da Guilda'
L.NumAllowed = '%s Permitidos'
L.NumWithdraw = '%d Retirar'
L.NumDeposit = '%d Depositar'
L.NumRemaining = '%d Restantes'

--dropdowns
L.OfflineViewing = 'Visualização Offline'
L.ServerSorting = 'Ordenar pelo Servidor'
L.ServerSortingTip = 'Se o servidor de jogo deve ordenar os itens, quando disponível.'
L.CleanupOptions = 'Opções de Limpeza'
L.LockItems = 'Bloquear Slots de Itens'
L.RequiresClientSorting = 'Requer ordenação pelo cliente!'

--dialogs
L.AskMafia = 'Perguntar à Máfia'
L.ConfirmDelete = 'Tem certeza de que deseja apagar os dados em cache de %s?'
L.ConfirmTransfer = 'Depositar quaisquer itens irá-lhes remover todas as modificações e torná-los-a introcáveis e não reembolsáveis.|n|nDeseja continuar?'
L.CannotPurchaseVault = 'Você não tem dinheiro suficiente para desbloquear a utilização do Cofre|n|n|cffff2020Custo: %s|r'
L.PurchaseVault = 'Gostaria de desbloquear o Cofre?|n|n|cffffd200Custo:|r %s'
L.ConfigurationMode = 'Você está no modo de configuração da ordenação pelo cliente.|n|nClique nos slots de itens para selecionar se devem ser bloqueados durante a ordenação.'
L.OutOfDate = 'A sua versão de |cffffd200%s|r pode estar desatualizada!|n%s reportou ter|n|cff82c5ff%s|r, atualize se for verdade.'
L.InvalidVersion = 'A sua cópia do |cffffd200%s|r está corrompida ou é ilegal.|nPor favor, faça download da versão oficial (gratuitamente).'
