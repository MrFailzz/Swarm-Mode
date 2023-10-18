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

		//Potentially apply swarm stream to specials (except tank and hunter)
		if (player.GetZombieType() != 8 && player.GetZombieType() != 3)
		{
			if (corruptionEnvironmental == "environmentSwarmStream" && RandomInt(1, 100) <= swarm_stream_chance)
			{
				CorruptionCard_SwarmStreamGlow(player);
			}
		}
	}
}

function PlayerDeath(params)
{
	//Check if a valid Player died, if userid does not exist then it was not a Player entity so we can ignore it
	if ("userid" in params)
	{
		local player = GetPlayerFromUserID(params["userid"]);

		if (player.IsSurvivor())
		{
			//AdrenalineRush
			//InspiringSacrifice
			ApplyAdrenalineRush();
			ApplyInspiringSacrifice();
		}
		else
		{
			if (params.victimname == "Tank")
			{
				TankDeath(player);
			}
			else if (params.victimname == "Boomer")
			{
				BoomerDeath(player);
			}

			//Mutation death (excludes Hunters, and Witches since they are not Players)
			if (params.victimname == "Tank" || params.victimname == "Smoker" || params.victimname == "Jockey" || params.victimname == "Boomer" || params.victimname == "Charger" || params.victimname == "Spitter")
			{
				//Piñata
				local Pinata = TeamHasCard("Pinata");
				if (RandomInt(1, 100) <= Pinata * 15)
				{
					RandomItemDrop(player.GetOrigin());
				}

				//ConfidentKiller
				ConfidentKillerCounter++;

				if ("attacker" in params)
				{
					local attacker = GetPlayerFromUserID(params["attacker"]);
					local headshot = params.headshot;
					if (attacker.IsValid())
					{
						if (attacker.IsPlayer())
						{
							if (attacker.IsSurvivor())
							{
								ApplyCardsOnMutationKill(attacker, player, headshot);
								ApplyBiohazardMutationKill(attacker, player);
							}
						}
					}
				}

				//Remove swarm stream glow
				EntFire("__swarm_stream_lightglow" + player.GetEntityIndex(), "Kill");
			}
		}

		NetProps.SetPropInt(player, "m_Glow.m_iGlowType", 0);
	}
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

function PlayerLeftSafeArea(params)
{
	if (!firstLeftCheckpoint)
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
					bHuntedEnabled = true;
					HuntedTimer = Time() + HuntedTimerDefault + 30;
					break;
				case "hordeOnslaught":
					bOnslaughtEnabled = true;
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

			switch(corruptionEnvironmental)
			{
				case "environmentBiohazard":
					bBiohazardEnabled = true;
					break;
				case "environmentFrozen":
					bFrigidOutskirtsEnabled = true;
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
				if (params.weapon == "charger_claw" && specialTallboyType != "Crusher")
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
				else if (params.weapon == "charger_claw" && specialTallboyType == "Crusher")
				{
					if ("attacker" in params)
					{
						local attacker = GetPlayerFromUserID(params.attacker);
						if (attacker.IsValid() && player != attacker)
						{
							//CrusherGrab(attacker, player);
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
				if (params.type == 2 && bOgreEnable && params.health < stagger_dmg)
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
	Update_GiveupTimer();
	Update_CheckpointWarp();
	Update_PlayerCards();

	if (bSwarmCircleActive)
	{
		SwarmCircleApplyDamage();
		CancelRockAnimation();
	}
	
	if (specialTallboyType == "Tallboy")
	{
		if (bChargerSpawned)
		{
			RemoveCharge();
		}
	}

	CommonsUpdate();

	if (corruptionEnvironmental == "environmentBiohazard")
	{
		BiohazardTimer();
	}

	if (corruptionEnvironmental == "environmentFrozen")
	{
		FrigidOutskirtsTimer();
	}

	difficulty_RandomBoss();

	if (corruptionHazards == "hazardSnitch" || bOgreEnable || bBreakerEnable)
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

	if (bTankHudExists)
	{
		CalculateTankHudString();
	}

	if (firstLeftCheckpoint)
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

function Update_GiveupTimer()
{
	local player = null;
	while ((player = Entities.FindByClassname(player, "player")) != null)
	{
		if (player.IsValid())
		{
			if (player.IsSurvivor())
			{
				local survivorID = GetSurvivorID(player);
				local startGiveupTime = 0;

				if (player.IsIncapacitated())
				{
					local survivorRevive = NetProps.GetPropEntity(player, "m_reviveOwner");

					if (survivorRevive == null)
					{
						if ((player.GetButtonMask() & IN_DUCK) && GiveupTimer[survivorID] == 0)
						{
							startGiveupTime = Time();
							GiveupTimer[survivorID]++;

							// Add progress bar for giving up
							NetProps.SetPropFloat(player, "m_flProgressBarStartTime", startGiveupTime);
							NetProps.SetPropFloat(player, "m_flProgressBarDuration", GiveupTimerDefault);
						}
						else if ((player.GetButtonMask() & IN_DUCK) && GiveupTimer[survivorID] > 0)
						{
							GiveupTimer[survivorID]++;

							if (GiveupTimer[survivorID] > GiveupTimerDefault)
							{
								// Kill player
								player.TakeDamage(9999, 0, null);
							}
						}
						else
						{
							GiveupTimer[survivorID] = 0;
							NetProps.SetPropFloat(player, "m_flProgressBarDuration", 0);
						}
					}
				}
			}
		}
	}
}

function Update_CheckpointWarp()
{
	local player = null;
	while ((player = Entities.FindByClassname(player, "player")) != null)
	{
		if (player.IsSurvivor())
		{
			local survivorID = GetSurvivorID(player);
			local survivorOrigin = player.GetOrigin();
			local flowPct = GetCurrentFlowPercentForPlayer(player);

			// Set the survivorAtCheckpoint flag based on the flow percentage or if the player is a bot
			if (flowPct == 100)
			{
				survivorAtCheckpoint[survivorID] = true;
			}
			else if (IsPlayerABot(player))
			{
				survivorAtCheckpoint[survivorID] = true;
			}
			else
			{
				survivorAtCheckpoint[survivorID] = false;
			}

			// Count the number of survivors at the checkpoint
			local numSurvivor = 0;
			foreach(survivor in survivorAtCheckpoint)
			{
				if (survivor)
				{
					numSurvivor += 1;
				}
			}

			// Warp all survivors to the checkpoint if there are more than 3 and the bSurvivorWarped flag is false
			if (numSurvivor > 3 && !bSurvivorWarped)
			{
				local safedoor = null;
				while ((safedoor = Entities.FindByClassnameWithin(safedoor, "prop_door_rotating_checkpoint", survivorOrigin, 1024)) != null)
				{
					// Only use closed doors and doors without names
					if (NetProps.GetPropInt(safedoor, "m_eDoorState") == 0)
					{
						Director.WarpAllSurvivorsToCheckpoint();
						bSurvivorWarped = true;
					}
				}
			}
		}
	}
}