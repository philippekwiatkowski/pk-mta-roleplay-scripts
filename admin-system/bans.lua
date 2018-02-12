local ips =
    {
		"208.110.69.200", -- yamaha
		"92.83.114.235", -- yamaha 2
		"109.96.*.*", -- yamaha rangeban
		"92.83.*.*", -- yamaha rangeban 2
		"68.119.201.191", -- matthew ello
		"68.119.192.184", -- matthew ello 2
		"68.119.192.161", -- matthew ello 3
		"68.119.*.*", -- matthew ello rangeban

		"173.168.242.143", -- 2dope
		"173.168.*.*", -- 2dope rangeban 1
		"74.115.*.*", -- 2dope rangeban 2
        "74.115.0.*.*", -- 2dope rangeban 3
		"173.168.*.*", -- 2dope rangeban 4
		"62.163.148.45", -- Jesseunit
		"62.163.*.*" -- Jesseunit rangeban
		
		
    }
     
    local serials =
    {
		"7DF09B4B3D2D729FCF69C9E7C348A4E4", -- matthew ello
		"401F3B7508DD40F71FB5E35EF8538702", -- 2Dope comp 1
        "14FE9A27983EB2D63C47060CE8E33C62", -- 2Dope comp 2
		"2B4C10CB63D29C22C2AF2519AD10FB52" -- Jesseunit's PC
    }
     
    addEventHandler ("onPlayerConnect", getRootElement(),
        function(playerNick, playerIP, playerUsername, playerSerial, playerVersion)
            for _, v in pairs(ips ) do
                if string.find( playerIP, "^" .. v .. "$" ) then
                    cancelEvent( true, "You are banned from this server." )
                end
            end
           
            for _, v in pairs( serials ) do
                if (playerSerial == v) then
                    outputDebugString("found ".. v)
                    cancelEvent( true, "You are banned from this server." )
                end
            end
        end
    )