local screenX, screenY = guiGetScreenSize()
local rotatingClockwise = false
local rotatingAntiClockwise = false

local clickedSignin = false
local clickedRegister = false

function displayLogin( changingAccount )
	hidePlayerHud( )
	fadeCamera( true )
	setCameraInterior( 0 )
	
	-- Display Background
	setCameraMatrix( -1169.7003173828, 739.37286376953, 116.03268432617, -1264.3681640625, 771.38189697266, 119.69632720947 )
	
	showCursor(true)
	guiSetInputEnabled(true)	
	
	-- Call Login Box
	addEventHandler("onClientRender", getRootElement(), rotateCamera)
	addEventHandler("onClientRender", getRootElement(), renderDirectX)

	createUserInterface( )
	getPlayerDetails( changingAccount )
	
	clickedSignin = false
	clickedRegister = false
end
addEvent("displayLogin", true)
addEventHandler("displayLogin", localPlayer, displayLogin)

addEventHandler("onClientResourceStart", resourceRoot, 
	function( )
		
		displayLogin( 0 )
	end
)	

-- Autologin/Remember
local remember = false
local autologin = false
function getPlayerDetails( changingAccount )
	
	local xml = xmlLoadFile("login.xml")
	if ( not xml ) then	-- Reserve a place in the memory
		
		xml = xmlCreateFile("login.xml", "login")
		
		-- Children
		xmlCreateChild(xml, "username")
		xmlCreateChild(xml, "password")
		xmlNodeSetValue( xmlCreateChild(xml, "remember"), "0" )
		xmlNodeSetValue( xmlCreateChild(xml, "autologin"), "0" )
	
		-- Save
		xmlSaveFile(xml)
	else
		
		local children = xmlNodeGetChildren(xml)
		for key, node in ipairs ( children ) do
			
			local value = tonumber(xmlNodeGetValue(node))
			if ( value == 1 ) then
				
				if ( key == 3 ) then -- Remember
					remember = true
				elseif ( key == 4 ) then -- Autologin
					autologin = true
				end	
			end
		end
		
	end
	
	guiCheckBoxSetSelected( checkboxRemember, remember )
	guiCheckBoxSetSelected( checkboxAutologin, autologin )
	
	if ( remember ) then
		
		local user = xmlFindChild( xml, "username", 0 )
		local pass = xmlFindChild( xml, "password", 0 )
		
		local username = tostring( xmlNodeGetValue( user ) )
		local password = tostring( xmlNodeGetValue( pass ) )
		
		guiSetText( editUsername, username )
		guiSetText( editPassword, password )
		
		if ( autologin ) and ( changingAccount == 0 ) then
			
			signIn("left", "up")
		end	
	end

	xmlUnloadFile(xml)
end
	
local frame = 0
local goingRight = true
local goingLeft = false
function rotateCamera( )
	
	if frame <= 400 and goingRight then
		
		local a, b, c, d, e, f = getCameraMatrix()
		setCameraMatrix(a, b, c, d + 0.2, e + 0.2, f)
	
	elseif frame <= 200 and goingLeft then
		
		local a, b, c, d, e, f = getCameraMatrix()
		setCameraMatrix(a, b, c, d - 0.2, e - 0.2, f)
	end	
	
	frame = frame + 1
	if frame == 400 and goingRight then
			
		goingRight = false
		goingLeft = true
		frame = -400
	elseif frame == 200 and goingLeft then
			
		goingRight = true
		goingLeft = false
		frame = -200
	end
end

function renderDirectX( )
	dxDrawRectangle(screenX - screenX, screenY - screenY, screenX, screenY, tocolor(0, 0, 0, 150))
end	
	
function createUserInterface( )
	
	-- Positions
	
	--------- [ Login Elements ] ---------
	local eu_width, eu_height = 110, 18
	local eu_x, eu_y = (screenX/2) - (eu_width/2), (screenY/2) - (eu_height/2)
	
	local ep_width, ep_height = 110, 18
	local ep_x, ep_y = (screenX/2) - (ep_width/2), ((screenY/2) - (ep_height/2) + 22)
	
	local lu_width, lu_height = 60, 18
	local lu_x, lu_y = ((screenX/2) - (lu_width/2) - 90), (screenY/2) - (lu_height/2)
	
	local lp_width, lp_height = 55, 18
	local lp_x, lp_y = ((screenX/2) - (lp_width/2) - 90), ((screenY/2) - (lp_height/2) + 22)
	
	local bl_width, bl_height = 70, 18
	local bl_x, bl_y = ((screenX/2) - (bl_width/2) - 50), ((screenY/2) - (bl_height/2) + 55)
	
	local br_width, br_height = 70, 18
	local br_x, br_y = ((screenX/2) - (br_width/2) + 50), ((screenY/2) - (br_height/2) + 55)
	
	--------- [ Information Elements ] ---------
	local info_width, info_height, info_offsetX, info_offsetY = 410, 18, 15, 200
	local info_x, info_y = ((screenX/2) - (info_width/2) - info_offsetX), ((screenY/2) - (info_height/2) - info_offsetY)
	
	--------- [ Lower buttons Elements ] ---------
	local about_width, about_height = 70, 22
	local about_x, about_y = screenX - screenX + 5, screenY - 25
	
	local information_width, information_height = 80, 22
	local information_x, information_y = screenX - screenX + 85, screenY - 25
	
	-- Elements
	
	--------- [ Login Elements ] ---------
	editUsername = guiCreateEdit(eu_x, eu_y, eu_width, eu_height, "", false, nil)
	editPassword = guiCreateEdit(ep_x, ep_y, ep_width, ep_height, "", false, nil)
	guiEditSetMasked(editPassword, true)
	
	lblUsername = guiCreateLabel(lu_x, lu_y, lu_width, lu_height, "Username:", false, nil)
	lblPassword = guiCreateLabel(lp_x, lp_y, lp_width, lp_height, "Password:", false, nil)
	
	btnLogin = guiCreateButton(bl_x, bl_y, bl_width, bl_height, "Login", false, nil)
	btnRegister = guiCreateButton(br_x, br_y, br_width, br_height, "Register", false, nil)
	
	checkboxRemember = guiCreateCheckBox(eu_x, br_y + 30, 110, 15, "Remember Me", false, false)
	checkboxAutologin = guiCreateCheckBox(eu_x, br_y + 50, 110, 15, "Automatic Login", false, false)
	
	--------- [ Information Elements ] ---------
	lblInfo_1 = guiCreateLabel(info_x, info_y, info_width, info_height, "Welcome to Arsenic Roleplay! You need to login in order to", false, nil)
	lblInfo_2 = guiCreateLabel(info_x, info_y + 20, info_width, info_height, "play, If you don't have an account already, please Register.", false, nil)
	
	--------- [ Lower button Elements ] ---------
	btnAbout = guiCreateButton(about_x, about_y, about_width, about_height, "About", false, nil)
	btnInformation = guiCreateButton(information_x, information_y, information_width, information_height, "Information", false, nil)
	
	-- Events
	
	--------- [ Login Elements ] ---------
	addEventHandler("onClientGUIClick", btnRegister, signIn, false)
	addEventHandler("onClientGUIClick", btnLogin, signIn, false)
	
	addEventHandler("onClientGUIClick", checkboxRemember, rememberDetails, false)
	addEventHandler("onClientGUIClick", checkboxAutologin, autoLogin, false)
	
	--------- [ Lower button Elements ] ---------
	addEventHandler("onClientGUIClick", btnAbout, displayAbout, false)
	addEventHandler("onClientGUIClick", btnInformation, displayInformation, false)
	
	
	-- Apply font
	
	--------- [ Login Elements ] ---------
	guiSetFont(lblUsername, "default-bold-small")
	guiSetFont(lblPassword, "default-bold-small")
	guiSetFont(editUsername, "default-bold-small")
	guiSetFont(editPassword, "default-bold-small")
	guiSetFont(btnLogin, "default-bold-small")
	guiSetFont(btnRegister, "default-bold-small")
	guiSetFont(checkboxRemember, "default-bold-small")
	guiSetFont(checkboxAutologin, "default-bold-small")
	
	--------- [ Information Elements ] ---------
	guiSetFont(lblInfo_1, "clear-normal")
	guiSetFont(lblInfo_2, "clear-normal")
	
	--------- [ Lower buttons Elements ] ---------
	guiSetFont(btnAbout, "default")
	guiSetFont(btnInformation, "default")
end

function displayAbout( button, state )
	if source == btnAbout and button == "left" and state == "up" then
		if guiGetText(source) == "About" then
		
			guiSetVisible(editUsername, false)
			guiSetVisible(editPassword, false)
			guiSetVisible(lblUsername, false)
			guiSetVisible(lblPassword, false)
			guiSetVisible(btnLogin, false)
			guiSetVisible(btnRegister, false)
			guiSetVisible(checkboxRemember, false)
			guiSetVisible(checkboxAutologin, false)
			guiSetVisible(lblInfo_1, false)
			guiSetVisible(lblInfo_2, false)
			
			local lblabout_width, lblabout_height = 100, 18
			local lblabout_x, lblabout_y = (screenX/2) - (lblabout_width/2), ((screenY/2) - (lblabout_height/2) - 200)
			
			lblAbout_1 = guiCreateLabel(lblabout_x, lblabout_y, lblabout_width + 110, lblabout_height, "About - Arsenic Roleplay", false, nil)
			lblAbout_2 = guiCreateLabel(lblabout_x - 40, lblabout_y + 20, lblabout_width, lblabout_height, "Scripts By: Dev", false, nil)
			lblAbout_3 = guiCreateLabel(lblabout_x - 40, lblabout_y + 40, lblabout_width, lblabout_height, "Version: 1.0", false, nil)
			lblAbout_4 = guiCreateLabel(lblabout_x - 40, lblabout_y + 60, lblabout_width + 115, lblabout_height, "Start date of Development: 6/22/2011", false, nil)
			lblAbout_5 = guiCreateLabel(lblabout_x - 40, lblabout_y + 80, lblabout_width + 115, lblabout_height, "End date of Development: 2/2/2012", false, nil)
		
			guiSetText(source, "Back")
			guiSetEnabled(btnInformation, false)
			
		elseif guiGetText(source) == "Back" then
		
			destroyElement(lblAbout_1)
			destroyElement(lblAbout_2)
			destroyElement(lblAbout_3)
			destroyElement(lblAbout_4)
			destroyElement(lblAbout_5)
			
			guiSetVisible(editUsername, true)
			guiSetVisible(editPassword, true)
			guiSetVisible(lblUsername, true)
			guiSetVisible(lblPassword, true)
			guiSetVisible(btnLogin, true)
			guiSetVisible(btnRegister, true)
			guiSetVisible(checkboxRemember, true)
			guiSetVisible(checkboxAutologin, true)
			guiSetVisible(lblInfo_1, true)
			guiSetVisible(lblInfo_2, true)
			
			guiSetText(source, "About")
			guiSetEnabled(btnInformation, true)
		
		end
	end
end	

function displayInformation( button, state )
	if source == btnInformation and button == "left" and state == "up" then
		
		if guiGetText(source) == "Information" then
			
			guiSetVisible(editUsername, false)
			guiSetVisible(editPassword, false)
			guiSetVisible(lblUsername, false)
			guiSetVisible(lblPassword, false)
			guiSetVisible(btnLogin, false)
			guiSetVisible(btnRegister, false)
			guiSetVisible(checkboxRemember, false)
			guiSetVisible(checkboxAutologin, false)
			guiSetVisible(lblInfo_1, false)
			guiSetVisible(lblInfo_2, false)
			
			local lblinfo_width, lblinfo_height = 100, 18
			local lblinfo_x, lblinfo_y = ((screenX/2) - (lblinfo_width/2) - 20), ((screenY/2) - (lblinfo_height/2) - 200)
				
			lblInformation_1 = guiCreateLabel(lblinfo_x, lblinfo_y, lblinfo_width + 90, lblinfo_height, "Information - Arsenic Roleplay", false, nil)
			lblInformation_2 = guiCreateLabel(lblinfo_x - 80, lblinfo_y + 20, lblinfo_width + 300, lblinfo_height, "Welcome to Arsenic Roleplay, this is a roleplay server which", false, nil)
			lblInformation_3 = guiCreateLabel(lblinfo_x - 80, lblinfo_y + 40, lblinfo_width + 300, lblinfo_height, "means that you are supposed to behave/act like you would in real", false, nil)
			lblInformation_4 = guiCreateLabel(lblinfo_x - 80, lblinfo_y + 60, lblinfo_width + 300, lblinfo_height, "life.", false, nil)
			lblInformation_5 = guiCreateLabel(lblinfo_x - 80, lblinfo_y + 100, lblinfo_width + 300, lblinfo_height, "Arsenic Roleplay presents its players with a totally fantastic", false, nil)
			lblInformation_6 = guiCreateLabel(lblinfo_x - 80, lblinfo_y + 120, lblinfo_width + 300, lblinfo_height, "roleplay script which will make you fall off your seat if you have been", false, nil)
			lblInformation_7 = guiCreateLabel(lblinfo_x - 80, lblinfo_y + 140, lblinfo_width + 300, lblinfo_height, "roleplaying on a SAMP server during the past.", false, nil)
			lblInformation_8 = guiCreateLabel(lblinfo_x - 80, lblinfo_y + 160, lblinfo_width + 300, lblinfo_height, "MTA allows us to present our players with wonderful and unimaginably", false, nil)
			lblInformation_9 = guiCreateLabel(lblinfo_x - 80, lblinfo_y + 180, lblinfo_width + 300, lblinfo_height, "flexible GUIs along with Direct X drawing functions, Moreover the", false, nil)
			lblInformation_10 = guiCreateLabel(lblinfo_x - 80, lblinfo_y + 200, lblinfo_width + 300, lblinfo_height, "programming language used by our scripters is also very easy to learn", false, nil)
			lblInformation_11 = guiCreateLabel(lblinfo_x - 80, lblinfo_y + 220, lblinfo_width + 300, lblinfo_height, "and facile.", false, nil)
			lblInformation_12 = guiCreateLabel(lblinfo_x - 80, lblinfo_y + 260, lblinfo_width + 300, lblinfo_height, "While playing here, you will have to keep in mind some terms and rules,", false, nil)
			lblInformation_13 = guiCreateLabel(lblinfo_x - 80, lblinfo_y + 280, lblinfo_width + 300, lblinfo_height, "you can get a whole list of our rules and terms by pressing F1 anytime", false, nil)
			lblInformation_14 = guiCreateLabel(lblinfo_x - 80, lblinfo_y + 300, lblinfo_width + 300, lblinfo_height, "while playing. If you fail to follow or obey any rule, you will be jailed", false, nil)
			lblInformation_15 = guiCreateLabel(lblinfo_x - 80, lblinfo_y + 320, lblinfo_width + 300, lblinfo_height, "by an Administrator and possibly banned if you continue to break them.", false, nil)
			lblInformation_16 = guiCreateLabel(lblinfo_x - 80, lblinfo_y + 360, lblinfo_width + 300, lblinfo_height, "We hope you enjoy playing at at our server,", false, nil)
			lblInformation_17 = guiCreateLabel(lblinfo_x - 80, lblinfo_y + 380, lblinfo_width + 300, lblinfo_height, "	- Arsenic Roleplay Administration Team.", false, nil)
			
			guiSetText(source, "Back")
			guiSetEnabled(btnAbout, false)
			
		elseif guiGetText(source) == "Back" then
			
			destroyElement(lblInformation_1)
			destroyElement(lblInformation_2)
			destroyElement(lblInformation_3)
			destroyElement(lblInformation_4)
			destroyElement(lblInformation_5)
			destroyElement(lblInformation_6)
			destroyElement(lblInformation_7)
			destroyElement(lblInformation_8)
			destroyElement(lblInformation_9)
			destroyElement(lblInformation_10)
			destroyElement(lblInformation_11)
			destroyElement(lblInformation_12)
			destroyElement(lblInformation_13)
			destroyElement(lblInformation_14)
			destroyElement(lblInformation_15)
			destroyElement(lblInformation_16)
			destroyElement(lblInformation_17)
			
			guiSetVisible(editUsername, true)
			guiSetVisible(editPassword, true)
			guiSetVisible(lblUsername, true)
			guiSetVisible(lblPassword, true)
			guiSetVisible(btnLogin, true)
			guiSetVisible(btnRegister, true)
			guiSetVisible(checkboxRemember, true)
			guiSetVisible(checkboxAutologin, true)
			guiSetVisible(lblInfo_1, true)
			guiSetVisible(lblInfo_2, true)
			
			guiSetText(source, "Information")
			guiSetEnabled(btnAbout, true)
		
		end
	end
end	

function signIn( button, state )
	if button == "left" and state == "up" then
		
		if source == btnRegister then
			
			local username = guiGetText(editUsername)
			local password = guiGetText(editPassword)
			
			if string.len(username) > 2 then
				
				if string.len(password) > 5 then
					
					if ( not clickedRegister ) then
						
						clickedRegister = true
						triggerServerEvent("attemptRegister", getLocalPlayer(), username, password)
					end
				else
					
					showMessage( "Your password should be atleast 6 characters long.", 280 )
				end
			else
				
				showMessage( "Your username should be atleast 3 characters long.", 280 )
			end	
		else
			
			local username = guiGetText(editUsername)
			local password = guiGetText(editPassword)
			
			if string.len(username) > 2 then
				
				if string.len(password) > 5 then
					
					if ( not clickedSignin ) then
						
						clickedSignin = true
						
						local remb = 0
						if ( remember == true ) then
							remb = 1
						end	
						
						triggerServerEvent("attemptLogin", getLocalPlayer(), username, password, remb)
					end	
				else
					
					showMessage( "Your password should be atleast 6 characters long.", 280 )
				end
			else
				
				showMessage( "Your username should be atleast 3 characters long.", 280 )
			end	
		end
	end
end
	
function showMessage( str, width )
	if tostring(str) then
		
		error_width, error_height = width, 18
		error_x, error_y = (screenX/2) - (error_width/2), ((screenY/2) - (error_height/2) - 20)
	
		if isElement(lblError) then
			
			destroyElement(lblError)
			lblError = nil
		end	
		
		if isTimer(removeTimer) then
			killTimer(removeTimer)
		end	
		
		lblError = guiCreateLabel(error_x, error_y, error_width, error_height, tostring(str), false, nil)
		playSoundFrontEnd(32)
		
		local removeTimer = setTimer(function() if isElement(lblError) then destroyElement(lblError) lblError = nil end end, 3000, 1)
		
		clickedSignin = false
		clickedRegister = false
	end
end
addEvent("showSignInMessage", true)
addEventHandler("showSignInMessage", getLocalPlayer(), showMessage)
	
function cleanLoginScreen( )
	removeEventHandler("onClientRender", getRootElement(), rotateCamera)
	removeEventHandler("onClientRender", getRootElement(), renderDirectX)
	
	if ( editUsername ) then
		destroyElement(editUsername)
		editUsername = nil
	end
	
	if ( editPassword ) then
		destroyElement(editPassword)
		editPassword = nil
	end

	if ( lblUsername ) then
		destroyElement(lblUsername)
		lblUsername = nil
	end
	
	if ( lblPassword ) then
		destroyElement(lblPassword)
		lblPassword = nil
	end
	
	if ( btnLogin ) then
		destroyElement(btnLogin)
		btnLogin = nil
	end
	
	if ( btnRegister ) then
		destroyElement(btnRegister)
		btnRegister = nil
	end
	
	if ( checkboxRemember ) then
		destroyElement(checkboxRemember)
		checkboxRemember = nil
	end
	
	if ( checkboxAutologin ) then
		destroyElement(checkboxAutologin)
		checkboxAutologin = nil
	end
	
	if ( lblInfo_1 ) then
		destroyElement(lblInfo_1)
		lblInfo_1 = nil
	end
	
	if ( lblInfo_2 ) then
		destroyElement(lblInfo_2)
		lblInfo_2 = nil
	end
	
	if ( btnAbout ) then
		destroyElement(btnAbout)
		btnAbout = nil
	end
	
	if ( btnInformation ) then
		destroyElement( btnInformation )
		btnInformation = nil
	end
	
	guiSetInputEnabled(false)
	showCursor(false)
end
addEvent("cleanUpLogin", true)
addEventHandler("cleanUpLogin", getLocalPlayer(), cleanLoginScreen)	

function savePlayerDetails( username, password )
	if ( username and password ) then
		
		if ( remember ) then
			
			local xml = xmlLoadFile("login.xml")
			if ( xml ) then
				
				local user = xmlFindChild( xml, "username", 0 )
				local pass = xmlFindChild( xml, "password", 0 )
				
				xmlNodeSetValue( user, tostring(username) )
				xmlNodeSetValue( pass, tostring(password) )
				
				xmlSaveFile(xml)
				xmlUnloadFile(xml)
			end
		end	
	end
end
addEvent("savePlayerDetails", true)
addEventHandler("savePlayerDetails", localPlayer, savePlayerDetails)

function rememberDetails( button, state )
	if ( button == "left" and state == "up" ) then
		
		local xml = xmlLoadFile("login.xml")
		local node = xmlFindChild( xml, "remember", 0 )
		
		if ( remember == true ) then
			
			remember = false
			xmlNodeSetValue( node, "0" )
			
			local user = xmlFindChild( xml, "username", 0 )
			local pass = xmlFindChild( xml, "password", 0 )
			
			xmlNodeSetValue( user, "" )
			xmlNodeSetValue( pass, "" ) 
			
			-- Can't auto login if the password is not saving.
			autologin = false
			guiCheckBoxSetSelected( checkboxAutologin, false )
			
			local node = xmlFindChild( xml, "autologin", 0 )
			xmlNodeSetValue( node, "0" )
		else
			
			remember = true
			xmlNodeSetValue( node, "1" )
		end
		
		xmlSaveFile(xml)
		xmlUnloadFile(xml)
	end	
end

function autoLogin( button, state )
	if ( button == "left" and state == "up" ) then
		
		local xml = xmlLoadFile("login.xml")
		local node = xmlFindChild( xml, "autologin", 0 )
		
		if ( autologin == true ) then
			
			autologin = false
			xmlNodeSetValue( node, "0" )
		else
			
			autologin = true
			xmlNodeSetValue( node, "1" )
			
			-- Remember too
			remember = true
			guiCheckBoxSetSelected( checkboxRemember, true )
			
			local node = xmlFindChild( xml, "remember", 0 )
			xmlNodeSetValue( node, "1" )
		end
		
		xmlSaveFile(xml)
		xmlUnloadFile(xml)
	end	
end

function hidePlayerHud( )
	showPlayerHudComponent("ammo", false)
	showPlayerHudComponent("area_name", false)
	showPlayerHudComponent("armour", false)
	showPlayerHudComponent("breath", false)
	showPlayerHudComponent("clock", false)
	showPlayerHudComponent("health", false)
	showPlayerHudComponent("money", false)
	showPlayerHudComponent("radar", false)
	showPlayerHudComponent("vehicle_name", false)
	showPlayerHudComponent("weapon", false)
	
	showChat(false)
end