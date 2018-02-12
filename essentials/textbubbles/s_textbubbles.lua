local showtime = 6000
local characteraddition = 50
local maxbubbles = 6
if maxbubbles == "false" then maxbubbles = false else maxbubbles = tonumber(maxbubbles) end
local hideown = "false"
if hideown == "true" then hideown = true else hideown = false end

function sendMessageToClient(message,messagetype)
	if not wasEventCancelled() then
		if messagetype == 0 or messagetype == 2 then
			triggerClientEvent("onChatbubblesMessageIncome",source,message,messagetype)
		end
	end
end

function returnSettings()
	local settings =
	{
	showtime,
	characteraddition,
	maxbubbles,
	hideown
	}
	triggerClientEvent(source,"onBubbleSettingsReturn",getRootElement(),settings)
end

addEventHandler("onPlayerChat",getRootElement(),sendMessageToClient)
addEvent("onAskForBubbleSettings",true)
addEventHandler("onAskForBubbleSettings",getRootElement(),returnSettings)