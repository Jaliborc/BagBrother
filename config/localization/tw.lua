--[[
  Chinese Traditional Localization
--]]

local CONFIG = ...
local L = LibStub('AceLocale-3.0'):NewLocale(CONFIG, 'zhTW')
if not L then return end

-- general
L.GeneralOptionsDescription = '這些是一般功能，可以根據您的喜好進行切換。'

L.Locked = '鎖定框架'
L.CountItems = '物品統計提示'
L.CountGuild = '包含公會銀行'
L.CountCurrency = '包含通貨'
L.FlashFind = '閃爍尋找'
L.FlashFindTip = '如果啟用，按住Alt鍵並點擊物品將在所有框架中閃爍具有相同物品的所有欄位。'
L.DisplayBlizzard = '使用暴雪內建框架顯示隱藏的背包'
L.DisplayBlizzardTip = '如果啟用，將使用暴雪內建框架來顯示隱藏的背包或銀行欄位。\n\n|cffff1919ESC->選項->控制，需取消勾選『合併背包』選項。|r\n\n|cffff1919需要重新載入UI。|r'
L.ConfirmGlobals = '您確定要取消此角色的角色專屬設定嗎？所有的角色專屬設定將被清除。'
L.CharacterSpecific = '角色專屬設定'

-- frame
L.FrameOptions = '框架設定'
L.FrameOptionsDescription = '這些是針對 %s 框架的特定設定。'

L.Frame = '框架'
L.Enabled = '啟用框架'
L.EnabledTip = '如果禁用，預設的暴雪UI將不會被替換為此框架。\n\n|cffff1919需要重新載入UI。|r'
L.ActPanel = '作為標準面板'
L.ActPanelTip = [[
如果啟用，此面板將自動定位
自身，就像|cffffffff法術書|r
或|cffffffff地城搜尋器|r一樣，並且無法移動。]]

L.BagToggle = '背包列表'
L.Broker = 'Databroker外掛'
L.Currency = '通貨'
L.ExclusiveReagent = '分離材料銀行'
L.Money = '金錢'
L.Sort = '排序按鈕'
L.Search = '切換搜尋'
L.Options = '設定按鈕'
L.Reagents = '材料按鈕'
L.LeftTabs = '左側的規則集'
L.LeftTabsTip = [[
如果啟用，側邊標籤將顯示在
面板的左側。]]

L.Appearance = '外觀'
L.Layer = '階層'
L.BagBreak = '根據背包顯示'
L.ByType = '根據類型'
L.ReverseBags = '反轉背包順序'
L.ReverseSlots = '反轉欄位順序'

L.Color = '背景顏色'
L.BorderColor = '邊框顏色'

L.Strata = '框架層級'
L.Skin = '樣式'
L.Columns = '列'
L.Scale = '縮放'
L.ItemScale = '物品縮放'
L.Spacing = '間距'
L.Alpha = '透明度'

-- auto display
L.DisplayOptions = '自動開關'
L.DisplayOptionsDescription = '這些設置允許您配置當您的背包由於遊戲事件而自動打開或關閉的情況。'

L.DisplayInventory = '自動打開背包'
L.CloseInventory = '自動關閉背包'

L.Auctioneer = '訪問拍賣場'
L.Banker = '訪問銀行'
L.Combat = '進入戰鬥'
L.Crafting = '製造'
L.GuildBanker = '訪問公會銀行'
L.VoidStorageBanker = '訪問虛空銀行'
L.MailInfo = '檢查信箱'
L.MapFrame = '打開世界地圖'
L.Merchant = '離開商人'
L.PlayerFrame = '開啟角色資訊'
L.ScrappingMachine = '銷毀裝備'
L.Socketing = '鑲崁寶石'
L.TradePartner = '交易物品'
L.Vehicle = '進入載具'

-- slots
L.SlotOptions = '欄位設定'
L.SlotOptionsDescription = '這些設置允許您更改在 %s 框架上呈現物品欄位的方式，使其更容易識別。'

L.GlowQuality = '根據品質高亮物品'
L.GlowQuest = '高亮任務物品'
L.GlowUnusable = '高亮無法使用的物品'
L.GlowSets = '高亮裝備管理員設定物品'
L.GlowNew = '高亮新物品'
L.GlowPoor = '標記垃圾物品'
L.GlowAlpha = '高亮亮度'

L.EmptySlots = '在空的欄位顯示背景顏色'
L.SlotBackground = '欄位背景樣式'
L.ColorSlots = '根據背包類型高亮空的欄位'
L.NormalColor = '一般背包欄位顏色'
L.KeyColor = '鑰匙顏色'
L.QuiverColor = '箭袋顏色'
L.SoulColor = '靈魂碎片包顏色'
L.ReagentColor = '材料銀行顏色'
L.LeatherColor = '製皮包欄位顏色'
L.InscribeColor = '銘文包欄位顏色'
L.HerbColor = '草藥包欄位顏色'
L.EnchantColor = '附魔包欄位顏色'
L.EngineerColor = '工程箱欄位顏色'
L.GemColor = '寶石包顏色'
L.MineColor = '礦石包顏色'
L.TackleColor = '釣餌箱顏色'
L.FridgeColor = '烹飪包顏色'

-- rulesets
L.RuleOptions = '物品規則集'
L.RuleOptionsDescription = '這些設置允許您選擇顯示哪些物品規則集以及它們的順序。'

-- info
L.Help = HELP_LABEL
L.HelpDescription = '在這裡，我們提供對最常見問題的回答。如果這兩者都不能解決您的問題，您可以考慮在 Discord 上的 %s 使用者社群尋求幫助。'
L.Patrons = '贊助者'
L.PatronsDescription = '%s是通過贊助來提供免費使用和更新的。衷心感謝在 Patreon 和 Paypal 上支持開發的所有支持者。您也可以在 |cFFF96854patreon.com/jaliborc|r 成為贊助者。'
L.AskCommunity = '向社群尋求幫助'
L.JoinUs = '加入我們'

L.FAQ = {
  '如何查看銀行、公會或其他離線角色？',
  '點擊您背包左上角的"離線瀏覽"按鈕。它看起來像是您目前遊玩角色的頭像。',

  '如何讓插件忘記已刪除/重新命名的角色？',
  '點擊您背包左上角的"離線瀏覽"按鈕。每個角色名稱旁邊都會有一個紅色的刪除圖示。點擊您要刪除的角色。',

  '出現問題了！物品等級沒有顯示在欄位上。',
  '插件本身不會顯示物品等級。您可能正在使用第三方插件，如|cffffd200Bagnon ItemLevel|r或|cffffd200Bagnon ItemInfo|r。請嘗試更新您使用的插件，最常見的原因是插件已過時。|n|n請注意，任何與插件相關的問題應該向該插件的作者報告，而不是 Jaliborc。',

  '我的一些背包沒有顯示。',
  '您可能意外地隱藏了它。點擊框架左上角的"背包欄位"按鈕即可查看您的背包。然後，您可以點擊任何一個背包以切換它們的可見性。',

  '如何切換插件的銀行、虛空倉庫等？',
  '前往插件 -> 框架設定。您需要找到面板頂部的兩個選項。選擇您想要切換的"框架"，然後點擊"啟用框架"。'
}