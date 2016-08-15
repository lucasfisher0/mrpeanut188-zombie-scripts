//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|||| Name		: zedtime.gsc
//|||| Info		: Allows for 'Zed-Time', in which time slows for a short duration after kills.
//|||| Site		: aviacreations.com
//|||| Author		: Mrpeanut188
//|||| Notes		: v1
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

/*
	Installation:
	Place this file (zedtime.gsc) inside of mods\YOURMODNAME\maps in the root folder.
	In _zombiemode_spawner.gsc :
		In function zombie_death_event( zombie )
			if( isdefined( zombie.attacker ) && isplayer( zombie.attacker ) )
			{
				damageloc = zombie.damagelocation;
				damagemod = zombie.damagemod;
				attacker = zombie.attacker;
				weapon = zombie.damageWeapon;

				self thread maps\zedtime::rollZedtime( damageloc, damagemod, attacker); // <-- Add this line here

				
	In mapname.gsc		
		Find the line:
			maps\_zombiemode::main();
			
		Add:
			maps\zedtime::init(); immediately below the 'maps\_zombiemode::main();' line.
		
		It should look like this:
			maps\_zombiemode::main();
			maps\zedtime::init();
	
	To change any settings, please see below.
	Mrpeanut188
	3/10/16
*/

#include maps\_utility;
#include maps\_zombiemode_utility;

init()
{
	// ================================= SETTINGS =================================
	
	// ================================= ZED TIME =================================
	set_zombie_var( "zedtime_duration", 		3, 		1, 		true ); 						// Duration of Zed-Time
	set_zombie_var( "zedtime_timescale", 		0.2, 	1, 		true );							// Timescale to apply during Zed-Time
	set_zombie_var( "zedtime_cooldown", 		10, 	1, 		true );							// Cooldown in seconds

	// ================================= ACTIVATION =================================
	set_zombie_var( "zedtime_chance_base", 				2.5, 		1, 		true ); 			// Chance to trigger
	set_zombie_var( "zedtime_chance_knife", 			0, 			1, 		true ); 			// Additional chance when killed with a melee weapon	
	set_zombie_var( "zedtime_chance_head", 				2, 			1, 		true ); 			// Additional chance when killed with a headshot
	set_zombie_var( "zedtime_chance_pistol",	 		0, 			1, 		true ); 			// Additional chance for pistols and shotguns
	set_zombie_var( "zedtime_chance_rifle",		 		0, 			1, 		true ); 			// Additional chance for rifles
	set_zombie_var( "zedtime_chance_explosive", 		3, 			1, 		true ); 			// Additional chance for explosive weapons & grenades
	set_zombie_var( "zedtime_chance_projectile", 		2.5, 		1, 		true ); 			// Additional chance for projectile weapons & splash damage
	set_zombie_var( "zedtime_chance_extension", 		100, 		1, 		true ); 			// Additional chance while killing zombies during zedtime
	set_zombie_var( "zedtime_chance_time_multiplier", 	3,			1,		true );				// Multiplier for chance after a minute without activation
	// ================================= SETTINGS =================================
	
	setDvar("zedtime_enable", 2);
}	

// ================================= DO NOT EDIT BELOW UNLESS YOU KNOW WHAT YOU ARE DOING =================================
rollZedtime( damageloc, damagemod, attacker ) 
{
	if (getDvarInt("zedtime_enable")==0)
		return;
		
	zedtime_chance = level.zombie_vars[ "zedtime_chance_base" ];
	
	if (damagemod == "MOD_EXPLOSIVE" || damagemod == "MOD_GRENADE" || damagemod == "MOD_GRENADE_SPLASH")
		{zedtime_chance = (zedtime_chance + level.zombie_vars[ "zedtime_chance_explosive" ]);}
	
	if (damagemod == "MOD_PROJECTILE" || damagemod == "MOD_PROJECTILE_SPLASH")
		{zedtime_chance = (zedtime_chance + level.zombie_vars[ "zedtime_chance_projectile" ]);}	
	
	if (damagemod == "MOD_PISTOL_BULLET")
		{zedtime_chance = (zedtime_chance + level.zombie_vars[ "zedtime_chance_pistol" ]);}
		
	if (damagemod == "MOD_RIFLE_BULLET")
		{zedtime_chance = (zedtime_chance + level.zombie_vars[ "zedtime_chance_rifle" ]);}

	if (damagemod == "MOD_MELEE")
		{zedtime_chance = (zedtime_chance + level.zombie_vars[ "zedtime_chance_knife" ]);}
	
	if (damagemod == "MOD_HEAD_SHOT" || damageloc == "head" || damageloc == "helmet" || damageloc == "neck")
		{zedtime_chance = (zedtime_chance + level.zombie_vars[ "zedtime_chance_head" ]);}
	
	if (getDvarFloat("timescale")==level.zombie_vars[ "zedtime_timescale" ])
		{zedtime_chance = (zedtime_chance + level.zombie_vars[ "zedtime_chance_extension" ]);}

	if (getDvarInt("zedtime_enable")==2)
		{zedtime_chance = (zedtime_chance * level.zombie_vars[ "zedtime_chance_time_multiplier" ]);}

		
	// ACTIVATE ZED-TIME
	if (randomInt(100) <= zedtime_chance)
	{
		level notify( "zedtime" );
		level endon( "zedtime" );
		
		players = GetPlayers();
		for(i = 0; i < players.size; i++) 
		{
			players[i] SetClientDvars("sv_cheats", 1, "timescale", level.zombie_vars[ "zedtime_timescale" ], "snd_pitch_timescale", 1, "sf_use_bw", 1);
		}
	
		setDvar("zedtime_enable", 0);

		for(i = 0; i < players.size; i++) 
		{
			players[i] SetClientDvars("timescale", 1, "snd_pitch_timescale", 0, "sf_use_bw", 0);
		}
		
		wait(level.zombie_vars[ "zedtime_cooldown" ]);
		setDvar("zedtime_enable", 1);
		
		wait(60);
		setDvar("zedtime_enable", 2);
	}
}




