///////////////////////////////////////////////
//              CORRUPTION CARDS             //
///////////////////////////////////////////////
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
	cardsUncommons.append("uncommonFallen");
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
	corruptionZSpeed = ChooseCorruptionCard(cardsZSpeed, true);
	ApplyZSpeedCard ();

	// Tallboys
	local cardsTallboy = array(1, null);
	cardsTallboy.clear();
	cardsTallboy.append("Tallboy");
	cardsTallboy.append("Crusher");
	cardsTallboy.append("Bruiser");
	corruptionTallboy = ChooseCorruptionCard(cardsTallboy, true);
	ApplyTallboyCard();

	// Hockers
	local cardsHocker = array(1, null);
	cardsHocker.clear();
	cardsHocker.append("Hocker");
	cardsHocker.append("Stalker");
	corruptionHocker = ChooseCorruptionCard(cardsHocker, true);
	ApplyHockerCard();

	// Retches
	local cardsRetch = array(1, null);
	cardsRetch.clear();
	cardsRetch.append("Retch");
	cardsRetch.append("Exploder");
	corruptionRetch = ChooseCorruptionCard(cardsRetch, true);
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
		cardsHazards.append("hazardSnitch");
	}
	corruptionHazards = ChooseCorruptionCard(cardsHazards);

	// Boss
	local cardsBoss = array(1, null);
	cardsBoss.clear();
	cardsBoss.append("None");
	cardsBoss.append("None");
	if (IsMissionFinalMap() == false)
	{
		cardsBoss.append("hazardBreaker");
		cardsBoss.append("hazardOgre");
	}
	corruptionBoss = ChooseCorruptionCard(cardsBoss, true);
	ApplyBossCard();

	// Environmental
	local cardsEnvironmental = array(1, null);
	cardsEnvironmental.clear();
	cardsEnvironmental.append("None");
	cardsEnvironmental.append("None");
	cardsEnvironmental.append("None");
	cardsEnvironmental.append("None");
	cardsEnvironmental.append("None");
	cardsEnvironmental.append("None");
	cardsEnvironmental.append("environmentSwarmStream");

	if ( Director.IsSinglePlayerGame() )
	{
		cardsEnvironmental.append("environmentDark");
		cardsEnvironmental.append("environmentFog");
		cardsEnvironmental.append("environmentFrozen");
	}
	corruptionEnvironmental = ChooseCorruptionCard(cardsEnvironmental);
	//ApplyEnvironmentalCard();

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

		if (corruptionTallboy == "Tallboy")
		{
			cardsHordes.append("hordeTallboy");
		}
		if (corruptionTallboy == "Crusher")
		{
			cardsHordes.append("hordeCrusher");
		}
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
	corruptionHordes = ChooseCorruptionCard(cardsHordes, true);
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

	UpdateCorruptionCardHUD();
}

function ChooseCorruptionCard(cardArray, infectedCard = false)
{
	local cardSlot = cardArray[RandomInt(0, cardArray.len() - 1)];
	corruptionCards.append(cardSlot);

	if (infectedCard == false)
	{
		corruptionCards_List.append(cardSlot);
	}
	else
	{
		corruptionCards_ListInf.append(cardSlot);
	}

	return cardSlot;
}

function UpdateCorruptionCardHUD()
{
	local returnString = "CORRUPTION CARDS";
	local returnStringInf = "";
	local cardName = null;
	local i = 0;
	local iInf = 0;

	foreach(cardID in corruptionCards_List)
	{
		cardName = GetCorruptionCardName(cardID);

		if (cardName != "None" && cardName != null)
		{
			returnString = returnString + "\n" + cardName;
			i++;
		}
	}

	foreach(cardID in corruptionCards_ListInf)
	{
		cardName = GetCorruptionCardName(cardID);

		if (cardName != "None" && cardName != null)
		{
			if (returnStringInf == "")
			{
				returnStringInf = cardName
			}
			else
			{
				returnStringInf = returnStringInf + "\n" + cardName;
				iInf++;
			}
		}
	}

	swarmHUD.Fields["corruptionCards"].dataval = returnString;
	swarmHUD.Fields["corruptionCardsInfected"].dataval = returnStringInf;

	local hudY = swarmHudY;
	local hudH = swarmHudH + (swarmHudLineH * (i == 0 ? 1 : i))
	HUDPlace(HUD_FAR_RIGHT, 1 - swarmHudW - swarmHudX, hudY, swarmHudW, hudH);
	hudY = hudY + hudH + swarmHudGapY;
	HUDPlace(HUD_SCORE_1, 1 - swarmHudW - swarmHudX, hudY, swarmHudW, swarmHudH + (swarmHudLineH * (iInf == 0 ? 1 : iInf)));
}

/*function PrintCorruptionCards()
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
}*/

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
		case "environmentSwarmStream":
			return "Swarm Stream";
			break;
		case "hordeHunted":
			return "Hunted";
			break;
		case "hordeOnslaught":
			return "Onslaught";
			break;
		case "hordeTallboy":
			return "Tallboy Hordes";
			break;
		case "hordeCrusher":
			return "Crusher Hordes";
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
			return "Construction Site";
			break;
		case "uncommonJimmy":
			return "Jimmy Gibbs and Cousins";
			break;
		case "uncommonFallen":
			return "Fallen Cleaners";
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
		case "hazardSnitch":
			return "Tattlers";
			break;
		case "hazardBreaker":
			return "Breaker";
			break;
		case "hazardOgre":
			return "Ogre";
			break;
		default:
			return cardID;
			break;
	}
	
	return cardID;
}

///////////////////////////////////////////////
//            ENVIRONMENTAL CARDS            //
///////////////////////////////////////////////
function ApplyEnvironmentalCard()
{
	if ( Director.IsSinglePlayerGame() )
	{
		ResetFogCvars();
	}
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
function CorruptionCard_FrigidOutskirts()
{
	if (!IsSoundPrecached("ambient/wind/windgust.wav"))
		PrecacheSound("ambient/wind/windgust.wav");

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

function CorruptionCard_SwarmStreamGlow(player)
{
	local playerIndex = player.GetEntityIndex();
	local playerOrigin = player.GetOrigin();
	local playerAngles = player.GetAngles();
	local lightglow = SpawnEntityFromTable("env_lightglow",
	{
		targetname = "__swarm_stream_lightglow" + playerIndex,
		origin = Vector(playerOrigin.x, playerOrigin.y, playerOrigin.z + 48),
		angles = Vector(playerAngles.x, playerAngles.y, playerAngles.z),
		GlowProxySize = 32,
		HDRColorScale = 0.075,
		HorizontalGlowSize = 175,
		MaxDist = 0,
		MinDist = 0,
		OuterMaxDist = 65535,
		rendercolor = Vector(255, 193, 159),
		spawnflags = 0,
		VerticalGlowSize = 125
	});

	lightglow.SetOrigin(Vector(playerOrigin.x, playerOrigin.y, playerOrigin.z + 48));
	DoEntFire("!self", "AddOutput", "targetname " + "__swarm_stream" + playerIndex, 0, player, player);
	EntFire("__swarm_stream_lightglow" + playerIndex, "SetParent", "__swarm_stream" + playerIndex);
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
		case "hordeTallboy":
			CorruptionCard_TallboyHordes();
			break;
		case "hordeCrusher":
			CorruptionCard_CrusherHordes();
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
function CorruptionCard_Hunted()
{
	DirectorOptions.cm_CommonLimit = 30
}

function HuntedTimerFunc()
{
	if (HuntedTimer < Time() && HuntedEnabled == true)
	{
		SpawnMob();
		HuntedTimer = Time() + 180;
	}
	else if (HuntedTimer < Time() + 5 && HuntedEnabled == true)
	{
		ClientPrint(null, 3, "\x01 Prepare for the horde in \x04" + ceil(HuntedTimer - Time()) + "...");
	}
}

// Onslaught
function CorruptionCard_Onslaught()
{
	DirectorOptions.cm_CommonLimit = 50
}

function OnslaughtTimerFunc()
{
	if (OnslaughtTimer < Time() && OnslaughtEnabled == true)
	{
		SpawnMob();
		OnslaughtTimer = Time() + 90;
	}
	else if (OnslaughtTimer < Time() + 5 && OnslaughtEnabled == true)
	{
		ClientPrint(null, 3, "\x01 Prepare for the horde in \x04" + ceil(OnslaughtTimer - Time()) + "...");
	}
}

// Specials
function CorruptionCard_TallboyHordes()
{
	TallboyHordeEnabled = true
	DirectorOptions.cm_AggressiveSpecials = 1
	DirectorOptions.SpecialRespawnInterval = 45
}

function TallboyTimerFunc(count = 4, zType = 6)
{
	if (SpecialHordeTimer < Time() && TallboyHordeEnabled == true)
	{
		local i = 0;
		while (i < count)
		{
			ZSpawn({type = zType});
			i++;
			SpecialHordeTimer = Time() + 90;
		}
	}
	else if (SpecialHordeTimer < Time() + 5)
	{
		ClientPrint(null, 3, "\x01 Prepare for the horde in \x04" + ceil(SpecialHordeTimer - Time()) + "...");
	}
}

function CorruptionCard_CrusherHordes()
{
	CrusherHordeEnabled = true
	DirectorOptions.cm_AggressiveSpecials = 1
	DirectorOptions.SpecialRespawnInterval = 45
}

function CrusherTimerFunc(count = 4, zType = 6)
{
	if (SpecialHordeTimer < Time() && CrusherHordeEnabled == true)
	{
		local i = 0;
		while (i < count)
		{
			ZSpawn({type = zType});
			i++;
			SpecialHordeTimer = Time() + 90;
		}
	}
	else if (SpecialHordeTimer < Time() + 5)
	{
		ClientPrint(null, 3, "\x01 Prepare for the horde in \x04" + ceil(SpecialHordeTimer - Time()) + "...");
	}
}

function CorruptionCard_BruiserHordes()
{
	BruiserHordeEnabled = true
	DirectorOptions.cm_AggressiveSpecials = 1
	DirectorOptions.SpecialRespawnInterval = 45
}

function BruiserTimerFunc(count = 4, zType = 6)
{
	if (SpecialHordeTimer < Time() && BruiserHordeEnabled == true)
	{
		local i = 0;
		while (i < count)
		{
			ZSpawn({type = zType});
			i++;
			SpecialHordeTimer = Time() + 90;
		}
	}
	else if (SpecialHordeTimer < Time() + 5)
	{
		ClientPrint(null, 3, "\x01 Prepare for the horde in \x04" + ceil(SpecialHordeTimer - Time()) + "...");
	}
}

function CorruptionCard_StalkerHordes()
{
	StalkerHordeEnabled = true
	DirectorOptions.cm_AggressiveSpecials = 1
	DirectorOptions.SpecialRespawnInterval = 45
}

function StalkerTimerFunc(count = 4, zType = 5)
{
	if (SpecialHordeTimer < Time() && StalkerHordeEnabled == true)
	{
		local i = 0;
		while (i < count)
		{
			ZSpawn({type = zType});
			i++;
			SpecialHordeTimer = Time() + 90;
		}
	}
	else if (SpecialHordeTimer < Time() + 5)
	{
		ClientPrint(null, 3, "\x01 Prepare for the horde in \x04" + ceil(SpecialHordeTimer - Time()) + "...");
	}
}

function CorruptionCard_HockerHordes()
{
	HockerHordeEnabled = true
	DirectorOptions.cm_AggressiveSpecials = 1
	DirectorOptions.SpecialRespawnInterval = 45
}

function HockerTimerFunc(count = 4, zType = 1)
{
	if (SpecialHordeTimer < Time() && HockerHordeEnabled == true)
	{
		local i = 0;
		while (i < count)
		{
			ZSpawn({type = zType});
			i++;
			SpecialHordeTimer = Time() + 90;
		}
	}
	else if (SpecialHordeTimer < Time() + 5)
	{
		ClientPrint(null, 3, "\x01 Prepare for the horde in \x04" + ceil(SpecialHordeTimer - Time()) + "...");
	}
}

function CorruptionCard_ExploderHordes()
{
	ExploderHordeEnabled = true
	DirectorOptions.cm_AggressiveSpecials = 1
	DirectorOptions.SpecialRespawnInterval = 45
}

function ExploderTimerFunc(count = 4, zType = 2)
{
	if (SpecialHordeTimer < Time() && ExploderHordeEnabled == true)
	{
		local i = 0;
		while (i < count)
		{
			ZSpawn({type = zType});
			i++;
			SpecialHordeTimer = Time() + 90;
		}
	}
	else if (SpecialHordeTimer < Time() + 5)
	{
		ClientPrint(null, 3, "\x01 Prepare for the horde in \x04" + ceil(SpecialHordeTimer - Time()) + "...");
	}
}


function CorruptionCard_RetchHordes()
{
	RetchHordeEnabled = true
	DirectorOptions.cm_AggressiveSpecials = 1
	DirectorOptions.SpecialRespawnInterval = 45
}

function RetchTimerFunc(count = 4, zType = 2)
{
	if (SpecialHordeTimer < Time() && RetchHordeEnabled == true)
	{
		local i = 0;
		while (i < count)
		{
			ZSpawn({type = zType});
			i++;
			SpecialHordeTimer = Time() + 90;
		}
	}
	else if (SpecialHordeTimer < Time() + 5)
	{
		ClientPrint(null, 3, "\x01 Prepare for the horde in \x04" + ceil(SpecialHordeTimer - Time()) + "...");
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

///////////////////////////////////////////////
//              INFECTED CARDS               //
///////////////////////////////////////////////

// Tallboy
function ApplyTallboyCard()
{
	switch(corruptionTallboy)
	{
		case "Tallboy":
			CorruptionCard_Tallboy();
			break;
		case "Crusher":
			CorruptionCard_Crusher();
			break;
		case "Bruiser":
			CorruptionCard_Bruiser();
			break;
	}
}

function CorruptionCard_Tallboy()
{
	tallboyRunSpeed = 250
}

function CorruptionCard_Crusher()
{
	tallboyRunSpeed = 220
}

function CorruptionCard_Bruiser()
{
	tallboyRunSpeed = 200
}

// Hocker
function ApplyHockerCard()
{
	switch(corruptionHocker)
	{
		case "Hocker":
			CorruptionCard_Hocker();
			break;
		case "Crusher":
			CorruptionCard_Stalker();
			break;
	}
}

function CorruptionCard_Hocker()
{
	DirectorOptions.JockeyLimit = 0
}

function CorruptionCard_Stalker()
{
	DirectorOptions.SmokerLimit = 0
}

// Retches
function ApplyRetchCard()
{
	switch(corruptionRetch)
	{
		case "Retch":
			CorruptionCard_Retch();
			break;
		case "Exploder":
			CorruptionCard_Exploder();
			break;
	}
}

function CorruptionCard_Retch()
{
	Convars.SetValue("z_exploding_speed", 210);
	Convars.SetValue("z_vomit_duration", 2.5);
	Convars.SetValue("z_vomit_range", 1600);
	Convars.SetValue("survivor_it_duration", 0.15);
	Convars.SetValue("z_notice_it_range", 500);
}

function CorruptionCard_Exploder()
{
	Convars.SetValue("z_exploding_speed", 250);
	Convars.SetValue("z_vomit_duration", 0);
	Convars.SetValue("z_vomit_range", 300);
	Convars.SetValue("survivor_it_duration", 0);
	Convars.SetValue("z_notice_it_range", 500);
}

///////////////////////////////////////////////
//                 BOSSES                    //
///////////////////////////////////////////////
function ApplyBossCard()
{
	switch(corruptionBoss)
	{
		case "None":
			break;
		case "hazardBreaker":
			CorruptionCard_Breaker();
			break;
		case "hazardOgre":
			CorruptionCard_Ogre();
			break;
	}
}

function CorruptionCard_Breaker()
{
	BossSettings_Breaker();
}

function CorruptionCard_Ogre()
{
	BossSettings_Ogre();
}