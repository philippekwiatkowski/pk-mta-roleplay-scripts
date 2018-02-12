--------- [ Globals ] ---------
local currMarker, nextMarker = nil, nil
local currBlip, nextBlip = nil, nil
local rand = math.random(1, 2)
local stage = 0

local canLeave = true

--------- [ Bus Routes ] ---------
local route = nil

function resourceStart( res )
	triggerServerEvent("getRouteInformation", localPlayer)
end
addEventHandler("onClientResourceStart", resourceRoot, resourceStart)	

function giveRouteInformation( table )
	if (table) then
		route = table
	end	
end
addEvent("giveRouteInformation", true)
addEventHandler("giveRouteInformation", localPlayer, giveRouteInformation)

--------- [ Server Calls ] ---------
function startBusJob( )
	createBusCheckpoint( )
end
addEvent("startBusJob", true)
addEventHandler("startBusJob", localPlayer, startBusJob)	

function endBusJob( )
	removeBusCheckpoint( )
end
addEvent("endBusJob", true)
addEventHandler("endBusJob", localPlayer, endBusJob)	

--------- [ Bus Job ] ---------
function createBusCheckpoint( )
	if (stage == 0) then -- Begin
	
		stage = 1		-- We start..
		
		local currX, currY, currZ, currStop = unpack(route[rand][stage])		-- Get the position of the current marker
		local nextX, nextY, nextZ, nextStop = unpack(route[rand][stage+1])		-- Get the position of the next marker
	
		-- Color Em'!
		local currR, currG, currB = nil, nil, nil
		local nextR, nextG, nextB = nil, nil, nil
		
		if (currStop == "true") then
			currR, currG, currB = 000, 255, 000
		else
			currR, currG, currB = 255, 194, 014
		end
 
		if (nextStop == "true") then
			nextR, nextG, nextB = 000, 255, 000
		else		
			nextR, nextG, nextB = 255, 194, 014
		end
		
		-- Create Em'!
		currMarker = createMarker(currX, currY, currZ, "checkpoint", 2, currR, currG, currB, 200, localPlayer)
		currBlip = createBlip(currX, currY, currZ, 0, 2, currR, currG, currB, 255, 0, 99999.0, localPlayer )
	
		nextMarker = createMarker(nextX, nextY, nextZ, "checkpoint", 1.5, nextR, nextG, nextB, 200, localPlayer)
		nextBlip = createBlip(nextX, nextY, nextZ, 0, 1, nextR, nextG, nextB, 255, 0, 99999.0, localPlayer)		
	end	
end
	
function hitBusCheckpoint( hitPlayer, matchingDimension )
	if (hitPlayer == localPlayer) and isPedInVehicle(localPlayer) then	-- Ensure that whoever hit the marker is the client
		if (getVehicleName(getPedOccupiedVehicle(localPlayer)) == "Bus") then -- Check if client hit the marker in a Bus
			
			if ( rand == 1 ) then
				if ( stage == 44 ) then
					stage = 43
				end
			else
				if ( stage == 44 ) then
					stage = 43
				end	
			end	
			
			local isStop = route[rand][stage][4]						
			
			if (source == nextMarker and isStop == "true") then								-- If the last (red) marker was hit
				
				canLeave = false
				
				leaveTimer = setTimer(
				function() 
					canLeave = true 
					
					stage = stage + 1
					
					advanceCheckpoint( nextMarker )
				end, 3000, 1)
			elseif (source == nextMarker and isStop == "false") then
				
				advanceCheckpoint( nextMarker )
				return
			end	
			
			if (source == currMarker and isStop == "true") then			-- if the current marker was hit and it is a stop
				
				canLeave = false
				
				leaveTimer = setTimer(
				function() 
					canLeave = true 
				
					advanceCheckpoint( currMarker )
				end, 3000, 1)
			elseif (source == currMarker and isStop == "false") then	-- if the current marker was hit and it is'nt stop
				
				advanceCheckpoint( currMarker )
			end
		end
	end	
end
addEventHandler("onClientMarkerHit", root, hitBusCheckpoint)

function leaveBusCheckpoint( leavePlayer, matchingDimension )
	if (leavePlayer == localPlayer) and (isPedInVehicle(localPlayer)) then	-- Ensure that whoever left the marker is the client
		if (getVehicleName(getPedOccupiedVehicle(localPlayer)) == "Bus") then -- Check if client left the marker in a Bus
			
			if (canLeave == false) then										-- They are on a stop, must wait for 5 seconds..
				if isTimer(leaveTimer) then
					killTimer(leaveTimer)
				end	
				
				canLeave = true
				outputChatBox("Wait at the bus stop for atleast 5 seconds!", 0, 255, 0)
			end	
		end
	end
end
addEventHandler("onClientMarkerLeave", root, leaveBusCheckpoint)
	
function advanceCheckpoint( source )
	if (source == currMarker) then	-- Keep goin'
	
		stage = stage + 1 -- Next stage
		playSoundFrontEnd(6)
		
		local currR, currG, currB = nil, nil, nil
		local nextR, nextG, nextB = nil, nil, nil
		
		if (rand == 1 and stage == 40) or (rand == 2 and stage == 40) then -- Hit the third last checkpoint
			
			currR, currG, currB = 255, 194, 014	
			nextR, nextG, nextB = 255, 000, 000	-- The last marker is red :P
		elseif (rand == 1 and stage == 41) or (rand == 2 and stage == 41) then -- Hit the second last checkpoint
		
			destroyElement(currMarker)	 -- Destroy the marker that was hit
			destroyElement(currBlip)
			
			setMarkerSize(nextMarker, 2) -- make the next marker identical to the current marker
			stage = stage + 1			 -- next stage	
		
			return						 -- No need to go down
		else
			
			local currStop = route[rand][stage][4]		-- currStop, true or false?
			local nextStop = route[rand][stage+1][4]	-- nextStop, true or false?
			
			if (currStop == "true") then				-- If its a stop, color it green
				currR, currG, currB = 000, 255, 00
			else
				currR, currG, currB = 255, 194, 014		-- Otherwise yellow..
			end
		 
			if (nextStop == "true") then
				nextR, nextG, nextB = 000, 255, 000
			else		
				nextR, nextG, nextB = 062, 065, 196
			end
		end
	
		destroyElement(currMarker)						-- Destroy the marker that was hit
		destroyElement(currBlip)
		
		currMarker, currBlip = nextMarker, nextBlip		-- our next marker becomes our current marker
		
		setMarkerSize(currMarker, 2)					-- Change the current marker's color and size
		setMarkerColor(currMarker, currR, currG, currB)
		setBlipSize(currBlip, 2)
		setBlipColor(currBlip, currR, currG, currB, 255)
		
		local nextX, nextY, nextZ = unpack(route[rand][stage+1])	-- Get the position of the next marker
		
		nextMarker = createMarker(nextX, nextY, nextZ, "checkpoint", 1.5, nextR, nextG, nextB, 200, localPlayer)	-- Create it
		nextBlip = createBlip(nextX, nextY, nextZ, 0, 1, nextR, nextG, nextB, 255, 0, 99999.0, localPlayer)
		
	elseif (source == nextMarker) and (stage == 42) or (stage == 42) then -- End of the line
		
		playSoundFrontEnd(13)
	
		destroyElement(nextMarker)	-- Destroy the last remaining marker
		destroyElement(nextBlip)
		
		-- Tell them
		outputChatBox("You completed your bus run!", 0, 255, 0)
		outputChatBox("Please park the bus before leaving.", 0, 255, 0)		
		
		-- Reset Globals
		currMarker, nextMarker = nil, nil
		currBlip, nextBlip = nil, nil
		rand = math.random(1, 2)
		stage = 0
		canLeave = true
		
		payBusDriver( 500 )
		
		triggerServerEvent("busAbandonTimer", localPlayer)
	end
end	

--------- [ Various Functions ] ---------

-- End the run when the player leaves the vehicle..
function removeBusCheckpoint( )
	if (currMarker) then
		destroyElement(currMarker)
		destroyElement(currBlip)
	end
		
	if (nextMarker) then
		destroyElement(nextMarker)
		destroyElement(nextBlip)
	end
	
	currMarker, nextMarker = nil, nil
	currBlip, nextBlip = nil, nil
	rand = math.random(1, 2)
	stage = 0
	canLeave = true
end

-- Pay the Bus driver
function payBusDriver( amount )
	local amount = tonumber(amount*100)
	
	triggerServerEvent("payBusDriver", localPlayer, amount)
end