local chatting = 0
local chatters = { }

function drawChatBubble( )
	
	if isChatBoxInputActive( ) and chatting == 0 then
		
		chatting = 1
		triggerServerEvent("clientStartedChatting", getLocalPlayer())
	elseif not isChatBoxInputActive() and chatting == 1 then
		
		chatting = 0
		triggerServerEvent("clientStoppedChatting", getLocalPlayer())
	end
end
setTimer(drawChatBubble, 100, 0)

function addBubble( )
	for k, v in ipairs (chatters) do
		if ( v == source ) then
			return
		end
	end
	table.insert(chatters, source)
end
addEvent("addChatBubble", true)
addEventHandler("addChatBubble", getRootElement(), addBubble)

function removeBubble()
	for k, v in ipairs (chatters) do
		if ( v == source ) then
			table.remove(chatters, k)
		end
	end
end
addEvent("removeChatBubble", true)
addEventHandler("removeChatBubble", getRootElement(), removeBubble)
addEventHandler("onClientPlayerQuit", getRootElement(), removeBubble)

function renderChatBubble( )
	local x, y, z = getCameraMatrix( )
	
	for k, v in ipairs (chatters) do
		if isElement(v) and getElementType(v) == "player" then
			
			local px, py, pz = getPedBonePosition(v, 5)
				
			local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
			if isElementOnScreen(v) then
				
				if (distance > 20) then
					chatters[v] = nil
					return
				end
				
				local a, b, c = getCameraMatrix()
				local col, cx, cy, cz, element
				local vehicle = getPedOccupiedVehicle(v)
				if not isElement(vehicle) then
					col, cx, cy, cz, element = processLineOfSight(a, b, c, px, py, pz+1, true, true, true, true, false, false, true, false, nil)
				else
					col, cx, cy, cz, element = processLineOfSight(a, b, c, px, py, pz+1, true, true, true, true, false, false, true, false, vehicle)
				end
				
				if not col then
					
					local sx, sy = getScreenFromWorldPosition(px, py, pz + 0.5)
					if sx and sy then
						distance = distance / 5
					
						if (distance < 1) then 
							distance = 1 
						end
							
						if (distance > 4) then 
							distance = 4
						end
				

						sx = sx - (distance / 5)
				
						local draw = dxDrawImage(sx, sy + 10, 50 / distance, 50 / distance, "chatbubble/bubble.png")
					end
				end
			end	
		else
			chatters[k] = nil
		end
	end
end
addEventHandler("onClientRender", getRootElement(), renderChatBubble)