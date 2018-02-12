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

--------- [ Faction Commands ] ---------
local lsvsColSphere = createColSphere( -2086.7333, -233.7988, 1028.6002, 2 )
setElementInterior( lsvsColSphere, 3 )
setElementDimension( lsvsColSphere, 61 )

local lspdColSphere = createColSphere( 273.1933, 118.2851, 1004.6171, 2 )
setElementInterior( lspdColSphere, 10 )
setElementDimension( lspdColSphere, 311 )

--[[
local detectiveColSphere = createColSphere( 273.1933, 118.2851, 1004.6171, 2 )
setElementInterior( detectiveColSphere, 10 )
setElementDimension( detectiveColSphere, 311 )
]]--

local lsfdColSphere = createColSphere( -94.1298, 1181.3125, 19.7499, 4 )
setElementInterior( lsfdColSphere, 0 )
setElementDimension( lsfdColSphere, 0 )

-- /duty
function factionDuty( thePlayer, commandName )
	if getData(thePlayer, "loggedin") == 1 then
		
		local faction = tonumber( getData(thePlayer, "faction") )
		if ( faction == 1 ) or ( faction == 2 ) then -- LSPD/LSFD
		
			if ( ( getElementDimension( thePlayer ) == 311 or getElementDimension( thePlayer ) == 0 ) and ( isElementWithinColShape( thePlayer, lspdColSphere ) or isElementWithinColShape( thePlayer, lsfdColSphere ) ) ) then		
			
				if ( getData(thePlayer, "duty") == 0 ) then
					triggerClientEvent(thePlayer, "showUniformUI", thePlayer, faction)
				else
					local result = sql:query_fetch_assoc("SELECT `dutyskin`, `dutyweps`, `dutyammo` FROM `characters` WHERE `charactername`='".. sql:escape_string(getPlayerName(thePlayer):gsub("_", " ")) .."'")
					if ( result ) then
						
						local dutySkin = tonumber( result['dutyskin'] )
						local dutyWeps = tostring( result['dutyweps'] )
						local dutyAmmo = tostring( result['dutyammo'] )
						
						-- Skin
						setElementModel(thePlayer, dutySkin)
						
						-- Armor
						setPedArmor (thePlayer, 0) 
						
						-- Weapons
						takeAllWeapons(thePlayer)
						
						if (faction == 2) then
							exports['[ars]inventory-system']:takeItem(thePlayer, 48)
						end
						
						if (tostring(dutyWeps) ~= "") and (tostring(dutyAmmo) ~= "") then 
							local tweapons = split(dutyWeps, string.byte(",")) 
							local tammo = split(dutyAmmo, string.byte(",")) 
							
							for i = 1, #tweapons do
								giveWeapon(thePlayer, tweapons[i], tammo[i])
							end	
						end
						
						setData(thePlayer, "duty", 0, true)
						updateDatabase("UPDATE `characters` SET `duty`='0' WHERE `charactername`='".. sql:escape_string(getPlayerName(thePlayer):gsub("_", " ")) .."'")
						
						outputChatBox("You are now off duty.", thePlayer, 212, 156, 49)
					end	
				end
			end
		elseif ( faction == 4 ) then -- LSVS
			
			if ( getElementDimension( thePlayer ) == 61 and isElementWithinColShape( thePlayer, lsvsColSphere ) ) then		
				
				if ( getData(thePlayer, "duty") == 0 ) then
				
					local dutySkin = getElementModel(thePlayer)
		
					local dutyWeps = ""
					local dutyAmmo = ""
					for i = 1, 12 do
						dutyWeps = dutyWeps ..",".. getPedWeapon(thePlayer, i)
						dutyAmmo = dutyAmmo ..",".. getPedTotalAmmo(thePlayer, i)
					end	
					
					local update = sql:query("UPDATE `characters` SET `dutyskin`=".. sql:escape_string(dutySkin) ..", `dutyweps`='".. sql:escape_string(dutyWeps) .."', `dutyammo`='".. sql:escape_string(dutyAmmo) .."' WHERE `charactername`='".. sql:escape_string(getPlayerName(thePlayer):gsub("_", " ")) .."'")
					if ( update ) then
						
						takeAllWeapons( thePlayer )
						setElementModel(thePlayer, 50)
						
						setData(thePlayer, "duty", 1, true)
						updateDatabase("UPDATE `characters` SET `duty`='1' WHERE `charactername`='".. sql:escape_string(getPlayerName(thePlayer):gsub("_", " ")) .."'")
						
						outputChatBox("You are now on duty.", thePlayer, 212, 156, 49)
					end
					
					sql:free_result(update)
				else
					local result = sql:query_fetch_assoc("SELECT `dutyskin`, `dutyweps`, `dutyammo` FROM `characters` WHERE `charactername`='".. sql:escape_string(getPlayerName(thePlayer):gsub("_", " ")) .."'")
					if ( result ) then
						
						local dutySkin = tonumber( result['dutyskin'] )
						local dutyWeps = tostring( result['dutyweps'] )
						local dutyAmmo = tostring( result['dutyammo'] )
						
						-- Skin
						setElementModel(thePlayer, dutySkin)
						
						-- Weapons
						takeAllWeapons(thePlayer)
						
						if (tostring(dutyWeps) ~= "") and (tostring(dutyAmmo) ~= "") then 
							local tweapons = split(dutyWeps, string.byte(",")) 
							local tammo = split(dutyAmmo, string.byte(",")) 
							
							for i = 1, #tweapons do
								giveWeapon(thePlayer, tweapons[i], tammo[i])
							end	
						end
						
						setData(thePlayer, "duty", 0, true)
						updateDatabase("UPDATE `characters` SET `duty`='0' WHERE `charactername`='".. sql:escape_string(getPlayerName(thePlayer):gsub("_", " ")) .."'")
						
						outputChatBox("You are now off duty.", thePlayer, 212, 156, 49)
					end
				end
			end
		end
	end	
end
addCommandHandler("duty", factionDuty, false, false)

-- /detective
function detectiveDuty( thePlayer, commandName )
	if getData(thePlayer, "loggedin") == 1 then
		
		local faction = tonumber( getData(thePlayer, "faction") )
		if ( faction == 1 ) then
		
			if ( getElementDimension( thePlayer ) == 311 ) and ( isElementWithinColShape( thePlayer, lspdColSphere ) ) then
			
				if ( getData(thePlayer, "duty") == 0 ) then
					triggerClientEvent(thePlayer, "showDetectiveUI", thePlayer, faction)
				else
					local result = sql:query_fetch_assoc("SELECT `dutyskin`, `dutyweps`, `dutyammo` FROM `characters` WHERE `charactername`='".. sql:escape_string(getPlayerName(thePlayer):gsub("_", " ")) .."'")
					if ( result ) then
						
						local dutySkin = tonumber( result['dutyskin'] )
						local dutyWeps = tostring( result['dutyweps'] )
						local dutyAmmo = tostring( result['dutyammo'] )
						
						-- Skin
						setElementModel(thePlayer, dutySkin)
						
						-- Armor
						setPedArmor (thePlayer, 0) 
						
						-- Weapons
						takeAllWeapons(thePlayer)
						
						if (tostring(dutyWeps) ~= "") and (tostring(dutyAmmo) ~= "") then 
							local tweapons = split(dutyWeps, string.byte(",")) 
							local tammo = split(dutyAmmo, string.byte(",")) 
							
							for i = 1, #tweapons do
								giveWeapon(thePlayer, tweapons[i], tammo[i])
							end	
						end
						
						setData(thePlayer, "duty", 0, true)
						updateDatabase("UPDATE `characters` SET `duty`='0' WHERE `charactername`='".. sql:escape_string(getPlayerName(thePlayer):gsub("_", " ")) .."'")
						
						outputChatBox("You are now off duty.", thePlayer, 212, 156, 49)
					end	
				end
			end
		end
	end
end
addCommandHandler("dduty", detectiveDuty, false, false)

function setFactionDuty( faction, skin ) 
	local weapons = nil
	
	if ( faction == 1 ) then -- LSPD
	
		if ( skin == 282 or skin == 283 or skin == 288 or skin == 211 or skin == 284 ) then
			weapons = { [3] = 1, [24] = 49, [25] = 50, [29] = 90, [41] = 1000 }
			items = { }
		else
			weapons = { [3] = 1, [24] = 49, [27] = 49, [29] = 150, [41] = 1000, [31] = 150 }
			items = { }
		end	
	elseif ( faction == 2 ) then -- LSFD
		
		if ( skin == 277 or skin == 278 or skin == 279 ) then
			weapons = { [9] = 1, [42] = 9000 }
			items = { [48] = 1 }
		else
			weapons = { [41] = 1000 }
			items = { }
		end		
		
	end
	
	local dutySkin = getElementModel(source)
	
	local dutyWeps = ""
	local dutyAmmo = ""
	for i = 1, 12 do
		dutyWeps = dutyWeps ..",".. getPedWeapon(source, i)
		dutyAmmo = dutyAmmo ..",".. getPedTotalAmmo(source, i)
	end	
	
	local update = sql:query("UPDATE `characters` SET `dutyskin`=".. sql:escape_string(dutySkin) ..", `dutyweps`='".. sql:escape_string(dutyWeps) .."', `dutyammo`='".. sql:escape_string(dutyAmmo) .."' WHERE `charactername`='".. sql:escape_string(getPlayerName(source):gsub("_", " ")) .."'")
	if ( update ) then
		
		takeAllWeapons( source )
		
		if ( faction == 1 ) then -- LSPD
		
			setPedArmor (source, 100)
		
		end
		
		for i, v in pairs ( weapons ) do
			giveWeapon(source, i, v)
		end
		
		for i, v in pairs ( items ) do
			exports['[ars]inventory-system']:giveItem(source, i, v)
		end
		
		setElementModel(source, skin)
		
		setData(source, "duty", 1, true)
		updateDatabase("UPDATE `characters` SET `duty`='1' WHERE `charactername`='".. sql:escape_string(getPlayerName(source):gsub("_", " ")) .."'")
		
		outputChatBox("You are now on duty.", source, 212, 156, 49)
	else
		outputDebugString("Unable to update duty skin.")
	end	
	
	sql:free_result(update)
end
addEvent("setFactionDuty", true)
addEventHandler("setFactionDuty", root, setFactionDuty)

function setDetectiveDuty( faction, skin ) 
	local weapons = nil
	weapons = { [24] = 50, [25] = 50, [43] = 100}

	
	local dutySkin = getElementModel(source)
	
	local dutyWeps = ""
	local dutyAmmo = ""
	for i = 1, 12 do
		dutyWeps = dutyWeps ..",".. getPedWeapon(source, i)
		dutyAmmo = dutyAmmo ..",".. getPedTotalAmmo(source, i)
	end	
	
	local update = sql:query("UPDATE `characters` SET `dutyskin`=".. sql:escape_string(dutySkin) ..", `dutyweps`='".. sql:escape_string(dutyWeps) .."', `dutyammo`='".. sql:escape_string(dutyAmmo) .."' WHERE `charactername`='".. sql:escape_string(getPlayerName(source):gsub("_", " ")) .."'")
	if ( update ) then
		
		takeAllWeapons( source )
		
		setPedArmor (source, 100) 
		
		for i, v in pairs ( weapons ) do
			giveWeapon(source, i, v)
		end
		
		setElementModel(source, skin)
		
		setData(source, "duty", 1, true)
		updateDatabase("UPDATE `characters` SET `duty`='1' WHERE `charactername`='".. sql:escape_string(getPlayerName(source):gsub("_", " ")) .."'")
		
		outputChatBox("You are now on duty.", source, 212, 156, 49)
	else
		outputDebugString("Unable to update duty skin.")
	end	
	
	sql:free_result(update)
end
addEvent("setDetectiveDuty", true)
addEventHandler("setDetectiveDuty", root, setDetectiveDuty)

-- /doorram
function doorRam( thePlayer, commandName )
	if getData(thePlayer, "loggedin") == 1 then
		
		local faction = tonumber( getData( thePlayer, "faction" ) )
		if ( faction == 2 ) then
			
			for key, door in ipairs ( getElementsByType("marker") )  do
				
				if ( getElementDimension( door ) == getElementDimension( thePlayer ) ) then
					
					if ( isElementWithinMarker( thePlayer, door ) ) then	
					
						local child = getElementChild(door, 0)	
						if ( child ) then								
							
							local type = tonumber( getData( door, "type" ) )
							local owner = tonumber( getData( door, "owner" ) )
						
							if ( type == 1 and owner == -1 ) then -- Unowned house
							
								outputChatBox("You cannot ram this door.", thePlayer, 255, 0, 0)
							else	
								
								local locked = tonumber( getData( door, "locked" ) )
								if ( locked == 1 ) then
									
									local chance = math.random(0, 2)
									if ( chance == 1 ) then
										
										local dbid = tonumber( getData(door, "dbid") )
									
										local update = sql:query("UPDATE `interiors` SET `locked`='0' WHERE `id`=".. sql:escape_string(dbid) .."")
										if (update) then
											
											setData(door, "locked", 0)
											triggerEvent("doAction", thePlayer, thePlayer, "do", "The door bursts open!")
											
											break
										end
										
										sql:free_result(update)
									else
										triggerEvent("doAction", thePlayer, thePlayer, "do", "The ram hits the door!")
									end	
								else
									outputChatBox("The door is already open.", thePlayer, 0, 255, 0)
								end	
							end
						else
							outputChatBox("You cannot apply a door ram from inside.", thePlayer, 255, 0, 0)
							break	
						end
					end
				end
			end
		end
	end	
end
addCommandHandler("doorram", doorRam, false, false)

------------ /// LSPD \\\ ------------
function togglePlayerDetain( thePlayer, commandName, partialPlayerName )
	if getData(thePlayer, "loggedin") == 1 then
		
		local faction = tonumber( getData( thePlayer, "faction" ) )
		if ( faction == 1 ) then
			
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
						
						local x, y, z = getElementPosition(thePlayer)
						local px, py, pz = getElementPosition(foundPlayer)
						
						if ( getDistanceBetweenPoints3D( x, y, z, px, py, pz ) <= 5 ) then
							
							local query = nil
							
							if ( commandName == "cuff" ) then
							
								setData(foundPlayer, "cuffed", 1, true)
							
								toggleControl(foundPlayer, "sprint", false)
								toggleControl(foundPlayer, "jump", false)
								toggleControl(foundPlayer, "aim_weapon", false)
								toggleControl(foundPlayer, "fire", false)
								toggleControl(foundPlayer, "next_weapon", false)
								toggleControl(foundPlayer, "previous_weapon", false)
								
								outputChatBox("You cuffed ".. getPlayerName(foundPlayer):gsub("_", " ") ..".", thePlayer, 212, 156, 49) 
								outputChatBox("You have been cuffed by ".. getPlayerName(thePlayer):gsub("_", " ") ..".", foundPlayer, 212, 156, 49)
								
								query = "UPDATE `characters` SET `cuffed`='1' WHERE charactername='".. getPlayerName(foundPlayer):gsub("_", " ") .."'"
								
							elseif ( commandName == "uncuff" ) then
								
								setData(foundPlayer, "cuffed", 0, true)
							
								toggleControl(foundPlayer, "sprint", true)
								toggleControl(foundPlayer, "jump", true)
								toggleControl(foundPlayer, "aim_weapon", true)
								toggleControl(foundPlayer, "fire", true)
								toggleControl(foundPlayer, "next_weapon", true)
								toggleControl(foundPlayer, "previous_weapon", true)
								
								outputChatBox("You un-cuffed ".. getPlayerName(foundPlayer):gsub("_", " ") ..".", thePlayer, 212, 156, 49) 
								outputChatBox("You have been un-cuffed by ".. getPlayerName(thePlayer):gsub("_", " ") ..".", foundPlayer, 212, 156, 49)
								
								query = "UPDATE `characters` SET `cuffed`='0' WHERE charactername='".. getPlayerName(foundPlayer):gsub("_", " ") .."'"
							end	
							
							local update = sql:query(query)
							if ( not update ) then
								outputDebugString("Unable to update player cuffs.")
							end	
							
							sql:free_result(update)
						else
							outputChatBox("You need to be closer to the player.", thePlayer, 255, 0, 0)
						end
					end
				end
			else
				outputChatBox("SYNTAX: /".. commandName .." [ Player Name / ID ]", thePlayer, 212, 156, 49)
			end
		end					
	end		
end
addCommandHandler("cuff", togglePlayerDetain, false, false)
addCommandHandler("uncuff", togglePlayerDetain, false, false)

-- /ticket
function ticketPlayer( thePlayer, commandName, partialPlayerName, ticketPrice, ... )
	if getData(thePlayer, "loggedin") == 1 then
		
		local faction = tonumber( getData( thePlayer, "faction" ) )
		if ( faction == 1 ) and ( getData(thePlayer, "duty") == 1 ) then
			
			if (ticketPrice) and (partialPlayerName) and (...) then
			
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
						
						if ( foundPlayer ~= thePlayer ) then
							
							local x, y, z = getElementPosition(thePlayer)
							local px, py, pz = getElementPosition(foundPlayer)
							
							if ( getDistanceBetweenPoints3D( x, y, z, px, py, pz ) <= 5 ) then
								
								local ticketPrice = tonumber( ticketPrice )
								local reason = table.concat({...}, " ")
								
								local money = getPlayerMoney(foundPlayer)/100
								if ( money >= ticketPrice ) then
									
									takePlayerMoney(foundPlayer, ticketPrice*100)
									giveMoneyToPolice( ticketPrice )
									
									outputChatBox("You were ticketed for $".. tostring( ticketPrice ) .." by ".. getPlayerName(thePlayer):gsub("_", " ") ..".", foundPlayer, 212, 156, 49)
									outputChatBox("Reason: ".. reason, foundPlayer, 212, 156, 49)
									
									outputChatBox("You ticketed ".. getPlayerName(foundPlayer):gsub("_", " ") .." for $".. tostring( ticketPrice ) ..".", thePlayer, 212, 156, 49)
									outputChatBox("Reason: ".. reason, thePlayer, 212, 156, 49)
								else
									outputChatBox("The player doesn't have enough money, try giving a lower ticket or escort him to the bank.", thePlayer, 255, 0, 0)
								end
							else
								outputChatBox("You are too far away from ".. getPlayerName(foundPlayer):gsub(" ", "_") ..".", thePlayer, 255, 0, 0)
							end
						else
							outputChatBox("You cannot ticket yourself.", thePlayer, 255, 0, 0)
						end
					end
				end
			else
				outputChatBox("SYNTAX: /".. commandName .." [Player Name / ID] [Ticket Price] [Reason]", thePlayer, 212, 156, 49)
			end
		end	
	end							
end
addCommandHandler("ticket", ticketPlayer, false, false)

local positions = { }
positions[1] = { 215.5927, 114.7119, 999.0156 }
positions[2] = { 219.5927, 114.7119, 999.0156 }
positions[3] = { 223.5927, 114.7119, 999.0156 }
positions[4] = { 227.5927, 114.7119, 999.0156 }

local cells = { } 
for key, value in ipairs ( positions ) do
	cells[key] = createColSphere( value[1], value[2], value[3], 1.5 )
	
	setElementInterior(cells[key], 10)
	setElementDimension(cells[key], 311)
end

local arrests = { }

-- /arrest
function policeArrest( thePlayer, commandName, partialPlayerName, minutes, finePrice, ... )
	if getData(thePlayer, "loggedin") == 1 then
		
		local faction = tonumber( getData( thePlayer, "faction" ) )
		if ( faction == 1 ) then
			
			if (partialPlayerName) and (minutes) and (finePrice) and (...) then
				
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
						
						if ( foundPlayer ~= thePlayer ) then
							
							local x, y, z = getElementPosition(thePlayer)
							local px, py, pz = getElementPosition(foundPlayer)
							
							if ( getDistanceBetweenPoints3D( x, y, z, px, py, pz ) <= 5 ) then 
								
								local nearestColSphere = nil
								for key, value in ipairs ( cells ) do
									
									local cx, cy, cz = getElementPosition(value)
									if ( getDistanceBetweenPoints3D( x, y, z, cx, cy, cz ) <= 1 ) then
										
										nearestColSphere = value
										break
									end
								end
								
								if ( nearestColSphere ~= nil ) then
									
									if ( getElementDimension( thePlayer ) == getElementDimension( nearestColSphere ) and getElementDimension( foundPlayer ) == getElementDimension( nearestColSphere ) ) then
										if ( isElementWithinColShape( thePlayer, nearestColSphere ) and isElementWithinColShape( thePlayer, nearestColSphere ) ) then
											
											local cx, cy, cz = getElementPosition(nearestColSphere)
											
											local reason = table.concat({...}, " ")
											local finePrice = tonumber(finePrice)
											
											arrests[foundPlayer] = { }
											arrests[foundPlayer]["arrestTimer"] = setTimer(updateArrestTimer, 60000, 1, foundPlayer)
											arrests[foundPlayer]["arrestTime"] = tonumber(minutes)
											arrests[foundPlayer]["arrestBy"] = tostring(getPlayerName(thePlayer))
											arrests[foundPlayer]["arrestReason"] = tostring(reason)
											
											setElementPosition( foundPlayer, cx - 3.5, cy, cz )
											
											outputChatBox("You arrested ".. getPlayerName(foundPlayer):gsub("_", " ") ..". [ ".. minutes .. " minute(s) ]", thePlayer, 70, 54, 224)
											outputChatBox("Crime(s): ".. reason, thePlayer, 70, 54, 224)
											
											outputChatBox("You were arrested by ".. getPlayerName(thePlayer):gsub("_", " ") ..". [ ".. minutes .. " minute(s) ]", foundPlayer, 70, 54, 224)
											outputChatBox("Crime(s): ".. reason, foundPlayer, 70, 54, 224)
											
											if ( finePrice > 0 ) then
												
												local money = tonumber( getPlayerMoney( foundPlayer )/100 )
												if ( money >= finePrice ) then
													
													takePlayerMoney( foundPlayer, finePrice*100 )
													giveMoneyToPolice( finePrice )
													
													outputChatBox("Fine: $".. tostring( finePrice ), thePlayer, 70, 54, 224)
													outputChatBox("Fine: $".. tostring( finePrice ), foundPlayer, 70, 54, 224)
												else
													outputChatBox("The player did not have enough money to pay the fine.", thePlayer, 255, 0, 0)
												end	
											end
											
											takeAllWeapons( foundPlayer )
											
											local count = takeAllNarcotics( foundPlayer )
											if ( count > 0 ) then
												outputChatBox("Took away ".. count .." narcotic(s) from ".. getPlayerName( foundPlayer ):gsub("_", " ") ..".", thePlayer, 212, 156, 49)
											end
											
											updateDatabase("UPDATE `characters` SET `arrest_time`=".. sql:escape_string(minutes) ..", `arrest_reason`='".. sql:escape_string(tostring(reason)) .."', `arrest_by`='".. sql:escape_string(tostring(getPlayerName(thePlayer))) .."' WHERE `id`=" .. sql:escape_string(getData(foundPlayer, "dbid")) .."")
										else
											outputChatBox("You and the suspect must be infront of the cell.", thePlayer, 255, 0, 0)
										end
									end
								else
									outputChatBox("You need to be infornt of the cell.", thePlayer, 255, 0, 0)
								end	
							else
								outputChatBox("You are too far away from the suspect.", thePlayer, 255, 0, 0)
							end
						else
							outputChatBox("You cannot jail yourself.", thePlayer, 255, 0, 0)
						end	
					end
				end
			else
				outputChatBox("SYNTAX: /".. commandName .." [Player Name / ID] [Minutes] [Fine] [Reason]", thePlayer, 212, 156, 49)
			end
		end
	end
end
addCommandHandler("arrest", policeArrest, false, false)		

local narcotics = { [36] = true, [37] = true, [38] = true, [39] = true, [40] = true, [41] = true }

function takeAllNarcotics( thePlayer )
	local items, values = exports['[ars]inventory-system']:getPlayerInventory( thePlayer )
	
	local count = 0
	if (#items > 0) then
		for key, value in pairs ( items ) do
			if ( narcotics[ tonumber( value ) ] ) then
				
				exports['[ars]inventory-system']:takeItem( thePlayer, value )
				
				count = count + 1
			end
		end
	end
	
	return count
end

-- /release
function releasePlayer( thePlayer, commandName, partialPlayerName )
	if ( getData(thePlayer, "loggedin") == 1 ) then
		if ( getData( thePlayer, "faction" ) == 1 ) or ( getData( thePlayer, "adminduty" ) == 1 ) then
			
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
						
						if ( arrests[foundPlayer] ) then
							
							local timer = arrests[foundPlayer]["arrestTimer"]
							if ( isTimer( timer ) ) then
								killTimer( timer )
							end
							
							arrests[foundPlayer] = nil
			
							setElementPosition(foundPlayer, -214.1445, 978.2744, 19.3339)
							setElementRotation(foundPlayer, 0, 0, 270)
							setElementDimension(foundPlayer, 0)
							setElementInterior(foundPlayer, 0)
							
							outputChatBox("You released ".. getPlayerName(foundPlayer):gsub("_", " ") ..".", thePlayer, 0, 255, 0)
							outputChatBox("You have been released by ".. getPlayerName(thePlayer):gsub("_", " ") ..".", foundPlayer, 0, 255, 0)
			
							updateDatabase("UPDATE `characters` SET `arrest_time`='0', `arrest_reason`=NULL, `arrest_by`=NULL WHERE `id`=" .. sql:escape_string(getData(foundPlayer, "dbid")) .."")	
						end
					end
				end
			else
				outputChatBox("SYNTAX: /".. commandName .." [Player Name / ID]", thePlayer, 212, 156, 49)
			end
		end
	end	
end
addCommandHandler("release", releasePlayer, false, false)

-- /arrested
function arrestedPlayers( thePlayer, commandName )
	if ( getData(thePlayer, "loggedin") == 1 ) then
		if ( getData( thePlayer, "faction" ) == 1 ) or ( getData( thePlayer, "adminduty" ) == 1 ) then
			
			outputChatBox("============== Arrested ==============", thePlayer, 212, 156, 49)
			
			local count = 0
			for arrestedPlayer, array in pairs ( arrests ) do
				
				if isElement( arrestedPlayer ) then
					outputChatBox("Name: ".. getPlayerName(arrestedPlayer):gsub("_", " ") ..".", thePlayer, 212, 156, 49)
					outputChatBox("Arrested By: ".. array["arrestBy"]:gsub("_", " ") ..".", thePlayer, 212, 156, 49)
					outputChatBox("Arrested For: ".. array["arrestReason"], thePlayer, 212, 156, 49)
					outputChatBox("Time Left: ".. array["arrestTime"] .. " minute(s).", thePlayer, 212, 156, 49)
					outputChatBox("~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=", thePlayer, 212, 156, 49)
					
					count = count + 1
				else
					array[arrestedPlayer] = nil
				end	
			end
			
			if ( count == 0 ) then
				outputChatBox("No one is arrested.", thePlayer, 212, 156, 49)
			end
		end
	end	
end
addCommandHandler("arrested", arrestedPlayers, false, false)

-- /arresttime
function arrestTime( thePlayer, commandName )
	if ( getData(thePlayer, "loggedin") == 1 ) then
		if ( arrests[thePlayer] ~= nil ) then
			
			outputChatBox("You have ".. arrests[thePlayer]["arrestTime"] .. " minute(s) left on your sentence.", thePlayer, 212, 156, 49)
		else
			outputChatBox("You are not jailed.", thePlayer, 255, 0, 0)
		end
	end	
end
addCommandHandler("arrestTime", arrestTime, false, false)

function remoteArrest( jailtime, jailby, jailreason )
	
	local jailtime = tonumber(jailtime)
	local jailby = tostring(jailby)
	local jailreason = tostring(jailreason)
	
	arrests[source] = { }
	arrests[source]["arrestTimer"] = setTimer(updateArrestTimer, 60000, 1, source)
	arrests[source]["arrestTime"] = jailtime
	arrests[source]["arrestBy"] = jailby
	arrests[source]["arrestReason"] = jailreason

	outputChatBox("You were arrested by ".. jailby:gsub("_", " ") ..". ( ".. jailtime .." minute(s) remaining )", source, 70, 54, 224)
	outputChatBox("Crime: ".. jailreason, source, 70, 54, 224)
end
addEvent("remoteArrest", true)
addEventHandler("remoteArrest", getRootElement(), remoteArrest)

function updateArrestTimer( thePlayer )
	if isElement( thePlayer ) then
		if ( arrests[thePlayer] ~= nil ) then -- He is arrested
			
			local timeLeft = tonumber( arrests[thePlayer]["arrestTime"] )
			if ( timeLeft == 1 ) then
			
				arrests[thePlayer] = nil
				
				setElementPosition(thePlayer, -214.1445, 978.2744, 19.3339)
				setElementRotation(thePlayer, 0, 0, 270)
				setElementDimension(thePlayer, 0)
				setElementInterior(thePlayer, 0)
				
				outputChatBox("You have served your jail sentence.", thePlayer, 0, 255, 0)
				
				updateDatabase("UPDATE `characters` SET `arrest_time`='0', `arrest_reason`=NULL, `arrest_by`=NULL WHERE `id`=" .. sql:escape_string(getData(thePlayer, "dbid")) .."")	
			else
				
				arrests[thePlayer]["arrestTime"] = timeLeft - 1
				arrests[thePlayer]["arrestTimer"] = setTimer(updateArrestTimer, 60000, 1, thePlayer)
				
				updateDatabase("UPDATE `characters` SET `arrest_time`=".. sql:escape_string(timeLeft - 1) .." WHERE `id`=" .. sql:escape_string(getData(thePlayer, "dbid")) .."")
			end
		else
			
			arrests[thePlayer] = nil
			
			setElementPosition(thePlayer, -214.1445, 978.2744, 19.3339)
			setElementRotation(thePlayer, 0, 0, 270)
			setElementDimension(thePlayer, 0)
			setElementInterior(thePlayer, 0)
			
			outputChatBox("You have served your jail sentence.", thePlayer, 0, 255, 0)
			
			updateDatabase("UPDATE `characters` SET `arrest_time`='0', `arrest_reason`=NULL, `arrest_by`=NULL WHERE `id`=" .. sql:escape_string(getData(thePlayer, "dbid")) .."")	
		end
	end	
end

addEventHandler("onPlayerQuit", root,
	function( )
		
		if ( arrests[source] ~= nil ) then
			
			local timer = arrests[source]["arrestTimer"]
			if ( isTimer( timer ) ) then
				killTimer( timer )
			end 
			
			arrests[source] = nil
		end	
	end
)
	
-- /showlicenses
function showPlayerLicenses( thePlayer, commandName, partialPlayerName )
	if ( getData(thePlayer, "loggedin") == 1 ) then
		
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
					
					local x, y, z = getElementPosition(thePlayer)
					local px, py, pz = getElementPosition(foundPlayer)
				
					if ( getDistanceBetweenPoints3D( x, y, z, px, py, pz ) <= 10 ) then 
						
						local license = tonumber( getData( thePlayer, "d:license" ) )
						
						local text = "#FF0000Unavailable"
						if ( license == 1 ) then
							text = "#00FF00Available"
						end
						
						outputChatBox("~-~-~-~-~-~ ".. getPlayerName( thePlayer ):gsub("_", " ") .." ~-~-~-~-~-~", foundPlayer, 212, 156, 49)
						outputChatBox("Driving License: ".. text, foundPlayer, 212, 156, 49, true)
						
						triggerEvent("meAction", thePlayer, thePlayer, "me", "shows his licenses to ".. getPlayerName( foundPlayer ):gsub("_", " ") ..".")
					end
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [ Player Name/ID ]", thePlayer, 212, 156, 49)
		end	
	end				
end
addCommandHandler("showlicenses", showPlayerLicenses, false, false)

addEventHandler("onPlayerQuit", root,
function( )
	if ( arrests[source] ) then
	
		killTimer(arrests[source]["arrestTimer"])
		arrests[source] = nil
	end	
end)

function updateDatabase( query )
	if ( query ~= "" ) then
		
		local update = sql:query(query)
		if ( not update ) then
			
			outputDebugString("MySQL Error: Unable to update database.")
			outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
		end	
		
		sql:free_result(update)
	end
end

function giveMoneyToPolice( amount )
	local amount = tonumber( amount )*100
	
	local result = sql:query_fetch_assoc("SELECT `balance` FROM `factions` WHERE `id`='1'")
	if ( result ) then
		
		local balance = tonumber( result['balance'] )
		local totalEarned = balance + amount
		
		local update = sql:query("UPDATE `factions` SET `balance`=".. sql:escape_string(totalEarned) .." WHERE `id`='1'")
		if ( not update ) then
		
			outputDebugString("MySQL Error: Unable to update SAN money!", 1)
			outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
		else
			setData( getTeamFromName("San Fierro Police Department"), "balance", totalEarned, true)
		end
		
		sql:free_result(update)
	end	
end

-- /taser
function changetoTaser( thePlayer, commandName )
	if ( getData(thePlayer, "loggedin") == 1 ) then
		if ( getData( thePlayer, "faction" ) == 1 ) and ( getData(thePlayer, "duty") == 1 ) then
			local weapon = getPedWeapon (thePlayer)
			if weapon == 24 then
			
				giveWeapon (thePlayer, 23, 50, false)
			
			elseif weapon == 23 then
			
				giveWeapon (thePlayer, 24, 50, false)
			end
		end
	end	
end
addCommandHandler("taser", changetoTaser, false, false)

------------ /// SAN \\\ ------------


local interviews = { }
addEventHandler("onPlayerQuit", root,
	function( )
		if ( interviews[source] ) then
			
			outputChatBox(getPlayerName(source):gsub("_", " ") .." left the game, interview ended.", interviews[source][1], 255, 0, 0)
			interviews[source] = nil
		end	
	end
)

-- /n
local totalLines = 0
function newsChat( thePlayer, commandName, ... )
	if ( getData( thePlayer, "loggedin" ) == 1 and not isPedDead( thePlayer ) ) then
		
		if ( getPlayerTeam( thePlayer ) == getTeamFromName("San Andreas Network and Entertainment") or interviews[thePlayer] ) then
			
			if (...) then
				local message = table.concat({...}, " ")
				
				for key, value in ipairs ( getElementsByType("player") ) do
					if ( getData( value, "loggedin" ) == 1 ) then
						
						outputChatBox("[NEWS] ".. getPlayerName(thePlayer):gsub("_", " ") .." says: ".. message, value, 229, 35, 135)
					end
				end
				
				totalLines = totalLines + 1
			else
				outputChatBox("SYNTAX: /".. commandName .." [ Message ]", thePlayer, 212, 156, 49)	
			end
		end
	end
end
addCommandHandler("n", newsChat, false, false)

setTimer(
	function( )
		
		local moneyEarned = totalLines * 1000
		if ( moneyEarned ~= 0 ) then
			
			local result = sql:query_fetch_assoc("SELECT `balance` FROM `factions` WHERE `id`='3'")
			if ( result ) then
				
				local balance = tonumber( result['balance'] )
				local totalEarned = balance + moneyEarned
				
				local update = sql:query("UPDATE `factions` SET `balance`=".. sql:escape_string(totalEarned) .." WHERE `id`='3'")
				if ( not update ) then
					
					outputDebugString("MySQL Error: Unable to update SAN money!", 1)
					outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
				else
					triggerEvent("takeMoneyFromGovernment", root, moneyEarned/100)
					
					setData( getTeamFromName("San Andreas Network and Entertainment"), "balance", totalEarned, true)
					totalLines = 0
				end
				
				sql:free_result(update)
			end	
		end	
	end, 10000, 0
)	

-- /invinterview
function inviteInterview( thePlayer, commandName, partialPlayerName )
	if ( getData( thePlayer, "loggedin" ) == 1 and not isPedDead( thePlayer ) ) then
		
		if ( getPlayerTeam( thePlayer ) == getTeamFromName("San Andreas Network and Entertainment") ) then
			
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
						
						interviews[foundPlayer] = { thePlayer, true }
						
						outputChatBox("You invited ".. getPlayerName(foundPlayer):gsub("_", " ") .." to this news interview.", thePlayer, 212, 156, 49)
						outputChatBox("You have been invited to a news interview by ".. getPlayerName(thePlayer):gsub("_", " ") ..".", foundPlayer, 212, 156, 49)
					end
				end
			else
				outputChatBox("SYNTAX: /".. commandName .." [ Player Name / ID ]", thePlayer, 212, 156, 49)
			end	
		end		
	end
end
addCommandHandler("invinterview", inviteInterview, false, false)
addCommandHandler("inviteinterview", inviteInterview, false, false)

-- /endinterview
function endInterview( thePlayer, commandName, partialPlayerName )
	if ( getData( thePlayer, "loggedin" ) == 1 and not isPedDead( thePlayer ) ) then
		
		if ( getPlayerTeam( thePlayer ) == getTeamFromName("San Andreas Network and Entertainment") ) then
			
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
						
						if ( interviews[foundPlayer][2] ) then
							
							interviews[foundPlayer] = nil
							
							outputChatBox("You ended the interview with ".. getPlayerName(foundPlayer):gsub("_", " ") ..".", thePlayer, 212, 156, 49)
							outputChatBox("Your interview with ".. getPlayerName(thePlayer):gsub("_", " ") .." was ended.", foundPlayer, 212, 156, 49)
						else
							outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." is not in an interview.", thePlayer, 255, 0, 0)
						end
					end
				end
			else
				outputChatBox("SYNTAX: /".. commandName .." [ Player Name / ID ]", thePlayer, 212, 156, 49)
			end
		end
	end
end
addCommandHandler("endinterview", endInterview, false, false)	

------------ /// LSVS \\\ ------------
function toggleVehicleImpound( thePlayer, commandName )
	if ( getData( thePlayer, "loggedin" ) == 1 and not isPedDead( thePlayer ) ) then
		
		if ( getPlayerTeam( thePlayer ) == getTeamFromName("San Fierro Vehicle Services") or exports['[ars]global']:isPlayerHighModerator( thePlayer ) ) then
			
			local vehicle = getPedOccupiedVehicle( thePlayer )
			if ( vehicle ) then
				
				if ( commandName == "impound" ) then
					
					local update = sql:query("UPDATE `vehicles` SET `engine`='0', `locked`='0', `enginebroke`='1', `Impounded`='1' WHERE `id`=".. sql:escape_string( tonumber( getData( vehicle, "dbid" ) ) ) .."")
					if ( update ) then
						
						setVehicleLocked( vehicle, false )
						setVehicleEngineState( vehicle, false )
						
						setData( vehicle, "engine", 0, true )
						setData( vehicle, "locked", 0, true )
						setData( vehicle, "enginebroke", 1, true )
						setData( vehicle, "impounded", 1, true )
						
						outputChatBox("You impounded this ".. getVehicleName( vehicle )..".", thePlayer, 212, 156, 49)
					end
					
					sql:free_result(update)
				elseif ( commandName == "unimpound" ) then
					
					local update = sql:query("UPDATE `vehicles` SET `enginebroke`='0', `Impounded`='0' WHERE `id`=".. sql:escape_string( tonumber( getData( vehicle, "dbid" ) ) ) .."")
					if ( update ) then
						
						setData( vehicle, "enginebroke", 0, true )
						setData( vehicle, "impounded", 0, true )
						
						outputChatBox("You un-impounded this ".. getVehicleName( vehicle )..".", thePlayer, 212, 156, 49)
					end
					
					sql:free_result(update)
				end
			else
				outputChatBox("You are not in a vehicle.", thePlayer, 255, 0, 0)
			end	
		end
	end	
end
addCommandHandler("impound", toggleVehicleImpound, false, false)
addCommandHandler("unimpound", toggleVehicleImpound, false, false)