local screenX, screenY = guiGetScreenSize( )

--------- [ Element Data returns ] ---------
local function getData( theElement, key )
	local key = tostring(key)
	if isElement(theElement) and (key) then
		
		return exports['[ars]anticheat-system']:c_callData( theElement, tostring(key) )
	else
		return false
	end
end	

--------- [ NPC System ] ---------
addEventHandler("onClientPedDamage", root, cancelEvent) -- NPCs 100% bullet proof

local criminalSuppliers = 
{
	[1] = { 24, 2268.1132, -1137.1005, 1050.6328, 0 },
	[2] = { 14, 413.4511, 2536.7021, 11.1484, 270 }
}

local crips = nil
local dough = nil
for key, value in pairs ( criminalSuppliers ) do

	local skin, x, y, z, rot = unpack( value )
	
	if ( key == 1 ) then
		crips = createPed( skin, x, y, z, rot )
		setElementInterior( crips, 10 )
		setElementDimension( crips, 100 )
	elseif ( key == 2 ) then
		dough = createPed( skin, x, y, z, rot )
		setElementInterior( dough, 10 )
		setElementDimension( dough, 232 )
	end	
end	

function clickSupplyNPC( button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
	if ( button == "right" and state == "up" ) then
		
		if ( getData( localPlayer, "loggedin" ) == 1 ) then 
			
			if ( clickedElement == crips ) and ( getData( localPlayer, "faction" ) == 5 ) then
				
				showCriminalSupplyUI( "Quentin Howard", "South Side Crips", "Yo' dawg, wha' can I get ya' today?" )
			elseif ( clickedElement == dough ) and ( getData( localPlayer, "faction" ) == 10 ) then	
				
				showCriminalSupplyUI( "Samuel Higgins", "The Dough Club", "Ey' wha' can I get ya' nigga?" )
			else
				if ( clickedElement == crips ) then
				
					outputChatBox("[English] Quentin Howard says: You ain't go no business 'ere!", 255, 255, 255)
				elseif ( clickedElement == dough ) then
					
					outputChatBox("[English] Samuel Higgins says: Get the hell outta 'ere!", 255, 255, 255)
				end	
			end
		end
	end
end
addEventHandler("onClientClick", root, clickSupplyNPC)

local supplierData = { }

local lastShipment = nil
local theWeapons = nil
local theDrugs = nil
local totalWeapons = 0
local totalDrugs = 0

local canBuy = false
function giveSupplierData( data, reload )
	supplierData = data
	
	local faction = tonumber( getData( localPlayer, "faction" ) )
	
	local npc = nil
	if ( faction == 5 ) then
		npc = crips
	elseif ( faction == 10 ) then
		npc = dough
	end
	
	if ( faction == 5 or faction == 10 ) then
		
		lastShipment = tonumber( supplierData[faction][2] )
		
		theWeapons = supplierData[faction][3]
		theDrugs = supplierData[faction][4]
		
		totalWeapons = 0
		for i = 1, #theWeapons do
			totalWeapons = totalWeapons + tonumber( theWeapons[i] )
		end
		
		totalDrugs = 0
		for i = 1, #theDrugs do
			totalDrugs = totalDrugs + tonumber( theDrugs[i] )
		end
		
		reloadSupplyWindow( npc, reload )
		
		canBuy = true
	end	
end
addEvent("giveSupplierData", true)
addEventHandler("giveSupplierData", localPlayer, giveSupplierData)

function reloadSupplyWindow( npc, reload )
	if ( isElement( supplyWindow ) ) then
		
		if ( reload ) then
			clickSupplyNPC( "right", "up", 0, 0, 0, 0, 0, npc )		
		end	
	end	
end


function callSupplierData( res )
	triggerServerEvent("getSupplierData", localPlayer, true)
end
addEventHandler("onClientResourceStart", resourceRoot, callSupplierData)
addEventHandler("onClientPlayerSpawn", localPlayer, callSupplierData)

local weapons = { ["Colt 45"] = true, ["Uzi"] = true, ["Sawn-Off Shotgun"] = true, ["Deagle"] = true, ["Shotgun"] = true, ["AK-47"] = true, ["Tec-9"] = true } 

local cripsList = 
{
	{"Weapons", "", ""},
	{"", "", ""},
	{"Colt 45", "17", "$500"},
	{"Uzi", "50", "$800"},
	{"Sawn-Off Shotgun", "10", "$700"},
	{"", "", ""},
	{"Drugs", "", ""},
	{"", "", ""},
	{"Marijuana", "1", "$25"},
	{"Lysergic Acid", "1", "$30"},
	{"PCP Hydrochloride", "1", "$20"},
	{"", "", ""},
	{"Accessories", "", ""},
	{"", "", ""},
	{"Blue Bandana", "1", "$5"}
}

local doughList =
{ 
	{"Weapons", "", ""},
	{"", "", ""},
	{"Deagle", "7", "$700"},
	{"Tec-9", "10", "$500"},
	{"AK-47", "15", "$800"},
	{"", "", ""},
	{"Drugs", "", ""},
	{"", "", ""},
	{"Marijuana", "1", "$25"},
	{"Heroin", "1", "$20"},
	{"Subutex", "1", "$15"}
}


function showCriminalSupplyUI( name, text, say )
	local width, height = 350, 340
	local x, y = (screenX / 2) - (width / 2), (screenY / 2) - (height / 2)
	
	local faction = nil
	if ( text == "South Side Crips" ) then
		faction = 5
	elseif ( text == "The Dough Club" ) then
		faction = 10
	end
	
	local isStockEmpty = isStockEmpty( )
	
	if ( not isStockEmpty ) then
	
		if ( not isElement( supplyWindow ) ) then
			
			supplyWindow = guiCreateWindow(x, y, width, height, text, false )
			
			supplyLabel = guiCreateLabel( 0, 30, 310, 20, say, false, supplyWindow)
			centerLabel( supplyLabel )
			
			supplyList = guiCreateGridList( 20, 50, 310, 240, false, supplyWindow)
			guiGridListAddColumn( supplyList, "Item", 0.4 )
			guiGridListAddColumn( supplyList, "Quantity", 0.3 )
			guiGridListAddColumn( supplyList, "Price", 0.2 )
			
			local list = nil
			if ( text == "South Side Crips" ) then
				list = cripsList
			elseif ( text == "The Dough Club" ) then
				list = doughList
			end
			
			local i = 1
			for key, value in ipairs ( list ) do
				
				local row = nil
			
				if ( key >= 12 ) then
					row = guiGridListAddRow( supplyList )
				end
				
				if ( not isStockEmpty ) then
					
					if ( key >= 1 and key <= 2 ) then -- Weapon Headers 
						if ( totalWeapons ~= 0 ) then
							row = guiGridListAddRow( supplyList )
						end	
					end
					
					if ( key >= 6 and key <= 8 ) then -- Drug Headers
						if ( totalDrugs ~= 0 ) then
							row = guiGridListAddRow( supplyList )
						end	
					end
					
					-- Weapons
					if ( key >= 3 and key <= 5 ) then
						
						local weapon = tonumber( theWeapons[i] )
						if ( weapon ~= 0 ) then
							row = guiGridListAddRow( supplyList )
						end
						
						i = i + 1
						
						if ( i > 3 ) then
							i = 1
						end	
					end
					
					-- Drugs
					if ( key >= 9 and key <= 11 ) then
						
						local drug = tonumber( theDrugs[i] )
						if ( drug ~= 0 ) then
							row = guiGridListAddRow( supplyList )
						end
						
						i = i + 1
					end
				end
				
				if ( row ~= nil ) then
				
					guiGridListSetItemText( supplyList, row, 1, tostring( value[1] ), false, false )
					guiGridListSetItemText( supplyList, row, 2, tostring( value[2] ), false, false )
					guiGridListSetItemText( supplyList, row, 3, tostring( value[3] ), false, false )
				end	
				
			end	
			
			buttonBuy = guiCreateButton( 30, 300, 110, 20, "Buy", false, supplyWindow)
			addEventHandler("onClientGUIClick", buttonBuy,
				function( button, state )
					if ( button == "left" and state == "up" ) then
						
						local row = guiGridListGetSelectedItem( supplyList )
						if ( row ~= -1 ) then
							
							local itemName = tostring( guiGridListGetItemText( supplyList, row, 1 ) )
							local itemQuantity = tonumber( guiGridListGetItemText( supplyList, row, 2 ) )
							local itemPrice = tonumber( string.sub( guiGridListGetItemText( supplyList, row, 3 ), 2 ) )
							
							if ( itemName ~= "Weapons" and itemName ~= "Drugs" and itemName ~= "Accessories" and itemName ~= "" ) then
								
								-- Drug or Weapon?
								local isWeapon = nil
								if ( weapons[itemName] ) then
									isWeapon = true
								else
									isWeapon = false
								end
								
								local money = tonumber( getPlayerMoney( )/100 )
								local itemPrice = tonumber( itemPrice )
								
								if ( money >= itemPrice ) then
									
									if ( canBuy  ) then
										
										local index = nil
										for i = 1, #list do
											if ( tostring( list[i][1] ) == itemName ) then
												
												index = i
												break
											end
										end	
										
										if ( not isWeapon ) then
											triggerServerEvent("buyItem", localPlayer, itemName, itemPrice, itemQuantity, index, faction )
										else
											triggerServerEvent("buyWeapon", localPlayer, itemName, itemPrice, itemQuantity, index, faction )
										end
										
										canBuy = false
										
										local wait = 0
										setTimer(
											function( )
												if ( not canBuy ) then
													if ( wait >= 2 ) then
														
														canBuy = true
													else
														wait = wait + 1
													end
												end
											end, 500, 3
										)
										
									end	
								else
									outputChatBox("You don't have enough money.", 255, 0, 0)
								end	
							end	
						end	
					end
				end, false
			)
		
			buttonClose = guiCreateButton( 210, 300, 110, 20, "Close", false, supplyWindow)
			addEventHandler("onClientGUIClick", buttonClose,
				function( button, state )
					if ( button == "left" and state == "up" ) then
						
						destroyElement( supplyWindow )
					end
				end, false
			)
			
			guiSetFont( supplyLabel, "clear-normal" )
			guiSetFont( supplyList, "default-bold-small" )
		else
			destroyElement( supplyWindow )
			showCriminalSupplyUI( name, text, say )
		end	
	else
		local text = "days"
		if ( lastShipment == 2 ) then
			text = "day"
		end
		
		outputChatBox(name .." says: Sorry eh.. I'm outta shipment for the next ".. tostring( 3 - lastShipment ) .." ".. text ..".", 255, 255, 255)
		
		if ( isElement( supplyWindow ) ) then
			destroyElement( supplyWindow )
		end	
	end	
end	

function centerLabel( label )
	local width = guiLabelGetTextExtent( label )
	guiSetPosition( label, ( 350 / 2 ) - ( width / 2), 30, false)
end	

function isStockEmpty( )
	local supplies = totalWeapons + totalDrugs
	
	if ( supplies == 0 ) then
		return true
	else
		return false
	end	
end