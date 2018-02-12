local sql = exports.sql

local suspects = { }
local crimes = { }
local policeVehicle = { [427]= true, [490]= true, [528]= true, [523]= true, [598]= true, [597]= true, [596]= true, [599]= true, [601]= true, [430]= true, [497]= true }

local ready = false

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

--------- [ Mobile Data Computer ] ---------

-- /mdc
addCommandHandler("mdc", 
function( thePlayer, commandName )
	if ( getData(thePlayer, "loggedin") == 1 ) then
		
		local playerFaction = tonumber( getData(thePlayer, "faction") )
		if ( playerFaction == 1 ) then
			
			local vehicle = false
			local dimension = getElementDimension (thePlayer)
			
			if ( isPedInVehicle( thePlayer ) ) then
				vehicle = getPedOccupiedVehicle( thePlayer )
			end
			
			if ( vehicle ) then
				if ( not policeVehicle[getElementModel(vehicle)] ) then
					
					outputChatBox("This vehicle does not have LSPD MDC system installed.", thePlayer, 255, 0, 0)
					return
				end
			else	
				if ( dimension ~= 311) then
					
					outputChatBox("You need to be near MDC to use it.", thePlayer, 255, 0, 0)
					return
				end
			end
				
			local faction = getTeamFromName("San Fierro Police Department")
				
			local rank = tonumber( getData(thePlayer, "f:rank") )
			local leaderRank = tonumber( getData(faction, "leader") )
			
			triggerClientEvent(thePlayer, "showMobileDataTerminal", thePlayer, rank, leaderRank)
		end
	end
end, false, false)	

function addSuspectToTerminal( array )
	if ( array ) then
		
		local name = tostring( array[1] ):gsub(" ", "_")
		local dob = tostring( array[2] )
		local job = tostring( array[3] )
		local age = tostring( array[4] )
		local gender = tonumber( array[5] )
		local race = tostring( array[6] )
		local height = tostring( array[7] )
		local weight = tostring( array[8] )
		local phone = tostring( array[9] )
		local address = tostring( array[10] )
		
		-- ## Format must be 'Firstname_Lastname' ##
		name = fixSuspectName( name )
		
		local result = sql:query_fetch_assoc("SELECT `name` FROM `mdt_suspects` WHERE `name`='".. sql:escape_string(name) .."'")
		if ( not result ) then
			
			local insert = sql:query("INSERT INTO `mdt_suspects` SET `name`='".. sql:escape_string(name) .."', `age`='".. sql:escape_string(age) .."', `gender`=".. sql:escape_string(gender) ..", `height`='".. sql:escape_string(height) .."', `weight`='".. sql:escape_string(weight) .."', `ethnicity`='".. sql:escape_string(race) .."', `phone`='".. sql:escape_string(phone) .."', `address`='".. sql:escape_string(address) .."', `job`='".. sql:escape_string(job) .."', `dob`='".. sql:escape_string(dob) .."'")
			if (insert) then
				local dbid = tonumber( sql:insert_id() )
				suspects[dbid] = { name, age, gender, height, weight, race, -2, phone, address, job, dob }
				
				triggerEvent("getTerminalData", source)
				triggerClientEvent(source, "informSuspectAddition", source)
			else
				outputDebugString("MySQL Error: Unable to add suspect!")
				outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
			end
			
			sql:free_result(insert)
		else
			triggerClientEvent(source, "giveAdditionError", source, "Suspect is already in the database")
		end	
	end	
end
addEvent("addSuspectToTerminal", true)
addEventHandler("addSuspectToTerminal", root, addSuspectToTerminal)

function removeSuspectFromTerminal ( name )
	local name = tostring( name ):gsub(" ", "_")
	
	name = fixSuspectName( name )
	-- ## Format must be 'Firstname_Lastname' ##
	
	local result = sql:query_fetch_assoc("SELECT `id` FROM `mdt_suspects` WHERE `name`='".. sql:escape_string(name) .."'")
	if ( result ) then
		
		local dbid = tonumber( result['id'] )
		
		local delete = sql:query("DELETE FROM `mdt_suspects` WHERE `name`='".. sql:escape_string(name) .."'")
		if ( delete ) then
			suspects[dbid] = nil
			
			local result = sql:query_fetch_assoc("SELECT `suspectid` FROM `mdt_crimes` WHERE `suspectid`=".. sql:escape_string(dbid) .."")
			if ( result ) then
				local crimeDelete = sql:query("DELETE FROM `mdt_crimes` WHERE `suspectid`=".. sql:escape_string(dbid) .."")
				if ( crimeDelete ) then
					
					for key, value in pairs ( crimes ) do
						if ( tonumber( value[1] ) == dbid ) then
							crimes[key] = nil
						end
					end	
				end	
				
				sql:free_result(crimeDelete)
			end
			
			triggerEvent("getTerminalData", source)
			triggerClientEvent(source, "informSuspectRemoval", source)
		end
	else
		triggerClientEvent(source, "giveRemovalError", source, "Invalid Entry!")
	end	
end
addEvent("removeSuspectFromTerminal", true)
addEventHandler("removeSuspectFromTerminal", root, removeSuspectFromTerminal)

function editSuspectInTerminal( array )
	if ( array ) then
		
		local dbid = tonumber( array[1] )
		local name = tostring( array[2] ):gsub(" ", "_")
		local dob = tostring( array[3] )
		local job = tostring( array[4] )
		local age = tostring( array[5] )
		local gender = tonumber( array[6] )
		local race = tostring( array[7] )
		local height = tostring( array[8] )
		local weight = tostring( array[9] )
		local photo = tonumber( array[10] ) 
		local phone = tostring( array[11] )
		local address = tostring( array[12] )
		
		-- ## Format must be 'Firstname_Lastname' ##
		name = fixSuspectName( name )
		
		local update = sql:query("UPDATE `mdt_suspects` SET `name`='".. sql:escape_string(name) .."', `age`='".. sql:escape_string(age) .."', `gender`=".. sql:escape_string(gender) ..", `height`='".. sql:escape_string(height) .."', `weight`='".. sql:escape_string(weight) .."', `ethnicity`='".. sql:escape_string(race) .."', `photo`=".. sql:escape_string(photo) ..", `phone`='".. sql:escape_string(phone) .."', `address`='".. sql:escape_string(address) .."', `job`='".. sql:escape_string(job) .."', `dob`='".. sql:escape_string(dob) .."' WHERE `id`=".. sql:escape_string(dbid) .."")
		if ( update ) then
			suspects[dbid] = { name, age, gender, height, weight, race, photo, phone, address, job, dob }
		
			triggerEvent("getTerminalData", source)
			triggerClientEvent(source, "informSuspectEdited", source)
		else
			outputDebugString("MySQL Error: Unable to edit suspect!")
			outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
		end
		
		sql:free_result(update)
	end
end
addEvent("editSuspectInTerminal", true)
addEventHandler("editSuspectInTerminal", root, editSuspectInTerminal)

function addSuspectCrimeToTerminal( array )
	if ( array ) then
	
		local dbid = tonumber( array[1] )
		local time = tostring( array[2] )
		local date = tostring( array[3] )
		local officers = tostring( array[4] )
		local punishmentType = tonumber( array[5] )
		local ticketPrice = tostring( array[6] )
		local arrestFine = tostring( array[7] )
		local arrestTime = tostring( array[8] )
		local fullDetails = tostring( array[9] )
		
		local insert = sql:query("INSERT INTO `mdt_crimes` SET `suspectid`=".. sql:escape_string(dbid) ..", `crime_time`='".. sql:escape_string(time) .."', `crime_date`='".. sql:escape_string(date) .."', `officers`='".. sql:escape_string(officers) .."', `punishment_type`=".. sql:escape_string(punishmentType) ..", `ticket_price`='".. sql:escape_string(ticketPrice) .."', `arrest_price`='".. sql:escape_string(arrestFine) .."', `arrest_time`='".. sql:escape_string(arrestTime) .."', `full_detail`='".. sql:escape_string(fullDetails) .."'")
		if (insert) then
			local id = tonumber( sql:insert_id() )
			crimes[id] = { dbid, time, date, officers, punishmentType, ticketPrice, arrestFine, arrestTime, fullDetails }
			
			triggerEvent("getTerminalData", source)
			triggerClientEvent(source, "informSuspectCrimeAddition", source)
		else
			outputDebugString("MySQL Error: Unable to insert suspect crime!")
			outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
		end	
		
		sql:free_result(insert)
	end
end
addEvent("addSuspectCrimeToTerminal", true)
addEventHandler("addSuspectCrimeToTerminal", root, addSuspectCrimeToTerminal)

function removeSuspectCrimeFromTerminal( id )
	local id = tonumber( id )
	
	local result = sql:query_fetch_assoc("SELECT `id` FROM `mdt_crimes` WHERE `id`=".. sql:escape_string(id) .."")
	if ( result ) then
		
		local delete = sql:query("DELETE FROM `mdt_crimes` WHERE `id`=".. sql:escape_string(id) .."")
		if ( delete ) then
			
			crimes[id] = nil
			triggerEvent("getTerminalData", source)
			triggerClientEvent(source, "informSuspectCrimeRemoval", source)
		end
		
		sql:free_result(delete)
	else
		triggerClientEvent(source, "giveCrimeRemovalError", source, "Invalid Entry!")
	end	
end
addEvent("removeSuspectCrimeFromTerminal", true)
addEventHandler("removeSuspectCrimeFromTerminal", root, removeSuspectCrimeFromTerminal)

function fixSuspectName( name )
	local name = tostring(name)
	local underscore = string.find(name, "_")
	
	if ( underscore == nil ) then
		name = name .."_"
		underscore = string.find(name, "_")
	end
	
	local f, l = string.sub(name, 1, 1), string.sub(name, underscore + 1, underscore + 1)
	local s = string.upper(f) .. string.sub(name, 2, underscore) .. string.upper(l) .. string.sub(name, underscore + 2)
	
	return s	
end

function getTerminalData( )
	local thePlayer = source
	
	if (ready) then
		triggerClientEvent(thePlayer, "giveTerminalData", thePlayer, suspects, crimes)
	else
		setTimer(function( )
			triggerEvent("getTerminalData", thePlayer)
		end, 1000, 1)
	end	
end
addEvent("getTerminalData", true)
addEventHandler("getTerminalData", root, getTerminalData)
 
addEventHandler("onResourceStart", resourceRoot,
function( )
	
	local suspectResult = sql:query("SELECT * FROM `mdt_suspects`")
	while true do
		
		local row = sql:fetch_assoc(suspectResult)
		if not row then break end
		
		local id = tonumber( row['id'] )
		local name = tostring( row['name'] )
		local age = tostring( row['age'] )
		local gender = tonumber( row['gender'] )
		local height = tostring( row['height'] )
		local weight = tostring( row['weight'] )
		local ethnicity = tostring( row['ethnicity'] )
		local photo = tonumber( row['photo'] )
		local phone = tostring( row['phone'] )
		local address = tostring( row['address'] )
		local job = tostring( row['job'] )
		local dob = tostring( row['dob'] )
		
		suspects[id] = { name, age, gender, height, weight, ethnicity, photo, phone, address, job, dob }
	end
	
	local crimeResult = sql:query("SELECT * FROM `mdt_crimes`")	
	while true do
		
		local row = sql:fetch_assoc(crimeResult)
		if not row then break end
		
		local id = tonumber( row['id'] )
		local time = tostring( row['crime_time'] )
		local date = tostring( row['crime_date'] )
		local suspectID = tonumber( row['suspectid'] )
		local officers = tostring( row['officers'] )
		local punishmentType = tonumber( row['punishment_type'] )
		local ticketPrice = tonumber( row['ticket_price'] )
		local arrestPrice = tonumber( row['arrest_price'] )
		local arrestTime = tonumber( row['arrest_time'] )
		local fullDetail = tostring( row['full_detail'] )
		
		crimes[id] = { suspectID, time, date, officers, punishmentType, ticketPrice, arrestPrice, arrestTime, fullDetail }
	end	
	
	sql:free_result(suspectResult)
	sql:free_result(crimeResult)
	
	ready = true
end)