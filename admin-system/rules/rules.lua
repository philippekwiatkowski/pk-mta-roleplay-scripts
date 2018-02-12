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

local screenX, screenY = guiGetScreenSize( )

function createRuleUI( )
	
	local width, height = 520, 390
	local x, y = (screenX/2) - (width/2), (screenY/2) - (height/2)
	
	if ( not isElement( rulesWindow ) ) then
		rulesWindow = guiCreateWindow( x, y, width, height, "Arsenic Roleplay - Rules & Help", false )
		
		rulesPanel = guiCreateTabPanel( 10, 30, 500, 290, false, rulesWindow )
		
		rulesTab = guiCreateTab( "Rules", rulesPanel )
		rulesPane = guiCreateScrollPane( 15, 20, 480, 230, false, rulesTab )
		
		if exports['[ars]global']:c_isPlayerTrialModerator(getLocalPlayer()) then
			staffrulesTab = guiCreateTab( "Staff Rules", rulesPanel )
			staffrulesPane = guiCreateScrollPane( 15, 20, 480, 230, false, staffrulesTab )
		end
		
		roleplayingTab = guiCreateTab( "Roleplaying", rulesPanel )
		roleplayingPane = guiCreateScrollPane( 15, 20, 480, 230, false, roleplayingTab )
		
		metagamingTab = guiCreateTab( "Metagaming", rulesPanel )
		metagamingPane = guiCreateScrollPane( 15, 20, 480, 230, false, metagamingTab )
		
		powergamingTab = guiCreateTab( "Powergaming", rulesPanel )
		powergamingPane = guiCreateScrollPane( 15, 20, 480, 230, false, powergamingTab )
		
		revengekillingTab = guiCreateTab( "RKing & DMing", rulesPanel )
		revengekillingPane = guiCreateScrollPane( 15, 20, 480, 230, false, revengekillingTab )
		
		local rules = { }
		rules[1] = guiCreateLabel(10, 10, 450, 35, "1. You are required to roleplay at all times. Only the staff members are\n allowed to declare a situation out of character or void it.", false, rulesPane)
		rules[2] = guiCreateLabel(10, 50, 450, 50, "2. Cheating, hacking or bug abusing is forbidden. All bugs should be\n reported via Mantis. This is a serious offence and you will always face\n permanent ban from the server.", false, rulesPane)
		rules[3] = guiCreateLabel(10, 110, 450, 35, "3. You are not allowed to deathmatch. You must always have a proper\n roleplay reason for attacking another player.", false, rulesPane)
		rules[4] = guiCreateLabel(10, 155, 450, 50, "4. You are not allowed to revenge kill. If you get player killed, you\n must roleplay having a memory loss. Therefore you cannot remember\n the previous events before your death.", false, rulesPane) 
		rules[5] = guiCreateLabel(10, 215, 450, 20, "5. You are not allowed to metagame.", false, rulesPane)
		rules[6] = guiCreateLabel(10, 240, 450, 20, "6. You are not allowed to powergame.", false, rulesPane)
		rules[7] = guiCreateLabel(10, 265, 450, 35, "7. Do not use foreign language anywhere else except in private\n messages. The server is based on English.", false, rulesPane)
		rules[8] = guiCreateLabel(10, 300, 450, 35, "8. Do not mix In Character and Out of Character. All OOC information\n should be presented inside brackets (( Text ))", false, rulesPane)
		rules[9] = guiCreateLabel(10, 340, 450, 20, "9. Respect other players. Do not insult or harass other players in OOC.", false, rulesPane)
		rules[10] = guiCreateLabel(10, 365, 450, 35, "10. Do not roleplay in admin jail. Admin jail is an OOC punishment\n and therefore should not be roleplayed.", false, rulesPane)
		rules[11] = guiCreateLabel(10, 410, 450, 35, "11. Do not increase your health in fights/shootouts. Eating or drinking\n while fighting or having a shootout is forbidden.", false, rulesPane)
		rules[12] = guiCreateLabel(10, 450, 450, 50, "12. Do not bunny hop or tap your bike/motorbike. You are not allowed\n to do bunny jumping in order to get faster travelling speed or either\n tap your bike to get faster speed.", false, rulesPane)
		rules[13] = guiCreateLabel(10, 505, 450, 35, "13. Always roleplay jacking vehicles. Ninjajacking is not allowed and\n you are always required to represent required /me's.", false, rulesPane)
		rules[14] = guiCreateLabel(10, 545, 450, 20, "14. Do not use internet abbreviations in character.", false, rulesPane)
		rules[15] = guiCreateLabel(10, 570, 450, 35, "15. You are not allowed to exit the game to avoid death, punishment\n or a roleplay situation.", false, rulesPane)
		rules[16] = guiCreateLabel(10, 610, 450, 35, "16. You are not allowed to transfer any assets between your own\n characters. Asset transfers are only available for donators.", false, rulesPane)	
		rules[17] = guiCreateLabel(10, 650, 450, 65, "17. Your character must have a proper roleplay name. Characters\n cannot have names which are used in fictional material, for example\n movies. Nicknames are not allowed as character names. Your\n character must have a forename and a surname.", false, rulesPane)
		rules[18] = guiCreateLabel(10, 725, 450, 20, "18. Do not provoke the police, gang members or anyone else.", false, rulesPane)
		rules[19] = guiCreateLabel(10, 750, 450, 35, "19. All scams must be done in-character ways. You are not allowed to\n OOCly lie to someone in order to scam him/her.", false, rulesPane)
		rules[20] = guiCreateLabel(10, 790, 450, 20, "20. You must have a moderator/administrator permission to perform a\n scam.", false, rulesPane)
		rules[21] = guiCreateLabel(10, 815, 450, 50, "21. You must roleplay taking out your weapon with a proper /me. You\n need to define the weapon and its location along with the proper\n action.", false, rulesPane)
		rules[22] = guiCreateLabel(10, 870, 450, 50, "22. All /me's must be described properly. You shall not have /me which\n says for example /me holsters/unholsters the weapon. The /me's must\n have only one meaning.]", false, rulesPane)
		rules[23] = guiCreateLabel(10, 925, 450, 35, "23. You are not allowed to have more than two characters in offical\n factions.", false, rulesPane)
		rules[24] = guiCreateLabel(10, 965, 450, 20, "24. Do not steal faction vehicles without the faction leader's permission.", false, rulesPane)
		rules[25] = guiCreateLabel(10, 990, 450, 20, "25. When in a police chase, you must stay within the Bone County area.", false, rulesPane)
		rules[26] = guiCreateLabel(10, 1015, 450, 50, "26. If you roleplay hiding items, drugs or weapons somewhere, they\n cannot be inside your inventory. Do not keep items in your inventory\n if they are not there in roleplay way.", false, rulesPane)
		rules[27] = guiCreateLabel(10, 1075, 450, 50, "27. You cannot change your identity by changing clothes. You are still\n recognizable even if you changed your clothes as long as your face\n is visible.", false, rulesPane)
		rules[28] = guiCreateLabel(10, 1135, 450, 35, "28. You cannot have fake driver license, weapon license or any other\n license.", false, rulesPane)
		rules[29] = guiCreateLabel(10, 1175, 450, 35, "29. If you have a driving license, then your name, social security\n number and fingerprints are stored in the DMV's database.", false, rulesPane)
		rules[30] = guiCreateLabel(10, 1215, 450, 90, "30. You are not allowed to steal, burn or break into person's car,\n property or building without them being online. You will always require\n a good reason to do one of these actions. The owner of the car or\n property must be online before any action takes place. (Staff approval\n may be required in some cases)", false, rulesPane)
		
		for key, value in ipairs ( rules ) do
			guiSetFont(value, "clear-normal")
		end
		
		if exports['[ars]global']:c_isPlayerTrialModerator(getLocalPlayer()) then
		
			local srules = { }
			srules[1] = guiCreateLabel(10, 10, 450, 35, "1. You are never allowed to administrate your own roleplay, no matter\n of the rank.", false, staffrulesPane)
			srules[2] = guiCreateLabel(10, 50, 450, 60, "2. If you are a moderator, never punish another staff member.\n Instead, take a screenshot and post it on the forums or send it to\n an administrator. Only administrators are allowed to punish other\n admins if they have valid reason.", false, staffrulesPane)
			srules[3] = guiCreateLabel(10, 120, 450, 50, "3. Always follow the server's rules. Specially look after rule number\n one, if you still have to do OOC stuff, please take it over to an area\n where roleplay is not happening (Las Venturas or San Fierro)", false, staffrulesPane)
			srules[4] = guiCreateLabel(10, 175, 450, 60, "4. Never void your own punishments. You are not allowed to unjail\n yourself, remove your history or anything else similar.\n You have been punished for a reason and if you feel\n mistreated, please fill a report on forums.", false, staffrulesPane) 
			srules[5] = guiCreateLabel(10, 245, 450, 60, "5. Do not abuse your staff commands by any way. You are not\n allowed to spawn yourself items, weapons, money, properties,\n cars, factions or do anything else. If you really need something,\n contact an administrator and ask for permission.", false, staffrulesPane)
			srules[6] = guiCreateLabel(10, 310, 450, 40, "6. You are required to obey higher ranked personnel at all times, even\n if you feel they are acting wrong. If so, you can always fill a report.", false, staffrulesPane)
			srules[7] = guiCreateLabel(10, 345, 450, 45, "7. Always respect the players and the community. The staff of the\n server is the best of best, we need to look professional and be friendly.", false, staffrulesPane)
			srules[8] = guiCreateLabel(10, 380, 450, 45, "8. Do not teleport cars to their owners if they don't have a really valid\n reason. The car might be RPly stolen etc. and all the work is gone\n if you just teleport the car back to their owner.", false, staffrulesPane)
			srules[9] = guiCreateLabel(10, 430, 450, 40, "9. Do not change anyone's name or do an asset transfer without\n donation or without valid reason (ex. invalid name)", false, staffrulesPane)
			srules[10] = guiCreateLabel(10, 465, 450, 40, "10. If you are on staff duty, you are OOC. You are not allowed to\n roleplay while in staff duty.", false, staffrulesPane)
	
			for key, value in ipairs ( srules ) do
				guiSetFont(value, "clear-normal")
			end
		end
		
		local roleplaying = { }
		roleplaying[1] = guiCreateLabel(10, 10, 450, 150, "Roleplay is taking a role of an imaginary character, but a character who\n is perfectly human by nature, thoughts and abilities. When roleplaying,\n you take in consideration your character's emotional feelings,\n thoughts etcetera, the actions you make must make sense in realistic\n manner. Roleplaying has two vital terms you should understand.\n These two terms are called Out of Character (OOC) and In Character\n (IC). Out of Character refers to the knowledge that you, the person in\n real possess, and In Character refers to the knowledge that your\n character in particular, possesses.", false, roleplayingPane)
		
		for key, value in ipairs ( roleplaying ) do
			guiSetFont(value, "clear-normal")
		end
		
		local metagaming = { }
		metagaming[1] = guiCreateLabel(10, 10, 450, 150, "Metagaming is the act of unrealistically providing your character with\n the knowledge of a particular thing, this happens when you use Out\n of Character knowledge, In Character. You know that this is a Roleplay\n server and you are controlling your character, this is OOC knowledge,\n and this is NOT known by your character. Alternatively, your character\n might know that the person infront of you has a revolver and he/she\n is about to shoot the person beside him, but you cannot spread\n this In Character knowledge by Out of Character means, such as by\n private messaging. When you exchange OOC information or IC\n information between yourself and your character, it is termed as MG.", false, metagamingPane)
		
		for key, value in ipairs ( metagaming ) do
			guiSetFont(value, "clear-normal")
		end
		
		local powergaming = { }
		powergaming[1] = guiCreateLabel(10, 10, 450, 220, "Attempting to achieve your character's goals by unrealistic or\n impractical means is defined as powergaming. Powergaming is quite\n wide term, but two good examples could be as follows. You are being\n transported to Police Station by Police, you are handcuffed and inside\n locked vehicle. My goal is to escape, and do to so I mysteriously open\n my hand cuffs, jump out of the vehicle and start running forward\n towards freedom. The occurance of this event was realistically\n impossible. Now, say that I got into a fist fight with a random black\n guy on the street. You start roleplaying the fight but then all of\n sudden the opposite player starts to force you to roleplay the way\n he wants. This means that he uses such /me's and /do's that\n don't let you give any resistance to his actions. If the other\n player tries to punch you, you can try to dodge it. This kind of situation\n could also be declared powergaming.", false, powergamingPane)
		
		for key, value in ipairs ( powergaming ) do
			guiSetFont(value, "clear-normal")
		end
		
		local revengekilling = { }
		revengekilling[1] = guiCreateLabel(10, 10, 450, 100, "Deathmatching is the act of killing/harming someone without any realistic\n Roleplay reason. A realistic roleplay reason means that your\n character has such emotions against the other player that she/he\n could actually kill them. You wouldn't kill a random person you don't\n know in real life right?", false, revengekillingPane)
		revengekilling[2] = guiCreateLabel(10, 100, 450, 100, "According to the server rules, if you are killed by someone in a realistic\n Roleplay manner, you're supposed to roleplay memory loss. When you\n decide to ignore this rule and go ahead to kill the man who killed me\n before in a Roleplay or Non-Roleplay way, you Revenge Kill.", false, revengekillingPane)
		
		for key, value in ipairs ( revengekilling ) do
			guiSetFont(value, "clear-normal")
		end
		
		buttonClose = guiCreateButton(205, 340, 110, 30, "Close", false, rulesWindow)
		addEventHandler("onClientGUIClick", buttonClose, 
			function( button, state )
				if ( button == "left" and state == "up" ) then
					
					destroyElement( rulesWindow )
				end	
			end, false
		)	
		
	else
		destroyElement( rulesWindow )
	end	
end
bindKey("F1", "down", createRuleUI)