--[[ 
TO DO:
-- /me 
-- /do 
-- /s(hout) 
-- /w(hisper) 
-- /o 
-- /a 
-- /su 
-- /l 
-- /h 
-- /dv 
-- /don 
-- /f 
-- /d 
-- /r 
]]--
local g_OOCState = false
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

-- ////// Local CHAT \\\\\\	
-- /say
function localChat( thePlayer, message, language )
	if getData(thePlayer, "loggedin") == 1 and not isPedDead(thePlayer) and message then
		
		local message = tostring( message )
		
		if ( string.find( string.sub ( message, 1, 1 ), " " ) ) then -- The first character is a space..
			return
		end	

		outputChatBox("[English] ".. getPlayerName(thePlayer):gsub("_", " ") .." says: ".. message, thePlayer, 255, 255, 255, true)
		
		-- Convey the message to all the players around him by doing a loop
		for k, players in ipairs ( getElementsByType("player") ) do
				
			local x, y, z = getElementPosition(thePlayer)
			local pX, pY, pZ = getElementPosition(players)
			local distance = getDistanceBetweenPoints3D(x, y, z, pX, pY, pZ)
				
			if (distance <= 20) then
					
				-- Color should be according to the distance
				local msgR, msgG, msgB
				local colorCode
				if (distance <= 6) then
					msgR, msgG, msgB = 255, 255, 255
					colorCode = "#FFFFFF"
				elseif (distance > 6 and distance <= 12) then
					msgR, msgG, msgB = 200, 200, 200
					colorCode = "#C8C8C8"
				elseif (distance > 12 and distance <= 20) then	
					msgR, msgG, msgB = 145, 145, 145
					colorCode = "#919191"
				end	
					
				if ( getData(thePlayer, "loggedin") == 1 ) and ( not isPedDead(thePlayer) ) and ( players ~= thePlayer ) then
					if (getElementDimension(players) == getElementDimension(thePlayer) and getElementInterior(players) == getElementInterior(thePlayer)) then
				
						outputChatBox("[English] ".. colorCode .."".. getPlayerName(thePlayer):gsub("_", " ") .." says: ".. message, players, msgR, msgG, msgB, true)
					end	
				end	
			end	
		end

	end	
end

-- /b
function localOOC( thePlayer, commandName, ... )
	if getData(thePlayer, "loggedin") == 1 and not isPedDead(thePlayer) then
		if (...) then
			
			local message = string.sub( table.concat({...}, " "), 1, 90 )
			
			if ( string.find( string.sub ( message, 1, 1 ), " " ) ) then 
				return
			end	
			
			outputChatBox(getPlayerName(thePlayer):gsub("_", " ") ..": (( ".. message .." ))", thePlayer, 61, 180, 219)
			
			-- Convey the message to all the players around him by doing a loop
			for k, players in ipairs ( getElementsByType("player") ) do
				
				local x, y, z = getElementPosition(thePlayer)
				local pX, pY, pZ = getElementPosition(players)
				local distance = getDistanceBetweenPoints3D(x, y, z, pX, pY, pZ)
				
				if (distance <= 20) then
					if ( getData(thePlayer, "loggedin") == 1 ) and ( not isPedDead(thePlayer) ) and ( players ~= thePlayer ) then
						
						if (getElementDimension(players) == getElementDimension(thePlayer) and getElementInterior(players) == getElementInterior(thePlayer)) then
							
							outputChatBox(getPlayerName(thePlayer):gsub("_", " ") ..": (( ".. message .." ))", players, 61, 180, 219)
						end	
					end
				end	
			end	
		else
			outputChatBox("SYNTAX: /".. commandName .." [Text]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("b", localOOC, false, false)
addCommandHandler("LocalOOC", localOOC)	

-- /s(hout)
function shoutLocal( thePlayer, commandName, ... )
	if getData(thePlayer, "loggedin") == 1 and not isPedDead(thePlayer) then
		if (...) then
			
			local message = string.sub( table.concat({...}, " "), 1, 90 )
			
			if ( string.find( string.sub ( message, 1, 1 ), " " ) ) then 
				return
			end
			
			for k, players in ipairs ( getElementsByType("player") ) do
				
				local x, y, z = getElementPosition(thePlayer)
				local pX, pY, pZ = getElementPosition(players)
				local distance = getDistanceBetweenPoints3D(x, y, z, pX, pY, pZ)
					
				if (distance <= 30) then
					
					if (getElementDimension(players) == getElementDimension(thePlayer) and getElementInterior(players) == getElementInterior(thePlayer)) then
						
						outputChatBox("[English] ".. getPlayerName(thePlayer):gsub("_", " ") .." shouts: ".. message .."!!", players, 255, 255, 255, true)
					end	
				end
			end	
			
			triggerClientEvent(thePlayer, "callTextBubble", thePlayer, message .."!!", 2)
		else
			outputChatBox("SYNTAX: /".. commandName .." [Text]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("s", shoutLocal, false, false)
addCommandHandler("shout", shoutLocal, false, false)
	
-- /w(hisper)
function whisperLocal( thePlayer, commandName, ... ) 	
	if getData(thePlayer, "loggedin") == 1 and not isPedDead(thePlayer) then
		if (...) then
			
			local message = string.sub( table.concat({...}, " "), 1, 90 )
			
			if ( string.find( string.sub ( message, 1, 1 ), " " ) ) then 
				return
			end
			
			for k, players in ipairs ( getElementsByType("player") ) do
				
				local x, y, z = getElementPosition(thePlayer)
				local pX, pY, pZ = getElementPosition(players)
				local distance = getDistanceBetweenPoints3D(x, y, z, pX, pY, pZ)
					
				if (distance <= 2) then
					
					if (getElementDimension(players) == getElementDimension(thePlayer) and getElementInterior(players) == getElementInterior(thePlayer)) then
					
						outputChatBox("[English] ".. getPlayerName(thePlayer):gsub("_", " ") .." whispers: ".. message, players, 200, 200, 200, true)
					end	
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Text]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("w", whisperLocal, false, false)
addCommandHandler("whisper", whisperLocal, false, false)

-- /me
function meAction( thePlayer, commandName, ... )
	if getData(thePlayer, "loggedin") == 1 and not isPedDead(thePlayer) then
		if (commandName) then 
			
			if (...) then
			
				local message = string.sub( table.concat({...}, " "), 1, 90 )
			
				if ( string.find( string.sub ( message, 1, 1 ), " " ) ) then 
					return
				end
				
				for k, players in ipairs ( getElementsByType("player") ) do
				
					local x, y, z = getElementPosition(thePlayer)
					local pX, pY, pZ = getElementPosition(players)
					local distance = getDistanceBetweenPoints3D(x, y, z, pX, pY, pZ)
						
					if (distance <= 20) then
						
						if (getElementDimension(players) == getElementDimension(thePlayer) and getElementInterior(players) == getElementInterior(thePlayer)) then
							
							outputChatBox(" * ".. getPlayerName(thePlayer):gsub("_", " ") .." ".. message .."", players, 127, 88, 205)
						end
					end	
				end
			else
				outputChatBox("SYNTAX: /me [Action]", thePlayer, 212, 156, 49)
			end	
		end
	end	
end
addEvent("meAction", true)
addEventHandler("meAction", root, meAction)
addCommandHandler("me", meAction, false, false)

-- /do
function doAction( thePlayer, commandName, ... )
	if getData(thePlayer, "loggedin") == 1 and not isPedDead(thePlayer) then
		if (...) then
			
			local message = string.sub( table.concat({...}, " "), 1, 90 )
			
			if ( string.find( string.sub ( message, 1, 1 ), " " ) ) then 
				return
			end
			
			for k, players in ipairs ( getElementsByType("player") ) do
				
				local x, y, z = getElementPosition(thePlayer)
				local pX, pY, pZ = getElementPosition(players)
				local distance = getDistanceBetweenPoints3D(x, y, z, pX, pY, pZ)
						
				if (distance <= 20) then
					if (getElementDimension(players) == getElementDimension(thePlayer) and getElementInterior(players) == getElementInterior(thePlayer)) then
					
						outputChatBox(" * ".. message .." ((".. getPlayerName(thePlayer):gsub("_", " ") .."))", players, 127, 88, 205)
					end	
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Event/Notification]", thePlayer, 212, 156, 49)
		end
	end
end
addEvent("doAction", true)
addEventHandler("doAction", root, doAction)
addCommandHandler("do", doAction, false, false)
	
-- /togglobal
function toggleGChat( thePlayer, commandName, ... )
	if getData(thePlayer, "loggedin") == 1 then
		if exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
			
			if (...) then
				reason = table.concat({...}, " ")
			else
				reason = ""
			end
			
			if not g_OOCState then
				g_OOCState = true
				
				if string.len(reason) > 0 then
					outputChatBox("Global OOC is now enabled (".. reason ..")", getRootElement(), 0, 255, 0)
				else
					outputChatBox("Global OOC is now enabled.", getRootElement(), 0, 255, 0)
				end	
			elseif g_OOCState then
				g_OOCState = false
				
				if string.len(reason) > 0 then
					outputChatBox("Global OOC is now disabled (".. reason ..")", getRootElement(), 255, 0, 0)
				else
					outputChatBox("Global OOC has been disabled.", getRootElement(), 255, 0, 0)
				end		
			end	
		end
	end
end
addCommandHandler("togglobal", toggleGChat, false, false)
addCommandHandler("togooc", toggleGChat, false, false)
	
-- Global Chat	
function globalOOC( thePlayer, commandName, ...)
	if getData(thePlayer, "loggedin") == 1 then
		if (...) then
			
			if (g_OOCState) or not (g_OOCState) and (exports['[ars]global']:isPlayerTrialModerator(thePlayer)) then	
			
				if (getData(thePlayer, "muted") == 0) then
					
					local message = string.sub( table.concat({...}, " "), 1, 90 )
			
					if ( string.find( string.sub ( message, 1, 1 ), " " ) ) then 
						return
					end
					
					for k, v in ipairs (getElementsByType("player")) do
						
						if (getData(v, "globalooc") == 1) then
							outputChatBox("[".. getData(thePlayer, "playerid") .."] ".. getPlayerName(thePlayer):gsub("_", " ") ..": (( ".. message .." ))", v, 95, 166, 163)
						end	
					end
				else
					outputChatBox("You have been muted by staff.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Global Chat is currently disabled.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("SYNTAX: /o [Message]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("o", globalOOC, false, false)
addCommandHandler("GlobalOOC", globalOOC)	

-- /pm	
function privateMessage( thePlayer, commandName, partialPlayerName, ... )
	if getData(thePlayer, "loggedin") == 1 then
		if (partialPlayerName) and (...) then
		
			local message = string.sub( table.concat({...}, " "), 1, 90 )
			
			if ( string.find( string.sub ( message, 1, 1 ), " " ) ) then 
				return
			end
			
			local players = findPlayer( thePlayer, partialPlayerName )
			
			if #players == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #players > 1 then
				outputChatBox("Multiple Players found!", thePlayer, 255, 200, 0)
				
				local count = 0
				for k, foundPlayer in ipairs (players) do
					
					count = count + 1
					outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayer in ipairs (players) do
					if (getData(foundPlayer, "loggedin") == 1) then
						
						local thePlayerAdminlevel = tonumber( getData( thePlayer, "admin" ) )
						local targetPlayerAdminLevel = tonumber( getData( foundPlayer, "admin" ) )
						
						if ( isPlayerPrivateMessagingDisabled( foundPlayer ) ) and ( targetPlayerAdminLevel >= thePlayerAdminlevel ) then
							
							outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." is ignoring Private Messages.", thePlayer, 212, 156, 49)
							return
						else	
							outputChatBox("PM sent to [".. getData(foundPlayer, "playerid") .."] ".. getPlayerName(foundPlayer):gsub("_", " ") ..": ".. message, thePlayer, 255, 255, 0)
							outputChatBox("PM from [".. getData(thePlayer, "playerid") .."] ".. getPlayerName(thePlayer):gsub("_", " ") ..": ".. message, foundPlayer, 255, 255, 0)
							
							outputDebugString("PM from " .. getPlayerName(thePlayer):gsub("_", " ") .. " to " .. getPlayerName(foundPlayer):gsub("_", " ")	.. ": " .. message)
						end	
					else
						outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." is not logged in.", thePlayer, 255, 0, 0)
					end
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Player Name / ID] [Message]", thePlayer, 212, 156, 49)
		end
	end
end	
addCommandHandler("pm", privateMessage, false, false)
	
function togglePrivateMessages( thePlayer )
	if ( getData( thePlayer, "loggedin" ) == 1 ) then
		
		if ( exports['[ars]global']:isPlayerLevelOneDonator( thePlayer ) or exports['[ars]global']:isPlayerTrialModerator( thePlayer ) ) then
			
			if ( isPlayerPrivateMessagingDisabled( thePlayer ) ) then
				
				local update = sql:query("UPDATE `accounts` SET `togpm`='0' WHERE `id`=".. sql:escape_string( tonumber( getData( thePlayer, "accountid") ) ) .."")
				if ( update ) then
					
					setData( thePlayer, "togglepm", 0, true )
					outputChatBox("You are no longer ignoring Private Messages.", thePlayer, 212, 156, 49)
				end
			elseif ( not isPlayerPrivateMessagingDisabled( thePlayer ) ) then
				
				local update = sql:query("UPDATE `accounts` SET `togpm`='1' WHERE `id`=".. sql:escape_string( tonumber( getData( thePlayer, "accountid") ) ) .."")
				if ( update ) then
					
					setData( thePlayer, "togglepm", 1, true )
					outputChatBox("You are now ignoring Private Messages.", thePlayer, 212, 156, 49)
				end	
			end	
		end
	end
end
addCommandHandler("togpm", togglePrivateMessages, false, false)
	
function isPlayerPrivateMessagingDisabled( thePlayer )
	if ( getData( thePlayer, "togglepm" ) == 1 ) then
		return true
	else
		return false
	end
end
	
-- ////// ADMIN CHAT \\\\\\

-- /a(dminchat)
function adminChat(thePlayer, commandName, ...)
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (...) then
		
			local message = string.sub( table.concat({...}, " "), 1, 90 )
			
			if ( string.find( string.sub ( message, 1, 1 ), " " ) ) then 
				return
			end
			
			for k, v in ipairs (getElementsByType("player")) do
				
				local loggedin = tonumber(getData(v, "loggedin"))
				if (loggedin == 1) then
				
					if exports['[ars]global']:isPlayerTrialModerator(v) then
						outputChatBox("(".. exports['[ars]global']:getPlayerAdminTitle(thePlayer) ..") ".. getPlayerName(thePlayer):gsub("_", " ") ..": ".. message, v, 54, 181, 75)
					end
				end	
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Message]", thePlayer, 212, 156, 49)	
		end	
	end
end
addCommandHandler("a", adminChat, false, false) 

-- /ann(ouncement)
function annChat(thePlayer, commandName, ...)
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerModerator(thePlayer) then
		if (...) then
			
			local message = string.sub( table.concat({...}, " "), 1, 90 )
			
			if ( string.find( string.sub ( message, 1, 1 ), " " ) ) then 
				return
			end
			
			for k, v in ipairs (getElementsByType("player")) do
			
				local loggedin = tonumber(getData(v, "loggedin"))
				if (loggedin == 1) then
				
					outputChatBox("~~ Announcement from Administration ~~", v, 212, 156, 49)
					outputChatBox(message, v, 212, 156, 49)
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Message]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("ann", annChat)

-- /don(ator chat)
function donatorChat( thePlayer, commandName, ...)
	if ( getData(thePlayer, "loggedin") == 1 ) and (exports['[ars]global']:isPlayerLevelOneDonator(thePlayer) or exports['[ars]global']:isPlayerTrialModerator(thePlayer)) then	
		if (...) then		
			local message = string.sub( table.concat({...}, " "), 1, 90 )
			
			if ( string.find( string.sub ( message, 1, 1 ), " " ) ) then 
				return
			end
			
			for k, players in ipairs ( getElementsByType("player") ) do
				local loggedin = tonumber(getData(players, "loggedin"))
				if (loggedin == 1) then
					
					local donatorlevel = exports['[ars]global']:getPlayerDonatorTitle( thePlayer )
					local adminlevel = exports['[ars]global']:getPlayerAdminTitle( thePlayer )
					
					local level = ""
					if ( donatorlevel == "Non-donator" ) then
						level = adminlevel
					else
						level = donatorlevel
					end
					
					if (exports['[ars]global']:isPlayerLevelOneDonator(players) or exports['[ars]global']:isPlayerTrialModerator(players)) then
						
						outputChatBox("(".. level ..") ".. getPlayerName(thePlayer):gsub("_", " ") ..": ".. message, players, 166, 141, 4)
					end	
				end	
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Message]", thePlayer, 210, 108, 58)
		end	
	end
end
addCommandHandler("don", donatorChat, false, false)
addCommandHandler("donator", donatorChat, false, false)

-- /gov(ernment announcement)
function govChat(thePlayer, commandName, ...)
	if getData(thePlayer, "loggedin") == 1 then
		if (...) then
			if ( getData(thePlayer, "faction") == 1 or getData(thePlayer, "faction") == 2 ) then -- PD/FD
				
				if (getData(thePlayer, "muted") == 0) then
				
					local message = string.sub( table.concat({...}, " "), 1, 90 )
			
					if ( string.find( string.sub ( message, 1, 1 ), " " ) ) then 
						return
					end
					
					for k, v in ipairs (getElementsByType("player")) do
						local loggedin = tonumber(getData(v, "loggedin"))
						if (loggedin == 1) then
							
							outputChatBox("~~ Government Announcement from ".. getPlayerName(thePlayer):gsub("_", " ") .." ~~", v, 0, 183, 239)
							outputChatBox(message, v, 0, 183, 239)
						end
					end
				else
					outputChatBox("You have been muted by staff.", thePlayer, 255, 0, 0)
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Message]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("gov", govChat)

-- /m(egaphone)
function useMegaPhone(thePlayer, commandName, ...)
	if getData(thePlayer, "loggedin") == 1 and not isPedDead(thePlayer) then
		if (...) then
			if ( getData(thePlayer, "faction") == 1 or getData(thePlayer, "faction") == 2 ) then -- PD/FD
				
				if ( getData(thePlayer, "muted") == 0 ) then
					
					local message = string.sub( table.concat({...}, " "), 1, 90 )
			
					if ( string.find( string.sub ( message, 1, 1 ), " " ) ) then 
						return
					end
			
					for k, players in ipairs ( getElementsByType("player") ) do
				
						local x, y, z = getElementPosition(thePlayer)
						local pX, pY, pZ = getElementPosition(players)
						local distance = getDistanceBetweenPoints3D(x, y, z, pX, pY, pZ)
						
						if (distance <= 50) then
							if (getElementDimension(players) == getElementDimension(thePlayer) and getElementInterior(players) == getElementInterior(thePlayer)) then
					
								outputChatBox("[English] " .. getPlayerName(thePlayer):gsub("_", " ") .. "'s megaphone: " .. message, players, 255, 255, 0)
							end		
						end
					end
				else
					outputChatBox("You have been muted by staff.", thePlayer, 255, 0, 0)
				end
			end
		else	
			outputChatBox("SYNTAX: /".. commandName .." [Message]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("m", useMegaPhone, false, false)

-- /f(action)
function factionOOC(thePlayer, commandName, ...)
	if getData(thePlayer, "loggedin") == 1 then
		if (...) then
			local theTeam = getPlayerTeam(thePlayer)
			local theTeamName = getTeamName(theTeam)
			local playerName = getPlayerName(thePlayer)
			local playerFaction = getData(thePlayer, "faction")
			
			if (playerFaction > 0) then
	
				local message = string.sub( table.concat({...}, " "), 1, 90 )
			
				if ( string.find( string.sub ( message, 1, 1 ), " " ) ) then 
					return
				end
	
				for index, arrayPlayer in ipairs( getElementsByType( "player" ) ) do
					if isElement( arrayPlayer ) then
						if getPlayerTeam( arrayPlayer ) == theTeam then
							local loggedin = tonumber(getData(arrayPlayer, "loggedin"))
							if (loggedin == 1) then
							
								outputChatBox("[FACTION OOC] " .. getPlayerName(thePlayer):gsub("_", " ") .. ": " .. message, arrayPlayer, 3, 237, 237)
							end	
						end
					end
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Message]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("f", factionOOC, false, false)

-- /d(epartment)
function depChat(thePlayer, commandName, ...)
	if getData(thePlayer, "loggedin") == 1 then
		if (...) then
			if (getData(thePlayer, "faction") == 1 or getData(thePlayer, "faction") == 2 or getData(thePlayer, "faction") == 4) then
				if (getData(thePlayer, "muted") == 0) then
					
					local message = string.sub( table.concat({...}, " "), 1, 90 )
			
					if ( string.find( string.sub ( message, 1, 1 ), " " ) ) then 
						return
					end
					
					local theTeam = getPlayerTeam(thePlayer)
					local LSPD = getPlayersInTeam(getTeamFromName("Bone County Sheriff's Department"))
					local LSFD = getPlayersInTeam(getTeamFromName("Bone County Fire Department"))
					local LSVS = getPlayersInTeam(getTeamFromName("Bone County Vehicle Services"))
					local playerName = getPlayerName(thePlayer)
					
					if getTeamName(theTeam) == "Bone County Sheriff's Department" then
						teamName = "BCSD"
					elseif getTeamName(theTeam) == "Bone County Fire Department" then
						teamName = "BCFD"
					elseif getTeamName(theTeam) == "Bone County Vehicle Services" then	
						teamName = "BCVS"
					end
				
					for key, value in ipairs(LSPD) do
						local loggedin = tonumber(getData(value, "loggedin"))
						if (loggedin == 1) then
							
							outputChatBox("[DEPARTMENT " .. teamName .. "] " .. getPlayerName(thePlayer):gsub("_", " ") .. " says: " .. message, value, 0, 102, 255)
						end	
					end
				
					for key, value in ipairs(LSFD) do
						local loggedin = tonumber(getData(value, "loggedin"))
						if (loggedin == 1) then
						
							outputChatBox("[DEPARTMENT " .. teamName .. "] " .. getPlayerName(thePlayer):gsub("_", " ") .. " says: " .. message, value, 0, 102, 255)
						end	
					end
					
					for key, value in ipairs(LSVS) do
						local loggedin = tonumber(getData(value, "loggedin"))
						if (loggedin == 1) then
						
							outputChatBox("[DEPARTMENT " .. teamName .. "] " .. getPlayerName(thePlayer):gsub("_", " ") .. " says: " .. message, value, 0, 102, 255)
						end	
					end
				else
					outputChatBox("You have been muted by staff.", thePlayer, 255, 0, 0)
				end		
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Message]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("d", depChat, false, false)

-- /r(adio)
function radioChat( thePlayer, commandName, ... )
	if getData(thePlayer, "loggedin") == 1 and not isPedDead(thePlayer) then
		if (...) then
			
			local message = string.sub( table.concat({...}, " "), 1, 90 )
			
			if ( string.find( string.sub ( message, 1, 1 ), " " ) ) then 
				return
			end
			
			local hasRadio = exports['[ars]inventory-system']:hasItem(thePlayer, 4)
			if ( hasRadio ) then 
			
				local frequency = tonumber( getData(thePlayer, "radio") )
				if ( frequency > 0 ) then
					
					for key, foundPlayer in ipairs ( getElementsByType("player") ) do
						if ( getData( foundPlayer, "loggedin" ) == 1 ) then
							local hasRadio = exports['[ars]inventory-system']:hasItem(foundPlayer, 4)
							local matchFrequency = tonumber( getData(foundPlayer, "radio") )
							
							if ( hasRadio and matchFrequency == frequency ) then
								
								if ( foundPlayer ~= thePlayer ) then
									outputChatBox("[RADIO #".. frequency .. "] (( ".. getPlayerName(thePlayer):gsub("_", " ") .." )): ".. message, foundPlayer, 70, 54, 224)
								end
							end
						end	
					end	
					
					outputChatBox("[RADIO #".. frequency .. "] (( ".. getPlayerName(thePlayer):gsub("_", " ") .." )): ".. message, thePlayer, 70, 54, 224)
				else
					outputChatBox("/tuneradio to set your radio's frequency.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("You do not have a radio.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [ Message ]", thePlayer, 212, 156, 49)
		end	
	end
end
addCommandHandler("r", radioChat, false, false)

function tuneRadio( thePlayer, commandName, frequency )
	if getData(thePlayer, "loggedin") == 1 and not isPedDead(thePlayer) then
		if ( frequency ) then
			frequency = tonumber( frequency )
			
			local hasRadio = exports['[ars]inventory-system']:hasItem(thePlayer, 4)
			if ( hasRadio ) then 
				
				local update = sql:query("UPDATE `characters` SET `radio`=".. sql:escape_string(frequency) .." WHERE `id`=".. sql:escape_string(tonumber(getData(thePlayer, "dbid"))) .."")
				if ( update ) then
					setData(thePlayer, "radio", frequency, true)
					outputChatBox("You tuned your frequency to #".. frequency ..".", thePlayer, 212, 156, 49)
				end	
			else
				outputChatBox("You do not have a radio.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [ Frequency number ]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("tuneradio", tuneRadio, false, false)	

-- ////// RETURN FUNCTIONS \\\\\\
-- /find	
function findPerson( thePlayer, commandName, partialPlayerName)
	
	local players = findPlayer( thePlayer, partialPlayerName )
		
	if #players == 0 then
		outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
	else 
		outputChatBox("Matches:", thePlayer, 255, 200, 0)
		
		local count = 0
		
		for k, foundPlayer in ipairs (players) do
			
			count = count + 1
			outputChatBox("[".. getData(foundPlayer, "playerid") .."] ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
		end	
	end
end
addCommandHandler("find", findPerson)
	
function findPlayer( thePlayer, partialName )
	local possiblePlayers = { }
	
	if partialName == "*" then
		table.insert(possiblePlayers, thePlayer)
		
		return possiblePlayers	
	elseif tonumber(partialName) then -- The id was given
	
		for k, v in ipairs (getElementsByType("player")) do
			local id = getData(v, "playerid")
				
			if (id == tonumber(partialName)) then
				table.insert(possiblePlayers, v)
			end
		end
		return possiblePlayers
	elseif tostring(partialName) then -- The name was given
		
		for k, v in ipairs (getElementsByType("player")) do
			local name = string.lower(getPlayerName(v))
				
			if (string.find(name, string.lower(tostring(partialName)))) then
				table.insert(possiblePlayers, v)	
			end
		end
		return possiblePlayers
	end
end

	
function bindOOC( )
	bindKey(source, "u", "down", "chatbox", "GlobalOOC")
	bindKey(source, "b", "down", "chatbox", "LocalOOC")
end
addEventHandler("onPlayerJoin", getRootElement(), bindOOC)
addEvent("bindOOC", true)
addEventHandler("bindOOC", getRootElement(), bindOOC)	
	
function bindOnResourceStart( res )
	for k, v in ipairs ( getElementsByType("player") ) do
		triggerEvent("bindOOC", v)
	end
end
addEventHandler("onResourceStart", resourceRoot, bindOnResourceStart)
	
function useChat( message, messageType )
	if getData(source, "loggedin") == 1 and not isPedDead(source) then
		
		if ( messageType == 0 ) then -- Local Text
			localChat( source, string.sub( message, 1, 90 ), language )
		elseif messageType == 1 then -- /me
			meAction( source, "me", string.sub( message, 1, 90 ) )
		elseif messageType == 2 then -- Team Say
			cancelEvent()
		end
	end
end
addEventHandler("onPlayerChat", getRootElement(), useChat)	
	
-- Disable default MTA Chat
addEventHandler("onPlayerChat", getRootElement(),
function ( )
	cancelEvent()
end
)