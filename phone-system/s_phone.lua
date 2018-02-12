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

--------- [ Phone System ] ---------

local lines = { }
lines["San Fierro Police Department"] = 911
lines["San Andreas Network and Entertainment"] = 700
lines["San Fierro Vehicle Services"] = 300
lines["San Fierro Taxi Services"] = 500

local playerRingtone = { }

function callPhone( thePlayer, commandName, phoneNumber )
	if getData(thePlayer, "loggedin") == 1 and not isPedDead(thePlayer) then
		
		local hasPhone = exports['[ars]inventory-system']:hasItem(thePlayer, 3)
		if ( hasPhone ) then
			
			if ( tonumber( getData(thePlayer, "calling") ) == 0 and tonumber( getData(thePlayer, "ringing") ) == 0 ) then
				
				if (phoneNumber) then
					local phoneNumber = tonumber(phoneNumber)
					
					local togglephone = tonumber( getData( thePlayer, "togglephone" ) )
					if ( togglephone == 0 ) then
						
						local found = false
						for key, foundPlayer in ipairs( getElementsByType("player") ) do
							if ( getData(foundPlayer, "loggedin" ) == 1 ) then
								
								local hasPhone, matchPhoneNumber = exports['[ars]inventory-system']:hasItem(foundPlayer, 3, phoneNumber)
							
								if (hasPhone and matchPhoneNumber) then
									
									if ( foundPlayer ~= thePlayer ) then
										if ( tonumber( getData(foundPlayer, "ringing") ) == 0 and tostring( getData(foundPlayer, "calling") ) == "0" ) then
											
											local togglephone = tonumber( getData( foundPlayer, "togglephone" ) )
											if ( togglephone == 0 ) then
												
												found = true
												
												setData(foundPlayer, "ringing", 1, true)
												
												setData(foundPlayer, "calling", tonumber(getData(thePlayer, "dbid")), true)
												setData(thePlayer, "calling", tonumber(getData(foundPlayer, "dbid")), true)
												
												triggerClientEvent (thePlayer, "playDialSound", thePlayer)
												
												outputChatBox("Dialing ".. phoneNumber .."...", thePlayer, 212, 156, 49)
												outputChatBox("Your phone is ringing, the number shows #".. tostring( getCallerNumber( thePlayer ) ) .." (/pickup or /hangup)", foundPlayer, 212, 156, 49)
												
												-- People should know..
												triggerEvent("doAction", foundPlayer, foundPlayer, "do", "You hear ".. getPlayerFirstName( foundPlayer ) .."'s phone ringing")
												
												local x, y, z = getElementPosition( foundPlayer )
												for key, value in ipairs ( getElementsByType("player") ) do
													
													triggerClientEvent(value, "playRingtone", value, playerRingtone[foundPlayer], foundPlayer, x, y, z )
												end	
												break
											else
												outputChatBox("The phone you're trying to reach is currently switched off.", thePlayer, 212, 156, 49)
												return
											end	
										else
											outputChatBox("You get a busy tone.", thePlayer, 212, 156, 49)
											return
										end	
									else
										outputChatBox("You get a busy tone.", thePlayer, 212, 156, 49)
										return	
									end	
								end
							end	
						end
						
						if ( not found ) then
							
							local found = false
							for key, value in pairs ( lines ) do
								if ( value == phoneNumber ) then
									
									found = true
									
									setData(thePlayer, "pickedup", 1, true)
									setData(thePlayer, "calling", tostring ( key ), true)
									
									triggerClientEvent( thePlayer, "playDialSound", thePlayer )
									outputChatBox("Dialing ".. phoneNumber .."...", thePlayer, 212, 156, 49)
									
									if ( key == "San Fierro Police Department") then
										outputChatBox("Operator says: This is 911, what's your emergency and location?", thePlayer, 212, 156, 49)
									elseif ( key == "San Andreas Network and Entertainment") then	
										outputChatBox("Operator says: Hello, this is SANE, What message would you like to convey?", thePlayer, 212, 156, 49)
									elseif ( key == "San Fierro Vehicle Services") then
										outputChatBox("Operator says: Hello, this is BCVS, What services do you require and where?", thePlayer, 212, 156, 49)
									elseif ( key == "San Fierro Taxi Services") then
										outputChatBox("Operator says: Hello, this is BCTS, Where would you like us to send a taxi?", thePlayer, 212, 156, 49)
									end	
								end
							end
							
							if ( not found ) then	
								outputChatBox("You get a dead tone.", thePlayer, 212, 156, 49)
							end	
						end
					else
						outputChatBox("Your phone is switched off.", thePlayer, 212, 156, 49)
					end	
				else
					outputChatBox("SYNTAX: /".. commandName .." [Number]", thePlayer, 212, 156, 49)
				end
			else
				outputChatBox("You are already on a call.", thePlayer, 255, 0, 0)
			end	
		else
			outputChatBox("You do not have a cell phone.", thePlayer, 255, 0, 0)
		end	
	end	
end
addEvent("callPlayer", true)
addEventHandler("callPlayer", root, callPhone)
addCommandHandler("call", callPhone, false, false)

function getPlayerFirstName( thePlayer )
	if ( thePlayer ) then
		local playerName = getPlayerName( thePlayer )
		
		return string.sub(playerName, 1, string.find(playerName, "_") - 1)
	end	
end

local calling = { }
function pickupPhone( thePlayer, commandName )
	if getData(thePlayer, "loggedin") == 1 and not isPedDead(thePlayer) then
		
		if ( tonumber( getData(thePlayer, "ringing") ) == 1 ) then
			
			setData(thePlayer, "pickedup", 1, true)
			setData(thePlayer, "ringing", 0, true)
			
			for key, value in ipairs ( getElementsByType("player") ) do
				if ( getData(value, "loggedin" ) == 1 ) then
				
					if ( tonumber(getData(thePlayer, "calling")) == tonumber(getData(value, "dbid")) ) then
						
						setData(value, "pickedup", 1, true)
						
						calling[thePlayer] = value
						calling[value] = thePlayer
						break
					end	
				end	
			end
			
			outputChatBox("They picked up the phone.", calling[thePlayer], 212, 156, 49)
			outputChatBox("You picked up the phone.", thePlayer, 212, 156, 49)
			
			for key, value in ipairs ( getElementsByType("player") ) do
				triggerClientEvent(value, "stopRingtone", value, thePlayer)
			end	
		else
			outputChatBox("Your phone is not ringing.", thePlayer, 255, 0, 0)
		end	
	end	
end
addCommandHandler("pickup", pickupPhone, false, false)

function hangupPhone( thePlayer, commandName )
	if getData(thePlayer, "loggedin") == 1 and not isPedDead(thePlayer) then
		
		if ( tonumber( getData(thePlayer, "ringing") ) == 1 or tostring( getData(thePlayer, "calling") ) ~= "0" ) then
			
			local found = false
			for key, value in ipairs ( getElementsByType("player") ) do
				if ( getData(value, "loggedin" ) == 1 ) then
					
					if ( tonumber(getData(thePlayer, "calling")) == tonumber(getData(value, "dbid")) ) then
					
						if ( getData(thePlayer, "ringing") == 1 ) then
							
							setData(thePlayer, "ringing", 0, true)
							
							resetCalling(thePlayer)
							resetCalling(value)
							
							outputChatBox("You hung up your phone.", thePlayer, 212, 156, 49)
							outputChatBox("They hung up the phone.", value, 212, 156, 49)
							
							found = true
							
							-- Ringtone
							for key, allPlayer in ipairs ( getElementsByType("player") ) do
								triggerClientEvent(allPlayer, "stopRingtone", allPlayer, thePlayer)	
							end	
							
							return
						end
							
						if ( tostring(getData(thePlayer, "calling")) ~= "0" ) then
							
							setData(value, "ringing", 0, true)
							
							resetCalling(thePlayer)
							resetCalling(value)
							
							outputChatBox("You hung up your phone.", thePlayer, 212, 156, 49)
							outputChatBox("They hung up the phone.", value, 212, 156, 49)
							
							found = true
							
							-- Ringtone
							for key, allPlayer in ipairs ( getElementsByType("player") ) do
								triggerClientEvent(allPlayer, "stopRingtone", allPlayer, value)	
							end
							return
						end
					end	
				end	
			end
			
			if ( not found ) then
				
				for key, value in pairs ( lines ) do
					if ( tostring( getData(thePlayer, "calling") ) == tostring( key ) ) then	

						resetCalling(thePlayer)
						outputChatBox("You hung up your phone.", thePlayer, 212, 156, 49)
						return
					end
				end
			end
		else
			outputChatBox("You are not on a call.", thePlayer, 255, 0, 0)
		end
	end	
end
addCommandHandler("hangup", hangupPhone, false, false)

function togglePlayerPhone( thePlayer )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerLevelTwoDonator( thePlayer ) then
		
		local togglephone = tonumber( getData( thePlayer, "togglephone") )
		if ( togglephone == 1 ) then
			
			local update = sql:query("UPDATE `characters` SET `togphone`='0' WHERE `id`=".. sql:escape_string( tonumber( getData( thePlayer, "dbid") ) ) .."")
			if ( update ) then
				
				setData( thePlayer, "togglephone", 0, true )
				outputChatBox("You switched on your phone.", thePlayer, 212, 156, 49)
			end
			
			sql:free_result(update)
		else
			
			local update = sql:query("UPDATE `characters` SET `togphone`='1' WHERE `id`=".. sql:escape_string( tonumber( getData( thePlayer, "dbid") ) ) .."")
			if ( update ) then
				
				setData( thePlayer, "togglephone", 1, true )
				outputChatBox("You switched off your phone.", thePlayer, 212, 156, 49)
			end
			
			sql:free_result(update)
		end
	end	
end
addCommandHandler("togphone", togglePlayerPhone, false, false)
addCommandHandler("togglephone", togglePlayerPhone, false, false)

function phoneChat( thePlayer, commandName, ... )
	if getData(thePlayer, "loggedin") == 1 and not isPedDead(thePlayer) then

		local callingLine = false
		for key, value in pairs ( lines ) do
			if ( tostring( getData(thePlayer, "calling") ) == key ) then
				
				callingLine = true
				break
			end
		end
		
		local callingNumber = false
		
		if ( not callingLine ) then
			if ( tonumber( getData(thePlayer, "calling") ) > 0 ) then
				
				callingNumber = true
			end
		end	
		
		if ( callingLine or callingNumber ) and ( tonumber( getData(thePlayer, "ringing") ) == 0 and tonumber( getData(thePlayer, "pickedup") ) == 1 ) then
			
			if (...) then
				
				local message = table.concat({...}, " ")
				
				for key, value in ipairs ( getElementsByType("player") ) do
					local x, y, z = getElementPosition( thePlayer )
					local px, py, pz = getElementPosition( value )
						
					if ( getDistanceBetweenPoints3D( x, y, z, px, py, pz ) <= 20 ) then
						
						outputChatBox("[English] ".. getPlayerName(thePlayer):gsub("_", " ") .." says (On Phone): ".. message, value, 255, 255, 255)
					end
				end
					
				if ( callingNumber ) then
			
					outputChatBox("[English] ".. getPlayerName( thePlayer ):gsub("_", " ") .." says (On Phone): ".. message, calling[thePlayer], 255, 255, 255)
				elseif ( callingLine ) then
				
					local operatorTellText = ""
					for key, value in pairs ( lines ) do
						if ( key == tostring( getData(thePlayer, "calling") ) ) then
							
							local operatorAskText = ""
							if ( key == "San Fierro Police Department") then
								operatorAskText = "[DISPATCH] This is dispatch, we received a 911 call from #".. tostring( getCallerNumber( thePlayer ) ) .."."
								operatorTellText = "Operator says: All units have been notified, please stay where you are!"
							elseif ( key == "San Andreas Network and Entertainment") then
								operatorAskText = "[OFFICE] We have a caller from #".. tostring( getCallerNumber( thePlayer ) ) ..", they want to send a message."
								operatorTellText = "Operator says: Your message has been given to our office."
							elseif ( key == "San Fierro Vehicle Services" ) then
								operatorAskText = "[DISPATCH] We have a customer from #".. tostring( getCallerNumber( thePlayer ) ) .." requiring our services at number."
								operatorTellText = "Operator says: The personnel has been informed of your request."
							elseif ( key == "San Fierro Taxi Services") then
								operatorAskText = "[DISPATCH] We have a customer from #".. tostring( getCallerNumber( thePlayer ) ) .." in need of a taxi."
								operatorTellText = "Operator says: Thank You, a taxi will be with you shortly."
							end
							
							-- SANE doesn't have Dispatch!
							local dispatch = "DISPATCH"
							if ( key == "San Andreas Network and Entertainment") then
								dispatch = "OFFICE"
							end
							
							-- Taxi Drivers
							if ( key == "San Fierro Taxi Services" ) then
								for index, array in ipairs( getElementsByType("player") ) do
									if ( tonumber( getData( array, "job") ) == 3 ) then
										
										outputChatBox(operatorAskText, array, 0, 100, 255)
										outputChatBox("[".. dispatch .."] Message: ".. message .."", array, 0, 100, 255)
									end	
								end
							else -- PD/FD/SANE/VS
								for index, array in ipairs( getPlayersInTeam( getTeamFromName( key ) ) ) do
			
									outputChatBox(operatorAskText, array, 0, 100, 255)
									outputChatBox("[".. dispatch .."] Message: ".. message .."", array, 0, 100, 255)
									triggerClientEvent ("playDispatchSound", getRootElement())
								end
								
								if ( key == "San Fierro Police Department" ) then
									for index, array in ipairs( getPlayersInTeam( getTeamFromName("San Fierro Fire Department") ) ) do
									
										outputChatBox(operatorAskText, array, 0, 100, 255)
										outputChatBox("[DISPATCH] Message: ".. message .."", array, 0, 100, 255)
										triggerClientEvent ("playDispatchSound", getRootElement())
									end
								end	
							end	
						end	
					end
					
					outputChatBox(operatorTellText, thePlayer, 212, 156, 49)
					outputChatBox("They hungup.", thePlayer, 212, 156, 49)
					
					resetCalling( thePlayer )
				end	
			else
				outputChatBox("SYNTAX: /".. commandName .." [Message]", thePlayer, 212, 156, 49)
			end
		else
			outputChatBox("You're not on a call.", thePlayer, 255, 0, 0)
		end	
	end	
end
addCommandHandler("p", phoneChat, false, false)

function useShortMessageService( thePlayer, commandName, phoneNumber, ... )
	if getData(thePlayer, "loggedin") == 1 and not isPedDead(thePlayer) then
		
		local hasPhone = exports['[ars]inventory-system']:hasItem(thePlayer, 3)
		if ( hasPhone ) then
			
			if (phoneNumber) and (...) then
				
				local phoneNumber = tonumber(phoneNumber)
				local message = table.concat({...}, " ")
				
				local togglephone = tonumber( getData( thePlayer, "togglephone" ) )
				if ( togglephone == 0 ) then
					
					local found = false
					for key, foundPlayer in ipairs( getElementsByType("player") ) do
						if ( getData(foundPlayer, "loggedin" ) == 1 ) then
						
							local hasPhone, matchPhoneNumber = exports['[ars]inventory-system']:hasItem(foundPlayer, 3, phoneNumber)
							if (hasPhone and matchPhoneNumber) then
							
								if ( foundPlayer ~= thePlayer ) then
									
									local togglephone = tonumber( getData( foundPlayer, "togglephone" ) )
									if ( togglephone == 0 ) then
				
										outputChatBox("SMS received from #:".. tostring( getCallerNumber( thePlayer ) ) .." ".. tostring( message ), foundPlayer, 217, 89, 26)
										outputChatBox("SMS sent to #".. phoneNumber ..": ".. tostring( message ), thePlayer, 217, 89, 26)
										
										found = true
										break
									else
										outputChatBox("The phone you're trying to reach is currently switched off.", thePlayer, 212, 156, 49)
										return
									end	
								else
									outputChatBox("You cannot sms yourself.", thePlayer, 255, 0, 0)
								end
							end
						end
					end
					
					if ( not found ) then
						outputChatBox("Unable to contact recepient.", thePlayer, 255, 0, 0)
					end	
				else
					outputChatBox("Your phone is switched off.", thePlayer, 212, 156, 49)
				end	
			else
				outputChatBox("SYNTAX: /".. commandName .." [Phone number] [Message]", thePlayer, 212, 156, 49)
			end
		else
			outputChatBox("You don't have a cellphone.", thePlayer, 255, 0, 0)
		end
	end
end
addEvent("useShortMessageService", true)
addEventHandler("useShortMessageService", root, useShortMessageService)
addCommandHandler("sms", useShortMessageService, false, false)	

function dropPlayerCall( )
	
	local ringing = tonumber( getData( source, "ringing") )
	local calling = tostring( getData( source, "calling") )
	
	if ( ringing == 1 ) or ( calling ~= "0" ) then
		
		if ( lines[calling] == nil ) then
			
			for key, thePlayer in ipairs ( getElementsByType("player") ) do
				if ( tonumber( getData( thePlayer, "dbid") ) == calling ) then
					
					restartPhone( thePlayer )
					outputChatBox("They hung up.", thePlayer, 212, 156, 49)
					
					-- Ringtone
					for key, allPlayer in ipairs ( getElementsByType("player") ) do
						triggerClientEvent(allPlayer, "stopRingtone", allPlayer, thePlayer)	
					end
					break
				end
			end
		end
	end	
end
addEventHandler("onPlayerQuit", root, dropPlayerCall)

function resetCalling( thePlayer )
	setData(thePlayer, "calling", 0, true)
	setData(thePlayer, "pickedup", 0, true)
end	

function restartPhone( thePlayer )

	setData(thePlayer, "calling", 0, true)
	setData(thePlayer, "ringing", 0, true)
	setData(thePlayer, "pickedup", 0, true)
	
	--outputChatBox("Your phone was restarted.", thePlayer, 212, 156, 49)
end
addEvent("restartPhone", true)
addEventHandler("restartPhone", root, restartPhone)
addCommandHandler("restartphone", restartPhone, false, false)

addEventHandler("onResourceStart", resourceRoot,
	function( )
		for key, thePlayer in ipairs ( getElementsByType("player" ) ) do
			triggerEvent("restartPhone", thePlayer, thePlayer )
		end	
	end
)	

function savePlayerWallpaper( wallpaper )
	if ( wallpaper ) then
		local dbid = tonumber( getData(source, "dbid") )
		
		local update = sql:query("UPDATE `characters` SET `wallpaper`=".. sql:escape_string( tonumber( wallpaper ) ) .." WHERE `id`=".. sql:escape_string( dbid ) .."")
		if ( not update ) then
			outputDebugString("MySQL Error: Unable to save wallpaper!")
			outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
		end
		
		sql:free_result(update)
	end	
end
addEvent("savePlayerWallpaper", true)
addEventHandler("savePlayerWallpaper", root, savePlayerWallpaper)

function savePlayerRingtone( ringtone )
	if ( ringtone ) then
		local dbid = tonumber( getData(source, "dbid") )
		
		local update = sql:query("UPDATE `characters` SET `ringtone`=".. sql:escape_string( tonumber( ringtone ) ) .." WHERE `id`=".. sql:escape_string( dbid ) .."")
		if ( not update ) then
			outputDebugString("MySQL Error: Unable to save ringtone!")
			outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
		else
			playerRingtone[source] = tonumber( ringtone )	
		end
		
		sql:free_result(update)
	end	
end
addEvent("savePlayerRingtone", true)
addEventHandler("savePlayerRingtone", root, savePlayerRingtone)

function savePlayerContact( contacts )
	if ( contacts ) then
		local dbid = tonumber( getData(source, "dbid") )
		
		local update = sql:query("UPDATE `characters` SET `contacts`='".. sql:escape_string( tostring( contacts ) ) .."' WHERE `id`=".. sql:escape_string( dbid ) .."")
		if ( not update ) then
			outputDebugString("MySQL Error: Unable to save contacts!")
			outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
		end
		
		sql:free_result(update)
	end	
end
addEvent("savePlayerContact", true)
addEventHandler("savePlayerContact", root, savePlayerContact)

function getPhoneDetails( )
	local dbid = tonumber( getData(source, "dbid") )
	if ( dbid ) then
		
		local details = { }
		
		local result = sql:query_fetch_assoc("SELECT `ringtone`, `wallpaper`, `contacts`, `togphone` FROM `characters` WHERE `id`=".. sql:escape_string( dbid ) .."")
		if ( result ) then
			
			local ringtone = tonumber( result['ringtone'] )
			local wallpaper = tonumber( result['wallpaper'] )
			local contacts = tostring( result['contacts'] )
			local togglephone = tonumber( result['togphone'] )
			
			setData( source, "togglephone", togglephone, true )
			playerRingtone[source] = ringtone
			
			details[dbid] = { ringtone, wallpaper, contacts }
		end	
		
		triggerClientEvent(source, "givePhoneDetails", source, details)
	end	
end
addEvent("getPhoneDetails", true)
addEventHandler("getPhoneDetails", root, getPhoneDetails)

function getCallerNumber( thePlayer )
	local items, values = exports['[ars]inventory-system']:getPlayerInventory( thePlayer )
	local callerNumber = nil

	for i = 1, #items do
		if ( tonumber( items[i] ) == 3 ) then		
			
			callerNumber = tonumber( values[i] )
			break
		end	
	end
	
	return callerNumber
end