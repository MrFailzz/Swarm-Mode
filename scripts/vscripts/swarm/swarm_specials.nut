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

			MutationOptions.SmokerLimit = RandomInt(1,3);
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

			MutationOptions.BoomerLimit = RandomInt(1,3);
		break;

		case 3:
			//Make regular hunters always use L4D2 model so we can change texture
			PrecacheAndSetModel(player, "models/swarm/infected/hunter.mdl");
			NetProps.SetPropInt(player, "m_fFlags", NetProps.GetPropInt(player, "m_fFlags") | (1 << 6)) //FL_ATCONTROLS	- Player can't move, but keeps key inputs for controlling another entity
		break;

		case 5:
			player.SetModelScale(1.25, 0.0);
			MutationOptions.JockeyLimit = RandomInt(1,3);
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
			MutationOptions.ChargerLimit = RandomInt(1,3);
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
		victim.TakeDamage((8 * HockerDmgMulti * difficulty_SpecialDmgMulti), 128, attacker)

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
		player.TakeDamage((6 * HockerDmgMulti * difficulty_SpecialDmgMulti), 128, attacker)
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

function StalkerGrab(params)
{
	local player = GetPlayerFromUserID(params["victim"]);
	local attacker = GetPlayerFromUserID(params["userid"]);

	player.TakeDamage((15 * HockerDmgMulti * difficulty_SpecialDmgMulti), 128, attacker)
}

///////////////////////////////////////////////
//                   RETCH                   //
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
				if (isExploder)
				{
					distanceVector = GetVectorDistance(survivorOrigin, boomerOrigin);
					damage = (1 - (distanceVector / boomerExplosionRange)) * boomerExplosionDamage;
					survivor.TakeDamage(damage, DMG_BLAST_SURFACE, exploder);
					
					if (bMonRetch)
					{
						survivor.OverrideFriction(0.5,1.5);
					}
				}
			}
		}
	}
}

function RetchVomitHit(params)
{
	local player = GetPlayerFromUserID(params["userid"]);
	local origin = player.GetOrigin();

	if (player.IsSurvivor())
	{
		if (specialRetchType == "Retch")
		{
			DropSpit(origin);
		}

		player.OverrideFriction(0.5,1.5);
	}
}

///////////////////////////////////////////////
//                  TALLBOY                  //
///////////////////////////////////////////////
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
		local bruiserOrigin = bruiser.GetOrigin();

		while ((survivor = Entities.FindByClassnameWithin(survivor, "player", bruiserOrigin, 150)) != null)
		{
			if (survivor.IsSurvivor())
			{
				local survivorOrigin = survivor.GetOrigin();
				local angle = GetVectorAngle(survivorOrigin, bruiserOrigin);

				survivor.TakeDamage((12.5 * TallboyDmgMulti * difficulty_SpecialDmgMulti), 128, bruiser)
				survivor.SetOrigin(Vector(survivorOrigin.x, survivorOrigin.y, survivorOrigin.z + 1));
				survivor.SetVelocity(Vector(sin(angle + 90) * tallboyPunchKnockback, sin(angle) * tallboyPunchKnockback, 180));
			}
		}
	}
}

function CrusherGrab(tallboy, survivor)
{
	if (!survivor.IsDominatedBySpecialInfected())
	{
		local charger_ability = NetProps.GetPropEntity(tallboy,"m_customAbility")

		NetProps.SetPropEntity(charger_ability, "m_hPotentialTarget", survivor)
		NetProps.SetPropEntity(tallboy, "m_pummelVictim", tallboy);
		NetProps.SetPropEntity(survivor, "m_pummelAttacker", survivor);
		NetProps.SetPropEntityArray(charger_ability, "m_nextActivationTimer", 6, 0);
		NetProps.SetPropEntityArray(charger_ability, "m_nextActivationTimer", Time() + 6, 1);
	}
}