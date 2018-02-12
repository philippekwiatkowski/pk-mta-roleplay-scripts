--------- [ Routes ] ---------

local route = { }
route[1] = { }
route[2] = { }

route[1][1] = { -2253.7929, -84.3662, 34.8969 }
route[1][2] = { -2266.7998, 51.1308, 34.8931 }
route[1][3] = { -2373.5517, -56.2490, 34.8967 }
route[1][4] = { -2274.2275, -192.6093, 34.8968 }
route[1][5] = { -2165.8291, -84.3593, 34.8970 }
route[1][6] = { -2156.8818, 96.6582, 34.8970 }
route[1][7] = { -2156.7480, 210.0332, 34.8968 }
route[1][8] = { -2254.4023, 181.9843, 34.8969}
route[1][9] = { -2260.3291, -53.4628, 34.8969 }
route[1][10] = { -2270.1806, -124.6552, 35.0454 }

route[2][1] = { -2259.5126, -174.4101, 34.8969 }
route[2][2] = { -2211.6181, -201.5634, 35.0454 }
route[2][3] = { -2031.6220, -295.2138, 35.0610 }
route[2][4] = { -2003.2939, -251.5927, 35.3222 }
route[2][5] = { -2004.2978, -86.1796, 35.0697 }
route[2][6] = { -2153.0839, -68.8212, 34.8967 }
route[2][7] = { -2169.7822, -152.2587, 34.8970 }
route[2][8] = { -2237.6962, -187.3359, 34.8937 }
route[2][9] = { -2251.4414, -144.9257, 34.8969 }
route[2][10] = { -2270.1806, -124.6552, 35.0454  }


--------- [ Server Calls ] ---------
function startSweeperJob( )
	createSweeperCheckpoint( )
end
addEvent("startSweeperJob", true)
addEventHandler("startSweeperJob", localPlayer, startSweeperJob)	

function endSweeperJob( )
	removeSweeperCheckpoint( )
end
addEvent("endSweeperJob", true)
addEventHandler("endSweeperJob", localPlayer, endSweeperJob)

--------- [ Globals ] ---------
local currMarker, nextMarker = nil, nil
local currBlip, nextBlip = nil, nil
local rand = math.random(1, 2)
local stage = 0

--------- [ Sweeper Job ] ---------
function createSweeperCheckpoint( )
	if (stage == 0) then -- Begin
	
		stage = 1
		
		local currX, currY, currZ = unpack(route[rand][stage])		-- Get the position of the current marker
		local nextX, nextY, nextZ = unpack(route[rand][stage+1])	-- Get the position of the next marker
	
		-- Create Em'!
		currMarker = createMarker(currX, currY, currZ, "checkpoint", 2, 255, 255, 0, 200, localPlayer)
		currBlip = createBlip(currX, currY, currZ, 0, 2, 255, 194, 14, 255, 0, 99999.0, localPlayer )
	
		nextMarker = createMarker(nextX, nextY, nextZ, "checkpoint", 1.5, 62, 65, 196, 200, localPlayer)
		nextBlip = createBlip(nextX, nextY, nextZ, 0, 1, 62, 65, 196, 255, 0, 99999.0, localPlayer)	
	end	
end
	
function hitSweeperCheckpoint( hitPlayer, matchingDimension )
	if (hitPlayer == localPlayer and isPedInVehicle(localPlayer)) then				-- Ensure that whoever hit the marker is the client
		if (getVehicleName(getPedOccupiedVehicle(localPlayer)) == "Sweeper") then 	-- Check if client hit the marker in a sweeper
		
			if (source == currMarker) then	 -- Keep going
				
				stage = stage + 1		 	 -- Next stage
			
				playSoundFrontEnd(6)
				
				local currR, currG, currB = nil, nil, nil
				local nextR, nextG, nextB = nil, nil, nil
				
				if (stage == 9) then -- Hit the third last checkpoint
				
					currR, currG, currB = 255, 255, 0
					nextR, nextG, nextB = 255, 0, 0	-- The last marker is red :P	
				elseif (stage == 10) then -- Hit the second last checkpoint
					
					destroyElement(currMarker)		-- Destroy the marker that was hit
					destroyElement(currBlip)
					
					setMarkerSize(nextMarker, 2)	-- make the next marker identical to the current marker
					stage = stage + 1				-- next stage		
				
					return							-- Stop!
				else										-- Otherwise,
					currR, currG, currB = 255, 255, 0		
					nextR, nextG, nextB = 62, 65, 196
				end
				
				destroyElement(currMarker)					-- Destroy the marker that was hit
				destroyElement(currBlip)
				
				currMarker, currBlip = nextMarker, nextBlip		-- our next marker becomes our current marker
				
				setMarkerSize(currMarker, 2)					-- Change the current marker's color and size
				setMarkerColor(currMarker, currR, currG, currB)
				setBlipSize(currBlip, 2)
				setBlipColor(currBlip, currR, currG, currB, 255)
				
				local nextX, nextY, nextZ = unpack(route[rand][stage+1])	-- Get the position of the next marker
	
				-- Create it
				nextMarker = createMarker(nextX, nextY, nextZ, "checkpoint", 1.5, nextR, nextG, nextB, 200, localPlayer)
				nextBlip = createBlip(nextX, nextY, nextZ, 0, 1, nextR, nextG, nextB, 255, 0, 99999.0, localPlayer)
				
			elseif (source == nextMarker and stage == 11) then -- End of the line
			
				playSoundFrontEnd(13)
				
				destroyElement(nextMarker)		-- Destroy the last remaining marker
				destroyElement(nextBlip)
				
				outputChatBox("You completed your sweeper run!", 0, 255, 0)
				outputChatBox("Please park the sweeper before leaving.", 0, 255, 0)
				
				paySweeper( 60 )	-- Pay Them
				
				-- Reset Globals
				currMarker, nextMarker = nil, nil
				currBlip, nextBlip = nil, nil
				rand = math.random(1, 2)
				stage = 0
				
				triggerServerEvent("sweeperAbandonTimer", localPlayer)		-- Start the countdown for abandoning the vehicle
			end
		end	
	end	
end
addEventHandler("onClientMarkerHit", root, hitSweeperCheckpoint)

--------- [ Various Functions ] ---------

-- End the run when the player leaves the vehicle..
function removeSweeperCheckpoint( )
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
end

-- Pay the Sweeper
function paySweeper ( amount )
	local amount = tonumber(amount*150)
	
	triggerServerEvent("paySweeperMoney", localPlayer, amount)
end	