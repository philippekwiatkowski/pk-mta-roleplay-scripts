addEventHandler("onClientResourceStart", resourceRoot,
	function( )
		triggerServerEvent("getCurrentWeather", localPlayer, true)
	end
)
	
function setPlayerWeather( theWeatherID )
	local theWeatherID = tonumber( theWeatherID )
	if ( theWeatherID ) then
		
		setWeather( theWeatherID )
	end	
end
addEvent("setPlayerWeather", true)
addEventHandler("setPlayerWeather", localPlayer, setPlayerWeather)