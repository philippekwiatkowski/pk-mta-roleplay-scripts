addEventHandler("onClientResourceStart", resourceRoot,
	function( res )
	
		triggerServerEvent("getServerTime", localPlayer)
	end
)

function setClientTime( hour, minute )
	local hour = tonumber( hour )
    local minute = tonumber( minute )
	
	setMinuteDuration (60000)
    setTime(hour, minute)
end
addEvent("setClientTime", true)
addEventHandler("setClientTime", localPlayer, setClientTime)

setTimer(
	function( )
		triggerServerEvent("getServerTime", localPlayer)
	end, 300000, 0
)	