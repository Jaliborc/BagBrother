--[[
  English Localization (default)
--]]

local CONFIG = ...
local NEW = BATTLENET_FONT_COLOR:WrapTextInColorCode(' ' .. NEW_CAPS)
local L = LibStub('AceLocale-3.0'):NewLocale(CONFIG, 'enUS', true, 'raw')

-- filters
L.InstalledFilters = 'Installed Filters'
L.CustomFilters = 'Custom Filters'
L.NewFilter = 'New Filter'
L.NewSearch = 'New Search'
L.NewMacro = 'New Macro'
L.Import = 'Import'
L.EnterSearch = 'Enter Search Query:'
L.SharePopup = 'Copy this data and share:'
L.ImportPopup = 'Paste data to import:|n|cnERROR_COLOR:(Warning - only import filters from sources you trust)|r'

-- automatic. do not translate unless necessary
L.Help = HELP_LABEL
L.Money = MONEY
L.NewFeature = NEW

-- general options
L.GeneralOptionsDescription = 'These are general features that can be toggled depending on your preferences.'

L.CountItems = 'Item Tooltip Counts'
L.CountGuild = 'Include Guild Banks'
L.CountCurrency = 'Currency Tooltip Counts'
L.ConfirmGlobals = 'Are you sure you want to disable specific settings for this character? All specific settings will be lost.'
L.CharacterSpecific = 'Character Specific Settings'
L.DisplayBlizzard = 'Fallback Hidden Bags'
L.DisplayBlizzardTip = 'If enabled, the default Blizzard UI bag panels will be displayed for hidden inventory or bank containers.\n\n|cffff1919May require UI reload.|r'
L.Locked = 'Lock Frames'
L.FlashFind = 'Flash Find'
L.FlashFindTip = 'If enabled, alt-clicking an item will flash all slots with that same item across frames.'
L.Tooltips = 'Tooltips'

-- frame options
L.FrameOptions = 'Frames'
L.FrameOptionsDescription = 'Individual configuration settings specific to each %s frame.'

L.Frame = 'Frame'
L.Enabled = 'Enable Frame'
L.EnabledTip = 'If disabled, the default Blizzard UI will not be replaced for this frame.\n\n|cffff1919May require UI reload.|r'
L.ActPanel = 'Act as Standard Panel'
L.ActPanelTip = [[
If enabled, this panel will automatically position
itself as the standard ones do, such as the |cffffffffSpellbook|r
or the |cffffffffDungeon Finder|r, and will not be movable.]]

L.BagToggle = 'Bags Toggle'
L.Broker = 'Databroker Carrousel'
L.Currency = 'Currency Tracker'
L.Deposit = 'Deposit Button'
L.Sidebar = 'Side Filters' .. NEW
L.Sort = 'Sort Button'
L.Search = 'Search Toggle'
L.Options = 'Options Button'
L.Tabs = 'Bottom Filters' .. NEW

L.Appearance = 'Appearance'
L.Layer = 'Layer'
L.BagBreak = 'Bag Break' .. NEW
L.BreakSpace = 'Break Spacing'  .. NEW
L.ByType = 'By Type'
L.ReverseBags = 'Reverse Bag Order'
L.ReverseSlots = 'Reverse Slot Order'

L.Color = 'Background Color'
L.BorderColor = 'Border Color'

L.Strata = 'Layer'
L.Skin = 'Skin' .. NEW
L.Columns = 'Columns'
L.Scale = 'Scale'
L.ItemScale = 'Item Scale'
L.Spacing = 'Spacing'
L.Alpha = 'Opacity'

-- slot options
L.SlotOptions = 'Item Slots'
L.SlotOptionsDescription = 'These settings allow you to change how item slots are presented on all %s frames for easier identification.'

L.GlowQuality = 'Color by Quality'
L.GlowQuest = 'Color Quest Items'
L.GlowUnusable = 'Color Unusable Items'
L.GlowSets = 'Color Equipment Sets'
L.GlowNew = 'Flash New Items'
L.GlowPoor = 'Mark Poor Items'
L.GlowAlpha = 'Glow Brightness'

L.EmptySlots = 'Display Background'
L.SlotBackground = 'Artwork'
L.ColorSlots = 'Color by Bag Type'
L.AccountColor = 'Warband Color'
L.NormalColor = 'Normal Color'
L.KeyColor = 'Keyring Color'
L.QuiverColor = 'Ammo Color'
L.SoulColor = 'Soul Bag Color'
L.ReagentColor = 'Reagent Color'
L.LeatherColor = 'Leatherworking Color'
L.InscribeColor = 'Inscription Color'
L.HerbColor = 'Herbalism Color'
L.EnchantColor = 'Enchanting Color'
L.EngineerColor = 'Engineering Color'
L.GemColor = 'Gem Color'
L.MineColor = 'Mining Color'
L.TackleColor = 'Tackle Box Color'
L.FridgeColor = 'Refrigerator Color'

-- auto display
L.DisplayOptions = 'Display Events'
L.DisplayOptionsDescription = 'These settings allow you to configure when your inventory automatically opens or closes due to game events.'

L.DisplayInventory = 'Display Inventory'
L.Auctioneer = 'At the Auction House'
L.Banker = 'At the Bank'
L.Crafting = 'Crafting'
L.GuildBanker = 'At the Guild Bank'
L.VoidStorageBanker = 'At Void Storage'
L.MailInfo = 'At a Mailbox'
L.Merchant = 'At a Merchant'
L.Character = 'Opening the Character Info'
L.TradePartner = 'Trading'
L.Transmogrifier = 'Modding Items'

L.CloseInventory = 'Close Inventory'
L.MapFrame = 'Opening the World Map'
L.Combat = 'Entering Combat'
L.Vehicle = 'Entering a Vehicle'

-- info
L.HelpDescription = 'Here we provide answers to the most frequently asked questions. If neither solve your problem, you might consider asking for help on the %s user community on discord.'
L.Patrons = 'Patrons'
L.PatronsDescription = '%s is distributed for free and supported trough donations. A massive thank you to all the supporters on Patreon and Paypal who keep development alive. You can become a patron too at |cFFF96854patreon.com/jaliborc|r.'
L.AskCommunity = 'Ask Community'
L.JoinUs = 'Join Us'

L.FAQ = {
  'How to deposit items directly into the warband bank?',
  'Shift right-click on the item slot and it will be placed in the warband bags instead of the normal ones.',

  'How to see the bank, guild or another character offline?',
  'Click on the "Offline Viewing" button in the top left of your inventory. It looks like a portrait of the character you are currently playing.',

  'How to make ADDON forget a deleted/renamed character?',
  'Click on the "Offline Viewing" button in the top left of your inventory. Each character name has a delete button next to it, which looks like a red cross. Click on the cross for the character you wish to delete.',

  'Something is wrong! Item levels aren\'t showing over the slots.',
  'ADDON does not natively display item levels. You must be using a third party plugin, such as |cffffd200Bagnon ItemLevel|r or |cffffd200Bagnon ItemInfo|r. Try to update the plugins you are using, most common cause is being out of date.|n|nPlease note that any issue with plugins should be reported to their authors, not with Jaliborc.',

  'Some of my bags are not appearing.',
  'You probably hid it accidentally. Click on the Bags button on the top left of the frame to see your bags. You can then click on any bag to toggle their visibility.',

  'How to toggle ADDON for Bank, VoidStorage, etc?',
  'Go to ADDON -> Frame Settings. You are looking for the two options at the very top of the panel. Choose the "Frame" you wish to toggle and then click "Enable Frame"'
}