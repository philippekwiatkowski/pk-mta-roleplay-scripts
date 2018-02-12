local screenX, screenY = guiGetScreenSize( )
	
function renderHUD( )	
		
	local m = string.format("%.2f", getPlayerMoney(getLocalPlayer( ))/100)
	local money = string.format("%07d.%02d", tostring(m), (m * 100) % 100)
		
	local draw = dxDrawText
		
	if ( screenY < 768 ) then
		screenY = screenY + 168
	end
	
	local x, y = 300, 641
	local offsetX = x + 2
	local offsetY = y + 2

	--draw("$".. tostring(money), screenX - x, screenY - y, screenX, screenY, tocolor(0, 0, 0, 200), 1.70, "pricedown")
	--draw("$".. tostring(money), screenX - x, screenY - y, screenX, screenY, tocolor(0, 0, 0, 200), 1.70, "pricedown")
	--draw("$".. tostring(money), screenX - offsetX, screenY - offsetY, screenX, screenY, tocolor(44, 91, 36, 250), 1.70, "pricedown")
	--draw("$".. tostring(money), screenX - offsetX, screenY - offsetY, screenX, screenY, tocolor(44, 91, 36, 250), 1.70, "pricedown")
end

addEvent("toggleMoney", true)
addEventHandler("toggleMoney", getLocalPlayer(), 
function( show )
	--
end)

-- ## Script Version
local version = nil
addEventHandler("onClientResourceStart", resourceRoot,
	function( )
		version = guiCreateLabel(0, 0, screenX, 15, "Arsenic Roleplay v1.0.0", false)
		
		guiSetSize(version, guiLabelGetTextExtent(version) + 5, 14, false)
		guiSetPosition(version, screenX - guiLabelGetTextExtent(version) - 5, screenY - 27, false )
		guiSetAlpha(version, 0.5)
	end
)	