--------- [ Element Data returns ] ---------
local function getData( theElement, key )
	local key = tostring(key)
	if isElement(theElement) and (key) then
		
		return exports['[ars]anticheat-system']:c_callData( theElement, tostring(key) )
	else
		return false
	end
end	

itemlistWindow = nil

function openItemlist()
	if getData(getLocalPlayer(), "loggedin") == 1 and exports['[ars]global']:c_isPlayerTrialModerator(getLocalPlayer()) then
		if not (itemlistWindow) then
			local screenX, screenY = guiGetScreenSize()
			
			local width, height = 300, 350
			local x = (screenX/2) - (width/2)
			local y = (screenY/2) - (height/2)
		
			itemlistWindow = guiCreateWindow(x, y, width, height, "List of items", false)
			itemlistGrid = guiCreateGridList(0.025, 0.1, 0.95, 0.775, true, itemlistWindow)
		
			local itemID = guiGridListAddColumn(itemlistGrid, "Item ID", 0.2)
			local itemName = guiGridListAddColumn(itemlistGrid, "Item Name", 0.7)
			
			populateItemList( )
			
			closeButton = guiCreateButton(0.025, 0.9, 0.95, 0.1, "Close", true, itemlistWindow)
			addEventHandler("onClientGUIClick", closeButton, closeItemlist, false)
		
			guiWindowSetSizable(itemlistWindow,false)
		
			showCursor(true)
		end
	end
end
addCommandHandler("itemlist", openItemlist)

function populateItemList( )
	for key, value in ipairs( g_items ) do
		
		local itemName = value[1]
		if ( itemName ) then
			
			local row = guiGridListAddRow( itemlistGrid )
		
			guiGridListSetItemText( itemlistGrid, row, 1, tostring( key ), false, false)
			guiGridListSetItemText( itemlistGrid, row, 2, tostring( itemName ), false, false)
		end
	end
end

function closeItemlist(button, state)
	if (button=="left") and (state=="up") then
		showCursor(false)
		destroyElement(itemlistWindow)
		itemlistWindow = nil
	end
end