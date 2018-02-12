local screenX, screenY = guiGetScreenSize()
local lastTab = ""

local items = { }
local values = { }

local selectedItem = -1
local selectedItemValue = -1

local isGeneralEmpty = true
local isKeyEmpty = true
local isWeaponEmpty = true

--------- [ Element Data returns ] ---------
local function getData( theElement, key )
	local key = tostring(key)
	if isElement(theElement) and (key) then
		
		return exports['[ars]anticheat-system']:c_callData( theElement, tostring(key) )
	else
		return false
	end
end	

--------- [ Get Items ] ---------
function giveInventoryItems( s_items, s_values )
	items = s_items
	values = s_values
end
addEvent("giveInventoryItems", true)
addEventHandler("giveInventoryItems", getLocalPlayer( ), giveInventoryItems)	

function showInventory( )
	if ( getData( localPlayer, "loggedin" ) == 1 ) then
		
		local width, height = 400, 440
		local x = (screenX) - (width)
		local y = (screenY) - (height)
		
		if not isElement(inventoryWin) then
			
			if ( isPedInVehicle( localPlayer ) ) then
				exports['[ars]vehicle-system']:hideSpeedometer( )
				exports['[ars]vehicle-system']:hideFuelmeter( )
			end
			
			inventoryWin = guiCreateWindow(x, y - 30, width, height, "Inventory", false)
			
			-- Tab Panel
			itemsPanel = guiCreateTabPanel(20, 30, 360, 360, false, inventoryWin)
			genTab = guiCreateTab("Generals", itemsPanel)
			keyTab = guiCreateTab("Keys", itemsPanel)
			wepTab = guiCreateTab("Weapons", itemsPanel)

			-- Pane
			generalPane = guiCreateScrollPane(20, 15, 325, 300, false, genTab)
			local g_colHeader1 = guiCreateLabel(10, 15, 50, 20, "Item", false, generalPane)
			local g_colHeader2 = guiCreateLabel(270, 15, 50, 20, "Value", false, generalPane) 
			local g_colSeparator = guiCreateLabel(10, 18, 290, 20, "__________________________________________", false, generalPane) 
			
			keyPane = guiCreateScrollPane(20, 15, 325, 300, false, keyTab) 	
			local k_colHeader1 = guiCreateLabel(10, 15, 50, 20, "Key", false, keyPane)
			local k_colHeader2 = guiCreateLabel(270, 15, 50, 20, "Value", false, keyPane) 
			local k_colSeparator = guiCreateLabel(10, 18, 290, 20, "__________________________________________", false, keyPane) 
			
			weaponPane = guiCreateScrollPane(20, 15, 325, 300, false, wepTab) 
			local w_colHeader1 = guiCreateLabel(10, 15, 50, 20, "Weapon", false, weaponPane)
			local w_colHeader2 = guiCreateLabel(270, 15, 50, 20, "Ammo", false, weaponPane) 
			local w_colSeparator = guiCreateLabel(11, 18, 295, 20, "___________________________________________", false, weaponPane) 
			
			guiSetFont(g_colHeader1, "default-bold-small")
			guiSetFont(g_colHeader2, "default-bold-small")
			guiSetFont(g_colSeparator, "default-bold-small")
			
			guiSetFont(k_colHeader1, "default-bold-small")
			guiSetFont(k_colHeader2, "default-bold-small")
			guiSetFont(k_colSeparator, "default-bold-small")
			
			guiSetFont(w_colHeader1, "default-bold-small")
			guiSetFont(w_colHeader2, "default-bold-small")
			guiSetFont(w_colSeparator, "default-bold-small")
			
			populateInventory( items, values )	
		
			-- Buttons
			invShowBtn = guiCreateButton(30, 400, 90, 20, "Show Item", false, inventoryWin) 
			addEventHandler("onClientGUIClick", invShowBtn, showItem, false)
			
			invDropBtn = guiCreateButton(160, 400, 90, 20, "Drop Item", false, inventoryWin) 
			addEventHandler("onClientGUIClick", invDropBtn, dropItem, false)
			
			invDestroyBtn = guiCreateButton(290, 400, 90, 20, "Destroy Item", false, inventoryWin)
			addEventHandler("onClientGUIClick", invDestroyBtn, destroyItem, false)
			
			for i, v in ipairs (getElementsByType("gui-tab"), resourceRoot) do
				local txt = tostring(guiGetText(v))
				if (txt == tostring(lastTab)) then
					guiSetSelectedTab(itemsPanel, v)
					break
				end
			end	
			
			showCursor(true)
		else
			lastTab = tostring(guiGetText(guiGetSelectedTab(itemsPanel)))
			
			destroyElement(inventoryWin)
			inventoryWin = nil
			
			showCursor(false)
			
			if ( isPedInVehicle( localPlayer ) ) then
				exports['[ars]vehicle-system']:showSpeedometer( )
				exports['[ars]vehicle-system']:showFuelmeter( )
			end
		end
	end	
end

function populateInventory( items, values )
	
	inventoryItems = { }
	t = inventoryItems
	
	t["General"] = { }
	t["Key"] = { }
	t["Weapon"] = { }
	
	-- Items
	local genX, genY = 10, 40
	local keyX, keyY = 10, 40
	
	local gj = 0
	local kj = 0
	
	for i = 1, #items do
		
		local itemType = g_items[tonumber(items[i])][2]
		if tostring(itemType) == "Generals" then
			
			gj = gj + 1
			
			-- Populate
			local itemName = g_items[tonumber(items[i])][1]
			
			local path = "images/".. items[i] ..".png"
			if ( itemName == "Clothes" ) then
				path = ":[ars]character-system/images/".. tostring(values[i]) ..".png"
			end
			
			local itemValue = tostring(values[i])
			if ( string.len( itemValue ) >= 6 ) then
				itemValue = string.sub( itemValue, 1, 5 ) .. "..."
			end
			
			local itemImage = guiCreateStaticImage(genX, genY, 54, 54, tostring(path), false, generalPane)
			local itemText = guiCreateLabel(genX + 74, genY + 15, 150, 20, tostring(itemName), false, generalPane) 
			local itemVal = guiCreateLabel(genX + 260, genY + 15, 50, 20, tostring(itemValue), false, generalPane)
			
			guiSetFont(itemText, "default-bold-small") 
			guiSetFont(itemVal, "default-bold-small")  
			
			t["General"][gj] = { itemImage, itemText, itemVal, tostring(values[i]) } 
			
			addEventHandler("onClientGUIClick", itemImage, selectItem, false)
			addEventHandler("onClientGUIDoubleClick", itemImage, useItem, false)
			
			genY = genY + 70
		elseif tostring(itemType == "Key") then
			
			kj = kj + 1
				
			local itemName = g_items[tonumber(items[i])][1]
			
			local itemImage = guiCreateStaticImage(keyX, keyY, 54, 54, "images/".. items[i] ..".png", false, keyPane)
			local itemText = guiCreateLabel(keyX + 74, keyY + 15, 150, 20, tostring(itemName), false, keyPane) 
			local itemVal = guiCreateLabel(keyX + 260, keyY + 15, 50, 20, tostring(values[i]), false, keyPane)
			
			guiSetFont(itemText, "default-bold-small") 
			guiSetFont(itemVal, "default-bold-small")  
			
			t["Key"][kj] = { itemImage, itemText, itemVal, tostring(values[i]) } 
			
			addEventHandler("onClientGUIClick", itemImage, selectItem, false)
			addEventHandler("onClientGUIDoubleClick", itemImage, useItem, false)
			
			keyY = keyY + 70
		end		
	end			
	
	if (gj > 0) then
		isGeneralEmpty = false
	else
		isGeneralEmpty = true
	end
	
	if (kj > 0) then
		isKeyEmpty = false
	else
		isKeyEmpty = true
	end
	
	-- Weapons
	local wepX, wepY = 10, 40
	
	local wj = 0
	
	for slot = 1, 12 do
		local weapon = getPedWeapon(getLocalPlayer(), slot)
		if tonumber(weapon) ~= 0 and tonumber(getPedTotalAmmo(getLocalPlayer(), slot)) ~= 0 then
			
			wj = wj + 1 
			
			local weaponName = getWeaponNameFromID(weapon)
			
			local weaponImage = guiCreateStaticImage(wepX, wepY, 54, 54, "images/".. -weapon ..".png", false, weaponPane)
			local weaponText = guiCreateLabel(wepX + 74, wepY + 15, 150, 20, tostring(weaponName), false, weaponPane) 
			local weaponAmmo = guiCreateLabel(wepX + 260, wepY + 15, 50, 20, tostring(getPedTotalAmmo(getLocalPlayer(), slot)), false, weaponPane)
			
			guiSetFont(weaponText, "default-bold-small")
			guiSetFont(weaponAmmo, "default-bold-small")

			t["Weapon"][wj] = { weaponImage, weaponText, weaponAmmo, tostring(getPedTotalAmmo(getLocalPlayer(), slot)) } 
			
			addEventHandler("onClientGUIClick", weaponImage, selectItem, false)	
			addEventHandler("onClientGUIDoubleClick", weaponImage, useItem, false)				

			wepY = wepY + 70
		end
	end	
	
	if (wj > 0) then
		isWeaponEmpty = false
	else
		isWeaponEmpty = true
	end
	
	
	-- Apply selection when populated..
	if (not isGeneralEmpty) then
		
		local iconX, iconY = guiGetPosition(t["General"][1][1], false)
		generalSelection = guiCreateStaticImage(iconX - 4, iconY - 6, 300, 64, "images/selection.png", false, generalPane)
		
		guiSetAlpha(generalSelection, 0.7)
		guiMoveToBack(generalSelection)
	end
		
	if (not isKeyEmpty) then
		local iconX, iconY = guiGetPosition(t["Key"][1][1], false)
		keySelection = guiCreateStaticImage(iconX - 4, iconY - 6, 300, 64, "images/selection.png", false, keyPane)
		
		guiSetAlpha(keySelection, 0.7)
		guiMoveToBack(keySelection)
	end
	
	if (not isWeaponEmpty)then
		local iconX, iconY = guiGetPosition(t["Weapon"][1][1], false)
		weaponSelection = guiCreateStaticImage(iconX - 4, iconY - 6, 300, 64, "images/selection.png", false, weaponPane)
		
		guiSetAlpha(weaponSelection, 0.7)
		guiMoveToBack(weaponSelection)
	end
	
	local selectedTab = guiGetSelectedTab(itemsPanel)
	if (selectedTab == genTab) then
		if (not isGeneralEmpty) then
			
			selectedItem = guiGetText(t["General"][1][2])
			selectedItemValue = tostring(t["General"][1][4])
		else
			selectedItem = -1
			selectedItemValue = -1
		end	
	elseif (selectedTab == keyTab) then	
		if (not isKeyEmpty) then
			
			selectedItem = guiGetText(t["Key"][1][2])
			selectedItemValue = tostring(t["Key"][1][4])
		else
			selectedItem = -1
			selectedItemValue = -1	
		end	
	elseif (selectedTab == wepTab) then
		if (not isWeaponEmpty) then
			
			selectedItem = guiGetText(t["Weapon"][1][2])
			selectedItemValue = tostring(t["Weapon"][1][4])
		else
			selectedItem = -1
			selectedItemValue = -1	
		end	
	end
end

-- Change Tab
function changeInventoryTab( newTab )
	local element = nil
	local selection = nil
	
	selectedItem = -1
	selectedItemValue = -1

	if (newTab == genTab) and ( not isGeneralEmpty) then
		
		selectedItem = guiGetText(t["General"][1][2])
		selectedItemValue = guiGetText(t["General"][1][3])
		
		element = t["General"][1][1]
		
		local iconX, iconY = guiGetPosition(element, false)
		guiSetPosition(generalSelection, iconX - 4, iconY - 6, false)
			
		guiSetAlpha(generalSelection, 0.7)
		guiMoveToBack(generalSelection)
	elseif (newTab == keyTab) and ( not isKeyEmpty) then
		
		selectedItem = guiGetText(t["Key"][1][2])
		selectedItemValue = guiGetText(t["Key"][1][3])
		
		element = t["Key"][1][1]
		local iconX, iconY = guiGetPosition(element, false)
		guiSetPosition(keySelection, iconX - 4, iconY - 6, false)
			
		guiSetAlpha(keySelection, 0.7)
		guiMoveToBack(keySelection)
	elseif (newTab == wepTab) and ( not isWeaponEmpty) then
	
		selectedItem = guiGetText(t["Weapon"][1][2])
		selectedItemValue = guiGetText(t["Weapon"][1][3])
		
		element = t["Weapon"][1][1]
		local iconX, iconY = guiGetPosition(element, false)
		guiSetPosition(weaponSelection, iconX - 4, iconY - 6, false)
			
		guiSetAlpha(weaponSelection, 0.7)
		guiMoveToBack(weaponSelection)
	end
end
addEventHandler("onClientGUITabSwitched", getRootElement(), changeInventoryTab)

-- Select Item
function selectItem( button, state )
	if (button == "left" and state == "up") then
		
		local element = nil
		local j = nil
		local tab = nil
		
		for i, v in pairs (t) do
				
			if (i == "General") then	
				tab = "General"
			elseif (i == "Key") then
				tab = "Key"
			elseif (i == "Weapon") then
				tab = "Weapon"
			end
			
			for k, v in ipairs ( t[i] ) do
				
				if ( #t[i][k] > 0 ) then
					for index, value in ipairs ( t[i][k] ) do
						
						if (value == source) and (value == t[i][k][index]) then
							
							element = value
							j = tostring(tab)
							
							selectedItem = guiGetText(t[tostring(tab)][k][2])
							selectedItemValue = tostring( t[i][k][4]:gsub(";", ",") )
							
							break
						end
					end	
				end	
			end	
		end	
		
		local selection = nil
		if (j == "General") then
			selection = generalSelection
		elseif (j == "Key") then
			selection = keySelection
		elseif (j == "Weapon") then
			selection = weaponSelection
		end
		
		local iconX, iconY = guiGetPosition(element, false)
		guiSetPosition(selection, iconX - 4, iconY - 6, false)
		
		guiSetAlpha(selection, 0.7)
		guiMoveToBack(selection)
	end	
end

local allowUse = true
function useItem( button, state )
	if (button == "left" and state == "up") then
		
		if ( allowUse ) then 
		
			if (selectedItem ~= -1) and (selectedItemValue ~= -1) then
				
				local itemName = tostring(selectedItem)
				local itemValue = tostring(selectedItemValue)
				
				disableUse( ) -- Fix for lag bug..
				
				triggerServerEvent("useInventoryItem", getLocalPlayer(), itemName, itemValue)
			else
				outputChatBox("You have not selected any item.", 255, 0, 0)	
			end
		end	
	end	
end

function disableUse( )
	if ( allowUse ) then
		
		allowUse = false
		
		setTimer(
			function( )
				allowUse = true
			end, 2000, 1
		)
	end	
end

-- Show Item
function showItem( button, state )
	if (button == "left" and state == "up") then
		
		if (selectedItem ~= -1) then
			
			local itemName = tostring(selectedItem)
			local itemValue = tostring(selectedItemValue)
		
			triggerServerEvent("showItemToPlayers", getLocalPlayer(), itemName, itemValue) 
		else
			outputChatBox("You have not selected any item.", 255, 0, 0)
		end
	end
end

-- Drop Item
local allowDrop = true
function createWeaponDropUI( weaponName, ammo )
	local width, height = 320, 140
	local x, y = (screenX/2) - (width/2), (screenY/2) - (height/2)
	
	if not isElement(dropWeaponWin) then
	
		dropWeaponWin = guiCreateWindow(x, y, width, height, "Drop Weapon", false)
		
		-- Question
		dropWeaponLbl = guiCreateLabel(40, 30, 300, 20, "How much ammo do you want to drop?", false, dropWeaponWin)
		
		-- Scroll
		ammoBar = guiCreateScrollBar(30, 55, 200, 20, true, false, dropWeaponWin)
		guiScrollBarSetScrollPosition(ammoBar, 100)
		
		addEventHandler("onClientGUIScroll", getRootElement(),
		function( scroll )
			if isElement(ammoLabel) then
				
				local newAmmo = math.floor(tonumber(guiScrollBarGetScrollPosition(scroll)/100*ammo))
				guiSetText(ammoLabel, tostring(newAmmo))
			end	
		end)

		-- Label
		ammoLabel = guiCreateLabel(240, 55, 50, 20, tostring(ammo), false, dropWeaponWin)
		
		-- Buttons
		btnDropWeapon = guiCreateButton(20, 90, 110, 20, "Drop", false, dropWeaponWin)
		addEventHandler("onClientGUIClick", btnDropWeapon, 
		function( button, state )
			if (button == "left" and state == "up") then
				
				if ( not isClientDead( ) ) then
				
					local dropAmmo = guiGetText(ammoLabel)
					local leftAmmo = tonumber(ammo) - tonumber(dropAmmo)
					
					local ammoDetails = { }
					ammoDetails[1] = dropAmmo
					ammoDetails[2] = leftAmmo
					
					local x, y, z = getElementPosition(getLocalPlayer())
					local rot = getPedRotation(getLocalPlayer())
					
					local dropPosition = { }
					dropPosition[1] = x + ( ( math.sin( math.rad( -rot) ) ) * 1 )
					dropPosition[2] = y + ( ( math.cos( math.rad( -rot) ) ) * 1 )
					dropPosition[3] = getGroundPosition(x, y, z + 2)
					
					disableDrop( )
					
					triggerServerEvent("dropItemOnGround", getLocalPlayer(), weaponName, ammoDetails, dropPosition) 
					
					-- Update inventory
					if (tonumber(leftAmmo) ~= 0) then
						changeItemValue(weaponName, ammo, tostring(leftAmmo))
					else
						setTimer(reloadInventory, 400, 1)
					end	
					
					destroyElement(dropWeaponWin)
					dropWeaponWin = nil
				end	
			end
		end, false)
		
		btnCancelWeaponDrop = guiCreateButton(190, 90, 110, 20, "Cancel", false, dropWeaponWin) 
		addEventHandler("onClientGUIClick", btnCancelWeaponDrop, 
		function( button, state )
			if (button == "left" and state == "up") then
				
				destroyElement(dropWeaponWin)
				dropWeaponWin = nil
			end
		end, false)
		
	else
		destroyElement(dropWeaponWin)
		dropWeaponWin = nil
	end	
end

function dropItem( button, state )
	if (button == "left" and state == "up") then
		
		if ( allowDrop ) then
			if (selectedItem ~= -1) and (selectedItemValue ~= -1) then
				
				if ( not isClientDead( ) ) then
					
					local itemName = tostring(selectedItem)
					local itemValue = tostring(selectedItemValue)
					
					if (guiGetSelectedTab(itemsPanel) == wepTab) then -- Dropping a weapon
						
						local duty = tonumber( getData(localPlayer, "duty") )
						if ( duty == 0 ) then	-- Offduty
							
							createWeaponDropUI( itemName, itemValue )
						else
							outputChatBox("You cannot drop your weapons on duty.", 255, 0, 0)
						end
						
					else								  -- Otherwise..
						local x, y, z = getElementPosition(getLocalPlayer())
						local rot = getPedRotation(getLocalPlayer())
						
						local dropPosition = { }
						dropPosition[1] = x + ( ( math.sin( math.rad( -rot) ) ) * 1 )
						dropPosition[2] = y + ( ( math.cos( math.rad( -rot) ) ) * 1 )
						dropPosition[3] = getGroundPosition(x, y, z + 2)
						
						disableDrop( )	-- Fix for lag bug..
						
						triggerServerEvent("dropItemOnGround", getLocalPlayer(), itemName, itemValue, dropPosition)				
					end	
				end	
			else
				outputChatBox("You have not selected any item.", 255, 0, 0)
			end
		end	
	end
end

function isClientDead( )
	local health = getElementHealth( localPlayer )
	if ( health > 0 ) then
		return false
	else 
		return true
	end
end
	
addEventHandler("onClientPlayerWasted", root,
	function( ) 
		if isElement( inventoryWin ) then
			destroyElement( inventoryWin )
			inventoryWin = nil
		end	
		
		if isElement( dropWeaponWin ) then
			destroyElement( dropWeaponWin )
			dropWeaponWin = nil
		end	
	end
)
	
function disableDrop( )
	if ( allowDrop ) then
		
		allowDrop = false
		
		setTimer( 
			function( )
				allowDrop = true
			end, 2000, 1
		)
	end
end

-- Destroy Item
local allowDestroy = true
function destroyItem( button, state )
	if (button == "left" and state == "up") then
		
		if ( allowDestroy ) then
			
			if (selectedItem ~= -1) and (selectedItemValue ~= -1) then
				
				local itemName = tostring(selectedItem)
				local itemValue = tostring(selectedItemValue)
				
				disableDestroy( ) -- Fix for lag bug..
				
				triggerServerEvent("destroyItemFromInventory", getLocalPlayer(), itemName, itemValue)
			else
				outputChatBox("You have not selected any item.", 255, 0, 0)	
			end	
		end	
	end	
end

function disableDestroy( )
	if ( allowDestroy ) then
		
		allowDestroy = false
		setTimer(
			function( )
				allowDestroy = true
			end, 2000, 1
		)
	end	
end

-- Inventory functions
function changeItemValue( itemName, itemValue, newValue)
	local selectedTab = guiGetSelectedTab(itemsPanel)
	
	for i, v in pairs ( t ) do
		for k, v in ipairs ( t[i] ) do
			for index, value in ipairs ( t[i][k] ) do
				
				if (itemName == guiGetText(t[i][k][2])) and (itemValue == guiGetText(t[i][k][3])) then
					
					guiSetText(t[i][k][3], tostring(newValue))
				end
			end
		end
	end
end	

function removeInventoryItem( itemID, itemValue )
	
	-- Remove 
	for i, v in pairs(items) do
		
		if ( not itemValue ) then
			
			if (tonumber(v) == tonumber(itemID)) then
				
				table.remove(items, i)
				table.remove(values, i)
				break	
			end
		
		elseif (itemValue) then 
			
			if (tonumber(v) == tonumber(itemID) and tonumber(itemValue) == tonumber(values[i])) then 
				
				table.remove(items, i)
				table.remove(values, i)
				break	
			end
		end
	end	

	-- Reload
	reloadInventory( )
end
addEvent("removeInventoryItem", true)
addEventHandler("removeInventoryItem", localPlayer, removeInventoryItem)

function addInventoryItem( itemName, itemValue )
	local itemModel, itemID, rx, ry, rz, elevation = getItemDetails( tostring(itemName) )
	
	items[#items+1] = tonumber(itemID)
	values[#values+1] = tostring(itemValue:gsub(",", ";"))
	
	-- Reload
	reloadInventory( )
end
addEvent("addInventoryItem", true)
addEventHandler("addInventoryItem", localPlayer, addInventoryItem)

function reloadInventory( )
	if ( isElement( inventoryWin ) ) then
		
		for i, v in pairs ( t ) do
			for k, v in ipairs ( t[i] ) do	
				
				destroyElement(v[1])
				destroyElement(v[2])
				destroyElement(v[3])
			end
		end
		
		if isElement(generalSelection) then
			destroyElement(generalSelection)
		end
		
		if isElement(keySelection) then
			destroyElement(keySelection)
		end
			
		if isElement(weaponSelection) then	
			destroyElement(weaponSelection)
		end	
		
		populateInventory( items, values )	
	end	
end
addEvent("reloadInventory", true)
addEventHandler("reloadInventory", localPlayer, reloadInventory)

-- Item function(s)		
function hasItem( itemID, itemValue )
	if (itemID) then
		
		local found = false
		local valueMatch = false
		for i, v in pairs(items) do
			if tonumber(v) == tonumber(itemID) then
					
				found = true
				
				if (itemValue) then
					if ( tonumber(values[i]) == tonumber(itemValue) ) then
					
						valueMatch = true
						break
					end
				else
					break
				end
			end
		end
		return found, valueMatch
	else
		return false, false
	end	
end

function getPlayerInventory(  )
	return items, values
end

function isPlayerInventoryOpen( )
	if isElement( inventoryWin ) then
		
		return true
	else
		return false
	end
end

function closePlayerInventory( )
	if isElement( inventoryWin ) then
		
		showInventory( )
	end
end	
	
-- Global Vars
local drawItemInfo = false
local pointingItem = nil

local draggedObject = nil
local tickStart = 0

-- Pickup/Move Item
function pickupItem( button, state, absoluteX, absoluteY, worldX, worldY, worldZ )
	if (button == "left") then
	
		if ( state == "up") then -- Picking
			
			local theObject = draggedObject
			if ( theObject ) then
				
				local tickEnd = getTickCount( )
				local theDelay = tickEnd - tickStart
				if ( theDelay >= 300 ) then 
					
					local x, y, z = getElementPosition( getLocalPlayer() )
					if ( getDistanceBetweenPoints3D( x, y, z, worldX, worldY, worldZ ) <= 7 ) then
						
						triggerServerEvent("moveItemOnGround", getLocalPlayer(), theObject, worldX, worldY, worldZ )
					else
						outputChatBox("You cannot place an object so far away.", 255, 0, 0)
					end	
				else	
					triggerServerEvent("pickItemFromGround", getLocalPlayer(), theObject )
				end
				
				tickStart = 0
				draggedObject = nil
				drawItemInfo = false
			end
		elseif ( state == "down" ) then
			
			local theObject = getClickedObject( absoluteX, absoluteY )
			if ( theObject ) then
				
				-- We're possible dragging this..
				draggedObject = theObject
				tickStart = getTickCount( )
			end	
		end	
	end	
end
addEventHandler("onClientClick", getRootElement(), pickupItem)

function getClickedObject( absoluteX, absoluteY )
	if ( absoluteX ) and ( absoluteY ) then
		
		for key, theObject in ipairs ( getElementsByType("object", resourceRoot ) ) do
			if ( getElementModel( theObject ) ~= 2942 ) then -- Can't pickup an ATM..
				
				local objectInterior = getElementInterior( theObject )
				local objectDimension = getElementDimension( theObject )
				
				local playerInterior = getElementInterior( localPlayer ) 
				local playerDimension = getElementDimension( localPlayer )
			
				if ( objectInterior == playerInterior ) and ( objectDimension == playerDimension ) then	-- Same World
				
					local objectX, objectY, objectZ = getElementPosition( theObject )
					
					local sx, sy = getScreenFromWorldPosition( objectX, objectY, objectZ )
					if ( sx and sy ) then
						
						-- Sqaure around the Object
						local minX, maxX = sx - 60, sx + 60
						local minY, maxY = sy - 50, sy + 50
						
						if ( absoluteX <= maxX and absoluteX >= minX ) and ( absoluteY <= maxY and absoluteY >= minY ) then
							
							return theObject
						end
					end
				end
			end
		end

		return false
	end	
end

-- Draw the item's information, if its being pointed at
function renderItemInfo ( )
	if (isCursorShowing()) then
		if (drawItemInfo) then
			
			if (pointingItem ~= nil) then
			
				local itemID = tonumber(getData(pointingItem, "itemid"))
				if (itemID) then
					
					local itemModel, itemName = getItemDetails( itemID )
					if (not itemName) then
						itemName = getWeaponNameFromID(itemID*-1)
						if (not itemName) then
							removeEventHandler("onClientRender", getRootElement(), renderItemInfo)
						end	
					end
					
					local itemValue = getData(pointingItem, "itemvalue")
					
					local txtWidth = dxGetTextWidth(tostring(itemName) .." (".. tostring(itemValue):gsub(";", ",") ..")", 1, "default")
					dxDrawRectangle(cx+2, cy+1.5, txtWidth+25, 25, tocolor(0, 0, 0, 200))
					
					dxDrawText(tostring(itemName) .." (".. tostring(itemValue) ..")", cx+15, cy+6, screenX, screenY, tocolor(255, 255, 255, 255), 1, "default")
				end
			end	
		end	
	end	
end	
addEventHandler("onClientRender", getRootElement(), renderItemInfo)

function checkObjectPointing( cursorX, cursorY, absoluteX, absoluteY )
	if (isCursorShowing() and getData(getLocalPlayer(), "loggedin") == 1) then
	
		cx = absoluteX - 0.5
		cy = absoluteY - 1.5
	
		for i, obj in ipairs(getElementsByType("object")) do
			if (getElementModel(obj) ~= 2942) then -- Can't pickup an ATM..
				
				local objInterior, objDimension = getElementInterior(obj), getElementDimension(obj)
				local playerInterior, playerDimension = getElementInterior(localPlayer), getElementDimension(localPlayer)
				
				if ( objInterior == playerInterior ) and ( objDimension == playerDimension ) then -- Same World
				
					local objX, objY, objZ = getElementPosition(obj)
				
					local sx, sy = getScreenFromWorldPosition(objX, objY, objZ)
					if (sx) and (sy) then
				
						-- create a sqaure around the object
						local minX, maxX = sx - 60, sx + 60
						local minY, maxY = sy - 50, sy + 50
							
						if (absoluteX <= maxX and absoluteX >= minX) and (absoluteY <= maxY and absoluteY >= minY) then
							drawItemInfo = true
							pointingItem = obj	
							break
						else
							drawItemInfo = false
							pointingItem = nil
						end
					end
				end	
			end	
		end	
	end	
end

local cx, cy, ax, ay = nil
function callPointingCheck( )
	if ( cx ~= nil ) and ( cy ~= nil ) and ( ax ~= nil ) and ( ay ~= nil ) then 
		
		if ( isCursorShowing( ) ) then
			checkObjectPointing( cx, cy, ax, ay )
		end	
	end	
end
addEventHandler("onClientRender", root, callPointingCheck)

addEventHandler("onClientCursorMove", root, 
	function( cursorX, cursorY, absoluteX, absoluteY )
		
		-- Construct Globals
		cx, cy, ax, ay = cursorX, cursorY, absoluteX, absoluteY
	end
)
	
function getClientItems( )
	triggerEvent("giveClientItems", localPlayer, items, values)
end
addEvent("getClientItems", true)
addEventHandler("getClientItems", localPlayer, getClientItems)

--------- [ Binds ] ---------
addEventHandler("onClientResourceStart", resourceRoot,
function ( res )
	bindKey("i", "down", showInventory)
	
	triggerServerEvent("onClientStart", localPlayer)
	
	for key, value in ipairs ( getElementsByType("object", resourceRoot ) ) do
		setElementCollidableWith( value, localPlayer, false )
	end	
end)