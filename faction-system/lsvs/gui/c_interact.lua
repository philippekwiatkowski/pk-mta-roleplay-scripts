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

--------- [ Vehicle Repairing ] ---------
addEventHandler("onClientDoubleClick", root,
	function( button, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
		if ( button == "left" ) then
			
			if ( clickedElement ) and ( getElementType( clickedElement ) == "vehicle" ) then
				if ( getData( localPlayer, "loggedin") == 1 and not isElement( interactWindow ) ) then
			
					createVehicleInteractUI( clickedElement )
				end	
			end
		end
	end
)

local theVehicle = nil
function createVehicleInteractUI( vehicle )
	
	local faction = tonumber( getData( localPlayer, "faction" ) )
	local duty = tonumber( getData( localPlayer, "duty" ) )
	
	if ( faction == 4 and duty == 1 ) then
		
		theVehicle = vehicle
		
		local width, height = 350, 240
		local x, y = (screenX/2) - (width/2), (screenY/2) - (height/2)
		
		interactWindow = guiCreateWindow(x, y, width, height, "Bone County Vehicle Services", false)
		interactLabel = guiCreateLabel(20, 30, 340, 40, "Select an option to be performed on this vehicle.", false, interactWindow)
		
		buttonRepair = guiCreateButton(115, 70, 120, 30, "Repair ( $50 )", false, interactWindow)
		addEventHandler("onClientGUIClick", buttonRepair,
			function( button, state )
				
				triggerServerEvent("repairVehicle", localPlayer, theVehicle)
			end, false
		)
		
		buttonRefuel = guiCreateButton(115, 110, 120, 30, "Refuel ( $100 )", false, interactWindow)
		addEventHandler("onClientGUIClick", buttonRefuel,
			function( button, state )
				
				triggerServerEvent("refuelVehicle", localPlayer, theVehicle)
			end, false
		)
		
		buttonPaint = guiCreateButton(115, 150, 120, 30, "Paint ( $300 )", false, interactWindow)
		addEventHandler("onClientGUIClick", buttonPaint,
			function( button, state )
				
				createPaintVehicleUI(  )
			end, false
		)
		
		buttonModify = guiCreateButton(115, 190, 120, 30, "Modification", false, interactWindow)
		addEventHandler("onClientGUIClick", buttonModify,
			function( button, state )
				
				createModifyVehicleUI(  )
			end, false
		)
		
		buttonClose = guiCreateButton(310, 200, 30, 30, "X", false, interactWindow)
		addEventHandler("onClientGUIClick", buttonClose,
			function( button, state )
				if ( button == "left" and state == "up" ) then
					
					destroyElement( interactWindow )
				end
			end, false
		)	
		
		guiSetFont(interactLabel, "clear-normal")
	end
end	

local color1, color2 = 0, 0
local newColor1, newColor2 = 0, 0
local redGreenBlue = { 0, 0, 0, 0, 0, 0 }
local orginalRedGreenBlue = { 0, 0, 0, 0, 0, 0 }
local lastChange = "default"

function createPaintVehicleUI(  )
	local width, height = 340, 250
	local x, y = (screenX/2) - (width/2), (screenY/2) - (height/2)
	
	guiSetVisible(interactWindow, false)
	
	paintWindow = guiCreateWindow(x, y, width, height, "Paint Vehicle", false)
	paintLabelOne = guiCreateLabel(20, 30, 300, 20, "Enter the color IDs to change the vehicle's color", false, paintWindow)
	
	local customColors = tonumber( getData( theVehicle, "custom_color") )
	
	local isVehicleCustomColored = false
	if ( customColors == 1 ) then
		isVehicleCustomColored = true
	end
	
	if ( isVehicleCustomColored ) then
		local red1, green1, blue1, red2, green2, blue2 = getVehicleColor( theVehicle, true )
		orginalRedGreenBlue = { red1, green1, blue1, red2, green2, blue2 }
		redGreenBlue = { red1, green1, blue1, red2, green2, blue2 }
	else	
		color1, color2 = getVehicleColor( theVehicle )
		newColor1, newColor2 = color1, color2
	end
	
	color1Label = guiCreateLabel(50, 60, 50, 20, "Color 1:", false, paintWindow)
	color1Edit = guiCreateEdit(105, 60, 130, 17, "", false, paintWindow)
	
	color2Label = guiCreateLabel(50, 80, 50, 20, "Color 2:", false, paintWindow)
	color2Edit = guiCreateEdit(105, 80, 130, 17, "", false, paintWindow)
	
	addEventHandler("onClientGUIChanged", color1Edit, showVehiclePainted, false)
	addEventHandler("onClientGUIChanged", color2Edit, showVehiclePainted, false)
	
	paintLabelTwo = guiCreateLabel(20, 110, 300, 20, "Or, enter the RGB values separated by comma.", false, paintWindow)
	
	rgb1Label = guiCreateLabel(50, 140, 50, 20, "Color 1:", false, paintWindow)
	rgb1Edit = guiCreateEdit(105, 140, 130, 17, "", false, paintWindow)
	
	rgb2Label = guiCreateLabel(50, 160, 50, 20, "Color 2:", false, paintWindow)
	rgb2Edit = guiCreateEdit(105, 160, 130, 17, "", false, paintWindow)
	
	addEventHandler("onClientGUIChanged", rgb1Edit, showVehiclePainted, false)
	addEventHandler("onClientGUIChanged", rgb2Edit, showVehiclePainted, false)
	
	buttonDone = guiCreateButton(30, 210, 110, 20, "Done", false, paintWindow)
	addEventHandler("onClientGUIClick", buttonDone,
		function( button, state )
			
			destroyElement(paintWindow)
			destroyElement(palleteWindow)
			
			guiSetVisible(interactWindow, true)
			
			if ( lastChange == "default" ) then
				triggerServerEvent("repaintVehicle", localPlayer, theVehicle, newColor1, newColor2)
			else
				triggerServerEvent("repaintVehicle", localPlayer, theVehicle, redGreenBlue)
			end
			
		end, false
	)
	
	buttonCancel = guiCreateButton(200, 210, 110, 20, "Cancel", false, paintWindow)
	addEventHandler("onClientGUIClick", buttonCancel,
		function( button, state )
			
			if ( isVehicleCustomColored ) then
				setVehicleColor(theVehicle, unpack(orginalRedGreenBlue))
			else
				setVehicleColor(theVehicle, color1, color2, 0, 0)
			end	
			
			destroyElement(paintWindow)
			destroyElement(palleteWindow)
			
			guiSetVisible(interactWindow, true)
		end, false
	)
	
	palleteWindow = guiCreateWindow(10, 10, 600, 240, "", false)
	paintPallete = guiCreateStaticImage(10, 20, 580, 229, "lsvs/gui/color.png", false, palleteWindow)
	
	guiMoveToBack(palleteWindow)
	
	guiSetFont(paintLabelOne, "clear-normal")
	guiSetFont(paintLabelTwo, "clear-normal")
	
	guiSetFont(color1Label, "clear-normal")
	guiSetFont(color2Label, "clear-normal")
	
	guiSetFont(rgb1Label, "clear-normal")
	guiSetFont(rgb2Label, "clear-normal")
end

function showVehiclePainted( )
	local color = guiGetText( source )
	if ( color ~= "" ) then
		
		if ( source == color1Edit or source == color2Edit ) then
			
			lastChange = "default"
			
			if ( source == color1Edit ) then
				setVehicleColor(theVehicle, color, newColor2, 0, 0)
				
				newColor1 = color
			else
				setVehicleColor(theVehicle, newColor1, color, 0, 0)
				
				newColor2 = color
			end
		elseif ( source == rgb1Edit or source == rgb2Edit ) then
			
			lastChange = "custom"
			
			local first, second = getEnteredRGBValue( color )
			if ( first ~= nil ) and ( second ~= nil ) then
				
				local red = color:sub( 1, first - 1 )
				local green = color:sub( first + 1, second - 1 )
				local blue = color:sub( second + 1)
				
				if ( red == "" ) then
					red = 0
				end

				if ( green == "" ) then
					green = 0
				end
				
				if ( blue == "" ) then
					blue = 0
				end	
				
				if ( source == rgb1Edit ) then
					
					redGreenBlue[1] = red
					redGreenBlue[2] = green
					redGreenBlue[3] = blue
					
					setVehicleColor(theVehicle, unpack( redGreenBlue ))
				else
					
					redGreenBlue[4] = red
					redGreenBlue[5] = green
					redGreenBlue[6] = blue
					
					setVehicleColor(theVehicle, unpack( redGreenBlue ))
				end
			end
		end	
	end	
end

function getEnteredRGBValue( text )
	local t = { }
	
	for i = 1, string.len( text ) do
		
		local char = string.sub( text, i, i )
		if ( char == "," ) then
			
			table.insert(t, i)
		end
	end
	
	local first, second = nil, nil
	if ( #t == 2 ) then
		first = t[1]
		second = t[2]
	end	

	return first, second
end

local vehicleModifications = 
{
	{ 1000, "Spoiler", "Pro" },
	{ 1001, "Spoiler", "Win" },
	{ 1002, "Spoiler", "Drag" },
	{ 1003, "Spoiler", "Alpha" },
	{ 1004, "Hood", "Champ Scoop" },
	{ 1005, "Hood", "Fury Scoop" },
	{ 1006, "Hood", "Roof Scoop" },
	{ 1007, "Sideskirt", "Right Skirt" },
	{ 1011, "Hood", "Race Scoop" },
	{ 1012, "Hood", "Worx Scoop" },
	{ 1013, "Lamps", "Round Fog" },
	{ 1014, "Spoiler", "Champ" },
	{ 1015, "Spoiler", "Race" },
	{ 1016, "Spoiler", "Worx" },
	{ 1017, "Sideskirt", "Left Skirt" },
	{ 1018, "Exhaust", "Upswept" },
	{ 1019, "Exhaust", "Twin" },
	{ 1020, "Exhaust", "Large" },
	{ 1021, "Exhaust", "Medium" },
	{ 1022, "Exhaust", "Small" },
	{ 1023, "Spoiler", "Fury" },
	{ 1024, "Lamps", "Square Fog" },
	{ 1025, "Wheels", "Offroad" },
	{ 1026, "Sideskirt", "Right Alient Skirt" },
	{ 1027, "Sideskirt", "Left Alient Skirt" },
	{ 1028, "Exhaust", "Alien" },
	{ 1029, "Exhaust", "X-Flow" },
	{ 1030, "Sideskirt", "Left X-Flow Skirt" },
	{ 1031, "Sideskirt", "Right X-Flow Skirt" },
	{ 1032, "Roof", "Alient Roof Vent" },
	{ 1033, "Roof", "X-Flow Roof Vent" },
	{ 1034, "Exhaust", "Alient" },
	{ 1035, "Roof", "X-Flow Roof Vent" },
	{ 1036, "Sideskirt", "Right Alien Skirt" },
	{ 1037, "Exhaust", "X-Flow" },
	{ 1038, "Roof", "Alien Roof Vent" },
	{ 1039, "Sideskirt", "Left X-Flow Skirt" },
	{ 1040, "Sideskirt", "Left Alien Skirt" },
	{ 1041, "Sideskirt", "Right X-Flow Skirt" },
	{ 1042, "Sideskirt", "Right Chrome Skirt" },
	{ 1043, "Exhaust", "Slamin" },
	{ 1044, "Exhaust", "Chrome" },
	{ 1045, "Exhaust", "X-Flow" },
	{ 1046, "Exhaust", "Alien" },
	{ 1047, "Sideskirt", "Right Alien Skirt" },
	{ 1048, "Sideskirt", "Right X-Flow Skirt" },
	{ 1049, "Spoiler", "Alien" },
	{ 1050, "Spolier", "X-Flow" },
	{ 1051, "Sideskirt", "Left Alien Skirt" },
	{ 1052, "Sideskirt", "Left X-Flow Skirt" },
	{ 1053, "Roof", "X-Flow" },
	{ 1054, "Roof", "Alien" },
	{ 1055, "Roof", "Alien" },
	{ 1056, "Sideskirt", "Right Alien Skirt" },
	{ 1057, "Sideskirt", "Right X-Flow Skirt" },
	{ 1058, "Spolier", "Alien" },
	{ 1059, "Exhaust", "X-Flow" },
	{ 1060, "Spolier", "X-Flow" },
	{ 1061, "Roof", "X-Flow" },
	{ 1062, "Sideskirt", "Left Alien Skirt" },
	{ 1063, "Sideskirt", "Left X-Flow Skirt" },
	{ 1064, "Exhaust", "Alien" },
	{ 1065, "Exhaust", "Alien" },
	{ 1066, "Exhaust", "X-Flow" },
	{ 1067, "Roof", "Alien" },
	{ 1068, "Roof", "X-Flow" },
	{ 1069, "Sideskirt", "Right Alien Skirt" },
	{ 1070, "Sideskirt", "Right X-Flow Skirt" },
	{ 1071, "Sideskirt", "Left Alien Skirt" },
	{ 1072, "Sideskirt", "Left X-Flow Skirt" },
	{ 1073, "Wheels", "Shadow" },
	{ 1074, "Wheels", "Mega" },
	{ 1075, "Wheels", "Rimshine" },
	{ 1076, "Wheels", "Wires" },
	{ 1077, "Wheels", "Classic" },
	{ 1078, "Wheels", "Twist" },
	{ 1079, "Wheels", "Cutter" },
	{ 1080, "Wheels", "Switch" },
	{ 1081, "Wheels", "Grove" },
	{ 1082, "Wheels", "Import" },
	{ 1083, "Wheels", "Dollar" },
	{ 1084, "Wheels", "Trance" },
	{ 1085, "Wheels", "Atomic" },
	{ 1087, "Hydraulics", "Hydraulics" },
	{ 1088, "Roof", "Alien" },
	{ 1089, "Exhaust", "X-Flow" },
	{ 1090, "Sideskirt", "Right Alien Skirt" },
	{ 1091, "Roof", "X-Flow" },
	{ 1092, "Exhaust", "Alien" },
	{ 1093, "Sideskirt", "Right X-Flow Skirt" },
	{ 1094, "Sideskirt", "Left Alien Skirt" },
	{ 1095, "Sideskirt", "Right X-Flow Skirt" },
	{ 1096, "Wheels", "Ahab" },
	{ 1097, "Wheels", "Virtual" },
	{ 1098, "Wheels", "Access" },
	{ 1099, "Sideskirt", "Left Chrome Skirt" },
	{ 1100, "Bullbar", "Chrome Grill" },
	{ 1101, "Sideskirt", "Left `Chrome Flames` Skirt" },
	{ 1102, "Sideskirt", "Left `Chrome Srip` Skirt" },
	{ 1103, "Roof", "Covertible" },
	{ 1104, "Exhaust", "Chrome" },
	{ 1105, "Exhaust", "Slamin" },
	{ 1106, "Sideskirt", "Right `Chrome Arches`" },
	{ 1107, "Sideskirt", "Left `Chrome Strip` Skirt" },
	{ 1108, "Sideskirt", "Right `Chrome Strip` Skirt" },
	{ 1109, "Rear Bullbars", "Chrome" },
	{ 1110, "Rear Bullbars", "Slamin" },
	{ 1111, "Front Sign?", "Little Sign?" },
	{ 1112, "Front Sign?", "Little Sign?" },
	{ 1113, "Exhaust", "Chrome" },
	{ 1114, "Exhaust", "Slamin" },
	{ 1115, "Front Bullbars", "Chrome" },
	{ 1116, "Front Bullbars", "Slamin" },
	{ 1117, "Front Bumper", "Chrome" },
	{ 1118, "Sideskirt", "Right `Chrome Trim` Skirt" },
	{ 1119, "Sideskirt", "Right `Wheelcovers` Skirt" },
	{ 1120, "Sideskirt", "Left `Chrome Trim` Skirt" },
	{ 1121, "Sideskirt", "Left `Wheelcovers` Skirt" },
	{ 1122, "Sideskirt", "Right `Chrome Flames` Skirt" },
	{ 1123, "Bullbars", "Bullbar Chrome Bars" },
	{ 1124, "Sideskirt", "Left `Chrome Arches` Skirt" },
	{ 1125, "Bullbars", "Bullbar Chrome Lights" },
	{ 1126, "Exhaust", "Chrome Exhaust" },
	{ 1127, "Exhaust", "Slamin Exhaust" },
	{ 1128, "Roof", "Vinyl Hardtop" },
	{ 1129, "Exhaust", "Chrome" },
	{ 1130, "Roof", "Hardtop" },
	{ 1131, "Roof", "Softtop" },
	{ 1132, "Exhaust", "Slamin" },
	{ 1133, "Sideskirt", "Right `Chrome Strip` Skirt" },
	{ 1134, "Sideskirt", "Right `Chrome Strip` Skirt" },
	{ 1135, "Exhaust", "Slamin" },
	{ 1136, "Exhaust", "Chrome" },
	{ 1137, "Sideskirt", "Left `Chrome Strip` Skirt" },
	{ 1138, "Spoiler", "Alien" },
	{ 1139, "Spolier", "X-Flow" },
	{ 1140, "Rear Bumper", "X-Flow" },
	{ 1141, "Rear Bumper", "Alien" },
	{ 1142, "Vents", "Left Oval Vents" },
	{ 1143, "Vents", "Right Oval Vents" },
	{ 1144, "Vents", "Left Square Vents" },
	{ 1145, "Vents", "Right Square Vents" },
	{ 1146, "Spoiler", "X-Flow" },
	{ 1147, "Spoiler", "Alien" },
	{ 1148, "Rear Bumper", "X-Flow" },
	{ 1149, "Rear Bumper", "Alien" },
	{ 1150, "Rear Bumper", "Alien" },
	{ 1151, "Rear Bumper", "X-Flow" },
	{ 1152, "Front Bumper", "X-Flow" },
	{ 1153, "Front Bumper", "Alien" },
	{ 1154, "Rear Bumper", "Alien" },
	{ 1155, "Front Bumper", "Alien" },
	{ 1156, "Rear Bumper", "X-Flow" },
	{ 1157, "Front Bumper", "X-Flow" },
	{ 1158, "Spoiler", "X-Flow" },
	{ 1159, "Rear Bumper", "Alien" },
	{ 1160, "Front Bumper", "Alien" },
	{ 1161, "Rear Bumper", "X-Flow" },
	{ 1162, "Spoiler", "Alien" },
	{ 1163, "Spoiler", "X-Flow" },
	{ 1164, "Spoiler", "Alien" },
	{ 1165, "Front Bumper", "X-Flow" },
	{ 1166, "Front Bumper", "Alien" },
	{ 1167, "Rear Bumper", "X-Flow" },
	{ 1168, "Rear Bumper", "Alien" },
	{ 1169, "Front Bumper", "Alien" },
	{ 1170, "Front Bumper", "X-Flow" },
	{ 1171, "Front Bumper", "Alien" },
	{ 1172, "Front Bumper", "X-Flow" },
	{ 1173, "Front Bumper", "X-Flow" },
	{ 1174, "Front Bumper", "Chrome" },
	{ 1175, "Rear Bumper", "Slamin" },
	{ 1176, "Front Bumper", "Chrome" },
	{ 1177, "Rear Bumper", "Slamin" },
	{ 1178, "Rear Bumper", "Slamin" },
	{ 1179, "Front Bumper", "Chrome" },
	{ 1180, "Rear Bumper", "Chrome" },
	{ 1181, "Front Bumper", "Slamin" },
	{ 1182, "Front Bumper", "Chrome" },
	{ 1183, "Rear Bumper", "Slamin" },
	{ 1184, "Rear Bumper", "Chrome" },
	{ 1185, "Front Bumper", "Slamin" },
	{ 1186, "Rear Bumper", "Slamin" },
	{ 1187, "Rear Bumper", "Chrome" },
	{ 1188, "Front Bumper", "Slamin" },
	{ 1189, "Front Bumper", "Chrome" },
	{ 1190, "Front Bumper", "Slamin" },
	{ 1191, "Front Bumper", "Chrome" },
	{ 1192, "Rear Bumper", "Chrome" },
	{ 1193, "Rear Bumper", "Slamin" }
}

local prices = 
{
	["Spoiler"] = 300, ["Hood"] = 300, ["Sideskirt"] = 200, ["Lamps"] = 50, ["Exhaust"] = 150, ["Wheels"] = 250, 
	["Roof"] = 150, ["Hydraulics"] = 100, ["Bullbars"] = 250, ["Front Bullbars"] = 250, ["Rear Bullbars"] = 250, 
	["Front Sign?"] = 0, ["Front Bumper"] = 250, ["Rear Bumper"] = 250, ["Vents"] = 150
}

local j = nil
function createModifyVehicleUI( )
	local width, height = 360, 430
	local x, y = (screenX/2) - (width/2), (screenY/2) - (height/2)
	
	guiSetVisible(interactWindow, false)
	
	modificationWindow = guiCreateWindow(x, y, width, height, "Vehicle Modifications", false)
	modificationLabel = guiCreateLabel(20, 30, 320, 20, "Select an available modification from the list below", false, modificationWindow)
	
	modificationList = guiCreateGridList(20, 55, 320, 315, false, modificationWindow)
	
	guiGridListAddColumn(modificationList, "Part", 0.35)
	guiGridListAddColumn(modificationList, "Type", 0.35)
	guiGridListAddColumn(modificationList, "Price ($)", 0.2)
	
	j = getVehicleUpgrades( theVehicle )
	
	local list = getSuitableModifications( theVehicle )
	for key, value in ipairs ( list ) do
		
		local id = vehicleModifications[value][1] 
		local part = vehicleModifications[value][2] 
		local price = prices[part]
		local type = vehicleModifications[value][3]
		
		local row = guiGridListAddRow(modificationList)
		
		guiGridListSetItemText(modificationList, row, 1, tostring(part), false, false)
		guiGridListSetItemData(modificationList, row, 1, tostring(id))
		
		guiGridListSetItemText(modificationList, row, 2, tostring(type), false, false)
		guiGridListSetItemText(modificationList, row, 3, tostring(price), false, false)
	end
	
	buttonShowModification = guiCreateButton(20, 380, 80, 30, "Show", false, modificationWindow)
	addEventHandler("onClientGUIClick", buttonShowModification, setVehicleUpgrade, false)
	
	buttonAddModification = guiCreateButton(125, 380, 80, 30, "Add", false, modificationWindow)
	addEventHandler("onClientGUIClick", buttonAddModification, setVehicleUpgrade, false)
	
	buttonCancelModification = guiCreateButton(230, 380, 100, 30, "Cancel", false, modificationWindow)
	addEventHandler("onClientGUIClick", buttonCancelModification,
		function( button, state )
			if ( button == "left" and state == "up" ) then
				
				destroyElement( modificationWindow )
				guiSetVisible( interactWindow, true )
				
				if ( #j == 0 ) then
					
					for key, value in ipairs ( getVehicleUpgrades( theVehicle ) ) do
						removeVehicleUpgrade( theVehicle, value )
					end
				else	
					for i = 1, #j do
						addVehicleUpgrade( theVehicle, j[i] )
					end
				end	
			end
		end, false
	)
	
	guiSetFont(modificationLabel, "clear-normal")
end

function setVehicleUpgrade( button, state )
	if ( button == "left" and state == "up" ) then
		
		local row = guiGridListGetSelectedItem( modificationList )
		if ( row > -1 ) then
			
			local upgradeID = guiGridListGetItemData( modificationList, row, 1 )
			local upgradeName = guiGridListGetItemText( modificationList, row, 1 )
			local upgradePrice = guiGridListGetItemText( modificationList, row, 3 )
			if ( upgradeID ) then
				
				if ( source == buttonShowModification ) then
			
					addVehicleUpgrade( theVehicle, tonumber( upgradeID ) )
				else
					triggerServerEvent("addVehicleModification", localPlayer, theVehicle, upgradeID, upgradeName, upgradePrice )
				end	
			end
		end	
	end	
end

function getSuitableModifications( vehicle )
	
	local t = { }
	
	for key, value in ipairs ( vehicleModifications ) do
		
		local success = addVehicleUpgrade( vehicle, value[1] )
		if ( success ) then
			
			table.insert( t, key )
			removeVehicleUpgrade( vehicle, value[1] )	
		end
	end
	
	for i = 1, #j do
		addVehicleUpgrade( vehicle, j[i] )
	end
	
	return t
end

function updateVehicleUpgrades( g )
	j = g
end
addEvent("updateVehicleUpgrades", true)
addEventHandler("updateVehicleUpgrades", localPlayer, updateVehicleUpgrades)