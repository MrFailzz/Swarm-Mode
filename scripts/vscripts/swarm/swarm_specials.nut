///////////////////////////////////////////////
//          PROPERTY / MODEL CHANGES         //
///////////////////////////////////////////////
function MutationSpawn(player)
{
	if (!IsModelPrecached("models/infected/smoker.mdl"))
		PrecacheModel("models/infected/smoker.mdl");
	if (!IsModelPrecached("models/swarm/infected/hunter.mdl"))
		PrecacheModel("models/swarm/infected/hunter.mdl");
	if (!IsModelPrecached("models/swarm/infected/boomer.mdl"))
		PrecacheModel("models/swarm/infected/boomer.mdl");
	if (!IsModelPrecached("models/swarm/infected/boomette.mdl"))
		PrecacheModel("models/swarm/infected/boomette.mdl");
	if (!IsModelPrecached("models/swarm/infected/boomer_l4d1.mdl"))
		PrecacheModel("models/swarm/infected/boomer_l4d1.mdl");
	if (!IsModelPrecached("models/infected/limbs/exploded_boomette.mdl"));
		PrecacheModel("models/infected/limbs/exploded_boomette.mdl");

	//Smoker = 1, Boomer = 2, Hunter = 3, Spitter = 4, Jockey = 5, Charger = 6, Witch = 7, Tank = 8, Survivor = 9
	switch(player.GetZombieType())
	{
		case 1:
		{
			player.SetModel("models/infected/smoker.mdl");
			break;
		}
		case 2:
		{
			if (corruptionRetch == "Exploder")
			{
				player.SetModel("models/swarm/infected/boomer.mdl");
				break;
			}
			else if (corruptionRetch == "Retch")
			{
				player.SetModel("models/swarm/infected/boomette.mdl");
				break;
			}
			else if (corruptionRetch == "Reeker")
			{
				player.SetModel("models/swarm/infected/boomer_l4d1.mdl");
				break;
			}
		}
		case 3:
		{
			//Make regular hunters always use L4D2 model so we can change texture
			player.SetModel("models/swarm/infected/hunter.mdl");
			NetProps.SetPropInt(player, "m_fFlags", NetProps.GetPropInt(player, "m_fFlags") | (1 << 6)) //FL_ATCONTROLS			(1 << 6)	/**< Player can't move, but keeps key inputs for controlling another entity */
			break;
		}
		case 5:
		{
			player.SetModel("models/infected/jockey.mdl");
			player.SetModelScale(1.25, 0.0);
			break;
		}
		case 6:
		{
			z_speed = Convars.GetFloat("z_speed");
			NetProps.SetPropFloat(player, "m_flLaggedMovementValue", (tallboyRunSpeed / z_speed));
			break;
		}
		case 8:
		{
			if (!IsModelPrecached(tankModel))
				PrecacheModel(tankModel);

			player.SetModel(tankModel);
		}
		default:
			break;
	}
}

///////////////////////////////////////////////
//             HOCKER KNOCKBACK              //
///////////////////////////////////////////////
function TongueGrab(params)
{
	local player = GetPlayerFromUserID(params["userid"]);

	// Make victim move backwards
	Convars.SetValue("tongue_victim_acceleration", -450);
	Convars.SetValue("tongue_victim_max_speed", 450);

	if (player.ValidateScriptScope())
	{
		local player_entityscript = player.GetScriptScope();
		player_entityscript["TickCount"] <- 0;
		player_entityscript["TongueSpeedReset"] <- function()
		{
			// Decelerate victim at specific ticks
			if (player_entityscript["TickCount"] == 1)
			{
				Convars.SetValue("tongue_victim_acceleration", -175);
				Convars.SetValue("tongue_victim_max_speed", 175);
			}
			else if (player_entityscript["TickCount"] == 3)
			{
				Convars.SetValue("tongue_victim_acceleration", -80);
				Convars.SetValue("tongue_victim_max_speed", 80);
			}
			else if (player_entityscript["TickCount"] == 5)
			{
				Convars.SetValue("tongue_victim_acceleration", -40);
				Convars.SetValue("tongue_victim_max_speed", 40);
			}
			else if (player_entityscript["TickCount"] > 6)
			{
				Convars.SetValue("tongue_victim_acceleration", 0);
				Convars.SetValue("tongue_victim_max_speed", 0);
				return
			}
			player_entityscript["TickCount"]++;
			return
		}

		AddThinkToEnt(player, "TongueSpeedReset");
	}
}


///////////////////////////////////////////////
//                   BOOMER                  //
///////////////////////////////////////////////
function BoomerDeath(player)
{
	local boomerOrigin = player.GetOrigin();
	local retchName = player.GetName();

	if (corruptionRetch == "Retch")
	{
		DropSpit(boomerOrigin);
//		EntFire(retchName + "spitTrail", "Kill");
	}
	if (corruptionRetch == "Exploder")
	{
		BoomerExplosion(boomerOrigin, true);
	}

	NetProps.SetPropInt(player, "m_clrRender", GetColorInt(Vector(255, 255, 255)));
}

/*
function SpitterDeath(player)
{
	local spitterOrigin = player.GetOrigin();
	BoomerExplosion(spitterOrigin, false);

	//Explosion particle
	local randomNameID = RandomInt(0, 9999);
	local spitExplosion = SpawnEntityFromTable("info_particle_system",
	{
		targetname = "spitExplosionPart" + randomNameID,
		origin = Vector(spitterOrigin.x, spitterOrigin.y, spitterOrigin.z + 32),
		angles = Vector(0, 0, 0),
		effect_name = "boomer_explode",
		start_active = 1
	});

	EntFire("spitExplosionPart" + randomNameID, "Kill", null, 5);
}
*/

function ExploderAbility(player)
{
	if (corruptionRetch == "Exploder")
	{
		local exploderSpeed = Convars.GetFloat("z_exploding_speed");
		NetProps.SetPropFloat(player, "m_flLaggedMovementValue", (exploderRunSpeed / exploderSpeed));

		NetProps.SetPropInt(player, "m_clrRender", GetColorInt(Vector(255, 72, 72)));

		local explodeThinker = SpawnEntityFromTable("info_target", { targetname = "explodeThinker" });
		if (explodeThinker.ValidateScriptScope())
		{
			const RETHINK_TIME_EXPLODER = 0.5;
			local player_entityscript = explodeThinker.GetScriptScope();
			player_entityscript["player"] <- player;
			player_entityscript["damagePerTick"] <- (Convars.GetFloat("z_exploding_health") / boomerExplodeTime) * RETHINK_TIME_EXPLODER;
			player_entityscript["ExploderSelfDamage"] <- function()
			{
				if (player_entityscript["player"].IsValid())
				{
					if (player_entityscript["player"].GetHealth() > 1)
					{
						player_entityscript["player"].TakeDamage(player_entityscript["damagePerTick"], 0, null);
						return RETHINK_TIME_EXPLODER;
					}
					else
					{
						player_entityscript["player"].TakeDamage(player_entityscript["damagePerTick"], 0, null);
						self.Kill();
					}
				}
				else
				{
					self.Kill();
				}
			}

			AddThinkToEnt(explodeThinker, "ExploderSelfDamage");}
	}
}

function BoomerExplosion(boomerOrigin, isExploder)
{
	local survivor = null;
	local survivorOrigin = null;
	local distanceVector = null;
	local damage = null;

	while ((survivor = Entities.FindByClassnameWithin(survivor, "player", boomerOrigin, boomerExplosionRange)) != null)
	{
		if (survivor.IsSurvivor())
		{
			survivorOrigin = survivor.GetOrigin();

			local angle = GetVectorAngle(survivorOrigin, boomerOrigin);
			survivor.SetOrigin(Vector(survivorOrigin.x, survivorOrigin.y, survivorOrigin.z + 1));
			survivor.SetVelocity(Vector(sin(angle + 90) * boomerExplosionKnockback, sin(angle) * boomerExplosionKnockback, 300));

			// Explosion damage
			if (isExploder == true)
			{
				distanceVector = GetVectorDistance(survivorOrigin, boomerOrigin);
				damage = (1 - (distanceVector / boomerExplosionRange)) * boomerExplosionDamage;
				survivor.TakeDamage(damage, DMG_BLAST_SURFACE, null);
			}
		}
	}
}

///////////////////////////////////////////////
//                  SPITTER                  //
///////////////////////////////////////////////
function RetchVomitHit(params)
{
	if (corruptionRetch == "Retch")	
	{
		local player = GetPlayerFromUserID(params["userid"]);
		local origin = player.GetOrigin();

		if (player.IsSurvivor())
		{
			DropSpit(origin)
		}
	}
}

///////////////////////////////////////////////
//                  TALLBOY                  //
///////////////////////////////////////////////
function TallboySpawn(params)
{
	local item = params["item"];
	if (item == "charger_claw")
	{
		bChargerSpawned = true;
	}
}

function RemoveCharge()
{
	local charger_ability = null;
	while ((charger_ability = Entities.FindByClassname(charger_ability, "ability_charge")) != null)
	{
		NetProps.SetPropFloatArray(charger_ability, "m_nextActivationTimer", 99999, 0);
		NetProps.SetPropFloatArray(charger_ability, "m_nextActivationTimer", Time() + 99999, 1);
	}
	bChargerSpawned = false;
}

function TallboyKnockback(tallboy, survivor)
{
	local tallboyOrigin = tallboy.GetOrigin();
	local survivorOrigin = survivor.GetOrigin();

	local angle = GetVectorAngle(survivorOrigin, tallboyOrigin);
	survivor.SetOrigin(Vector(survivorOrigin.x, survivorOrigin.y, survivorOrigin.z + 1));
	survivor.SetVelocity(Vector(sin(angle + 90) * tallboyPunchKnockback, sin(angle) * tallboyPunchKnockback, 180));
}

///////////////////////////////////////////////
//               SNITCH HORDE                //
///////////////////////////////////////////////
function SnitchAlerted(params)
{
	local witch = params.witchid;
	local witchEnt = EntIndexToHScript(witch);

	if (params.first == 1)
	{
		SpawnMob(2);

		//Force witch to retreat
		//witchEnt.SetSequence(8)

		//Set witch on fire
		//witchEnt.TakeDamage(250, 8, null);
	}
}


///////////////////////////////////////////////
//                  SLEEPERS                 //
///////////////////////////////////////////////
function InitSleepers()
{
	local sleepersSpawned = 0;
	local sleepersToSpawn = null;
	local sleeperOrigin = null;
	local sleeperSpawnName = null;

	if (corruptionHazards == "hazardSleepers")
	{
		sleepersToSpawn = ceil(RandomInt(sleeperCountMin, sleeperCountMax) * hazardDifficultyScale * 2);
	}
	else
	{
		sleepersToSpawn = 0
	}

	while (sleepersSpawned < sleepersToSpawn)
	{
		sleeperOrigin = HazardGetRandomNavArea(hazardNavArray);
		sleeperSpawnName = "__sleeperspawn" + sleepersSpawned;

		local sleeperSpawn = SpawnEntityFromTable("info_zombie_spawn",
		{
			targetname = sleeperSpawnName,
			origin = sleeperOrigin,
			angles = Vector(0, RandomInt(0, 359), 0),
			population = "hunter"
		});
		local sleeperSpawnTrigger = SpawnEntityFromTable("trigger_once",
		{
			targetname = sleeperSpawnName + "_trigger",
			origin = sleeperOrigin,
			spawnflags = 1,
			filtername = "__swarm_filter_survivor"
		});

		// Set up trigger
		DoEntFire("!self", "AddOutput", "mins -2548 -2548 -512", 0, null, sleeperSpawnTrigger);
		DoEntFire("!self", "AddOutput", "maxs 2548 2548 512", 0, null, sleeperSpawnTrigger);
		DoEntFire("!self", "AddOutput", "solid 2", 0, null, sleeperSpawnTrigger);

		//Only spawn sleepers as you get close to keep infected limits under control
		EntFire(sleeperSpawnName + "_trigger", "AddOutput", "OnTrigger " + sleeperSpawnName + ":SpawnZombie::0:-1");

		sleepersSpawned++;
	}
}

function SleeperLunge(player)
{
	if (!IsSoundPrecached("player/jockey/voice/attack/jockey_loudattack01_wet.wav"))
		PrecacheSound("player/jockey/voice/attack/jockey_loudattack01_wet.wav");
	
	EmitSoundOn("JockeyZombie.Pounce", player);

	local sleeperThinker = SpawnEntityFromTable("info_target", { targetname = "sleeperThinker" });
	if (sleeperThinker.ValidateScriptScope())
	{
		const RETHINK_TIME_SLEEPER = 2;
		local player_entityscript = sleeperThinker.GetScriptScope();
		player_entityscript["player"] <- player;
		player_entityscript["thinkCount"] <- 0;
		player_entityscript["pounceVictim"] <- 0;
		player_entityscript["SleeperPounced"] <- function()
		{
			if (player_entityscript["thinkCount"] != 0)
			{
				if (player_entityscript["player"].IsValid())
				{
					player_entityscript["pounceVictim"] = NetProps.GetPropInt(player_entityscript["player"], "m_pounceVictim");
					if (player_entityscript["pounceVictim"] == -1)
					{
						player_entityscript["player"].TakeDamage(250, 2097152, null);
						self.Kill();
					}
				}
				else
				{
					self.Kill();
				}
			}

			player_entityscript["thinkCount"]++
			return RETHINK_TIME_SLEEPER;
		}

		AddThinkToEnt(sleeperThinker, "SleeperPounced");
	}
}

function SleeperLanded(params)
{
	local player = GetPlayerFromUserID(params.userid);
	local sleeperLandedThinker = SpawnEntityFromTable("info_target", { targetname = "sleeperLandedThinker" });
	if (sleeperLandedThinker.ValidateScriptScope())
	{
		const RETHINK_TIME_SLEEPER_LANDED = 0.75;
		local player_entityscript = sleeperLandedThinker.GetScriptScope();
		player_entityscript["player"] <- player;
		player_entityscript["thinkCount"] <- 0;
		player_entityscript["SleeperLanded"] <- function()
		{
			if (player_entityscript["thinkCount"] != 0)
			{
				if (player_entityscript["player"].IsValid())
				{
					if (player_entityscript["player"].GetHealth() > 1)
					{
						ZSpawnMob();
						self.Kill();
					}
				}
				else
				{
					self.Kill();
				}
			}

			player_entityscript["thinkCount"]++
			return RETHINK_TIME_SLEEPER_LANDED;
		}

		AddThinkToEnt(sleeperLandedThinker, "SleeperLanded");
	}
}

function SleeperShoved(params)
{
	//Kill sleeper on shove
	local hunter = GetPlayerFromUserID(params.userid);
	local survivor = GetPlayerFromUserID(params.attacker);
	if (hunter.GetZombieType() == 3)
	{
		hunter.TakeDamage(250, 2097152, survivor);
	}
}