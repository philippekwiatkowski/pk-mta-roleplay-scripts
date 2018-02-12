local function getData( theElement, key )
	local key = tostring(key)
	if isElement(theElement) and (key) then
		
		return exports['[ars]anticheat-system']:c_callData( theElement, tostring(key) )
	else
		return false
	end
end

local screenX, screenY = guiGetScreenSize( )

function showClientInventory( thePlayer, items, values, weapons )
	local width, height = 280, 300
	local x, y = ( screenX - screenX ) + 5, ( screenY / 2 ) - ( height / 2 )

	local inventoryWindow = guiCreateWindow( x, y, width, height, getPlayerName( thePlayer ):gsub("_", " "), false)
	
	local inventoryList = guiCreateGridList( 20, 30, 240, 220, false, inventoryWindow )
	guiGridListAddColumn( inventoryList, "Item", 0.5 )
	guiGridListAddColumn( inventoryList, "Value", 0.4 )
	
	for key, value in pairs ( items ) do
		local row = guiGridListAddRow( inventoryList )
		
		local _, itemName = exports['[ars]inventory-system']:getItemDetails( tonumber( value ) )
		
		guiGridListSetItemText( inventoryList, row, 1, tostring( itemName ), false, false )
		guiGridListSetItemText( inventoryList, row, 2, tostring( values[key] ), false, false )
	end	
	
	for i = 1, #weapons do
		local row = guiGridListAddRow( inventoryList )
		
		guiGridListSetItemText(inventoryList, row, 1, tostring(weapons[i][1]), false, false)
		guiGridListSetItemText(inventoryList, row, 2, tostring(weapons[i][2]), false, false)
	end
	
	local buttonClose = guiCreateButton( 85, 260, 110, 20, "Close", false, inventoryWindow )
	
	addEventHandler("onClientGUIClick", buttonClose,
		function( button, state )
			if ( button == "left" and state == "up" ) then
				
				destroyElement( inventoryWindow )
			end
		end
	)	
end
addEvent("showClientInventory", true)
addEventHandler("showClientInventory", localPlayer, showClientInventory)

-- /settime
function changeTime( commandName, hour, minutes )
	if ( getData( localPlayer, "loggedin") == 1 ) and ( exports['[ars]global']:c_isPlayerTrialModerator( localPlayer ) ) then
		
		if ( hour and minutes ) then
			
			local hour = tonumber( hour )
			local minutes = tonumber( minutes )
			
			setTime( hour, minutes )
		else
			outputChatBox("SYNTAX: /".. commandName .." [ Hour ] [ Minutes ]", 212, 156, 49)
		end
	end
end
addCommandHandler("settime", changeTime, false, false)	