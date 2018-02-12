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

local fire = { }

function createFire(thePlayer, commandName)
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerModerator(thePlayer) then
		local id = #fire + 1
		local x, y, z = getElementPosition(thePlayer)
			
		fire[id] = { }
		fire[id][1] = x
		fire[id][2] = y
		fire[id][3] = z
		fire[id][4] = createObject(14862, x, y, z - 0.5)
		fire[id][5] = createObject(3082, x, y, z)
		fire[id][6] = createColSphere (x, y, z, 1)
		
		setElementDimension(fire[id][4], getElementDimension(thePlayer))
		setElementInterior(fire[id][4], getElementInterior(thePlayer))
		setElementDimension(fire[id][5], getElementDimension(thePlayer))
		setElementInterior(fire[id][5], getElementInterior(thePlayer))
		setElementDimension(fire[id][6], getElementDimension(thePlayer))
		setElementInterior(fire[id][6], getElementInterior(thePlayer))
		outputChatBox("Fire created with ID " .. id .. ".", thePlayer, 0, 255, 0)
	end
end
addCommandHandler("createfire", createFire, false, false)
addCommandHandler("makefire", createFire, false, false)

function nearbyFire(thePlayer)
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerModerator(thePlayer) then
		local count = 0
		outputChatBox("Fires Nearby: ", thePlayer, 212, 156, 49)
		local px, py, pz = getElementPosition(thePlayer)
		for key, value in ipairs(fire) do
			local x = fire[key][1]
			local y = fire[key][2]
			local z = fire[key][3]
			
			if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) < 50) and getElementDimension(thePlayer) == getElementDimension(value[5]) and getElementDimension(thePlayer) == getElementDimension(value[4]) then
				count = count + 1
				outputChatBox("Fire with ID " .. key .. ".", thePlayer, 212, 156, 49)
			end
		end
		
		if (count == 0) then
			outputChatBox("No fires nearby.", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("nearbyfire", nearbyFire)
addCommandHandler("nearbyfires", nearbyFire)

function deleteFire(thePlayer, commandName, id)
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerModerator(thePlayer) then
		if not (id) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Fire ID]", thePlayer, 212, 156, 49)
		else
			if ( fire[tonumber(id)] == nil ) then
				outputChatBox("No fire with such ID exist.", thePlayer, 255, 0, 0)
			else
				local obj = fire[tonumber(id)][5]
				local obj2 = fire[tonumber(id)][4]
				local obj3 = fire[tonumber(id)][6]
				fire[tonumber(id)] = nil
				destroyElement(obj)
				destroyElement(obj2)
				destroyElement(obj3)
				outputChatBox("Fire with ID " .. id .. " was deleted.", thePlayer, 0, 255, 0)
			end
		end
	end
end
addCommandHandler("delfire", deleteFire)
addCommandHandler("deletefire", deleteFire)

function deleteAll(thePlayer, commandName)
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerModerator(thePlayer) then
		local count = 0
		for k, v in pairs(fire) do
			destroyElement(v[6])
			destroyElement(v[5])
			destroyElement(v[4])
			count = count + 1
		end
		fire = {}
		outputChatBox("Deleted " .. count .. " fires.", thePlayer, 0, 255, 0)
	end
end
addCommandHandler("deleteallfires", deleteAll)
addCommandHandler("delallfires", deleteAll)