///////////////////////////////////////////////
//                  SETTINGS                 //
///////////////////////////////////////////////
function BossSettings_Breaker()
{
	tankModel = "models/infected/hulk.mdl";
	bossType = "Breaker";
	Convars.SetValue("z_tank_health", 7500);
	Convars.SetValue("z_tank_speed", 190);
	Convars.SetValue("z_tank_speed_vs", 190);
	Convars.SetValue("z_tank_throw_interval", 16);
	Convars.SetValue("tank_throw_allow_range", 250);
}

function BossSettings_Ogre()
{
	tankModel = "models/infected/hulk_dlc3.mdl";
	bossType = "Ogre";
	Convars.SetValue("z_tank_health", 8000);
	Convars.SetValue("z_tank_speed", 200);
	Convars.SetValue("z_tank_speed_vs", 200);
	Convars.SetValue("z_tank_throw_interval", 8);
	Convars.SetValue("tank_throw_allow_range", 125);
}

function TankSpawn(params)
{
	if (tankHudTanks[0] == null)
	{
		tankHudTanks[0] = GetPlayerFromUserID(params["userid"]);
		if (!bTankHudExists)
		{
			CreateTankHealthHud();
		}
	}
	else if (tankHudTanks[1] == null)
	{
		tankHudTanks[1] = GetPlayerFromUserID(params["userid"]);
		if (!bTankHudExists)
		{
			CreateTankHealthHud();
		}
	}

	if (corruptionBoss == "bossOgreMon")
	{
		bOgreAggro = false;
	}
}

///////////////////////////////////////////////
//               SWARM CIRCLE                //
///////////////////////////////////////////////
function TankDeath(player)
{
	KillSwarmCircle();
	DestroyTankHud(player);
}

function TankKicked(params)
{
	// Called when a tank is kicked
	if (!Director.IsTankInPlay())
	{
		// Player is a disconnecting bot tank
		if (params.team == 0 && params.disconnect && params.isbot && GetPlayerFromUserID(params.userid).GetZombieType() == 8)
		{
			KillSwarmCircle();
			DestroyTankHud(params.userid);
		}
	}
}

function CreateSwarmCircle(tankID)
{
	if (!IsModelPrecached("models/swarm/props/swarmcircle.mdl"))
		PrecacheModel("models/swarm/props/swarmcircle.mdl");

	if (!bSwarmCircleActive)
	{
		local tankOrigin = tankID.GetOrigin();
		local survivor = null;
		local playerOrigin = null;
		local vectorDistance = null;
		local closestDistance = null;

		// Find closest player to tank
		while ((survivor = Entities.FindByClassname(survivor, "player")) != null)
		{
			if (ValidAliveSurvivor(survivor))
			{
				playerOrigin = survivor.GetOrigin();
				vectorDistance = GetVectorDistance(playerOrigin, tankOrigin);

				if (vectorDistance < closestDistance || closestDistance == null)
				{
					closestDistance = vectorDistance;
					swarmOrigin = playerOrigin;
				}
			}
		}

		if (swarmOrigin != null)
		{
			// Spawn the swarm circle on the closest player
			local swarm_circle = SpawnEntityFromTable("prop_dynamic",
			{
				targetname = "swarm_circle",
				origin = Vector(swarmOrigin.x, swarmOrigin.y, swarmOrigin.z),
				angles = Vector(0, 0, 0),
				model = "models/swarm/props/swarmcircle.mdl",
				solid = 0,
				disableshadows = 1
			});

			if (corruptionBoss == "bossBreakerMon")
			{
				SpawnMob(1, 10, false);
			}

			bSwarmCircleActive = true;
		}
	}
}

function KillSwarmCircle()
{
	if (bSwarmCircleActive)
	{
		EntFire("swarm_circle", "Kill");
	}
	bSwarmCircleActive = false;
}

function SwarmCircleApplyDamage()
{
	if ((Time() - swarmTickTime) >= swarmTickInterval || swarmTickTime == 0)
	{
		if (swarmOrigin != null)
		{
			local survivor = null;
			//local safeSurvivors = array(4, null);
			safeSurvivors.clear();

			// Track all survivors inside the circle
			while ((survivor = Entities.FindByClassnameWithin(survivor, "player", swarmOrigin, 748)) != null)
			{
				if (survivor.IsSurvivor())
				{
					safeSurvivors.append(survivor);
				}
			}

			// Hurt any survivors not found within the circle
			local allSurvivors = null;

			while ((allSurvivors = Entities.FindByClassname(allSurvivors, "player")) != null)
			{
				if (allSurvivors.IsSurvivor())
				{
					if (!allSurvivors.IsDead())
					{
						if (safeSurvivors.find(allSurvivors) == null)
						{
							allSurvivors.TakeDamage(swarmDamagePerTick, 0, null);
							ScreenFade(allSurvivors, 255, 0, 0, 50, 0.5, 0, 1);
							EmitSoundOnClient("PlayerZombie.AttackHit", allSurvivors);
						}
					}
				}
			}
		}

		swarmTickTime = Time();
	}
}

///////////////////////////////////////////////
//               BREAKER JUMP                //
///////////////////////////////////////////////
if (!IsSoundPrecached("player/tank/voice/pain/tank_fire_06.wav"))
	PrecacheSound("player/tank/voice/pain/tank_fire_06.wav");

function BreakerJump(player)
{
	if (bossType == "Breaker")
	{
		//Apply the jump
		local eyeAngles = player.EyeAngles();
		local verticalVelocity = sin(DegToRad(Clamp(eyeAngles.x, 0) * -1)) * tankJumpExtraHeight;
		local verticalOffset = (1.15 - (verticalVelocity / tankJumpExtraHeight))

		player.SetVelocity(Vector(
			(tankJumpVelocity * sin(DegToRad(eyeAngles.y + 90))) * verticalOffset,
			(tankJumpVelocity * sin(DegToRad(eyeAngles.y))) * verticalOffset,
			300 + verticalVelocity));

		//Stagger to stop the rock
		local staggerDuration = Convars.GetFloat("z_max_stagger_duration");
		Convars.SetValue("z_max_stagger_duration", 1);
		player.Stagger(Vector(0, 0, 0));
		Convars.SetValue("z_max_stagger_duration", staggerDuration);

		if (!bSwarmCircleActive)
		{
			EmitSoundOn("player/tank/voice/pain/tank_fire_06.wav", player)
		}

		CreateSwarmCircle(player);
	}
}

function CancelRockAnimation()
{
	local tank = null;
	while ((tank = Entities.FindByClassname(tank, "player")) != null)
	{
		if (tank.GetZombieType() == 8)
		{
			local sequence = tank.GetSequence();
			if (tank.GetSequenceName(sequence).find("Throw") != null)
			{
				// Changing the model resets all animations cleanly
				local tankModel = tank.GetModelName();
				PrecacheAndSetModel(tank, "models/infected/hunter.mdl");
				PrecacheAndSetModel(tank, tankModel);
			}
		}
	}
}

function difficulty_RandomBoss()
{
	//Only spawn random bosses above Normal
	if (difficulty > 1)
	{
		local progressPct = (Director.GetFurthestSurvivorFlow() / GetMaxFlowDistance())
		
		//No boss card played, set tank to be Breaker or Ogre randomly
		if (corruptionBoss == "None")
		{
			if (randomPct < 50)
			{
				BossSettings_Breaker();
			}
			else
			{
				BossSettings_Ogre();
			}
		}
		if (progressPct > spawnRngBoss && !bBossSpawned)
		{
			BossSpawn();
			bBossSpawned = true;
		}
	}
}

function SpawnBoss()
{
	local progressPct = (Director.GetFurthestSurvivorFlow() / GetMaxFlowDistance())
	    
	if (progressPct > spawnSnitch && !bSnitchSpawned && corruptionHazards == "hazardSnitch")
	{
		SnitchSpawn();
		bSnitchSpawned = true;
	}
	if (progressPct > spawnBoss && !bBreakerSpawned && bossType == "Breaker")
	{
		BossSpawn();
		bBreakerSpawned = true;
	}
	if (progressPct > spawnBoss && !bOgreSpawned && bossType == "Ogre")
	{
		BossSpawn();
		bOgreSpawned = true;
	}

	if (corruptionBoss == "bossOgreMon")
	{
		if (!bOgreAggro)
		{
			bOgreAggro = Director.IsTankInPlay();
			if (bOgreAggro)
			{
				SpawnMob(1, 10, false);
			}
		}
	}
}

function BossSpawn(count = 1, zType = 8)
{
	local i = 0;
	while (i < count)
	{
		ZSpawn({type = zType});
		i++;
	}
}
