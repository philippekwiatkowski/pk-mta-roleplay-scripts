function getPositionFromElementAtOffset(element,x,y,z)
	if not x or not y or not z then      
		return x, y, z   
	end        
	local matrix = getElementMatrix ( element )
	local offX = x * matrix[1][1] + y * matrix[2][1] + z * matrix[3][1] + matrix[4][1]
	local offY = x * matrix[1][2] + y * matrix[2][2] + z * matrix[3][2] + matrix[4][2]
	local offZ = x * matrix[1][3] + y * matrix[2][3] + z * matrix[3][3] + matrix[4][3]
	return offX, offY, offZ
end

function getVehicleWheelPosition(vehicle,wheel)
	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
	if (vehicle) then
		local x, y, z = 0, 0, 0
		local minX, minY, minZ, maxX, maxY, maxZ = getElementBoundingBox(vehicle)
		if wheel == 1 then
			x, y, z = getPositionFromElementAtOffset(vehicle, minX, maxY, minZ)
		elseif wheel == 2 then
			x, y, z = getPositionFromElementAtOffset(vehicle, minX, -maxY, minZ)		
		elseif wheel == 3 then
			x, y, z = getPositionFromElementAtOffset(vehicle, maxX, maxY, minZ)
		elseif wheel == 4 then
			x, y, z = getPositionFromElementAtOffset(vehicle, maxX, -maxY, minZ)
		end	 
		return x, y, z
	end	
end

function onClientRender()
	if isPedInVehicle(getLocalPlayer()) then	
	 	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		
		local wx1, wy1, wz1 = getVehicleWheelPosition(vehicle,1)
		local wx2, wy2, wz2 = getVehicleWheelPosition(vehicle,2)
		local wx3, wy3, wz3 = getVehicleWheelPosition(vehicle,3)
		local wx4, wy4, wz4 = getVehicleWheelPosition(vehicle,4)
		
		for k, v in ipairs (getElementsByType("object")) do
			if (getElementModel(v) == 2899) then
				local vx, vy, vz = getElementPosition(v)
				if getDistanceBetweenPoints3D(wx1, wy1, wz1, vx, vy, vz) <= 2.0 then
					setVehicleWheelStates(vehicle, 1, -1, -1, -1)	
				end
				if getDistanceBetweenPoints3D(wx2, wy2, wz2, vx, vy, vz) <= 2.0 then
					setVehicleWheelStates(vehicle, -1, 1, -1, -1)	
				end
				if getDistanceBetweenPoints3D(wx3, wy3, wz3, vx, vy, vz) <= 2.0 then
					setVehicleWheelStates(vehicle, -1, -1, 1, -1)	
				end
				if getDistanceBetweenPoints3D(wx4, wy4, wz4, vx, vy, vz) <= 2.0 then
					setVehicleWheelStates(vehicle, -1, -1, -1, 1)	
				end		
			end										
		end
	 end
end
addEventHandler("onClientRender",getRootElement(), onClientRender)
