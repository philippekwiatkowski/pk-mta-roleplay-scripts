function giveClientPaycheck( factionID, bankAccounts, totalVehicles, totalProperty, rented, getBenefits, playerWage, stateBenefits, governmentTax, bankInterest )
	if ( factionID and bankAccounts and totalVehicles and totalProperty and rented and stateBenefits and governmentTax and bankInterest) then
		
		local factionID = tonumber( factionID )
		
		local totalVehicles = tonumber( totalVehicles )
		local totalProperty = tonumber( totalProperty )
		
		local playerWage = tonumber( playerWage )
		
		local stateBenefits = tonumber( stateBenefits )
		local governmentTax = tonumber( governmentTax )
		local bankInterest = tonumber( bankInterest )
		
		executeSound( ) -- Melody
		
		outputChatBox("~=~=~=~=~=~=~=~= Pay Day ~=~=~=~=~=~=~=~=", 212, 156, 49)

		local count = 1
		local totalIncome = 0
		
		for key, array in pairs ( bankAccounts ) do

			local netIncome = 0
			
			outputChatBox("============= Account: ".. tostring( key ) .. " =============", 212, 156, 49)
			if ( count == 1 ) then	-- Wage ( Primary Account )
				
				if ( getBenefits ) then
					outputChatBox("State Benefits: #00FF00$".. tostring( stateBenefits ), 212, 156, 49, true)
				else
					outputChatBox("Wage: #00FF00$".. tostring( playerWage ), 212, 156, 49, true)
				end
				
				if ( getBenefits ) then
					incomeTax = array[1]
				else
					incomeTax = math.floor( playerWage / 100 ) * governmentTax
				end
				
				outputChatBox("Income Tax: #FF0000$".. tostring( incomeTax ) .." #d49c31( ".. tostring( governmentTax ) .."% )", 212, 156, 49, true)
			end
			
			outputChatBox("Interest: #00FF00$".. tostring( array[2] ) .." #d49c31( ".. tostring( bankInterest*100 ) .."% )", 212, 156, 49, true)
		
			if ( count == 1 ) then
				if ( getBenefits ) then
					netIncome = netIncome + ( stateBenefits - incomeTax ) + array[2]
				else
					netIncome = netIncome + ( playerWage - incomeTax ) + array[2]
				end	
			else
				netIncome = netIncome + array[2]
			end
			
			-- Tax Taking ( Primary Account )
			if ( count == 1 ) then
		
				if ( totalVehicles > 0 ) then
					netIncome = netIncome - ( totalVehicles * 10 )
					
					outputChatBox("Vehicle Tax: #FF0000$".. tostring( totalVehicles * 10 ), 212, 156, 49, true)
				end
				
				if ( totalProperty > 0 ) then
					netIncome = netIncome - ( totalProperty * 15 )
					
					outputChatBox("Property Tax: #FF0000$".. tostring( totalProperty * 15 ), 212, 156, 49, true)
				end
				
				if ( #rented > 0 ) then
					local totalRent = 0
					
					for key, value in ipairs ( rented ) do
						totalRent = totalRent + value
					end
					
					netIncome = netIncome - totalRent
					outputChatBox("Rent: #FF0000$".. tostring( totalRent ), 212, 156, 49, true)	
				end
			end	
			
			-- Net Income should be atleast 0..
			if ( netIncome < 0 ) then
				netIncome = 0
			end
		
			outputChatBox("Net Income: #00FF00$".. tostring( netIncome ), 212, 156, 49, true)
			outputChatBox("=======================================",  212, 156, 49)
			
			triggerServerEvent("tellClientPaycheck", localPlayer, playerWage, netIncome, factionID, count, array[3], array[4], key )
			
			count = count + 1
		end
	end
end
addEvent("giveClientPaycheck", true)
addEventHandler("giveClientPaycheck", localPlayer, giveClientPaycheck)