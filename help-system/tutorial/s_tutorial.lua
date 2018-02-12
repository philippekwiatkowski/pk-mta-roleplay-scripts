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

--------- [ Tutorial System ] ---------	
function saveTutorial( )
	local id = tonumber( getData(source, "accountid") )
	if ( id ) then
		
		local update = sql:query("UPDATE `accounts` SET `tutorial`='1' WHERE `id`=".. sql:escape_string( id ))
		if ( update ) then
			
			local username = tostring( getData(source, "accountname") )
			local admin = tonumber( getData(source, "admin") )
			local adminduty = tonumber( getData(source, "adminduty") )
			local hiddenadmin = tonumber( getData(source, "hiddenadmin") )
			local reports = tonumber( getData(source, "adminreports") )
			local donator = tonumber( getData(source, "donator") )
			local togglepm = tonumber( getData(source, "togglepm") )
			local tutorial = 1
			local friends = tostring( getData(source, "friends") )
			local skinmods = tonumber( getData(source, "skinmods") )
			local weaponmods = tonumber( getData(source, "weaponmods") )
			local vehiclemods = tonumber( getData(source, "vehiclemods") )
		
			triggerEvent("loginPlayer", source, username, id, admin, adminduty, hiddenadmin, reports, donator, togglepm, tutorial, friends, skinmods, weaponmods, vehiclemods, false)
		end	
	end	
	
	sql:free_result(update)
end
addEvent("saveTutorial", true)
addEventHandler("saveTutorial", root, saveTutorial)