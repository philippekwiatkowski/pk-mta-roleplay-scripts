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

--------- [ Photograph Selling ] ---------
function sellPhotographs( moneyEarned )
	local moneyEarned = tonumber( moneyEarned )*100
	
	if ( moneyEarned ~= 0 ) then
		
		local result = sql:query_fetch_assoc("SELECT `balance` FROM `factions` WHERE `id`='3'")
		if ( result ) then
			
			local balance = tonumber( result['balance'] )
			local totalLoose = balance - moneyEarned
		
			local update = sql:query("UPDATE `factions` SET `balance`=".. sql:escape_string(totalLoose) .." WHERE `id`='3'")
			if ( not update ) then
			
				outputDebugString("MySQL Error: Unable to update SAN money!", 1)
				outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
			else
				local realEarned = moneyEarned / 100
				
				outputChatBox("You earned $".. realEarned .." for your pictures.", source, 212, 156, 49)
				
				givePlayerMoney( source, moneyEarned )
				setData( getTeamFromName("San Andreas Network and Entertainment"), "balance", totalLoose, true)
			end
		end	
	else
		outputChatBox("You do not have any photos to sell.", source, 255, 0, 0)
	end	
end
addEvent("sellPhotographs", true)
addEventHandler("sellPhotographs", root, sellPhotographs)