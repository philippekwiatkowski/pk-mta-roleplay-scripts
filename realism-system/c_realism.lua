function disableGunfire ()
	setAmbientSoundEnabled("gunfire", false)
end
addEventHandler ("onClientResourceStart", getRootElement(), disableGunfire)