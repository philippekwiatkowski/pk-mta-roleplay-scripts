local sql = exports.sql
local clients = { }

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

-- /makeinterior 
-- /delinterior 
-- /nearbyinteriors 
-- /setinteriorname 
-- /setinteriorprice 
-- /setinteriortype 
-- /tptointerior 
-- /setinteriorid
-- /setinteriorentrance
-- /setinteriorexit
-- /sellproperty

-- /makeinterior
function makeInterior( thePlayer, commandName, interiorid, interiorprice, interiortype, interiorrented, ... )
	if ( getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerAdministrator(thePlayer) ) then
		
		if (interiorid) and (...) and (interiorprice) and (interiortype) and (interiorrented) then
			
			local interiorid = tonumber(interiorid)
			if (interiorid >= 1) then
				
				local interiortype = tonumber(interiortype)
				if (interiortype >= 1) and (interiortype <= 3) then
					
					local interiorrented = tonumber(interiorrented)
					if ( interiorrented == 1 or interiorrented == 0 ) then
					
						local interiorname = tostring(table.concat({...}, " "))
						local interiorprice = tonumber(interiorprice)
							
						local t = interiors[interiorid]
							
						local int = t[1]
						local x, y, z = t[2], t[3], t[4]
							
						local entX, entY, entZ = getElementPosition(thePlayer)
						local entInt = getElementInterior(thePlayer)
						local entDim = getElementDimension(thePlayer)
						local rotation = getPedRotation(thePlayer)
							
						entX = entX + ( ( math.sin( math.rad( rotation ) ) ) * 0.1 )
						entY = entY + ( ( math.cos( math.rad( rotation ) ) ) * 0.1 )
					
						local insert = sql:query("INSERT INTO interiors SET `name`='".. sql:escape_string(interiorname) .."', price=".. sql:escape_string(interiorprice) ..", entx=".. sql:escape_string(entX) ..", enty=".. sql:escape_string(entY) ..", entz=".. sql:escape_string(entZ-1) ..", x=".. sql:escape_string(x) ..", y=".. sql:escape_string(y) ..", z=".. sql:escape_string(z) ..", entdim=".. sql:escape_string(entDim) ..", entint=".. sql:escape_string(entInt) ..", `int`=".. sql:escape_string(int) ..", `owner`='-1', `type`=".. sql:escape_string(interiortype) ..", `rent`=".. sql:escape_string(interiorrented) .."")
						if (insert) then
							local dbid = sql:insert_id()
							
							local r, g, b = 255, 255, 255
							local type = ""
							
							if (interiortype == 1) then
								type = "House"
							elseif (interiortype == 2) then
								type = "Business"
							elseif (interiortype == 3) then
								type = "Government"
							end	
								
							-- Create outside marker
							local entranceMarker = createMarker(entX, entY, entZ-1, "cylinder", 2, r, g, b, 50)
							setElementDimension(entranceMarker, entDim)
							setElementInterior(entranceMarker, entInt)
							
							setData(entranceMarker, "name", tostring(interiorname), true)
							setData(entranceMarker, "owner", -1, true)
							setData(entranceMarker, "dbid", tonumber(dbid), true)
							setData(entranceMarker, "type", tonumber(interiortype), true)
							setData(entranceMarker, "locked", 0, true)
							setData(entranceMarker, "price", tonumber(interiorprice), true)
							setData(entranceMarker, "rented", tonumber(interiorrented), true)
							setData(entranceMarker, "elevator", 0, true)
							
							-- Create inside marker
							local exitMarker = createMarker(x, y, z-1, "cylinder", 2, r, g, b, 50)
							setElementDimension(exitMarker, dbid)
							setElementInterior(exitMarker, int)
							
							setData(exitMarker, "name", tostring(interiorname), true)
							setData(exitMarker, "owner", -1, true)
							setData(exitMarker, "dbid", tonumber(dbid), true)
							setData(exitMarker, "type", tonumber(interiortype), true)
							setData(exitMarker, "locked", 0, true)
							setData(exitMarker, "price", tonumber(interiorprice), true)
							setData(exitMarker, "rented", tonumber(interiorrented), true)
							setData(exitMarker, "elevator", 0, true)
							
							setElementParent(exitMarker, entranceMarker)
								
							outputChatBox("Interior created with ID: ".. tostring(dbid) .." & Type: ".. tostring(type) ..".", thePlayer, 0, 255, 0)
						else
							outputDebugString("MySQL Error: Unable to create interior!")
							outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
						end
						
						sql:free_result(insert)
					else
						outputChatBox("Interior rent can only be 1 ( rented ) or 0 ( not rented ).", thePlayer, 255, 0, 0)
					end	
				else
					outputChatBox("Interior Type can only be 1 ( House ) or 2 ( Business ) or 3 ( Government ).", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Invalid Interior ID.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("SYNTAX: /makeinterior [Interior ID] [Interior Price] [Type 1/2/3] [Rented 1/0] [Interior Name]", thePlayer, 212, 156, 49)
		end	
	end
end	
addCommandHandler("makeinterior", makeInterior, false, false)

-- /delinterior
function deleteInterior( thePlayer, commandName, interiorID )
	if ( getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerAdministrator(thePlayer) ) then
		
		if ( interiorID ) then
			local interiorID = tonumber(interiorID)
			
			for key, value in ipairs (getElementsByType("marker")) do
				if ( getElementDimension( value ) == interiorID ) then  -- Look for an interior in the given dimension
					
					local parent = getElementParent( value )			-- Find its parent
					
					-- Delete
					destroyElement( parent )
					
					found = true
				end
			end	
			
			if (found) then
				
				local result = sql:query("SELECT * FROM `elevators` WHERE `parentid`=".. sql:escape_string(interiorID) .."")
				while true do
					
					local row = sql:fetch_assoc(result)
					if ( not row ) then
						break
					end	

					sql:query("DELETE FROM `elevators` WHERE `parentid`=".. sql:escape_string(interiorID) .."")
				end	
				
				sql:free_result(result)
				
				local delete = sql:query("DELETE FROM `interiors` WHERE id=".. sql:escape_string(interiorID) .."")
				if (delete) then
				
					outputChatBox("Deleted interior with ID ".. tostring(interiorID) ..".", thePlayer, 0, 255, 0)
				else
					outputDebugString("MySQL Error: Unable to delete interior!")
					outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
				end	
				
				sql:free_result(delete)
			else
				outputChatBox("Couldn't find interior with ID ".. tostring(interiorID) ..".", thePlayer, 255, 0, 0)
			end	
		else
			outputChatBox("SYNTAX: /".. commandName .." [Interior ID]", thePlayer, 212, 156, 49)
		end	
	end	
end
addCommandHandler("delinterior", deleteInterior, false, false)	
	
-- /nearbyinteriors
function getNearbyInteriors( thePlayer, commandName )
	if ( getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) ) then	
		
		local count = 0
		outputChatBox("~-~-~-~-~-~ Nearby Interiors ~-~-~-~-~-~", thePlayer, 212, 156, 49)
		
		for key, value in ipairs (getElementsByType("marker")) do
			
			local elevator = tonumber( getData( value, "elevator") )
			if ( elevator == 0 ) then
				
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
			outputChatBox("Couldn't find any interiors nearby you.", thePlayer, 255, 0, 0)
		end	
	end
end
addCommandHandler("nearbyinteriors", getNearbyInteriors, false, false)
	
-- /setinteriorname
function setInteriorName( thePlayer, commandName, interiorID, ... )
	if ( getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerAdministrator(thePlayer) ) then	
		
		if (interiorID) and (...) then
			
			local interiorID = tonumber(interiorID)
			local name = table.concat({...}, " ")
			
			local found = false
			for key, value in ipairs (getElementsByType("marker")) do
				if ( getElementDimension( value ) == interiorID ) then  -- Look for an interior in the given dimension
					
					local parent = getElementParent( value )			-- Find its parent
					
					-- Change the values
					setData(value, "name", tostring(name), true)
					setData(parent, "name", tostring(name), true)

					found = true
				end
			end

			if (found) then
				local update = sql:query("UPDATE `interiors` SET name='".. sql:escape_string(tostring(name)) .."' WHERE id=".. sql:escape_string(interiorID) .."")
				if (not update) then
					
					outputDebugString("MySQL Error: Unable to change interior name!")
					outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
				else
					outputChatBox("Changed Interior name to '".. tostring(name) .."'. (ID ".. tostring(interiorID) ..")", thePlayer, 0, 255, 0)
				end	
				
				sql:free_result(update)
			else
				outputChatBox("Couldn't find interior with ID ".. tostring(interiorID) ..".", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Interior ID] [New Interior Name]", thePlayer, 212, 156, 49)
		end
	end			
end
addCommandHandler("setinteriorname", setInteriorName, false, false)
	
-- /setinteriorprice
function setInteriorPrice( thePlayer, commandName, interiorID, price )
	if ( getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerAdministrator(thePlayer) ) then	
		
		if (interiorID) and (price) then
			
			local interiorID = tonumber(interiorID)
			local price = tonumber(price)
			
			for key, value in ipairs (getElementsByType("marker")) do
				if ( getElementDimension( value ) == interiorID ) then  -- Look for an interior in the given dimension
					
					local parent = getElementParent( value )			-- Find its parent
					
					-- Change the values
					setData(value, "price", price, true)
					setData(parent, "price", price, true)
					
					found = true
				end
			end

			if (found) then
				local update = sql:query("UPDATE interiors SET price=".. sql:escape_string(price) .." WHERE id=".. sql:escape_string(interiorID) .."")
				if (not update) then
					
					outputDebugString("MySQL Error: Unable to change interior price!")
					outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
				else
					outputChatBox("Changed Interior price to $".. tostring(price) .." (ID ".. tostring(interiorID) ..")", thePlayer, 0, 255, 0)
				end	
				
				sql:free_result(update)
			else
				outputChatBox("Couldn't find interior with ID ".. tostring(interiorID) ..".", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Interior ID] [New Price]", thePlayer, 212, 156, 49)
		end
	end			
end
addCommandHandler("setinteriorprice", setInteriorPrice, false, false)
	
-- /setinteriortype
function setInteriorType( thePlayer, commandName, interiorID, interiorType )
	if ( getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerAdministrator(thePlayer) ) then	
		
		if (interiorID) and (interiorType) then
			
			local interiorID = tonumber(interiorID)
			local interiorType = tonumber(interiorType)
			if (interiorType >= 1 and interiorType <= 3) then
			
				local found = false
				local interior, elev = nil, { }
				for key, value in ipairs (getElementsByType("marker")) do
					if ( getElementDimension( value ) == interiorID ) then  -- Look for an interior in the given dimension
					
						local parent = getElementParent( value )			-- Find its parent
					
						-- Change the values
						setData(value, "type", interiorType, true)
						setData(parent, "type", interiorType, true)
						
						if (interiorType == 3) then
							setData(value, "owner", -1, true)
							setData(parent, "owner", -1, true)
						end
						
						local elevator = tonumber( getData( parent, "elevator") )
						if ( elevator == 0 ) then
							
							interior = parent
						else
							table.insert(elev, parent)	
						end	
						
						found = true
					end
				end

				if (found) then
					
					local query = nil
					if (interiorType == 3) then
						query = "UPDATE interiors SET `owner`='-1', `type`=".. sql:escape_string(interiorType) .." WHERE id=".. sql:escape_string(interiorID) ..""
					else
						query = "UPDATE interiors SET `type`=".. sql:escape_string(interiorType) .." WHERE id=".. sql:escape_string(interiorID) ..""
					end	
						
					local update = sql:query(query)
					if (update) then
						
						local reload = reloadInterior( interior )
						
						if ( #elev ~= 0 ) then
							
							local i = 1
							while reload do
								
								reloadElevator( elev[i] )
								
								if ( i == #elev ) then
									break
								end	
								i = i + 1
							end	
						end
						
						outputChatBox("Changed Interior type to ".. tostring(interiorType) .." (ID ".. tostring(interiorID) ..")", thePlayer, 0, 255, 0)
					else
						outputDebugString("MySQL Error: Unable to change interior type!")
						outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
					end	
					
					sql:free_result(update)
				else
					outputChatBox("Couldn't find interior with ID ".. tostring(interiorID) ..".", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Invalid interior type (1 = House, 2 = Business, 3 = Government)", thePlayer, 255, 0, 0)
			end	
		else
			outputChatBox("SYNTAX: /".. commandName .." [Interior ID] [1/2/3]", thePlayer, 212, 156, 49)
		end
	end			
end
addCommandHandler("setinteriortype", setInteriorType, false, false)

-- /tptointerior
function teleportToInterior( thePlayer, commandName, interiorID )
	if ( getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) ) then	
		
		if (interiorID) then
			
			local interiorID = tonumber(interiorID)
			
			for key, value in ipairs (getElementsByType("marker")) do
				if ( getElementDimension( value ) == interiorID ) then  -- Look for an interior in the given dimension
					
					local parent = getElementParent( value )			-- Find its parent
					local elevator = tonumber( getData( value, "elevator" ) )
					if ( parent and elevator == 0 ) then
						
						if (isPedInVehicle(thePlayer)) then 
							removePedFromVehicle(thePlayer) 
						end
						
						local interiorX, interiorY, interiorZ = getElementPosition(parent)
						local interiorInterior, interiorDimension = getElementDimension(parent), getElementInterior(parent)
						
						setElementPosition(thePlayer, interiorX, interiorY, interiorZ+1)
						setElementInterior(thePlayer, interiorInterior)
						setElementDimension(thePlayer, interiorDimension)
						
						outputChatBox("Teleported to Interior ID ".. interiorID ..".", thePlayer, 0, 255, 0)
						
						found = true
						break
					end
				end	
			end	

			if (not found) then
				outputChatBox("Couldn't find interior with ID ".. tostring(interiorID) ..".", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Interior ID]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("tptointerior", teleportToInterior, false, false)	

-- /setinteriorid
function setInteriorID( thePlayer, commandName, interiorID )
	if ( getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerAdministrator(thePlayer) ) then	
		
		if (interiorID) then
			
			local interiorID = tonumber(interiorID)
			
			if (getElementDimension(thePlayer) ~= 0 and getElementInterior(thePlayer) ~= 0) then
				
				local dbid = getElementDimension(thePlayer)
				local interior = nil
				for key, value in ipairs (getElementsByType("marker")) do
					if ( getElementDimension(value) == dbid ) then
						
						local parent = getElementParent( value )
						
						local elevator = tonumber( getData( parent, "elevator") )
						if ( elevator == 0 ) then
							
							interior = parent
						else
							destroyElement( parent )
						end
					end
				end	
				
				local t = interiors[interiorID]
				local int = t[1]
				local x, y, z = t[2], t[3], t[4]
				
				local update = sql:query("UPDATE `interiors` SET `x`=".. sql:escape_string(x) ..", `y`=".. sql:escape_string(y) ..", `z`=".. sql:escape_string(z) ..", `int`=".. sql:escape_string(int) .." WHERE `id`=".. sql:escape_string(dbid) .."")
				if (update) then
					
					local result = sql:query("SELECT * FROM `elevators` WHERE `parentid`=".. sql:escape_string(dbid) .."")
					while true do
						
						local row = sql:fetch_assoc(result)
						if ( not row ) then
							break
						end	

						sql:query("DELETE FROM `elevators` WHERE `parentid`=".. sql:escape_string(dbid) .."")
					end	
					
					reloadInterior( interior )
					
					for key, value in ipairs ( getElementsByType("player") ) do
						if ( getElementInterior( value ) == getElementInterior( thePlayer ) and getElementDimension( value ) == getElementDimension( thePlayer ) ) then
							
							setElementPosition(value, x, y, z)
							setElementInterior(value, int)
						end
					end	
				else
					outputDebugString("MySQL Error: Unable to change interior id!")
					outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
				end
				
				sql:free_result(update)
			else
				outputChatBox("You can only use this command within an interior.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Interior ID]", thePlayer, 212, 156, 49)
		end	
	end
end
addCommandHandler("setinteriorid", setInteriorID, false, false)
	
-- /sellproperty
function sellProperty( thePlayer, commandName )
	if ( (getData(thePlayer, "loggedin") == 1) and (not isPedDead(thePlayer)) ) then
		if (getElementDimension(thePlayer) ~= 0 and getElementInterior(thePlayer) ~= 0) then
			
			local dbid = getElementDimension(thePlayer)
			local interior = nil
			for key, value in ipairs (getElementsByType("marker")) do
				if ( getElementDimension(value) == dbid ) then
				
					local parent = getElementParent( value )
						
					local elevator = tonumber( getData( parent, "elevator") )
					if ( elevator == 0 ) then
						
						interior = parent
					end
				end
			end	
			
			local type = tonumber(getData(interior, "type"))
			if (type ~= 3) then
				
				local admin = tonumber(getData(thePlayer, "admin"))
				local adminduty = tonumber(getData(thePlayer, "adminduty")) 
			
				local owner = tonumber(getData(interior, "owner"))
				if ( (owner == tonumber(getData(thePlayer, "dbid"))) or (admin >= 4 and adminduty == 1) ) then
					
					local update = sql:query("UPDATE `interiors` SET `owner`='-1' WHERE `id`=".. sql:escape_string(dbid) .."")
					if (update) then
					
						for key, value in ipairs (getElementsByType("marker")) do
							if ( getElementDimension(value) == dbid ) then
								
								local parent = getElementParent( value )
								
								setData(parent, "owner", -1, true)
								setData(value, "owner", -1, true)
							end
						end	
					
						local x, y, z = getElementPosition(interior)
						setElementPosition(thePlayer, x, y, z+1)
						setElementDimension(thePlayer, getElementDimension(interior))
						setElementInterior(thePlayer, getElementInterior(interior))
						
						local price = tonumber(getData(interior, "price"))
						local moneyBack = nil
						
						if (admin >= 4 and adminduty == 1) then
							moneyBack = price
						else	
							moneyBack = 1*price
						end
						
						givePlayerMoney(thePlayer, moneyBack*100)
						exports['[ars]inventory-system']:takeItem( thePlayer, 2, dbid )
						
						outputChatBox("You sold your property for $".. moneyBack ..".", thePlayer, 0, 255, 0)
						
						triggerEvent("takeMoneyFromGovernment", thePlayer, moneyBack)
					else
						outputDebugString("MySQL Error: Unable to sell interior!")
						outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
					end

					sql:free_result(update)
				end
			else
				outputChatBox("A Government building cannot be sold.", thePlayer, 255, 0, 0)
			end	
		else
			outputChatBox("You can only use this command within an interior.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("sellproperty", sellProperty, false, false)	

-- /setinteriorentrance
function setInteriorEntrance( thePlayer, commandName, interiorID )
	if ( getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerAdministrator(thePlayer) ) then	
		
		if (interiorID) then
			
			local interiorID = tonumber(interiorID)
			
			local x, y, z = getElementPosition( thePlayer )
			local int, dim = getElementInterior( thePlayer ), getElementDimension( thePlayer )

			for key, value in ipairs (getElementsByType("marker")) do
				if ( getElementDimension( value ) == interiorID ) then  -- Look for an interior in the given dimension
					
					local parent = getElementParent( value )			-- Find its parent
					local elevator = tonumber( getData( parent, "elevator" ) )
					if ( parent and elevator == 0 ) then
						
						local child = getElementChild( parent, 0 )
						local cx, cy, cz = getElementPosition( child )
						local cint, cdim = getElementInterior( child ), getElementDimension( child )
						
						setElementPosition(parent, x, y, z - 1)
						setElementInterior(parent, int)
						setElementDimension(parent, dim)
						
						setElementPosition(child, cx, cy, cz)
						setElementInterior(child, cint)
						setElementDimension(child, cdim)
						
						outputChatBox("Changed interior entrance. (".. interiorID ..")", thePlayer, 0, 255, 0)
						
						found = true
						break
					end
				end	
			end	

			if (not found) then
				outputChatBox("Couldn't find interior with ID ".. tostring(interiorID) ..".", thePlayer, 255, 0, 0)
			else	
				local update = sql:query("UPDATE `interiors` SET `entx`=".. sql:escape_string( tonumber(x) ) ..", `enty`=".. sql:escape_string( tonumber(y) ) ..", `entz`=".. sql:escape_string( tonumber(z-1) ) ..", `entdim`=".. sql:escape_string( tonumber(dim) )..", `entint`=".. sql:escape_string( tonumber(int) ) .." WHERE `id`=".. sql:escape_string( tonumber(interiorID) ) .."")
				if ( not update ) then
					outputDebugString("MySQL Error: Unable to set interior exit!")
					outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
				end	
				
				sql:free_result(update)
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Interior ID]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("setinteriorentrance", setInteriorEntrance, false, false)	

-- /setinteriorexit
function setInteriorExit( thePlayer, commandName, interiorID )
	if ( getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerAdministrator(thePlayer) ) then	
		
		if (interiorID) then
			
			local interiorID = tonumber(interiorID)
			
			local x, y, z = getElementPosition( thePlayer )
			local int, dim = getElementInterior( thePlayer ), getElementDimension( thePlayer )

			for key, value in ipairs (getElementsByType("marker")) do
				if ( getElementDimension( value ) == interiorID ) then  -- Look for an interior in the given dimension
					
					local elevator = tonumber( getData( value, "elevator" ) )
					if ( elevator == 0 ) then
						
						if ( interiorID ~= dim ) then
							
							outputChatBox("You cannot put an interior's exit into another interior.", thePlayer, 255, 0, 0)
							return
						else	
							setElementPosition(value, x, y, z - 1)
							setElementInterior(value, int)
							setElementDimension(value, dim)
							
							outputChatBox("Changed interior exit. (".. interiorID ..")", thePlayer, 0, 255, 0)
							
							found = true
						end	
						break
					end
				end	
			end	

			if (not found) then
				outputChatBox("Couldn't find interior with ID ".. tostring(interiorID) ..".", thePlayer, 255, 0, 0)
			else
				local update = sql:query("UPDATE `interiors` SET `x`=".. sql:escape_string( tonumber(x) ) ..", `y`=".. sql:escape_string( tonumber(y) ) ..", `z`=".. sql:escape_string( tonumber(z) ) ..", `int`=".. sql:escape_string( tonumber(int) ) .." WHERE `id`=".. sql:escape_string( tonumber(interiorID) ) .."")
				if ( not update ) then
					outputDebugString("MySQL Error: Unable to set interior exit!")
					outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
				end
				
				sql:free_result(update)
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Interior ID]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("setinteriorexit", setInteriorExit, false, false)	

--------- [ Miscellaneous Functions ] ---------	

-- ENTER/EXIT
function interactInterior( thePlayer )
	if ( getData(thePlayer, "loggedin") == 1 ) and (not isPedDead(thePlayer) ) then
		
		for key, value in ipairs (getElementsByType("marker")) do
			
			if ( getElementDimension(value) == getElementDimension(thePlayer) and isElementWithinMarker( thePlayer, value ) ) then	-- We're At a Marker
				
				local dbid = tonumber(getData(value, "dbid"))
				local elevator = tonumber(getData(value, "elevator"))
				
				local child = getElementChild(value, 0)	-- Does it Have a Child?
				if (child) then							-- If it Has a Child ( then we're at the entrance )
					
					local locked = tonumber(getData(value, "locked"))
					local price = tonumber(getData(value, "price"))
					local owner = tonumber(getData(value, "owner"))
					local type = tonumber(getData(value, "type"))
					
					if (owner ~= nil) and (price ~= nil) and (locked ~= nil) then 
						
						if ( (owner == -1 and type == 3) or (owner > 0 and type ~= 3) ) then
						
							-- ENTER
							if (locked == 0) then
								
								local isVehicle = false
								if ( getMarkerSize( value ) == 3 ) then
									isVehicle = true
								end
									
								local x, y, z = getElementPosition(child)
								local int = getElementInterior(child)
								local dim = getElementDimension(child)	
								
								if ( not isVehicle ) then
									changePlayerInterior( thePlayer, x, y, z+1, int, dim)
								else
									local theVehicle = getPedOccupiedVehicle( thePlayer )
									if ( theVehicle ) then
										changeVehicleInterior( theVehicle, x, y, z+1, int, dim)
									end	
								end	
							else
								outputChatBox("The door is locked.", thePlayer, 255, 0, 0)
							end
							
						else 
							if (elevator == 0) then
								-- BUY
								local money = (getPlayerMoney(thePlayer)/100)
								if (money >= price) then
								
									buyInterior( thePlayer, money, price, dbid, value )
									setData(parent, "owner", dbid, true)	
								else
									outputChatBox("You do not have enough money.", thePlayer, 255, 0, 0)
								end
							else
								outputChatBox("This interior must be bought first.", thePlayer, 255, 0, 0)
							end	
						end
					
						break
					end
				else											-- If it Doesn't Have a Child ( then we're at the exit )
					
					local parent = getElementParent( value )	-- Find its parent
					if (parent) then
						
						local locked = tonumber(getData(parent, "locked"))
						
						-- ENTER
						if (locked == 0) then
							
							local isVehicle = false
							if ( getMarkerSize( parent ) == 3 ) then
								isVehicle = true
							end
							
							local x, y, z = getElementPosition(parent)
							local int = getElementInterior(parent)
							local dim = getElementDimension(parent)
							
							if ( not isVehicle ) then	
								changePlayerInterior( thePlayer, x, y, z+1, int, dim)
							else
								local theVehicle = getPedOccupiedVehicle( thePlayer )
								if ( theVehicle ) then
									changeVehicleInterior( theVehicle, x, y, z+1, int, dim)
								end	
							end
						else
							outputChatBox("The door is locked.", thePlayer, 255, 0, 0)
						end	
						
						break
					else
						outputDebugString("ERROR:389; Unable to find interior parent!")
					end	
				end
			end	
		end	
	end	
end
	
-- LOCK/UNLOCK
function toggleLock( thePlayer )
	if ( getData(thePlayer, "loggedin") == 1 ) and (not isPedDead(thePlayer) ) then
		
		local adminduty = tonumber(getData(thePlayer, "adminduty"))
		
		for key, interior in ipairs ( getElementsByType("marker") )  do
			if ( getElementDimension(interior) == getElementDimension(thePlayer) and isElementWithinMarker(thePlayer, interior) ) then	-- We're At a Marker
				
				local elevator = tonumber(getData(interior, "elevator"))
				
				local child = getElementChild(interior, 0)	-- Does it Have a Child?
				if (child) then								-- If it Has a Child ( then we're at the entrance )
					
					local dbid = getElementDimension( child )
					
					local key, keyid = exports['[ars]inventory-system']:hasItem(thePlayer, 2, dbid )
					if (key and keyid) or (adminduty == 1) then		-- Do We Have a Key?
					
						local locked = tonumber(getData(interior, "locked"))
						if (locked == 1) then
						
							setData(interior, "locked", 0)
							setData(child, "locked", 0)
							
							local update
							if ( elevator == 0 ) then
								update = sql:query("UPDATE `interiors` SET `locked`='0' WHERE `id`=".. sql:escape_string(dbid) .."")
							else
								update = sql:query("UPDATE `elevators` SET `locked`='0' WHERE `parentid`=".. sql:escape_string(getElementDimension(child)) .."")
							end
							
							sql:free_result(update)
							outputChatBox("You unlocked the door.", thePlayer, 212, 156, 49)
						elseif (locked == 0) then
							
							setData(interior, "locked", 1)
							setData(child, "locked", 1)
							
							local update
							if ( elevator == 0 ) then
								update = sql:query("UPDATE `interiors` SET `locked`='1' WHERE `id`=".. sql:escape_string(dbid) .."")
							else
								update = sql:query("UPDATE `elevators` SET `locked`='1' WHERE `parentid`=".. sql:escape_string(getElementDimension(child)) .."")
							end
							
							sql:free_result(update)
							outputChatBox("You locked the door.", thePlayer, 212, 156, 49)
						end
						
						break
					end
				
				else												-- If it Doesn't Have a Child ( then we're at the exit )
					
					local parent = getElementParent( interior )		-- Find its parent
					if (parent) then
						
						local dbid = getElementDimension( interior )
					
						local locked = tonumber(getData(parent, "locked"))
						if (locked == 1) then
							
							setData(parent, "locked", 0)
							setData(interior, "locked", 0)
							
							local update
							if ( elevator == 0 ) then
								update = sql:query("UPDATE `interiors` SET `locked`='0' WHERE `id`=".. sql:escape_string(dbid) .."")
							else
								update = sql:query("UPDATE `elevators` SET `locked`='0' WHERE `parentid`=".. sql:escape_string(getElementDimension(interior)) .."")
							end
							
							sql:free_result(update)
							outputChatBox("You unlocked the door.", thePlayer, 212, 156, 49)
						elseif (locked == 0) then
							
							setData(parent, "locked", 1)
							setData(interior, "locked", 1)
							
							local update
							if ( elevator == 0 ) then
								update = sql:query("UPDATE `interiors` SET `locked`='1' WHERE `id`=".. sql:escape_string(dbid) .."")
							else
								update = sql:query("UPDATE `elevators` SET `locked`='1' WHERE `parentid`=".. sql:escape_string(getElementDimension(interior)) .."")
							end	
							
							sql:free_result(update)
							outputChatBox("You locked the door.", thePlayer, 212, 156, 49)
						end
						
						break
					else
						outputDebugString("ERROR:456; Unable to find interior parent!")
					end
				end	
			end
		end
	end
end

-- BUY INTERIOR	
local interiorReload = false
function buyInterior(thePlayer, money, price, interiorID, interior )
	
	local money = tonumber(money)
	local price = tonumber(price)
	local interiorID = tonumber(interiorID)
	local dbid = tonumber(getData(thePlayer, "dbid"))
	
	local update = sql:query("UPDATE interiors SET owner=".. sql:escape_string(dbid) .." WHERE id=".. sql:escape_string(interiorID) .."")
	if (update) then
		
		interiorReload = reloadInterior( interior )
		
		exports['[ars]inventory-system']:giveItem(thePlayer, 2, tostring(interiorID))
		
		takePlayerMoney(thePlayer, price*100)
		outputChatBox("You bought this place for $".. tostring(price) ..".", thePlayer, 212, 156, 49)
		
		callElevatorReload( interiorID )
	
		triggerEvent("giveMoneyToGovernment", thePlayer, price)
	else
		outputDebugString("MySQL Error: Unable to buy interior!")
		outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
	end	
	
	sql:free_result(update)
end

function callElevatorReload( interiorID )
	if ( interiorReload ) then
		for key, value in ipairs( getElementsByType("marker") ) do
			if ( getElementDimension( value ) == interiorID ) then
				
				local parent = getElementParent( value )
				if ( getData( parent, "elevator" ) == 1 ) then
					
					reloadElevator( parent )
				end
			end
		end
	else -- Wait for the main interior to reload
		setTimer( callElevatorReload, 1000, 1, interiorID )
	end
end
	
-- RELOAD INTERIOR	
function reloadInterior( interior )
	local dbid = tonumber(getData(interior, "dbid"))

	destroyElement(interior) -- Child is automatically deleted
	
	local row = sql:query_fetch_assoc("SELECT `name`, price, entx, enty, entz, x, y, z, entdim, entint, `int`, owner, `type`, locked, `rent` FROM `interiors` WHERE id=".. sql:escape_string(dbid) .."")
	
	local entX = tonumber(row['entx'])
	local entY = tonumber(row['enty'])
	local entZ = tonumber(row['entz'])
	local x = tonumber(row['x'])
	local y = tonumber(row['y'])
	local z = tonumber(row['z'])
	local entDim = tonumber(row['entdim'])
	local entInt = tonumber(row['entint'])
	local int = tonumber(row['int'])
	local owner = tonumber(row['owner'])
	local type = tonumber(row['type'])
	local name = tostring(row['name'])
	local price = tonumber(row['price'])
	local locked = tonumber(row['locked'])
	local rented = tonumber(row['rent'])
	
	local r, g, b = 255, 255, 255
	
	-- Create outside marker
	local entranceMarker = createMarker(entX, entY, entZ, "cylinder", 2, r, g, b, 50)
	setElementDimension(entranceMarker, entDim)
	setElementInterior(entranceMarker, entInt)
	
	setData(entranceMarker, "name", tostring(name), true)
	setData(entranceMarker, "owner", tonumber(owner), true)
	setData(entranceMarker, "dbid", tonumber(dbid), true)
	setData(entranceMarker, "type", tonumber(type), true)
	setData(entranceMarker, "locked", tonumber(locked), true)
	setData(entranceMarker, "price", tonumber(price), true)
	setData(entranceMarker, "rented", tonumber(rented), true)
	setData(entranceMarker, "elevator", 0, true)
	
	-- Create inside marker
	local exitMarker = createMarker(x, y, z-1, "cylinder", 2, r, g, b, 50)
	setElementDimension(exitMarker, dbid)
	setElementInterior(exitMarker, int)
	
	setData(exitMarker, "name", tostring(name), true)
	setData(exitMarker, "owner", tonumber(owner), true)
	setData(exitMarker, "dbid", tonumber(dbid), true)
	setData(exitMarker, "type", tonumber(type), true)
	setData(exitMarker, "locked", tonumber(locked), true)
	setData(exitMarker, "price", tonumber(price), true)	
	setData(exitMarker, "rented", tonumber(rented), true)
	setData(exitMarker, "elevator", 0, true)
	
	setElementParent(exitMarker, entranceMarker)
	
	return true
end

function reloadElevator( interior )
	triggerEvent("reloadElevator", root, interior)
end

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
	
-- CHANGE INTERIOR
function changePlayerInterior( thePlayer, x, y, z, int, dim )
	setElementPosition(thePlayer, x, y, z)
	setElementInterior(thePlayer, int)
	setElementDimension(thePlayer, dim)
end

function changeVehicleInterior( theVehicle, x, y, z, int, dim )
	
	local occupants = { }
	for i = 0, getVehicleMaxPassengers( theVehicle ) do
		
		local thePlayer = getVehicleOccupant( theVehicle, i )
		if ( thePlayer ) then
			
			removePedFromVehicle(thePlayer)
			changePlayerInterior(thePlayer, x, y, z, int, dim )
		
			setElementFrozen( thePlayer, true )
			
			occupants[i] = thePlayer
		end	
	end	

	setElementPosition(theVehicle, x, y, z)
	setElementInterior(theVehicle, int)
	setElementDimension(theVehicle, dim)
	
	setElementVelocity(theVehicle, 0, 0, 0)
	setVehicleTurnVelocity(theVehicle, 0, 0, 0)

	local _, _, rz = getVehicleRotation(theVehicle)
	setVehicleRotation(theVehicle, 0, 0, rz)
	
	setTimer(setVehicleTurnVelocity, 50, 2, theVehicle, 0, 0, 0)
	
	setElementHealth(theVehicle, getElementHealth(theVehicle))
	
	setElementFrozen(theVehicle, true)
	setTimer(setElementFrozen, 2000, 1, theVehicle, false)
	
	for key, thePlayer in pairs ( occupants ) do
		warpPedIntoVehicle( thePlayer, theVehicle, key )
		setElementFrozen( thePlayer, false )
	end	
end

addEventHandler("onVehicleStartExit", root,
	function( thePlayer )
		for key, interior in ipairs ( getElementsByType("marker") )  do
			if ( getElementDimension(interior) == getElementDimension(thePlayer) and isElementWithinMarker(thePlayer, interior) ) then
				
				cancelEvent( true )
			end	
		end	
	end
)
	
--------- [ Interior Spawn ] ---------
local toLoad = { }
local threads = { }
function loadAllInteriors( res )
	local result = sql:query("SELECT `id` FROM `interiors` ORDER BY `id` ASC")
	if result then
		while true do
			local row = sql:fetch_assoc(result)
			if not row then break end
			
			toLoad[tonumber(row['id'])] = true
		end
		sql:free_result(result)
		
		for id in pairs( toLoad ) do
			
			local co = coroutine.create(loadOneInterior)
			coroutine.resume(co, id, true)
			table.insert(threads, co)
		end
		setTimer(resume, 1000, 4)
	else
		outputDebugString("Coroutine failure.")
	end
	
	sql:free_result(result)
end
addEventHandler("onResourceStart", resourceRoot, loadAllInteriors)

local resumeCount = 0
function resume( )
	for key, value in ipairs(threads) do
		coroutine.resume(value)
	end
	
	-- Load Elevators
	resumeCount = resumeCount + 1
	if ( resumeCount == 4 ) then
		
		local elevatorSystem = getResourceFromName("[ars]elevator-system")
		if ( elevatorSystem ) then
			
			local state = getResourceState( elevatorSystem )
			if ( state == "loaded" ) then
				
				local success = startResource( elevatorSystem )
				if ( success ) then
					
					triggerEvent("onInteriorsLoad", root)
				end	
			end
		end	
		
		resumeCount = 0
	end	
end

function loadOneInterior(id, hasCoroutine)
	if (hasCoroutine == nil) then
		hasCoroutine = false
	end
	
	local row = sql:query_fetch_assoc("SELECT * FROM `interiors` WHERE `id`=" .. sql:escape_string(id) )
	if row then
		
		if (hasCoroutine) then
			coroutine.yield()
		end
		
		local dbid = tonumber(row['id'])
		local entX = tonumber(row['entx'])
		local entY = tonumber(row['enty'])
		local entZ = tonumber(row['entz'])
		local x = tonumber(row['x'])
		local y = tonumber(row['y'])
		local z = tonumber(row['z'])
		local entDim = tonumber(row['entdim'])
		local entInt = tonumber(row['entint'])
		local int = tonumber(row['int'])
		local owner = tonumber(row['owner'])
		local type = tonumber(row['type'])
		local name = tostring(row['name'])
		local price = tonumber(row['price'])
		local locked = tonumber(row['locked'])
		local rented = tonumber(row['rent'])
		
		local r, g, b = 255, 255, 255
	
		-- Create outside marker
		local entranceMarker = createMarker(entX, entY, entZ, "cylinder", 2, r, g, b, 50)
		setElementDimension(entranceMarker, entDim)
		setElementInterior(entranceMarker, entInt)
		
		setData(entranceMarker, "name", tostring(name), true)
		setData(entranceMarker, "owner", tonumber(owner), true)
		setData(entranceMarker, "dbid", tonumber(dbid), true)
		setData(entranceMarker, "type", tonumber(type), true)
		setData(entranceMarker, "locked", tonumber(locked), true)
		setData(entranceMarker, "price", tonumber(price), true)
		setData(entranceMarker, "rented", tonumber(rented), true)
		setData(entranceMarker, "elevator", 0, true)
		
		-- Create inside marker
		local exitMarker = createMarker(x, y, z-1, "cylinder", 2, r, g, b, 50)
		setElementDimension(exitMarker, dbid)
		setElementInterior(exitMarker, int)
		
		setData(exitMarker, "name", tostring(name), true)
		setData(exitMarker, "owner", tonumber(owner), true)
		setData(exitMarker, "dbid", tonumber(dbid), true)
		setData(exitMarker, "type", tonumber(type), true)
		setData(exitMarker, "locked", tonumber(locked), true)
		setData(exitMarker, "price", tonumber(price), true)
		setData(exitMarker, "rented", tonumber(rented), true)
		setData(exitMarker, "elevator", 0, true)
		
		setElementParent(exitMarker, entranceMarker)
	end	
end

addEventHandler("onResourceStop", resourceRoot,
	function( )
		local elevatorSystem = getResourceFromName("[ars]elevator-system")
		if ( elevatorSystem ) then
			
			local state = getResourceState( elevatorSystem )
			if ( state == "running" ) then
				
				stopResource( elevatorSystem )
			end
		end	
	end
)
	
--------- [ Bind Key ] --------- 
addEventHandler("onResourceStart", resourceRoot,	
function ( res )
	for k, v in ipairs ( getElementsByType("player") ) do
		bindKey(v, "f", "down", interactInterior)
		bindKey(v, "k", "down", toggleLock)
	end	
end)

addEventHandler("onPlayerJoin", root,
function( )
	bindKey(source, "f", "down", interactInterior)
	bindKey(source, "k", "down", toggleLock)
end)	