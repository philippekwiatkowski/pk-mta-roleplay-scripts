local sql = exports.sql
local supplierData = { }
	
--------- [ NPC System ] ---------	
function buyItem( itemName, itemPrice, itemQuantity, index, faction )
	local faction = tonumber( faction )
	
	local itemName = tostring( itemName )
	local itemPrice = tonumber( itemPrice )
	local itemQuantity = tostring( itemQuantity )
	
	local index = tonumber( index ) - 8
	
	local _, itemID = exports['[ars]inventory-system']:getItemDetails( itemName )
	if ( itemID ) then	
		
		local given = exports['[ars]inventory-system']:giveItem( source, itemID, itemQuantity )
		if ( given ) then
		
			takePlayerMoney( source, itemPrice * 100 )
			giveGovMoney( source, itemPrice )
			
			if ( itemName ~= "Blue Bandana" ) then
				takeStock( "drug", index, faction )
			end	
			
			outputChatBox("You bought an ".. itemName .." for $".. itemPrice ..".", source, 212, 156, 49)
		else
			outputChatBox("You inventory is full.", source, 255, 0, 0)
		end	
	end
end
addEvent("buyItem", true)
addEventHandler("buyItem", root, buyItem)

function buyWeapon( weaponName, weaponPrice, weaponAmmo, index, faction )
	local faction = tonumber( faction )
	
	local weaponName = tostring( weaponName )
	
	local weaponID = nil
	if ( weaponName == "Sawn-Off Shotgun" ) then
		weaponID = 26
	else	
		weaponID = tonumber( getWeaponIDFromName( weaponName ) )
	end
	
	local weaponPrice = tonumber( weaponPrice )
	local weaponAmmo = tonumber( weaponAmmo )
	
	local index = tonumber( index ) - 2
	
	local given = giveWeapon( source, weaponID, weaponAmmo )
	if ( given ) then
		
		takePlayerMoney( source, weaponPrice * 100 )
		giveGovMoney( source, weaponPrice )
		
		takeStock( "weapon", index, faction )
		
		outputChatBox("You bought a ".. weaponName .." for $".. weaponPrice ..".", source, 212, 156, 49)
	end	
end
addEvent("buyWeapon", true)
addEventHandler("buyWeapon", root, buyWeapon)

function giveGovMoney( thePlayer, amount )
	local amount = tonumber( amount )
	if ( amount ) then
	
		triggerEvent("giveMoneyToGovernment", thePlayer, amount )
	end	
end

function takeStock( itemType, index, faction )
	local itemType = tostring( itemType )
	local index = tostring( index )
	local faction = tonumber( faction )
	
	local field = itemType .. index
	
	local result = sql:query_fetch_assoc("SELECT `".. field .."` FROM `npcs` WHERE `faction`=".. sql:escape_string( faction ))
	if ( result ) then
		
		local value = tonumber( result[field] ) - 1
		
		local update = sql:query("UPDATE `npcs` SET ".. field .."=".. sql:escape_string( value ) .." WHERE `faction`=".. sql:escape_string( faction ))
		if ( update ) then
			
			local totalSupplies = 0
			if ( value == 0 ) then -- Out of Stock
				
				local i = nil
				if ( itemType == "drug" ) then
					i = 4
				else
					i = 3
				end
				
				local t = supplierData[faction][i]
				for j = 1, #t do
					if ( tonumber( j ) == tonumber( index ) ) then
						
						supplierData[faction][i][j] = 0
						break
					end
				end
				
				local totalWeapons = 0
				for i = 1, #supplierData[faction][3] do
					totalWeapons = totalWeapons + tonumber( supplierData[faction][3][i] )
				end
				
				local totalDrugs = 0
				for i = 1, #supplierData[faction][4] do
					totalDrugs = totalDrugs + tonumber( supplierData[faction][4][i] )
				end
				
				totalSupplies = totalWeapons + totalDrugs
				if ( totalSupplies == 0 ) then
					supplierData[faction][2] = 0
				end
				
				for key, thePlayer in ipairs ( getElementsByType("player") ) do
					triggerClientEvent(thePlayer, "giveSupplierData", thePlayer, supplierData, true)
				end
			else
				for key, thePlayer in ipairs ( getElementsByType("player") ) do
					triggerClientEvent(thePlayer, "giveSupplierData", thePlayer, supplierData, false)
				end	
			end	
			
			if ( totalSupplies == 0 ) then -- Empty
				local update = sql:query("UPDATE `npcs` SET `lastshipment`=NOW(), `update`='0' WHERE `faction`=".. sql:escape_string( faction ))
				if ( not update ) then
				
					outputDebugString("Unable to end faction stock!", 1)
				end
				
				sql:free_result(update)
			end	
		end

		sql:free_result(update)
	end
end

function getSupplierData( reload )

	local result = sql:query("SELECT `id`, `faction`, DATEDIFF(NOW(), `lastshipment`) AS `llastshipment`, `weapon1`, `weapon2`, `weapon3`, `drug1`, `drug2`, `drug3`, `update` FROM `npcs`")
	while true do
		
		local row = sql:fetch_assoc( result ) 
		if ( not row ) then
			break
		end
		
		local id = tonumber( row['id'] )
		local faction = tonumber( row['faction'] )
		local lastShipment = tonumber( row['llastshipment'] )
		
		local weapon1 = tonumber( row['weapon1'] )
		local weapon2 = tonumber( row['weapon2'] )
		local weapon3 = tonumber( row['weapon3'] )
		
		local drug1 = tonumber( row['drug1'] )
		local drug2 = tonumber( row['drug2'] )
		local drug3 = tonumber( row['drug3'] )
		
		local update = tonumber( row['update'] )
		
		-- Re-stock
		if ( lastShipment == 3 and update == 0 ) then
	
			local update = sql:query("UPDATE `npcs` SET `weapon1`='5', `weapon2`='5', `weapon3`='5', `drug1`='5', `drug2`='5', `drug3`='5', `update`='1' WHERE `id`=".. sql:escape_string( tonumber( id ) ) .."")
			if ( update ) then
				
				weapon1, weapon2, weapon3 = 5, 5, 5
				drug1, drug2, drug3 = 5, 5, 5
			end
			
			sql:free_result(update)
		end	
		
		local weapons = { weapon1, weapon2, weapon3 }
		local drugs = { drug1, drug2, drug3 }
		
		supplierData[faction] = { id, lastShipment, weapons, drugs }
	end
	
	sql:free_result(result)
	triggerClientEvent(source, "giveSupplierData", source, supplierData, reload)
end
addEvent("getSupplierData", true)
addEventHandler("getSupplierData", root, getSupplierData)

function updateSupplyData( reload )
	for key, value in ipairs ( getElementsByType("player") ) do
		triggerEvent("getSupplierData", value, reload)
	end	
end	
setTimer( updateSupplyData, 3600000, 0, false )