localPlayer = getLocalPlayer()

function fireTaser(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
	if (weapon==23) then
		local px, py, pz = getElementPosition(localPlayer)
		triggerServerEvent("onTaserFire", localPlayer, hitX, hitY, hitZ, hitElement) 
	end
end
addEventHandler("onClientPlayerWeaponFire", localPlayer, fireTaser)

function taserDamage(attacker, weapon, bodypart, loss)
	if (weapon==23) then
		cancelEvent()
	end
end
addEventHandler("onClientPlayerDamage", localPlayer, taserDamage)

function showTaserEffect ()
	local tasersound = playSound("taser.wav", false) 
end