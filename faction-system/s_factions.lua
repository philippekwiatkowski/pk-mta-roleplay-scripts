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

-- /setfaction 
-- /makefaction 
-- /delfaction 
-- /setfactionid 
-- /setfactionname 
-- /setfactionleaderrank
-- /showfactions
-- /makecrimefaction ( for all players )
-- /setvehfaction

--------- [ Admin Commands] ---------

-- /setfaction
function setPlayerFaction( thePlayer, commandName, partialPlayerName, factionID, rankID )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerHighModerator(thePlayer) then
		
		if (partialPlayerName) and (factionID) and (rankID) then
			
			local players = exports['[ars]global']:findPlayer( thePlayer, partialPlayerName )

			if #players == 0 then
				outputChatBox("No one found with that Name / ID.", thePlayer, 255, 0, 0)
			elseif #players > 1 then
				outputChatBox("Multiple Players found!", thePlayer, 255, 200, 0)
				
				local count = 0
				for k, foundPlayer in ipairs (players) do
					
					count = count + 1
					outputChatBox("(".. getData(foundPlayer, "playerid") ..") ".. getPlayerName(foundPlayer):gsub("_", " "), thePlayer, 255, 255, 0)
				end		
			else
				for k, foundPlayer in ipairs (players) do 
				
					local factionID = tonumber(factionID)
					local rankID = tonumber(rankID)
					
					local found = false
					for k, team in ipairs ( getElementsByType("team") ) do
						if tonumber(getData(team, "id")) == factionID then
							
							found = true
							
							local update = sql:query("UPDATE characters SET faction=".. factionID ..", rank=".. rankID .." WHERE id=".. sql:escape_string(getData(foundPlayer, "dbid")) .."")
							if (update) then
								setPlayerTeam(foundPlayer, team)
								setData(foundPlayer, "faction", factionID, true)
								setData(foundPlayer, "f:rank", rankID, true)
								
								outputChatBox("You were set to the faction '".. getTeamName(team) ..".", foundPlayer, 212, 156, 49)
								outputChatBox("You set ".. getPlayerName(foundPlayer):gsub("_", " ") .." to the faction '".. getTeamName(team) ..".", thePlayer, 212, 156, 49)
								break
							end	
							
							sql:free_result(update)
						end
					end
					
					if not (found) then
						outputChatBox("Invalid faction ID.", thePlayer, 255, 0, 0)
					end	
				end
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Player Name/ID] [Faction ID] [Rank ID  (1 - 15)]", thePlayer, 212, 156, 49)
		end
	end	
end
addCommandHandler("setfaction", setPlayerFaction, false, false)

-- /makefaction
function makeFaction( thePlayer, commandName, factionType )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerAdministrator(thePlayer) then
		
		if (factionType) then
			
			local factionType = tostring(factionType)
			if factionType == "gov" then
				
				triggerClientEvent(thePlayer, "showCreateGovFaction", thePlayer)
			elseif factionType == "private" then
				
				triggerClientEvent(thePlayer, "showCreatePrivateFaction", thePlayer)
			elseif factionType == "criminal" then
				
				triggerClientEvent(thePlayer, "showCreateCriminalFaction", thePlayer)	
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Faction Type (gov/private/criminal)]", thePlayer, 212, 156, 49)
		end
	end	
end
addCommandHandler("makefaction", makeFaction, false, false)

-- /delfaction
function deleteFaction( thePlayer, commandName, factionID )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerAdministrator(thePlayer) then
		
		if (factionID) then
			
			local factionID = tonumber(factionID)
			
			local found = false
			for key, faction in ipairs ( getElementsByType("team") ) do
				if tonumber(getData(faction, "id")) == factionID then
					
					outputChatBox("Destroyed faction '".. getTeamName(faction) .."' ( ID: ".. tostring(factionID) .." )", thePlayer, 212, 156, 49) 
					destroyElement(faction)
					found = true
					break
				end	
			end
				
			if (found) then
				
				local delete = sql:query("DELETE FROM factions WHERE id=".. sql:escape_string(factionID) .."")
				if (not delete) then
					outputDebugString("MySQL Error: Unable to delete faction!")
					outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
				end	
				
				sql:free_result(delete)
			else	
				outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Faction ID]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("delfaction", deleteFaction, false, false)
	
-- /setfactionleaderank
function setFactionLeaderRank( thePlayer, commandName, factionID, leaderRank )	
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerAdministrator(thePlayer) then
		
		if (factionID) and (leaderRank) then
			
			local factionID = tonumber(factionID)
			local leaderRank = tonumber(leaderRank)
			
			local found = false
			for key, faction in ipairs ( getElementsByType("team") ) do
				if tonumber(getData(faction, "id")) == factionID then
					
					outputChatBox("Updated '".. getTeamName(faction) .."' leader rank to ".. sql:escape_string(leaderRank) ..".", thePlayer, 212, 156, 49) 
					setData(faction, "leader", tonumber(leaderRank), true)
					found = true
					break
				end	
			end
				
			if (found) then
				local update = sql:query("UPDATE factions SET leader_rank=".. sql:escape_string(leaderRank) .." WHERE id=".. sql:escape_string(factionID) .."")
				if (not update) then
					outputDebugString("MySQL Error: Unable to set faction leader rank!")
					outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
				end
				
				sql:free_result(update)
			else	
				outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Faction ID] [Rank ID]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("setfactionleaderrank", setFactionLeaderRank, false, false)
	
-- /setfactionid
function setFactionID( thePlayer, commandName, factionID, newFactionID )	
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerAdministrator(thePlayer) then
		
		if (factionID) and (newFactionID) then
			
			local factionID = tonumber(factionID)
			local newFactionID = tonumber(newFactionID)
			
			local found = false
			for key, faction in ipairs ( getElementsByType("team") ) do
				if tonumber(getData(faction, "id")) == factionID then
					
					outputChatBox("Updated '".. getTeamName(faction) .."' faction ID to ".. tostring(newFactionID) ..".", thePlayer, 212, 156, 49) 
					setData(faction, "id", tonumber(newFactionID), true)
					
					for key, factionMember in ipairs (getPlayersInTeam(faction)) do
						setData(factionMember, "faction", tonumber(newFactionID), true)
					end
					
					found = true
					break
				end	
			end

			if (found) then	
				local update = sql:query("UPDATE factions SET id=".. sql:escape_string(newFactionID) .." WHERE id=".. sql:escape_string(factionID) .."")
				local update2 = sql:query("UPDATE characters SET faction=".. sql:escape_string(newFactionID) .." WHERE faction=".. sql:escape_string(factionID) .."")
				if (not update) or (not update2) then
					outputDebugString("MySQL Error: Unable to change faction id!")
					outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
				else
					-- ID changed? Need to notify
					sendRanksAndWages( ) 
					sendFactionNames( )
				end	
				
				sql:free_result(update)
				sql:free_result(update2)
			else
				outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Faction ID] [New Faction ID]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("setfactionid", setFactionID, false, false)

-- /setfactionname
function setFactionName( thePlayer, commandName, factionID, ... )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerAdministrator(thePlayer) then
		
		if (factionID) and (...) then
			
			local factionID = tonumber(factionID)
			local newFactionName = table.concat({...}, " ")
			
			local found = false
			for key, faction in ipairs ( getElementsByType("team") ) do
				if tonumber(getData(faction, "id")) == factionID then
					
					outputChatBox("Updated '".. getTeamName(faction) .."' name to ".. tostring(newFactionName) ..".", thePlayer, 212, 156, 49) 
					setTeamName(faction, tostring(newFactionName))
					
					-- Notify Name change
					sendFactionNames( )
					
					found = true
					break
				end	
			end

			if (found) then	
				local update = sql:query("UPDATE factions SET name='".. sql:escape_string(tostring(newFactionName)) .."' WHERE id=".. sql:escape_string(factionID) .."")
				if (not update) then
					outputDebugString("MySQL Error: Unable to rename faction!")
					outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
				else
					-- Notify Name change
					sendFactionNames( )
				end

				sql:free_result(update)
			else
				outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Faction ID] [New Faction Name]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("setfactionname", setFactionName, false, false)

-- /showfactions
function showFactions( thePlayer, commandName )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerHighModerator(thePlayer) then
		
		local factions = { }
		factions["id"] = { }
		factions["name"] = { }
		factions["type"] = { }
		
		local result = sql:query("SELECT id, name, type FROM factions")
		while true do
			local row = sql:fetch_assoc(result)
			if not row then break end
			
			table.insert(factions["id"], row['id'])
			table.insert(factions["name"], row['name'])
			table.insert(factions["type"], row['type'])
		end
		
		sql:free_result(result)
		triggerClientEvent(thePlayer, "showAllFactions", thePlayer, factions)
	end
end
addCommandHandler("showfactions", showFactions, false, false)
	
-- /setvehfaction	
function setVehicleFaction( thePlayer, commandName )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerHighModerator(thePlayer) then
		
		local faction = tonumber(getData(thePlayer, "faction"))
		if (faction > 0) then
			
			local factionRank = tonumber(getData(thePlayer, "f:rank"))
			local leaderRank = tonumber(getData(getPlayerTeam(thePlayer), "leader"))
			
			if (factionRank >= leaderRank) or (exports['[ars]global']:isPlayerHighModerator(thePlayer)) then
				
				local vehicle = getPedOccupiedVehicle(thePlayer)
				if (vehicle) then
					
					local dbid = tonumber(getData(vehicle, "dbid"))
					local update = sql:query("UPDATE vehicles SET faction=".. sql:escape_string(faction) ..", owner='-1' WHERE id=".. sql:escape_string(dbid) .."")
					if (update) then
						setData(vehicle, "faction", tonumber(faction), true)
						setData(vehicle, "owner", -1, true)
						
						outputChatBox("This vehicle is now owned by your faction.", thePlayer, 0, 255, 0)
					else
						outputDebugString("MySQL Error: Unable to set vehicle to faction!")
						outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
					end
					
					sql:free_result(update)
				else
					outputChatBox("You need to be in a vehicle to trigger that command.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("You are not authorized to that command.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("You are not in a faction.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("setvehfaction", setVehicleFaction, false, false)
	
--------- [ Client Side Calls] ---------

-- // Faction Menu Calls
function callFactionUI( thePlayer )
	
	if isElement(getPlayerTeam(thePlayer)) then -- If his faction exists..
		local factionID = tonumber(getData(getPlayerTeam(thePlayer), "id"))
		local factionType = tonumber(getData(getPlayerTeam(thePlayer), "type"))
		local leaderRank = tonumber(getData(getPlayerTeam(thePlayer), "leader"))
		local playerRank = tonumber(getData(thePlayer, "f:rank"))
		local factionBalance = tonumber(getData(getPlayerTeam(thePlayer), "balance"))
		
		triggerClientEvent(thePlayer, "createFactionUI", thePlayer, playerRank, factionID, factionType, leaderRank, factionBalance)
	end	
end

function getFactionInfo( )
	
	local dbid = tonumber(getData(getPlayerTeam(source), "id"))
	local factionType = tonumber(getData(getPlayerTeam(source), "type"))
	
	local members = { }
	members["name"] = { }
	members["rank"] = { }
	members["status"] = { }
	members["lastseen"] = { }
	
	local result = sql:query("SELECT charactername, DATEDIFF(NOW(), lastlogin) AS llastlogin, rank FROM characters WHERE faction=".. sql:escape_string(dbid) .." ORDER BY rank DESC, charactername ASC")
	while true do
		local row = sql:fetch_assoc(result)
		if not row then break end
		
		table.insert(members["name"], row['charactername'])
		table.insert(members["rank"], row['rank'])
		table.insert(members["lastseen"], row['llastlogin'])
		
		local found = false
		for key, thePlayer in ipairs ( getElementsByType("player") ) do
			if tostring(row['charactername']) == tostring(getPlayerName(thePlayer):gsub("_", " ")) then
				
				found = true
				table.insert(members["status"], "Online")
				break
			end
		end
		
		if not found then
			table.insert(members["status"], "Offline")
		end	
	end
	
	sql:free_result(result)
	triggerClientEvent(source, "populateMemberList", source, members, dbid, factionType)		
end
addEvent("getFactionInfo", true)
addEventHandler("getFactionInfo", getRootElement(), getFactionInfo)

-- Quit Faction
function quitFaction( )
	local update = sql:query("UPDATE characters SET faction='-1', rank='-1' WHERE id=".. sql:escape_string(getData(source, "dbid")) .."")
	if (update) then
		
		setPlayerTeam(source, nil)
		setData(source, "faction", -1, true)
		setData(source, "f:rank", -1, true)
		
		outputChatBox("You have quit your faction.", source, 0, 255, 0)
	else
		outputDebugString("MySQL Error: Unable to quit faction!")
		outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
	end
	
	sql:free_result(update)
end
addEvent("quitFaction", true)
addEventHandler("quitFaction", getRootElement(), quitFaction)

-- Kick Player
function removePlayerFromFaction( playerName )
	local playerName = tostring(playerName)
	
	local update = sql:query("UPDATE characters SET faction='-1', rank='-1' WHERE charactername='".. sql:escape_string(tostring(playerName)) .."'")
	if (update) then
		
		local thePlayer = getPlayerFromName(playerName:gsub(" ", "_"))
		if isElement(thePlayer) then
			
			setPlayerTeam(thePlayer, nil)
			setData(thePlayer, "faction", -1, true)
			setData(thePlayer, "f:rank", -1, true)
			
			outputChatBox("You were kicked from your faction.", thePlayer, 255, 0, 0)
		end
		
		outputChatBox("You kicked ".. playerName .." from your faction.", source, 212, 156, 14)
	else
		outputDebugString("MySQL Error: Unable to kick player from faction!")
		outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
	end	
	
	sql:free_result(update)
end
addEvent("removePlayerFromFaction", true)
addEventHandler("removePlayerFromFaction", getRootElement(), removePlayerFromFaction)

-- Invite Player
function invitePlayerToFaction( thePlayer )
	local invitingFaction = tonumber(getData(source, "faction"))
	local playerName = tostring(getPlayerName(thePlayer):gsub("_", " "))
	
	local update = sql:query("UPDATE characters SET faction=".. sql:escape_string(invitingFaction) ..", rank='1' WHERE charactername='".. sql:escape_string(tostring(playerName)) .."'")
	if (update) then
		
		setPlayerTeam(thePlayer, getPlayerTeam(source))
		setData(thePlayer, "faction", invitingFaction, true)
		setData(thePlayer, "f:rank", 1, true)
	
		outputChatBox("You were set to a faction.", thePlayer, 0, 255, 0)
		outputChatBox("You set ".. playerName .." to your faction.", source, 212, 156, 14)
	else
		outputDebugString("MySQL Error: Unable to invite player to faction!")
		outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
	end	
	
	sql:free_result(update)
end
addEvent("invitePlayerToFaction", true)
addEventHandler("invitePlayerToFaction", getRootElement(), invitePlayerToFaction)

-- Promote Player
function promoteFactionMember( playerName, rankID, rankName )
	local rankName = tostring(rankName)
	local rankID = tonumber(rankID)
	local playerName = tostring(playerName)
	
	local update = sql:query("UPDATE characters SET rank=".. sql:escape_string(rankID) .." WHERE charactername='".. sql:escape_string(tostring(playerName)) .."'")
	if (update) then
		
		local thePlayer = getPlayerFromName(playerName:gsub(" ", "_"))
		if isElement(thePlayer) then
			setData(thePlayer, "f:rank", tonumber(rankID), true)
		end
		
		for key, factionMember in ipairs( getPlayersInTeam(getPlayerTeam(source)) ) do
			outputChatBox(getPlayerName(source) .." promoted ".. playerName .." to ".. rankName ..".", factionMember, 212, 156, 49)
		end
	else	
		outputDebugString("MySQL Error: Unable to promote player in faction!")
		outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
	end
	
	sql:free_result(update)
end
addEvent("promoteFactionMember", true)
addEventHandler("promoteFactionMember", getRootElement(), promoteFactionMember)

-- Demote Player
function demoteFactionMember( playerName, rankID, rankName )
	local rankName = tostring(rankName)
	local rankID = tonumber(rankID)
	local playerName = tostring(playerName)
	
	local update = sql:query("UPDATE characters SET rank=".. sql:escape_string(rankID) .." WHERE charactername='".. sql:escape_string(tostring(playerName)) .."'")
	if (update) then
		
		local thePlayer = getPlayerFromName(playerName:gsub(" ", "_"))
		if isElement(thePlayer) then
			setData(thePlayer, "f:rank", tonumber(rankID), true)
		end	
		
		for key, factionMember in ipairs( getPlayersInTeam(getPlayerTeam(source)) ) do
			outputChatBox(getPlayerName(source) .." demoted ".. playerName .." to ".. rankName ..".", factionMember, 212, 156, 49)
		end
	else	
		outputDebugString("MySQL Error: Unable to demote player in faction!")
		outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
	end	
	
	sql:free_result(update)
end
addEvent("demoteFactionMember", true)
addEventHandler("demoteFactionMember", getRootElement(), demoteFactionMember)

-- Change Ranks
function saveFactionRanks( ranks, leaderRank, factionID )
	local factionID = tonumber(factionID)
	local leaderRank = tostring(leaderRank)
	
	local rank = ranks[1] ..",".. ranks[2] ..",".. ranks[3] ..",".. ranks[4] ..",".. ranks[5] ..",".. ranks[6] ..",".. ranks[7] ..",".. ranks[8] ..",".. ranks[9] ..",".. ranks[10] ..",".. ranks[11] ..",".. ranks[12] ..",".. ranks[13] ..",".. ranks[14] ..",".. ranks[15]
	local update = sql:query("UPDATE factions SET leader_rank=".. sql:escape_string(leaderRank) ..", rank='".. sql:escape_string(tostring(rank)) .."' WHERE id=".. sql:escape_string(factionID) .."")
	if (update) then
		setData(getPlayerTeam(source), "leader", leaderRank, true)
		
		sendRanksAndWages( ) -- Ranks and Wage update
		outputChatBox("Ranks Saved!", source, 0, 255, 0)
	else
		outputDebugString("MySQL Error: Unable to change faction ranks!")
		outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
	end		
	
	sql:free_result(update)
end
addEvent("saveFactionRanks", true)
addEventHandler("saveFactionRanks", getRootElement(), saveFactionRanks)

-- Change Wages
function saveFactionWages( wages, factionID )
	local factionID = tonumber(factionID)
	
	local wage = wages[1] ..",".. wages[2] ..",".. wages[3] ..",".. wages[4] ..",".. wages[5] ..",".. wages[6] ..",".. wages[7] ..",".. wages[8] ..",".. wages[9] ..",".. wages[10] ..",".. wages[11] ..",".. wages[12] ..",".. wages[13] ..",".. wages[14] ..",".. wages[15]
	local update = sql:query("UPDATE factions SET wages='".. sql:escape_string(tostring(wage)) .."' WHERE id=".. sql:escape_string(factionID) .."")
	if (update) then
		
		sendRanksAndWages( ) -- Ranks and Wage update
		outputChatBox("Wages Saved!", source, 0, 255, 0)
	else	
		outputDebugString("MySQL Error: Unable to change faction wages!")
		outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
	end	
	
	sql:free_result(update)
end
addEvent("saveFactionWages", true)
addEventHandler("saveFactionWages", getRootElement(), saveFactionWages)

-- Change MOTD
function saveFactionMOTD(motdText, factionID)
	local factionID = tonumber(factionID)
	
	local update = sql:query("UPDATE factions SET motd='".. sql:escape_string(tostring(motdText)) .."' WHERE id=".. sql:escape_string(factionID) .."")
	if (update) then
		sendMOTD( )
		outputChatBox("MOTD Updated!", source, 0, 255, 0)
	else	
		outputDebugString("MySQL Error: Unable to change MOTD!")
		outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
	end	
	
	sql:free_result(update)
end
addEvent("saveFactionMOTD", true)
addEventHandler("saveFactionMOTD", getRootElement(), saveFactionMOTD)

-- // Create Government Faction Calls
function createGovFaction( name, ranks, wages )
	
	local rank = ranks[1] ..",".. ranks[2] ..",".. ranks[3] ..",".. ranks[4] ..",".. ranks[5] ..",".. ranks[6] ..",".. ranks[7] ..",".. ranks[8] ..",".. ranks[9] ..",".. ranks[10] ..",".. ranks[11] ..",".. ranks[12] ..",".. ranks[13] ..",".. ranks[14] ..",".. ranks[15]
	local wage = wages[1] ..",".. wages[2] ..",".. wages[3] ..",".. wages[4] ..",".. wages[5] ..",".. wages[6] ..",".. wages[7] ..",".. wages[8] ..",".. wages[9] ..",".. wages[10] ..",".. wages[11] ..",".. wages[12] ..",".. wages[13] ..",".. wages[14] ..",".. wages[15]

	local insert = sql:query("INSERT INTO factions SET name='".. sql:escape_string(tostring(name)) .."', type='1', rank='".. sql:escape_string(tostring(rank)) .."', wages='".. sql:escape_string(tostring(wage)) .."', motd=''")
	if (insert) then
		local insertid = sql:insert_id()
		
		local faction = createTeam(tostring(name))
		setData(faction, "id", tonumber(insertid), true)
		setData(faction, "type", 1, true)
		setData(faction, "leader", 10, true)
		setData(faction, "balance", 0, true)
		
		outputChatBox("Faction '".. tostring(name) .."' created with ID ".. tostring(insertid) ..".", source, 0, 255, 0)
		
		sendRanksAndWages( ) -- Ranks and Wage update
		sendFactionNames( ) -- A new faction 
	else
		outputDebugString("MySQL Error: Unable to create government faction!")
		outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
	end	
	
	sql:free_result(insert)
end
addEvent("createGovFaction", true)
addEventHandler("createGovFaction", getRootElement(), createGovFaction)

-- // Create Private Faction Calls
function createPrivateFaction( name, ranks, wages )
	local rank = ranks[1] ..",".. ranks[2] ..",".. ranks[3] ..",".. ranks[4] ..",".. ranks[5] ..",".. ranks[6] ..",".. ranks[7] ..",".. ranks[8] ..",".. ranks[9] ..",".. ranks[10] ..",".. ranks[11] ..",".. ranks[12] ..",".. ranks[13] ..",".. ranks[14] ..",".. ranks[15]
	local wage = wages[1] ..",".. wages[2] ..",".. wages[3] ..",".. wages[4] ..",".. wages[5] ..",".. wages[6] ..",".. wages[7] ..",".. wages[8] ..",".. wages[9] ..",".. wages[10] ..",".. wages[11] ..",".. wages[12] ..",".. wages[13] ..",".. wages[14] ..",".. wages[15]

	local insert = sql:query("INSERT INTO factions SET name='".. sql:escape_string(tostring(name)) .."', type='2', rank='".. sql:escape_string(tostring(rank)) .."', wages='".. sql:escape_string(tostring(wage)) .."', motd=''")
	if (insert) then
		local insertid = sql:insert_id()
		
		local faction = createTeam(tostring(name))
		setData(faction, "id", tonumber(insertid), true)
		setData(faction, "type", 2, true)
		setData(faction, "leader", 10, true)
		setData(faction, "balance", 0, true)
		
		outputChatBox("Faction '".. tostring(name) .."' created with ID ".. tostring(insertid) ..".", source, 0, 255, 0)
		
		sendRanksAndWages( ) -- Ranks and Wage update
		sendFactionNames( ) -- A new faction 
	else
		outputDebugString("MySQL Error: Unable to create private faction!")
		outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
	end	
	
	sql:free_result(insert)
end
addEvent("createPrivateFaction", true)
addEventHandler("createPrivateFaction", getRootElement(), createPrivateFaction)

-- // Create Criminal Faction Calls
function createCriminalFaction( name, ranks )
	local rank = ranks[1] ..",".. ranks[2] ..",".. ranks[3] ..",".. ranks[4] ..",".. ranks[5] ..",".. ranks[6] ..",".. ranks[7] ..",".. ranks[8] ..",".. ranks[9] ..",".. ranks[10] ..",".. ranks[11] ..",".. ranks[12] ..",".. ranks[13] ..",".. ranks[14] ..",".. ranks[15]
	local wage = "100,100,100,100,100,100,100,100,100,100,100,100,100,100,100"
	
	local insert = sql:query("INSERT INTO factions SET name='".. sql:escape_string(tostring(name)) .."', type='3', rank='".. sql:escape_string(tostring(rank)) .."', wages='".. sql:escape_string(tostring(wage)) .."', motd=''")
	if (insert) then
		local insertid = sql:insert_id()
		
		local faction = createTeam(tostring(name))
		setData(faction, "id", tonumber(insertid), true)
		setData(faction, "type", 3, true)
		setData(faction, "leader", 10, true)
		setData(faction, "balance", 0, true)
		
		outputChatBox("Faction '".. tostring(name) .."' created with ID ".. tostring(insertid) ..".", source, 0, 255, 0)
		
		sendRanksAndWages( ) -- Ranks and Wage update
		sendFactionNames( ) -- A new faction 
	else
		outputDebugString("MySQL Error: Unable to create criminal faction!")
		outputDebugString("SQL Error: #".. sql:errno() ..": ".. sql:err())
	end	
	
	sql:free_result(insert)
end 
addEvent("createCriminalFaction", true)
addEventHandler("createCriminalFaction", getRootElement(), createCriminalFaction)

function getPlayerWage( factionID, rank )
	local factionID = tonumber( factionID )
	local rank = tonumber( rank )
	
	local result = sql:query_fetch_assoc("SELECT `wages` FROM `factions` WHERE `id`=".. sql:escape_string( factionID ) .."")
	if ( result ) then
		
		local wages = tostring( result['wages'] )
		local t = split(wages, string.byte(",")) 
		
		for i = 1, #t do
			if ( tonumber( i ) == rank ) then
				
				if ( string.find( tostring( t[ i ] ), "#" ) ) then
					return 0
				else	
					return t[ i ]
				end	
			end	
		end
	end	
end

--------- [ Resource Start ] ---------
function createFactions( res )
	for index, team in ipairs(getElementsByType("team")) do -- Destroy all present teams
		destroyElement(team)
	end
	
	local result = sql:query("SELECT id, name, type, leader_rank, balance FROM factions")
	while true do
		local row = sql:fetch_assoc(result)
		if not row then break end
		
		local id = row['id']
		local name = row['name']
		local factionType = row['type']
		local leaderRank = row['leader_rank']
		local balance = row['balance']
			
		local faction = createTeam(tostring(name))
		if (faction) then
				
			setData(faction, "id", tonumber(id), true)
			setData(faction, "type", tonumber(factionType), true)
			setData(faction, "leader", tonumber(leaderRank), true)
			setData(faction, "balance", tonumber(balance), true)
		end
		
		for key, thePlayer in ipairs ( getElementsByType("player") ) do
			if getData(thePlayer, "faction") == tonumber(id) then
				
				setPlayerTeam(thePlayer, faction)
				outputServerLog(getPlayerName(thePlayer) .." added to faction ".. getTeamName(faction))
			end
		end	
	end	
	
	sql:free_result(result)
	started = false
end
addEventHandler("onResourceStart", resourceRoot, createFactions)

function getFactionDetails( )

	local result = sql:query("SELECT id, name, rank, wages, motd FROM factions")
	while true do
		local row = sql:fetch_assoc(result)
		if not row then break end
		
		local id = row['id']
		local name = row['name']
		local ranks = row['rank']
		local wages = row['wages']
		local motd = row['motd']
		
		triggerClientEvent(source, "storeRanksAndWages", source, id, ranks, wages)
		triggerClientEvent(source, "storeFactionNames", source, id, name)
		triggerClientEvent(source, "storeMOTD", source, id, motd)
	end
	
	sql:free_result(result)
end
addEvent("getFactionDetails", true)
addEventHandler("getFactionDetails", root, getFactionDetails)

-- We need to send an update to the client sometimes
function sendRanksAndWages( )
	local result = sql:query("SELECT id, rank, wages FROM factions")
	while true do
		local row = sql:fetch_assoc(result)
		if not row then break end
			
		local id = row['id']
		local ranks = row['rank']
		local wages = row['wages']
			
		triggerClientEvent("storeRanksAndWages", getRootElement(), id, ranks, wages)
	end	
	
	sql:free_result(result)
end
addEvent("sendRanksAndWages", true)
addEventHandler("sendRanksAndWages", getRootElement(), sendRanksAndWages)

function sendFactionNames( )
	local result = sql:query("SELECT id, name FROM factions")
	while true do
		local row = sql:fetch_assoc(result)
		if not row then break end
			
		local id = row['id']
		local name = row['name']
			
		triggerClientEvent("storeFactionNames", getRootElement(), id, name)
	end
	
	sql:free_result(result)
end
addEvent("sendFactionNames", true)
addEventHandler("sendFactionNames", getRootElement(), sendFactionNames)

function sendMOTD( )
	local result = sql:query("SELECT id, motd FROM factions")
	while true do
		local row = sql:fetch_assoc(result)
		if not row then break end
			
		local id = row['id']
		local motd = row['motd']
			
		triggerClientEvent("storeMOTD", getRootElement(), id, motd)
	end
	
	sql:free_result(result)
end
addEvent("sendMOTD", true)
addEventHandler("sendMOTD", getRootElement(), sendMOTD)

--------- [ Binds ] ---------
local function bindKeysOnStart( res )
	for i, thePlayer in ipairs ( getElementsByType("player") ) do
		if ( not isKeyBound( thePlayer, "f3", "down", callFactionUI) ) then
			bindKey(thePlayer, "f3", "down", callFactionUI)
		end
	end	
end
addEventHandler("onResourceStart", resourceRoot, bindKeysOnStart)
	
function bindFactionKeys( )
	bindKey(source, "f3", "down", callFactionUI)
end
addEventHandler("onPlayerJoin", getRootElement(), bindFactionKeys)