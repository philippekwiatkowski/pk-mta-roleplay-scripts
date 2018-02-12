addEventHandler("onClientResourceStart", resourceRoot,
	function( )
		
		-- Skins
		
		fdskin1 = engineLoadTXD ( "skins/277.txd" )
		engineImportTXD ( fdskin1, 277)
		fdskin1 = engineLoadDFF ( "skins/277.dff", 277)
		engineReplaceModel ( fdskin1, 277 )
		
		fdskin2 = engineLoadTXD ( "skins/278.txd" )
		engineImportTXD ( fdskin2, 278)
		fdskin2 = engineLoadDFF ( "skins/278.dff", 278)
		engineReplaceModel ( fdskin2, 278 )
		
		mongolskin1 = engineLoadTXD ( "skins/9.txd" )
		engineImportTXD ( mongolskin1, 9)
		mongolskin1 = engineLoadDFF ( "skins/9.dff",9)
		engineReplaceModel ( mongolskin1, 9 )
		
		mongolskin2 = engineLoadTXD ( "skins/31.txd" )
		engineImportTXD ( mongolskin2, 31)
		mongolskin2 = engineLoadDFF ( "skins/31.dff", 31)
		engineReplaceModel ( mongolskin2, 31)
		
		mongolskin3 = engineLoadTXD ( "skins/38.txd" )
		engineImportTXD ( mongolskin3, 38)
		mongolskin3 = engineLoadDFF ( "skins/38.dff", 38)
		engineReplaceModel ( mongolskin3, 38 )
		
		mongolskin4 = engineLoadTXD ( "skins/10.txd" )
		engineImportTXD ( mongolskin4, 10)
		mongolskin4 = engineLoadDFF ( "skins/10.dff", 10)
		engineReplaceModel ( mongolskin4, 10 )
		
		suzie = engineLoadTXD ( "skins/165.txd" )
		engineImportTXD ( suzie, 165 )
		suzie = engineLoadDFF ( "skins/165.dff", 165 )
		engineReplaceModel ( suzie, 165 )
		
		-- Vehicles
		
		--ambulance = engineLoadTXD ( "vehicles/ambulance.txd" )
		--engineImportTXD ( ambulance, 416)
		--ambulance = engineLoadDFF ( "vehicles/ambulance.dff", 416)
		--engineReplaceModel ( ambulance, 416 )
		
		--firetruck = engineLoadTXD ( "vehicles/firetruck.txd" )
		--engineImportTXD ( firetruck, 407)
		--firetruck = engineLoadDFF ( "vehicles/firetruck.dff", 407)
		--engineReplaceModel ( firetruck, 407 )
		
		--ladder = engineLoadTXD ( "vehicles/ladder.txd" )
		--engineImportTXD ( ladder, 544)
		--ladder = engineLoadDFF ( "vehicles/ladder.dff", 544)
		--engineReplaceModel ( ladder, 544 )
		
		-- Weapons
		local weapons = 
		{ 
			["colt45"] = 346, ["ak47"] = 355, ["combatshotgun"] = 351, ["deagle"] = 348, 
			["m4"] = 356, ["mp5"] = 353, ["rifle"] = 357, ["sawnoff"] = 350, ["shotgun"] = 349, 
			["taser"] = 347, ["sniper"] = 358, ["uzi"] = 352
		}
		
		
		for key, value in pairs ( weapons ) do
			local var = { }
			
			var[1] = engineLoadTXD( "weapons/".. key ..".txd", value)
			engineImportTXD( var[1] , value )
			
			var[2] = engineLoadDFF( "weapons/".. key ..".dff", value)
			engineReplaceModel( var[2], value )
		end	
		
		-- World
		local world = { ["speedcamera"] = 3441 }
		
		for key, value in pairs ( world ) do
			local var = { }
			
			var[1] = engineLoadTXD("world/".. key ..".txd", value)
			engineImportTXD( var[1], value )
			
			var[2] = engineLoadDFF( "world/".. key ..".dff", value)
			engineReplaceModel( var[2], value )
			
			var[3] = engineLoadCOL( "world/".. key ..".col", value)
			engineReplaceCOL ( var[3], value)
		end	
		
		
		fireLarge = engineLoadDFF( "world/fire_large.dff", 14862 )
		engineReplaceModel( fireLarge, 14862)
		
		smoke50lit = engineLoadDFF ( "world/smoke50lit.dff", 3082 )
		engineReplaceModel( smoke50lit, 3082)
		
		flag = engineLoadTXD ( "world/cj_ammo_posters.txd" )
		engineImportTXD ( flag, 2047 )
		
		firedepartment = engineLoadTXD ( "world/firehouse_sfse.txd" )
		engineImportTXD ( firedepartment, 11008 )
		
		fd = engineLoadDFF ( "world/firehouse.dff", 11008 )
		engineReplaceModel( fd, 11008)
		
		fdcol = engineLoadCOL( "world/sfse_12.col" )
		engineReplaceCOL( fdcol, 11008 )
		
		weed = engineLoadTXD ( "world/weed.txd" )
		engineImportTXD ( weed, 3409 )
		weed = engineLoadDFF ( "world/weed.dff", 3409 )
		engineReplaceModel( weed, 3409)

		lilprobeinn = engineLoadTXD ( "world/des_ufoinn.txd" )
		engineImportTXD ( lilprobeinn, 16146 )
		
		lilprobeinn2 = engineLoadTXD ( "world/desn2_stud.txd" )
		engineImportTXD ( lilprobeinn2, 16388 )
		
		tajiri = engineLoadTXD ( "world/airp_prop.txd" )
		engineImportTXD ( tajiri, 2789 )
		
		speedlimits = engineLoadTXD("world/privatesign.txd", 3262 )
		engineImportTXD(speedlimits, 3262)
  
		speedlimits2 = engineLoadTXD("world/privatesign.txd", 3263 )
		engineImportTXD(speedlimits2, 3263)
		
	end
)