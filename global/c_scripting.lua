function toggleDevelopmentMode( ) 
	if ( c_isPlayerScripter( localPlayer ) ) then
		if ( not getDevelopmentMode( ) ) then
			setDevelopmentMode( true ) 
		else
			setDevelopmentMode( false )
		end	
	end	
end
addCommandHandler("dmode", toggleDevelopmentMode)

local screenX, screenY = guiGetScreenSize( )
local isEventHandled = false

local fps = 0
local realFps = 0
function showFps( )
	local text = "FPS: ".. realFps
	local r, g, b = 255, 255, 255
	
	if ( realFps <= 15 ) then
		r, g, b = 255, 0, 0
	elseif ( realFps > 15 and realFps <= 30 ) then
		r, g, b = 255, 255, 0
	elseif ( realFps > 30 ) then
		r, g, b = 0, 255, 0
	end	
	
	dxDrawText(text, ( screenX - screenX ) + 2, screenY - 28, screenX, screenY, tocolor(r, g, b, 200), 1.7, "arial")
end

function calculateFPS( )
	fps = fps + 1
end
addEventHandler("onClientRender", root, calculateFPS)
	
setTimer(
	function( )
		realFps = fps
		fps = 0
	end, 1000, 0
)	

function toggleClientFps( )
	if ( isEventHandled ) then
		removeEventHandler("onClientRender", root, showFps)
		isEventHandled = false
	else
		addEventHandler("onClientRender", root, showFps)
		isEventHandled = true
	end
end
addCommandHandler("fps", toggleClientFps, false, false)