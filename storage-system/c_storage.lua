local screenX, screenY = guiGetScreenSize( )

--------- [ Element Data returns ] ---------
local function getData( theElement, key )
	local key = tostring(key)
	if isElement(theElement) and (key) then
		
		return exports['[ars]anticheat-system']:c_callData( theElement, tostring(key) )
	else
		return false
	end
end	

--------- [ Storage System ] ---------
local items = { }
local values = { }
local received = false
function giveClientItems( i, v )
	items = i
	values = v
	
	received = true
end
addEvent("giveClientItems", true)
addEventHandler("giveClientItems", localPlayer, giveClientItems)

local theObject = nil
local isObject, isVehicle = false, false
addEventHandler("onClientClick", root,
	function( button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
		if ( button == "right" and state == "up" ) then
	
			if ( clickedElement ) then
				
				if ( getElementType( clickedElement ) == "object" ) then
					isObject = true	
				elseif ( getElementType( clickedElement ) == "vehicle" ) then
					isVehicle = true
				else
					return
				end
				
				if ( isObject ) then
					if ( getElementModel( clickedElement ) ~= 2332 and getElementModel( clickedElement ) ~= 3761 ) then -- Must be safe/shelf
						return
					end
				end
				
				if ( getData( localPlayer, "loggedin") == 1 and not isElement( storageWindow ) ) then
					theObject = clickedElement
					
					if ( isVehicle ) then
						if ( getData( theObject, "dbid" ) < 0 ) then
						
							outputChatBox("You cannot store items in that vehicle.", 255, 0, 0)
							return
						end
					end
					
					if ( exports['[ars]inventory-system']:isPlayerInventoryOpen( ) ) then
						
						exports['[ars]inventory-system']:closePlayerInventory( )
					end					
				
					triggerEvent("getClientItems", localPlayer)
	
					while received do
						local adminduty = tonumber( getData( localPlayer, "adminduty") )
						local dbid = getElementDimension( clickedElement )
						
						if ( isObject ) then
							if ( getElementModel( clickedElement ) == 2332 ) then
								
								local key, keyid = false, false
								for i = 1, #items do
									if ( tonumber( items[i] ) == 2 ) then
										key = true
									
										if ( tonumber( values[i] ) == dbid ) then

											keyid = true
										end	
									end
								end	
								
								if ( key ) then
									if ( not keyid ) and ( adminduty == 0 ) then	-- Do We Have a Key?
										
										outputChatBox("You do not have a key to this safe.", 255, 0, 0)
										return
									end
								else
									if ( adminduty == 0 ) then
										outputChatBox("You do not have a key to this safe.", 255, 0, 0)
										return
									end
								end
							end
						elseif ( isVehicle ) then											-- Is the vehicle unlocked?
							
							if ( isVehicleLocked( clickedElement ) ) then
								outputChatBox("The vehicle is locked.", 255, 0, 0)
								return
							end
						end	
					
						createStorageInteractUI(  )
						received = false
						break
					end		
				end	
			end
		end
	end
)

function createStorageInteractUI( )
	local width, height = 450, 230
	local x, y = (screenX/2) - (width/2), (screenY/2) - (height/2)
	
	local text = ""
	local lx, lw = 70, 95
	if ( isObject ) then
		if ( getElementModel( theObject ) == 2332 ) then
			text = "Safe"
		else
			text = "Shelf"
		end
	else
		text = "Vehicle"
		lx = lx - 20
		lw = lw + 15
	end	
	
	
	storageWindow = guiCreateWindow(x, y, width, height, text, false)
	storageLabel = guiCreateLabel(95, 20, 265, 20, "Double click on an item in the list to transfer it.", false, storageWindow)
	
	storageInventoryLabel = guiCreateLabel(lx, 40, lw, 20, text .." Inventory", false, storageWindow)
	
	storageItemsList = guiCreateGridList(20, 60, 190, 120, false, storageWindow)
	guiGridListAddColumn(storageItemsList, "Item", 0.6)
	guiGridListAddColumn(storageItemsList, "Value", 0.2)
	
	playerInventoryLabel = guiCreateLabel(280, 40, 95, 20, "Your Inventory", false, storageWindow)
	
	inventoryItemsList = guiCreateGridList(240, 60, 190, 120, false, storageWindow)
	guiGridListAddColumn(inventoryItemsList, "Item", 0.6)
	guiGridListAddColumn(inventoryItemsList, "Value", 0.2)
	
	addEventHandler("onClientGUIDoubleClick", storageItemsList, transferItem, false)
	addEventHandler("onClientGUIDoubleClick", inventoryItemsList, transferItem, false)
	
	buttonClose = guiCreateButton(170, 200, 110, 20, "Close", false, storageWindow)
	addEventHandler("onClientGUIClick", buttonClose,
		function( button, state )
			
			theObject = nil
			isObject, isVehicle = false, false

			destroyElement(storageWindow)
			guiSetInputEnabled(false)
		end
	)
	
	populateStorageGridLists( false, theObject )
	
	guiSetFont(storageLabel, "default-bold-small")
	guiSetFont(storageInventoryLabel, "clear-normal")
	guiSetFont(playerInventoryLabel, "clear-normal")
	
	guiSetInputEnabled(true)
end

local playerRows, storageRows = nil, nil
function populateStorageGridLists( refresh, sourceObject )
	if ( isElement( storageItemsList ) and isElement( inventoryItemsList ) ) then
		
		if ( sourceObject == theObject ) then
		
			guiGridListClear( storageItemsList )
			guiGridListClear( inventoryItemsList )
			
			if ( refresh ) then
				
				items, values = exports['[ars]inventory-system']:getPlayerInventory( )
			end
			
			local objectItems = tostring( getData( theObject, "items") )
			local objectValues = tostring( getData( theObject, "values") )
			
			local storageItems = { }
			local storageValues = { }
			if (objectItems ~= "") and (objectValues ~= "") then
				storageItems = split(objectItems, string.byte(","))
				storageValues = split(objectValues, string.byte(","))
			end
			
			for i = 1, #storageItems do
				local row = guiGridListAddRow( storageItemsList )
				
				local itemID = tonumber( storageItems[i] )
				if ( itemID ~= nil ) then
					local itemName = nil
					
					if ( itemID < 0 ) then
						itemName = getWeaponNameFromID( itemID*-1 )
					else	
						_, itemName = getItemDetails( tonumber( itemID ) )
					end	
					
					guiGridListSetItemText(storageItemsList, row, 1, tostring(itemName), false, false)
					guiGridListSetItemText(storageItemsList, row, 2, tostring(storageValues[i]), false, false)
				end	
			end
			
			for i = 1, #items do
				local row = guiGridListAddRow( inventoryItemsList )
				
				local _, itemName = getItemDetails( tonumber( items[i] ) )
				
				guiGridListSetItemText(inventoryItemsList, row, 1, tostring(itemName), false, false)
				guiGridListSetItemText(inventoryItemsList, row, 2, tostring(values[i]), false, false)
			end
			
			for i = 1, 12 do
				local row = guiGridListAddRow( inventoryItemsList )
				
				local itemName = getWeaponNameFromID( getPedWeapon( localPlayer, i ) )
				if ( itemName ~= "Fist" and itemName ~= "Brass Knuckles") then
					
					local itemAmmo = getPedTotalAmmo( localPlayer, i )
					
					guiGridListSetItemText(inventoryItemsList, row, 1, tostring(itemName), false, false)
					guiGridListSetItemText(inventoryItemsList, row, 2, tostring(itemAmmo), false, false)
				end	
			end
		end	
	end	
end
addEvent("populateStorageGridLists", true)
addEventHandler("populateStorageGridLists", localPlayer, populateStorageGridLists)

function transferItem( button, state )
	if ( button == "left" and state == "up" ) then
		
		local row = guiGridListGetSelectedItem( source )
		if ( row ~= -1 ) then
			
			local itemName = guiGridListGetItemText( source, row, 1 )
			local _, itemID = getItemDetails( tostring( itemName ) )
			if ( itemID == false ) then
				itemID = -getWeaponIDFromName( tostring( itemName ) )
			end	
			
			local itemValue = guiGridListGetItemText( source, row, 2 )
			
			local objectItems = tostring( getData( theObject, "items") )
			local objectValues = tostring( getData( theObject, "values") )
			
			if ( source == inventoryItemsList ) then
				
				local name = ""
				if ( getElementType( theObject ) == "object" ) then
					
					if ( getElementModel( theObject ) == 2332 ) then
						name = "Safe"
					else
						name = "Shelf"
					end
				elseif ( getElementType( theObject ) == "vehicle" ) then
					name = "Vehicle"
				end	
			
				local t = { }
				t = split(objectItems, ",")
				
				local limit = nil
				
				if ( name == "Safe" or name == "Vehicle" ) then
					limit = 10
				elseif ( name == "Shelf" ) then	
					limit = 20
				end
				
				if ( #t < limit ) then
					objectItems = objectItems ..",".. itemID
					objectValues = objectValues ..",".. itemValue
					
					for key, value in pairs ( items ) do
						if ( tonumber( value ) == tonumber( itemID ) ) and ( tonumber( values[key] ) == tonumber( itemValue ) ) then
							
							table.remove(items, tonumber( key ))
							table.remove(values, tonumber( key ))
							
							break
						end
					end	
					
					guiGridListRemoveRow( inventoryItemsList, row )
					local row = guiGridListAddRow( storageItemsList )
					
					guiGridListSetItemText(storageItemsList, row, 1, tostring(itemName), false, false)
					guiGridListSetItemText(storageItemsList, row, 2, tostring(itemValue), false, false)
					
					triggerServerEvent("updateObjectInventory", localPlayer, theObject, objectItems, objectValues)
					
					if ( itemID < 0 ) then
						triggerServerEvent("takePlayerWeapon", localPlayer, itemID )
					else	
						triggerServerEvent("takeItem", localPlayer, localPlayer, itemID, itemValue)	
					end
				else
					outputChatBox("You cannot store anymore items in this ".. name ..".", 255, 0, 0)
				end
				
			elseif ( source == storageItemsList ) then
				
				local totalItems = countItems( )
				
				if (totalItems < 10) then
				
					local t = { }
					local v = { }
					
					if (objectItems ~= "") and (objectValues ~= "") then
						t = split(objectItems, string.byte(","))
						v = split(objectValues, string.byte(","))
					end
					
					for i = 1, #t do
						if ( tonumber( t[i] ) == tonumber( itemID ) and tonumber( v[i] ) == tonumber( itemValue ) ) then
							
							table.remove(t, i)
							table.remove(v, i)
							
							table.insert(items, t[i])
							table.insert(values, t[i])
							break
						end
					end	
					
					objectItems, objectValues = "", ""
					for i = 1, #t do
						if ( i == 1 ) then
							objectItems = tostring( t[i] )
							objectValues = tostring( v[i] )
						else
							objectItems = objectItems ..",".. tostring( t[i] )
							objectValues = objectValues ..",".. tostring( v[i] )
						end	
					end
					
					guiGridListRemoveRow( storageItemsList, row )
					local row = guiGridListAddRow( inventoryItemsList )
					
					guiGridListSetItemText(inventoryItemsList, row, 1, tostring(itemName), false, false)
					guiGridListSetItemText(inventoryItemsList, row, 2, tostring(itemValue), false, false)
					
					triggerServerEvent("updateObjectInventory", localPlayer, theObject, objectItems, objectValues)
					
					if ( itemID < 0 ) then
						triggerServerEvent("givePlayerWeapon", localPlayer, itemID, itemValue )
					else	
						triggerServerEvent("giveItem", localPlayer, localPlayer, itemID, itemValue)
					end
				else
					outputChatBox("Your inventory is full.", 255, 0, 0)
				end	
			end
		end	
	end
end	

function getItemDetails( item )
	return exports['[ars]inventory-system']:getItemDetails( item )
end	

function countItems( )
	if ( items ) then
		
		local totalItems = 0
	
		if (#items > 0) then
		
			for k, v in pairs ( items ) do         
				if ( tonumber( v ) > 2 ) then -- Not keys
				
					totalItems = totalItems + 1
				end
			end	
		end
		
		return totalItems
	end
end