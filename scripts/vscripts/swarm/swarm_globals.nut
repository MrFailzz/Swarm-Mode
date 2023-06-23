///////////////////////////////////////////////
//            GLOBALS / CONSTANTS            //
///////////////////////////////////////////////
//Globals
difficulty <- GetDifficulty();
survivorSet <- Director.GetSurvivorSet();
z_speed <- Convars.GetFloat("z_speed");
BaseMaxIncaps <- 2

//Breaker
tankModel <- "models/infected/hulk.mdl"
randomPct <- RandomInt(1,100)
spawnBoss <- RandomFloat(0.1,0.9)
spawnBreaker <- RandomFloat(0.1,0.9)
spawnOgre <- RandomFloat(0.1,0.9)
bSwarmCircleActive <- false;
swarmTickTime <- 0;
swarmOrigin <- null;
safeSurvivors <- array(4);

//Tank HUD
bTankHudExists <- false;
tankHudTankID <- null;

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

//Corruption
corruptionCards <- array(1, null);
corruptionCards_List <- array(1, null);
corruptionCards_ListInf <- array(1, null);
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

//Corruption - Specials
TallboyHordeEnabled <- false;
CrusherHordeEnabled <- false;
BruiserHordeEnabled <- false;
StalkerHordeEnabled <- false;
HockerHordeEnabled <- false;
ExploderHordeEnabled <- false;
RetchHordeEnabled <- false;
SpecialHordeTimer <- null;

//Corruption - Frigid Outskirts
frigidOutskirtsEnabled <- false;
frigidOutskirtsStormActive <- false;
frigidOutskirtsCalmTime <- 90;
frigidOutskirtsStormTime <- 20;
frigidOutskirtsTimer <- 0;

//Corruption - Hunted
HuntedEnabled <- false;
HuntedTimer <- null;

//Corruption - Onslaught
OnslaughtEnabled <- false;
OnslaughtTimer <- null;

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

//Chainsaw
chainsaw_damage <- 100;
chainsaw_attack_distance <- 50;

//Grenade Launcher
grenadelauncher_radius_stumble <- 250;
grenadelauncher_radius_kill <- 180;
grenadelauncher_damage <- 400;

//Infected Fire Timer
extinguish_time <- 0;

//Ogre Stagger
stagger_dmg <- null;

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

/*[0 - Max HP
1 - RES
2 - Trauma RES
3 - Speed
4 - DMG
5 - Reload
6 - Heal EFF]*/
p1Gambler <- [RandomInt(-100, 100), RandomInt(-100, 100), RandomInt(-100, 100), RandomInt(-100, 100), RandomInt(-100, 100), RandomInt(-100, 100), RandomInt(-100, 100)];
p2Gambler <- [RandomInt(-100, 100), RandomInt(-100, 100), RandomInt(-100, 100), RandomInt(-100, 100), RandomInt(-100, 100), RandomInt(-100, 100), RandomInt(-100, 100)];
p3Gambler <- [RandomInt(-100, 100), RandomInt(-100, 100), RandomInt(-100, 100), RandomInt(-100, 100), RandomInt(-100, 100), RandomInt(-100, 100), RandomInt(-100, 100)];
p4Gambler <- [RandomInt(-100, 100), RandomInt(-100, 100), RandomInt(-100, 100), RandomInt(-100, 100), RandomInt(-100, 100), RandomInt(-100, 100), RandomInt(-100, 100)];

cardPickingAllowed <- [false, false, false, false];
cardsPerCategory <- 2;
reflexCardsPick <- array(cardsPerCategory);
brawnCardsPick <- array(cardsPerCategory);
disciplineCardsPick <- array(cardsPerCategory);
fortuneCardsPick <- array(cardsPerCategory);
pickableCards <- array(cardsPerCategory * 4);
addictPlaySound <- false;
ConfidentKillerCounter <- 0;
MethHeadCounter <- [0, 0, 0, 0];
cardHudTimeout <- 0;
::AmpedUpCooldown <- 0;
BaseTempHealthDecayRate <- 0.27;
BaseSurvivorIncapDecayRate <- 3;
MaxTraumaDamage <- 20;

//Specials
bChargerSpawned <- false;

//Stocks
firstLeftCheckpoint <- false;
survivorHealthBuffer <- [0, 0, 0, 0];

///////////////////////////////////////////////
//                  CONVARS                  //
///////////////////////////////////////////////
Convars.SetValue("z_versus_hunter_limit", 0);
Convars.SetValue("z_versus_spitter_limit", 0);
Convars.SetValue("z_ghost_delay_minspawn", 20);

///////////////////////////////////////////////
//              DIRECTOR OPTIONS             //
///////////////////////////////////////////////
DirectorOptions <-
{
	ActiveChallenge = 1

	cm_AggressiveSpecials = 0
	
	cm_DominatorLimit = 4
	cm_MaxSpecials = 13 //For sleepers, was 4 previously. Game limits max players on server to 18
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
	BileMobSize = 0

	TankHitDamageModifierCoop = 1
	EscapeSpawnTanks = false
	SurvivorMaxIncapacitatedCount = 2
	
	TempHealthDecayRate = BaseTempHealthDecayRate
}

///////////////////////////////////////////////
//             DIFFICULTY OPTIONS            //
///////////////////////////////////////////////
switch(difficulty)
{
	//Easy
	case 0:
		Convars.SetValue("z_jockey_health", 361);
		Convars.SetValue("z_gas_health", 297);
		Convars.SetValue("z_exploding_health", 595);
		Convars.SetValue("z_witch_health", 850);
		BaseMaxIncaps = 3;
		MaxTraumaDamage = 0;
		stagger_dmg = 4000;
	break;

	//Normal
	case 1:
		Convars.SetValue("z_jockey_health", 361);
		Convars.SetValue("z_gas_health", 297);
		Convars.SetValue("z_exploding_health", 595);
		Convars.SetValue("z_witch_health", 850);
		BaseMaxIncaps = 2;
		MaxTraumaDamage = 20;
		stagger_dmg = 4000;
	break;

	//Advanced
	case 2:
		Convars.SetValue("z_jockey_health", 425);
		Convars.SetValue("z_gas_health", 350);
		Convars.SetValue("z_exploding_health", 700);
		Convars.SetValue("z_witch_health", 1000);
		BaseMaxIncaps = 2;
		MaxTraumaDamage = 30;
		stagger_dmg = 10000;
	break;

	//Expert
	case 3:
		Convars.SetValue("z_jockey_health", 425);
		Convars.SetValue("z_gas_health", 350);
		Convars.SetValue("z_exploding_health", 700);
		Convars.SetValue("z_witch_health", 1000);
		BaseMaxIncaps = 1;
		MaxTraumaDamage = 40;
		stagger_dmg = 10000;
		DirectorOptions.TankHitDamageModifierCoop = 0.48;
	break;
}

DirectorOptions.SurvivorMaxIncapacitatedCount = BaseMaxIncaps;

///////////////////////////////////////////////
//              GAMEMODE OPTIONS             //
///////////////////////////////////////////////
if (swarmMode == "hardcore" || swarmMode == "survival" || swarmMode == "vs" || swarmMode == "survival_vs")
{
	DirectorOptions.cm_TankLimit = 2
}

///////////////////////////////////////////////
//             SETTINGS / OPTIONS            //
///////////////////////////////////////////////
swarmTickInterval <- 1;				// In seconds
swarmDamagePerTick <- 2;

tankJumpVelocity <- 500;
tankJumpExtraHeight <- 450;			// Max extra height from aiming up

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
exploderRunSpeed <- 320;			// Run speed while using explosion ability

tallboyPunchKnockback <- 350;		// Max knockback
tallboyRunSpeed <- 210;

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

// UNCOMMON //
uncommonMax <- 7;
uncommonSpawnAmount <- 4;			// Size of group to spawn
uncommonSpawnRate <- 30;			// How often a group will be spawned in seconds
uncommonJimmyMax <- 3;
uncommonJimmySpawnAmount <- 3;			// Size of group to spawn
uncommonFallenMax <- 3;
uncommonFallenSpawnAmount <- 3;			// Size of group to spawn

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

// SURVIVOR //
survivorCrawlSpeed <- 30			// Last Legs base crawl speed
