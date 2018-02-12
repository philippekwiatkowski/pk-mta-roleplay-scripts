local screenX, screenY = guiGetScreenSize( )

function showUniformUI( faction )
	
	local skins = nil
	if ( faction == 1 ) then -- LSPD
	
		skins = { 280, 281, 265, 211, 285, 284 }
	elseif ( faction == 2 ) then -- LSFD
		
		skins = { 277, 278, 279, 274, 275, 276 }
	end	
	
	if ( not isElement(uniformWin) ) then
		
		local width, height = 320, 360
		local x, y = (screenX/2) - (width/2), (screenY/2) - (height/2)
		
		uniformWin = guiCreateWindow(x, y, width, height, "Select your Uniform", false)
		
		local images = { }
		local imgX, imgY = 20, 50
		for key, value in ipairs ( skins ) do
			
			images[key] = guiCreateStaticImage(imgX, imgY, 64, 64, "images/".. value ..".png", false, uniformWin)
			local label = guiCreateLabel(imgX + 20, imgY + 70, 60, 20, "#".. tostring(key), false, uniformWin)
		
			if ( imgX < 240 ) then
				imgX = imgX + 110
			elseif ( imgX >= 240 ) then
				imgY = imgY + 90
				imgX = 20
			end	
			
			guiSetFont(label, "default-bold-small")
		end	
		
		informationLabel = guiCreateLabel(20, 240, 300, 20, "Type in the Uniform index:", false, uniformWin)
		indexEdit = guiCreateEdit(100, 260, 130, 20, "", false, uniformWin)
		
		buttonSelect = guiCreateButton(30, 300, 100, 25, "Select", false, uniformWin)
		addEventHandler("onClientGUIClick", buttonSelect, 
		function( button, state )
			if ( button == "left" and state == "up" ) then
				
				local i = tonumber( guiGetText(indexEdit) )
				if ( i >= 1 and i <= 6 ) then
					
					local skin = skins[i]
					if ( skin ) then
						
						triggerServerEvent("setFactionDuty", localPlayer, faction, skin)
						
						destroyElement(uniformWin)
						
						if (isCursorShowing( )) then
							showCursor(false)
						end	
					else
						playSoundFrontEnd(32)
					end
				else
					playSoundFrontEnd(32)
				end	
			end
		end, false)
	
		buttonCancel = guiCreateButton(190, 300, 100, 25, "Cancel", false, uniformWin)
		addEventHandler("onClientGUIClick", buttonCancel, 
		function( button, state )
			if ( button == "left" and state == "up" ) then
				
				destroyElement(uniformWin)
				
				if (isCursorShowing( )) then
					showCursor(false)
				end	
			end
		end, false)
		
		guiSetPosition(informationLabel, (width/2) - (guiLabelGetTextExtent(informationLabel)/2), 240, false)
		guiSetFont(informationLabel, "default-bold-small")	
		
		showCursor(true)
	end	
end
addEvent("showUniformUI", true)
addEventHandler("showUniformUI", localPlayer, showUniformUI)

function showDetectiveUI( faction )
	
	local skins = nil	
	skins = { 70, 286, 165, 166 }
	
	if ( not isElement(uniformWin) ) then
		
		local width, height = 320, 360
		local x, y = (screenX/2) - (width/2), (screenY/2) - (height/2)
		
		uniformWin = guiCreateWindow(x, y, width, height, "Select your Uniform", false)
		
		local images = { }
		local imgX, imgY = 20, 50
		for key, value in ipairs ( skins ) do
			
			images[key] = guiCreateStaticImage(imgX, imgY, 64, 64, "images/".. value ..".png", false, uniformWin)
			local label = guiCreateLabel(imgX + 20, imgY + 70, 60, 20, "#".. tostring(key), false, uniformWin)
		
			if ( imgX < 240 ) then
				imgX = imgX + 110
			elseif ( imgX >= 240 ) then
				imgY = imgY + 90
				imgX = 20
			end	
			
			guiSetFont(label, "default-bold-small")
		end	
		
		informationLabel = guiCreateLabel(20, 240, 300, 20, "Type in the Uniform index:", false, uniformWin)
		indexEdit = guiCreateEdit(100, 260, 130, 20, "", false, uniformWin)
		
		buttonSelect = guiCreateButton(30, 300, 100, 25, "Select", false, uniformWin)
		addEventHandler("onClientGUIClick", buttonSelect, 
		function( button, state )
			if ( button == "left" and state == "up" ) then
				
				local i = tonumber( guiGetText(indexEdit) )
				if ( i >= 1 and i <= 4 ) then
					
					local skin = skins[i]
					if ( skin ) then
						
						triggerServerEvent("setDetectiveDuty", localPlayer, faction, skin)
						
						destroyElement(uniformWin)
						
						if (isCursorShowing( )) then
							showCursor(false)
						end	
					else
						playSoundFrontEnd(32)
					end
				else
					playSoundFrontEnd(32)
				end	
			end
		end, false)
	
		buttonCancel = guiCreateButton(190, 300, 100, 25, "Cancel", false, uniformWin)
		addEventHandler("onClientGUIClick", buttonCancel, 
		function( button, state )
			if ( button == "left" and state == "up" ) then
				
				destroyElement(uniformWin)
				
				if (isCursorShowing( )) then
					showCursor(false)
				end	
			end
		end, false)
		
		guiSetPosition(informationLabel, (width/2) - (guiLabelGetTextExtent(informationLabel)/2), 240, false)
		guiSetFont(informationLabel, "default-bold-small")	
		
		showCursor(true)
	end	
end
addEvent("showDetectiveUI", true)
addEventHandler("showDetectiveUI", localPlayer, showDetectiveUI)