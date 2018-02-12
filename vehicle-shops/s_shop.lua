local sql = exports.sql
local element = createElement("shop")

--------- [ Element Data returns ] ---------
local function getData( theElement, key )
	local key = tostring(key)
	if isElement(theElement) and (key) then
		
		return exports['[ars]anticheat-system']:callData( theElement, tostring(key) )
	else
		return false
	end
end	

local function setData( theElement, key, value, sync )
	local key = tostring(key)
	local value = tonumber(value) or tostring(value)
	if isElement(theElement) and (key) and (value) then
		
		return exports['[ars]anticheat-system']:assignData( theElement, tostring(key), value, sync )
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
addEventHandler("onVehicleStartEnter", root,
function( thePlayer )
	if (getElementParent(source) == element) then
		cancelEvent( )
		
		local name = getVehicleName(source)
		local price = 0
		for k, v in ipairs(shops) do 
			for i, j in ipairs(shops[k][2]) do
				if (j[1] == tostring(name)) then
				
					price = j[2]
				end
			end	
		end
		
		triggerClientEvent(thePlayer, "showVehicleBuyUI", thePlayer, source, price)
	end	
end)

--------- [ Re-order Vehicle ] ---------
function reorderVehicle( shop, x, y, z, rot )
	local data = { shop, x, y, z, rot }
	
	setTimer(function( )
		
		for m, n in ipairs(shops) do
			if ( m == tonumber( data[1] ) ) then
			
				local t = shops[m][2]
			
				local id = getVehicleModelFromName(tostring(t[math.random(1, #t)][1]))
				local x, y, z, rot = data[2], data[3], data[4], data[5]
				
				-- Spawn!
				local vehicle = createVehicle( id, x, y, z, 0, 0, rot )
				if isElement(vehicle) then
					
					setData(vehicle, "faction", -1, true)
					setData(vehicle, "dbid", 0, true)
					setData(vehicle, "owner", -1, true)
					setData(vehicle, "fuel", 100, true)
					setData(vehicle, "plate", "SHOP", true)
					setData(vehicle, "tinted", 0, true)
					setData(vehicle, "engine", 0, true)
					setData(vehicle, "enginebroke", 0, true)
					setData(vehicle, "impounded", 0, true)
					setData(vehicle, "handbrake", 0, true)
					
					setElementParent(vehicle, element)
					setElementFrozen(vehicle, true)
					break
				end	
			end	
		end
	end, 300000, 1)	
end
addEvent("reorderVehicle", true)
addEventHandler("reorderVehicle", root, reorderVehicle)
	
--------- [ Spawning Vehicles ] ---------
local spawnTimer = nil
function spawnShopVehicles( )
	
	local positions = { }
	positions[1] = { }
	positions[2] = { }
	positions[3] = { }
	
	for i, v in ipairs(shops) do 
		for k, j in ipairs(shops[i][1]) do 
			
			positions[i][k] = { j[1], j[2], j[3], j[4], j[5], j[6] }
		end
	end
	
	for m, n in ipairs(shops) do
		
		local t = shops[m][2]
		
		for j = 1, #positions[m] do
			
			local id = getVehicleModelFromName(tostring(t[math.random(1, #t)][1]))
			local x, y, z, rot = unpack(positions[m][j])
			
			-- Spawn!
			local vehicle = createVehicle( id, x, y, z, 0, 0, rot )
			if isElement(vehicle) then

				setData(vehicle, "faction", -1, true)
				setData(vehicle, "dbid", 0, true)
				setData(vehicle, "owner", -1, true)
				setData(vehicle, "fuel", 100, true)
				setData(vehicle, "plate", "SHOP", true)
				setData(vehicle, "tinted", 0, true)
				setData(vehicle, "engine", 0, true)
				setData(vehicle, "enginebroke", 0, true)
				setData(vehicle, "impounded", 0, true)
				setData(vehicle, "handbrake", 0, true)
				
				setElementParent(vehicle, element)
				setTimer(setElementFrozen, 1000, 1, vehicle, true)
			end
		end	
	end
end	
addEventHandler("onResourceStart", resourceRoot, spawnShopVehicles)

function startAllCycles( )
	for key, value in ipairs ( getElementsByType("vehicle") ) do
		local theVehicle = getVehicleNameFromModel( getElementModel( value ) )
		if ( theVehicle == "Bike" or theVehicle == "BMX" or theVehicle == "Mountain Bike" ) then
			
			setVehicleEngineState( value, true )
			setData( value, "engine", 1 )
		end
	end	
end
addCommandHandler("startcycle", startAllCycles)