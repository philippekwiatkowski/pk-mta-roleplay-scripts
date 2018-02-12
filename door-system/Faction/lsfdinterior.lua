local fdgate1 = createObject(1495, -1295.259765625, -220.81840515137, 13.16489982605, 0, 0, 0)
setElementInterior (fdgate1, 2)
setElementDimension (fdgate1, 105)

local fdopen1 = false

function openfdgate(thePlayer)
	local x, y, z = getElementPosition(thePlayer)
	local distance1 = getDistanceBetweenPoints3D(-1295.259765625, -220.81840515137, 13.16489982605, x, y, z)

	if (distance1<=5) and (fdopen1==false) then
		if exports['[ars]inventory-system']:hasItem(thePlayer, 33) then
			fdopen1 = true
			moveObject(fdgate1, 500, -1295.259765625, -220.81840515137, 13.16489982605, 0, 0, 90)
			setTimer(closefdgate, 2000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", openfdgate)

function closefdgate(thePlayer)
	if (fdopen1==true) then
		moveObject(fdgate1, 500, -1295.259765625, -220.81840515137, 13.16489982605, 0, 0, -90)
		setTimer (setOpen, 500, 1)
	end
end

function setOpen ()
	fdopen1 = false
end