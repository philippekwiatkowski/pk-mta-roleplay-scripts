--------- [ Element Data returns ] ---------
local function getData( theElement, key )
	local key = tostring(key)
	if isElement(theElement) and (key) then
		
		return exports['[ars]anticheat-system']:c_callData( theElement, tostring(key) )
	else
		return false
	end
end	

--------- [ Commands ] ---------
local generalCmds = 
{
	[1] = 
		{
			{"/ar", "Accept a report"},
			{"/cr", "Close a report"},
			{"/fr", "Mark a report as false"},
			{"/tr", "Transfer a report to another admin"},
			{"/rd", "Details of a report"},
			{"/reports", "List all active reports"},
			{"/freconnect", "Force reconnect a player"}, 
			{"/tpto", "Teleport to a plater"}, 
			{"/tphere", "Teleport a player to you"}, 
			{"/send", "Send a player to someone"}, 
			{"/tptoplace", "Teleport to a specific place"}, 
			{"/pmute", "Mute a player"}, 
			{"/adminduty", "Go on/off adminduty"}, 
			{"/watch", "Watch a player"}, 
			{"/pkick", "Kick a player"}, 
			{"/pban", "Ban a player"}, 
			{"/jail", "Jail a player"},
			{"/unjail", "Unjail a player"}, 
			{"/jailed", "See all the jailed players"}, 
			{"/warn", "Warn a player"},
			{"/freeze", "Freeze a player"}, 
			{"/unfreeze", "Unfreeze a player"}, 
			{"/disappear", "Become Invisible"}, 
			{"/tognametag", "Toggle your nametag"},
			{"/checkinv", "Check a player's inventory"},
			{"/sethp", "Set a player's health"},
			{"/setarmor", "Set a player's armor"},
			{"/setskin", "Set a player's skin"},
			{"/slap", "Slap a player"},
			{"/giveitem", "Give an item to a player"},
			{"/takeitem", "Take an item from a player"},
			{"/disarm", "Take all guns from a player"},
			{"/hugeslap", "Hugeslap a player"},
			{"/x", "Sets your x-position"},
			{"/y", "Sets your y-position"},
			{"/z", "Sets your z-position"},
			{"/allchars", "List all characters of a player"},
			{"/allaccs", "List all accounts of a player"}
		},
		
	[2] = { },
		
	[3] = { },
	
	[4] =
		{
			{"/givegun", "Give a gun to a player"},
			{"/setmotd", "Set the Message of the Day"},
			{"/changename", "Change a player's name"},
			{"/hideadmin", "Be a hidden admin"},
			{"/unban", "Unban a player"},
			{"/setmoney", "Set a player's money"},
			{"/givemoney", "Give money to a player"},
			{"/makedon", "Make a player a donator"},
			{"/unwarn", "Unwarn a player"}
		},
	
	[5] =
		{
			{"/makeadmin", "Make a player an administrator"},
			{"/setamotd", "Set the Admin Message of the Day"}
		}		
}

local vehicleCmds =
{
	[1] = 
		{
			{"/veh", "Create a Temporary civ. vehicle"},
			{"/fixveh", "Repair a vehicle"},
			{"/refillveh", "Refuel a vehicle"},
			{"/unflip", "Unflip a vehicle"},
			{"/tpcar", "Teleport a vehicle to you"},
			{"/tptocar", "Teleport to a vehicle"},
			{"/delveh", "Delete a vehicle"},
			{"/respawnvehs", "Respawn all vehicles"}, 
			{"/respawncivvehs", "Respawn all civilian vehicles"}, 
			{"/respawnveh", "Respawn a vehicle"},
			{"/nearbyvehs", "List nearby vehicles"}
			
		},
		
	[2] =
		{
			{"/fixvehs", "Fix all vehicles"},
			{"/setcarhp", "Set a vehicle's health"},
			{"/addupgrade", "Add an upgrade to a vehicle"},
			{"/setvehcolor", "Sets a vehicle's color"},
			{"/makeveh", "Create a Permanent vehicle"},
			{"/makecivveh", "Create a Permanent civ. vehicle"}
			
		},
		
	[3] = { },
		
	[4] = { },
	
	[5] = { }
}

local factionCmds = 
{
	[1] = { },
	[2] = { },
		
	[3] = 
		{
			{"/showfactions", "Show all factions"},
			{"/setfaction", "Set a player to a faction"},
			{"/setvehfaction", "Sets the vehicle owned by your faction"}
			
			
		},
		
	[4] = 
		{
			{"/makefaction", "Make a faction"},
			{"/delfaction", "Delete a faction"},
			{"/setfactionleaderrank", "Set a faction's leader rank"},
			{"/setfactionid", "Change a faction's ID"},
			{"/setfactionname", "Change a faction's name"}			
			
		},
		
	[5] = { } 	
}	

local shopCmds = 
{
	[1] = { },

	[2] = 
		{ 
			{"/createshop", "Create a shop"},
			{"/delshop", "Delete a shop"},
			{"/nearbyshop", "List nearby shops"}
		},	
	
	[3] = { },	
	
	[4] = { },
	
	[5] = { }
}

local interiorCmds =
{
	[1] = 
	{
		{"/nearbyinteriors", "List nearby interiors"},
		{"/tptointerior", "Teleport to an interior"}
	},
	
	[2] = { },

	[3] = { },

	[4] =
		{
			{"/makeinterior", "Create an interior"},
			{"/delinterior", "Delete an interior"},
			{"/setinteriorname", "Rename an interior"},
			{"/setinteriorprice", "Set an interior's price"},
			{"/setinteriortype", "Set an interiors' Type"},
			{"/setinteriorid", "Set an interior's ID"}
		},

	[5] = { }	
}		

local screenX, screenY = guiGetScreenSize( )
function createCommandList(	)
	if ( exports['[ars]global']:c_isPlayerTrialModerator( localPlayer ) ) then
		
		local adminLevel = tonumber( getData( localPlayer, "admin") )
		if ( adminLevel > 5 ) then
			adminLevel = 5
		end
		
		local width, height = 440, 340
		local x = (screenX/2) - (width/2)
		local y = (screenY/2) - (height/2)
		
		if ( not isElement( commandWin ) ) then
		
			commandWin = guiCreateWindow(x, y, width, height, "Admin Commands' List", false)
			
			commandPanel = guiCreateTabPanel(20, 26, 400, 250, false, commandWin)
			
			local commandTab = { }
			commandTab[1] = guiCreateTab("General", commandPanel)
			commandTab[2] = guiCreateTab("Vehicle", commandPanel)
			commandTab[3] = guiCreateTab("Faction", commandPanel)
			commandTab[4] = guiCreateTab("Shop", commandPanel)
			commandTab[5] = guiCreateTab("Interior", commandPanel)
			
			for i = 1, 5 do
				local gridList = guiCreateGridList(10, 10, 380, 200, false, commandTab[i])
				guiGridListAddColumn(gridList, "Command", 0.4)
				guiGridListAddColumn(gridList, "Description", 0.5)
				
				local t = nil
				if ( i == 1 ) then
					t = generalCmds
				elseif ( i == 2 ) then
					t = vehicleCmds
				elseif ( i == 3 ) then
					t = factionCmds
				elseif ( i == 4 ) then
					t = shopCmds
				else
					t = interiorCmds
				end
				
				populateGridList(t, adminLevel, gridList)
			end	
			
		
			btnClose = guiCreateButton(165, 290, 110, 30, "Close", false, commandWin)
			addEventHandler("onClientGUIClick", btnClose, 
			function( )
				if isElement(commandWin) then
					
					destroyElement(commandWin)
					commandWin = nil
					
					showCursor(false)
				end
			end, false)
			
			showCursor(true)
		else
			destroyElement(commandWin)
			commandWin = nil
			
			showCursor(false)
		end
	end	
end	
addCommandHandler("acmds", createCommandList, false, false) 
addCommandHandler("admincmds", createCommandList, false, false) 		

function populateGridList( t, adminLevel, gridList )	
	for j = 1, adminLevel do
		
		for i = 1, #t[j] do
			local row = guiGridListAddRow(gridList)
		
			guiGridListSetItemText(gridList, row, 1, tostring(t[j][i][1]), false, false)
			guiGridListSetItemText(gridList, row, 2, tostring(t[j][i][2]), false, false)
		end	
	end
end