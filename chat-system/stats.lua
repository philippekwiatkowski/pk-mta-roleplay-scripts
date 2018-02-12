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
	if isElement(theElement) and (key) and (value) then
		
		return exports['[ars]anticheat-system']:assignData( theElement, tostring(key), value, sync )
	else
		return false
	end	
end

-- /stats
function showPlayerStats( thePlayer, commandName, partialPlayerName )
	local drivingLicense, hoursPlayed, vehicles, properties = nil
	
	if ( partialPlayerName ) then
		
		if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
			
			local players = exports['[ars]global']:findPlayer( thePlayer, partialPlayerName )
			
			if #players == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #players > 1 then
				outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
				
				local count = 0
				for k, foundPlayer in ipairs (players) do
					
					count = count + 1
					outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayer in ipairs (players) do
					
					outputChatBox("~-~-~-~-~~-~ Stats: ".. getPlayerName( foundPlayer ):gsub("_", " ") .." ~-~-~-~-~~-~", thePlayer, 212, 156, 49)
					outputStats( thePlayer, getPlayerStats( foundPlayer ) )
				end
			end	
		end
	else
		outputChatBox("~-~-~-~-~~-~ Stats: ".. getPlayerName( thePlayer ):gsub("_", " ") .." ~-~-~-~-~~-~", thePlayer, 212, 156, 49)
		outputStats( thePlayer, getPlayerStats( thePlayer ) )
	end	
end
addCommandHandler("stats", showPlayerStats, false, false)

function outputStats( thePlayer, drivingLicense, hoursPlayed, vehicles, properties )
	if ( drivingLicense ) and ( hoursPlayed ) and ( vehicles ) and ( properties ) then
	
		local licenseText = ""
		if ( drivingLicense == 1 ) then
			licenseText = "#00FF00Obtained"
		else
			licenseText = "#FF0000Unobtained"
		end
			
		local vehicleText = "#FF0000None"
		local vehCount = 0
		for key, value in pairs ( vehicles ) do
			if ( vehCount == 0 ) then
				vehicleText = "#00FF00".. getVehicleName( value ) .." (".. key ..")"
			else
				vehicleText = vehicleText ..", ".. getVehicleName( value ) .." (".. key ..")"
			end
		
			vehCount = vehCount + 1
		end
		
		local propertyText = "#FF0000None"
		local propertyCount = 0
		for key, value in pairs ( properties ) do
			if ( propertyCount == 0 ) then
				propertyText = "#00FF00".. key 
			else
				propertyText = propertyText ..", ".. key
			end
		
			propertyCount = propertyCount + 1
		end
			
		outputChatBox("Driving License: ".. licenseText, thePlayer, 212, 156, 49, true)
		outputChatBox("Time spent on this character: #00FF00".. tostring( hoursPlayed ) .." hours", thePlayer, 212, 156, 49, true)
		outputChatBox("Vehicles (".. vehCount .."): ".. vehicleText, thePlayer, 212, 156, 49, true)
		outputChatBox("Properties (".. propertyCount .."): ".. propertyText, thePlayer, 212, 156, 49, true)
	end	
end


function getPlayerStats( thePlayer )
	local result = sql:query_fetch_assoc("SELECT `drivinglicense` FROM `characters` WHERE `charactername`='".. sql:escape_string( tostring( getPlayerName(thePlayer):gsub("_", " ") ) ) .."'")
	if ( result ) then
		
		local drivingLicense = tonumber( result['drivinglicense'] )
		local hoursPlayed = tonumber( getData(thePlayer, "hoursplayed" ) )
		
		local vehicles = { }
		for key, theVehicle in ipairs ( getElementsByType("vehicle") ) do
			
			local dbid = tonumber( getData( thePlayer, "dbid" ) )
			if ( tonumber( getData( theVehicle, "owner" ) ) == dbid ) then
				
				vehicles[tonumber( getData( theVehicle, "dbid" ) )] = theVehicle
			end
		end
			
		local properties = { }
		for key, theProperty in ipairs ( getElementsByType("marker") ) do
			
			local dbid = tonumber( getData( thePlayer, "dbid" ) )
			local elevator = tonumber( getData( theProperty, "elevator" ) )
			if ( getElementChild( theProperty, 0 ) and elevator == 0 ) then -- Parent
			
				if ( tonumber( getData( theProperty, "owner" ) ) == dbid ) then
				
					properties[tonumber( getData( theProperty, "dbid" ) )] = tostring( getData( theProperty, "name") )
				end	
			end
		end
		
		return drivingLicense, hoursPlayed, vehicles, properties
	end	
end	