function disableCrosshair (previousWeaponID, currentWeaponID)
    if currentWeaponID < 22 or currentWeaponID > 31 then
		showPlayerHudComponent (source, "crosshair", true)
	else
		showPlayerHudComponent (source, "crosshair", false)
	end
end
addEventHandler("onPlayerWeaponSwitch", getRootElement(), disableCrosshair)