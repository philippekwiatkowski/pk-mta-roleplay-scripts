--------- [ Element Data returns ] ---------
local function getData( theElement, key )
	local key = tostring(key)
	if isElement(theElement) and (key) then
		
		return exports['[ars]anticheat-system']:callData( theElement, tostring(key) )
	else
		return false
	end
end	

local function setData( theElement, key, value, sync )
	local key = tostring(key)
	local value = tonumber(value) or tostring(value)
	if isElement(theElement) and (key) and (value) then
		
		return exports['[ars]anticheat-system']:assignData( theElement, tostring(key), value, sync )
	else
		return false
	end	
end

-----------------------------------------------------------------------------------------------------------

local rb = { }

function createRoadblock(thePlayer, commandName, rbType)
	if getData(thePlayer, "loggedin") == 1 then
	
		if (rbType) then
		
			local rbType = tonumber(rbType)
			local faction = tonumber( getData(thePlayer, "faction") )
			if ( faction == 1 ) or ( faction == 2 ) then -- LSPD/LSFD
		
				if (rbType == 1) then -- Traffic Block
			
					local id = #rb + 1
					local x, y, z = getElementPosition(thePlayer)
					local rx, ry, rz = getElementRotation (thePlayer)
			
					rb[id] = { }
					rb[id][1] = x
					rb[id][2] = y
					rb[id][3] = z
					rb[id][4] = createObject(978, x, y, z - 0.5)
					setElementDoubleSided (rb[id][4], true)
					setElementRotation (rb[id][4], rx, ry, rz)
		
					setElementDimension(rb[id][4], getElementDimension(thePlayer))
					setElementInterior(rb[id][4], getElementInterior(thePlayer))
					outputChatBox("Roadblock created with ID " .. id .. ".", thePlayer, 0, 255, 0)
				elseif (rbType == 2) then -- Yellow Block
				
					local id = #rb + 1
					local x, y, z = getElementPosition(thePlayer)
					local rx, ry, rz = getElementRotation (thePlayer)
			
					rb[id] = { }
					rb[id][1] = x
					rb[id][2] = y
					rb[id][3] = z
					rb[id][4] = createObject(3578, x, y, z - 0.3)
					setElementDoubleSided (rb[id][4], true)
					setElementRotation (rb[id][4], rx, ry, rz)
		
					setElementDimension(rb[id][4], getElementDimension(thePlayer))
					setElementInterior(rb[id][4], getElementInterior(thePlayer))
					outputChatBox("Roadblock created with ID " .. id .. ".", thePlayer, 0, 255, 0)
					setElementPosition(thePlayer, x, y, z + 1)
				elseif (rbType == 3) then -- Traffic Barrier
				
					local id = #rb + 1
					local x, y, z = getElementPosition(thePlayer)
					local rx, ry, rz = getElementRotation (thePlayer)
				
					rb[id] = { }
					rb[id][1] = x
					rb[id][2] = y
					rb[id][3] = z
					rb[id][4] = createObject(1459, x, y, z - 0.4)
					setElementDoubleSided (rb[id][4], true)
					setElementRotation (rb[id][4], rx, ry, rz)
			
					setElementDimension(rb[id][4], getElementDimension(thePlayer))
					setElementInterior(rb[id][4], getElementInterior(thePlayer))
					outputChatBox("Roadblock created with ID " .. id .. ".", thePlayer, 0, 255, 0)
				elseif (rbType == 4) then -- Sidewalk Barrier
					
					local id = #rb + 1
					local x, y, z = getElementPosition(thePlayer)
					local rx, ry, rz = getElementRotation (thePlayer)
				
					rb[id] = { }
					rb[id][1] = x
					rb[id][2] = y
					rb[id][3] = z
					rb[id][4] = createObject(1424, x, y, z - 0.43)
					setElementRotation (rb[id][4], rx, ry, rz)
			
					setElementDimension(rb[id][4], getElementDimension(thePlayer))
					setElementInterior(rb[id][4], getElementInterior(thePlayer))
					outputChatBox("Roadblock created with ID " .. id .. ".", thePlayer, 0, 255, 0)
				elseif (rbType == 5) then -- Detour Sign
					
					local id = #rb + 1
					local x, y, z = getElementPosition(thePlayer)
					local rx, ry, rz = getElementRotation (thePlayer)
				
					rb[id] = { }
					rb[id][1] = x
					rb[id][2] = y
					rb[id][3] = z
					rb[id][4] = createObject(1425, x, y, z - 0.5)
					setElementRotation (rb[id][4], rx, ry, rz - 180)
			
					setElementDimension(rb[id][4], getElementDimension(thePlayer))
					setElementInterior(rb[id][4], getElementInterior(thePlayer))
					outputChatBox("Roadblock created with ID " .. id .. ".", thePlayer, 0, 255, 0)
				elseif (rbType == 6) then -- Cone
					
					local id = #rb + 1
					local x, y, z = getElementPosition(thePlayer)
					local rx, ry, rz = getElementRotation (thePlayer)
				
					rb[id] = { }
					rb[id][1] = x
					rb[id][2] = y
					rb[id][3] = z
					rb[id][4] = createObject(1238, x, y, z - 0.7)
					setElementRotation (rb[id][4], rx, ry, rz)
			
					setElementDimension(rb[id][4], getElementDimension(thePlayer))
					setElementInterior(rb[id][4], getElementInterior(thePlayer))
					outputChatBox("Roadblock created with ID " .. id .. ".", thePlayer, 0, 255, 0)
				elseif (rbType == 7) and ( faction == 1 ) then -- Spike Strip
					
					local id = #rb + 1
					local x, y, z = getElementPosition(thePlayer)
					local rx, ry, rz = getElementRotation (thePlayer)
				
					rb[id] = { }
					rb[id][1] = x
					rb[id][2] = y
					rb[id][3] = z
					rb[id][4] = createObject(2899, x, y, z - 0.92)
					setElementRotation (rb[id][4], rx, ry, rz - 90)
			
					setElementDimension(rb[id][4], getElementDimension(thePlayer))
					setElementInterior(rb[id][4], getElementInterior(thePlayer))
					outputChatBox("Roadblock created with ID " .. id .. ".", thePlayer, 0, 255, 0)
				end
			end
		else
			outputChatBox("~~~~~ Roadblocks ~~~~~", thePlayer, 212, 156, 49)
			outputChatBox("1 = Traffic Block, 2 = Yellow Block, 3 = Traffic Barrier", thePlayer, 212, 156, 49)
			outputChatBox("4 = Sidewalk Barrier, 5 = Detour Sign, 6 = Cone", thePlayer, 212, 156, 49)
			if ( faction == 1 ) then
				outputChatBox("7 = Spike Strip", thePlayer, 212, 156, 49)
			end
			outputChatBox("~~~~~~~~~~~~~~~~~~~~", thePlayer, 212, 156, 49)
			outputChatBox("SYNTAX: /".. commandName .." [Roadblock Type]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("rb", createRoadblock, false, false)
addCommandHandler("roadblock", createRoadblock, false, false)

function nearbyRoadblock(thePlayer)
	if getData(thePlayer, "loggedin") == 1 then
		local count = 0
		outputChatBox("Roadblocks Nearby: ", thePlayer, 212, 156, 49)
		local px, py, pz = getElementPosition(thePlayer)
		for key, value in ipairs(rb) do
			local x = rb[key][1]
			local y = rb[key][2]
			local z = rb[key][3]
			
			if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) < 50) and getElementDimension(thePlayer) == getElementDimension(value[4]) then
				count = count + 1
				outputChatBox("Roadblock with ID " .. key .. ".", thePlayer, 212, 156, 49)
			end
		end
		
		if (count == 0) then
			outputChatBox("No roadblocks nearby.", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("nearbyrbs", nearbyRoadblock)
addCommandHandler("nearbyroadblocks", nearbyRoadblock)

function deleteRoadblock(thePlayer, commandName, id)
	if getData(thePlayer, "loggedin") == 1 then
		if not (id) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Roadblock ID]", thePlayer, 212, 156, 49)
		else
			if ( rb[tonumber(id)] == nil ) then
				outputChatBox("No roadblock with such ID exist.", thePlayer, 255, 0, 0)
			else
				local obj = rb[tonumber(id)][4]
				rb[tonumber(id)] = nil
				destroyElement(obj)
				outputChatBox("Roadblock with ID " .. id .. " was deleted.", thePlayer, 0, 255, 0)
			end
		end
	end
end
addCommandHandler("delrb", deleteRoadblock)
addCommandHandler("deleteroadblock", deleteRoadblock)

function deleteAll(thePlayer, commandName)
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		local count = 0
		for k, v in pairs(rb) do
			destroyElement(v[4])
			count = count + 1
		end
		rb = {}
		outputChatBox("Deleted " .. count .. " roadblocks.", thePlayer, 0, 255, 0)
	end
end
addCommandHandler("delallrbs", deleteAll)