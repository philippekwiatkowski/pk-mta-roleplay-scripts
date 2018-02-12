function isPlayerLevelOneDonator( thePlayer )
	if exports['[ars]anticheat-system']:callData(thePlayer, "donator") >= 1 then
		return true
	else
		return false
	end
end

function isPlayerLevelTwoDonator( thePlayer )
	if exports['[ars]anticheat-system']:callData(thePlayer, "donator") >= 2 then
		return true
	else
		return false
	end
end

function isPlayerLevelThreeDonator( thePlayer )
	if exports['[ars]anticheat-system']:callData(thePlayer, "donator") >= 3 then
		return true
	else
		return false
	end
end	

function getPlayerDonatorTitle( thePlayer )
	if exports['[ars]anticheat-system']:callData(thePlayer, "donator") == 1 then
		
		return "Level One Donator"
	elseif exports['[ars]anticheat-system']:callData(thePlayer, "donator") == 2 then
		
		return "Level Two Donator"
	elseif exports['[ars]anticheat-system']:callData(thePlayer, "donator") == 3 then	
	
		return "Level Three Donator"
	else
		return "Non-donator"
	end
end