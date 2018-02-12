-- Database details.
local hostname = "localhost"
local username = "root"
local password = "mysql"
local database = "roleplay"
local port = 3306

-- Result table
local resultTable = { }

-- Connect to database.
function connectToMysql( res )
	sqlConnection = mysql_connect(tostring(hostname), tostring(username), tostring(password), tostring(database), tonumber(port))
	
	if not sqlConnection then
		cancelEvent(true, "Unable to connect to MySQL Database.")
	end
end
addEventHandler("onResourceStart", resourceRoot, connectToMysql)

-- Disconnect from database.
function disconnectFromMysql( res )
	if sqlConnection then
		
		mysql_close(sqlConnection)
		outputServerLog("Resource '".. getResourceName(getThisResource()) .."' stopped, closed Database connection!") 
	end
end
addEventHandler("onResourceStop", resourceRoot, disconnectFromMysql)

function getResultID( )
	local size = #resultTable
	if (size == 0) then
		return 1 
	end
	for index, query in ipairs(resultTable) do
		if (query == nil) then
			return index
		end
	end
	return (size + 1)
end

-------------------- [ Export Functions ] --------------------

-- Triggers a query.
function query( str )
	if str then
		
		local result = mysql_query(sqlConnection, tostring(str))
		if (not result) then
			return false
		else
			
			local resultID = getResultID( )
			
			resultTable[resultID] = result
			return resultID
		end
	end	
end

-- Data fetching.
function fetch_assoc( resultID )
	if ( not resultTable[resultID]) then
		return false
	else
		
		return mysql_fetch_assoc(resultTable[resultID])
	end
end

function query_fetch_assoc( str )
	local query_result = query( tostring(str) )
	if not ( query_result == false ) then
	
		local result = fetch_assoc( query_result )
		free_result( query_result )
		return result
	else
		return false
	end
end

-- Returns the id of the query.
function insert_id( )
	local id = mysql_insert_id( sqlConnection )
	if ( id ) then	
		return id
	else
		return false
	end	
end

-- Returns the number of rows.
function num_rows( resultID )
	if ( not resultTable[resultID]) then
		return false
	else
		
		return mysql_num_rows(resultTable[resultID])
	end	
end
	
-- Is the column's value null?
function null( )
	return mysql_null
end
	
-- Frees the result.
function free_result( resultID )
	if ( not resultTable[resultID]) then
		return false
	else
		
		mysql_free_result(resultTable[resultID])
		table.remove(resultTable, resultID)
		return nil
	end
end
	
-- Error
function errno( )
	return mysql_errno( sqlConnection )
end

function err( )
	return mysql_error( sqlConnection )
end
	
-- Escapes security holes.
function escape_string( str )
	if str then
		return mysql_escape_string( sqlConnection, tostring(str) )
	end	
end