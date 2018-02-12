local screenX, screenY = guiGetScreenSize( )

local theElement = nil
local get = false
function showCheckUI( thePlayer, accountname, accountid, ip, admin, reports, name, faction, adminnote )
	if ( not isElement( checkWindow ) ) then
		
		local width, height = 350, 350
		local x, y = (screenX - screenX) + 2, (screenY/2) - (height/2)
		
		get = true
		theElement = thePlayer
		
		checkWindow = guiCreateWindow(x, y, width, height, "Check Player", false)
		
		buttonExit = guiCreateButton(310, 30, 30, 20, "x", false, checkWindow)
		addEventHandler("onClientGUIClick", buttonExit,
			function( button, state )
				if ( button == "left" and state == "up" ) then
					
					destroyElement( checkWindow )
					guiSetInputEnabled( false )
					
					-- Stop
					get = false
					triggerServerEvent("stopSending", localPlayer)
					
					theElement = nil
				end
			end
		)
		
		nameLabel = guiCreateLabel(20, 30, 150, 20, "Name: ".. name, false, checkWindow)
		
		usernameLabel = guiCreateLabel(20, 50, 200, 20, "Username: ".. accountname, false, checkWindow)
		useridLabel = guiCreateLabel(20, 65, 150, 20, "Account ID: ".. accountid, false, checkWindow)
		ipLabel = guiCreateLabel(20, 80, 150, 20, "IP: ".. ip, false, checkWindow)
		adminLabel = guiCreateLabel(20, 95, 200, 20, "Admin Level: ".. admin, false, checkWindow)
		reportLabel = guiCreateLabel(20, 110, 150, 20, "Reports: ".. reports, false, checkWindow)
		
		positionLabel = guiCreateLabel(20, 130, 230, 20, "Position: ", false, checkWindow)
		weaponLabel = guiCreateLabel(20, 145, 150, 20, "Weapon: ", false, checkWindow)
		healthLabel = guiCreateLabel(20, 160, 150, 20, "", false, checkWindow)
		armorLabel = guiCreateLabel(20, 175, 150, 20, "", false, checkWindow)
		moneyLabel = guiCreateLabel(20, 190, 150, 20, "Money: $", false, checkWindow)
		vehicleLabel = guiCreateLabel(20, 205, 150, 20, "", false, checkWindow)
		factionLabel = guiCreateLabel(20, 220, 330, 20, "Faction: ".. faction, false, checkWindow)
		
		guiSetFont(nameLabel, "clear-normal")
		
		guiSetFont(usernameLabel, "clear-normal")
		guiSetFont(useridLabel, "clear-normal")
		guiSetFont(ipLabel, "clear-normal")
		guiSetFont(adminLabel, "clear-normal")
		guiSetFont(reportLabel, "clear-normal")
		guiSetFont(factionLabel, "clear-normal")
		
		addEventHandler("onClientRender", root,		-- Updating values
			function( )
				if ( isElement( checkWindow ) ) then
					
					local health = tostring( math.floor( getElementHealth( theElement ) ) )
					local armor = tostring( math.floor( getPedArmor( theElement ) ) )
					
					local vehicle = "None"
					
					if ( getPedOccupiedVehicle( theElement ) ) then
						vehicle = getVehicleName( getPedOccupiedVehicle( theElement ) )
					end
					
					guiSetText(healthLabel, "Health: ".. health .."%")
					guiSetText(armorLabel, "Armor: ".. armor .."%")
					guiSetText(vehicleLabel, "Vehicle: ".. vehicle)
				end	
			end
		)
		
		
		adminnoteLabel = guiCreateLabel(20, 250, 150, 20, "Admin Note:", false, checkWindow)
		
		-- If 'nil', then empty
		if ( tostring( adminnote ) == "nil" ) then
			adminnote = ""
		end	
		
		adminnoteMemo = guiCreateMemo(20, 270, 250, 60, tostring( adminnote ), false, checkWindow)
		addEventHandler("onClientGUIClick", adminnoteMemo, toggleInput, false)
		
		saveNoteButton = guiCreateButton(280, 280, 50, 40, "Save Note", false, checkWindow)
		addEventHandler("onClientGUIClick", saveNoteButton,
			function( button, state )
				if ( button == "left" and state == "up" ) then
					
					local text = guiGetText( adminnoteMemo )
					triggerServerEvent("savePlayerNote", localPlayer, theElement, text )
				end
			end
		)
		
		guiSetFont(positionLabel, "clear-normal")
		guiSetFont(weaponLabel, "clear-normal")
		guiSetFont(healthLabel, "clear-normal")
		guiSetFont(armorLabel, "clear-normal")
		guiSetFont(vehicleLabel, "clear-normal")
		guiSetFont(adminnoteLabel, "clear-normal")
	end	
end
addEvent( "showCheckUI", true )
addEventHandler( "showCheckUI", localPlayer, showCheckUI )

function toggleInput( )
	guiSetInputEnabled( true )
end

function sendServerData( data )
	if ( get ) then
		
		local position = tostring( data[1] )
		local weapon = tostring( data[2] )
		local money = tostring( data[3] )
		
		if ( positionLabel ) then
			guiSetText(positionLabel, "Position: ".. position)
		end
			
		if ( weaponLabel ) then
			guiSetText(weaponLabel, "Weapon: ".. weapon)
		end
		
		if ( moneyLabel ) then	
			guiSetText(moneyLabel, "Money: $".. money)
		end	
	end	
end
addEvent("sendServerData", true)
addEventHandler("sendServerData", localPlayer, sendServerData)

function stopGetting( )
	if ( get ) then
		get = false
	end	
end
addEvent("stopGetting", true)
addEventHandler("stopGetting", localPlayer, stopGetting)

addEventHandler("onClientPlayerQuit", root,
	function( )
		if ( source == theElement ) then
			if ( isElement( checkWindow ) ) then
				
				destroyElement( checkWindow )
				
				-- Stop
				get = false
				triggerServerEvent("stopSending", localPlayer)
			end
		end
	end
)	

function decimalPlace( num )

	local num = tostring(num)
	local len = string.len(num)
	
	local place, i = nil, 1
	while i <= len do
		if ( string.sub(num, i, i) == "." ) then
			
			place = i
			break
		else
			i = i + 1
		end	
	end
	
	return place
end