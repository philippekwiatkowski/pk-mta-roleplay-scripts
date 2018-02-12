local localPlayer = getLocalPlayer ( )
local value = nil

function createPanelWindow ()

	if isPedInVehicle (localPlayer) then
	
		local vehicle = getPedOccupiedVehicle (localPlayer)
		
		showCursor(true,true)
	
		local screenX, screenY = guiGetScreenSize()

		local width, height = 300, 230	
		local x = (screenX/2) - (width/2)
		local y = (screenY/2) - (height/2)
	
		panelWindow = guiCreateWindow(x, y, width, height, "Vehicle Panel", false)
	
		guiWindowSetSizable(panelWindow,false)
	
	
		bonnetButton = guiCreateButton(20,30,125,35,"Bonnet",false,panelWindow)
		trunkButton = guiCreateButton(155,30,125,35,"Trunk",false,panelWindow)
	
		leftfrontdoorButton = guiCreateButton(20,80,125,35,"Left Frontdoor",false,panelWindow)
		leftbackdoorButton = guiCreateButton(20,130,125,35,"Left Backdoor",false,panelWindow)
	
		rightfrontdoorButton = guiCreateButton(155,80,125,35,"Right Frontdoor",false,panelWindow)
		rightbackdoorButton = guiCreateButton(155,130,125,35,"Right Backdoor",false,panelWindow)
	
		closeButton = guiCreateButton(20,180,260,35,"Close",false,panelWindow)
	
		addEventHandler("onClientGUIClick", bonnetButton, onBonnetPress, false)
		addEventHandler("onClientGUIClick", trunkButton, onTrunkPress, false)
		addEventHandler("onClientGUIClick", leftfrontdoorButton, onLeftFrontPress, false)
		addEventHandler("onClientGUIClick", leftbackdoorButton, onLeftBackPress, false)
		addEventHandler("onClientGUIClick", rightfrontdoorButton, onRightFrontPress, false)
		addEventHandler("onClientGUIClick", rightbackdoorButton, onRightBackPress, false)
		addEventHandler("onClientGUIClick", closeButton, onClosePress, false)
		
	else
	
		outputChatBox ("You need to be inside a vehicle to use the vehicle panel!", 255, 0, 0, false)
	
	end
end
addCommandHandler ("panel", createPanelWindow)
addCommandHandler ("doors", createPanelWindow)

function onBonnetPress(button,state)
	if button == "left" and state == "up" then	
		
		value = 1
		triggerServerEvent ( "toggleDoor", getLocalPlayer(), value)	
		
	end
end

function onTrunkPress(button,state)
	if button == "left" and state == "up" then	
		
		value = 2
		triggerServerEvent ( "toggleDoor", getLocalPlayer(), value)		
		
	end
end

function onLeftFrontPress(button,state)
	if button == "left" and state == "up" then	
		
		value = 3
		triggerServerEvent ( "toggleDoor", getLocalPlayer(), value)		
		
	end
end

function onLeftBackPress(button,state)
	if button == "left" and state == "up" then	
		
		value = 4
		triggerServerEvent ( "toggleDoor", getLocalPlayer(), value)	
		
	end
end

function onRightFrontPress(button,state)
	if button == "left" and state == "up" then	
		
		value = 5
		triggerServerEvent ( "toggleDoor", getLocalPlayer(), value)	
		
	end
end

function onRightBackPress(button,state)
	if button == "left" and state == "up" then	
		
		value = 6
		triggerServerEvent ( "toggleDoor", getLocalPlayer(), value)	
		
	end
end

function onClosePress(button,state)
	if button == "left" and state == "up" then
		
		showCursor(false)
		destroyElement(panelWindow)
		value = nil
	end
end