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
	corruptionCommons = ChooseCorruptionCard_List(cardsCommons);

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
	corruptionUncommons = ChooseCorruptionCard_List(cardsUncommons);

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
	corruptionZSpeed = ChooseCorruptionCard_ListInf(cardsZSpeed);
	ApplyZSpeedCard ();

	// Tallboys
	local cardsTallboy = array(1, null);
	cardsTallboy.clear();
	cardsTallboy.append("Tallboy");
	cardsTallboy.append("Crusher");
	cardsTallboy.append("Bruiser");
	corruptionTallboy = ChooseCorruptionCard_ListInf(cardsTallboy);
	ApplyTallboyCard();

	// Hockers
	local cardsHocker = array(1, null);
	cardsHocker.clear();
	cardsHocker.append("Hocker");
	cardsHocker.append("Stinger");
	cardsHocker.append("Stalker");
	corruptionHocker = ChooseCorruptionCard_ListInf(cardsHocker);
	ApplyHockerCard();

	// Retches
	local cardsRetch = array(1, null);
	cardsRetch.clear();
	cardsRetch.append("Retch");
	cardsRetch.append("Exploder");
	cardsRetch.append("Reeker");
	corruptionRetch = ChooseCorruptionCard_ListInf(cardsRetch);
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
	corruptionHazards = ChooseCorruptionCard_List(cardsHazards);

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
	corruptionBoss = ChooseCorruptionCard_ListInf(cardsBoss);
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
	corruptionEnvironmental = ChooseCorruptionCard_List(cardsEnvironmental);
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
		if (corruptionHocker == "Hocker")
		{
			cardsHordes.append("hordeHocker");
		}
		if (corruptionHocker == "Stinger")
		{
			cardsHordes.append("hordeStinger");
		}
		if (corruptionHocker == "Stalker")
		{
			cardsHordes.append("hordeStalker");
		}
		if (corruptionRetch == "Retch")
		{
			cardsHordes.append("hordeRetch");
		}
		if (corruptionRetch == "Exploder")
		{
			cardsHordes.append("hordeExploder");
		}
		if (corruptionRetch == "Reeker")
		{
			cardsHordes.append("hordeReeker");
		}
	}
	corruptionHordes = ChooseCorruptionCard_ListInf(cardsHordes);
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
	corruptionGameplay = ChooseCorruptionCard_List(cardsGameplay);
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
	corruptionPlayer = ChooseCorruptionCard_List(cardsPlayer);
	ApplyPlayerCorruptionCard();

	// Missions
	local cardsMission = array(1, null);
	cardsMission.clear();
	cardsMission.append("None");
	cardsMission.append("None");
	cardsMission.append("missionSpeedrun");
	cardsMission.append("missionAllAlive");
	//cardsMission.append("missionGnomeAlone");
	corruptionMission = ChooseCorruptionCard_ListMission(cardsMission);
	//ApplyMissionCorruptionCard();

	UpdateCorruptionCardHUD();
}

function ChooseCorruptionCard_List(cardArray)
{
	local cardSlot = cardArray[RandomInt(0, cardArray.len() - 1)];
	corruptionCards.append(cardSlot);
	corruptionCards_List.append(cardSlot);
	return cardSlot;
}

function ChooseCorruptionCard_ListInf(cardArray)
{
	local cardSlot = cardArray[RandomInt(0, cardArray.len() - 1)];
	corruptionCards.append(cardSlot);
	corruptionCards_ListInf.append(cardSlot);
	return cardSlot;
}

function ChooseCorruptionCard_ListMission(cardArray)
{
	local cardSlot = cardArray[RandomInt(0, cardArray.len() - 1)];
	corruptionCards.append(cardSlot);
	corruptionCards_ListMission.append(cardSlot);
	return cardSlot;
}

function UpdateCorruptionCardHUD()
{
	local returnString = "CORRUPTION CARDS";
	local returnStringInf = "";
	local returnStringMission = "";
	local cardName = null;
	local iList = 0;
	local iInf = 0;
	local iMission = 0;
	local missionGoal = "";
	local missionStatus = "";

	foreach(cardID in corruptionCards_List)
	{
		cardName = GetCorruptionCardName(cardID);

		if (cardName != "None" && cardName != null)
		{
			returnString = returnString + "\n" + cardName;
			iList++;
		}
	}

	foreach(cardID in corruptionCards_ListInf)
	{
		cardName = GetCorruptionCardName(cardID);

		if (cardName != "None" && cardName != null)
		{
			if (returnStringInf == "")
			{
				returnStringInf = cardName;
			}
			else
			{
				returnStringInf = returnStringInf + "\n" + cardName;
				iInf++;
			}
		}
	}

	foreach(cardID in corruptionCards_ListMission)
	{
		cardName = GetCorruptionCardName(cardID);

		if (cardName != "None" && cardName != null)
		{
			if (returnStringMission == "")
			{
				returnStringMission = cardName;
			}
			else
			{
				returnStringMission = returnStringMission + "\n" + cardName;
				iMission++;
			}

			missionGoal = GetMissionGoal();
			missionStatus = GetMissionStatus();

			if (missionGoal != "")
			{
				returnStringMission = returnStringMission + "\n" + missionGoal;
				iMission++;
			}

			if (missionStatus != "")
			{
				returnStringMission = returnStringMission + "\n" + missionStatus;
				iMission++;
			}
		}
	}

	if (returnStringMission == "")
	{
		returnStringMission = "No Objective";
	}

	swarmHUD.Fields["corruptionCards"].dataval = returnString;
	swarmHUD.Fields["corruptionCardsInfected"].dataval = returnStringInf;
	swarmHUD.Fields["corruptionCardsMission"].dataval = returnStringMission;

	local hudY = swarmHudY;
	local hudH = swarmHudH + (swarmHudLineH * (iMission == 0 ? 1 : iMission))
	HUDPlace(HUD_SCORE_2, 1 - swarmHudW - swarmHudX, hudY, swarmHudW, hudH);
	hudY = hudY + hudH + swarmHudGapY;
	hudH = swarmHudH + (swarmHudLineH * (iList == 0 ? 1 : iList))
	HUDPlace(HUD_FAR_RIGHT, 1 - swarmHudW - swarmHudX, hudY, swarmHudW, hudH);
	hudY = hudY + hudH + swarmHudGapY;
	hudH = swarmHudH + (swarmHudLineH * (iInf == 0 ? 1 : iInf))
	HUDPlace(HUD_SCORE_1, 1 - swarmHudW - swarmHudX, hudY, swarmHudW, hudH);
	
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
		case "hordeHocker":
			return "Hocker Hordes";
			break;
		case "hordeStinger":
			return "Stinger Hordes";
			break;
		case "hordeStalker":
			return "Stalker Hordes";
			break;
		case "hordeExploder":
			return "Exploder Hordes";
			break;
		case "hordeRetch":
			return "Retch Hordes";
			break;
		case "hordeReeker":
			return "Reeker Hordes";
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
		case "Stinger":
			return "Stinger";
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
		case "Reeker":
			return "Reeker";
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
		case "missionSpeedrun":
			return "Speed Run";
			break;
		case "missionAllAlive":
			return "No One Left Behind";
			break;
		case "missionGnomeAlone":
			return "Gnome Alone";
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
			CorruptionCard_TallboyHordes();
			break;
		case "hordeBruiser":
			CorruptionCard_TallboyHordes();
			break;
		case "hordeHocker":
			CorruptionCard_HockerHordes();
			break;
		case "hordeStinger":
			CorruptionCard_HockerHordes();
			break;
		case "hordeStalker":
			CorruptionCard_StalkerHordes();
			break;
		case "hordeRetch":
			CorruptionCard_RetchHordes();
			break;
		case "hordeExploder":
			CorruptionCard_RetchHordes();
			break;
		case "hordeReeker":
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
	DirectorOptions.cm_CommonLimit = 30
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
	DirectorOptions.cm_AggressiveSpecials = 1
}

function CorruptionCard_HockerHordes()
{
	DirectorOptions.cm_AggressiveSpecials = 1
}

function CorruptionCard_StalkerHordes()
{
	DirectorOptions.cm_AggressiveSpecials = 1
}

function CorruptionCard_RetchHordes()
{
	DirectorOptions.cm_AggressiveSpecials = 1
}

function SpecialTimerFunc()
{
	if (SpecialHordeTimer < Time() && SpecialHordeEnabled == true)
	{
		local i = 0;
		local count = 6;
		local zType = null;

		if (corruptionHordes == "hordeTallboy" || corruptionHordes == "hordeCrusher" || corruptionHordes == "hordeCrusher")
		{
			zType = 6;
		}
		if (corruptionHordes == "hordeRetch" || corruptionHordes == "hordeExploder" || corruptionHordes == "hordeReeker")
		{
			zType = 2;
		}
		if (corruptionHordes == "hordeHocker" || corruptionHordes == "hordeStinger")
		{
			zType = 1;
		}
		if (corruptionHordes == "hordeStalker")
		{
			zType = 5;
		}

		while (i < count)
		{
			ZSpawn({type = zType});
			i++;
			SpecialHordeTimer = Time() + 120 + 30;
		}

		Heal_AmpedUp();
		Director.PlayMegaMobWarningSounds();
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
	tallboyRunSpeed = 240
}

function CorruptionCard_Crusher()
{
	tallboyRunSpeed = 210
}

function CorruptionCard_Bruiser()
{
	tallboyRunSpeed = 190
}

// Hocker
function ApplyHockerCard()
{
	switch(corruptionHocker)
	{
		case "Hocker":
			CorruptionCard_Hocker();
			break;
		case "Stinger":
			CorruptionCard_Stinger();
			break;
		case "Stalker":
			CorruptionCard_Stalker();
			break;
	}
}

function CorruptionCard_Hocker()
{
	DirectorOptions.JockeyLimit = 0
	Convars.SetValue("tongue_release_fatigue_penalty", 2500)
}

function CorruptionCard_Stinger()
{
	DirectorOptions.JockeyLimit = 0
	Convars.SetValue("tongue_release_fatigue_penalty", 0)
}

function CorruptionCard_Stalker()
{
	DirectorOptions.SmokerLimit = 0
	Convars.SetValue("tongue_release_fatigue_penalty", 2500)
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
		case "Reeker":
			CorruptionCard_Reeker();
			break;
	}
}

function CorruptionCard_Retch()
{
	Convars.SetValue("z_exploding_speed", 210);
	Convars.SetValue("z_vomit_duration", 2.5);
	Convars.SetValue("z_vomit_range", 1600);
	Convars.SetValue("survivor_it_duration", 0.33);
	Convars.SetValue("z_notice_it_range", 500);
	Convars.SetValue("z_exploding_inner_radius", 0);
	Convars.SetValue("z_exploding_outer_radius", 0);
	Convars.SetValue("z_exploding_splat_radius", 0);
}

function CorruptionCard_Exploder()
{
	Convars.SetValue("z_exploding_speed", 250);
	Convars.SetValue("z_vomit_duration", 0);
	Convars.SetValue("z_vomit_range", 300);
	Convars.SetValue("survivor_it_duration", 0);
	Convars.SetValue("z_notice_it_range", 500);
	Convars.SetValue("z_exploding_inner_radius", 0);
	Convars.SetValue("z_exploding_outer_radius", 0);
	Convars.SetValue("z_exploding_splat_radius", 0);
}

function CorruptionCard_Reeker()
{
	Convars.SetValue("z_exploding_speed", 250);
	Convars.SetValue("z_vomit_duration", 0);
	Convars.SetValue("z_vomit_range", 0);
	Convars.SetValue("survivor_it_duration", 20);
	Convars.SetValue("z_notice_it_range", 1500);
	Convars.SetValue("z_exploding_inner_radius", 130);
	Convars.SetValue("z_exploding_outer_radius", 200);
	Convars.SetValue("z_exploding_splat_radius", 200);
	DirectorOptions.BileMobSize = 20
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


///////////////////////////////////////////////
//               MISSION CARDS                //
///////////////////////////////////////////////
/*function ApplyMissionCorruptionCard()
{
	//ResetPlayerCvars();
	switch(corruptionMission)
	{
		case "None":
			break;
		case "missionSpeedrun":
			CorruptionCard_Speedrun();
			break;
	}
}*/

function GetMissionGoal()
{
	switch(corruptionMission)
	{
		case "None":
			return "";
			break;
		case "missionSpeedrun":
			return "Goal: " + IntToTime(MissionSpeedrun_Goal);
			break;
		case "missionAllAlive":
			return "";
			break;
		case "missionGnomeAlone":
			return "Find and rescue the Gnome";
			break;
		default:
			return "";
			break;
	}
}

function GetMissionStatus()
{
	switch(corruptionMission)
	{
		case "None":
			return "";
			break;
		case "missionSpeedrun":
			return "Time: " + IntToTime(MissionSpeedrun_Timer);
			break;
		case "missionAllAlive":
			return "Alive: " + GetAliveCleaners() + " / " + GetTotalCleaners();
			break;
		case "missionGnomeAlone":
			return GnomeStatus();
			break;
		default:
			return "";
			break;
	}
}

function GetTotalCleaners()
{
	local i = 0;
	local player = null;
	while ((player = Entities.FindByClassname(player, "player")) != null)
	{
		if (player.IsSurvivor())
		{
			i++;
		}
	}
	return i;
}

function GetAliveCleaners()
{
	local i = 0;
	local player = null;
	while ((player = Entities.FindByClassname(player, "player")) != null)
	{
		if (player.IsSurvivor())
		{
			if (!player.IsDead() && !player.IsDying())
			{
				i++;
			}
		}
	}
	return i;
}

function GnomeStatus()
{
	if (MissionGnomeAlone_Status == 0)
	{
		//Not picked up
		return "Gnome Not Found";
	}
	else if (MissionGnomeAlone_Status == 1)
	{
		//Held, not in saferoom
		return "Gnome Found";
	}
	else if (MissionGnomeAlone_Status == 2)
	{
		//Picked up and dropped
		return "Gnome Dropped";
	}
	else if (MissionGnomeAlone_Status == 3)
	{
		//Held, in saferoom OR dropped in saferoom
		return "Gnome Rescued";
	}
}