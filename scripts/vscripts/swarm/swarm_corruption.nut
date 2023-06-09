///////////////////////////////////////////////
//              CORRUPTION CARDS             //
///////////////////////////////////////////////
corruptionCards <- array(1, null);
corruptionCommons <- null;
corruptionUncommons <- null;
corruptionZSpeed <- null;
corruptionHazards <- null;
corruptionEnvironmental <- null;
corruptionHordes <- null;
corruptionGameplay <- null;
corruptionPlayer <- null;
corruptionTallboy <- null;
corruptionHocker <- null;
corruptionRetch <- null;

function InitCorruptionCards()
{
	corruptionCards.clear();

	// Special Commons
	local cardsCommons = array(1, null);
	cardsCommons.clear();
	// Always choose a special common type on expert
	if (difficulty != 3)
	{
		cardsCommons.append("None");
	}
	cardsCommons.append("commonAcid");
	cardsCommons.append("commonFire");
	cardsCommons.append("commonExplode");
	corruptionCommons = ChooseCorruptionCard(cardsCommons);

	// Uncommons
	local cardsUncommons = array(1, null);
	cardsUncommons.clear();
	cardsUncommons.append("None");
	cardsUncommons.append("None");
	cardsUncommons.append("None");
	cardsUncommons.append("uncommonClown");
	cardsUncommons.append("uncommonRiot");
	cardsUncommons.append("uncommonMud");
	cardsUncommons.append("uncommonCeda");
	cardsUncommons.append("uncommonConstruction");
	cardsUncommons.append("uncommonJimmy");
	corruptionUncommons = ChooseCorruptionCard(cardsUncommons);

	// ZSpeed
	local cardsZSpeed = array(1, null);
	cardsZSpeed.clear();
	if (difficulty < 1)
	{
		cardsZSpeed.append("commonShamble");
		cardsZSpeed.append("commonShamble");
		cardsZSpeed.append("commonShamble");
		cardsZSpeed.append("commonShamble");
	}
	cardsZSpeed.append("commonRunning");
	cardsZSpeed.append("commonRunning");
	cardsZSpeed.append("commonBlitzing");
	corruptionZSpeed = ChooseCorruptionCard(cardsZSpeed);

	// Tallboys
	local cardsTallboy = array(1, null);
	cardsTallboy.clear();
	cardsTallboy.append("Tallboy");
	cardsTallboy.append("Crusher");
	cardsTallboy.append("Bruiser");
	corruptionTallboy = ChooseCorruptionCard(cardsTallboy);
	ApplyTallboyCard();

	// Hockers
	local cardsHocker = array(1, null);
	cardsHocker.clear();
	cardsHocker.append("Hocker");
	cardsHocker.append("Stalker");
	corruptionHocker = ChooseCorruptionCard(cardsHocker);
	ApplyHockerCard();

	// Retches
	local cardsRetch = array(1, null);
	cardsRetch.clear();
	cardsRetch.append("Retch");
	cardsRetch.append("Exploder");
	corruptionRetch = ChooseCorruptionCard(cardsRetch);
	ApplyRetchCard();

	// Hazards
	local cardsHazards = array(1, null);
	cardsHazards.clear();
	cardsHazards.append("None");
	if (IsMissionFinalMap() == false)
	{
		cardsHazards.append("None");
		cardsHazards.append("hazardBirds");
		cardsHazards.append("hazardLockdown");
		cardsHazards.append("hazardSleepers");
	}
	corruptionHazards = ChooseCorruptionCard(cardsHazards);

	// Environmental
	local cardsEnvironmental = array(1, null);
	cardsEnvironmental.clear();
	cardsEnvironmental.append("None");
	cardsEnvironmental.append("None");
	cardsEnvironmental.append("None");
	cardsEnvironmental.append("None");
	cardsEnvironmental.append("None");
	cardsEnvironmental.append("None");

	if ( Director.IsSinglePlayerGame() )
	{
		cardsEnvironmental.append("environmentDark");
		cardsEnvironmental.append("environmentFog");
		cardsEnvironmental.append("environmentFrozen");
	}
	corruptionEnvironmental = ChooseCorruptionCard(cardsEnvironmental);
	ApplyEnvironmentalCard();

	// Hordes
	local cardsHordes = array(1, null);
	cardsHordes.clear();
	cardsHordes.append("None");
	// Only allow horde cards on non-finale levels?
	if ( IsMissionFinalMap() == false && difficulty > 1)
	{
		cardsHordes.append("None");
		cardsHordes.append("None");
		cardsHordes.append("None");
		cardsHordes.append("None");
		cardsHordes.append("None");
		cardsHordes.append("None");
		cardsHordes.append("None");
		cardsHordes.append("hordeHunted");
		cardsHordes.append("hordeHunted");
		cardsHordes.append("hordeHunted");
		cardsHordes.append("hordeHunted");
		cardsHordes.append("hordeOnslaught");
		cardsHordes.append("hordeOnslaught");
		cardsHordes.append("hordeOnslaught");
		cardsHordes.append("hordeDuringBoss");

		if (corruptionTallboy == "Bruiser")
		{
			cardsHordes.append("hordeBruiser");
		}
		if (corruptionHocker == "Stalker")
		{
			cardsHordes.append("hordeStalker");
		}
		if (corruptionHocker == "Hocker")
		{
			cardsHordes.append("hordeHocker");
		}
		if (corruptionRetch == "Exploder")
		{
			cardsHordes.append("hordeExploder");
		}
		if (corruptionRetch == "Retch")
		{
			cardsHordes.append("hordeRetch");
		}
	}
	corruptionHordes = ChooseCorruptionCard(cardsHordes);
	ApplyHordeCard();

	// Gameplay
	local cardsGameplay = array(1, null);
	cardsGameplay.clear();
	cardsGameplay.append("None");
	cardsGameplay.append("None");
	cardsGameplay.append("gameplayNoGrenades");
	cardsGameplay.append("gameplayNoOutlines");
	if ( difficulty > 1 )
	{
		cardsGameplay.append("None");
		cardsGameplay.append("None");
		cardsGameplay.append("gameplayNoSupport");
		cardsGameplay.append("gameplayNoRespawn");
	}
	corruptionGameplay = ChooseCorruptionCard(cardsGameplay);
	ApplyGameplayCard();

	// Player
	local cardsPlayer = array(1, null);
	cardsPlayer.clear();
	cardsPlayer.append("None");
	if ( difficulty > 1 )
	{
		cardsPlayer.append("None");
		cardsPlayer.append("None");
		cardsPlayer.append("playerLessAmmo");
		cardsPlayer.append("playerFatigue");
	}
	corruptionPlayer = ChooseCorruptionCard(cardsPlayer);
	ApplyPlayerCorruptionCard();

	GetCorruptionCardsString();
}

function ChooseCorruptionCard(cardArray)
{
	local cardSlot = cardArray[RandomInt(0, cardArray.len() - 1)];
	corruptionCards.append(cardSlot);

	return cardSlot;
}

function GetCorruptionCardsString()
{
	local returnString = "CORRUPTION CARDS";
	local cardName = null;
	local i = 0;

	foreach(cardID in corruptionCards)
	{
		cardName = GetCorruptionCardName(cardID);

		if (cardName != "None")
		{
			returnString = returnString + "\n" + cardName;
			i++;
		}
	}

	swarmHUD.Fields["corruptionCards"].dataval = returnString;
	HUDPlace(HUD_FAR_RIGHT, 1 - swarmHudW - swarmHudX, swarmHudY, swarmHudW, swarmHudH + (swarmHudLineH * (i == 0 ? 1 : i)));
}

function PrintCorruptionCards()
{
	local cardName = null;
	foreach(cardID in corruptionCards)
	{
		cardName = GetCorruptionCardName(cardID);

		if (cardName != "None")
		{
			ClientPrint(null, 3, "\x04" + "Corruption Card: " + "\x01" + cardName);
		}
	}
}

function GetCorruptionCardName(cardID)
{
	switch(cardID)
	{
		case "None":
			return "None";
			break;
		case "commonAcid":
			return "Acid Commons";
			break;
		case "commonFire":
			return "Fire Commons";
			break;
		case "commonExplode":
			return "Exploding Commons";
			break;
		case "hazardBirds":
			return "The Birds";
			break;
		case "hazardLockdown":
			return "The Lockdown";
			break;
		case "hazardSleepers":
			return "Slumber Party";
			break;
		case "environmentDark":
			return "The Dark";
			break;
		case "environmentFog":
			return "The Fog";
			break;
		case "environmentFrozen":
			return "Frigid Outskirts";
			break;
		case "hordeHunted":
			return "Hunted";
			break;
		case "hordeOnslaught":
			return "Onslaught";
			break;
		case "hordeBruiser":
			return "Bruiser Hordes";
			break;
		case "hordeStalker":
			return "Stalker Hordes";
			break;
		case "hordeHocker":
			return "Hocker Hordes";
			break;
		case "hordeExploder":
			return "Exploder Hordes";
			break;
		case "hordeRetch":
			return "Retch Hordes";
			break;
		case "hordeDuringBoss":
			return "Raging Swarm";
			break;
		case "gameplayNoGrenades":
			return "Empty Pockets";
			break;
		case "gameplayNoOutlines":
			return "No Outlines";
			break;
		case "gameplayNoSupport":
			return "Survival of the Fittest";
			break;
		case "gameplayNoRespawn":
			return "Do or Die";
			break;
		case "playerLessAmmo":
			return "Ammo Shortage";
			break;
		case "playerFatigue":
			return "Fatigue";
			break;
		case "uncommonClown":
			return "Clown Show";
			break;
		case "uncommonRiot":
			return "Crowd Control";
			break;
		case "uncommonMud":
			return "Mud Crawlers";
			break;
		case "uncommonCeda":
			return "CEDA Operatives";
			break;
		case "uncommonConstruction":
			return "Building Site";
			break;
		case "uncommonJimmy":
			return "Jimmy Gibbs and Cousins";
			break;
		case "commonShamble":
			return "Shambling Commons";
			break;
		case "commonRunning":
			return "Running Commons";
			break;
		case "commonBlitzing":
			return "Blitzing Commons";
			break;
		case "Tallboy":
			return "Tallboys";
			break;
		case "Crusher":
			return "Crushers";
			break;
		case "Bruiser":
			return "Bruisers";
			break;
		case "Hocker":
			return "Hockers";
			break;
		case "Stalker":
			return "Stalkers";
			break;
		case "Retch":
			return "Retches";
			break;
		case "Exploder":
			return "Exploders";
			break;
		default:
			return "None";
			break;
	}
	
	return "None";
}

///////////////////////////////////////////////
//            ENVIRONMENTAL CARDS            //
///////////////////////////////////////////////
function ApplyEnvironmentalCard()
{
	ResetFogCvars();
	switch(corruptionEnvironmental)
	{
		case "None":
			break;
		case "environmentDark":
			CorruptionCard_TheDark();
			break;
		case "environmentFog":
			CorruptionCard_TheFog();
			break;
		case "environmentFrozen":
			CorruptionCard_FrigidOutskirts();
			break;
	}
}

function SetFogCvar(cvar, value)
{
    Convars.SetValue(cvar, value);
    SendToServerConsole(cvar + " " + value)
}

function ResetFogCvars()
{
	SetFogCvar("fog_color", "-1 -1 -1");
	SetFogCvar("fog_colorskybox", "-1 -1 -1");
	SetFogCvar("fog_start", "1200");
	SetFogCvar("fog_startskybox", "-10000");
	SetFogCvar("fog_end", "2400");
	SetFogCvar("fog_endskybox", "-10000");
	SetFogCvar("r_flashlightconstant", "0");
	SetFogCvar("r_flashlightbrightness", "0.25");
	SetFogCvar("mat_force_tonemap_scale", "0");
}

function CorruptionCard_TheDark()
{
	SetFogCvar("fog_color", "1 1 1");
	SetFogCvar("fog_colorskybox", "1 1 1");
	SetFogCvar("fog_start", "242");
	SetFogCvar("fog_startskybox", "-10000");
	SetFogCvar("fog_end", "730");
	SetFogCvar("fog_endskybox", "-10000");
	SetFogCvar("r_flashlightconstant", "0.25");
	SetFogCvar("r_flashlightbrightness", "10");
	SetFogCvar("mat_force_tonemap_scale", "0.8");
	
	local fog = null;
	while ((fog = Entities.FindByClassname(fog, "env_fog_controller")) != null)
	{
		DoEntFire("!self", "SetStartDist", "242", 0, fog, fog);
		DoEntFire("!self", "SetEndDist", "730", 0, fog, fog);
	}

	local sun = null;
	while ((sun = Entities.FindByClassname(sun, "env_sun")) != null)
	{
		sun.Kill();
	}
}

function CorruptionCard_TheFog()
{
	SetFogCvar("fog_start", "242");
	SetFogCvar("fog_startskybox", "-10000");
	SetFogCvar("fog_end", "730");
	SetFogCvar("fog_endskybox", "-10000");
	SetFogCvar("r_flashlightbrightness", "2");

	local fog = null;
	while ((fog = Entities.FindByClassname(fog, "env_fog_controller")) != null)
	{
		DoEntFire("!self", "SetStartDist", "242", 0, fog, fog);
		DoEntFire("!self", "SetEndDist", "730", 0, fog, fog);
	}
}

// Frigid Outskirts
frigidOutskirtsEnabled <- false;
frigidOutskirtsStormActive <- false;
frigidOutskirtsCalmTime <- 90;
frigidOutskirtsStormTime <- 20;
frigidOutskirtsTimer <- 0;

function CorruptionCard_FrigidOutskirts()
{
	if (!IsSoundPrecached("ambient\\wind\\windgust.wav"))
		PrecacheSound("ambient\\wind\\windgust.wav");

	SetFogCvar("fog_color", "174 196 209");
	SetFogCvar("fog_colorskybox", "174 196 209");
	FrigidOutskirtsSetFog("0", "1400");
	
	local windSound = SpawnEntityFromTable("ambient_generic",
	{
		targetname = "__frigid_outskirts_wind_snd",
		origin = Vector(0, 0, 0),
		spawnflags = 17,
		message = "ambient\\wind\\windgust.wav",
		radius = 10000,
		health = 10
	});
	local windSound = SpawnEntityFromTable("ambient_generic",
	{
		targetname = "__frigid_outskirts_wind_snd",
		origin = Vector(0, 0, 0),
		spawnflags = 17,
		message = "ambient\\wind\\windgust.wav",
		radius = 10000,
		health = 10
	});
	local windSound = SpawnEntityFromTable("ambient_generic",
	{
		targetname = "__frigid_outskirts_wind_snd2",
		origin = Vector(0, 0, 0),
		spawnflags = 17,
		message = "ambient\\wind\\windgust.wav",
		radius = 10000,
		health = 10
	});
	local windSound = SpawnEntityFromTable("ambient_generic",
	{
		targetname = "__frigid_outskirts_wind_snd2",
		origin = Vector(0, 0, 0),
		spawnflags = 17,
		message = "ambient\\wind\\windgust.wav",
		radius = 10000,
		health = 10
	});

	frigidOutskirtsEnabled = true;
}

function FrigidOutskirtsSetFog(fogStart, fogEnd)
{
	SetFogCvar("fog_start", fogStart);
	SetFogCvar("fog_startskybox", fogStart);
	SetFogCvar("fog_end", fogEnd);
	SetFogCvar("fog_endskybox", fogEnd);

	if (frigidOutskirtsStormActive == true)
	{
		EntFire("__frigid_outskirts_wind_snd", "PlaySound", "", 3);
		EntFire("__frigid_outskirts_wind_snd2", "PlaySound", "", 10);
		SetFogCvar("r_flashlightbrightness", "2");
	}
	else
	{
		EntFire("__frigid_outskirts_wind_snd", "StopSound");
		EntFire("__frigid_outskirts_wind_snd2", "StopSound");
		SetFogCvar("r_flashlightbrightness", "0.5");
	}
}

function FrigidOutskirtsTimer()
{
	if (frigidOutskirtsEnabled == false)
	{
		frigidOutskirtsTimer = Time();
		return;
	}

	if (frigidOutskirtsStormActive == false)
	{
		if ((Time() - frigidOutskirtsTimer) >= frigidOutskirtsCalmTime)
		{
			frigidOutskirtsStormActive = true;
			FrigidOutskirtsSetFog("-250", "600");
			frigidOutskirtsTimer = Time();
		}
	}
	else
	{
		if ((Time() - frigidOutskirtsTimer) >= frigidOutskirtsStormTime)
		{
			frigidOutskirtsStormActive = false;
			FrigidOutskirtsSetFog("0", "1400");
			frigidOutskirtsTimer = Time();
		}
	}
}

///////////////////////////////////////////////
//                HORDE CARDS                //
///////////////////////////////////////////////
function ApplyHordeCard()
{
	//ResetHordeCvars();
	switch(corruptionHordes)
	{
		case "None":
			break;
		case "hordeHunted":
			CorruptionCard_Hunted();
			break;
		case "hordeOnslaught":
			CorruptionCard_Onslaught();
			break;
		case "hordeBruiser":
			CorruptionCard_BruiserHordes();
			break;
		case "hordeStalker":
			CorruptionCard_StalkerHordes();
			break;
		case "hordeHocker":
			CorruptionCard_HockerHordes();
			break;
		case "hordeExploder":
			CorruptionCard_ExploderHordes();
			break;
		case "hordeRetch":
			CorruptionCard_RetchHordes();
			break;
	}
}

/*function ResetHordeCvars()
{
	HuntedEnabled = false;
	OnslaughtEnabled = false;
}*/

// Hunted
HuntedEnabled <- false;
HuntedTimer <- Time() + 180 + 30;

function CorruptionCard_Hunted()
{
	HuntedEnabled = true
}

function HuntedTimerFunc()
{
	if (HuntedTimer < Time())
	{
		SpawnMob(2);
		HuntedTimer = Time() + 180;
	}
	else if (HuntedTimer < Time() + 5)
	{
		ClientPrint(null, 3, "\x04" + "Hunted: " + "\x01 Prepare for the horde in \x04" + ceil(HuntedTimer - Time()) + "...");
	}
}

// Onslaught
OnslaughtEnabled <- false;
OnslaughtTimer <- Time() + 90 + 30;

function CorruptionCard_Onslaught()
{
	OnslaughtEnabled = true
	DirectorOptions.cm_CommonLimit = 50
}

function OnslaughtTimerFunc()
{
	if (OnslaughtTimer < Time())
	{
		SpawnMob(2);
		OnslaughtTimer = Time() + 90;
	}
	else if (OnslaughtTimer < Time() + 5)
	{
		ClientPrint(null, 3, "\x04" + "Onslaught: " + "\x01 Prepare for the horde in \x04" + ceil(OnslaughtTimer - Time()) + "...");
	}
}

BruiserHordeEnabled <- false;
StalkerHordeEnabled <- false;
HockerHordeEnabled <- false;
ExploderHordeEnabled <- false;
RetchHordeEnabled <- false;
SpecialHordeTimer <- Time() + 60;

function CorruptionCard_BruiserHordes()
{
	BruiserHordeEnabled = true
	DirectorOptions.cm_AggressiveSpecials = 1
}

function BruiserTimerFunc(count = 6, zType = 6)
{
	if (SpecialHordeTimer < Time())
	{
		local i = 0;
		while (i < count)
		{
			ZSpawn({type = zType});
			i++;
		}
	}
	else if (SpecialHordeTimer < Time() + 5)
	{
		ClientPrint(null, 3, "\x04" + "Onslaught: " + "\x01 Prepare for the horde in \x04" + ceil(SpecialHordeTimer - Time()) + "...");
	}
}

function CorruptionCard_StalkerHordes()
{
	StalkerHordeEnabled = true
	DirectorOptions.cm_AggressiveSpecials = 1
}

function StalkerTimerFunc(count = 6, zType = 5)
{
	if (SpecialHordeTimer < Time())
	{
		local i = 0;
		while (i < count)
		{
			ZSpawn({type = zType});
			i++;
		}
	}
	else if (SpecialHordeTimer < Time() + 5)
	{
		ClientPrint(null, 3, "\x04" + "Onslaught: " + "\x01 Prepare for the horde in \x04" + ceil(SpecialHordeTimer - Time()) + "...");
	}
}

function CorruptionCard_HockerHordes()
{
	HockerHordeEnabled = true
	DirectorOptions.cm_AggressiveSpecials = 1
}

function HockerTimerFunc(count = 6, zType = 1)
{
	if (SpecialHordeTimer < Time())
	{
		local i = 0;
		while (i < count)
		{
			ZSpawn({type = zType});
			i++;
		}
	}
	else if (SpecialHordeTimer < Time() + 5)
	{
		ClientPrint(null, 3, "\x04" + "Onslaught: " + "\x01 Prepare for the horde in \x04" + ceil(SpecialHordeTimer - Time()) + "...");
	}
}

function CorruptionCard_ExploderHordes()
{
	ExploderHordeEnabled = true
	DirectorOptions.cm_AggressiveSpecials = 1
}

function ExploderTimerFunc(count = 6, zType = 2)
{
	if (SpecialHordeTimer < Time())
	{
		local i = 0;
		while (i < count)
		{
			ZSpawn({type = zType});
			i++;
		}
	}
	else if (SpecialHordeTimer < Time() + 5)
	{
		ClientPrint(null, 3, "\x04" + "Onslaught: " + "\x01 Prepare for the horde in \x04" + ceil(SpecialHordeTimer - Time()) + "...");
	}
}


function CorruptionCard_RetchHordes()
{
	RetchHordeEnabled = true
	DirectorOptions.cm_AggressiveSpecials = 1
}

function RetchTimerFunc(count = 6, zType = 2)
{
	if (SpecialHordeTimer < Time())
	{
		local i = 0;
		while (i < count)
		{
			ZSpawn({type = zType});
			i++;
		}
	}
	else if (SpecialHordeTimer < Time() + 5)
	{
		ClientPrint(null, 3, "\x04" + "Onslaught: " + "\x01 Prepare for the horde in \x04" + ceil(SpecialHordeTimer - Time()) + "...");
	}
}


///////////////////////////////////////////////
//              GAMEPLAY CARDS               //
///////////////////////////////////////////////
function ApplyGameplayCard()
{
	ResetGameplayCvars();
	switch(corruptionGameplay)
	{
		case "None":
			break;
		case "gameplayNoOutlines":
			CorruptionCard_NoOutlines();
			break;
		case "gameplayNoRespawn":
			CorruptionCard_OneLife();
			break;
		case "gameplayNoGrenades":
			CorruptionCard_NoOffense();
			break;
		case "gameplayNoSupport":
			CorruptionCard_NoSupport();
			break;
	}
}

function ResetGameplayCvars()
{
	Convars.SetValue("sv_disable_glow_survivors", 0);
	Convars.SetValue("sv_disable_glow_faritems", 0);
	Convars.SetValue("sv_rescue_disabled", 0)
}

function CorruptionCard_NoOutlines()
{
	Convars.SetValue("sv_disable_glow_survivors", 1);
	Convars.SetValue("sv_disable_glow_faritems", 1);
}

function CorruptionCard_OneLife()
{
	Convars.SetValue("sv_rescue_disabled", 1)
}

function CorruptionCard_NoOffense()
{
	local ItemstoRemove_ModelPaths =
	[
		"models/w_models/weapons/w_eq_molotov.mdl",
		"models/w_models/weapons/w_eq_pipebomb.mdl",
		"models/w_models/weapons/w_eq_bile_flask.mdl",
		"models/w_models/weapons/w_eq_explosive_ammopack.mdl",
		"models/w_models/weapons/w_eq_incendiary_ammopack.mdl",
	];

	foreach(modelpath in ItemstoRemove_ModelPaths)
	{
		local weapon_ent = null;
		while(weapon_ent = Entities.FindByModel(weapon_ent, modelpath))
			weapon_ent.Kill();
	}
}

function CorruptionCard_NoSupport()
{
	local ItemstoRemove_ModelPaths =
	[
		"models/w_models/weapons/w_eq_defibrillator.mdl",
		"models/w_models/weapons/w_eq_medkit.mdl",
		"models/w_models/weapons/w_eq_adrenaline.mdl",
		"models/w_models/weapons/w_eq_painpills.mdl",
	];
	foreach(modelpath in ItemstoRemove_ModelPaths)
	{
		local weapon_ent = null;
		while(weapon_ent = Entities.FindByModel(weapon_ent, modelpath))
			weapon_ent.Kill();
	}
}

function CorruptionDropItems()
{
	local player = null;
	switch(corruptionGameplay)
	{
		case "gameplayNoGrenades":
			while(player = Entities.FindByClassname(player, "player"))
			{
				player.DropItem("weapon_molotov");
				player.DropItem("weapon_pipe_bomb");
				player.DropItem("weapon_vomitjar");
				player.DropItem("weapon_upgradepack_explosive");
				player.DropItem("weapon_upgradepack_incendiary");
			}
			CorruptionCard_NoOffense();
			break;
		case "gameplayNoSupport":
			while(player = Entities.FindByClassname(player, "player"))
			{
				player.DropItem("weapon_pain_pills");
				player.DropItem("weapon_adrenaline");
				player.DropItem("weapon_defibrillator");
				player.DropItem("weapon_first_aid_kit");
			}
			CorruptionCard_NoSupport();
			break;
	}
}

///////////////////////////////////////////////
//               PLAYER CARDS                //
///////////////////////////////////////////////
function ApplyPlayerCorruptionCard()
{
	ResetPlayerCvars();
	switch(corruptionPlayer)
	{
		case "None":
			break;
		case "playerLessAmmo":
			CorruptionCard_ReducedAmmo();
			break;
		case "playerFatigue":
			CorruptionCard_Sluggish();
			break;
	}
}

ammoShortageMultiplier <- 0.7;
ammo_assaultrifle_max <- 360;
ammo_autoshotgun_max <- 90;
ammo_huntingrifle_max <- 150;
ammo_shotgun_max <- 72;
ammo_smg_max <- 650;
ammo_sniperrifle_max <- 180;

sluggishMultiplier <- 1.5;
ammo_pack_use_duration <- 3;
cola_bottles_use_duration <- 1.95;
defibrillator_use_duration <- 3;
first_aid_kit_use_duration <- 5;
gas_can_use_duration <- 2;
upgrade_pack_use_duration <- 2;
survivor_revive_duration <- 5;
function ResetPlayerCvars()
{
	//Ammo
	Convars.SetValue("ammo_assaultrifle_max", ammo_assaultrifle_max);
	Convars.SetValue("ammo_autoshotgun_max", ammo_autoshotgun_max);
	Convars.SetValue("ammo_huntingrifle_max", ammo_huntingrifle_max);
	Convars.SetValue("ammo_shotgun_max", ammo_shotgun_max);
	Convars.SetValue("ammo_smg_max", ammo_smg_max);
	Convars.SetValue("ammo_sniperrifle_max", ammo_sniperrifle_max);

	//Use Speed
	Convars.SetValue("ammo_pack_use_duration", ammo_pack_use_duration);
	Convars.SetValue("cola_bottles_use_duration", cola_bottles_use_duration);
	Convars.SetValue("defibrillator_use_duration", defibrillator_use_duration);
	Convars.SetValue("first_aid_kit_use_duration", first_aid_kit_use_duration);
	Convars.SetValue("gas_can_use_duration", gas_can_use_duration);
	Convars.SetValue("upgrade_pack_use_duration", upgrade_pack_use_duration);
	Convars.SetValue("survivor_revive_duration", survivor_revive_duration);
	Convars.SetValue("z_gun_swing_coop_max_penalty", 8);
	Convars.SetValue("z_gun_swing_coop_min_penalty", 5);
	Convars.SetValue("z_gun_swing_vs_max_penalty", 6);
	Convars.SetValue("z_gun_swing_vs_min_penalty", 3);
}

function CorruptionCard_ReducedAmmo()
{
	
	Convars.SetValue("sv_infinite_primary_ammo", 1);

	Convars.SetValue("ammo_assaultrifle_max", ceil(ammo_assaultrifle_max * ammoShortageMultiplier));
	Convars.SetValue("ammo_autoshotgun_max", ceil(ammo_autoshotgun_max * ammoShortageMultiplier));
	Convars.SetValue("ammo_huntingrifle_max", ceil(ammo_huntingrifle_max * ammoShortageMultiplier));
	Convars.SetValue("ammo_shotgun_max", ceil(ammo_shotgun_max * ammoShortageMultiplier));
	Convars.SetValue("ammo_smg_max", ceil(ammo_smg_max * ammoShortageMultiplier));
	Convars.SetValue("ammo_sniperrifle_max", ceil(ammo_sniperrifle_max * ammoShortageMultiplier));
	
	Convars.SetValue("sv_infinite_primary_ammo", 0);

}

function CorruptionCard_Sluggish()
{
	Convars.SetValue("ammo_pack_use_duration", ammo_pack_use_duration * sluggishMultiplier);
	Convars.SetValue("cola_bottles_use_duration", cola_bottles_use_duration * sluggishMultiplier);
	Convars.SetValue("defibrillator_use_duration", defibrillator_use_duration * sluggishMultiplier);
	Convars.SetValue("first_aid_kit_use_duration", first_aid_kit_use_duration * sluggishMultiplier);
	Convars.SetValue("gas_can_use_duration", gas_can_use_duration * sluggishMultiplier);
	Convars.SetValue("upgrade_pack_use_duration", upgrade_pack_use_duration * sluggishMultiplier);
	Convars.SetValue("survivor_revive_duration", survivor_revive_duration * sluggishMultiplier);
	Convars.SetValue("z_gun_swing_coop_max_penalty", 6);
	Convars.SetValue("z_gun_swing_coop_min_penalty", 3);
	Convars.SetValue("z_gun_swing_vs_max_penalty", 4);
	Convars.SetValue("z_gun_swing_vs_min_penalty", 2);
}