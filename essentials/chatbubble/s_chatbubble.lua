function onClientStartChat( )
	local px, py, pz = getElementPosition(client)

	for k, v in ipairs ( getElementsByType("player") ) do
		local vx, vy, vz = getElementPosition(v)
			
		if ( getDistanceBetweenPoints3D( px, py, pz, vx, vy, vz ) <= 25 ) and not (v == client) then 
			triggerClientEvent(v, "addChatBubble", client)
		end
	end
end
addEvent("clientStartedChatting", true)
addEventHandler("clientStartedChatting", getRootElement(), onClientStartChat)

function onClientStopChat( )
	local px, py, pz = getElementPosition(client)
	
	for k, v in ipairs ( getElementsByType("player") ) do
		local vx, vy, vz = getElementPosition(v)
		
		if ( getDistanceBetweenPoints3D( px, py, pz, vx, vy, vz ) <= 25 ) and not (v == client) then 
			triggerClientEvent(v, "removeChatBubble", client)
		end
	end
end
addEvent("clientStoppedChatting", true)
addEventHandler("clientStoppedChatting", getRootElement(), onClientStopChat)