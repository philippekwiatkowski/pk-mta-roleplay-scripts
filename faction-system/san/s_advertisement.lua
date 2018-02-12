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

function sendAdvertisement( advert )
	local advert = tostring( advert )
	
	for key, value in ipairs ( getElementsByType("player") ) do
		if ( getData( value, "loggedin" ) == 1 ) then
			
			outputChatBox("[ADVERT] ".. advert .." (( ".. getPlayerName(source):gsub("_", " ") .." ))", value, 177, 120, 29) 
		end
	end
end
addEvent("sendAdvertisement", true)
addEventHandler("sendAdvertisement", root, sendAdvertisement)

function giveMoneyToSan( amount )
	local amount = tonumber( amount )*100
	
	local result = sql:query_fetch_assoc("SELECT `balance` FROM `factions` WHERE `id`='3'")
	if ( result ) then
	
		local balance = tonumber( result['balance'] )
		local totalEarned = balance + amount
		
		local update = sql:query("UPDATE `factions` SET `balance`=".. sql:escape_string(totalEarned) .." WHERE `id`='3'")
		if ( not update ) then	
			outputDebugString("MySQL Error: Unable to update SAN money!", 1)
			outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
		else
			takePlayerMoney(source, amount)
			setData( getTeamFromName("San Andreas Network and Entertainment"), "balance", totalEarned, true)
		end	
		
		sql:free_result(update)
	end	
end
addEvent("giveMoneyToSan", true)
addEventHandler("giveMoneyToSan", root, giveMoneyToSan)	