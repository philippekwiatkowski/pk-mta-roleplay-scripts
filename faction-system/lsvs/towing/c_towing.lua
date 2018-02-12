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

--------- [ Vehicle Towing ] ---------
local employee = createPed(93, -2090.0187, -242.8746, 1029.1063, 90)
setElementInterior(employee, 3)
setElementDimension(employee, 61)
setPedAnimation(employee, "FOOD", "FF_Sit_Look", -1, true, false, false)

addEventHandler("onClientClick", root,
	function( button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
		if ( button == "right" and state == "up" ) then
			
			if ( clickedElement ) and ( clickedElement == employee ) then
				if ( getData( localPlayer, "loggedin") == 1 and not isElement( towVehicleWindow ) ) then
			
					createTowVehicleWindow(  )
				end	
			end
		end
	end
)

function createTowVehicleWindow(  )
	local width, height = 300, 240
	local x, y = (screenX/2) - (width/2), (screenY/2) - (height/2)
	
	towVehicleWindow = guiCreateWindow(x, y, width, height, "San Fierro Vehicle Services", false)
	
	towVehicleLabel = guiCreateLabel(20, 30, 260, 20, "Select your vehicle from the list below.", false, towVehicleWindow)
	
	towVehicleList = guiCreateGridList(20, 50, 260, 130, false, towVehicleWindow)
	guiGridListAddColumn( towVehicleList, "ID", 0.30 )
	guiGridListAddColumn( towVehicleList, "Name", 0.60 )
	
	for key, theVehicle in ipairs ( getElementsByType("vehicle" ) ) do
		
		if ( getData( theVehicle, "impounded") == 1 ) then
			
			local owner = tonumber( getData( theVehicle, "owner" ) )
			local dbid = tonumber( getData( localPlayer, "dbid" ) )
			
			if ( owner == dbid ) then
				local row = guiGridListAddRow( towVehicleList )
				
				guiGridListSetItemText( towVehicleList, row, 1, tostring( getData( theVehicle, "dbid" ) ), false, false)
				guiGridListSetItemText( towVehicleList, row, 2, tostring( getVehicleName( theVehicle ) ), false, false)
			end
		end
	end	
	
	buttonReleaseVehicle = guiCreateButton(20, 200, 110, 20, "Release ($150)", false, towVehicleWindow)
	addEventHandler("onClientGUIClick", buttonReleaseVehicle,
		function( button, state )
			
			local row = guiGridListGetSelectedItem( towVehicleList )
			if ( row ~= -1 ) then
				
				local money = tonumber( getPlayerMoney( localPlayer )/100 )
				if ( money >= 150 ) then
				
					local vehicleID = guiGridListGetItemText( towVehicleList, row, 1 )
					triggerServerEvent( "releaseVehicle", localPlayer, vehicleID )
					
					destroyElement(towVehicleWindow)
				else
					outputChatBox("You do not have enough money.", 255, 0, 0)
				end	
			end	
		end, false
	)	
	
	buttonReleaseCancel = guiCreateButton(170, 200, 110, 20, "Cancel", false, towVehicleWindow)
	addEventHandler("onClientGUIClick", buttonReleaseCancel,
		function( button, state )
			
			destroyElement(towVehicleWindow)
		end, false
	)	
	
	guiSetFont( towVehicleLabel, "clear-normal" )
end