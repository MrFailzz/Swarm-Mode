///////////////////////////////////////////////
//                  OPTIONS                  //
///////////////////////////////////////////////
difficulty <- GetDifficulty();
survivorSet <- Director.GetSurvivorSet();
z_speed <- Convars.GetFloat("z_speed");

Convars.SetValue("z_versus_hunter_limit", 0);
Convars.SetValue("z_versus_spitter_limit", 0);
Convars.SetValue("z_ghost_delay_minspawn", 20);

// DIRECTOR OPTIONS //
DirectorOptions <-
{
	ActiveChallenge = 1

	cm_AggressiveSpecials = 0
	
	cm_DominatorLimit = 4
	cm_MaxSpecials = 13 //For sleepers, was 4. Game limits max players on server to 18?
	cm_TankLimit = 1
	cm_WitchLimit = -1
	cm_CommonLimit = 30
	cm_ProhibitBosses = true

	MobSpawnMinTime = 9999
	MobSpawnMaxTime = 9999

	SpecialInitialSpawnDelayMax = 45
	SpecialInitialSpawnDelayMin = 30
	SpecialRespawnInterval = 25
	BoomerLimit = 2
	ChargerLimit = 1
	HunterLimit = 0
	JockeyLimit = 2
	SmokerLimit = 2
	SpitterLimit = 0

	TankHitDamageModifierCoop = 1
	EscapeSpawnTanks = false
	SurvivorMaxIncapacitatedCount = 2
}

// EXPERT OPTIONS //
// DIFFICULTY OPTIONS //
if (difficulty == 0)
{
	Convars.SetValue("z_jockey_health", 361);
	Convars.SetValue("z_gas_health", 297);
	Convars.SetValue("z_exploding_health", 595);
	Convars.SetValue("z_witch_health", 850);
	DirectorOptions.SurvivorMaxIncapacitatedCount = 3
}
else if (difficulty == 1)
{
	Convars.SetValue("z_jockey_health", 361);
	Convars.SetValue("z_gas_health", 297);
	Convars.SetValue("z_exploding_health", 595);
	Convars.SetValue("z_witch_health", 850);
	DirectorOptions.SurvivorMaxIncapacitatedCount = 2
}
else if (difficulty == 2)
{
	Convars.SetValue("z_jockey_health", 425);
	Convars.SetValue("z_gas_health", 350);
	Convars.SetValue("z_exploding_health", 700);
	Convars.SetValue("z_witch_health", 1000);
	DirectorOptions.SurvivorMaxIncapacitatedCount = 2
}
else if (difficulty == 3)
{
	Convars.SetValue("z_jockey_health", 425);
	Convars.SetValue("z_gas_health", 350);
	Convars.SetValue("z_exploding_health", 700);
	Convars.SetValue("z_witch_health", 1000);
	DirectorOptions.SurvivorMaxIncapacitatedCount = 1
	DirectorOptions.TankHitDamageModifierCoop = 0.48
}

// BOSSES //
swarmTickInterval <- 1;				// In seconds
swarmDamagePerTick <- 2;

tankJumpVelocity <- 500;
tankJumpExtraHeight <- 300;			// Max extra height from aiming up

spawnBoss <- (RandomFloat(0.1,0.9))
spawnBreaker <- (RandomFloat(0.1,0.9))
spawnOgre <- (RandomFloat(0.1,0.9))

breakerSpawned <- false;
ogreSpawned <- false;
bossSpawned <- false;
bossOgreEnable <- false;
bossBreakerEnable <- false;

// INFECTED //
boomerExplosionRange <- 250;
boomerExplosionDamage <- 45;		// Max damage
boomerExplosionKnockback <- 275;	// Max knockback
boomerExplodeTime <- 3;				// In seconds

tallboyPunchKnockback <- 350;		// Max knockback
tallboyRunSpeed <- 210;

// COMMON //
acidCommonsMax <- 7;
acidCommonSpawnAmount <- 4;			// Size of group to spawn
acidCommonSpawnRate <- 30;			// How often a group will be spawned in seconds

fireCommonsMax <- 7;
fireCommonSpawnAmount <- 4;			// Size of group to spawn
fireCommonSpawnRate <- 30;			// How often a group will be spawned in seconds
fireCommonDamage <- 2;				// Damage per tick from burning
fireCommonRange <- 40;				// Size of fire damage hitbox

explodingCommonsMax <- 7;
explodingCommonSpawnAmount <- 4;	// Size of group to spawn
explodingCommonSpawnRate <- 30;		// How often a group will be spawned in seconds
::explodingCommonDamage <- 8;			// Max damage from explosion
::explodingCommonRange <- 200;		// Explosion range
::explodingCommonKnockback <- 275;	// Explosion force

// UNCOMMON //
uncommonMax <- 7;
uncommonSpawnAmount <- 4;			// Size of group to spawn
uncommonSpawnRate <- 30;			// How often a group will be spawned in seconds

uncommonJimmyMax <- 3;
uncommonJimmySpawnAmount <- 3;			// Size of group to spawn
uncommonJimmySpawnRate <- 30;			// How often a group will be spawned in seconds

// HAZARDS //
hazardDifficultyScale <- (difficulty + 1) / 2;	// Number of hazards to be scaled with difficulty (Easy (0): 0.5x, Normal (1): 1x, Advanced (2): 1.5x, Expert (3): 2x)

alarmDoorCountMin <- 2;				// Min number of alarm doors to spawn per map
alarmDoorCountMax <- 2;				// Max number of alarm doors to spawn per map

crowGroupCountMin <- 4;				// Mix number of crow groups to spawn
crowGroupCountMax <- 4;				// Max number of crow groups to spawn

sleeperCountMin <- 4;				// Mix number of sleepers to spawn
sleeperCountMax <- 4;				// Max number of sleepers to spawn

explosiveCarHealth <- 1000;			// HP of explosive cars

spawnSnitch <- (RandomFloat(0.1,0.9))

snitchSpawned <- false;

// HEALING //
medkitHealAmount <- 50;				// HP healed by first aid kits
pillsHealAmount <- 50;				// HP healed by pain pills
adrenalineHealAmount <- 25;			// HP healed by adrenaline

// PINGING //
pingRange <- 2000					// Max range for pinging an object
pingDuration <- 8					// How many seconds do objects stay pinged


//MODE SPECIFIC CHANGES
if (swarmMode == "hardcore" || swarmMode == "survival" || swarmMode == "vs")
{
	DirectorOptions.cm_TankLimit = 2
}


///////////////////////////////////////////////
//               SHARED EVENTS               //
///////////////////////////////////////////////
firstLeftCheckpoint <- false;
cardHudTimeout <- 0;

function DropItemFunc(player, weaponClass)
{
	local activeWeapon = player.GetActiveWeapon();
	if (activeWeapon!=null && player.IsSurvivor() && activeWeapon.IsValid())
 	{
		local weaponClass = activeWeapon.GetClassname();
		player.DropItem(weaponClass);
 	}
}

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
	else if ( command == "!drop" || command == "/drop") 
	{
		DropItem();
		return false;
	}
	else if (command == "!cards" || command == "/cards")
	{
		//PrintCorruptionCards();

		if (!IsHudElementVisible("corruptionCards"))
		{
			ToggleHudElement("corruptionCards");
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
	//local victimType = victim.GetClassname();
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
				//Francis Perk
				Francis = PlayerHasCard(attacker, "Francis");

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
				local critChance = (7 * LuckyShot) + (5 * Ellis);

				if (RandomInt(1, 100) <= critChance)
				{
					LuckyShotRoll = 1;
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
								 + (0.05 * Francis));
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
				//Nick Perk
				Nick = PlayerHasCard(victim, "Nick");

				//Glass Cannon
				GlassCannonVictim = PlayerHasCard(victim, "GlassCannon");

				//Overconfident
				Overconfident = PlayerHasCard(victim, "Overconfident");
				local OverconfidentMultiplier = 0.1;
				local OverconfidentHealth = (victim.GetHealth() + victim.GetHealthBuffer()) / victim.GetMaxHealth();

				if (victim.IsIncapacitated() == false && OverconfidentHealth >= 0.6)
				{
					OverconfidentMultiplier = -0.25
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

				damageModifier = (damageModifier
								 + (0.2 * GlassCannonVictim)
								 + (OverconfidentMultiplier * Overconfident)
								 + (-0.5 * FireProof)
								 + (-0.2 * EyeOfTheSwarmVictim)
								 + (-0.5 * ChemicalBarrier)
								 + (-1 * AddictVictimMultiplier * AddictVictim)
								 + (-0.1 * Nick)
								 + (-0.3 * ScarTissue));
				damageDone = damageDone * damageModifier;
			}
		}

		//Make custom CEDA zombies immune to fire - DOESNT STOP THEM FROM DYING
		/*if (victim.GetClassname() == "infected")
		{
			local commonName = victim.GetName()
			if (commonName.find("__uncommon_") != null)
			{
				if ((damageType & DMG_BURN) == DMG_BURN)
				{
					if (NetProps.GetPropInt(victim, "m_Gender") == 11)
					{
						damageDone = 0;
					}
				}
			}
		}*/
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

/*pipeDuration <- Convars.GetFloat("pipe_bomb_timer_duration");
function OnGameEvent_weapon_fire(params)
{
	ThrowPipeBomb(params);
}*/

function OnGameEvent_player_spawn(params)
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
	}
}

ConfidentKillerCounter <- 0;
MethHeadCounter <- [0, 0, 0, 0];
function OnGameEvent_player_death(params)
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
		local player = GetPlayerFromUserID(params["userid"]);
		local origin = player.GetOrigin();
		local Pinata = TeamHasCard("Pinata");

		if (RandomInt(1, 100) <= Pinata * 15)
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
			printl(randomItem);

			switch(randomItem)
			{
				case "weapon_molotov":
					SpawnEntityFromTable("weapon_molotov",{origin = Vector(origin.x, origin.y, origin.z + 16),angles = Vector(0, 0, 0),model = "models/w_models/weapons/w_eq_molotov.mdl"});
					break;
				case "weapon_pipe_bomb":
					SpawnEntityFromTable("weapon_pipe_bomb",{origin = Vector(origin.x, origin.y, origin.z + 16),angles = Vector(0, 0, 0),model = "models/w_models/weapons/w_eq_pipebomb.mdl"});
					break;
				case "weapon_vomitjar":
					SpawnEntityFromTable("weapon_vomitjar",{origin = Vector(origin.x, origin.y, origin.z + 16),angles = Vector(0, 0, 0),model = "models/w_models/weapons/w_eq_bile_flask.mdl"});
					break;
				case "weapon_pain_pills":
					SpawnEntityFromTable("weapon_pain_pills",{origin = Vector(origin.x, origin.y, origin.z + 16),angles = Vector(0, 0, 0),model = "models/w_models/weapons/w_eq_painpills.mdl"});
					break;
				case "weapon_adrenaline":
					SpawnEntityFromTable("weapon_adrenaline",{origin = Vector(origin.x, origin.y, origin.z + 16),angles = Vector(0, 0, 0),model = "models/w_models/weapons/w_eq_adrenaline.mdl"});
					break;
				case "weapon_first_aid_kit":
					SpawnEntityFromTable("weapon_first_aid_kit",{origin = Vector(origin.x, origin.y, origin.z + 16),angles = Vector(0, 0, 0),model = "models/w_models/weapons/w_eq_Medkit.mdl"});
					break;
				case "weapon_defibrillator":
					SpawnEntityFromTable("weapon_defibrillator",{origin = Vector(origin.x, origin.y, origin.z + 16),angles = Vector(0, 0, 0),model = "models/w_models/weapons/w_eq_defibrillator.mdl"});
					break;
			}
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

function OnGameEvent_player_incapacitated_start(params)
{
	//AdrenalineRush
	//InspiringSacrifice
	ApplyAdrenalineRush();
	ApplyInspiringSacrifice();
}

function OnGameEvent_round_start(params)
{
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
}

function OnGameEvent_player_activate(params)
{
	CorruptionDropItems();
}

function OnGameEvent_player_left_safe_area(params)
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
	if (corruptionHordes == "hordeHunted")
	{
		HuntedEnabled = true;
		HuntedTimer = Time() + 180 + 30;
	}
	if (corruptionHordes == "hordeOnslaught")
	{
		OnslaughtEnabled = true;
		OnslaughtTimer = Time() + 90 + 30;
	}

			firstLeftCheckpoint = true;
			cardHudTimeout = 0;

			InitAlarmDoors();
			InitCrows();
			ModifyHittables();
			InitSleepers();
		}
	}
}

function OnGameEvent_player_hurt(params)
{
	//Add FX when being hit by script spawned spit
	local player = GetPlayerFromUserID(params.userid);
	local attackerID = GetPlayerFromUserID(params.attacker);

	if (player == attackerID || attackerID == null)
	{
		return;
	}

	//Survivor was hurt
	if (player.GetZombieType() == 9)
	{
		if (params.type == 265216)
		{
			//Spit damage
			ScreenFade(player, 0, 200, 0, 50, 0.5, 0, 1);
			EmitSoundOnClient("PlayerZombie.AttackHit", player);
		}
		else if (params.type == 8)
		{
			ScreenFade(player, 255, 70, 0, 50, 0.5, 0, 1);
			EmitSoundOnClient("General.BurningObject", player);
		}

		if (params.weapon == "charger_claw")
		{
			//Charger scratch
			local attacker = GetPlayerFromUserID(params.attacker);
			TallboyKnockback(attacker, player);
		}
	}
}

//Store temp health at time of heal
survivorHealthBuffer <- [0, 0, 0, 0];

//Use heal begin because heal end is bugged, so restored temp health may not be accurate
function OnGameEvent_heal_begin(params)
{
	local player = GetPlayerFromUserID(params.subject);
	local currentTempHealth = player.GetHealthBuffer();
	survivorHealthBuffer[GetSurvivorID(player)] = currentTempHealth;
}

function OnGameEvent_heal_success(params)
{
	local healer = GetPlayerFromUserID(params.userid);
	local player = GetPlayerFromUserID(params.subject);

	local EMTBag = PlayerHasCard(healer, "EMTBag");
	local AntibioticOintment = PlayerHasCard(healer, "AntibioticOintment");
	local MedicalExpert = TeamHasCard("MedicalExpert");
	local Rochelle = PlayerHasCard(healer, "Rochelle");
	local ScarTissue = PlayerHasCard(healer, "ScarTissue");
	local healMultiplier = 1 + ((0.5 * EMTBag) + (0.25 * AntibioticOintment) + (0.15 * MedicalExpert) + (0.1 * Rochelle) + (-0.5 * ScarTissue));
	local healAmount = medkitHealAmount * healMultiplier;

	Heal_PermaHealth(player, healAmount, survivorHealthBuffer[GetSurvivorID(player)]);

	if (AntibioticOintment > 0)
	{
		local healAmountAntibiotic = 10 * AntibioticOintment;
		Heal_Antibiotic(healAmountAntibiotic, player)
	}

	Heal_GroupTherapy(player, healAmount, false);
}

function OnGameEvent_pills_used(params)
{
	local player = GetPlayerFromUserID(params.subject);
	local maxHealth = player.GetMaxHealth();

	local EMTBag = PlayerHasCard(player, "EMTBag");
	local AntibioticOintment = PlayerHasCard(player, "AntibioticOintment");
	local MedicalExpert = TeamHasCard("MedicalExpert");
	local Addict = PlayerHasCard(player, "Addict");
	local Rochelle = PlayerHasCard(player, "Rochelle");
	local ScarTissue = PlayerHasCard(player, "ScarTissue");
	local healMultiplier = 1 + ((0.5 * EMTBag) + (0.25 * AntibioticOintment) + (0.15 * MedicalExpert) + (0.5 * Addict) + (0.1 * Rochelle) + (-0.5 * ScarTissue));
	local healAmount = pillsHealAmount * healMultiplier;

	Heal_TempHealth(player, healAmount);

	if (AntibioticOintment > 0)
	{
		local healAmountAntibiotic = 10 * AntibioticOintment;
		Heal_Antibiotic(healAmountAntibiotic, player);
	}

	Heal_GroupTherapy(player, healAmount, true);
}

function OnGameEvent_adrenaline_used(params)
{
	local player = GetPlayerFromUserID(params.subject);
	local maxHealth = player.GetMaxHealth();

	local EMTBag = PlayerHasCard(player, "EMTBag");
	local AntibioticOintment = PlayerHasCard(player, "AntibioticOintment");
	local MedicalExpert = TeamHasCard("MedicalExpert");
	local Addict = PlayerHasCard(player, "Addict");
	local Rochelle = PlayerHasCard(player, "Rochelle");
	local ScarTissue = PlayerHasCard(player, "ScarTissue");
	local healMultiplier = 1 + ((0.5 * EMTBag) + (0.25 * AntibioticOintment) + (0.15 * MedicalExpert) + (0.75 * Addict) + (0.1 * Rochelle) + (-0.5 * ScarTissue));
	local healAmount = adrenalineHealAmount * healMultiplier;

	Heal_TempHealth(player, healAmount);

	if (AntibioticOintment > 0)
	{
		local healAmountAntibiotic = 10 * AntibioticOintment;
		Heal_Antibiotic(healAmountAntibiotic, player);
	}

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

function Heal_Antibiotic(healAmount, player)
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

function OnGameEvent_revive_success(params)
{
	local ledgeHang = params.ledge_hang;
	if (ledgeHang == 0)
	{
		local player = GetPlayerFromUserID(params.userid);
		local subject = GetPlayerFromUserID(params.subject);
		local CombatMedic = PlayerHasCard(player, "CombatMedic");
		local CombatMedicAmount = 30 * CombatMedic;

		local currentTempHealth = subject.GetHealthBuffer();
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

function OnGameEvent_triggered_car_alarm(params)
{
	local AmpedUp = TeamHasCard("AmpedUp");
	if (AmpedUp > 0)
	{
		Heal_AmpedUp(AmpedUp);
	}
}

::AmpedUpCooldown <- 0;
function Heal_AmpedUp(AmpedUp)
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
::Heal_AmpedUp <- Heal_AmpedUp;

function OnGameEvent_player_shoved(params)
{
	//Kill sleeper on shove
	local hunter = GetPlayerFromUserID(params.userid);
	local survivor = GetPlayerFromUserID(params.attacker);
	if (hunter.GetZombieType() == 3)
	{
		hunter.TakeDamage(250, 2097152, survivor);
	}
}

function OnGameEvent_item_pickup(params)
{
	TallboySpawn(params);
	SurvivorPickupItem(params);
	InitOptics(params);
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
		}
	}

	if (corruptionEnvironmental == "environmentFrozen")
	{
		FrigidOutskirtsTimer();
	}

	if (difficulty > 1)
	{
		difficulty_RandomBoss()
	}

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

	local AmpedUp = TeamHasCard("AmpedUp");
	if (AmpedUp > 0)
	{
		Heal_AmpedUp(AmpedUp);
	}
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

/*function CreateInfectedFilter()
{
	SpawnEntityFromTable("filter_activator_team",
	{
		targetname = "__swarm_filter_infected",
		Negated = "Allow entities that match criteria",
		filterteam = 3
	});
}*/

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