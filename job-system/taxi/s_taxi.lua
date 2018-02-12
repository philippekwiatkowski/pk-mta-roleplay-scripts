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

--------- [ Taxi Job ] ---------
function onEnterTaxi( vehicle, seat )
	if (getData(vehicle, "job") == 3 and getData(source, "job") ~= 3 and seat == 0) then 											-- The vehicle & player are not allowed to do taxi job
	
		removePedFromVehicle(source)
		return	
	elseif (getData(vehicle, "job") == 3 and getData(source, "job") == 3) then
	
		if (seat == 0) then																											-- They are the driver
			
			outputChatBox("Type /jobhelp if you need help regarding your job!", source, 0, 255, 0)
			
			if (getData(vehicle, "engine") == 0) then 																				-- Incase they are new and don't know whats wrong..
				
				outputChatBox("Press J to start the vehicle's engine.", source, 219, 105, 29)
			end
		end
	end	
end
addEventHandler("onPlayerVehicleEnter", root, onEnterTaxi)