if not WoWUnit then
	return
end

local Tests = WoWUnit('BagBrother')
local AreEqual, Replace = WoWUnit.AreEqual, WoWUnit.Replace

function Tests:BasicItem()
	local link = '|cffa335ee|Hitem:3246:0:0:0:0:0:0:0:0:0:0|h[Big Bunny]|h|r'

	AreEqual('3246', BagBrother:ParseItem(link, 1))
	AreEqual('3246;2', BagBrother:ParseItem(link, 2))
end

function Tests:ComplexItem()
	local link = '|cffa335ee|Hitem:3246:0:5:3:0:0:0:0:0:0:0|h[Scary Sword]|h|r'
	local expected = '3246:0:5:3:0:0:0:0:0:0:0'
	
	AreEqual(expected, BagBrother:ParseItem(link, 1))
end

function Tests:CagedPet()
	local link = '|cffa335ee|Hbattlepet:236:1:2:157:10:10:0x000000000000|h[Mountain Rat]|h|r'
	local expected = '236:1:2:157:10:10:0'

	AreEqual(expected, BagBrother:ParseItem(link, 1))
end

function Tests:NoItem()
	AreEqual(nil, BagBrother:ParseItem(nil, nil))
end