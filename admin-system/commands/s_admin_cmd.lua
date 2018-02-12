-- /givegun 
-- /disarm 
-- /sethp 
-- /setarmor 
-- /setskin 
-- /changename 
-- /hideadmin 
-- /slap 
-- /hugeslap 
-- /watch 
-- /pkick
-- /pban 
-- /unban 
-- /makeadmin 
-- /jail 
-- /unjail 
-- /setmoney 
-- /givemoney 
-- /freeze 
-- /unfreeze 
-- /makedonator 
-- /adminduty 
-- /setmotd 
-- /setamotd 
-- /warn 
-- /unwarn 
-- /disappear 
-- /tognametag 
-- /resetcharacter
-- /givelicense 
-- /setvehlimit 
-- /giveitem 
-- /takeitem
-- /check
-- /checkinv
-- /x
-- /y
-- /z
-- /allchars
-- /allaccs

local sql = exports.sql

local function getData( theElement, key )
	local key = tostring(key)
	if isElement(theElement) and (key) then
		
		return exports['[ars]anticheat-system']:callData( theElement, tostring(key) )
	else
		return false
	end
end	

local function setData( theElement, key, value, sync )
	local key = tostring(key)
	local value = tonumber(value) or tostring(value)
	if isElement(theElement) and (key) and (value) then
		
		return exports['[ars]anticheat-system']:assignData( theElement, tostring(key), value, sync )
	else
		return false
	end	
end

-- /freconnect
function forceReconnect( thePlayer, commandName, partialPlayerName )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (partialPlayerName) then
			
			local players = exports['[ars]global']:findPlayer( thePlayer, partialPlayerName )
			
			if #players == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #players > 1 then
				outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
				
				local count = 0
				for k, foundPlayer in ipairs (players) do
					
					count = count + 1
					outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayer in ipairs (players) do
					
					redirectPlayer(foundPlayer, "91.215.156.68", 22003)
					outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." was force reconnected.", thePlayer, 212, 156, 49)
					
					exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." force reconnect ".. getPlayerName(foundPlayer):gsub("_", " ") ..".")
				end	
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Player Name / ID]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("freconnect", forceReconnect, false, false)	

-- /tpto
function teleportTo( thePlayer, commandName, partialPlayerName )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (partialPlayerName) then
			
			local players = exports['[ars]global']:findPlayer( thePlayer, partialPlayerName )
			
			if #players == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #players > 1 then
				outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
				
				local count = 0
				for k, foundPlayer in ipairs (players) do
					
					count = count + 1
					outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayer in ipairs (players) do
					
					if getData(foundPlayer, "loggedin") == 1 then
					
						if not isPedInVehicle(foundPlayer) and not isPedInVehicle(thePlayer) then 
							
							local x, y, z = getElementPosition(foundPlayer)
							local dimension = getElementDimension(foundPlayer)
							local interior = getElementInterior(foundPlayer)
							local rotation = getPedRotation(foundPlayer)
							
							x = x + ( ( math.cos ( math.rad ( rotation ) ) ) * 2 )
							y = y + ( ( math.sin ( math.rad ( rotation ) ) ) * 2 )
							
							fadeCamera(thePlayer, false, 0)
							
							setElementPosition(thePlayer, x, y, z)
							setElementDimension(thePlayer, dimension)
							setElementInterior(thePlayer, interior)
							
							fadeCamera(thePlayer, true, 1)
						
						elseif isPedInVehicle(foundPlayer) and not isPedInVehicle(thePlayer) then 
							
							local vehicle = getPedOccupiedVehicle(foundPlayer)
							fadeCamera(thePlayer, false, 0)
							
							warpPedIntoVehicle(thePlayer, vehicle, 1)
							
							fadeCamera(thePlayer, true, 1)
						
						elseif not isPedInVehicle(foundPlayer) and isPedInVehicle(thePlayer) then
							
							local vehicle = getPedOccupiedVehicle(thePlayer)
							local x, y, z = getElementPosition(foundPlayer)
							local dimension = getElementDimension(foundPlayer)
							local interior = getElementInterior(foundPlayer)
							local rotation = getPedRotation(foundPlayer)
							
							x = x + ( ( math.cos ( math.rad ( rotation ) ) ) * 2 )
							y = y + ( ( math.sin ( math.rad ( rotation ) ) ) * 2 )
							
							fadeCamera(thePlayer, false, 0)
							
							removePedFromVehicle(thePlayer, vehicle)
							setElementPosition(thePlayer, x, y, z)
							setElementDimension(thePlayer, dimension)
							setElementInterior(thePlayer, interior)
							
							fadeCamera(thePlayer, true, 1)
						
						elseif isPedInVehicle(foundPlayer) and isPedInVehicle(thePlayer) then 
						
							local _vehicle = getPedOccupiedVehicle(thePlayer)
							
							local vehicle = getPedOccupiedVehicle(foundPlayer)
							local x, y, z = getElementPosition(vehicle)
							local dimension = getElementDimension(vehicle)
							local interior = getElementInterior(vehicle)
							local _, _, rotation = getVehicleRotation(vehicle)
							
							x = x + ( ( math.cos ( math.rad ( rotation ) ) ) * 3 )
							y = y + ( ( math.sin ( math.rad ( rotation ) ) ) * 3 )
							
							fadeCamera(thePlayer, false, 0)
							
							setElementPosition(_vehicle, x, y, z)
							setElementDimension(_vehicle, dimension)
							setElementInterior(_vehicle, interior)
							setVehicleRotation(_vehicle, 0, 0, rotation)
							
							fadeCamera(thePlayer, true, 1)
							
						end
						
						outputChatBox("Administrator ".. getPlayerName(thePlayer):gsub("_", " ") .." has teleported to you.", foundPlayer, 212, 156, 49)
						outputChatBox("You teleported to ".. getPlayerName(foundPlayer):gsub("_", " ") ..".", thePlayer, 212, 156, 49)
					else
						outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." is not logged in.", thePlayer, 255, 0, 0)
					end
				end
			end
		else
			outputChatBox("SYNATX: /".. commandName .." [ Player Name / ID ]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("tpto", teleportTo, false, false)	
	
-- /tphere
function teleportHere( thePlayer, commandName, partialPlayerName )	
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (partialPlayerName) then
			
			local players = exports['[ars]global']:findPlayer( thePlayer, partialPlayerName )
			
			if #players == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #players > 1 then
				outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
				
				local count = 0
				for k, foundPlayer in ipairs (players) do
					
					count = count + 1
					outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayer in ipairs (players) do
					
					if getData(foundPlayer, "loggedin") == 1 then
			
						if not isPedInVehicle(foundPlayer) and not isPedInVehicle(thePlayer) then 
							
							local x, y, z = getElementPosition(thePlayer)
							local dimension = getElementDimension(thePlayer)
							local interior = getElementInterior(thePlayer)
							local rotation = getPedRotation(thePlayer)
							
							x = x + ( ( math.cos ( math.rad ( rotation ) ) ) * 2 )
							y = y + ( ( math.sin ( math.rad ( rotation ) ) ) * 2 )
							
							fadeCamera(foundPlayer, false, 0)
							
							setElementPosition(foundPlayer, x, y, z)
							setElementDimension(foundPlayer, dimension)
							setElementInterior(foundPlayer, interior)
							
							fadeCamera(foundPlayer, true, 1)
						
						elseif isPedInVehicle(foundPlayer) and not isPedInVehicle(thePlayer) then 
							
							local vehicle = getPedOccupiedVehicle(foundPlayer)
							local x, y, z = getElementPosition(thePlayer)
							local dimension = getElementDimension(thePlayer)
							local interior = getElementInterior(thePlayer)
							local rotation = getPedRotation(thePlayer)
							
							x = x + ( ( math.cos ( math.rad ( rotation ) ) ) * 2 )
							y = y + ( ( math.sin ( math.rad ( rotation ) ) ) * 2 )
							
							fadeCamera(foundPlayer, false, 0)
							
							removePedFromVehicle(foundPlayer, vehicle)
							setElementPosition(foundPlayer, x, y, z)
							setElementDimension(foundPlayer, dimension)
							setElementInterior(foundPlayer, interior)
							
							fadeCamera(foundPlayer, true, 1)
						
						elseif not isPedInVehicle(foundPlayer) and isPedInVehicle(thePlayer) then
							
							local vehicle = getPedOccupiedVehicle(thePlayer)
							
							fadeCamera(foundPlayer, false, 0)
							
							warpPedIntoVehicle(foundPlayer, vehicle, 1)
							
							fadeCamera(foundPlayer, true, 1)
						
						elseif isPedInVehicle(foundPlayer) and isPedInVehicle(thePlayer) then 
						
							local _vehicle = getPedOccupiedVehicle(thePlayer)
							
							local vehicle = getPedOccupiedVehicle(foundPlayer)
							local x, y, z = getElementPosition(_vehicle)
							local dimension = getElementDimension(_vehicle)
							local interior = getElementInterior(_vehicle)
							local _, _, rotation = getVehicleRotation(_vehicle)
							
							x = x + ( ( math.cos ( math.rad ( rotation ) ) ) * 3 )
							y = y + ( ( math.sin ( math.rad ( rotation ) ) ) * 3 )
							
							fadeCamera(foundPlayer, false, 0)
							
							setElementPosition(vehicle, x, y, z)
							setElementDimension(vehicle, dimension)
							setElementInterior(vehicle, interior)
							setVehicleRotation(vehicle, 0, 0, rotation)
							
							fadeCamera(foundPlayer, true, 1)
							
						end
						
						outputChatBox("Administrator ".. getPlayerName(thePlayer):gsub("_", " ") .." has teleported you to them.", foundPlayer, 212, 156, 49)
						outputChatBox("You teleported ".. getPlayerName(foundPlayer):gsub("_", " ") .." to you.", thePlayer, 212, 156, 49) 
					else
						outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." is not logged in.", thePlayer, 255, 0, 0)
					end
				end
			end
		else
			outputChatBox("SYNATX: /".. commandName .." [ Player Name / ID ]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("tphere", teleportHere, false, false)

-- /send [firstplayer] to [secondplayer]
function sendPlayerTo( thePlayer, commandName, partialPlayerNameFirst, theSpecialWord, partialPlayerNameSecond )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (partialPlayerNameFirst) and theSpecialWord == "to" and (partialPlayerNameSecond) then
			
			local x, y, z, dimension, interior, rotation
			local title
			if getData(thePlayer, "hiddenadmin") == 0 then
		
				title = exports['[ars]global']:getPlayerAdminTitle(thePlayer) .. " ".. getPlayerName(thePlayer):gsub("_", " ")
			else
		
				title = "Hidden Admin"
			end
			
			local secondPlayerName
			local secondPlayer
				
			local playersSecond = exports['[ars]global']:findPlayer( thePlayer, partialPlayerNameSecond )
			
			if #playersSecond == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #playersSecond > 1 then
				outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
				
				local count = 0
				for k, foundPlayerSecond in ipairs (playersSecond) do
					
					count = count + 1
					outputChatBox("(".. getData(foundPlayerSecond, "playerid") ..") ".. getPlayerName(foundPlayerSecond):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayerSecond in ipairs (playersSecond) do
					
					secondPlayerName = getPlayerName(foundPlayerSecond)
					secondPlayer = foundPlayerSecond
					
					if getData(foundPlayerSecond, "loggedin") == 1 then
						
						if isPedInVehicle(foundPlayerSecond) then
							
							removePedFromVehicle(foundPlayerSecond)
						end
						
						x, y, z = getElementPosition(foundPlayerSecond)
						dimension = getElementDimension(foundPlayerSecond)
						interior = getElementInterior(foundPlayerSecond)
						rotation = getPedRotation(foundPlayerSecond)
								
						x = x + ( ( math.cos ( math.rad ( rotation ) ) ) * 2 )
						y = y + ( ( math.sin ( math.rad ( rotation ) ) ) * 2 )
					else
						outputChatBox(getPlayerName(foundPlayerSecond):gsub("_", " ") .." is not logged in.", thePlayer, 255, 0, 0)
					end
				end
			end	
							
			
			local playersFirst = exports['[ars]global']:findPlayer( thePlayer, partialPlayerNameFirst )
			
			if #playersFirst == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #playersFirst > 1 then
				outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
				
				local count = 0
				for k, foundPlayerFirst in ipairs (playersFirst) do
					
					count = count + 1
					outputChatBox("(".. getData(foundPlayerFirst, "playerid") ..") ".. getPlayerName(foundPlayerFirst):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayerFirst in ipairs (playersFirst) do
					
					if isPedInVehicle(foundPlayerFirst) then
						
						removePedFromVehicle(foundPlayerFirst)
					end

					setElementPosition(foundPlayerFirst, x, y, z)
					setElementDimension(foundPlayerFirst, dimension)
					setElementInterior(foundPlayerFirst, interior)
					
					outputChatBox("You teleported ".. getPlayerName(foundPlayerFirst):gsub("_", " ") .." to ".. secondPlayerName:gsub("_", " ") ..".", thePlayer, 212, 156, 49)
					outputChatBox("You were teleported to ".. secondPlayerName:gsub("_", " ") .." by ".. title ..".", foundPlayerFirst, 212, 156, 49)
					outputChatBox(getPlayerName(foundPlayerFirst):gsub("_", " ") .." has been teleported to you by ".. title ..".", secondPlayer, 212, 156, 49)
				end					
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [First Player Name / ID] to [Second Player Name / ID]", thePlayer, 212, 156, 49)
		end
	end	
end
addCommandHandler("send", sendPlayerTo, false, false)
	
local places = { 
	cityhall = { -2755.9091, 375.6718, 4.3345, 270 },
	airport =  { -1554.5283, -431.5087, 6.1332, 226 },
	bank =     { -1889.0810, 831.0556, 35.1718, 40 },
	pd =       { -1605.0566, 721.4951, 11.8799, 360},
	hospital = { -2657.0458, 574.8642, 14.6107, 180},

	ls = { 1480.924, -1724.975, 13.547, 180},
	lv = { 2111.871, 1915.542, 10.820, 270},
	fc = { -201.9082, 1119.4941, 19.7421, 90 },
	sf = { -2018.131, 156.639, 28.006, 270}
}

	
-- /tptoplace
function teleportToPlace( thePlayer, commandName, placeName )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if placeName then
			
			if places[placeName] ~= nil then
					
				setElementPosition(thePlayer, places[placeName][1], places[placeName][2], places[placeName][3])
				setPedRotation(thePlayer, places[placeName][4])
				setElementInterior(thePlayer, 0)
				setElementDimension(thePlayer, 0)
					
				outputChatBox("You teleported to ".. string.upper(tostring(placeName)) ..".", thePlayer, 212, 156, 49)
				
			else
				outputChatBox("Invalid place name.", thePlayer, 255, 0, 0)
			end	
		else
			outputChatBox("SYNTAX: /".. commandName .." [ Place Name ]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("tptoplace", teleportToPlace, false, false)	
	
-- /pmute
function mutePlayer(thePlayer, commandName, partialPlayerName )	
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (partialPlayerName) then
			
			local players = exports['[ars]global']:findPlayer( thePlayer, partialPlayerName )
			
			if #players == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #players > 1 then
				outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
				
				for k, foundPlayer in ipairs (players) do
					
					outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayer in ipairs (players) do
					
					if getData(foundPlayer, "loggedin") == 1 then
						
						if getData(foundPlayer, "muted") == 0 then
							
							setData(foundPlayer, "muted", 1, true)
							outputChatBox("You were muted by Administrator ".. getPlayerName(thePlayer):gsub("_", " ") ..".", foundPlayer, 212, 156, 49)
							outputChatBox("You muted ".. getPlayerName(foundPlayer):gsub("_", " ") ..".", thePlayer, 212, 156, 49)
							
							exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." muted ".. getPlayerName(foundPlayer):gsub("_", " ") ..".")
						elseif getData(foundPlayer, "muted") == 1 then
							
							setData(foundPlayer, "muted", 0, true)
							outputChatBox("You were un-muted by Administrator ".. getPlayerName(thePlayer):gsub("_", " ") ..".", foundPlayer, 212, 156, 49)
							outputChatBox("You un-muted ".. getPlayerName(foundPlayer):gsub("_", " ") ..".", thePlayer, 212, 156, 49)
							
							exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." un-muted ".. getPlayerName(foundPlayer):gsub("_", " ") ..".")
						end
					else
						outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." is not logged in.", thePlayer, 255, 0, 0)
					end	
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [ Player Name / ID ]", thePlayer, 212, 156, 49)	
		end
	end	
end
addCommandHandler("pmute", mutePlayer, false, false)

-- /givegun
function giveGun( thePlayer, commandName, partialPlayerName, ... )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerAdministrator(thePlayer) then
		
		if (partialPlayerName) and (...) then
			
			local args = {...}
			local players = exports['[ars]global']:findPlayer( thePlayer, partialPlayerName )
			
			if #players == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #players > 1 then
				outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
				
				for k, foundPlayer in ipairs (players) do
					
					outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayer in ipairs (players) do
					
					if getData(foundPlayer, "loggedin") == 1 then
						
						local weapon = tonumber(args[1])
						local ammo = #args ~= 1 and tonumber(args[#args]) or 1
					
						if not weapon then 
							local weaponEnd = #args
							repeat
								weapon = getWeaponIDFromName(table.concat(args, " ", 1, weaponEnd))
								weaponEnd = weaponEnd - 1
							until weapon or weaponEnd == -1
							
							if weaponEnd == -1 then
								outputChatBox("Invalid Weapon Name.", thePlayer, 255, 0, 0)
								return
							elseif weaponEnd == #args - 1 then
								ammo = 1
							end
					
						elseif not getWeaponNameFromID(weapon) then
							outputChatBox("Invalid Weapon ID.", thePlayer, 255, 0, 0)
						end
					
						takeWeapon(foundPlayer, weapon)
						local give = giveWeapon(foundPlayer, weapon, ammo, true)
					
						if not (give) then
							outputChatBox("Invalid Weapon ID.", thePlayer, 255, 0, 0)
						else
							outputChatBox("You gave ".. getPlayerName(foundPlayer):gsub("_", " ") .." a ".. getWeaponNameFromID(weapon) .. " with " .. ammo .. " Ammo.", thePlayer, 212, 156, 49)
							
							exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." gave ".. getPlayerName(foundPlayer):gsub("_", " ") .." a ".. getWeaponNameFromID(weapon) .. " with " .. ammo .. " Ammo.")
						end
					else
						outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." is not logged in.", thePlayer, 255, 0, 0)
					end
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [ Player Name / ID ] [ Weapon Name / ID ] [ Ammo ]", thePlayer, 212, 156, 49)
		end
	end
end	
addCommandHandler("givegun", giveGun, false, false)
	
-- /disarm	
function disarmPlayer( thePlayer, commandName, partialPlayerName )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (partialPlayerName) then
			local players = exports['[ars]global']:findPlayer(thePlayer, partialPlayerName)
			
			if #players == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #players > 1 then
				outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
				
				for k, foundPlayer in ipairs (players) do
					
					outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayer in ipairs (players) do
					
					if getData(foundPlayer, "loggedin") == 1 then
					
						takeAllWeapons(foundPlayer)
						outputChatBox("You disarmed ".. getPlayerName(foundPlayer):gsub("_", " ") ..".", thePlayer, 212, 156, 49)
						
						exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." disarmed ".. getPlayerName(foundPlayer):gsub("_", " ") ..".")
					else
						outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." is not logged in.", thePlayer, 255, 0, 0)
					end
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Player Name / ID]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("disarm", disarmPlayer, false, false)	

-- /sethp
function setHealth( thePlayer, commandName, partialPlayerName, health )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (partialPlayerName) and (health) then
			local players = exports['[ars]global']:findPlayer(thePlayer, partialPlayerName)
			
			if #players == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #players > 1 then
				outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
				
				for k, foundPlayer in ipairs (players) do
					
					outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayer in ipairs (players) do
					toggleControl( thePlayer, "sprint", true )
					toggleControl( thePlayer, "jump", true )
					
					local health = tonumber(health)
					if (health > 100) then
						health = 100
					elseif (health < 0) then
						health = 0
					end
					
					if getData(foundPlayer, "loggedin") == 1 then
					
						local success = setElementHealth(foundPlayer, health)
						if (success) then
							outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .."'s health was set to ".. tostring(health) ..".", thePlayer, 212, 156, 49)
							
							exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." set ".. getPlayerName(foundPlayer):gsub("_", " ") .."'s health to ".. tostring(health) ..".")
						else
							outputChatBox("Failed to set ".. getPlayerName(foundPlayer):gsub("_", " ") .."'s health to ".. tostring(health) ..".", thePlayer, 255, 0, 0)
						end
					else
						outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." is not logged in.", thePlayer, 255, 0, 0)
					end
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Player Name / ID] [Health]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("sethp", setHealth, false, false)

-- /setarmor
function setArmor( thePlayer, commandName, partialPlayerName, armor )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (partialPlayerName) and (armor) then
			local players = exports['[ars]global']:findPlayer(thePlayer, partialPlayerName)
			
			if #players == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #players > 1 then
				outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
				
				for k, foundPlayer in ipairs (players) do
					
					outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayer in ipairs (players) do
					
					local armor = tonumber(armor)
					if (armor > 100) then
						armor = 100
					elseif (armor < 0) then
						armor = 0
					end
					
					if getData(foundPlayer, "loggedin") == 1 then
					
						local success = setPedArmor(foundPlayer, armor)
						if (success) then
							outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .."'s armor was set to ".. tostring(armor) ..".", thePlayer, 212, 156, 49)
							
							exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." set ".. getPlayerName(foundPlayer):gsub("_", " ") .."'s armor to ".. tostring(armor) ..".")
						else
							outputChatBox("Failed to set ".. getPlayerName(foundPlayer):gsub("_", " ") .."'s armor to ".. tostring(armor) ..".", thePlayer, 255, 0, 0)
						end
					else
						outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." is not logged in.", thePlayer, 255, 0, 0)
					end
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Player Name / ID] [Armor]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("setarmor", setArmor, false, false)	

-- /setskin
function setSkin( thePlayer, commandName, partialPlayerName, skin )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (partialPlayerName) and (skin) then
			local players = exports['[ars]global']:findPlayer(thePlayer, partialPlayerName)
			
			if #players == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #players > 1 then
				outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
				
				for k, foundPlayer in ipairs (players) do
					
					outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayer in ipairs (players) do
					
					if getData(foundPlayer, "loggedin") == 1 then
					
						local success = setElementModel(foundPlayer, skin)
						if (success) then
							outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .."'s skin was set to ".. tostring(skin) ..".", thePlayer, 212, 156, 49)
						else
							outputChatBox("Invalid skin ID.", thePlayer, 255, 0, 0)
						end
					else
						outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." is not logged in.", thePlayer, 255, 0, 0)
					end
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Player Name / ID] [Skin ID]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("setskin", setSkin, false, false)	
	
-- /changename		
function changePlayerName( thePlayer, commandName, partialPlayerName, ... )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (partialPlayerName) and (...) then
			
			local newName = table.concat({...}, " ")
			
			local playersBySameNick = exports['[ars]global']:findPlayer(thePlayer, newName)
			
			if #playersBySameNick > 1 then
				outputChatBox("A player with the name ".. newName .." already exists.", thePlayer, 255, 0, 0)
			else
				
				local players = exports['[ars]global']:findPlayer(thePlayer, partialPlayerName)
				if #players == 0 then
					outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
				elseif #players > 1 then
					outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
				
					for k, foundPlayer in ipairs (players) do
					
						outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
					end		
				else
					for k, foundPlayer in ipairs (players) do
					
						if getData(foundPlayer, "loggedin") == 1 then
							
							local formerName = getPlayerName(foundPlayer):gsub("_", " ")
							local dbid = getData(foundPlayer, "dbid")
							
							local result = sql:query_fetch_assoc("SELECT `charactername` FROM `characters` WHERE `charactername`='" .. sql:escape_string(newName) .. "' AND id !=" .. sql:escape_string(dbid) .."")
							if ( not result ) then
								
								local name = setPlayerName(foundPlayer, tostring(newName):gsub(" ", "_"))
						
								if (name) then
									if getPlayerNametagText(foundPlayer) ~= "Unknown Person" then
										setPlayerNametagText(foundPlayer, tostring(newName))
									end
							
									local update = sql:query("UPDATE `characters` SET `charactername`='" .. sql:escape_string(newName) .. "' WHERE `id` = " .. sql:escape_string(dbid))
									if ( update ) then
									
										outputChatBox("You changed ".. formerName .."'s name to ".. newName ..".", thePlayer, 212, 156, 49)
										
										exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." changed ".. formerName .."'s name to ".. newName ..".")
									end	
									
									sql:free_result(update)
								end
							else
								outputChatBox("A player with the name ".. newName .." already exists.", thePlayer, 255, 0, 0)
							end
						else
							outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." is not logged in.", thePlayer, 255, 0, 0)
						end
					end
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Player Name / ID] [New Name]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("changename", changePlayerName, false, false)

-- /hideadmin
function hideAdmin( thePlayer, commandName )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerAdministrator(thePlayer) then
		
		local state = tonumber( getData(thePlayer, "hiddenadmin") )
		
		if ( state == 0 ) then
		
			setData( thePlayer, "hiddenadmin", 1, true)
			outputChatBox("You are now hidden.", thePlayer, 212, 156, 49)
	
		elseif ( state == 1 ) then
				
			setData( thePlayer, "hiddenadmin", 0, true)
			outputChatBox("You are no longer hidden.", thePlayer, 212, 156, 49)
		end
			
		exports['[ars]global']:updateNametagColor(thePlayer)
		
		local update = sql:query("UPDATE accounts SET hiddenadmin=" .. sql:escape_string(getData(thePlayer, "hiddenadmin")) .. " WHERE id =" .. sql:escape_string(getData(thePlayer, "accountid")) )
		sql:free_result(update)
	end
end
addCommandHandler("hideadmin", hideAdmin, false, false)

-- /adminduty
function toggleDuty( thePlayer, commandName )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		local duty = getData(thePlayer, "adminduty")
		if duty == 1 then
			
			setData(thePlayer, "adminduty", 0, true)
			outputChatBox("You are now off duty.", thePlayer, 212, 156, 49)
		elseif duty == 0 then
			
			setData(thePlayer, "adminduty", 1, true)
			outputChatBox("You are now on duty.", thePlayer, 212, 156, 49)
		end	
		
		exports['[ars]global']:updateNametagColor(thePlayer)
		
		local update = sql:query("UPDATE accounts SET adminduty=" .. sql:escape_string(getData(thePlayer, "adminduty")) .. " WHERE id = " .. sql:escape_string(getData(thePlayer, "dbid")) )
		sql:free_result(update)
	end	
end	
addCommandHandler("adminduty", toggleDuty, false, false)

-- /slap			
function slapPlayer( thePlayer, commandName, partialPlayerName )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (partialPlayerName) then
			
			local players = exports['[ars]global']:findPlayer(thePlayer, partialPlayerName)
			if #players == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #players > 1 then
				outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
			
				for k, foundPlayer in ipairs (players) do
				
					outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayer in ipairs (players) do
					
					if getData(foundPlayer, "loggedin") == 1 then
						
						local x, y, z = getElementPosition(foundPlayer)
						setElementPosition(foundPlayer, x, y, z + 10)
						
						outputChatBox("You slapped ".. getPlayerName(foundPlayer):gsub("_", " ") ..".", thePlayer, 212, 156, 49)
						
						exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." slapped ".. getPlayerName(foundPlayer):gsub("_", " ") ..".")
					else
						outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." is not logged in.", thePlayer, 255, 0, 0)
					end	
				end	
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Player Name / ID]", thePlayer, 212, 156, 49)
		end		
	end
end
addCommandHandler("slap", slapPlayer, false, false)

-- /hugeslap			
function hugeslapPlayer( thePlayer, commandName, partialPlayerName )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (partialPlayerName) then
			
			local players = exports['[ars]global']:findPlayer(thePlayer, partialPlayerName)
			if #players == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #players > 1 then
				outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
			
				for k, foundPlayer in ipairs (players) do
				
					outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayer in ipairs (players) do
					
					if getData(foundPlayer, "loggedin") == 1 then
						
						local x, y, z = getElementPosition(foundPlayer)
						setElementPosition(foundPlayer, x, y, z + 20)
						
						outputChatBox("You huge slapped ".. getPlayerName(foundPlayer):gsub("_", " ") ..".", thePlayer, 212, 156, 49)
						
						exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." huge slapped ".. getPlayerName(foundPlayer):gsub("_", " ") ..".")
					else
						outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." is not logged in.", thePlayer, 255, 0, 0)
					end	
				end	
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Player Name / ID]", thePlayer, 212, 156, 49)
		end		
	end
end
addCommandHandler("hugeslap", hugeslapPlayer, false, false)

local watching = { }
-- /watch
function watchPlayer(thePlayer, commandName, partialPlayerName)
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (partialPlayerName) then
			
			local players = exports['[ars]global']:findPlayer(thePlayer, partialPlayerName)
			
			if #players == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #players > 1 then
				outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
			
				for k, foundPlayer in ipairs (players) do
				
					outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayer in ipairs (players) do
					
					if getData(foundPlayer, "loggedin") == 1 then
						
						if not (foundPlayer == thePlayer) then 
							
							setElementAlpha(thePlayer, 255)
							setData( thePlayer, "invisible", 1, true)
							
							setData(thePlayer, "nametag", 0, true)
						
							local x, y, z = getElementPosition(thePlayer)
							local rot = getPedRotation(thePlayer)
							local dimension = getElementDimension(thePlayer)
							local interior = getElementInterior(thePlayer)
							
							setData( thePlayer, "reconx", x, true)
							setData( thePlayer, "recony", y, true)
							setData( thePlayer, "reconz", z, true)
							setData( thePlayer, "reconrot", rot, true)
							setData( thePlayer, "recondimension", dimension, true)
							setData( thePlayer, "reconinterior", interior, true)
								
							setPedWeaponSlot(thePlayer, 0)
							
							local playerdimension = getElementDimension(foundPlayer)
							local playerinterior = getElementInterior(foundPlayer)
						
							setElementDimension(thePlayer, playerdimension)
							setElementInterior(thePlayer, playerinterior)
							setCameraInterior(thePlayer, playerinterior)
						
							local x, y, z = getElementPosition(foundPlayer)
							setElementPosition(thePlayer, x - 10, y - 10, z - 5)
							local success = attachElements(thePlayer, foundPlayer, -10, -10, -5)
							if not (success) then
								
								success = attachElements(thePlayer, foundPlayer, -5, -5, -5)
								if not (success) then
									
									success = attachElements(thePlayer, foundPlayer, 5, 5, -5)
								end
							end
						
							if not (success) then
								outputChatBox("Failed to watch ".. getPlayerName(foundPlayer):gsub("_", " ") ..".", thePlayer, 255, 0, 0)
							else
								setCameraTarget(thePlayer, foundPlayer)
								
								watching[thePlayer] = foundPlayer
								outputChatBox("You are now watching " .. getPlayerName(foundPlayer):gsub("_", " ") .. ".", thePlayer, 212, 156, 49)
							end	
						else
							outputChatBox("You cannot watch yourself.", thePlayer, 255, 0, 0)	
						end
					else
						outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." is not logged in.", thePlayer, 255, 0, 0)	
					end	
				end
			end
		else	
	
			local rx = getData(thePlayer, "reconx")
			local ry = getData(thePlayer, "recony")
			local rz = getData(thePlayer, "reconz")
			local reconrot = getData(thePlayer, "reconrot")
			local recondimension = getData(thePlayer, "recondimension")
			local reconinterior = getData(thePlayer, "reconinterior")
			
			if (rx) and (ry) and (rz) and (reconrot) and (recondimension) and (reconinterior) then
				
				detachElements(thePlayer)
				
				setElementPosition(thePlayer, rx, ry, rz)
				setPedRotation(thePlayer, reconrot)
				setElementDimension(thePlayer, recondimension)
				setElementInterior(thePlayer, reconinterior)
				setCameraInterior(thePlayer, reconinterior)
				
				setCameraTarget(thePlayer, thePlayer)
				
				setElementAlpha(thePlayer, 255)
				setData( thePlayer, "invisible", 0, true)
				
				setData(thePlayer, "nametag", 1, true)
				
				outputChatBox("You are no longer watching a player. ( Turned off )", thePlayer, 212, 156, 49)
				watching[thePlayer] = nil
			else
				outputChatBox("SYNTAX: /" .. commandName .. " [Player Name / ID]", thePlayer, 212, 156, 49)
			end
		end
	end
end
addCommandHandler("watch", watchPlayer, false, false)	

function removeWatch( )
	for k, v in pairs (watching) do
		if v == source then
			
			local thePlayer = k
			
			local rx = getData(thePlayer, "reconx")
			local ry = getData(thePlayer, "recony")
			local rz = getData(thePlayer, "reconz")
			local reconrot = getData(thePlayer, "reconrot")
			local recondimension = getData(thePlayer, "recondimension")
			local reconinterior = getData(thePlayer, "reconinterior")
		
			if (rx) and (ry) and (rz) and (reconrot) and (recondimension) and (reconinterior) then
			
				detachElements(thePlayer)
				
				setElementPosition(thePlayer, rx, ry, rz)
				setPedRotation(thePlayer, reconrot)
				setElementDimension(thePlayer, recondimension)
				setElementInterior(thePlayer, reconinterior)
				setCameraInterior(thePlayer, reconinterior)
				
				setCameraTarget(thePlayer, thePlayer)
				
				setElementAlpha(thePlayer, 255)
				setData( thePlayer, "invisible", 0, true)
				
				setData(thePlayer, "nametag", 1, true)
				
				outputChatBox("You are no longer watching a player. ( Player Quit )", thePlayer, 212, 156, 49)
				
				v = nil
			end
		end	
	end	
end
addEventHandler("onPlayerQuit", getRootElement(), removeWatch)

-- /pkick
function playerKick( thePlayer, commandName, partialPlayerName, ... )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (partialPlayerName) then
			
			local players = exports['[ars]global']:findPlayer(thePlayer, partialPlayerName)
			
			if #players == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #players > 1 then
				outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
			
				for k, foundPlayer in ipairs (players) do
				
					outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayer in ipairs (players) do
					
					local reason
					if (...)then
						
						reason = table.concat({...}, " ")
					else
						
						reason = ""
					end	
						
					local thePlayerPower = exports['[ars]global']:getPlayerAdminLevel(thePlayer)
					local targetPlayerPower = exports['[ars]global']:getPlayerAdminLevel(foundPlayer)
					
					if (targetPlayerPower <= thePlayerPower) then
							
						local insert = sql:query("INSERT INTO adminhistory SET player='" .. sql:escape_string(tostring(getPlayerName(foundPlayer))) .."', admin='".. sql:escape_string(tostring(getPlayerName(thePlayer))) .."', hidden=".. sql:escape_string(tostring(getData(thePlayer, "hiddenadmin"))) ..", action='1', duration='0', reason='".. sql:escape_string(reason) .."', date=NOW()")
						if insert then
						
							local title
							if getData(thePlayer, "hiddenadmin") == 0 then
									
								title = exports['[ars]global']:getPlayerAdminTitle(thePlayer) .. " ".. getPlayerName(thePlayer):gsub("_", " ")
							else
									
								title = "Hidden Admin"
							end
						
							outputChatBox("Kick: "..  title .." kicked ".. getPlayerName(foundPlayer):gsub("_", " ") ..".", getRootElement(), 200, 0, 0)
							exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] ".. exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." kicked ".. getPlayerName(foundPlayer):gsub("_", " ") ..". ( ".. reason .." )")
							
							if reason ~= "" then
								outputChatBox("Reason: ".. reason, getRootElement(), 200, 0, 0)
							end
							
							kickPlayer(foundPlayer, getRootElement(), reason)
						else
							outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
						end	
						
						sql:free_result(insert)
					else
						
						outputChatBox("You are not authorized to do so.", thePlayer, 255, 0, 0)
						outputChatBox(getPlayerName(thePlayer) .." attempted to kick you.", foundPlayer, 255, 0 ,0)
					end
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Player Name / ID] [Reason]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("pkick", playerKick, false, false)
	
function remoteKick( reason )
	if ( source ) then
	
		kickPlayer( source, tostring( reason ) )
	end
end
addEvent("remoteKick", true)
addEventHandler("remoteKick", root, remoteKick)
	
-- /pban
function playerBan( thePlayer, commandName, partialPlayerName, hours, ... )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (partialPlayerName) and (hours) then
			
			local players = exports['[ars]global']:findPlayer(thePlayer, partialPlayerName)
			
			if #players == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #players > 1 then
				outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
			
				for k, foundPlayer in ipairs (players) do
				
					outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayer in ipairs (players) do
					
						
					local thePlayerPower = exports['[ars]global']:getPlayerAdminLevel(thePlayer)
					local targetPlayerPower = exports['[ars]global']:getPlayerAdminLevel(foundPlayer)
					
					if (targetPlayerPower <= thePlayerPower) then
						
						local seconds = ((hours*60)*60)
						local rhours = tonumber(hours)
						
						if (rhours<1) then
							
							hours = "Permanent"
						elseif (rhours==1) then
							
							hours = "1 Hour"
						else
							hours = hours .. " Hours"
						end
						
						local reason
						if (...)then
							
							reason = table.concat({...}, " ")
						else
							
							reason = ""
						end	
						
						local insert = sql:query("INSERT INTO adminhistory SET player='" .. sql:escape_string(getPlayerName(foundPlayer)) .. "', admin='".. sql:escape_string(getPlayerName(thePlayer)) .. "', hidden=".. sql:escape_string(tostring(getData(thePlayer, "hiddenadmin"))) ..", action='2', duration=".. sql:escape_string(rhours) ..", reason='".. sql:escape_string(reason) .."', date=NOW()")
						if insert then
							local title
							if getData(thePlayer, "hiddenadmin") == 0 then
									
								title = exports['[ars]global']:getPlayerAdminTitle(thePlayer) .. " ".. getPlayerName(thePlayer):gsub("_", " ")
							else
									
								title = "Hidden Admin"
							end
							
							outputChatBox("Ban: "..  title .." banned ".. getPlayerName(foundPlayer):gsub("_", " ") ..". ( ".. tostring(hours) .." )", getRootElement(), 200, 0, 0)
							
							if reason ~= "" then
								outputChatBox("Reason: ".. reason, getRootElement(), 200, 0, 0)
							end
							
							exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." banned ".. getPlayerName(foundPlayer):gsub("_", " ") ..". ( ".. hours ..")")
							
							local update = sql:query("UPDATE accounts SET banned='1', banned_reason='" .. sql:escape_string(reason) .. "', banned_by='" .. sql:escape_string(getPlayerName(thePlayer)) .. "' WHERE id='" .. sql:escape_string(tonumber(getData(foundPlayer, "accountid"))) .. "'")
							if update then
								banPlayer(foundPlayer, true, false, false, getRootElement(), reason, seconds)
							else
								outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
							end	
							
						else
							outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
						end	
						
						sql:free_result(insert)
					else
						
						outputChatBox("You are not authorized to do so.", thePlayer, 255, 0, 0)
						outputChatBox(getPlayerName(thePlayer) .." attempted to ban you.", foundPlayer, 255, 0 ,0)
					end
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Player Name / ID] [Hours] [Reason]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("pban", playerBan, false, false)
	
-- /unban	
function playerUnban( thePlayer, commandName, ...)
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerAdministrator(thePlayer) then
		
		if (...) then
			
			local name = table.concat({...}, "_")
			local bans = getBans( )
			
			local row = sql:query_fetch_assoc("SELECT ip, banned FROM accounts WHERE username='".. sql:escape_string(name) .."'")
			if (row) then
					
				local banned = row['banned']
				if (tonumber(banned) ~= 0) then
							
					local ip = row['ip']
					local found = false
					for k, v in ipairs(bans) do
						if (ip == getBanIP(v)) then
							
							removeBan(v, thePlayer)
							
							local update = sql:query("UPDATE accounts SET banned='0', banned_by=NULL, banned_reason=NULL WHERE ip='" .. sql:escape_string(tostring(ip)) .. "'")
							sql:free_result(update)
							
							found = true
						end
					end
							
					if (found) then
						outputChatBox("You unbanned ".. name ..".", thePlayer, 212, 156, 49)
						
						exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." unbanned ".. name ..".")
					else
						outputChatBox("Couldn't find '".. name:gsub("_", " ") .."' in banlist.", thePlayer, 255, 0, 0)
					end
				else
					outputChatBox("Player '".. name:gsub("_", " ") .."' is not banned.", thePlayer, 255, 0, 0)
				end	
			else
				outputChatBox("No one with the username '".. name:gsub("_", " ") .."' is banned.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Full Username]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("unban", playerUnban, false, false) 

-- /makeadmin		
function makePlayerAdmin( thePlayer, commandName, partialPlayerName, rrank )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerHighAdministrator(thePlayer) then
		
		if (partialPlayerName) and (rrank) then
			
			local players = exports['[ars]global']:findPlayer(thePlayer, partialPlayerName)
			
			if #players == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #players > 1 then
				outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
			
				for k, foundPlayer in ipairs (players) do
				
					outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayer in ipairs (players) do
					
					if getData(foundPlayer, "loggedin") == 1 then
						
						local rrank = tonumber(rrank)
						if (rrank) then
						
							local rank
							if rrank == 0 then
								rank = "Player"
							elseif rrank == 1 then
								rank = "Trial Moderator"
							elseif rrank == 2 then
								rank = "Moderator"
							elseif rrank == 3 then
								rank = "High Moderator"
							elseif rrank == 4 then
								rank = "Administrator"
							elseif rrank == 5 then
								rank = "High Administrator"
							elseif rrank == 6 then
								rank = "Sub Owner"
							elseif rrank == 7 then
								rank = "Server Owner"
							elseif (rrank > 7) or (rrank < 0) then
								rank = "Invalid rank"
							end
								
							if (rrank == 0 or rrank == 1 or rrank == 2 or rrank == 3 or rrank == 4 or rrank == 5 or rrank == 6 or rrank == 7) then
								
								local update = sql:query("UPDATE `accounts` SET `admin`=".. sql:escape_string(tonumber(rrank)) .." WHERE id=".. sql:escape_string(tonumber(getData(foundPlayer, "accountid"))) .."")
								if (update) then
									
									setData( foundPlayer, "admin", tonumber(rrank), true)
									setData( foundPlayer, "adminduty", 1, true)
									
									exports['[ars]global']:updateNametagColor( foundPlayer )
									
									outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .."'s administrative rank was set to ".. rank ..".", thePlayer, 212, 156, 49)
									
									exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." set ".. getPlayerName(foundPlayer):gsub("_", " ") .."'s administrative rank to ".. rank ..".")
								else
									outputDebugString("Unable to update admin rank!")
								end	
								
								sql:free_result(update)
							else
								outputChatBox("Invalid rank ID.", thePlayer, 255, 200, 0)
								outputChatBox("#0 Player", thePlayer, 212, 156, 49)
								outputChatBox("#1 Trial Moderator", thePlayer, 212, 156, 49)
								outputChatBox("#2 Moderator", thePlayer, 212, 156, 49)
								outputChatBox("#3 High Moderator", thePlayer, 212, 156, 49)
								outputChatBox("#4 Administrator", thePlayer, 212, 156, 49)
								outputChatBox("#5 High Administrator", thePlayer, 212, 156, 49)
								outputChatBox("#6 Sub Owner", thePlayer, 212, 156, 49)
								outputChatBox("#7 Server Owner", thePlayer, 212, 156, 49)
							end
						else
							outputChatBox("Invalid rank ID.", thePlayer, 255, 200, 0)
							outputChatBox("#0 Player", thePlayer, 212, 156, 49)
							outputChatBox("#1 Trial Moderator", thePlayer, 212, 156, 49)
							outputChatBox("#2 Moderator", thePlayer, 212, 156, 49)
							outputChatBox("#3 High Moderator", thePlayer, 212, 156, 49)
							outputChatBox("#4 Administrator", thePlayer, 212, 156, 49)
							outputChatBox("#5 High Administrator", thePlayer, 212, 156, 49)
							outputChatBox("#6 Sub Owner", thePlayer, 212, 156, 49)
							outputChatBox("#7 Server Owner", thePlayer, 212, 156, 49)
						end		
					else
						outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." is not logged in.", thePlayer, 255, 0, 0)
					end
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Player Name / ID] [Rank ID]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("makeadmin", makePlayerAdmin, false, false)

-- /jail
local jails = { }
function jailPlayer( thePlayer, commandName, partialPlayerName, minutes, ... )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (partialPlayerName) and (minutes) and (...) then
			
			
			local players = exports['[ars]global']:findPlayer(thePlayer, partialPlayerName)
				
			if #players == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #players > 1 then
				outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
			
				for k, foundPlayer in ipairs (players) do
				
					outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayer in ipairs (players) do
				
					local reason = table.concat({...}, " ")
					
					-- tables can remember him
					jails[foundPlayer] = { }
					jails[foundPlayer]["timer"] = setTimer(unjailPlayer, 60000, 1, foundPlayer)
					jails[foundPlayer]["jailtime"] = tonumber(minutes)
					jails[foundPlayer]["jail_by"] = tostring(getPlayerName(thePlayer):gsub("_", " "))
					jails[foundPlayer]["jail_reason"] = tostring(reason)
				
					setElementInterior(foundPlayer, 3)
					setElementDimension(foundPlayer, 65000 + getData(foundPlayer, "playerid"))
					setElementPosition(foundPlayer, 193.5804, 175.1421, 1003.0234)
				
					local title = ""
					if getData(thePlayer, "hiddenadmin") == 0 then
						title = exports['[ars]global']:getPlayerAdminTitle(thePlayer) .. " ".. getPlayerName(thePlayer):gsub("_", " ")
					else
						title = "Hidden Admin"
					end
			
					outputChatBox("Jail: "..  title .." jailed ".. getPlayerName(foundPlayer):gsub("_", " ") .." for ".. tostring(minutes) .." minute(s).", getRootElement(), 200, 0, 0)
					outputChatBox("Reason: ".. reason, getRootElement(), 200, 0, 0)
					
					exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." jailed ".. getPlayerName(foundPlayer):gsub("_", " ") .." for ".. tostring(minutes) .." minute(s). ( ".. reason .. " )")
					
					local update = sql:query("UPDATE accounts SET jail_time=".. sql:escape_string(minutes) ..", jail_reason='".. sql:escape_string(tostring(reason)) .."', jail_by='".. sql:escape_string(tostring(getPlayerName(thePlayer))) .."' WHERE id=" .. sql:escape_string(getData(foundPlayer, "accountid")) .."")
					local insert = sql:query("INSERT INTO adminhistory SET player='" .. sql:escape_string(getPlayerName(foundPlayer)) .. "', admin='".. sql:escape_string(getPlayerName(thePlayer)) .. "', hidden=".. sql:escape_string(tostring(getData(thePlayer, "hiddenadmin"))) ..", action='0', duration=".. sql:escape_string(minutes) ..", reason='".. sql:escape_string(reason) .."', date=NOW()")
					
					sql:free_result(update)
					sql:free_result(insert)
				end
			end	
		else
			outputChatBox("SYNTAX: /".. commandName .." [ Player Name / ID ] [ Time ( minutes ) ] [ Reason ]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("jail", jailPlayer, false, false)	

-- /unjail
function forceUnjail( thePlayer, commandName, partialPlayerName)
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (partialPlayerName) then
			
			local players = exports['[ars]global']:findPlayer(thePlayer, partialPlayerName)
			
			if #players == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #players > 1 then
				outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
			
				for k, foundPlayer in ipairs (players) do
				
					outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayer in ipairs (players) do
				
					if ( jails[foundPlayer] ~= nil ) then
						
						local jailTimer = jails[foundPlayer]["timer"]
						if isTimer(jailTimer) then
							killTimer(jailTimer)
						end
						
						jails[foundPlayer] = nil
						
						local update = sql:query("UPDATE accounts SET jail_time='0', jail_reason=NULL, jail_by=NULL WHERE id=" .. sql:escape_string(getData(foundPlayer, "accountid")) .."")	
						sql:free_result(update)
						
						setElementDimension(foundPlayer, 0)
						setElementInterior(foundPlayer, 0)
						setElementPosition(foundPlayer, -201.9082, 1119.4941, 19.7421)
					
						if getData(thePlayer, "hiddenadmin") == 1 then
							outputChatBox("You were unjailed by an administrator.", foundPlayer, 0, 255, 0)
						else
							outputChatBox("You were unjailed by ".. getPlayerName(thePlayer):gsub("_", " ") ..".", foundPlayer, 0, 255, 0)
						end	
						
						outputChatBox("You unjailed ".. getPlayerName(foundPlayer):gsub("_", " ") ..".", thePlayer, 212, 156, 49)
						
						exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." unjailed ".. getPlayerName(foundPlayer):gsub("_", " ") ..".")
					else
						
						outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." is not jailed.", thePlayer, 212, 156, 49)
					end	
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [ Player Name / ID ]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("unjail", forceUnjail, false, false)
	
function unjailPlayer( thePlayer )
	if isElement( thePlayer ) then
		
		if jails[thePlayer] then -- He is jailed
			
			local timeLeft = jails[thePlayer]["jailtime"]
			if tonumber(timeLeft) == 1 then
				
				jails[thePlayer] = nil
				setElementDimension(thePlayer, 0)
				setElementInterior(thePlayer, 0)
				setElementPosition(thePlayer, -201.9082, 1119.4941, 19.7421)
				
				outputChatBox("You have served your admin jail sentence.", thePlayer, 0, 255, 0)
				
				local update = sql:query("UPDATE accounts SET jail_time='0', jail_reason=NULL, jail_by=NULL WHERE id=" .. sql:escape_string(getData(thePlayer, "accountid")) .."")	
				sql:free_result(update)
			else
				
				if ( timeLeft ~= nil ) then
					jails[thePlayer]["jailtime"] = timeLeft - 1
					jails[thePlayer]["timer"] = setTimer(unjailPlayer, 60000, 1, thePlayer)
					
					local update = sql:query("UPDATE accounts SET jail_time=".. sql:escape_string(timeLeft-1) .." WHERE id=" .. sql:escape_string(getData(thePlayer, "accountid")) .."")
					sql:free_result(update)
				end
			end
		else
			
			jails[thePlayer] = nil
			setElementDimension(thePlayer, 0)
			setElementInterior(thePlayer, 0)
			setElementPosition(thePlayer, -201.9082, 1119.4941, 19.7421)
				
			outputChatBox("You have served your admin jail sentence.", thePlayer, 0, 255, 0)
			
			local update = sql:query("UPDATE accounts SET jail_time='0', jail_reason=NULL, jail_by=NULL WHERE id=" .. sql:escape_string(getData(thePlayer, "accountid")) .."")	
			sql:free_result(update)
		end
	end	
end	

addEventHandler("onPlayerQuit", root,
	function( )
		
		if ( jails[source] ~= nil ) then
			
			local timer = jails[source]["arrestTimer"]
			if ( isTimer( timer ) ) then
				killTimer( timer )
			end 
			
			jails[source] = nil
		end	
	end
)

function jailedPlayers( thePlayer, commandName )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		local count = 0
		outputChatBox("========= Jailed Players =========", thePlayer, 212, 156, 49)
		for k, v in pairs ( jails ) do
			
			if ( isElement( k ) ) then
				local time = jails[k]["jailtime"]
				local by = jails[k]["jail_by"]
				local reason = jails[k]["jail_reason"]
				
				outputChatBox("~-~-~-~-~-~-~-~ ".. getPlayerName(k):gsub("_", " ") .." ~-~-~-~-~-~-~-~", thePlayer, 212, 156, 49)
				outputChatBox("Time left: ".. tostring(time) .." minute(s)", thePlayer, 212, 156, 49)
				outputChatBox("Jailed by: ".. by, thePlayer, 212, 156, 49)
				outputChatBox("Reason: ".. reason, thePlayer, 212, 156, 49)
				count = count + 1
			else
				jails[k] = nil
			end	
		end
		
		if ( count == 0 ) then
			outputChatBox("	No one is jailed.", thePlayer, 212, 156, 49)
		end	
	end	
end
addCommandHandler("jailed", jailedPlayers, false, false)

function getJailTime( thePlayer, commandName )
	if jails[thePlayer] then
		
		local time = jails[thePlayer]["jailtime"]
		outputChatBox("You have ".. time .." minute(s) left on your admin jail sentence.", thePlayer, 212, 156, 49)
	end
end
addCommandHandler("jailtime", getJailTime, false, false)	

function remoteJail( jailtime, jailby, jailreason )
	
	local jailtime = tonumber( jailtime )
	local jailby = tostring( jailby )
	local jailreason = tostring( jailreason )
	
	jails[source] = { }
	jails[source]["timer"] = setTimer(unjailPlayer, 60000, 1, source)
	jails[source]["jailtime"] = jailtime
	jails[source]["jail_by"] = jailby
	jails[source]["jail_reason"] = jailreason
						
	setElementInterior(source, 3)
	setElementDimension(source, 65000 + getData(source, "playerid"))
	setElementPosition(source, 193.5804, 175.1421, 1003.0234)
	
	outputChatBox("You were jailed by ".. jailby .." for ".. jailtime .." minute(s).", source, 200, 0, 0)
	outputChatBox("Reason: ".. jailreason, source, 200, 0, 0)
end
addEvent("remoteJail", true)
addEventHandler("remoteJail", getRootElement(), remoteJail)

-- /setmoney
function setMoney( thePlayer, commandName, partialPlayerName, money )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerAdministrator(thePlayer) then
		
		if (partialPlayerName) and (money) then
			
			local players = exports['[ars]global']:findPlayer(thePlayer, partialPlayerName)
			
			if #players == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #players > 1 then
				outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
			
				for k, foundPlayer in ipairs (players) do
				
					outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayer in ipairs (players) do
					
					if getData(foundPlayer, "loggedin") == 1 then
						
						if (tonumber(money) > 99999999 or tonumber(money) < 0) then
							
							outputChatBox("Invalid amount entered.", thePlayer, 255, 0, 0)
						else	
							
							setPlayerMoney(foundPlayer, tonumber(money)*100)
							outputChatBox("You set ".. getPlayerName(foundPlayer):gsub("_", " ") .."'s money to $".. tostring(money) ..".", thePlayer, 212, 156, 49)
							
							exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." set ".. getPlayerName(foundPlayer):gsub("_", " ") .."'s money to $".. tostring(money) ..".")
						end	
					else
						outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." is not logged in.", thePlayer, 255, 0, 0)	
					end
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Player Name / ID] [Money]", thePlayer, 212, 156, 49)
		end
	end	
end
addCommandHandler("setmoney", setMoney, false, false)

-- /givemoney
function giveMoney( thePlayer, commandName, partialPlayerName, money )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerAdministrator(thePlayer) then
		
		if (partialPlayerName) and (money) then
			
			local players = exports['[ars]global']:findPlayer(thePlayer, partialPlayerName)
			
			if #players == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #players > 1 then
				outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
			
				for k, foundPlayer in ipairs (players) do
				
					outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayer in ipairs (players) do
					
					if getData(foundPlayer, "loggedin") == 1 then
						
						if (tonumber(money) > 99999999 or tonumber(money) < 0) then
							
							outputChatBox("Invalid amount entered.", thePlayer, 255, 0, 0)
						else	
							
							givePlayerMoney(foundPlayer, tonumber(money)*100)
							outputChatBox("You gave $".. tostring(money) .." to ".. getPlayerName(foundPlayer):gsub("_", " ") ..".", thePlayer, 212, 156, 49)
							
							exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." gave ".. getPlayerName(foundPlayer):gsub("_", " ") .." $".. tostring(money) ..".")
						end	
					else
						outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." is not logged in.", thePlayer, 255, 0, 0)	
					end
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Player Name / ID] [Money]", thePlayer, 212, 156, 49)
		end
	end	
end
addCommandHandler("givemoney", giveMoney, false, false)

-- /freeze
function playerFreeze( thePlayer, commandName, partialPlayerName )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (partialPlayerName) then
			
			local players = exports['[ars]global']:findPlayer(thePlayer, partialPlayerName)
			
			if #players == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #players > 1 then
				outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
			
				for k, foundPlayer in ipairs (players) do
				
					outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayer in ipairs (players) do
					
					if getData(foundPlayer, "loggedin") == 1 then 
						
						local vehicle = getPedOccupiedVehicle(foundPlayer)
						if vehicle then
							
							setElementFrozen(vehicle, true)
							toggleAllControls(foundPlayer, false, true, false)
						else
							
							toggleAllControls(foundPlayer, false, true, false)
							setPedWeaponSlot(foundPlayer, 0)
						end
							
						local title
						if getData(thePlayer, "hiddenadmin") == 0 then
						
							title = exports['[ars]global']:getPlayerAdminTitle(thePlayer) .. " ".. getPlayerName(thePlayer):gsub("_", " ")
						else
						
							title = "Hidden Admin"
						end	
						
						outputChatBox("You were frozen by ".. title ..".", foundPlayer, 212, 156, 49)
						outputChatBox("You froze ".. getPlayerName(foundPlayer):gsub("_", " ") ..".", thePlayer, 212, 156, 49)
					else
						outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." is not logged in.", thePlayer, 255, 0, 0)	
					end
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Player Name / ID]", thePlayer, 212, 156, 49)
		end
	end									
end
addCommandHandler("freeze", playerFreeze, false, false)

-- /unfreeze
function unplayerFreeze( thePlayer, commandName, partialPlayerName )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (partialPlayerName) then
			
			local players = exports['[ars]global']:findPlayer(thePlayer, partialPlayerName)
			
			if #players == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #players > 1 then
				outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
			
				for k, foundPlayer in ipairs (players) do
				
					outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayer in ipairs (players) do
					
					if getData(foundPlayer, "loggedin") == 1 then 
						
						local vehicle = getPedOccupiedVehicle(foundPlayer)
						if vehicle then
							
							setElementFrozen(vehicle, false)
							toggleAllControls(foundPlayer, true, true, true)
						else
							
							toggleAllControls(foundPlayer, true, true, true)
						end
							
						local title
						if getData(thePlayer, "hiddenadmin") == 0 then
											
							title = exports['[ars]global']:getPlayerAdminTitle(thePlayer) .. " ".. getPlayerName(thePlayer):gsub("_", " ")
						else
											
							title = "Hidden Admin"
						end	
						
						outputChatBox("You were unfrozen by ".. title ..".", foundPlayer, 212, 156, 49)
						outputChatBox("You unfroze ".. getPlayerName(foundPlayer):gsub("_", " ") ..".", thePlayer, 212, 156, 49)
					else
						outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." is not logged in.", thePlayer, 255, 0, 0)	
					end
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Player Name / ID]", thePlayer, 212, 156, 49)
		end
	end									
end
addCommandHandler("unfreeze", unplayerFreeze, false, false)

-- /makedon(ator)
function makePlayerDonator( thePlayer, commandName, partialPlayerName, llevel )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerAdministrator(thePlayer) then
		
		if (partialPlayerName) and (llevel) then
			
			local players = exports['[ars]global']:findPlayer(thePlayer, partialPlayerName)
			
			if #players == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #players > 1 then
				outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
			
				for k, foundPlayer in ipairs (players) do
				
					outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayer in ipairs (players) do
					
					if getData(foundPlayer, "loggedin") == 1 then
						
						local llevel = tonumber(llevel)
						if (llevel) then
						
							local level
							if llevel == 0 then
								level = "Non-donator"
							elseif llevel == 1 then
								level = "Level One Donator"
							elseif llevel == 2 then
								level = "Level Two Donator"
							elseif llevel == 3 then
								level = "Level Three Donator"
							end
								
							if (llevel >= 0 and llevel <= 3) then
								
								local update = sql:query("UPDATE `accounts` SET `donator`=".. sql:escape_string(llevel) .." WHERE `id`=".. sql:escape_string( tonumber( getData(foundPlayer, "accountid") ) ) .."")
								if ( update ) then
									
									setData( foundPlayer, "donator", tonumber(llevel), true)
									exports['[ars]global']:updateNametagColor( foundPlayer )
									
									outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .."'s donator level was set to ".. level ..".", thePlayer, 212, 156, 49)
									exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." set ".. getPlayerName(foundPlayer):gsub("_", " ") .."'s donator level to ".. level ..".")
								end
								
								sql:free_result(update)
							else
								outputChatBox("~-~-~-~-~-~ Invalid level ID. ~-~-~-~-~-~", thePlayer, 255, 156, 49)
								outputChatBox("#0 Non-donator", thePlayer, 212, 156, 49)
								outputChatBox("#1 Level One Donator", thePlayer, 212, 156, 49)
								outputChatBox("#2 Level Two Donator", thePlayer, 212, 156, 49)
								outputChatBox("#3 Level Three Donator", thePlayer, 212, 156, 49)
							end
						else
							outputChatBox("~-~-~-~-~-~ Invalid level ID. ~-~-~-~-~-~", thePlayer, 255, 156, 49)
							outputChatBox("#0 Non-donator", thePlayer, 212, 156, 49)
							outputChatBox("#1 Level One Donator", thePlayer, 212, 156, 49)
							outputChatBox("#2 Level Two Donator", thePlayer, 212, 156, 49)
							outputChatBox("#3 Level Three Donator", thePlayer, 212, 156, 49)
						end		
					else
						outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." is not logged in.", thePlayer, 255, 0, 0)
					end
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Player Name / ID] [Level ID]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("makedon", makePlayerDonator, false, false)
addCommandHandler("makedonator", makePlayerDonator, false, false)	

-- /setmotd
function setMOTD( thePlayer, commandName, ... )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerAdministrator(thePlayer) then
		
		if (...) then
			
			local newMOTD = table.concat({...}, " ")
			
			local update = sql:query("UPDATE settings SET motd='".. sql:escape_string(tostring(newMOTD)) .."'")
			sql:free_result(update)
			
			outputChatBox("MOTD changed to: ".. newMOTD, thePlayer, 0, 255, 0)
			
			exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." changed MOTD to '".. newMOTD .."'.")
		else
			outputChatBox("SYNTAX: /".. commandName .." [ New MOTD ]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("setmotd", setMOTD)

-- /setamotd
function setAMOTD( thePlayer, commandName, ... )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerHighAdministrator(thePlayer) then
		
		if (...) then
			
			local newMOTD = table.concat({...}, " ")
			
			local update = sql:query("UPDATE settings SET amotd='".. sql:escape_string(tostring(newMOTD)) .."'")
			sql:free_result(update)
			
			outputChatBox("AMOTD changed to: ".. newMOTD, thePlayer, 0, 255, 0)
			
			exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." changed AMOTD to '".. newMOTD .."'.")
		else
			outputChatBox("SYNTAX: /".. commandName .." [ New AMOTD ]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("setamotd", setAMOTD)
	
-- /warn
function warnPlayer( thePlayer, commandName, partialPlayerName, ... )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (partialPlayerName) and (...) then
			
			local players = exports['[ars]global']:findPlayer(thePlayer, partialPlayerName)
			
			if #players == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #players > 1 then
				outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
			
				for k, foundPlayer in ipairs (players) do
				
					outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayer in ipairs (players) do
					
					local reason = table.concat({...}, " ")
					local title
					if getData(thePlayer, "hiddenadmin") == 0 then
						title = exports['[ars]global']:getPlayerAdminTitle(thePlayer) .. " ".. getPlayerName(thePlayer):gsub("_", " ")
					else
						title = "Hidden Admin"
					end	
					
					local result = sql:query("SELECT warns FROM accounts WHERE id='".. sql:escape_string(tostring(getData(foundPlayer, "dbid"))) .."'")
					local row = sql:fetch_assoc(result)
					if (row) then
						local currentWarns = row['warns']
						
						local warnUpdate = currentWarns + 1
						if (warnUpdate >= 3) then
							
							local sql_reason = "AdmWrns"
							
							sql:query("INSERT INTO adminhistory SET player='" .. sql:escape_string(getPlayerName(foundPlayer)) .. "', admin='".. sql:escape_string(getPlayerName(thePlayer)) .. "', hidden=".. sql:escape_string(tostring(getData(thePlayer, "hiddenadmin"))) ..", action='5', duration='0', reason='".. sql:escape_string(reason) .."', date=NOW()")
							sql:query("UPDATE accounts SET warns='3', banned='1', banned_reason='" .. sql:escape_string(sql_reason) .. "', banned_by='" .. sql:escape_string(getPlayerName(thePlayer)) .. "' WHERE id='" .. sql:escape_string(tostring(getData(foundPlayer, "dbid"))) .. "'")
							
							outputChatBox("Warn: ".. getPlayerName(foundPlayer):gsub("_", " ") .." was warned by ".. title ..". ( ".. reason .." ) (".. warnUpdate .."/3)", getRootElement(), 200, 0, 0)
							outputChatBox("Ban: ".. getPlayerName(foundPlayer):gsub("_", " ") .." was auto banned. ( ".. warnUpdate .."/3 Admin Warnings )", getRootElement(), 200, 0, 0)
							local ban = banPlayer(foundPlayer, true, false, false, getRootElement(), reason, 0)
						else
						
							sql:query("INSERT INTO adminhistory SET player='" .. sql:escape_string(getPlayerName(foundPlayer)) .. "', admin='".. sql:escape_string(getPlayerName(thePlayer)) .. "', hidden=".. sql:escape_string(tostring(getData(thePlayer, "hiddenadmin"))) ..", action='5', duration='0', reason='".. sql:escape_string(reason) .."', date=NOW()")
							sql:query("UPDATE accounts SET warns='".. sql:escape_string(warnUpdate) .."' WHERE id='".. sql:escape_string(tostring(getData(foundPlayer, "dbid"))) .. "'")
							outputChatBox("Warn: ".. getPlayerName(foundPlayer):gsub("_", " ") .." was warned by ".. title ..". ( ".. reason .." ) (".. warnUpdate .."/3)", getRootElement(), 200, 0, 0)
							
							exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." warned ".. getPlayerName(thePlayer):gsub("_", " ") ..". ( ".. reason .." ) (".. warnUpdate .."/3)")
						end	
					else
						outputChatBox("MySQL Error.", thePlayer, 255, 0, 0)
					end
					
					sql:free_result(result)
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Player Name / ID] [Reason]", thePlayer, 212, 156, 49)
		end
	end	
end
addCommandHandler("warn", warnPlayer, false, false)	

-- /unwarn
function unWarnPlayer( thePlayer, commandName, partialPlayerName )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerAdministrator(thePlayer) then
		
		if (partialPlayerName) then
			
			local players = exports['[ars]global']:findPlayer(thePlayer, partialPlayerName)
			
			if #players == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #players > 1 then
				outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
			
				for k, foundPlayer in ipairs (players) do
					
					
					outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayer in ipairs (players) do
			
					local result = sql:query("SELECT warns FROM accounts WHERE id='".. sql:escape_string(tostring(getData(foundPlayer, "dbid"))) .."'")
					local row = sql:fetch_assoc(result)
					if (row) then
						
						local currentWarns = row['warns']
						if (tonumber(currentWarns) ~= 0) then
							
							local warnUpdate = currentWarns - 1
							
							local update = sql:query("UPDATE accounts SET warns=".. sql:escape_string(warnUpdate) .." WHERE id='".. sql:escape_string(tostring(getData(foundPlayer, "dbid"))) .."'")
							outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .."'s warns have been reduced to ".. warnUpdate ..".", thePlayer, 212, 156, 49)
							
							exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." un-warned ".. getPlayerName(thePlayer):gsub("_", " ") ..".")
						else
							outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .."'s warns are already 0.", thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("MySQL Error.", thePlayer, 255, 0, 0)
					end
					
					sql:free_result(result)
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [ Player Name / ID ]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("unwarn", unWarnPlayer, false, false)

-- /disappear	
function toggleDisappear( thePlayer, commandName )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		local current = getData(thePlayer, "invisible")
		if (current == 1) then
			
			setElementAlpha(thePlayer, 255)
			setData( thePlayer, "invisible", 0, true)
			
			setData(thePlayer, "nametag", 0, true)
			
			outputChatBox("You are now visible.", thePlayer, 212, 156, 49)
		elseif (current == 0) then
			
			setElementAlpha(thePlayer, 0)
			setData( thePlayer, "invisible", 1, true)
			
			setData(thePlayer, "nametag", 1, true)
			
			outputChatBox("You are now invisible.", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("disappear", toggleDisappear, false, false)

-- /tognametag	
function toggleNametag( thePlayer, commandName )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		local current = getData(thePlayer, "nametag")
		if (current == 1) then
			
			setData(thePlayer, "nametag", 0, true)
			outputChatBox("Your nametag is now invisible.", thePlayer, 212, 156, 49)
		else
			
			setData(thePlayer, "nametag", 1, true)
			outputChatBox("Your nametag is now visible.", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("tognametag", toggleNametag, false, false)

-- /giveitem
function givePlayerItem(thePlayer, commandName, partialPlayerName, itemID, ...)
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (partialPlayerName) and (itemID) and (...) then
			
			local players = exports['[ars]global']:findPlayer(thePlayer, partialPlayerName)
			
			if #players == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #players > 1 then
				outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
			
				for k, foundPlayer in ipairs (players) do
					
					
					outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayer in ipairs (players) do	
					
					local itemID = tonumber(itemID)
					local itemValue = tostring( table.concat({...}, " ") )
					
					local success, itemName = exports['[ars]inventory-system']:giveItem(foundPlayer, itemID, itemValue)
					if (success) then
						outputChatBox("You gave ".. getPlayerName(foundPlayer):gsub("_", " ") .." a ".. tostring(itemName) .." with value ".. tostring(itemValue) ..".", thePlayer, 212, 156, 49)
						
						exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." gave ".. getPlayerName(thePlayer):gsub("_", " ") .." a ".. tostring(itemName) .." with value ".. tostring(itemValue) ..".")
					else
						if ( itemName ~= "" ) then
							
							local f = string.upper(string.sub(itemName, 1, 1))
							local reason = string.sub(itemName, 2)
							
							outputChatBox("Failed to Give Item. ( ".. f .. reason .." )", thePlayer, 255, 0, 0)
						end	
					end
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Player Name/ID] [Item ID] [Item Value]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("giveitem", givePlayerItem, false, false)	

-- /takeitem
function takePlayerItem(thePlayer, commandName, partialPlayerName, itemID)
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (partialPlayerName) and (itemID) then
			
			local players = exports['[ars]global']:findPlayer(thePlayer, partialPlayerName)
			
			if #players == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #players > 1 then
				outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
			
				for k, foundPlayer in ipairs (players) do
					
					
					outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayer in ipairs (players) do	
					
					local itemID = tonumber(itemID)
					
					local success, itemName = exports['[ars]inventory-system']:takeItem(foundPlayer, itemID)
					if (success) then
						outputChatBox("You took away one ".. tostring(itemName) .." from ".. getPlayerName(foundPlayer):gsub("_", " ") ..".", thePlayer, 212, 156, 49)
						
						exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." took away one ".. tostring(itemName) .." from ".. getPlayerName(foundPlayer):gsub("_", " ") ..".")
					else
						outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." does not have an item with that ID ".. tostring(itemID) ..".", thePlayer, 255, 0, 0)
					end
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Player Name/ID] [Item ID]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("takeitem", takePlayerItem, false, false)

-- /checkinv
function checkInventory( thePlayer, commandName, partialPlayerName )
	if getData(thePlayer, "loggedin") == 1 then
		
		if ( exports['[ars]global']:isPlayerTrialModerator(thePlayer) and commandName == "checkinv" ) or ( getData( thePlayer, "faction" ) == 1 and commandName == "frisk" ) then
		
			if (partialPlayerName) then
				
				local players = exports['[ars]global']:findPlayer(thePlayer, partialPlayerName)
				
				if #players == 0 then
					outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
				elseif #players > 1 then
					outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
				
					for k, foundPlayer in ipairs (players) do
						
						outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
					end		
				else
					for k, foundPlayer in ipairs (players) do
						if ( getData( foundPlayer, "loggedin" ) == 1 ) then
							
							if ( commandName == "frisk" ) then
								local x, y, z = getElementPosition( thePlayer )
								local px, py, pz = getElementPosition( foundPlayer )
								
								if ( getDistanceBetweenPoints3D( x, y, z, px, py, pz ) > 5 ) then
									outputChatBox("You are too far away from that player", thePlayer, 255, 0, 0 )
									return
								end
							end
							
							local items, values = exports['[ars]inventory-system']:getPlayerInventory( foundPlayer )
							
							local weapons = { }
							for i = 1, 12 do
								local playerWeapon = getPedWeapon( foundPlayer, i )
								if ( playerWeapon ~= 0 and playerWeapon ~= 1 ) then
									
									local weaponName = getWeaponNameFromID( playerWeapon )
									local weaponAmmo = getPedTotalAmmo( foundPlayer, i )
									
									if ( weaponAmmo > 0 ) then
										weapons[#weapons+1] = { weaponName, weaponAmmo }
									end	
								end	
							end
							
							if ( items ) and ( values ) and ( weapons ) then
							
								triggerClientEvent(thePlayer, "showClientInventory", thePlayer, foundPlayer, items, values, weapons )
								
								exports['[ars]logs-system']:logAdminCommand("[".. string.upper(commandName) .."] "..exports['[ars]global']:getPlayerAdminTitle( thePlayer ) .." ".. getPlayerName(thePlayer):gsub("_", " ") .." checked ".. getPlayerName(foundPlayer):gsub("_", " ") .."'s inventory.")
							end
						else
							outputChatBox("The player is not logged in.", thePlayer, 255, 0, 0)
						end	
					end
				end
			else
				outputChatBox("SYNTAX: /".. commandName .." [Player Name/ID]", thePlayer, 212, 156, 49)
			end
		end	
	end	
end
addCommandHandler("checkinv", checkInventory, false, false)
addCommandHandler("frisk", checkInventory, false, false)

-- /x
function setXcoordinate(thePlayer, commandName, ix)
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		if not (ix) then
			outputChatBox("SYNTAX: /".. commandName .." [x value]", thePlayer, 212, 156, 49)
		else
			if (isPedInVehicle(thePlayer)) then
				local x, y, z = getElementPosition(thePlayer)
				local veh = getPedOccupiedVehicle(thePlayer)
				setElementPosition(veh, x+ix, y, z)
			else
				local x, y, z = getElementPosition(thePlayer)
				setElementPosition(thePlayer, x+ix, y, z)
			end
		end
	end
end
addCommandHandler("x", setXcoordinate)

-- /y
function setYcoordinate(thePlayer, commandName, iy)
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		if not (iy) then
			outputChatBox("SYNTAX: /".. commandName .." [y value]", thePlayer, 212, 156, 49)
		else
			if (isPedInVehicle(thePlayer)) then
				local x, y, z = getElementPosition(thePlayer)
				local veh = getPedOccupiedVehicle(thePlayer)
				setElementPosition(veh, x, y+iy, z)
			else
				local x, y, z = getElementPosition(thePlayer)
				setElementPosition(thePlayer, x, y+iy, z)
			end
		end
	end
end
addCommandHandler("y", setYcoordinate, false, false)

-- /z
function setZcoordinate(thePlayer, commandName, iz)
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		if not (iz) then
			outputChatBox("SYNTAX: /".. commandName .." [z value]", thePlayer, 212, 156, 49)
		else
			if (isPedInVehicle(thePlayer)) then
				local x, y, z = getElementPosition(thePlayer)
				local veh = getPedOccupiedVehicle(thePlayer)
				setElementPosition(veh, x, y, z+iz)
			else
				local x, y, z = getElementPosition(thePlayer)
				setElementPosition(thePlayer, x, y, z+iz)
			end
		end
	end
end
addCommandHandler("z", setZcoordinate, false, false)

-- /allchars
function getAllCharacters( thePlayer, commandName, partialPlayerName )
	if ( getData(thePlayer, "loggedin") == 1 ) and ( exports['[ars]global']:isPlayerTrialModerator(thePlayer) ) then
		
		if (partialPlayerName) then
			
			local players = exports['[ars]global']:findPlayer(thePlayer, partialPlayerName)
			
			if #players == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #players > 1 then
				outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
			
				for k, foundPlayer in ipairs (players) do
					
					outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayer in ipairs (players) do
					if ( getData( foundPlayer, "loggedin" ) == 1 ) then
					
						local accountid = tonumber( getData(foundPlayer, "accountid") )
						local accountname = tostring( getData(foundPlayer, "accountname") )
						
						outputChatBox("~-~-~-~-~-~-~ ".. accountname .." - ".. accountid .." ~-~-~-~-~-~-~", thePlayer, 212, 156, 49)
						
						local count = 1
						
						local result = sql:query("SELECT `charactername`, `faction` FROM `characters` WHERE `account`=".. sql:escape_string( accountid ) .."")
						while true do
							local row = sql:fetch_assoc(result)
							if ( row ) then
								
								local charactername = tostring( row['charactername'] )
								local faction = tonumber( row['faction'] )
								
								local name = "#FF0000Not in a faction"
								if ( faction > 0 ) then
									local result = sql:query_fetch_assoc("SELECT `name` FROM `factions` WHERE `id`=".. sql:escape_string( faction ) .."")
									if ( result ) then
										
										name = "#00FF00".. tostring( result['name'] )
									end
								end	
								
								outputChatBox("#".. count ..": ".. charactername .." - ".. name, thePlayer, 212, 156, 49, true)
	
								count = count + 1
							else
								break
							end
						end
						
						sql:free_result(result)
					else
						outputChatBox("The Player is not logged in.", thePlayer, 255, 0, 0)
					end
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Player Name/ID]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("allchars", getAllCharacters, false, false)

-- /allaccs
function getAllAccounts( thePlayer, commandName, ... )
	if ( getData(thePlayer, "loggedin") == 1 ) and ( exports['[ars]global']:isPlayerTrialModerator(thePlayer) ) then
		
		if (...) then
			
			local partialPlayerName = table.concat({...}, " ")
			
			local players = exports['[ars]global']:findPlayer(thePlayer, partialPlayerName)
			if ( #players > 1 ) then
				outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
			
				for k, foundPlayer in ipairs (players) do
					
					outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			elseif ( #players == 1 ) then
				local foundPlayer = players[#players]
				
				local ip = getPlayerIP( foundPlayer )
				ip = string.sub( tostring( ip ), 1, decimalPlace( ip ) + 2 )
				
				printAccounts( thePlayer, getPlayerName(foundPlayer):gsub("_", " "), ip )
			else
				local result = sql:query_fetch_assoc("SELECT `account` FROM `characters` WHERE `charactername`='".. sql:escape_string( partialPlayerName ) .."'")
				if ( result ) then
					
					local account = tonumber( result['account'] )
					
					local row = sql:query_fetch_assoc("SELECT `ip` FROM `accounts` WHERE `id`=".. sql:escape_string( account ) .."")
					if ( row ) then
						
						local ip = row['ip']
						ip = string.sub( tostring( ip ), 1, decimalPlace( ip ) + 2 )
						
						printAccounts( thePlayer, partialPlayerName, ip )
					end
				else
					local row = sql:query_fetch_assoc("SELECT `ip` FROM `accounts` WHERE `username`='".. sql:escape_string( partialPlayerName ) .."'")
					if ( row ) then
						
						local ip = row['ip']
						ip = string.sub( tostring( ip ), 1, decimalPlace( ip ) + 2 )
						
						printAccounts( thePlayer, partialPlayerName, ip )
					else
						outputChatBox("No one found with the given Username/Character Name/ID", thePlayer, 255, 0, 0)
					end	
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Player Name/ID]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("allaccs", getAllAccounts, false, false)

function printAccounts( thePlayer, name, ip )
	local ip = tostring( ip )
	local accounts = { }
	
	local result = sql:query("SELECT `username`, DATEDIFF(NOW(), `lastlogin`) AS `llastlogin`, `ip` FROM `accounts`")
	while true do
		local row = sql:fetch_assoc( result )
		if ( row ) then
		
			local username = tostring( row['username'] )
			local savedIP = tostring( row['ip'] )
			local lastlogin = tostring( row['llastlogin'] )
	
			if ( string.sub( savedIP, 1, decimalPlace( savedIP ) + 2 ) == ip ) then
				accounts[#accounts+1] = { username, lastlogin }
			end
		else
			break
		end
	end
	
	sql:free_result(result)
	
	outputChatBox("~-~-~-~-~ ".. name .." ~-~-~-~-~", thePlayer, 212, 156, 49)
	
	local count = 1
	for key, value in ipairs ( accounts ) do
		
		local username = tostring( accounts[key][1] )
		local lastlogin = tostring( accounts[key][2] )
		
		local text = lastlogin .." days ago"
		if ( lastlogin == "0" ) then
			text = "Today"
		elseif ( lastlogin == "1" ) then
			text = lastlogin .." day ago"
		end
		
		outputChatBox("#".. count ..": ".. username .." - ".. text, thePlayer, 212, 156, 49)
		count = count + 1
	end
end

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