-- Gas Stations
local gasStation = 
{
	{ -1349.4902, 2688.6738, 50.0625, "to El Quebrados, Tierra Robada" },
	{ -1487.5654, 1874.0156, 32.6328, "above Freeway 17, Tierra Robada" },
    { 647.8945, 1696.1152, 6.9921, "near Freeway 9, Bone County" },
	{ 77.6142, 1223.0703, 18.8259, "to Shelburne Rd., Fort Carson" },
	{ 1944.4199, -1772.2841, 13.3905, "to Idlewood Gas Station, Los Santos"},
	{ 984.5029, -898.5253, 42.4193, "to Vinewood Gas Station, Los Santos"},
	{ 2108.4453, 938.3623, 10.8203, "to Tortola Bay, Las Venturas"},
	{ -2031.4248, 135.7529, 28.8359, "to St. Francis Blvd., San Fierro" },
	{ -1695.7763, 395.4912, 7.1796, "to Easter Basin, San Fierro"}
}

local stationMarker = nil

--------- [ Tanker Job ] ---------
function startTankerJob( )
	createDepotMarker( )
end
addEvent("startTankerJob", true)
addEventHandler("startTankerJob", localPlayer, startTankerJob)

function endTankerJob( )
	removeTankerMarker( )
end
addEvent("endTankerJob", true)
addEventHandler("endTankerJob", localPlayer, endTankerJob)

-- Refinery
function createDepotMarker( )
	depotMarker = createMarker( 276.3710, 1413.0576, 10.4359, "checkpoint", 2, 0, 255, 0, 200 )
	depotBlip = createBlip( 276.3710, 1413.0576, 10.4359, 0, 2, 0, 255, 0, 255, 0, 99999.0 )
end

-- Dropoff
local station = nil
function createTankerMarker( )
	
	station = math.random( 1, 9 )
	local x, y, z, place = unpack( gasStation[station] )
	
	stationMarker = createMarker( x, y, z, "checkpoint", 2, 255, 255, 0, 200)
	stationBlip = createBlip( x, y, z, 0, 2, 255, 255, 0, 255, 0, 99999.0 )
	
	outputChatBox("You need to transport this oil ".. place ..".", 0, 255, 0)
end

function removeTankerMarker( )
	if ( isElement( stationMarker ) ) then
		
		destroyElement( stationMarker )
		destroyElement( stationBlip )
	end
	
	if ( isElement( depotMarker ) ) then
		destroyElement( depotMarker )
		destroyElement( depotBlip )
	end
end	

function restartTankerJob( )
	if ( isElement( stationMarker ) ) then
		
		destroyElement( stationMarker )
		destroyElement( stationBlip )
	end
	
	createDepotMarker( )
end

local unloadTimer = nil	
local loadTimer = nil
function onStationHit( hitElement, matchingDimension )
	if ( isPedInVehicle( localPlayer ) ) then
		
		local vehicle = getPedOccupiedVehicle( localPlayer )
		if ( hitElement == localPlayer and getVehicleName( vehicle ) == "Tanker" ) then
			
			if ( source == stationMarker ) then
			
				outputChatBox("Please wait here while the oil is unloaded.", 212, 156, 49)
				
				unloadTimer = 
				setTimer(
					function ( )
						
						outputChatBox("You can now go back to the Refinery to get another drop off location.", 0, 255, 0) 
						
						restartTankerJob( )
						
						unloadTimer = nil
						
						local x, y, z = unpack( gasStation[station] )
						local money = math.floor( ( getDistanceBetweenPoints3D( 276.3710, 1413.0576, 10.4359, x, y, z ) )/10 )
						
						payClientDriver( money )
						outputChatBox("You earned $".. tostring( money ) .." by delivering this oil.", 212, 156, 49)
						
					end, 5000, 1
				)
			elseif ( source == depotMarker ) then
			
				outputChatBox("Please wait here while the oil is loaded in your Tanker.", 212, 156, 49)
				
				loadTimer = 
				setTimer(
					function ( )
						
						loadTimer = nil
						
						destroyElement( depotMarker )
						destroyElement( depotBlip )
			
						createTankerMarker( )
						
					end, 5000, 1
				)
			end	
		end
	end
end
addEventHandler("onClientMarkerHit", root, onStationHit)

function onStationLeave( leaveElement, matchingDimension )
	if ( isPedInVehicle( localPlayer ) ) then
		
		local vehicle = getPedOccupiedVehicle( localPlayer )
		if ( leaveElement == localPlayer and getVehicleName( vehicle ) == "Tanker" ) then
			
			if ( source == stationMarker ) then
				
				if ( isElement( stationMarker ) ) then
					
					if isTimer( unloadTimer ) then
						killTimer( unloadTimer )
					end	
					
					outputChatBox("You need to wait there till the oil is unloaded.", 255, 0, 0)
				end
			elseif ( source == depotMarker ) then
				
				if ( isElement( depotMarker ) ) then
					
					if isTimer( loadTimer ) then
						killTimer( loadTimer )
					end	
					
					outputChatBox("You need to wait there till the oil is loaded to your tanker.", 255, 0, 0)
				end
			end	
		end
	end
end
addEventHandler("onClientMarkerLeave", root, onStationLeave)

function payClientDriver( amount )
	triggerServerEvent("payTankerDriver", localPlayer, amount)
end	