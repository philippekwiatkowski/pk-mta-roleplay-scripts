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
	if isElement(theElement) and (key) and (value) then
		
		return exports['[ars]anticheat-system']:assignData( theElement, tostring(key), value, sync )
	else
		return false
	end	
end

--------- [ Login Player ] ---------
function loginPlayer( username, id, admin, adminduty, hiddenadmin, reports, donator, togglepm, tutorial, friends, skinmods, weaponmods, vehiclemods, clean )
	
	local friends = tostring( friends )
	if ( friends == "nil" ) or ( string.find( friends, "userdata" ) ) or ( string.len( friends ) == 0 ) then
		friends = "none"
	end
	
	setData(source, "accountname", tostring(username), true)
	setData(source, "accountid", tonumber(id), true)
	setData(source, "admin", tonumber(admin), true)
	setData(source, "adminduty", tonumber(adminduty), true)
	setData(source, "hiddenadmin", tonumber(hiddenadmin), true)
	setData(source, "adminreports", tonumber(reports), true)
	setData(source, "donator", tonumber(donator), true)
	setData(source, "togglepm", tonumber(togglepm), true)
	setData(source, "tutorial", tonumber(tutorial), true)
	setData(source, "friends", tostring(friends), true)
	setData(source, "skinmods", tonumber(skinmods), true)
	setData(source, "weaponmods", tonumber(weaponmods), true)
	setData(source, "vehiclemods", tonumber(vehiclemods), true)
	
	if (clean) then
		triggerClientEvent(source, "cleanUpLogin", source)
	end
	
	if ( tonumber( tutorial ) == 0 ) then -- Tutorial
		
		fadeCamera(source, false )
		
		local thePlayer = source
		setTimer( triggerClientEvent, 2000, 1, thePlayer, "beginTutorial", thePlayer)
	else	
		setElementAlpha(source, 0)
		setElementInterior(source, 0)
		setElementPosition(source, 0, 0, 3)
		setCameraInterior(source, 0)
		setCameraMatrix(source, -1982.8076171875, 538.39984130859, 101.63790893555, -2038.9289550781, 616.32495117188, 73.743957519531)
		
		-- CHARACTERS
		local characters = { }
		local count = 0
		local result = sql:query("SELECT id, charactername, skin, faction, rank, lastarea, age, gender, lastlogin, DATEDIFF(NOW(), lastlogin) AS llastlogin FROM characters WHERE account=".. sql:escape_string(id) .." ORDER BY lastlogin DESC")
		while true do
			local row = sql:fetch_assoc( result )
			if not row then break end
			
			count = count + 1
			
			local id = row['id']
			local name = row['charactername']
			local skin = row['skin']	
			local faction = row['faction']
			local rank = row['rank']
			local lastarea = row['lastarea']
			local age = row['age']
			local gender = row['gender']
			local lastlogin = row['lastlogin']
			
			characters[count] = { }
			characters[count][1] = id
			characters[count][2] = name
			characters[count][3] = skin
			characters[count][4] = "Not in a faction"
			
			-- Faction
			for i, team in ipairs ( getElementsByType("team") ) do
				if isElement(team) then
					if tonumber(getData(team, "id")) == tonumber(faction) then
						
						characters[count][4] = getTeamName(team)
						break
					end
				end
			end	
			
			-- Rank
			characters[count][5] = ""
			if tonumber(faction) ~= -1 then
				local result = sql:query_fetch_assoc("SELECT rank FROM factions WHERE id=".. sql:escape_string(faction) .."")
				if (result) then
					local ranks = tostring(result['rank'])
					tranks = split(ranks, string.byte(",")) 
					
					characters[count][5] = tranks[tonumber(rank)] or "N/A"
					tranks = nil
				end	
			end
			
			characters[count][6] = gender
			characters[count][7] = lastarea
			characters[count][8] = age
			characters[count][9] = lastlogin
			
		end	
		
		sql:free_result(result)
		
		-- FRIENDS
		local theFriends = { }
		
		if ( friends ~= "none" ) then -- No Friends
		
			-- Their country
			local country = tostring( exports['[ars]global']:getPlayerCountryByIP( getPlayerIP( source ), true ) )
		
			local listFriends = split( tostring( friends ), "," )
			if ( #listFriends > 0 ) then
				for key, value in ipairs ( listFriends ) do
					
					local result = sql:query_fetch_assoc("SELECT `username`, `ip`, DATEDIFF(NOW(), `lastlogin`) as `llastlogin`, `banned` FROM accounts WHERE id=".. sql:escape_string( tonumber( value ) ).."")
					if ( result ) then
						
						local username = tostring( result['username'] )
						local lastlogin = tostring( result['llastlogin'] )
						local banned = tonumber( result['banned'] )
						local ip = tostring( result['ip'] )
						
						local friendCountry = tostring( exports['[ars]global']:getPlayerCountryByIP( ip, true ) )
						
						local sameCountry = "false"
						if ( country == friendCountry ) then
							sameCountry = "true"
						end
						
						theFriends[key] = { username, friendCountry, sameCountry, lastlogin, banned }
					end
				end
			end	
		end
		
		triggerClientEvent(source, "showCharactersUI", source, characters, theFriends, skinmods, weaponmods, vehiclemods)
		
		if isKeyBound(source, "end", "down", changeCharacter) then
			unbindKey(source, "end", "down", changeCharacter)
		end	
		
		bindKey(source, "end", "down", changeAccount)
		
		sql:free_result(result)
	end	
end
addEvent("loginPlayer", true)
addEventHandler("loginPlayer", getRootElement(), loginPlayer)
	
--------- [ Character Spawning ] ---------
function spawnCharacter( name )
	
	local result = sql:query_fetch_assoc("SELECT * FROM characters WHERE charactername='".. sql:escape_string(tostring(name)) .."'")
	if (result) then
		
		local dbid = result['id']
		local x = result['x']
		local y = result['y']
		local z = result['z']
		local rot = result['rot']
		local skin = result['skin']
		local health = result['health']
		local armor = result['armor']
		local weapons = result['weapons']
		local ammo = result['ammo']
		local radio = result['radio']
		local fightstyle = result['fightstyle']
		local money = result['money']
		local interior = result['interior']
		local dimension = result['dimension']
		local duty = result['duty']
		local job = result['job']
		local faction = result['faction']
		local rank = result['rank']
		local items = result['items']
		local itemvalues = result['itemvalues']
		local mask = result['mask']
		local cuffed = result['cuffed']
		local drivinglicense = result['drivinglicense']
		local hoursplayed = result['hoursplayed']
		
		setData(source, "dbid", tonumber(dbid), true)
		
		-- Others
		setData(source, "loggedin", 1, true)
		setData(source, "invisible", 0, true)
		setData(source, "muted", 0, true)
		setData(source, "globalooc", 1, true)
	
		setData(source, "LSPDbadge", 0, true)
		setData(source, "LSFDbadge", 0, true)
		setData(source, "SANEbadge", 0, true)
		setData(source, "LSVSbadge", 0, true)
		
		setData(source, "duty", tonumber(duty), true)
		
		setData(source, "job", tonumber(job), true)
		
		setData(source, "pickedup", 0, true) 
		setData(source, "ringing", 0, true)
		setData(source, "calling", 0, true)
		
		setData(source, "radio", tonumber(radio), true)
		
		setPlayerName(source, tostring(name):gsub(" ", "_"))
		setData(source, "nametag", 1, true) 
		
		-- Mask
		if tonumber( mask ) == 0 then
			setData(source, "mask", 0, true)
			setPlayerNametagText(source, getPlayerName(source):gsub("_", " "))
		else
			setData(source, "mask", 1, true)
			setPlayerNametagText(source, "Unknown Person (Mask)")
		end
		
		-- Bandana
		setData(source, "bandana", 0, true)
		
		-- Cuffs
		setData(source, "cuffed", tonumber(cuffed), true)
		if tonumber( cuffed ) == 1 then
		
			toggleControl(source, "sprint", false)
			toggleControl(source, "jump", false)
			toggleControl(source, "aim_weapon", false)
			toggleControl(source, "fire", false)
			toggleControl(source, "next_weapon", false)
			toggleControl(source, "previous_weapon", false)
		elseif tonumber( cuffed ) == 0 then
			
			toggleControl(source, "sprint", true)
			toggleControl(source, "jump", true)
			toggleControl(source, "aim_weapon", true)
			toggleControl(source, "fire", true)
			toggleControl(source, "next_weapon", true)
			toggleControl(source, "previous_weapon", true)
		end	
		
		setData(source, "d:license", tonumber(drivinglicense), true)
		setData(source, "hoursplayed", tonumber(hoursplayed), true)
		
		setData(source, "bank:showing", 0, true)
		
		spawnPlayer(source, x, y, z, rot)
		setElementModel(source, tonumber(skin))
		setElementInterior(source, tonumber(interior))
		setElementDimension(source, tonumber(dimension))
		setElementAlpha(source, 255)
	
		setElementHealth( source, tonumber(health))
		setPedArmor(source, tonumber(armor))
		setPedFightingStyle(source, tonumber(fightstyle))
		setPlayerMoney(source, tonumber(money))
	
		clearChatBox(source)
		
		setCameraTarget(source, source)
		exports['[ars]global']:updateNametagColor(source)
		
		-- Faction
		setData( source, "faction", tonumber(faction), true)
		setData( source, "f:rank", tonumber(rank), true)
		
		setPlayerTeam( source, nil )
		
		if tonumber(faction) > 0 and tonumber(rank) > 0 then
			local factions = getElementsByType("team")
			local found = false
			for i, team in ipairs ( factions ) do
				if isElement(team) then
					if tonumber(getData(team, "id")) == tonumber(faction) then
						
						setPlayerTeam(source, team)
						found = true
						break
					end
				end
			end	
		
			if not (found) then
				local update = sql:query("UPDATE characters SET faction='-1', rank='-1' WHERE id=".. sql:escape_string(dbid) .."")
				sql:free_result(update)
			end
		end
		
		-- Weapons
		takeAllWeapons(source)
		
		if (tostring(weapons) ~= "") and (tostring(ammo) ~= "") then 
			local tweapons = split(weapons, string.byte(",")) 
			local tammo = split(ammo, string.byte(",")) 
			
			for i = 1, #tweapons do
				giveWeapon(source, tweapons[i], tammo[i])
			end	
		end
		
		local result = sql:query_fetch_assoc("SELECT motd, amotd FROM settings")
		local motd = result['motd']
		local amotd = result['amotd']
		
		outputChatBox("MOTD: ".. motd, source, 244, 219, 11)
		if tonumber(getData(source, "admin")) > 0 then
			outputChatBox("Admin MOTD: ".. amotd, source, 89, 189, 59)
		end	
		
		-- Admin Jail
		local result = sql:query_fetch_assoc("SELECT jail_time, jail_reason, jail_by FROM accounts WHERE id=".. sql:escape_string(tonumber(getData(source, "accountid"))) .."")
		if ( result ) then
			local jailtime = tonumber( result['jail_time'] )
			local jailby = tostring( result['jail_by'] )
			local jailreason = tostring( result['jail_reason'] )
			
			if ( jailtime > 0 ) then
				triggerEvent("remoteJail", source, jailtime, jailby, jailreason)
			end
		end	
		
		-- Police Jail
		local result = sql:query_fetch_assoc("SELECT arrest_time, arrest_reason, arrest_by FROM characters WHERE id=".. sql:escape_string(tonumber(getData(source, "dbid"))) .."")
		if ( result ) then
		
			local arresttime = tonumber( result['arrest_time'] )
			local arrestby = tostring( result['arrest_by'] )
			local arrestreason = tostring( result['arrest_reason'] )
			
			if (arresttime > 0) then
				triggerEvent("remoteArrest", source, arresttime, arrestby, arrestreason)
			end
		end	
		
		-- Client Side Data Sending
		triggerEvent("sendRanksAndWages", source) -- FACTIONS
		triggerEvent("sendFactionNames", source)  
		
		triggerEvent("callInventoryData", source) -- INVENTORY
		triggerClientEvent(source, "renderInteriorDetails", source)
		
		-- Gun Stats
		
		setWeaponProperty(23, "pro", "maximum_clip_ammo", 2)
		setWeaponProperty(31, "pro", "maximum_clip_ammo", 30)
		setPedStat(source, 70, 999)
		setPedStat(source, 71, 999)
		setPedStat(source, 72, 999)
		setPedStat(source, 74, 999)
		setPedStat(source, 76, 999)
		setPedStat(source, 77, 999)
		setPedStat(source, 78, 999)
		setPedStat(source, 79, 999)

		-- Hud
		showPlayerHudComponent(source, "ammo", true)
		showPlayerHudComponent(source, "area_name", true)
		showPlayerHudComponent(source, "armour", true)
		showPlayerHudComponent(source, "breath", true)
		showPlayerHudComponent(source, "clock", true)
		showPlayerHudComponent(source, "health", true)
		showPlayerHudComponent(source, "radar", true)
		showPlayerHudComponent(source, "weapon", true)
		
		local callClient = triggerClientEvent
		callClient(source, "toggleMoney", source, true)
	
		showChat(source, true)
		
		-- We came! :)
		local update = sql:query("UPDATE characters SET lastlogin=NOW() WHERE charactername='".. sql:escape_string(tostring(name)) .."'")
		sql:free_result(update)
		
		if isKeyBound(source, "end", "down", changeAccount) then
			unbindKey(source, "end", "down", changeAccount)
		end
		
		bindKey(source, "end", "down", changeCharacter)
		
		triggerEvent("getInventoryItems", source)
		triggerEvent("sendPlayerBankAccounts", source)
	else
		outputDebugString("Unable to Spawn Character!")
	end	
end
addEvent("spawnCharacter", true)
addEventHandler("spawnCharacter", getRootElement(), spawnCharacter)

function clearChatBox( thePlayer )
	outputChatBox(" ", thePlayer)
	outputChatBox(" ", thePlayer)
	outputChatBox(" ", thePlayer)
	outputChatBox(" ", thePlayer)
	outputChatBox(" ", thePlayer)
	outputChatBox(" ", thePlayer)
	outputChatBox(" ", thePlayer)
	outputChatBox(" ", thePlayer)
	outputChatBox(" ", thePlayer)
	outputChatBox(" ", thePlayer)
	outputChatBox(" ", thePlayer)
	outputChatBox(" ", thePlayer)
	outputChatBox(" ", thePlayer)
	outputChatBox(" ", thePlayer)
	outputChatBox(" ", thePlayer)
end	
addCommandHandler("clearchat", clearChatBox)

--------- [ Character Creation ] ---------
function createCharacter( name, gender, ethnicity, skin, height, weight, age, description ) 
	
	local accountid = tonumber(getData(source, "accountid"))
	
	local name = tostring(name)
	local gender = tonumber(gender)
	local ethnicity = tonumber(ethnicity)
	local skin = tonumber(skin)
	local height = tonumber(height)
	local weight = tonumber(weight)
	local age = tonumber(age)
	local description = tostring(description)
	
	local result = sql:query_fetch_assoc("SELECT charactername FROM characters WHERE charactername='".. sql:escape_string(name) .."'")
	if not (result) then
		
		local insert = sql:query("INSERT INTO characters SET account=".. sql:escape_string(accountid) ..", charactername='".. sql:escape_string(name) .."', skin=".. sql:escape_string(skin) ..", weapons='', ammo='', lastarea='Unity Station', age=".. sql:escape_string(age) ..", gender=".. sql:escape_string(gender) ..", ethnicity=".. sql:escape_string(ethnicity) ..", height=".. sql:escape_string(height) ..", weight=".. sql:escape_string(weight) ..", description='".. sql:escape_string(description) .."', items='6', itemvalues='".. sql:escape_string(tostring(skin)) .."'")
		if (insert) then
			
			triggerClientEvent(source, "endCharacterCreation", source)
		else
			outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
		end	
		
		sql:free_result(insert)
	else
		triggerClientEvent(source, "showCreationError", source, "Choosen character name already exists.")
	end	
end
addEvent("createCharacter", true)
addEventHandler("createCharacter", getRootElement(), createCharacter) 

--------- [ Change Character ] ---------
function changeCharacter( thePlayer )
	if ( getData( thePlayer, "bank:showing" ) == 0 ) then
	
		triggerEvent("savePlayer", thePlayer, "Change Character")
		
		local username = getData(thePlayer, "accountname")
		local id = getData(thePlayer, "accountid")
		local admin = getData(thePlayer, "admin")
		local adminduty = getData(thePlayer, "adminduty")
		local hiddenadmin = getData(thePlayer, "hiddenadmin")
		local reports = getData(thePlayer, "adminreports")
		local donator = getData(thePlayer, "donator")
		local togglepm = getData(thePlayer, "togglepm")
		local tutorial = getData(thePlayer, "tutorial")
		local friends = getData(thePlayer, "friends")
		local skinmods = getData(thePlayer, "skinmods")
		local weaponmods = getData(thePlayer, "weaponmods")
		local vehiclemods = getData(thePlayer, "vehiclemods")
		
		triggerEvent("loginPlayer", thePlayer, username, id, admin, adminduty, hiddenadmin, reports, donator, togglepm, tutorial, friends, skinmods, weaponmods, vehiclemods, false)
		
		setData(thePlayer, "loggedin", 0, true)
		
		exports['[ars]global']:updateNametagColor(thePlayer)
		setPlayerNametagShowing(thePlayer, false )
		
		showPlayerHudComponent(thePlayer, "ammo", false)
		showPlayerHudComponent(thePlayer, "area_name", false)
		showPlayerHudComponent(thePlayer, "armour", false)
		showPlayerHudComponent(thePlayer, "breath", false)
		showPlayerHudComponent(thePlayer, "clock", false)
		showPlayerHudComponent(thePlayer, "health", false)
		showPlayerHudComponent(thePlayer, "radar", false)
		showPlayerHudComponent(thePlayer, "weapon", false)
		
		local callClient = triggerClientEvent
		callClient(thePlayer, "toggleMoney", thePlayer, false)
			
		showChat(thePlayer, false)
		
		if isKeyBound(thePlayer, "end", "down", changeCharacter) then
			unbindKey(thePlayer, "end", "down", changeCharacter)
		end	
		
		bindKey(thePlayer, "end", "down", changeAccount)
	else
		outputChatBox("You cannot switch characters while your bank window is open.", thePlayer, 255, 0, 0)
	end	
end

function changeAccount( thePlayer )
	
	triggerClientEvent( thePlayer, "clearCharacterScreen", thePlayer )
	
	triggerClientEvent( thePlayer, "cleanUpLogin", thePlayer )
	triggerClientEvent( thePlayer, "displayLogin", thePlayer, 1 )
end
	
addEventHandler("onResourceStart", root,
	function( )
		for key, value in ipairs ( getElementsByType("player") ) do
			if ( getData( value, "loggedin") == 1 ) then
				
				bindKey(value, "end", "down", changeCharacter)
			elseif ( getData( value, "loggedin") == 0 ) then
				
				if ( getData( value, "username" ) ~= false ) then
					
					bindKey(value, "end", "down", changeAccount)
				end	
			end
		end	
	end
)
	
-- /look
function lookAtPlayer( thePlayer, commandName, partialPlayerName )
	if (partialPlayerName) then
		
		local players = exports['[ars]global']:findPlayer( thePlayer, partialPlayerName )
			
		if #players == 0 then
			outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
		elseif #players > 1 then
			outputChatBox("Multple Players found!", thePlayer, 255, 200, 0)
			
			local count = 0
			for k, foundPlayer in ipairs (players) do
				
				count = count + 1
				outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
			end		
		else
			for k, foundPlayer in ipairs (players) do
				
				local age, weight, height, description = getPlayerAppearance( foundPlayer )
				
				local len = string.len( description )
				if ( len >= 95 ) then
					description = string.sub(description, 1, 95)
				end
				
				outputChatBox("~-~-~-~-~~-~-~-~-~ ".. getPlayerName( foundPlayer ):gsub("_", " ") .." ~-~-~-~-~~-~-~-~-~", thePlayer, 212, 156, 49)
				outputChatBox("Age: ".. tostring( age ) .." years", thePlayer, 212, 156, 49)
				outputChatBox("Weight: ".. tostring( weight ) .." kg", thePlayer, 212, 156, 49)
				outputChatBox("Height: ".. tostring( height ) .." cm", thePlayer, 212, 156, 49)
				outputChatBox("Description: ".. tostring( description ), thePlayer, 212, 156, 49)
			end	
		end		
	else
		outputChatBox("SYNTAX: /".. commandName .." [ Player Name/ID ]", thePlayer, 212, 156, 49)
	end	
end
addCommandHandler("look", lookAtPlayer, false, false)

function getPlayerAppearance( thePlayer )
	local result = sql:query_fetch_assoc("SELECT `age`, `weight`, `height`, `description` FROM `characters` WHERE `id`=".. sql:escape_string( tonumber( getData( thePlayer, "dbid" ) ) ) .."")
	if ( result ) then
		
		local age = tonumber( result['age'] )
		local weight = tonumber( result['weight'] )
		local height = tonumber( result['height'] )
		local description = tostring( result['description'] )
		
		return age, weight, height, description
	end	
end

-- Ehm.. no /nick
addEventHandler("onPlayerChangeNick", root,
	function( )
		cancelEvent( )
	end
)	