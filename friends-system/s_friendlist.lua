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
	if isElement(theElement) and (key) and (value) then
		
		return exports['[ars]anticheat-system']:assignData( theElement, tostring(key), value, sync )
	else
		return false
	end	
end

--------- [ Friend System ] ---------
function getPlayerFriends( thePlayer )
	if ( thePlayer ) then
		
		local theFriends = { }
		
		local clientFriends = tostring( getData( thePlayer, "friends") )
		if ( clientFriends ~= "none" ) then
			
			local country = tostring( exports['[ars]global']:getPlayerCountryByIP( getPlayerIP( thePlayer ), true ) )
		
			local t = split( clientFriends, "," )
			for key, value in ipairs ( t ) do
				
				local result = sql:query_fetch_assoc("SELECT `username`, `ip`, DATEDIFF(NOW(), `lastlogin`) as `llastlogin`, `banned` FROM accounts WHERE id=".. sql:escape_string( tonumber( value ) ).."")
				if ( result ) then
					
					local username = tostring( result['username'] )
					local lastlogin = tostring( result['llastlogin'] )
					local banned = tonumber( result['banned'] )
					local ip = tostring( result['ip'] )
					
					local friendCountry = tostring( exports['[ars]global']:getPlayerCountryByIP( ip, true ) )
					
					local sameCountry = "false"
					if ( country == friendCountry ) then
						sameCountry = "true"
					end
					
					theFriends[key] = { username, friendCountry, sameCountry, lastlogin, banned }
				end
			end
		end
		
		triggerClientEvent(thePlayer, "showPlayerFriendlist", thePlayer, theFriends )
	end	
end
addCommandHandler("friends", getPlayerFriends, false, false)	

function bindShortcutKey( res )
	if ( res ) then
		for key, thePlayer in ipairs ( getElementsByType("player") ) do
			
			bindKey(thePlayer, "o", "down", getPlayerFriends)
		end
	else
		bindKey(source, "o", "down", getPlayerFriends)
	end	
end
addEventHandler("onPlayerJoin", root, bindShortcutKey)
addEventHandler("onResourceStart", resourceRoot, bindShortcutKey)