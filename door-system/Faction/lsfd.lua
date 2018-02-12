local fdgate1 = createObject(3055, -84.14469909668, 1167.1721191406, 20.940299987793, 0, 0, 90) -- Garage 
local fdgate2 = createObject(3055, -84.085899353027, 1175.9237060547, 20.940299987793, 0, 0, 90) -- Garage
local fdgate3 = createObject(3055, -84.14330291748, 1158.5499267578, 20.940299987793, 0, 0, 90) -- Garage

local fdopen1 = false
local fdopen2 = false
local fdopen3 = false

function togglefdgate(thePlayer)
	local x, y, z = getElementPosition(thePlayer)
	local distance1 = getDistanceBetweenPoints3D(-84.14469909668, 1167.1721191406, 20.940299987793, x, y, z)
	local distance2 = getDistanceBetweenPoints3D(-84.085899353027, 1175.9237060547, 20.940299987793, x, y, z)
	local distance3 = getDistanceBetweenPoints3D(-84.14330291748, 1158.5499267578, 20.940299987793, x, y, z)


	if (distance1<=10) then
		if (fdopen1==false) then
			if exports['[ars]inventory-system']:hasItem(thePlayer, 33) then
				fdopen1 = true
				moveObject(fdgate1, 3000, -84.14469909668, 1167.1721191406, 25, 0, 0, 0)
			end
		elseif (fdopen1==true) then
			if exports['[ars]inventory-system']:hasItem(thePlayer, 33) then
				fdopen1 = false
				moveObject(fdgate1, 3000, -84.14469909668, 1167.1721191406, 20.940299987793, 0, 0, 0)
			end
		end
	elseif (distance2<=10) then
		if (fdopen2==false) then
			if exports['[ars]inventory-system']:hasItem(thePlayer, 33) then
				fdopen2 = true
				moveObject(fdgate2, 3000, -84.085899353027, 1175.9237060547, 25, 0, 0, 0)
			end
		elseif (fdopen2==true) then
			if exports['[ars]inventory-system']:hasItem(thePlayer, 33) then
				fdopen2 = false
				moveObject(fdgate2, 3000, -84.085899353027, 1175.9237060547, 20.940299987793, 0, 0, 0)
			end
		end
	elseif (distance3<=10) then
		if (fdopen3==false) then
			if exports['[ars]inventory-system']:hasItem(thePlayer, 33) then
				fdopen3 = true
				moveObject(fdgate3, 3000, -84.14330291748, 1158.5499267578, 25, 0, 0, 0)
			end
		elseif (fdopen3==true) then
			if exports['[ars]inventory-system']:hasItem(thePlayer, 33) then
				fdopen3 = false
				moveObject(fdgate3, 3000, -84.14330291748, 1158.5499267578, 20.940299987793, 0, 0, 0)
			end
		end
	end
end
addCommandHandler("gate", togglefdgate)

