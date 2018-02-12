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
	if isElement(theElement) and (key) and (value) then
		
		return exports['[ars]anticheat-system']:assignData( theElement, tostring(key), value, sync )
	else
		return false
	end	
end

--------- [ Admin Commands ] ---------

-- /makeatm
-- /delatm
-- /setatmlimit
-- /setatmdepositable

-- /makeatm
function makeATM( thePlayer, commandName, depositable, atmLimit )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerAdministrator(thePlayer) then
		
		local depositable = tonumber(depositable)
		local atmLimit = tonumber(atmLimit)
		
		if not (depositable) then
			depositable = 0
		end	
		
		if not (atmLimit) then
			atmLimit = 5000
		end	
			
		if (depositable == 1) or (depositable == 0) then
				
			if (atmLimit >= 5000) and (atmLimit <= 10000) then
				
				local x, y, z = getElementPosition(thePlayer)
				local rot = getPedRotation(thePlayer) - 180
				local int = getElementInterior(thePlayer)
				local dim = getElementDimension(thePlayer)
					
				z = z - 0.5
					
				local insert = sql:query("INSERT INTO atms SET x=".. sql:escape_string(tonumber(x)) ..", y=".. sql:escape_string(tonumber(y)) ..", z=".. sql:escape_string(tonumber(z)) ..", rotation=".. sql:escape_string(tonumber(rot)) ..", dimension=".. sql:escape_string(tonumber(dim)) ..", interior=".. sql:escape_string(tonumber(int)) ..", deposit=".. sql:escape_string(tonumber(depositable)) ..", `limit`=".. sql:escape_string(tonumber(atmLimit)) .."")
				if (insert) then
						
					local dbid = tonumber(sql:insert_id())
						
					local atm = createObject(2942, x, y, z, 0, 0, rot)
					setData(atm, "dbid", dbid, true)
					setData(atm, "deposit", depositable, true)
					setData(atm, "limit", atmLimit, true)
						
					setElementPosition(thePlayer, x, y, z+1)
					
					setElementInterior(atm, tonumber(int))
					setElementDimension(atm, tonumber(dim))
		
					outputChatBox("ATM created with ID ".. dbid ..".", thePlayer, 0, 255, 0)
				else
					outputDebugString("MySQL Error: Unable to create atm!")
					outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
				end
				
				sql:free_result(insert)
			else
				outputChatBox("ATM Limit should be between 5000 and 10000.", thePlayer, 255, 0, 0)
			end	
		else
			outputChatBox("Depositable value can only be 1 ( true ) or 0 ( false )", thePlayer, 255, 0, 0)
		end
	end
end	
addCommandHandler("makeatm", makeATM, false, false)

-- /delatm
function deleteATM( thePlayer, commandName, atmID )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerAdministrator(thePlayer) then
		
		if (atmID) then
			
			local atmID = tonumber(atmID)
			
			local found = false
			for i, v in ipairs (getElementsByType("object")) do
				if (getElementModel(v) == 2942) then
					
					local dbid = tonumber(getData(v, "dbid"))
					if (dbid == atmID) then
						
						destroyElement(v)
						outputChatBox("Deleted ATM with ID ".. atmID ..".", thePlayer, 0, 255, 0)
						
						found = true
						break
					end
				end
			end
				
			if (found) then
				
				local delete = sql:query("DELETE FROM atms WHERE id=".. sql:escape_string(atmID) .."")
				if (not delete) then
				
					outputDebugString("MySQL Error: Unable to delete atm!")
					outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
				end
				
				sql:free_result(delete)
			else
				outputChatBox("Couldn't find ATM with ID ".. atmID ..".", thePlayer, 255, 0, 0)
			end	
			
		else
			outputChatBox("SYNTAX: /".. commandName .." [ATM ID]", thePlayer, 212, 156, 49)
		end	
	end
end	
addCommandHandler("delatm", deleteATM, false, false)
addCommandHandler("deleteatm", deleteATM, false, false)

-- /setatmlimit
function setATMWithdrawLimit( thePlayer, commandName, atmID, atmLimit )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerAdministrator(thePlayer) then
		
		if (atmID) and (atmLimit) then
			
			local atmID = tonumber(atmID)
			local atmLimit = tonumber(atmLimit)
			
			if (atmLimit >= 5000) and (atmLimit <= 10000) then
				
				local found = false
				for i, v in ipairs (getElementsByType("object")) do
					if (getElementModel(v) == 2942) then
						
						local dbid = tonumber(getData(v, "dbid"))
						if (dbid == atmID) then
							
							setData(v, "limit", atmLimit, true)
							outputChatBox("Changed widthdraw limit of ATM ID ".. atmID .." to ".. atmLimit ..".", thePlayer, 0, 255, 0)
							
							found = true
							break
						end
					end
				end
					
				if (found) then
					
					local update = sql:query("UPDATE atms SET `limit`=".. sql:escape_string(atmLimit) .." WHERE id=".. sql:escape_string(atmID) .."")
					if (not update) then
					
						outputDebugString("MySQL Error: Unable to update atm withdraw limit!")
						outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
					end
					
					sql:free_result(update)
				else
					outputChatBox("Couldn't find ATM with ID ".. atmID ..".", thePlayer, 255, 0, 0)
				end	
			else
				outputChatBox("ATM Limit should be between 5000 and 10000.", thePlayer, 255, 0, 0)
			end	
		else
			outputChatBox("SYNTAX: /".. commandName .." [ATM ID] [Widthdraw limit]", thePlayer, 212, 156, 49)
		end	
	end
end	
addCommandHandler("setatmlimit", setATMWithdrawLimit, false, false)

-- /setatmdepositable
function setATMDepositable( thePlayer, commandName, atmID, depositable )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerAdministrator(thePlayer) then
		
		if (atmID) and (depositable) then
			
			local atmID = tonumber(atmID)
			local depositable = tonumber(depositable)
			
			if (depositable == 1) or (depositable == 0) then
				
				local found = false
				for i, v in ipairs (getElementsByType("object")) do
					if (getElementModel(v) == 2942) then
						
						local dbid = tonumber(getData(v, "dbid"))
						if (dbid == atmID) then
							
							setData(v, "deposit", depositable, true)
							outputChatBox("Changed deposit value of ATM ID ".. atmID .." to ".. depositable ..".", thePlayer, 0, 255, 0)
							
							found = true
							break
						end
					end
				end
					
				if (found) then
					
					local update = sql:query("UPDATE atms SET deposit=".. sql:escape_string(depositable) .." WHERE id=".. sql:escape_string(atmID) .."")
					if (not update) then
					
						outputDebugString("MySQL Error: Unable to update atm deposit value!")
						outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
					end
					
					sql:free_result(update)
				else
					outputChatBox("Couldn't find ATM with ID ".. atmID ..".", thePlayer, 255, 0, 0)
				end	
			else
				outputChatBox("Depositable value can only be 1 ( true ) or 0 ( false )", thePlayer, 255, 0, 0)
			end	
		else
			outputChatBox("SYNTAX: /".. commandName .." [ATM ID] [Depositable (1/0)]", thePlayer, 212, 156, 49)
		end	
	end
end
addCommandHandler("setatmdepositable", setATMDepositable, false, false)

function nearbyAtms( thePlayer, commandName )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		local x, y, z = getElementPosition( thePlayer )
		local count = 0
		
		outputChatBox("~-~-~-~-~-~-~-~ Nearby ATMs ~-~-~-~-~-~-~-~", thePlayer, 212, 156, 49)

		for i, v in ipairs (getElementsByType("object")) do
			if (getElementModel(v) == 2942) then
				
				local ox, oy, oz = getElementPosition( v )
				if ( getDistanceBetweenPoints3D( x, y, z, ox, oy, oz ) <= 10 ) then
					
					count = count + 1
					
					local dbid = tonumber( getData( v, "dbid" ) )
					outputChatBox("#".. count ..": ".. dbid, thePlayer, 212, 156, 49)
				end	
			end
		end	
		
		if ( count == 0 ) then
			outputChatBox("No ATMs nearby you.", thePlayer, 212, 156, 49)
		end
	end	
end
addCommandHandler("nearbyatms", nearbyAtms, false, false)

--------- [ Client Callbacks ] ---------
function getBankAccountData( pinCode )
	local pinCode = tonumber(pinCode)
	
	local result = sql:query_fetch_assoc("SELECT accountid, balance, transactions FROM bankaccounts WHERE pin=".. sql:escape_string(pinCode) .." and owner='".. sql:escape_string(tostring(getPlayerName(source):gsub("_", " "))) .."'")
	if (result) then
		
		local accountID = tonumber(result['accountid'])
		local balance = tonumber(result['balance'])
		local transactions = tostring(result['transactions'])
		
		triggerClientEvent(source, "giveBankAccountData", source, accountID, balance, transactions)
	else
		triggerClientEvent(source, "showPINCodeError", source, "Invalid PIN code entered.")
	end			
end
addEvent("getBankAccountData", true)
addEventHandler("getBankAccountData", getRootElement(), getBankAccountData)

-- Withdraw
function withdrawAmount( amount, accountID )
	local amount = tonumber(string.format("%.2f", amount))
	local accountID = tonumber(accountID)
	
	local result = sql:query_fetch_assoc("SELECT owner, accountid, balance, transactions FROM bankaccounts WHERE accountid=".. sql:escape_string(accountID) .."")
	local owner = tostring(result['owner'])
	local accountid = tonumber(result['accountid'])
	local balance = tonumber(result['balance'])
	local transactions = tostring(result['transactions'])
	
	-- Update Transaction
	local add = ";Withdraw,C&C Bank,".. tostring(owner) ..",".. tostring(amount) ..",".. generateTimeStamp( ) ..",-"
	local transactions = transactions .. add
	
	local update = sql:query("UPDATE bankaccounts SET balance=".. sql:escape_string(balance-(amount*100)) ..", transactions='".. sql:escape_string(tostring(transactions)) .."' WHERE accountid=".. sql:escape_string(accountID) .."")
	if (update) then
		givePlayerMoney(source, amount*100)
		
		outputChatBox("You withdrew $".. tostring(amount) .." from your bank account.", source, 212, 156, 49) 
	else
		outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
	end
	
	sql:free_result(update)
end
addEvent("withdrawAmount", true)
addEventHandler("withdrawAmount", getRootElement(), withdrawAmount)

-- Transfer
function transferAmount( amount, accountNo, accountID )
	local amount = tonumber(string.format("%.2f", amount))
	local accountNo = tonumber(accountNo)
	local accountID = tonumber(accountID)
	
	local ownerOne = nil
	local balanceOne = nil
	local resultOne = sql:query_fetch_assoc("SELECT owner, accountid, balance, transactions FROM bankaccounts WHERE accountid=".. sql:escape_string(accountNo) .."")
	if (resultOne) then
		ownerOne = tostring(resultOne['owner'])
		accountidOne = tonumber(resultOne['accountid'])
		balanceOne = tonumber(resultOne['balance'])
		transactionOne = tostring(resultOne['transactions'])
	else
		outputChatBox("Invalid Account No. entered.", source, 212, 156, 49)
		return
	end
	
	local resultTwo = sql:query_fetch_assoc("SELECT owner, accountid, balance, transactions FROM bankaccounts WHERE accountid=".. sql:escape_string(accountID) .."")
	local ownerTwo = tostring(resultTwo['owner'])
	local accountidTwo = tonumber(resultTwo['accountid'])
	local balanceTwo = tonumber(resultTwo['balance'])
	local transactionTwo = tostring(resultTwo['transactions'])
	
	local secondryAccount = false
	if ( ownerTwo == ownerOne ) then
		if ( accountNo > accountID ) then
			secondryAccount = true
		end
	end	
		
	if ( secondryAccount ) then
		if ( amount > 10000 ) then
	
			outputChatBox("You cannot transfer more than $10,000 to your secondry account.", source, 255, 0, 0)
			return
		end
	else
		local result = sql:query_fetch_assoc("SELECT `account` FROM `characters` WHERE `charactername`='".. sql:escape_string( ownerOne ) .."'")
		if ( result ) then
			
			if ( ownerTwo ~= ownerOne ) then
				
				local playerAccount = tonumber( getData( source, "accountid") )
				local account = tonumber( result['account'] )
					
				if ( playerAccount == account ) then
				
					outputChatBox("You cannot transfer money between your characters.", source, 255, 0, 0)
					return
				end
			end	
		end	
	end
		
	-- Update Transaction
	local addOne = ";Received,".. tostring(ownerTwo) ..",".. tostring(ownerOne) ..",".. tostring(amount) ..",".. generateTimeStamp( ) ..",-"
	local transactionOne = transactionOne .. addOne
	
	local addTwo = ";Transfer,".. tostring(ownerTwo) ..",".. tostring(ownerOne) ..",".. tostring(amount) ..",".. generateTimeStamp( ) ..",-"
	local transactionTwo = transactionTwo .. addTwo
	
	local updateOne = sql:query("UPDATE bankaccounts SET balance=".. sql:escape_string(balanceOne + (amount*100)) ..", transactions='".. sql:escape_string(tostring(transactionOne)) .."' WHERE accountid=".. sql:escape_string(accountNo) .."")
	local updateTwo = sql:query("UPDATE bankaccounts SET balance=".. sql:escape_string(balanceTwo - (amount*100)) ..", transactions='".. sql:escape_string(tostring(transactionTwo)) .."' WHERE accountid=".. sql:escape_string(accountID) .."")
	
	outputChatBox("You transferred $".. tostring(amount) .." to ".. tostring(ownerOne) ..".", source, 212, 156, 49)
	triggerClientEvent(source, "remoteCloseATM", source)
	
	if (not updateOne) or (not updateTwo) then
		outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())	
	end	
	
	sql:free_result(updateOne)
	sql:free_result(updateTwo)
end
addEvent("transferAmount", true)
addEventHandler("transferAmount", getRootElement( ), transferAmount)

function generateTimeStamp( )
	local hour = getRealTime().hour
	local minute = getRealTime().minute
	local second = getRealTime().second
	
	local monthday = getRealTime().monthday
	local month = (getRealTime().month) + 1
	local year = (getRealTime().year) + 1900
	
	return tostring(year) .."-".. tostring(string.format("%02d", month)) .."-".. tostring(string.format("%02d", monthday)) .." ".. tostring(string.format("%02d", hour)) ..":".. tostring(string.format("%02d", minute)) ..":".. tostring(string.format("%02d", second))
end

--------- [ ATM Spawn ] ---------
function spawnATMOnStart( res )
	
	local result = sql:query("SELECT id, x, y, z, rotation, interior, dimension, deposit, `limit` FROM atms")
	while true do
		local row = sql:fetch_assoc(result)
		if not (row) then break end
		
		local dbid = row['id']
		local x = row['x']
		local y = row['y']
		local z = row['z']
		local rot = row['rotation']
		local int = row['interior']
		local dim = row['dimension']
		local deposit = row['deposit']
		local limit = row['limit']
		
		local atm = createObject(2942, tonumber(x), tonumber(y), tonumber(z), 0, 0, tonumber(rot))
		
		setElementInterior(atm, tonumber(int))
		setElementDimension(atm, tonumber(dim))
		
		setData(atm, "dbid", tonumber(dbid), true)
		setData(atm, "deposit", tonumber(deposit), true)
		setData(atm, "limit", tonumber(limit), true)
	end

	sql:free_result(result)	
end
addEventHandler("onResourceStart", resourceRoot, spawnATMOnStart)