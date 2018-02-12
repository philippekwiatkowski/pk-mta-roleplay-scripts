--------- [ Vehicle Lock/Unlock Alarms ] ---------

-- calculate the volume according to the distance from the car
function calculateVolume( distance )
	local value = (distance/20*100)/100
	local diff = nil
	if value < 0.5 then
		diff = 0.5-value
		value = 0.5+diff
	elseif value > 0.5 then
		diff = value-0.5
		value = 0.5-diff
	end
	
	return value 
end

function unlockAlarm( distance )
	local distance = math.floor(distance)
	
	local alarm = playSound("sounds/unlock.mp3")
	local volume = calculateVolume( distance ) 
	setSoundVolume( alarm, tonumber(volume))
end
addEvent("playUnlockSound", true)
addEventHandler("playUnlockSound", getLocalPlayer(), unlockAlarm)

function lockAlarm( distance )
	local distance = math.floor(distance)
	
	local alarm = playSound("sounds/lock.mp3")
	local volume = calculateVolume( distance )
	setSoundVolume( alarm, tonumber(volume))
end
addEvent("playLockSound", true)
addEventHandler("playLockSound", getLocalPlayer(), lockAlarm)
	