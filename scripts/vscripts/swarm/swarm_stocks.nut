///////////////////////////////////////////////
//               SHARED EVENTS               //
///////////////////////////////////////////////
function PlayerSpawn(params)
{
	local player = GetPlayerFromUserID(params["userid"]);
	if (!player)
	{
		return;
	}

	//Reset scale as it stays with the player entity, becoming a jockey messes any other model the player uses
	player.SetModelScale(1, 0.0);

	if (player.IsSurvivor())
	{
		SurvivorSpawn(player);
	}
	else
	{
		MutationSpawn(player);
		if (corruptionEnvironmental == "environmentSwarmStream" && RandomInt(0, 3) == 0)
		{
			if (player.GetZombieType() != 8 && player.GetZombieType() != 7 && player.GetZombieType() != 3)
			{
				CorruptionCard_SwarmStreamGlow(player);
			}
		}
	}
}

function PlayerDeath(params)
{
	local player = null;
	local isSurvivorDeath = false;

	if ("userid" in params)
	{
		player = GetPlayerFromUserID(params["userid"]);
		if (player.IsSurvivor())
		{
			isSurvivorDeath = true;
		}
	}

	if (params.victimname == "Tank")
	{
		TankDeath();
	}
	else if (params.victimname == "Boomer")
	{
		BoomerDeath(GetPlayerFromUserID(params["userid"]));
	}

	if (params.victimname == "Tank" || params.victimname == "Smoker" || params.victimname == "Jockey" || params.victimname == "Boomer" || params.victimname == "Charger")
	{
		//Remove swarm stream glow
		local playerIndex = player.GetEntityIndex();
		EntFire("__swarm_stream_lightglow" + playerIndex, "Kill");

		//FaceYourFears
		local player = GetPlayerFromUserID(params["attacker"]);
		local victim = GetPlayerFromUserID(params["userid"]);
		local FaceYourFears = 0;
		if (GetVectorDistance(player.GetOrigin(), victim.GetOrigin()) < 100)
		{
			FaceYourFears = PlayerHasCard(player, "FaceYourFears");
			Heal_TempHealth(player, 2 * FaceYourFears);
		}

		//HotShot
		local survivor = null;
		local HotShot = 0;
		while ((survivor = Entities.FindByClassname(survivor, "player")) != null)
		{
			if (survivor.IsSurvivor())
			{
				HotShot = PlayerHasCard(survivor, "HotShot");
				if (RandomInt(1, 100) <= HotShot * 15)
				{
					//0 = UPGRADE_INCENDIARY_AMMO, 1 = UPGRADE_EXPLOSIVE_AMMO
					survivor.GiveUpgrade(RandomInt(0, 1));
				}
			}
		}

		//Piñata
		//local player = GetPlayerFromUserID(params["userid"]);
		local origin = player.GetOrigin();
		local Pinata = TeamHasCard("Pinata");

		if (RandomInt(1, 100) <= Pinata * 15)
		{
			RandomItemDrop(origin);
		}

		//ConfidentKiller
		ConfidentKillerCounter++;

		//MethHead
		if ("attacker" in params)
		{
			local attacker = GetPlayerFromUserID(params["attacker"]);
			if (attacker.IsValid())
			{
				if (attacker.IsPlayer())
				{
					if (attacker.IsSurvivor())
					{
						MethHeadCounter[GetSurvivorID(attacker)]++;
						CalcSpeedMultiplier(attacker);
					}
				}
			}
		}
	}

	//AdrenalineRush
	//InspiringSacrifice
	if (isSurvivorDeath)
	{
		ApplyAdrenalineRush();
		ApplyInspiringSacrifice();
	}

	NetProps.SetPropInt(player, "m_Glow.m_iGlowType", 0);
}

function RandomItemDrop(origin)
{
	local randomItem = RandomInt(1,100);
	local randomItemArray =
	[
		"weapon_molotov",
		"weapon_molotov",
		"weapon_molotov",
		"weapon_molotov",
		"weapon_pipe_bomb",
		"weapon_pipe_bomb",
		"weapon_pipe_bomb",
		"weapon_pipe_bomb",
		"weapon_vomitjar",
		"weapon_vomitjar",
		"weapon_pain_pills",
		"weapon_pain_pills",
		"weapon_pain_pills",
		"weapon_pain_pills",
		"weapon_adrenaline",
		"weapon_adrenaline",
		"weapon_adrenaline",
		"weapon_adrenaline",
		"weapon_first_aid_kit",
		"weapon_first_aid_kit",
		"weapon_defibrillator"
	];

	local randomItem = randomItemArray[RandomInt(0, randomItemArray.len() - 1)];

	switch(randomItem)
	{
		case "weapon_molotov":
			SpawnEntityFromTable("weapon_molotov",{origin = Vector(origin.x, origin.y, origin.z + 24),angles = Vector(0, 0, 0),model = "models/w_models/weapons/w_eq_molotov.mdl"});
		break;
		case "weapon_pipe_bomb":
			SpawnEntityFromTable("weapon_pipe_bomb",{origin = Vector(origin.x, origin.y, origin.z + 24),angles = Vector(0, 0, 0),model = "models/w_models/weapons/w_eq_pipebomb.mdl"});
		break;
		case "weapon_vomitjar":
			SpawnEntityFromTable("weapon_vomitjar",{origin = Vector(origin.x, origin.y, origin.z + 24),angles = Vector(0, 0, 0),model = "models/w_models/weapons/w_eq_bile_flask.mdl"});
		break;
		case "weapon_pain_pills":
			SpawnEntityFromTable("weapon_pain_pills",{origin = Vector(origin.x, origin.y, origin.z + 24),angles = Vector(0, 0, 0),model = "models/w_models/weapons/w_eq_painpills.mdl"});
		break;
		case "weapon_adrenaline":
			SpawnEntityFromTable("weapon_adrenaline",{origin = Vector(origin.x, origin.y, origin.z + 24),angles = Vector(0, 0, 0),model = "models/w_models/weapons/w_eq_adrenaline.mdl"});
		break;
		case "weapon_first_aid_kit":
			SpawnEntityFromTable("weapon_first_aid_kit",{origin = Vector(origin.x, origin.y, origin.z + 24),angles = Vector(0, 0, 0),model = "models/w_models/weapons/w_eq_Medkit.mdl"});
		break;
		case "weapon_defibrillator":
			SpawnEntityFromTable("weapon_defibrillator",{origin = Vector(origin.x, origin.y, origin.z + 24),angles = Vector(0, 0, 0),model = "models/w_models/weapons/w_eq_defibrillator.mdl"});
		break;
	}
}

function RoundStart(params)
{
	CreateCardHud();

	// Multiplier for speedrun objective based on map length. Must be before InitCorruption
	local flow = GetMaxFlowDistance();
	if (flow < 25000)
	{
		MissionSpeedrun_Multi = 1
	}
	else
	{
		MissionSpeedrun_Multi = 1.5
	}

	difficulty = GetDifficulty();
	InitCorruptionCards();
	SetDifficulty();
}

function PlayerLeftSafeArea(params)
{
	if (firstLeftCheckpoint == false)
	{
		local player = GetPlayerFromUserID(params["userid"]);

		if (player.IsSurvivor())
		{
			if (swarmMode == "hardcore")
			{
				// Print the number of continues left.
				ClientPrint(null, 3, "\x04" + "Continues: " + "\x01"+ (3 - Director.GetMissionWipes()));
			}

			if (PlayerHasCard(player, "Gambler") > 0)
			{
				PrintGamblerValue(player);
			}

			switch(corruptionHordes)
			{
				case "hordeHunted":
					HuntedEnabled = true;
					HuntedTimer = Time() + HuntedTimerDefault + 30;
					break;
				case "hordeOnslaught":
					OnslaughtEnabled = true;
					OnslaughtTimer = Time() + OnslaughtTimerDefault + 30;
					break;
				case "hordeTallboy":
				case "hordeCrusher":
				case "hordeBruiser":
				case "hordeHocker":
				case "hordeStinger":
				case "hordeStalker":
				case "hordeRetch":
				case "hordeExploder":
				case "hordeReeker":
					SpecialHordeTimer = Time() + SpecialHordeTimerDefault;
					break;
			}

			firstLeftCheckpoint = true;

			ModifyHittables();
			ApplyEnvironmentalCard();
			PropModels();

			//Spawn hazards
			if (corruptionHazards == "hazardLockdown")
			{
				InitAlarmDoors();
			}
			else if (corruptionHazards == "hazardBirds")
			{
				InitCrows();
			}
			else if (corruptionHazards == "hazardSleepers")
			{
				InitSleepers();
			}
		}
	}
}

function PlayerHurt(params)
{
	//Add FX when being hit by script spawned spit
	local player = GetPlayerFromUserID(params.userid);
	local attacker = GetPlayerFromUserID(params.attacker);

	if (player.IsValid())
	{
		//Survivor was hurt
		if (player.GetZombieType() == 9)
		{
			if ("type" in params)
			{
				if (params.type == 265216)
				{
					//Spit damage
					ScreenFade(player, 0, 200, 0, 50, 0.5, 0, 1);
					EmitSoundOnClient("PlayerZombie.AttackHit", player);
				}
				else if (params.type == 8)
				{
					//Fire damage
					ScreenFade(player, 255, 70, 0, 50, 0.5, 0, 1);
					EmitSoundOnClient("General.BurningObject", player);
				}
			}

			//Charger scratch
			if ("weapon" in params)
			{
				if (params.weapon == "charger_claw" && corruptionTallboy != "Crusher")
				{
					if ("attacker" in params)
					{
						local attacker = GetPlayerFromUserID(params.attacker);
						if (attacker.IsValid() && player != attacker)
						{
							TallboyKnockback(attacker, player);
						}
					}
				}
			}
		}
		//Tank was hurt
		if (player.GetZombieType() == 8)
		{
			if ("type" in params)
			{
				if (params.type == 2 && bossOgreEnable == true && params.health < stagger_dmg)
				{
					//Stagger tank
					player.Stagger(Vector(-1, -1, -1));
					stagger_dmg = stagger_dmg / 4;
				}
			}
		}
		if (!player.IsSurvivor() && player.IsOnFire())
		{
			player.Extinguish();
		}
	}
}

function CappedAlert()
{
	local player = null;
	while ((player = Entities.FindByClassname(player, "player")) != null)
	{
		if (player.IsSurvivor())
		{
			EmitSoundOnClient("Instructor.ImportantLessonStart", player);
		}
	}
}

function WeaponFireM60(params)
{
	local player = GetPlayerFromUserID(params.userid);
	if (player.IsValid())
	{
		if ("weapon" in params)
		{
			if (params.weapon == "rifle_m60")
			{
				local weaponEnt = player.GetActiveWeapon();
				if (weaponEnt.Clip1() <= 1)
				{
					weaponEnt.SetClip1(-1);
				}
			}
		}
	}
}

///////////////////////////////////////////////
//               STOCK FUNCTIONS             //
///////////////////////////////////////////////
function Update()
{
	Update_PlayerCards();

	if (bSwarmCircleActive)
	{
		SwarmCircleApplyDamage();
		CancelRockAnimation();
	}
	
	if (corruptionTallboy != "Crusher")
	{
		if (bChargerSpawned)
		{
			RemoveCharge();
		}
	}

	if (corruptionCommons != "None" || corruptionUncommons != "None")
	{
		BuildCommonList();
	}

	if (corruptionCommons != "None")
	{
		switch(corruptionCommons)
		{
			case "commonAcid":
				AcidCommonsCountdown();
				break;
			case "commonFire":
				FireCommonsCountdown();
				break;
			case "commonExplode":
				ExplodingCommonsFilters();
				ExplodingCommonsCountdown();
				break;
		}
	}

	Update_UncommonSpawnTimer();

	if (corruptionEnvironmental == "environmentFrozen")
	{
		FrigidOutskirtsTimer();
	}

	difficulty_RandomBoss();

	if (corruptionHazards == "hazardSnitch" || corruptionBoss == "hazardBreaker" || corruptionBoss == "hazardOgre" || corruptionBoss == "hazardBreakerRaging" || corruptionBoss == "hazardOgreRaging")
	{
		SpawnBoss();
	}

	if (corruptionHordes != "None")
	{
		switch(corruptionHordes)
		{
			case "hordeHunted":
				HuntedTimerFunc();
			break;

			case "hordeOnslaught":
				OnslaughtTimerFunc();
			break;

			case "hordeTallboy":
			case "hordeCrusher":
			case "hordeBruiser":
				SpecialTimerFunc(6);
			break;

			case "hordeStalker":
				SpecialTimerFunc(5);
			break;

			case "hordeHocker":
			case "hordeStinger":
				SpecialTimerFunc(1);
			break;

			case "hordeExploder":
			case "hordeRetch":
			case "hordeReeker":
				SpecialTimerFunc(2);
			break;
		}
	}

	if (bTankHudExists == true)
	{
		CalculateTankHudString();
	}

	if (firstLeftCheckpoint == true)
	{
		CardHudUpdate();
	}

	if (corruptionMission == "missionGnomeAlone")
	{
		if (MissionGnomeAlone_CalloutTimer > 0)
		{
			MissionGnomeAlone_CalloutTimer--;
		}
		else
		{
			MissionGnomeAlone_CalloutTimer = MissionGnomeAlone_CalloutTimerInterval
		}

		GetGnomeStatus();
	}

	if (AmpedUpCooldown > 0)
	{
		AmpedUpCooldown--;
	}

	if (cardReminderTimer > 0)
	{
		cardReminderTimer--;
	}
	else
	{
		local player = null;
		while ((player = Entities.FindByClassname(player, "player")) != null)
		{
			local survivorID = GetSurvivorID(player);

			if (player.IsSurvivor() && survivorID != -1)
			{
				if (cardPickingAllowed[survivorID] > 0)
				{
					ClientPrint(player, 3, "\x01" + "Use " + "\x03" + "!pick [A-H]\x01" + " to choose a card (" + "\x03" + cardPickingAllowed[survivorID] + " remaining" + "\x01" + ")");

					local voteCount = 0;
					foreach(vote in cardShuffleVote)
					{
						if (vote == true)
						{
							voteCount += 1;
						}
					}
					if (voteCount < 4)
					{
						ClientPrint(player, 3, "\x01" + "Use " + "\x03" + "!shuffle\x01" + " to vote for a new set of cards (" + "\x03" + voteCount + "/4" + "\x01" + " votes"  + ")");
					}
				}
			}
		}
		cardReminderTimer = cardReminderInterval;
	}

	//Remove critical particles
	EntFire("__critical_particle*", "Kill");
}

function SpawnMob(count = 1, zType = 10)
{
	//count = Number of groups to spawn
	//zType = Infected type to spawn, defaults to MOB if zType is not specified
	/*ZOMBIE_NORMAL = 0
	ZOMBIE_SMOKER = 1
	ZOMBIE_BOOMER = 2
	ZOMBIE_HUNTER = 3
	ZOMBIE_SPITTER = 4
	ZOMBIE_JOCKEY = 5
	ZOMBIE_CHARGER = 6
	ZOMBIE_WITCH = 7
	ZOMBIE_TANK = 8
	ZSPAWN_MOB = 10
	ZSPAWN_MUDMEN = 12
	ZSPAWN_WITCHBRIDE = 11*/

	local i = 0;
	while (i < count)
	{
		ZSpawn({type = zType, pos = Vector(0,0,0)});
		i++;
	}

	DelayHordeTimers();

	Heal_AmpedUp();
	Director.PlayMegaMobWarningSounds();
}
::ZSpawnMob <- SpawnMob;

function DelayHordeTimers()
{
	if (HuntedTimer != null)
	{
		HuntedTimer += 20;
	}
	if (OnslaughtTimer != null)
	{
		OnslaughtTimer += 20;
	}
	if (SpecialHordeTimer != null)
	{
		SpecialHordeTimer += 20;
	}
}
::DelayHordeTimers <- DelayHordeTimers;

function DegToRad(angle)
{
	return angle * (PI / 180);
}

function GetVectorDistance(vec1, vec2)
{
	return sqrt(pow(vec1.x - vec2.x,2) + pow(vec1.y - vec2.y,2) + pow(vec1.z - vec2.z,2));
}
::zGetVectorDistance <- GetVectorDistance;

function GetVectorAngle(vec1, vec2)
{
	return atan2(vec1.y - vec2.y, vec1.x - vec2.x);
}
::zGetVectorAngle <- GetVectorAngle;

function CheckLOS(vec1, vec2, originEntity)
{
	local traceTable =
	{
		start = vec1
		end = vec2
		mask = TRACE_MASK_VISION
		ignore = originEntity
	};

	if(TraceLine(traceTable))
	{
		if(traceTable.hit)
		{
			return traceTable.enthit;
		}
	}
}
::CheckLOS <- CheckLOS;
::TRACE_MASK_VISION <- TRACE_MASK_VISION;

function Clamp(angle, clampTo)
{
	if (angle > clampTo)
	{
		return clampTo;
	}
	else
	{
		return angle;
	}
}

function Sign(x)
{
	if (x >= 0)
	{
		return 1;
	}
	else
	{
		return -1;
	}
}

// From Rocketdude
function GetColorInt(col)
{
	if(typeof(col) == "Vector")
	{
		local color = col.x;
		color += 256 * col.y;
		color += 65536 * col.z;
		return color;
	}
	else if(typeof(col) == "string")
	{
		local colorArray = split(col, " ");
		local r = colorArray[0].tointeger();
		local g = colorArray[1].tointeger();
		local b = colorArray[2].tointeger();
		local color = r;
		color += 256 * g;
		color += 65536 * b;
		return color;
	}
}

function CreateSurvivorFilter()
{
	SpawnEntityFromTable("filter_activator_team",
	{
		targetname = "__swarm_filter_survivor",
		Negated = "Allow entities that match criteria",
		filterteam = 2
	});
}
CreateSurvivorFilter();

function CreateInfectedFilter()
{
	SpawnEntityFromTable("filter_activator_team",
	{
		targetname = "__swarm_filter_infected",
		Negated = "Allow entities that match criteria",
		filterteam = 3
	});
}
CreateInfectedFilter();

// From VSLib - Get rendercolor of a prop
/**
 * Gets a table of RGBA colors from 32 bit format to 8 bit.
 */
function GetColor32( color32 )
{
	local t = {};
	local readColor = color32;
	
	// Reads the 8 bit color values by rightshifting and masking the lowest byte out with bitwise AND.
	// The >>> makes it consider the input value unsigned.
	t.red <- (readColor & 0xFF);
	t.green <- ((readColor >>> 8) & 0xFF);
	t.blue <- ((readColor >>> 16) & 0xFF);
	t.alpha <- ((readColor >>> 24) & 0xFF);
	return t;
}

function IntToTime(integer)
{
	local minutes = floor(integer / 60);
	minutes = format("%02i", minutes);
	local seconds = integer % 60;
	seconds = format("%02i", seconds);
	return minutes + ":" + seconds;
}

function BarbedWire(params)
{
	if (!IsModelPrecached("models/props_fortifications/barricade_razorwire001_128_reference.mdl"))
		PrecacheModel("models/props_fortifications/barricade_razorwire001_128_reference.mdl");

	local ItemstoRemove_ModelPaths =
	[
		"models/props/terror/exploding_ammo.mdl",
	];

	// Remove ammo pack model
	foreach(modelpath in ItemstoRemove_ModelPaths)
	{
		local weapon_ent = null;
		while(weapon_ent = Entities.FindByModel(weapon_ent, modelpath))
		{
			weapon_ent.Kill();

			// Create barbed wire
			local player = GetPlayerFromUserID(params.userid);
			local wireX = player.GetOrigin().x;
			local wireY = player.GetOrigin().y;
			local wireZ = player.GetOrigin().z;
			local wireAngleX = player.GetAngles().x;
			local wireAngleY = player.GetAngles().y;
			local wireName = "wire";
			local wire = SpawnEntityFromTable("prop_dynamic",
			{
				targetname = wireName,
				origin = Vector(wireX, wireY, wireZ),
				angles = Vector(wireAngleX, wireAngleY, 0)
				model = "models/props_fortifications/barricade_razorwire001_128_reference.mdl",
				solid = 0,
				disableshadows = 1,
			});
			local wireDmgTrigger = SpawnEntityFromTable("trigger_hurt",
			{
				targetname = wireName + "_trigger",
				origin = Vector(wireX, wireY, wireZ),
				damagetype = 0,
				damage = 50,
				spawnflags = 3,
				filtername = "__swarm_filter_infected"
			});
			local wireSlowTrigger = SpawnEntityFromTable("trigger_playermovement",
			{
				targetname = wireName + "_trigger",
				origin = Vector(wireX, wireY, wireZ),
				StartDisabled = false,
				spawnflags = 4099,
				filtername = "__swarm_filter_infected"
			});

			// Set up trigger
			DoEntFire("!self", "AddOutput", "mins -44 -44 0", 0, null, wireDmgTrigger);
			DoEntFire("!self", "AddOutput", "maxs 44 44 24", 0, null, wireDmgTrigger);
			DoEntFire("!self", "AddOutput", "solid 2", 0, null, wireDmgTrigger);

			DoEntFire("!self", "AddOutput", "mins -44 -44 0", 0, null, wireSlowTrigger);
			DoEntFire("!self", "AddOutput", "maxs 44 44 24", 0, null, wireSlowTrigger);
			DoEntFire("!self", "AddOutput", "solid 2", 0, null, wireSlowTrigger);
		}
	}
}

function AmmoPack(params)
{
	local ItemstoRemove_ModelPaths =
	[
		"models/props/terror/incendiary_ammo.mdl"
	];

	// Remove ammo pack model
	foreach(modelpath in ItemstoRemove_ModelPaths)
	{
		local weapon_ent = null;
		while(weapon_ent = Entities.FindByModel(weapon_ent, modelpath))
            {
		    	weapon_ent.Kill();

				// Create ammo pile
                local player = GetPlayerFromUserID(params.userid);
		    	local ammoX = player.GetOrigin().x;
                local ammoY = player.GetOrigin().y;
	            local ammoZ = player.GetOrigin().z;
	            local ammoAngleX = player.GetAngles().x;
	            local ammoAngleY = player.GetAngles().y;
	            local ammoName = "ammoPile";
	            local ammoPile = SpawnEntityFromTable("weapon_ammo_spawn",
	            {
		            targetname = ammoName,
		            origin = Vector(ammoX, ammoY, ammoZ),
		            angles = Vector(ammoAngleX, ammoAngleY, 0)
		            model = "models/props/terror/ammo_stack.mdl",
		            solid = 0,
		            disableshadows = 1,
	            });
            }
	}
}

function PropModels()
{
	local expl_pack = null;
	local ince_pack = null;
	while (expl_pack = Entities.FindByModel(expl_pack, "models/w_models/weapons/w_eq_explosive_ammopack.mdl"))
	{
		PrecacheAndSetModel(expl_pack, "models/swarm/props/barricade_razorwire001_128_reference.mdl");
	}
	while (ince_pack = Entities.FindByModel(ince_pack, "models/w_models/weapons/w_eq_incendiary_ammopack.mdl"))
	{
		PrecacheAndSetModel(ince_pack, "models/swarm/props/w_eq_incendiary_ammopack.mdl");
	}	
}

function AllowBash(basher, bashee)
{
	if (bashee.IsPlayer())
	{
		if (bashee.GetZombieType() == 2)
		{
			return ALLOW_BASH_NONE;
		}
	}

	return ALLOW_BASH_ALL;
}

function PrecacheAndSetModel(entity, model)
{
	if (!IsModelPrecached(model))
	{
		PrecacheModel(model);
	}

	entity.SetModel(model);
}