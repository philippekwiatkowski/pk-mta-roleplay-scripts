local screenX, screenY = guiGetScreenSize( )
local selection = nil 
local clicked = false
local c_characters = { }
local currentTab = 1

--------- [ Account Management ] ---------
function showCharactersUI( characters, theFriends, messages, skinmods, weaponmods, vehiclemods )
	
	local winWidth, winHeight = 480, 450
	local winX, winY = (screenX - screenX) + (20), (screenY/2) - (winHeight/2)
	
	accountWindow = guiCreateWindow(winX, winY, winWidth, winHeight, "Welcome to your account", false)
	
	accountPanel = guiCreateTabPanel(20, 30, 440, 390, false, accountWindow)
	charactersTab = guiCreateTab("Character Selection", accountPanel)
	friendsTab = guiCreateTab("Your Friends", accountPanel)
	--manageTab = guiCreateTab("Manage your Account", accountPanel)
	
	-- CHARACTER SELECTION
	characterLabel = guiCreateLabel(20, 10, 400, 40, "Double click on a character to spawn, or click 'New Character'.", false, charactersTab) 
	guiSetFont(characterLabel, "clear-normal")
	
	characterPane = guiCreateScrollPane(30, 50, 400, 300, false, charactersTab) 	
	paneElements = { }
	
	-- Populating
	local objectY, objectX = 20, 20
	local objects = 0
	for i, v in ipairs ( characters ) do	
		
		objects = objects + 1
		
		paneElements[i] = { }
		
		paneElements[i][1] = guiCreateStaticImage(objectX, objectY, 64, 64, "images/".. tostring(characters[i][3]) ..".png", false, characterPane)
		paneElements[i][2] = guiCreateLabel(objectX, objectY + 74, 100, 20, tostring(characters[i][2]), false, characterPane)
		
		guiSetFont(paneElements[i][2], "default-bold-small")
		
		if (objects == 3) then
			objectY, objectX = objectY + 100, 20
			objects = 0
		else
			objectX = objectX + 120
		end	
		
		addEventHandler("onClientGUIClick", paneElements[i][1], selectCharacter, false)
		addEventHandler("onClientGUIDoubleClick", paneElements[i][1], doubleSelectCharacter, false)
	end	
	
	-- New Character
	local i = #paneElements + 1
	paneElements[i] = { }
	paneElements[i][1] = guiCreateStaticImage(objectX, objectY, 64, 64, "images/-1.png", false, characterPane)
	paneElements[i][2] = guiCreateLabel(objectX, objectY + 74, 100, 20, "New Character", false, characterPane)
	
	guiSetFont(paneElements[i][2], "default-bold-small")
	
	addEventHandler("onClientGUIClick", paneElements[i][1], selectCharacter, false)
	addEventHandler("onClientGUIDoubleClick", paneElements[i][1], showCreateCharacterUI, false)
	
	-- Selection
	local imgX, imgY = guiGetPosition(paneElements[1][1], false)
	selection = guiCreateStaticImage(imgX - 6, imgY - 4, 76, 74, "images/selection.png", false, characterPane) 
	
	addEventHandler("onClientGUIClick", selection, function( ) guiMoveToBack(source) end, false)
	
	guiMoveToBack(selection)
	guiSetAlpha(selection, 0)
	
	-- Store the characters
	c_characters = characters 
	
	-- FRIEND SYSTEM
	friendsPane = guiCreateScrollPane(30, 50, 400, 300, false, friendsTab) 	
	
	local friendY = 10
	local friendCount = 0
	local onlineFriendCount = 0
	local closeFriendCount = 0
	for key, value in ipairs ( theFriends ) do
		
		local username = tostring( value[1] )
		local country = tostring( value[2] )
		local sameCountry = tostring( value[3] )
		local lastlogin = tonumber( value[4] )
		local onlineName = exports['[ars]friends-system']:isFriendOnline( username )
		
		local text = nil
		if ( lastlogin > 1 ) then
			text = tostring( lastlogin ) .." days ago"
		elseif ( lastlogin == 1 ) then
			text = "Yesterday"
		elseif ( lastlogin == 0 ) then
			text = "Today"
		end	
		
		local statusText = "Online"
		local loginText = "Playing as: ".. tostring( onlineName )
		local red, green, blue = 0, 255, 0
		
		onlineFriendCount = onlineFriendCount + 1
		if ( onlineName == false ) then
			statusText = "Offline"
			loginText =  "Last seen: ".. text
			red, green, blue = 255, 0, 0
			
			onlineFriendCount = onlineFriendCount - 1
		end
		
		local flag = guiCreateStaticImage(20, friendY, 75, 35, ":[ars]global/flags/".. tostring( country ):gsub(" ", "_") ..".png", false, friendsPane)
		local header = guiCreateLabel(120, friendY, 250, 20, tostring( username ) .." (".. tostring( country ) ..")" , false, friendsPane)
		local playStatus = guiCreateLabel( guiLabelGetTextExtent( header ) + 130, friendY, 48, 20, " - ".. tostring( statusText ), false, friendsPane)
		local login = guiCreateLabel(120, friendY + 20, 200, 20, loginText, false, friendsPane)
		
		local banned = tonumber( value[5] )
		if ( banned == 1 ) then
			guiCreateStaticImage(130, friendY - 16, 100, 59, "images/banned.png", false, friendsPane)
		end	
		
		if ( sameCountry == "true" ) then
			closeFriendCount = closeFriendCount + 1
		end
		
		guiSetFont(header, "default-bold-small")
		guiSetFont(login, "default-bold-small")
		guiSetFont( playStatus, "default-bold-small")
		
		guiLabelSetColor( playStatus, red, green, blue )
		
		friendY = friendY + 60
		friendCount = friendCount + 1
	end
	
	local friendText = "You have not added any friends yet, right click on a player\nIn-Game and click 'Add Friend' to add them as your friend."
	if ( friendCount ~= 0 ) then
		friendText = "You have ".. friendCount .." friend(s) in total. ".. onlineFriendCount .." online, ".. closeFriendCount .." from your country."
	end
	
	local friendLabel = guiCreateLabel(20, 20, 400, 40, friendText, false, friendsTab)
	guiSetFont(friendLabel, "clear-normal")
	
	showCursor(true)
end
addEvent("showCharactersUI", true)
addEventHandler("showCharactersUI", getLocalPlayer(), showCharactersUI)	

function selectCharacter( button, state )
	if (button == "left" and state == "up") then
		
		local element = nil
		for i, j in ipairs ( paneElements ) do
			for k, v in ipairs ( paneElements[i] ) do
				if ( v == source ) then
					
					element = { v, i }
					break
				end
			end
		end	
		
		if (element ~= nil) then
			
			local imgX, imgY = guiGetPosition(element[1], false)
			guiSetPosition(selection, imgX - 6, imgY - 4, false)
			guiSetAlpha(selection, 0.7)
			
			playSoundFrontEnd(10)
			
			if (element[1] ~= paneElements[#paneElements][1]) then -- Not 'New character'
	
				displayInformation( element, false )
			else
				
				displayInformation( element, true )
			end	
		end	
	end	
end

function displayInformation( element, newCharacter )
		
	if not isElement(informationWindow) then
		
		informationWindow = guiCreateWindow(screenX - 200, screenY - 200, 200, 200, "Information", false)
	
		nameInfo = guiCreateLabel(65, 20, 100, 20, "", false, informationWindow) 			
		ageInfo = guiCreateLabel(20, 60, 200, 20, "", false, informationWindow) 
		genderInfo = guiCreateLabel(20, 80, 200, 20, "", false, informationWindow) 
		factionInfo = guiCreateLabel(20, 100, 200, 20, "", false, informationWindow) 
		rankInfo = guiCreateLabel(20, 120, 200, 20, "", false, informationWindow) 
		lastareaInfo = guiCreateLabel(20, 140, 200, 20, "", false, informationWindow)
		
		guiSetFont(nameInfo, "default-bold-small")
		guiSetFont(ageInfo, "default-bold-small")
		guiSetFont(genderInfo, "default-bold-small")
		guiSetFont(factionInfo, "default-bold-small")
		guiSetFont(rankInfo, "default-bold-small")
		guiSetFont(lastareaInfo, "default-bold-small")
	end
	
	if not (newCharacter) then
	
		local gender = tonumber(c_characters[element[2]][6])
		if (gender == 1) then
			gender = "Male"
		else
			gender = "Female"
		end
	
		guiSetText(nameInfo, tostring(c_characters[element[2]][2]))
		guiSetText(ageInfo, "Age: ".. tostring(c_characters[element[2]][8]) .." years old")
		guiSetText(genderInfo, "Gender: ".. tostring(gender))
		guiSetText(factionInfo, "Faction: ".. tostring(c_characters[element[2]][4]))
		
		local rank
		if (tostring(c_characters[element[2]][4]) == "Not in a faction") then
			rank = "N/A"
		else
			rank = tostring(c_characters[element[2]][5])
		end
		
		guiSetText(rankInfo, "Rank: ".. tostring(rank))
		guiSetText(lastareaInfo, "Last Area: ".. tostring(c_characters[element[2]][7]))
	
		guiSetSize(ageInfo, 200, 20, false)
		
	elseif (newCharacter) then
	
		guiSetText(nameInfo, "New Character")
		guiSetText(ageInfo, "Double click here to create a\nnew character.\n\nYou can create your custom\ncharacter with just 3 easy\nsteps!")
		guiSetText(genderInfo, "")
		guiSetText(factionInfo, "")
		guiSetText(rankInfo, "")
		guiSetText(lastareaInfo, "")
	
		guiSetSize(ageInfo, 200, 120, false)
	end	
end

function doubleSelectCharacter( button, state )
	if (button == "left" and state == "up") then
		
		local index = nil
		for i, j in ipairs ( paneElements ) do
			for k, v in ipairs ( paneElements[i] ) do
				if ( v == source ) then
					
					index = i
					break
				end
			end
		end	
		
		if (index ~= nil) then 
			
			destroyElement(accountWindow)
			destroyElement(informationWindow)
			showCursor(false)
			
			local characterName = tostring(c_characters[index][2])
			
			triggerServerEvent("spawnCharacter", getLocalPlayer(), characterName)
		end
	end
end

--------- [ Character Creation ] ---------
local creationStep = 0
local beenToStep1, beenToStep2, beenToStep3, beenToStep4 = false, false, false, false

local character = { }
character["name"] = "Matthew Anderson"
character["gender"] = 1
character["ethnicity"] = 1
character["skin"] = 264
character["height"] = 170
character["weight"] = 65
character["age"] = 24
character["description"] = "You can enter your character's build, eye colour, hair color or any other special appearance feature here."

local bMale = {7, 14, 15, 16, 17, 18, 20, 21, 22, 24, 25, 28, 35, 36, 50, 51, 66, 67, 78, 79, 80, 83, 84, 102, 103, 104, 105, 106, 107, 134, 136, 142, 143, 144, 156, 163, 166, 168, 176, 180, 182, 183, 185, 220, 221, 222, 249, 253, 260, 262 }
local bFemale = {9, 10, 11, 12, 13, 40, 41, 63, 64, 69, 76, 91, 139, 148, 190, 195, 207, 215, 218, 219, 238, 243, 244, 245, 256 }
local wMale = {23, 26, 27, 29, 30, 32, 33, 34, 35, 36, 37, 38, 43, 44, 45, 46, 47, 48, 50, 51, 52, 53, 58, 59, 60, 61, 62, 68, 70, 72, 73, 78, 81, 82, 94, 95, 96, 97, 98, 99, 100, 101, 108, 109, 110, 111, 112, 113, 114, 115, 116, 120, 121, 122, 124, 125, 126, 127, 128, 132, 133, 135, 137, 146, 147, 153, 154, 155, 158, 159, 160, 161, 162, 164, 165, 170, 171, 173, 174, 175, 177, 179, 181, 184, 186, 187, 188, 189, 200, 202, 204, 206, 209, 212, 213, 217, 223, 230, 234, 235, 236, 240, 241, 242, 247, 248, 250, 252, 254, 255, 258, 259, 261, 264 }
local wFemale = {12, 31, 38, 39, 40, 41, 53, 54, 55, 56, 64, 75, 77, 85, 86, 87, 88, 89, 90, 91, 92, 93, 129, 130, 131, 138, 140, 145, 150, 151, 152, 157, 172, 178, 192, 193, 194, 196, 197, 198, 199, 201, 205, 211, 214, 216, 224, 225, 226, 231, 232, 233, 237, 243, 246, 251, 257, 263 }
local aMale = {49, 57, 58, 59, 60, 117, 118, 120, 121, 122, 123, 170, 186, 187, 203, 210, 227, 228, 229}
local aFemale = {38, 53, 54, 55, 56, 88, 141, 169, 178, 224, 225, 226, 263}

function showCreateCharacterUI( button, state )
	if (button == "left" and state == "up") then
		
		clicked = false

		destroyElement(accountWindow)
		destroyElement(informationWindow)
		
		local creationWidth, creationHeight = 300, 420
		local creationX, creationY = (screenX/2) - (creationWidth/2), (screenY/2) - (creationHeight/2)
		
		creationWindow = guiCreateWindow(creationX, creationY, creationWidth, creationHeight, "New Character - Welcome", false)
		
		creationInfo = guiCreateLabel(20, 50, 280, 220, "Welcome to Arsenic Roleplay's\nCharacter Creation system.\n\nThis system will give you a step-by-step\nguide on how to create a character and\nstart playing on our server.\n\nThe process of character creation consists\nof 3 easy steps:\n1. Name your character\n2. Customize your character\n3. Describe your character\n\nClick 'Next' to begin creating your character", false, creationWindow) 
		creationIcon = guiCreateStaticImage(220, 170, 64, 64, "images/extra.png", false, creationWindow)
		
		btnBack = guiCreateButton(20, 380, 110, 20, "Back", false, creationWindow)
		addEventHandler("onClientGUIClick", btnBack, creationStepBack, false)
		
		btnNext = guiCreateButton(170, 380, 110, 20, "Next", false, creationWindow)
		addEventHandler("onClientGUIClick", btnNext, creationStepNext, false)
		
		guiSetFont(creationInfo, "clear-normal")
	end
end	

function creationStepNext( button, state )
	if (button == "left" and state == "up") then
		
		if (creationStep == 0) then
			
			guiSetVisible(creationInfo, false)
			
			if not (beenToStep1) then
				
				nameLbl = guiCreateLabel(38, 50, 280, 110, "Name:", false, creationWindow)
				nameEdit = guiCreateEdit(80, 48, 130, 20, "Matthew Anderson", false, creationWindow)
				namingInfo = guiCreateLabel(20, 80, 280, 110, "Please type in your desired character\nname above, be sure that you character\nname obeys all the character naming\nrules that are listed on the right. Failure\nto produce a name that obeys these\nrules will result in the deletion of your\ncharacter.", false, creationWindow) 
				
				windowRules = guiCreateWindow(screenX - 220, screenY - 220, 220, 220, "Character Naming Rules", false)
				rulesLbl = guiCreateLabel(10, 30, 280, 160, "- Your name must be in the\n	  format - 'Firstname Lastname'.\n\n- Your must not contain any\n	  underscore, use space.\n\n- Your name must only contain\n	  alphabets.\n\n- Your name must not match\n	  the name of any celebrity.", false, windowRules)
						
				guiSetPosition(creationIcon, 220, 180, false)
				
				guiSetFont(nameLbl, "clear-normal")
				guiSetFont(namingInfo, "clear-normal")
				guiSetFont(rulesLbl, "clear-normal")
				
				beenToStep1 = true
			else
			
				guiSetVisible(nameLbl, true)
				guiSetVisible(nameEdit, true)
				guiSetVisible(namingInfo, true)
				guiSetVisible(windowRules, true)
			end	
			
			guiSetText(creationWindow, "New Character - Step 1")
			
			creationStep = 1
		elseif (creationStep == 1) then
			
			guiSetVisible(nameLbl, false)
			guiSetVisible(nameEdit, false)
			guiSetVisible(namingInfo, false)
			guiSetVisible(windowRules, false)
			
			character["name"] = guiGetText(nameEdit)
			
			if not (beenToStep2) then
			
				customizeInfo = guiCreateLabel(20, 50, 280, 40, "You can now customize your character by\nselecting its gender, ethnicity and skin.", false, creationWindow)
				genderLabel = guiCreateLabel(20, 100, 180, 20, "Select your character's gender", false, creationWindow)
				cMale = guiCreateCheckBox(20, 120, 50, 20, "Male", true, false, creationWindow)
				cFemale = guiCreateCheckBox(80, 120, 57, 20, "Female", false, false, creationWindow)
				
				character["gender"] = 1
				
				addEventHandler("onClientGUIClick", cMale,
				function( button, state )
					if (button == "left" and state == "up") then
						
						character["gender"] = 1
						generateSkin( )
						
						guiCheckBoxSetSelected(cMale, true)
						guiCheckBoxSetSelected(cFemale, false)
					end
				end, false)

				addEventHandler("onClientGUIClick", cFemale,
				function( button, state )
					if (button == "left" and state == "up") then
						
						character["gender"] = 2
						generateSkin( )
						
						guiCheckBoxSetSelected(cFemale, true)
						guiCheckBoxSetSelected(cMale, false)
					end
				end, false)
				
				ethnicityLabel = guiCreateLabel(20, 170, 200, 20, "Select your character's ethnicity", false, creationWindow)
				rWhite = guiCreateRadioButton(20, 190, 55, 20, "White", false, creationWindow)
				guiRadioButtonSetSelected(rWhite, true)
				
				rBlack = guiCreateRadioButton(80, 190, 50, 20, "Black", false, creationWindow)
				rAsian = guiCreateRadioButton(140, 190, 50, 20, "Asian", false, creationWindow)
				
				character["ethnicity"] = 1
				
				addEventHandler("onClientGUIClick", rWhite,
				function( button, state )
					if (button == "left" and state == "up") then
						
						character["ethnicity"] = 1
						generateSkin( )
						
						guiRadioButtonSetSelected(rWhite, true)
						guiRadioButtonSetSelected(rBlack, false)
						guiRadioButtonSetSelected(rAsian, false)
					end
				end, false)
				
				addEventHandler("onClientGUIClick", rBlack,
				function( button, state )
					if (button == "left" and state == "up") then
						
						character["ethnicity"] = 2
						generateSkin( )
						
						guiRadioButtonSetSelected(rWhite, false)
						guiRadioButtonSetSelected(rBlack, true)
						guiRadioButtonSetSelected(rAsian, false)
					end
				end, false)
				
				addEventHandler("onClientGUIClick", rAsian,
				function( button, state )
					if (button == "left" and state == "up") then
						
						character["ethnicity"] = 3
						generateSkin( )
						
						guiRadioButtonSetSelected(rWhite, false)
						guiRadioButtonSetSelected(rBlack, false)
						guiRadioButtonSetSelected(rAsian, true)
					end
				end, false)
				
				skinLabel = guiCreateLabel(20, 240, 200, 20, "Select your character's skin", false, creationWindow)
				btnLastSkin = guiCreateButton(20, 270, 90, 20, "Previous", false, creationWindow)
				btnNextSkin = guiCreateButton(194, 270, 90, 20, "Next", false, creationWindow)
				imgSkin = guiCreateStaticImage(120, 270, 64, 64, "images/264.png", false, creationWindow)
				
				generateSkin( )
				
				addEventHandler("onClientGUIClick", btnLastSkin, browseSkins, false)
				addEventHandler("onClientGUIClick", btnNextSkin, browseSkins, false)
				
				guiSetFont(customizeInfo, "clear-normal")
				guiSetFont(genderLabel, "default-bold-small")
				guiSetFont(ethnicityLabel, "default-bold-small")
				guiSetFont(skinLabel, "default-bold-small")
				
				beenToStep2 = true
			else
				
				guiSetVisible(customizeInfo, true)
				guiSetVisible(genderLabel, true)
				guiSetVisible(cMale, true)
				guiSetVisible(cFemale, true)
				guiSetVisible(ethnicityLabel, true)
				guiSetVisible(rWhite, true)
				guiSetVisible(rBlack, true)
				guiSetVisible(rAsian, true)
				guiSetVisible(skinLabel, true)
				guiSetVisible(btnLastSkin, true)
				guiSetVisible(btnNextSkin, true)
				guiSetVisible(imgSkin, true)
			end	
			
			guiSetPosition(creationIcon, 220, 100, false)
			guiSetText(creationWindow, "New Character - Step 2")
			
			creationStep = 2
		elseif (creationStep == 2) then
			
			guiSetVisible(creationIcon, false)
				
			guiSetVisible(customizeInfo, false)
			guiSetVisible(genderLabel, false)
			guiSetVisible(cMale, false)
			guiSetVisible(cFemale, false)
			guiSetVisible(ethnicityLabel, false)
			guiSetVisible(rWhite, false)
			guiSetVisible(rBlack, false)
			guiSetVisible(rAsian, false)
			guiSetVisible(skinLabel, false)
			guiSetVisible(btnLastSkin, false)
			guiSetVisible(btnNextSkin, false)
			guiSetVisible(imgSkin, false)
			
			if not (beenToStep3) then
			
				describeInfo = guiCreateLabel(20, 50, 280, 70, "Please describe your character to us, it is\nnecessary because other players may\npossess the same skin as you, but not\nthe same special features.", false, creationWindow)
				
				heightLbl = guiCreateLabel(20, 130, 180, 40, "Enter your character's height:\n( between 152 & 213 cms )", false, creationWindow)
				heightUnitLbl = guiCreateLabel(255, 130, 180, 40, "cms", false, creationWindow)
				heightEdit = guiCreateEdit(200, 130, 50, 20, "170", false, creationWindow)
				
				weightLbl = guiCreateLabel(20, 180, 180, 40, "Enter your character's weight:\n( between 60 & 120 kg )", false, creationWindow)
				weightUnitLbl = guiCreateLabel(255, 180, 180, 40, "kg", false, creationWindow)
				weightEdit = guiCreateEdit(200, 180, 50, 20, "65", false, creationWindow)
				
				ageLbl = guiCreateLabel(20, 230, 180, 40, "Enter your character's age:\n( between 18 & 80 yrs. )", false, creationWindow)
				ageUnitLbl = guiCreateLabel(255, 230, 180, 40, "yrs.", false, creationWindow)
				ageEdit = guiCreateEdit(200, 230, 50, 20, "24", false, creationWindow)
				
				visualDescribleLbl = guiCreateLabel(20, 270, 240, 40, "Please provide us with a SMALL visual\ndescription of your character:", false, creationWindow)
				describeMemo = guiCreateMemo(20, 300, 240, 60, "You can enter your character's build, eye colour, hair color or any other special appearance feature here.", false, creationWindow)
				
				guiSetFont(describeInfo, "clear-normal")
				guiSetFont(heightLbl, "default-bold-small")
				guiSetFont(heightUnitLbl, "default-bold-small")
				guiSetFont(weightLbl, "default-bold-small")
				guiSetFont(weightUnitLbl, "default-bold-small")
				guiSetFont(ageLbl, "default-bold-small")
				guiSetFont(ageUnitLbl, "default-bold-small")
				guiSetFont(visualDescribleLbl, "default-bold-small")
				
				beenToStep3 = true
			else

				guiSetVisible(describeInfo, true)
				guiSetVisible(heightLbl, true)
				guiSetVisible(heightUnitLbl, true)
				guiSetVisible(heightEdit, true)
				guiSetVisible(weightLbl, true)
				guiSetVisible(weightUnitLbl, true)
				guiSetVisible(weightEdit, true)
				guiSetVisible(ageLbl, true)
				guiSetVisible(ageUnitLbl, true)
				guiSetVisible(ageEdit, true)
				guiSetVisible(visualDescribleLbl, true)
				guiSetVisible(describeMemo, true)	
			end
			
			guiSetText(creationWindow, "New Character - Step 3")
			
			creationStep = 3
		elseif (creationStep == 3) then
			
			character["height"] = guiGetText(heightEdit)
			character["weight"] = guiGetText(weightEdit)
			character["age"] = guiGetText(ageEdit)
			character["description"] = guiGetText(describeMemo)
			
			guiSetVisible(describeInfo, false)
			guiSetVisible(heightLbl, false)
			guiSetVisible(heightUnitLbl, false)
			guiSetVisible(heightEdit, false)
			guiSetVisible(weightLbl, false)
			guiSetVisible(weightUnitLbl, false)
			guiSetVisible(weightEdit, false)
			guiSetVisible(ageLbl, false)
			guiSetVisible(ageUnitLbl, false)
			guiSetVisible(ageEdit, false)
			guiSetVisible(visualDescribleLbl, false)
			guiSetVisible(describeMemo, false)
			
			if not (beenToStep4) then
				
				finalizeInfo = guiCreateLabel(15, 50, 280, 90, "The character creation process is finished,\nclick 'Create' to create your new character,\nonce created you cannot delete it yourself,\nso we suggest that you go back one time\nand review all the information that you\nhave entered.", false, creationWindow)
				
				btnCreateCharacter = guiCreateButton(110, 180, 80, 80, "Create!", false, creationWindow)
				addEventHandler("onClientGUIClick", btnCreateCharacter, createClientCharacter, false) 
				
				guiSetFont(finalizeInfo, "clear-normal")
				
				beenToStep4 = true
			else
				
				guiSetVisible(finalizeInfo, true)
				guiSetVisible(btnCreateCharacter, true)
			end	
				
			guiSetVisible(btnNext, false)
			guiSetPosition(btnBack, 100, 380, false)
			guiSetText(creationWindow, "New Character - Finish")
			
			creationStep = 4
		end
	end
end

local skinIndex
function generateSkin( )
	local gender = tonumber(character["gender"])
	local ethnicity = tonumber(character["ethnicity"])
	local skinint = 0
	local skin
	
	if (gender == 1) then 
						
		if (ethnicity == 1) then 
								
			skinint = math.random(1, #wMale)
			skin = wMale[skinint]
			
			guiStaticImageLoadImage(imgSkin, "images/".. skin ..".png")
			character["skin"] = skin	
			
		elseif (ethnicity == 2) then 
								
			skinint = math.random(1, #bMale)
			skin = bMale[skinint]
			
			guiStaticImageLoadImage(imgSkin, "images/".. skin ..".png")
			character["skin"] = skin
			
		elseif (ethnicity == 3) then 
								
			skinint = math.random(1, #aMale)
			skin = aMale[skinint]
			
			guiStaticImageLoadImage(imgSkin, "images/".. skin ..".png")
			character["skin"] = skin
			
		end
						
	elseif (gender == 2) then 
						
		if (ethnicity == 1) then 
						
			skinint = math.random(1, #wFemale)
			skin = wFemale[skinint]
			
			guiStaticImageLoadImage(imgSkin, "images/".. skin ..".png")
			character["skin"] = skin
			
		elseif (ethnicity == 2) then 
						
			skinint = math.random(1, #bFemale)
			skin = bFemale[skinint]
			
			guiStaticImageLoadImage(imgSkin, "images/".. skin ..".png")
			character["skin"] = skin
			
		elseif (ethnicity == 3) then
					
			skinint = math.random(1, #aFemale)
			skin = aFemale[skinint]
			
			guiStaticImageLoadImage(imgSkin, "images/".. skin ..".png")
			character["skin"] = skin	
			
		end
	end
	skinIndex = skinint
end

function browseSkins( button, state )
	if (button == "left" and state == "up") then
		
		local gender = tonumber(character["gender"])
		local ethnicity = tonumber(character["ethnicity"])
		local skin
		local t = nil
			
		if (ethnicity == 1) then 
			
			if (gender == 1) then 
				t = wMale
			elseif (gender == 2) then 
				t = wFemale
			end
		
		elseif (ethnicity == 2) then 
			
			if (gender == 1) then 
				t = bMale
			elseif (gender == 2) then 	
				t = bFemale
			end
		
		elseif (ethnicity == 3) then
			
			if (gender == 1) then 
				t = aMale
			elseif (gender == 2) then
				t = aFemale
			end
			
		end
		
		if (source == btnNextSkin) then
			
			if (skinIndex == #t) then
				
				skinIndex = 1
				skin = t[1]
				
				guiStaticImageLoadImage(imgSkin, "images/".. skin ..".png")
				character["skin"] = skin
			else
				skinIndex = skinIndex + 1
				skin = t[skinIndex]
				
				guiStaticImageLoadImage(imgSkin, "images/".. skin ..".png")
				character["skin"] = skin
			end
		elseif (source == btnLastSkin) then
			
			if (skinIndex == 1) then
				
				skinIndex = #t
				skin = t[1]
				
				guiStaticImageLoadImage(imgSkin, "images/".. skin ..".png")
				character["skin"] = skin
			else
				skinIndex = skinIndex - 1
				skin = t[skinIndex]
				
				guiStaticImageLoadImage(imgSkin, "images/".. skin ..".png")
				character["skin"] = skin
			end
		end
	end
end

function creationStepBack( button, state )
	if (button == "left" and state == "up") then
	
		if (creationStep == 0) then
			destroyElement(creationWindow)
			
			if isElement(windowRules) then
				destroyElement(windowRules)
			end
		
			showCharactersUI( c_characters )
			
			-- Reset Globals
			creationStep = 0
			beenToStep1, beenToStep2, beenToStep3, beenToStep4 = false, false, false, false

			character = { }
			character["name"] = "Matthew Anderson"
			character["gender"] = 1
			character["ethnicity"] = 1
			character["skin"] = 264
			character["height"] = 170
			character["weight"] = 65
			character["age"] = 24
			character["description"] = "You can enter your character's build, eye colour, hair color or any other special appearance feature here."
			
		elseif (creationStep == 1) then
			
			guiSetVisible(creationInfo, true)
			
			guiSetVisible(nameLbl, false)
			guiSetVisible(nameEdit, false)
			guiSetVisible(namingInfo, false)
			guiSetVisible(windowRules, false)
			
			guiSetPosition(creationIcon, 220, 170, false)
			guiSetText(creationWindow, "New Character - Welcome")
			
			creationStep = 0
		elseif (creationStep == 2) then
			
			guiSetVisible(customizeInfo, false)
			guiSetVisible(genderLabel, false)
			guiSetVisible(cMale, false)
			guiSetVisible(cFemale, false)
			guiSetVisible(ethnicityLabel, false)
			guiSetVisible(rWhite, false)
			guiSetVisible(rBlack, false)
			guiSetVisible(rAsian, false)
			guiSetVisible(skinLabel, false)
			guiSetVisible(btnLastSkin, false)
			guiSetVisible(btnNextSkin, false)
			guiSetVisible(imgSkin, false)
			
			guiSetVisible(nameLbl, true)
			guiSetVisible(nameEdit, true)
			guiSetVisible(namingInfo, true)
			guiSetVisible(windowRules, true)

			guiSetPosition(creationIcon, 220, 180, false)
			guiSetText(creationWindow, "New Character - Step 1")
			
			creationStep = 1
		elseif (creationStep == 3) then
			
			guiSetVisible(describeInfo, false)
			guiSetVisible(heightLbl, false)
			guiSetVisible(heightUnitLbl, false)
			guiSetVisible(heightEdit, false)
			guiSetVisible(weightLbl, false)
			guiSetVisible(weightUnitLbl, false)
			guiSetVisible(weightEdit, false)
			guiSetVisible(ageLbl, false)
			guiSetVisible(ageUnitLbl, false)
			guiSetVisible(ageEdit, false)
			guiSetVisible(visualDescribleLbl, false)
			guiSetVisible(describeMemo, false)
			
			guiSetVisible(customizeInfo, true)
			guiSetVisible(genderLabel, true)
			guiSetVisible(cMale, true)
			guiSetVisible(cFemale, true)
			guiSetVisible(ethnicityLabel, true)
			guiSetVisible(rWhite, true)
			guiSetVisible(rBlack, true)
			guiSetVisible(rAsian, true)
			guiSetVisible(skinLabel, true)
			guiSetVisible(btnLastSkin, true)
			guiSetVisible(btnNextSkin, true)
			guiSetVisible(imgSkin, true)
			
			guiSetVisible(creationIcon, true)
			guiSetText(creationWindow, "New Character - Step 2")
			
			creationStep = 2
		elseif (creationStep == 4) then

			if isElement(creationError) then
				destroyElement(creationError)
			end
			
			guiSetVisible(finalizeInfo, false)
			guiSetVisible(btnCreateCharacter, false)
			
			guiSetVisible(describeInfo, true)
			guiSetVisible(heightLbl, true)
			guiSetVisible(heightUnitLbl, true)
			guiSetVisible(heightEdit, true)
			guiSetVisible(weightLbl, true)
			guiSetVisible(weightUnitLbl, true)
			guiSetVisible(weightEdit, true)
			guiSetVisible(ageLbl, true)
			guiSetVisible(ageUnitLbl, true)
			guiSetVisible(ageEdit, true)
			guiSetVisible(visualDescribleLbl, true)
			guiSetVisible(describeMemo, true)
			
			guiSetPosition(btnBack, 20, 380, false)
			guiSetVisible(btnNext, true)
			guiSetText(creationWindow, "New Character - Step 3")
			
			creationStep = 3
		end	
	end
end

function showCreationError( text )
	local text = tostring(text)
	
	if isElement(creationError) then
		destroyElement(creationError)
	end
	
	creationError = guiCreateLabel(20, 280, 280, 20, tostring(text), false, creationWindow)
	local width, height = guiLabelGetTextExtent(creationError), 20
	local x, y = (150) - (width/2), 280
	
	guiSetPosition(creationError, x, y, false)
	
	guiLabelSetColor(creationError, 255, 0, 0)
	guiSetFont(creationError, "default-bold-small")
	
	setTimer(function() if isElement(creationError) then destroyElement(creationError) end end, 3000, 1)
	
	playSoundFrontEnd(32)
end	
addEvent("showCreationError", true)
addEventHandler("showCreationError", getLocalPlayer(), showCreationError)

local numbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 0} 
local alphabets = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"}
function createClientCharacter( button, state )
	if ( button == "left" and state == "up" ) then
		if ( not clicked ) then
			
			clicked = true
			
			local name = character["name"]
			local gender = character["gender"]
			local ethnicity = character["ethnicity"]
			local skin = character["skin"]
			local height = character["height"]
			local weight = character["weight"]
			local age = character["age"]
			local description = character["description"]
			
			local correctName, correctHeight, correctWeight, correctAge = true, true, true, true
			for i, v in ipairs ( numbers ) do
				if string.find(name, v) then
				
					showCreationError("Invalid character name entered on Step 1.")
					correctName = false
					return
				end	
			end
				
			for i, v in ipairs ( alphabets ) do
				if string.find(string.lower(height), v) then
				
					showCreationError("Invalid height entered on Step 3.")
					correctHeight = false
					return
				end
					
				if string.find(string.lower(weight), v) then
				
					showCreationError("Invalid weight entered on Step 3.")
					correctWeight = false
					return
				end
				
				if string.find(string.lower(age), v) then
				
					showCreationError("Invalid age entered on Step 3.")
					correctAge = false
					return
				end
			end	
			
			if (correctName and correctHeight and correctWeight and correctAge) then
				
				if (tonumber(height) >= 152 and tonumber(height) <= 213) then
					
					if (tonumber(weight) >= 60 and tonumber(weight) <= 120) then
						
						if (tonumber(age) >= 18 and tonumber(age) <= 80) then
							
							triggerServerEvent("createCharacter", getLocalPlayer(), tostring(name):gsub("_", " "), gender, ethnicity, skin, height, weight, age, description)
						else
							showCreationError("Age must be between 18 and 80 yrs.")
						end	
					else
						showCreationError("Weight must be between 60 and 120 kg.")
					end
				else	
					showCreationError("Height must be between 152 and 213 cms.")
				end	
			end
		end	
	end
end

function endCharacterCreation( )
	
	destroyElement(creationWindow)
	
	if isElement(windowRules) then
		destroyElement(windowRules)
	end
		
	local getData = exports['[ars]anticheat-system']
	
	local username = getData:c_callData(getLocalPlayer(), "accountname")
	local id = getData:c_callData(getLocalPlayer(), "accountid")
	local admin = getData:c_callData(getLocalPlayer(), "admin")
	local adminduty = getData:c_callData(getLocalPlayer(), "adminduty")
	local hiddenadmin = getData:c_callData(getLocalPlayer(), "hiddenadmin")
	local reports = getData:c_callData(getLocalPlayer(), "adminreports")
	local donator = getData:c_callData(getLocalPlayer(), "donator")
	
	triggerServerEvent("loginPlayer", getLocalPlayer(), username, id, admin, adminduty, hiddenadmin, reports, donator, false)
			
	-- Reset Globals
	creationStep = 0
	beenToStep1, beenToStep2, beenToStep3, beenToStep4 = false, false, false, false

	character = { }
	character["name"] = "Matthew Anderson"
	character["gender"] = 1
	character["ethnicity"] = 1
	character["skin"] = 264
	character["height"] = 170
	character["weight"] = 65
	character["age"] = 24
	character["description"] = "You can enter your character's build, eye colour, hair color or any other special appearance feature here."
end
addEvent("endCharacterCreation", true)
addEventHandler("endCharacterCreation", getRootElement(), endCharacterCreation)

function clearCharacterScreen( )
	
	if ( accountWindow ) then
		destroyElement(accountWindow)
		accountWindow = nil
	end
	
	if ( informationWindow ) then
		destroyElement(informationWindow)
		informationWindow = nil
	end	
end
addEvent("clearCharacterScreen", true)
addEventHandler("clearCharacterScreen", localPlayer, clearCharacterScreen)