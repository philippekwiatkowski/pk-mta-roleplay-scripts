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

--------- [ Paycheck System ] ---------

local governmentAssets, stateBenefits, governmentTax, bankInterest = 0, 0, 0, 0
function getGovernmentAssets(  )
	
	local result = sql:query_fetch_assoc("SELECT `assets`, `benefits`, `tax`, `interest` FROM `government`")
	if ( result ) then
	
		governmentAssets = result['assets']
		stateBenefits = result['benefits']
		governmentTax = result['tax']
		bankInterest = result['interest']
	end
end
addEventHandler("onResourceStart", resourceRoot, getGovernmentAssets)	
	
local totalPlayers = 0	
function payCheck( thePlayer )
	if ( thePlayer ) then
		if ( getPlayerName(thePlayer) ~="Mark_Andrews" ) then	-- Me :P
			return
		else
			payCheck(  )
		end
	else
		
		for key, thePlayer in ipairs( getElementsByType("player") ) do
			if ( getData( thePlayer, "loggedin" ) == 1 ) then
				
				local dbid = tonumber( getData( thePlayer, "dbid" ) )
				if ( dbid ) then
					
					-- Check Bankaccount!
					local bankAccounts = { }
				
					local resultAccount = sql:query("SELECT `accountid`, `balance`, `transactions` FROM `bankaccounts` WHERE `owner`='".. sql:escape_string( tostring( getPlayerName( thePlayer ):gsub("_", " ") ) ) .."'")
					
					local accountCount = 0
					while true do
						local row = sql:fetch_assoc( resultAccount )
						if ( not row ) then 
						
							break 
						end
							
						local accountid = tonumber( row['accountid'] )
						local balance = tonumber( row['balance'] )/100
						local transactions = tostring( row['transactions'] )
						
						bankAccounts[accountid] = { math.floor( ( stateBenefits/100 ) * governmentTax ), math.floor( balance * bankInterest ), balance, transactions }
						
						accountCount = accountCount + 1
					end	
					
					sql:free_result(resultAccount)
					
					if ( accountCount > 0 ) then
						
						-- Counting of Vehicles & Properties
						local totalVehicles, totalProperty = 0, 0
						
						local resultVehicle = sql:query_fetch_assoc("SELECT COUNT(*) as `vehCount` FROM `vehicles` WHERE `owner`=".. sql:escape_string( tonumber( dbid ) ) .."")
						if ( resultVehicle ) then
							
							totalVehicles = tonumber( resultVehicle['vehCount'] )
						end
						
						local resultInterior = sql:query_fetch_assoc("SELECT COUNT(*) as `propertyCount` FROM `interiors` WHERE `owner`=".. sql:escape_string( tonumber( dbid ) ) .." AND `rent`='0'")
						if ( resultInterior ) then
							
							totalProperty = tonumber( resultInterior['propertyCount'] )
						end
						
						-- Listing of Rented Houses
						local rented = { }
						local resultRented = sql:query("SELECT `price` FROM `interiors` WHERE `owner`=".. sql:escape_string( tonumber( dbid ) ) .." AND `rent`='1'")
						while true do
							local row = sql:fetch_assoc( resultRented )
							if ( not row ) then 
				
								break 
							end
								
							local price = tonumber( row['price'] )
							table.insert(rented, price)
						end
						
						sql:free_result(resultRented)
						
						local factionID = tonumber( getData( thePlayer, "faction" ) )
						local factionRank = tonumber( getData( thePlayer, "f:rank" ) )
						
						local getBenefits = true
						local playerWage = false
						local incomeTax = false
						
						if ( factionID >= 1 and factionID <= 4 ) then -- Government Faction
							getBenefits = false
							playerWage = tonumber( exports['[ars]faction-system']:getPlayerWage( factionID, factionRank ) )
						end
						
						totalPlayers = totalPlayers + 1
						
						triggerClientEvent(thePlayer, "giveClientPaycheck", thePlayer, factionID, bankAccounts, totalVehicles, totalProperty, rented, getBenefits, playerWage, stateBenefits, governmentTax, bankInterest )
						
					else
						outputChatBox("You need a bank account in order to obtain your paycheck.", thePlayer, 255, 0, 0)	
					end
					
					-- Playing Hours
					local hoursplayed = tonumber( getData(thePlayer, "hoursplayed") )
					setData(thePlayer, "hoursplayed", hoursplayed + 1, true)
				end	
			end
		end
		
		updateGovernmentAssets( )
	end	
end
addCommandHandler("paycheck", payCheck, false, false)

local governmentDeduction = 0
local toldClients = { }
function tellClientPaycheck( playerWage, netIncome, factionID, count, bankBalance, bankTransactions, accountID )
	
	local playerWage = tonumber( playerWage )
	local netIncome = tonumber( netIncome )
	local factionID = tonumber( factionID )
	local count = tonumber( count )
	local bankBalance = tonumber( bankBalance )
	local bankTransactions = tostring( bankTransactions )
	local accountID = tonumber( accountID )
	
	local payFrom, payAs = nil

	if ( factionID >= 1 and factionID <= 4 ) and ( count == 1 ) then -- Faction Wage
		
		local result = sql:query_fetch_assoc("SELECT `balance` FROM `factions` WHERE `id`=".. sql:escape_string( tonumber( factionID ) ) .."")
		if ( result ) then
			
			local factionBalance = tonumber( result['balance'] )
			local deduction = ( factionBalance / 100) - playerWage
			
			for key, value in ipairs ( getElementsByType("team") ) do
				
				local dbid = tonumber( getData( value, "id" ) )
				if ( dbid == factionID ) then
				
					setData( value, "balance", deduction * 100, true )
					break
				end
			end
			
			local update = sql:query("UPDATE `factions` SET `balance`=".. sql:escape_string( deduction*100 ) .." WHERE `id`=".. sql:escape_string( tonumber( factionID ) ) .."")
			sql:free_result(update)
		end
	
		governmentDeduction = governmentDeduction + ( netIncome - playerWage )
		payFrom, payAs = "Work place", "Wage"
	else															-- State Benefits
	
		governmentDeduction = governmentDeduction + netIncome
		payFrom, payAs = "Government", "Paycheck"
	end

	-- Transaction Update
	local transactions = bankTransactions ..";Deposit,".. payFrom ..",".. getPlayerName( source ):gsub("_", " ") ..",".. netIncome ..",".. generateTimeStamp( ) ..",".. payAs

	local update = sql:query("UPDATE `bankaccounts` SET `balance`=".. sql:escape_string( tonumber( bankBalance + netIncome ) * 100 ) ..", `transactions`='".. sql:escape_string( tostring( transactions ) ) .."' WHERE `accountid`=".. sql:escape_string( tonumber( accountID ) ))
	if ( not update ) then
		outputDebugString("MySQL Error: Unable to update bankaccount!")
		outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
	end
	
	sql:free_result(update)
	
	-- Check that all received paycheck!
	if ( #toldClients == 0 ) then
		toldClients[#toldClients + 1] = source
	else	
		for key, value in pairs ( toldClients ) do
			if ( value ~= source ) then
				
				toldClients[#toldClients + 1] = source
			end	
		end
	end	
end
addEvent("tellClientPaycheck", true)
addEventHandler("tellClientPaycheck", root, tellClientPaycheck)

local timeouts = 0
function updateGovernmentAssets( )
	setTimer( 
		function( )
			
			if ( totalPlayers == #toldClients ) or ( timeouts > 5 ) then
				
				-- Money From Government
				local update = sql:query("UPDATE `government` SET `assets`=".. sql:escape_string( tonumber( governmentAssets ) - governmentDeduction ) .."")
				if ( not update ) then
					outputDebugString("MySQL Error: Unable to update government assets!")
					outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
				else
					getGovernmentAssets(  )
					
					totalPlayers = 0
					governmentDeduction = 0
					toldClients = { }
					
				end
				
				sql:free_result(update)
			else
				timeouts = timeouts + 1
				updateGovernmentAssets( )
			end
		end, 2000, 1	
	)	
end

-- Trigger Payday each Hour
local justPayday = false
setTimer(
	function( )
		local _, mins = getTime( )
		if ( mins == 00 ) then
			
			if ( not justPayday ) then
				payCheck( )
				
				justPayday = true
				setTimer( function( ) justPayday = false end, 120000, 1)
			end	
		end	
	end, 10000, 0
)
	
function generateTimeStamp( )
	local hour = getRealTime().hour
	local minute = getRealTime().minute
	local second = getRealTime().second
	
	local monthday = getRealTime().monthday
	local month = (getRealTime().month) + 1
	local year = (getRealTime().year) + 1900
	
	return tostring(year) .."-".. tostring(string.format("%02d", month)) .."-".. tostring(string.format("%02d", monthday)) .." ".. tostring(string.format("%02d", hour)) ..":".. tostring(string.format("%02d", minute)) ..":".. tostring(string.format("%02d", second))
end	