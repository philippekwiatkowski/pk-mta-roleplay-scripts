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

local trailers = { }
local playerDetached = { }
local detachTimer = { }

--------- [ Tanker Job ] ---------
function onTrailerSpawn( )
	for key, value in ipairs ( getElementsByType("vehicle" ) ) do
		if ( getElementModel( value ) == 514 ) then
			
			playerDetached[value] = false
		end	
	end
end
addEventHandler("onResourceStart", resourceRoot, onTrailerSpawn)

function onEnterTanker( vehicle, seat )
	if (getData(vehicle, "job") == 4 and getData(source, "job") ~= 4) then
		
		removePedFromVehicle(source)
	elseif (getData(vehicle, "job") == 4 and getData(source, "job") == 4) then
	
		if (seat == 0) then
			
			outputChatBox("Type /jobhelp if you need help regarding your job!", source, 0, 255, 0)
		
			if (getData(vehicle, "engine") == 0) then
				outputChatBox("Press J to start the vehicle's engine.", source, 231, 60, 128)
			end
			
			local trailer = trailers[vehicle]
			if ( trailer ~= nil ) then
				
				playerDetached[vehicle] = true
				triggerClientEvent(source, "startTankerJob", source)
			else
				outputChatBox("You need to attach a trailer to your truck in order to begin you job.", source, 212, 156, 49)
			end
		end
	end	
end
addEventHandler("onPlayerVehicleEnter", root, onEnterTanker)

function onExitTanker( vehicle, seat )
	if (getData(vehicle, "job") == 4 and getData(source, "job") == 4) then
		
		if (seat == 0) then
			
			local trailer = trailers[vehicle]
			if ( trailer ~= nil ) then
				
				playerDetached[vehicle] = false
				triggerClientEvent(source, "endTankerJob", source)	
			end	
		end
	end
end	
addEventHandler("onPlayerVehicleExit", root, onExitTanker)

function onAttachTrailer( theTanker )
	if ( getData( theTanker, "job") == 4 ) then
		
		local thePlayer = getVehicleController( theTanker )
		if ( getData(thePlayer, "job") == 4) then
			
			local wasDetachedByPlayer = playerDetached[theTanker]
			
			if ( not wasDetachedByPlayer ) then
				playerDetached[theTanker] = true
				trailers[theTanker] = source
				
				triggerClientEvent(thePlayer, "startTankerJob", thePlayer)
			else
				outputChatBox("You attached your trailer before time, now head to your destination.", thePlayer, 212, 156, 49)
				
				local timer = detachTimer[theTanker]
				if isTimer( timer ) then
					killTimer( timer )
				end	
			end	
		end	
	end	
end
addEventHandler("onTrailerAttach", root, onAttachTrailer)

function onDetachTrailer( theTanker )
	if ( getData( theTanker, "job") == 4 ) then
		
		local thePlayer = getVehicleController( theTanker )
		if ( thePlayer ) then
			if ( getData(thePlayer, "job") == 4) then
				
				local wasDetachedByPlayer = playerDetached[theTanker]
				local trailer = trailers[theTanker]
				
				if ( wasDetachedByPlayer ) then
					
					outputChatBox("You have only 30 seconds to re-attach your trailer before your job ends.", thePlayer, 212, 156, 49)
					
					detachTimer[theTanker] = setTimer(
						function( )
							triggerEvent("respawnRemoteVehicle", thePlayer, trailer )
							trailers[theTanker] = nil
							
							playerDetached[theTanker] = false
							triggerClientEvent(thePlayer, "endTankerJob", thePlayer)
						end, 30000, 1
					)
				end	
			end	
		else
			local theTrailer = source
			
			setTimer( 
				function( )
					triggerEvent("respawnRemoteVehicle", root, theTrailer )
					trailers[theTanker] = nil
				
					playerDetached[theTanker] = false
				end, 3000, 1
			)	
		end	
	end	
end
addEventHandler("onTrailerDetach", root, onDetachTrailer)
	
function explodeTrailer( )
	if ( getElementModel( source ) == 584 ) then -- Trailer
		
		for key, value in pairs ( trailers ) do
			if ( value == source ) then
			
				trailers[key] = nil
			end
		end
		
		return
	elseif ( getElementModel( source ) == 514 ) then -- Tanker
		
		if ( trailers[source] ~= nil ) then
			
			trailers[source] = nil
		end	
	end	
end
addEventHandler("onVehicleExplode", root, explodeTrailer)
	
--------- [ Callbacks ] ---------
function payTankerDriver( amount )
	if ( amount ) then
		givePlayerMoney( source, amount * 100 )
		triggerEvent("takeMoneyFromGovernment", source, amount)
	end	
end
addEvent("payTankerDriver", true)
addEventHandler("payTankerDriver", root, payTankerDriver)	

--------- [ Exports ] ---------
function isTrailerAttached( theTrailer )
	if ( theTrailer ) then
		
		local isAttached = false
		for key, value in pairs ( trailers ) do
			if ( value == theTrailer ) then
				
				isAttached = true
				break
			end
		end

		return isAttached
	end
end

function hasTrailerAttached( theTanker )
	if ( theTanker ) then
		
		local hasAttached = false
		for key, value in pairs ( trailers ) do
			if ( key == theTanker ) then
				
				hasAttached = true
				break
			end
		end

		return hasAttached
	end
end