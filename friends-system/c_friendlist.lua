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

local width, height = 480, 380
local x, y = ( screenX/2 - width/2 ), ( screenY/2 - height/2 )

function showPlayerFriendlist( theFriends )
	if ( not isElement( friendsWindow ) ) then
		
		friendsWindow = guiCreateWindow(x, y, width, height, "Your Friends", false)
		friendsPane = guiCreateScrollPane(30, 60, 430, 300, false, friendsWindow) 	
		
		local friendY, friendCount, onlineFriendCount, closeFriendCount = 10, 0, 0, 0
		for i = 1, #theFriends do
			
			local username = tostring( theFriends[i][1] )
			local country = tostring( theFriends[i][2] )
			local sameCountry = tostring( theFriends[i][3] )
			local lastlogin = tonumber( theFriends[i][4] )
			local onlineName = isFriendOnline( username )
			
			local text = nil
			if ( lastlogin > 1 ) then
				text = tostring( lastlogin ) .." days ago"
			elseif ( lastlogin == 1 ) then
				text = "Yesterday"
			elseif ( lastlogin == 0 ) then
				text = "Today"
			end	
			
			local statusText = "Online"
			local loginText = "Playing as: ".. tostring( onlineName )
			local red, green, blue = 0, 255, 0
			
			onlineFriendCount = onlineFriendCount + 1
			if ( onlineName == false ) then
				statusText = "Offline"
				loginText =  "Last seen: ".. text
				red, green, blue = 255, 0, 0
				
				onlineFriendCount = onlineFriendCount - 1
			end
			
			local flag = guiCreateStaticImage(20, friendY, 75, 35, ":[ars]global/flags/".. tostring( country ):gsub(" ", "_") ..".png", false, friendsPane)
			local header = guiCreateLabel(120, friendY, 250, 20, tostring( username ) .." (".. tostring( country ) ..")" , false, friendsPane)
			local playStatus = guiCreateLabel( guiLabelGetTextExtent( header ) + 130, friendY, 100, 20, " - ".. tostring( statusText ), false, friendsPane)
			local login = guiCreateLabel(120, friendY + 20, 200, 20, loginText, false, friendsPane)
			
			local banned = tonumber( theFriends[i][5] )
			if ( banned == 1 ) then
				guiCreateStaticImage(130, friendY - 16, 100, 59, "images/banned.png", false, friendsPane)
			end	
			
			if ( sameCountry == "true" ) then
				closeFriendCount = closeFriendCount + 1
			end
			
			guiSetFont(header, "default-bold-small")
			guiSetFont(login, "default-bold-small")
			guiSetFont( playStatus, "default-bold-small")
			
			guiLabelSetColor( playStatus, red, green, blue )
			
			friendY = friendY + 60
			friendCount = friendCount + 1
		end
		
		local friendText = "You have not added any friends yet, right click on a player In-Game\nand click 'Add Friend' to add them as your friend."
		if ( friendCount ~= 0 ) then
			friendText = "You have ".. friendCount .." friend(s) in total. ".. onlineFriendCount .." online, ".. closeFriendCount .." from your country."
		end
		
		local friendLabel = guiCreateLabel(20, 30, 430, 40, friendText, false, friendsWindow)
		guiSetFont(friendLabel, "clear-normal")
	else
		destroyElement(friendsWindow)
		friendsWindow = nil
	end
end
addEvent("showPlayerFriendlist", true)
addEventHandler("showPlayerFriendlist", localPlayer, showPlayerFriendlist)

function isFriendOnline( username )
	if ( username ) then
		local username = tostring( username )
		
		for key, value in ipairs ( getElementsByType("player") ) do
			if ( tostring( getData( value, "accountname") ) == username ) then
				
				return getPlayerName( value ):gsub("_", " ")
			end
		end
		
		return false
	end
end