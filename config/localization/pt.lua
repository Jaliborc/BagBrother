--[[
	Brasilian Portuguese Localization
--]]

local CONFIG = ...
local L = LibStub('AceLocale-3.0'):NewLocale(CONFIG, 'ptBR')
if not L then return end

-- general
L.GeneralOptionsDesc = 'Funcionalidades gerais do %s.'
L.Locked = 'Bloquear Posição das Janelas'
L.CountItems = 'Contar Stock na Descrição de Itens'
L.CountGuild = 'Incluir Bancos de Guildas'
L.CountCurrency = 'Contar Stock na Descrição de Moedas'
L.FlashFind = 'Localizar com Flash'
L.FlashFindTip = 'Se ativado, ao pressionar alt e clicar em um item, todos os espaços contendo esse mesmo item serão destacados.'
L.DisplayBlizzard = 'Mostrar Janelas da Blizzard para Sacos Desligados'
L.DisplayBlizzardTip = 'Se ativado, os paineis padrão da Blizzard seram exibido para bolsas do inventário ou banco escondidos.\n\n|cffff1919Necessário recarregar a IU.|r'
L.ConfirmGlobals = 'Tens a certeza que queres desligar a configuração individual desta personagem? Todas as diferenças individuais serão perdidas.'
L.CharacterSpecific = 'Configuração Individual por Personagem'

-- frame
L.FrameOptions = 'Janelas'
L.FrameOptionsDesc = 'Configuração específica das janela do %s'
L.Frame = 'Janela'
L.Enabled = 'Ativar'
L.EnabledTip = 'Se desativado, a UI padrão da Blizzard não será substituída por este quadro.\n\n|cffff1919Necessário recarregar a IU.|r'
L.ActPanel = 'Agir como Painel Padrão'
L.ActPanelTip = 'Se ativado, este painel se posicionará automaticamente como os painéis padrão, como o |cffffffffLivro de Feitiços|r ou o |cffffffffLocalizador de Masmorras|r, e não poderá ser movido.'

L.BagToggle = 'Lista de Sacos'
L.Broker = 'DataBroker'
L.Currency = 'Moedas'
L.ExclusiveReagent = 'Banco de Reagentes Separado'
L.Money = 'Dinheiro'
L.Sort = 'Botão de Ordenação'
L.Search = 'Botão da Pesquisa'
L.Options = 'Botão da Configração'
L.LeftTabs = 'Separadores à Esquerda'
L.LeftTabsTip = 'Se ativado, os separadores laterais serão exibidos no lado esquerdo do painel.'

L.Appearance = 'Aparência'
L.Layer = 'Camada'
L.BagBreak = 'Quebras entre Sacos'
L.ReverseBags = 'Inverter Sacos'
L.ReverseSlots = 'Inverter Itens'
L.Color = 'Cor de Fundo'
L.BorderColor = 'Cor do Bordo'
L.Strata = 'Camada'
L.Columns = 'Colunas'
L.Scale = 'Escala da Janela'
L.ItemScale = 'Escala dos Itens'
L.Spacing = 'Espaçamento'
L.Alpha = 'Transparência'

-- auto display
L.DisplayOptions = 'Exibição Automática'
L.DisplayOptionsDesc = 'Essas configurações permitem configurar quando o seu inventário abre ou fecha automaticamente devido a eventos do jogo.'
L.DisplayInventory = 'Exibir Inventário'
L.CloseInventory = 'Fechar Inventário'

L.Auctioneer = 'Na Casa de Leilões'
L.Banker = 'No Banco'
L.Combat = 'Entrando em Combate'
L.Crafting = 'Produção'
L.GuildBanker = 'No Banco da Guilda'
L.VoidStorageBanker = 'No Depósito do Caos'
L.MailInfo = 'No Correio'
L.MapFrame = 'Abrindo o Mapa Mundial'
L.Merchant = 'Falando com o Comerciante'
L.PlayerFrame = 'Abrindo as Informações do Personagem'
L.ScrappingMachine = 'Destruindo Equipamento'
L.Socketing = 'Inserindo Engastes'
L.TradePartner = 'Negociando'
L.Vehicle = 'Entrando em um Veículo'

-- colors
L.ColorOptions = 'Cores'
L.ColorOptionsDesc = 'Estas preferências permitem controlar a aparência dos espaços dos itens para melhor visiblidade.'

L.GlowQuality = 'Realçar por Qualidade'
L.GlowQuest = 'Realçar Itens de Missão'
L.GlowUnusable = 'Realçar Inutilizáveis'
L.GlowSets = 'Realçar Conjuntos'
L.GlowNew = 'Realçar Itens Novos'
L.GlowPoor = 'Realçar Baixa Qualidade'
L.GlowAlpha = 'Intensidade de Brilho'

L.EmptySlots = 'Mostrar Fundo em Espaços Vazios'
L.ColorSlots = 'Colorir Fundos por Tipo de Saco'
L.NormalColor = 'Espaços Normais'
L.LeatherColor = 'Bolsas de Couraria'
L.InscribeColor = 'Bolsas de Escrivania'
L.HerbColor = 'Bolsas de Plantas'
L.EnchantColor = 'Bolsas de Encantamento'
L.EngineerColor = 'Mochilas de Engenharia'
L.GemColor = 'Bolsas de Gemas'
L.MineColor = 'Bolsas de Mineração'
L.TackleColor = 'Caixas de Pesca'
L.FridgeColor = 'Bolsas de Cozinhar'
L.ReagentColor = 'Banco de Reagentes'
