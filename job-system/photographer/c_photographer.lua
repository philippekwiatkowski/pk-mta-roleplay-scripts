local screenX, screenY = guiGetScreenSize( )

--------- [ Element Data returns ] ---------
local function getData( theElement, key )
	local key = tostring(key)
	if isElement(theElement) and (key) then
		
		return exports['[ars]anticheat-system']:c_callData( theElement, tostring(key) )
	else
		return false
	end
end	

local function setData( theElement, key, value, sync )
	local key = tostring(key)
	local value = tonumber(value) or tostring(value)
	if isElement(theElement) and (key) and (value) then
		
		return exports['[ars]anticheat-system']:c_assignData( theElement, tostring(key), value, sync )
	else
		return false
	end	
end

--------- [ Photographer ] ---------
local totalPictureMoney = 0
function clickPicture( weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement )
	if ( weapon == 43 ) then
		if ( hitElement ) then
			if ( getElementType( hitElement ) == "player" ) then
			
				local faction = tonumber( getData( localPlayer, "faction" ) )
				if ( faction == 3 ) then
					
					local pictureComment = ""
					local pictureCost = 0
					
					local x, y, z = getElementPosition( localPlayer )
					local px, py, pz = getElementPosition( hitElement )
					
					local distance = getDistanceBetweenPoints3D( x, y, z, px, py, pz )
					if ( distance <= 10 ) then
						
						pictureComment = "great!"
						pictureCost = 5
					elseif ( distance > 10 and distance <= 20 ) then
						
						pictureComment = "okay.."
						pictureCost = 3
					elseif ( distance > 20 )then
						
						pictureComment = "pretty poor!"
						pictureCost = 1
					end	
					
					outputChatBox("That picture is ".. pictureComment, 212, 156, 49)
					
					totalPictureMoney = totalPictureMoney + pictureCost	
				end	
			end	
		else	
			outputChatBox("Nothing of interest in that picture.", 212, 156, 49)
		end
	end	
end
addEventHandler("onClientPlayerWeaponFire", localPlayer, clickPicture)

--------- [ Photograph Selling ] ---------

local employee = createPed(141, 1538.5878, -2469.5371, 13.6776, 311)
setElementInterior(employee, 3)
setElementDimension(employee, 37)

addEventHandler("onClientClick", root, 
	function( button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
		if ( getData(getLocalPlayer(), "loggedin") == 1 and not isElement(sellPhotoWindow) ) then
			if (button == "right" and state == "up") then
				
				if (clickedElement) and (clickedElement == employee) then
				
					sellPhotographsUI( )
				end	
			end
		end
	end
)	


function sellPhotographsUI( )
	local width, height = 300, 140
	local x, y = (screenX/2) - (width/2), (screenY/2) - (height/2)
	
	sellPhotoWindow = guiCreateWindow(x, y, width, height, "Sell Photographs", false)
	
	local isPhotographer = false
	if ( getData( localPlayer, "faction" ) == 3 ) then
		isPhotographer = true
	end

	local text
	if ( isPhotographer ) then
		text = "Hello ".. getPlayerFirstName(localPlayer):gsub("_", " ") ..", would you like to sell us some\nphotographs?"
	else
		text = "Hello, if you want to be a photographer\nfor SAN, please send a job application to\nthe office. (( On Forums ))"
	end
	
	sellInformationLabel = guiCreateLabel(20, 30, 280, 60, "", false, sellPhotoWindow)
	guiSetText(sellInformationLabel, text)
	
	local buttonPositiveReply, buttonNegativeReply = false, false
	if ( isPhotographer ) then
		buttonPositiveReply = guiCreateButton(95, 70, 110, 20, "Sure", false, sellPhotoWindow)
		
		buttonNegativeReply = guiCreateButton(95, 100, 110, 20, "Not now", false, sellPhotoWindow)
		addEventHandler("onClientGUIClick", buttonNegativeReply,
			function( button, state )
				
				destroyElement(sellPhotoWindow)
			end
		)
	else
		buttonPositiveReply = guiCreateButton(95, 90, 110, 20, "Alright", false, sellPhotoWindow)
	end	
	
	addEventHandler("onClientGUIClick", buttonPositiveReply,
		function( button, state )
			if ( guiGetText(source) == "Alright" ) then			
				
				destroyElement(sellPhotoWindow)
			else
				
				triggerServerEvent("sellPhotographs", localPlayer, totalPictureMoney)
				
				destroyElement(sellPhotoWindow)
			end	
		end
	)
		
	guiSetFont(sellInformationLabel, "clear-normal")
end

function getPlayerFirstName( thePlayer )
	if ( thePlayer ) then
		local playerName = getPlayerName( thePlayer )
		
		return string.sub(playerName, 1, string.find(playerName, "_") - 1)
	end	
end