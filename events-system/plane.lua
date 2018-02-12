-- ELEMENT DATA
local function getData( theElement, key )
	local key = tostring(key)
	if isElement(theElement) and (key) then
		
		return exports['[ars]anticheat-system']:callData( theElement, tostring(key) )
	else
		return false
	end
end

-- EVENT ( 5/3/2012 )
local planeEntrance = nil
local planeExit = nil

function createPlaneEntrance( )
	planeEntrance = createMarker( 1301.1992, 1453.4648, 9.8203, "cylinder", 2, 0, 255, 0, 100 )
	if ( planeEntrance ) then
		
		local thePlane = getEventPlane( )
		if ( thePlane == nil ) then
			
			outputDebugString("The Event Plane was deleted!")
			return
		else	
			attachElements( planeEntrance, thePlane, -2, 3.45, -1.5, 0, 0, 0 )
		end
	end	
end

function createPlaneExit( )
	planeExit = createMarker( 4.0898, 23.0221, 1198.7011, "cylinder", 2, 0, 255, 0, 100 )
	if ( planeExit ) then
		
		setElementInterior( planeExit, 1 )
		setElementDimension( planeExit, 0 )
	end	
end

function getEventPlane( )
	
	local thePlane = nil
	for key, theVehicle in ipairs ( getElementsByType("vehicle") ) do
		
		local dbid = tonumber( getData(theVehicle, "dbid") )
		if ( dbid == 218 ) then
			
			thePlane = theVehicle
			break
		end
	end

	return thePlane
end

-- FAKE PILOTS
function createFakePilots( )
	local pilot = createPed( 61, 2.6572, 35.9570, 1199.5937, 360 )
	if ( pilot ) then
		
		setElementInterior( pilot, 1 )
		setTimer( setPedAnimation, 2000, 1, pilot, "ped", "SEAT_idle", -1, true, false, false)
	end	
	
	local copilot = createPed( 61, 0.8730, 35.9580, 1199.6011, 360 )
	if ( copilot ) then
		
		setElementInterior( copilot, 1 )
		setTimer( setPedAnimation, 2000, 1, copilot, "ped", "SEAT_idle", -1, true, false, false)
	end	
end
addEventHandler("onResourceStart", resourceRoot, createFakePilots) 	

-- EVENTS
local canExit = { }
local canEnter = { }
local lookingOut = { }
function openPlaneDoor( theElement )
	if ( getElementType( theElement ) == "player" ) then
		
		if ( source == planeEntrance ) and ( canEnter[theElement] == true ) then
			
			local x, y, z = getElementPosition( planeExit )
			if ( x and y and z ) then
				
				setElementPosition( theElement, x, y, z + 1 )
				setElementInterior( theElement, 1 )
				setElementDimension( theElement, 0 )
				
				canEnter[theElement] = false
				
				setTimer(
					function( )
						canExit[theElement] = true
					end, 2000, 1
				)	
			end	
		elseif ( source == planeExit ) and ( canExit[theElement] == true ) then
			
			local x, y, z = getElementPosition( planeEntrance )
			if ( x and y and z ) then
				
				setElementPosition( theElement, x, y, z )
				setElementInterior( theElement, 0 )
				setElementDimension( theElement, 0 )
				
				canExit[theElement] = false
				
				setTimer(
					function( )
						canEnter[theElement] = true
					end, 2000, 1
				)	
			end	
		end
	end	
end
addEventHandler("onMarkerHit", root, openPlaneDoor )

local seatX = { }
local seatY = { }
local seatZ = { }
function pilotGetOffPlane( thePlayer )
	local thePlane = getEventPlane( )
	if ( thePlane == source ) then
		
		for key, value in pairs ( lookingOut ) do
			if ( lookingOut[key] == true ) then
				setCameraTarget( key, key )
				setCameraInterior( key, 1 )
				
				setElementPosition( key, seatX[key], seatY[key], seatZ[key] )
				setElementFrozen( key, false )
				
				lookingOut[key] = false
				
				outputChatBox("Please proceed to the exit gate of the plane.", key, 212, 156, 49)
			end	
		end
	end	
end
addEventHandler("onVehicleStartExit", root, pilotGetOffPlane)

addEventHandler("onPlayerJoin", root,
	function( )
		
		canExit[source] = false
		canEnter[source] = true
		lookingOut[source] = false
	end
)

addEventHandler("onPlayerQuit", root,
	function( )
		
		canExit[source] = nil
		canEnter[source] = nil
		lookingOut[source] = nil
	end
)

addEventHandler("onResourceStart", resourceRoot,
	function( )
		
		for key, thePlayer in ipairs ( getElementsByType("player") ) do
			
			if ( getElementDimension( thePlayer ) == 1 ) and ( getElementInterior( thePlayer ) == 1 ) then -- Inside Plane
				
				canExit[thePlayer] = true
				canEnter[thePlayer] = false
			else
				canExit[thePlayer] = false
				canEnter[thePlayer] = true
			end	
			
			lookingOut[thePlayer] = false
		end	
	end
)

addEventHandler("onResourcePreStart", resourceRoot,
	function( )
		
		for key, thePlayer in ipairs ( getElementsByType("player") ) do
			
			if ( lookingOut[thePlayer] ~= false ) then
				
				setCameraInterior( thePlayer, 1 )
				setCameraTarget( thePlayer, thePlayer )
			end
		end
	end
)
	
-- COMMANDS
function togglePlaneDoors( thePlayer, commandName )
	if ( exports['[ars]global']:isPlayerTrialModerator( thePlayer ) ) then
		
		if ( commandName == "opendoors" ) then
			
			if ( planeEntrance == nil ) and ( planeExit == nil ) then
				
				createPlaneEntrance( )
				createPlaneExit( )
				
				outputChatBox("The Plane doors were opened.", thePlayer, 0, 255, 0)
			else
				outputChatBox("The Plane doors are already open.", thePlayer, 255, 0, 0)
			end	
		elseif ( commandName == "closedoors" ) then
			
			if ( planeEntrance ~= nil ) and ( planeExit ~= nil ) then
				
				destroyElement( planeEntrance )
				destroyElement( planeExit )
				
				planeEntrance = nil
				planeExit = nil
				
				outputChatBox("The Plane doors were closed.", thePlayer, 0, 255, 0)
			else
				outputChatBox("The Plane doors are already closed.", thePlayer, 255, 0, 0)
			end		
		end	
	end	
end
addCommandHandler("opendoors", togglePlaneDoors, false, false)
addCommandHandler("closedoors", togglePlaneDoors, false, false)

function lookOutOfWindow( thePlayer, commandName )
	if ( thePlayer ) then
		
		if ( getElementDimension( thePlayer ) == 0 ) and ( getElementInterior( thePlayer ) == 1 ) then -- Inside Plane
			
			local thePlane = getEventPlane( )
			if ( thePlane ~= nil ) then
				
				if ( lookingOut[thePlayer] == false ) then
					
					local thePilot = getVehicleController( thePlane )
					if ( thePilot ) then
						
						local x, y, z = getElementPosition( thePlayer )
						seatX[thePlayer] = x
						seatY[thePlayer] = y
						seatZ[thePlayer] = z
						
						setElementFrozen( thePlayer, true )
						
						setCameraInterior( thePlayer, 0 )
						setCameraTarget( thePlayer, thePilot )
						
						lookingOut[thePlayer] = true
						
						outputChatBox("You are now looking outside the plane's window.", thePlayer, 0, 255, 0)
					else
						outputChatBox("Please wait till the Administrators tell you to /lookout.", thePlayer, 212, 156, 49)
					end	
				elseif ( lookingOut[thePlayer] == true ) then
					
					setCameraTarget( thePlayer, thePlayer )
					setCameraInterior( thePlayer, 1 )
					
					setElementPosition( thePlayer, seatX[thePlayer], seatY[thePlayer], seatZ[thePlayer] )
					setElementFrozen( thePlayer, false )
					
					lookingOut[thePlayer] = false
					
					outputChatBox("You are no longer looking outside the plane's window.", thePlayer, 255, 0, 0)
				end
			end	
		else
			outputChatBox("You are not inside the plane.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("lookout", lookOutOfWindow, false, false)

function eventCommands( thePlayer, commandName )
	outputChatBox("~-~-~- Today's Event Commands ~-~-~-", thePlayer, 212, 156, 49)

	if ( exports['[ars]global']:isPlayerTrialModerator( thePlayer ) ) then
	
		outputChatBox("- Admin Commands:", thePlayer, 212, 156, 49)
		outputChatBox("1. /opendoors - Show plane doors.", thePlayer, 212, 156, 49)
		outputChatBox("1. /closedoors - Hide plane doors.", thePlayer, 212, 156, 49)
		outputChatBox(" ", thePlayer)		
	end	
	
	outputChatBox("- Player Commands:", thePlayer, 212, 156, 49)
	outputChatBox("1. /lookout - Look out of the plane's window.", thePlayer, 212, 156, 49)
end
addCommandHandler("eventcmds", eventCommands)	