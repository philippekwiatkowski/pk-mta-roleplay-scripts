local screenX, screenY = guiGetScreenSize()

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

local questions = { }
questions[1] = { }
questions[1][1] = { "If you plan to pass another vehicle, you should:", nil }
questions[1][2] = { "Not assume the other driver will make space for you to return.", true }
questions[1][3] = { "Assume the other driver will let you pass if you use you blinkers.", false }
questions[1][4] = { "Assume the other driver will maintain a constant speed.", false }

questions[2] = { }
questions[2][1] = { "If an officer believes you are driving under the influence:", nil }
questions[2][2] = { "You can refuse to be tested for the presence of alcohol or drugs.", false }
questions[2][3] = { "You can refuse to be tested only if it is your first offense.", false }
questions[2][4] = { "You cannot refuse to be tested for the presence of alcohol or drugs.", true }

questions[3] = { }
questions[3][1] = { "You should buckle your seat belt and make sure your passengers\ndo the same:", nil }
questions[3][2] = { "When it's raining or snowing.", false }
questions[3][3] = { "When you are getting ready to drive, before you start the engine.", true }
questions[3][4] = { "Only when you're going on a long trip.", false }

questions[4] = { }
questions[4][1] = { "You may legally block an intersection:", nil }
questions[4][2] = { "When you entered the intersection on the green light.", false }
questions[4][3] = { "During rush hour traffic.", false }
questions[4][4] = { "Under no circumstances.", true }

questions[5] = { }
questions[5][1] = { "Roadways are the most slippery:", nil }
questions[5][2] = { "During a heavy downpour.", false }
questions[5][3] = { "After it has been raining for awhile.", false }
questions[5][4] = { "The first rain after a dry spell.", true }

questions[6] = { }
questions[6][1] = { "At intersections, crosswalks, and railroad crossings, you should\nalways:", nil }
questions[6][2] = { "Stop, listen, and proceed cautiously.", false }
questions[6][3] = { "Look to the sides of your vehicle to see what is coming.", true }
questions[6][4] = { "Slowly pass vehicles that seem to be stopped for no reason.", false }

questions[7] = { }
questions[7][1] = { "You drive defensively when you:", nil }
questions[7][2] = { "Always put one car length between you and the car ahead.", false }
questions[7][3] = { "Look only at the car in front of you while driving.", false }
questions[7][4] = { "Keep your eyes moving to look for possible hazards.", true }

questions[8] = { }
questions[8][1] = { "When you tailgate other drivers (drive close to their rear bumper):", nil }
questions[8][2] = { "You can frustrate the other drivers and make them angry.", true }
questions[8][3] = { "Your actions cannot result in a traffic citation.", false }
questions[8][4] = { "You help reduce traffic congestion.", false }

questions[9] = { }
questions[9][1] = { "Should you always drive slower than other traffic?", nil }
questions[9][2] = { "No, you can block traffic when you drive too slowly.", true }
questions[9][3] = { "Yes, it is a good defensive driving technique.", false }
questions[9][4] = { "Yes, it is always safer than driving faster than other traffic.", false }

questions[10] = { }
questions[10][1] = { "You are getting ready to make a right turn. You should:", nil }
questions[10][2] = { "Signal and turn immediately.", false }
questions[10][3] = { "Stop before entering the right lane and let all other traffic go first.", false }
questions[10][4] = { "Slow down or stop, if necessary, and then make the turn.", true }

questions[11] = { }
questions[11][1] = { "There is no crosswalk and you see a pedestrian crossing your\nlane ahead.\nYou should:", nil }
questions[11][2] = { "Make eye contact and then pass him/her.", false }
questions[11][3] = { "Slow down as you pass him/her.", false }
questions[11][4] = { "Stop and let him/her finish crossing the street.", true }

questions[12] = { }
questions[12][1] = { "Stopping distances on slippery roads are:", nil }
questions[12][2] = { "About the same as on dry pavement.", false }
questions[12][3] = { "A little less than on dry pavement.", false }
questions[12][4] = { "2 to 10 times greater than on dry pavement.", true }

questions[13] = { }
questions[13][1] = { "When you hear the siren or see the flashing lights of an emergency\nvehicle, you must:", nil }
questions[13][2] = { "Drive to the right side of the road and stop.", true }
questions[13][3] = { "Slow down until it passes you.", false }
questions[13][4] = { "Continue at the same speed, but pull to the right.", false }

questions[14] = { }
questions[14][1] = { "If you drive faster than other vehicles on a road with one lane in\neach direction and continually pass the other cars, you will:", nil }
questions[14][2] = { "Get you to your destination much faster and safer.", false }
questions[14][3] = { "Increase your chances of an accident.", true }
questions[14][4] = { "Help prevent traffic congestion.", false }

questions[15] = { }
questions[15][1] = { "The safest precaution that you can take regarding the use of cell\nphones and driving is:", nil }
questions[15][2] = { "Use hands-free devices so you can keep both hands on the wheel.", true }
questions[15][3] = { "Keep your phone within easy reach so you can see the road.", false }
questions[15][4] = { "Review the number before answering a call.", false }


--------- [ Department of Motor Vehicles System ] ---------
local employee = nil
function createEmployee( res )
	employee = createPed(147, -2035.0185, -118.3505, 1035.1718)
	
	setPedRotation(employee, 273)
	setElementInterior(employee, 3)
	setElementDimension(employee, 3)
end
addEventHandler("onClientResourceStart", resourceRoot, createEmployee)	

addEventHandler("onClientClick", root,
	function( button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
		if ( button == "right" and state == "up" ) then
			if (clickedElement) and (clickedElement == employee) then
		
				if ( getData( localPlayer, "loggedin") == 1 ) and ( not isElement( motorVehicleWindow ) ) then
					
					createMotorVehicleUI( )
				end	
			end
		end
	end
)

function createMotorVehicleUI(  )
	local width, height = 420, 210
	local x, y = (screenX/2) - (width/2), (screenY/2) - (height/2)
	
	motorVehicleWindow = guiCreateWindow(x, y, width, height, "Department of Motor Vehicles", false)
	motorVehicleLabel = guiCreateLabel(20, 30, 380, 20, "Which of the following licenses would you like to apply for?", false, motorVehicleWindow)
	
	licensesList = guiCreateGridList(20, 50, 380, 110, false, motorVehicleWindow)
	
	guiGridListAddColumn( licensesList, "Type", 0.5 )
	guiGridListAddColumn( licensesList, "Price", 0.4 )
	
	local drivingLicense = tonumber( getData( localPlayer, "d:license") )
	if ( drivingLicense == 0 ) then
		local row = guiGridListAddRow( licensesList )
		
		guiGridListSetItemText(licensesList, row, 1, "Driving License", false, false)
		guiGridListSetItemText(licensesList, row, 2, "$150", false, false)
	end	
	
	buttonApplyLicense = guiCreateButton(40, 170, 110, 20, "Apply", false, motorVehicleWindow)
	addEventHandler("onClientGUIClick", buttonApplyLicense,
		function( button, state )
			if ( button == "left" and state == "up" ) then
				
				local selected = guiGridListGetSelectedItem( licensesList )
				if ( selected ~= -1 ) then
					
					local money = tonumber( getPlayerMoney(localPlayer)/100 )
					if ( money >= 150 ) then
						
						showDrivingLicenseExam( )
						
						triggerServerEvent("takeMoney", localPlayer, 50)
						triggerServerEvent("giveMoneyToGovernment", localPlayer, 50)
					else
						outputChatBox("You do not have enough money.", 255, 0, 0)
					end	
				end	
			end
		end
	)	
	
	buttonCancelApply = guiCreateButton(270, 170, 110, 20, "Cancel", false, motorVehicleWindow)
	addEventHandler("onClientGUIClick", buttonCancelApply,
		function( button, state )
			if ( button == "left" and state == "up" ) then
				
				destroyElement( motorVehicleWindow )
			end
		end
	)	
	
	guiSetFont(motorVehicleLabel, "clear-normal")
end

function showDrivingLicenseExam( )
	
	guiSetSize(motorVehicleWindow, 420, 150, false)
	
	destroyElement( motorVehicleLabel )
	destroyElement( licensesList )
	destroyElement( buttonApplyLicense )
	destroyElement( buttonCancelApply )
	
	examLabel = guiCreateLabel(20, 30, 380, 30, "You need to pass an Examination before you proceed to the\nDriving Test. You must get about 60% in this Quiz to pass.", false, motorVehicleWindow)
	guiSetFont(examLabel, "clear-normal")
	
	buttonStartExam = guiCreateButton(155, 90, 110, 30, "Start Exam", false, motorVehicleWindow)
	addEventHandler("onClientGUIClick", buttonStartExam, 
		function( button, state )
			if ( button == "left" and state == "up" ) then
				
				guiSetSize(motorVehicleWindow, 460, 180, false)
	
				destroyElement( examLabel )
				destroyElement( source )
				
				-- Create Question
				createQuestion( )
			end
		end, false
	)	
end

local taken = { }
local radioButtons = { }
local questionNo = 0
local points = 0
function createQuestion( )
	if ( questionNo ~= 10 ) then
		
		local rand = getRandomQuestion( )
		if ( rand == false ) then
			createQuestion( )
		else
			
			local question = questions[rand][1][1]
			local answerOne = questions[rand][2][1]
			local answerTwo = questions[rand][3][1]
			local answerThree = questions[rand][4][1]
			
			local correct = nil
			if ( questions[rand][2][2] ) then
				correct = 1
			elseif ( questions[rand][3][2] ) then
				correct = 2
			elseif ( questions[rand][4][2] ) then
				correct = 3 
			end	
		
			questionNo = questionNo + 1
			
			questionLabel = guiCreateLabel(20, 30, 420, 30, "Q".. tostring(questionNo) ..". ".. tostring(question), false, motorVehicleWindow)
			
			radioOne = guiCreateRadioButton(20, 60, 420, 30, tostring(answerOne), false, motorVehicleWindow)
			radioTwo = guiCreateRadioButton(20, 80, 420, 30, tostring(answerTwo), false, motorVehicleWindow)
			radioThree = guiCreateRadioButton(20, 100, 420, 30, tostring(answerThree), false, motorVehicleWindow)
			
			guiRadioButtonSetSelected( radioOne, true )
			
			radioButtons = { radioOne, radioTwo, radioThree }
			
			buttonNextQuestion = guiCreateButton(340, 140, 100, 20, "Next", false, motorVehicleWindow)
			addEventHandler("onClientGUIClick", buttonNextQuestion,
				function( button, state )
					
					local selected = false
					for key, value in ipairs ( radioButtons ) do
						if ( guiRadioButtonGetSelected( value ) ) then
							selected = key
						end	
					end	
					
					
					if ( selected == correct ) then
						points = points + 1
					end
					
					destroyElement( questionLabel )
					for key, value in ipairs ( radioButtons ) do
						destroyElement( value )
					end	
					
					radioButtons = { }
					
					destroyElement( buttonNextQuestion )
					destroyElement( buttonQuitExam )
		
					-- Again!
					createQuestion( )
				end, false
			)	
			
			buttonQuitExam = guiCreateButton(20, 140, 100, 20, "Quit", false, motorVehicleWindow)
			addEventHandler("onClientGUIClick", buttonQuitExam,
				function( button, state )
					if ( button == "left" and state == "up" ) then
						
						destroyElement( motorVehicleWindow )
					end
				end, false
			)	
			
			guiSetFont( radioOne, "default-bold-small")
			guiSetFont( radioTwo, "default-bold-small")
			guiSetFont( radioThree, "default-bold-small")
			
			guiSetFont( questionLabel, "default-bold-small")
		end	
	else
		guiSetSize(motorVehicleWindow, 450, 130, false)
		
		local text = ""
		local r, g, b = nil, nil, nil
		local x = 20
		if ( points >= 6 ) then
			text = "Congratulations! You obtained ".. tostring(points) .."0% in your exam and Passed!"
			r, g, b = 0, 255, 0
		else
			text = "Sorry, You only obtained ".. tostring(points) .."0% in your exam and Failed."
			r, g, b = 255, 0, 0
			x = 55
		end
		
		resultLabel = guiCreateLabel(x, 30, 430, 20, tostring(text), false, motorVehicleWindow)
		
		guiSetFont(resultLabel, "clear-normal")
		guiLabelSetColor(resultLabel, r, g, b)
		
		if ( r == 0 ) then
			triggerServerEvent("takeMoney", localPlayer, 100)
			triggerServerEvent("giveMoneyToGovernment", localPlayer, 100)
			
			triggerServerEvent("setPlayerStudent", localPlayer)
			
			outputChatBox("Please go outside and sit in one of the Previons to begin your Practical Test.", 0, 255, 0)
		end
		
		buttonEndExam = guiCreateButton(155, 80, 110, 30, "Close", false, motorVehicleWindow)
		addEventHandler("onClientGUIClick", buttonEndExam,
			function( button, state )
				if ( button == "left" and state == "up" ) then
					
					taken = { }
					radioButtons = { }
					questionNo = 0
					points = 0

					destroyElement( motorVehicleWindow )
				end
			end, false
		)	
	end	
end

function getRandomQuestion( )
	local rand = math.random(1, 15)
	
	local alreadyShown = false
	for key, value in pairs ( taken ) do
		if ( key == rand ) then
			
			alreadyShown = true
		end
	end
	
	if ( alreadyShown ) then
		return false
	else
		taken[rand] = true
		return rand
	end	
end

function selectExamOption( button, state )
	if ( button == "left" and state == "up" ) then
		
		guiRadioButtonSetSelected( source, true )
		
		for key, value in ipairs ( radioButtons ) do
			if ( value ~= source ) then
				guiRadioButtonSetSelected( source, false )
			end
		end	
	end	
end