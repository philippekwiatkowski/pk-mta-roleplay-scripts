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

--------- [ Job System ] ---------
function setPlayerJob( job )
	local jobID = nil
	
	if (job == "Road Sweeper") then
		jobID = 1
	elseif (job == "Bus Driver") then
		jobID = 2	
	elseif (job == "Taxi Driver") then
		jobID = 3
	elseif (job == "Oil Transporter") then
		jobID = 4
	end

	local update = sql:query("UPDATE `characters` SET `job`=".. sql:escape_string(tonumber(jobID)) .." WHERE `id`=".. sql:escape_string(tonumber(getData(source, "dbid"))) .."")
	if (update) then
		
		setData(source, "job", tonumber(jobID), true)
		outputChatBox("You are now a ".. job ..".", source, 0, 255, 0)
	else
		outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
	end	
	
	sql:free_result(update)
end
addEvent("setPlayerJob", true)
addEventHandler("setPlayerJob", root, setPlayerJob)

function removePlayerJob( )
	
	local update = sql:query("UPDATE `characters` SET `job`='0' WHERE `id`=".. sql:escape_string(tonumber(getData(source, "dbid"))) .."")
	if (update) then
		
		setData(source, "job", 0, true)
		outputChatBox("You quit your job.", source, 0, 255, 0)
	else
		outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
	end	
	
	sql:free_result(update)
end
addEvent("removePlayerJob", true)
addEventHandler("removePlayerJob", root, removePlayerJob)

-- Removed the gate at the Depot
addEventHandler("onResourceStart", resourceRoot,
	function( )
		removeWorldModel(11014, 100, -2056.6425, -103.7333, 35.3161)
		removeWorldModel(11372, 100, -2056.6425, -103.7333, 35.3161)
	end
)	