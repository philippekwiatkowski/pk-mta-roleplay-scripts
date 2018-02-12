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

--------- [ Client call backs ] ---------
function depositMoney( amount, accountID, primaryAccount )
	if (amount and accountID) then
		
		local money = tonumber( getPlayerMoney(source)/100 )
		
		-- Fix ( If you send 0.01 to serverside it changes to 0.00997.. )
		local amount = (amount)/100
		
		local playerName = tostring(getPlayerName(source):gsub("_", " "))
		
		local result = sql:query_fetch_assoc("SELECT balance, transactions FROM bankaccounts WHERE accountid=".. sql:escape_string(tonumber(accountID)) .."")
		local bankBalance = tonumber(result['balance'])
		
		local finalAmount = (bankBalance/100) + amount
		if ( finalAmount > 10000 ) and ( not primaryAccount ) then
			
			triggerClientEvent(source, "restoreBalance", source, amount)
		
			outputChatBox("The money on your secondry account cannot exceed $10,000.", source, 255, 0, 0)
			return
		else
			local transactions = result['transactions']
			
			local walletBalance = (money - amount)*100 

			-- Update Transaction
			local add = ";Deposit,".. playerName ..",C&C Bank,".. tostring(amount) ..",".. generateTimeStamp( ) ..",-"
			local transactions = transactions .. add
			
			local update = sql:query("UPDATE bankaccounts SET balance=".. sql:escape_string(bankBalance+(amount*100)) ..", transactions='".. sql:escape_string(tostring(transactions)) .."' WHERE accountid=".. sql:escape_string(tonumber(accountID)) .."")
			if (update) then
				
				setPlayerMoney(source, walletBalance)
				outputChatBox("You deposited $".. tostring(amount) .." to your bank account.", source, 212, 156, 49)
			else
				outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
			end
			
			sql:free_result(update)
		end
	end
end
addEvent("depositMoney", true)
addEventHandler("depositMoney", getRootElement(), depositMoney)	

function withdrawMoney( amount, accountID )
	if (amount and accountID) then
		
		-- Fix ( If you send 0.01 to serverside it changes to 0.00997.. )
		local amount = amount/100
		
		local playerName = tostring(getPlayerName(source):gsub("_", " "))
		
		local result = sql:query_fetch_assoc("SELECT balance, transactions FROM bankaccounts WHERE accountid=".. sql:escape_string(tonumber(accountID)) .."")
		local bankBalance = tonumber(result['balance'])
		local transactions = result['transactions']
		
		local walletBalance = amount*100

		-- Update Transaction
		local add = ";Withdraw,C&C Bank,".. playerName ..",".. tostring(amount) ..",".. generateTimeStamp( ) ..",-"
		local transactions = transactions .. add
		
		local update = sql:query("UPDATE bankaccounts SET balance=".. sql:escape_string(bankBalance-(amount*100)) ..", transactions='".. sql:escape_string(tostring(transactions)) .."' WHERE accountid=".. sql:escape_string(tonumber(accountID)) .."")
		if (update) then
			
			givePlayerMoney(source, walletBalance)
			outputChatBox("You withdrew $".. tostring(amount) .." from your bank account.", source, 212, 156, 49)
		else
			outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
		end
		
		sql:free_result(update)
	end
end
addEvent("withdrawMoney", true)
addEventHandler("withdrawMoney", getRootElement(), withdrawMoney)	

function transferMoney( amount, accountNo, accountID )
	if (amount and accountNo and accountID) then
		
		local accountNo = tonumber( accountNo )
		local accountID = tonumber( accountID )
		
		-- Fix ( If you send 0.01 to serverside it changes to 0.00997.. )
		local amount = amount/100
		
		local playerName = tostring(getPlayerName(source):gsub("_", " "))
		
		local ownerOne, balanceOne, transactionOne = nil
		local resultOne = sql:query_fetch_assoc("SELECT owner, balance, transactions FROM bankaccounts WHERE accountid=".. sql:escape_string(accountNo) .."")
		if (resultOne) then
			ownerOne = tostring(resultOne['owner'])
			balanceOne = tonumber(resultOne['balance'])
			transactionOne = tostring(resultOne['transactions'])
		else
			outputChatBox("Invalid Account No. entered.", source, 212, 156, 49)
			return
		end
		
		local resultTwo = sql:query_fetch_assoc("SELECT owner, balance, transactions FROM bankaccounts WHERE accountid=".. sql:escape_string(accountID) .."")
		local ownerTwo = tostring(resultTwo['owner'])
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
				
				triggerClientEvent(source, "restoreBalance", source, amount)
				
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
						
						triggerClientEvent(source, "restoreBalance", source, amount)
					
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
		
		sql:free_result(updateOne)
		sql:free_result(updateTwo)
		
		outputChatBox("You transferred $".. tostring(amount) .." to ".. tostring(ownerOne) ..".", source, 212, 156, 49)
	end	
end
addEvent("transferMoney", true)
addEventHandler("transferMoney", getRootElement(), transferMoney)

function createBankAccount( details )
	local name, address, phone, spouse, pin, job = tostring(details[1]), tostring(details[2]), tonumber(details[3]), tostring(details[4]), tonumber(details[5]), tostring(details[6])
	
	local insert = sql:query("INSERT INTO bankaccounts SET `owner`='".. sql:escape_string(name) .."', `address`='".. sql:escape_string(address) .."', `phone`=".. sql:escape_string(phone) ..", `spouse`='".. sql:escape_string(spouse) .."', `balance`='0', `pin`=".. sql:escape_string(pin) ..", `job`='".. sql:escape_string(job) .."', `transactions`=''")
	if (insert) then
		local insertid = sql:insert_id()
		
		local update = sql:query("UPDATE `bankaccounts` SET `accountid`=".. sql:escape_string(insertid + 65000) .." WHERE `id`=".. sql:escape_string(insertid))
		if (update) then
			triggerClientEvent(source, "receiveAccountCreateMessage", source, true)
			triggerEvent("sendPlayerBankAccounts", source)
		end	
	else
		outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
	end	
	
	sql:free_result(insert)
end
addEvent("createBankAccount", true)
addEventHandler("createBankAccount", getRootElement(), createBankAccount)

--------- [ Custom functions ] ---------
function generateTimeStamp( )
	local hour = getRealTime().hour
	local minute = getRealTime().minute
	local second = getRealTime().second
	
	local monthday = getRealTime().monthday
	local month = (getRealTime().month) + 1
	local year = (getRealTime().year) + 1900
	
	return tostring(year) .."-".. tostring(string.format("%02d", month)) .."-".. tostring(string.format("%02d", monthday)) .." ".. tostring(string.format("%02d", hour)) ..":".. tostring(string.format("%02d", minute)) ..":".. tostring(string.format("%02d", second))
end
	
--------- [ SQL fetching ] ---------
function sendPlayerBankAccounts( )
	local playerName = getPlayerName(source):gsub("_", " ")
	if (playerName) then
		
		local accounts = { }
		local accountNo = 1
		
		local result = sql:query("SELECT accountid, balance, pin, transactions FROM bankaccounts WHERE owner='".. sql:escape_string(playerName) .."'")
		while true do
			local row = sql:fetch_assoc(result)
			if not (row) then break end
			
			local accountid = tonumber(row['accountid'])
			local balance = tonumber(row['balance'])
			local pin = tonumber(row['pin'])
			local transactions = tostring(row['transactions'])
			
			accounts[accountNo] = {accountid, balance, pin, transactions}
			
			accountNo = accountNo + 1
		end
		
		sql:free_result(result)
		
		triggerClientEvent(source, "receivePlayerBankAccounts", source, accounts)
	end		
end
addEvent("sendPlayerBankAccounts", true)
addEventHandler("sendPlayerBankAccounts", root, sendPlayerBankAccounts)	