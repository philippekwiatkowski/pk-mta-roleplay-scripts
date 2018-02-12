--[[
	SuperGlue v.1.0.0
	
	By John_Michael
	
	:server.lua - handles the actual "attatchment" of elements.
]]

function handleGlueRequest(slaveElement, masterElement, xOffset, yOffset, zOffset, xRotOffset, yRotOffset, zRotOffset, pedWeaponSlot, isHeli)
	attachElements(slaveElement, masterElement, xOffset, yOffset, zOffset, xRotOffset, yRotOffset, zRotOffset)
	if isHeli then
		setElementData(masterElement, "glueParent", slaveElement)
	else
		setElementData(slaveElement, "glueParent", masterElement)
	end
	if pedWeaponSlot then
		setPedWeaponSlot(source, pedWeaponSlot)
	end
	if getElementType(slaveElement) == "player" or getElementType(slaveElement) == "ped" then
		addEventHandler("onPlayerWasted", slaveElement, function() handleUnglueRequest(slaveElement, masterElement) end)
	end
	outputChatBox("You have been glued to a vehicle!", source, 255, 255, 0)
end
addEvent("clientRequestElementAttachment", true)
addEventHandler("clientRequestElementAttachment", root, handleGlueRequest)

function handleUnglueRequest(slaveElement, masterElement, isHeli)
	detachElements(slaveElement, masterElement)
	if isHeli then
		removeElementData(masterElement, "glueParent")
	else
		removeElementData(slaveElement, "glueParent")
	end
	if source then
		outputChatBox("You have been un-glued from the vehicle!", source, 255, 255, 0)
	end
	if getElementType(slaveElement) == "ped" then
		removeEventHandler("onPlayerWasted", slaveElement, function() handleUnglueRequest(slaveElement, masterElement) end)
	end
end
addEvent("clientRequestElementDetachment", true)
addEventHandler("clientRequestElementDetachment", root, handleUnglueRequest)
	