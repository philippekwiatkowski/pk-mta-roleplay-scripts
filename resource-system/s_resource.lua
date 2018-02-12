--------- [ Element Data returns ] ---------
local function getData( theElement, key )
	local key = tostring(key)
	if isElement(theElement) and (key) then
		
		return exports['[ars]anticheat-system']:callData( theElement, tostring(key) )
	else
		return false
	end
end	

--------- [ Resource System ] ---------
local function output( console, text, baseElement )
	if ( console == true ) then
		outputServerLog(tostring(text))
	else
		outputChatBox(tostring(text), baseElement, 0, 255, 0)
	end
end	

-- /startres
function resourceStart( thePlayer, commandName, resourceName )
	local console = nil
	local baseElement = nil
	
	if (getElementType(thePlayer) == "console") then
		baseElement = false
		console = true
	else
		baseElement = thePlayer
		console = false
	end	
	
	if resourceName then
	
		local resourceVirtualName = resourceName
		
		local resourceName = "[ars]".. tostring(resourceName)
		local resource = getResourceFromName(resourceName)
		
		if resource then
		
			local state = getResourceState(resource)
			if state == "loaded" then
				
				if ( baseElement == false ) then
					
					local success = startResource(resource)
					if (success) then
						
						output(console, "Resource '".. resourceVirtualName .."' started.", baseElement)
					else	
						output(console, "Resource '".. resourceVirtualName .."' could not be started.", baseElement)
					end	
				else	
					if ( exports['[ars]global']:isPlayerHighAdministrator(baseElement) or exports['[ars]global']:isPlayerScripter(baseElement) ) or ( tostring( getData(baseElement, "accountname" ) ) == "tajiri" and resourceVirtualName == "map-system" ) then
						
						local success = startResource(resource)
						if (success) then
							output(console, "Resource '".. resourceVirtualName .."' started.", baseElement)
						else	
							output(console, "Resource '".. resourceVirtualName .."' could not be started.", baseElement)
						end	
					end
				end
					
			elseif state == "running" then
			
				output(console, "Resource '".. resourceVirtualName .."' is already running.", baseElement)
			elseif state == "starting" then
				
				output(console, "Resource '".. resourceVirtualName .."' is starting...", baseElement)
			end	
		else	
			output(console, "No such resource as '".. resourceVirtualName .."' found.", baseElement)
		end
	else
		output(console, "SYNTAX: /".. commandName .." [ Resource ]", baseElement)
	end
end
addCommandHandler("startres", resourceStart, false, false)

-- /stopres
function resourceStop( thePlayer, commandName, resourceName )
	local console = nil
	local baseElement = nil
	
	if (getElementType(thePlayer) == "console") then
		baseElement = false
		console = true
	else
		baseElement = thePlayer
		console = false
	end	
	
	if resourceName then
	
		local resourceVirtualName = resourceName
		
		local resourceName = "[ars]".. tostring(resourceName)
		local resource = getResourceFromName(resourceName)
		
		if resource then
		
			local state = getResourceState(resource)
			if state == "running" then
				
				if ( baseElement == false ) then
					
					local success = stopResource(resource)
					if (success) then
						
						output(console, "Resource '".. resourceVirtualName .."' stopped.", baseElement)
					else	
						output(console, "Resource '".. resourceVirtualName .."' could not be stopped.", baseElement)
					end	
				else	
					if ( exports['[ars]global']:isPlayerHighAdministrator(baseElement) or exports['[ars]global']:isPlayerScripter(baseElement) ) or ( tostring( getData(baseElement, "accountname" ) ) == "tajiri" and resourceVirtualName == "map-system" ) then
						
						local success = stopResource(resource)
						if (success) then
							output(console, "Resource '".. resourceVirtualName .."' stopped.", baseElement)
						else	
							output(console, "Resource '".. resourceVirtualName .."' could not be stopped.", baseElement)
						end	
					end
				end
				
			elseif state == "loaded" or state == "stopping" or state == "failed to load" then
				output(console, "Resource '".. resourceVirtualName .."' is not running.", baseElement)
			end	
		else	
			output(console, "No such resource as '".. resourceVirtualName .."' found.", baseElement)
		end
	else
		output(console, "SYNTAX: /".. commandName .." [ Resource ]", baseElement)
	end
end
addCommandHandler("stopres", resourceStop, false, false)	

-- /restartres
function resourceRestart( thePlayer, commandName, resourceName )
	local console = nil
	local baseElement = nil
	
	if (getElementType(thePlayer) == "console") then
		baseElement = false
		console = true
	else
		baseElement = thePlayer
		console = false
	end	
	
	if resourceName then
	
		local resourceVirtualName = resourceName
		
		local resourceName = "[ars]".. tostring(resourceName)
		local resource = getResourceFromName(resourceName)
		
		if resource then
		
			local state = getResourceState(resource)
			if state == "running" then
				
				if ( baseElement == false ) then
					
					local success = restartResource(resource)
					if (success) then
						output(console, "Resource '".. resourceVirtualName .."' restarted.", baseElement)
					else	
						output(console, "Resource '".. resourceVirtualName .."' could not be restarted.", baseElement)
					end	
						
				else	
					if ( exports['[ars]global']:isPlayerHighAdministrator(baseElement) or exports['[ars]global']:isPlayerScripter(baseElement) ) or ( tostring( getData(baseElement, "accountname" ) ) == "tajiri" and resourceVirtualName == "map-system" ) then
						
						local success = restartResource(resource)
						if (success) then
						
							output(console, "Resource '".. resourceVirtualName .."' restarted.", baseElement)
						else	
							output(console, "Resource '".. resourceVirtualName .."' could not be restarted.", baseElement)
						end	
					end
				end
				
			elseif state == "stopping" or state == "loaded" or state == "failed to load" then
			
				output(console, "Resource '".. resourceVirtualName .."' is not running.", baseElement)
			elseif state == "starting" then
				
				output(console, "Resource '".. resourceVirtualName .."' is starting...", baseElement)
			end	
		else	
			output(console, "No such resource as '".. resourceVirtualName .."' found.", baseElement)
		end
	else
		output(console, "SYNTAX: /".. commandName .." [ Resource ]", baseElement)
	end
end
addCommandHandler("restartres", resourceRestart, false, false)	

-- /refreshres 
function resourceRefresh( thePlayer, commandName )
	local console = nil
	local baseElement = nil
	
	if (getElementType(thePlayer) == "console") then
		baseElement = false
		console = true
	else
		baseElement = thePlayer
		console = false
	end	

	if ( baseElement == false ) then
		
		local success = refreshResources(true)
		if (success) then
		
			output(console, "Refreshed all resources!.", baseElement)
		else
			output(console, "Could not refresh resources!.", baseElement)
		end
		
	else	
		if ( exports['[ars]global']:isPlayerHighAdministrator(baseElement) or exports['[ars]global']:isPlayerScripter(baseElement) ) or ( tostring( getData(baseElement, "accountname" ) ) == "tajiri" ) then
			
			local success = refreshResources(true)
			if (success) then
				output(console, "Refreshed all resources!", baseElement)
			else
				output(console, "Could not refresh resources!.", baseElement)	
			end
		end
	end
end
addCommandHandler("refreshres", resourceRefresh, false, false)	