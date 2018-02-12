local screenX, screenY = guiGetScreenSize()
local open = false

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

--------- [ ATM Access ] ---------
function onATMClick(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if (getData(getLocalPlayer(), "loggedin") == 1) and (not isElement(atmWindow)) and not open then
		
		if (button == "right" and state == "up") then
			
			if (clickedElement) then
			
				local elementType = getElementType(clickedElement)
				if (elementType) and (elementType == "object") and (getElementModel(clickedElement) == 2942) then
				
					if (getElementParent(getElementParent(clickedElement)) == resourceRoot) then
					
						local atm = clickedElement
						
						limit = tonumber(getData(atm, "limit"))
						
						if ( not isElement( atmWindow ) ) then
							
							if ( getData( localPlayer, "bank:showing") == 0 ) then
							
								local width, height = 380, 260
								local x, y = (screenX/2) - (width/2), (screenY/2) - (height/2)
								
								atmWindow = guiCreateWindow(x, y, width, height, "ATM - Credit & Commerce Bank", false)
								
								bankLogo = guiCreateStaticImage(158, 30, 64, 60, "logo.png", false, atmWindow)
								
								infoLbl = guiCreateLabel(75, 100, 270, 40, "Please insert your debit card inside\nthe machine and enter your PIN code.", false, atmWindow)
								pinEdit = guiCreateEdit(125, 140, 130, 20, "", false, atmWindow)
								
								btnExit = guiCreateButton(15, 220, 110, 20, "Exit", false, atmWindow)
								addEventHandler("onClientGUIClick", btnExit, closeATM, false)
								
								btnNext = guiCreateButton(250, 220, 110, 20, "Proceed", false, atmWindow)
								addEventHandler("onClientGUIClick", btnNext, proceedATM, false)
								
								guiEditSetMasked(pinEdit, true)
								
								guiSetFont(infoLbl, "default-bold-small")
								guiWindowSetSizable(atmWindow, false)
								
								guiSetInputEnabled(true)
								open = true
								
								setData(localPlayer, "bank:showing", 1, true)
							end	
						end	
					end
				end
			end
		end
	end
end
addEventHandler("onClientClick", getRootElement(), onATMClick) 

--------- [ Button Events ] ---------
function closeATM( button, state )
	if ( button == "left" and state == "up" ) then
		
		destroyElement(atmWindow)
		atmWindow = nil	
		
		guiSetInputEnabled(false)
		open = false
		
		setData(localPlayer, "bank:showing", 0, true)
	end
end

function proceedATM( button, state )
	if ( button == "left" and state == "up" ) then
		
		local pinCode = guiGetText(pinEdit)
		if (string.len(pinCode) > 0) then
			
			triggerServerEvent("getBankAccountData", getLocalPlayer(), pinCode)
		else
			showPINCodeError("You did not enter your PIN code.")
		end
	end
end

--------- [ Server Callbacks ] ---------
local rbalance = nil
local accountID = nil
function giveBankAccountData( id, balance, transactions )
	
	rbalance = tostring(string.format("%.2f", tonumber(balance)/100))
	accountID = tonumber(id)
	
	local transactions = tostring(transactions)
	
	destroyElement(bankLogo)
	destroyElement(infoLbl)
	destroyElement(pinEdit)
	destroyElement(btnNext)
	
	guiSetPosition(btnExit, 135, 220, false) 
	
	idLbl = guiCreateLabel(230, 30, 65, 20, "Account No: ", false, atmWindow)
	idEdit = guiCreateEdit(300, 28, 72, 20, tostring(accountID), false, atmWindow)
	
	guiEditSetReadOnly(idEdit, true)
	guiSetFont(idLbl, "default-bold-small")
	
	-- Tab Panel
	atmPanel = guiCreateTabPanel(20, 50, 340, 160, false, atmWindow)
	
	-- Withdraw
	withdrawTab = guiCreateTab("Withdraw", atmPanel)
	
	balanceLbl1 = guiCreateLabel(12, 15, 320, 20, "Account Balance: $".. tostring(rbalance), false, withdrawTab) 
	
	currencySymbol = guiCreateLabel(95, 60, 8, 20, "$", false, withdrawTab) 
	widthdrawEdit = guiCreateEdit(105, 60, 130, 20, "", false, withdrawTab) 
	
	limitLbl = guiCreateLabel(15, 110, 150, 20, "Withdraw Limit: $".. tostring(limit) .."", false, withdrawTab)  
	
	btnWithdraw = guiCreateButton(230, 105, 90, 20, "Withdraw", false, withdrawTab) 
	addEventHandler("onClientGUIClick", btnWithdraw, withdrawMoney, false)
	
	guiSetFont(balanceLbl1, "clear-normal")
	guiSetFont(currencySymbol, "clear-normal")
	guiSetFont(limitLbl, "default-bold-small")

	-- Money Transfer
	transferTab = guiCreateTab("Money Transfer", atmPanel)
	
	balanceLbl2 = guiCreateLabel(12, 15, 320, 20, "Account Balance: $".. tostring(rbalance), false, transferTab) 
	
	receipentLbl = guiCreateLabel(12, 45, 150, 20, "Receipent's Account No.", false, transferTab) 
	amountLbl = guiCreateLabel(210, 45, 100, 20, "Transfer Amount:", false, transferTab) 
	
	recepientEdit = guiCreateEdit(12, 65, 110, 20, "", false, transferTab)
	amountEdit = guiCreateEdit(210, 65, 110, 20, "", false, transferTab)
	
	btnTransfer = guiCreateButton(125, 105, 90, 20, "Transfer", false, transferTab)
	addEventHandler("onClientGUIClick", btnTransfer, transferMoney, false)
	
	guiSetFont(balanceLbl2, "clear-normal")
	guiSetFont(receipentLbl, "default-bold-small")
	guiSetFont(amountLbl, "default-bold-small")
	
	-- Transactions
	transactionTab = guiCreateTab("Transactions", atmPanel)
	
	transactionsList = guiCreateGridList(10, 10, 320, 115, false, transactionTab)
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
end
addEvent("giveBankAccountData", true)
addEventHandler("giveBankAccountData", getLocalPlayer( ), giveBankAccountData)
	
--------- [ Button Events ] ---------
local alphabets = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"}

-- Withdraw
function withdrawMoney( button, state )
	if (button == "left" and state == "up") then
		
		local text = guiGetText(widthdrawEdit)
		if (string.len(text) > 0) then
			
			local wrong = false
			for i, v in ipairs ( alphabets ) do
				if string.find(string.lower(text), v) then
				
					playSoundFrontEnd(32)
					wrong = true
					return
				end	
			end
			
			if (wrong == false) then
			
				local amount = tonumber(guiGetText(widthdrawEdit))
				local balance = tonumber(rbalance)
					
				if (amount <= limit) then
					if (amount > 0) then
						if (amount <= balance) and (balance ~= 0.00) then
							
							triggerServerEvent("withdrawAmount", getLocalPlayer( ), amount, accountID)
							closeATM("left", "up")
						else
							playSoundFrontEnd(32)
							guiLabelSetColor(balanceLbl1, 255, 0, 0)
								
							resetColor( balanceLbl1 )
						end
					else
						playSoundFrontEnd(32)	
					end		
				else
					playSoundFrontEnd(32)
					guiLabelSetColor(limitLbl, 255, 0, 0)
						
					resetColor( limitLbl )
				end
			end	
		else
			playSoundFrontEnd(32)
		end	
	end
end
	
-- Transfer	
function transferMoney( button, state )
	if ( button == "left" and state == "up") then
		
		local text1 = guiGetText(recepientEdit)
		local text2 = guiGetText(amountEdit)
		
		if (string.len(text1) > 0) and (string.len(text2) > 0) then
		
			local wrong = false
			for i, v in ipairs ( alphabets ) do
				if ( string.find(string.lower(text1), v) or string.find(string.lower(text2), v) )  then
				
					playSoundFrontEnd(32)
					wrong = true
					return
				end	
			end
			
			if (wrong == false) then
				
				local accountNo = tonumber(text1)
				local amount = tonumber(text2)
				local balance = tonumber(rbalance)	
				
				if (amount <= balance) and (balance ~= 0.00) then
					if (amount > 0) then		
					
						triggerServerEvent("transferAmount", getLocalPlayer( ), amount, accountNo, accountID)
					else
						playSoundFrontEnd(32)
					end
				else
					playSoundFrontEnd(32)
					guiLabelSetColor(balanceLbl2, 255, 0, 0)
							
					resetColor( balanceLbl2 )
				end	
			end
		else
			playSoundFrontEnd(32)
		end
	end
end	

function remoteCloseATM( )
	closeATM("left", "up")
end
addEvent("remoteCloseATM", true)
addEventHandler("remoteCloseATM", getLocalPlayer( ), remoteCloseATM)				
		
--------- [ ATM Functions ] ---------
function resetColor( element )
	setTimer(function( ) 
		if isElement(element) then 
			guiLabelSetColor(element, 255, 255, 255) 
		end 
	end, 3000, 1)
end

function showPINCodeError( text )
	local text = tostring(text)
	
	if isElement(pinError) then
		destroyElement(pinError)
	end
	
	pinError = guiCreateLabel(125, 170, 280, 20, tostring(text), false, atmWindow)
	local width, height = guiLabelGetTextExtent(pinError), 20
	local x, y = (190) - (width/2), 170
	
	guiSetPosition(pinError, x, y, false)
	
	guiLabelSetColor(pinError, 255, 0, 0)
	guiSetFont(pinError, "default-bold-small")
	
	setTimer(function() if isElement(pinError) then destroyElement(pinError) end end, 3000, 1)
	
	playSoundFrontEnd(32)
end
addEvent("showPINCodeError", true)
addEventHandler("showPINCodeError", getLocalPlayer(), showPINCodeError)	