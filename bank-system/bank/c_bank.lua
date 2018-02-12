local screenX, screenY = guiGetScreenSize()
local selectedRow = nil

local allowInteract = true

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

--------- [ Player's Bank Accounts ] ---------
local playerAccounts = nil
local receive = false

function receivePlayerBankAccounts( accounts )
	if (accounts) then
		playerAccounts = accounts
		receive = true
	else
		receive = false
	end	
end
addEvent("receivePlayerBankAccounts", true)
addEventHandler("receivePlayerBankAccounts", localPlayer, receivePlayerBankAccounts)

function receiveChange( bool )
	if ( bool == true ) then
		receive = true
	elseif ( bool == false ) then
		receive = false
	end
end

--------- [ Bank Employee ] ---------
local employee = nil
function createEmployee( res )
	employee = createPed(187, 359.7148, 173.6015, 1008.3893)
	
	setPedRotation(employee, 270)
	setElementInterior(employee, 3)
	setElementDimension(employee, 2)
end
addEventHandler("onClientResourceStart", resourceRoot, createEmployee)	

--------- [ Bank Access ] ---------
local allowOpen = true
function onEmployeeClick(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if (getData(getLocalPlayer(), "loggedin") == 1) and (not isElement(bankWindow)) then
		
		if (button == "right" and state == "up") then
			
			if (clickedElement) and (clickedElement == employee) then
				
				if ( allowOpen ) then
					allowOpen = false
					
					triggerServerEvent("sendPlayerBankAccounts", localPlayer)
					checkReceive( )
					
					setTimer( function( ) allowOpen = true end, 3000, 1 )
				end	
			end	
		end
	end
end
addEventHandler("onClientClick", root, onEmployeeClick) 
	
local checkTimer = nil
function checkReceive( )
	if (not receive) then
		checkTimer = setTimer(checkReceive, 1500, 1)
		
	elseif (receive) then
		receive = false
		
		if isTimer(checkTimer) then
			killTimer(checkTimer)
		end
		
		showBankUI( )
	end
end

function showBankUI( )
	if ( getData( localPlayer, "bank:showing") == 0 ) then
		
		bankWidth, bankHeight = 480, 240
		bankX, bankY = (screenX/2) - (bankWidth/2), (screenY/2) - (bankHeight/2)
		
		-- Elements
		bankWindow = guiCreateWindow(bankX, bankY, bankWidth, bankHeight, "Credit & Commerce Bank", false)
		
		welcomeLbl = guiCreateLabel(20, 30, 440, 20, "Welcome to the Credit & Commerce Bank, what would you like to do?", false, bankWindow)
		answerLbl = guiCreateLabel(195, 60, 90, 20, "I would like to..", false, bankWindow)
		
		local optionViewX, optionViewY = 140, 80
		local optionNewX, optionNewY = 140, 140
		closeX, closeY = 440, 200

		if ( #playerAccounts ~= 0 ) then
			optionView = guiCreateButton(optionViewX, optionViewY, 190, 50, "View my accounts", false, bankWindow)
			addEventHandler("onClientGUIClick", optionView, bankFunctions, false)
		else
			optionNewX, optionNewY = 140, 80
			bankWidth, bankHeight = 480, 180
			
			guiSetSize(bankWindow, bankWidth, bankHeight, false)
			closeX, closeY = 440, 140
		end
		
		if ( #playerAccounts < 3 ) then
			optionNew = guiCreateButton(optionNewX, optionNewY, 190, 50, "Open a new account", false, bankWindow) 
			addEventHandler("onClientGUIClick", optionNew, bankFunctions, false)
		else
			guiSetSize(bankWindow, bankWidth, bankHeight - 90, false)
			closeX, closeY = 440, 110
		end
		
		btnExit = guiCreateButton(closeX, closeY, 30, 30, "X", false, bankWindow) 
		addEventHandler("onClientGUIClick", btnExit, 
		function( button, state )
			if ( button == "left" and state == "up" ) then
			
				destroyElement(bankWindow)
				bankWindow = nil
				
				setData(localPlayer, "bank:showing", 0, true)
				
				if ( guiGetInputEnabled( ) ) then
					guiSetInputEnabled(false)
				end	
			end	
		end, false)		
			
		guiSetFont(welcomeLbl, "clear-normal")
		guiSetFont(answerLbl, "default-bold-small")
			
		guiWindowSetSizable(bankWindow, false)
		
		setData(localPlayer, "bank:showing", 1, true)
		
		guiSetInputEnabled(true)
	end	
end

function populateAccountList( )
	if (accountList) then
		
		guiGridListClear(accountList)
		
		for i, v in ipairs ( playerAccounts ) do
			local row = guiGridListAddRow(accountList)
			
			guiGridListSetItemText(accountList, row, 1, tostring(i), false, false)
			guiGridListSetItemText(accountList, row, 2, tostring(v[1]), false, false)
			
			local balance = correctBalance( v[2] ) 
			
			guiGridListSetItemText(accountList, row, 3, "$".. tostring(tonumber(balance)), false, false)
			guiGridListSetItemText(accountList, row, 4, tostring(v[3]), false, false)
		end
	end	
end

-- Correct the balance stored in the database
function correctBalance( balance ) 
	local len = string.len(balance) 
	
	return string.sub(balance, 1, len - 2) ..".".. string.sub(balance, len - 1, len) 
end

local alphabets = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "-"}
	
local made = false	
function receiveAccountCreateMessage( created )
	if (created) then
		made = true
	end	
end
addEvent("receiveAccountCreateMessage", true)
addEventHandler("receiveAccountCreateMessage", localPlayer, receiveAccountCreateMessage)

--------- [ View Account or New Account ] ---------
function bankFunctions( button, state )
	if ( button == "left" and state == "up" ) then
	
		if (source == optionView) then -- View Accounts
			
			guiSetSize(bankWindow, bankWidth, bankHeight, false)	
			
			guiSetText(welcomeLbl, "Which one of the following accounts would your like check and see?")
			guiSetText(answerLbl, "I'd like to see..")	
				
			accountList = guiCreateGridList(40, 80, 400, 100, false, bankWindow)
			guiGridListAddColumn(accountList, "Number", 0.2)
			guiGridListAddColumn(accountList, "ID", 0.275)
			guiGridListAddColumn(accountList, "Balance", 0.31)
			guiGridListAddColumn(accountList, "Pin", 0.15)
			
			populateAccountList( )
			
			guiSetPosition(btnExit, 440, 190, false)
			
			buttonBack = guiCreateButton(10, 190, 40, 40, "<--", false, bankWindow)
			addEventHandler("onClientGUIClick", buttonBack, 
			function( button, state )
				if ( button == "left" and state == "up" ) then
								
					returnToWindow(bankWindow)
				end
			end, false)	
				
			selectAccount = guiCreateButton(185, 190, 110, 30, "Select Account", false, bankWindow)
			addEventHandler("onClientGUIClick", selectAccount,
			function( button, state )
				if ( button == "left" and state == "up" ) then
						
					local row = guiGridListGetSelectedItem(accountList)
					if (row ~= -1) then
							
						selectedRow = row	
						
						if (selectedRow) then
							
							guiSetVisible(accountList, false)
							guiSetVisible(source, false)
							guiSetVisible(buttonBack, false)
								
							guiSetSize(bankWindow, 480, 360, false)
							guiSetPosition(welcomeLbl, 155, 30, false)
							
							guiSetPosition(btnExit, 440, 310, false)
							
							guiSetText(welcomeLbl, "what would you like to do?")
							guiSetText(answerLbl, "I would like to..")
							
							optionDeposit = guiCreateButton(140, 90, 190, 50, "Deposit Money", false, bankWindow) 
							optionWithdraw = guiCreateButton(140, 150, 190, 50, "Withdraw Money", false, bankWindow) 
							optionTransfer = guiCreateButton(140, 210, 190, 50, "Transfer Money", false, bankWindow)
							optionTransaction = guiCreateButton(140, 270, 190, 50, "View Transactions", false, bankWindow)
									
							addEventHandler("onClientGUIClick", optionDeposit, accountFunctions, false)
							addEventHandler("onClientGUIClick", optionWithdraw, accountFunctions, false)
							addEventHandler("onClientGUIClick", optionTransfer, accountFunctions, false)
							addEventHandler("onClientGUIClick", optionTransaction, accountFunctions, false)
								
							buttonBackAccount = guiCreateButton(10, 310, 40, 40, "<--", false, bankWindow)
							addEventHandler("onClientGUIClick", buttonBackAccount,
							function( button, state )
								if ( button == "left" and state == "up" ) then
									
									destroyElement(optionDeposit)
									destroyElement(optionWithdraw)
									destroyElement(optionTransfer)
									destroyElement(optionTransaction)
									
									guiSetSize(bankWindow, 480, 240, false)
										
									guiSetText(welcomeLbl, "Which one of the following accounts would your like check and see?")
									guiSetText(answerLbl, "I'd like to see..")	
										
									guiSetPosition(welcomeLbl, 20, 30, false)
									guiSetPosition(btnExit, 440, 190, false)
										
									guiSetVisible(accountList, true)
									guiSetVisible(source, true)
									guiSetVisible(buttonBack, true)
									guiSetVisible(selectAccount, true)
								end	
							end, false)		
						end
					else
						playSoundFrontEnd(32)
					end
				end	
			end, false)	
		
		elseif (source == optionNew) then
			
			local step = 1
			
			local accountDetails = { }
			
			guiSetVisible(welcomeLbl, false)
			guiSetVisible(answerLbl, false)
			
			guiSetSize(bankWindow, 480, 360, false)
			guiSetPosition(btnExit, 440, 310, false)
			
			requestLbl = guiCreateLabel(40, 30, 440, 20, "Please fill in the following form in order to open a new Account.", false, bankWindow)
			
			nameLbl = guiCreateLabel(30, 60, 65, 20, "Your name:", false, bankWindow)
			nameEdit = guiCreateEdit(30, 80, 150, 20, getPlayerName(localPlayer):gsub("_", " "), false, bankWindow)
			guiEditSetReadOnly(nameEdit, true)
			
			addressLbl = guiCreateLabel(30, 110, 80, 20, "Your address:", false, bankWindow)
			addressEdit = guiCreateEdit(30, 130, 150, 20, "", false, bankWindow)
			
			phoneLbl = guiCreateLabel(30, 160, 105, 20, "Your cell number:", false, bankWindow)
			phoneEdit = guiCreateEdit(30, 180, 150, 20, "", false, bankWindow)
			
			spouseLbl = guiCreateLabel(30, 210, 155, 20, "Your spouse name: (if any)", false, bankWindow)
			spouseEdit = guiCreateEdit(30, 230, 150, 20, "", false, bankWindow)
			
			pinLbl = guiCreateLabel(300, 60, 150, 20, "Your PIN code: (4 digits)", false, bankWindow)
			pinEdit = guiCreateEdit(300, 80, 150, 20, "", false, bankWindow)
			
			jobLbl = guiCreateLabel(300, 110, 150, 20, "Your Occupation:", false, bankWindow)
			jobEdit = guiCreateEdit(300, 130, 150, 20, "", false, bankWindow)
			
			if ( isElement( buttonBackAccount ) ) then
				destroyElement( buttonBackAccount )
			end
			
			backSubmit = guiCreateButton(10, 310, 30, 30, "<--", false, bankWindow)
			addEventHandler("onClientGUIClick", backSubmit,
			function( button, state )
				if ( button == "left" and state == "up" ) then
						
					if (step == 1) then
						
						destroyElement(nameLbl)
						destroyElement(nameEdit)
						destroyElement(addressLbl)
						destroyElement(addressEdit)
						destroyElement(phoneLbl)
						destroyElement(phoneEdit)
						destroyElement(spouseLbl)
						destroyElement(spouseEdit)
						destroyElement(pinLbl)
						destroyElement(pinEdit)
						destroyElement(jobLbl)
						destroyElement(jobEdit)
						destroyElement(requestLbl)
						destroyElement(backSubmit)
						destroyElement(buttonSubmit)
						
						guiSetSize(bankWindow, bankWidth, bankHeight, false)
						guiSetPosition(btnExit, closeX, closeY, false) 
						
						guiSetVisible(welcomeLbl, true)
						guiSetVisible(answerLbl, true)
						
						if (optionView) then
							guiSetVisible(optionView, true)
						end
						
						guiSetVisible(optionNew, true)
		
						guiSetInputEnabled(false)
						
					elseif (step == 2) then	
						
						step = 1
						
						guiSetVisible(nameLbl, true)
						guiSetVisible(nameEdit, true)
						guiSetVisible(addressLbl, true)
						guiSetVisible(addressEdit, true)
						guiSetVisible(phoneLbl, true)
						guiSetVisible(phoneEdit, true)
						guiSetVisible(spouseLbl, true)
						guiSetVisible(spouseEdit, true)
						guiSetVisible(pinLbl, true)
						guiSetVisible(pinEdit, true)
						guiSetVisible(jobLbl, true)
						guiSetVisible(jobEdit, true)
						guiSetVisible(requestLbl, true)
						guiSetVisible(buttonSubmit, true)
									
						destroyElement(terms)
						destroyElement(buttonAgree)
						destroyElement(buttonDisagree)
						
						guiSetInputEnabled(true)
					end	
				end
			end, false)	
						
			buttonSubmit = guiCreateButton(185, 300, 110, 40, "Submit", false, bankWindow)
			addEventHandler("onClientGUIClick", buttonSubmit,
			function( button, state )
				if ( button == "left" and state == "up") then
					
					step = 2
					
					local addressLen = string.len(guiGetText(addressEdit))
					local phoneLen = string.len(guiGetText(phoneEdit))
					local spouseLen = string.len(guiGetText(spouseEdit))
					local pinLen = string.len(guiGetText(pinEdit))
					local jobLen = string.len(guiGetText(jobEdit))
					
					if (addressLen == 0) then
					
						guiLabelSetColor(addressLbl, 255, 0, 0)
						playSoundFrontEnd(32)
						
						setTimer(function() guiLabelSetColor(addressLbl, 255, 255, 255) end, 1500, 1)
						return
					elseif (phoneLen == 0) then	
						
						guiLabelSetColor(phoneLbl, 255, 0, 0)
						playSoundFrontEnd(32)
						
						setTimer(function() guiLabelSetColor(phoneLbl, 255, 255, 255) end, 1500, 1)
						return
					elseif (phoneLen > 0) then
						
						local wrong = false
						for i, v in ipairs ( alphabets ) do
							if ( string.find( string.lower(guiGetText(phoneEdit)), v ) ) then
							
								guiLabelSetColor(phoneLbl, 255, 0, 0)
								playSoundFrontEnd(32)
								
								setTimer(function() guiLabelSetColor(phoneLbl, 255, 255, 255) end, 1500, 1)	
								
								playSoundFrontEnd(32)
								wrong = true
								return
							end
						end	
						
						if (not wrong) then
							
							if (pinLen ~= 4) then
								
								guiLabelSetColor(pinLbl, 255, 0, 0)
								playSoundFrontEnd(32)
								
								setTimer(function() guiLabelSetColor(pinLbl, 255, 255, 255) end, 1500, 1)
								return
							elseif (pinLen == 4) then
								
								local wrong = false
								for i, v in ipairs ( alphabets ) do
									if ( string.find( string.lower(guiGetText(pinEdit)), v ) ) then
									
										guiLabelSetColor(pinLbl, 255, 0, 0)
										playSoundFrontEnd(32)
										
										setTimer(function() guiLabelSetColor(pinLbl, 255, 255, 255) end, 1500, 1)	
										
										playSoundFrontEnd(32)
										wrong = true
										return
									end	
								end	
								
								if (not wrong) then
									
									accountDetails[1] = guiGetText(nameEdit)
									accountDetails[2] = guiGetText(addressEdit)
									accountDetails[3] = guiGetText(phoneEdit)
									accountDetails[4] = guiGetText(spouseEdit)
									accountDetails[5] = guiGetText(pinEdit)
									accountDetails[6] = guiGetText(jobEdit)
									
									guiSetVisible(nameLbl, false)
									guiSetVisible(nameEdit, false)
									guiSetVisible(addressLbl, false)
									guiSetVisible(addressEdit, false)
									guiSetVisible(phoneLbl, false)
									guiSetVisible(phoneEdit, false)
									guiSetVisible(spouseLbl, false)
									guiSetVisible(spouseEdit, false)
									guiSetVisible(pinLbl, false)
									guiSetVisible(pinEdit, false)
									guiSetVisible(jobLbl, false)
									guiSetVisible(jobEdit, false)
									guiSetVisible(requestLbl, false)
									guiSetVisible(source, false)
									
									local termText = "By opening an Account in the Credit and Commerce Bank, you agree\nto the terms as set forth below:\n\n1. Your given information may be provided to government officials\nupon court order, under no other circumstances will we share\nyour personal information.\n\n2. Incase the given information provided by you is wrong, a legal\naction may be taken against you.\n\n3. You will receive an interest rate of 1% on your account balance.\n\n4. You are not allowed to share your PIN code with anyone else."	
									terms = guiCreateLabel(20, 30, 450, 280, termText, false, bankWindow)
										
									buttonAgree = guiCreateButton(85, 300, 110, 40, "I Agree", false, bankWindow)
									addEventHandler("onClientGUIClick", buttonAgree, 
									function( button, state )
										if ( button == "left" and state == "up" ) then
												
											destroyElement(bankWindow)
											bankWindow = nil
												
											setData(localPlayer, "bank:showing", 0, true)
											
											if ( guiGetInputEnabled( ) ) then
												guiSetInputEnabled(false)
											end	
			
											successWin = guiCreateWindow(screenX/2 - 175, screenY/2 - 100, 350, 180, "...", false)
											successLbl = guiCreateLabel(145, 30, 330, 20, "Please wait..", false, successWin)
												
											buttonOK = guiCreateButton(120, 80, 110, 40, "OK", false, successWin)
											addEventHandler("onClientGUIClick", buttonOK,
											function( button, state )
												if ( button == "left" and state == "up" ) then
														
													destroyElement(successWin)
												end
											end, false)	
												
											guiSetEnabled(buttonOK, false)
											guiSetFont(successLbl, "clear-normal")
											guiSetInputEnabled(false)
											
											triggerServerEvent("createBankAccount", localPlayer, accountDetails)
											
											accountMade( )
										end	
									end, false)		
										
									buttonDisagree = guiCreateButton(285, 300, 110, 40, "I Disagree", false, bankWindow)
									addEventHandler("onClientGUIClick", buttonDisagree, 
									function( button, state )
										if ( button == "left" and state == "up" ) then
										
											destroyElement(bankWindow)
											bankWindow = nil
											
											setData(localPlayer, "bank:showing", 0, true)
											
											if ( guiGetInputEnabled( ) ) then
												guiSetInputEnabled(false)
											end	
										end	
									end, false)		
										
									guiSetFont(terms, "clear-normal")
								end
							end	
						end	
					end	
				end
			end, false)	
			
			guiSetFont(requestLbl, "clear-normal")
			guiSetFont(nameLbl, "default-bold-small")
			guiSetFont(addressLbl, "default-bold-small")
			guiSetFont(phoneLbl, "default-bold-small")
			guiSetFont(spouseLbl, "default-bold-small")
			guiSetFont(pinLbl, "default-bold-small")
			guiSetFont(jobLbl, "default-bold-small")
			
			guiSetInputEnabled(true)
		end
		
		if (optionView) then
			guiSetVisible(optionView, false)
		end
		
		if (optionNew) then
			guiSetVisible(optionNew, false)
		end	
	end
end

local madeTimer = nil
function accountMade( )
	if (not made) then
		
		madeTimer = setTimer(accountMade, 100, 1)
	elseif (made) then
		made = false
		
		if isTimer(madeTimer) then
			killTimer(madeTimer)
		end
		
		guiSetText(successWin, "Congratulations!")
		guiSetText(successLbl, "Your bank account has been successfully created!")
		guiSetPosition(successLbl, 20, 30, false)
	
		guiSetEnabled(buttonOK, true)
	end
end
--------- [ Deposit/Withdraw/Transfer/Transactions ] ---------	
function accountFunctions( button, state )
	if ( button == "left" and state == "up" ) then
		
		guiSetVisible(bankWindow, false)
		
		if ( not isElement(subWindow) ) then
			
			local subWindow = nil
			
			local subWidth, subHeight = 350, 230
			local subX, subY = (screenX/2) - (subWidth/2), (screenY/2) - (subHeight/2)
			
			local accountID = guiGridListGetItemText(accountList, selectedRow, 2)
			local accountIndex = getAccountIndex( accountID )
			
			local bankBalance = guiGridListGetItemText(accountList, selectedRow, 3)
			
			if (source == optionDeposit) then -- Deposit Money
			
				subWindow = guiCreateWindow(subX, subY, subWidth, subHeight, "Deposit Money", false)
				
				informationLbl = guiCreateLabel(15, 30, 320, 20, "Please enter the amount you would like to deposit", false, subWindow)
				balanceLbl = guiCreateLabel(100, 60, 200, 20, "Your Balance: ".. tostring(bankBalance), false, subWindow)
				
				currencySymbol = guiCreateLabel(100, 120, 8, 20, "$", false, subWindow)
				depositEdit = guiCreateEdit(110, 120, 130, 20, "", false, subWindow)
				
				local allowClick = true
				
				buttonDeposit = guiCreateButton(110, 170, 130, 40, "Deposit", false, subWindow)
				addEventHandler("onClientGUIClick", buttonDeposit, 
				function( button, state )
					if ( button == "left" and state == "up" ) then
						
						if ( allowClick ) then
							
							allowClick = false
							
							setTimer(
								function( ) 
									allowClick = true 
								end, 2000, 1 
							)
							
							local money 
							money = tonumber(getPlayerMoney(localPlayer)/100)
							money = tonumber(string.format("%.2f", money))
							
							local primaryAccount = false
							if ( accountIndex == 1 ) then
								primaryAccount = true
							end
							
							local amount = tonumber(guiGetText(depositEdit))
							
							if ( isElement( balanceLbl ) and guiGetText( balanceLbl ) == "Please wait.." ) then
								outputChatBox("Please wait..", 255, 0, 0)
								return
							end

							-- Remove the $
							if ( bankBalance == nil ) then
								return
							else	
								bankBalance = tonumber( string.sub(bankBalance, 2) )
							end
							
							-- Check	
							if ( string.len(tostring(amount)) > 0 ) then
							
								local wrong = false
								for i, v in ipairs ( alphabets ) do
									if ( string.find( string.lower(tostring(amount)), v ) ) then
										
										playSoundFrontEnd(32)
										wrong = true
										return
									end	
								end
								
								local correct = check( tostring(amount) )
								if (correct) then
									wrong = false
								else
									wrong = true
								end
									
								-- Everything's fine
								if (not wrong) then
							
									if (money ~= nil) and (tonumber(amount) <= money) then
										
										if (tonumber(amount) > 0) then
											
											bankBalance = "$".. tostring( bankBalance + amount )
										
											guiSetText(balanceLbl, "Please wait..")
											calculateTimer = setTimer( 
												function( )
													guiGridListSetItemText(accountList, selectedRow, 3, tostring(bankBalance), false, false)
													guiSetText(balanceLbl, "Your Balance: ".. bankBalance)
												end, 2000, 1
											)
										
											triggerServerEvent("depositMoney", localPlayer, amount*100, accountID, primaryAccount)
										else
											playSoundFrontEnd(32)	
										end
									else
										playSoundFrontEnd(32)
									end
								else
									playSoundFrontEnd(32)
								end
							end
						end	
					end
				end, false)	
				
				buttonBackDeposit = guiCreateButton(10, 200, 30, 30, "<--", false, subWindow)
				addEventHandler("onClientGUIClick", buttonBackDeposit, 
				function( button, state )
					if ( button == "left" and state == "up" ) then
				
						closeWindow(subWindow)
					end
				end, false)	
				
				guiSetFont(informationLbl, "clear-normal")
				guiSetFont(balanceLbl, "default-bold-small")
				guiSetFont(currencySymbol, "clear-normal")
			
				guiSetSize(balanceLbl, guiLabelGetTextExtent(balanceLbl), 20, false)
				guiSetPosition(balanceLbl, 175 - guiLabelGetTextExtent(balanceLbl)/2, 60, false)
				
			elseif (source == optionWithdraw) then -- Withdraw money
			
				subWindow = guiCreateWindow(subX, subY, subWidth, subHeight, "Withdraw Money", false)			
				
				informationLbl = guiCreateLabel(15, 30, 320, 20, "Please enter the amount you want to withdraw.", false, subWindow)			
				balanceLbl = guiCreateLabel(100, 60, 200, 20, "Your Balance: ".. tostring(bankBalance), false, subWindow)
				
				currencySymbol = guiCreateLabel(100, 120, 8, 20, "$", false, subWindow)
				withdrawEdit = guiCreateEdit(110, 120, 130, 20, "", false, subWindow)			
				
				local allowClick = true
				
				buttonWithdraw = guiCreateButton(110, 170, 130, 40, "Withdraw", false, subWindow)
				addEventHandler("onClientGUIClick", buttonWithdraw, 
				function( button, state )
					if ( button == "left" and state == "up" ) then
						
						if ( allowClick ) then
							
							allowClick = false
							
							setTimer(
								function( ) 
									allowClick = true 
								end, 1000, 1 
							)
							
							local amount = tonumber(guiGetText(withdrawEdit))
							
							if ( isElement( balanceLbl ) and guiGetText( balanceLbl ) == "Please wait.." ) then
								outputChatBox("Please wait..", 255, 0, 0)
								return
							end

							-- Remove the $
							if ( bankBalance == nil ) then
								return
							else	
								bankBalance = tonumber( string.sub(bankBalance, 2) )
							end
							
							-- Check	
							if (string.len(tostring(amount)) > 0) then
							
								local wrong = false
								for i, v in ipairs ( alphabets ) do
									if ( string.find( string.lower(tostring(amount)), v ) ) then
									
										playSoundFrontEnd(32)
										wrong = true
										return
									end	
								end
								
								local correct = check( tostring(amount) )
								if (correct) then
									wrong = false
								else
									wrong = true
								end
								
								if ( amount == nil ) then
									amount = 0
								end
								
								-- Everything's fine
								if (not wrong) then
									
									if ( bankBalance ~= nil ) then
										
										if ( tonumber( amount ) <= bankBalance ) and ( bankBalance > 0 and tonumber( amount ) > 0 ) then
											
											bankBalance = "$".. tostring( bankBalance - amount )
											
											guiSetText(balanceLbl, "Please wait..")
											calculateTimer = setTimer( 
												function( )
													guiGridListSetItemText(accountList, selectedRow, 3, tostring(bankBalance), false, false)
													guiSetText(balanceLbl, "Your Balance: ".. bankBalance)
												end, 2000, 1
											)
											
											triggerServerEvent("withdrawMoney", localPlayer, amount*100, accountID)
										else
											playSoundFrontEnd(32)
										end		
									else
										playSoundFrontEnd(32)
									end
								else
									playSoundFrontEnd(32)
								end
							end	
						end	
					end		
				end, false)	
				
				buttonBackWithdraw = guiCreateButton(10, 200, 30, 30, "<--", false, subWindow)
				addEventHandler("onClientGUIClick", buttonBackWithdraw, 
				function( button, state )
					if ( button == "left" and state == "up" ) then
				
						closeWindow(subWindow)
					end
				end, false)	
						
				guiSetFont(informationLbl, "clear-normal")
				guiSetFont(balanceLbl, "default-bold-small")
				guiSetFont(currencySymbol, "clear-normal")
			
				guiSetSize(balanceLbl, guiLabelGetTextExtent(balanceLbl), 20, false)
				guiSetPosition(balanceLbl, 175 - guiLabelGetTextExtent(balanceLbl)/2, 60, false)
				
			elseif (source == optionTransfer) then -- Transfer Money
				
				subWindow = guiCreateWindow(subX, subY, subWidth, subHeight, "Transfer Money", false)			
				informationLbl = guiCreateLabel(15, 30, 320, 20, "Enter receipient's account no. & transfer amount", false, subWindow)	 
				balanceLbl = guiCreateLabel(100, 60, 200, 20, "Your Balance: ".. tostring(bankBalance), false, subWindow)
				
				accountLbl = guiCreateLabel(15, 100, 140, 20, "Receipient's Account No.", false, subWindow)
				accountEdit = guiCreateEdit(15, 120, 110, 20, "", false, subWindow)
				
				transferLbl = guiCreateLabel(230, 100, 100, 20, "Transfer Amount", false, subWindow)
				transferEdit = guiCreateEdit(230, 120, 110, 20, "", false, subWindow)
				
				local allowClick = true
				
				buttonTransfer = guiCreateButton(110, 170, 130, 40, "Transfer", false, subWindow)
				addEventHandler("onClientGUIClick", buttonTransfer,
				function( button, state )
					if ( button == "left" and state == "up" ) then
						
						if ( allowClick ) then
							
							allowClick = false
							
							setTimer(
								function( ) 
									allowClick = true 
								end, 2000, 1 
							)
							
							local currentAccountID = tonumber(guiGridListGetItemText(accountList, selectedRow, 2))
							
							local receipientAccount = tonumber(guiGetText(accountEdit))
							local transferAmount = tonumber(guiGetText(transferEdit))
							
							if (currentAccountID ~= receipientAccount) then
								
								if ( isElement( balanceLbl ) and guiGetText( balanceLbl ) == "Please wait.." ) then
									outputChatBox("Please wait..", 255, 0, 0)
									return
								end	
							
								-- Remove the $
								if ( bankBalance == nil ) then
									return
								else	
									bankBalance = tonumber( string.sub(bankBalance, 2) )
								end
								
								if (string.len(transferAmount) > 0 and string.len(receipientAccount) > 0) then
									
									local wrong = false
									for index, value in ipairs ( alphabets ) do
										if ( string.find( string.lower(transferAmount), value ) or string.find( string.lower(receipientAccount), value ) ) then
											
											playSoundFrontEnd(32)
											wrong = true
											return
										end	
									end
									
									local correct = check( tostring(transferAmount) )
									if (correct) then
										wrong = false
									else
										wrong = true
									end
									
									if ( transferAmount == nil ) then
										transferAmount = 0
									end
									
									if (not wrong) then
										
										if ( tonumber( transferAmount ) <= tonumber( bankBalance ) ) and ( tonumber( bankBalance ) ~= 0.00 ) then
										
											if ( tonumber( transferAmount ) > 0 ) then
												
												bankBalance = "$".. tostring( bankBalance - transferAmount )
												
												guiSetText(balanceLbl, "Please wait..")
												calculateTimer = setTimer( 
													function( )
														guiGridListSetItemText(accountList, selectedRow, 3, tostring(bankBalance), false, false)
														guiSetText(balanceLbl, "Your Balance: ".. bankBalance)
													end, 2000, 1
												)	
						
												triggerServerEvent("transferMoney", localPlayer, transferAmount*100, receipientAccount, accountID)
											else
												playSoundFrontEnd(32)
											end
										else
											playSoundFrontEnd(32)
										end
									else
										playSoundFrontEnd(32)
									end
								else
									playSoundFrontEnd(32)
								end
							else
								outputChatBox("You cannot transfer money to your own account.", 212, 156, 49)
								playSoundFrontEnd(32)
							end
						end	
					end
				end, false)
				
				buttonBackTransfer = guiCreateButton(10, 200, 30, 30, "<--", false, subWindow)
				addEventHandler("onClientGUIClick", buttonBackTransfer, 
				function( button, state )
					if ( button == "left" and state == "up" ) then
				
						closeWindow(subWindow)
					end
				end, false)	
				
				guiSetFont(informationLbl, "clear-normal")
				guiSetFont(accountLbl, "default-bold-small")
				guiSetFont(transferLbl, "default-bold-small")
				guiSetFont(balanceLbl, "default-bold-small")
				
				
				guiSetSize(balanceLbl, guiLabelGetTextExtent(balanceLbl), 20, false)
				guiSetPosition(balanceLbl, 175 - guiLabelGetTextExtent(balanceLbl)/2, 60, false)
			
			elseif (source == optionTransaction) then -- Transactions
				
				subWindow = guiCreateWindow(subX, subY, subWidth, subHeight, "Transactions", false)			
				
				local accountID = guiGridListGetItemText(accountList, selectedRow, 1)
				local transactions = tostring(playerAccounts[tonumber(accountID)][4])
				
				transactionsList = guiCreateGridList(20, 30, 310, 155, false, subWindow)
				guiGridListAddColumn(transactionsList, "Type", 0.25)
				guiGridListAddColumn(transactionsList, "From", 0.3)
				guiGridListAddColumn(transactionsList, "To", 0.3)
				guiGridListAddColumn(transactionsList, "Amount", 0.2)
				guiGridListAddColumn(transactionsList, "Date", 0.4)
				guiGridListAddColumn(transactionsList, "Reason", 0.3)
				
				local tableTransactions = split(transactions, ";")
				
				local dataTransaction = { }
				for i = 1, #tableTransactions do
					dataTransaction[i] = split(tableTransactions[i], ",")
				end	
				
				for i = 1, #tableTransactions do
						
					local row = guiGridListAddRow(transactionsList)
						
					guiGridListSetItemText(transactionsList, row, 1, tostring(dataTransaction[i][1]), false, false)
					guiGridListSetItemText(transactionsList, row, 2, tostring(dataTransaction[i][2]), false, false)
					guiGridListSetItemText(transactionsList, row, 3, tostring(dataTransaction[i][3]), false, false)
					guiGridListSetItemText(transactionsList, row, 4, "$".. tostring(dataTransaction[i][4]), false, false)
					guiGridListSetItemText(transactionsList, row, 5, tostring(dataTransaction[i][5]), false, false)
					guiGridListSetItemText(transactionsList, row, 6, tostring(dataTransaction[i][6]), false, false)
				end

				buttonBackTransaction = guiCreateButton(10, 200, 30, 30, "<--", false, subWindow)
				addEventHandler("onClientGUIClick", buttonBackTransaction, 
				function( button, state )
					if ( button == "left" and state == "up" ) then
				
						closeWindow(subWindow)
					end
				end, false)	
			end	
		end	
	end
end
	
function restoreBalance( amount )
	local amount = tonumber( amount )
	local bankBalance = string.sub( guiGridListGetItemText( accountList, selectedRow, 3 ), 2 )
	local restore = tonumber( bankBalance ) + amount
	
	if isTimer( calculateTimer ) then
		killTimer( calculateTimer )
		
		if isElement( balanceLbl ) then
			guiSetText(balanceLbl, "Your Balance: $".. bankBalance)
		end	
		return
	end
	
	guiGridListSetItemText(accountList, selectedRow, 3, tostring(restore), false, false)
	
	if isElement( balanceLbl ) then
		guiSetText(balanceLbl, "Your Balance: $".. restore)
	end	
end
addEvent("restoreBalance", true)
addEventHandler("restoreBalance", localPlayer, restoreBalance)
	
function getAccountIndex( accountID )
	for key, value in ipairs ( playerAccounts ) do
		if ( value[1] == tonumber( accountID ) ) then
			
			return key
		end
	end	
end
	
-- The number of digits after decimal should not be more than 2	
function check( num ) 
	local len = string.len(num)
	local place = nil
	
	local i = 1
	while i <= len do 
		if (string.sub(num, i, i) == ".") then
			
			place = i
			break
		else	
			i = i + 1 
		end	
	end
	
	if (place == nil) then
		return true
	else	
		local afterDecimal = string.len(string.sub(num, place + 1))
		if (afterDecimal <= 2) then
			return true
		else
			return false
		end	
	end	
end
	
--------- [ Button Events ] ---------
function closeWindow( window )
	if ( isElement(window) ) then
		
		if ( isElement( balanceLbl ) ) then
			
			local text = guiGetText( balanceLbl )
			if ( text ~= "Please wait.." ) then
				
				destroyElement(window)
				window = nil
				
				guiSetVisible(bankWindow, true)
			else
				outputChatBox("Please wait..", 255, 0, 0)
			end
		else
			destroyElement(window)
			window = nil
			
			guiSetVisible(bankWindow, true)
		end	
	end	
end

function returnToWindow( window )
	if (window == bankWindow) then
		
		destroyElement(buttonBack)
		buttonBack = nil
		
		destroyElement(accountList)
		accountList = nil
		
		destroyElement(selectAccount)
		selectAccount = nil
		
		guiSetText(welcomeLbl, "Welcome to the Credit & Commerce Bank, what would you like to do?")
		guiSetText(answerLbl, "I would like to..")
		
		if ( optionView ) then
			guiSetVisible(optionView, true)
		end
		
		if ( optionNew ) then
			guiSetVisible(optionNew, true)
		else
			guiSetSize(bankWindow, bankWidth, bankHeight - 90, false)
			guiSetPosition(btnExit, 440, 110, false)
		end	
	end
end

addEventHandler("onClientResourceStart", resourceRoot,
function( res )
	local r, g, b = getPlayerNametagColor(localPlayer)
	if (r ~= 140 and g ~= 140 and b ~= 140) then
		triggerServerEvent("sendPlayerBankAccounts", localPlayer)
	end	
	
	setTimer(receiveChange, 1000, 1, false )
	setTimer(function() made = false end, 1000, 1)
end)