///////////////////////////////////////////////
//               SHARED EVENTS               //
///////////////////////////////////////////////
function InterceptChat(message, speaker)
{
	// Remove player name from message
	local name = speaker.GetPlayerName() + ": ";
	local text = strip(message.slice(message.find(name) + name.len()));
	local textArgs = [];
	textArgs = split(text, " ");
	local command = textArgs[0].tolower();


	if (command == "!ping" || command == "/ping")
	{
		TraceEye(speaker);
		return false;
	}
	else if (command == "!drop" || command == "/drop") 
	{
		local activeWeapon = speaker.GetActiveWeapon();

		if (activeWeapon!=null && speaker.IsSurvivor() && activeWeapon.IsValid())
		{
			local weaponClass = activeWeapon.GetClassname();
			speaker.DropItem(weaponClass);
		}
		
		return false;
	}
	else if (command == "!cards" || command == "/cards")
	{
		//PrintCorruptionCards();

		if (!IsHudElementVisible("corruptionCards"))
		{
			ToggleHudElement("corruptionCards");
		}
		if (!IsHudElementVisible("corruptionCardsInfected"))
		{
			ToggleHudElement("corruptionCardsInfected");
		}
		if (!IsHudElementVisible("playerCardsP1"))
		{
			ToggleHudElement("playerCardsP1");
		}
		if (!IsHudElementVisible("playerCardsP2"))
		{
			ToggleHudElement("playerCardsP2");
		}
		if (!IsHudElementVisible("playerCardsP3"))
		{
			ToggleHudElement("playerCardsP3");
		}
		if (!IsHudElementVisible("playerCardsP4"))
		{
			ToggleHudElement("playerCardsP4");
		}
		if (cardPickingAllowed[0] == true || cardPickingAllowed[1] == true || cardPickingAllowed[2] == true || cardPickingAllowed[3] == true)
		{
			if (!IsHudElementVisible("cardPickReflex"))
			{
				ToggleHudElement("cardPickReflex");
			}
			if (!IsHudElementVisible("cardPickBrawn"))
			{
				ToggleHudElement("cardPickBrawn");
			}
			if (!IsHudElementVisible("cardPickDiscipline"))
			{
				ToggleHudElement("cardPickDiscipline");
			}
			if (!IsHudElementVisible("cardPickFortune"))
			{
				ToggleHudElement("cardPickFortune");
			}
		}

		cardHudTimeout = 0;
		return false;
	}
	else if (command == "!pick" || command == "/pick" || command == "!card" || command == "/card")
	{
		if (textArgs[1].len() == 1 && speaker.IsSurvivor())
		{
			PickCard(speaker, textArgs[1].toupper())
		}
		return false;
	}
	else if (command == "!pickbot" || command == "/pickbot" || command == "!botpick" || command == "/botpick")
	{
		if (textArgs[1].len() == 1 && speaker.IsSurvivor())
		{
			local player = null;
			while ((player = Entities.FindByClassname(player, "player")) != null)
			{
				if (player.IsSurvivor())
				{
					if (IsPlayerABot(player))
					{
						PickCard(player, textArgs[1].toupper())
					}
				}
			}
		}
		return false;
	}
	else if (command == "!debugpick" || command == "/debugpick")
	{
		if (Convars.GetFloat("sv_cheats") == 1)
		{
			AddCardToTable(GetSurvivorCardTable(GetSurvivorID(speaker)), speaker, textArgs[1]);
			GetAllPlayerCards();
			ApplyCardEffects(speaker);
			if (textArgs[1] == "Gambler")
			{
				PrintGamblerValue(speaker);
			}
		}
		return false;
	}
}

function AllowTakeDamage(damageTable)
{
	//Table values
	local damageDone = damageTable.DamageDone;
	local attacker = damageTable.Attacker;
	local victim = damageTable.Victim;
	local victimPlayer = victim.IsPlayer();
	local victimType = victim.GetClassname();
	local inflictor = damageTable.Inflictor;
	local inflictorClass = null;
	if (inflictor.IsValid())
	{
		inflictorClass = inflictor.GetClassname();
	}
	local weapon = damageTable.Weapon;
	local weaponClass = null;
	if (weapon != null)
	{
		weaponClass = weapon.GetClassname();
	}
	local damageType = damageTable.DamageType;

	//Modifiers
	local damageModifier = 1;
	local GlassCannonAttacker = 0;
	local GlassCannonVictim = 0;
	local Sharpshooter = 0;
	local Outlaw = 0;
	local Overconfident = 0;
	local OverconfidentMultiplier = 0;
	local OverconfidentHealth = 0;
	local Broken = 0;
	local Pyromaniac = 0;
	local BombSquad = 0;
	local LuckyShot = 0;
	local LuckyShotRoll = 0;
	local FireProof = 0;
	local EyeOfTheSwarmAttacker = 0;
	local EyeOfTheSwarmVictim = 0;
	local Brazen = 0;
	local StrengthInNumbers = 0;
	local StrengthInNumbersSurvivors = 0;
	local ConfidentKiller = 0;
	local ChemicalBarrier = 0;
	local Berserker = 0;
	local AddictAttacker = 0;
	local AddictAttackerMultiplier = 0;
	local AddictVictim = 0;
	local AddictVictimMultiplier = 0;
	local BuckshotBruiser = 0;
	local Nick = 0;
	local Ellis = 0;
	local Zoey = 0;
	local Francis = 0;
	local ScarTissue = 0;
	local Arsonist = 0;
	local SwanSong = 0;
	local ToughSkin = 0;
	local GamblerAttacker = 0;
	local GamblerVictim = 0;

	//printl("Attacker: " + attacker);
	//printl("Victim: " + victim);
	//printl("Original DMG: " + damageDone);

	//Modify Attacker damage
	if (attacker.IsValid())
	{
		if (attacker.IsPlayer())
		{
			//Survivor dealing damage
			if (attacker.IsSurvivor())
			{
				//Gambler
				local GamblerAttacker = PlayerHasCard(attacker, "Gambler");

				//Nick Perk
				Nick = PlayerHasCard(attacker, "Nick");

				//Glass Cannon
				GlassCannonAttacker = PlayerHasCard(attacker, "GlassCannon");

				//Sharpshooter
				if (GetVectorDistance(attacker.GetOrigin(), victim.GetOrigin()) > 600)
				{
					Sharpshooter = PlayerHasCard(attacker, "Sharpshooter");
				}

				//Outlaw
				if (weaponClass == "weapon_pistol" || weaponClass == "weapon_pistol_magnum")
				{
					Outlaw = PlayerHasCard(attacker, "Outlaw");
				}

				//Broken
				if (victimPlayer == true)
				{
					if (victim.GetZombieType() == 8)
					{
						Broken = PlayerHasCard(attacker, "Broken");
					}
				}
				else if (victimType == "witch")
				{
					Broken = PlayerHasCard(attacker, "Broken");
				}
				
				//Pyromaniac
				//Arsonist
				if ((damageType & DMG_BURN) == DMG_BURN)
				{
					Pyromaniac = PlayerHasCard(attacker, "Pyromaniac");
					Arsonist = PlayerHasCard(attacker, "Arsonist");
					if (Arsonist > 0)
					{
						Heal_TempHealth(attacker, 0.1 * Arsonist);
					}
				}

				//BombSquad
				if ((damageType & DMG_BLAST) == DMG_BLAST || (damageType & DMG_BLAST_SURFACE) == DMG_BLAST_SURFACE)
				{
					BombSquad = PlayerHasCard(attacker, "BombSquad");
				}

				/*if((damageType & DMG_BURN) == DMG_BURN){printl("DMG_BURN")}
				if((damageType & DMG_BLAST) == DMG_BLAST){printl("DMG_BLAST")}
				if((damageType & DMG_BLAST_SURFACE) == DMG_BLAST_SURFACE){printl("DMG_BLAST_SURFACE")}*/

				//BombSquad
				/*if (inflictorClass == "pipe_bomb_projectile")
				{
					if (victimPlayer == true)
					{
						if (victim.IsSurvivor() == false)
						{
							BombSquad = PlayerHasCard(attacker, "BombSquad");
						}
					}
					else
					{
						BombSquad = PlayerHasCard(attacker, "BombSquad");
					}
				}
				BombSquadMultiplier = BombSquad == 0 ? 0 : (BombSquad - 1)*/

				//LuckyShot
				//Ellis Perk
				LuckyShot = TeamHasCard("LuckyShot");
				Ellis = PlayerHasCard(attacker, "Ellis");
				SwanSong = PlayerHasCard(attacker, "SwanSong");
				local SwanSongMultiplier = (attacker.IsIncapacitated() == true ? 1 : 0);
				local critChance = (7 * LuckyShot) + (5 * Ellis) + (100 * SwanSongMultiplier * SwanSong);

				if (RandomInt(1, 100) <= critChance)
				{
					LuckyShotRoll = 1;
					CriticalHit(attacker, damageTable.Location);
				}

				//EyeOfTheSwarm
				if (safeSurvivors.find(attacker) != null)
				{
					EyeOfTheSwarmAttacker = PlayerHasCard(attacker, "EyeOfTheSwarm");
				}

				//Brazen
				//Berserker
				//Zoey Perk
				if ((damageType & DMG_MELEE) == DMG_MELEE)
				{
					if (victimPlayer == true)
					{
						if (victim.IsSurvivor() == false)
						{
							Brazen = PlayerHasCard(attacker, "Brazen");
							Berserker = PlayerHasCard(attacker, "Berserker");
							Zoey = PlayerHasCard(attacker, "Zoey");
						}
					}
				}

				//StrengthInNumbers
				local survivorSIN = null;
				while ((survivorSIN = Entities.FindByClassname(survivorSIN, "player")) != null)
				{
					if (survivorSIN.IsSurvivor() && !survivorSIN.IsDead())
					{
						StrengthInNumbersSurvivors++
					}
				}
				StrengthInNumbers = TeamHasCard("StrengthInNumbers");

				//ConfidentKiller
				ConfidentKiller = PlayerHasCard(attacker, "ConfidentKiller");

				//Addict
				AddictAttacker = PlayerHasCard(attacker, "Addict");
				AddictAttackerMultiplier = AddictGetValue(attacker);

				//BuckshotBruiser
				if (weaponClass == "weapon_shotgun_chrome" || weaponClass == "weapon_pumpshotgun" || weaponClass == "weapon_autoshotgun" || weaponClass == "weapon_shotgun_spas")
				{
					BuckshotBruiser = PlayerHasCard(attacker, "BuckshotBruiser");
					Heal_TempHealth(attacker, 0.25 * BuckshotBruiser);
				}

				damageModifier = (damageModifier
								 + (0.3 * GlassCannonAttacker)
								 + (0.25 * Sharpshooter)
								 + (1 * Outlaw)
								 + (0.2 * Broken)
								 + (1.5 * Pyromaniac)
								 + (1.5 * BombSquad)
								 + (3 * LuckyShotRoll)
								 + (0.1 * EyeOfTheSwarmAttacker)
								 + (0.4 * Brazen)
								 + (0.025 * StrengthInNumbers * StrengthInNumbersSurvivors)
								 + (0.01 * ConfidentKiller * ConfidentKillerCounter)
								 + (0.25 * Berserker)
								 + (AddictAttackerMultiplier * AddictAttacker)
								 + (0.1 * Zoey)
								 + (0.05 * Nick));
				if (GamblerAttacker > 0)
				{
					damageModifier += ApplyGamblerValue(GetSurvivorID(attacker), 4, GamblerAttacker, damageModifier);
				}
				GamblerAttacker
				damageDone = damageDone * damageModifier;
			}
		}
	}


	//Modify Victim damage
	if (victim.IsValid())
	{
		if (victim.IsPlayer())
		{
			if (victim.IsSurvivor())
			{
				//Gambler
				local GamblerVictim = PlayerHasCard(victim, "Gambler");

				//Francis Perk
				Francis = PlayerHasCard(victim, "Francis");

				//Glass Cannon
				GlassCannonVictim = PlayerHasCard(victim, "GlassCannon");

				//Overconfident
				Overconfident = PlayerHasCard(victim, "Overconfident");
				if (Overconfident > 0)
				{
					OverconfidentMultiplier = 0.1;
					OverconfidentHealth = (victim.GetHealth() + victim.GetHealthBuffer()) / victim.GetMaxHealth();

					if (victim.IsIncapacitated() == false && OverconfidentHealth >= 0.6)
					{
						OverconfidentMultiplier = -0.25
					}
				}

				if ((damageType & DMG_BURN) == DMG_BURN)
				{
					FireProof = PlayerHasCard(victim, "FireProof");
				}

				//EyeOfTheSwarm
				if (safeSurvivors.find(victim) != null)
				{
					EyeOfTheSwarmVictim = PlayerHasCard(victim, "EyeOfTheSwarm");
				}

				//ChemicalBarrier
				//DMG_RADIATION + DMG_ENERGYBEAM = Spitter Acid
				if ((damageType & 262144) == 262144 && (damageType & 1024) == 1024)
				{
					ChemicalBarrier = PlayerHasCard(victim, "ChemicalBarrier");
				}

				//Addict
				AddictVictim = PlayerHasCard(victim, "Addict");
				AddictVictimMultiplier = AddictGetValue(victim);

				//ScarTissue
				ScarTissue = PlayerHasCard(victim, "ScarTissue");

				//ToughSkin
				if (attacker.IsValid())
				{
					local attackerClass = attacker.GetClassname();
					if (attackerClass == "infected")
					{
						ToughSkin = PlayerHasCard(victim, "ToughSkin");
					}
				}

				damageModifier = (damageModifier
								+ (0.2 * GlassCannonVictim)
								+ (OverconfidentMultiplier * Overconfident)
								+ (-0.5 * FireProof)
								+ (-0.2 * EyeOfTheSwarmVictim)
								+ (-0.5 * ChemicalBarrier)
								+ (-1 * AddictVictimMultiplier * AddictVictim)
								+ (-0.1 * Francis)
								+ (-0.3 * ScarTissue)
								+ (-0.4 * ToughSkin));
				if (GamblerVictim > 0)
				{
					damageModifier += ApplyGamblerValue(GetSurvivorID(victim), 1, GamblerVictim, damageModifier);
				}
				damageDone = damageDone * damageModifier;
			}
		}
	}

	//Damage can't go below 1
	//TODO: Add clause for = 0
	if (damageDone < 1)
	{
		damageDone = 1;
	}
	else
	{
		damageTable.DamageDone = damageDone
	}
	//printl("New DMG: " + damageTable.DamageDone);

	return true;
}

function CriticalHit(player, location)
{
	local id = location.Length();

	local target = SpawnEntityFromTable("info_particle_target",
	{
		targetname = "__critical_particle_target" + id,
		origin = Vector(location.x, location.y, location.z + 16)
	});
	local particle = SpawnEntityFromTable("info_particle_system",
	{
		targetname = "__critical_particle" + id,
		origin = Vector(location.x, location.y, location.z - 16),
		cpoint1 = "__critical_particle_target" + id,
		effect_name = "electrical_arc_01",
		start_active = 1
	});

	local random = RandomInt(1, 3);
	if (random == 1)
	{
		//EmitSoundOnClient("ambient.electrical_zap_1", player);
		EmitAmbientSoundOn("ambient.electrical_zap_1", 0.75, RandomInt(95, 105), RandomInt(90, 110), target);
	}
	else if (random == 2)
	{
		//EmitSoundOnClient("ambient.electrical_zap_2", player);
		EmitAmbientSoundOn("ambient.electrical_zap_2", 0.75, RandomInt(95, 105), RandomInt(90, 110), target);
	}
	else
	{
		//EmitSoundOnClient("ambient.electrical_zap_3", player);
		EmitAmbientSoundOn("ambient.electrical_zap_2", 0.75, RandomInt(95, 105), RandomInt(90, 110), target);
	}
}

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
		if (corruptionEnvironmental == "environmentSwarmStream" && RandomInt(0, 2) == 0)
		{
			CorruptionCard_SwarmStreamGlow(player);
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
	else if (params.victimname == "Spitter")
	{
		SpitterDeath(GetPlayerFromUserID(params["userid"]));
	}

	if (params.victimname == "Tank" || params.victimname == "Smoker" || params.victimname == "Jockey" || params.victimname == "Boomer" || params.victimname == "Spitter" || params.victimname == "Charger")
	{
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
	if (!IsModelPrecached("models/swarm/barricade_razorwire001_128_reference.mdl"))
		PrecacheModel("models/swarm/barricade_razorwire001_128_reference.mdl");

	CreateCardHud();

	difficulty = GetDifficulty();
	InitCorruptionCards();

	// Ends the game after the third wipe
	if (swarmMode == "hardcore")
	{
		if ( Director.GetMissionWipes() > 2)
		{
			Convars.SetValue("sv_permawipe", "1");
		}
		else
		{
			Convars.SetValue("sv_permawipe", "0");
		}
	}

	local expl_pack = null;
	while (expl_pack = Entities.FindByModel(expl_pack, "models/w_models/weapons/w_eq_explosive_ammopack.mdl"))
		expl_pack.SetModel("models/swarm/barricade_razorwire001_128_reference.mdl");
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
					HuntedTimer = Time() + 180 + 30;
					break;
				case "hordeOnslaught":
					OnslaughtEnabled = true;
					OnslaughtTimer = Time() + 90 + 30;
					break;
				case "hordeTallboy":
					TallboyHordeEnabled = true;
					SpecialHordeTimer = Time() + 90 + 30;
					break;
				case "hordeCrusher":
					CrusherHordeEnabled = true;
					SpecialHordeTimer = Time() + 90 + 30;
					break;
				case "hordeBruiser":
					BruiserHordeEnabled = true;
					SpecialHordeTimer = Time() + 90 + 30;
					break;
				case "hordeStalker":
					StalkerHordeEnabled = true;
					SpecialHordeTimer = Time() + 90 + 30;
					break;
				case "hordeHocker":
					HockerHordeEnabled = true;
					SpecialHordeTimer = Time() + 90 + 30;
					break;
				case "hordeExploder":
					ExploderHordeEnabled = true;
					SpecialHordeTimer = Time() + 90 + 30;
					break;
				case "hordeRetch":
					RetchHordeEnabled = true;
					SpecialHordeTimer = Time() + 90 + 30;
					break;
			}

			firstLeftCheckpoint = true;
			cardHudTimeout = 0;

			ModifyHittables();
			ApplyEnvironmentalCard();

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
		if (!player.IsSurvivor())
		{
			while (player.IsOnFire())
			{
//				player.TakeDamage( 4, 8, attacker ); //Do cards effect this??
				player.Extinguish();
			}
		}
	}
}


//Use heal begin because heal end is bugged, so restored temp health may not be accurate
function HealBegin(params)
{
	local player = GetPlayerFromUserID(params.subject);
	local currentTempHealth = player.GetHealthBuffer();
	survivorHealthBuffer[GetSurvivorID(player)] = currentTempHealth; //Store temp health at time of heal
}

function HealSuccess(params)
{
	local healer = GetPlayerFromUserID(params.userid);
	local player = GetPlayerFromUserID(params.subject);

	local Gambler = PlayerHasCard(player, "Gambler");
	local EMTBag = PlayerHasCard(healer, "EMTBag");
	local AntibioticOintment = PlayerHasCard(healer, "AntibioticOintment");
	local MedicalExpert = TeamHasCard("MedicalExpert");
	local Rochelle = PlayerHasCard(healer, "Rochelle");
	local ScarTissue = PlayerHasCard(healer, "ScarTissue");
	local healMultiplier = 1 + ((0.5 * EMTBag) + (0.25 * AntibioticOintment) + (0.15 * MedicalExpert) + (0.1 * Rochelle) + (-0.5 * ScarTissue));
	if (Gambler > 0)
	{
		healMultiplier += ApplyGamblerValue(GetSurvivorID(player), 6, Gambler, healMultiplier);
	}
	local healAmount = medkitHealAmount * healMultiplier;

	Heal_PermaHealth(player, healAmount, survivorHealthBuffer[GetSurvivorID(player)]);

	if (AntibioticOintment > 0)
	{
		local healAmountAntibiotic = 10 * AntibioticOintment;
		Heal_TempHealth(player, healAmountAntibiotic);
		Heal_GroupTherapy(player, healAmountAntibiotic, true);
	}

	Heal_GroupTherapy(player, healAmount, false);
}

function PillsUsed(params)
{
	local player = GetPlayerFromUserID(params.subject);
	local maxHealth = player.GetMaxHealth();

	local Gambler = PlayerHasCard(player, "Gambler");
	local EMTBag = PlayerHasCard(player, "EMTBag");
	local AntibioticOintment = PlayerHasCard(player, "AntibioticOintment");
	local MedicalExpert = TeamHasCard("MedicalExpert");
	local Addict = PlayerHasCard(player, "Addict");
	local Rochelle = PlayerHasCard(player, "Rochelle");
	local ScarTissue = PlayerHasCard(player, "ScarTissue");
	local healMultiplier = 1 + ((0.5 * EMTBag) + (0.25 * AntibioticOintment) + (0.15 * MedicalExpert) + (0.5 * Addict) + (0.1 * Rochelle) + (-0.5 * ScarTissue));
	if (Gambler > 0)
	{
		healMultiplier += ApplyGamblerValue(GetSurvivorID(player), 6, Gambler, healMultiplier);
	}
	local healAmount = (pillsHealAmount * healMultiplier) + (10 * AntibioticOintment);

	Heal_TempHealth(player, healAmount);
	Heal_GroupTherapy(player, healAmount, true);
}

function AdrenalineUsed(params)
{
	local player = GetPlayerFromUserID(params.subject);
	local maxHealth = player.GetMaxHealth();

	local Gambler = PlayerHasCard(player, "Gambler");
	local EMTBag = PlayerHasCard(player, "EMTBag");
	local AntibioticOintment = PlayerHasCard(player, "AntibioticOintment");
	local MedicalExpert = TeamHasCard("MedicalExpert");
	local Addict = PlayerHasCard(player, "Addict");
	local Rochelle = PlayerHasCard(player, "Rochelle");
	local ScarTissue = PlayerHasCard(player, "ScarTissue");
	local healMultiplier = 1 + ((0.5 * EMTBag) + (0.25 * AntibioticOintment) + (0.15 * MedicalExpert) + (0.75 * Addict) + (0.1 * Rochelle) + (-0.5 * ScarTissue));
	if (Gambler > 0)
	{
		healMultiplier += ApplyGamblerValue(GetSurvivorID(player), 6, Gambler, healMultiplier);
	}
	local healAmount = (adrenalineHealAmount * healMultiplier) + (10 * AntibioticOintment);

	Heal_TempHealth(player, healAmount);
	Heal_GroupTherapy(player, healAmount, true);
}

function Heal_PermaHealth(player, healAmount, currentTempHealth)
{
	local currentHealth = player.GetHealth();
	local maxHealth = player.GetMaxHealth();

	if (currentHealth + healAmount > maxHealth)
	{
		player.SetHealth(maxHealth);
		player.SetHealthBuffer(0);
	}
	else
	{
		player.SetHealth(currentHealth + healAmount);

		if (currentTempHealth + (currentHealth + healAmount) > maxHealth)
		{
			player.SetHealthBuffer(maxHealth - (currentHealth + healAmount));
		}
		else
		{
			player.SetHealthBuffer(currentTempHealth);
		}
	}
}

function Heal_TempHealth(player, healAmount)
{
	local currentHealth = player.GetHealth();
	local currentTempHealth = player.GetHealthBuffer();
	local maxHealth = player.GetMaxHealth();

	if (currentHealth + currentTempHealth + healAmount > maxHealth)
	{
		player.SetHealthBuffer(maxHealth - currentHealth);
	}
	else
	{
		player.SetHealthBuffer(healAmount + currentTempHealth);
	}
}

function Heal_GroupTherapy(healTarget, healAmount, isTempHealth)
{
	local GroupTherapy = TeamHasCard("GroupTherapy");

	if (GroupTherapy > 0)
	{
		healAmount = healAmount * (0.2 * GroupTherapy);
		
		local player = null;
		while ((player = Entities.FindByClassname(player, "player")) != null)
		{
			if (player.IsValid())
			{
				if (player.IsSurvivor())
				{
					if (player != healTarget)
					{
						if (isTempHealth == false)
						{
							Heal_PermaHealth(player, healAmount, player.GetHealthBuffer());
						}
						else
						{
							Heal_TempHealth(player, healAmount);
						}
					}
				}
			}
		}
	}
}

function ReviveSuccess(params)
{
	local ledgeHang = params.ledge_hang;
	if (ledgeHang == 0)
	{
		local player = GetPlayerFromUserID(params.userid);
		local subject = GetPlayerFromUserID(params.subject);
		local CombatMedic = PlayerHasCard(player, "CombatMedic");
		local CombatMedicAmount = 30 * CombatMedic;
		//local currentTempHealth = subject.GetHealthBuffer();
		local maxHealth = subject.GetMaxHealth();
		local reviveHealth = Convars.GetFloat("survivor_revive_health");

		if (CombatMedic > 0)
		{
			if (reviveHealth + CombatMedicAmount + 1 > maxHealth)
			{
				subject.SetHealthBuffer(maxHealth - 1);
			}
			else
			{
				subject.SetHealthBuffer(reviveHealth + CombatMedicAmount);
			}
		}
	}
}

function DefibrillatorUsed(params)
{
	local player = GetPlayerFromUserID(params.userid);
	local subject = GetPlayerFromUserID(params.subject);
	local CombatMedic = PlayerHasCard(player, "CombatMedic");
	local CombatMedicAmount = 30 * CombatMedic;
	//local currentTempHealth = subject.GetHealthBuffer();
	local maxHealth = subject.GetMaxHealth();

	if (CombatMedic > 0)
	{
		if (CombatMedicAmount + 1 > maxHealth)
		{
			subject.SetHealthBuffer(maxHealth - 1);
		}
		else
		{
			subject.SetHealthBuffer(CombatMedicAmount);
		}
	}
}

function Heal_AmpedUp()
{
	local AmpedUp = TeamHasCard("AmpedUp");
	if (AmpedUp > 0)
	{
		if (AmpedUpCooldown <= 0)
		{
			local player = null;
			while ((player = Entities.FindByClassname(player, "player")) != null)
			{
				if (player.IsSurvivor())
				{
					local currentTempHealth = player.GetHealthBuffer();
					local currentHealth = player.GetHealth();
					local maxHealth = player.GetMaxHealth();

					local healAmount = 20 * AmpedUp;

					if (healAmount + currentHealth > maxHealth)
					{
						player.SetHealth(maxHealth);
					}
					else
					{
						player.SetHealth(healAmount + currentHealth);
					}

					local currentHealth = player.GetHealth();
					if (currentHealth + currentTempHealth > maxHealth)
					{
						player.SetHealthBuffer(maxHealth - currentHealth)
					}
				}
			}

			AmpedUpCooldown = 5;
		}
	}
}
::Heal_AmpedUp <- Heal_AmpedUp;

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

///////////////////////////////////////////////
//                    HUD                    //
///////////////////////////////////////////////
swarmHudX <- 0.01;
swarmHudY <- 0.01;
swarmHudW <- 0.22;
swarmHudH <- 0.0275;
swarmHudLineH <- 0.0275;
swarmHudMidBoxW <- 0.5;
swarmHudGapY <- 0.01;

swarmHUD <-
{
	Fields = 
	{
		corruptionCards = {name = "corruptionCards", slot = HUD_FAR_RIGHT, dataval = "", flags = HUD_FLAG_ALIGN_LEFT},
		corruptionCardsInfected = {name = "corruptionCardsInfected", slot = HUD_SCORE_1, dataval = "", flags = HUD_FLAG_ALIGN_LEFT},
		playerCardsP1 = {name = "playerCardsP1", slot = HUD_FAR_LEFT, dataval = "", flags = HUD_FLAG_ALIGN_LEFT},
		playerCardsP2 = {name = "playerCardsP2", slot = HUD_LEFT_TOP, dataval = "", flags = HUD_FLAG_ALIGN_LEFT},
		playerCardsP3 = {name = "playerCardsP3", slot = HUD_LEFT_BOT, dataval = "", flags = HUD_FLAG_ALIGN_LEFT},
		playerCardsP4 = {name = "playerCardsP4", slot = HUD_MID_TOP, dataval = "", flags = HUD_FLAG_ALIGN_LEFT},
		cardPickReflex = {name = "cardPickReflex", slot = HUD_MID_BOX, dataval = "", flags = HUD_FLAG_ALIGN_LEFT},
		cardPickBrawn = {name = "cardPickBrawn", slot = HUD_MID_BOT, dataval = "", flags = HUD_FLAG_ALIGN_LEFT},
		cardPickDiscipline = {name = "cardPickDiscipline", slot = HUD_RIGHT_TOP, dataval = "", flags = HUD_FLAG_ALIGN_LEFT},
		cardPickFortune = {name = "cardPickFortune", slot = HUD_RIGHT_BOT, dataval = "", flags = HUD_FLAG_ALIGN_LEFT}
	}
}

function CreateCardHud()
{
	HUDSetLayout(swarmHUD);
}

function ToggleHudElement(hudName)
{
	swarmHUD.Fields[hudName].flags = swarmHUD.Fields[hudName].flags ^ HUD_FLAG_NOTVISIBLE;
}

function IsHudElementVisible(hudName)
{
	local flagValue = swarmHUD.Fields[hudName].flags & HUD_FLAG_NOTVISIBLE;
	return flagValue == 0 ? true : false;
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

	if (corruptionUncommons != "None")
	{
		switch(corruptionUncommons)
		{
			case "uncommonClown":
				ClownCountdown();
				break;
			case "uncommonRiot":
				RiotCountdown();
				break;
			case "uncommonMud":
				MudCountdown();
				break;
			case "uncommonCeda":
				CedaCountdown();
				break;
			case "uncommonConstruction":
				ConstructionCountdown();
				break;
			case "uncommonJimmy":
				JimmyCountdown();
				break;
			case "uncommonFallen":
				FallenCountdown();
				break;
		}
	}

	if (corruptionEnvironmental == "environmentFrozen")
	{
		FrigidOutskirtsTimer();
	}

	difficulty_RandomBoss();

	if (corruptionHazards == "hazardSnitch" || corruptionBoss == "hazardBreaker" || corruptionBoss == "hazardOgre")
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
				TallboyTimerFunc();
				break;
			case "hordeCrusher":
				CrusherTimerFunc();
				break;
			case "hordeBruiser":
				BruiserTimerFunc();
				break;
			case "hordeStalker":
				StalkerTimerFunc();
				break;
			case "hordeHocker":
				HockerTimerFunc();
				break;
			case "hordeExploder":
				ExploderTimerFunc();
				break;
			case "hordeRetch":
				RetchTimerFunc();
				break;
		}
	}

	if (bTankHudExists == true)
	{
		CalculateTankHudString();
	}

	if (firstLeftCheckpoint == true)
	{
		if (cardHudTimeout == 8)
		{
			if (IsHudElementVisible("corruptionCards"))
			{
				ToggleHudElement("corruptionCards");
			}
			if (IsHudElementVisible("corruptionCardsInfected"))
			{
				ToggleHudElement("corruptionCardsInfected");
			}
			if (IsHudElementVisible("playerCardsP1"))
			{
				ToggleHudElement("playerCardsP1");
			}
			if (IsHudElementVisible("playerCardsP2"))
			{
				ToggleHudElement("playerCardsP2");
			}
			if (IsHudElementVisible("playerCardsP3"))
			{
				ToggleHudElement("playerCardsP3");
			}
			if (IsHudElementVisible("playerCardsP4"))
			{
				ToggleHudElement("playerCardsP4");
			}
			if (IsHudElementVisible("cardPickReflex"))
			{
				ToggleHudElement("cardPickReflex");
			}
			if (IsHudElementVisible("cardPickBrawn"))
			{
				ToggleHudElement("cardPickBrawn");
			}
			if (IsHudElementVisible("cardPickDiscipline"))
			{
				ToggleHudElement("cardPickDiscipline");
			}
			if (IsHudElementVisible("cardPickFortune"))
			{
				ToggleHudElement("cardPickFortune");
			}
		}
		cardHudTimeout++;
	}

	if (AmpedUpCooldown > 0)
	{
		AmpedUpCooldown--;
	}

	//Remove critical particles
	EntFire("__critical_particle*", "Kill");
}

function SpawnMob(count = 1, zType = 10)
{
	//count = Number of groups to spawn
	//zType = Infected type to spawn, defaults to MOB
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

	Heal_AmpedUp();
}
::ZSpawnMob <- SpawnMob;

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