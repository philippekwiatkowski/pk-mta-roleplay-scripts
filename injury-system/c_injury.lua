local screenX, screenY = guiGetScreenSize( )

--------- [ Death System ] ---------
local timeLeft = 10

function renderRespawnTimer( )
	local respawnText = "Respawning in ".. tostring(timeLeft) .." second(s)"
	
	local width, height = dxGetTextWidth(respawnText, 1, "bankgothic"), dxGetFontHeight(1, "bankgothic")
	local x = (screenX/2) - (width/2)
	local y = (screenY/2) - (height/2) 

	dxDrawText(respawnText, x, y, screenX, screenY, tocolor(255, 255, 255, 200), 1, "bankgothic")
end

addEventHandler("onClientPlayerWasted", root,
	function( )
		if ( source == localPlayer ) then
			
			addEventHandler("onClientRender", root, renderRespawnTimer)
			setGameSpeed(0.5)
			exports['[ars]shader-system']:toggleBlackWhite()

			setTimer(
				function( ) 
					timeLeft = timeLeft - 1
					
					if (timeLeft == 0) then
						timeLeft = 10
						
						setGameSpeed(1)
						
						removeEventHandler("onClientRender", root, renderRespawnTimer)
						triggerServerEvent("respawnPlayer", localPlayer)
						exports['[ars]shader-system']:toggleBlackWhite()
					end
				end, 1000, 10
			)
		end	
	end	
)