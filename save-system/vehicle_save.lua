local sql = exports.sql

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

--------- [ Save Vehicle ] ---------
function saveVehicle( thePlayer )

	local dbid = getData(source, "dbid")
	
	local fuel = getData(source, "fuel")
	local engine = getData(source, "engine")
	local enginebroke = getData(source, "enginebroke")
	local handbrake = getData(source, "handbrake")
	local impounded = getData(source, "impounded")
	
	local customColors = tonumber( getData( source, "custom_color") )
	local isVehicleCustomColored = false
	if ( customColors == 1 ) then
		isVehicleCustomColored = true
	end 
	
	local colours = false
	local color1, color2 = false
	
	if ( isVehicleCustomColored ) then
		local red1, green1, blue1, red2, green2, blue2 = getVehicleColor( source, true )
		colors = red1 ..",".. green1 ..",".. blue1 ..",".. red2 ..",".. green2 ..",".. blue2
	else	
		color1, color2 = getVehicleColor(source)
	end	
	
	local upgrades = ""
	local t = getVehicleUpgrades( source )
	
	if ( #t > 0 ) then
		for key, value in ipairs ( t ) do
			
			upgrades = upgrades .. value .. ","
		end
	end
	
	local health = getElementHealth(source)
	local lights = getVehicleOverrideLights(source)
	
	local x, y, z = getElementPosition(source)
	local rotx, roty, rotz = getElementRotation(source)
	local dim = getElementDimension(source)
	local int = getElementInterior(source)
	
	local colorQuery = nil
	if ( not color1 ) and ( not color2 ) then
		colorQuery = "color1='0', color2='0', custom_colors='".. sql:escape_string(colors) .."'"
	else
		colorQuery = "color1=".. sql:escape_string(color1) ..", color2=".. sql:escape_string(color2) ..", custom_colors=''"
	end
	
	local update = sql:query("UPDATE vehicles SET currx=".. sql:escape_string(x) ..", curry=".. sql:escape_string(y) ..", currz=".. sql:escape_string(z) ..", currrotx=".. sql:escape_string(rotx) ..", currroty=".. sql:escape_string(roty) ..", currrotz=".. sql:escape_string(rotz) ..", currdimension=".. sql:escape_string(dim) ..", currinterior=".. sql:escape_string(int) ..", fuel=".. sql:escape_string(fuel) ..", lights=".. sql:escape_string(lights) ..", engine=".. sql:escape_string(engine) ..", enginebroke=".. sql:escape_string(enginebroke) ..", handbrake=".. sql:escape_string(handbrake) ..", ".. colorQuery ..", `upgrades`='".. sql:escape_string( upgrades ) .."', health=".. sql:escape_string(health) ..", Impounded=".. sql:escape_string(impounded) .." WHERE id=".. sql:escape_string(dbid) .."")
	if not (update) then
		outputDebugString("MySQL Error: Vehicle saving failed!", 1)
	end	
	
	sql:free_result(update)
end
addEventHandler("onVehicleExit", getRootElement(), saveVehicle)
addEvent("saveVehicle", true)
addEventHandler("saveVehicle", getRootElement(), saveVehicle)