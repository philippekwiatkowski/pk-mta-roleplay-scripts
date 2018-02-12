local pdgate1 = createObject(968, 1544.6875, -1630.785546875, 13.1828125, 0, 90, 90) -- Barrier
local pdgate2 = createObject(3055, 1588.5490234375, -1637.95546875, 13.846516990662, 0, 0, 180) -- Garage
local pdgate3 = createObject(4100, 1577.4779052734, -1617.7227783203, 14.1, 0, 0, 320.31500244141) -- Impound
local pdgate4 = createObject(4100, 1587.1, -1611.25, 14.1, 0, 0, 25.804992675781) -- Impound


createObject(970, 1544.318359375, -1621.5888671875, 13, 0, 0, 90)
createObject(970, 1544.318359375, -1619.5888671875, 13, 0, 0, 90)

createObject(970, 1544.318359375, -1634.5888671875, 13, 0, 0, 90)
createObject(970, 1544.318359375, -1637.5888671875, 13, 0, 0, 90)

createObject(3055, 1580.5490234375, -1637.95546875, 13.446516990662, 0, 0, 180)

local pdopen1 = false
local pdopen2 = false
local pdopen3 = false

function openpdgate(thePlayer)
	local x, y, z = getElementPosition(thePlayer)
	local distance1 = getDistanceBetweenPoints3D(1544.6875, -1630.785546875, 13.1828125, x, y, z)
	local distance2 = getDistanceBetweenPoints3D(1588.5490234375, -1637.95546875, 13.846516990662, x, y, z)
	local distance3 = getDistanceBetweenPoints3D(1581.0400390625, -1617.6396484375, 13.3828125, x, y, z)

	if (distance1<=10) and (pdopen1==false) then
		if exports['[ars]inventory-system']:hasItem(thePlayer, 32) then
			pdopen1 = true
			outputChatBox("LSPD Barrier is now open!", thePlayer, 0, 255, 0)
			moveObject(pdgate1, 1000, 1544.6875, -1630.785546875, 13.1828125, 0, -90, 0)
			setTimer(closepdgate, 5000, 1, thePlayer)
		end
	elseif (distance2<=10) and (pdopen2==false) then
		if exports['[ars]inventory-system']:hasItem(thePlayer, 32) then
			pdopen2 = true
			outputChatBox("LSPD Garage is now open!", thePlayer, 0, 255, 0)
			moveObject(pdgate2, 1000, 1588.5490234375, -1637.95546875, 16.446516990662, -90, 0, 0)
			setTimer(closepdgate, 5000, 1, thePlayer)
		end
	elseif (distance3<=10) and (pdopen3==false) then
		if exports['[ars]inventory-system']:hasItem(thePlayer, 32) then
			pdopen3 = true
			outputChatBox("LSPD Impound is now open!", thePlayer, 0, 255, 0)
			moveObject(pdgate3, 1000, 1570.4779052734, -1617.7227783203, 14.1, 0, 0, 0)
			moveObject(pdgate4, 1000, 1588.2482910156, -1608.6553955078, 14.1, 0, 0, 0)
			setTimer(closepdgate, 5000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", openpdgate)

function closepdgate(thePlayer)
	if (pdopen1==true) then
		moveObject(pdgate1, 1000, 1544.6875, -1630.785546875, 13.1828125, 0, 90, 0)
		pdopen1 = false
	elseif (pdopen2==true) then
		moveObject(pdgate2, 1000, 1588.5490234375, -1637.95546875, 13.846516990662, 90, 0, 0)
		pdopen2 = false
	elseif (pdopen3==true) then
		moveObject(pdgate3, 1000, 1577.4779052734, -1617.7227783203, 14.1, 0, 0, 0)
		moveObject(pdgate4, 1000, 1587.1, -1611.25, 14.1, 0, 0, 0)
		pdopen3 = false
	end
end
