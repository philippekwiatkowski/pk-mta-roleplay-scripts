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

local leaveTimer = { }

--------- [ Bus Job ] ---------
function onEnterBus( vehicle, seat )
	if (getData(vehicle, "job") == 2 and getData(source, "job") ~= 2) then -- The vehicle & player are not allowed to do bus job
		
		removePedFromVehicle(source)
		return
	elseif (getData(vehicle, "job") == 2 and getData(source, "job") == 2) then
	
		if (seat == 0) then		-- They are the driver
			
			outputChatBox("Type /jobhelp if you need help regarding your job!", source, 0, 255, 0)
			
			if (getData(vehicle, "engine") == 0) then -- Incase they are new and don't know whats wrong..
				
				outputChatBox("Press J to start the vehicle's engine.", source, 219, 105, 29)
			end
			
			triggerClientEvent(source, "startBusJob", source)
		end
	end	
end
addEventHandler("onPlayerVehicleEnter", root, onEnterBus)

function onExitBus( vehicle, seat )
	if (getData(vehicle, "job") == 2 and getData(source, "job") == 2) then
		
		if (seat == 0) then	-- They were in the driver's seat
			
			if isTimer(leaveTimer[source]) then	-- They got out before 15 seconds after the run was complete
				killTimer(leaveTimer[source])
			
				leaveTimer[source] = nil
				return							-- Stop here!
			end
			
			triggerClientEvent(source, "endBusJob", source)	-- They got out in the middle
		end
	end
end	
addEventHandler("onPlayerVehicleExit", root, onExitBus)

--------- [ Client Call Backs ] ---------
function getRouteInformation(  )

	local xml = xmlLoadFile("bus/route.xml")
	local one = xmlFindChild(xml, "one", 0)
	local two = xmlFindChild(xml, "two", 0)
	
	local childrenOne = xmlNodeGetChildren(one)
	local childrenTwo = xmlNodeGetChildren(two)
	
	local route = { }
	route[1] = { }
	route[2] = { }
	
	for i, node in ipairs (childrenOne) do    

		local x, y, z = xmlNodeGetAttribute(node, "x"), xmlNodeGetAttribute(node, "y"), xmlNodeGetAttribute(node, "z")
		local isStop = xmlNodeGetAttribute(node, "stop")
		
		route[1][i] = { tonumber(x), tonumber(y), tonumber(z), isStop }
	end
	
	 for i, node in ipairs (childrenTwo) do    
	 
		local x, y, z = xmlNodeGetAttribute(node, "x"), xmlNodeGetAttribute(node, "y"), xmlNodeGetAttribute(node, "z")
		local isStop = xmlNodeGetAttribute(node, "stop")
		
		route[2][i] = { tonumber(x), tonumber(y), tonumber(z), isStop }
	end 
	
	triggerClientEvent(source, "giveRouteInformation", source, route)
	
	xmlUnloadFile(xml) 
end	
addEvent("getRouteInformation", true)
addEventHandler("getRouteInformation", root, getRouteInformation)

-- They must get out of the vehicle before 15 seconds after finishing the run
function busAbandonTimer( )
	outputChatBox("You have 15 seconds to get out of your vehicle.", source, 83, 236, 220)
	outputChatBox("Re-enter the vehicle to start another run.", source, 83, 236, 220)
	
	leaveTimer[source] = setTimer(removePedFromVehicle, 15000, 1, source)
end
addEvent("busAbandonTimer", true)
addEventHandler("busAbandonTimer", root, busAbandonTimer)

-- Pay the bus driver
function payBus( amount )
	givePlayerMoney(source, amount)
	triggerEvent("takeMoneyFromGovernment", source, amount/100)
end
addEvent("payBusDriver", true)
addEventHandler("payBusDriver", root, payBus)