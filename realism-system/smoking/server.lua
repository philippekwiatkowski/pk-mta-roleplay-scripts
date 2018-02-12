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

--------- [ Smoking System ] ---------	

-- Exported function
function smokeCigarette( thePlayer )
	if ( thePlayer ) then
		
		setData( thePlayer, "smoking_thing", 1, true )
		setData( thePlayer, "smoking_true", 1, true ) 
	end		
end

-- /throwcig
function throwCigarette( thePlayer, commandName )
	if ( thePlayer ) then
		
		setData( thePlayer, "smoking_thing", 0, true )
		setData( thePlayer, "smoking_true", 0, true )
	end	
end
addCommandHandler("throwcig", throwCigarette)

-- /switchhand
function switchCigaretteHand( thePlayer, commandName )
	
	local lefthand = tonumber( getData( thePlayer, "smoking_lefthand" ) )
	if ( lefthand == 1 ) then -- Switch to right hand
	
		setData( thePlayer, "smoking_lefthand", 0, true)
	else					  -- Switch to left hand
		setData( thePlayer, "smoking_lefthand", 1, true)
	end	
end
addCommandHandler("switchhand", switchCigaretteHand)

-- Resource Start
function setSmokingData( )
	for key, thePlayer in ipairs( getElementsByType("player") ) do

		setData( thePlayer, "smoking_true", 0, true )
		setData( thePlayer, "smoking_thing", 0, true )
		setData( thePlayer, "smoking_lefthand", 0, true )
	end
end
addEventHandler("onResourceStart",  resourceRoot, setSmokingData)