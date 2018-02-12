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

--------- [ Storage System ] ---------
function updateObjectInventory( theObject, objectItems, objectValues )
	setData(theObject, "items", tostring(objectItems), true)
	setData(theObject, "values", tostring(objectValues), true)
	
	if ( getElementType( theObject ) == "vehicle" ) then
		local update = sql:query("UPDATE `vehicles` SET `items`='".. sql:escape_string(objectItems) .."', `itemvalues`='".. sql:escape_string(objectValues) .."' WHERE `id`=".. sql:escape_string(tonumber(getData(theObject, "dbid"))) .."")
		if ( not update ) then
			outputDebugString("MySQL Error: Unable to save vehicle inventory!", 1)
			outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
		end
		
		sql:free_result(update)
	else
		local update = sql:query("UPDATE `worlditems` SET `items`='".. sql:escape_string(objectItems) .."', `itemvalues`='".. sql:escape_string(objectValues) .."' WHERE `id`=".. sql:escape_string(tonumber(getData(theObject, "dbid"))) .."")
		if ( not update ) then
			outputDebugString("MySQL Error: Unable to save object inventory!", 1)
			outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
		end
		
		sql:free_result(update)
	end
	
	-- Tell
	for key, value in ipairs ( getElementsByType("player") ) do
		if ( value ~= source ) then
			
			triggerClientEvent(value, "populateStorageGridLists", value, true, theObject)
		end
	end	
end
addEvent("updateObjectInventory", true)
addEventHandler("updateObjectInventory", root, updateObjectInventory)

function takePlayerWeapon( weaponID )
	takeWeapon( source, weaponID*-1 )
	triggerClientEvent( source, "reloadInventory", source )
end
addEvent("takePlayerWeapon", true)
addEventHandler("takePlayerWeapon", root, takePlayerWeapon)

function givePlayerWeapon( weaponID, weaponAmmo )
	giveWeapon( source, weaponID*-1, weaponAmmo )
	triggerClientEvent( source, "reloadInventory", source )
end
addEvent("givePlayerWeapon", true)
addEventHandler("givePlayerWeapon", root, givePlayerWeapon)	