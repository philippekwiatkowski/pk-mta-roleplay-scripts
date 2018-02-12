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

--------- [ Report System ] ---------
function showReportUI( )
	if ( not isElement(reportWin) ) then
	
		local reportWidth, reportHeight = 400, 300
		local reportX, reportY = (screenX/2) - (reportWidth/2), (screenY/2) - (reportHeight/2)
		
		reportWin = guiCreateWindow(reportX, reportY, reportWidth, reportHeight, "Report System", false)
		
		nameLbl = guiCreateLabel(20, 30, 350, 20, "Name of person you are reporting (Or just your name):", false, reportWin)
		nameEdit = guiCreateEdit(20, 50, 350, 20, "", false, reportWin)
		
		typeLbl = guiCreateLabel(20, 80, 100, 20, "Type of report:", false, reportWin)
		
		options = { }
		options[1] = guiCreateCheckBox(120, 80, 125, 20, "Administration Help", true, false, reportWin)
		options[2] = guiCreateCheckBox(260, 80, 115, 20, "Rule Violation", false, false, reportWin)
		options[3] = guiCreateCheckBox(120, 100, 80, 20, "Hacking", false, false, reportWin)
		options[4] = guiCreateCheckBox(260, 100, 80, 20, "Refunding", false, false, reportWin)
		
		addEventHandler("onClientGUIClick", options[1], selectOption, false) 
		addEventHandler("onClientGUIClick", options[2], selectOption, false) 
		addEventHandler("onClientGUIClick", options[3], selectOption, false) 
		addEventHandler("onClientGUIClick", options[4], selectOption, false) 

		
		explainLbl = guiCreateLabel(20, 130, 100, 20, "Explaination:", false, reportWin)
		explainMemo = guiCreateMemo(120, 130, 260, 100, "", false, reportWin)
		
		buttonReport = guiCreateButton(40, 245, 110, 30, "Report", false, reportWin)
		addEventHandler("onClientGUIClick", buttonReport,
		function( button, state )
			if ( button == "left" and state == "up" ) then
				
				local option = nil
				for key, value in ipairs (options) do
					if (guiCheckBoxGetSelected(value)) then
						
						option = key
						break
					end
				end	
				
				local realOption = ""
				if (option == 1) then
					realOption = "Administration Help"
				elseif (option == 2) then
					realOption = "Rule Violation"
				elseif (option == 3) then
					realOption = "Hacking"
				elseif (option == 4) then
					realOption = "Refunding"
				end

				local playerName = guiGetText(nameEdit)
				local explaination = guiGetText(explainMemo)
				
				triggerServerEvent("sendPlayerReport", localPlayer, option, realOption, playerName, explaination)
				
				destroyElement(reportWin)
				reportWin = nil
				
				guiSetInputEnabled(false)
			end
		end, false)	
		
		buttonCancel = guiCreateButton(240, 245, 110, 30, "Cancel", false, reportWin)
		addEventHandler("onClientGUIClick", buttonCancel,
		function( button, state )
			if ( button == "left" and state == "up" ) then
				
				destroyElement(reportWin)
				reportWin = nil
				
				guiSetInputEnabled(false)
			end
		end, false)	
		
		guiSetFont(nameLbl, "clear-normal")
		guiSetFont(typeLbl, "clear-normal")
		guiSetFont(explainLbl, "clear-normal")
		
		guiSetInputEnabled(true)
	else
		destroyElement(reportWin)
		reportWin = nil
	
		guiSetInputEnabled(false)
	end			
end

function selectOption( button, state )
	if ( button == "left" and state == "up" ) then
		
		guiCheckBoxSetSelected(source, true)
		
		for key, value in ipairs (options) do
			if (value ~= source) then
			
				guiCheckBoxSetSelected(value, false)
			end
		end	
	end
end


addEventHandler("onClientResourceStart", getResourceRootElement( ),
function( res )
	bindKey("F2", "down", showReportUI)
end)