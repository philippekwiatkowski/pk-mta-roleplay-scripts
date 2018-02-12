function togglePointer( commandName )
	if (isCursorShowing()) then
		showCursor(false)
	else
		showCursor(true)
	end	
end

local function bindClientKeys( )
	bindKey("m", "down", togglePointer)
end
addEventHandler("onClientResourceStart", resourceRoot, bindClientKeys)	