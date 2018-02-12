function onTaserFire(x, y, z, target)
	local px, py, pz = getElementPosition(source)
	local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)

	if (distance<10) then
		if (isElement(target) and getElementType(target)=="player") then
			toggleAllControls(target, false, true, false)
			setPedAnimation(target, "ped", "FLOOR_hit_f", -1, false, false, false)
			setTimer(removeAnimation, 10000, 1, target)
			triggerClientEvent (showTaserEffect)
		end
	end
end
addEvent("onTaserFire", true )
addEventHandler("onTaserFire", getRootElement(), onTaserFire)

function removeAnimation(thePlayer)
	if (isElement(thePlayer) and getElementType(thePlayer)=="player") then
		toggleAllControls(thePlayer, true, true, true)
		setPedAnimation(thePlayer)
	end
end