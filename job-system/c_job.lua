local screenX, screenY = guiGetScreenSize( )

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

--------- [ Job Employee ] ---------
local employee = nil
function createEmployee( res )
	employee = createPed(141, 359.7158, 173.5800, 1008.3893)
	
	setPedRotation(employee, 270)
	setElementInterior(employee, 3)
	setElementDimension(employee, 313)
	
	setPedAnimation( employee, "ped", "SEAT_idle", -1, true, false, false)
end
addEventHandler("onClientResourceStart", resourceRoot, createEmployee)

--------- [ Job Access ] ---------
function onEmployeeClick(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if (getData(getLocalPlayer(), "loggedin") == 1) and (not isElement(jobWindow)) then
		
		if (button == "right" and state == "up") then
			
			if (clickedElement) and (clickedElement == employee) then
				
				local license = tonumber( getData(localPlayer, "d:license") )
				if ( license == 1 ) then
					showJobUI( )
				else
					outputChatBox("You don't have a driving license.", 255, 0, 0)
				end	
			end	
		end
	end
end
addEventHandler("onClientClick", root, onEmployeeClick) 

--------- [ Job System ] ---------
function showJobUI( )
	jobWidth, jobHeight = 460, 240
	jobX, jobY = (screenX/2) - (jobWidth/2), (screenY/2) - (jobHeight/2)
	
	-- Elements
	jobWindow = guiCreateWindow(jobX, jobY, jobWidth, jobHeight, "Government Jobs' list", false)
		
	if (getData(localPlayer, "job") == 0) then 
		
		welcomeLbl = guiCreateLabel(20, 30, 420, 20, "Welcome, this is the list of the current available Government jobs.", false, jobWindow)
		
		jobList = guiCreateGridList(20, 60, 420, 120, false, jobWindow)
		guiGridListAddColumn(jobList, "Job", 0.55)
		guiGridListAddColumn(jobList, "Depot", 0.4)
		
		local rows = { }
		
		local i = 1
		while i <= 4 do
			rows[i] = guiGridListAddRow(jobList)
			
			i = i + 1
		end
		
		guiGridListSetItemText(jobList, rows[1], 1, "Bus Driver", false, false)
		guiGridListSetItemText(jobList, rows[1], 2, "City Transport, Madison Ave.", false, false)
		guiGridListSetItemText(jobList, rows[2], 1, "Taxi Driver", false, false)
		guiGridListSetItemText(jobList, rows[2], 2, "City Transport, Madison Ave.", false, false)
		guiGridListSetItemText(jobList, rows[3], 1, "Road Sweeper", false, false)
		guiGridListSetItemText(jobList, rows[3], 2, "Lincoln Ave.", false, false)
		guiGridListSetItemText(jobList, rows[4], 1, "Oil Transporter", false, false)
		guiGridListSetItemText(jobList, rows[4], 2, "Oil Refinery, Interstate 7", false, false)
		
		buttonAccept = guiCreateButton(32.5, 190, 110, 30, "Accept", false, jobWindow)
		addEventHandler("onClientGUIClick", buttonAccept,
		function( button, state )
			if ( button == "left" and state == "up" ) then
				
				local row = guiGridListGetSelectedItem(jobList)
				if (row ~= -1) then
					
					local job = guiGridListGetItemText(jobList, row, 1)
					triggerServerEvent("setPlayerJob", localPlayer, job)
					
					destroyElement(jobWindow)
					jobWindow = nil
				else
					playSoundFrontEnd(32)
				end	
			end
		end, false)
		
		buttonCancel = guiCreateButton(317.5, 190, 110, 30, "Cancel", false, jobWindow)
		addEventHandler("onClientGUIClick", buttonCancel,
		function( button, state )
			if ( button == "left" and state == "up" ) then
				
				destroyElement(jobWindow)
				jobWindow = nil
			end
		end, false)
		
		guiSetFont(welcomeLbl, "clear-normal")
	elseif (getData(localPlayer, "job") > 0) then 
		
		guiSetSize(jobWindow, 460, 160, false)
		guiSetText(jobWindow, "Quit Job")
		
		local hour = getTime( )
		local greet = ""
		
		if (hour == 12 or hour == 13 or hour == 14 or hour == 15) then
			greet = "Afternoon"
		end
		
		if (hour == 16 or hour == 17 or hour == 18 or hour == 19 or hour == 20 or hour == 21 or hour == 22 or hour == 23 or hour == 00 or hour == 01 or hour == 02 or hour == 03) then
			greet = "Evening"
		end
		
		if (hour == 04 or hour == 05 or hour == 06 or hour == 07 or hour == 08 or hour == 09 or hour == 10 or hour == 11) then
			greet = "Morning"
		end	
		
		questionLbl = guiCreateLabel(20, 30, 420, 20, " ".. greet ..", are you willing to quit your current public service job?", false, jobWindow)
		
		buttonYes = guiCreateButton(32.5, 105, 120, 30, "Yes", false, jobWindow)
		addEventHandler("onClientGUIClick", buttonYes,
		function( button, state )
			if ( button == "left" and state == "up" ) then
				
				triggerServerEvent("removePlayerJob", localPlayer)
				
				destroyElement(jobWindow)
				jobWindow = nil
			end
		end, false)
		
		buttonNo = guiCreateButton(317.5, 105, 120, 30, "No", false, jobWindow)
		addEventHandler("onClientGUIClick", buttonNo,
		function( button, state )
			if ( button == "left" and state == "up" ) then
				
				destroyElement(jobWindow)
				jobWindow = nil
			end
		end, false)
		
		guiSetFont(questionLbl, "clear-normal")
	end
end	