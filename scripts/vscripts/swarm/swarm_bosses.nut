///////////////////////////////////////////////
//                  SETTINGS                 //
///////////////////////////////////////////////
function BossSettings_Breaker()
{
	tankModel = "models/infected/hulk.mdl"
	bossBreakerEnable = true;
	Convars.SetValue("z_tank_health", 8000);
	Convars.SetValue("z_tank_speed", 190);
	Convars.SetValue("z_tank_speed_vs", 190);
	Convars.SetValue("z_tank_throw_interval", 18);
	Convars.SetValue("tank_throw_allow_range", 250);
}

function BossSettings_Ogre()
{
	tankModel = "models/infected/hulk_dlc3.mdl"
	bossOgreEnable = true;
	Convars.SetValue("z_tank_health", 9000);
	Convars.SetValue("z_tank_speed", 200);
	Convars.SetValue("z_tank_speed_vs", 200);
	Convars.SetValue("z_tank_throw_interval", 8);
	Convars.SetValue("tank_throw_allow_range", 125);
}

///////////////////////////////////////////////
//               SWARM CIRCLE                //
///////////////////////////////////////////////
function TankDeath()
{
	KillSwarmCircle();
	DestroyTankHud();
}

function TankKicked(params)
{
	// Called when a tank is kicked
	if (Director.IsTankInPlay() == false)
	{
		// Player is a disconnecting bot tank
		if (params.team == 0 && params.disconnect && params.isbot && GetPlayerFromUserID(params.userid).GetZombieType() == 8)
		{
			KillSwarmCircle();
			DestroyTankHud();
		}
	}
}

function CreateSwarmCircle(tankID)
{
	if (!IsModelPrecached("models/swarm/props/swarmcircle.mdl"))
		PrecacheModel("models/swarm/props/swarmcircle.mdl");

	if (bSwarmCircleActive == false)
	{
		local tankOrigin = tankID.GetOrigin();
		local survivor = null;
		local playerOrigin = null;
		local vectorDistance = null;
		local closestDistance = null;

		// Find closest player to tank
		while ((survivor = Entities.FindByClassname(survivor, "player")) != null)
		{
			if (survivor.IsSurvivor() && !survivor.IsDead() && !survivor.IsIncapacitated() && !survivor.IsHangingFromLedge())
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

			if (corruptionHordes == "hordeDuringBoss")
			{
				SpawnMob(2);
			}

			bSwarmCircleActive = true;
		}
	}
}

function KillSwarmCircle()
{
	if (bSwarmCircleActive == true)
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
					if (allSurvivors.IsDead() == false)
					{
						if (safeSurvivors.find(allSurvivors) == null)
						{
							allSurvivors.TakeDamage(swarmDamagePerTick, 0, null);
							ScreenFade(allSurvivors, 255, 50, 0, 50, 0.5, 0, 1);
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
	if (bossBreakerEnable == true)
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
		printl(staggerDuration)
		Convars.SetValue("z_max_stagger_duration", 1);
		player.Stagger(Vector(0, 0, 0));
		Convars.SetValue("z_max_stagger_duration", staggerDuration);

		if (bSwarmCircleActive == false)
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
				// Changing the model resets all animations
				local tankModel = tank.GetModelName();
				if (!IsModelPrecached(tankModel))
				{
					PrecacheModel(tankModel);
				}
				if (!IsModelPrecached("models/infected/hunter.mdl"))
				{
					PrecacheModel("models/infected/hunter.mdl");
				}
				tank.SetModel("models/infected/hunter.mdl");
				tank.SetModel(tankModel);
			}
		}
	}
}

///////////////////////////////////////////////
//                HEALTH HUD                 //
///////////////////////////////////////////////
function TankSpawn(params)
{
	if (!bTankHudExists)
	{
		tankHudTankID = GetPlayerFromUserID(params["userid"]);
		CreateTankHealthHud();
	}
/*
	if (corruptionBoss == "hazardOgre")
	{
		local tankName = GetPlayerFromUserID(params["userid"]);
		local tankDmgTrigger = SpawnEntityFromTable("trigger_hurt",
		{
			targetname = tankName + "_dmgtrigger",
			origin = tankName.GetOrigin(),
			damagetype = 0,
			damage = 5,
			spawnflags = 1,
			filtername = "__swarm_filter_survivor"
		});

		EntFire(tankName + "_dmgtrigger", "SetParent", tankName);
		DoEntFire(tankName + "_dmgtrigger", "AddOutput", "mins -44 -44 -44", 0, null, tankDmgTrigger);
		DoEntFire(tankName + "_dmgtrigger", "AddOutput", "maxs 44 44 44", 0, null, tankDmgTrigger);
		DoEntFire(tankName + "_dmgtrigger", "AddOutput", "solid 2", 0, null, tankDmgTrigger);
	}
*/
}

function CreateTankHealthHud(startStr = "FROM THE CREATORS OF BACK 4 BLOOD")
{
   Ticker_AddToHud(swarmHUD, startStr)
   HUDSetLayout(swarmHUD)
   HUDPlace(HUD_TICKER, 0.25, 0.05, 0.5, 0.04)

   bTankHudExists = true;
}

function CalculateTankHudString()
{
	if (tankHudTankID == null || bTankHudExists == false)
	{
		Ticker_NewStr("");
	}
	else
	{
		local healthCur = tankHudTankID.GetHealth();
		local healthMax = tankHudTankID.GetMaxHealth();
		local maxBlocks = 40;
		local healthPerBlock = healthMax / maxBlocks;
		local fullBlocks = ceil(healthCur / healthPerBlock); //ceil is bugged lol?
		local emptyBlocks = maxBlocks - fullBlocks;
		local hudString = "";

		local i = 0;
		for (i = 0; i < fullBlocks; i++)
		{
			hudString = hudString + "■";
		}
		for (i = 0; i < emptyBlocks; i++)
		{
			hudString = hudString + "□";
		}
		Ticker_NewStr(hudString);
	}
}

function DestroyTankHud()
{
	if (bTankHudExists == true)
	{
		bTankHudExists = false;
		tankHudTankID = null;
		Ticker_Hide();
	}
}