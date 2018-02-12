function getPlayerPosition( thePlayer, commandName )
	if isPlayerTrialModerator(thePlayer) or isPlayerScripter(thePlayer) then
		
		local x, y, z = getElementPosition(thePlayer)
		local rot = getPedRotation(thePlayer)
		local int = getElementInterior(thePlayer)
		local dim = getElementDimension(thePlayer)
		
		local decimalX, decimalY, decimalZ = decimalPlace(x), decimalPlace(y), decimalPlace(z)
		
		x = string.sub(x, 1, decimalX + 4)
		y = string.sub(y, 1, decimalY + 4)
		z = string.sub(z, 1, decimalZ + 4)
		
		rot = string.format("%d", rot)
		
		outputChatBox(x ..", ".. y ..", ".. z, thePlayer, 212, 156, 49)
		outputChatBox("Rotation: ".. rot, thePlayer, 212, 156, 49)
		outputChatBox("Interior: ".. int, thePlayer, 212, 156, 49)
		outputChatBox("Dimension: ".. dim, thePlayer, 212, 156, 49)
	end	
end
addCommandHandler("getpos", getPlayerPosition, false, false)

function decimalPlace( num )

	local num = tostring(num)
	local len = string.len(num)
	
	local place, i = nil, 1
	while i <= len do
		if ( string.sub(num, i, i) == "." ) then
			
			place = i
			break
		else
			i = i + 1
		end	
	end
	
	return place
end