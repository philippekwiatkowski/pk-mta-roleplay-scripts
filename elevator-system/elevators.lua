local sql = exports.sql
local elevators = { }

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

--------- [ Admin Commands] ---------

-- /makeelevator
-- /delelevator
-- /nearbyelevators

-- /makeelevator
function makeElevator( thePlayer, commandName, x, y, z, int, dim, vehicle )
	if ( getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerAdministrator(thePlayer) ) then	
		
		if ( x and y and z and int and dim and vehicle ) then
			
			local x, y, z = tonumber( x ), tonumber( y ), tonumber( z )
			local int = tonumber( int )
			local dim = tonumber( dim )
			local vehicle = tonumber( vehicle )
			
			if ( vehicle == 1 or vehicle == 0 ) then
				
				local entX, entY, entZ = getElementPosition( thePlayer )
				local entInt = getElementInterior( thePlayer )
				local entDim = getElementDimension( thePlayer )
				local rotation = getElementRotation( thePlayer )
				
				entX = entX + ( ( math.sin( math.rad( rotation ) ) ) * 0.1 )
				entY = entY + ( ( math.cos( math.rad( rotation ) ) ) * 0.1 )
				
				local insert = sql:query("INSERT INTO `elevators` SET `parentid`=".. sql:escape_string(dim) ..", `entx`=".. sql:escape_string(entX) ..", `enty`=".. sql:escape_string(entY) ..", `entz`=".. sql:escape_string(entZ) ..", `entint`=".. sql:escape_string(entInt) ..", `entdim`=".. sql:escape_string(entDim) ..", `x`=".. sql:escape_string(x) ..", `y`=".. sql:escape_string(y) ..", `z`=".. sql:escape_string(z) ..", `int`=".. sql:escape_string(int) ..", `vehicle`=".. sql:escape_string(vehicle) .."")
				if ( insert ) then
					
					local dbid = sql:insert_id()
					
					local interior = getParentInterior( dim )
		
					local name = tostring( getData( interior, "name" ) )
					local owner = tonumber( getData( interior, "owner" ) )
					local type = tonumber( getData( interior, "type" ) )
					local price = tonumber( getData( interior, "price" ) )
					local rented = tonumber( getData( interior, "rented" ) )
					
					local r, g, b = 255, 255, 255
					
					local size = 2
					if ( vehicle == 1 ) then
						size = 3
					end
					
					-- Create outside elevator
					local entranceElevator = createMarker(entX, entY, entZ-1, "cylinder", size, r, g, b, 50)
					setElementDimension(entranceElevator, entDim)
					setElementInterior(entranceElevator, entInt)
					
					setData(entranceElevator, "name", tostring(name), true)
					setData(entranceElevator, "owner", tonumber(owner), true)
					setData(entranceElevator, "dbid", tonumber(dbid), true)
					setData(entranceElevator, "type", tonumber(type), true)
					setData(entranceElevator, "locked", 0, true)
					setData(entranceElevator, "price", tonumber(price), true)
					setData(entranceElevator, "rented", tonumber(rented), true)
					setData(entranceElevator, "elevator", 1, true)
					
					-- Create inside elevator
					local exitElevator = createMarker(x, y, z-1, "cylinder", size, r, g, b, 50)
					setElementDimension(exitElevator, dim)
					setElementInterior(exitElevator, int)
					
					setData(exitElevator, "name", tostring(name), true)
					setData(exitElevator, "owner", tonumber(owner), true)
					setData(exitElevator, "dbid", tonumber(dbid), true)
					setData(exitElevator, "type", tonumber(type), true)
					setData(exitElevator, "locked", 0, true)
					setData(exitElevator, "price", tonumber(price), true)
					setData(exitElevator, "rented", tonumber(rented), true)
					setData(exitElevator, "elevator", 1, true)
					
					setElementParent(exitElevator, entranceElevator)
				else
					outputDebugString("MySQL Error: Unable to create elevator!")
					outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
				end
				
				sql:free_result(insert)
			else
				outputChatBox("The value of vehicle can only be 1 ( allowed ) or 0 ( not allowed ).", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [X] [Y] [Z] [Interior] [Dimension] [Vehicle 1/0]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("makeelevator", makeElevator, false, false)	

-- /delelevator
function deleteElevator( thePlayer, commandName, elevatorID )
	if ( getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerAdministrator(thePlayer) ) then
		
		if ( elevatorID ) then
			local elevatorID = tonumber( elevatorID )
			
			local found = false
			for key, value in ipairs( getElementsByType("marker") ) do
				local elevator = tonumber( getData(value, "elevator") )
				local dbid = tonumber( getData(value, "dbid") )
				
				if ( elevator == 1 and dbid == elevatorID and getElementChild( value, 0 ) ) then
					
					destroyElement(value)
					found = true
					break
				end
			end
				
			local delete = sql:query("DELETE FROM `elevators` WHERE `id`=".. sql:escape_string(elevatorID) .."")
			if ( not delete ) then
				
				outputDebugString("MySQL Error: Unable to delete elevator!")
				outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
			else	
				outputChatBox("Deleted elevator with ID: ".. elevatorID, thePlayer, 0, 255, 0)
			end	
			
			sql:free_result(delete)
		else
			outputChatBox("SYNTAX: /".. commandName .." [ Elevator ID ]", thePlayer, 212, 156, 49)
		end	
	end		
end
addCommandHandler("delelevator", deleteElevator, false, false)	
	
-- /nearbyelevators
function nearbyElevators( thePlayer, commandName )
	if ( getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerModerator(thePlayer) ) then	
		
		local count = 0
		outputChatBox("~-~-~-~-~-~ Nearby Elevators ~-~-~-~-~-~", thePlayer, 212, 156, 49)
		
		for key, value in ipairs (getElementsByType("marker")) do
			
			local elevator = tonumber( getData( value, "elevator") )
			if ( elevator == 1 ) then
				
				local x, y, z = getElementPosition(value)
				local interior, dimension = getElementInterior(value), getElementDimension(value)
				
				local playerX, playerY, playerZ = getElementPosition(thePlayer)
				local playerInt, playerDim = getElementInterior(thePlayer), getElementDimension(thePlayer)
	
				if ( playerInt == interior )and ( playerDim == dimension ) and ( getDistanceBetweenPoints3D( x, y, z, playerX, playerY, playerZ ) <= 10 ) then
					
					count = count + 1
					outputChatBox("#".. tostring(count) .." - ID: ".. tostring(getData(value, "dbid")) ..", Name: ".. tostring(getData(value, "name")) ..", Owner: ".. tostring(getInteriorOwnerName(tonumber(getData(value, "owner")))), thePlayer, 212, 156, 49)
				end
			end	
		end
			
		if (count == 0) then
			outputChatBox("Couldn't find any elevators nearby you.", thePlayer, 255, 0, 0)
		end	
	end
end
addCommandHandler("nearbyelevators", nearbyElevators, false, false)
	
-- /setelevatorentrance
function setElevatorEntrance( thePlayer, commandName, elevatorID )
	if ( getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerAdministrator(thePlayer) ) then	
		
		if (elevatorID) then
			
			local elevatorID = tonumber(elevatorID)
			
			local x, y, z = getElementPosition( thePlayer )
			local int, dim = getElementInterior( thePlayer ), getElementDimension( thePlayer )

			for key, value in ipairs (getElementsByType("marker")) do
				if ( tonumber( getData( value, "dbid" ) ) == elevatorID ) then  -- Look for an interior in the given dimension
					
					local parent = getElementParent( value )			-- Find its parent
					local elevator = tonumber( getData( parent, "elevator" ) )
					if ( parent and elevator == 1 ) then
						
						local child = getElementChild( parent, 0 )
						local cx, cy, cz = getElementPosition( child )
						local cint, cdim = getElementInterior( child ), getElementDimension( child )
						
						setElementPosition(parent, x, y, z - 1)
						setElementInterior(parent, int)
						setElementDimension(parent, dim)
						
						setElementPosition(child, cx, cy, cz)
						setElementInterior(child, cint)
						setElementDimension(child, cdim)
						
						outputChatBox("Changed elevator entrance. (".. elevatorID ..")", thePlayer, 0, 255, 0)
						
						found = true
						break
					end
				end	
			end	

			if (not found) then
				outputChatBox("Couldn't find elevator with ID ".. tostring(elevatorID) ..".", thePlayer, 255, 0, 0)
			else	
				local update = sql:query("UPDATE `elevators` SET `entx`=".. sql:escape_string( tonumber(x) ) ..", `enty`=".. sql:escape_string( tonumber(y) ) ..", `entz`=".. sql:escape_string( tonumber(z) ) ..", `entdim`=".. sql:escape_string( tonumber(dim) )..", `entint`=".. sql:escape_string( tonumber(int) ) .." WHERE `id`=".. sql:escape_string( tonumber(elevatorID) ) .."")
				if ( not update ) then
					outputDebugString("MySQL Error: Unable to set elevator exit!")
					outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
				end	
				
				sql:free_result(update)
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Elevator ID]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("setelevatorentrance", setElevatorEntrance, false, false)	

-- /setelevatorexit
function setElevatorExit( thePlayer, commandName, elevatorID )
	if ( getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerAdministrator(thePlayer) ) then	
		
		if (elevatorID) then
			
			local elevatorID = tonumber(elevatorID)
			
			local x, y, z = getElementPosition( thePlayer )
			local int, dim = getElementInterior( thePlayer ), getElementDimension( thePlayer )

			for key, value in ipairs (getElementsByType("marker")) do
				if ( tonumber( getData( value, "dbid" ) ) == elevatorID ) then  -- Look for an interior in the given dimension
					
					local parent = getElementParent( value )					-- Find its parent
					local elevator = tonumber( getData( parent, "elevator" ) )
					if ( parent and elevator == 1 ) then
						
						setElementPosition(value, x, y, z - 1)
						setElementInterior(value, int)
						setElementDimension(value, dim)
						
						outputChatBox("Changed elevator exit. (".. elevatorID ..")", thePlayer, 0, 255, 0)
						
						found = true
						break
					end
				end	
			end	

			if (not found) then
				outputChatBox("Couldn't find elevator with ID ".. tostring(elevatorID) ..".", thePlayer, 255, 0, 0)
			else	
				local update = sql:query("UPDATE `elevators` SET `x`=".. sql:escape_string( tonumber(x) ) ..", `y`=".. sql:escape_string( tonumber(y) ) ..", `z`=".. sql:escape_string( tonumber(z) ) ..", `dim`=".. sql:escape_string( tonumber(dim) )..", `int`=".. sql:escape_string( tonumber(int) ) .." WHERE `id`=".. sql:escape_string( tonumber(elevatorID) ) .."")
				if ( not update ) then
					outputDebugString("MySQL Error: Unable to set elevator exit!")
					outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
				end	
				
				sql:free_result(update)
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Elevator ID]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("setelevatorexit", setElevatorExit, false, false)
	
-- INTERIOR OWNER NAME
function getInteriorOwnerName( dbid )
	local result = sql:query_fetch_assoc("SELECT `charactername` FROM `characters` WHERE `id`=".. sql:escape_string(tonumber(dbid)) .."")
	if (result) then
		
		local name = tostring(result['charactername'])
		return name
	else
		return "None"
	end
end
	
addEvent("reloadElevator", true)
addEventHandler("reloadElevator", root,
	function( elevator )
		local dbid = tonumber(getData(elevator, "dbid"))
		
		destroyElement(elevator)
		
		local row = sql:query_fetch_assoc("SELECT `id`, `parentid`, `entx`, `enty`, `entz`, `entdim`, `entint`, `x`, `y`, `z`, `int`, `locked`, `vehicle` FROM `elevators` WHERE `id`=".. sql:escape_string(dbid) .."")
		
		local parentID = tonumber( row['parentid'] )
		local entX = tonumber( row['entx'] )
		local entY = tonumber( row['enty'] )
		local entZ = tonumber( row['entz'] )
		local entDim = tonumber( row['entdim'] )
		local entInt = tonumber( row['entint'] )
		local x = tonumber( row['x'] )
		local y = tonumber( row['y'] )
		local z = tonumber( row['z'] )
		local int = tonumber( row['int'] )
		local locked = tonumber( row['locked'] )
		local vehicle = tonumber( row['vehicle'] )
		
		local interior = getParentInterior( parentID )
		
		local name = tostring( getData( interior, "name" ) )
		local owner = tonumber( getData( interior, "owner" ) )
		local type = tonumber( getData( interior, "type" ) )
		local price = tonumber( getData( interior, "price" ) )
		local rented = tonumber( getData( interior, "rented" ) )
		
		local r, g, b = 255, 255, 255
		
		local size = 2
		if ( vehicle == 1 ) then
			size = 3
		end
		
		-- Create outside elevator
		local entranceElevator = createMarker(entX, entY, entZ-1, "cylinder", size, r, g, b, 50)
		setElementDimension(entranceElevator, entDim)
		setElementInterior(entranceElevator, entInt)
		
		setData(entranceElevator, "name", tostring(name), true)
		setData(entranceElevator, "owner", tonumber(owner), true)
		setData(entranceElevator, "dbid", tonumber(dbid), true)
		setData(entranceElevator, "type", tonumber(type), true)
		setData(entranceElevator, "locked", tonumber(locked), true)
		setData(entranceElevator, "price", tonumber(price), true)
		setData(entranceElevator, "rented", tonumber(rented), true)
		setData(entranceElevator, "elevator", 1, true)
		
		-- Create inside elevator
		local exitElevator = createMarker(x, y, z-1, "cylinder", size, r, g, b, 50)
		setElementDimension(exitElevator, parentID)
		setElementInterior(exitElevator, int)
		
		setData(exitElevator, "name", tostring(name), true)
		setData(exitElevator, "owner", tonumber(owner), true)
		setData(exitElevator, "dbid", tonumber(dbid), true)
		setData(exitElevator, "type", tonumber(type), true)
		setData(exitElevator, "locked", tonumber(locked), true)
		setData(exitElevator, "price", tonumber(price), true)
		setData(exitElevator, "rented", tonumber(rented), true)
		setData(exitElevator, "elevator", 1, true)
		
		setElementParent(exitElevator, entranceElevator)
	end
)	

local loaded = false
function loadElevators( )
	if ( not loaded ) then
	
		local result = sql:query("SELECT `id`, `parentid`, `entx`, `enty`, `entz`, `entdim`, `entint`, `x`, `y`, `z`, `int`, `locked`, `vehicle` FROM `elevators`")
		while true do
			
			local row = sql:fetch_assoc(result)
			if ( not row ) then
				break
			end
			
			local dbid = tonumber( row['id'] )
			local parentID = tonumber( row['parentid'] )
			local entX = tonumber( row['entx'] )
			local entY = tonumber( row['enty'] )
			local entZ = tonumber( row['entz'] )
			local entDim = tonumber( row['entdim'] )
			local entInt = tonumber( row['entint'] )
			local x = tonumber( row['x'] )
			local y = tonumber( row['y'] )
			local z = tonumber( row['z'] )
			local int = tonumber( row['int'] )
			local locked = tonumber( row['locked'] )
			local vehicle = tonumber( row['vehicle'] )
			
			local interior = getParentInterior( parentID )
			
			local name = tostring( getData( interior, "name" ) )
			local owner = tonumber( getData( interior, "owner" ) )
			local type = tonumber( getData( interior, "type" ) )
			local price = tonumber( getData( interior, "price" ) )
			local rented = tonumber( getData( interior, "rented" ) )
			
			local r, g, b = 255, 255, 255
			
			local size = 2
			if ( vehicle == 1 ) then
				size = 3
			end
			
			-- Create outside elevator
			local entranceElevator = createMarker(entX, entY, entZ-1, "cylinder", size, r, g, b, 100)
			setElementDimension(entranceElevator, entDim)
			setElementInterior(entranceElevator, entInt)
			
			setData(entranceElevator, "name", tostring(name), true)
			setData(entranceElevator, "owner", tonumber(owner), true)
			setData(entranceElevator, "dbid", tonumber(dbid), true)
			setData(entranceElevator, "type", tonumber(type), true)
			setData(entranceElevator, "locked", tonumber(locked), true)
			setData(entranceElevator, "price", tonumber(price), true)
			setData(entranceElevator, "rented", tonumber(rented), true)
			setData(entranceElevator, "elevator", 1, true)
			
			-- Create inside elevator
			local exitElevator = createMarker(x, y, z-1, "cylinder", size, r, g, b, 100)
			setElementDimension(exitElevator, parentID)
			setElementInterior(exitElevator, int)
			
			setData(exitElevator, "name", tostring(name), true)
			setData(exitElevator, "owner", tonumber(owner), true)
			setData(exitElevator, "dbid", tonumber(dbid), true)
			setData(exitElevator, "type", tonumber(type), true)
			setData(exitElevator, "locked", tonumber(locked), true)
			setData(exitElevator, "price", tonumber(price), true)
			setData(exitElevator, "rented", tonumber(rented), true)
			setData(exitElevator, "elevator", 1, true)
			
			setElementParent(exitElevator, entranceElevator)
		end
		
		sql:free_result(result)
		loaded = true
	end	
end
addEvent("onInteriorsLoad", true)
addEventHandler("onInteriorsLoad", root, loadElevators)

addEventHandler("onResourceStart", resourceRoot,
	function( )
		
		local interiorSystem = getResourceFromName("[ars]interior-system")
		if ( interiorSystem ) then
			
			local state = getResourceState( interiorSystem )
			if ( state == "loaded" or state == "stopped" ) then
				
				outputDebugString("Unable to start Elevator System, Interior System is not running.")
			else
				setTimer( loadElevators, 6000, 1 )
				outputDebugString("Loading Elevators...")
			end
		end
	end
)
	
function getParentInterior( parentID )
	for key, value in ipairs ( getElementsByType("marker") ) do
		if ( tonumber( getData( value, "dbid" ) ) == parentID and isElement( getElementChild( value, 0 ) ) ) then
			
			return value
		end	
	end	
end