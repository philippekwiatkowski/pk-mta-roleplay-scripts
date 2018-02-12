--------- [ Element Data returns ] ---------
local function getData( theElement, key )
	local key = tostring(key)
	if isElement(theElement) and (key) then
		
		return exports['[ars]anticheat-system']:c_callData( theElement, tostring(key) )
	else
		return false
	end
end	

--------- [ Friend System ] ---------
local screenX, screenY = guiGetScreenSize( )

local isFriendWindowOpen = false
local isAskFriendWindowOpen = false

local otherPlayer = nil
local theFriend = nil

local width, height = 370, 140
local x, y = ( screenX/2 - width/2 ), ( screenY/2 - height/2 )		

addEventHandler("onClientClick", root,
	function( button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
		if ( button == "right" ) and ( state == "up" ) then
			
			if ( clickedElement ) and ( clickedElement ~= localPlayer ) then
				
				local elementType = getElementType( clickedElement )
				if ( elementType == "player" ) then
					
					if ( not isFriendWindowOpen ) then
						
						otherPlayer = clickedElement
		
						createFriendWindow( )
						isFriendWindowOpen = true
					end	
				end
			end
		end
	end
)	

function createFriendWindow( )
	local theText = "Would you like to add this player to your friend list?"
	local theFunction = addPlayerFriend
	
	if isPlayerAlreadyFriend( otherPlayer ) then -- Already Friend
		theText = "You want to delete this player from your friend list?"
		theFunction = removePlayerFriend
	end
	
	friendWindow = guiCreateWindow( x, y, width, height, getPlayerName( otherPlayer ):gsub("_", " "), false)
	friendLabel = guiCreateLabel(20, 25, 330, 40, theText, false, friendWindow)
	
	buttonYes = guiCreateButton(130, 60, 110, 25, "Yes", false, friendWindow)
	addEventHandler("onClientGUIClick", buttonYes, theFunction, false)
	
	buttonNo = guiCreateButton(130, 90, 110, 25, "No", false, friendWindow)
	addEventHandler("onClientGUIClick", buttonNo, closeFriendWindow, false)
	
	guiSetFont(friendLabel, "clear-normal")	
end	

function addPlayerFriend( button, state )
	if ( button == "left" and state == "up" ) then
		
		triggerServerEvent("addPlayerFriend", localPlayer, otherPlayer )

		destroyElement( friendWindow )
		open = false
		
		isFriendWindowOpen = false
	end
end

function removePlayerFriend( button, state )
	if ( button == "left" and state == "up" ) then
		
		triggerServerEvent("removePlayerFriend", localPlayer, otherPlayer )

		destroyElement( friendWindow )
		open = false
		
		isFriendWindowOpen = false
	end
end

function closeFriendWindow( button, state )
	if ( button == "left" and state == "up" ) then
		
		destroyElement( friendWindow )
		open = false
		
		isFriendWindowOpen = false
	end
end

function askPlayerFriend( client )
	if ( not isAskFriendWindowOpen ) then
		theFriend = client
		
		askPlayerWindow = guiCreateWindow( x, y, width, height, getPlayerName( theFriend ):gsub("_", " "), false)
		questionLabel = guiCreateLabel(20, 25, 330, 40, getPlayerName( theFriend ):gsub("_", " ").. " wants to add you as their friend.", false, askPlayerWindow)
		
		buttonAccept = guiCreateButton(130, 60, 110, 25, "Accept", false, askPlayerWindow)
		addEventHandler("onClientGUIClick", buttonAccept, setPlayerFriend, false)
		
		buttonDecline = guiCreateButton(130, 90, 110, 25, "Decline", false, askPlayerWindow)
		addEventHandler("onClientGUIClick", buttonDecline, closeAskPlayerWindow, false)
		
		guiSetFont(questionLabel, "clear-normal")
		
		isAskFriendWindowOpen = true
		triggerServerEvent("tellPlayer", client, true, localPlayer)
	else
		triggerServerEvent("tellPlayer", client, false)
	end	
end
addEvent("askPlayerFriend", true)
addEventHandler("askPlayerFriend", localPlayer, askPlayerFriend)

function setPlayerFriend( button, state )
	if ( button == "left" and state == "up" ) then
		
		triggerServerEvent("setPlayerAsFriend", localPlayer, theFriend)
		
		destroyElement( askPlayerWindow )
		isAskFriendWindowOpen = false
		
		theFriend = nil
	end
end

function closeAskPlayerWindow( button, state )
	if ( button == "left" and state == "up" ) then
		
		destroyElement( askPlayerWindow )
		isAskFriendWindowOpen = false
		
		theFriend = nil
	end
end

function isPlayerAlreadyFriend( thePlayer )
	if ( thePlayer ) then
	
		local accountid = tonumber( getData(thePlayer, "accountid") )
		
		local clientFriends = tostring( getData(localPlayer, "friends") )
		if ( clientFriends == "none" ) then
			return false
		else	
			local t = split(clientFriends, ",")
			for key, value in ipairs ( t ) do
				if ( tonumber( value ) == accountid ) then
					
					return true
				end
			end
			
			return false
		end	
	end
end	