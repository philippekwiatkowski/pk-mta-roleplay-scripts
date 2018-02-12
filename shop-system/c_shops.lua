local screenX, screenY = guiGetScreenSize()
local skins = nil

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

--------- [ Shop System ] ---------
local shops =
{
	-- General
	[1] = {
			{"Mask", "A Mask", "$5"},
			{"Cookies", "A packet of cookies", "$3"},
			{"Water Bottle", "A bottle of water", "$1"},
			{"Ice Cream", "A cold Ice Cream", "$3"},
			{"Coca Cola", "A can of Coca Cola", "$1"},
			{"Lighter", "A stylish Lighter", "$2"},
			{"Cigarette", "A Cigarette", "$0.50"},
			{"Card Deck", "A Card Deck", "$5"}
		},
	
	-- Electronics
	[2] = {
			{"Cell Phone", "A Stylish Cell Phone", "$50"},
			{"Radio", "A Radio", "$20"},
			{"Camera", "A Digital Camera", "$60"}, 
			{"Safe", "A lockable Safe", "$80"}
		},
		
	-- Food	( Stall )
	[3] = {
			{"Hotdog", "A Yummy Hotdog", "$3"},
			{"Sandwich", "A Yummy Sandwich", "$3"}
		},
		
	-- Food ( Burger Shot )
	[4] = {
			{"Moo Kids Burger", "A Small Size Yummy Burger", "$1"},
			{"Beef Tower Burger", "A Beef Stuffed Burger", "$2"},
			{"Meat Stack Burger", "A Meat Stuffed Burger", "$3"}
		},
	
	-- Food ( Pizza Stack ) 
	[5] = { 
			{"Buster Pizza", "A Buster Pizza", "$1"},
			{"Double D-Luxe Pizza", "A Deluxe Pizza", "$2"},
			{"Full Rack Pizza", "A Full Rack Pizza", "$3"}
		},
		
	-- Food ( Cluckin' Bell )	
	[6] = {
			{"Cluckin' Little Meal", "A Small Size Meal", "$1"},
			{"Cluckin' Big Meal", "A Big Size Meal", "$2"},
			{"Cluckin' Huge Meal", "A Huge Size Meal", "$3"}
		},
		
	-- Food ( Donut Shop )
	[7] = {
			{"Choco Donut", "A Chocolate Donut", "$1"},
			{"Sweet Donut", "A Sweet Donut", "$1"}
		},
		
	-- Bar
	[8] = {
			{"Beer", "A Chilled Beer", "$3"},
			{"Wine", "A Wine", "$5"},
			{"Champagne", "A Champagne", "$6"}
		}
}

--------- [ Global Skins ] ---------

local globalSkins = { 
	[1] = {7, 14, 15, 16, 17, 18, 20, 21, 22, 24, 25, 28, 35, 36, 50, 51, 66, 67, 78, 79, 80, 83, 84, 102, 103, 104, 105, 106, 107, 134, 136, 142, 143, 144, 156, 163, 166, 168, 176, 180, 182, 183, 185, 220, 221, 222, 249, 253, 260, 262, 269, 270, 271, 293, 296, 297},
	[2] = {9, 10, 11, 12, 13, 40, 41, 63, 64, 69, 76, 91, 139, 148, 190, 195, 207, 215, 218, 219, 238, 243, 244, 245, 256, 304},
	[3] = {1, 2, 23, 26, 27, 29, 30, 32, 33, 34, 35, 36, 37, 38, 43, 44, 45, 46, 47, 48, 50, 51, 52, 53, 58, 59, 60, 61, 62, 68, 70, 72, 73, 78, 81, 82, 94, 95, 96, 97, 98, 99, 100, 101, 108, 109, 110, 111, 112, 113, 114, 115, 116, 120, 121, 122, 124, 125, 126, 127, 128, 132, 133, 135, 137, 146, 147, 153, 154, 155, 158, 159, 160, 161, 162, 164, 165, 170, 171, 173, 174, 175, 177, 179, 181, 184, 186, 187, 188, 189, 200, 202, 204, 206, 209, 212, 213, 217, 223, 230, 234, 235, 236, 240, 241, 242, 247, 248, 250, 252, 254, 255, 258, 259, 261, 264, 268, 272, 290, 291, 292, 295, 299, 302, 303, 305, 306, 307, 308, 309, 310, 312},
	[4] = {12, 31, 38, 39, 40, 41, 53, 54, 55, 56, 64, 75, 77, 85, 86, 87, 88, 89, 90, 91, 92, 93, 129, 130, 131, 138, 140, 145, 150, 151, 152, 157, 172, 178, 192, 193, 194, 196, 197, 198, 199, 201, 205, 211, 214, 216, 224, 225, 226, 231, 232, 233, 237, 243, 246, 251, 257, 263, 298},
	[5] = {49, 57, 58, 59, 60, 117, 118, 120, 121, 122, 123, 170, 186, 187, 203, 210, 227, 228, 229, 294},
	[6] = {38, 53, 54, 55, 56, 88, 141, 169, 178, 224, 225, 226, 263}
}

addEventHandler("onClientPedDamage", getRootElement(), cancelEvent) -- We don't want people going around and killing our shops keepers..

function onShopKeeperClick(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if (getData(getLocalPlayer(), "loggedin") == 1) then
		if (button == "right" and state == "up") then
			
			if (clickedElement) then
			
				local elementType = getElementType(clickedElement)
				if (elementType) and (elementType == "ped") then
				
					local x, y, z = getElementPosition(clickedElement)
					local px, py, pz = getElementPosition(localPlayer)
					
					if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 10) then
						
						if (getElementParent(getElementParent(clickedElement)) == resourceRoot) then
								
							if not isElement(shopWin) then	
								
								local shopKeeper = clickedElement
								local shopType = tonumber(getData(shopKeeper, "type"))
								
								local width, height = 400, 280
								local x, y = (screenX/2) - (width/2), (screenY/2) - (height/2)
								
								local shopName 
								if (shopType == 1) then
									shopName = "General Store"
								elseif (shopType == 2) then
									shopName = "Electronics Store"
								elseif (shopType == 3) then
									shopName = "Food Stall"
								elseif (shopType == 4) then
									shopName = "Burger Shot"
								elseif (shopType == 5) then
									shopName = "Pizza Stack"
								elseif (shopType == 6) then
									shopName = "Cluckin' Bell"
								elseif (shopType == 7) then
									shopName = "Donut Shop"
								elseif (shopType == 8) then
									shopName = "Bar"
								elseif (shopType == 9) then
									shopName = "Clothes Shop"
								end
								
								shopWin = guiCreateWindow(x, y, width, height, tostring(shopName), false)
								
								-- Grid
								shopItemsList = guiCreateGridList(20, 30, 360, 200, false, shopWin)
								if shopType == 9 then
									guiGridListAddColumn(shopItemsList, "Skin ID", 0.25)
								else
									guiGridListAddColumn(shopItemsList, "Item", 0.25)
								end
								guiGridListAddColumn(shopItemsList, "Cost", 0.3)
								guiGridListAddColumn(shopItemsList, "Description", 0.4)
								
								local skin = getElementModel(localPlayer)
								
								local skins = nil
								for key, value in ipairs ( globalSkins ) do
									for index, array in ipairs ( globalSkins[key] ) do
										if ( array == skin ) then
											
											if ( skins == nil ) then
												skins = globalSkins[key]
											end
											
											break
										end
									end	
								end
								
								if ( shopType == 9 ) then								
									for i, v in ipairs (skins) do
										local row = guiGridListAddRow(shopItemsList)
									
										guiGridListSetItemText(shopItemsList, row, 1, tostring (v), false, false)
										guiGridListSetItemText(shopItemsList, row, 2, "$50", false, false)
										guiGridListSetItemText(shopItemsList, row, 3, "A pair of clothes.", false, false)
									end
								else
									for i, v in ipairs (shops[shopType]) do
										local row = guiGridListAddRow(shopItemsList)
									
										guiGridListSetItemText(shopItemsList, row, 1, v[1], false, false)
										guiGridListSetItemText(shopItemsList, row, 2, v[3], false, false)
										guiGridListSetItemText(shopItemsList, row, 3, v[2], false, false)
									end
								end	
								
								-- Buttons
								shopBuyBtn = guiCreateButton(40, 240, 110, 20, "Buy", false, shopWin)
								addEventHandler("onClientGUIClick", shopBuyBtn,
								function( button, state )
									if (button == "left" and state == "up") then
										
										local row = guiGridListGetSelectedItem(shopItemsList)
										if (row ~= -1) then
					
											local itemName = guiGridListGetItemText(shopItemsList, row, 1)
											local itemCost = guiGridListGetItemText(shopItemsList, row, 2):sub(2)
											
											triggerServerEvent("playerBuyItem", getLocalPlayer(), itemName, itemCost, shopName)
											skins = nil
										else
											outputChatBox("You did not select any item.", 255, 0, 0)	
										end
									end
								end, false)
								
								shopCloseBtn = guiCreateButton(250, 240, 110, 20, "Close", false, shopWin)
								addEventHandler("onClientGUIClick", shopCloseBtn,
								function( button, state )
									if (button == "left" and state == "up") then
										
										destroyElement(shopWin)
										shopWin = nil
										skins = nil
									end
								end, false)	
							end
						end	
					end	
				end	
			end	
		end
	end	
end
addEventHandler("onClientClick", getRootElement(), onShopKeeperClick)