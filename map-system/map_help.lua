--/SETINTERIOR
function setInterior(thePlayer, commandName, interiorId)
	if (exports['[ars]global']:isPlayerTrialModerator(thePlayer)) then
		if (interiorId) then
			setElementInterior(thePlayer, tonumber(interiorId))
			outputChatBox("Interior set to: "..interiorId, thePlayer, 212, 156, 49)
		else
			outputChatBox("SYNTAX: /"..commandName.." [interior id]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("setinterior", setInterior, false, false)

--/SETDIMENSION
function setDimension(thePlayer, commandName, dimensionId)
	if (exports['[ars]global']:isPlayerTrialModerator(thePlayer)) then
		if (dimensionId) then
			setElementDimension(thePlayer, tonumber(dimensionId))
			outputChatBox("Dimension set to: "..dimensionId, thePlayer, 212, 156, 49)
		else
			outputChatBox("SYNTAX: /"..commandName.." [dimension id]", thePlayer, 212, 156, 49)
		end
	end
end
addCommandHandler("setdimension", setDimension, false, false)