local sql = exports.sql

--------- [ Element Data returns ] ---------
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

--------- [ Check Player ] ---------
local send = false
function checkPlayer( thePlayer, commandName, partialPlayerName )
	if ( getData(thePlayer, "loggedin") == 1 ) and ( exports['[ars]global']:isPlayerTrialModerator(thePlayer) ) then
		if ( partialPlayerName ) then
			
			local players = exports['[ars]global']:findPlayer( thePlayer, partialPlayerName )
			
			if #players == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #players > 1 then
				outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
				
				local count = 0
				for k, foundPlayer in ipairs ( players ) do
					
					count = count + 1
					outputChatBox("(".. getData( foundPlayer, "playerid" ) ..") ".. getPlayerName( foundPlayer ):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayer in ipairs ( players ) do
					if ( getData( foundPlayer, "loggedin" ) == 1 ) then
						
						local accountname = tostring( getData( foundPlayer, "accountname" ) )
						local accountid = tostring( getData( foundPlayer, "accountid" ) )
						local ip = tostring( getPlayerIP( foundPlayer ) )
						local admin = tostring( exports['[ars]global']:getPlayerAdminTitle( foundPlayer ) )
						local reports = tostring( getData( foundPlayer, "adminreports" ) )
						
						local name = tostring( getPlayerName( foundPlayer ):gsub("_", " " ) )
						
						local factionid = tonumber( getData( foundPlayer, "faction") )
						local faction = "Not in a faction"
						
						if ( factionid > 0 ) then
							local result = sql:query_fetch_assoc("SELECT `name` FROM `factions` WHERE `id`=".. sql:escape_string( tonumber( factionid ) ) .."")
							if ( result ) then
								
								faction = tostring( result['name'] )
							end
						end
						
						local adminnote = ""
						local result = sql:query_fetch_assoc("SELECT `adminnote` FROM `accounts` WHERE `id`=".. sql:escape_string( tonumber( accountid ) ) .."")
						if ( result ) then
							
							adminnote = result['adminnote']
						end
						
						triggerClientEvent( thePlayer, "showCheckUI", thePlayer, foundPlayer, accountname, accountid, ip, admin, reports, name, faction, adminnote )
						
						-- Others
						send = true
						setTimer(getServerData, 500, 1, thePlayer, foundPlayer )
					else
						outputChatBox("The player is not logged in.", thePlayer, 255, 0, 0)
					end
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [ Player Name/ID ]", thePlayer, 212, 156, 49)
		end
	end	
end
addCommandHandler("check", checkPlayer, false, false)

function getServerData( thePlayer, foundPlayer )
	if ( send ) then
		
		if ( isElement( foundPlayer ) ) then
			
			local position = tostring( getElementZoneName( foundPlayer ) )
			local weapon = tostring( getWeaponNameFromID( getPedWeapon( foundPlayer ) ) )
			if ( weapon == "Fist" ) then
				weapon = "None"
			end
			
			local money = tostring( getPlayerMoney( foundPlayer )/100 )
			
			local data = { position, weapon, money }
			
			-- Update
			triggerClientEvent(thePlayer, "sendServerData", thePlayer, data )
			
			setTimer(getServerData, 1500, 1, thePlayer, foundPlayer)
		else
			send = false
			triggerClientEvent(thePlayer, "stopGetting", thePlayer)
		end
	end	
end

function stopSending( )
	if ( send ) then
		send = false
	end	
end
addEvent("stopSending", true)
addEventHandler("stopSending", root, stopSending)

function savePlayerNote( thePlayer, note )
	local note = tostring( note )
	
	local update = sql:query("UPDATE `accounts` SET `adminnote`='".. sql:escape_string( note ) .."' WHERE `id`=".. sql:escape_string( getData( thePlayer, "accountid" ) ) .."")
	if ( update ) then
		
		outputChatBox("Note saved!", source, 0, 255, 0)
	end	
	
	sql:free_result(update)
end
addEvent("savePlayerNote", true)
addEventHandler("savePlayerNote", root, savePlayerNote)