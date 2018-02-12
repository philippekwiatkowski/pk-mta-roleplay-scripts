--------- [ Element Data returns ] ---------
local function getData( theElement, key )
	local key = tostring(key)
	if isElement(theElement) and (key) then
		
		return exports['[ars]anticheat-system']:c_callData( theElement, tostring(key) )
	else
		return false
	end
end	

--------- [ Fuel Meter ] ---------
local bikes = { ["Bike"] = true, ["BMX"] = true, ["Mountain Bike"] = true }

local screenX, screenY = guiGetScreenSize( )
local imageWidth, imageHeight = 117, 117

addEventHandler("onClientVehicleEnter", root,
	function ( thePlayer )
		if ( thePlayer == localPlayer ) then
		
			if ( not bikes[getVehicleName(source)] ) then
				
				showFuelmeter( )
			end	
		end
	end
)

addEventHandler("onClientVehicleStartExit", root,
	function ( thePlayer )
		if ( thePlayer == localPlayer ) then
			
			if ( not bikes[getVehicleName(source)] ) then
				
				hideFuelmeter( )
			end	
		end
	end
)

function getVehicleFuel( )
	if ( isPedInVehicle( localPlayer ) ) then
		
		local vehicle = getPedOccupiedVehicle( localPlayer )
		
		local fuel = tonumber( getData(vehicle, "fuel") )
		if ( fuel ~= false ) then
			
			return fuel
		end	
	end	
end

local needleOffsetX, needleOffsetY = 222, 17

local needleX = ( screenX - imageWidth - needleOffsetX )
local needleY = ( screenY - imageHeight - needleOffsetY )

local maxRot = 214
local minRot = 63

function drawFuelmeterNeedle( )
	if ( not isPedInVehicle( localPlayer ) ) then
      
        hideFuelmeter( )
    end
	
	local fuel = getVehicleFuel( )
	if ( fuel ~= nil ) then
		local rotation = ( fuel - 51 ) + 114
		
		if ( rotation < minRot ) then
			rotation = minRot
		end	
		
		dxDrawImage(needleX, needleY, imageWidth, imageHeight, "fuelmeter/fuelneedle.png", rotation, 11, -11, white, true)
	end	
end


local imageOffsetX, imageOffsetY = 210, 25
	
local discX = ( screenX - imageWidth - imageOffsetX )
local discY = ( screenY - imageHeight - imageOffsetY )

function showFuelmeter( )
	theDisc = guiCreateStaticImage( discX, discY, imageWidth, imageHeight, "fuelmeter/fueldisc.png", false )
	if ( theDisc ) then
		
		addEventHandler("onClientRender", root, drawFuelmeterNeedle)
	end	
end

function hideFuelmeter( )
	if ( theDisc ) then
		
		destroyElement( theDisc )
		removeEventHandler("onClientRender", root, drawFuelmeterNeedle)
	end
end	