--------- [ Element Data returns ] ---------
local function getData( theElement, key )
	local key = tostring(key)
	if isElement(theElement) and (key) then
		
		return exports['[ars]anticheat-system']:c_callData( theElement, tostring(key) )
	else
		return false
	end
end	

--------- [ Phone System ] ---------
local screenX, screenY = guiGetScreenSize( )
local menu = "main"

local ringtone = "flute"
local wallpaper = "red"
local listContacts = ""

local wallpapers = { "red", "blue", "black" }
local ringtones = { "flute", "business", "pretty" }

local phoneNumber = false
local network = "Good"

function givePhoneDetails( details )
	if ( details ) then
		for key, value in pairs ( details ) do
			
			ringtone = ringtones[value[1]]
			wallpaper = wallpapers[value[2]]
			
			if ( not string.find( value[3], "userdata" ) ) then -- wierd bug
				listContacts = value[3]
			end
		end
	end	
end
addEvent("givePhoneDetails", true)
addEventHandler("givePhoneDetails", localPlayer, givePhoneDetails)

-- ## PHONE COVER ##
local winX, winY = nil
function drawPhoneCover( )

	dxDrawImage(winX - 27, winY - 40, 253, 350, "phone.png")
end

function createPhoneUI( )
	if ( getData( localPlayer, "loggedin" ) == 1 ) then
		
		local width, height = 200, 242
		winX, winY = (screenX/2) - (width/2), (screenY/2) - (height/2)
		
		if ( not isElement( phoneWindow ) ) then
			
			if ( exports['[ars]inventory-system']:hasItem( 3 ) ) then -- Do they have a phone?
				
				phoneWindow = guiCreateWindow(winX, winY, width, height, "", false)
				addEventHandler("onClientGUIClick", phoneWindow, stickPhone, false)
				
				addEventHandler("onClientRender", root, drawPhoneCover)
				
				guiWindowSetMovable( phoneWindow, false )
				guiWindowSetSizable( phoneWindow, false )
				
				wallpaperImage = guiCreateStaticImage(0, 10, 200, 250, "wallpapers/".. wallpaper ..".png", false, phoneWindow) 
				addEventHandler("onClientGUIClick", wallpaperImage, stickWallpaper, false)
				
				networkLabel = guiCreateLabel(18, 20, 90, 20, "Network: ".. network, false, phoneWindow)
				batteryLabel = guiCreateLabel(115, 20, 90, 20, "Battery: 100%", false, phoneWindow) 
				
				local hour, minutes = getTime( )
				if ( hour < 10 ) then
					hour = "0".. hour
				end
				
				if ( minutes < 10 ) then
					minutes = "0".. minutes
				end
				
				timeLabel = guiCreateLabel(47, 40, 106, 40, hour ..":".. minutes, false, phoneWindow)
				
				buttonContacts = guiCreateStaticImage(20, 90, 32, 32, "icons/contacts.png", false, phoneWindow)
				labelContacts = guiCreateLabel(60, 95, 50, 20, "Contacts", false, phoneWindow)
				
				addEventHandler("onClientGUIClick", buttonContacts, createPhoneContactsUI, false)
				
				buttonMenu = guiCreateStaticImage(20, 140, 32, 32, "icons/menu.png", false, phoneWindow)
				labelMenu = guiCreateLabel(60, 145, 50, 20, "Menu", false, phoneWindow)
				
				addEventHandler("onClientGUIClick", buttonMenu, createPhoneMenuUI, false)
				
				buttonOff = guiCreateStaticImage(20, 190, 32, 32, "icons/off.png", false, phoneWindow)
				labelOff = guiCreateLabel(60, 195, 80, 20, "Switch Off", false, phoneWindow)
				
				addEventHandler("onClientGUIClick", buttonOff,
					function( button, state )
						if ( button == "left" and state == "up" ) then
							
							removeEventHandler("onClientRender", root, drawPhoneCover)
							destroyElement( phoneWindow )
							
							guiSetInputEnabled( false )
						end	
					end, false
				)
				
				guiSetAlpha(wallpaperImage, 0.7)
				
				guiSetFont(timeLabel, "sa-header")
				
				guiSetFont(labelContacts, "default-bold-small")
				guiSetFont(labelMenu, "default-bold-small")
				guiSetFont(labelOff, "default-bold-small")
				
				guiSetFont(networkLabel, "default-small")
				guiSetFont(batteryLabel, "default-small")
			else
				outputChatBox("You do not have a phone.", 255, 0, 0)
			end	
		else
			removeEventHandler("onClientRender", root, drawPhoneCover)
			destroyElement( phoneWindow )
			
			guiSetInputEnabled( false )
		end
	end	
end
addEvent("createPhoneUI", true)
addEventHandler("createPhoneUI", localPlayer, createPhoneUI)

-- PHONE TIME & NETWORK
addEventHandler("onClientRender", root,
	function( )
		if isElement( timeLabel ) then
			
			local hour, minutes = getTime( )
			if ( hour < 10 ) then
				hour = "0".. hour
			end
			
			if ( minutes < 10 ) then
				minutes = "0".. minutes
			end
			
			guiSetText(timeLabel, hour ..":".. minutes)
		end	
	end
)	

setTimer( 
	function( )
		
		local rand = math.random( 1, 3 )
		if ( rand == 1 ) then
			network = "Poor"
		elseif ( rand == 2 ) then
			network = "Good"
		else
			network = "Strong"
		end
		
		if isElement( networkLabel ) then
			guiSetText( networkLabel, "Network: ".. network )
		end	
	end, 60000, 0
)
	
-- ## CONTACTS ##
local contacts = { }
local contact = nil
function createPhoneContactsUI( button, state )
	if ( button == "left" and state == "up" ) then
		
		phoneMenu = "contacts"
		
		guiSetVisible(timeLabel, false)
		
		guiSetVisible(buttonContacts, false)
		guiSetVisible(labelContacts, false)
		
		guiSetVisible(buttonMenu, false)
		guiSetVisible(labelMenu, false)
		
		guiSetVisible(buttonOff, false)
		guiSetVisible(labelOff, false)
		--
		
		searchEdit = guiCreateEdit(20, 40, 120, 20, "Search Contact", false, phoneWindow)
		
		buttonSearch = guiCreateButton(145, 40, 30, 20, "Go", false, phoneWindow)
		addEventHandler("onClientGUIClick", buttonSearch, searchContact, false)
		
		contactsPane = guiCreateScrollPane(20, 70, 180, 140, false, phoneWindow)
		
		if string.len( listContacts ) > 0 then
			contact = split(listContacts, ";")
		end
		
		if ( contact ~= nil ) then
			populateContacts( 1, #contact )
		end	
		
		buttonBack = guiCreateStaticImage(20, 210, 32, 32, "icons/back.png", false, phoneWindow)
		addEventHandler("onClientGUIClick", buttonBack, goBack, false)
		
		buttonCall = guiCreateStaticImage(90, 210, 32, 32, "icons/call.png", false, phoneWindow)
		addEventHandler("onClientGUIClick", buttonCall, callContact, false)
		
		buttonAddContact = guiCreateStaticImage(150, 205, 32, 32, "icons/addcontact.png", false, phoneWindow)
		addEventHandler("onClientGUIClick", buttonAddContact, createAddContactUI, false)
		--
		
		guiSetInputEnabled( true )
	end	
end

function searchContact( button, state )
	if ( button == "left" and state == "up" ) then
		
		local name = guiGetText(searchEdit)
		local found = false
		local theStart = nil
		for key, value in ipairs ( contact ) do
			
			local text = value
			local find = findContact( name, text )
			if ( find ) then
				
				found = true
				theStart = key
				break
			end
		end	
		
		if ( found ) then
			for key = 1, #contacts do
				destroyElement( contacts[key][1] )
				destroyElement( contacts[key][2] )
			end
			
			contacts = { }
			
			contactY = 20
			populateContacts( theStart, #contact )
			populateContacts( 1, theStart - 1 )
		
		else
			outputChatBox("Couldn't find any contact with the given name.", 255, 0, 0)
		end		
	end
end

function findContact( name, text )
	return string.find( string.sub(text, 1, string.find(text, ",") - 1), name )
end	

local contactY = 20
function populateContacts( theStart, theEnd )
	
	local theStart = tonumber( theStart )
	local theEnd = tonumber( theEnd )
	
	for i = theStart, theEnd do
		
		contacts[i] = { }
		contacts[i][1] = guiCreateStaticImage(20, contactY, 32, 32, "icons/contacts.png", false, contactsPane)
		contacts[i][2] = guiCreateLabel(60, contactY + 5, 100, 20, contact[i]:gsub(",", " - "), false, contactsPane)
		
		addEventHandler("onClientGUIClick", contacts[i][1], selectContact, false)
		
		contactY = contactY + 40
		
		guiSetFont(contacts[i][2], "default-small")
	end	
end

function selectContact( button, state )
	if ( state == "up" ) then
		
		for key, value in ipairs ( contacts ) do
			if ( value[1] == source ) then
				
				local text = guiGetText( value[2] )
				if ( button == "left" ) then
					
					phoneNumber = string.sub( text, string.find(text, "-") + 1 )
					
					guiLabelSetColor(value[2], 0, 255, 0)
				elseif ( button == "right" ) then
					
					local name = string.sub( text, 1, string.find(text, "-") - 1 )
					local phoneNumber = string.sub( text, string.find(text, "-") + 1 )
					
					createEditContactUI( name, phoneNumber )
				end	
			else
				guiLabelSetColor(value[2], 255, 255, 255)
			end	
		end	
	end
end
	
function callContact( button, state )
	if ( button == "left" and state == "up" ) then
		if ( phoneNumber ~= false ) then
		
			playerCall( button, state, _, _, true )
		else
			outputChatBox("You did not select any contact.", 255, 0, 0)
		end
	end	
end

-- ADD CONTACT
function createAddContactUI( button, state )
	if ( button == "left" and state == "up" ) then
		
		phoneMenu = "add_contact"
		
		guiSetVisible( searchEdit, false )
		guiSetVisible( buttonSearch, false )
		guiSetVisible( contactsPane, false )
		guiSetVisible( buttonCall, false )
		guiSetVisible( buttonAddContact, false )
		--
		
		firstNameLabel = guiCreateLabel(20, 40, 150, 20, "First name:", false, phoneWindow)
		firstNameEdit = guiCreateEdit(20, 60, 150, 17, "", false, phoneWindow)
		
		lastNameLabel = guiCreateLabel(20, 80, 150, 20, "Last name:", false, phoneWindow)
		lastNameEdit = guiCreateEdit(20, 100, 150, 17, "", false, phoneWindow)
		
		phoneNumberLabel = guiCreateLabel(20, 120, 150, 20, "Phone number:", false, phoneWindow)
		phoneNumberEdit = guiCreateEdit(20, 140, 150, 20, "", false, phoneWindow)
		
		buttonSaveContact = guiCreateStaticImage(150, 205, 32, 32, "icons/addcontact.png", false, phoneWindow)
		addEventHandler("onClientGUIClick", buttonSaveContact, addContact, false)
		
		guiSetFont(firstNameLabel, "default-bold-small")
		guiSetFont(lastNameLabel, "default-bold-small")
		guiSetFont(phoneNumberLabel, "default-bold-small")
	end
end
	
function addContact( button, state )
	if ( button == "left" and state == "up" ) then
		
		local name = guiGetText(firstNameEdit) .." ".. guiGetText(lastNameEdit)
		local number = guiGetText(phoneNumberEdit)
		
		if ( string.len( name:gsub(" ", "") ) > 0 and string.len( number ) > 0 ) then
			
			phoneMenu = "contacts"
			
			listContacts = listContacts ..";".. name ..",".. number
			contact = split(listContacts, ";")
			
			destroyElement( firstNameLabel )
			destroyElement( firstNameEdit )
			destroyElement( lastNameLabel )
			destroyElement( lastNameEdit )
			destroyElement( phoneNumberLabel )
			destroyElement( phoneNumberEdit )
			destroyElement( buttonSaveContact )
			--
			guiSetVisible( searchEdit, true )
			guiSetVisible( buttonSearch, true )
			guiSetVisible( buttonCall, true )
			guiSetVisible( contactsPane, true )
			guiSetVisible( buttonAddContact, true )
			
			for key = 1, #contacts do
				if isElement( contacts[key][1] ) then
					
					destroyElement( contacts[key][1] )
					destroyElement( contacts[key][2] )
				end
			end	
			
			contacts = { }
			
			contactY = 20
			populateContacts( 1, #contact )
			
			triggerServerEvent("savePlayerContact", localPlayer, listContacts)
		else
			outputChatBox("You need to fill the name and the number field.", 255, 0, 0)
		end	
	end
end
	
local oldName = nil	
local oldNumber = nil
function createEditContactUI( name, phoneNumber )
	local firstName = string.sub( name, 1, string.find(name, " ") - 1)
	local lastName = string.sub( name, string.find(name, " ") + 1, string.len( name ) - 1 )
	
	local phoneNumber = tostring( phoneNumber ):gsub(" ", "")
	
	oldName = firstName .." ".. lastName
	oldNumber = phoneNumber
	
	phoneMenu = "edit_contact"
	
	guiSetVisible( searchEdit, false )
	guiSetVisible( buttonSearch, false )
	guiSetVisible( contactsPane, false )
	guiSetVisible( buttonCall, false )
	guiSetVisible( buttonAddContact, false )
	--

	firstNameLabel = guiCreateLabel(20, 40, 150, 20, "First name:", false, phoneWindow)
	firstNameEdit = guiCreateEdit(20, 60, 150, 20, tostring( firstName ), false, phoneWindow)
	
	lastNameLabel = guiCreateLabel(20, 80, 150, 20, "Last name:", false, phoneWindow)
	lastNameEdit = guiCreateEdit(20, 100, 150, 20, tostring( lastName ), false, phoneWindow)
	
	phoneNumberLabel = guiCreateLabel(20, 120, 150, 20, "Phone number:", false, phoneWindow)
	phoneNumberEdit = guiCreateEdit(20, 140, 150, 20, tostring( phoneNumber ), false, phoneWindow)
	
	buttonSaveContact = guiCreateStaticImage(150, 205, 32, 32, "icons/change.png", false, phoneWindow)
	addEventHandler("onClientGUIClick", buttonSaveContact, saveContact, false)
	
	buttonDeleteContact = guiCreateStaticImage(90, 205, 32, 32, "icons/delete.png", false, phoneWindow)
	addEventHandler("onClientGUIClick", buttonDeleteContact, deleteContact, false)
	
	guiSetFont(firstNameLabel, "default-bold-small")
	guiSetFont(lastNameLabel, "default-bold-small")
	guiSetFont(phoneNumberLabel, "default-bold-small")
end
	
-- SAVE CONTACT	
function saveContact( button, state )
	if ( button == "left" and state == "up" ) then
		
		local name = guiGetText(firstNameEdit) .." ".. guiGetText(lastNameEdit)
		local number = guiGetText(phoneNumberEdit)
		
		if ( string.len( name:gsub(" ", "") ) > 0 and string.len( number ) > 0 ) then
			
			phoneMenu = "contacts"
			
			listContacts = ""
			
			local newDetail = name ..",".. number
			local oldDetail = oldName ..",".. oldNumber
		
			for i = 1, #contact do
				if ( tostring( contact[i] ) == tostring( oldDetail ) ) then
					listContacts = listContacts ..";".. newDetail
				else	
					listContacts = listContacts ..";".. contact[i]
				end	
				
				destroyElement( contacts[i][1] )
				destroyElement( contacts[i][2] )
			end
			
			contacts = { }
			
			contact = split(listContacts, ";")
			
			destroyElement( firstNameLabel )
			destroyElement( firstNameEdit )
			destroyElement( lastNameLabel )
			destroyElement( lastNameEdit )
			destroyElement( phoneNumberLabel )
			destroyElement( phoneNumberEdit )
			destroyElement( buttonSaveContact )
			destroyElement( buttonDeleteContact )
			--
			guiSetVisible( searchEdit, true )
			guiSetVisible( buttonSearch, true )
			guiSetVisible( buttonCall, true )
			guiSetVisible( contactsPane, true )
			guiSetVisible( buttonAddContact, true )
			
			contactY = 20
			populateContacts( 1, #contact )
			
			triggerServerEvent("savePlayerContact", localPlayer, listContacts)
			
			outputChatBox("Changed '".. oldName .."'s details.", 0, 255, 0)
		else
			outputChatBox("You need to fill the name and the number field.", 255, 0, 0)
		end
	end
end	

-- DELETE CONTACT
function deleteContact( button, state )
	if ( button == "left" and state == "up" ) then
		
		phoneMenu = "contacts"
	
		listContacts = ""
	
		local oldDetail = oldName ..",".. oldNumber
		for i = 1, #contact do
			if ( tostring( contact[i] ) == tostring( oldDetail ) ) then
				
				table.remove( contact, i )
			else	
				listContacts = listContacts ..";".. contact[i]
			end	
			
			destroyElement( contacts[i][1] )
			destroyElement( contacts[i][2] )
		end
		
		contacts = { }
		
		contact = split(listContacts, ";")
		
		destroyElement( firstNameLabel )
		destroyElement( firstNameEdit )
		destroyElement( lastNameLabel )
		destroyElement( lastNameEdit )
		destroyElement( phoneNumberLabel )
		destroyElement( phoneNumberEdit )
		destroyElement( buttonSaveContact )
		destroyElement( buttonDeleteContact )
		--
		guiSetVisible( searchEdit, true )
		guiSetVisible( buttonSearch, true )
		guiSetVisible( buttonCall, true )
		guiSetVisible( contactsPane, true )
		guiSetVisible( buttonAddContact, true )
		
		contactY = 20
		populateContacts( 1, #contact )
		
		triggerServerEvent("savePlayerContact", localPlayer, listContacts)
		
		outputChatBox("Deleted '".. oldName .."' from contacts.", 0, 255, 0)
	end
end

-- ## MENU ##
function createPhoneMenuUI( button, state )
	if ( button == "left" and state == "up" ) then
		
		phoneMenu = "menu"
		
		guiSetVisible(timeLabel, false)
		
		guiSetVisible(buttonContacts, false)
		guiSetVisible(labelContacts, false)
		
		guiSetVisible(buttonMenu, false)
		guiSetVisible(labelMenu, false)
		
		guiSetVisible(buttonOff, false)
		guiSetVisible(labelOff, false)
		
		--
		menuPane = guiCreateScrollPane(20, 50, 180, 200, false, phoneWindow)
		
		buttonCall = guiCreateStaticImage(20, 10, 32, 32, "icons/call.png", false, menuPane)
		labelCall = guiCreateLabel(60, 15, 40, 20, "Call", false, menuPane)
			
		addEventHandler("onClientGUIClick", buttonCall, createPhoneCallUI, false)
		
		buttonSms = guiCreateStaticImage(20, 60, 32, 32, "icons/sms.png", false, menuPane)
		labelSms = guiCreateLabel(60, 65, 40, 20, "SMS", false, menuPane)
		
		addEventHandler("onClientGUIClick", buttonSms, createPhoneSmsUI, false)
		
		buttonSettings = guiCreateStaticImage(20, 110, 32, 32, "icons/settings.png", false, menuPane)
		labelSettings = guiCreateLabel(60, 115, 50, 20, "Settings", false, menuPane)
		
		addEventHandler("onClientGUIClick", buttonSettings, createPhoneSettingsUI, false)
	
		buttonBack = guiCreateStaticImage(20, 210, 32, 32, "icons/back.png", false, phoneWindow)
		addEventHandler("onClientGUIClick", buttonBack, goBack, false)
		--
		
		guiSetFont(labelCall, "default-bold-small")
		guiSetFont(labelSettings, "default-bold-small")
		guiSetFont(labelSms, "default-bold-small")
	end
end	

-- ## CALL ##
local callButtons = { }

function createPhoneCallUI( button, state, _, _, isSms )
	if ( button == "left" and state == "up" ) then
		
		guiSetVisible( menuPane, false )
		--
		numberEdit = guiCreateEdit(20, 50, 120, 20, "", false, phoneWindow)
		
		callBackSpace = guiCreateButton(150, 50, 25, 20, "<-", false, phoneWindow)
		addEventHandler("onClientGUIClick", callBackSpace, typeBackSpace, false )
		
		local x, y = 40, 0
		for i = 1, 9 do
			
			if ( i <= 3 ) then
				y = 80
			elseif ( i > 3 and i <= 6 ) then
				y = 120
			elseif ( i > 6 and i <= 9 ) then
				y = 160
			end
			
			callButtons[i] = guiCreateButton( x, y, 30, 30, tostring(i), false, phoneWindow )
			addEventHandler("onClientGUIClick", callButtons[i], dialPhoneNumber, false)
			
			if ( i == 3 or i == 6 ) then
				x = 40
			else	
				x = x + 40
			end
		end	
		
		callButtons[0] = guiCreateButton( 80, 200, 30, 30, "0", false, phoneWindow)
		addEventHandler("onClientGUIClick", callButtons[0], dialPhoneNumber, false)
		
		if ( not isSms ) then 
			realCallButton = guiCreateStaticImage( 120, 200, 30, 30, "icons/call.png", false, phoneWindow)
			addEventHandler("onClientGUIClick", realCallButton, playerCall, false )
			
			phoneMenu = "call"
		else
			proceedSmsButton = guiCreateStaticImage(150, 210, 32, 32, "icons/next.png", false, phoneWindow)
			addEventHandler("onClientGUIClick", proceedSmsButton, proceedToSms, false)
			
			phoneMenu = "sms_first"
		end
		
		guiSetInputEnabled( true )
	end
end	

function dialPhoneNumber( button, state )
	if ( button == "left" and state == "up" ) then
		
		local text = guiGetText(numberEdit)
		guiSetText(numberEdit, text .. guiGetText( source ))
	end
end

function playerCall( button, state, _, _, dynamicCall )
	if ( button == "left" and state == "up" ) then
		
		local number = false
		if ( not dynamicCall ) then
			number = guiGetText( numberEdit )
		else
			number = phoneNumber
		end
		
		if ( string.len( number ) > 0 ) then
			
			guiSetInputEnabled( false )
			setTimer(showCursor, 200, 10, false )
			
			destroyElement( phoneWindow )
			removeEventHandler("onClientRender", root, drawPhoneCover)
			
			triggerServerEvent("callPlayer", localPlayer, localPlayer, "call", number )
		else
			outputChatBox("You didn't type a number.", 255, 0, 0)
		end	
	end	
end

function proceedToSms( button, state )
	local text = guiGetText( numberEdit )
	if ( string.len( text ) > 0 ) then
		
		phoneNumber = text
		
		guiSetVisible( source, false )
		guiSetVisible( numberEdit, false )
		guiSetVisible( callBackSpace, false )
		
		for key, value in pairs ( callButtons ) do
			guiSetVisible( value, false )
		end
		
		createPhoneSmsUI( button, state, false, false, true )
	else
		outputChatBox("You did not enter any number.", 255, 0, 0)
	end	
end

-- ## SMS ##
local alphabets = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "$", "!", "@", "|", ",", "/", ":", "(", ")", " "}
local typeKeys = { }
local caps = false

function createPhoneSmsUI( button, state, _, _, isNumber )
	if ( button == "left" and state == "up" ) then
		
		if ( not isNumber ) then
			createPhoneCallUI( button, state, false, false, true )
			return
		end
		
		smsEdit = guiCreateEdit( 20, 40, 120, 17, "", false, phoneWindow)
		
		smsBackSpace = guiCreateButton(150, 40, 25, 20, "<-", false, phoneWindow)
		addEventHandler("onClientGUIClick", smsBackSpace, typeBackSpace, false)
		
		local x, y = 25, 65
		for i = 1, #alphabets do
			if ( i == 7 ) then
				y = 90
				x = 25
			elseif ( i == 13 ) then
				y = 115
				x = 25 
			elseif ( i == 19 ) then
				y = 140
				x = 25
			elseif ( i == 25 ) then
				y = 165
				x = 25
			elseif ( i == 31 ) then
				y = 190
				x = 25
			end
			
			typeKeys[i] = guiCreateButton(x, y, 20, 20, tostring(alphabets[i]), false, phoneWindow)
			addEventHandler("onClientGUIClick", typeKeys[i], typeText, false)
			
			x = x + 25
		end
		
		
		buttonCapsLock = guiCreateButton(70, 215, 60, 20, "Caps", false, phoneWindow)
		addEventHandler("onClientGUIClick", buttonCapsLock, toggleCapsLock, false)

		buttonSendSms = guiCreateStaticImage(150, 210, 32, 32, "icons/sendsms.png", false, phoneWindow)
		addEventHandler("onClientGUIClick", buttonSendSms, sendPlayerSms, false)
		
		phoneMenu = "sms_second"
	end
end

function toggleCapsLock( button, state )
	if ( button == "left" and state == "up" ) then
	
		for key, value in ipairs ( typeKeys ) do
	
			local func = string.upper
			if ( caps ) then	
				func = string.lower
			end	
		
			guiSetText(value, func( guiGetText( value ) ))
		end
		
		caps = not caps
	end
end

function typeText( button, state )
	if ( button == "left" and state == "up" ) then
		
		local text = guiGetText(smsEdit)
		guiSetText(smsEdit, text .. guiGetText( source ))
	end
end

function sendPlayerSms( button, state )
	local text = guiGetText(smsEdit)
	triggerServerEvent("useShortMessageService", localPlayer, localPlayer, "sms", phoneNumber, text)
end

-- ## SETTINGS ##
local selected = nil

-- WALLPAPER
function createPhoneSettingsUI( button, state )
	if ( button == "left" and state == "up" ) then
	
		guiSetVisible( menuPane, false )
		
		buttonWallpaper = guiCreateStaticImage(20, 50, 32, 32, "icons/wallpaper.png", false, phoneWindow)
		labelWallpaper = guiCreateLabel(60, 55, 65, 20, "Wallpapers", false, phoneWindow)
		
		addEventHandler("onClientGUIClick", buttonWallpaper, createPhoneWallpaperUI, false)
		
		buttonRingtone = guiCreateStaticImage(20, 100, 32, 32, "icons/ringtone.png", false, phoneWindow)
		labelRingtone = guiCreateLabel(60, 105, 60, 20, "Ringtones", false, phoneWindow)
		
		addEventHandler("onClientGUIClick", buttonRingtone, createPhoneRingtoneUI, false)
		
		phoneMenu = "settings"
		
		guiSetFont(labelWallpaper, "default-bold-small")
		guiSetFont(labelRingtone, "default-bold-small")
	end
end

function createPhoneWallpaperUI( button, state )
	if ( button == "left" and state == "up" ) then	
		
		selected = nil
		
		guiSetVisible( buttonWallpaper, false )
		guiSetVisible( labelWallpaper, false )
		
		guiSetVisible( buttonRingtone, false )
		guiSetVisible( labelRingtone, false )
		
		--
		wallpaperPane = guiCreateScrollPane( 20, 50, 180, 140, false, phoneWindow)
		
		local papers = { }
		local y = 0
		for i = 1, #wallpapers do
			
			papers[i] = { }
			papers[i][1] = guiCreateStaticImage( 20, y, 40, 40, "wallpapers/".. wallpapers[i] ..".png", false, wallpaperPane)
			papers[i][2] = guiCreateLabel(70, y, 50, 20, string.upper(string.sub(wallpapers[i], 1, 1)) .. string.sub(wallpapers[i], 2), false, wallpaperPane)
			
			addEventHandler("onClientGUIClick", papers[i][1], 
				function( button, state )
					if ( button == "left" and state == "up" ) then
						
						for k, v in ipairs ( papers ) do
							if ( v[2] ~= source ) then
								guiLabelSetColor( v[2], 255, 255, 255 )
							end	
						end
						
						selected = i
						guiLabelSetColor( papers[i][2], 0, 255, 0 )
					end	
				end, false
			)	
			
			guiSetAlpha(papers[i][1], 0.9)
			guiSetFont(papers[i][2], "default-bold-small")
			
			y = y + 50
		end	
		
		changeWallpaperButton = guiCreateStaticImage( 150, 200, 30, 30, "icons/change.png", false, phoneWindow)
		addEventHandler("onClientGUIClick", changeWallpaperButton, selectWallpaper, false)
		
		phoneMenu = "wallpaper"
	end	
end

function selectWallpaper( button, state )
	if ( button == "left" and state == "up" ) then
		if ( selected ~= nil ) then
			
			destroyElement( wallpaperImage )
		
			wallpaperImage = guiCreateStaticImage( 0, 10, 200, 250, "wallpapers/".. wallpapers[selected] ..".png", false, phoneWindow)
			addEventHandler("onClientGUIClick", wallpaperImage, stickWallpaper, false)
			
			triggerServerEvent("savePlayerWallpaper", localPlayer, selected)
			outputChatBox("Wallpaper changed to '".. string.upper(string.sub(wallpapers[selected], 1, 1)) .. string.sub(wallpapers[selected], 2) .."'.", 0, 255, 0)
			
			wallpaper = wallpapers[selected]
			
			guiMoveToBack( wallpaperImage )
			guiSetAlpha( wallpaperImage, 0.7 )
		else
			outputChatBox("You did not select any wallpaper.", 255, 0, 0)
		end	
	end
end

-- RINGTONES
local ringtone = nil
function createPhoneRingtoneUI( button, state )
	if ( button == "left" and state == "up" ) then
		
		selected = nil
		
		guiSetVisible( buttonWallpaper, false )
		guiSetVisible( labelWallpaper, false )
		
		guiSetVisible( buttonRingtone, false )
		guiSetVisible( labelRingtone, false )
		
		--
		ringtonePane = guiCreateScrollPane(20, 50, 180, 140, false, phoneWindow)
		
		local tones = { }
		local y = 0
		for i = 1, #ringtones do
			
			tones[i] = { }
			tones[i][1] = guiCreateStaticImage( 20, y, 40, 40, "icons/music.png", false, ringtonePane)
			tones[i][2] = guiCreateLabel(70, y, 50, 20, string.upper(string.sub(ringtones[i], 1, 1)) .. string.sub(ringtones[i], 2), false, ringtonePane)
			
			addEventHandler("onClientGUIClick", tones[i][1], 
				function( button, state )
					if ( button == "left" and state == "up" ) then
						
						for k, v in ipairs ( tones ) do
							if ( v[2] ~= source ) then
								guiLabelSetColor( v[2], 255, 255, 255 )
							end	
						end
						
						selected = i
						guiLabelSetColor( tones[i][2], 0, 255, 0 )
						
						local loop = false
						local name = ringtones[selected]
						if ( name == "business" ) then
							loop = true
						end
						
						if ( ringtone ~= nil ) then
							stopSound( ringtone )
						end
						
						ringtone = playSound("sounds/".. ringtones[selected] ..".mp3", loop)
						if ( ringtone ) then
							
							if ( loop ) then
								setTimer( stopSound, 6000, 1, ringtone )
							end
						end	
					end	
				end, false
			)	
			
			guiSetFont(tones[i][2], "default-bold-small")
			
			y = y + 50
		end	
		
		changeRingtoneButton = guiCreateStaticImage( 150, 200, 30, 30, "icons/change.png", false, phoneWindow)
		addEventHandler("onClientGUIClick", changeRingtoneButton, selectRingtone, false)
		
		phoneMenu = "ringtone"
	end
end

function selectRingtone( button, state )
	if ( button == "left" and state == "up" ) then
		if ( selected ~= nil ) then
			
			triggerServerEvent("savePlayerRingtone", localPlayer, selected)
			outputChatBox("Ringtone changed to '".. string.upper(string.sub(ringtones[selected], 1, 1)) .. string.sub(ringtones[selected], 2) .."'.", 0, 255, 0)	
		else
			outputChatBox("You did not select any ringtone.", 255, 0, 0)
		end	
	end
end

-- ## GLOBALS ##
function stickWallpaper( )
	guiMoveToBack( source )
end	

function stickPhone( )
	guiMoveToBack( phoneWindow )
end

function typeBackSpace( button, state )
	if ( button == "left" and state == "up" ) then
		
		local edit = numberEdit
		if isElement( smsEdit ) then
			edit = smsEdit
		end
		
		local text = guiGetText(edit)
		local len = string.len( text )
	
		guiSetText(edit, string.sub(text, 1, len - 1))
	end	
end

function goBack( button, state )
	if ( button == "left" and state == "up" ) then
		
		if ( phoneMenu == "menu" ) then
			
			phoneMenu = "main"
			
			destroyElement( menuPane )
			destroyElement( source )
			
			guiSetVisible(timeLabel, true)
			
			guiSetVisible(buttonContacts, true)
			guiSetVisible(labelContacts, true)
		
			guiSetVisible(buttonMenu, true)
			guiSetVisible(labelMenu, true)
		
			guiSetVisible(buttonOff, true)
			guiSetVisible(labelOff, true)
		elseif ( phoneMenu == "contacts" ) then
			
			phoneMenu = "main"
			
			destroyElement( searchEdit )
			destroyElement( buttonSearch )
			destroyElement( contactsPane )
			destroyElement( buttonBack )
			destroyElement( buttonCall )
			destroyElement( buttonAddContact )
			
			guiSetVisible(timeLabel, true)
			
			guiSetVisible(buttonContacts, true)
			guiSetVisible(labelContacts, true)
		
			guiSetVisible(buttonMenu, true)
			guiSetVisible(labelMenu, true)
		
			guiSetVisible(buttonOff, true)
			guiSetVisible(labelOff, true)
			
			guiSetInputEnabled( false )
		elseif ( phoneMenu == "add_contact" ) then

			phoneMenu = "contacts"
			
			destroyElement( firstNameLabel )
			destroyElement( firstNameEdit )
			destroyElement( lastNameLabel )
			destroyElement( lastNameEdit )
			destroyElement( phoneNumberLabel )
			destroyElement( phoneNumberEdit )
			destroyElement( buttonSaveContact )
			
			guiSetVisible( searchEdit, true )
			guiSetVisible( buttonSearch, true )
			guiSetVisible( buttonCall, true )
			guiSetVisible( contactsPane, true )
			guiSetVisible( buttonAddContact, true )
		elseif ( phoneMenu == "edit_contact" ) then
			
			phoneMenu = "contacts"
			
			destroyElement( firstNameLabel )
			destroyElement( firstNameEdit )
			destroyElement( lastNameLabel )
			destroyElement( lastNameEdit )
			destroyElement( phoneNumberLabel )
			destroyElement( phoneNumberEdit )
			destroyElement( buttonSaveContact )
			destroyElement( buttonDeleteContact )
			
			guiSetVisible( searchEdit, true )
			guiSetVisible( buttonSearch, true )
			guiSetVisible( buttonCall, true )
			guiSetVisible( contactsPane, true )
			guiSetVisible( buttonAddContact, true )
		elseif ( phoneMenu == "call" ) then	
			
			phoneMenu = "menu"
			
			destroyElement( numberEdit )
			destroyElement( realCallButton )
			destroyElement( callBackSpace )
			
			for key, value in pairs ( callButtons ) do
				destroyElement( value )
			end

			guiSetVisible( menuPane, true )
			guiSetInputEnabled( false )
		elseif ( phoneMenu == "sms_second" ) then
			
			phoneMenu = "sms_first"
			
			destroyElement( smsEdit )
			destroyElement( smsBackSpace )
			destroyElement( buttonCapsLock )
			destroyElement( buttonSendSms )
			
			for key, value in ipairs ( typeKeys ) do
				destroyElement( value )
			end
			
			guiSetVisible( source, true )
			guiSetVisible( numberEdit, true )
			guiSetVisible( callBackSpace, true )
			guiSetVisible( proceedSmsButton, true )
			
			for key, value in pairs ( callButtons ) do
				guiSetVisible( value, true )
			end
		elseif ( phoneMenu == "sms_first" ) then
			
			phoneMenu = "menu"
			
			destroyElement( proceedSmsButton )
			destroyElement( numberEdit )
			destroyElement( callBackSpace )
			
			for key, value in pairs ( callButtons ) do
				destroyElement( value )
			end
			
			guiSetVisible( menuPane, true )
			guiSetInputEnabled( false )
			
			phoneNumber = false
		elseif ( phoneMenu == "settings" ) then
			
			phoneMenu = "menu"
			
			destroyElement( buttonWallpaper )
			destroyElement( labelWallpaper )
			
			destroyElement( buttonRingtone )
			destroyElement( labelRingtone )
			
			guiSetVisible( menuPane, true )
		elseif ( phoneMenu == "wallpaper" ) then	
			
			phoneMenu = "settings"
			
			destroyElement( wallpaperPane )
			destroyElement( changeWallpaperButton )
			
			guiSetVisible( buttonWallpaper, true )
			guiSetVisible( labelWallpaper, true )
			
			guiSetVisible( buttonRingtone, true )
			guiSetVisible( labelRingtone, true )
		elseif ( phoneMenu == "ringtone" ) then
			
			phoneMenu = "settings"
			
			destroyElement( ringtonePane )
			destroyElement( changeRingtoneButton )
			
			guiSetVisible( buttonWallpaper, true )
			guiSetVisible( labelWallpaper, true )
			
			guiSetVisible( buttonRingtone, true )
			guiSetVisible( labelRingtone, true )
			
			if ( ringtone ~= nil ) then
				stopSound(ringtone)
			end	
		end
	end
end

local playing = { }
local replay = { }
function playRingtone( theRingtone, thePlayer, x, y, z )
	local theRingtone = tonumber( theRingtone )
	
	playing[thePlayer] = playSound3D("sounds/".. ringtones[theRingtone] ..".mp3", x, y, z)
	setSoundVolume( playing[thePlayer], 0.3 )
	
	attachElements( playing[thePlayer], thePlayer )
	
	local timer = 0
	if ( theRingtone == 1 ) then
		timer = 8000
	elseif ( theRingtone == 2 ) then
		timer = 4000
	elseif ( theRingtone == 3 ) then
		timer = 8000
	end
	
	if isElement( playing[thePlayer] ) then
		replay[thePlayer] = setTimer(playRingtone, timer, 1, theRingtone, thePlayer, x, y, z)
	end
end
addEvent("playRingtone", true)
addEventHandler("playRingtone", localPlayer, playRingtone)
	
function stopRingtone( thePlayer )
	if isElement( playing[thePlayer] ) then
		
		stopSound( playing[thePlayer] )
		playing[thePlayer] = nil
		
		if isTimer( replay[thePlayer] ) then
			killTimer( replay[thePlayer] )
			replay[thePlayer] = nil
		end	
	end
end
addEvent("stopRingtone", true)
addEventHandler("stopRingtone", localPlayer, stopRingtone)

addEventHandler("onClientPlayerQuit", root,
	function( )
		if isElement( playing[source] ) then
			
			stopSound( playing[source] )
			playing[source] = nil
			
			if isTimer( replay[thePlayer] ) then
				killTimer( replay[thePlayer] )
				replay[thePlayer] = nil
			end	
		end	
	end
)

function startPhone( )
	if ( getData( localPlayer, "loggedin" ) == 1 ) then
		triggerServerEvent("getPhoneDetails", localPlayer)
	end
end
addEventHandler("onClientPlayerSpawn", localPlayer, startPhone)
addEventHandler("onClientResourceStart", resourceRoot, startPhone)

function playDialSound( )
	
	local dialSound = playSound("sounds/dial.wav")
	setSoundVolume(dialSound, 0.5)
end
addEvent("playDialSound", true)
addEventHandler("playDialSound", localPlayer, playDialSound)