local sql = exports.sql
local items = { }
local values = { }

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

--------- [ Data Fetching ] ---------
function callInventoryData( )
	
	items[source] = nil
	values[source] = nil
	
	if (not items[source]) or (not values[source]) then 
		items[source] = { } 
		values[source] = { }
	end
		
	local itemData = ""
	local valueData = ""
	
	local result = sql:query_fetch_assoc("SELECT items, itemvalues FROM characters WHERE id=".. sql:escape_string(getData(source, "dbid")) .."")
	if (result) then
		itemData = result['items']
		valueData = result['itemvalues']
	end
	
	-- Split 'em
	local item = { }
	local value = { }
	if (tostring(itemData) ~= "") and (tostring(valueData) ~= "") then
		item = split(itemData, string.byte(","))
		value = split(valueData, string.byte(","))
	end
	
	-- We try to keep our inventory updated
	local i = 1
	local tlength = #item or #value
	while true do
		if (i > tlength) then break end
		
		items[source][i] = tonumber(item[i])
		values[source][i] = tostring(value[i])
		
		i = i + 1
	end
	
	-- Sent
	triggerClientEvent(source, "giveInventoryItems", source, items[source], values[source])
end
addEvent("callInventoryData", true)
addEventHandler("callInventoryData", getRootElement(), callInventoryData)

-- We call only once,
addEvent("onClientStart", true)
addEventHandler("onClientStart", getRootElement(),
function(  )
	if (getData(source, "loggedin") == 1) then
		triggerEvent("callInventoryData", source)
	end	
end)

addEvent("getInventoryItems", true)
addEventHandler("getInventoryItems", getRootElement(),
function( )
	triggerEvent("callInventoryData", source)
end)

--------- [ Various Functions ] ---------
function giveItem(thePlayer, itemID, itemValue) 
	if (thePlayer) and (itemID) then
		if (not itemValue) then itemValue = 1 end
		
		if (g_items[itemID]) then
			
			local pass = false
			if ( itemID == 1 or itemID == 2 ) then
				
				pass = true
			else	
				local totalItems = 0
				
				if (#items[thePlayer] > 0) then
				
					for k, v in pairs ( items[thePlayer] ) do
						if ( tonumber( v ) > 2 ) then -- Not keys
							
							totalItems = totalItems + 1
						end
					end	
					
					if ( totalItems < 10 ) then
						
						pass = true
					else
						pass = false
					end
				else
					pass = true
				end	
			end	
			
			if ( pass ) then
				
				items[thePlayer][#items[thePlayer]+1] = tonumber(itemID)
				values[thePlayer][#values[thePlayer]+1] = tostring(itemValue:gsub(",", ";"))
				
				-- Add Item
				local _, itemName = getItemDetails(itemID)
				
				triggerClientEvent(thePlayer, "addInventoryItem", thePlayer, itemName, itemValue)
				
				return true, g_items[itemID][1]
			else
				return false, "inventory is full"
			end	
		else
			return false, "invalid Item ID"
		end	
	else
		return false, "insufficient Parameters"
	end	
end
addEvent("giveItem", true)
addEventHandler("giveItem", getRootElement(), giveItem)

function takeItem(thePlayer, itemID, itemValue)
	if (thePlayer) and (itemID) then
		
		local found = false
		
		if (#items[thePlayer] > 0) then
			for i, v in pairs(items[thePlayer]) do
				
				if (not itemValue) then -- If the itemValue is not given 
					
					if (tonumber(v) == tonumber(itemID)) then -- Just look for the itemID and delete the first index thats found
						
						table.remove(items[thePlayer], i)
						table.remove(values[thePlayer], i)
						
						found = true
						break
					end	
				
				elseif (itemValue) then -- If the itemValue is given 
					
					if ( tonumber(v) == tonumber(itemID) ) and ( tostring(itemValue) == tostring(values[thePlayer][i]) ) then -- Look for the itemID and the itemValue and delete the matching index
						
						table.remove(items[thePlayer], i)
						table.remove(values[thePlayer], i)
						
						found = true
						break
					end	
				end
			end
		else
			return false
		end	
		
		-- Removed client side too!
		if ( not itemValue ) then
			itemValue = false
		end

		triggerClientEvent(thePlayer, "removeInventoryItem", thePlayer, itemID, itemValue)
		
		return found, g_items[itemID][1]
	else
		return false
	end
end	
addEvent("takeItem", true)
addEventHandler("takeItem", getRootElement(), takeItem)

function hasItem(thePlayer, itemID, itemValue)
	if (thePlayer) and (itemID) then
		
		local found = false
		local valueMatch = false
		
		if ( #items[thePlayer] > 0 ) then
			
			for i, v in pairs(items[thePlayer]) do
				if tonumber(v) == tonumber(itemID) then
						
					found = true
					
					if (itemValue) then
						if ( tostring(values[thePlayer][i]) == tostring(itemValue) ) then
								
							valueMatch = true
							break
						end
					else
						break
					end
				end
			end
			
			return found, valueMatch
		else
			return false
		end
	else
		return false, false
	end	
end
addEvent("hasItem", true)
addEventHandler("hasItem", getRootElement(), hasItem)

function getPlayerInventory( thePlayer )
	return items[thePlayer], values[thePlayer]
end
	
function savePlayerInventory( dbid )
	if ( #items[source] > 0 ) then	-- No need to save empty inventory
	
		local item = table.concat(items[source], ",")
		local value = table.concat(values[source], ",")
		
		local update = sql:query("UPDATE characters SET items='".. sql:escape_string(tostring(item)) .."', itemvalues='".. sql:escape_string(tostring(value)) .."' WHERE id=".. sql:escape_string(dbid) .."")
		if (not update) then
			outputDebugString("MySQL Error: Unable to save inventory!", 1)
			outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
		end
		
		sql:free_result(update)
	
	end	
end
addEvent("savePlayerInventory", true)
addEventHandler("savePlayerInventory", getRootElement(), savePlayerInventory)
	
addEventHandler("onPlayerQuit", resourceRoot,
	function( )
		
		items[source] = nil
		values[source] = nil
	end
)
	
--------- [ Client Side Calls ] ---------

-- Show Item	
function showItemToPlayers( itemName, itemValue )
	local itemName = tostring(itemName)
	local itemValue = tostring(itemValue)
	
	for i, thePlayer in ipairs ( getElementsByType("player") ) do
		local px, py, pz = getElementPosition(thePlayer)
		local x, y, z = getElementPosition(source)
		if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 20) then
			
			outputChatBox(" ** ".. getPlayerName(source):gsub("_", " ") .." shows everyone a ".. itemName .." with value ".. itemValue .."", thePlayer, 127, 88, 205)
		end
	end	
end
addEvent("showItemToPlayers", true)
addEventHandler("showItemToPlayers", getRootElement(), showItemToPlayers)
	
local weaponModels = 
{ 
	[1] = 331, [2] = 333, [3] = 344, [4] = 355, [5] = 336, [6] = 337, [7] = 338, [8] = 339, [9] = 341, [10] = 321, [11] = 322, [12] = 323, [14] = 325, [15] = 326,
	[16] = 342, [17] = 343, [18] = 344, [22] = 346, [23] = 347, [24] = 348, [25] = 349, [26] = 350, [27] = 351, [28] = 352, [29] = 353, [30] = 355, [31] = 356, 
	[32] = 372, [33] = 357, [34] = 358, [35] = 359, [36] = 360, [37] = 361, [38] = 362, [39] = 363, [40] = 364, [41] = 365, [42] = 366, [43] = 367
}

-- Drop Item
function dropItemOnGround( itemName, itemValue, dropPosition )
	local itemName = tostring(itemName)

	local x, y, z = dropPosition[1], dropPosition[2], dropPosition[3]
	local interior, dimension = getElementInterior(source), getElementDimension(source)

	local itemModel, itemID, rx, ry, rz, elevation
	
	local weaponID = tonumber(getWeaponIDFromName(itemName))
	if (weaponID and weaponID > 0) then -- Dropping a weapon
		
		weaponModel = weaponModels[weaponID]
		if (weaponModel) then
			
			itemModel, itemID, rx, ry, rz, elevation = weaponModel, -weaponID, 274, 86, 92, -0.07
			
			local leftAmmo = tonumber(itemValue[2])
			itemValue = itemValue[1]
			
			if ( leftAmmo == 0 ) then
				takeWeapon(source, weaponID)
			else	
				setWeaponAmmo(source, weaponID, tonumber(leftAmmo)) 
			end	
		end	
	else								-- Droping an item
		itemModel, itemID, rx, ry, rz, elevation = getItemDetails( itemName )
		
		if ( interior ~= 0 and dimension ~= 0 ) then
			_, _, z = getElementPosition(source)
			
			if ( itemID == 31 ) then	-- Shelf
				z = z + 3
				
				_, _, rz = getElementRotation(source)
				rz = rz - 90
			else
				z = z - 1
				_, _, rz = getElementRotation(source)
			end
		end	
		
		if ( tonumber(itemModel) == 2332 or tonumber(itemModel) == 3761 ) then
			if ( getElementInterior( source ) == 0 and getElementDimension( source ) == 0 ) then
			
				outputChatBox("You can only drop this item inside an interior.", source, 255, 0, 0)
				return
			end
		end
		
		takeItem(source, itemID, tostring(itemValue):gsub(",", ";"))
	end
	
	local insert = sql:query("INSERT INTO `worlditems` SET x=".. sql:escape_string(x) ..", y=".. sql:escape_string(y) ..", z=".. sql:escape_string(z) ..", `interior`=".. sql:escape_string(interior) ..", `dimension`=".. sql:escape_string(dimension) ..", rx=".. sql:escape_string(rx) ..", ry=".. sql:escape_string(ry) ..", rz=".. sql:escape_string(rz) ..", elevation=".. sql:escape_string(elevation) ..", itemmodel=".. sql:escape_string(itemModel) ..", itemid=".. sql:escape_string(itemID) ..", itemvalue='".. sql:escape_string(itemValue:gsub(",", ";")) .."', droper=".. sql:escape_string(getData(source, "dbid")) .."")		
	if (insert) then
		local insertid = sql:insert_id()
		
		local item = createObject(tonumber(itemModel), x, y, z-elevation, rx, ry, rz)
		setElementInterior(item, interior)
		setElementDimension(item, dimension)
		
		setData(item, "dbid", tonumber(insertid), true)
		setData(item, "droper", tonumber(getData(source, "dbid")), true)
		setData(item, "itemid", tonumber(itemID), true) 
		setData(item, "itemvalue", tostring(itemValue):gsub(",", ";"), true) 
		
		if ( tonumber(itemModel) == 2332 or tonumber(itemModel) == 3761 ) then
			setData(item, "items", "", true)
			setData(item, "values", "", true)
		end
	
		outputChatBox("You dropped a ".. tostring(itemName) ..".", source, 212, 156, 49)
		
		setPedAnimation(source, "CARRY", "putdwn", 500, false, false, true)
		toggleAllControls(source, true, true, true )
	else
		outputDebugString("MySQL Error: Unable to save dropped item!", 1)
		outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
	end
	
	sql:free_result(insert)
end
addEvent("dropItemOnGround", true)
addEventHandler("dropItemOnGround", getRootElement(), dropItemOnGround)
	
-- Pickup Item	
function pickItemFromGround( item )
	local dbid = tonumber(getData(item, "dbid"))
	local itemID = tonumber(getData(item, "itemid"))
	local itemValue = tostring(getData(item, "itemvalue"))
	
	if ( itemID ) then
		
		local itemName, value = nil, "value"
		local success, reason = false, ""
		if (itemID < 0) then 										-- Picking up a weapon
			itemName = tostring(getWeaponNameFromID(itemID*-1))
			
			success = giveWeapon(source, itemID*-1, tonumber(itemValue), true) 
			value = "ammo"
		else														-- Picking up an item														
			if (itemID == 30 or itemID == 31) then
				outputChatBox("You cannot pickup this item.", source, 255, 0, 0)
				return
				
			else
				itemModel, itemName = getItemDetails( itemID )
				success, reason = giveItem(source, itemID, tostring(itemValue))
			end	
		end	
			
		if ( success ) then
			outputChatBox("You picked up a ".. tostring(itemName) .." with ".. value .." ".. tostring(itemValue):gsub(";", ",") ..".", source, 212, 156, 49)
		
			destroyElement(item)
			item = nil
			
			local delete = sql:query("DELETE FROM `worlditems` WHERE id=".. sql:escape_string(dbid) .."")
			if (not delete) then
				outputDebugString("MySQL Error: Unable to remove dropped item!", 1)
				outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
			end	
			
			sql:free_result(delete)
		else
			if ( reason ~= "" ) then
				outputChatBox("Your ".. reason ..".", source, 255, 0, 0)
			end
		end
	end	
end
addEvent("pickItemFromGround", true)
addEventHandler("pickItemFromGround", getRootElement(), pickItemFromGround)	
	
-- Move Item
function moveItemOnGround( theObject, worldX, worldY, worldZ )
	if ( theObject ) then
		moveObject( theObject, 200, worldX, worldY, worldZ )
		
		local dbid = tonumber( getData( theObject, "dbid") )
		local update = sql:query("UPDATE `worlditems` SET `x`=".. sql:escape_string( worldX ) ..", `y`=".. sql:escape_string( worldY ) ..", `z`=".. sql:escape_string( worldZ ) .." WHERE `id`=".. sql:escape_string( dbid ) .."")
		if ( not update ) then
			
			outputDebugString("MySQL Error: Unable to save object position!", 1)
			outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
		end
		
		sql:free_result(update)
	end	
end
addEvent("moveItemOnGround", true)
addEventHandler("moveItemOnGround", getRootElement(), moveItemOnGround)
		
-- Destroy Item	
function destroyItemFromInventory( itemName, itemValue )
	local itemName = tostring(itemName)
	local itemValue = tonumber(itemValue)
	
	local weaponID = tonumber(getWeaponIDFromName(itemName))
	if (weaponID and weaponID > 0) then -- Unrealistic
		
		outputChatBox("You cannot destroy a weapon.", source, 255, 0, 0)
	else	
		local itemModel, itemID = getItemDetails( itemName )
		
		local success = takeItem(source, itemID, itemValue)
		if (success) then
			for i, thePlayer in ipairs ( getElementsByType("player") ) do
				local px, py, pz = getElementPosition(thePlayer)
				local x, y, z = getElementPosition(source)
				if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 20) then
					outputChatBox(" ** ".. getPlayerName(source):gsub("_", " ") .." destroyed a ".. itemName ..".", thePlayer, 127, 88, 205)
				end
			end
		else
			triggerClientEvent(source, "reloadInventory", source)
		end
	end	
end	
addEvent("destroyItemFromInventory", true)
addEventHandler("destroyItemFromInventory", getRootElement(), destroyItemFromInventory)

-- Use Item
function useInventoryItem( itemName, itemValue )
	local itemName = tostring(itemName)
	local itemValue = tostring(itemValue)
	local itemModel, itemID = getItemDetails( itemName )
	
	local itemRemoved = false
	if (itemID == 1) then -- Vehicle Key
	
		outputChatBox("You need this to lock/unlock your vehicles.", source, 212, 156, 49)
	elseif (itemID == 2) then -- House Key
		
		outputChatBox("You need to lock/unlock your properties.", source, 212, 156, 49)
	elseif (itemID == 3) then -- Cell Phone
		
		triggerClientEvent(source, "createPhoneUI", source)
	elseif (itemID == 4) then -- Radio
	
		outputChatBox("A Radio. ( /tuneradio & /r )", source, 212, 156, 49)
	elseif (itemID == 5) then -- Mask
		
		local mask = tonumber(getData(source, "mask"))
		if (mask == 0) then
			
			setPlayerNametagText(source, "Unknown Person(Mask)")
			setData(source, "mask", 1, true)
			
			sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." slips on a mask.")
		elseif (mask == 1) then
			
			local name = getPlayerName(source):gsub("_", " ")
			
			setPlayerNametagText(source, name)
			setData(source, "mask", 0, true)
			
			sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." takes off a mask.")
		end
	elseif (itemID == 6) then -- Clothes
		
		setElementModel(source, tonumber(itemValue))
		sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." changes his ".. itemName ..".")
	elseif (itemID == 7) then -- Hotdog
	
		local health = getElementHealth(source)
		setElementHealth(source, health+20)
		
		takeItem(source, itemID, itemValue)
		
		sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." eats a ".. itemName ..".")
	elseif (itemID == 8) then -- Sandwich	
		
		local health = getElementHealth(source)
		setElementHealth(source, health+20)
		
		takeItem(source, itemID, itemValue)
		
		sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." eats a ".. itemName ..".")
	elseif (itemID == 9) then -- Cookies	
		
		local health = getElementHealth(source)
		setElementHealth(source, health+20)
		
		takeItem(source, itemID, itemValue)
		
		sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." eats a ".. itemName ..".")
	elseif (itemID == 10) then -- Water Bottle	
		
		local health = getElementHealth(source)
		setElementHealth(source, health+40)
		
		takeItem(source, itemID, itemValue)
		
		sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." drinks some water.")
	elseif (itemID == 11) then -- Ice Cream
	
		local health = getElementHealth(source)
		setElementHealth(source, health+10)
		
		takeItem(source, itemID, itemValue)
		
		sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." eats a ".. itemName ..".")
	elseif (itemID == 12) then -- Choco Donut	
		
		local health = getElementHealth(source)
		setElementHealth(source, health+20)
		
		takeItem(source, itemID, itemValue)
		
		sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." eats a ".. itemName ..".")
	elseif (itemID == 13) then -- Sweet Donut	
		
		local health = getElementHealth(source)
		setElementHealth(source, health+20)
		
		takeItem(source, itemID, itemValue)
		
		sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." eats a ".. itemName ..".")	
	elseif (itemID == 14) then -- Buster Pizza	
		
		local health = getElementHealth(source)
		setElementHealth(source, health+20)
		
		takeItem(source, itemID, itemValue)
		
		sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." eats a ".. itemName ..".")	
	elseif (itemID == 15) then -- Double D-Luxe Pizza	
		
		local health = getElementHealth(source)
		setElementHealth(source, health+30)
		
		takeItem(source, itemID, itemValue)
		
		sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." eats a ".. itemName ..".")	
	elseif (itemID == 16) then -- Full Rack Pizza		
		
		local health = getElementHealth(source)
		setElementHealth(source, health+40)
		
		takeItem(source, itemID, itemValue)
		
		sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." eats a ".. itemName ..".")	
	elseif (itemID == 17) then -- Cluckin' Little Meal	
		
		local health = getElementHealth(source)
		setElementHealth(source, health+20)
		
		takeItem(source, itemID, itemValue)
		
		sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." eats a ".. itemName ..".")	
	elseif (itemID == 18) then -- Cluckin' Big Meal	
		
		local health = getElementHealth(source)
		setElementHealth(source, health+30)
		
		takeItem(source, itemID, itemValue)
		
		sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." eats a ".. itemName ..".")		
	elseif (itemID == 19) then -- Cluckin' Huge Meal	
		
		local health = getElementHealth(source)
		setElementHealth(source, health+40)
		
		takeItem(source, itemID, itemValue)
		
		sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." eats a ".. itemName ..".")		
	elseif (itemID == 20) then -- Moo Kids Burger
		
		local health = getElementHealth(source)
		setElementHealth(source, health+20)
		
		takeItem(source, itemID, itemValue)
		
		sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." eats a ".. itemName ..".")				
	elseif (itemID == 21) then -- Beef Tower Burger
		
		local health = getElementHealth(source)
		setElementHealth(source, health+30)
		
		takeItem(source, itemID, itemValue)
		
		sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." eats a ".. itemName ..".")	
	elseif (itemID == 22) then -- Meat Stack Burger
		
		local health = getElementHealth(source)
		setElementHealth(source, health+40)
		
		takeItem(source, itemID, itemValue)
		
		sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." eats a ".. itemName ..".")		
	elseif (itemID == 23) then -- Beer
		
		takeItem(source, itemID, itemValue)
		
		sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." drinks a ".. itemName ..".")
	elseif (itemID == 24) then -- Wine
		
		takeItem(source, itemID, itemValue)
		
		sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." drinks a ".. itemName ..".")
	elseif (itemID == 25) then -- Champagne
		
		takeItem(source, itemID, itemValue)
		
		sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." drinks a ".. itemName ..".")
	elseif (itemID == 26) then -- Coca Cola
		
		local health = getElementHealth(source)
		setElementHealth(source, health+20)
		
		takeItem(source, itemID, itemValue)
		
		sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." drinks a ".. itemName ..".")
	elseif (itemID == 27) then -- Generic Item
		
		sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." shows everyone a ".. itemName .." with value ".. itemValue)
	elseif (itemID == 28) then -- SCUBA Equipment
	
		sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." shows everyone ".. itemName .." with value ".. value)
	elseif (itemID == 29) then -- Boom Box
	
		sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." shows everyone a ".. itemName .."  with value ".. value)
	elseif (itemID == 30) then -- Safe
		
		outputChatBox("Drop this in your house to store items.", source, 212, 156, 49)
	elseif (itemID == 31) then -- Shelf
		
		outputChatBOx("Drop this in your house to store items.", source, 212, 156, 49)
	elseif (itemID == 32 or itemID == 33 or itemID == 34 or itemID == 35) then -- LSPD/LSFD/SANE/LSVS Badge	
		
		local text = ""
		if ( itemID == 32 ) then
			text = "LSPDbadge"
		elseif ( itemID == 33 ) then
			text = "LSFDbadge"
		elseif ( itemID == 34 ) then
			text = "SANEbadge"
		elseif ( itemID == 35 ) then
			text = "LSVSbadge"
		end
		
		local badge = tonumber( getData( source, text ) )
		
		if ( badge == 0 ) then
			setData( source, text, 1, true )
			sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." puts on a ".. itemName ..".")
		else
			setData( source, text, 0, true )
			sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." removes a ".. itemName ..".")
		end
		
		exports['[ars]global']:updateNametagColor(source)
	elseif (itemID >= 36 and itemID <= 41) then	-- Drugs
		
		takeItem(source, itemID, itemValue)
		
		triggerClientEvent(source, "take".. itemName:gsub(" ", ""), source, source)
		sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." takes some ".. itemName ..".")
	elseif (itemID >= 42 and itemID <= 47) then -- Bandanas	
		
		local bandana = tonumber(getData(source, "bandana"))
		if (bandana == 0) then
			
			setPlayerNametagText(source, "Unknown Person(Band)")
			setData(source, "bandana", 1, true)
			
			sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." wraps a ".. itemName .." around his face.")
		elseif (bandana == 1) then
			
			local name = getPlayerName(source):gsub("_", " ")
			
			setPlayerNametagText(source, name)
			setData(source, "bandana", 0, true)
			
			sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." unwraps a ".. itemName .." from his face.")
		end
	elseif (itemID == 51) then -- Lighter
		
		outputChatBox("You need this to light a cigarette.", source, 212, 156, 49)
	elseif (itemID == 52) then -- Cigarette
		
		local lighter = hasItem( source, 51 )
		if ( lighter ) then
			
			exports['[ars]realism-system']:smokeCigarette( source )
			takeItem(source, itemID, itemValue)
		else
			outputChatBox("You need a lighter in order to light a cigarette.", source, 255, 0, 0)
		end	
	elseif (itemID == 53) then -- Card Deck
	
		local cardName = {"Joker", "King", "Queen", "Jack", "10", "9", "8", "7", "6", "5", "4", "3", "2", "Ace" }
		local cardType = {"Diamond", "Hearts", "Spades", "Clubs" }
		
		local randName = cardName[ math.random(1, 14) ]
		if ( randName == "Joker" ) then
			
			randType = ""
		else
			randType = "of ".. cardType[ math.random(1, 4) ]
		end
		
		local text = getPlayerName( source ):gsub("_", " ") .. " shuffles the card deck and takes out a ".. randName .." ".. randType
		
		sendActionToNearbyPlayers( source, text .."." )
	end
end
addEvent("useInventoryItem", true)
addEventHandler("useInventoryItem", getRootElement(), useInventoryItem)

function sendActionToNearbyPlayers( thePlayer, action )
	local action = tostring(action)
	
	for i, nearbyPlayer in ipairs ( getElementsByType("player") ) do
		local px, py, pz = getElementPosition(nearbyPlayer)
		local x, y, z = getElementPosition(thePlayer)
		if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 20) then
			outputChatBox(action, nearbyPlayer, 127, 88, 205)
		end
	end
end
	
-- /movesafe	
function moveSafe( thePlayer, commandName, safeID )
	if ( safeID ) then
		
		local safeID = tonumber( safeID )
		
		local safe = false
		for key, value in ipairs ( getElementsByType("object") ) do
			if ( getElementModel( value ) == 2332 ) then
				
				if ( getElementDimension( value ) == getElementDimension( thePlayer ) and getElementInterior( value ) == getElementInterior( thePlayer ) ) then
					
					local dbid = tonumber( getData( value, "dbid" ) )
					if ( dbid == safeID ) then
						
						safe = value
						break
					end
				end
			end
		end
			
		if ( safe ) then	
			
			local x, y, z = getElementPosition( thePlayer )
			local _, _, rotZ = getElementRotation( thePlayer )
			
			setElementPosition( safe, x, y, z - 0.6)
			setElementRotation( safe, 0, 0, rotZ - 180 )	
			
			setElementPosition( thePlayer, x, y, z + 1)
			
			outputChatBox("Safe moved!", thePlayer, 0, 255, 0)
			
			local update = sql:query("UPDATE `worlditems` SET `x`=".. sql:escape_string( x ) ..", `y`=".. sql:escape_string( y ) ..", `z`=".. sql:escape_string( z - 1 ) ..", `rz`=".. sql:escape_string( rotZ - 180 ) .." WHERE `id`=".. sql:escape_string( tonumber( getData( safe, "dbid" ) ) ) .."")
			if ( not update ) then
				outputDebugString("Unable to save safe position!")
			end	
			
			sql:free_result(update)
		else
			outputChatBox("Invalid Safe ID, use /nearbysafes", thePlayer, 255, 0, 0)
		end	
	else
		outputChatBox("SYNTAX: /".. commandName .." [Safe ID]", thePlayer, 212, 156, 49)
	end	
end
addCommandHandler("movesafe", moveSafe, false, false)

-- /nearbysafes
function nearbySafes( thePlayer )
	if ( getElementDimension( thePlayer ) > 0 ) and ( getElementInterior( thePlayer ) > 0 ) then
		
		outputChatBox("~-~-~-~-~-~-~ Nearby Safes ~-~-~-~-~-~-~", thePlayer, 212, 156, 49)
		
		local count = 0
		for key, value in ipairs ( getElementsByType("object") ) do
			if ( getElementModel( value ) == 2332 ) then
				
				if ( getElementDimension( value ) == getElementDimension( thePlayer ) and getElementInterior( value ) == getElementInterior( thePlayer ) ) then

					count = count + 1
					
					local dbid = tostring( getData( value, "dbid" ) )
					outputChatBox("#".. count .." - ID: ".. dbid ..".", thePlayer, 212, 156, 49)
				end
			end
		end
		
		if ( count == 0 ) then
			outputChatBox("There are no safes nearby by.", thePlayer, 255, 0, 0)
		end	
	end
end
addCommandHandler("nearbysafes", nearbySafes, false, false)

--------- [ Spawn World Items ] ---------
function spawnWorldItems( res )
	local result = sql:query("SELECT id, x, y, z, interior, dimension, rx, ry, rz, elevation, itemmodel, itemid, itemvalue, droper, `items`, `itemvalues` FROM `worlditems`")
	while true do
		local row = sql:fetch_assoc(result)
		if not row then break end
		
		local id = row['id']
		local x = row['x']
		local y = row['y']
		local z = row['z']
		local interior = row['interior']
		local dimension = row['dimension']
		local rx = row['rx']
		local ry = row['ry']
		local rz = row['rz']
		local elevation = row['elevation']
		local itemModel = row['itemmodel']
		local itemID = row['itemid']
		local itemValue = row['itemvalue']
		local droper = row['droper']
		local items = row['items']
		local values = row['itemvalues']
		
		-- create!
		local item = createObject(tonumber(itemModel), x, y, z-elevation, rx, ry, rz)
		setElementInterior(item, tonumber(interior))
		setElementDimension(item, tonumber(dimension))
		
		setData(item, "dbid", tonumber(id), true)
		setData(item, "droper", tonumber(droper), true)
		setData(item, "itemid", tonumber(itemID), true) 
		setData(item, "itemvalue", tonumber(itemValue), true) 
		
		if ( tonumber(itemModel) == 2332 or tonumber(itemModel) == 3761 ) then
			setData(item, "items", tostring(items), true)
			setData(item, "values", tostring(values), true)
		end
	end	
	
	sql:free_result(result)
	readyToSend = true
end
addEventHandler("onResourceStart", resourceRoot, spawnWorldItems)