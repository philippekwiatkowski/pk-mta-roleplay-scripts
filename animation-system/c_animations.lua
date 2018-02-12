local screenX, screenY = guiGetScreenSize()

local animations =
{
	"cover", "cpr", "wait", "think", "lean", "idle", "piss", "wank", "slapass", "fixcar", "handsup", 
	"hailtaxi", "scratch", "fu", "strip [1 - 11]", "heil", "drink", "lay [1/2]", "beg", "mourn", "cry", 
	"cheer [1 - 3]", "dance [1 - 8]", "gsign [1 - 5]", "puke", "rap [1 - 3]", "aim", "sit", "smoke", 
	"smokelean", "laugh", "carchat", "tired", "bitchslap", "shocked", "dive", "what", "fallfront", "fall", 
	"walk [1 - 36]", "win [1 - 3]"
}

function createAnimWindow( )
	local width, height = 300, 400
	local x = (screenX/2) - (width/2)
	local y = (screenY/2) - (height/2)
	
	animWindow = guiCreateWindow(x, y, width, height, "List of animations", false)
	
	local closeButton = guiCreateButton(100,360,100,30,"Close",false,animWindow)
	addEventHandler("onClientGUIClick", closeButton, closeAnimWindow, false)
	
	local gridList = guiCreateGridList (10, 25, 300, 330, false, animWindow)
	
	guiGridListAddColumn(gridList, "Command", 0.85)
	
	for key, value in ipairs ( animations ) do
		local row = guiGridListAddRow( gridList )
		
		guiGridListSetItemText( gridList, row, 1, "/".. value, false, false)
	end	
	
	showCursor(true)
	guiWindowSetSizable(animWindow,false)
end
addCommandHandler("animations", createAnimWindow)
addCommandHandler("anims", createAnimWindow)

function closeAnimWindow( button, state )
	if ( button == "left" and state == "up" ) then	
	
		destroyElement(animWindow)
		showCursor(false)		
	end
end