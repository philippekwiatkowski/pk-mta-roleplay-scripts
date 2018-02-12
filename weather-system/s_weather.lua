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

local weathers = 
{
	{ 0, "Sunny 1" },
	{ 1, "Sunny 2" },
	{ 2, "Sunny 3" },
	{ 3, "Sunny 4" },
	{ 7, "Sunny 5" },
	{ 40, "Sunny 6" },
	{ 8, "Rainy" },
	{ 10, "Clear" },
	{ 19, "Sand Storm" }
}

local theWeatherID = nil
local theWeatherName = nil

-- CHANGE WEATHER
local nextWeather = nil
function regulateWeather( )
	if ( nextWeather ~= nil ) then
		
		theWeatherID = weathers[nextWeather][1]
		theWeatherName = weathers[nextWeather][2]
		
		local success = setNextWeather( )
		if ( success ) then
			
			for key, value in ipairs( getElementsByType("player" ) ) do
				triggerClientEvent(value, "setPlayerWeather", value, theWeatherID)
			end	
		end	
	else
		local success = setNextWeather( )
		if ( success ) then
			
			regulateWeather( )
		end	
	end
end
addEventHandler("onResourceStart", resourceRoot, regulateWeather)
setTimer( regulateWeather, 3600000, 0 )

-- NEXT WEATHER
function setNextWeather( )
	nextWeather = math.random(1, 8)
	
	if ( nextWeather ) then
		return true
	else
		return false
	end	
end

function getNextWeather( )
	return nextWeather
end
	
-- CURRENT WEATHER	
function getCurrentWeather( clientCall )
	if ( not clientCall ) then
		return theWeatherName, theWeatherID
	else
		triggerClientEvent(source, "setPlayerWeather", source, theWeatherID)
	end	
end
addEvent("getCurrentWeather", true)
addEventHandler("getCurrentWeather", root, getCurrentWeather)

-- ADMIN COMMANDS
function setWeather( thePlayer, commandName, givenWeatherID )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (givenWeatherID) then
			
			local givenWeatherID = tonumber( givenWeatherID )
			if ( givenWeatherID >= 1 and givenWeatherID <= 9 ) then
				
				theWeatherID = weathers[givenWeatherID][1]
				theWeatherName = weathers[givenWeatherID][2]
				
				getNextWeather( )
				
				for key, value in ipairs( getElementsByType("player" ) ) do
					triggerClientEvent(value, "setPlayerWeather", value, theWeatherID)
				end	
				
				outputChatBox("The weather was set to '".. tostring(theWeatherName) .."'.", thePlayer, 212, 156, 49)
			else
				for key, value in ipairs ( weathers ) do
					outputChatBox(tostring( key ) .." - ".. value[2], thePlayer, 212, 156, 49)
				end	
				
				outputChatBox("Weather ID can only be between 1 and 9.", thePlayer, 212, 156, 49)
			end	
		else
			outputChatBox("SYNTAX: /".. commandName .." [Weather ID]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("setweather", setWeather, false, false)