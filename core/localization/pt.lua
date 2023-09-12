--[[
	Portuguese Localization
--]]

local ADDON = ...
local L = LibStub('AceLocale-3.0'):NewLocale(ADDON, 'ptBR')
if not L then return end

--keybindings
L.ToggleBags = 'Abrir Mochila'
L.ToggleBank = 'Abrir Banco'
L.ToggleGuild = 'Abrir Banco da Guilda'
L.ToggleVault = 'Abrir Cofre'

--terminal
L.Commands = 'Commandos:'
L.CmdShowInventory = 'Abre a sua mochila'
L.CmdShowBank = 'Abre o seu banco'
L.CmdShowGuild = 'Abre o banco da sua guilda'
L.CmdShowVault = 'Abre o seu cofre'
L.CmdShowVersion = 'Mostra a versão atual'
L.CmdShowOptions = 'Abre o menu de configuração'
L.Updated = 'Atualizado para versão %s'

--frame titles
L.TitleBags = 'Mochila de %s'
L.TitleBank = 'Banco de %s'
L.TitleVault = 'Cofre de %s'

--dropdowns
L.TitleFrames = 'Quadros de %s'
L.SelectCharacter = 'Selecionar Personagem'
L.ConfirmDelete = 'Tem certeza de que deseja apagar os dados em cache de %s?'

--interactions
L.Click = 'Click'
L.Drag = '<Arraste>'
L.LeftClick = '<Clique Esquerdo>'
L.RightClick = '<Clique Direito>'
L.DoubleClick = '<Clique Duplo>'
L.ShiftClick = '<Shift+Clique>'

--tooltips
L.GuildFunds = 'Fundos da Guilda'
L.TipGoldOnRealm = '%s no Total'
L.NumWithdraw = '%d retiradas'
L.NumDeposit = '%d depósitos'
L.NumRemainingWithdrawals = '%d Retiradas Restantes'

--action tooltips
L.TipChangePlayer = '%s para ver os itens das suas personagens.'
L.TipCleanItems = '%s para limpar itens.'
L.TipConfigure = '%s para configurar.'
L.TipDepositReagents = '%s para depositar reagentes no banco.'
L.TipDeposit = '%s para depositar.'
L.TipWithdraw = '%s para retirar (%s restantes).'
L.TipFrameToggle = '%s para alternar outras janelas.'
L.TipHideBag = '%s para esconder o saco.'
L.TipHideBags = '%s para esconder os sacos.'
L.TipHideSearch = '%s para esconder o campo de pesquisa.'
L.TipMove = '%s para mover.'
L.TipPurchaseBag = '%s para comprar uma ranhura no banco.'
L.TipResetPlayer = '%s para voltar ao personagem atual.'
L.TipShowBag = '%s para mostrar o saco.'
L.TipShowBags = '%s para mostrar os sacos.'
L.TipShowBank = '%s para abrir o banco.'
L.TipShowInventory = '%s para abrir a mochila.'
L.TipShowOptions = '%s para abrir o menu de configuração.'
L.TipShowSearch = '%s para pesquisar.'

--item tooltips
L.TipCountEquip = 'Equipado: %d'
L.TipCountBags = 'Mochila: %d'
L.TipCountBank = 'Banco: %d'
L.TipCountVault = 'Cofre: %d'
L.TipCountGuild = 'Guilda: %d'

--dialogs
L.AskMafia = 'Perguntar à Máfia'
L.ConfirmTransfer = 'Depositando quaisquer itens irá remover todas as modificações e torná-los inegociáveis e não reembolsáveis.|n|nDeseja continuar?'
L.CannotPurchaseVault = 'Você não tem dinheiro suficiente para desbloquear o serviço de Cofre|n|n|cffff2020Custo: %s|r'
L.PurchaseVault = 'Gostaria de desbloquear o serviço de Cofre?|n|n|cffffd200Custo:|r %s'