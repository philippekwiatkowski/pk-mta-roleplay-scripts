--------- [ Fuel Stations ] ---------
local screenX, screenY = guiGetScreenSize( )
local open = false

local stations = 
{ 
	{ 69.8613, 1217.4227, 19.0804, 75, "Jeremy Shepard" },
	{ 612.5908, 1691.6083, 7.1875, 34, "Mark Williams" },
	{ -1329.4208, 2680.5966, 50.4687, 73, "John O'Connel" },
	{ -1464.3720, 1868.3369, 32.8333, 184, "Stefan Brown" },
	{ -1680.4912, 415.0917, 7.3984, 224, "Steven White" },
	{ 2116.5039, 925.6210, 10.9609, 180, "Carl Sanders" },
	{ 2638.4511, 1100.9570, 10.9609, 358, "Peter Woods" },
	{ 1941.5585, -1776.4755, 13.6406, 89, "Richard Henry" },
	{ 2256.0859, 27.2636, 26.5828, 2, "Jason Reed" },
	{ 655.7255, -557.8544, 16.5014, 91, "Jack Normal" },
	{ -2026.5937, 156.8115, 29.0390, 91, "Silvius Audre" }
}

local gasPedestrian = { }

function spawnGasPedestrian( )
	for key, value in ipairs ( stations ) do
		
		local pedestrian = createPed( 50, value[1], value[2], value[3], value[4] )
		gasPedestrian[pedestrian] = value[5]
	end	
end
addEventHandler("onClientResourceStart", resourceRoot, spawnGasPedestrian)

function onClickGasPedestrian( button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
	if ( button == "right" and state == "up" ) then
		
		if ( clickedElement ) then
			if ( getElementType( clickedElement ) == "ped" ) then
				
				local find = false
				for key, value in pairs ( gasPedestrian ) do
					
					if ( key == clickedElement ) then
						
						find = true
						break
					end
				end	
				
				if ( find ) then
					
					if ( not isElement( gasWindow ) ) and ( open == false ) then
						
						createGasUI( gasPedestrian[clickedElement] )
						open = true
					end	
				end	
			end	
		end			
	end
end
addEventHandler("onClientClick", root, onClickGasPedestrian)

function createGasUI( theName )
	local vehicle = getPedOccupiedVehicle( localPlayer )
	if ( vehicle ) then
	
		local width, height = 300, 170
		local x, y = ( screenX/2 - width/2 ), ( screenY/2 - height/2 )
		
		gasWindow = guiCreateWindow( x, y, width, height, "Gas Station", false )
		labelQuestion = guiCreateLabel( 15, 30, 270, 20, "Hello, would you like to refuel your vehicle?", false, gasWindow )
		
		buttonYes = guiCreateButton( 80, 60, 140, 40, "Yes please", false, gasWindow )
		addEventHandler("onClientGUIClick", buttonYes,
			function( button, state )
				if ( button == "left" and state == "up" ) then
					
					destroyElement( gasWindow )
					open = false
					
					local money = math.floor(getPlayerMoney( localPlayer )/100)
					if ( money >= 130 ) then
					
						local engineOn = getVehicleEngineState( vehicle )
						if ( not engineOn ) then
							
							outputChatBox("[English] ".. theName .." says: Alright, just a second.", 255, 255, 255)
							setTimer( outputChatBox, 2000, 1, "* ".. theName .." extends his arm for the gas hose, taking it off the pump.", 127, 88, 205)
							setTimer( outputChatBox, 5000, 1, "* ".. theName .." reaches for the fuel jack, turning it open and placing the hose inside it.", 127, 88, 205)
							setTimer( outputChatBox, 8000, 1, "* ".. theName .." takes out the hose, placing it back on the pump.", 127, 88, 205)
							
							setTimer( 
								function( )
								
									outputChatBox("[English] ".. theName .." says: You're good to go.", 255, 255, 255)
									triggerServerEvent("refuelFromGasStation", localPlayer, vehicle)
								end, 11000, 1
							)	
						else
							outputChatBox("[English] ".. theName .." says: Turn off your engine, brother.", 255, 255, 255)
						end
					else
						outputChatBox("You need atleast $130 to refuel your vehicle.", 255, 0, 0)
					end	
 				end
			end, false
		)	
		
		buttonNo = guiCreateButton( 80, 110, 140, 40, "Not really, thanks", false, gasWindow )
		addEventHandler("onClientGUIClick", buttonNo,
			function( button, state )
				if ( button == "left" and state == "up" ) then
					
					destroyElement( gasWindow )
					open = false
				end
			end, false
		)	
		
		guiSetFont( labelQuestion, "clear-normal" )
	else
		outputChatBox("You need a vehicle in order to refuel.", 255, 0, 0)
	end	
end