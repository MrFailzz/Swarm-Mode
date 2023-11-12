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
	};

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

function PingEntity(entity, player, tracepos, automatedPing = false)
{
	// Get entity info
	local entityReturnName = GetEntityType(entity);
	local applyPingDuration = pingDuration;

	// Create ping object in the world if we hit an entity we don't want to highlight
	if (!automatedPing)
	{
		if (!entityReturnName)
		{
			PingWorld(tracepos, player);
			return;
		}
	}
	else
	{
		applyPingDuration = 2;
	}

	if (entityReturnName != "Crows")
	{
		NetProps.SetPropInt(entity, "m_Glow.m_iGlowType", 3);

		if (entity.ValidateScriptScope())
		{
			local ping_entityscript = entity.GetScriptScope();
			ping_entityscript["TickCount"] <- 0;
			ping_entityscript["Owner"] <- player;
			ping_entityscript["PingKill"] <- function()
			{
				if (ping_entityscript["TickCount"] > (applyPingDuration / 0.1) || ping_entityscript["Owner"].IsDying())
				{
					NetProps.SetPropInt(entity, "m_Glow.m_iGlowType", 0);
					return;
				}
				ping_entityscript["TickCount"]++;
				return;
			}
			AddThinkToEnt(entity, "PingKill");
		}
		else
		{
			NetProps.SetPropInt(entity, "m_Glow.m_iGlowType", 0);
		}
	}
	else
	{
		// Make the whole crow group glow when one is pinged
		local entityName = entity.GetName();

		if (entityName != "")
		{
			local nameArray = split(entityName, "_");

			if (nameArray.len() >= 3)
			{
				local crowGroupName = "__" + nameArray[0] + "_" + nameArray[1] + "_" + nameArray[2] + "*";
				EntFire(crowGroupName, "StartGlowing", "", 0);
				EntFire(crowGroupName, "StopGlowing", "", applyPingDuration);
			}
		}
	}

	// Notifications
	if (!automatedPing)
	{
		ClientPrint(null, 3, "\x04" + player.GetPlayerName() + "\x01 pinged \x03" + entityReturnName);
		EmitSoundOn("ui\\beepclear.wav", player);
	}
}

function PingWorld(pingOrigin, player)
{
    PrecacheModel( "swarm/sprites/ping01.vmt" );

        local playerID = player.GetEntityIndex();
        local pingName = "pingWorld" + playerID;

        // Create fake prop for glow
        local pingWorld = SpawnEntityFromTable("env_sprite",
        {
            targetname = pingName,
            model = "swarm/sprites/ping01.vmt",
            scale = 0.1,
            framerate = 0,
			rendermode = 9,
			renderamt = 255,
        });

        // Apply ping glow
        DoEntFire("!self", "ShowSprite", "", 0, null, pingWorld);
		pingWorld.SetLocalOrigin(pingOrigin);

        // Remove ping
        DoEntFire("!self", "Kill", "", pingDuration, null, pingWorld);

        EmitSoundOn("ui\\beepclear.wav", player);
}

function HeightendSensesPing(player)
{
	local autoPingDuration = 2;
	local entity = null;

	while ((entity = Entities.FindInSphere(entity, player.GetOrigin(), 300)) != null)
	{
		//Ignore invalid entities
		local entityReturnName = GetEntityType(entity);
		if (!entityReturnName)
		{
			continue;
		}

		//Ignore survivors
		if (entity.GetClassname() == "player")
		{
			if (entity.IsSurvivor() || entity.IsDying() || entity.IsDead())
			{
				continue;
			}
		}

		//Ignore items in inventory
		local playerInv = null;
		local skipInventory = false;
		while ((playerInv = Entities.FindByClassname(playerInv, "player")) != null)
		{
			local invTable = {};
			GetInvTable(playerInv, invTable);
			foreach(slot, weapon in invTable)
			{
				if (weapon == entity)
				{
					skipInventory = true;
				}
			}
		}
		if (skipInventory)
		{
			continue;
		}

		PingEntity(entity, player, Vector(0, 0, 0), true);
	}
}

function GetEntityType(entity)
{
	switch(entity.GetClassname())
	{
		case "player":
			//Smoker = 1, Boomer = 2, Hunter = 3, Spitter = 4, Jockey = 5, Charger = 6, Witch = 7, Tank = 8, Survivor = 9
			switch(entity.GetZombieType())
			{
				case 1:
					if (specialHockerType == "Hocker")
						return "Hocker";
					else if (specialHockerType == "Stinger")
						return "Stinger";
				break;

				case 2:
					if (specialRetchType == "Retch")
						return "Retch";
					else if (specialRetchType == "Exploder")
						return "Exploder";
					else if (specialRetchType == "Reeker")
						return "Reeker";
				break;

				case 3:
					return "Sleeper";
				break;

				case 5:
					return "Stalker";
				break;

				case 6:
					if (specialTallboyType == "Tallboy")
						return "Tallboy";
					else if (specialTallboyType == "Crusher")
						return "Crusher";
					else if (specialTallboyType == "Bruiser")
						return "Bruiser";
				break;

				case 8:
					if (bossType == "Breaker")
						return "Breaker";
					if (bossType == "Ogre")
						return "Ogre";
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
			if (entity.GetName().find("__alarm_door_") != null)
				return "Alarm Door";
			else
				return false;
		break;

		case "prop_door_rotating_checkpoint":
			return "Saferoom Door";
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
			if (entity.GetModelName() == "models/swarm/jockey_crow.mdl")
				return "Crows";
			else
				return false;
		break;

		case "prop_physics":
			switch(entity.GetModelName())
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

				case "models/props_junk/gnome.mdl":
					return "Gnome";
				break

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
			return "Barbed Wire";
		break;

		case "weapon_upgradepack_incendiary_spawn":
		case "weapon_upgradepack_incendiary":
		case "upgrade_ammo_incendiary":
			return "Ammo Pack";
		break;

		case "upgrade_laser_sight":
			return "Laser Sight";
		break;

		case "weapon_vomitjar_spawn":
		case "weapon_vomitjar":
			return "Bile Jar";
		break;

		case "weapon_spawn":
			switch(entity.GetModelName())
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