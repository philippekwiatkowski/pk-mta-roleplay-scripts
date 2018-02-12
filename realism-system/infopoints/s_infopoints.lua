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
	local value = tonumber(value) or tostring(value)
	if isElement(theElement) and (key) and (value) then
		
		return exports['[ars]anticheat-system']:assignData( theElement, tostring(key), value, sync )
	else
		return false
	end	
end

local info = { }

function createinfo(thePlayer, commandName, ...)
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		if (...)  then
			local x, y, z = getElementPosition(thePlayer)
			local interior = getElementInterior(thePlayer)
			local dimension = getElementDimension(thePlayer)
			
			local text = table.concat({...}, " ")
			local placer = getPlayerName(thePlayer):gsub("_", " ")
			
			local insert = sql:query("INSERT INTO `infopoints` SET `x`=".. sql:escape_string(x) ..", y=".. sql:escape_string(y) ..", z=".. sql:escape_string(z)..", `interior`=".. sql:escape_string(interior) ..", `dimension`=".. sql:escape_string(dimension) ..", `text`='".. sql:escape_string(text) .."', placer='".. sql:escape_string(placer) .."'")
			if ( insert ) then
				
				local pickup = createPickup(x, y, z, 3, 1239)
				
				setElementInterior(pickup, interior)
				setElementDimension(pickup, dimension)
				
				local id = tonumber( sql:insert_id() )
				info[id] = { text, x, y, z, pickup, placer }
				
				outputChatBox("Infopoint created with ID #" .. id .. ".", thePlayer, 0, 255, 0, 0)
			end

			sql:free_result(insert)
		else
			outputChatBox("SYNTAX: /createinfo [Text]", thePlayer, 212, 156, 49)
		end
	else
		outputChatBox("Please request an Administrator to create an information point.", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("createinfo", createinfo, false, false)

function nearbyInfo(thePlayer)
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		local count = 0
		outputChatBox("Infopoints Nearby:", thePlayer, 212, 156, 49)
		local px, py, pz = getElementPosition(thePlayer)
		for key, value in pairs(info) do
			local text = info[key][1]
			local x = info[key][2]
			local y = info[key][3]
			local z = info[key][4]
			local placer = info[key][6]
			
			if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) < 50) and getElementDimension(thePlayer) == getElementDimension(value[5]) then
				count = count + 1
				outputChatBox("Infopoint created by " .. placer .. " with ID #" .. key .. ": ", thePlayer, 212, 156, 49)
				outputChatBox(text, thePlayer, 212, 156, 49)
			end
		end
		
		if (count == 0) then
			outputChatBox("No infopoints nearby.", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("nearbyinfo", nearbyInfo)
addCommandHandler("nearbyinfos", nearbyInfo)

function deleteInfo(thePlayer, commandName, id)
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		if ( not id ) then
			outputChatBox("SYNTAX: /delinfo [Infopoint ID]", thePlayer, 212, 156, 49)
		else
			local id = tonumber( id )
			
			if ( info[id] == nil ) then
				outputChatBox("No infopoint with such ID exist.", thePlayer, 255, 0, 0)
			else
				local pickup = info[tonumber(id)][5]
				
				local delete = sql:query("DELETE FROM `infopoints` WHERE `id`=".. sql:escape_string(id))
				if ( delete ) then
				
					destroyElement( pickup )
					info[id] = nil
					
					outputChatBox("Infopoint with ID #" .. id .. " was deleted.", thePlayer, 0, 255, 0)
				end	
				
				sql:free_result(delete)
			end
		end
	end
end
addCommandHandler("delinfo", deleteInfo)

function displayText( pickup )
	if ( getElementDimension( source ) == getElementDimension( pickup ) ) and ( getPickupType( pickup ) == 3 ) then

		for key, value in pairs ( info ) do
			if ( value[5] == pickup ) then
	
				local text = tostring( value[1] )
				outputChatBox(" * ".. text .." (( Infopoint #" .. key .. " ))", source, 127, 88, 205)
				
				break
			end
		end
	end	
	
	cancelEvent( )
end
addEventHandler("onPlayerPickupHit", getRootElement(), displayText)

function spawnInfopoints( )
	
	local result = sql:query("SELECT * FROM `infopoints`")
	while true do
		local row = sql:fetch_assoc(result)
		
		if ( not row ) then
			break
		end
		
		local id = tonumber( row['id'] )
		local x = tonumber( row['x'] )
		local y = tonumber( row['y'] )
		local z = tonumber( row['z'] )
		local interior = tonumber( row['interior'] )
		local dimension = tonumber( row['dimension'] )
		local text = tostring( row['text'] )
		local placer = tostring( row['placer'] )
		
		local pickup = createPickup(x, y, z, 3, 1239)
		
		setElementInterior(pickup, interior)
		setElementDimension(pickup, dimension)
		
		info[id] = { text, x, y, z, pickup, placer }
	end
	
	sql:free_result(result)
end
addEventHandler("onResourceStart", resourceRoot, spawnInfopoints)	