local sql = exports.sql

function giveMoneyToGovernment( money )
	
	local result = sql:query_fetch_assoc("SELECT `assets` FROM `government`")
	if ( result ) then
		
		local currentMoney = tonumber( result['assets'] )
		
		local update = sql:query("UPDATE `government` SET `assets`=".. sql:escape_string( tonumber( currentMoney + money ) ) .."")
		if ( not update ) then
			outputDebugString("MySQL Error: Unable to update government assets!")
			outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())	
		end
		
		sql:free_result(update)
	end	
end
addEvent("giveMoneyToGovernment", true)
addEventHandler("giveMoneyToGovernment", root, giveMoneyToGovernment)

function takeMoneyFromGovernment( money )
	
	local result = sql:query_fetch_assoc("SELECT `assets` FROM `government`")
	if ( result ) then
		
		local currentMoney = tonumber( result['assets'] )
		
		local update = sql:query("UPDATE `government` SET `assets`=".. sql:escape_string( tonumber( currentMoney - money ) ) .."")
		if ( not update ) then
			outputDebugString("MySQL Error: Unable to update government assets!")
			outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())	
		end
		
		sql:free_result(update)
	end	
end
addEvent("takeMoneyFromGovernment", true)
addEventHandler("takeMoneyFromGovernment", root, takeMoneyFromGovernment)