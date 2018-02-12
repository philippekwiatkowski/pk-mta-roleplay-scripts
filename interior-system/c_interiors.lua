--------- [ Element Data returns ] ---------
local function getData( theElement, key )
	local key = tostring(key)
	if isElement(theElement) and (key) then
		
		return exports['[ars]anticheat-system']:c_callData( theElement, tostring(key) )
	else
		return false
	end
end	

--------- [ Interior System ] ---------

-- DRAW INTERIOR DETAILS
local rendering = false
local calibri = dxCreateFont("calibri.ttf", 11, true)

function drawInteriorDetails( )
	local a, b, c = getCameraMatrix( ) 
	
	for index, value in ipairs (getElementsByType("marker", root, true)) do
		
		-- Make sure they are interior markers, not job or any other markers
		local mr, mg, mb = getMarkerColor(value)
		if (mr == 255 and mg == 255 and mb == 255) then
		
			local child = getElementChild(value, 0)
			if ( child ) then
				
				local x, y, z = getElementPosition(value)
				
				local distance = getDistanceBetweenPoints3D(x, y, z, a, b, c)	
				
				if ( distance <= 15 ) then
				
					local screenX, screenY = getScreenFromWorldPosition(x, y, z + 1.5)
					if (screenX and screenY) then
						
						local sightClear = isLineOfSightClear( a, b, c, x, y, z + 0.75, true, true, false, false, false )
						if ( sightClear ) then
							
							local name = tostring(getData(value, "name"))
							local price = tonumber(getData(value, "price"))
							local owner = tonumber(getData(value, "owner"))
							local rented = tonumber(getData(value, "rented"))
							local type = tonumber(getData(value, "type"))
							local elevator = tonumber(getData(value, "elevator"))
						
							local helpText = nil
							
							if (owner == -1) and (type ~= 3) and (rented == 0) and (elevator == 0) then
								helpText = "Press F to buy"
								price = "Price: $".. tostring(price)
							elseif (owner == -1) and (type ~= 3) and (rented == 1) and (elevator == 0) then
								helpText = "Press F to rent"
								price = "Price: $".. tostring(price)
							elseif (owner > 0) and (type ~= 3) and (elevator == 1) then
								helpText = "Press F to enter"
								price = ""
							elseif (owner > 0) and (type ~= 3) and (elevator == 0) then
								helpText = "Press F to enter"
								price = ""	
							elseif (owner == -1) and (type ~= 3) and (elevator == 1) then
								helpText = ""
								price = ""	
							elseif (owner == -1) and (type == 3) then
								helpText = "Press F to enter"
								price = ""
							end	
							
							local r, g, b = 255, 255, 255
							
							if (calibri) then
								dxDrawText(tostring(name), screenX - 55, screenY - 5, screenX, screenY, tocolor(r, g, b, 200), 1, calibri, "center")
								dxDrawText(tostring(helpText), screenX - 55, screenY + 13, screenX, screenY + 18, tocolor(r, g, b, 200), 1, calibri, "center")
								dxDrawText(tostring(price), screenX - 55, screenY + 31, screenX, screenY + 36, tocolor(r, g, b, 200), 1, calibri, "center")
							end
						end	
					end
				end	
			end	
		end	
	end	
end

function renderInteriorDetails( )
	if ( not rendering ) then
		
		rendering = true
		addEventHandler("onClientRender", root, drawInteriorDetails)
	end	
end
addEvent("renderInteriorDetails", true)
addEventHandler("renderInteriorDetails", localPlayer, renderInteriorDetails)

addEventHandler("onClientResourceStart", resourceRoot,
	function( )
		if ( getData( localPlayer, "loggedin" ) == 1 ) then
			
			rendering = true
			addEventHandler("onClientRender", root, drawInteriorDetails)
		end
	end
)	