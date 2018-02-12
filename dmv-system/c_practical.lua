-- ## Route 
local route = 
{
	{ -2104.9492, 97.7109, 35.1640 },
	{ -2142.8544, 111.8330, 35.1718 },
	{ -2144.2929, 195.2031, 35.2112 },
	{ -2239.4980, 210.6318, 35.1718 },
	{ -2255.0703, 129.7880, 35.1718 },
	{ -2257.7128, 62.3876, 35.1718 },
	{ -2340.5253, 52.0244, 35.1640 },
	{ -2374.2724, -57.3955, 35.1718 },
	{ -2273.0273, -72.8085, 35.1640 },
	{ -2259.9853, -176.8134, 35.1718 },
	{ -2168.7792, -174.7744, 35.1718 },
	{ -2165.0292, -83.4941, 35.1718 },
	{ -2103.0009, -72.8906, 35.1718 },
	{ -2084.8740, 16.7861, 35.1718 },
	{ -2102.2060, 61.4492, 35.3203 }
}
-- ## Globals
local currMarker, nextMarker = nil, nil
local currBlip, nextBlip = nil, nil
local stage = 0

--------- [ Department of Motor Vehicles ] ---------
function startDrivingTest( )
	if (stage == 0) then
	
		stage = 1
		
		local currX, currY, currZ = unpack(route[stage])		
		local nextX, nextY, nextZ = unpack(route[stage+1])	
	
		currMarker = createMarker(currX, currY, currZ, "checkpoint", 2, 255, 255, 0, 200, localPlayer)
		currBlip = createBlip(currX, currY, currZ, 0, 2, 255, 194, 14, 255, 0, 99999.0, localPlayer )
	
		nextMarker = createMarker(nextX, nextY, nextZ, "checkpoint", 1.5, 0, 255, 0, 200, localPlayer)
		nextBlip = createBlip(nextX, nextY, nextZ, 0, 1, 0, 255, 0, 255, 0, 99999.0, localPlayer)	
	end	
end
addEvent("startDrivingTest", true)
addEventHandler("startDrivingTest", localPlayer, startDrivingTest)
	
function endDrivingTest( )
	if ( currMarker ) then
		destroyElement( currMarker )
		destroyElement( currBlip )
	end

	if ( nextMarker ) then
		destroyElement( nextMarker )
		destroyElement( nextBlip )
	end	
	
	-- ## Reset Globals
	currMarker, nextMarker = nil, nil
	currBlip, nextBlip = nil, nil
	stage = 0
end
addEvent("endDrivingTest", true)
addEventHandler("endDrivingTest", localPlayer, endDrivingTest)
	
function hitDrivingTestMarker ( hitPlayer, matchingDimension )
	if ( hitPlayer == localPlayer and isPedInVehicle( localPlayer ) ) then				
		if (getVehicleName(getPedOccupiedVehicle(localPlayer)) == "Previon") then 	
		
			if (source == currMarker) then	 
				
				stage = stage + 1		 	 
			
				playSoundFrontEnd(6)
				
				local currR, currG, currB = nil, nil, nil
				local nextR, nextG, nextB = nil, nil, nil
					
				if (stage == 14) then 
				
					currR, currG, currB = 255, 255, 0
					nextR, nextG, nextB = 255, 0, 0						
				elseif (stage == 15) then 
					
					destroyElement(currMarker)		
					destroyElement(currBlip)
					
					setMarkerSize(nextMarker, 2)							
					
					stage = stage + 1						
					return							
				else										
					currR, currG, currB = 255, 255, 0		
					nextR, nextG, nextB = 0, 255, 0
				end
				
				destroyElement(currMarker)					
				destroyElement(currBlip)
				
				currMarker, currBlip = nextMarker, nextBlip		
				
				setMarkerSize(currMarker, 2)					
				setMarkerColor(currMarker, currR, currG, currB)
				setBlipSize(currBlip, 2)
				setBlipColor(currBlip, currR, currG, currB, 255)
				
				local nextX, nextY, nextZ = unpack(route[stage+1])	
				nextMarker = createMarker(nextX, nextY, nextZ, "checkpoint", 1.5, nextR, nextG, nextB, 200, localPlayer)
				nextBlip = createBlip(nextX, nextY, nextZ, 0, 1, nextR, nextG, nextB, 255, 0, 99999.0, localPlayer)
				
			elseif (source == nextMarker and stage == 16) then 
				
				playSoundFrontEnd(13)
		
				destroyElement(nextMarker)		
				destroyElement(nextBlip)
				
				outputChatBox("You completed your Driving Test!", 0, 255, 0)
				
				triggerServerEvent("givePlayerDrivingLicense", localPlayer)
				
				-- ## Reset Globals
				currMarker, nextMarker = nil, nil
				currBlip, nextBlip = nil, nil
				stage = 0
			end
		end	
	end	
end
addEventHandler("onClientMarkerHit", root, hitDrivingTestMarker)	