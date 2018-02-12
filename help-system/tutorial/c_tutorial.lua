local screenX, screenY = guiGetScreenSize( )

--------- [ Tutorial System ] ---------	
local line = 0	
local lines = { }

-- TUTORIAL
lines[1] = "Hello, My name is Norman Robertson and I will take only 5 minutes of your time to teach you the basics of Roleplaying."
lines[2] = "As you are about to play here, it is important for you to know what Roleplay exactly is."
lines[3] = "Let us first begin with the definition of Roleplaying, to know what it really is."
lines[4] = "In simple terms, Roleplay is playing the role of an imaginary character, but a character who is perfectly human by nature, thoughts and abilities."
lines[5] = "That is, while Roleplaying, your actions must make sense in a realistic manner. When this doesn't happen, it leads to Powergaming."
lines[6] = "Now what is Powergaming? Basically, Powergaming is when you aim to maximise your progress towards a goal by unrealistic means." 
lines[7] = "Here, let me provide you with an example, imagine that I'm being transported by the Police to the Police station.."
lines[8] = "and I certainly don't want to go to the Police station. I have perfectly no chance of escaping the vehicle I'm being transported in,"
lines[9] = "Here, my goal is to escape, and do to so I mysteriously open my hand cuffs, jump out of the vehicle and start running forward towards freedom."
lines[10] = "Now! There is something wrong here, do you know what it is? Yes, the occurance of this event was realistically impossible."
lines[11] = "So, I tried to achieve my goal by unrealistic or impractical means and hence, Powergamed."
lines[12] = "Let us now talk about another important thing, Metagaming."
lines[13] = "Metagaming is the act of unrealistically providing your character with the knowledge of a particular thing."
lines[14] = "This happens when you use Out of Character knowledge, In Character."
lines[15] = "Let me first explain you what is Out of Character (OOC) and In Character (IC)."
lines[16] = "Out of Character refers to the knowledge that you, the person in real possess, and In Character refers to the knowledge that your character in particular, possesses."
lines[17] = "For example, You know that this is a Roleplay server and you are controlling your character, this is OOC knowledge, and this is NOT known by your character."
lines[18] = "Alternatively, your character might know that the person infront of you has a revolver and he/she is about to shoot the person beside him,"
lines[19] = "but you cannot spread this In Character knowledge by Out of Character means, such as by private messaging."
lines[20] = "Now, when you exchange OOC information or IC information between yourself and your character, it is termed as Metagaming."
lines[21] = "Now there are last two very important things you need to know about, Deathmatching and Revenge Killing."
lines[22] = "Deathmatching is the act of killing/harming someone without any realistic Roleplay reason."
lines[23] = "For example, I'm Mister A standing on Main St. and Mister B approaches me, after staring at my face for a while he, without any reason, starts to punch me till I die."
lines[24] = "Now there was no past connection between me and Mister B, we did not even know each other, nor was he contracted to kill me by anyone else with a roleplay reason to kill me."
lines[25] = "Plus, it was quite unrealistic to punch anyone to death in a public place."
lines[26] = "Now, considering Revenge Killing. According to the server rules, if I am killed by someone in a realistic Roleplay manner, I'm supposed to roleplay memory loss."
lines[27] = "When, I decide to ignore this rule and go ahead to kill the man who killed me before in a Roleplay or Non-Roleplay way, I Revenge Kill."
lines[28] = "Alright, so in this class I'm only going to cover these six main things which were extremely vital for you to remember and realise."
lines[29] = "I also want to tell you about certain important things, such as your character name should be like mine, 'Norman Robertson', that is, 'Firstname Lastname'."
lines[30] = "And this is an English speaking server, so you are not allowed to talk to anyone in any other language than English, except in Private Messages. (/pm)"
lines[31] = "Also, you are not allowed to use any forms of hacks or cheats, if caught you will be banned for life. Press F2 In-Game to report any Hackers/Rule violators or request Help."
lines[32] = "So now, it is time for evaluation, I'll be giving you a small test which you MUST pass in order to play here, otherwise you will have to try again."
	
function beginTutorial( )
	local success = setCameraMatrix( 3940.166015625, -1154.0915527344, 147.81718444824, 3840.5122070313, -1146.0629882813, 149.97830200195 )
	if ( success ) then
		
		showCursor( false )
		setTimer( fadeCamera, 2000, 1, true )
		
		local clear = clearChatBox( )
		if ( clear ) then
			
			setTimer( getSentence, 2000, 1 )
			setTimer( showChat, 2000, 1, true )
		end	
	end	
end
addEvent("beginTutorial", true)
addEventHandler("beginTutorial", localPlayer, beginTutorial)

function getSentence( )
	line = line + 1
	if ( line < 33 ) then
		
		local sentence = tostring( lines[line] )
		talkToPlayer( sentence )
	
		setTimer( getSentence, 9000, 1 )
	else	
		beginEvaluation( )
	end	
end	

function talkToPlayer( text )
	local clear = clearChatBox( )
	if ( clear ) then
		
		outputChatBox("[English] Norman Robertson says: ".. tostring( text ), 255, 255, 255, true)
	end	
end

-- QUESTIONS
local questions = { }
questions[1] = { }
questions[1][0] = { "What is Roleplaying?", nil }
questions[1][1] = { "Playing the role of any imaginary character, e.g, Clint Eastwood or Chuck Norris.", false }
questions[1][2] = { "Playing the role of an anonymous Human being, having realistic abilities & drawbacks.", true }
questions[1][3] = { "Not actually playing any role, and doing whatever you want.", false }

questions[2] = { }
questions[2][0] = { "What is Powergaming?", nil }
questions[2][1] = { "Maximising your progress towards a a goal by unrealistic means.", true }
questions[2][2] = { "Playing powerfully, i.e, with total dedication", false }
questions[2][3] = { "Bullying or trying to create your influence over other players.", false }

questions[3] = { }
questions[3][0] = { "What is Metagaming?", nil }
questions[3][1] = { "PM'ing OOC information to other players while not being engaged Roleplay.", false }
questions[3][2] = { "Exchanging OOC information or IC information between yourself and your character.", true }
questions[3][3] = { "Talking about IC information to other players while Roleplaying.", false }

questions[4] = { }
questions[4][0] = { "Out of Character (OOC) refers to..", nil }
questions[4][1] = { "Things that are related to the Roleplaying environment.", false }
questions[4][2] = { "Killing a player without a proper Roleplay reason.", false }
questions[4][3] = { "Things that are not related to the Roleplaying environment.", true }

questions[5] = { }
questions[5][0] = { "In Character (IC) refers to..", nil }
questions[5][1] = { "Things that are not related to the Roleplaying environment.", false }
questions[5][2] = { "Playing the role of any imaginary character.", false }
questions[5][3] = { "Things that are related to the Roleplaying environment.", true }

questions[6] = { }
questions[6][0] = { "What is Deathmatching?", nil }
questions[6][1] = { "Killing a player after if he/she kills with or without a Roleplay reason.", false }
questions[6][2] = { "Killing a player without a proper Roleplay reason.", true }
questions[6][3] = { "Roleplaying an event which might result in the death of a player in a Roleplay way.", false }

questions[7] = { }
questions[7][0] = { "What is Revenge Killing?", nil }
questions[7][1] = { "Killing a player without a proper Roleplay reason.", false }
questions[7][2] = { "Killing a player after if he/she kills with or without a Roleplay reason.", true }
questions[7][3] = { "Roleplaying an event which might result in the death of a player in a Roleplay way.", false }

questions[8] = { }
questions[8][0] = { "Your character name must be in the format..", nil }
questions[8][1] = { "firstname lastname", false }
questions[8][2] = { "Firstname lastname", false }
questions[8][3] = { "Firstname Lastname", true }

questions[9] = { }
questions[9][0] = { "You can talk to another player in your native language..", nil }
questions[9][1] = { "via IC chat if both of the characters are from the same country.", false }
questions[9][2] = { "via Private messages.", true }
questions[9][3] = { "via OOC chat.", false }

questions[10] = { }
questions[10][0] = { "You are allowed to use hacks..", nil }
questions[10][1] = { "Under no circumstances.", true }
questions[10][2] = { "If you have permission from an Administrator.", false }
questions[10][3] = { "If you are able to handle & use them properly.", false }

function beginEvaluation( )
	local width, height = 550, 150
	local x, y = ( screenX/2 ) - ( width/2 ), ( screenY/2 ) - ( height/2 )
	
	evaluationWin = guiCreateWindow( x, y, width, height, "Evaluation Exam", false )
	evaluationLabel = guiCreateLabel( 10, 30, 525, 20, "Welcome, you need to obtain 60% marks in this exam in order to pass, Good luck!", false, evaluationWin)
	
	evaluationBegin = guiCreateButton( 225, 80, 110, 40, "Begin Exam", false, evaluationWin )
	addEventHandler("onClientGUIClick", evaluationBegin, showQuestion, false)
	
	clean = true
	
	showChat( false )
	showCursor( true )
	
	clearChatBox( )
	
	guiSetFont( evaluationLabel, "clear-normal" )
end

local taken = { }
local options = { }
local selected = 1
local marks = 0
local questionCount = 0
function showQuestion( )
	if ( clean ) then
		destroyElement( evaluationLabel )
		destroyElement( evaluationBegin )
		
		clean = false
	end
	
	local rand = getRandomQuestion( )
	if ( not rand ) then
		
		showQuestion( )
	else
		
		questionCount = questionCount + 1
		
		question = tostring( questions[rand][0][1] )
		questionLabel = guiCreateLabel( 20, 30, 400, 20, "Q".. tostring( questionCount ) ..". ".. tostring( question ), false, evaluationWin )
		
		guiSetFont( questionLabel, "default-bold-small" )
		
		options = { }
		options[1] = guiCreateRadioButton( 20, 50, 540, 20, tostring( questions[rand][1][1] ), false, evaluationWin )
		options[2] = guiCreateRadioButton( 20, 70, 540, 20, tostring( questions[rand][2][1] ), false, evaluationWin )
		options[3] = guiCreateRadioButton( 20, 90, 540, 20, tostring( questions[rand][3][1] ), false, evaluationWin )
		
		guiRadioButtonSetSelected( options[1], true )
		selected = 1
		
		for key, value in ipairs ( options ) do
			addEventHandler("onClientGUIClick", value, selectOption, false )
			
			guiSetFont( value, "default-bold-small" )
		end
		
		nextQuestion = guiCreateButton( 220, 120, 110, 20, "Next", false, evaluationWin )
		addEventHandler("onClientGUIClick", nextQuestion, 
			function( button, state )
				if ( button == "left" and state == "up" ) then
					
					local correct = questions[rand][selected][2]
					if ( correct ) then
						marks = marks + 1
					end
					
					destroyElement( source )
					destroyElement( questionLabel )
					for key, value in ipairs ( options ) do
						destroyElement( value )
					end
					
					if ( questionCount < 8 ) then
						showQuestion( )
					else
						endEvaluation( )
					end	
				end
			end, false
		)	
	end	
end

function selectOption( button, state )
	if ( button == "left" and state == "up" ) then
		
		for key, value in ipairs ( options ) do
			if ( value ~= source ) then
				guiRadioButtonSetSelected( value, false )
			else
				guiRadioButtonSetSelected( value, true )
				selected = key
			end
		end	 
	end	
end

function getRandomQuestion( )
	local rand = math.random(1, 10)
	
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

function endEvaluation( )
	local marks = ( marks/8 ) * 100
	if ( string.len( tostring( marks ) ) > 2 ) then
		marks = math.floor( tonumber( marks ) ) - 2
	end
	
	-- Passed
	local x = 225
	local greet = "Congratulations!"
	local result = "Passed"
	local only = ""
	local proud = "you can now play!"
	local text = "OK"
	local _function = endTutorial 
	local r, g, b = 0, 255, 0
	
	-- Failed
	if ( marks < 60 ) then
		x = 340
		greet = "We are sorry,"
		result = "Failed"
		only = "only "
		proud = "please click retry."
		text = "Retry Exam"
		_function = retakeExam 
		r, g,b  = 255, 0, 0
		
		buttonRetake = guiCreateButton( 100, 80, 110, 40, "Retake Class", false, evaluationWin)
		addEventHandler("onClientGUIClick", buttonRetake, restartTutorial, false)
	end
	
	evaluationLabel = guiCreateLabel( 20, 30, 525, 20, greet .." You have obtained ".. only .."".. tostring( marks ) .."% marks and ".. result ..", ".. proud, false, evaluationWin)
	
	guiLabelSetColor( evaluationLabel, r, g, b )
	guiSetFont( evaluationLabel, "clear-normal" )
	
	buttonFinish = guiCreateButton( x, 80, 110, 40, text, false, evaluationWin)
	addEventHandler("onClientGUIClick", buttonFinish, _function, false)
end

function endTutorial( button, state )
	if ( button == "left" and state == "up" ) then
		
		resetGlobals( )
		
		destroyElement( evaluationWin )
		triggerServerEvent("saveTutorial", localPlayer)
	end	
end

function retakeExam( button, state )
	if ( button == "left" and state == "up" ) then
		
		resetGlobals( )
		destroyElement( evaluationWin )
		
		beginEvaluation( )
	end
end
	
function restartTutorial( button, state )
	if ( button == "left" and state == "up" ) then
		
		resetGlobals( )
		
		destroyElement( evaluationWin )
		beginTutorial( )
	end	
end

function resetGlobals( )
	taken = { }
	marks = 0
	questionCount = 0
	line = 0

	showCursor( false )
end

function clearChatBox( )
	local lines = getChatboxLayout( )['chat_lines']
	for i = 1, lines do
		outputChatBox(" ")
	end
	
	return true
end