function logAdminCommand( text )
	local text = tostring( text )
	
	local exists = fileExists("admin.txt")
	if ( exists ) then
		local file = fileOpen("admin.txt")
		
		local size = fileGetSize( file )
		fileSetPos( file, size )
    
		local write = fileWrite( file, "[".. getTimeStamp( ) .."] ".. text .."\r\n" )
		if ( write ) then
			
			fileFlush( file )
			fileClose( file )
		end	
	else
		local file = fileCreate("admin.txt")
		if ( file ) then
			fileWrite( file, "FILE CREATED - ".. getTimeStamp( ) .."\r\n" )
			
			fileFlush( file )
			fileClose( file )
			
			logAdminCommand( text )
		end	
	end	
end

function getTimeStamp( )
	local hour = getRealTime().hour
	local minute = getRealTime().minute
	local second = getRealTime().second
	
	local monthday = getRealTime().monthday
	local month = (getRealTime().month) + 1
	local year = (getRealTime().year) + 1900
	
	local timestamp = tostring(year) .."-".. tostring(string.format("%02d", month)) .."-".. tostring(string.format("%02d", monthday)) .." ".. tostring(string.format("%02d", hour)) ..":".. tostring(string.format("%02d", minute)) ..":".. tostring(string.format("%02d", second))
	
	return timestamp
end