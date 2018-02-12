local playing = false

function streamRadio ()


	sound = playSound3D("http://www.arsenicroleplay.net/files/listen.pls", -145.5722, 1167.625, 18.0899)
	setSoundMaxDistance (sound, 25)
	setSoundEffectEnabled (sound, "i3dl2reverb", true)
	setSoundEffectEnabled (sound, "chorus", true)
	setAmbientSoundEnabled( "general", false )
		
	sound2 = playSound3D("http://www.arsenicroleplay.net/files/listen.pls", 487.9101, -14.1201, 1000.6796)
	setSoundMaxDistance (sound2, 100)
	setElementDimension (sound2, 102)
	setElementInterior (sound2, 17)

end
addEventHandler("onClientResourceStart", getRootElement (), streamRadio)