local pdgates = 
{
	{
		{ createObject(3089,250.47143554688,61.826011657715,1003.9696044922,0,0,90), 90 },
		{ createObject(3089,250.47166442871,64.801498413086,1003.9696044922,0,0,270), -90 }
	},
	{
		{ createObject(3089,244.92276000977,72.402946472168,1003.9696044922,0,0,0), -90 },
		{ createObject(3089,247.89755249023,72.399978637695,1003.9696044922,0,0,180), 90 }
	},
	{
		{ createObject(3089,247.92985534668,85.359832763672,1003.9696044922,0,0,90), -90 },
		{ createObject(3089,247.93688964844,88.326103210449,1003.9696044922,0,0,270), 90 }
	},
	{
		{ createObject(3089,247.9327545166,74.369293212891,1003.9696044922,0,0,90), -90 },
		{ createObject(3089,247.93360900879,77.327697753906,1003.9696044922,0,0,270), 90 }
	},
	{
		{ createObject(3089,222.32984924316,68.324752807617,1005.3692626953,0,0,90), 90 },
		{ createObject(3089,222.33256530762,71.303207397461,1005.3692626953,0,0,270), -90 }
	},
	{
		{ createObject(3089,222.35145568848,78.380508422852,1005.3692626953,0,0,90), 90 },
		{ createObject(3089,222.36004638672,81.324035644531,1005.3692626953,0,0,270), -90 }
	}
}

for _, group in ipairs(pdgates) do
	for _, gate in ipairs(group) do
		setElementInterior(gate[1], 6)
		setElementDimension(gate[1], 231)
	end
end

local function resetBusy( shortestID )
	pdgates[ shortestID ].busy = nil
end

local function closeDoor( shortestID )
	group = pdgates[ shortestID ]
	for _, gate in ipairs(group) do
		local nx, ny, nz = getElementPosition( gate[1] )
		moveObject( gate[1], 1000, nx + ( gate[3] and -gate[2] or 0 ), ny, nz, 0, 0, gate[3] and 0 or -gate[2] )
	end
	group.busy = true
	group.timer = nil
	setTimer( resetBusy, 1000, 1, shortestID )
end

local function openDoor(thePlayer)
	if getElementDimension(thePlayer) == 231 and getElementInterior(thePlayer) == 6 and exports['[ars]inventory-system']:hasItem(thePlayer, 32) then
		local shortest, shortestID, dist = nil, nil, 5
		local px, py, pz = getElementPosition(thePlayer)
		
		for id, group in pairs(pdgates) do
			for _, gate in ipairs(group) do
				local d = getDistanceBetweenPoints3D(px,py,pz,getElementPosition(gate[1]))
				if d < dist then
					shortest = group
					shortestID = id
					dist = d
				end
			end
		end
		
		if shortest then
			if shortest.busy then
				return
			elseif shortest.timer then
				killTimer( shortest.timer )
				shortest.timer = nil
			else
				for _, gate in ipairs(shortest) do
					local nx, ny, nz = getElementPosition( gate[1] )
					moveObject( gate[1], 1000, nx + ( gate[3] and gate[2] or 0 ), ny, nz, 0, 0, gate[3] and 0 or gate[2] )
				end
			end
			shortest.timer = setTimer( closeDoor, 5000, 1, shortestID )
		end
	end
end
addCommandHandler( "gate", openDoor)
