local bikes = { ["Bike"] = true, ["BMX"] = true, ["Mountain Bike"] = true }

showSpeedo = true
enableScaling = true

offsetX = 10
offsetY = 10
imageWidth = 200
imageHeight = 200

function drawSpeedometerNeedle( ) 
    if ( not isPedInVehicle( localPlayer ) ) then
      
        hideSpeedometer( )
    end
   
	local speed = getVehicleSpeed( )
	
    dxDrawImage(x, y, globalImageWidth, globalImageHeight, "speedometer/needle.png", speed, 0, 0, white, true)
end

function showSpeedometer( )
	guiSetVisible( disc, true )
    addEventHandler("onClientRender", root, drawSpeedometerNeedle ) 
end

function hideSpeedometer()
    guiSetVisible( disc, false )
	removeEventHandler("onClientRender", root, drawSpeedometerNeedle ) 
end

function getVehicleSpeed( )
    if ( isPedInVehicle(localPlayer) ) then
        local veloX, veloY, veloZ = getElementVelocity( getPedOccupiedVehicle(localPlayer) )
		local realSpeed = (veloX^2 + veloY^2 + veloZ^2)^(0.5) 
		
		return realSpeed * 180
    end
	
    return 0
end


addEventHandler("onClientVehicleEnter", root,
	function ( thePlayer )
		if ( thePlayer == localPlayer ) then
		
			if ( not bikes[getVehicleName(source)] ) then
				showSpeedometer( )
			end	
		end
	end
)

addEventHandler("onClientVehicleStartExit", root,
	function ( thePlayer )
		if ( thePlayer == localPlayer ) then
			
			if ( not bikes[getVehicleName(source)] ) then
				hideSpeedometer( )
			end	
		end
	end
)

function showUI()
    if isElement( disc ) then
        destroyElement(disc)
    end
	
    screenX, screenY = guiGetScreenSize( )
   
    local scale
    if enableScaling then
        scale = ( screenX / 1152 + screenY / 864 ) / 2
    else
        scale = 1
    end
	
    globalOffsetY = math.floor(offsetY * scale)
    globalOffsetX = math.floor(offsetX * scale)
    globalImageWidth = math.floor(imageWidth * scale)
    globalImageHeight = math.floor(imageHeight * scale)
    
    disc = guiCreateStaticImage(screenX - globalImageWidth - globalOffsetX, screenY - globalImageHeight - ( globalOffsetY + 15 ), globalImageWidth, globalImageHeight, "speedometer/disc.png", false)
    x, y = guiGetPosition( disc, false )
end

addEventHandler("onClientResourceStart", resourceRoot,
	function( )
        showUI()
		
        guiSetVisible( disc, false )
       
	    setTimer(
		   function( )
				local width, height = guiGetScreenSize()
				if (width ~= screenX) or (height ~= screenY) then
					
					outputDebugString("trig")
					showUI()
				end
			end, 500, 0
		)
		
		if ( isPedInVehicle(localPlayer) ) then
			showSpeedometer( )
		end
	end
)

addCommandHandler("togspeedo", 
	function( )
		if ( isPedInVehicle( localPlayer ) ) then
			
			if ( showSpeedo ) then
				guiSetVisible( disc, false )
				removeEventHandler("onClientRender", root, drawSpeedometerNeedle)
				
				showSpeedo = false
			else
				guiSetVisible( disc, true )
				addEventHandler("onClientRender", root, drawSpeedometerNeedle)
				
				showSpeedo = true
			end
		end	
	end
)	