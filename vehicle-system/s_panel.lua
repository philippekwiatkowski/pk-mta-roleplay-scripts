function toggleDoor (value)

	local vehicle = getPedOccupiedVehicle (source)

	if (value == 1) then	
	
		if getVehicleDoorOpenRatio (vehicle, 0) == 0 then
			setVehicleDoorOpenRatio (vehicle, 0, 1, 500)
		else
			setVehicleDoorOpenRatio (vehicle, 0, 0, 500)
		end
	elseif (value == 2) then	
	
		if getVehicleDoorOpenRatio (vehicle, 1) == 0 then
			setVehicleDoorOpenRatio (vehicle, 1, 1, 500)
		else
			setVehicleDoorOpenRatio (vehicle, 1, 0, 500)
		end	
	elseif (value == 3) then
	
		if getVehicleDoorOpenRatio (vehicle, 2) == 0 then
			setVehicleDoorOpenRatio (vehicle, 2, 1, 500)
		else
			setVehicleDoorOpenRatio (vehicle, 2, 0, 500)
		end
	elseif (value == 4) then
		
		if getVehicleDoorOpenRatio (vehicle, 4) == 0 then
			setVehicleDoorOpenRatio (vehicle, 4, 1, 500)
		else
			setVehicleDoorOpenRatio (vehicle, 4, 0, 500)
		end
	elseif (value == 5) then
	
		if getVehicleDoorOpenRatio (vehicle, 3) == 0 then
			setVehicleDoorOpenRatio (vehicle, 3, 1, 500)
		else
			setVehicleDoorOpenRatio (vehicle, 3, 0, 500)
		end	
	elseif (value == 6) then
	
		if getVehicleDoorOpenRatio (vehicle, 5) == 0 then
			setVehicleDoorOpenRatio (vehicle, 5, 1, 500)
		else
			setVehicleDoorOpenRatio (vehicle, 5, 0, 500)
		end	
	end
end
addEvent("toggleDoor", true)
addEventHandler("toggleDoor", getRootElement(), toggleDoor)