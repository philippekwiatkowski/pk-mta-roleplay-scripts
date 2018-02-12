local sql = exports.sql
local salt = "insert here"

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

--------- [ Login Screen ] ---------
function attemptRegister( username, password )
	if username and password then
		
		local username = tostring(username)
		local password = tostring(password)
		local safepassword = string.upper(tostring(md5(salt .. password)))
		
		local result = sql:query_fetch_assoc("SELECT `id` FROM `accounts` WHERE `username`='".. sql:escape_string(tostring(username)) .."'")
		if ( result ) then
			
			triggerClientEvent(source, "showSignInMessage", source, "An account with the given username already exists.", 282)
			return 
		else	
			local update = sql:query("INSERT INTO `accounts` SET `username`='".. sql:escape_string(tostring(username)) .."', `password`='".. sql:escape_string(tostring(safepassword)) .."', `ip`='".. getPlayerIP(source) .."', `registerdate`=NOW()")
			if ( update ) then
				
				triggerClientEvent(source, "showSignInMessage", source, "You successfully registered!", 150)
			else
				
				triggerClientEvent(source, "showSignInMessage", source, "Failed to register your account.", 150)
				outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
			end
			
			sql:free_result(update)
		end
	end
end
addEvent("attemptRegister", true)
addEventHandler("attemptRegister", getRootElement(), attemptRegister)

function attemptLogin( username, password, remember )
	
	local username = tostring(username)
	local password = tostring(password)
	local safepassword = ""
	
	if ( string.len( password ) < 32 ) then -- Not MD5'd
		safepassword = string.upper(tostring(md5(salt .. password))) 
	else
		safepassword = password
	end
	
	if ( remember == 1 ) then
		triggerClientEvent( source, "savePlayerDetails", source, username, safepassword )
	end	
	
	local result = sql:query_fetch_assoc("SELECT * FROM accounts WHERE `username`='".. sql:escape_string(tostring(username)) .."' AND `password`='".. sql:escape_string(tostring(safepassword)) .."'")
	if result then
		
		if tonumber(result['banned']) == 0 then -- they are not banned
			
			local update = sql:query("UPDATE `accounts` SET `lastlogin`=NOW() WHERE `username`='".. sql:escape_string(tostring(username)) .."'")
			if (update) then
				
				triggerEvent("loginPlayer", source, result['username'], result['id'], result['admin'], result['adminduty'], result['hiddenadmin'], result['reports'], result['donator'], result['togpm'], result['tutorial'], result['friends'], result['skinmods'], result['weaponmods'], result['vehiclemods'], true)
			end
			
			sql:free_result(update)
		else -- if they are banned in the database
			local bans = getBans( )
			local nick = result['username']
			local ip = result['ip']
			local found = false
			for k, v in ipairs(bans) do
				if (nick == getBanNick(v) or ip == getBanIP(v)) then
				
					found = true -- they still exist in the banlist.xml
				end
			end	
			
			if (found) then -- ban evading ( perma ban )
				local update = sql:query("UPDATE `accounts` SET `banned`='1', `banned_reason`='Ban Evading', `banned_by`='Console' WHERE `username`='" .. sql:escape_string(tostring(nick)) .. "'")
				if update then
					local ban = banPlayer(source, true, false, false, getRootElement(), "Ban Evading", 0)
				end	
				
				sql:free_result(update)
			else -- unban
				local update = sql:query("UPDATE `accounts` SET `banned`='0', `banned_by`=NULL, `banned_reason`=NULL WHERE `username`='" .. sql:escape_string(tostring(nick)) .. "'")
				sql:free_result(update)
				
				triggerEvent("attemptLogin", source, username, password )
			end	
		end
		
		if ( isElement(source) ) then 
			local update = sql:query("UPDATE `accounts` SET `ip`='".. getPlayerIP(source) .."' WHERE `username`='".. sql:escape_string(tostring(username)) .."'") -- Update their IP
			sql:free_result(update)
		end	
	else
		
		triggerClientEvent(source, "showSignInMessage", source, "Invalid username/password!", 150)
	end
end
addEvent("attemptLogin", true)
addEventHandler("attemptLogin", getRootElement(), attemptLogin)
	
--------- [ Login ] ---------
function onRestart( res )
	
	for i, thePlayer in ipairs ( getElementsByType("player") ) do
		if getData( thePlayer, "loggedin") == 1 then
			
			triggerEvent("savePlayer", thePlayer)
			triggerEvent("onJoin", thePlayer)
			
			setElementPosition(thePlayer, 0, 0, 3)
			setElementAlpha(thePlayer, 0)
		end
	end	
end
addEventHandler("onResourceStart", resourceRoot, onRestart)	

function onJoin( )	
	setData( source, "loggedin", 0, true)
	
	exports['[ars]global']:updateNametagColor( source )
	setPlayerNametagShowing( source, false )
end
addEvent("onJoin", true)
addEventHandler("onJoin", getRootElement(), onJoin)
addEventHandler("onPlayerJoin", getRootElement(), onJoin)