--------- [ Element Data returns ] ---------
local function getData( theElement, key )
	local key = tostring(key)
	if isElement(theElement) and (key) then
		
		return exports['[ars]anticheat-system']:callData( theElement, tostring(key) )
	else
		return false
	end
end

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