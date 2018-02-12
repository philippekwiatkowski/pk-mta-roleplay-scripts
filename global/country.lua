--[[
## ## ## ## ## ## ## ## 
Author: Timic
Modified by: Dev
## ## ## ## ## ## ## ## 
]]--

local countries = { } 

function getPlayerCountry ( player, getCountryName )
	return getPlayerCountryByIP( getPlayerIP( player ), getCountryName )
end

function getPlayerCountryByIP( ip, getCountryName )
	if ( ip ) then
		local ip = tostring( ip )
		
		local ipGroup = tonumber ( gettok ( ip, 1, 46 ) )
		local ipCode = ( gettok ( ip, 1, 46 ) * 16777216 ) + ( gettok ( ip, 2, 46 ) * 65536 ) + ( gettok ( ip, 3, 46 ) * 256 ) + ( gettok ( ip, 4, 46 ) )
		
		if ( #countries == 0 ) then
			loadIPGroups( )
		end
		
		if ( not countries[ipGroup] ) then
			countries[ipGroup] = { }
		end
		
		for key, group in ipairs ( countries[ipGroup] ) do
			if ( group.rstart <= ipCode ) and ( ipCode <= group.rend ) then
				
				if ( getCountryName ) then
					return getCountryNameByCode( group.rcountry )
				else
					return group.rcountry
				end	
			end
		end
		
		return false
	end	
end

function loadIPGroups( )
	unrelPosReset( )

	local hReadFile = fileOpen( "conf/IpToCountryCode.csv", true )
	if ( not hReadFile ) then
		return
	end

	local buffer = ""
	while true do
		local endpos = string.find(buffer, "\n")

		if not endpos then
			if fileIsEOF( hReadFile ) then
				break
			end
			buffer = buffer .. fileRead( hReadFile, 500 )
		end

		if ( endpos ) then
		
			local line = string.sub(buffer, 1, endpos - 1)
			buffer = string.sub(buffer, endpos + 1)

			local parts = split( line, string.byte(",") )
			if ( #parts > 2 ) then
			
				local rstart = tonumber(parts[1])
				local rend = tonumber(parts[2])
				local rcountry = parts[3]

				rstart = unrelRange ( rstart )
				rend = unrelRange ( rend )

				local group = math.floor( rstart / 0x1000000 )

				if ( not countries[group] ) then
					countries[group] = { }
				end
				
				local count = #countries[group] + 1
				countries[group][count] = {}
				countries[group][count].rstart = rstart
				countries[group][count].rend = rend
				countries[group][count].rcountry = rcountry
			end
		end
	end

	fileClose( hReadFile )
end

local relPos = 0
function relPosReset( )
	relPos = 0
end
function relRange( v )
	local rel = v - relPos
	relPos = v
	return rel
end

local unrelPos = 0
function unrelPosReset( )
	unrelPos = 0
end

function unrelRange( v )
	local unrel = v + unrelPos
	unrelPos = unrel
	return unrel
end

function getCountryNameByCode( countryCode )
	if ( countryCode ) then
	
		local countryCode = tostring( countryCode )
		
		local file = xmlLoadFile("conf/countryCodeToCountryName.xml")
		local list = xmlFindChild(file, "list", 0)
		local countries = xmlNodeGetChildren(list)
		
		for key, node in ipairs (countries) do    

			local code = tostring( xmlNodeGetAttribute( node, "code") )
			if ( code == countryCode ) then
				
				return xmlNodeGetAttribute( node, "name")
			end
		end
		
		return false
	end
end	