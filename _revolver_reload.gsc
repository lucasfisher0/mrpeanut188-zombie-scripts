//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|||| Name		: _revolver_reload.gsc
//|||| Info		: Forces reload from empty after firing.
//|||| Site		: aviacreations.com
//|||| Author		: Mrpeanut188 (Credit required, see thread.)
//|||| Notes		: 
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
/*
	Installation
		Place in mods/MAPNAME/maps and replace if necessary.
		Include in .IWD.

		mapname.gsc:
		Add at the end of Main():
			players = getPlayers();
			for (i = 0; i < players.size; i++)
				players[i] thread maps\_revolver_reload::Init();
*/

#include maps\_utility; 
#include common_scripts\utility; 
#include maps\_zombiemode_utility;

Init()
{
	self thread cofWeaponRevolver();
}

cofWeaponRevolver()
{
	self endon("disconnect");
	self thread cofWeaponRevolver_FireWatch();
	for (;;)
	{
		self waittill( "reload_start" );
		println( "Player is reloading! (reload_start)" );
		
		if (self.forceRevolverReload == true)
		{
			currentWeapon = self getCurrentWeapon();
			if ( currentWeapon == "cof_revolver" || currentWeapon == "cof_revolver_upgraded" )
			{
				println( "Forcing Reload From Empty!" );
				
				clipAmmo = self GetWeaponAmmoClip( currentWeapon );
				self setWeaponAmmoClip( currentWeapon, 0 );
				self.forceRevolverReload = false;
			
				self setWeaponAmmoStock( currentWeapon, self GetWeaponAmmoStock( currentWeapon ) + clipAmmo );
			}
		}
	}
}

cofWeaponRevolver_FireWatch()
{
	self endon("disconnect");
	self.forceRevolverReload = false;
	
	for (;;)
	{
		self waittill( "weapon_fired" );
		currentWeapon = self getCurrentWeapon();
		if ( currentWeapon == "cof_revolver" || currentWeapon == "cof_revolver_upgraded" )
			self.forceRevolverReload = true;
	}
}
