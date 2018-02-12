function c_isPlayerTrialModerator( thePlayer )
	if exports['[ars]anticheat-system']:c_callData( thePlayer, "admin") >= 1 then
		
		return true
	else
		return false
	end	
end	

function c_isPlayerModerator( thePlayer )
	if exports['[ars]anticheat-system']:c_callData( thePlayer, "admin") >= 2 then
		
		return true
	else
		return false
	end	
end	

function c_isPlayerHighModerator( thePlayer )
	if exports['[ars]anticheat-system']:c_callData( thePlayer, "admin") >= 3 then
		
		return true
	else
		return false
	end	
end	

function c_isPlayerAdministrator( thePlayer )
	if exports['[ars]anticheat-system']:c_callData( thePlayer, "admin") >= 4 then
		
		return true
	else
		return false
	end	
end	

function c_isPlayerHighAdministrator( thePlayer )
	if exports['[ars]anticheat-system']:c_callData( thePlayer, "admin") >= 5 then
		
		return true
	else
		return false
	end	
end

local scripters = { ["Dev"] = true, ["Coinz"] = true, ["Jamiez"] = true }
function c_isPlayerScripter( thePlayer )
	if scripters[ tostring( exports['[ars]anticheat-system']:c_callData( thePlayer, "accountname" ) ) ] then
		return true
	else
		return false
	end	
end	

function c_getPlayerAdminTitle( thePlayer )
	if exports['[ars]anticheat-system']:c_callData( thePlayer, "admin") == 1 then
		
		return "Trial Moderator"
	elseif exports['[ars]anticheat-system']:c_callData( thePlayer, "admin") == 2 then
		
		return "Moderator"
	elseif exports['[ars]anticheat-system']:c_callData( thePlayer, "admin") == 3 then
		
		return "High Moderator"
	elseif exports['[ars]anticheat-system']:c_callData( thePlayer, "admin") == 4 then
		
		return "Administrator"
	elseif exports['[ars]anticheat-system']:c_callData( thePlayer, "admin") == 5 then
		
		return "High Administrator"
	elseif exports['[ars]anticheat-system']:c_callData( thePlayer, "admin") == 6 then
		
		return "Sub-Owner"
	elseif exports['[ars]anticheat-system']:c_callData( thePlayer, "admin") == 7 then
		
		return "Server Owner"	
	else
		return "Player"
	end
end

function c_getPlayerAdminLevel( thePlayer )
	return exports['[ars]anticheat-system']:c_callData( thePlayer, "admin")
end	