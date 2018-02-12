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

--------- [ Report System ] ---------
local reports = { }

function sendPlayerReport( option, realOption, name, explaination )
	
	local reportID = false
	local i = 1
	while true do
		if (reports[i] == nil) then
			
			reportID = tonumber(i)
			reports[reportID] = { }
			
			break
		end
		
		i = i + 1
	end
	
	if ( not reportID ) then
		
		return
	else	
		reports[reportID][1] = tonumber(option)
		reports[reportID][2] = tostring(name)
		reports[reportID][3] = tostring(explaination)
		reports[reportID][4] = source
		reports[reportID][5] = false
		reports[reportID][6] = tostring(realOption)
		
		for key, thePlayer in ipairs(getElementsByType("player")) do
			
			local loggedin = tonumber(getData(thePlayer, "loggedin"))
			if (loggedin == 1) then
			
				local admin = tonumber(getData(thePlayer, "admin"))
				local adminduty = tonumber(getData(thePlayer, "adminduty"))
				
				if (admin > 0 and adminduty == 1) then
					
					outputChatBox("========= New Report: #".. reportID .." =========", thePlayer, 0, 100, 212)
					outputChatBox("Report from: ".. getPlayerName(source):gsub("_", " "), thePlayer, 0, 100, 212)
					outputChatBox("Regarding: ".. realOption, thePlayer, 0, 100, 212)
					
					if (option == 2) or (option == 3) then
						outputChatBox("Against: ".. name:gsub("_", " "), thePlayer, 0, 100, 212)
					end	
					
					local length = string.len(explaination)
					if (length > 95) then
						explaination = string.sub(explaination, 1, 95)
					end
					
					outputChatBox("Explaination: ".. explaination, thePlayer, 0, 100, 212)
					outputChatBox("===============================", thePlayer, 0, 100, 212)
				end	
			end	
		end
		
		outputChatBox("Your report (#".. reportID ..") has been sent to our Administrators.", source, 0, 255, 0)
		outputChatBox("Please wait till an administrator responds to your report.", source, 0, 255, 0)
	end	
end
addEvent("sendPlayerReport", true)
addEventHandler("sendPlayerReport", root, sendPlayerReport)

-- /ar
function acceptReport( thePlayer, commandName, reportID )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (reportID) then 
			
			local reportID = tonumber(reportID) 
			
			if (reports[reportID] ~= nil) then
				
				if (reports[reportID][5] == false) then
					
					local reporter = reports[reportID][4]
					reports[reportID][5] = thePlayer
					
					for key, val in ipairs(getElementsByType("player")) do
						
						local loggedin = tonumber(getData(val, "loggedin"))
						if (loggedin == 1) then
							
							local admin = tonumber(getData(val, "admin"))
							local adminduty = tonumber(getData(val, "adminduty"))
							
							if (admin > 0 and adminduty == 1) then
								
								outputChatBox(getPlayerName(thePlayer):gsub("_", " ") .." accepted report #".. reportID ..".", val, 212, 156, 49)
							end
						end	
					end	
			
					outputChatBox("Your report (#".. reportID ..") has been accepted by ".. getPlayerName(thePlayer):gsub("_", " ") ..".", reporter, 0, 255, 0)
					outputChatBox("You accepted ".. getPlayerName(reporter):gsub("_", " ") .."'s report (#".. reportID ..")", thePlayer, 0, 255, 0)
					
					local reports = tonumber( getData( thePlayer, "adminreports" ) )
					setData( thePlayer, "adminreports", reports + 1, true )
					
				else
					outputChatBox("This report is already handled by ".. getPlayerName(reports[reportID][5]):gsub("_", " ") ..".", thePlayer, 255, 0, 0)
				end		
			else
				outputChatBox("Invalid report ID.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Report ID]", thePlayer, 212, 156, 49)
		end	
	end
end
addCommandHandler("ar", acceptReport, false, false)
	
-- /cr
function closeReport( thePlayer, commandName, reportID )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (reportID) then 
			
			local reportID = tonumber(reportID) 
			
			if (reports[reportID] ~= nil) then
				
				if (reports[reportID][5] == thePlayer) then
					
					local reporter = reports[reportID][4]
					
					for key, val in ipairs(getElementsByType("player")) do
						
						local loggedin = tonumber(getData(val, "loggedin"))
						if (loggedin == 1) then
							
							local admin = tonumber(getData(val, "admin"))
							local adminduty = tonumber(getData(val, "adminduty"))
						
							if (admin > 0 and adminduty == 1) then
								
								outputChatBox(getPlayerName(thePlayer):gsub("_", " ") .." closed report #".. reportID ..".", val, 212, 156, 49)
							end
						end	
					end	
			
					reports[reportID] = nil
				
					outputChatBox("Your report (#".. reportID ..") has been closed by ".. getPlayerName(thePlayer):gsub("_", " ") ..".", reporter, 0, 255, 0)
					outputChatBox("You closed ".. getPlayerName(reporter):gsub("_", " ") .."'s report (#".. reportID ..")", thePlayer, 0, 255, 0)
					
				else
					outputChatBox("You are not handling this report.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Invalid report ID.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Report ID]", thePlayer, 212, 156, 49)
		end	
	end
end
addCommandHandler("cr", closeReport, false, false)

-- /fr
function falseReport( thePlayer, commandName, reportID )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (reportID) then 
			
			local reportID = tonumber(reportID) 
			
			if (reports[reportID] ~= nil) then
				
				if (reports[reportID][5] == false) then
				
					local reporter = reports[reportID][4]
					
					for key, val in ipairs(getElementsByType("player")) do
						
						local loggedin = tonumber(getData(val, "loggedin"))
						if (loggedin == 1) then
						
							local admin = tonumber(getData(val, "admin"))
							local adminduty = tonumber(getData(val, "adminduty"))
								
							if (admin > 0 and adminduty == 1) then
								
								outputChatBox(getPlayerName(thePlayer):gsub("_", " ") .." marked report #".. reportID .." as false.", val, 212, 156, 49)
							end
						end	
					end	
				
					reports[reportID] = nil
					
					outputChatBox("Your report (#".. reportID ..") has been marked false by ".. getPlayerName(thePlayer):gsub("_", " ") ..".", reporter, 0, 255, 0)
					outputChatBox("You marked ".. getPlayerName(reporter):gsub("_", " ") .."'s report (#".. reportID ..") as false.", thePlayer, 0, 255, 0)
				else
					outputChatBox("This report is already handled by ".. getPlayerName(reports[reportID][5]):gsub("_", " ") ..".", thePlayer, 255, 0, 0)
				end	
			else
				outputChatBox("Invalid report ID.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Report ID]", thePlayer, 212, 156, 49)
		end	
	end				
end
addCommandHandler("fr", falseReport, false, false)

-- /tr
function transferReport( thePlayer, commandName, reportID, partialPlayerName )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (partialPlayerName) and (reportID) then
			
			local reportID = tonumber(reportID) 
			if (reports[reportID] ~= nil) then
				
				if (reports[reportID][5] == thePlayer) then
				
					local reporter = reports[reportID][4]
					
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
							
							if (tonumber(getData(foundPlayer, "admin")) > 0) then
								
								reports[reportID][5] = foundPlayer
								
								outputChatBox("You transferred your report (#".. reportID ..") to ".. getPlayerName(foundPlayer):gsub("_", " ") ..".", thePlayer, 0, 255, 0)
								outputChatBox(getPlayerName(thePlayer):gsub("_", " ") .." transffered his report (#".. reportID ..") to you.", foundPlayer, 0, 255, 0)
								
								outputChatBox("Your report (#".. reportID ..") was transffered to ".. getPlayerName(foundPlayer):gsub("_", " ") ..".", reporter, 0, 255, 0)
								
								local reports = tonumber( getData( thePlayer, "adminreports" ) )
								setData( thePlayer, "adminreports", reports - 1, true )
								
								local reports = tonumber( getData( foundPlayer, "adminreports") )
								setData( foundPlayer, "adminreports", reports + 1, true )
							else
								outputChatBox(getPlayerName(foundPlayer):gsub("_", " ") .." is not an admin.", thePlayer, 255, 0, 0)
							end
						end
					end
				else
					outputChatBox("You are not handling this report.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Invalid report ID.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Report ID]", thePlayer, 212, 156, 49)
		end	
	end				
end	
addCommandHandler("tr", transferReport, false, false)
	
-- /rd
function reportDetails( thePlayer, commandName, reportID )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		if (reportID) then 
			
			local reportID = tonumber(reportID) 
			
			if (reports[reportID] ~= nil) then
				
				local reporter = reports[reportID][4]
				local handler = reports[reportID][5]
				if ( handler == false ) then
					handler = "None"
				else
					handler = getPlayerName(handler):gsub("_", " ")
				end
				
				local against = reports[reportID][2]
				local explaination = reports[reportID][3]
				local realOption = reports[reportID][6]
				
				outputChatBox("========= Report #".. reportID .." =========", thePlayer, 0, 100, 212)
				outputChatBox("Report from: ".. getPlayerName(reporter):gsub("_", " "), thePlayer, 0, 100, 212)
				outputChatBox("Handled by: ".. handler, thePlayer, 0, 100, 212)
				outputChatBox("Regarding: ".. realOption, thePlayer, 0, 100, 212)
				
				local option = nil
				if (realOption == "Rule Violation") then
					option = 2
				elseif (realOption == "Hacking") then
					option = 3
				end
				
				if (option == 2) or (option == 3) then
					outputChatBox("Against: ".. against:gsub("_", " "), thePlayer, 0, 100, 212)
				end	
					
				local length = string.len(explaination)
				if (length > 95) then
					explaination = string.sub(explaination, 1, 95)
				end
			
				outputChatBox("Explaination: ".. explaination, thePlayer, 0, 100, 212)
				outputChatBox("==========================", thePlayer, 0, 100, 212)
			else
				outputChatBox("Invalid report ID.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("SYNTAX: /".. commandName .." [Report ID]", thePlayer, 212, 156, 49)
		end	
	end
end	
addCommandHandler("rd", reportDetails, false, false)
	
-- /reports
function listReports( thePlayer, commandName )
	if getData(thePlayer, "loggedin") == 1 and exports['[ars]global']:isPlayerTrialModerator(thePlayer) then
		
		outputChatBox("========= Current Reports =========", thePlayer, 0, 100, 212)
		
		local count = 0
		for i = 1, #reports do
			
			if (reports[i] ~= nil) then
			
				local id = i
				local from = reports[i][4]
				local regarding = reports[i][6]
			
				outputChatBox("~-~-~-~-~ Report #".. id .." ~-~-~-~-~", thePlayer, 0, 100, 212) 
				outputChatBox("From: ".. getPlayerName(from):gsub("_", " "), thePlayer, 0, 100, 212)
				outputChatBox("Regarding: ".. regarding, thePlayer, 0, 100, 212)
				outputChatBox("~-~-~-~-~-~-~-~-~-~-~-~-~-~-~", thePlayer, 0, 100, 212)
			end	
			
			i = i + 1
			count = count + 1
		end	
		
		if (count == 0) then
			outputChatBox("No active reports.", thePlayer, 0, 100, 212)
		end
	end		
end
addCommandHandler("reports", listReports, false, false)

addEventHandler("onPlayerQuit", root,
function( )
	
	for key, value in pairs(reports) do
		if (value[4] == source) then
			
			if (value[5] ~= false) then
				outputChatBox("Report #".. key .." has been closed, ".. getPlayerName(source):gsub("_", " ") .." has left.", value[5], 212, 156, 49)
			end
			
			reports[key] = nil
		elseif (value[5] == source) then
			
			outputChatBox("The administrator handling your report (#".. key ..") has left, please re-submit your report.", value[4], 212, 156, 49)
			reports[key] = nil
		end
	end
end)	