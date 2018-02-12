--------- [ Element Data returns ] ---------
local function getData( theElement, key )
	local key = tostring(key)
	if isElement(theElement) and (key) then
		
		return exports['[ars]anticheat-system']:c_callData( theElement, tostring(key) )
	else
		return false
	end
end	

-------------- [ Nametags ] ---------------
local font = dxCreateFont("font.ttf", 12, true)

function renderNameTags( )
	local a, b, c = getCameraMatrix( )
	
	for k, v in ipairs( getElementsByType("player") ) do
		if getData(v, "loggedin") == 1 then
			
			if getData(v, "nametag") == 1 then
				
				local x, y, z = getElementPosition(getLocalPlayer())
				local px, py, pz = getElementPosition(v)
				local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
				
				if ((distance < 20) and (v ~= getLocalPlayer()) and isElementOnScreen( v ) and isLineOfSightClear(a, b, c, px, py, pz, true, false, false, true, false, false, false)) then
					pz = pz + 1.2
					
			
					local barSkyPosition = 5
					local txtSkyPosition = 5

					local r, g, b = getPlayerNametagColor(v)
					local health = getElementHealth(v)
					if (health > 70) then
						color = tocolor(0, 255, 0, 150)
					elseif (health > 35 and health <= 70) then
						color = tocolor(255, 255, 0, 150)
					elseif (health <= 35) then
						color = tocolor(255, 0, 0, 150)
					end
					
					if (health > 100) then
						health = 100
					end	
					local h_barsize = health * 1
					
					local armor = getPedArmor(v)
					if (armor > 100) then
						armor = 100
					end	
					local a_barsize = armor * 1
					
					local sx, sy = getScreenFromWorldPosition(px, py, pz)
					
					if (sx) and (sy) then
						
						dxDrawText("[".. getData(v, "playerid") .."] ".. getPlayerNametagText(v):gsub("_", " ") .."", sx, sy - txtSkyPosition*20, sx, sy, tocolor(r, g, b, 255), 1, font, "center", "center")
						
						dxDrawRectangle(sx - 50, (sy + 20) - barSkyPosition*10 , h_barsize, 15, color, false)
						-- Bounding Box
						dxDrawLine(sx - 51, (sy + 18) - barSkyPosition*10, sx + 49, (sy + 18) - barSkyPosition*10, tocolor(0, 0, 0, 200), 3)
						dxDrawLine(sx - 51, (sy + 35) - barSkyPosition*10, sx + 49, (sy + 35) - barSkyPosition*10, tocolor(0, 0, 0, 200), 3)
						dxDrawLine(sx - 52, (sy + 16.5) - barSkyPosition*10, sx - 52, (sy + 36.5) - barSkyPosition*10, tocolor(0, 0, 0, 200), 3)
						dxDrawLine(sx + 49, (sy + 17) - barSkyPosition*10, sx + 49, (sy + 36) - barSkyPosition*10, tocolor(0, 0, 0, 200), 3)
						
						if armor > 0 then
							dxDrawRectangle(sx - 50, (sy + 45) - barSkyPosition*10, a_barsize, 15, tocolor(255, 255, 255, 150), false)	
							-- Bounding Box
							dxDrawLine(sx - 51, (sy + 42) - barSkyPosition*10, sx + 50, (sy + 42) - barSkyPosition*10, tocolor(0, 0, 0, 200), 3)
							dxDrawLine(sx - 51, (sy + 59) - barSkyPosition*10, sx + 50, (sy + 59) - barSkyPosition*10, tocolor(0, 0, 0, 200), 3)
							
							dxDrawLine(sx - 52, (sy + 40.5) - barSkyPosition*10, sx - 52, (sy + 60.5) - barSkyPosition*10, tocolor(0, 0, 0, 200), 3)
							dxDrawLine(sx + 49, (sy + 41) - barSkyPosition*10, sx + 49, (sy + 60) - barSkyPosition*10, tocolor(0, 0, 0, 200), 3)	
						end	
					end
				end
			end	
		end	
	end	
end
	
function onResourceStartDisplayTags( res )
	addEventHandler("onClientRender", getRootElement(), renderNameTags)
end
addEventHandler("onClientResourceStart", resourceRoot, onResourceStartDisplayTags)

function onResourceStopRemoveTags( res )
	removeEventHandler("onClientRender", getRootElement(), renderNameTags)
end
addEventHandler("onClientResourceStop", resourceRoot, onResourceStopRemoveTags)	