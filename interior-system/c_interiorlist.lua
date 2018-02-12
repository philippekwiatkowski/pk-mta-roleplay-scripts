local screenX, screenY = guiGetScreenSize( )

local panelTabs = { }
local gridLists = { }
function interiorList( commandName )
	if not isElement(interiorWin) then
		
		local width, height = 600, 360
		local x, y = (screenX/2) - (width/2), (screenY/2) - (height/2)
	
		interiorWin = guiCreateWindow(x, y, width, height, "Interior List", false)
		
		interiorListPanel = guiCreateTabPanel(20, 25, 560, 280, false, interiorWin)
		
		panelTabs[1] = guiCreateTab("Houses", interiorListPanel)
		panelTabs[2] = guiCreateTab("Businesses", interiorListPanel)
		panelTabs[3] = guiCreateTab("Government", interiorListPanel)
		panelTabs[4] = guiCreateTab("Storage", interiorListPanel)
		panelTabs[5] = guiCreateTab("Recreational", interiorListPanel)
		panelTabs[6] = guiCreateTab("Hotels/Motels", interiorListPanel)
		
		for i = 1, 6 do
			gridLists[i] = guiCreateGridList(10, 10, 540, 240, false, panelTabs[i])
			guiGridListAddColumn(gridLists[i], "ID", 0.3)
			guiGridListAddColumn(gridLists[i], "Name", 0.6)
		end
		
		buttonClose = guiCreateButton(255, 320, 90, 20, "Close", false, interiorWin)
		addEventHandler("onClientGUIClick", buttonClose, 
		function( button, state )
			if ( button == "left" and state == "up" ) then
				
				destroyElement(interiorWin)
				interiorWin = nil
			end
		end, false)	
		
		populateList( )
	else
		destroyElement(interiorWin)
		interiorWin = nil
	end
end
addCommandHandler("intlist", interiorList)	
addCommandHandler("interiorlist", interiorList)

function populateList( )
	local id = 1
	for i = 0, 147 do
		
		
		if (i >= 0) and (i <= 43) then -- Houses
			local row = guiGridListAddRow(gridLists[1])
			
			if (i == 0) then
				guiGridListSetItemText(gridLists[1], row, 1, "Low Class", false, false)		
			elseif (i == 10) then
				guiGridListSetItemText(gridLists[1], row, 1, "", false, false)	
			elseif (i == 11) then
				guiGridListSetItemText(gridLists[1], row, 1, "Medium Class", false, false)
			elseif (i == 30) then
				guiGridListSetItemText(gridLists[1], row, 1, "", false, false)	
			elseif (i == 31) then
				guiGridListSetItemText(gridLists[1], row, 1, "High Class", false, false)
				
			else	
				guiGridListSetItemText(gridLists[1], row, 1, tostring(id), false, false) 
				guiGridListSetItemText(gridLists[1], row, 2, tostring(interiors[id][5]), false, false) 
				
				id = id + 1
			end
		elseif (i >= 44) and (i <= 110)	then
			local row = guiGridListAddRow(gridLists[2])
			
			if (i == 44) then
				guiGridListSetItemText(gridLists[2], row, 1, "Betting Places", false, false)		
			elseif (i == 47) then	
				guiGridListSetItemText(gridLists[2], row, 1, "", false, false)
			elseif (i == 48) then	
				guiGridListSetItemText(gridLists[2], row, 1, "Casinos", false, false)
			elseif (i == 52) then
				guiGridListSetItemText(gridLists[2], row, 1, "", false, false)
			elseif (i == 53) then
				guiGridListSetItemText(gridLists[2], row, 1, "Barber Shops", false, false)
			elseif (i == 57) then
				guiGridListSetItemText(gridLists[2], row, 1, "", false, false)
			elseif (i == 58) then
				guiGridListSetItemText(gridLists[2], row, 1, "Tattoo Parlours", false, false)
			elseif (i == 62) then
				guiGridListSetItemText(gridLists[2], row, 1, "", false, false)
			elseif (i == 63) then
				guiGridListSetItemText(gridLists[2], row, 1, "Clothes Shops", false, false)
			elseif (i == 70) then
				guiGridListSetItemText(gridLists[2], row, 1, "", false, false)
			elseif (i == 71) then
				guiGridListSetItemText(gridLists[2], row, 1, "24/7s", false, false)
			elseif (i == 78) then
				guiGridListSetItemText(gridLists[2], row, 1, "", false, false)
			elseif (i == 79) then
				guiGridListSetItemText(gridLists[2], row, 1, "Eating Places", false, false)
			elseif (i == 86) then
				guiGridListSetItemText(gridLists[2], row, 1, "", false, false)
			elseif (i == 87) then
				guiGridListSetItemText(gridLists[2], row, 1, "Bars", false, false)
			elseif (i == 90) then
				guiGridListSetItemText(gridLists[2], row, 1, "", false, false)
			elseif (i == 91) then
				guiGridListSetItemText(gridLists[2], row, 1, "Strip Clubs", false, false)
			elseif (i == 96) then
				guiGridListSetItemText(gridLists[2], row, 1, "", false, false)
			elseif (i == 97) then
				guiGridListSetItemText(gridLists[2], row, 1, "Brothels", false, false)
			elseif (i == 100) then
				guiGridListSetItemText(gridLists[2], row, 1, "", false, false)
			elseif (i == 101) then
				guiGridListSetItemText(gridLists[2], row, 1, "Club", false, false)
			elseif (i == 103) then
				guiGridListSetItemText(gridLists[2], row, 1, "", false, false)
			elseif (i == 104) then
				guiGridListSetItemText(gridLists[2], row, 1, "Sex Shop", false, false)
			elseif (i == 106) then
				guiGridListSetItemText(gridLists[2], row, 1, "", false, false)
			elseif (i == 107) then
				guiGridListSetItemText(gridLists[2], row, 1, "Gyms", false, false)
				
			else
				guiGridListSetItemText(gridLists[2], row, 1, tostring(id), false, false) 
				guiGridListSetItemText(gridLists[2], row, 2, tostring(interiors[id][5]), false, false)

				id = id + 1
			end
		elseif (i >= 111) and (i <= 125) then
			local row = guiGridListAddRow(gridLists[3])
			
			if (i == 111) then
				guiGridListSetItemText(gridLists[3], row, 1, "Service Buildings", false, false)
			elseif (i == 114) then
				guiGridListSetItemText(gridLists[3], row, 1, "", false, false)
			elseif (i == 115) then
				guiGridListSetItemText(gridLists[3], row, 1, "Sales Buildings", false, false)
			elseif (i == 121) then
				guiGridListSetItemText(gridLists[3], row, 1, "", false, false)
			elseif (i == 122) then
				guiGridListSetItemText(gridLists[3], row, 1, "Organisational Buildings", false, false)
				
			else
				guiGridListSetItemText(gridLists[3], row, 1, tostring(id), false, false) 
				guiGridListSetItemText(gridLists[3], row, 2, tostring(interiors[id][5]), false, false)
				
				id = id + 1
			end
		elseif (i >= 126) and (i <= 139) then
			local row = guiGridListAddRow(gridLists[4])
			
			if (i == 126) then
				guiGridListSetItemText(gridLists[4], row, 1, "Warehouses", false, false)
			elseif (i == 129) then
				guiGridListSetItemText(gridLists[4], row, 1, "", false, false)
			elseif (i == 130) then
				guiGridListSetItemText(gridLists[4], row, 1, "Garages", false, false)
			elseif (i == 134) then
				guiGridListSetItemText(gridLists[4], row, 1, "", false, false)
			elseif (i == 135) then
				guiGridListSetItemText(gridLists[4], row, 1, "Miscellaneous", false, false)
			
			else
				guiGridListSetItemText(gridLists[4], row, 1, tostring(id), false, false) 
				guiGridListSetItemText(gridLists[4], row, 2, tostring(interiors[id][5]), false, false)
				
				id = id + 1
			end
		elseif (i >= 140) and (i <= 144) then
			local row = guiGridListAddRow(gridLists[5])
			
			guiGridListSetItemText(gridLists[5], row, 1, tostring(id), false, false) 
			guiGridListSetItemText(gridLists[5], row, 2, tostring(interiors[id][5]), false, false)
				
			id = id + 1
		elseif (i >= 145) then
			local row = guiGridListAddRow(gridLists[6])
			
			guiGridListSetItemText(gridLists[6], row, 1, tostring(id), false, false) 
			guiGridListSetItemText(gridLists[6], row, 2, tostring(interiors[id][5]), false, false)
				
			id = id + 1
		end
			
	end	
	
	for i = 1, 6 do
		guiSetFont(gridLists[i], "default-bold-small")
	end
end