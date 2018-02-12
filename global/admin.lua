function isPlayerTrialModerator( thePlayer )
	if exports['[ars]anticheat-system']:callData( thePlayer, "admin") >= 1 then
		
		return true
	else
		return false
	end	
end	

function isPlayerModerator( thePlayer )
	if exports['[ars]anticheat-system']:callData( thePlayer, "admin") >= 2 then
		
		return true
	else
		return false
	end	
end	

function isPlayerHighModerator( thePlayer )
	if exports['[ars]anticheat-system']:callData( thePlayer, "admin") >= 3 then
		
		return true
	else
		return false
	end	
end	

function isPlayerAdministrator( thePlayer )
	if exports['[ars]anticheat-system']:callData( thePlayer, "admin") >= 4 then
		
		return true
	else
		return false
	end	
end	

function isPlayerHighAdministrator( thePlayer )
	if exports['[ars]anticheat-system']:callData( thePlayer, "admin") >= 5 then
		
		return true
	else
		return false
	end	
end

local scripters = { ["Dev"] = true, ["Phil"] = true, ["mat290"] = true }
function isPlayerScripter( thePlayer )
	if scripters[ tostring( exports['[ars]anticheat-system']:callData( thePlayer, "accountname") ) ] then
		return true
	else
		return false
	end	
end	

function getPlayerAdminTitle( thePlayer )
	if exports['[ars]anticheat-system']:callData( thePlayer, "admin") == 1 then
		
		return "Trial Moderator"
	elseif exports['[ars]anticheat-system']:callData( thePlayer, "admin") == 2 then
		
		return "Moderator"
	elseif exports['[ars]anticheat-system']:callData( thePlayer, "admin") == 3 then
		
		return "High Moderator"
	elseif exports['[ars]anticheat-system']:callData( thePlayer, "admin") == 4 then
		
		return "Administrator"
	elseif exports['[ars]anticheat-system']:callData( thePlayer, "admin") == 5 then
		
		return "High Administrator"
	elseif exports['[ars]anticheat-system']:callData( thePlayer, "admin") == 6 then
		
		return "Sub-Owner"
	elseif exports['[ars]anticheat-system']:callData( thePlayer, "admin") == 7 then
		
		return "Server Owner"
	else
		return "Player"
	end
end

function getPlayerAdminLevel( thePlayer )
	return exports['[ars]anticheat-system']:callData( thePlayer, "admin")
end	

function onlineAdmins( thePlayer, commandName )
	
	local admins = { }
	admins["Trial-Moderator"] = { }
	admins["Moderator"] = { }
	admins["High-Moderator"] = { }
	admins["Administrator"] = { }
	admins["High-Administrator"] = { }
	admins["Sub-Owner"] = { }
	admins["Server-Owner"] = { }
	
	for k, player in ipairs ( getElementsByType("player") ) do
		
		local adminlevel = tonumber( exports['[ars]anticheat-system']:callData( player, "admin") )
		local loggedin = tonumber( exports['[ars]anticheat-system']:callData( player, "loggedin" ) )
		
		if ( adminlevel ~= nil and adminlevel > 0 ) and ( loggedin ~= 0 ) then
			
			if adminlevel == 1 then
				table.insert(admins["Trial-Moderator"], player)
			elseif adminlevel == 2 then	
				table.insert(admins["Moderator"], player)
			elseif adminlevel == 3 then	
				table.insert(admins["High-Moderator"], player)
			elseif adminlevel == 4 then	
				table.insert(admins["Administrator"], player)
			elseif adminlevel == 5 then	
				table.insert(admins["High-Administrator"], player)
			elseif adminlevel == 6 then	
				table.insert(admins["Sub-Owner"], player)
			elseif adminlevel == 7 then	
				table.insert(admins["Server-Owner"], player)
			end	
		end	
	end
	
	local count = 0
	outputChatBox("~~~ Online Staff: ~~~", thePlayer, 212, 156, 49)
	
	-- Server Owner
	for iOwner = 1, #admins["Server-Owner"] do
		local Owner = admins["Server-Owner"][iOwner]
		
		local r, g, b = nil, nil, nil
		local duty = "(Off Duty)"
		if ( exports['[ars]anticheat-system']:callData( Owner, "adminduty") == 1 ) then
			r, g, b = 212, 156, 49
			duty = "(On Duty)"
		end	
		
		local username = ""
		if ( exports['[ars]anticheat-system']:callData( thePlayer, "admin" ) > 0 ) then
			username = "[".. tostring( exports['[ars]anticheat-system']:callData( Owner, "accountname" ) ) .."] "
		end
		
		local hiddenShow = true
		if ( exports['[ars]anticheat-system']:callData( Owner, "hiddenadmin" ) == 1 ) then
			
			if ( exports['[ars]anticheat-system']:callData( thePlayer, "admin" ) == 0 ) then
				hiddenShow = false
			end
		end
		
		if ( hiddenShow ) then
			
			outputChatBox(username .."".. exports['[ars]global']:getPlayerAdminTitle(Owner) .." ".. getPlayerName(Owner):gsub("_", " ") .." ".. duty, thePlayer, r, g, b)
			count = count + 1
		end	
	end
	
	-- Sub-Owner
	for iSubOwner = 1, #admins["Sub-Owner"] do
		local SubOwner = admins["Sub-Owner"][iSubOwner]
		
		local r, g, b = nil, nil, nil
		local duty = "(Off Duty)"
		if exports['[ars]anticheat-system']:callData( SubOwner, "adminduty") == 1 then
			r, g, b = 212, 156, 49
			duty = "(On Duty)"
		end	
		
		local username = ""
		if ( exports['[ars]anticheat-system']:callData( thePlayer, "admin" ) > 0 ) then
			username = "[".. tostring( exports['[ars]anticheat-system']:callData( SubOwner, "accountname" ) ) .."] "
		end
		
		local hiddenShow = true
		if ( exports['[ars]anticheat-system']:callData( SubOwner, "hiddenadmin" ) == 1 ) then
			
			if ( exports['[ars]anticheat-system']:callData( thePlayer, "admin" ) == 0 ) then 
				hiddenShow = false
			end
		end
		
		if ( hiddenShow ) then
			
			outputChatBox(username .."".. exports['[ars]global']:getPlayerAdminTitle(SubOwner) .." ".. getPlayerName(SubOwner):gsub("_", " ") .." ".. duty, thePlayer, r, g, b)
			count = count + 1
		end	
	end
	
	-- High Administrators
	for iHighAdmin = 1, #admins["High-Administrator"] do
		local HighAdmin = admins["High-Administrator"][iHighAdmin]
		
		local r, g, b = nil, nil, nil
		local duty = "(Off Duty)"
		if exports['[ars]anticheat-system']:callData( HighAdmin, "adminduty") == 1 then
			r, g, b = 212, 156, 49
			duty = "(On Duty)"
		end	
		
		local username = ""
		if ( exports['[ars]anticheat-system']:callData( thePlayer, "admin" ) > 0 ) then
			username = "[".. tostring( exports['[ars]anticheat-system']:callData( HighAdmin, "accountname" ) ) .."] "
		end
		
		local hiddenShow = true
		if ( exports['[ars]anticheat-system']:callData( HighAdmin, "hiddenadmin" ) == 1 ) then
			
			if ( exports['[ars]anticheat-system']:callData( thePlayer, "admin" ) == 0 ) then
				hiddenShow = false
			end
		end
		
		if ( hiddenShow ) then
			
			outputChatBox(username .."".. exports['[ars]global']:getPlayerAdminTitle(HighAdmin) .." ".. getPlayerName(HighAdmin):gsub("_", " ") .." ".. duty, thePlayer, r, g, b)
			count = count + 1
		end	
	end
		
	-- Administrators
	for iAdministrator = 1, #admins["Administrator"] do
		local Administrator = admins["Administrator"][iAdministrator]
		
		local r, g, b = nil, nil, nil
		local duty = "(Off Duty)"
		if exports['[ars]anticheat-system']:callData( Administrator, "adminduty") == 1 then
			r, g, b = 212, 156, 49
			duty = "(On Duty)"
		end	
		
		local username = ""
		if ( exports['[ars]anticheat-system']:callData( thePlayer, "admin" ) > 0 ) then
			username = "[".. tostring( exports['[ars]anticheat-system']:callData( Administrator, "accountname" ) ) .."] "
		end
		
		local hiddenShow = true
		if ( exports['[ars]anticheat-system']:callData( Administrator, "hiddenadmin" ) == 1 ) then
			
			if ( exports['[ars]anticheat-system']:callData( thePlayer, "admin" ) == 0 ) then 
				hiddenShow = false
			end
		end
		
		if ( hiddenShow ) then
			
			outputChatBox(username .."".. exports['[ars]global']:getPlayerAdminTitle(Administrator) .." ".. getPlayerName(Administrator):gsub("_", " ") .." ".. duty, thePlayer, r, g, b)
			count = count + 1
		end	
	end
	
	-- High Moderators
	for iHighMod = 1, #admins["High-Moderator"] do
		local HighMod = admins["High-Moderator"][iHighMod]
		
		local r, g, b = nil, nil, nil
		local duty = "(Off Duty)"
		if exports['[ars]anticheat-system']:callData( HighMod, "adminduty") == 1 then
			r, g, b = 212, 156, 49
			duty = "(On Duty)"
		end	
		
		local username = ""
		if ( exports['[ars]anticheat-system']:callData( thePlayer, "admin" ) > 0 ) then
			username = "[".. tostring( exports['[ars]anticheat-system']:callData( HighMod, "accountname" ) ) .."] "
		end
		
		local hiddenShow = true
		if ( exports['[ars]anticheat-system']:callData( HighMod, "hiddenadmin" ) == 1 ) then
			
			if ( exports['[ars]anticheat-system']:callData( thePlayer, "admin" ) == 0 ) then
				hiddenShow = false
			end
		end
		
		if ( hiddenShow ) then
		
			outputChatBox(username .."".. exports['[ars]global']:getPlayerAdminTitle(HighMod) .." ".. getPlayerName(HighMod):gsub("_", " ") .." ".. duty, thePlayer, r, g, b)
			count = count + 1
		end	
	end
		
	-- Moderators
	for iModerator = 1, #admins["Moderator"] do
		local Moderator = admins["Moderator"][iModerator]
		
		local r, g, b = nil, nil, nil
		local duty = "(Off Duty)"
		if exports['[ars]anticheat-system']:callData( Moderator, "adminduty") == 1 then
			r, g, b = 212, 156, 49
			duty = "(On Duty)"
		end	
		
		local username = ""
		if ( exports['[ars]anticheat-system']:callData( thePlayer, "admin" ) > 0 ) then
			username = "[".. tostring( exports['[ars]anticheat-system']:callData( Moderator, "accountname" ) ) .."] "
		end
		
		local hiddenShow = true
		if ( exports['[ars]anticheat-system']:callData( Moderator, "hiddenadmin" ) == 1 ) then
			
			if ( exports['[ars]anticheat-system']:callData( thePlayer, "admin" ) == 0 ) then
				hiddenShow = false
			end
		end
		
		if ( hiddenShow ) then
		
			outputChatBox(username .."".. exports['[ars]global']:getPlayerAdminTitle(Moderator) .." ".. getPlayerName(Moderator):gsub("_", " ") .." ".. duty, thePlayer, r, g, b)
			count = count + 1
		end	
	end

	-- Trial Moderators
	for iTrialMod = 1, #admins["Trial-Moderator"] do
		local TrialMod = admins["Trial-Moderator"][iTrialMod]
		
		local r, g, b = nil, nil, nil
		local duty = "(Off Duty)"
		if exports['[ars]anticheat-system']:callData( TrialMod, "adminduty") == 1 then
			r, g, b = 212, 156, 49
			duty = "(On Duty)"
		end	
		
		local username = ""
		if ( exports['[ars]anticheat-system']:callData( thePlayer, "admin" ) > 0 ) then
			username = "[".. tostring( exports['[ars]anticheat-system']:callData( TrialMod, "accountname" ) ) .."] "
		end
		
		local hiddenShow = true
		if ( exports['[ars]anticheat-system']:callData( TrialMod, "hiddenadmin" ) == 1 ) then
			
			if ( exports['[ars]anticheat-system']:callData( thePlayer, "admin" ) == 0 ) then 
				hiddenShow = false
			end
		end
		
		if ( hiddenShow ) then
			
			outputChatBox(username .."".. exports['[ars]global']:getPlayerAdminTitle(TrialMod) .." ".. getPlayerName(TrialMod):gsub("_", " ") .." ".. duty, thePlayer, r, g, b)
			count = count + 1
		end	
	end
	
	if ( count == 0 ) then
		outputChatBox("No staff online at the moment.", thePlayer)
	end
end
addCommandHandler("admins", onlineAdmins, false, false)
addCommandHandler("staff", onlineAdmins, false, false)