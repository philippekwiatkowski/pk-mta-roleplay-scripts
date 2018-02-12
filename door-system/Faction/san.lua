local sangate1 = createObject(3055, 1643.6640625, -1714.6693115234, 16, 0, 0, 270) -- Garage 
local sangate2 = createObject(3055, 1643.6879882813, -1696.4516601563, 16, 0, 0, 270) -- Garage

local sanopen1 = false
local sanopen2 = false

function opensangate(thePlayer)
	local x, y, z = getElementPosition(thePlayer)
	local distance1 = getDistanceBetweenPoints3D(1643.6640625, -1714.6693115234, 16, x, y, z)
	local distance2 = getDistanceBetweenPoints3D(1643.6879882813, -1696.4516601563, 16, x, y, z)


	if (distance1<=10) and (sanopen1==false) then
		if exports['[ars]inventory-system']:hasItem(thePlayer, 34) then
			sanopen1 = true
			outputChatBox("SAN Garage Door #1 is now open!", thePlayer, 0, 255, 0)
			moveObject(sangate1, 1000, 1643.6640625, -1714.6693115234, 11, 0, 0, 0)
			setTimer(closesangate, 5000, 1, thePlayer)
		end
	elseif (distance2<=10) and (sanopen2==false) then
		if exports['[ars]inventory-system']:hasItem(thePlayer, 34) then
			sanopen2 = true
			outputChatBox("SAN Garage Door #2 is now open!", thePlayer, 0, 255, 0)
			moveObject(sangate2, 1000, 1643.6879882813, -1696.4516601563, 11, 0, 0, 0)
			setTimer(closesangate, 5000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", opensangate)

function closesangate(thePlayer)
	if (sanopen1==true) then
		moveObject(sangate1, 1000, 1643.6640625, -1714.6693115234, 16, 0, 0, 0)
		sanopen1 = false
	elseif (sanopen2==true) then
		moveObject(sangate2, 1000, 1643.6879882813, -1696.4516601563, 16, 0, 0, 0)
		sanopen2 = false
	end
end

