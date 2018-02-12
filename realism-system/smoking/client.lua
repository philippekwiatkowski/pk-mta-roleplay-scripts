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

--------- [ Smoking System ] ---------	

function renderCigarette( )
	
	for key, thePlayer in ipairs( getElementsByType("player") ) do
		
		if ( getData( thePlayer, "smoking_true") == 1 ) then
			
			local color = nil
			local thing = tonumber( getData(thePlayer, "smoking_thing") )
			
			if ( thing == 1 ) then -- Cigarette
				color = tocolor(254, 232, 214)
			elseif ( thing == 2 ) then -- Marijuana
				color = tocolor(223, 255, 165)
			end
			
			local bypass = 0
			if ( getData( thePlayer, "smoking_lefthand") == 1 ) then -- Left hand
				
				bypass = 10
			end
			
			A = {getPedBonePosition(thePlayer, 25+bypass)}
			B = {getPedBonePosition(thePlayer, 24+bypass)}
			C = {2*A[1] - B[1], 2*A[2] - B[2], 2*A[3] - B[3]}
			D = {getPedBonePosition(thePlayer, 26+bypass)}
			
			A[1] = (A[1]+D[1])/2
			A[2] = (A[2]+D[2])/2
			A[3] = (A[3]+D[3])/2
			
			AC = { (C[1]-A[1])*1.5, (C[2]-A[2])*1.5, (C[3]-A[3])*1.25}
			
			dxDrawLine3D(A[1], A[2], A[3], A[1]+(AC[1]*17/18), A[2]+(AC[2]*17/18), A[3]+(AC[3]*17/18), color, 1.25)
			
			dxDrawLine3D(A[1]+(AC[1]*(17/18)), A[2]+(AC[2]*(17/18)), A[3]+(AC[3]*(17/18)), A[1]+AC[1], A[2]+AC[2], A[3]+AC[3], tocolor(178,32,32), 1.25) -- Burning
		end
	end
end
addEventHandler("onClientPreRender", root, renderCigarette)