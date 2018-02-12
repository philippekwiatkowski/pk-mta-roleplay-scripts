local allowSave = false
local sql = exports.sql

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

local fileName = nil
function getBankBalances( thePlayer, commandName )
	if ( thePlayer ) then
		
		if ( getData(thePlayer, "loggedin") ~= 1 ) or ( not exports['[ars]global']:isPlayerTrialModerator(thePlayer) ) then
			return
		end
	end	
	
	local bankaccounts = { }
	
	local result = sql:query("SELECT `id`, `balance` FROM `bankaccounts`")
	while true do
		local row = sql:fetch_assoc(result)
		
		if ( not row ) then
			break 
		end
		
		local id = tonumber( row['id'] )
		local balance = tonumber( row['balance'] )
		
		bankaccounts[id] = balance
	end
	
	sql:free_result(result)
	
	if ( thePlayer ) then
		saveBankBalances( thePlayer, bankaccounts )
	else
		saveBankBalances( false, bankaccounts )
	end	
end
addCommandHandler("savebank", getBankBalances, false, false)

function saveBankBalances( thePlayer, bankaccounts )
	if ( bankaccounts ) then -- Table
	
		local backup = fileCreate(tostring( fileName ) ..".sql")  
		if ( backup ) then
			
			for key, value in pairs ( bankaccounts ) do
				local id = tonumber( key )
				local balance = tonumber( value )
		
				fileWrite( backup, "UPDATE `bankaccounts` SET `balance`=".. balance .." WHERE `id`=".. id ..";" )
			end
			
			fileFlush( backup )
			fileClose( backup ) 
			
			if ( thePlayer ) then
				outputChatBox("Backup created! (".. fileName ..".sql )", thePlayer, 212, 156, 49)
			end	
		
			bankaccounts = { }
		end	
	end	
end
	
local threads = { }	
function restoreBankBalances( thePlayer, commandName )
	if ( thePlayer ) then
		if ( getData(thePlayer, "loggedin") ~= 1 ) or ( not exports['[ars]global']:isPlayerTrialModerator(thePlayer) ) then
			
			return
		end
	end
	
	outputDebugString("======== Restoring bankaccounts... (".. fileName ..".sql) ========")
	
	getTickStart = getTickCount( )

	local backup = fileOpen(fileName ..".sql", true)
	if ( backup ) then
	
		local size = fileGetSize( backup )			
		while ( not fileIsEOF( backup ) ) do          
			local queries = fileRead( backup, size )
			
			for key, query in ipairs ( split(queries, ";") ) do
				
				local co = coroutine.create( executeOneQuery )
				coroutine.resume( co, tostring( query ), true )
				
				table.insert( threads, co )
			end	
		end
		
		-- Steady
		setTimer(resume, 100, #threads )
		
		if ( thePlayer ) then
			outputChatBox("Restored bankaccounts! (".. fileName ..".sql)", thePlayer, 0, 255, 0)
		end	
		
		fileClose( backup )
	end
end
addCommandHandler("restorebank", restoreBankBalances, false, false)	

local count = 0
function resume( )
	count = count + 1
	coroutine.resume( threads[count] )
	
	if ( count == #threads ) then
		
		threads = nil
		threads = { }
		
		getTickEnd = getTickCount( )
		
		outputDebugString("======== Restored bankaccounts! [".. count .." in " .. ( getTickEnd - getTickStart )/1000 .." seconds] (".. fileName ..".sql) ========")
		count = 0
	end	
end

function executeOneQuery( query, yield )
	if ( query ) then
		
		if ( yield ) then
			
			coroutine.yield( )
		end

		local update = sql:query( tostring( query ) )
		if ( not update ) then
			
			outputDebugString("SQL Error!")
		end	
		
		sql:free_result(update)
	end	
end

local save = 0
function isBankBugged( )
	local balances = { }
	
	local rows = 0
	local result = sql:query("SELECT `balance` FROM `bankaccounts`")
	while true do
		local row = sql:fetch_assoc(result)
		
		if ( rows == 10 ) then		-- Get the First 10 rows
			break 
		end
		
		local balance = tonumber( row['balance'] )
		balances[#balances + 1] = balance
		
		rows = rows + 1
	end
	
	sql:free_result(result)
	
	local lastBalance = nil
	local same = 0
	for i = 1, #balances do
		
		if ( same <= 5 ) then	-- Occurance is smaller than 5
			local balance = tonumber( balances[i] )
			
			if ( i == 1 ) then
				lastBalance = balance
			else
				if ( lastBalance == balance ) then -- 100 == 
					same = same + 1
				else
					
					lastBalance = balance
				end	
			end
		else					-- About 5 bankaccounts have the same balance
			balances = nil
			
			restoreBankBalances( false, "restorebank" )	-- Fix
			return
		end
	end
	
	balances = nil
	
	if ( save == 45 ) then
		if ( same <= 5 ) then	  -- Otherwise, another backup
			getBankBalances( false, "savebank" )
		end
		
		save = 0
		return
	end	
	
	save = save + 1
end

addCommandHandler("togbanksave",
	function( thePlayer, commandName )
		if ( getData(thePlayer, "loggedin") == 1 ) and ( exports['[ars]global']:isPlayerAdministrator(thePlayer) ) then
		
			if ( allowSave ) then
				
				allowSave = false
				outputChatBox("Bank saving disabled!", thePlayer, 255, 0, 0)
			else
				
				allowSave = true
				outputChatBox("Bank saving enabled!", thePlayer, 0, 255, 0)
			end	
		end
	end
)	

function inspectBankAccounts( )
	local _, minutes = getTime( )
	if ( minutes > 0 ) and ( minutes <= 30 ) then
		fileName = "bank"
	else
		fileName = "bank2"
	end
	
	if ( allowSave ) then
		isBankBugged( )
	end	
end

setTimer( inspectBankAccounts, 20000, 0 )