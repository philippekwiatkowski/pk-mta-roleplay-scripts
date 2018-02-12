--------- [ Death System ] ---------
function respawnPlayer( )
	spawnPlayer(source, -2660.5976, 630.1435, 14.4531, 180, getElementModel( source ), 0, 0, getPlayerTeam( source ))
	toggleControl( source, "sprint", true )
	toggleControl( source, "jump", true )

	fadeCamera(source, true, 6)
	setCameraInterior(source, 0)
	
	outputChatBox("You have recieved treatment from the San Fierro Medical Center.", source, 255, 255, 0)
end
addEvent("respawnPlayer", true)
addEventHandler("respawnPlayer", root, respawnPlayer)

--------- [ Injuries ] ---------

function injuries(attacker, weapon, bodypart, loss)
	
	if (weapon == 22 or weapon == 23 or weapon == 24 or weapon == 25 or weapon == 26 or weapon == 27 or weapon == 28 or weapon == 29 or weapon == 30 or weapon == 31 or weapon == 32 or weapon == 33 or weapon == 34) then
		if bodypart == 3 then
			if bodypart == 3 and getPedArmor(source) > 0 then
				outputChatBox("You got shot in your body armor!", source, 255, 0, 0)
				cancelEvent()
				return
			else
				sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." gets shot in the torso.")
				setElementHealth(source,getElementHealth(source)-15)
				return
			end
		elseif bodypart == 4 then
			sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." gets shot in the buttocks.")
			setElementHealth(source,getElementHealth(source)-7)
			return
		elseif bodypart == 5 then
			sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." gets shot in left arm.")
			setElementHealth(source,getElementHealth(source)-7)
			return
		elseif bodypart == 6 then
			sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." gets shot in right arm.")
			setElementHealth(source,getElementHealth(source)-7)
			return
		elseif bodypart == 7 then
			sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." gets shot in left leg.")
			toggleControl( source, "sprint", false )
			toggleControl( source, "jump", false )
			setElementHealth(source,getElementHealth(source)-7)
			return
		elseif bodypart == 8 then
			sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." gets shot in right leg.")
			toggleControl( source, "sprint", false )	
			toggleControl( source, "jump", false )			
			setElementHealth(source,getElementHealth(source)-7)
			return
		end
	end
	
	-- drowning
	if weapon == 53 then
		return
	end
	
	-- source = player who was hit
	if not bodypart and getPedOccupiedVehicle(source) then
		bodypart = 3
	end

	if bodypart == 9 then -- headshot
		 
		local x1, y1, z1 = getElementPosition(source)
		local x2, y2, z2 = getElementPosition(attacker)
		sendActionToNearbyPlayers(source, " ** ".. getPlayerName(source):gsub("_", " ") .." gets shot in the head.")
		
		if  (getDistanceBetweenPoints3D( x1, y1, z1, x2, y2, z2) < 6) then
			killPed(source, attacker, weapon, bodypart)
			return
		else

			chances = math.random(1, 7)
			if (chances == 1) then
				killPed(source, attacker, weapon, bodypart)
				return
			end	
		end
	end
end

addEventHandler( "onPlayerDamage", getRootElement(), injuries )

function sendActionToNearbyPlayers( thePlayer, action )
	local action = tostring(action)
	
	for i, nearbyPlayer in ipairs ( getElementsByType("player") ) do
		local px, py, pz = getElementPosition(nearbyPlayer)
		local x, y, z = getElementPosition(thePlayer)
		if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 20) then
			outputChatBox(action, nearbyPlayer, 127, 88, 205)
		end
	end
end