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
	if isElement(theElement) and (key) and (value) then
		
		return exports['[ars]anticheat-system']:c_assignData( theElement, tostring(key), value, sync )
	else
		return false
	end	
end

--------- [ Advertisement ] ---------
local adEmployee = createPed(192, 1539.3232, -2471.2031, 13.6776, 275)
setElementInterior(adEmployee, 3)
setElementDimension(adEmployee, 37)

addEventHandler("onClientClick", root, 
	function( button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
		
		if ( getData(getLocalPlayer(), "loggedin") == 1 and not isElement(advertWindow) ) then
			
			if (button == "right" and state == "up") then
				
				if (clickedElement) and (clickedElement == adEmployee) then
				
					advertisementUI( )
				end	
			end
		end
	end
)	

function advertisementUI( )
	local width, height = 400, 150
	local x, y = (screenX/2) - (width/2), (screenY/2) - (height/2)
	
	advertWindow = guiCreateWindow(x, y, width, height, "Place an advertisement", false)
	
	advertHelpLabel = guiCreateLabel(20, 30, 350, 40, "Please write down your advertisement here, we'll send\nit on air soon. ( $10 per advertisement )", false, advertWindow)
	
	advertEdit = guiCreateEdit(20, 70, 350, 20, "", false, advertWindow)
	guiEditSetMaxLength( advertEdit, 92 )
	
	local buttonSend = guiCreateButton(50, 110, 110, 20, "Send", false,  advertWindow)
	addEventHandler("onClientGUIClick", buttonSend,
		function ( button, state )
			
			local money = tonumber( getPlayerMoney( localPlayer )/100 )
			if ( money >= 10 ) then
				
				local advert = guiGetText( advertEdit )
				if ( string.len( advert ) > 0 ) then
					
					setTimer(
						function( )
							triggerServerEvent("sendAdvertisement", localPlayer, advert)
						end, 10000, 1
					)	
					
					triggerServerEvent("giveMoneyToSan", localPlayer, 10)
					
					destroyElement(advertWindow)
					guiSetInputEnabled(false)
					
					outputChatBox("Your advertisement has been sent.", 0, 255, 0)
				else
					outputChatBox("You didn't enter any advertisement.", 255, 0, 0)
				end	
			else
				outputChatBox("You do not have enough money.", 255, 0, 0)
			end	
		end
	)
	
	local buttonCancel = guiCreateButton(230, 110, 110, 20, "Cancel", false,  advertWindow)
	addEventHandler("onClientGUIClick", buttonCancel,
		function ( button, state )
			
			destroyElement(advertWindow)
			guiSetInputEnabled(false)
		end
	)
	
	guiSetFont(advertHelpLabel, "clear-normal")
	guiSetInputEnabled(true)
end
