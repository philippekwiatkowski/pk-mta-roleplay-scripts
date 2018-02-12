function c_isPlayerLevelOneDonator( thePlayer )
	if exports['[ars]anticheat-system']:c_callData(thePlayer, "donator") >= 1 then
		return true
	else
		return false
	end
end

function c_isPlayerLevelTwoDonator( thePlayer )
	if exports['[ars]anticheat-system']:c_callData(thePlayer, "donator") >= 2 then
		return true
	else
		return false
	end
end

function c_isPlayerLevelThreeDonator( thePlayer )
	if exports['[ars]anticheat-system']:c_callData(thePlayer, "donator") >= 3 then
		return true
	else
		return false
	end
end	

function c_getPlayerDonatorTitle( thePlayer )
	if exports['[ars]anticheat-system']:c_callData(thePlayer, "donator") == 1 then
		
		return "Level One Donator"
	elseif exports['[ars]anticheat-system']:c_callData(thePlayer, "donator") == 2 then
		
		return "Level Two Donator"
	elseif exports['[ars]anticheat-system']:c_callData(thePlayer, "donator") == 3 then	
	
		return "Level Three Donator"
	else
		return "Non-donator"
	end
end	