function executeSound( )
	local sound = playSound("paycheck.wav")
	setSoundVolume(sound, 1)
end
addEvent("executeSound", true)
addEventHandler("executeSound", localPlayer, executeSound)