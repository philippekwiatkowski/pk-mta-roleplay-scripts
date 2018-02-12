local doors = { }
doors[1] = createObject(3089, -2092.3999, -237.3999, 1029.1199, 0, 0, 0)

for key, door in ipairs ( doors ) do
	setElementInterior( door, 3 )
	setElementDimension( door, 61 ) 
end	

local open = false
addCommandHandler("gate",
	function( thePlayer, commandName )
	
		local x, y, z = getElementPosition(thePlayer)
		local dx, dy, dz = getElementPosition( doors[1] )
		
		local distance = getDistanceBetweenPoints3D(dx, dy, dz, x, y, z)

		if (distance <= 5) and ( not open ) then
			
			if ( exports['[ars]inventory-system']:hasItem( thePlayer, 35 ) ) then
				
				open = true
				moveObject(doors[1], 500, -2092.3999, -237.3999, 1029.1199, 0, 0, 90)
				
				setTimer( 
					function( )
						
						open = false
						moveObject(doors[1], 500, -2092.3999, -237.3999, 1029.1199, 0, 0, -90)
					end, 2000, 1
				)	
			end
		end
	end, false, false
)	