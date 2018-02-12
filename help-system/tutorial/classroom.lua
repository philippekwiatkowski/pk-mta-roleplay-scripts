-- Classroom
addEventHandler("onResourceStart", resourceRoot,
	function( )
		createObject( 14603, 3942.6000, -1153.3000, 148.3000, 0, 0, 0 )
		createObject( 14603, 3935.7998, -1149.0996, 148.3999, 0, 0, 91.49 )  
		createObject( 3077, 3935.3999, -1154.0999, 146.6000, 0, 0, 89 )
		createObject( 1811, 3939.8999, -1152.9000, 147.3000, 0, 0, 2.24 )
		createObject( 1811, 3939.8999, -1153.9000, 147.3000, 0, 0, 2.24 )
		createObject( 1811, 3939.8999, -1154.9000, 147.3000, 0, 0, 2.24 )
		createObject( 2911, 3936.5000, -1151.4000, 146.6000, 0, 0, 1.25 )
		
		local teacher = createPed(147, 3936.5000, -1151.9000, 148.6186 )
		setElementRotation( teacher, 0, 0, 223 )
	end
)	