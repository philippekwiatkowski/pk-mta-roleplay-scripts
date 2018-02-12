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

--------- [ Player IDs ] ---------
local playerID = { }
addEventHandler("onPlayerJoin", root,
	function( )
		local slot = nil
		
		for i = 1, 128 do
			if ( playerID[ i ] == nil ) then
				
				slot = i
				break
			end
		end
		
		playerID[slot] = source
		setData(source, "playerid", tonumber(slot), true)
	end
)

addEventHandler("onPlayerQuit", root,
	function ( )
		local slot = tonumber( getData(source, "playerid") )
		if ( slot ) then
			
			playerID[slot] = nil
		end
	end
)

addEventHandler("onResourceStart", resourceRoot,
	function( )
		for i, thePlayer in ipairs( getElementsByType("player") ) do
			
			playerID[ i ] = thePlayer
			setData( thePlayer, "playerid", tonumber( i ), true)
		end
	end
)