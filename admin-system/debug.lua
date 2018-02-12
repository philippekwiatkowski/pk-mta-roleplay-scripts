--------- [ Element Data returns ] ---------
local function getData( theElement, key )
	local key = tostring(key)
	if isElement(theElement) and (key) then
		
		return exports['anticheat-system']:c_callData( theElement, tostring(key) )
	else
		return false
	end
end	

local function setData( theElement, key, value )
	local key = tostring(key)
	local value = tonumber(value) or tostring(value)
	if isElement(theElement) and (key) and (value) then
		
		return exports['anticheat-system']:c_assignData( theElement, tostring(key), value )
	else
		return false
	end	
end

--------- [ Debugscript Security ] ---------
local exceptions = { }
exceptions["mat290"] = true
exceptions["Phil"] = true

addEventHandler("onClientRender", root,
	function( )
		if ( isDebugViewActive( ) ) then
			
			local username = tostring( getData( localPlayer, "accountname" ) )
			if ( username == nil ) then	
				
			--	triggerServerEvent("remoteKick", localPlayer, "Unauthorized Command")
			else	
				
				local find = false
				for key, value in pairs ( exceptions ) do	
					if ( key == username ) then
						
						find = true
						break
					end
				end
				
				if ( not find ) then
					
				--	triggerServerEvent("remoteKick", localPlayer, "Unauthorized Command")
				end
			end	
		end
	end
)	