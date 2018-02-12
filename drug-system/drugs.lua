-- Marijuana
function takeMarijuana( thePlayer )
	if ( thePlayer ) then
		
		setSkyGradient( 255, 0, 0, 255, 0, 0 )
		setGameSpeed( 0.7 )
		
		setTimer( resetDrugEffect, 300000, 1, thePlayer )
	end	
end
addEvent("takeMarijuana", true)
addEventHandler("takeMarijuana", localPlayer, takeMarijuana )

-- Lysergic Acid
function takeLysergicAcid( thePlayer )
	if ( thePlayer ) then
		
		setSkyGradient( 0, 255, 0, 0, 255, 0 )
		setGameSpeed( 0.5 )
		
		setTimer( resetDrugEffect, 300000, 1, thePlayer )
	end	
end
addEvent("takeLysergicAcid", true)
addEventHandler("takeLysergicAcid", localPlayer, takeLysergicAcid )

-- Cocaine
function takeCocaine( thePlayer )
	if ( thePlayer ) then
		
		setSkyGradient( 0, 0, 0, 0, 0, 0 )
		setGameSpeed( 0.7 )
		
		setTimer( resetDrugEffect, 300000, 1, thePlayer )
	end
end
addEvent("takeCocaine", true)
addEventHandler("takeCocaine", localPlayer, takeCocaine )

-- PCP Hydrochloride
function takePCPHydrochloride( thePlayer )
	if ( thePlayer ) then
		
		setSkyGradient( 0, 0, 255, 0, 0, 255 )
		setGameSpeed( 1.2 )
		
		setTimer( resetDrugEffect, 300000, 1, thePlayer )
	end
end
addEvent("takePCPHydrochloride", true)
addEventHandler("takePCPHydrochloride", localPlayer, takePCPHydrochloride)

-- Heroin
function takeHeroin( thePlayer )
	if ( thePlayer ) then
		
		setSkyGradient( 200, 200, 0, 200, 200, 0 )
		setGameSpeed( 1 )
		
		setTimer( resetDrugEffect, 300000, 1, thePlayer )
	end
end
addEvent("takeHeroin", true)
addEventHandler("takeHeroin", localPlayer, takeHeroin)

-- Subutex
function takeSubutex( thePlayer )
	if ( thePlayer ) then
		
		setSkyGradient( 0, 200, 200, 0, 200, 200 )
		setGameSpeed( 0.3 )
		
		setTimer( resetDrugEffect, 300000, 1, thePlayer )
	end
end
addEvent("takeSubutex", true)
addEventHandler("takeSubutex", localPlayer, takeSubutex)

function resetDrugEffect( thePlayer, weather )
	resetSkyGradient( )
	setGameSpeed( 1 )
end