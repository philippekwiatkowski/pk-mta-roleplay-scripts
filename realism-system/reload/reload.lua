function reloadWeapon( thePlayer )
	reloadPedWeapon( thePlayer )
end

addEventHandler("onResourceStart", resourceRoot, 
function( ) 
	for key, thePlayer in ipairs( getElementsByType("player") ) do
		bindKey(thePlayer, "r", "down", reloadWeapon)
	end
end)
	
addEventHandler("onPlayerJoin", getRootElement(), 
function( ) 
	bindKey(source, "r", "down", reloadWeapon) 
end)
