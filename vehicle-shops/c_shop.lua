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

--------- [ Vehicle Shops ] ---------
local shops = 
{ 
	{
		{
			{ -1970.3007, 256.4638, 34.8027, 91 },
			{ -1970.4218, 260.9804, 34.8022, 90 },
			{ -1970.4980, 265.3876, 34.7746, 91 },
			{ -1970.6689, 269.8632, 34.8026, 92 },
			{ -1970.4833, 274.3330, 34.8014, 91 },
			{ -1970.4824, 278.8154, 34.8043, 90 }
		},
		
		{
			{ "Buffalo", 51000 },
			{ "Phoenix", 43000 },
			{ "Banshee", 89000 },
			{ "Jester",  44000 },
			{ "Cheetah", 140000 },
			{ "Comet",   66000 },
			{ "Sultan",  45000 },
			{ "Elegy",   37000 },
			{ "Flash",   32000 },  
			{ "Uranus",  56000 },
			{ "Turismo", 370000 },
			{ "Infernus", 330000 },
			{ "Bullet", 260000 },
			{ "Super GT", 110000 },
			{ "ZR-350", 75000 },
			{ "Windsor", 42000 },
			{ "Feltzer", 51000 },
			{ "Euros", 36000 }
		}	
	},

	{
		{
			{ -1992.7285, 241.1767, 34.8691, 280 },
			{ -1992.4423, 245.2685, 34.8716, 266 },
			{ -1991.9267, 249.2519, 34.8696, 264 },
			{ -1991.3798, 253.4052, 34.9248, 266 },
			{ -1990.6533, 261.5654, 34.8772, 266 },
			{ -1990.3710, 265.6660, 34.8657, 267 },
			{ -1991.0585, 257.4882, 34.8754, 267 },
			{ -1989.9746, 269.9824, 34.8745, 267 },
			{ -1989.6406, 274.5546, 34.8722, 267 }	
		},
		
		{
			{ "Hustler", 18000 },
			{ "Blista Compact", 17000 },
			{ "Majestic", 11000 },
			{ "Bravura", 15000 },
			{ "Manana", 7000 },
			{ "Picador", 13000 },
			{ "Cadrona", 13000 },
			{ "Previon", 7000 },
			{ "Club", 9000 },
			{ "Stallion", 10000 },
			{ "Tampa", 7000 },
			{ "Fortune", 13000 },
			{ "Virgo", 15000 },
			{ "Admiral", 25000 },
			{ "Premier", 30000 },
			{ "Elegant", 22000 },
			{ "Primo", 18000 },
			{ "Emperor", 20000 },
			{ "Sentinel", 41000 },
			{ "Sunrise", 18000 },
			{ "Greenwood", 15000 },
			{ "Tahoma", 14000 },
			{ "Intruder", 16000 },
			{ "Vincent", 18000 },
			{ "Merit", 23000 },
			{ "Washington", 41000 },
			{ "Nebula", 22000 },
			{ "Willard", 15000 },
			{ "Walton", 6900 },
			{ "Clover", 14000 },
			{ "Sadler", 14000 },
			{ "Rumpo", 24000 },
			{ "Rancher", 23000 },
			{ "Moonbeam", 16000 },
			{ "Pony", 21000 },
			{ "Regina", 21000 },
			{ "Bobcat", 19000 },
			{ "Perennial", 10000 },
			{ "Camper", 27000 },
			{ "Burrito", 23000 },
			{ "Solair", 28000 },
			{ "Stratum", 31000 },
			{ "Yosemite", 34000 },
			{ "Patriot", 37000 },
			{ "Landstalker", 37000 },
			{ "Huntley", 49000 },
			{ "Mesa", 25000 },
			{ "Savanna", 18000 },
			{ "Blade", 17000 },
			{ "Broadway", 24000 },
			{ "Remington", 22000 },
			{ "Slamvan", 24000 },
			{ "Tornado", 13000 },
			{ "Voodoo", 16000 },
			{ "Oceanic", 15000 },
			{ "Glendale", 13000 },
			{ "Buccaneer", 14000 },
			{ "Esperanto", 13000 },
			{ "Hermes", 23000 }
		}
	},
	
	{
		{
			{ -1969.5654, 307.5390, 34.7352, 179 },
			{ -1971.5654, 307.5488, 34.7360, 179 },
			{ -1973.5654, 307.5488, 34.7360, 179 },
			{ -1975.5654, 307.5488, 34.7360, 179 },
			{ -1977.5654, 307.5488, 34.7360, 179 },
			{ -1979.5654, 307.5488, 34.7360, 179 },
			{ -1981.5654, 307.5488, 34.7360, 179 }
		},
		
		{
			{ "BF-400", 14000 },
			{ "NRG-500", 30000 },
			{ "PCJ-600", 16000 },
			{ "Faggio", 2000 },
			{ "Pizzaboy", 2000 },
			{ "FCR-900", 15000 },
			{ "Sanchez", 4000 },
			{ "Freeway", 17000 },
			{ "Wayfarer", 14000 },
			{ "Quadbike", 3000 }
		}
	}
}

--------- [ Buy Vehicle ] ---------
function showVehicleBuyUI( theVehicle, theVehiclePrice )
	local screenX, screenY = guiGetScreenSize( )

	local width, height = 400, 180
	local x, y = (screenX/2) - (width/2), (screenY/2) - (height/2)
	
	vehicleBuyWin = guiCreateWindow(x, y, width, height, "Buy Vehicle", false)
	
	askLabel = guiCreateLabel(20, 30, 360, 20, "Would you like to buy this ".. getVehicleName(theVehicle) .."?", false, vehicleBuyWin)
	
	local length = guiLabelGetTextExtent(askLabel)
	guiSetPosition(askLabel, (width/2) - (length/2), 30, false)
	
	local priceLbl = guiCreateLabel(153, 60, 94, 20, "Price: $".. theVehiclePrice, false, vehicleBuyWin)
	local taxLbl = guiCreateLabel(153, 80, 94, 20, "Tax: $".. math.ceil( theVehiclePrice*0.001 ), false, vehicleBuyWin)
	
	buttonYes = guiCreateButton(30, 120, 110, 30, "Yes", false, vehicleBuyWin)
	addEventHandler("onClientGUIClick", buttonYes, 
	function( button, state )
		if (button == "left" and state == "up") then
		
			destroyElement(vehicleBuyWin)
			showCursor(false)
			
			local tax = math.ceil( theVehiclePrice*0.001 )
			local realPrice = theVehiclePrice + tax
			
			local money = nil
			money = tonumber(getPlayerMoney(localPlayer)/100)
			money = tonumber(string.format("%.2f", money))
			
			if (money >= realPrice) then
				
				local x, y, z = getElementPosition(theVehicle)
				local _, _, rot = getElementRotation(theVehicle)
				
				triggerServerEvent("buyVehicle", theVehicle, localPlayer, realPrice, x, y, z, rot)
	
				-- Reorder
				triggerServerEvent("reorderVehicle", localPlayer, getVehicleShop( getVehicleName(theVehicle) ), x, y, z, rot)
			else
				outputChatBox("You do not have enough money.", 255, 0, 0)
			end	
		end
	end, false)
	
	buttonNo = guiCreateButton(260, 120, 110, 30, "No", false, vehicleBuyWin)
	addEventHandler("onClientGUIClick", buttonNo, 
	function( button, state )
		if (button == "left" and state == "up") then
			
			destroyElement(vehicleBuyWin)
			showCursor(false)
		end
	end, false)	
	
	guiSetFont(askLabel, "clear-normal")
	guiSetFont(priceLbl, "clear-normal")
	guiSetFont(taxLbl, "clear-normal")
	
	showCursor(true)
end
addEvent("showVehicleBuyUI", true)
addEventHandler("showVehicleBuyUI", localPlayer, showVehicleBuyUI)

function getVehicleShop( vehicleName )
	for k, v in ipairs ( shops ) do
		for i, j in ipairs ( shops[k][2] ) do
			
			if ( j[1] == vehicleName ) then
				
				return k
			end
		end
	end
end

--------- [ Rendering ] ---------
function renderVehicleInformation( )
	local a, b, c = getCameraMatrix( ) 
	
	for key, shop in pairs( getElementsByType( "shop" ) ) do 
		for index, vehicle in ipairs( getElementChildren( shop ) ) do
			
			local vehicleName = getVehicleName( vehicle )
			local price = getVehiclePrice( vehicleName )
			
			local vehicleX, vehicleY, vehicleZ = getElementPosition( vehicle )
			
			local x, y, z = getDrawingPosition( vehicleX, vehicleY, vehicleZ )
			local px, py, pz = getElementPosition(localPlayer)
		
			local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)	
			if ( distance <= 15 ) then
				
				local screenX, screenY = getScreenFromWorldPosition(x, y, z + 1.5)
				if (screenX and screenY) then
					
					dxDrawText("Name: ".. tostring(vehicleName), screenX - 65, screenY - 40, screenX, screenY, tocolor(255, 255, 255, 255), 1.5, "clear")
					dxDrawText("Price: $".. tostring(price), screenX - 65, screenY - 20, screenX, screenY, tocolor(255, 255, 255, 255), 1.5, "clear")
					dxDrawText("Tax: $".. tostring(math.ceil( price*0.001 ) ), screenX - 65, screenY, screenX, screenY, tocolor(255, 255, 255, 255), 1.5, "clear")
				end	
			end
		end
	end
end
addEventHandler("onClientRender", root, renderVehicleInformation)

function getVehiclePrice( vehicleName )
	for key, value in ipairs( shops ) do
		
		local t = shops[key][2]
		for i = 1, #t do
			
			if ( tostring( vehicleName ) == t[i][1] ) then
				return t[i][2]
			end	
		end
	end
end	

function getDrawingPosition( vehicleX, vehicleY, vehicleZ )
	for key, value in ipairs( shops ) do
		
		local t = shops[key][1]
		for i = 1, #t do
			
			if ( getDistanceBetweenPoints3D( vehicleX, vehicleY, vehicleZ, t[i][1], t[i][2], t[i][3] ) <= 1.2 ) then
				return t[i][1], t[i][2], t[i][3]
			end	
		end
	end	
end