local screenX, screenY = guiGetScreenSize()

--------- [ Element Data returns ] ---------
local function getData( theElement, key )
	local key = tostring(key)
	if isElement(theElement) and (key) then
		
		return exports['[ars]anticheat-system']:c_callData( theElement, tostring(key) )
	else
		return false
	end
end	

--------- [ Admin Commands ] ---------
function showCreateGovFaction( )
	local width, height = 400, 500
	local x = (screenX/2) - (width/2)
	local y = (screenY/2) - (height/2)
	
	if not isElement(createGovFactionWin) and not isElement(createPrivateFactionWin) and not isElement(createCriminalFactionWin) then 
		
		createGovFactionWin = guiCreateWindow(x, y, width, height, "Create Government Faction", false)
		guiWindowSetSizable (createGovFactionWin, false)
		
		-- Labels
		guiCreateLabel(20, 40, 33, 25, "Name: ", false, createGovFactionWin)
		guiCreateLabel(20, 80, 36, 25, "Ranks: ", false, createGovFactionWin)
		guiCreateLabel(180, 80, 40, 25, "Wages: ", false, createGovFactionWin)
		
		-- Edits
		local nameEdit = guiCreateEdit(60, 40, 160, 20, "", false, createGovFactionWin)
		
		local rankEdits = { }
		local ry = 105
		
		for i = 1, 15 do
			rankEdits[i] = guiCreateEdit(20, ry, 130, 20, "#Dynamic Rank ".. i, false, createGovFactionWin)
			ry = ry + 25
		end	
		
		local wageEdits = { }
		local wy = 105
		
		for i = 1, 15 do
			wageEdits[i] = guiCreateEdit(180, wy, 130, 20, "#Dynamic Wage ".. i, false, createGovFactionWin)
			wy = wy + 25
		end
	
		-- Buttons
		createGovBtn = guiCreateButton(270, 40, 110, 20, "Create Faction", false, createGovFactionWin)
		addEventHandler("onClientGUIClick", createGovBtn,
		function( )
			
			local wages = { }
			for i = 1, 15 do
				wages[i] = guiGetText(wageEdits[i])
			end
			
			local ranks = { }
			for i = 1, 15 do
				ranks[i] = guiGetText(rankEdits[i])
			end
			
			local name = guiGetText(nameEdit)
			triggerServerEvent("createGovFaction", getLocalPlayer(), name, ranks, wages)
			
			destroyElement(createGovFactionWin)
			createGovFactionWin = nil
			
			guiSetInputEnabled(false)
			showCursor(false)
		end, false)	
		
		cancelGovBtn = guiCreateButton(270, 70, 110, 20, "Cancel", false, createGovFactionWin)
		addEventHandler("onClientGUIClick", cancelGovBtn,
		function( )
			destroyElement(createGovFactionWin)
			createGovFactionWin = nil
			
			guiSetInputEnabled(false)
			showCursor(false)
		end, false)	
		
		guiSetInputEnabled(true)
		showCursor(true)
	else
		outputChatBox("You already have a faction creation window open, close it first.", 255, 0, 0)	
	end	
end
addEvent("showCreateGovFaction", true)
addEventHandler("showCreateGovFaction", getLocalPlayer(), showCreateGovFaction)

function showCreatePrivateFaction( )
	local width, height = 400, 500
	local x = (screenX/2) - (width/2)
	local y = (screenY/2) - (height/2)
	
	if not isElement(createPrivateFactionWin) and not isElement(createGovFactionWin) and not isElement(createCriminalFactionWin) then 
		
		createPrivateFactionWin = guiCreateWindow(x, y, width, height, "Create Private Faction", false)
		guiWindowSetSizable (createPrivateFactionWin, false)
		
		-- Labels
		guiCreateLabel(20, 40, 33, 25, "Name: ", false, createPrivateFactionWin)
		guiCreateLabel(20, 80, 36, 25, "Ranks: ", false, createPrivateFactionWin)
		guiCreateLabel(180, 80, 40, 25, "Wages: ", false, createPrivateFactionWin)
		
		-- Edits
		local nameEdit = guiCreateEdit(60, 40, 160, 20, "", false, createPrivateFactionWin)
		
		local rankEdits = { }
		local ry = 105
		
		for i = 1, 15 do
			rankEdits[i] = guiCreateEdit(20, ry, 130, 20, "#Dynamic Rank ".. i, false, createPrivateFactionWin)
			ry = ry + 25
		end	
		
		local wageEdits = { }
		local wy = 105
		
		for i = 1, 15 do
			wageEdits[i] = guiCreateEdit(180, wy, 130, 20, "#Dynamic Wage ".. i, false, createPrivateFactionWin)
			wy = wy + 25
		end
	
		-- Buttons
		createPrivateBtn = guiCreateButton(270, 40, 110, 20, "Create Faction", false, createPrivateFactionWin)
		addEventHandler("onClientGUIClick", createPrivateBtn,
		function( )
			
			local wages = { }
			for i = 1, 15 do
				wages[i] = guiGetText(wageEdits[i])
			end
			
			local ranks = { }
			for i = 1, 15 do
				ranks[i] = guiGetText(rankEdits[i])
			end
			
			local name = guiGetText(nameEdit)
			triggerServerEvent("createPrivateFaction", getLocalPlayer(), name, ranks, wages)
			
			destroyElement(createPrivateFactionWin)
			createPrivateFactionWin = nil
			
			guiSetInputEnabled(false)
			showCursor(false)
		end, false)	
		
		cancelPrivateBtn = guiCreateButton(270, 70, 110, 20, "Cancel", false, createPrivateFactionWin)
		addEventHandler("onClientGUIClick", cancelPrivateBtn,
		function( )
			destroyElement(createPrivateFactionWin)
			createPrivateFactionWin = nil
			
			guiSetInputEnabled(false)
			showCursor(false)
		end, false)	
		
		guiSetInputEnabled(true)
		showCursor(true)
	else
		outputChatBox("You already have a faction creation window open, close it first.", 255, 0, 0)
	end	
end
addEvent("showCreatePrivateFaction", true)
addEventHandler("showCreatePrivateFaction", getLocalPlayer(), showCreatePrivateFaction)

function showCreateCriminalFaction( )
	local width, height = 300, 500
	local x = (screenX/2) - (width/2)
	local y = (screenY/2) - (height/2)
	
	if not isElement(createCriminalFactionWin) and not isElement(createPrivateFactionWin) and not isElement(createGovFactionWin) then 
		
		createCriminalFactionWin = guiCreateWindow(x, y, width, height, "Create Criminal Faction", false)
		guiWindowSetSizable (createCriminalFactionWin, false)
		
		-- Labels
		guiCreateLabel(20, 40, 33, 25, "Name: ", false, createCriminalFactionWin)
		guiCreateLabel(20, 80, 36, 25, "Ranks: ", false, createCriminalFactionWin)
		
		-- Edits
		local nameEdit = guiCreateEdit(60, 40, 160, 20, "", false, createCriminalFactionWin)
		
		local rankEdits = { }
		local ry = 105
		
		for i = 1, 15 do
			rankEdits[i] = guiCreateEdit(20, ry, 130, 20, "#Dynamic Rank ".. i, false, createCriminalFactionWin)
			ry = ry + 25
		end	
	
		-- Buttons
		createCriminalBtn = guiCreateButton(170, 80, 110, 20, "Create Faction", false, createCriminalFactionWin)
		addEventHandler("onClientGUIClick", createCriminalBtn,
		function( )
			
			local ranks = { }
			for i = 1, 15 do
				ranks[i] = guiGetText(rankEdits[i])
			end
			
			local name = guiGetText(nameEdit)
			triggerServerEvent("createCriminalFaction", getLocalPlayer(), name, ranks)
			
			destroyElement(createCriminalFactionWin)
			createCriminalFactionWin = nil
			
			guiSetInputEnabled(false)
			showCursor(false)
		end, false)	
		
		cancelCriminalBtn = guiCreateButton(170, 110, 110, 20, "Cancel", false, createCriminalFactionWin)
		addEventHandler("onClientGUIClick", cancelCriminalBtn,
		function( )
			destroyElement(createCriminalFactionWin)
			createCriminalFactionWin = nil
			
			guiSetInputEnabled(false)
			showCursor(false)
		end, false)	
		
		guiSetInputEnabled(true)
		showCursor(true)
	else
		outputChatBox("You already have a faction creation window open, close it first.", 255, 0, 0)
	end	
end
addEvent("showCreateCriminalFaction", true)
addEventHandler("showCreateCriminalFaction", getLocalPlayer(), showCreateCriminalFaction)

function showAllFactions( data )
	local width, height = 500, 300
	local x = (screenX/2) - (width/2)
	local y = (screenY/2) - (height/2)
	
	if not isElement(factionsWin) then
		
		factionsWin = guiCreateWindow(x, y, width, height, "All Factions", false)
		guiWindowSetSizable (factionsWin, false)
		
		-- Grid
		factionsList = guiCreateGridList(20, 30, 460, 210, false, factionsWin) 
		guiGridListAddColumn(factionsList, "ID", 0.2)
		guiGridListAddColumn(factionsList, "Name", 0.5)
		guiGridListAddColumn(factionsList, "Type", 0.3)
		
		local length = #data["name"]
		for i = 1, length do
			local row = guiGridListAddRow(factionsList)
				
			guiGridListSetItemText(factionsList, row, 1, tostring(data["id"][i]), false, false)
			guiGridListSetItemText(factionsList, row, 2, tostring(data["name"][i]), false, false)
				
			local typeColumn = "Unknown"
			if tonumber(data["type"][i]) == 1 then 
				typeColumn = "Government" 
			elseif tonumber(data["type"][i]) == 2 then 
				typeColumn = "Private" 
			elseif tonumber(data["type"][i]) == 3 then 
				typeColumn = "Criminal" 
			end	
			guiGridListSetItemText(factionsList, row, 3, tostring(typeColumn), false, false)
		end	
			
		-- Buttons
		closeListBtn = guiCreateButton(200, 260, 110, 20, "Close", false, factionsWin)
		addEventHandler("onClientGUIClick", closeListBtn,
		function( button, state )
			if (button == "left" and state == "up") then
				destroyElement(factionsWin)
				factionsWin = nil
				
				showCursor(false)
			end
		end, false)	
		
		showCursor(true)
	else	
		destroyElement(factionsWin)
		factionsWin = nil
		
		showCursor(false)
	end	
end
addEvent("showAllFactions", true)
addEventHandler("showAllFactions", getLocalPlayer(), showAllFactions)

--------- [ Faction Menu ] ---------
local loadedFactionData = false

local teams = { }
local factionMOTD = { }
local factionData = 
{
	["ranks"] = { },
	["wages"] = { }
}

local leader_rank = { }
local isWageColumnPresent = false

local totalMembers = 0
function createFactionUI( playerRank, factionID, factionType, leaderRank, factionBalance )
	if (getData(getLocalPlayer(), "faction") > 0) and (loadedFactionData) then
		
		local factionID = tonumber(factionID)
		local factionType = tonumber(factionType)
		local leaderRank = tonumber(leaderRank)
		local playerRank = tonumber(playerRank)	
		local factionBalance = tonumber(factionBalance)
		
		leader_rank[getLocalPlayer()] = leaderRank
	
		local height, width = 300, 600
		if (playerRank >= leaderRank) then -- If he is a faction leader
			height = 400
		end
		
		local x = (screenX/2) - (width/2)
		local y = (screenY/2) - (height/2)
	
		if not isElement(factionWin) then 
			
			
			local teamName = teams[factionID]
			
			local online = 0
			for key, thePlayer in ipairs ( getElementsByType("player") ) do
				if getPlayerTeam(thePlayer) == getPlayerTeam(getLocalPlayer()) then
					online = online + 1
				end
			end	
			
			factionWin = guiCreateWindow(x, y, width, height, tostring(teamName) .. " ( ".. tostring(online) .."/".. totalMembers .." Players Online )", false)
			guiWindowSetSizable (factionWin, false)
		
			-- Buttons
			local quitY, cancelY, gridHeight = 210, 240, 230
			
			if (playerRank >= leaderRank) then -- He is a faction leader
				
				quitY, cancelY, gridHeight = 310, 340, 330
					
				kickBtn = guiCreateButton(480, 40, 110, 20, "Kick Player", false, factionWin)
				addEventHandler("onClientGUIClick", kickBtn, kickFactionPlayer, false)
					
				inviteBtn = guiCreateButton(480, 70, 110, 20, "Invite Player", false, factionWin)
				addEventHandler("onClientGUIClick", inviteBtn, inviteFactionPlayer, false)
					
				promoteBtn = guiCreateButton(480, 100, 110, 20, "Promote Player", false, factionWin)
				addEventHandler("onClientGUIClick", promoteBtn, promoteFactionPlayer, false)
					
				demoteBtn = guiCreateButton(480, 130, 110, 20, "Demote Player", false, factionWin) 
				addEventHandler("onClientGUIClick", demoteBtn, demoteFactionPlayer, false)
			
				rankChangeBtn = guiCreateButton(480, 160, 110, 20, "Change Ranks", false, factionWin) 
				addEventHandler("onClientGUIClick", rankChangeBtn, changeRanks, false)
				
				motdChangeBtn = guiCreateButton(480, 190, 110, 20, "Change MOTD", false, factionWin) 
				addEventHandler("onClientGUIClick", motdChangeBtn, changeMOTD, false)
				
				if (factionType == 2) or (factionType == 1) then
					lblBalance2 = guiCreateLabel(495, 250, 110, 40, "Bank Balance:", false, factionWin)
					guiSetFont(lblBalance2, "default-bold-small")
					
					local len = string.len(factionBalance)
					local first = math.floor(factionBalance/100)
					
					local last = ""
					if ( len > 1 ) then 
						last = string.sub(factionBalance, len - 1)
					else
						last = "0".. string.sub(factionBalance, len - 1)
					end
					
					lblBalance = guiCreateLabel(497, 265, 110, 40, "$".. tostring(string.format("%07d", first)) ..".".. last, false, factionWin)
					guiSetFont(lblBalance, "default-bold-small")
					
					wageChangeBtn = guiCreateButton(480, 220, 110, 20, "Change Wages", false, factionWin) 
					addEventHandler("onClientGUIClick", wageChangeBtn, changeWages, false) 	
				end	
			end	
				
			quitBtn = guiCreateButton(480, quitY, 110, 20, "Quit Faction", false, factionWin)
			addEventHandler("onClientGUIClick", quitBtn,
			function( )
				destroyElement(factionWin)
				factionWin = nil
				
				triggerServerEvent("quitFaction", getLocalPlayer())
				showCursor(false)
			end, false)	
				
			closeBtn = guiCreateButton(480, cancelY, 110, 20, "Exit", false, factionWin)
			addEventHandler("onClientGUIClick", closeBtn,
			function( )
				destroyElement(factionWin)
				factionWin = nil
				
				showCursor(false)
			end, false)
	
		
			-- MOTD
			lblMOTD = guiCreateLabel(20, height - 25, 560, 40, "MOTD: " .. tostring(factionMOTD[factionID]), false, factionWin)
			guiSetFont(lblMOTD, "default-bold-small")
				
			-- Grid
			membersList = guiCreateGridList(20, 40, 450, gridHeight, false, factionWin)
			guiGridListAddColumn(membersList, "Name", 0.24)
			guiGridListAddColumn(membersList, "Rank", 0.24)
			
			isWageColumnPresent = false
			if (factionType == 1) or (factionType == 2) then
				isWageColumnPresent = true
				wageColumn = guiGridListAddColumn(membersList, "Wage", 0.16)
			end	
			
			lastseenColumn = guiGridListAddColumn(membersList, "Last seen", 0.18)
			statusColumn = guiGridListAddColumn(membersList, "Status", 0.14)
			
			if not isWageColumnPresent then
				guiGridListSetColumnWidth(membersList, 1, 0.30, true)
				guiGridListSetColumnWidth(membersList, 2, 0.30, true)
			end
			
			triggerServerEvent("getFactionInfo", getLocalPlayer())
			
			showCursor(true)
		else 
			destroyElement(factionWin)
			factionWin = nil
			
			showCursor(false)
			guiSetInputEnabled(false)
		end
	end	
end
addEvent("createFactionUI", true)
addEventHandler("createFactionUI", getLocalPlayer(), createFactionUI)

-- Kick Player
function kickFactionPlayer( button, state )
	if ( button == "left" and state == "up" and source == kickBtn ) then
		
		local row = guiGridListGetSelectedItem(membersList)
		if (row ~= -1) then
			
			local memberName = guiGridListGetItemText(membersList, row, 1)
			if (memberName) then
				
				local member = getPlayerFromName(memberName:gsub(" ", "_"))
				if (member ~= getLocalPlayer()) then
				
					triggerServerEvent("removePlayerFromFaction", getLocalPlayer(), memberName)
					guiGridListRemoveRow(membersList, row) -- Remove the row..
				else
					outputChatBox("You cannot kick yourself!", 255, 0, 0)
				end	
			end
		else
			outputChatBox("You need to select a player.", 255, 0, 0)
		end
	end	
end

-- Invite Player
function inviteFactionPlayer( button, state )
	if ( button == "left" and state == "up" and source == inviteBtn ) then
		
		if not isElement(inviteWin) then
			
			local height, width = 100, 260
		
			local x = (screenX/2) - (width/2)
			local y = (screenY/2) - (height/2)
		
			inviteWin = guiCreateWindow(x, y, width, height, "Invite Player", false)
			guiWindowSetSizable (inviteWin, false)
			setElementParent(inviteWin, factionWin)
			
			-- Label
			inviteLbl = guiCreateLabel(10, 30, 90, 20, "Full Player Name:", false, inviteWin)
			
			-- Edit
			inviteEdit = guiCreateEdit(105, 30, 120, 20, "", false, inviteWin)  
			
			-- Buttons
			inviteBtn = guiCreateButton(20, 65, 90, 22, "Invite", false, inviteWin)
			addEventHandler("onClientGUIClick", inviteBtn,
			function( button, state )
				if ( button == "left" and state == "up" and source == inviteBtn ) then
					
					local txt = tostring(guiGetText(inviteEdit))
					if (txt ~= "") then
						
						local thePlayer = getPlayerFromName(txt:gsub(" ", "_"))
						if isElement(thePlayer) then
							
							if (thePlayer ~= getLocalPlayer()) then
								triggerServerEvent("invitePlayerToFaction", getLocalPlayer(), thePlayer)
								
								-- Repopulate it
								guiGridListClear(membersList)
								triggerServerEvent("getFactionInfo", getLocalPlayer())
								
								destroyElement(inviteWin)
								inviteWin = nil
								
								guiSetInputEnabled(false)
							else
								outputChatBox("You cannot invite yourself!", 255, 0, 0)
							end	
						else
							outputChatBox("Couldn't find anyone with that name.", 255, 0, 0)
						end
					else
						outputChatBox("You didn't enter a name.", 255, 0, 0)
					end
				end	
			end, false)
			
			inviteCancelBtn = guiCreateButton(145, 65, 90, 22, "Cancel", false, inviteWin)
			addEventHandler("onClientGUIClick", inviteCancelBtn,
			function( button, state )
				if ( button == "left" and state == "up" and source == inviteCancelBtn ) then
					
					destroyElement(inviteWin)
					inviteWin = nil
					
					guiSetInputEnabled(false)
				end	
			end, false)
			
			guiSetInputEnabled(true)
		end	
	end	
end

-- Promote Player
function promoteFactionPlayer( button, state )
	if ( button == "left" and state == "up" and source == promoteBtn ) then
		
		local row = guiGridListGetSelectedItem(membersList)
		if (row ~= -1) then
			
			local memberName = guiGridListGetItemText(membersList, row, 1)
			local rankName = guiGridListGetItemText(membersList, row, 2)
			if (memberName) and (rankName) then
				
				local nextRank = false
				local factionID = tonumber(getData(getLocalPlayer(), "faction"))
				
				for key, value in pairs ( factionData["ranks"][factionID] ) do
					if tostring(value) == tostring(rankName) then
						
						nextRank = key+1
					end
				end
				
				if nextRank and nextRank <= 15 then
					
					local newRank = factionData["ranks"][factionID][tonumber(nextRank)]
					local newWage = factionData["wages"][factionID][tonumber(nextRank)]
					
					if (newRank) then
						
						guiGridListSetItemText(membersList, row, 2, tostring(newRank), false, false)
						
						if isWageColumnPresent then
							guiGridListSetItemText(membersList, row, wageColumn, tostring(newWage), false, false)
						end	
						
						triggerServerEvent("promoteFactionMember", getLocalPlayer(), memberName, nextRank, newRank)
					else
						outputChatBox("Unable to find new rank!", 255, 0, 0)
					end
				else
					outputChatBox("The Player is already at the highest rank.", 255, 0, 0)
				end
			end
		else
			outputChatBox("You need to select a player.", 255, 0, 0)
		end
	end	
end

-- Demote Player
function demoteFactionPlayer( button, state )
	if ( button == "left" and state == "up" and source == demoteBtn ) then
		
		local row = guiGridListGetSelectedItem(membersList)
		if (row ~= -1) then
			
			local memberName = guiGridListGetItemText(membersList, row, 1)
			local rankName = guiGridListGetItemText(membersList, row, 2)
			if (memberName) and (rankName) then
				
				local nextRank = false
				local factionID = tonumber(getData(getLocalPlayer(), "faction"))
				
				for key, value in pairs ( factionData["ranks"][factionID] ) do
					if tostring(value) == tostring(rankName) then
						
						nextRank = key-1
					end
				end
				
				if nextRank and nextRank >= 1 then
					
					local newRank = factionData["ranks"][factionID][tonumber(nextRank)]
					local newWage = factionData["wages"][factionID][tonumber(nextRank)]
					
					if (newRank) then
						
						guiGridListSetItemText(membersList, row, 2, tostring(newRank), false, false)
						
						if isWageColumnPresent then
							guiGridListSetItemText(membersList, row, wageColumn, tostring(newWage), false, false)
						end	
						
						triggerServerEvent("demoteFactionMember", getLocalPlayer(), memberName, nextRank, newRank)
					else
						outputChatBox("Unable to find new rank!", 255, 0, 0)
					end
				else
					outputChatBox("The Player is already at the lowest rank.", 255, 0, 0)
				end
			end
		else
			outputChatBox("You need to select a player.", 255, 0, 0)
		end
	end	
end

-- Change Ranks
function changeRanks( button, state )
	if ( button == "left" and state == "up" and source == rankChangeBtn ) then
		
		if not isElement(rankChangeWin) then
			
			local height, width = 460, 300
		
			local x = (screenX/2) - (width/2)
			local y = (screenY/2) - (height/2)
		
			rankChangeWin = guiCreateWindow(x, y, width, height, "Change Ranks", false)
			guiWindowSetSizable (rankChangeWin, false)
			setElementParent(rankChangeWin, factionWin)
			
			-- Edits
			local factionID = tonumber(getData(getLocalPlayer(), "faction"))
			
			local ranks = { }
			local editY = 65
			for i = 1, 15 do
				
				ranks[i] = guiCreateEdit(20, editY, 130, 20, tostring(factionData["ranks"][factionID][i]), false, rankChangeWin)
				editY = editY + 25
			end
			
			local lRankEdit = guiCreateEdit(235, 40, 40, 20, tostring(leader_rank[getLocalPlayer()]), false, rankChangeWin)
			
			-- Labels
			guiCreateLabel(20, 40, 60, 20, "Ranks:", false, rankChangeWin)
			guiCreateLabel(160, 40, 70, 20, "Leader Rank:", false, rankChangeWin)
			
			-- Buttons
			rankChangeSave = guiCreateButton(200, 90, 90, 20, "Save", false, rankChangeWin)
			addEventHandler("onClientGUIClick", rankChangeSave,
			function( button, state )
				if ( button == "left" and state == "up" and source == rankChangeSave ) then
					
					local factionID = tonumber(getData(getLocalPlayer(), "faction"))
					
					local editTxts = { }
					for i = 1, 15 do
						editTxts[i] = guiGetText(ranks[i])
					end
					
					local lRankTxt = guiGetText(lRankEdit)
					leader_rank[getLocalPlayer()] = tonumber(lRankTxt) -- update
					
					triggerServerEvent("saveFactionRanks", getLocalPlayer(), editTxts, lRankTxt, factionID)
					
					destroyElement(rankChangeWin)
					rankChangeWin = nil
					
					guiSetInputEnabled(false)
				end
			end, false)
			
			rankChangeCancel = guiCreateButton(200, 115, 90, 20, "Cancel", false, rankChangeWin)
			addEventHandler("onClientGUIClick", rankChangeCancel, 
			function( button, state )
				if ( button == "left" and state == "up" and source == rankChangeCancel ) then
				
					destroyElement(rankChangeWin)
					rankChangeWin = nil
					
					guiSetInputEnabled(false)
				end	
			end, false)	
				
			
			guiSetInputEnabled(true)
		else
			destroyElement(rankChangeWin)
			rankChangeWin = nil
			
			guiSetInputEnabled(false)
		end	
	end
end
	
-- Change Wages
function changeWages( button, state )
	if ( button == "left" and state == "up" and source == wageChangeBtn ) then
		
		if not isElement(wageChangeWin) then
			
			local height, width = 460, 300
		
			local x = (screenX/2) - (width/2)
			local y = (screenY/2) - (height/2)
		
			wageChangeWin = guiCreateWindow(x, y, width, height, "Change Wages", false)
			guiWindowSetSizable (wageChangeWin, false)
			setElementParent(wageChangeWin, factionWin)
			
			-- Edits
			local factionID = tonumber(getData(getLocalPlayer(), "faction"))
			
			local wages = { }
			local editY = 65
			for i = 1, 15 do
				
				wages[i] = guiCreateEdit(20, editY, 130, 20, tostring(factionData["wages"][factionID][i]), false, wageChangeWin)
				editY = editY + 25
			end
			
			-- Labels
			guiCreateLabel(20, 40, 60, 20, "Wages:", false, wageChangeWin)
			
			-- Buttons
			wageChangeSave = guiCreateButton(200, 40, 90, 20, "Save", false, wageChangeWin)
			addEventHandler("onClientGUIClick", wageChangeSave,
			function( button, state )
				if ( button == "left" and state == "up" and source == wageChangeSave ) then
					
					local factionID = tonumber(getData(getLocalPlayer(), "faction"))
					
					local editTxts = { }
					for i = 1, 15 do
						editTxts[i] = guiGetText(wages[i])
					end
					
					triggerServerEvent("saveFactionWages", getLocalPlayer(), editTxts, factionID)
					
					destroyElement(wageChangeWin)
					wageChangeWin = nil
					
					guiSetInputEnabled(false)
				end
			end, false)
			
			wageChangeCancel = guiCreateButton(200, 65, 90, 20, "Cancel", false, wageChangeWin)
			addEventHandler("onClientGUIClick", wageChangeCancel, 
			function( button, state )
				if ( button == "left" and state == "up" and source == wageChangeCancel ) then
				
					destroyElement(wageChangeWin)
					wageChangeWin = nil
					
					guiSetInputEnabled(false)
				end	
			end, false)	
				
			
			guiSetInputEnabled(true)
		else
			destroyElement(wageChangeWin)
			wageChangeWin = nil
			
			guiSetInputEnabled(false)
		end	
	end	
end

-- Update MOTD
function changeMOTD( button, state )
	if ( button == "left" and state == "up" and source == motdChangeBtn ) then
		
		if not isElement(motdWin) then
			
			local height, width = 100, 260
		
			local x = (screenX/2) - (width/2)
			local y = (screenY/2) - (height/2)
		
			local factionID = tonumber(getData(getLocalPlayer(), "faction"))
			
			motdWin = guiCreateWindow(x, y, width, height, "Change MOTD", false)
			guiWindowSetSizable (motdWin, false)
			setElementParent(motdWin, factionWin)
			
			-- Label
			motdLbl = guiCreateLabel(10, 30, 90, 20, "New MOTD:", false, motdWin)
			
			-- Edit
			motdEdit = guiCreateEdit(105, 30, 120, 20, tostring(factionMOTD[factionID]), false, motdWin)  
			
			-- Buttons
			motdBtn = guiCreateButton(20, 65, 90, 22, "Update", false, motdWin)
			addEventHandler("onClientGUIClick", motdBtn,
			function( button, state )
				if ( button == "left" and state == "up" and source == motdBtn ) then
					
					motdText = guiGetText(motdEdit)
				
					triggerServerEvent("saveFactionMOTD", getLocalPlayer(), motdText, factionID)
					
					destroyElement(motdWin)
					motdWin = nil
								
					guiSetInputEnabled(false)
				end	
			end, false)
			
			motdCancelBtn = guiCreateButton(145, 65, 90, 22, "Cancel", false, motdWin)
			addEventHandler("onClientGUIClick", motdCancelBtn,
			function( button, state )
				if ( button == "left" and state == "up" and source == motdCancelBtn ) then
					
					destroyElement(motdWin)
					motdWin = nil
					
					guiSetInputEnabled(false)
				end	
			end, false)
			
			guiSetInputEnabled(true)
		end	
	end	
end
	
local loadedNames = false
local loadedRanksAndWages = false
local loadedMOTD = false

-- NAMES
function storeFactionNames( id, name )

	local id = tonumber(id)
	local name = tostring(name)
	
	teams[id] = name
	
	loadedNames = true
end
addEvent("storeFactionNames", true)
addEventHandler("storeFactionNames", getLocalPlayer(), storeFactionNames)

-- RANKS & WAGES
function storeRanksAndWages( id, ranks, wages )
	
	local id = tonumber(id)
	
	factionData["ranks"][id] = { }
	factionData["wages"][id] = { }
	
	if (tostring(ranks) ~= "") then 
		factionData["ranks"][id] = split(ranks, string.byte(",")) 
	end
	
	if (tostring(wages) ~= "") then
		factionData["wages"][id] = split(wages, string.byte(",")) 
	end
	
	loadedRanksAndWages = true
end
addEvent("storeRanksAndWages", true)
addEventHandler("storeRanksAndWages", getLocalPlayer(), storeRanksAndWages)

function getPlayerWage( factionID, rank )
	for key, value in pairs ( factionData ) do
		if ( key == "wages" ) then
			for index, array in pairs ( factionData[key] ) do
				if ( index == tonumber( factionID ) ) then
				
					return array[tonumber(rank)]
				end
			end
		end
	end	
end

function storeMOTD( id, motd )

	local id = tonumber(id)
	local motd = tostring(motd)
	
	factionMOTD[id] = motd
	
	loadedMOTD = true
end
addEvent("storeMOTD", true)
addEventHandler("storeMOTD", getLocalPlayer(), storeMOTD)

local loadTimer = nil
function isFactionDataLoaded( )
	if ( loadedNames and loadedRanksAndWages and loadedMOTD ) then
		
		loadedFactionData = true
	else
		loadTimer = setTimer(isFactionDataLoaded, 1000, 1)
	end	
end
addEventHandler("onClientResourceStart", resourceRoot, isFactionDataLoaded)

function populateMemberList( data, factionID, factionType )
	local factionID = tonumber(factionID)
	local factionType = tonumber(factionType)
	
	local length = #data["name"]

	local i = 1
	while i <= length do
		
		local rankname = factionData["ranks"][tonumber(factionID)][tonumber(data["rank"][i])]
		local wage = factionData["wages"][tonumber(factionID)][tonumber(data["rank"][i])] -- We can get the wage if we just know the rank ID
		
		local lastseen = tonumber( data["lastseen"][i] )
		local text = nil
		if ( lastseen == 0 ) then
			text = "Today"
		elseif ( lastseen == 1 ) then
			text = "Yesterday"
		else
			text = tostring( lastseen ).." days ago"
		end
		
		local status = { }
		if (data["status"][i] == "Online") then 
			status = { 0, 255, 0 }
		else 
			status = { 255, 0, 0 }
		end 
		
		local row = guiGridListAddRow(membersList)
		
		guiGridListSetItemText(membersList, row, 1, tostring(data["name"][i]), false, false)
		guiGridListSetItemText(membersList, row, 2, tostring(rankname), false, false)
		if (factionType == 1) or (factionType == 2) then -- Government or Private
			guiGridListSetItemText(membersList, row, wageColumn, tostring(wage), false, false)	
		end	
		guiGridListSetItemText(membersList, row, statusColumn, tostring(data["status"][i]), false, false)
		guiGridListSetItemText(membersList, row, lastseenColumn, tostring(text), false, false)
		guiGridListSetItemColor(membersList, row, statusColumn, unpack(status)) 
	
		i = i + 1	
	end

	totalMembers = guiGridListGetRowCount( membersList )
	
	local text = guiGetText( factionWin )
	local find = string.find( text, "/" )
	guiSetText(factionWin, string.sub( text, 1, find ) .. totalMembers .." Players Online )")
end
addEvent("populateMemberList", true)
addEventHandler("populateMemberList", getLocalPlayer(), populateMemberList)

addEventHandler("onClientResourceStart", resourceRoot,
function( res )
	triggerServerEvent("getFactionDetails", localPlayer)
end)