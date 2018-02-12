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

--------- [ Vehicle Repairing ] ---------
function repairVehicle( theVehicle )
	if ( isElement( theVehicle ) ) then
		
		fixVehicle( theVehicle )
		takeMoneyFromVs( 50 )
		
		outputChatBox("Vehicle repaired for $50", source, 212, 156, 49)
	end	
end
addEvent("repairVehicle", true)
addEventHandler("repairVehicle", root, repairVehicle)

function refuelVehicle( theVehicle )
	if ( isElement( theVehicle ) ) then
		
		setData( theVehicle, "fuel", 151, true)
		takeMoneyFromVs( 100 )
		
		outputChatBox("Vehicle refuelled for $100", source, 212, 156, 49)
	end
end
addEvent("refuelVehicle", true)
addEventHandler("refuelVehicle", root, refuelVehicle)

function repaintVehicle( theVehicle, color1, color2 )
	if ( isElement( theVehicle ) ) then
		
		if ( not color2 ) then
			setVehicleColor(theVehicle, unpack( color1 ))
			setData( theVehicle, "custom_color", 1, true)
		else
			setVehicleColor(theVehicle, color1, color2, 0, 0)
			setData( theVehicle, "custom_color", 0, true)
		end
		
		takeMoneyFromVs( 300 )
		
		outputChatBox("Vehicle painted for $300", source, 212, 156, 49)
	end
end
addEvent("repaintVehicle", true)
addEventHandler("repaintVehicle", root, repaintVehicle)

function addVehicleModification( theVehicle, upgradeID, upgradeName, upgradePrice )
	if ( isElement( theVehicle ) ) then
		
		local success = addVehicleUpgrade( theVehicle, tonumber( upgradeID ) ) 
		if ( success ) then
			
			outputChatBox(tostring( upgradeName ).. " added to ".. getVehicleName( theVehicle ) .." for $".. tostring( upgradePrice ), source, 212, 156, 49)
			
			local upgrades = ""
			local t = getVehicleUpgrades( theVehicle )
			
			if ( #t > 0 ) then
				for key, value in ipairs ( t ) do
					
					upgrades = upgrades .. value .. ","
				end
			end	
			
			local update = sql:query("UPDATE `vehicles` SET `upgrades`='".. sql:escape_string( tostring( upgrades ) ) .."' WHERE `id`=".. sql:escape_string( tonumber( getData( theVehicle, "dbid" ) ) ) .."")
			sql:free_result(update)
			
			triggerClientEvent(source, "updateVehicleUpgrades", source, t )
			takeMoneyFromVs( tonumber( upgradePrice ) )
		end	
	end
end
addEvent("addVehicleModification", true)
addEventHandler("addVehicleModification", root, addVehicleModification)

--------- [ Miscellaneous Functions ] ---------
function takeMoneyFromVs( amount )
	local amount = tonumber( amount )*100
	
	if ( amount > 0 ) then
		
		local result = sql:query_fetch_assoc("SELECT `balance` FROM `factions` WHERE `id`='4'")
		if ( result ) then
			
			local balance = tonumber( result['balance'] )
			local totalLoss = balance - amount
		
			local update = sql:query("UPDATE `factions` SET `balance`=".. sql:escape_string(totalLoss) .." WHERE `id`='4'")
			if ( not update ) then
				outputDebugString("MySQL Error: Unable to update LSVS money!", 1)
				outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
			else
				setData( getTeamFromName("Bone County Vehicle Services"), "balance", totalLoss, true)
			end
			
			sql:free_result(update)
		end	
	end	
end