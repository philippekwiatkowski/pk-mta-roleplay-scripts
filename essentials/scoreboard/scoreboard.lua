--------- [ Element Data returns ] ---------
local function getData( theElement, key )
	local key = tostring(key)
	if isElement(theElement) and (key) then
		
		return exports['[ars]anticheat-system']:c_callData( theElement, tostring(key) )
	else
		return false
	end
end	

-------------- [ Scoreboard ] ---------------
local screenX, screenY = guiGetScreenSize()

local width, height = 300, 420
local x = (screenX/2) - (width/2)
local y = (screenY/2) - (height/2)

local logowidth, logoheight = 275, 275
local logox = (x/2) - (logowidth/2)
local logoy = (y/2) - (logoheight/2)

local isEventHandled = false
local page = 1

local a = { "Z", "W", "Y", "G", "H", "L", "P", "A", "B" }
function getPlayerIDTable( )
	
	local array = { }
	--[[
	for key, thePlayer in ipairs ( getElementsByType("player") ) do
		
		local playerID = tonumber( getData( thePlayer, "playerid") )
		if ( playerID ) then
			
			array[#array + 1] = { playerID, thePlayer }
		end
	end
	]]--
	
	for i = 1, 9 do
			
	end
	
	return array
end

local players = { }
function assemblePlayersByID( )
	
	local array = getPlayerIDTable( )
	local smallest, index, tempo
	
	for i = 1, #array do
		
		smallest = array[i][1]
		index = i
		
		for j = i + 1, #array do
			if ( array[j][1] < smallest ) then
				
				smallest = array[j][1]
				index = j	
			end
		end
		
		-- flip arrays
		tempo = array[i]
		array[i] = array[index]
		array[index] = tempo
	end
	
	-- Sort
	for key, value in ipairs ( array ) do
		
		players[value[1]] = value[2]
	end	
end	
	
function removePlayerFromList( )
	local playerID = tonumber( getData(source, "playerid") )
	players[playerID] = nil
end
addEventHandler("onClientPlayerQuit", getRootElement(), removePlayerFromList)
	
function renderPlayerList( )
	dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 200))
	
	limit = 0
	for k, v in pairs (players) do
		limit = limit + 1
	end
	
	local clientName = getPlayerName(getLocalPlayer()):gsub("_", " ")
	
	dxDrawText("Arsenic Roleplay 1.0", x + 2, y + 403, screenX, screenY, tocolor(255, 255, 255, 150), 1, "default-bold")
	dxDrawText("Players: (".. limit .."/50)", x + 208, y + 403, screenX, screenY, tocolor(255, 255, 255, 150), 1, "default-bold")
	
	dxDrawText("ID", x + 15, y + 13, screenX, screenY, tocolor(255, 255, 255, 150), 1, "default-bold")
	dxDrawText("Player", x + 60, y + 13, screenX, screenY, tocolor(255, 255, 255, 150), 1, "default-bold")
	dxDrawText("Ping", x + 250, y + 13, screenX, screenY, tocolor(255, 255, 255, 150), 1, "default-bold")
	
	dxDrawLine(x, y + 30, x + 299, y + 30, tocolor(255, 255, 255, 150), 1)
	
	local yTxt = (screenY/2) - (height/2) + 35
	
	for k, v in ipairs (players) do
		
		if isElement(v) then
			
			local name = tostring( getPlayerName(v):gsub("_", " ") )
			local id = tostring( getData(v, "playerid") )
			local ping = tostring( getPlayerPing(v) )
			local r, g, b = getPlayerNametagColor(v)
			
			if ( page == 1 ) then
				
				if k <= 24 then
			
					if name == clientName then
						dxDrawRectangle(x, yTxt, 300, 15, tocolor(255, 255, 255, 40))
					end	
						
					dxDrawText(tostring(id), x + 15, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
					dxDrawText(tostring(name), x + 60, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
					dxDrawText(tostring(ping), x + 250, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
			
					yTxt = yTxt + 15
				end	
			elseif ( page == 2 ) then	
			
				if k >= 12 and k < 36 then
				
					
					if name == clientName then
						dxDrawRectangle(x, yTxt, 300, 15, tocolor(255, 255, 255, 40))
					end	
					
					dxDrawText(tostring(id), x + 15, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
					dxDrawText(tostring(name), x + 60, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
					dxDrawText(tostring(ping), x + 250, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
						
					yTxt = yTxt + 15	
				end	
			elseif ( page == 3 ) then		
			
				if k >= 24 and k < 48 then
				
					
					if name == clientName then
						dxDrawRectangle(x, yTxt, 300, 15, tocolor(255, 255, 255, 40))
					end	
					
					dxDrawText(tostring(id), x + 15, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
					dxDrawText(tostring(name), x + 60, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
					dxDrawText(tostring(ping), x + 250, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
						
					yTxt = yTxt + 15	
				end	
			elseif ( page == 4 ) then		
				
				if k >= 36 and k < 60 then
				
					
					if name == clientName then
						dxDrawRectangle(x, yTxt, 300, 15, tocolor(255, 255, 255, 40))
					end	
					
					dxDrawText(tostring(id), x + 15, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
					dxDrawText(tostring(name), x + 60, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
					dxDrawText(tostring(ping), x + 250, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
						
					yTxt = yTxt + 15	
				end	
			elseif ( page == 5 ) then	
				
				if k >= 48 and k < 72 then
					
					
					if name == clientName then
						dxDrawRectangle(x, yTxt, 300, 15, tocolor(255, 255, 255, 40))
					end	
					
					dxDrawText(tostring(id), x + 15, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
					dxDrawText(tostring(name), x + 60, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
					dxDrawText(tostring(ping), x + 250, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
						
					yTxt = yTxt + 15	
				end	
			elseif ( page == 6 ) then	
				
				if id >= 60 and id < 84 then
					
					
					if name == clientName then
						dxDrawRectangle(x, yTxt, 300, 15, tocolor(255, 255, 255, 40))
					end	
					
					dxDrawText(tostring(id), x + 15, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
					dxDrawText(tostring(name), x + 60, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
					dxDrawText(tostring(ping), x + 250, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
						
					yTxt = yTxt + 15
				end	
			elseif ( page == 7 ) then	
				
				if id >= 72 and id < 96 then
					
					
					if name == clientName then
						dxDrawRectangle(x, yTxt, 300, 15, tocolor(255, 255, 255, 40))
					end	
					
					dxDrawText(tostring(id), x + 15, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
					dxDrawText(tostring(name), x + 60, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
					dxDrawText(tostring(ping), x + 250, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
						
					yTxt = yTxt + 15
				end	
			elseif ( page == 8 ) then	
				
				if id >= 84 and id < 108 then
					
					
					if name == clientName then
						dxDrawRectangle(x, yTxt, 300, 15, tocolor(255, 255, 255, 40))
					end	
					
					dxDrawText(tostring(id), x + 15, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
					dxDrawText(tostring(name), x + 60, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
					dxDrawText(tostring(ping), x + 250, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
						
					yTxt = yTxt + 15
				end	
			elseif ( page == 9 ) then	
				
				if id >= 96 and id < 120 then
					
					
					if name == clientName then
						dxDrawRectangle(x, yTxt, 300, 15, tocolor(255, 255, 255, 40))
					end	
					
					dxDrawText(tostring(id), x + 15, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
					dxDrawText(tostring(name), x + 60, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
					dxDrawText(tostring(ping), x + 250, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
						
					yTxt = yTxt + 15
				end	
			elseif ( page == 10 ) then	
				
				if id >= 108 and id <= 128 then
					
					
					if name == clientName then
						dxDrawRectangle(x, yTxt, 300, 15, tocolor(255, 255, 255, 40))
					end	
					
					dxDrawText(tostring(id), x + 15, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
					dxDrawText(tostring(name), x + 60, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
					dxDrawText(tostring(ping), x + 250, yTxt, screenX, screenY, tocolor(r, g, b, 255), 1, "default-bold")
				
					yTxt = yTxt + 15		
				end		
			end	
		end	
	end	
end

function scrollDown( )
	if (isEventHandled) then
		if (limit >= 24 and limit < 36) then
			
			if (page ~= 2) then
				page = page + 1	
			end	
		elseif (limit >= 36 and limit < 48 ) then
			
			if (page ~= 3) then
				page = page + 1	
			end	
		elseif (limit >= 48 and limit < 60) then
			
			if (page ~= 4) then
				page = page + 1	
			end	
		elseif (limit >= 60 and limit < 72) then
			
			if (page ~= 5) then
				page = page + 1	
			end	
		elseif (limit >= 72 and limit <= 84) then
			
			if (page ~= 6) then
				page = page + 1		
			end
		elseif (limit >= 84 and limit <	96) then
			
			if (page ~= 7) then
				page = page + 1
			end
		elseif (limit >= 96 and limit < 108) then
			
			if (page ~= 8) then
				page = page + 1
			end
		elseif (limit >= 108 and limit < 120) then
			
			if (page ~= 9) then
				page = page +1
			end
		elseif (limit >= 120 and limit <= 128) then
			
			if (page ~= 10) then
				page = page + 1
			end	
		end
	end	
end

function scrollUp( )
	if (isEventHandled) then
		if (page ~= 1) then
			
			page = page - 1
		end	
	end	
end

function drawPlayerList( )
	if (getData(getLocalPlayer(), "loggedin") == 1) then
		if not (isEventHandled) then
			
			isEventHandled = true
			
			local done = assemblePlayersByID( )
			if ( done ) then
				addEventHandler("onClientRender", getRootElement(), renderPlayerList)
			end	
		end	
	end	
end

function removePlayerList( )
	if (isEventHandled) then
		
		isEventHandled = false
		removeEventHandler("onClientRender", getRootElement(), renderPlayerList)
	end	
end

function bindKeysOnStart( )
	bindKey("tab", "down", drawPlayerList)
	bindKey("tab", "up", removePlayerList)
	
	bindKey("mouse_wheel_down", "down", scrollDown)
	bindKey("mouse_wheel_up", "down", scrollUp)
end
addEventHandler("onClientResourceStart", resourceRoot, bindKeysOnStart)	