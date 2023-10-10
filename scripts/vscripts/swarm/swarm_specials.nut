///////////////////////////////////////////////
//          PROPERTY / MODEL CHANGES         //
///////////////////////////////////////////////
function MutationSpawn(player)
{
	if (!IsModelPrecached("models/infected/limbs/exploded_boomette.mdl"));
		PrecacheModel("models/infected/limbs/exploded_boomette.mdl");

	//Smoker = 1, Boomer = 2, Hunter = 3, Spitter = 4, Jockey = 5, Charger = 6, Witch = 7, Tank = 8, Survivor = 9
	switch(player.GetZombieType())
	{
		case 1:
			if (specialHockerType == "Hocker")
			{
				PrecacheAndSetModel(player, "models/infected/smoker.mdl");
			}
			else if (specialHockerType == "Stinger")
			{
				PrecacheAndSetModel(player, "models/infected/smoker_l4d1.mdl");
			}

			DirectorOptions.SmokerLimit = RandomInt(1,3);
		break;

		case 2:
			if (specialRetchType == "Exploder")
			{
				PrecacheAndSetModel(player, "models/swarm/infected/boomer.mdl");
			}
			else if (specialRetchType == "Retch")
			{
				PrecacheAndSetModel(player, "models/swarm/infected/boomette.mdl");
			}
			else if (specialRetchType == "Reeker")
			{
				PrecacheAndSetModel(player, "models/swarm/infected/boomer_l4d1.mdl");
			}

			DirectorOptions.BoomerLimit = RandomInt(1,3);
		break;

		case 3:
			//Make regular hunters always use L4D2 model so we can change texture
			PrecacheAndSetModel(player, "models/swarm/infected/hunter.mdl");
			NetProps.SetPropInt(player, "m_fFlags", NetProps.GetPropInt(player, "m_fFlags") | (1 << 6)) //FL_ATCONTROLS	- Player can't move, but keeps key inputs for controlling another entity
		break;

		case 5:
			player.SetModelScale(1.25, 0.0);
			DirectorOptions.JockeyLimit = RandomInt(1,3);
		break;

		case 6:
			if (specialTallboyType == "Tallboy")
			{
				PrecacheAndSetModel(player, "models/swarm/infected/charger.mdl");
			}
			else if (specialTallboyType == "Bruiser")
			{
				PrecacheAndSetModel(player, "models/swarm/infected/bruiser.mdl");
			}

			z_speed = Convars.GetFloat("z_speed");
			NetProps.SetPropFloat(player, "m_flLaggedMovementValue", (tallboyRunSpeed / z_speed));
			DirectorOptions.ChargerLimit = RandomInt(1,3);
		break;

		case 8:
			PrecacheAndSetModel(player, tankModel);
		break;
	}
}


///////////////////////////////////////////////
//                  HOCKER                   //
///////////////////////////////////////////////
function TongueGrab(params)
{
	if (specialHockerType == "Hocker")
	{
		local attacker = GetPlayerFromUserID(params["userid"]);
		local victim = GetPlayerFromUserID(params["victim"]);

		// Make victim move backwards
		Convars.SetValue("tongue_force_break", 0);
		Convars.SetValue("tongue_victim_acceleration", -450);
		Convars.SetValue("tongue_victim_max_speed", 450);
		NetProps.SetPropInt(attacker, "m_tongueVictim", 0);

		if (attacker.ValidateScriptScope())
		{
			local hocker_entityscript = attacker.GetScriptScope();
			hocker_entityscript["TickCount"] <- 0;
			hocker_entityscript["TongueSpeedReset"] <- function()
			{
				// Decelerate victim at specific ticks
				if (hocker_entityscript["TickCount"] == 1)
				{
					Convars.SetValue("tongue_force_break", 0);
					Convars.SetValue("tongue_victim_acceleration", -175);
					Convars.SetValue("tongue_victim_max_speed", 175);
				}
				else if (hocker_entityscript["TickCount"] == 3)
				{
					Convars.SetValue("tongue_victim_acceleration", -80);
					Convars.SetValue("tongue_victim_max_speed", 80);
				}
				else if (hocker_entityscript["TickCount"] == 5)
				{
					Convars.SetValue("tongue_victim_acceleration", -40);
					Convars.SetValue("tongue_victim_max_speed", 40);
				}
				else if (hocker_entityscript["TickCount"] == 6)
				{
					Convars.SetValue("tongue_victim_acceleration", 0);
					Convars.SetValue("tongue_victim_max_speed", 0);
				}
				else if (hocker_entityscript["TickCount"] > 36)
				{
					NetProps.SetPropInt(victim, "m_tongueOwner", 0);
					return
				}
				hocker_entityscript["TickCount"]++;
				return
			}

			AddThinkToEnt(attacker, "TongueSpeedReset");
		}

		local hockerThinker = SpawnEntityFromTable("info_target", { targetname = "hockerThinker" });
		if (hockerThinker.ValidateScriptScope())
		{
			const RETHINK_TIME_HOCKER = 1;
			local victim_entityscript = hockerThinker.GetScriptScope();
			victim_entityscript["victim"] <- victim;
			victim_entityscript["tongueVictim"] <- 0;
			victim_entityscript["damagePerTick"] <- 8 * RETHINK_TIME_HOCKER;
			victim_entityscript["HockerSelfDamage"] <- function()
			{
				if (victim_entityscript["victim"].IsValid())
				{
					victim_entityscript["tongueVictim"] = NetProps.GetPropInt(victim_entityscript["victim"], "m_tongueOwner");
					if (victim_entityscript["tongueVictim"] != 0)
					{
						victim_entityscript["victim"].TakeDamage(victim_entityscript["damagePerTick"], DMG_CLUB, attacker);
						return RETHINK_TIME_HOCKER;
					}
					else
					{
						self.Kill();
					}
				}
			}

			AddThinkToEnt(hockerThinker, "HockerSelfDamage");
		}
	}	
}

function VictimShoved(params)
{
	//Free survivor on shove
	local victim = GetPlayerFromUserID(params.userid);
	local savior = GetPlayerFromUserID(params.attacker);
	if (victim.GetZombieType() == 9)
	{
		NetProps.SetPropInt(victim, "m_tongueOwner", 0);
	}
}

function StingerProjectile(params)
{
	if (specialHockerType == "Stinger")
	{
		local player = GetPlayerFromUserID(params["victim"]);
		local attacker = GetPlayerFromUserID(params["userid"]);

		// DMG victim
		player.TakeDamage(8, DMG_CLUB, attacker)
		player.OverrideFriction(0.5,1.35);
		
		// Break Tongue
		Convars.SetValue("tongue_force_break", 1);

		if (attacker.ValidateScriptScope())
		{
			local stinger_entityscript = attacker.GetScriptScope();
			stinger_entityscript["TickCount"] <- 0;
			stinger_entityscript["TongueKill"] <- function()
			{
				if (stinger_entityscript["TickCount"] > 1)
				{
					Convars.SetValue("tongue_force_break", 1);
					return
				}
				stinger_entityscript["TickCount"]++;
				return
			}
			AddThinkToEnt(attacker, "TongueKill");
		}
	}
}


///////////////////////////////////////////////
//                   BOOMER                  //
///////////////////////////////////////////////
function BoomerDeath(player)
{
	local boomerOrigin = player.GetOrigin();
	local retchName = player.GetName();

	if (specialRetchType == "Retch")
	{
		DropSpit(boomerOrigin);
	}
	if (specialRetchType == "Exploder")
	{
		BoomerExplosion(boomerOrigin, true, player);
	}

	NetProps.SetPropInt(player, "m_clrRender", GetColorInt(Vector(255, 255, 255)));
}

function ExploderAbility(player)
{
	if (specialRetchType == "Exploder")
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
						player_entityscript["player"].TakeDamage(player_entityscript["damagePerTick"], 0, player);
						return RETHINK_TIME_EXPLODER;
					}
					else
					{
						player_entityscript["player"].TakeDamage(player_entityscript["damagePerTick"], 0, player);
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

function BoomerExplosion(boomerOrigin, isExploder, exploder)
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

			if (CheckLOS(Vector(boomerOrigin.x,boomerOrigin.y,boomerOrigin.z+48), Vector(survivorOrigin.x,survivorOrigin.y,survivorOrigin.z+48), exploder) == survivor)
			{
				local angle = GetVectorAngle(survivorOrigin, boomerOrigin);
				survivor.SetOrigin(Vector(survivorOrigin.x, survivorOrigin.y, survivorOrigin.z + 1));
				survivor.SetVelocity(Vector(sin(angle + 90) * boomerExplosionKnockback, sin(angle) * boomerExplosionKnockback, 300));

				// Explosion damage
				if (isExploder == true)
				{
					distanceVector = GetVectorDistance(survivorOrigin, boomerOrigin);
					damage = (1 - (distanceVector / boomerExplosionRange)) * boomerExplosionDamage;
					survivor.TakeDamage(damage, DMG_BLAST_SURFACE, exploder);
				}
			}
		}
	}
}

///////////////////////////////////////////////
//                   RETCH                   //
///////////////////////////////////////////////
function RetchVomitHit(params)
{
	if (specialRetchType == "Retch")	
	{
		local player = GetPlayerFromUserID(params["userid"]);
		local origin = player.GetOrigin();

		if (player.IsSurvivor())
		{
			DropSpit(origin);
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

function BruiserKnockback(bruiser)
{
	if (specialTallboyType == "Bruiser")
	{
		local survivor = null;
		local tallboyOrigin = bruiser.GetOrigin();

		bruiser.Stagger(Vector(0, 0, 0));
		while ((survivor = Entities.FindByClassnameWithin(survivor, "bruiser", tallboyOrigin, 224)) != null)
		{
			if (survivor.IsSurvivor())
			{
				local survivorOrigin = survivor.GetOrigin();
				local angle = GetVectorAngle(survivorOrigin, tallboyOrigin);

				survivor.TakeDamage(12.5, DMG_CLUB, bruiser)
				survivor.SetOrigin(Vector(survivorOrigin.x, survivorOrigin.y, survivorOrigin.z + 1));
				survivor.SetVelocity(Vector(sin(angle + 90) * tallboyPunchKnockback, sin(angle) * tallboyPunchKnockback, 180));
			}
		}
	}
}

function CrusherGrab(tallboy, survivor)
{
	if (survivor.IsDominatedBySpecialInfected() == false)
	{
		local charger_ability = NetProps.GetPropEntity(tallboy,"m_customAbility")

		NetProps.SetPropEntity(charger_ability, "m_hPotentialTarget", survivor)
		NetProps.SetPropEntity(tallboy, "m_pummelVictim", survivor);
		NetProps.SetPropEntity(survivor, "m_pummelAttacker", tallboy);
		NetProps.SetPropEntityArray(charger_ability, "m_nextActivationTimer", 6, 0);
		NetProps.SetPropEntityArray(charger_ability, "m_nextActivationTimer", Time() + 6, 1);
	}
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
		SpawnMob();
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