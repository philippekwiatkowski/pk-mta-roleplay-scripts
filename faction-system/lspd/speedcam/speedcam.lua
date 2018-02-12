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

--------- [ Speed Camera ] ---------
local positions = { }
positions[1] = { -139.2421, 1098.4921, 19.5937, "Home St." }
positions[2] = { -193.0390, 1068.6289, 19.7890, "Main St." }
positions[3] = { -23.0917, 1198.2353, 19.2109, "Shelburne Rd." }

local speedCameras = { }

local exceptions = { 
[596] = true, [598] = true, [597] = true, 
[427] = true, [416] = true, [601] = true,
[407] = true, [544] = true, [523] = true
}

function onVehicleColShapeHit( hitElement, matchingDimension )
	if ( matchingDimension ) then
		
		local elementType = getElementType( hitElement )
		if ( elementType == "vehicle" ) then
			
			if ( not exceptions[getElementModel( hitElement )] ) then 
			
				local speedX, speedY, speedZ = getElementVelocity( hitElement )
		
				local realSpeed = (speedX^2 + speedY^2 + speedZ^2)^(0.5) 
				local kmph = math.floor( realSpeed * 180 )
				
				if ( kmph >= 70 ) then
					
					local placeName = ""
					for index, array in ipairs ( speedCameras ) do
						if ( array == source ) then
						
							placeName = tostring( positions[index][4] )
							break
						end
					end
			
					local _, _, rot = getElementRotation( hitElement )
					local rotation = math.floor(rot)
					
					local vehicleDirection = ""
					if ( rotation >= 10 and rotation <= 100 ) then
						vehicleDirection = "West"
					elseif ( rotation > 100 and rotation <= 190 ) then
						vehicleDirection = "South"
					elseif ( rotation > 190 and rotation <= 280 ) then
						vehicleDirection = "East"
					elseif ( rotation > 280 ) then
						vehicleDirection = "North"
					end	
						
					local plate = tostring( getData( hitElement, "plate" ) )
					
					for key, thePlayer in ipairs ( getElementsByType("player") ) do
						if ( getPlayerTeam( thePlayer ) == getTeamFromName("San Fierro Police Department") ) then
							
							outputChatBox("~-~-~-~-~-~-~-~ Speed Camera ~-~-~-~-~-~-~-~", thePlayer, 212, 156, 49)
							outputChatBox(getVehicleName( hitElement ).. " clocked heading ".. vehicleDirection .." bound on ".. placeName, thePlayer, 212, 156, 49)
							outputChatBox("at ".. tostring( kmph ) .." km/h. Plate number, ".. tostring( plate ) ..".", thePlayer, 212, 156, 49)
						end
					end	
				end
			end	
		end	
	end
end
addEventHandler("onColShapeHit", root, onVehicleColShapeHit)

addEventHandler("onResourceStart", resourceRoot,
	function( )
		for key, value in ipairs ( positions ) do
			speedCameras[key] = createColSphere( value[1], value[2], value[3], 7)
		end	
	end
)