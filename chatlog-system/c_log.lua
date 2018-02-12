local xmlFile = nil
local xmlNode = nil
local yearday, hour

--

local function openFile( )
	local time = getRealTime( )
	yearday = time.yearday
	hour = time.hour
	local fileName = ( "logs/%04d-%02d-%02d/%02d.html" ):format( time.year + 1900, time.month + 1, time.monthday, time.hour )
	
	xmlFile = xmlLoadFile( fileName )
	if not xmlFile then
		-- create the basic layout
		xmlFile = xmlCreateFile( fileName, "html" )
		local head = xmlCreateChild( xmlFile, "head" )
		local title = xmlCreateChild( head, "title" )
		xmlNodeSetValue( title, ( "Bone County Roleplay :: Client Logs :: %04d-%02d-%02d" ):format( time.year + 1900, time.month + 1, time.monthday ) )
		
		local style = xmlCreateChild( head, "style" )
		xmlNodeSetAttribute( style, "type", "text/css" )
		xmlNodeSetValue( style, "body { font-family: Tahoma; font-size: 0.8em; background: #000000; }  p { padding: 0; margin: 0; } .v1 { color: #AAAAAA; } .v2 { color: #DDDDDD; } .v3 { white-space:pre; }" )
		
		--
		
		xmlNode = xmlCreateChild( xmlFile, "body" )
		xmlSaveFile( xmlFile )
	else
		xmlNode = xmlFindChild( xmlFile, "body", 0 )
	end
end

local function closeFile( )
	if xmlFile then
		xmlUnloadFile( xmlFile )
		xmlFile = nil
		xmlNode = nil
	end
end

local function xmlNodeSetValue2( a, b )
	if b:match "^%s*(.-)%s*$" == "" then
		return xmlDestroyNode( a )
	else
		return xmlNodeSetValue( a, b )
	end
end

addEventHandler( "onClientChatMessage", getRootElement( ),
	function( message, r, g, b )
		local time = getRealTime( )
		if not xmlFile or not xmlNode then
			openFile( )
		elseif time.yearday ~= yearday or time.hour ~= hour then
			closeFile( )
			openFile( )
		end
		
		local node = xmlCreateChild( xmlNode, "p" )
		
		--
		local nodeDate = xmlCreateChild( node, "span" )
		xmlNodeSetValue( nodeDate, ( "%04d-%02d-%02d" ):format( time.year + 1900, time.month + 1, time.monthday ) )
		xmlNodeSetAttribute( nodeDate, "class", "v1" )
		
		local nodeTime = xmlCreateChild( node, "span" )
		xmlNodeSetValue( nodeTime, ( "%02d:%02d:%02d" ):format( time.hour, time.minute, time.second ) )
		xmlNodeSetAttribute( nodeTime, "class", "v2" )

		
		local t = { }
		local prevcolor = ("#%02x%02x%02x"):format( r, g, b )
		while true do
			local a, b = message:find("#%x%x%x%x%x%x")
			local t = xmlCreateChild( node, "span" )
			xmlNodeSetAttribute( t, "class", "v3" )
			if a and b then
				xmlNodeSetAttribute( t, "style", "color:" .. prevcolor )
				xmlNodeSetValue2( t, message:sub( 1, a - 1 ) )
				prevcolor = message:sub( a, b )
				message = message:sub( b + 1 )
			else
				xmlNodeSetAttribute( t, "style", "color:" .. prevcolor )
				xmlNodeSetValue2( t, message )
				break
			end
		end
		
		xmlSaveFile( xmlFile )
	end
)

addEventHandler( "onClientResourceStart", getResourceRootElement( ),
	function( )
		openFile( )
	end
)

addEventHandler( "onClientResourceStop", getResourceRootElement( ),
	function( )
		closeFile( )
	end
)