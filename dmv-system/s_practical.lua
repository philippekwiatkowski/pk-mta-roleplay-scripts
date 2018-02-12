local sql = exports.sql

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

--------- [ Department of Motor Vehicles ] ---------
local students = { }

function enterTestVehicle( vehicle, seat )
	if ( getData(vehicle, "job") == 10 ) then -- DMV vehicle
		if ( students[source] ) then
	
			if (seat == 0) then
				
				outputChatBox("Follow the checkpoints to complete your Driving Test.", source, 212, 156, 49)
			
				if (getData(vehicle, "engine") == 0) then
					outputChatBox("Press J to start the vehicle's engine.", source, 231, 60, 128)
				end
				
				triggerClientEvent(source, "startDrivingTest", source)
			end
		else
			outputChatBox("This vehicle is for Driving Test only.", source, 255, 0, 0)
			removePedFromVehicle( source )
		end	
	end	
end
addEventHandler("onPlayerVehicleEnter", root, enterTestVehicle)

function exitTestVehicle( vehicle, seat )
	if ( getData(vehicle, "job") == 10 ) then -- DMV vehicle
		if (seat == 0) then
			
			setVehicleEngineState( vehicle, false )
			setVehicleOverrideLights( vehicle, 1 )
			
			triggerEvent("respawnRemoteVehicle", source, vehicle)
			
			removePlayerStudent( source )
			triggerClientEvent( source, "endDrivingTest", source )
		end	
	end			
end
addEventHandler("onPlayerVehicleExit", root, exitTestVehicle)

-- ## Call Backs
function givePlayerDrivingLicense( )
	local update = sql:query("UPDATE `characters` SET `drivinglicense`='1' WHERE `charactername`='".. sql:escape_string(getPlayerName(source):gsub("_", " ")) .."'")
	if ( update ) then
		
		removePlayerStudent( source )
		setData(source, "d:license", 1, true)
	else
		outputDebugString("MySQL Error: Unable to update license!")
		outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
	end
	
	sql:free_result(update)
end
addEvent("givePlayerDrivingLicense", true)
addEventHandler("givePlayerDrivingLicense", root, givePlayerDrivingLicense)

function setPlayerStudent( )
	students[source] = true
end
addEvent("setPlayerStudent", true)
addEventHandler("setPlayerStudent", root, setPlayerStudent)	

function removePlayerStudent( thePlayer )
	students[thePlayer] = nil
end
addEvent("removePlayerStudent", true)
addEventHandler("removePlayerStudent", root, removePlayerStudent)		