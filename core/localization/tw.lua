--[[
	Chinese Traditional Localization
--]]

local ADDON = ...
local L = LibStub('AceLocale-3.0'):NewLocale(ADDON, 'zhTW')
if not L then return end

--keybindings
L.OpenBags = '打開背包'
L.OpenBank = '打開銀行'
L.OpenGuild = '打開公會銀行'
L.OpenVault = '打開虛空倉庫'

--terminal
L.Commands = '指令列表'
L.CmdShowInventory = '切換顯示背包'
L.CmdShowBank = '切換顯示銀行'
L.CmdShowGuild = '切換顯示公會銀行'
L.CmdShowVault = '切換顯示虛空倉庫'
L.CmdShowVersion = '顯示目前版本'
L.CmdShowOptions = '開啟設定選單'
L.SkinError = '套用外觀時發生錯誤。'
L.UpgradeError = '升級設定時發生問題。如遇問題，請嘗試重設設定。'

--titles
L.TitleBags = '%s的背包'
L.TitleBank = '%s的銀行'
L.TitleVault = '%s的虛空倉庫'
L.NormalBags = '普通背包'
L.TradeBags = '交易背包'

--actions
L.Bags = '背包欄位'
L.Drag = '拖曳'
L.BrowseItems = '查看其他'
L.HideBag = '點擊隱藏這個背包'
L.ShowBag = '點擊顯示這個背包'
L.GuildFunds = '公會資金'
L.NumAllowed = '%s允許'
L.NumWithdraw = '%d提領'
L.NumDeposit = '%d存入'
L.NumRemaining = '%d餘的'
L.WarbandMoney = '戰團金錢'
L.OfflineViewing = '離線瀏覽'
L.Others = '其他'

--menus
L.Characters = '角色'
L.Guilds = '公會銀行'
L.Locations = '位置'
L.EnterDescription = '輸入描述：'
L.ServerSorting = '伺服器端排序'
L.ServerSortingTip = '是否讓遊戲伺服器對可用的項目進行排序'
L.CleanupOptions = '清理選項'
L.IncludeReagents = '包含材料'
L.LockItems = '鎖定物品欄位'

--dialogs
L.AskMafia = '詢問黑手黨'
L.ConfirmDelete = '您確定您要刪除%s的快取資料?'
L.ConfirmTransfer = '存放任何物品都將移除所有修改，使它們無法交易和無法退還。|n|n您是否要繼續？'
L.CannotPurchaseVault = '您沒有足夠的金錢解鎖虛空倉庫服務|n|n|cffff2020花費：%s|r'
L.PurchaseVault = '您是否想解鎖虛空倉庫？|n|n|cffffd200花費：|r %s'
L.ConfigurationMode = '您現在處於客戶端排序配置模式。|n|n點擊物品欄位以切換它們在排序時是否應該被鎖定。'
L.OutOfDate = '您的 |cffffd200%s|r 版本可能已過時！|n%s 報告出現|n|cff82c5ff%s|r，如果是真的，請更新。'
L.InvalidVersion = '您的|cffffd200%s|r 副本已損壞或非法。|n請免費下載官方版本。'
