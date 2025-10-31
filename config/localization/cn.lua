--[[
	Chinese Simplified Localization
		Credits: Diablohu, yleaf@cwdg, 狂飙@cwdg, 天下牧@萨格拉斯, ananhaid
--]]

local CONFIG = ...
local NEW = BATTLENET_FONT_COLOR:WrapTextInColorCode(' ' .. NEW_CAPS)
local L = LibStub('AceLocale-3.0'):NewLocale(CONFIG, 'zhCN')
if not L then return end

-- filters
L.InstalledFilters = '已安装的过滤器'
L.CustomFilters = '自定义过滤器'
L.NewFilter = '新建过滤器'
L.NewSearch = '新建搜索'
L.NewMacro = '新建宏'
L.Import = '导入'
L.SharePopup = '复制此数据并分享：'
L.ImportPopup = '粘贴要导入的数据：|n|cnERROR_COLOR:(警告 - 仅从可信来源导入过滤器)|r'

-- general options
L.GeneralOptionsDesc = '这些通用功能可以依据配置切换。'
L.Locked = '锁定框架'
L.CountItems = '提示物品数目'
L.CountGuild = '包含公会银行'
L.FlashFind = '闪烁搜索'
L.DisplayBlizzard = '显示暴雪框架隐藏背包'
L.DisplayBlizzardTip = '如果启用，隐藏背包或银行容器将显示默认暴雪用户界面背包面板。\n\n|cffff1919需要重载用户界面。|r'
L.ConfirmGlobals = '确定要禁用特定此角色的特定设置？所有特定设置将丢失。'
L.CharacterSpecific = '角色特定设置'

-- frame
L.FrameOptions = '框架设置'
L.FrameOptionsDesc = '此配置设置特定到一个%s框架。'
L.Frame = '框架'
L.Enabled = '启用框架'
L.EnabledTip = '如果禁用，默认暴雪用户界面不会替换此框架。\n\n|cffff1919需要重载用户界面。|r'
L.ActPanel = '作为标准面板'
L.ActPanelTip = [[
如启用，此面板将自动定位
像标准的一样，如同 |cffffffff法术书|r
或 |cffffffff团队查找器|r，并不能被移动。]]

L.BagToggle = '背包切换'
L.Broker = 'Databroker 插件'
L.Currency = '货币'
L.ExclusiveReagent = '分离材料银行'
L.Sort = '整理按钮'
L.Search = '切换搜索'
L.Options = '选项按钮'
L.LeftTabs = '左侧规则'
L.LeftTabsTip = [[
如启用，边框标签将被
显示到左侧面板。]]

L.Appearance = '外观'
L.Layer = '层级'
L.BagBreak = '背包分散'
L.ReverseBags = '反向背包排列'
L.ReverseSlots = '反向物品排列'

L.Color = '背景颜色'
L.BorderColor = '边框颜色'

L.Strata = '框架层级'
L.Columns = '列数'
L.Scale = '缩放'
L.ItemScale = '物品缩放'
L.Spacing = '间距'
L.Alpha = '透明度'

-- auto display
L.DisplayOptions = '自动显示'
L.DisplayOptionsDesc = '此设置允许配置游戏事件时自动打开或关闭背包。'
L.DisplayInventory = '打开背包'
L.CloseInventory = '关闭背包'

L.Auctioneer = '打开拍卖行时'
L.Banker = '打开银行时'
L.Combat = '进入战斗时'
L.Crafting = '制作时'
L.GuildBanker = '打开公会银行时'
L.VoidStorageBanker = '打开虚空仓库时'
L.MailInfo = '打开邮箱时'
L.MapFrame = '打开世界地图时'
L.Merchant = '离开商人时'
L.PlayerFrame = '打开角色信息时'
L.ScrappingMachine = '摧毁装备时'
L.Socketing = '镶嵌物品时'
L.TradePartner = '交易时'
L.Vehicle = '进入载具时'

-- colors
L.ColorOptions = '颜色设置'
L.ColorOptionsDesc = '此设置允许更改物品在%s框架上的染色以便于识别。'

L.GlowQuality = '按物品品质染色'
L.GlowQuest = '任务物品染色'
L.GlowUnusable = '无用品染色'
L.GlowSets = '套装染色'
L.GlowNew = '新物品发光'
L.GlowPoor = '标记垃圾物品'
L.GlowAlpha = '发光亮度'

L.EmptySlots = '显示空格背景材质'
L.ColorSlots = '按背包类型染色'
L.NormalColor = '一般颜色'
L.KeyColor = '钥匙颜色'
L.QuiverColor = '箭袋颜色'
L.SoulColor = '灵魂袋颜色'
L.ReagentColor = '材料银行颜色'
L.LeatherColor = '制皮颜色'
L.InscribeColor = '铭文颜色'
L.HerbColor = '草药颜色'
L.EnchantColor = '附魔颜色'
L.EngineerColor = '工程颜色'
L.GemColor = '宝石颜色'
L.MineColor = '矿石颜色'
L.TackleColor = '工具箱颜色'
L.FridgeColor = '烹饪颜色'

-- info
L.HelpDescription = '这里提供了最常见问题的解答。如果仍无法解决你的问题，可以在 Discord 上的 %s 用户社区寻求帮助。'
L.Patrons = '赞助者'
L.PatronsDescription = '%s 免费发布并通过捐赠支持。非常感谢在 Patreon 和 Paypal 上支持开发的所有人。你也可以在 |cFFF96854patreon.com/jaliborc|r 成为赞助者。'
L.AskCommunity = '询问社区'
L.JoinUs = '加入我们'

L.FAQ = {
  '如何直接将物品存入战团银行？',
  '按住 Shift 并右键点击物品栏位，物品会被放入战团背包而不是普通背包。',

  '如何离线查看银行、公会或其他角色？',
  '点击物品栏左上角的“离线查看”按钮，看起来像你当前角色的头像。',

  '如何让 ADDON 忘记已删除或重命名的角色？',
  '点击左上角的“离线查看”按钮。每个角色名旁边都有一个红色的删除按钮，点击它即可删除对应角色。',

  '出现问题！物品等级未显示。',
  'ADDON 不会原生显示物品等级。你需要使用第三方插件，例如 |cffffd200Bagnon ItemLevel|r 或 |cffffd200Bagnon ItemInfo|r。请尝试更新插件，最常见的原因是版本过旧。|n|n请注意，插件问题应反馈给其作者，而非 Jaliborc。',

  '我的一些背包没有显示。',
  '你可能不小心隐藏了它们。点击界面左上角的背包按钮查看背包，然后点击任意背包以切换可见性。',

  '如何在银行、虚空仓库等处启用或禁用 ADDON？',
  '进入 ADDON -> 框体设置。在面板顶部选择要切换的“框体”，然后点击“启用框体”。'
}
