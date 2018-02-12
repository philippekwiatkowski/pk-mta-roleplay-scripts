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

--------- [ Shop System ] ---------

--------- [ Admin Commands ] ---------

-- /createshop
function createShop( thePlayer, commandName, shopType )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerModerator(thePlayer) then
		
		if (shopType) then
			
			local shopType = tonumber(shopType)
			local skin
			
			if (shopType == 1) then -- General Store Keeper
				
				local rand = math.random(0,1)
				if (rand == 1) then
					skin = 217
				else
					skin = 211
				end
			elseif (shopType == 2) then -- Electronics
				
				local rand = math.random(0,1)
				if (rand == 1) then
					skin = 217
				else
					skin = 211
				end
			elseif (shopType == 3) then -- Stall
				
				skin = 209
			elseif (shopType == 4) then -- Burger Shot
				
				skin = 205
			elseif (shopType == 5) then -- Pizza
				
				skin = 155
			elseif (shopType == 6) then -- Cluckin' Bell
				
				skin = 167
			elseif (shopType == 7) then -- Donut
				
				skin = 209
			elseif (shopType == 8) then -- Bar
				
				local rand = math.random(0,1)
				if (rand == 1) then
					skin = 171
				else
					skin = 172
				end
			elseif (shopType == 9) then -- Clothes Shop
				
				local rand = math.random(0,1)
				if (rand == 1) then
					skin = 171
				else
					skin = 172
				end
			end	
			
			local x, y, z = getElementPosition(thePlayer)
			local rot = getPedRotation(thePlayer)
			local int = getElementInterior(thePlayer)
			local dim = getElementDimension(thePlayer)
			
			local insert = sql:query("INSERT INTO shops SET x=".. sql:escape_string(x) ..", y=".. sql:escape_string(y) ..", z=".. sql:escape_string(z) ..", rotation=".. sql:escape_string(rot) ..", dimension=".. sql:escape_string(dim) ..", interior=".. sql:escape_string(int) ..", skin=".. sql:escape_string(skin) ..", type=".. sql:escape_string(shopType) .."")
			if (insert) then
				local insertid = sql:insert_id()
				
				local ped = createPed(skin, x, y, z)
				setElementInterior(ped, int)
				setElementDimension(ped, dim)
				setPedRotation(ped, rot)
				setElementFrozen(ped, true)
				
				setData(ped, "dbid", tonumber(insertid), true)
				setData(ped, "type", tonumber(shopType), true)	
				
				outputChatBox("Shop created with ID ".. insertid .." & Type ".. shopType ..".", thePlayer, 0, 255, 0)
			else
				outputDebugString("MySQL Error: Unable to create shop!", 1)
				outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
			end
			
			sql:free_result(insert)
		else
			outputChatBox("Shop Types: 1 = General, 2 = Electronics, 3 = Food Stall", thePlayer, 212, 156, 49)
			outputChatBox("4 = Burger Shot, 5 = Pizza, 6 = Cluckin' Bell", thePlayer, 212, 156, 49)
			outputChatBox("7 = Donut Shop, 8 = Bar, 9 = Clothes Shop", thePlayer, 212, 156, 49)
			outputChatBox("SYNTAX: /".. commandName .." [Shop Type]", thePlayer, 212, 156, 49)
		end
	end	
end	
addCommandHandler("createshop", createShop, false, false)

-- /delshop
function deleteShop( thePlayer, commandName, shopID)
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerModerator(thePlayer) then
		
		if (shopID) then
			local shopID = tonumber(shopID)
			
			local found = false
			for i, ped in ipairs (getElementsByType("ped", resourceRoot)) do
				if (tonumber(getData(ped, "dbid")) == shopID) then
				
					local delete = sql:query("DELETE FROM shops WHERE id=".. sql:escape_string(shopID) .."")
					if (delete) then
						
						destroyElement(ped)
						outputChatBox("Shop deleted with ID ".. shopID ..".", thePlayer, 0, 255, 0)
						found = true
					else
						outputDebugString("MySQL Error: Unable to delete shop!", 1)
						outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
					end
					
					sql:free_result(delete)
					break
				end
			end	
			
			if not (found) then
				outputChatBox("Invalid shop ID.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Shop ID]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("delshop", deleteShop, false, false)

-- /nearbyshops
function nearbyShops( thePlayer, commandName )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerModerator(thePlayer) then
		
		local x, y, z = getElementPosition(thePlayer)
		
		local count = 0
		outputChatBox("~-~-~-~-~-~-~ Shops ~-~-~-~-~-~-~", thePlayer, 212, 156, 49)
		for i, ped in ipairs (getElementsByType("ped", resourceRoot)) do
			
			local px, py, pz = getElementPosition(ped)
			if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 10) then
				
				local dbid = getData(ped, "dbid")
				local shopType = getData(ped, "type")
				local skin = getElementModel(ped)
				
				outputChatBox("ID: ".. dbid ..", Type: ".. shopType ..", Skin: ".. skin ..".", thePlayer, 212, 156, 49)
				count = count + 1
			end	
		end	
	
		if (count == 0) then
			outputChatBox("		No shops near you.", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("nearbyshops", nearbyShops, false, false)
	
--------- [ Client Side Callbacks ] ---------				
function playerBuyItem( itemName, itemCost, shopName )
	local itemName = tostring(itemName)
	local itemCost = tonumber(itemCost)
	
	if ( getPlayerMoney( source ) / 100 ) >= ( itemCost ) then
		
		local itemValue = 1
		if ( itemName == "Cell Phone" ) then
			itemValue = getPhoneNumber( )
			
			-- Repeat
			if ( itemValue == false ) then
				triggerEvent("playerBuyItem", source, itemName, itemCost )
				return
			end
		end
		
		if ( shopName == "Clothes Shop" ) then
			itemValue = tostring( itemName )
			itemName = "Clothes"
		end
		
		local success = nil
		if ( itemName ~= "Camera" ) then
			local _, itemID = exports['[ars]inventory-system']:getItemDetails( itemName )
			success = exports['[ars]inventory-system']:giveItem(source, itemID, tostring(itemValue))
		else
			success = giveWeapon( source, 43 )
		end
	 
		if (success) then
			
			takePlayerMoney(source, itemCost*100)
			
			local dim = getElementDimension(source)
			local int = getElementInterior(source)
			
			if ( dim > 0 and int  > 0 ) then
				for key, value in ipairs ( getElementsByType("marker") ) do
					
					local id = getElementDimension(value)
					local elevator = tonumber( getData( value, "elevator" ) )
					
					if ( id == dim and elevator == 0 ) then
						
						local owner = tonumber( getData( value, "owner" ) )
						if ( owner ~= -1 ) then
							
							local result = sql:query_fetch_assoc("SELECT `charactername` FROM `characters` WHERE `id`=".. sql:escape_string( owner ) .."")
							if ( result ) then
								
								local row = sql:query_fetch_assoc("SELECT `balance` FROM `bankaccounts` WHERE `owner`='".. sql:escape_string( tostring( result['charactername'] ) ) .."'")
								if ( row ) then
									
									local update = sql:query("UPDATE `bankaccounts` SET `balance`=".. sql:escape_string( tonumber( row['balance'] ) + itemCost*100 ) .."")
								end
							end
							
							sql:free_result(result)
						else
							triggerEvent("giveMoneyToGovernment", source, itemCost)
						end
					end
				end
			end
			
			outputChatBox("You bought a ".. itemName .." for $".. itemCost ..".", source, 212, 156, 49)
		else
			outputChatBox("Your inventory is full.", source, 255, 0, 0)
		end	
	else
		outputChatBox("You do not have enough money.", source, 255, 0, 0)
	end		
end
addEvent("playerBuyItem", true)
addEventHandler("playerBuyItem", getRootElement(), playerBuyItem)

function getPhoneNumber( )
	local rand = math.random(10000, 99999)
	
	local exists = false
	
	local result = sql:query("SELECT `items`, `itemvalues` FROM `characters`")
	while true do
		local row = sql:fetch_assoc(result)
		if ( not row ) then
			
			break
		end
		
		local items = tostring( row['items'] )
		local values = tostring( row['itemvalues'] )
		
		if ( items ~= "" ) and ( values ~= "" ) then
			local i = split(items, ",")
			local v = split(values, ",")
			
			for j = 1, #i do
				if ( tonumber( i[ j ] ) == 3 and tonumber( v[ j ] ) == rand ) then
					
					exists = true
					break
				end
			end
		end	
	end
	
	sql:free_result(result)
	
	if ( not exists ) then
		return rand
	else
		return false
	end	
end
			
--------- [ Resource Start ] ---------
function spawnShopsOnStart( res )
	
	local result = sql:query("SELECT id, x, y, z, rotation, interior, dimension, skin, type FROM shops")
	while true do
		local row = sql:fetch_assoc(result)
		if not (row) then break end
		
		local dbid = row['id']
		local x = row['x']
		local y = row['y']
		local z = row['z']
		local rot = row['rotation']
		local int = row['interior']
		local dim = row['dimension']
		local skin = row['skin']
		local shopType = row['type']
		
		local ped = createPed(tonumber(skin), tonumber(x), tonumber(y), tonumber(z))
		setElementInterior(ped, tonumber(int))
		setElementDimension(ped, tonumber(dim))
		setPedRotation(ped, tonumber(rot))
		setElementFrozen(ped, true)
		
		setData(ped, "dbid", tonumber(dbid), true)
		setData(ped, "type", tonumber(shopType), true)
	end	
	
	sql:free_result(result)
end
addEventHandler("onResourceStart", resourceRoot, spawnShopsOnStart)