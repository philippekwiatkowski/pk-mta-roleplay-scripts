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

function editHandling ()

	-- Bike
	
	setModelHandling (509, "maxVelocity", 40)
	setModelHandling (509, "engineInertia", 5)
	setModelHandling (509, "engineAcceleration", 5)
	
	-- BMX
	
	setModelHandling (481, "maxVelocity", 40)	
	setModelHandling (481, "engineInertia", 5)	
	setModelHandling (481, "engineAcceleration", 5)
	
	-- Mountain Bike
	
	setModelHandling (510, "maxVelocity", 40)
	setModelHandling (510, "engineInertia", 5)
	setModelHandling (510, "engineAcceleration", 5)
	
	-- HPV1000

	setModelHandling (523, "maxVelocity", 200)

	-- FBI Rancher
	
	setModelHandling(490, "maxVelocity", 155.0)
	setModelHandling(596, "collisionDamageMultiplier", 0.4)

	-- FBI Truck

	setModelHandling(528, "maxVelocity", 140.0)
	setModelHandling(528, "collisionDamageMultiplier", 0.3)
	
	-- Police LS
	
	setModelHandling(596, "maxVelocity", 250.0)
	setModelHandling(596, "collisionDamageMultiplier", 0.4)
	
	-- Police SF
	
	setModelHandling(597, "maxVelocity", 250.0)
	setModelHandling(597, "collisionDamageMultiplier", 0.4)
	
	-- Police LV
	
	setModelHandling(598, "maxVelocity", 250.0)
	setModelHandling(598, "collisionDamageMultiplier", 0.4)
	
	-- Police Ranger
	
	setModelHandling(599, "maxVelocity", 180.0)
	setModelHandling(599, "collisionDamageMultiplier", 0.4)
	
	-- S.W.A.T
	
	setModelHandling(601, "maxVelocity", 120.0)
	setModelHandling(601, "collisionDamageMultiplier", 0.3)
	
	-- BCSD Premier #1
	
	for i, vehicle in ipairs ( getElementsByType("vehicle") ) do
		
		local dbid = getData(vehicle, "dbid")
		if tonumber(dbid) == 294 then
					
			theVehicle = vehicle
			break
		end
	end
	
	if (theVehicle) then
		setVehicleHandling(theVehicle, "maxVelocity", 200.0)
		setVehicleHandling(theVehicle, "engineAcceleration", 12.0)
	end
end
addEventHandler ("onResourceStart", getRootElement(), editHandling)