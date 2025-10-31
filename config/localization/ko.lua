--[[
	Config Localization: Korean
--]]

local CONFIG = ...
local L = LibStub('AceLocale-3.0'):NewLocale(CONFIG, 'koKR')
if not L then return end
local NEW = BATTLENET_FONT_COLOR:WrapTextInColorCode(' ' .. NEW_CAPS)

-- import
L.InstalledFilters = '설치된 필터'
L.CustomFilters = '사용자 필터'
L.NewFilter = '새 필터'
L.NewSearch = '새 검색'
L.NewMacro = '새 매크로'
L.Import = '가져오기'
L.SharePopup = '이 데이터를 복사하여 공유하세요:'
L.ImportPopup = '가져올 데이터를 붙여넣으세요:|n|cnERROR_COLOR:(경고 - 신뢰할 수 있는 출처의 필터만 가져오세요)|r'

-- general options
L.GeneralOptionsDesc = '환경 설정에 따라 설정을 전환 할 수 있는 일반적인 기능입니다.'

L.Locked = '창 위치 잠금'
L.CountItems = '아이템 갯수를 툴팁에 표시'
L.CountGuild = '길드 금고 포함'
L.FlashFind = '빠른 찾기 사용'
L.DisplayBlizzard = '숨은 가방 대비책'
L.DisplayBlizzardTip = '만약 활성화하면 숨긴 가방 또는 은행 저장소에 대해 기본 블리자드 UI 가방 창이 표시됩니다.\n\n|cffff1919UI 리로드가 필요합니다.|r'
L.ConfirmGlobals = '이 캐릭터에 대한 개별 설정을 비활성화 하시겠습니까? 모든 개별 설정을 잃게됩니다.'
L.CharacterSpecific = '캐릭터 개별 설정'

-- frame options
L.FrameOptions = '창 설정'
L.FrameOptionsDesc = '애드온 창에 특화된 설정'

L.Frame = '창'
L.Enabled = '애드온 사용'
L.CharacterSpecific = '캐릭터 개별 설정'
L.ActPanel = '표준 패널로 작동'
L.ActPanelTip = [[
활성화되면 이 패널은 |cffffffff마법책|r이나
|cffffffff던젼 찾기|r와 같은 표준 패널과 같이
자동으로 배치되며 움직일 수 없습니다.]]

L.BagToggle = '가방 표시'
L.Broker = 'Databroker 플러그인 표시'
L.Sort = '정리 버튼 표시'
L.Search = '검색 버튼 표시'
L.Options = '설정 버튼 표시'
L.ExclusiveReagent = '재료 은행 별도 표시'
L.LeftTabs = '좌측에 규칙 표시'
L.LeftTabsTip = [[
활성화되면 측면의 탭이
패널의 좌측에 표시됩니다.]]

L.Appearance = '모양'
L.Layer = '레이어'
L.BagBreak = '가방 별로 구분하여 표시' .. NEW
L.ReverseBags = '가방 순서 반대로'
L.ReverseSlots = '칸 순서 반대로'

L.Color = '배경 색상'
L.BorderColor = '테두리 색상'

L.Strata = '프레임 레이어'
L.Columns = '칸 수'
L.Scale = '크기 비율'
L.ItemScale = '아이템 크기 비율'
L.Spacing = '간격'
L.Alpha = '투명도'

-- auto display
L.DisplayOptions = '자동 표시'
L.DisplayOptionsDesc = '이 설정은 게임 이벤트에 따라 가방을 자동으로 열거나 닫게 해줍니다.'
L.DisplayInventory = '가방 표시'
L.CloseInventory = '가방 닫기'

L.Banker = '은행 창 열 때 가방 열기'
L.GuildBanker = '길드 은행 열 때 가방 열기'
L.Auctioneer = '경매 창 열 때 가방 열기'
L.MailInfo = '우편함 열 때 가방 열기'
L.TradePartner = '거래 시 가방 열기'
L.ScrappingMachine = '장비 폐기시 가방 열기'
L.Socketing = '보석 장착시 가방 열기'
L.Crafting = '제작 시 가방 열기'
L.PlayerFrame = '캐릭터 창 열 때 가방 열기'
L.Merchant = '상인을 떠날 때 가방 닫기'

L.Combat = '전투 시 가방 닫기'
L.Vehicle = '차량 탑승 시 가방 닫기'
L.MapFrame = '지도를 열 때 가방 닫기'

-- colors
L.ColorOptions = '색상 설정'
L.ColorOptionsDesc = '이 설정은 아이템의 변화 상황을 쉽게 구분할 수 있도록 표시합니다.'

L.GlowQuality = '품질에 따라 아이템 강조'
L.GlowQuest = '퀘스트 아이템 강조'
L.GlowUnusable = '사용할 수 없는 아이템 강조'
L.GlowSets = '장비 관리 구성 아이템 강조'
L.GlowNew = '새로 획득한 아이템 강조'
L.GlowPoor = '잡템 표식 사용'
L.GlowAlpha = '강조 색상 밝기'

L.EmptySlots = '빈 칸 배경 표시'
L.ColorSlots = '가방 종류에 따라 빈 칸 색상 표시'
L.NormalColor = '일반 칸 색상'
L.KeyColor = '열쇠 칸 색상'
L.QuiverColor = '화살통/탄환주머니 색상'
L.SoulColor = '영혼 가방 색상'
L.ReagentColor = '재료 은행 칸 색상'
L.LeatherColor = '가죽세공 가방 칸 색상'
L.InscribeColor = '주문각인 가방 칸 색상'
L.HerbColor = '약초 가방 칸 색상'
L.EnchantColor = '마법부여 가방 칸 색상'
L.EngineerColor = '기계공학 가방 칸 색상'
L.GemColor = '보석 가방 칸 색상'
L.MineColor = '채광 자루 칸 색상'
L.TackleColor = '낚시상자 칸 색상'
L.FridgeColor = '요리 칸 색상'

-- info
L.HelpDescription = '여기에서는 가장 자주 묻는 질문에 대한 답변을 제공합니다. 해결되지 않으면 Discord의 %s 사용자 커뮤니티에 도움을 요청해 보세요.'
L.Patrons = '후원자'
L.PatronsDescription = '%s는 무료로 배포되며, 후원을 통해 유지됩니다. 개발을 지속할 수 있게 도와주신 Patreon과 Paypal 후원자 여러분께 진심으로 감사드립니다. 당신도 |cFFF96854patreon.com/jaliborc|r에서 후원자가 될 수 있습니다.'
L.AskCommunity = '커뮤니티에 문의'
L.JoinUs = '함께하기'

L.FAQ = {
  '전쟁단 은행에 아이템을 직접 예치하려면 어떻게 하나요?',
  '아이템 칸을 Shift + 오른쪽 클릭하면 일반 가방 대신 전쟁단 가방에 저장됩니다.',

  '은행, 길드 또는 다른 캐릭터를 오프라인 상태에서 보려면?',
  '인벤토리 왼쪽 상단의 "오프라인 보기" 버튼을 클릭하세요. 현재 플레이 중인 캐릭터의 초상화처럼 보입니다.',

  '삭제되었거나 이름이 변경된 캐릭터를 ADDON이 잊게 하려면?',
  '"오프라인 보기" 버튼을 클릭하세요. 각 캐릭터 이름 옆에 빨간색 X 버튼이 있으며, 해당 캐릭터를 삭제하려면 그 버튼을 클릭하세요.',

  '문제가 있어요! 아이템 레벨이 표시되지 않습니다.',
  'ADDON은 기본적으로 아이템 레벨을 표시하지 않습니다. |cffffd200Bagnon ItemLevel|r 또는 |cffffd200Bagnon ItemInfo|r 같은 외부 애드온을 사용해야 합니다. 사용하는 애드온을 업데이트해 보세요 — 대부분의 문제는 구버전 때문입니다.|n|n플러그인 문제는 Jaliborc가 아닌 플러그인 제작자에게 보고해야 합니다.',

  '가방 중 일부가 보이지 않습니다.',
  '실수로 숨겼을 수 있습니다. 프레임 왼쪽 상단의 가방 버튼을 클릭하여 다시 표시하세요. 개별 가방을 클릭해 표시를 전환할 수 있습니다.',

  '은행, 공허 보관소 등에 대해 ADDON을 켜거나 끄려면?',
  'ADDON -> 프레임 설정으로 이동하세요. 패널 상단의 두 옵션에서 원하는 "프레임"을 선택하고 "프레임 활성화"를 클릭하세요.'
}