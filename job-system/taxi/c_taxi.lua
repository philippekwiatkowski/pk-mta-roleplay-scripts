--[[
local timer = nil
local distance, money, cost = "0.00", 0, 5

--------- [ Server Calls ] ---------
function startTaxiMeter( )
	drawTaxiMeter( )
	calculateDistance( )
end
addEvent("startTaxiMeter", true)
addEventHandler("startTaxiMeter", localPlayer, startTaxiMeter)

function stopTaxiMeter( )
	removeTaxiMeter( )
	
	if isTimer(timer) then
		killTimer(timer)
	end	
	
	outputChatBox("Distance: ".. tostring(tonumber(math.floor(distance))) .." KM", 212, 156, 49)
	outputChatBox("Cost: $".. tostring(cost), 212, 156, 49)
	
	distance, money, cost = "0.00", 0, 5
end
addEvent("stopTaxiMeter", true)
addEventHandler("stopTaxiMeter", localPlayer, stopTaxiMeter)

--------- [ Taxi Job ] ---------
function drawTaxiMeter( )
	local screenX, screenY = guiGetScreenSize( )
	local startX, startY = screenX - screenX, screenY - screenY
	
	taxiMeter = guiCreateLabel( startX + 50, screenY - 230, 200, 20, "K-METER: 0.00", false) 
	moneyMeter = guiCreateLabel( startX + 50, screenY - 210, 200, 20, "BALANCE: $0", false)
	
	guiLabelSetColor(taxiMeter, 200, 0, 0)
	guiLabelSetColor(moneyMeter, 200, 0, 0)
	
	local font = guiCreateFont("taxi/crysta.ttf", 15)
	
	guiSetFont(taxiMeter, font)
	guiSetFont(moneyMeter, font)
end

function removeTaxiMeter( )
	if (taxiMeter) then
		
		destroyElement(taxiMeter)
		destroyElement(moneyMeter)
		
		taxiMeter = nil
		moneyMeter = nil
	end
end

function getVehicleSpeed( vehicle )
	local veloX, veloY, veloZ = getElementVelocity(vehicle)
	local speed = (veloX^2 + veloY^2 + veloZ^2)^(0.5) 
	
	return speed*180
end
	
function calculateDistance( )
	local vehicle = getPedOccupiedVehicle(localPlayer)
	
	timer = setTimer(
	function( ) 
		local speed = getVehicleSpeed(vehicle)
		local time = 0.00002777777777777778 -- = 0.1 s 
		
		distance = tonumber(distance)
		
		distance = distance + (speed*time)
		if (tostring(distance) == "0") then
			distance = "0.00"
		end
		
		guiSetText(taxiMeter, "K-METER: ".. string.sub(distance, 0, 4))
		
		money = cost*math.floor(distance)
		guiSetText(moneyMeter, "BALANCE: $".. money)
	end, 100, 0)
]]--	
--end