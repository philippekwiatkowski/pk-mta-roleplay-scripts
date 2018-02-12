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

--------- [ Vehicle Towing ] ---------
local garageGate = nil

addEventHandler("onResourceStart", resourceRoot,
	function( res )
		garageGate = createColCuboid(-1872.5242, -138.5156, 10.8984, 3, 8.5, 4)
	end
)	

function enterTowingGarage( hitElement, matchingDimension )
	if ( matchingDimension ) and ( source == garageGate ) then
		if ( hitElement ) and ( getElementType( hitElement ) == "vehicle" ) then
		
			if ( getElementModel( hitElement ) == 525 ) then -- Towtruck
				
				local towedVehicle = getVehicleTowedByVehicle( hitElement )
				if ( towedVehicle ) then
					
					local update = sql:query("UPDATE `vehicles` SET `engine`='0', `locked`='0', `enginebroke`='1', `Impounded`='1' WHERE `id`=".. sql:escape_string( tonumber( getData( towedVehicle, "dbid" ) ) ) .."")
					if ( update ) then
						
						setVehicleLocked( towedVehicle, false )
						setVehicleEngineState( towedVehicle, false )
						
						setData( towedVehicle, "engine", 0, true )
						setData( towedVehicle, "locked", 0, true )
						setData( towedVehicle, "enginebroke", 1, true )
						setData( towedVehicle, "impounded", 1, true )
						
						outputChatBox("Remember to /park the vehicle, prevent clustering of vehicles as it may cause lag.", getVehicleController( hitElement ), 212, 156, 49)
					end	
					
					sql:free_result(update)
				end	
			end
		end
	end	
end
addEventHandler("onColShapeHit", root, enterTowingGarage)

local releasePoints = {	}
releasePoints[1] = { -1831.8378, -110.6933, 5.3812, 89 }
releasePoints[2] = { -1839.2880, -110.4804, 5.3548, 89 }
releasePoints[3] = { -1846.5117, -110.5039, 5.3795, 90 }
	
local takenOne, takenTwo, takenThree = false, false, false
	
function releaseVehicle( vehicleID )
	if ( vehicleID ) then
		
		local vehicleID = tonumber( vehicleID )
		
		for key, theVehicle in ipairs ( getElementsByType("vehicle" ) ) do
			
			if ( tonumber( getData( theVehicle, "dbid") ) == vehicleID ) then
				
				local update = sql:query("UPDATE `vehicles` SET `enginebroke`='0', `Impounded`='0' WHERE `id`=".. sql:escape_string( vehicleID ) .."")
				if ( update ) then
					
					setVehicleEngineState( theVehicle, false )
					setVehicleLocked( theVehicle, false )
					
					setData( theVehicle, "engine", 0, true )
					setData( theVehicle, "enginebroke", 0, true )
					setData( theVehicle, "impounded", 0, true )
					
					fixVehicle( theVehicle )
					
					local x, y, z = nil, nil, nil
					if ( not takenOne ) then
						
						x, y, z, rot = unpack( releasePoints[1] )
						takenOne = true
					elseif ( not takenTwo ) then
						
						x, y, z, rot = unpack( releasePoints[2] )
						takenTwo = true
					elseif ( not takenThree ) then
						
						x, y, z, rot = unpack( releasePoints[3] )
						takenThree = true	
					end
					
					setElementPosition( theVehicle, x, y, z )
					setElementRotation( theVehicle, 0, 0, rot )
					
					local park = sql:query("UPDATE vehicles SET `x`=".. sql:escape_string(x) ..", `y`=".. sql:escape_string(y) ..", `z`=".. sql:escape_string(z) ..", `rotx`='0', `roty`='0', `rotz`=".. sql:escape_string(rot) ..", dimension='0', interior='0' WHERE `id`=".. sql:escape_string(vehicleID) .."")
					if ( park ) then
						
						takePlayerMoney( source, 150*100 )
						giveMoneyToVs( 150 )
						
						outputChatBox("Your ".. getVehicleName( theVehicle ) .." has be released.", source, 0, 255, 0)
						outputChatBox("Please remember to /park it after taking it from outside.", source, 0, 255, 0)
					else
						outputDebugString("SQL Error: Unable to park released vehicle!")
						outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
					end
					
					break
				else
					outputDebugString("SQL Error: Unable to reset released vehicle!")
					outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
					
					break
				end
				
				sql:free_result(update)
			end
		end
	end	
end
addEvent("releaseVehicle", true)
addEventHandler("releaseVehicle", root, releaseVehicle)

setTimer(
	function( )
	
		takenOne, takenTwo, takenThree = false, false, false
	end, 300000, 0
)	

function giveMoneyToVs( amount )
	local amount = tonumber( amount )*100
	
	local result = sql:query_fetch_assoc("SELECT `balance` FROM `factions` WHERE `id`='4'")
	if ( result ) then
	
		local balance = tonumber( result['balance'] )
		local totalGain = balance + amount
		
		local update = sql:query("UPDATE `factions` SET `balance`=".. sql:escape_string(totalGain) .." WHERE `id`='4'")
		if ( not update ) then	
			outputDebugString("MySQL Error: Unable to update LSVS money!", 1)
			outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
		else
			setData( getTeamFromName("San Fierro Vehicle Services"), "balance", totalGain, true)
		end	
		
		sql:free_result(update)
	end	
end
addEvent("giveMoneyToVs", true)
addEventHandler("giveMoneyToVs", root, giveMoneyToVs)