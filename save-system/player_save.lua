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

--------- [ Saving ] ---------
function savePlayer( quitType )
	if (getData(source, "loggedin") == 1) then
	
		local x, y, z = getElementPosition(source)
		local rot = getPedRotation(source)
		local skin = getElementModel(source)
		local health = getElementHealth(source)
		local armor = getPedArmor(source) 
		local fightstyle = getPedFightingStyle(source)
		local money = getPlayerMoney(source) 
		local lastarea = getElementZoneName(source)
		
		local tweapons = { }
		local tammo = { }
		for i = 1, 12 do
			tweapons[i] = getPedWeapon(source, i)
			tammo[i] = getPedTotalAmmo(source, i)
		end
		local weapons = tweapons[1] ..",".. tweapons[2] ..",".. tweapons[3] ..",".. tweapons[4] ..",".. tweapons[5] ..",".. tweapons[6] ..",".. tweapons[7] ..",".. tweapons[8] ..",".. tweapons[9] ..",".. tweapons[10] ..",".. tweapons[11] ..",".. tweapons[12]
		local ammo = tammo[1] ..",".. tammo[2] ..",".. tammo[3] ..",".. tammo[4] ..",".. tammo[5] ..",".. tammo[6] ..",".. tammo[7] ..",".. tammo[8] ..",".. tammo[9] ..",".. tammo[10] ..",".. tammo[11] ..",".. tammo[12]
		
		local int = getElementInterior(source)
		local dim = getElementDimension(source)
			
		local reports = getData(source, "adminreports")
		local hoursPlayed = getData(source, "hoursplayed")
		
		local update1 = sql:query("UPDATE characters SET x=".. sql:escape_string(x) ..", y=".. sql:escape_string(y) ..", z=".. sql:escape_string(z) ..", rot=".. sql:escape_string(rot) ..", skin=".. sql:escape_string(skin) ..", health=".. sql:escape_string(health) ..", armor=".. sql:escape_string(armor) ..", weapons='".. sql:escape_string(tostring(weapons)) .."', ammo='".. sql:escape_string(tostring(ammo)) .."', fightstyle=".. sql:escape_string(fightstyle) ..", money=".. sql:escape_string(money) ..", interior=".. sql:escape_string(int) ..", dimension=".. sql:escape_string(dim) ..", lastarea='".. sql:escape_string(lastarea) .."', `hoursplayed`=".. sql:escape_string(hoursPlayed) .." WHERE id=".. sql:escape_string(getData(source, "dbid")) .."") 
		local update2 = sql:query("UPDATE accounts SET reports=".. sql:escape_string(reports) .." WHERE id=".. sql:escape_string(getData(source, "accountid")) .."")
		
		if ( not update1 ) then
			
			outputDebugString("Unable to save character stats!")
			outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
		elseif ( not update2 ) then
			
			outputDebugString("Unable to save account stats!")
			outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
		end	
		
		sql:free_result(update1)
		sql:free_result(update2)
		
		triggerEvent("savePlayerInventory", source, getData(source, "dbid"))
		
		if (quitType ~= "Change Character") then
			triggerEvent("emptyIndex", source)
		end	
	end	
end
addEvent("savePlayer", true)
addEventHandler("savePlayer", getRootElement(), savePlayer)
addEventHandler("onPlayerQuit", getRootElement(), savePlayer)

function saveAllPlayers( )
	outputServerLog("===== Saving All Players =====")
	for key, thePlayer in ipairs(getElementsByType("player")) do
		if (getData(thePlayer, "loggedin") == 1) then
			triggerEvent("savePlayer", thePlayer, "Change Character")
		end	
	end	
	outputServerLog("===== All Players Saved =====")
end
setTimer(saveAllPlayers, 1800000, 0) -- Save every 30 minutes..