///////////////////////////////////////////////
//            GLOBALS / CONSTANTS            //
///////////////////////////////////////////////
//1m = 40 units
//5m = 200 units

swarmSettingsTable <-
{
	language = "English",
	autoHideHUD = true,
	hardcore = false,
	debug_mode = 0,

	//Forced Corruption Cards
	cardsZSpeed = "null",
	cardsCommons = "null",
	cardsUncommons = "null",
	cardsTallboy = "null",
	cardsHocker = "null",
	cardsRetch = "null",
	cardsHazards = "null",
	cardsBoss = "null",
	cardsEnvironmental = "null",
	cardsHordes = "null",
	cardsGameplay = "null",
	cardsPlayer = "null",
	cardsMission = "null",
}

//Globals
difficulty <- GetDifficulty();
survivorSet <- Director.GetSurvivorSet();
mapNumber <- Director.GetMapNumber();
z_speed <- Convars.GetFloat("z_speed");
BaseMaxIncaps <- 2;

//Fog Map Defaults
savedFogSettings <- {};

//Bosses
tankModel <- "models/infected/hulk.mdl";
randomPct <- RandomInt(1,100);
spawnBoss <- RandomFloat(0.1,0.9);
spawnRngBoss <- RandomFloat(0.1,0.9);
bossType <- "null";

bBreakerSpawned <- false;
bOgreSpawned <- false;
bBossSpawned <- false;
bOgreAggro <- false;

//Breaker
bSwarmCircleActive <- false;
swarmTickTime <- 0;
swarmOrigin <- null;
safeSurvivors <- array(4);

//Ogre
stagger_dmg <- null;

//Boss DMG & HP Scaling
BossDmgMulti <- 1;
BossHpMulti <- 1;

//Tank HUD
bTankHudExists <- false;
tankHudTanks <- [null, null];

//Specials DMG & HP Scaling
TallboyDmgMulti <- 1;
RetchDmgMulti <- 1;
HockerDmgMulti <- 1;
TallboyHpMulti <- 1;
RetchHpMulti <- 1;
HockerHpMulti <- 1;
difficulty_SpecialHpMulti <- 1;
difficulty_SpecialDmgMulti <- 1;

//Commons
commonVarList <- array(50, null);
acidCommonsCount <- 0;
fireCommonsCount <- 0;
explodingCommonsCount <- 0;
uncommonsCount <- 0;
acidCommonsTimer <- 0;
fireCommonsTimer <- 1;
explodingCommonsTimer <- 3;
explodingCommonsFiltersExist <- false;
uncommonsTimer <- 0;

//Commons DMG & HP Scaling
CommonDmgMulti <- 1;
CommonHpMulti <- 1;
difficulty_CommonDmgMulti <- 1;
difficulty_CommonHpMulti <- 1;

//Corruption
corruptionCards <- [];
corruptionCards_List <- [];
corruptionCards_ListInf <- [];
corruptionCards_ListMission <- [];
corruptionCards_ListHorde <- [];
corruptionCommons <- null;
corruptionUncommons <- null;
corruptionZSpeed <- null;
corruptionTallboy <- null;
corruptionHocker <- null;
corruptionRetch <- null;
corruptionHazards <- null;
corruptionBoss <- null;
corruptionEnvironmental <- null;
corruptionHordes <- null;
corruptionGameplay <- null;
corruptionPlayer <- null;
corruptionMission <- null;

//Corruption - Specials
specialTallboyType <- null;
specialRetchType <- null;
specialHockerType <- null;
bMonTallboy <- false;
bMonRetch <- false;
bMonHocker <- false;

//Corruption - Biohazard
bBiohazardEnabled <- false;
biohazardTickTime <- 0;
biohazardTickInterval <- 5;
biohazardDamagerPerTick <- 1

//Corruption - Frigid Outskirts
bFrigidOutskirtsEnabled <- false;
bFrigidOutskirtsStormActive <- false;
frigidOutskirtsCalmTime <- 90;
frigidOutskirtsStormTime <- 20;
frigidOutskirtsTimer <- 0;

//Corruption - Hordes
//Special Hordes
::SpecialHordeTimer <- null;
::SpecialHordeTimerDefault <- 120

//Common Hordes
bHuntedEnabled <- false;
::HuntedTimer <- null;
::HuntedTimerDefault <- 180;

bOnslaughtEnabled <- false;
::OnslaughtTimer <- null;
::OnslaughtTimerDefault <- 90;

//Corruption - Missions
missionsCompleted <- {};
missionsCompleted["completed"] <- 0;
MissionSpeedrun_Goal <- 8 * 60;
MissionSpeedrun_Timer <- 0;
MissionGnomeAlone_Status <- 0;
MissionGnomeAlone_CalloutTimerInterval <- 10;
MissionGnomeAlone_CalloutTimer <- MissionGnomeAlone_CalloutTimerInterval;
::MissionSilenceFailed <- false;
MissionSafetyFirstIncaps <- 0;

swarm_stream_chance <- 25;	//Percentage chance

//Corruption - Hazards
::alarmDoorStatus <- {};

//Ammo
ammoShortageMultiplier <- 0.7;
ammo_assaultrifle_max <- 360;
ammo_autoshotgun_max <- 90;
ammo_huntingrifle_max <- 150;
ammo_shotgun_max <- 72;
ammo_smg_max <- 650;
ammo_sniperrifle_max <- 180;

//Use Speed
sluggishMultiplier <- 1.5;
ammo_pack_use_duration <- 3;
cola_bottles_use_duration <- 1.95;
defibrillator_use_duration <- 3;
first_aid_kit_use_duration <- 5;
gas_can_use_duration <- 2;
upgrade_pack_use_duration <- 2;
survivor_revive_duration <- 5;

//Melee
melee_damage <- 400;
shove_damage <- 10;

//Chainsaw
chainsaw_damage <- 100;

//Grenade Launcher
grenadelauncher_damage <- 400;

//Player Cards
::p1Cards <- {};
::p2Cards <- {};
::p3Cards <- {};
::p4Cards <- {};

if (survivorSet == 1)
{
	p1Cards["Bill"] <- 1;
	p2Cards["Zoey"] <- 1;
	p3Cards["Louis"] <- 1;
	p4Cards["Francis"] <- 1;
}
else
{
	p1Cards["Nick"] <- 1;
	p2Cards["Rochelle"] <- 1;
	p3Cards["Coach"] <- 1;
	p4Cards["Ellis"] <- 1;
}

/*
0 - Max HP
1 - RES
2 - Trauma RES
3 - Speed
4 - DMG
5 - Reload
6 - Heal EFF
7 - Melee Speed
*/
::p1Gambler <- [RandomInt(-100, 100), RandomInt(-100, 100), RandomInt(-100, 100), RandomInt(-50, 80), RandomInt(-100, 100), RandomInt(-50, 80), RandomInt(-100, 100), RandomInt(-100, 100)];
::p2Gambler <- [RandomInt(-100, 100), RandomInt(-100, 100), RandomInt(-100, 100), RandomInt(-50, 80), RandomInt(-100, 100), RandomInt(-50, 80), RandomInt(-100, 100), RandomInt(-100, 100)];
::p3Gambler <- [RandomInt(-100, 100), RandomInt(-100, 100), RandomInt(-100, 100), RandomInt(-50, 80), RandomInt(-100, 100), RandomInt(-50, 80), RandomInt(-100, 100), RandomInt(-100, 100)];
::p4Gambler <- [RandomInt(-100, 100), RandomInt(-100, 100), RandomInt(-100, 100), RandomInt(-50, 80), RandomInt(-100, 100), RandomInt(-50, 80), RandomInt(-100, 100), RandomInt(-100, 100)];

cardPickingAllowed <- [0, 0, 0, 0];
cardShuffleVote <- [false, false, false, false];
cardShuffled <- false;
shuffleVoteStarted <- false;
cardReminderInterval <- 20;
cardReminderTimer <- cardReminderInterval;
cardsPerCategory <- 2;
reflexCardsPick <- array(cardsPerCategory);
brawnCardsPick <- array(cardsPerCategory);
disciplineCardsPick <- array(cardsPerCategory);
fortuneCardsPick <- array(cardsPerCategory);
pickableCards <- array(cardsPerCategory * 4);
addictPlaySound <- false;
ConfidentKillerCounter <- 0;
::MethHeadCounter <- [0, 0, 0, 0];
::CleanKillCounter <- [0, 0, 0, 0];
::BreakoutTimer <- [0, 0, 0, 0];
::BreakoutUsed <- [0, 0, 0, 0];
BreakoutTimerDefault <- 2;
cardHudTimeout <- 5;
::AmpedUpCooldown <- 0;
BaseTempHealthDecayRate <- 0.27;
BaseSurvivorIncapDecayRate <- 3;
MaxTraumaDamage <- 20;
TraumaDmg <- [0, 0, 0, 0];
baseShovePenalty <- [0, 0, 0, 0];
experiencedEMT <- [0, 0, 0, 0];

//Stocks
firstLeftCheckpoint <- false;
survivorHealthBuffer <- [0, 0, 0, 0];
survivorReviveCount <- [0, 0, 0, 0];
survivorAtCheckpoint <- [false, false, false, false];
bSurvivorWarped <- false;
::GiveupTimer <- [0, 0, 0, 0];
GiveupTimerDefault <- 3;

///////////////////////////////////////////////
//                  CONVARS                  //
///////////////////////////////////////////////
Convars.SetValue("z_versus_hunter_limit", 0);
Convars.SetValue("z_versus_spitter_limit", 0);
Convars.SetValue("z_ghost_delay_minspawn", 20);
Convars.SetValue("fire_dmginterval", 0.5);

///////////////////////////////////////////////
//             SETTINGS / OPTIONS            //
///////////////////////////////////////////////
swarmTickInterval <- 0.5;				// In seconds
swarmDamagePerTick <- 1;

tankJumpVelocity <- 475;
tankJumpExtraHeight <- 450;			// Max extra height from aiming up

bossClawDmg <- 20;

// INFECTED //
boomerExplosionRange <- 250;
boomerExplosionDamage <- 45;		// Max damage
boomerExplosionKnockback <- 275;	// Max knockback
boomerExplodeTime <- 3;				// In seconds
exploderRunSpeed <- 320;			// Run speed while using explosion ability

tallboyPunchKnockback <- 350;		// Max knockback
tallboyRunSpeed <- 250;

tallboyClawDmg <- 20;
crusherClawDmg <- 5;
bruiserClawDmg <- 17.5;

hockerClawDmg <- 2
stingerClawDmg <- 1
stalkerClawDmg <- 3

retchClawDmg <- 4;
exploderClawDmg <- 8;
reekerClawDmg <- 4;

// COMMON //
acidCommonsMax <- 4;
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

// Base DMG
commonClawDmg <- 2.5;

// UNCOMMON //
uncommonMax <- 7;
uncommonSpawnAmount <- 4;			// Size of group to spawn
uncommonSpawnRate <- 30;			// How often a group will be spawned in seconds
uncommonJimmyMax <- 3;
uncommonJimmySpawnAmount <- 3;			// Size of group to spawn
uncommonFallenMax <- 3;
uncommonFallenSpawnAmount <- 3;			// Size of group to spawn

// HAZARDS //
difficultyHazardMulti <- 1;			// Number of hazards to be scaled with difficulty (Easy (0): 0.5x, Normal (1): 1x, Advanced (2): 1.5x, Expert (3): 2x)
alarmDoorCountMin <- 2;				// Min number of alarm doors to spawn per map
alarmDoorCountMax <- 2;				// Max number of alarm doors to spawn per map
crowGroupCountMin <- 4;				// Mix number of crow groups to spawn
crowGroupCountMax <- 4;				// Max number of crow groups to spawn
sleeperCountMin <- 4;				// Mix number of sleepers to spawn
sleeperCountMax <- 4;				// Max number of sleepers to spawn
explosiveCarHealth <- 1000;			// HP of explosive cars
spawnSnitch <- (RandomFloat(0.1,0.9));
bSnitchSpawned <- false;

// HEALING //
medkitHealAmount <- 50;				// HP healed by first aid kits
pillsHealAmount <- 50;				// HP healed by pain pills
adrenalineHealAmount <- 25;			// HP healed by adrenaline
antibioticHealAmount <- 15;

// PINGING //
pingRange <- 2000;					// Max range for pinging an object
pingDuration <- 8;					// How many seconds do objects stay pinged

// SURVIVOR //
survivorCrawlSpeed <- 30;			// Last Legs base crawl speed

///////////////////////////////////////////////
//              DIRECTOR OPTIONS             //
///////////////////////////////////////////////
MutationOptions <-
{
	ActiveChallenge = 1

	cm_AggressiveSpecials = 0
	
	cm_MaxSpecials = 6 //Game limits max players on server to 18 (Surviors + Infected)
	cm_TankLimit = 2
	cm_WitchLimit = -1
	cm_CommonLimit = 30
	cm_ProhibitBosses = true

	SpecialInitialSpawnDelayMax = RandomInt(60,75)
	SpecialInitialSpawnDelayMin = RandomInt(30,45)
	SpecialRespawnInterval = RandomInt(45,60)

	BoomerLimit = 2
	ChargerLimit = 1
	HunterLimit = 0
	JockeyLimit = 2
	SmokerLimit = 2
	SpitterLimit = 0

	MobMaxPending = 90
	MobSpawnSize = 30
	MegaMobSize = 50
	BileMobSize = 0

	EscapeSpawnTanks = false
	SurvivorMaxIncapacitatedCount = 2
	
	TempHealthDecayRate = BaseTempHealthDecayRate
}

///////////////////////////////////////////////
//             DIFFICULTY OPTIONS            //
///////////////////////////////////////////////
function SetDifficulty()
{
	difficulty = GetDifficulty();

	switch(difficulty)
	{
		//Easy
		case 0:
			BaseMaxIncaps = 3;
			MaxTraumaDamage = 0;
			stagger_dmg = 4000;
			MutationOptions.MobSpawnSize = 30;
			MutationOptions.MegaMobSize = 50;
			difficulty_CommonDmgMulti = 0.5;
			difficulty_CommonHpMulti = 0.75;
			difficulty_SpecialDmgMulti = 0.5;
			difficulty_SpecialHpMulti = 0.75;
			difficultyHazardMulti = 0.5;
		break;

		//Normal
		case 1:
			BaseMaxIncaps = 3;
			MaxTraumaDamage = 20;
			stagger_dmg = 4000;
			MutationOptions.MobSpawnSize = 30;
			MutationOptions.MegaMobSize = 50;
			difficulty_CommonDmgMulti = 1;
			difficulty_CommonHpMulti = 1;
			difficulty_SpecialDmgMulti = 1;
			difficulty_SpecialHpMulti = 1;
			difficultyHazardMulti = 1;
		break;

		//Advanced
		case 2:
			BaseMaxIncaps = 2;
			MaxTraumaDamage = 30;
			stagger_dmg = 10000;
			MutationOptions.MobSpawnSize = 35;
			MutationOptions.MegaMobSize = 60;
			difficulty_CommonDmgMulti = 2;
			difficulty_CommonHpMulti = 1.5;
			difficulty_SpecialDmgMulti = 1.5;
			difficulty_SpecialHpMulti = 1.25;
			difficultyHazardMulti = 1.5;
		break;

		//Expert
		case 3:
			BaseMaxIncaps = 2;
			MaxTraumaDamage = 40;
			stagger_dmg = 10000;
			MutationOptions.MobSpawnSize = 40;
			MutationOptions.MegaMobSize = 70;
			difficulty_CommonDmgMulti = 4;
			difficulty_CommonHpMulti = 2;
			difficulty_SpecialDmgMulti = 2;
			difficulty_SpecialHpMulti = 1.5;
			difficultyHazardMulti = 2;
		break;
	}

	switch(specialTallboyType)
	{
		case "Tallboy":
			Convars.SetValue("z_charger_health", (725 * TallboyHpMulti * difficulty_SpecialHpMulti));
		break;
		case "Crusher":
			Convars.SetValue("z_charger_health", (806 * TallboyHpMulti * difficulty_SpecialHpMulti));
		break;
		case "Bruiser":
			Convars.SetValue("z_charger_health", (1021 * TallboyHpMulti * difficulty_SpecialHpMulti));
		break;
	}

	switch(specialRetchType)
	{
		case "Retch":
		case "Exploder":
			Convars.SetValue("z_exploding_health", (376 * RetchHpMulti * difficulty_SpecialHpMulti));
		break;
		case "Reeker":
			Convars.SetValue("z_exploding_health", (430 * RetchHpMulti * difficulty_SpecialHpMulti));
		break;
	}

	switch(specialHockerType)
	{
		case "Hocker":
		case "Stinger":
			Convars.SetValue("z_exploding_health", (161 * HockerHpMulti * difficulty_SpecialHpMulti));
		break;
		case "Stalker":
			Convars.SetValue("z_exploding_health", (241 * HockerHpMulti * difficulty_SpecialHpMulti));
		break;
	}

	Convars.SetValue("z_witch_health", 1000);
	Convars.SetValue("z_health", 50 * (CommonHpMulti * difficulty_CommonHpMulti));

	Convars.SetValue("z_charge_max_damage", (5 * TallboyDmgMulti * difficulty_SpecialDmgMulti));
	Convars.SetValue("z_charger_pound_dmg", (5 * TallboyDmgMulti * difficulty_SpecialDmgMulti));
}

MutationOptions.SurvivorMaxIncapacitatedCount = BaseMaxIncaps;