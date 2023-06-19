///////////////////////////////////////////////
//                PING SYSTEM                //
///////////////////////////////////////////////
if (!IsSoundPrecached("ui\\beepclear.wav"))
	PrecacheSound("ui\\beepclear.wav");

function TraceEye(player)
{
	local eyeAngles = player.EyeAngles();
	local eyePosition = player.EyePosition();
	local traceStart = eyePosition;
	local traceEnd = eyePosition + (eyeAngles.Forward() * pingRange);

	local traceTable =
	{
		start = eyePosition
		end = traceEnd
		ignore = player
	}

	if(TraceLine(traceTable))
	{
		if(traceTable.hit)
		{
			PingEntity(traceTable.enthit, player, traceTable.pos);

			// Uncomment to show where ping is landing
			/*SpawnEntityFromTable("prop_dynamic_override",
			{
				origin = traceTable.pos,
				model = "models/w_models/weapons/w_eq_painpills.mdl",
				solid = 0,
			});*/
		}
		else
		{
			PingWorld(traceTable.pos, player);
		}
	}
}

function PingEntity(entity, player, tracepos)
{
	// Get entity info
	local entityClassname = GetEntityType(entity);
	if (entityClassname == false)
	{
		PingWorld(tracepos, player);
		return;
	}

	// Check if entity has a targetname
	local entityName = entity.GetName();
	local entityIndex = entity.GetEntityIndex();
	if (entityName == "")
	{
		// Give it a name
		entityName = "__pingtarget_" + entityIndex;
		DoEntFire("!self", "AddOutput", "targetname " + entityName, 0, entity, entity);
	}

	local canGlow = CanGlow(entityClassname);
	if (canGlow == false)
	{
		// Create fake prop for glow
		local glow_name = "__pingtarget_" + entityIndex + "_glow_";
		local entityAngles = entity.GetAngles();
		local glow_target = SpawnEntityFromTable("prop_dynamic_override",
		{
			targetname = glow_name,
			origin = entity.GetOrigin(),
			angles = Vector(entityAngles.x, entityAngles.y, entityAngles.z),
			model = entity.GetModelName(),
			solid = 0,
			rendermode = 10
		});

		// Apply ping glow
		DoEntFire("!self", "SetParent", entityName, 0, null, glow_target);
		DoEntFire("!self", "StartGlowing", "", 0, null, glow_target);

		// Remove ping
		DoEntFire("!self", "StopGlowing", "", pingDuration, null, glow_target);
		DoEntFire("!self", "Kill", "", pingDuration, null, glow_target);
	}
	else if (canGlow == true)
	{
		// Apply ping glow
		DoEntFire("!self", "StartGlowing", "", 0, null, entityName);

		// Remove ping
		DoEntFire("!self", "StopGlowing", "", pingDuration, null, entityName);
	}
	else if (canGlow == "crows")
	{
		local nameArray = split(entityName, "_");
		local crowGroupName = "__" + nameArray[0] + "_" + nameArray[1] + "_" + nameArray[2] + "*";

		// Apply ping glow
		EntFire(crowGroupName, "StartGlowing", "", 0);

		// Remove ping
		EntFire(crowGroupName, "StopGlowing", "", pingDuration);
	}

	// Notifications
	ClientPrint(null, 3, "\x04" + player.GetPlayerName() + "\x01 pinged \x03" + entityClassname);
	EmitSoundOn("ui\\beepclear.wav", player)
}

function PingWorld(pingOrigin, player)
{
	local playerID = player.GetEntityIndex();
	local pingName = "pingWorld" + playerID;

	// Create fake prop for glow
	local pingWorld = SpawnEntityFromTable("prop_dynamic",
	{
		targetname = pingName,
		origin = pingOrigin,
		angles = Vector(0, 0, 0),
		model = "models/props_fortifications/concrete_post001_48.mdl",
		solid = 0,
		rendermode = 10
	});

	// Apply ping glow
	DoEntFire("!self", "StartGlowing", "", 0, null, pingWorld);

	// Remove ping
	DoEntFire("!self", "StopGlowing", "", pingDuration, null, pingWorld);
	DoEntFire("!self", "Kill", "", pingDuration, null, pingWorld);

	EmitSoundOn("ui\\beepclear.wav", player)
}

function GetEntityType(entity)
{
	local entityClassname = entity.GetClassname();
	local targetname = entity.GetName();

	switch(entityClassname)
	{
		case "player":
			//Smoker = 1, Boomer = 2, Hunter = 3, Spitter = 4, Jockey = 5, Charger = 6, Witch = 7, Tank = 8, Survivor = 9
			switch(entity.GetZombieType())
			{
				case 1:
					return "Hocker";
					break;
				case 2:
					return "Exploder";
					break;
				case 3:
					return "Sleeper";
					break;
				case 4:
					return "Retch";
					break;
				case 5:
					return "Stalker";
					break;
				case 6:
					return "Tallboy";
					break;
				case 7:
					return "Snitcher";
					break;
				case 8:
					return "Breaker";
					break;
				case 9:
					return entity.GetPlayerName();
					break;
				default:
					return false;
					break;
			}
			break;
		case "witch":
			return "Snitcher";
			break;
		case "prop_door_rotating":
			if (targetname.find("__alarm_door") != null)
			{
				return "Alarm Door";
			}
			else
			{
				return false;
			}
			break;
		case "prop_car_alarm":
			return "Alarm Car";
			break;
		case "prop_health_cabinet":
			return "First Aid Cabinet";
			break;
		case "prop_fuel_barrel":
			return "Explosive";
			break;
		case "prop_minigun":
		case "prop_minigun_l4d1":
		case "prop_mounted_machine_gun":
			return "Minigun";
			break;
		case "prop_dynamic":
			local modelName = entity.GetModelName();
			switch(modelName)
			{
				case "models/swarm/jockey_crow.mdl":
					return "Crows";
					break;
				default:
					return false;
					break;
			}
			break;
		case "prop_physics":
			local modelName = entity.GetModelName();
			switch(modelName)
			{
				case "models/props_junk/propanecanister001a.mdl":
					return "Propane Canister";
					break;
				case "models/props_junk/gascan001a.mdl":
					return "Gas Can";
					break;
				case "models/props_equipment/oxygentank01.mdl":
					return "Oxygen Tank";
					break;
				case "models/props_junk/explosive_box001.mdl":
					return "Fireworks";
					break;
				default:
					return false;
					break;
			}
			break;
		case "weapon_ammo_spawn":
		case "weapon_ammo":
			return "Ammo Pile";
			break;
		case "weapon_adrenaline_spawn":
		case "weapon_adrenaline":
			return "Adrenaline";
			break;
		case "weapon_autoshotgun_spawn":
		case "weapon_autoshotgun":
			return "M4 Autoshotgun";
			break;
		case "weapon_chainsaw_spawn":
		case "weapon_chainsaw":
			return "Chainsaw";
			break;
		case "weapon_defibrillator_spawn":
		case "weapon_defibrillator":
			return "Defibrillator";
			break;
		case "weapon_first_aid_kit_spawn":
		case "weapon_first_aid_kit":
			return "First Aid Kit";
			break;
		case "weapon_grenade_launcher_spawn":
		case "weapon_grenade_launcher":
			return "Grenade Launcher";
			break;
		case "weapon_hunting_rifle_spawn":
		case "weapon_hunting_rifle":
			return "Hunting Rifle";
			break;
		case "weapon_molotov_spawn":
		case "weapon_molotov":
			return "Molotov";
			break;
		case "weapon_pain_pills_spawn":
		case "weapon_pain_pills":
			return "Pain Pills";
			break;
		case "weapon_pipe_bomb_spawn":
		case "weapon_pipe_bomb":
			return "Pipe Bomb";
			break;
		case "weapon_pistol_magnum_spawn":
		case "weapon_pistol_magnum":
			return "Magnum";
			break;
		case "weapon_pistol_spawn":
		case "weapon_pistol":
			return "Pistol";
			break;
		case "weapon_pumpshotgun_spawn":
		case "weapon_pumpshotgun":
			return "Pump Shotgun";
			break;
		case "weapon_rifle_ak47_spawn":
		case "weapon_rifle_ak47":
			return "AK47";
			break;
		case "weapon_rifle_desert_spawn":
		case "weapon_rifle_desert":
			return "Desert Rifle";
			break;
		case "weapon_rifle_m60_spawn":
		case "weapon_rifle_m60":
			return "M60 Machine Gun";
			break;
		case "weapon_rifle_sg552_spawn":
		case "weapon_rifle_sg552":
			return "SG 552 Assault Rifle";
			break;
		case "weapon_rifle_spawn":
		case "weapon_rifle":
			return "M16 Assault Rifle";
			break;
		case "weapon_shotgun_chrome_spawn":
		case "weapon_shotgun_chrome":
			return "Chrome Shotgun";
			break;
		case "weapon_shotgun_spas_spawn":
		case "weapon_shotgun_spas":
			return "SPAS-12 Shotgun";
			break;
		case "weapon_smg_mp5_spawn":
		case "weapon_smg_mp5":
			return "MP5";
			break;
		case "weapon_smg_silenced_spawn":
		case "weapon_smg_silenced":
			return "Silenced SMG";
			break;
		case "weapon_smg_spawn":
		case "weapon_smg":
			return "Uzi";
			break;
		case "weapon_sniper_awp_spawn":
		case "weapon_sniper_awp":
			return "AWP";
			break;
		case "weapon_sniper_military_spawn":
		case "weapon_sniper_military":
			return "Military Sniper";
			break;
		case "weapon_sniper_scout_spawn":
		case "weapon_sniper_scout":
			return "Scout Sniper Rifle";
			break;
		case "weapon_sniper_scout_spawn":
		case "weapon_sniper_scout":
			return "Scout";
			break;
		case "weapon_upgradepack_explosive_spawn":
		case "weapon_upgradepack_explosive":
		case "upgrade_ammo_explosive":
			return "Explosive Ammo";
			break;
		case "weapon_upgradepack_incendiary_spawn":
		case "weapon_upgradepack_incendiary":
		case "upgrade_ammo_incendiary":
			return "Incendiary Ammo";
			break;
		case "upgrade_laser_sight":
			return "Laser Sight";
			break;
		case "weapon_vomitjar_spawn":
			return "Bile Jar";
			break;
		case "weapon_spawn":
			local modelName = entity.GetModelName();
			switch(modelName)
			{
				case "models/w_models/weapons/w_autoshot_m4super.mdl":
					return "M4 Autoshotgun";
					break;
				case "models/w_models/weapons/w_desert_eagle.mdl":
					return "Magnum";
					break;
				case "models/w_models/weapons/w_desert_rifle.mdl":
				case "models/w_models/weapons/w_rifle_b.mdl":
					return "Desert Rifle";
					break;
				case "models/w_models/weapons/w_grenade_launcher.mdl":
					return "Grenade Launcher";
					break;
				case "models/w_models/weapons/w_m60.mdl":
					return "M60 Machine Gun";
					break;
				case "models/w_models/weapons/w_pistol_a.mdl":
				case "models/w_models/weapons/w_pistol_b.mdl":
					return "Pistol";
					break;
				case "models/w_models/weapons/w_pumpshotgun_A.mdl":
					return "Chrome Shotgun";
					break;
				case "models/w_models/weapons/w_rifle_ak47.mdl":
					return "AK47";
					break;
				case "models/w_models/weapons/w_rifle_m16a2.mdl":
					return "M16 Assault Rifle";
					break;
				case "models/w_models/weapons/w_rifle_sg552.mdl":
					return "SG 552 Assault Rifle";
					break;
				case "models/w_models/weapons/w_shotgun.mdl":
					return "Pump Shotgun";
					break;
				case "models/w_models/weapons/w_shotgun_spas.mdl":
					return "SPAS-12 Shotgun";
					break;
				case "models/w_models/weapons/w_smg_a.mdl":
					return "Silenced SMG";
					break;
				case "models/w_models/weapons/w_smg_mp5.mdl":
					return "MP5";
					break;
				case "models/w_models/weapons/w_smg_uzi.mdl":
					return "Uzi";
					break;
				case "models/w_models/weapons/w_sniper_awp.mdl":
					return "AWP";
					break;
				case "models/w_models/weapons/w_sniper_military.mdl":
					return "Military Sniper";
					break;
				case "models/w_models/weapons/w_sniper_mini14.mdl":
					return "Hunting Rifle";
					break;
				case "models/w_models/weapons/w_sniper_scout.mdl":
					return "Scout Sniper Rifle";
					break;
				case "models/weapons/melee/w_chainsaw.mdl":
					return "Chainsaw";
					break;
				default:
					return false;
					break;
			}
			break;
		case "weapon_melee_spawn":
		case "weapon_melee":
			return "Melee Weapon";
			break;
		case "weapon_propanetank":
			return "Propane Canister";
			break;
		case "weapon_gascan":
			return "Gas Can";
			break;
		case "weapon_oxygentank":
			return "Oxygen Tank";
			break;
		case "weapon_fireworkcrate":
			return "Fireworks";
			break;
		default:
			return false;
			break;
	}
}

// Returns if entity needs to spawn dynamic prop, turns out everything does (crows are a special case)
function CanGlow(entityName)
{
	switch(entityName)
	{
		//case "Alarm Door":
		//case "Alarm Car":
		//case "First Aid Cabinet":
		//case "Explosive Barrel":
		//case "Minigun":
		//case "Propane Canister":
		//case "Gas Can":
		//case "Oxygen Tank":
		//case "Fireworks":
		//	return true;
		//	break;
		case "Crows":
			return "crows";
			break;
		default:
			return false;
			break;
	}
}