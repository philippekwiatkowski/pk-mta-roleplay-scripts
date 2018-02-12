local screenX, screenY = guiGetScreenSize( )

--------- [ Mobile Data Computer ] ---------
local suspectAdded = false
local suspectRemoved = false
local suspectEdited = false
local crimeAdded = false
local crimeRemoved = false

local suspects = { }
local crimes = { }
function giveTerminalData( s, c )
	suspects, crimes = s, c
end
addEvent("giveTerminalData", true)
addEventHandler("giveTerminalData", localPlayer, giveTerminalData)

addEventHandler("onClientResourceStart", resourceRoot,
function( )
	triggerServerEvent("getTerminalData", localPlayer)
end)

local mainButtons = { }
function showMobileDataTerminal( rank, leaderRank )
	local width, height = 447, 480
	local x, y = (screenX/2) - (width/2), (screenY/2) - (height/2)
	
	mdtWindow = guiCreateWindow(x, y, width, height, "Mobile Data Computer - BCSD", false)
	
	logo = guiCreateStaticImage(87, 30, 320, 80, "mdc/logo.png", false, mdtWindow)
	
	searchLabel = guiCreateLabel(20, 120, 120, 20, "Search Database:", false, mdtWindow)
	searchEdit = guiCreateEdit(20, 140, 277, 20, "", false, mdtWindow)
	
	-- Buttons --
	searchButton = guiCreateButton(307, 140, 120, 25, "Search", false, mdtWindow)
	addEventHandler("onClientGUIClick", searchButton, searchTerminal, false) 

	newSuspectButton = guiCreateButton(307, 175, 120, 25, "Add Suspect", false, mdtWindow)
	addEventHandler("onClientGUIClick", newSuspectButton, showAddSuspectToTerminalUI, false)
	
	local editButtonY = nil
	local isRemoveCrime = true
	
	if ( rank >= leaderRank ) then
		removeSuspectButton = guiCreateButton(307, 210, 120, 25, "Remove Suspect", false, mdtWindow)
		addEventHandler("onClientGUIClick", removeSuspectButton, showRemoveSuspectFromTerminalUI, false)
		
		editButtonY = 210 + 35
	else
		isRemoveCrime = false
		editButtonY = 210
	end
	
	editSuspectButton = guiCreateButton(307, editButtonY, 120, 25, "Edit Suspect", false, mdtWindow)
	addEventHandler("onClientGUIClick", editSuspectButton, showEditSuspectInTerminalUI, false)
	
	addCrime = guiCreateButton(307, editButtonY + 35, 120, 25, "Add Crime", false, mdtWindow)
	addEventHandler("onClientGUIClick", addCrime, showAddSuspectCrimeToTerminalUI, false)
	
	-- Table Feeding
	mainButtons[1] = searchButton
	mainButtons[2] = newSuspectButton
	
	if ( isElement( removeSuspectButton ) ) then
		mainButtons[3] = removeSuspectButton
	else
		mainButtons[3] = false
	end

	mainButtons[4] = editSuspectButton
	mainButtons[5] = addCrime
	
	if ( isRemoveCrime ) then
		removeCrime = guiCreateButton(307, editButtonY + 70, 120, 25, "Remove Crime", false, mdtWindow)
		addEventHandler("onClientGUIClick", removeCrime, showRemoveSuspectCrimeFromTerminalUI, false)
		
		mainButtons[6] = removeCrime
	end
	
	logoutButton = guiCreateButton(307, 400, 120, 25, "Logout", false, mdtWindow)
	addEventHandler("onClientGUIClick", logoutButton, logoutTerminal, false)
	-- -- -- -- --
	
	local guiGetText = "Welcome to San Fierro Police\nDepartment's Mobile Data Computer.\n\nThis database keeps a record of the\ncrimes committed by individuals of\nSan Fierro. It also keeps a track of the\ncurrent BOLO's and missions in SFPD.\n\nAs an officer it is your responsibility to keep\nthe database updated so that every officer\ncan use it effectively and efficiently."
	informationLabel = guiCreateLabel(20, 180, 277, 200, tostring(guiGetText), false, mdtWindow)
	
	-- Toggle Button --
	buttonToggle = guiCreateButton(20, 400, 120, 20, " (( Toggle Input )) ", false, mdtWindow)
	addEventHandler("onClientGUIClick", buttonToggle,
	function( button, state )
		if ( button == "left" and state == "up" ) then
			
			if ( guiGetInputEnabled( ) ) then
				guiSetInputEnabled(false)
			else
				guiSetInputEnabled(true)

			end
		end	
	end, false)
	
	toggleInformationLabel = guiCreateLabel(20, 430, 255, 30, "(( Click this to toggle input between window \n    and chatbox for example talking. ))", false, mdtWindow)
	-- -- -- -- --
	
	guiSetFont(searchLabel, "clear-normal")
	guiSetFont(informationLabel, "clear-normal")
	
	guiSetFont(toggleInformationLabel, "default-bold-small")
	
	guiSetInputEnabled(true)
end
addEvent("showMobileDataTerminal", true)
addEventHandler("showMobileDataTerminal", localPlayer, showMobileDataTerminal)

--------- [ Events ] ---------
local alphabets = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "-"}

-- // Logout \\
function logoutTerminal( button, state )
	if ( button == "left" and state == "up" ) then
		
		guiSetInputEnabled(false)
		destroyElement(mdtWindow)
	end
end

-- // Search \\
function searchTerminal( button, state )
	if ( button == "left" and state == "up" ) then
		
		local name = tostring( guiGetText(searchEdit):gsub(" ", "_") )
		
		-- ## Format must be 'Firstname_Lastname' ##
		name = fixSuspectName( name )
		
		local found = false
		for key, array in pairs ( suspects ) do
			if ( array[1] == name ) then
				
				local dbid = tonumber( key )
				
				for key, value in ipairs ( mainButtons ) do
					if ( value ~= source ) and ( value ~= false ) then
						
						guiSetEnabled(value, false)
					end
				end
				
				if ( isElement( informationPane ) ) then 
					destroyElement( informationPane )
				end	
				
				guiSetVisible(informationLabel, false)
				
				-- -- -- --
				informationPane = guiCreateScrollPane(20, 180, 270, 200, false, mdtWindow)
				
				local aboutLabel = guiCreateLabel(20, 0, 50, 20, "About", false, informationPane)
				
				local suspectNameLabel = guiCreateLabel(20, 20, 200, 20, "Name: ".. array[1]:gsub("_", " "), false, informationPane)
				local suspectJobLabel = guiCreateLabel(20, 35, 200, 20, "Occupation: ".. array[10], false, informationPane)
				local suspectDateOfBirthLabel = guiCreateLabel(20, 50, 120, 20, "DOB: ".. array[11], false, informationPane)
				
				local appearanceLabel = guiCreateLabel(20, 70, 70, 20, "Appearance", false, informationPane)
				
				local gender = ""
				if ( array[3] == 1 ) then
					gender = "Male"
				else
					gender = "Female"
				end
				
				local appearanceText = array[2] .." year old ".. array[6] .." ".. gender ..",\nabout ".. array[4] .." cm in height and\n".. array[5] .." kg in weight."
				
				local suspectPhoto = guiCreateStaticImage(200, 70, 60, 60, ":[ars]character-system/images/".. array[7] ..".png", false, informationPane)
				local suspectAppearanceLabel = guiCreateLabel(20, 90, 210, 60, tostring(appearanceText), false, informationPane)
				
				local contactLabel = guiCreateLabel(20, 140, 120, 20, "Contact Information", false, informationPane)
				
				local suspectPhoneLabel = guiCreateLabel(20, 160, 100, 20, "Phone: #".. array[8], false, informationPane)
				local suspectAddressLabel = guiCreateLabel(20, 175, 260, 20, "Address: ".. array[9], false, informationPane)
				
				local suspectCrimeRecordLabel = guiCreateLabel(20, 195, 110, 20, "Criminal Record:", false, informationPane)
				
				local x, y = 20, 215
				local count = 0
				for index, val in pairs ( crimes ) do
					if ( val[1] == dbid ) then
						
						local crimeIDLabel = guiCreateLabel(x, y, 100, 20, "Crime ID: #".. tostring( index ), false, informationPane)
						local crimeTimeLabel = guiCreateLabel(x, y + 20, 75, 20, "Time: ".. tostring( val[2] ), false, informationPane)
						local crimeDateLabel = guiCreateLabel(x, y + 35, 120, 20, "Date: ".. tostring( val[3] ), false, informationPane)
						
						local officersInvolvedLabel = guiCreateLabel(x, y + 60, 120, 20, "Personnel Involved:", false, informationPane)
						local officersInvolvedEdit = guiCreateEdit(145, y + 60, 100, 17, tostring( val[4] ), false, informationPane)
						guiEditSetReadOnly(officersInvolvedEdit, true)
						
						local punishmentType = tonumber( val[5] )
						local punishment = ""
						if ( punishmentType == 1 ) then
							punishment = "Arrested"
						elseif ( punishmentType == 2 ) then
							punishment = "Warning"
						elseif ( punishmentType == 3 ) then
							punishment = "Ticketed"
						end

						local crimePunishmentLabel = guiCreateLabel(x, y + 75, 170, 20, "Punishment Type: ".. tostring( punishment ), false, informationPane)
						
						local crimePunishmentPriceLabel
						local isArrest = false
						if ( punishmentType == 1 ) then
							crimePunishmentPriceLabel = guiCreateLabel(x, y + 90, 200, 20, "Arrest Fine: $".. tostring( val[7] ), false, informationPane)
							isArrest = true
						elseif ( punishmentType == 3 ) then
							crimePunishmentPriceLabel = guiCreateLabel(x, y + 90, 200, 20, "Ticket: $".. tostring( val[6] ), false, informationPane)
						end
						
						if ( isArrest ) then
							crimeArrestTimeLabel = guiCreateLabel(x, y + 105, 200, 20, "Arrest Time: ".. tostring( val[8] ) .." minute(s)", false, informationPane)
							guiSetFont(crimeArrestTimeLabel, "clear-normal")
							
							y = y + 15
						end
						
						local crimeDetailsLabel = guiCreateLabel(x, y + 115, 130, 20, "Details of the Crime:", false, informationPane)
						local crimeDetailsMemo = guiCreateMemo(x, y + 130, 230, 80, tostring( val[9] ), false, informationPane)
						guiMemoSetReadOnly(crimeDetailsMemo, true)
						
						guiSetFont(crimeIDLabel, "default-small")
						guiSetFont(crimeTimeLabel, "clear-normal")
						guiSetFont(crimeDateLabel, "clear-normal")
						guiSetFont(officersInvolvedLabel, "clear-normal")
						guiSetFont(crimePunishmentLabel, "clear-normal")
						guiSetFont(crimePunishmentPriceLabel, "clear-normal")
						guiSetFont(crimeDetailsLabel, "clear-normal")
						
						x, y = 20, y + 230
						count = count + 1
					end
				end
				
				if ( count == 0 ) then
					guiSetFont( guiCreateLabel(x, y, 200, 20, "No criminal record.", false, informationPane), "clear-normal" )
				end
				
				local backToMainButton = guiCreateButton(208, 0, 50, 20, "Back", false, informationPane)
				addEventHandler("onClientGUIClick", backToMainButton, 
				function( )
					
					destroyElement(informationPane)
					guiSetVisible(informationLabel, true)
					
					for key, value in ipairs ( mainButtons ) do
						if ( value ~= source ) and ( value ~= false ) then
							
							guiSetEnabled(value, true)
						end
					end
				end)
				-- -- -- --
				
				guiSetFont(aboutLabel, "default-bold-small")
				guiSetFont(appearanceLabel, "default-bold-small")
				guiSetFont(contactLabel, "default-bold-small")
				guiSetFont(suspectCrimeRecordLabel, "default-bold-small")
				
				guiSetFont(suspectNameLabel, "clear-normal") 
				guiSetFont(suspectJobLabel, "clear-normal") 
				guiSetFont(suspectDateOfBirthLabel, "clear-normal") 
				guiSetFont(suspectAppearanceLabel, "clear-normal") 
				guiSetFont(suspectPhoneLabel, "clear-normal") 
				guiSetFont(suspectAddressLabel, "clear-normal") 
				
				found = true
				break
			end
		end	
		
		if ( not found ) then
			
			guiSetText(searchEdit, "Could not find anyone with that name!")
			playSoundFrontEnd(32)
		end
	end
end

-- // Add Suspect \\
function showAddSuspectToTerminalUI( button, state )
	if ( button == "left" and state == "up" ) then
		
		guiSetVisible(informationLabel, false)
		
		-- -- -- --
		for key, value in ipairs ( mainButtons ) do
			if ( value ~= source ) and ( value ~= false ) then
				
				guiSetEnabled(value, false)
			end
		end
	
		if ( not isElement( addSuspectPane ) ) then
			
			addSuspectPane = guiCreateScrollPane(20, 180, 270, 200, false, mdtWindow)
		
			-- ## About ##
			local aboutLabel = guiCreateLabel(20, 0, 50, 20, "About", false, addSuspectPane)
			
			local suspectNameLabel = guiCreateLabel(20, 20, 40, 20, "Name:", false, addSuspectPane)
			local suspectNameEdit = guiCreateEdit(65, 20, 130, 17, "", false, addSuspectPane)
			
			local suspectDateOfBirthLabel = guiCreateLabel(20, 40, 40, 20, "D.O.B:", false, addSuspectPane)
			local suspectDateOfBirthEdit = guiCreateEdit(65, 40, 130, 17, "DD/MM/YY", false, addSuspectPane)
			
			local suspectJobLabel = guiCreateLabel(20, 60, 25, 20, "Job:", false, addSuspectPane)
			local suspectJobEdit = guiCreateEdit(50, 60, 130, 17, "", false, addSuspectPane)
			
			-- ## Appearance ##
			local appearanceLabel = guiCreateLabel(20, 80, 70, 20, "Appearance", false, addSuspectPane)
			
			local suspectAgeLabel = guiCreateLabel(20, 100, 30, 20, "Age:", false, addSuspectPane)
			local suspectAgeEdit = guiCreateEdit(55, 100, 130, 17, "", false, addSuspectPane)
			
			local suspectGenderLabel = guiCreateLabel(20, 120, 50, 20, "Gender:", false, addSuspectPane)
			
			local genderOptions = { }
			
			genderOptions[1] = guiCreateRadioButton(75, 120, 50, 20, "Male", false, addSuspectPane)
			genderOptions[2] = guiCreateRadioButton(130, 120, 65, 20, "Female", false, addSuspectPane)
			guiRadioButtonSetSelected(genderOptions[1], true)
			
			for key, value in ipairs ( genderOptions ) do
			
				addEventHandler("onClientGUIClick", value,
				function( button, state )
					if ( button == "left" and state == "up" ) then
						
						guiRadioButtonSetSelected(source, true)
						
						if ( key == 1 ) then
							guiRadioButtonSetSelected(genderOptions[2], false)
						else
							guiRadioButtonSetSelected(genderOptions[1], false)
						end	
					end
				end, false)
			end	
			
			local suspectRaceLabel = guiCreateLabel(20, 140, 60, 20, "Ethnicity:", false, addSuspectPane)
			local suspectRaceEdit = guiCreateEdit(85, 140, 130, 17, "White/Black/Asian", false, addSuspectPane)
			
			local suspectHeightLabel = guiCreateLabel(20, 160, 50, 20, "Height:", false, addSuspectPane)
			local suspectHeightEdit = guiCreateEdit(75, 160, 130, 17, "", false, addSuspectPane)
			
			local suspectWeightLabel = guiCreateLabel(20, 180, 50, 20, "Weight:", false, addSuspectPane)
			local suspectWeightEdit = guiCreateEdit(75, 180, 130, 17, "", false, addSuspectPane)
			
			-- ## Contact ##
			local contactLabel = guiCreateLabel(20, 200, 120, 20, "Contact Information", false, addSuspectPane)
			
			local suspectPhoneLabel = guiCreateLabel(20, 220, 45, 20, "Phone:", false, addSuspectPane)
			local suspectPhoneEdit = guiCreateEdit(70, 220, 130, 17, "", false, addSuspectPane)
			
			local suspectAddressLabel = guiCreateLabel(20, 240, 55, 20, "Address:", false, addSuspectPane)
			local suspectAddressEdit = guiCreateEdit(80, 240, 130, 17, "", false, addSuspectPane)
			
			addSuspectButton = guiCreateButton(30, 270, 90, 25, "Add Suspect", false, addSuspectPane)
			addEventHandler("onClientGUIClick", addSuspectButton,
			function( button, state )
				if ( button == "left" and state == "up" ) then
					
					local gender = nil
					if ( guiRadioButtonGetSelected(genderOptions[1]) ) then 
						gender = 1 
					else 
						gender = 2 
					end
					
					local age = guiGetText(suspectAgeEdit)
					local height = guiGetText(suspectHeightEdit)		
					local weight = guiGetText(suspectWeightEdit)
					
					-- Removal of units like, yr, km & cms
					for key, value in ipairs ( alphabets ) do
						if ( string.find( age, value ) ) then
							age = string.sub(age, 1, string.find( age, value ) - 1 )
						end
						
						if ( string.find( height, value ) ) then
							height = string.sub(height, 1, string.find( height, value ) - 1 )
						end
						
						if ( string.find( weight, value ) ) then
							weight = string.sub(weight, 1, string.find( weight, value ) - 1 )
						end	
					end	
					
					local array = { guiGetText(suspectNameEdit), guiGetText(suspectDateOfBirthEdit), guiGetText(suspectJobEdit), age, gender, guiGetText(suspectRaceEdit), height, weight, guiGetText(suspectPhoneEdit), guiGetText(suspectAddressEdit) }
					
					for key, value in ipairs ( array ) do	-- Fix for blank fields
						if ( tonumber( string.len( array[key] ) ) == 0 ) then
							array[key] = "N/A"
						end						
					end
					
					triggerServerEvent("addSuspectToTerminal", localPlayer, array)
					
					destroyElement(addSuspectPane)
					
					waitLabel = guiCreateLabel(20, 200, 270, 20, "~-~-~-~-~-~ Please wait... ~-~-~-~-~-~", false, mdtWindow)
					guiSetFont(waitLabel, "clear-normal")
					
					isAdded( )
				end
			end, false)
			
			cancelAddSuspectButton = guiCreateButton(150, 270, 90, 25, "Cancel", false, addSuspectPane)
			addEventHandler("onClientGUIClick", cancelAddSuspectButton,
			function( button, state )
				if ( button == "left" and state == "up" ) then
					
					destroyElement(addSuspectPane)
					guiSetVisible(informationLabel, true)
					
					for key, value in ipairs ( mainButtons ) do
						if ( value ~= addSuspectButton ) and ( value ~= false ) then
							
							guiSetEnabled(value, true)
						end
					end
				end
			end, false)
			
			local space = guiCreateButton(20, 290, 0, 20, "", false, addSuspectPane)
			-- -- -- --
			
			guiSetFont(aboutLabel, "default-bold-small")
			guiSetFont(appearanceLabel, "default-bold-small")
			guiSetFont(contactLabel, "default-bold-small")
			
			guiSetFont(suspectNameLabel, "clear-normal")
			guiSetFont(suspectDateOfBirthLabel, "clear-normal")
			guiSetFont(suspectJobLabel, "clear-normal")
			guiSetFont(suspectAgeLabel, "clear-normal")
			guiSetFont(suspectGenderLabel, "clear-normal")
			guiSetFont(suspectRaceLabel, "clear-normal")
			guiSetFont(suspectHeightLabel, "clear-normal")
			guiSetFont(suspectWeightLabel, "clear-normal")
			guiSetFont(suspectPhoneLabel, "clear-normal")
			guiSetFont(suspectAddressLabel, "clear-normal")
		end	
	end
end

-- // Remove Suspect \\
local isRemoveSuspectWindowOpen = false
local removeSuspectWindow = { }
function showRemoveSuspectFromTerminalUI( button, state )
	if ( button == "left" and state == "up" ) then
		
		guiSetVisible(informationLabel, false)
		-- -- -- --
		for key, value in ipairs ( mainButtons ) do
			if ( value ~= source ) and ( value ~= false ) then
				
				guiSetEnabled(value, false)
			end
		end
	
		if ( not isRemoveSuspectWindowOpen ) then
			
			suspectRemovalHelpLabel = guiCreateLabel(50, 180, 210, 40, "Type in the name of the suspect\nto be removed from the database:", false, mdtWindow)
			suspectRemovalEdit = guiCreateEdit(50, 215, 210, 17, "", false, mdtWindow)
			
			local buttonRemoveSuspect = guiCreateButton(30, 245, 110, 25, "Remove Suspect", false, mdtWindow)
			addEventHandler("onClientGUIClick", buttonRemoveSuspect, 
			function( button, state )
				if ( button == "left" and state == "up" ) then
					
					local name = tostring( guiGetText( suspectRemovalEdit ) )
					triggerServerEvent("removeSuspectFromTerminal", localPlayer, name)
					
					isRemoved( )
				end
			end, false)
			
			removeSuspectWindow[1] = suspectRemovalHelpLabel
			removeSuspectWindow[2] = suspectRemovalEdit
			removeSuspectWindow[3] = buttonRemoveSuspect
			
			local cancelRemoveSuspectButton = guiCreateButton(170, 245, 110, 25, "Cancel", false, mdtWindow)
			addEventHandler("onClientGUIClick", cancelRemoveSuspectButton, 
			function( button, state )
				if ( button == "left" and state == "up" ) then
					
					destroyElement(source)
					for key, value in ipairs ( removeSuspectWindow ) do
						destroyElement(value)
						
						if ( key == 3 ) then
							break
						end	
					end
					
					guiSetVisible(informationLabel, true)
					
					for key, value in ipairs ( mainButtons ) do
						if ( value ~= removeSuspectButton ) and ( value ~= false ) then
							
							guiSetEnabled(value, true)
						end
					end
					
					isRemoveSuspectWindowOpen = false
				end
			end, false)
			
			removeSuspectWindow[4] = cancelRemoveSuspectButton
			
			guiSetFont(suspectRemovalHelpLabel, "clear-normal")
			
			isRemoveSuspectWindowOpen = true
		end	
	end	
end

-- // Edit Suspect \\

local isEditSuspectWindowOpen = false 
local editSuspectWindow = { }
function showEditSuspectInTerminalUI( button, state )
	if ( button == "left" and state == "up" ) then
		
		guiSetVisible(informationLabel, false)
		-- -- -- --
		for key, value in ipairs ( mainButtons ) do
			if ( value ~= source ) and ( value ~= false ) then
				
				guiSetEnabled(value, false)
			end
		end
	
		if ( not isEditSuspectWindowOpen ) then
		
			local editSuspectSearchLabel = guiCreateLabel(50, 180, 210, 40, "Type in the name of the suspect\nwhose details you need to edit:", false, mdtWindow)
			local editSuspectSearchEdit = guiCreateEdit(50, 215, 210, 17, "", false, mdtWindow)
			
			local editSuspectSearchButton = guiCreateButton(30, 245, 110, 25, "Edit Suspect", false, mdtWindow)
			addEventHandler("onClientGUIClick", editSuspectSearchButton,
			function( button, state )
				if ( button == "left" and state == "up" ) then
					
					local name = tostring( guiGetText( editSuspectSearchEdit ) ):gsub(" ", "_")
					
					-- ## Format must be 'Firstname_Lastname' ##
					name = fixSuspectName( name )
					
					local found = false
					for key, array in pairs ( suspects ) do
						if ( array[1] == name ) then
							
							local dbid = tonumber( key )
							
							for key, value in ipairs ( editSuspectWindow ) do
								destroyElement(value)
							end
							
							editSuspectPane = guiCreateScrollPane(20, 180, 270, 200, false, mdtWindow)
							
							local aboutLabel = guiCreateLabel(20, 0, 50, 20, "About", false, editSuspectPane)
							
							local suspectNameLabel = guiCreateLabel(20, 20, 40, 20, "Name:", false, editSuspectPane)
							local suspectNameEdit = guiCreateEdit(65, 20, 130, 17, array[1]:gsub("_", " "), false, editSuspectPane)
							
							local suspectJobLabel = guiCreateLabel(20, 40, 25, 20, "Job:", false, editSuspectPane)
							local suspectJobEdit = guiCreateEdit(50, 40, 130, 17, array[10], false, editSuspectPane)
							
							local suspectDateOfBirthLabel = guiCreateLabel(20, 60, 40, 20, "DOB:", false, editSuspectPane)
							local suspectDateOfBirthEdit = guiCreateEdit(65, 60, 130, 17, array[11], false, editSuspectPane)
							
							local appearanceLabel = guiCreateLabel(20, 80, 70, 20, "Appearance", false, editSuspectPane)
							
							local gender = ""
							if ( array[3] == 1 ) then
								gender = "Male"
							else
								gender = "Female"
							end
							
							local suspectGenderLabel = guiCreateLabel(20, 100, 50, 20, "Gender:", false, editSuspectPane)
							local genderOptions = { }
			
							genderOptions[1] = guiCreateRadioButton(75, 100, 50, 20, "Male", false, editSuspectPane)
							genderOptions[2] = guiCreateRadioButton(130, 100, 65, 20, "Female", false, editSuspectPane)
							
							if ( array[3] == 1 ) then
								guiRadioButtonSetSelected(genderOptions[1], true)
							else
								guiRadioButtonSetSelected(genderOptions[2], true)
							end	
							
							for key, value in ipairs ( genderOptions ) do
							
								addEventHandler("onClientGUIClick", value,
								function( button, state )
									if ( button == "left" and state == "up" ) then
										
										guiRadioButtonSetSelected(source, true)
										
										if ( key == 1 ) then
											guiRadioButtonSetSelected(genderOptions[2], false)
										else
											guiRadioButtonSetSelected(genderOptions[1], false)
										end	
									end
								end, false)
							end	
							
							local suspectAgeLabel = guiCreateLabel(20, 120, 30, 20, "Age:", false, editSuspectPane)
							local suspectAgeEdit = guiCreateEdit(55, 120, 130, 17, array[2], false, editSuspectPane)
							
							local suspectRaceLabel = guiCreateLabel(20, 140, 60, 20, "Ethnicity:", false, editSuspectPane)
							local suspectRaceEdit = guiCreateEdit(85, 140, 130, 17, array[6], false, editSuspectPane)
							
							local suspectHeightLabel = guiCreateLabel(20, 160, 45, 20, "Height:", false, editSuspectPane)
							local suspectHeightEdit = guiCreateEdit(70, 160, 130, 17, array[4], false, editSuspectPane)
							
							local suspectWeightLabel = guiCreateLabel(20, 180, 48, 20, "Weight:", false, editSuspectPane)
							local suspectWeightEdit = guiCreateEdit(73, 180, 130, 17, array[5], false, editSuspectPane)
							
							local skin = ""
							if ( tonumber( array[7] ) == -2 ) then
								skin = "None"
							else
								skin = tostring( array[7] )
							end
							
							local suspectPhotoLabel = guiCreateLabel(20, 200, 120, 20, "Photo (( Skin ID )):", false, editSuspectPane)
							local suspectPhotoEdit = guiCreateEdit(145, 200, 100, 17, skin, false, editSuspectPane)
							
							local contactLabel = guiCreateLabel(20, 220, 120, 20, "Contact Information", false, editSuspectPane)
							
							local suspectPhoneLabel = guiCreateLabel(20, 240, 45, 20, "Phone:", false, editSuspectPane)
							local suspectPhoneEdit = guiCreateEdit(70, 240, 130, 17, array[8], false, editSuspectPane)
							
							local suspectAddressLabel = guiCreateLabel(20, 260, 60, 20, "Address:", false, editSuspectPane)
							local suspectAddressEdit = guiCreateEdit(85, 260, 130, 17, array[9], false, editSuspectPane)
							
							local editSuspectButton = guiCreateButton(30, 290, 90, 25, "Edit Suspect", false, editSuspectPane)
							addEventHandler("onClientGUIClick", editSuspectButton,
							function( button, state )
								if ( button == "left" and state == "up" ) then
									
									local gender = nil
									if ( guiRadioButtonGetSelected(genderOptions[1]) ) then 
										gender = 1 
									else 
										gender = 2 
									end
									
									local age = guiGetText(suspectAgeEdit)
									local height = guiGetText(suspectHeightEdit)		
									local weight = guiGetText(suspectWeightEdit)
									
									-- Removal of units like, yr, km & cms
									for key, value in ipairs ( alphabets ) do
										if ( string.find( age, value ) ) then
											age = string.sub(age, 1, string.find( age, value ) - 1 )
										end
										
										if ( string.find( height, value ) ) then
											height = string.sub(height, 1, string.find( height, value ) - 1 )
										end
										
										if ( string.find( weight, value ) ) then
											weight = string.sub(weight, 1, string.find( weight, value ) - 1 )
										end	
									end	
					
									local array = { dbid, guiGetText(suspectNameEdit), guiGetText(suspectDateOfBirthEdit), guiGetText(suspectJobEdit), age, gender, guiGetText(suspectRaceEdit), height, weight, guiGetText(suspectPhotoEdit), guiGetText(suspectPhoneEdit), guiGetText(suspectAddressEdit) }
									
									for key, value in ipairs ( array ) do	-- Fix for blank fields
										if ( tonumber( string.len( array[key] ) ) == 0 ) then
											array[key] = "N/A"
										end						
									end
					
									triggerServerEvent("editSuspectInTerminal", localPlayer, array)
									
									destroyElement(editSuspectPane)
									
									waitLabel = guiCreateLabel(20, 200, 270, 20, "~-~-~-~-~-~ Please wait... ~-~-~-~-~-~", false, mdtWindow)
									guiSetFont(waitLabel, "clear-normal")
									
									isEdited( )
								end
							end, false)
							
							local buttonEditSuspectCancel = guiCreateButton(150, 290, 90, 25, "Cancel", false, editSuspectPane)
							addEventHandler("onClientGUIClick", buttonEditSuspectCancel,
							function( button, state )
								if ( button == "left" and state == "up" ) then
									
									destroyElement(editSuspectPane)
									guiSetVisible(informationLabel, true)
									
									for key, value in ipairs ( mainButtons ) do
										if ( value ~= editSuspectButton ) and ( value ~= false ) then
											
											guiSetEnabled(value, true)
										end
									end
								end
							end, false)
							
							local space = guiCreateButton(20, 310, 0, 20, "", false, editSuspectPane)
							
							guiSetFont(aboutLabel, "default-bold-small")
							guiSetFont(appearanceLabel, "default-bold-small")
							guiSetFont(contactLabel, "default-bold-small")
							
							guiSetFont(suspectNameLabel, "clear-normal")
							guiSetFont(suspectJobLabel, "clear-normal")
							guiSetFont(suspectDateOfBirthLabel, "clear-normal")
							guiSetFont(suspectGenderLabel, "clear-normal")
							guiSetFont(suspectAgeLabel, "clear-normal")
							guiSetFont(suspectRaceLabel, "clear-normal")
							guiSetFont(suspectHeightLabel, "clear-normal")
							guiSetFont(suspectWeightLabel, "clear-normal")
							guiSetFont(suspectPhotoLabel, "clear-normal")
							guiSetFont(suspectPhoneLabel, "clear-normal")
							guiSetFont(suspectAddressLabel, "clear-normal")
							
							found = true
							break
						end
					end	
					
					if ( not found ) then
						
						local text = guiGetText(editSuspectSearchLabel)
						guiSetText(editSuspectSearchLabel, "~-~-~-~ Invalid entry! ~-~-~-~")
						
						playSoundFrontEnd(32)
						
						setTimer(guiSetText, 1500, 1, editSuspectSearchLabel, text) 
					end
				end	
			end, false)
			
			editSuspectWindow[1] = editSuspectSearchLabel
			editSuspectWindow[2] = editSuspectSearchEdit
			editSuspectWindow[3] = editSuspectSearchButton
			
			local editSuspectCancelButton = guiCreateButton(170, 245, 110, 25, "Cancel", false, mdtWindow)
			addEventHandler("onClientGUIClick", editSuspectCancelButton, 
			function( button, state )
				if ( button == "left" and state == "up" ) then
					
					destroyElement(source)
					for key, value in ipairs ( editSuspectWindow ) do
						destroyElement(value)
						
						if ( key == 3 ) then
							break
						end	
					end
					
					guiSetVisible(informationLabel, true)
					
					for key, value in ipairs ( mainButtons ) do
						if ( value ~= editSuspectButton ) and ( value ~= false ) then
							
							guiSetEnabled(value, true)
						end
					end
					
					isEditSuspectWindowOpen = false
				end
			end, false)
			
			editSuspectWindow[4] = editSuspectCancelButton
			
			guiSetFont(editSuspectSearchLabel, "clear-normal")
			isEditSuspectWindowOpen = true
		end
	end	
end

function showAddSuspectCrimeToTerminalUI( button, state )
	if ( button == "left" and state == "up" ) then
		
		guiSetVisible(informationLabel, false)
		-- -- -- --
		for key, value in ipairs ( mainButtons ) do
			if ( value ~= source ) and ( value ~= false ) then
				
				guiSetEnabled(value, false)
			end
		end
	
		if ( not isElement( addSuspectCrimePane ) ) then
			
			addSuspectCrimePane = guiCreateScrollPane(20, 180, 270, 200, false, mdtWindow)
			
			local criminalNameLabel = guiCreateLabel(20, 20, 95, 20, "Criminal Name:", false, addSuspectCrimePane)
			local criminalNameEdit = guiCreateEdit(120, 20, 130, 17, "", false, addSuspectCrimePane)
			
			local crimeTimeLabel = guiCreateLabel(20, 50, 90, 20, "Time of Crime:", false, addSuspectCrimePane)
			local crimeTimeEdit = guiCreateEdit(115, 50, 130, 17, "HH:MM", false, addSuspectCrimePane)
			
			local crimeDateLabel = guiCreateLabel(20, 70, 90, 20, "Date of Crime:", false, addSuspectCrimePane)
			local crimeDateEdit = guiCreateEdit(115, 70, 130, 17, "DD/MM/YY", false, addSuspectCrimePane)
			
			local involvedOfficersLabel = guiCreateLabel(20, 100, 120, 20, "Personnel Involved:", false, addSuspectCrimePane) 
			local involdedOfficersEdit = guiCreateEdit(145, 100, 130, 17, "", false, addSuspectCrimePane)
			
			local punishmentTypeLabel = guiCreateLabel(20, 120, 115, 20, "Punishment Type:", false, addSuspectCrimePane) 
			local punishmentOptions = { }
			
			punishmentOptions[1] = guiCreateRadioButton(140, 120, 55, 20, "Arrest", false, addSuspectCrimePane) 
			punishmentOptions[2] = guiCreateRadioButton(200, 120, 65, 20, "Warning", false, addSuspectCrimePane)
			punishmentOptions[3] = guiCreateRadioButton(140, 140, 55, 20, "Ticket", false, addSuspectCrimePane)
			
			guiRadioButtonSetSelected(punishmentOptions[1], true)
			
			local punishmentType = 1
			for key, value in ipairs ( punishmentOptions ) do
				
				guiSetFont(value, "default-bold-small")
				
				addEventHandler("onClientGUIClick", value,
					function( button, state )
						if ( button == "left" and state == "up" ) then
							
							guiRadioButtonSetSelected(source, true)
							
							for index, button in ipairs ( punishmentOptions ) do
								if ( button ~= source ) then
									
									guiRadioButtonSetSelected(button, false)
								elseif ( button == source ) then
									
									punishmentType = index
								end
							end
						end
					end, false
				)	
			end
			
			local ticketPriceLabel = guiCreateLabel(20, 160, 88, 20, "Ticket Price: $", false, addSuspectCrimePane)
			local ticketPriceEdit = guiCreateEdit(113, 160, 130, 17, "", false, addSuspectCrimePane)
			
			local arrestTimeLabel = guiCreateLabel(20, 180, 75, 20, "Arrest Time:", false, addSuspectCrimePane)
			local arrestTimeEdit = guiCreateEdit(100, 180, 130, 17, "", false, addSuspectCrimePane)
			
			local arrestFineLabel = guiCreateLabel(20, 200, 85, 20, "Arrest Fine: $", false, addSuspectCrimePane)
			local arrestFineEdit = guiCreateEdit(110, 200, 130, 17, "", false, addSuspectCrimePane)
			
			local detailsLabel = guiCreateLabel(20, 230, 150, 20, "Full details of the crime:", false, addSuspectCrimePane)
			local detailsMemo = guiCreateMemo(20, 250, 230, 80, "When, where, how etc.", false, addSuspectCrimePane)
			
			local buttonAddSuspectCrime = guiCreateButton(30, 350, 90, 25, "Add Crime", false, addSuspectCrimePane)
			addEventHandler("onClientGUIClick", buttonAddSuspectCrime,
			function( button, state )
				if ( button == "left" and state == "up" ) then
					
					local criminalName = tostring( guiGetText(criminalNameEdit) ):gsub(" ", "_")
					criminalName = fixSuspectName( criminalName )
					
					local ticketPrice = tostring( guiGetText(ticketPriceEdit) )
					if ( ticketPrice == "" ) then
						ticketPrice = "0"
					end

					local arrestFine = tostring( guiGetText(arrestFineEdit) )
					if ( arrestFine == "" ) then
						arrestFine = "0"
					end
					
					local arrestTime = tostring( guiGetText(arrestTimeEdit) )
					if ( arrestTime == "" ) then
						arrestTime = "0"
					end
					
					-- Remove units like, mins/hours
					for key, value in ipairs ( alphabets ) do
						if ( string.find( arrestTime, value ) ) then
							arrestTime = string.sub(arrestTime, 1, string.find( arrestTime, value ) - 1 )
						end
					end	
					
					local suspectID = false
					for key, value in pairs ( suspects ) do
						if ( value[1] == criminalName ) then
							
							suspectID = key
							break
						end
					end
					
					if ( suspectID ~= false ) then
						
						local array = { suspectID, guiGetText(crimeTimeEdit), guiGetText(crimeDateEdit), guiGetText(involdedOfficersEdit), punishmentType, ticketPrice, arrestFine, arrestTime, guiGetText(detailsMemo) }
						triggerServerEvent("addSuspectCrimeToTerminal", localPlayer, array)
						
						destroyElement(addSuspectCrimePane)
					
						waitLabel = guiCreateLabel(20, 200, 270, 20, "~-~-~-~-~-~ Please wait... ~-~-~-~-~-~", false, mdtWindow)
						guiSetFont(waitLabel, "clear-normal")
						
						isCrimeAdded( )
					else
						playSoundFrontEnd(32)
					end	
				end
			end, false)	
			
			local buttonCancelAddSuspectCrime = guiCreateButton(150, 350, 90, 25, "Cancel", false, addSuspectCrimePane)
			addEventHandler("onClientGUIClick", buttonCancelAddSuspectCrime,
			function( button, state )
				if ( button == "left" and state == "up" ) then
					
					destroyElement(addSuspectCrimePane)
					guiSetVisible(informationLabel, true)
					
					for key, value in ipairs ( mainButtons ) do
						if ( value ~= addCrime ) and ( value ~= false ) then
							
							guiSetEnabled(value, true)
						end
					end
				end
			end, false)	
			
			local space = guiCreateButton(20, 370, 0, 20, "", false, addSuspectCrimePane)
			
			guiSetFont(criminalNameLabel, "clear-normal")
			guiSetFont(crimeTimeLabel, "clear-normal")
			guiSetFont(crimeDateLabel, "clear-normal")
			guiSetFont(involvedOfficersLabel, "clear-normal")
			guiSetFont(punishmentTypeLabel, "clear-normal")
			guiSetFont(ticketPriceLabel, "clear-normal")
			guiSetFont(arrestTimeLabel, "clear-normal")
			guiSetFont(arrestFineLabel, "clear-normal")
			guiSetFont(detailsLabel, "clear-normal")
		end
	end
end

local isRemoveSuspectCrimeWindowOpen = false
local removeSuspectCrimeWindow = { }
function showRemoveSuspectCrimeFromTerminalUI( button, state )
	if ( button == "left" and state == "up" ) then
		
		guiSetVisible(informationLabel, false)
		-- -- -- --
		for key, value in ipairs ( mainButtons ) do
			if ( value ~= source ) and ( value ~= false ) then
				
				guiSetEnabled(value, false)
			end
		end
	
		if ( not isRemoveSuspectCrimeWindowOpen ) then
			
			suspectCrimeRemovalHelpLabel = guiCreateLabel(50, 180, 220, 40, "Type in the ID of the suspect crime\nto be removed from the database:", false, mdtWindow)
			local suspectCrimeRemovalEdit = guiCreateEdit(50, 215, 210, 17, "", false, mdtWindow)
			
			local buttonRemoveSuspectCrime = guiCreateButton(30, 245, 110, 25, "Remove Crime", false, mdtWindow)
			addEventHandler("onClientGUIClick", buttonRemoveSuspectCrime, 
			function( button, state )
				if ( button == "left" and state == "up" ) then
					
					local id = tonumber( guiGetText( suspectCrimeRemovalEdit ) )
					triggerServerEvent("removeSuspectCrimeFromTerminal", localPlayer, id)
					
					isCrimeRemoved( )
				end
			end, false)
			
			removeSuspectCrimeWindow[1] = suspectCrimeRemovalHelpLabel
			removeSuspectCrimeWindow[2] = suspectCrimeRemovalEdit
			removeSuspectCrimeWindow[3] = buttonRemoveSuspectCrime
			
			local cancelRemoveSuspectCrimeButton = guiCreateButton(170, 245, 110, 25, "Cancel", false, mdtWindow)
			addEventHandler("onClientGUIClick", cancelRemoveSuspectCrimeButton, 
			function( button, state )
				if ( button == "left" and state == "up" ) then
					
					destroyElement(source)
					for key, value in ipairs ( removeSuspectCrimeWindow ) do
						destroyElement(value)
						
						if ( key == 3 ) then
							break
						end	
					end
					
					guiSetVisible(informationLabel, true)
					
					for key, value in ipairs ( mainButtons ) do
						if ( value ~= removeCrime ) and ( value ~= false ) then
							
							guiSetEnabled(value, true)
						end
					end
					
					isRemoveSuspectCrimeWindowOpen = false
				end
			end, false)
			
			removeSuspectCrimeWindow[4] = cancelRemoveSuspectCrimeButton
			
			guiSetFont(suspectCrimeRemovalHelpLabel, "clear-normal")
			
			isRemoveSuspectCrimeWindowOpen = true
		end	
	end	
end

-- // ADD SUSPECT \\

local addedTimer = nil
function isAdded( )
	if ( suspectAdded ) then
		
		destroyElement(waitLabel)
		guiSetVisible(informationLabel, true)
		
		for key, value in ipairs ( mainButtons ) do
			if ( key ~= 2 ) and ( value ~= false ) then
				
				guiSetEnabled(value, true)
			end
		end
	
		suspectAdded = false
	else
		addedTimer = setTimer(isAdded, 1000, 1)
	end
end	
	
function informSuspectAddition( )
	suspectAdded = true
end
addEvent("informSuspectAddition", true)
addEventHandler("informSuspectAddition", localPlayer, informSuspectAddition)

function giveAdditionError( reason )
	
	guiSetText(waitLabel, "~- ".. tostring(reason) .." ~-")
	playSoundFrontEnd(32)
	
	killTimer(addedTimer)
	setTimer(
		function( )
			destroyElement(waitLabel)
			guiSetVisible(informationLabel, true)
			
			for key, value in ipairs ( mainButtons ) do
				if ( key ~= 2 ) and ( value ~= false ) then
					
					guiSetEnabled(value, true)
				end
			end
		end, 3000, 1
	)	
end
addEvent("giveAdditionError", true)
addEventHandler("giveAdditionError", localPlayer, giveAdditionError)

-- // REMOVE SUSPECT \\

local removalTimer = nil
function isRemoved( )
	if ( suspectRemoved ) then
		
		local text = guiGetText(suspectRemovalHelpLabel)
		guiSetText(suspectRemovalHelpLabel, "~-~-~- Suspect Removed! ~-~-~-")
		
		setTimer( 
			function( )
				
				guiSetText(suspectRemovalHelpLabel, text)
			end, 1500, 1
		)
		
		suspectRemoved = false
	else
		removalTimer = setTimer(isRemoved, 1000, 1)
	end	
end

function informSuspectRemoval( )
	suspectRemoved = true
end
addEvent("informSuspectRemoval", true)
addEventHandler("informSuspectRemoval", localPlayer, informSuspectRemoval)

function giveRemovalError( reason )
	
	local text = guiGetText(suspectRemovalHelpLabel)
	guiSetText(suspectRemovalHelpLabel, "~-~-~-~ ".. tostring(reason) .." ~-~-~-~")
	
	playSoundFrontEnd(32)
	
	if ( isTimer( removalTimer ) ) then
		killTimer( removalTimer )
	end
	
	setTimer(
		function( )
			
			guiSetText(suspectRemovalHelpLabel, text)
		end, 1500, 1
	)
end
addEvent("giveRemovalError", true)
addEventHandler("giveRemovalError", localPlayer, giveRemovalError)
	
-- // EDIT SUSPECT \\
function isEdited( )
	if ( suspectEdited ) then
		
		destroyElement(waitLabel)
		guiSetVisible(informationLabel, true)
		
		for key, value in ipairs ( mainButtons ) do
			if ( key ~= 4 ) and ( value ~= false ) then
				
				guiSetEnabled(value, true)
			end
		end
	
		suspectEdited = false
		isEditSuspectWindowOpen = false
	else
		editedTimer = setTimer(isEdited, 1000, 1)
	end
end

function informSuspectEdited( )
	suspectEdited = true
end
addEvent("informSuspectEdited", true)
addEventHandler("informSuspectEdited", localPlayer, informSuspectEdited)

-- // ADD CRIME \\
local crimeTimer = nil
function isCrimeAdded( )
	if ( crimeAdded ) then
		
		destroyElement(waitLabel)
		guiSetVisible(informationLabel, true)
		
		for key, value in ipairs ( mainButtons ) do
			if ( key ~= 5 ) and ( value ~= false ) then
				
				guiSetEnabled(value, true)
			end
		end
		
		crimeAdded = false
	else
		crimeTimer = setTimer(isCrimeAdded, 1000, 1)
	end
end

function informSuspectCrimeAddition( )
	crimeAdded = true
end
addEvent("informSuspectCrimeAddition", true)
addEventHandler("informSuspectCrimeAddition", localPlayer, informSuspectCrimeAddition)

-- // REMOVE CRIME \\

local crimeRemovalTimer = nil
function isCrimeRemoved( )
	if ( crimeRemoved ) then
		
		local text = guiGetText(suspectCrimeRemovalHelpLabel)
		guiSetText(suspectCrimeRemovalHelpLabel, "~-~-~-~ Crime Removed! ~-~-~-~")
		
		setTimer( 
			function( )
				
				guiSetText(suspectCrimeRemovalHelpLabel, text)
			end, 1500, 1
		)
		
		crimeRemoved = false
	else
		crimeRemovalTimer = setTimer(isCrimeRemoved, 1000, 1)
	end	
end

function giveCrimeRemovalError( reason )
	
	local text = guiGetText(suspectCrimeRemovalHelpLabel)
	guiSetText(suspectCrimeRemovalHelpLabel, "~-~-~-~ ".. tostring(reason) .." ~-~-~-~")
	
	playSoundFrontEnd(32)
	
	if ( isTimer( crimeRemovalTimer ) ) then
		killTimer( crimeRemovalTimer )
	end
	
	setTimer(
		function( )
			
			guiSetText(suspectCrimeRemovalHelpLabel, text)
		end, 1500, 1
	)
end
addEvent("giveCrimeRemovalError", true)
addEventHandler("giveCrimeRemovalError", localPlayer, giveCrimeRemovalError)

function informSuspectCrimeRemoval( )
	crimeRemoved = true
end
addEvent("informSuspectCrimeRemoval", true)
addEventHandler("informSuspectCrimeRemoval", localPlayer, informSuspectCrimeRemoval)

function fixSuspectName( name )
	local name = tostring(name)
	local underscore = string.find(name, "_")
	
	if ( underscore == nil ) then
		name = name .."_"
		underscore = string.find(name, "_")
	end
	
	local f, l = string.sub(name, 1, 1), string.sub(name, underscore + 1, underscore + 1)
	local s = string.upper(f) .. string.sub(name, 2, underscore) .. string.upper(l) .. string.sub(name, underscore + 2)
	
	return s
end