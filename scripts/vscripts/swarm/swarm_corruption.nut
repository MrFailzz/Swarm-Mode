///////////////////////////////////////////////
//              CORRUPTION CARDS             //
///////////////////////////////////////////////
function InitCorruptionCards()
{
	corruptionCards.clear();

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
	corruptionZSpeed = ChooseCorruptionCard_List(cardsZSpeed);
	ApplyZSpeedCard();

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
	cardsHazards.append("None");
	if (IsMissionFinalMap() == false)
	{
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
	cardsBoss.append("None");
	cardsBoss.append("None");
	cardsBoss.append("None");
	cardsBoss.append("None");
	if (IsMissionFinalMap() == false)
	{
		cardsBoss.append("hazardBreaker");
		cardsBoss.append("hazardBreaker");
		cardsBoss.append("hazardBreakerRaging");
		cardsBoss.append("hazardOgre");
		cardsBoss.append("hazardOgre");
		cardsBoss.append("hazardOgreRaging");
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
	cardsEnvironmental.append("environmentDark");
	cardsEnvironmental.append("environmentFog");
	cardsEnvironmental.append("environmentFrozen");
	corruptionEnvironmental = ChooseCorruptionCard_List(cardsEnvironmental);
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
		//cardsHordes.append("hordeDuringBoss");
		cardsHordes.append("horde" + corruptionTallboy);
		cardsHordes.append("horde" + corruptionHocker);
		cardsHordes.append("horde" + corruptionRetch);
	}
	corruptionHordes = ChooseCorruptionCard_ListHorde(cardsHordes);
	ApplyHordeCard();

	// Gameplay
	local cardsGameplay = array(1, null);
	cardsGameplay.clear();
	cardsGameplay.append("None");
	cardsGameplay.append("None");
	cardsGameplay.append("gameplayNoGrenades");
	//cardsGameplay.append("gameplayNoOutlines");
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
		//cardsPlayer.append("playerWhiteWeapons");
	}
	corruptionPlayer = ChooseCorruptionCard_List(cardsPlayer);
	ApplyPlayerCorruptionCard();

	// Missions
	local cardsMission = array(1, null);
	cardsMission.clear();
	cardsMission.append("None");
	if (IsMissionFinalMap() == false)
	{
		cardsMission.append("missionSpeedrun");
		cardsMission.append("missionSpeedrun");
		cardsMission.append("missionAllAlive");
		cardsMission.append("missionAllAlive");
		cardsMission.append("missionGnomeAlone");
		cardsMission.append("missionGnomeAlone");
	}
	corruptionMission = ChooseCorruptionCard_ListMission(cardsMission);
	ApplyMissionCorruptionCard();

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

function ChooseCorruptionCard_ListHorde(cardArray)
{
	local cardSlot = cardArray[RandomInt(0, cardArray.len() - 1)];
	corruptionCards.append(cardSlot);
	corruptionCards_ListHorde.append(cardSlot);
	return cardSlot;
}

function UpdateCorruptionCardHUD()
{
	local returnString = "";
	local returnStringInf = "";
	local returnStringMission = "";
	local returnStringHorde = "";
	local cardName = null;
	local iList = 0;
	local iInf = 0;
	local iMission = 0;
	local iHorde = 0;
	local missionGoal = "";
	local missionStatus = "";
	local hordeTimer = "";

	foreach(cardID in corruptionCards_List)
	{
		cardName = GetCorruptionCardName(cardID);

		if (cardName != "None" && cardName != null)
		{
			if (returnString == "")
			{
				returnString = cardName;
			}
			else
			{
				returnString = returnString + "\n" + cardName;
				iList++;
			}
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

	foreach(cardID in corruptionCards_ListHorde)
	{
		cardName = GetCorruptionCardName(cardID);

		if (cardName != "None" && cardName != null)
		{
			if (returnStringHorde == "")
			{
				returnStringHorde = cardName;
			}
			else
			{
				returnStringHorde = returnStringHorde + "\n" + cardName;
				iHorde++;
			}

			hordeTimer = GetHordeTimer();

			if (hordeTimer != "")
			{
				returnStringHorde = returnStringHorde + "\n" + hordeTimer;
				iHorde++;
			}
		}
	}

	if (returnStringHorde == "")
	{
		returnStringHorde = "No Horde";
	}

	swarmHUD.Fields["corruptionCards"].dataval = returnString;
	swarmHUD.Fields["corruptionCardsInfected"].dataval = returnStringInf;
	swarmHUD.Fields["corruptionCardsMission"].dataval = returnStringMission;
	swarmHUD.Fields["corruptionCardsHorde"].dataval = returnStringHorde;

	local hudY = swarmHudY;
	local hudH = swarmHudH + (swarmHudLineH * (iMission == 0 ? 1 : iMission))
	HUDPlace(HUD_SCORE_2, 1 - swarmHudW - swarmHudX, hudY, swarmHudW, hudH);
	hudY = hudY + hudH + swarmHudGapY;
	hudH = swarmHudH + (swarmHudLineH * (iHorde == 0 ? 1 : iHorde))
	HUDPlace(HUD_SCORE_3, 1 - swarmHudW - swarmHudX, hudY, swarmHudW, hudH);
	hudY = hudY + hudH + swarmHudGapY;
	hudH = swarmHudH + (swarmHudLineH * (iList == 0 ? 1 : iList))
	HUDPlace(HUD_FAR_RIGHT, 1 - swarmHudW - swarmHudX, hudY, swarmHudW, hudH);
	hudY = hudY + hudH + swarmHudGapY;
	hudH = swarmHudH + (swarmHudLineH * (iInf == 0 ? 1 : iInf))
	HUDPlace(HUD_SCORE_1, 1 - swarmHudW - swarmHudX, hudY, swarmHudW, hudH);
	
}

function GetCorruptionCardName(cardID)
{
	if (language == "English")
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
			case "hazardBreakerRaging":
				return "Raging Breaker";
				break;
			case "hazardOgre":
				return "Ogre";
				break;
			case "hazardOgreRaging":
				return "Raging Ogre";
				break;
			case "missionSpeedrun":
				return "Speedrun";
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
	}
	else if (language == "Russian")
	{
		switch(cardID)
		{
			case "None":
				return "None";
				break;
			case "commonAcid":
				return "Кислотные заражённые";
				break;
			case "commonFire":
				return "Огненные заражённые";
				break;
			case "commonExplode":
				return "Взрывающиеся заражённые";
				break;
			case "hazardBirds":
				return "Вороны";
				break;
			case "hazardLockdown":
				return "Двери с сигнализацией";
				break;
			case "hazardSleepers":
				return "Слиперы";
				break;
			case "environmentDark":
				return "Темнота";
				break;
			case "environmentFog":
				return "Туман";
				break;
			case "environmentFrozen":
				return "Холодные окраины";
				break;
			case "environmentSwarmStream":
				return "Светящийся ручей";
				break;
			case "hordeHunted":
				return "На Охоте";
				break;
			case "hordeOnslaught":
				return "Натиск";
				break;
			case "hordeTallboy":
				return "Орда Толлбоев";
				break;
			case "hordeCrusher":
				return "Орда Крашеров";
				break;
			case "hordeBruiser":
				return "Орда Брузеров";
				break;
			case "hordeHocker":
				return "Орда Хокеров";
				break;
			case "hordeStinger":
				return "Орда Стингеров";
				break;
			case "hordeStalker":
				return "Орда Сталкеров";
				break;
			case "hordeExploder":
				return "Орда Эксплодеров";
				break;
			case "hordeRetch":
				return "Орда Ретчей";
				break;
			case "hordeReeker":
				return "Орда Рикеров";
				break;
			case "hordeDuringBoss":
				return "Бушующая Орда";
				break;
			case "gameplayNoGrenades":
				return "Опустевшие карманы";
				break;
			case "gameplayNoOutlines":
				return "Без контуров";
				break;
			case "gameplayNoSupport":
				return "Выживает наиболее приспособленный";
				break;
			case "gameplayNoRespawn":
				return "Сделай или сдохни";
				break;
			case "playerLessAmmo":
				return "Нехватка боеприпасов";
				break;
			case "playerFatigue":
				return "Усталость";
				break;
			case "uncommonClown":
				return "Шоу Клоунов";
				break;
			case "uncommonRiot":
				return "Подавление толпы";
				break;
			case "uncommonMud":
				return "Грязевики";
				break;
			case "uncommonCeda":
				return "Сотрудники CEDA";
				break;
			case "uncommonConstruction":
				return "Стройка";
				break;
			case "uncommonJimmy":
				return "Джимми Гиббс и его двоюродные братья";
				break;
			case "uncommonFallen":
				return "Павшие чистильщики";
				break;
			case "commonShamble":
				return "Медленные заражённые";
				break;
			case "commonRunning":
				return "Обычные заражённые";
				break;
			case "commonBlitzing":
				return "Быстрые заражённые";
				break;
			case "Tallboy":
				return "Толлбои";
				break;
			case "Crusher":
				return "Крашеры";
				break;
			case "Bruiser":
				return "Брузеры";
				break;
			case "Hocker":
				return "Хокеры";
				break;
			case "Stinger":
				return "Стингеры";
				break;
			case "Stalker":
				return "Сталкеры";
				break;
			case "Retch":
				return "Ретчи";
				break;
			case "Exploder":
				return "Эксплодеры";
				break;
			case "Reeker":
				return "Рикеры";
				break;
			case "hazardSnitch":
				return "Стукачи";
				break;
			case "hazardBreaker":
				return "Брейкер";
				break;
			case "hazardBreakerRaging":
				return "Разгневанный Брейкер";
				break;
			case "hazardOgre":
				return "Огр";
				break;
			case "hazardOgreRaging":
				return "Разгневанный Огр";
				break;
			case "missionSpeedrun":
				return "Спидран";
				break;
			case "missionAllAlive":
				return "Своих не оставляем";
				break;
			case "missionGnomeAlone":
				return "Один Гнома";
				break;
			default:
				return cardID;
				break;
		}
	}
	
	return cardID;
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
	SetFogCvar("r_flashlightconstant", "0");
	SetFogCvar("r_flashlightbrightness", "0.25");
	SetFogCvar("mat_force_tonemap_scale", "0");
	Convars.SetValue("sv_disable_glow_survivors", 0);
	Convars.SetValue("sv_disable_glow_faritems", 0);

	local fog = null;
	while ((fog = Entities.FindByClassname(fog, "env_fog_controller")) != null)
	{
		/*
		NetProps.SetPropInt(fog, "m_fog.colorPrimary", fogColor);
		NetProps.SetPropFloat(fog, "m_fog.maxdensity", fogDensity);
		NetProps.SetPropFloat(fog, "m_fog.start", fogStart);
		NetProps.SetPropFloat(fog, "m_fog.end", fogEnd);
		NetProps.SetPropFloat(fog, "m_fog.farz", fogZ);
		*/
		DoEntFire("!self", "SetStartDistLerpTo", "300", 0, fog, fog);
		DoEntFire("!self", "SetEndDistLerpTo", "3000", 0, fog, fog);
		DoEntFire("!self", "SetFarZ", "3500", 5, fog, fog);
		DoEntFire("!self", "SetColorLerpTo", "18 29 33", 0, fog, fog);
		DoEntFire("!self", "SetMaxDensityLerpTo", "1", 0, fog, fog);
		DoEntFire("!self", "Set2DSkyboxFogFactorLerpTo", "0", 0, fog, fog);
		DoEntFire("!self", "StartFogTransition", "", 0, fog, fog);
	}

	local player = null;
	while ((player = Entities.FindByClassname(player, "player")) != null)
	{
		NetProps.SetPropInt(player, "m_Local.m_skybox3d.fog.colorPrimary", GetColorInt(Vector(18, 29, 33)));
	}
}

function CorruptionCard_TheDark()
{
	SetFogCvar("r_flashlightconstant", "0.25");
	SetFogCvar("r_flashlightbrightness", "10");
	Convars.SetValue("sv_disable_glow_survivors", 1);
	Convars.SetValue("sv_disable_glow_faritems", 1);
	
	local fog = null;
	while ((fog = Entities.FindByClassname(fog, "env_fog_controller")) != null)
	{
		/*
		NetProps.SetPropInt(fog, "m_fog.colorPrimary", GetColorInt(Vector(1, 1, 1)));
		NetProps.SetPropFloat(fog, "m_fog.maxdensity", 1);
		NetProps.SetPropFloat(fog, "m_fog.start", 242);
		NetProps.SetPropFloat(fog, "m_fog.end", 730);
		NetProps.SetPropFloat(fog, "m_fog.farz", 1200);
		*/
		DoEntFire("!self", "SetStartDistLerpTo", "0", 0, fog, fog);
		DoEntFire("!self", "SetEndDistLerpTo", "512", 0, fog, fog);
		DoEntFire("!self", "SetFarZ", "1500", 5, fog, fog);
		DoEntFire("!self", "SetColorLerpTo", "1 1 1", 0, fog, fog);
		DoEntFire("!self", "SetMaxDensityLerpTo", "1", 0, fog, fog);
		DoEntFire("!self", "Set2DSkyboxFogFactorLerpTo", "1", 0, fog, fog);
		DoEntFire("!self", "StartFogTransition", "", 0, fog, fog);
	}

	local player = null;
	while ((player = Entities.FindByClassname(player, "player")) != null)
	{
		NetProps.SetPropInt(player, "m_Local.m_skybox3d.fog.colorPrimary", GetColorInt(Vector(1, 1, 1)));
	}

	local tonemap = null;
	while ((tonemap = Entities.FindByClassname(tonemap, "env_tonemap_controller")) != null)
	{
		DoEntFire("!self", "SetAutoExposureMin", "0.1", 1, tonemap, tonemap);
		DoEntFire("!self", "SetAutoExposureMax", "0.5", 1, tonemap, tonemap);
	}

	local sun = null;
	while ((sun = Entities.FindByClassname(sun, "env_sun")) != null)
	{
		sun.Kill();
	}
}

function CorruptionCard_TheFog()
{
	Convars.SetValue("sv_disable_glow_survivors", 1);
	Convars.SetValue("sv_disable_glow_faritems", 1);

	local fog = null;
	while ((fog = Entities.FindByClassname(fog, "env_fog_controller")) != null)
	{
		/*
		NetProps.SetPropInt(fog, "m_fog.colorPrimary", GetColorInt(Vector(255, 255, 255)));
		NetProps.SetPropFloat(fog, "m_fog.maxdensity", 1);
		NetProps.SetPropFloat(fog, "m_fog.start", 242);
		NetProps.SetPropFloat(fog, "m_fog.end", 730);
		NetProps.SetPropFloat(fog, "m_fog.farz", 1200);
		*/
		DoEntFire("!self", "SetStartDistLerpTo", "242", 0, fog, fog);
		DoEntFire("!self", "SetEndDistLerpTo", "730", 0, fog, fog);
		DoEntFire("!self", "SetFarZ", "1500", 5, fog, fog);
		DoEntFire("!self", "SetColorLerpTo", "255 255 255", 0, fog, fog);
		DoEntFire("!self", "SetMaxDensityLerpTo", "1", 0, fog, fog);
		DoEntFire("!self", "Set2DSkyboxFogFactorLerpTo", "1", 0, fog, fog);
		DoEntFire("!self", "StartFogTransition", "", 0, fog, fog);
	}

	local player = null;
	while ((player = Entities.FindByClassname(player, "player")) != null)
	{
		NetProps.SetPropInt(player, "m_Local.m_skybox3d.fog.colorPrimary", GetColorInt(Vector(255, 255, 255)));
	}
}

// Frigid Outskirts
function CorruptionCard_FrigidOutskirts()
{
	if (!IsSoundPrecached("ambient/wind/windgust.wav"))
		PrecacheSound("ambient/wind/windgust.wav");

	local fog = null;
	while ((fog = Entities.FindByClassname(fog, "env_fog_controller")) != null)
	{
		DoEntFire("!self", "SetStartDistLerpTo", "0", 0, fog, fog);
		DoEntFire("!self", "SetEndDistLerpTo", "1400", 0, fog, fog);
		DoEntFire("!self", "SetFarZ", "1600", 5, fog, fog);
		DoEntFire("!self", "SetColorLerpTo", "174 196 209", 0, fog, fog);
		DoEntFire("!self", "SetMaxDensityLerpTo", "1", 0, fog, fog);
		DoEntFire("!self", "Set2DSkyboxFogFactorLerpTo", "1", 0, fog, fog);
		DoEntFire("!self", "StartFogTransition", "", 0, fog, fog);
	}

	local player = null;
	while ((player = Entities.FindByClassname(player, "player")) != null)
	{
		NetProps.SetPropInt(player, "m_Local.m_skybox3d.fog.colorPrimary", GetColorInt(Vector(174, 196, 209)));
	}
	
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
			frigidOutskirtsTimer = Time();

			local fog = null;
			while ((fog = Entities.FindByClassname(fog, "env_fog_controller")) != null)
			{
				DoEntFire("!self", "SetStartDistLerpTo", "-250", 0, fog, fog);
				DoEntFire("!self", "SetEndDistLerpTo", "600", 0, fog, fog);
				DoEntFire("!self", "SetFarZ", "1000", 5, fog, fog);
				DoEntFire("!self", "SetColorLerpTo", "174 196 209", 0, fog, fog);
				DoEntFire("!self", "SetMaxDensityLerpTo", "1", 0, fog, fog);
				DoEntFire("!self", "Set2DSkyboxFogFactorLerpTo", "1", 0, fog, fog);
				DoEntFire("!self", "StartFogTransition", "", 0, fog, fog);
			}

			EntFire("__frigid_outskirts_wind_snd", "PlaySound", "", 3);
			EntFire("__frigid_outskirts_wind_snd2", "PlaySound", "", 10);
			SetFogCvar("r_flashlightbrightness", "2");
			Convars.SetValue("sv_disable_glow_survivors", 1);
			Convars.SetValue("sv_disable_glow_faritems", 1);
		}
	}
	else
	{
		if ((Time() - frigidOutskirtsTimer) >= frigidOutskirtsStormTime)
		{
			frigidOutskirtsStormActive = false;
			frigidOutskirtsTimer = Time();

			local fog = null;
			while ((fog = Entities.FindByClassname(fog, "env_fog_controller")) != null)
			{
				DoEntFire("!self", "SetStartDistLerpTo", "0", 0, fog, fog);
				DoEntFire("!self", "SetEndDistLerpTo", "1400", 0, fog, fog);
				DoEntFire("!self", "SetFarZ", "1600", 5, fog, fog);
				DoEntFire("!self", "SetColorLerpTo", "174 196 209", 0, fog, fog);
				DoEntFire("!self", "SetMaxDensityLerpTo", "1", 0, fog, fog);
				DoEntFire("!self", "Set2DSkyboxFogFactorLerpTo", "1", 0, fog, fog);
				DoEntFire("!self", "StartFogTransition", "", 0, fog, fog);
			}

			EntFire("__frigid_outskirts_wind_snd", "StopSound");
			EntFire("__frigid_outskirts_wind_snd2", "StopSound");
			SetFogCvar("r_flashlightbrightness", "0.5");
			Convars.SetValue("sv_disable_glow_survivors", 0);
			Convars.SetValue("sv_disable_glow_faritems", 0);
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
		HorizontalGlowSize = 100,
		MaxDist = 0,
		MinDist = 0,
		OuterMaxDist = 4000,
		rendercolor = Vector(255, 193, 159),
		spawnflags = 0,
		VerticalGlowSize = 75
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
		case "hordeCrusher":
		case "hordeBruiser":
		case "hordeHocker":
		case "hordeStinger":
		case "hordeStalker":
		case "hordeRetch":
		case "hordeExploder":
		case "hordeReeker":
			CorruptionCard_SpecialHordes();
			break;
	}
}

// Hunted
function CorruptionCard_Hunted()
{
	DirectorOptions.cm_CommonLimit = 30
}

function HuntedTimerFunc()
{
	if (HuntedTimer < Time() && HuntedEnabled == true && HuntedTimer != null)
	{
		SpawnMob();
		HuntedTimer = Time() + HuntedTimerDefault;
		ClientPrint(null, 3, "\x04" + "Here comes the horde!");
	}
	else if (HuntedTimer < Time() + 5 && HuntedEnabled == true && HuntedTimer != null)
	{
		ClientPrint(null, 3, "\x01" + "Prepare for the horde in \x04" + ceil(HuntedTimer - Time()) + "...");
	}
}

// Onslaught
function CorruptionCard_Onslaught()
{
	DirectorOptions.cm_CommonLimit = 30
}

function OnslaughtTimerFunc()
{
	if (OnslaughtTimer < Time() && OnslaughtEnabled == true && OnslaughtTimer != null)
	{
		SpawnMob();
		OnslaughtTimer = Time() + OnslaughtTimerDefault;
		ClientPrint(null, 3, "\x04" + "Here comes the horde!");
	}
	else if (OnslaughtTimer < Time() + 5 && OnslaughtEnabled == true && OnslaughtTimer != null)
	{
		ClientPrint(null, 3, "\x01" + "Prepare for the horde in \x04" + ceil(OnslaughtTimer - Time()) + "...");
	}
}

// Specials
function CorruptionCard_SpecialHordes()
{
	DirectorOptions.cm_AggressiveSpecials = 1;
}

function SpecialTimerFunc(zType)
{
	if (SpecialHordeTimer < Time() && SpecialHordeTimer != null)
	{
		local i = 0;
		local count = 6;

		while (i < count)
		{
			ZSpawn({type = zType});
			i++;
		}
		SpecialHordeTimer = Time() + SpecialHordeTimerDefault;
		ClientPrint(null, 3, "\x04" + "Here comes the horde!");

		Heal_AmpedUp();
		Director.PlayMegaMobWarningSounds();
	}
	else if (SpecialHordeTimer < Time() + 5 && SpecialHordeTimer != null)
	{
		ClientPrint(null, 3, "\x01" + "Prepare for the horde in \x04" + ceil(SpecialHordeTimer - Time()) + "...");
	}
}

function GetHordeTimer()
{
	switch(corruptionHordes)
	{
		case "None":
			return "";
			break;
		case "hordeHunted":
			if (HuntedTimer == null)
			{
				return IntToTime(HuntedTimerDefault + 30);
				break;
			}
			else
			{
				return IntToTime(HuntedTimer - Time());
				break;
			}
			break;
		case "hordeOnslaught":
			if (OnslaughtTimer == null)
			{
				return IntToTime(OnslaughtTimerDefault + 30);
				break;
			}
			else
			{
				return IntToTime(OnslaughtTimer - Time());
				break;
			}
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
			if (SpecialHordeTimer == null)
			{
				return IntToTime(SpecialHordeTimerDefault + 30);
				break;
			}
			else
			{
				return IntToTime(SpecialHordeTimer - Time());
				break;
			}
			break;
		default:
			return "";
			break;
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
		local OnMapItems = [];
		local weapon_ent = null;
		while(weapon_ent = Entities.FindByModel(weapon_ent, modelpath))
		{
			if (weapon_ent.IsValid())
			{
				if (weapon_ent.GetClassname().find("weapon_", 0) == 0)
				{
					OnMapItems.resize(OnMapItems.len() + 1, weapon_ent);
				}
			}
		}
		
		local OnMapItemsLength = OnMapItems.len();
		printl(modelpath + " " + OnMapItemsLength);
		if (OnMapItems.len() > 0)
		{
			while(OnMapItems.len() >= OnMapItemsLength * 0.25)
			{
				local randomItemIndex = RandomInt(0, OnMapItems.len() - 1);
				local randomItem = OnMapItems.remove(randomItemIndex);
				printl(randomItem);
				randomItem.Kill();
			}
		}
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
		local OnMapItems = [];
		local weapon_ent = null;
		while(weapon_ent = Entities.FindByModel(weapon_ent, modelpath))
		{
			if (weapon_ent.IsValid())
			{
				if (weapon_ent.GetClassname().find("weapon_", 0) == 0)
				{
					OnMapItems.resize(OnMapItems.len() + 1, weapon_ent);
				}
			}
			//weapon_ent.Kill();
		}
		
		local OnMapItemsLength = OnMapItems.len();
		printl(modelpath + " " + OnMapItemsLength);
		if (OnMapItems.len() > 0)
		{
			while(OnMapItems.len() >= OnMapItemsLength * 0.25)
			{
				local randomItemIndex = RandomInt(0, OnMapItems.len() - 1);
				local randomItem = OnMapItems.remove(randomItemIndex);
				printl(randomItem);
				randomItem.Kill();
			}
		}
	}
}

/*function CorruptionDropItems()
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
}*/

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
		case "hazardBreakerRaging":
			CorruptionCard_Breaker();
			break;
		case "hazardOgreRaging":
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
function ApplyMissionCorruptionCard()
{
	//ResetPlayerCvars();
	switch(corruptionMission)
	{
		case "None":
			break;
		case "missionGnomeAlone":
			CorruptionCard_GnomeAlone();
			break;
	}
}

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

function CorruptionCard_GnomeAlone()
{
	//Spawn the Gnome on a random nav
	local gnomeOrigin = HazardGetRandomNavArea(hazardNavArray);

	local gnome = SpawnEntityFromTable("prop_physics",
	{
		targetname = "__GnomeAlone",
		origin = Vector(gnomeOrigin.x, gnomeOrigin.y, gnomeOrigin.z + 32),
		angles = Vector(0, 0, 0),
		model = "models/props_junk/gnome.mdl",
		disableshadows = 1,
		spawnflags = 256,
		//glowrange = 512
	});

	//EntFire("__GnomeAlone", "StartGlowing"); //GLOW FOR TESTING
}

function GetGnomeStatus()
{
	local player = null;
	local gnomeHeld = false;
	//local heldGnomeEnt = null;
	local heldGnomePlayer = null;

	//Check if a player is carrying a gnome
	while ((player = Entities.FindByClassname(player, "player")) != null)
	{
		local invTable = {};
		GetInvTable(player, invTable);

		if("slot5" in invTable)
		{
			if (invTable.slot5.GetClassname() == "weapon_gnome")
			{
				gnomeHeld = true;
				//heldGnomeEnt = invTable.slot5;
				heldGnomePlayer = player;
			}
		}
	}

	if (gnomeHeld == false)
	{
		//heldGnomeEnt = null;
		heldGnomePlayer = null;

		local looseGnome = null;

		//Find loose gnomes in the map
		local findGnomeName = null;
		while ((findGnomeName = Entities.FindByName(findGnomeName, "__GnomeAlone")) != null)
		{
			looseGnome = findGnomeName;
		}

		if (looseGnome == null)
		{
			local findGnomeModel = null;
			while ((findGnomeModel = Entities.FindByModel(findGnomeModel, "models/props_junk/gnome.mdl")) != null)
			{
				if (findGnomeModel.GetName() == "")
				{
					looseGnome = findGnomeModel;
					break;
				}
			}
		}

		if (MissionGnomeAlone_Status != 0)
		{
			//Gnome has been found and then dropped
			local navArea = NavMesh.GetNearestNavArea(looseGnome.GetOrigin(), 256, false, true);
			if (navArea != null)
			{
				if (navArea.HasSpawnAttributes(2048))
				{
					//In saferoom
					if (MissionGnomeAlone_Status != 3)
					{
						EmitAmbientSoundOn(GnomeCallGetLine("rescue"), 1, 60, 170, looseGnome);
					}
					MissionGnomeAlone_Status = 3;
				}
				else
				{
					//Not in saferoom
					if (MissionGnomeAlone_Status != 2)
					{
						EmitAmbientSoundOn(GnomeCallGetLine("dropped"), 1, 60, 170, looseGnome);
					}
					MissionGnomeAlone_Status = 2;
				}
			}
		}
		else
		{
			//Gnome not yet found
			if (MissionGnomeAlone_CalloutTimer == 0)
			{
				EmitAmbientSoundOn(GnomeCallGetLine("lost"), 1, 60, 170, looseGnome);
			}
		}
	}
	else
	{
		//Check if the player carrying the gnome is in a saferoom
		local navArea = NavMesh.GetNearestNavArea(heldGnomePlayer.GetOrigin(), 256, false, true);
		if (navArea != null)
		{
			if (navArea.HasSpawnAttributes(2048))
			{
				//Gnome held in saferoom
				if (MissionGnomeAlone_Status != 3)
				{
					EmitAmbientSoundOn(GnomeCallGetLine("rescue"), 1, 60, 170, heldGnomePlayer);
				}
				MissionGnomeAlone_Status = 3;
			}
			else
			{
				//Gnome held not in saferoom
				if (MissionGnomeAlone_Status != 1 && MissionGnomeAlone_Status != 3)
				{
					EmitAmbientSoundOn(GnomeCallGetLine("found"), 1, 60, 170, heldGnomePlayer);
				}
				MissionGnomeAlone_Status = 1;
			}
		}
	}
}

function GnomeCallGetLine(soundType)
{
	local lineChosen = "";
	local lineArray = [];

	switch(soundType)
	{
		case "lost":
			lineArray =
			[
				"player/survivor/voice/Manager/LostCall01.wav", //Hello
				"player/survivor/voice/Manager/LostCall03.wav", //Where is everyone
				"player/survivor/voice/Manager/LostCall04.wav", //Is anyone there
				"player/survivor/voice/Manager/LostCall05.wav", //Where'd everybody get to
				"player/survivor/voice/Manager/LostCall06.wav", //Can anyone hear me
				"Player.Manager_LedgeHangStart02", //Could someone give me a hand over here
				"Player.Manager_LedgeHangStart03", //Could someone give me a hand over here
				"Player.Manager_LedgeHangStart04", //I could really use a hand over here
				"Player.Manager_Help01", //HEEEELP
				"Player.Manager_Help02", //I need some help over here
				"Player.Manager_Help03", //Need a little help over here
				"Player.Manager_Help05", //HELP ME
				"Player.Manager_Help06", //HEEEEELP
				"Player.Manager_Help08", //I NEED SOME HELP
				"Player.Manager_Help09", //SOMEBODY HELP ME
				"Player.Manager_Help10", //CAN YOU HEAR ME I NEED SOME HELP
			];
		break;

		case "found":
			lineArray =
			[
				"Manager_DLC1_C6M3_FinaleChat08", //Hey you made it
				"Manager_DLC1_C6M3_FinaleChat10", //HEY YOU MADE IT
				"Manager_DLC1_C6M3_FinaleChat11", //Where you guys heading
				"Manager_DLC1_C6M3_FinaleChat14", //Hey you made it, where you heading
				"Manager_DLC1_C6M3_FinaleChat15", //Hey you made it, where you heading
				"Manager_DLC1_C6M3_FinaleChat16", //Hey you made it, where you heading
				"Manager_DLC1_C6M3_FinaleChat20", //Francis said you werent gonna make it, but i said i had a good feeling about you
				"Manager_DLC1_C6M3_FinaleChat33", //Yeah i stayed here, yeah im ok im just a little banged up, it wasnt easy getting up here, we lost a man
				"Manager_DLC1_C6M3_FinaleChat38", //Okay :)
				"Manager_DLC1_C6M3_L4D1FinaleBridgeRun02", //Get going GET GOING
				"npc.Manager_AnswerReady02", //Lets do it
				"npc.Manager_AnswerReady04", //Come on lets do it
				"npc.Manager_GenericResponses09", //Alright then lets do it
				"npc.Manager_GenericResponses16", //Hell yes
				"npc.Manager_GenericResponses23", //Works for me
				"npc.Manager_GenericResponses24", //Sounds good
				"npc.Manager_GenericResponses40", //HELL YEAH
				"npc.Manager_ReviveFriendB06", //Up we go
				"npc.Manager_ReviveFriendB10", //Lets move
				"npc.Manager_WorldAirportNPC07", //Ok lets do it
				"npc.Manager_WorldHospital0415", //Lets go LETS GO
				"npc.Manager_ZombieGenericLong03", //If i go down go on without me, actually wait no, save my ass
				"npc.Manager_ZombieGenericLong11", //Any of you guys cub scouts [...]
				"Player.Manager_C6DLC3INTRO21", //Oh thanks man
				"Player.Manager_DLC2Recycling01", //We get outta this alive [...]
				"Player.Manager_EmphaticRun01", //Lets get the hell outta here
				"Player.Manager_Generic02", //Oh cool
				"Player.Manager_HurryUp10", //Lets go, lets go lets go
				"Player.Manager_ImWithYou03", //Im with you
				"Player.Manager_LeadOn03", //You take the lead
				"Player.Manager_ReactionPositive05", //ALL RIGHT
				"Player.Manager_ReactionPositive06", //HOO heh heh hey
				"Player.Manager_ReactionPositive09", //Sweet baby
				"Player.Manager_revivefriend04", //Come on man, look at me, focus, you're gonna be ok lets get moving
				"Player.Manager_ScenarioJoin01", //Im here
				"Player.Manager_ScenarioJoin02", //Heeeello
				"Player.Manager_ScenarioJoin03", //Hey im here
				"npc.Manager_ViolenceAwe01", //Woah
				"npc.Manager_ViolenceAwe05", //Holy shit
				"Player.Manager_AskReady01", //Ready?
				"Player.Manager_AskReady02", //Ready?
				"Player.Manager_AskReady03", //Ready for this?
				"Player.Manager_AskReady04", //Ready for this?
				"Player.Manager_AskReady05", //Whaddya say, ready?
				"Player.Manager_AskReady06", //You ready to bounce?
				"Player.Manager_AskReady07", //You ready?
				"Player.Manager_AskReady09", //Im ready, you ready?
				"Player.Manager_Hurrah06", //WE ARE GONNA BE OK
				"Player.Manager_Hurrah07", //Man I think we gonna make it
				"Player.Manager_MoveOn01", //Alright lets go
				"Player.Manager_MoveOn02", //Time to move
				"Player.Manager_MoveOn03", //Lets go
				"Player.Manager_MoveOn04", //Lets move lets move
				"Player.Manager_MoveOn07", //Lets go
				"Player.Manager_MoveOn08", //Time to move
				"Player.Manager_NiceJob", //Nice
				"Player.Manager_RadioUsedGeneric01", //Our ride outta here its on its way
				"Player.Manager_RadioUsedGeneric02", //Help is on the way a few more minutes and we're outta here for good
				"Player.Manager_RadioUsedGeneric03", //Help is on the way, I cant believe it [...]
				"Player.Manager_Thanks01", //Thanks
				"Player.Manager_Thanks03", //Thanks I owe you one
				"Player.Manager_Thanks04", //Thanks :)
				"Player.Manager_Thanks05", //Thanks man
				"Player.Manager_Thanks06", //Thanks man :)
				"Player.Manager_Thanks07", //Thank you
				"Player.Manager_Thanks08", //Thanks I owe you a big one
				"Player.Manager_Thanks09", //Thanks a lot
				"Player.Manager_Thanks10", //Whoo thanks
				"Player.Manager_Thanks11", //Hey thanks
				"Player.Manager_Thanks12", //Thanks dawg
				"Player.Manager_Thanks14", //Thanks playa
				"Player.Manager_Yes01", //Alright
				"Player.Manager_Yes05", //Okay :)
				"Player.Manager_Yes07", //I'm cool with that
				"Player.Manager_Yes09", //Cool
			];
		break;

		case "dropped":
			lineArray =
			[
				"Manager_DLC1_C6M3_FinaleChat39", // Okay :(
				"Manager_DLC1_C6M3_L4D1FinaleBridgeRun03", //bye rochelle bye nick bye coach bye ellis (only use if on l4d2 survivor set)!!!!!!!
				"Manager_DLC1_C6M3_L4D1FinaleCinematic05", //bye ro bye coach bye ellis bye whats your name (only use if on l4d2 survivor set)!!!!!!!!
				"Manager_DLC1_C6M3_L4D1FinaleCinematic01", //Im gonna miss them
				"Manager_DLC1_C6M3_L4D1FinaleCinematic02", //It was nice to see normal people again
				"Manager_DLC1_C6M3_L4D1FinaleCinematic03", //It was nice to see normal people again, except for that nick guy (only use if on l4d2 survivor set)!!!!!!!!
				"npc.Manager_Dying01", //GUYS I NEED HELP NOW
				"npc.Manager_Dying02", //YO I NEED SOME HELP RIGHT NOW
				"npc.Manager_Dying03", //YO I NEED HELP RIGHT THE HELL NOW
				"npc.Manager_Dying04", //I NEED HELP RIGHT THE HELP NOW
				"npc.Manager_GenericResponses03", //You're joking right
				"npc.Manager_GenericResponses25", //Tell me you aint serious
				"npc.Manager_GenericResponses39", //Oh no aint no damn way
				"npc.Manager_GoingToDieLight16", //I dont wanna die [...]
				"npc.Manager_IncapacitatedInitial01", //Ah im down
				"npc.Manager_IncapacitatedInitial02", //Ah im down
				"npc.Manager_IncapacitatedInitial03", //Jesus im down
				"npc.Manager_IncapacitatedInitial04", //Shit im down
				"npc.Manager_InsideSafeRoom05", //We cannot leave anyone behind
				"npc.Manager_Manager_FriendlyFireFrancis07", //Go on, do it one more time fat man
				"Player.Manager_C6DLC3INTRO16", //Yeah im really pissed
				"Player.Manager_C6DLC3INTRO17", //Yeah im really pissed
				"Player.Manager_C6DLC3JUMPINGOFFBRIDGE06", //Im gonna miss you guys
				"Player.Manager_DLC2M2FinaleButtonPressLift01", //Im sure this will just take a second
				"Player.Manager_FriendlyFire01", //Hey man that hurt
				"Player.Manager_FriendlyFire06", //Hey man thats not cool
				"Player.Manager_FriendlyFire13", //Aaaah motherf-
				"Player.Manager_GoingToDie11", //At this rate im not gonna make it
				"Player.Manager_GoingToDie20", //I shoulda stayed in the damn store
				"Player.Manager_GoingToDie22", //AAAHH damn it
				"Player.Manager_GoingToDie26", //Im not gonna make it man
				"Player.Manager_GrabbedBySmoker01a", //No no no!
				"Player.Manager_GrabbedBySmoker01b", //NOOO
				"Player.Manager_GrabbedBySmoker02a", //NO NO
				"Player.Manager_GrabbedBySmoker02b", //No NOOOO
				"Player.Manager_GrabbedBySmoker03a", //Nono, no
				"Player.Manager_GrabbedBySmoker03b", //NOOOOOOOOO
				"Player.Manager_GrabbedBySmoker04", //NO NO, NO, NO
				"Player.Manager_LedgeHangEnd04", //Somebody somebody OH SHIT IM FALLIN IM FALLIN
				"Player.Manager_NegativeNoise03", //(buzzing lips sound)
				"Player.Manager_ReactionNegative01", //Uh oh
				"Player.Manager_StayTogether02", //Come on we've got to stay together
				"Player.Manager_StayTogether05", //We've got to stick together
				"Player.Manager_StayTogether06", //Nobody run off
				"Player.Manager_WaitHere04", //Everybody hold up
				"Player.Manager_WaitHere05", //Hold up hold up
				"npc.Manager_GettingRevived08", //I'll live
				"npc.Manager_GettingRevived09", //I can shake it off
				"npc.Manager_Swears02", //Damn it
				"npc.Manager_Swears03", //Aww hell
				"npc.Manager_Swears05", //Ssshit
				"npc.Manager_Swears06", //Aww shit
				"npc.Manager_Swears07", //Shit shit shit
				"npc.Manager_Swears10", //Damn it
				"npc.Manager_Swears11", //Aww hell
				"npc.Manager_Swears12", //Shit
				"npc.Manager_Swears13", //Aww shit
				"npc.Manager_ViolenceAwe08", //Jee-sus
				"npc.Manager_GoingToDieLight15", //This is some real bullshit right here
				"Player.Manager_Hurrah01", //ALL RIGHT
				"Player.Manager_MoveOn05", //I really think we should keep moving
				"Player.Manager_ReactionBoomerVomit01", //(spitting)
				"Player.Manager_ReactionBoomerVomit02", //Eww eugh (spitting)
				"Player.Manager_ReactionBoomerVomit03", //(gagging)
				"Player.Manager_ReactionBoomerVomit04", //(spitting)
				"Player.Manager_ReactionApprehensive01", //I got a bad feeling about this
				"Player.Manager_ReactionApprehensive03", //Man I dont like this one damn bit
				"Player.Manager_TeamKillAccident01", //Woah man you gotta be careful
				"Player.Manager_TeamKillAccident02", //Woah man you gotta be careful
				"Player.Manager_TeamKillAccident03", //What the hell man
				"Player.Manager_TeamKillAccident04", //Be careful what are you doing
			];
		break;

		case "rescue":
			lineArray =
			[
				"npc.Manager_NiceShot09", //POW
				"npc.Manager_NiceShot10", //Aw hell yes
				"npc.Manager_PlayerTransitionClose03", //Well at least we're safe now
				"npc.Manager_PlayerTransitionClose04", //Boom diyah
				"npc.Manager_SafeSpotAheadReaction01", //Finally
				"npc.Manager_SafeSpotAheadReaction02", //WE MADE IT
				"npc.Manager_SafeSpotAheadReaction03", //I knew we'd make it
				"npc.Manager_SafeSpotAheadReaction05", //Man i knew we were gonna make
				"npc.Manager_ToTheRescueThanks01", //Thanks for getting me outta there
				"npc.Manager_ToTheRescueThanks02", //Thanks man
				"npc.Manager_ToTheRescueThanks03", //Yo thanks man
				"Player.Manager_C6DLC3JUMPINGOFFBRIDGE14", //I love you guys
				"Player.Manager_C6DLC3JUMPINGOFFBRIDGE15", //I love you guys
				"Player.Manager_NiceShot03", //WOOOO nice baby
				"Player.Manager_PositiveNoise02", //Ha ha yeah
				"Player.Manager_PositiveNoise03", //WOOO
				"Player.Manager_Taunt01", //Thats right
				"Player.Manager_Taunt02", //HOO HOO Thats right
				"Player.Manager_Taunt03", //YEAH BABY YEAH
				"Player.Manager_Taunt04", //All right!
				"Player.Manager_Taunt05", //Oh yeah whose yo momma whose your daddy
				"Player.Manager_Taunt06", //Hell yeah, HELL yeah
				"Player.Manager_Taunt07", //MWUHAHAHA HAHAHA
				"Player.Manager_Taunt08", //MWHAHAHA
				"Player.Manager_Taunt09", //AHAHAHAhahahaha
				"Player.Manager_Taunt10", //NAHAHAHAHA Yeah
				"Player.Manager_CloseTheDoor01", //Lock that door
				"Player.Manager_CloseTheDoor02", //Lock the door
				"Player.Manager_CloseTheDoor03", //Lock the damn door
				"Player.Manager_CloseTheDoor04", //Go ahead and lock that door
				"Player.Manager_CloseTheDoor05", //Lock the damn door
				"Player.Manager_CloseTheDoor06", //Did you lock the door?
				"Player.Manager_CloseTheDoor07", //Lock the door man
				"Player.Manager_Hurrah02", //WOOO BABY alright
				"Player.Manager_Hurrah03", //Hell yeah
				"Player.Manager_Hurrah09", //Nothing can stop us
				"Player.Manager_Hurrah10", //Nothing can stop us, do you hear me [...]
				"Player.Manager_Hurrah11", //We are unstoppable
				"Player.Manager_Hurrah12", //We should call ourselves the unstoppables
				"Player.Manager_Hurrah13", //We are unstoppable
				"Player.Manager_Hurrah14", //Yeah
				"Player.Manager_Hurrah15", //YEAHHHH WOO
				"Player.Manager_NiceJob04", //Damn man that was nice
				"Player.Manager_NiceJob05", //That was great
				"Player.Manager_NiceJob06", //That was cool
			];
		break;
	}

	lineChosen = lineArray[RandomInt(0, lineArray.len() - 1)];

	if (!IsSoundPrecached(lineChosen))
	{
		PrecacheSound(lineChosen);
	}

	return lineChosen;
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
