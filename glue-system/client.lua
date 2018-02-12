--[[
	SuperGlue v.1.0.0
	
	By John_Michael
	
	:client.lua - pre-process requests to be sent to the server, handle keybinds.
]]
local localPlayer = getLocalPlayer() --For pre-MTA 1.1 servers.

function onGlueButtonPressed(_, _)
	--First, check if the local player is glued to an element
	local localPlayerVehicle = getPedOccupiedVehicle(localPlayer)
	local localVehicleType
	if localPlayerVehicle then
		localVehicleType = getElementModel(localPlayerVehicle)
	end
	
	
	if (getElementData(localPlayer, "glueParent")) then
		triggerServerEvent("clientRequestElementDetachment", localPlayer, localPlayer, getElementData(localPlayer, "glueParent"))
		return
	end
	
	--Second, check if the local player is in a vehicle, and if that vehicle is glued.
	if localPlayerVehicle then
		if getElementData(localPlayerVehicle, "glueParent") then
			if localVehicleType == (487 or 548 or 425 or 417 or 488 or 497 or 563 or 447 or 469) then
				triggerServerEvent("clientRequestElementDetachment", localPlayer, getElementData(localPlayerVehicle, "glueParent"), localPlayerVehicle, true)
				return
			else
				triggerServerEvent("clientRequestElementDetachment", localPlayer, localPlayerVehicle, getElementData(localPlayerVehicle, "glueParent"))
				return
			end
		end
	end
	
	--If the player isn't requesting an unglue, than process it as a glue.
	--If the player is in a car, we are gluing a car to a car.
	if localPlayerVehicle then
		local localVehicleX, localVehicleY, localVehicleZ = getElementPosition(localPlayerVehicle)
		--
		--	HELICOPTER TO VEHICLE REQUEST
		--
		--Check if the local vehicle is a helicopter
		if localVehicleType == (487 or 548 or 425 or 417 or 488 or 497 or 563 or 447 or 469) then
			local slaveVehicle
			for i, vehicle in ipairs(getElementsByType("vehicle")) do
				if isElementStreamedIn(vehicle) and vehicle ~= localPlayerVehicle then
						local vehicleX, vehicleY, vehicleZ = getElementPosition(vehicle)
						if getDistanceBetweenPoints3D(vehicleX, vehicleY, vehicleZ, localVehicleX, localVehicleY, localVehicleZ) < 6 then
							slaveVehicle = vehicle
						end
				end
			end
			if slaveVehicle then
				--Get the vehicles bouding box, then calculate the size on the Z axis.
				local x0, y0, z0, x1, y1, z1 = getElementBoundingBox(slaveVehicle)
				local vehicleZOffset = z1-z0
				--Then, add the distance from the helicopters center to the base to it, giving us the Z offset
				local heliZOffset = getElementDistanceFromCentreOfMassToBaseOfModel(localPlayerVehicle)
				local zOffset = -(heliZOffset + vehicleZOffset)
				if localVehicleZ - heliZOffset - (z1-z0) < getGroundPosition(localVehicleX, localVehicleY, localVehicleZ) then
					outputChatBox("You are hovering too close to be able to glue to the vehicle!", 255, 0, 0)
					return
				end
				--Also grab the helis rotation
				local rotX, rotY, rotZ = getElementRotation(localPlayerVehicle)
				triggerServerEvent("clientRequestElementAttachment", localPlayer, slaveVehicle, localPlayerVehicle, 0, 0, zOffset, 0, 0, 0, false, true)
				return
			else
				outputChatBox("You aren't hovering close enough to a vehicle to glue to!", 255, 0, 0)
				return
			end
		else
		--
		--	NORMAL VEHICLE REQUEST
		--
		--Check if there is a car within 4 meters of the local vehicle
			local masterVehicle
			for i, vehicle in ipairs(getElementsByType("vehicle")) do
				if isElementStreamedIn(vehicle) and vehicle ~= localPlayerVehicle then
					if getElementData(vehicle, "glueParent") ~= localPlayerVehicle then
						local vehicleX, vehicleY, vehicleZ = getElementPosition(vehicle)
						if getDistanceBetweenPoints3D(vehicleX, vehicleY, vehicleZ, localVehicleX, localVehicleY, localVehicleZ) < 4 then
							masterVehicle = vehicle
						end
					else
						outputChatBox("You are not close enough to a vehicle to glue to!", 255, 0, 0)
						return
					end
				end
			end
			if masterVehicle then
				local x, y, z, rx, ry, rz = calculateOffsets(localPlayerVehicle, masterVehicle)
				--Fix for packer (id 443)
				if getElementModel(masterVehicle) == 443 then
					rx = 15
				end
				triggerServerEvent("clientRequestElementAttachment", localPlayer, localPlayerVehicle, masterVehicle, x, y, z, rx, ry, rz)
				return
			else
				outputChatBox("You aren't close enough to a vehicle to glue to!", 255, 0, 0)
				return
			end
		end
		
	
	--
	--	TRADITIONAL (LOCAL PED TO VEHICLE) REQUEST
	--
	else
		local contactElement = getPedContactElement(localPlayer)
		if isElement(contactElement) then
			if getElementType(contactElement) == "vehicle" then
				local x, y, z, rx, ry, rz = calculateOffsets(localPlayer, contactElement)
				local weaponSlot = getPedWeaponSlot(localPlayer)
	
				triggerServerEvent("clientRequestElementAttachment", localPlayer, localPlayer, contactElement, x, y, z, rx, ry, rz, weaponSlot)
				return
			else
				outputChatBox("You aren't close enough to a vehicle to glue to!", 255, 0, 0)
				return
			end
		else
			outputChatBox("You aren't close enough to a vehicle to glue to!", 255, 0, 0)
			return
		end
	end
end

--This function returns the proper offsets for attachElements (from the original glue resource)
function calculateOffsets(slaveElement, masterElement)
	local px, py, pz = getElementPosition(slaveElement)
	local vx, vy, vz = getElementPosition(masterElement)
	local sx = px - vx
	local sy = py - vy
	local sz = pz - vz
	
	local rotpX, rotpY, rotpZ
	if getElementType(slaveElement) == "vehicle" then
		rotpX, rotpY, rotpZ = getElementRotation(slaveElement)
	else
		rotpX, rotpY, rotpZ = 0, 0, getPedRotation(slaveElement)
	end
					
	local rotvX,rotvY,rotvZ = getElementRotation(masterElement)
			
	local t = math.rad(rotvX)
	local p = math.rad(rotvY)
	local f = math.rad(rotvZ)
			
	local ct = math.cos(t)
	local st = math.sin(t)
	local cp = math.cos(p)
	local sp = math.sin(p)
	local cf = math.cos(f)
	local sf = math.sin(f)
			
	local z = ct*cp*sz + (sf*st*cp + cf*sp)*sx + (-cf*st*cp + sf*sp)*sy
	local x = -ct*sp*sz + (-sf*st*sp + cf*cp)*sx + (cf*st*sp + sf*cp)*sy
	local y = st*sz - sf*ct*sx + cf*ct*sy
			
	local rotX = rotpX - rotvX
	local rotY = rotpY - rotvY
	local rotZ = rotpZ - rotvZ

	return x, y, z, rotx, roty, rotz
end

addCommandHandler("glue", onGlueButtonPressed)	