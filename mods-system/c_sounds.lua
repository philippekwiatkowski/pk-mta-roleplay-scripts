function toggleWeaponSounds(weapon, ammo, ammoInClip)
	local x,y,z = getElementPosition(source)
	if weapon == 22 then
		local sound = playSound3D("sounds/pistol.wav", x,y,z)
		setSoundMaxDistance(sound, 100)
		setSoundVolume(sound, 0.5)
	elseif weapon == 24 then
		local sound = playSound3D("sounds/deagle.wav", x,y,z)
		setSoundMaxDistance(sound, 100)
	elseif weapon == 25 or weapon == 26 or weapon == 27 then
		local sound = playSound3D("sounds/shotgun.wav", x,y,z)
		setSoundMaxDistance(sound, 100)
	elseif weapon == 28 then
		local sound = playSound3D("sounds/uzi.wav", x,y,z)
		setSoundMaxDistance(sound, 100)
		setSoundVolume(sound, 0.5)
	elseif weapon == 29 then
		local sound = playSound3D("sounds/mp5.wav", x,y,z)
		setSoundMaxDistance(sound, 100)
	elseif weapon == 30 then
		local sound = playSound3D("sounds/ak.wav", x,y,z)
		setSoundMaxDistance(sound, 100)
		setSoundVolume(sound, 0.5)
	elseif weapon == 31 then
		local sound = playSound3D("sounds/m4.wav", x,y,z)
		setSoundMaxDistance(sound, 100)
		setSoundVolume(sound, 0.5)
	elseif weapon == 32 then
		local sound = playSound3D("sounds/tec-9.wav", x,y,z)
		setSoundMaxDistance(sound, 100)
		setSoundVolume(sound, 0.5)
	elseif weapon == 32 or weapon == 33 then
		local sound = playSound3D("sounds/sniper.wav", x,y,z)
		setSoundMaxDistance(sound, 100)
		setSoundVolume(sound, 0.5)
	end
end
addEventHandler("onClientPlayerWeaponFire", getRootElement(), toggleWeaponSounds)

addEventHandler("onClientExplosion", getRootElement(), function(x,y,z, theType)
	if(theType == 0 or theType == 2 or theType == 3)then
		local explosion1 = playSound3D("sounds/explosion1.wav", x,y,z)
		setSoundMaxDistance(explosion1, 100)
	elseif(theType == 4 or theType == 5 or theType == 6 or theType == 7) then
		local explosion2 = playSound3D("sounds/explosion2.wav", x,y,z)
		setSoundMaxDistance(explosion1, 100)
	end
end)