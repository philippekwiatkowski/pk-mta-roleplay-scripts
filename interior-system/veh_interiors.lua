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

--------- [ Interior Spawn ] ---------
function startVehicleInteriors( )
	for key, theVehicle in ipairs ( getElementsByType("vehicle") ) do
		if ( getElementModel( theVehicle ) == 508 ) then -- Journey
		
			createVehicleInterior( theVehicle )
		end
	end	
end
addEventHandler("onResourceStart", resourceRoot, startVehicleInteriors)

function createVehicleInterior( theVehicle )
	if ( theVehicle ) then
		
		local interiorID = tonumber( getData( theVehicle, "dbid" ) )
		local vehicleFaction = tonumber( getData( theVehicle, "faction" ) )
		local vehicleOwner = tonumber( getData( theVehicle, "owner" ) )
		if ( interiorID < 0 ) or ( vehicleOwner <= 0 ) or ( vehicleFaction > 0 ) then
			
			return
		else	
			local interiorOwner = getData( theVehicle, "owner" )
			
			local interiorLocked = 0
			if isVehicleLocked( theVehicle ) then
				interiorLocked = 1
			end	
			
			local entranceDimension = getElementDimension( theVehicle )
			local entranceInterior = getElementInterior( theVehicle )
			
			local exitInterior = 1
			local exitDimension = interiorID
			
			-- Pre-defined
			local interiorType = 1
			local interiorName = "Journey Trailer"
			local interiorPrice = 0
			local interiorRented = 0
			
			-- Entrance
			local entranceMarker = createMarker(0, 0, 3, "cylinder", 1.5, 255, 255, 255, 50)
			attachElements( entranceMarker, theVehicle, 1.5, 0.25, -1, 0, 0, 0 )
			
			setElementDimension( entranceMarker, entranceDimension )
			setElementInterior( entranceMarker, entranceInterior )
			
			setData( entranceMarker, "name", tostring( interiorName ), true )
			setData( entranceMarker, "owner", tonumber( interiorOwner ), true )
			setData( entranceMarker, "dbid", tonumber( -interiorID ), true )
			setData( entranceMarker, "type", tonumber( interiorType ), true )
			setData( entranceMarker, "locked", tonumber( interiorLocked ), true )
			setData( entranceMarker, "price", tonumber( interiorPrice ), true )
			setData( entranceMarker, "rented", tonumber( interiorRented ), true )
			setData( entranceMarker, "elevator", 0, true )
			
			-- Exit
			local exitMarker = createMarker( 1930.1464, -2379.3242, 12.7187, "cylinder", 2, 255, 255, 255, 50)
			setElementDimension( exitMarker, exitDimension )
			setElementInterior( exitMarker, exitInterior )
			
			setData( exitMarker, "name", tostring( interiorName ), true )
			setData( exitMarker, "owner", tonumber( interiorOwner ), true )
			setData( exitMarker, "dbid", tonumber( -interiorID ), true )
			setData( exitMarker, "type", tonumber( interiorType ), true )
			setData( exitMarker, "locked", tonumber( interiorLocked ), true )
			setData( exitMarker, "price", tonumber( interiorPrice ), true )
			setData( exitMarker, "rented", tonumber( interiorRented ), true )
			setData( exitMarker, "elevator", 0, true )
		
			setElementParent( exitMarker, entranceMarker )
			
			-- Add Interior
			addInteriorToDimension( exitDimension )
		end	
	end
end