--[[
	Portuguese Localization
--]]

local CONFIG = ...
local L = LibStub('AceLocale-3.0'):NewLocale(CONFIG, 'ptBR')
if not L then return end

-- general
L.GeneralOptionsDescription = 'Estas são características gerais que podem ser ativadas ou desativadas de acordo com suas preferências.'

L.Locked = 'Bloquear Posição das Janelas'
L.CountItems = 'Contar Stock na Descrição de Itens'
L.CountGuild = 'Incluir Bancos de Guildas'
L.CountCurrency = 'Contar Stock na Descrição de Moedas'
L.FlashFind = 'Pesquisa Rápida'
L.FlashFindTip = 'Se ativado, ao pressionar alt e clicar num item, todos os espaços contendo esse mesmo item serão destacados.'
L.DisplayBlizzard = 'Mostrar Janelas da Blizzard para Bolsas Desligadas'
L.DisplayBlizzardTip = 'Se ativado, os paineis padrão da Blizzard seram exibido para bolsas do inventário ou banco escondidos.\n\n|cffff1919Necessário recarregar a IU.|r'
L.ConfirmGlobals = 'Tens a certeza que queres desligar a configuração individual desta personagem? Todas as diferenças individuais serão perdidas.'
L.CharacterSpecific = 'Configuração Individual por Personagem'

-- frame
L.FrameOptions = 'Janelas'
L.FrameOptionsDescription = 'Estas são opções específicas para cada janela do %s.'

L.Frame = 'Janela'
L.Enabled = 'Ativar'
L.EnabledTip = 'Se desativado, as janelas padrão do Blizzard não serao substituídas por esta janela.\n\n|cffff1919Necessário recarregar a interface.|r'
L.ActPanel = 'Agir como Painel Padrão'
L.ActPanelTip = 'Se ativado, esta janela irá se posicionar automaticamente como os painéis padrão, como o |cffffffffLivro de Feitiços|r ou o |cffffffffLocalizador de Masmorras|r, e não poderá ser movido.'

L.BagToggle = 'Lista de Bolsas'
L.Broker = 'DataBroker'
L.Sort = 'Botão de Limpeza'
L.Search = 'Botão de Pesquisa'
L.Options = 'Botão de Configuração'
L.LeftTabs = 'Separadores à Esquerda'
L.LeftTabsTip = 'Se ativado, os separadores laterais serão exibidos no lado esquerdo da janela.'

L.Appearance = 'Aparência'
L.Layer = 'Camada'
L.BagBreak = 'Separação de Bolsas'
L.ByType = 'Por Tipo'
L.ReverseBags = 'Inverter Ordem das Bolsas'
L.ReverseSlots = 'Inverter Ordem dos Espaços'
L.Color = 'Cor de Fundo'
L.BorderColor = 'Cor da Borda'
L.Strata = 'Camada'
L.Skin = 'Tema'
L.Columns = 'Colunas'
L.Scale = 'Escala da Janela'
L.ItemScale = 'Escala dos Itens'
L.Spacing = 'Espaçamento'
L.Alpha = 'Transparência'

-- colors
L.SlotOptions = 'Espaços'
L.SlotOptionsDescription = 'Estas configurações permitem alterar como os espaços de itens são apresentados nas janelas do %s para facilitar a sua identificação.'

L.GlowQuality = 'Realçar Qualidade'
L.GlowQuest = 'Realçar Itens de Missão'
L.GlowUnusable = 'Realçar Inutilizáveis'
L.GlowSets = 'Realçar Conjuntos de Equipamentos'
L.GlowNew = 'Realçar Itens Novos'
L.GlowPoor = 'Realçar Baixa Qualidade'
L.GlowAlpha = 'Intensidade de Brilho'

L.EmptySlots = 'Exibir Fundo'
L.SlotBackground = 'Arte'
L.ColorSlots = 'Colorir por Tipo de Bolsa'
L.NormalColor = 'Bolsas Normais'
L.KeyColor = 'Chaves'
L.QuiverColor = 'Aljavas'
L.SoulColor = 'Bolsa de Almas'
L.ReagentColor = 'Bolsas de Reagentes'
L.LeatherColor = 'Bolsas de Couraria'
L.InscribeColor = 'Bolsas de Escrivania'
L.HerbColor = 'Bolsas de Herborismo'
L.EnchantColor = 'Bolsas de Encantamentos'
L.EngineerColor = 'Bolsas de Engenharia'
L.GemColor = 'Bolsas de Gemas'
L.MineColor = 'Bolsas de Mineração'
L.TackleColor = 'Caixas de Pesca'
L.FridgeColor = 'Refrigeradores'

-- auto display
L.DisplayOptions = 'Exibição Automática'
L.DisplayOptionsDesc = 'Essas opções permitem configurar quando a sua mochila se abre ou fecha automaticamente devido a eventos do jogo.'

L.DisplayInventory = 'Exibir Mochila'
L.CloseInventory = 'Fechar Mochila'

L.Auctioneer = 'Na Casa de Leilões'
L.Banker = 'No Banco'
L.Combat = 'Ao Entrar em Combate'
L.Crafting = 'Ao Fabricar'
L.GuildBanker = 'No Banco da Guilda'
L.VoidStorageBanker = 'No Cofre'
L.MailInfo = 'No Correio'
L.MapFrame = 'Ao Abrir o Mapa'
L.Merchant = 'Ao Falar com Comerciantes'
L.PlayerFrame = 'Ao Abrir Informações da Personagem'
L.ScrappingMachine = 'Ao Destruir Equipamento'
L.Socketing = 'Ao Inserir Engastes'
L.TradePartner = 'Ao Trocar com Jogadores'
L.Vehicle = 'Ao Entrar num Veículo'

-- info
L.HelpDescription = 'Aqui vai encontrar respostas para as perguntas mais frequentes. Se nenhuma resolver o seu problema, considere pedir ajuda na comunidade de utilizadores do %s no Discord.'
L.PatronsDescription = '%s é distribuído gratuitamente e suportado por doações. Um grande agradecimento a todos os fans no Patreon e Paypal que mantêm o desenvolvimento vivo. Também te podes tornar um patron visitando |cFFF96854patreon.com/jaliborc|r.'
L.AskCommunity = 'Pergunte à Comunidade'
L.JoinUs = 'Junta-te a Nós'

L.FAQ = {
'Como ver o banco, banco da guilda ou outro personagem offline?',
'Clique no botão "Visualização Offline," no canto superior esquerdo da janela. O botão parece-se com um retrato do personagem que está a jogar.',

'Como fazer com que o ADDON se esqueça de uma personagem excluída/renomeada?',
'Clique no botão "Visualização Offline" no canto superior esquerdo da janela. Cada nome de personagem terá uma cruz vermelha ao lado. Clique na cruz do personagem que deseja excluir.',

'Algo está de errado! Os níveis dos itens não estão a aparecer sobre os espaços.',
'O ADDON não exibe níveis de item nativamente. Você deve estar usando um plugin de terceiros, como |cffffd200Bagnon ItemLevel|r ou |cffffd200Bagnon ItemInfo|r. Tente atualizar os plugins que está usando, a causa mais comum é estar desatualizado.|n|nObserve que qualquer problema com plugins deve ser relatado aos seus autores, não ao Jaliborc.',

'Algumas das minhas bolsas não estão a aparecer.',
'Provavelmente escondeu-as acidentalmente. Clique no botão Bolsas no canto superior esquerdo da janela para ver suas bolsas. Depois, pode clicar em qualquer bolsa para alterar a sua visibilidade.',

'Como ligar/desligar o ADDON para Banco, Cofre, etc?',
'Vá para ADDON -> Janelas. Olhe para o topo do painel. Escolha a "Janela" que deseja alterar e depois clique em "Ativar"'
}
