function helpPlayer( commandName, job )
	if (job) then
		local job = tonumber(job)
		
		if (job == 1) then
			outputChatBox("As a Road Sweeper, your objective is to take a Sweeper from the", 0, 255, 0)
			outputChatBox("depot, and follow the checkpoints, i.e cleaning the roads as", 0, 255, 0)
			outputChatBox("you go through them.", 0, 255, 0)
			outputChatBox("")
			outputChatBox("If there is anything else you would like to learn about your job,", 0, 255, 0)
			outputChatBox("please contact and Administrator.", 0, 255, 0)
	
		elseif (job == 2) then
			outputChatBox("As a Bus Driver, your objective is to take a Bus from the depot,", 0, 255, 0)
			outputChatBox("and follow the checkpoints, stopping at the green ones while", 0, 255, 0)
			outputChatBox("going through the yellow ones.", 0, 255, 0)
			outputChatBox("")
			outputChatBox("If there is anything else you would like to learn about your job,", 0, 255, 0)
			outputChatBox("please contact and Administrator.", 0, 255, 0)
			
		elseif (job == 3) then
			outputChatBox("As a Taxi Driver, your objective is to take a Taxi from the depot,", 0, 255, 0)
			outputChatBox("and wait for a call, when a customer calls, drive to their location,", 0, 255, 0)
			outputChatBox("pick them up and take them to their destination.", 0, 255, 0)
			outputChatBox("")
			outputChatBox("If there is anything else you would like to learn about your job,", 0, 255, 0)
			outputChatBox("please contact and Administrator.", 0, 255, 0)
			
		elseif (job == 4) then
			outputChatBox("As a Oil Transporter, your objective is to take a Truck from the depot,", 0, 255, 0)
			outputChatBox("and attach a trailer to it, then drive to the Gas Station.", 0, 255, 0)
			outputChatBox("")
			outputChatBox("If there is anything else you would like to learn about your job,", 0, 255, 0)
			outputChatBox("please contact and Administrator.", 0, 255, 0)
		end	
	else	
		outputChatBox("SYNTAX: /jobhelp [Job ID]", 212, 156, 49)
		outputChatBox("1 - Sweeper Job", 212, 156, 49)
		outputChatBox("2 - Bus  Job", 212, 156, 49)
		outputChatBox("3 - Taxi Job", 212, 156, 49)
		outputChatBox("4 - Oil Transporter Job", 212, 156, 49)
	end	
end
addCommandHandler("jobhelp", helpPlayer, false, false)