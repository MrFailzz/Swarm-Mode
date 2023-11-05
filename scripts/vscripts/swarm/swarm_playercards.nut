///////////////////////////////////////////////
//                PLAYER CARDS               //
///////////////////////////////////////////////
if (!IsSoundPrecached("Christmas.GiftPickup"))
	PrecacheSound("Christmas.GiftPickup");

function PickCard(player, cardID)
{
	local cardNumber = cardID;
	local card = null;
	local cardName = null;
	local cardTable = {};
	local survivorID = null;

	if (cardNumber != "" && cardNumber <= cardsPerCategory * 4)
	{
		card = pickableCards[cardNumber - 1];
		cardName = GetPlayerCardName(card);
		survivorID = GetSurvivorID(player);

		if (cardPickingAllowed[survivorID] > 0)
		{
			cardPickingAllowed[survivorID] -= 1;
			AddCardToTable(GetSurvivorCardTable(survivorID), player, card);
			GetAllPlayerCards();
			ApplyCardEffects(player);
		}

		if (cardPickingAllowed[survivorID] == 0)
		{
			cardShuffleVote[survivorID] = true;
			ShuffleVote(player, true);
		}

		if (card == "Gambler")
		{
			PrintGamblerValue(player);
		}
	}
}

function ApplyCardEffects(player, heal = true)
{
	CalcMaxHealth(heal);
	CalcSpeedMultiplier(player);
	CalcUseSpeed();
	CalcMaxAmmo();
	CalcChainsaw();
	CalcGrenadeLauncher();
	EquipOptics(player);
	ApplyLastLegs();
	ApplyNeedsOfTheMany();
	ApplyCauterized();
	ApplyShovePenalties(player);
}

function AddCardToTable(cardTable, player, card)
{
	//Check if key in table
	if (card in cardTable)
	{
		cardTable[card] += 1;
	}
	else
	{
		cardTable[card] <- 1;
	}

	ClientPrint(player, 3, "\x03" + "Card Played: " + "\x04" + GetPlayerCardName(card) + " \x01(" + GetPlayerCardName(card, "desc") + ")");
	EmitSoundOnClient("Christmas.GiftPickup", player);

}

function InitCardPicking(shuffle = false)
{
	if (shuffle)
	{
		reflexCardsPick = array(cardsPerCategory);
		brawnCardsPick = array(cardsPerCategory);
		disciplineCardsPick = array(cardsPerCategory);
		fortuneCardsPick = array(cardsPerCategory);
	}
	reflexCardsPick = ReduceCardArray(reflexCardsPick, reflexCards);
	brawnCardsPick = ReduceCardArray(brawnCardsPick, brawnCards);
	disciplineCardsPick = ReduceCardArray(disciplineCardsPick, disciplineCards);
	fortuneCardsPick = ReduceCardArray(fortuneCardsPick, fortuneCards);

	UpdateCardPickHUD();

	if (!shuffle)
	{
		local cardPicks = 1 + missionsCompleted["completed"];

		if (Director.IsSessionStartMap())
		{
			cardPicks = 2 + missionsCompleted["completed"];
		}
		else
		{
			cardPicks = 1 + missionsCompleted["completed"];
		}
		
		cardPickingAllowed = [cardPicks, cardPicks, cardPicks, cardPicks];
		ClientPrint(null, 3, "\x01" + "Use " + "\x03" + "!pick [1-8]\x01" + " to choose a card (" + "\x03" + cardPicks + " remaining" + "\x01" + ")");
	}
}

function UpdateCardPickHUD()
{
	local hudY = swarmHudY;
	hudY = GetPickableCardsString(reflexCardsPick, 1, "REFLEX\n", "cardPickReflex", HUD_MID_BOX, hudY);
	hudY = GetPickableCardsString(brawnCardsPick, 1 + cardsPerCategory, "BRAWN\n", "cardPickBrawn", HUD_MID_BOT, hudY);
	hudY = GetPickableCardsString(disciplineCardsPick, 1 + (cardsPerCategory * 2), "DISCIPLINE\n", "cardPickDiscipline", HUD_RIGHT_TOP, hudY);
	hudY = GetPickableCardsString(fortuneCardsPick, 1 + (cardsPerCategory * 3), "FORTUNE\n", "cardPickFortune", HUD_RIGHT_BOT, hudY);
}

function ReduceCardArray(pickArray, refArray)
{
	local cloneRefArray = refArray;
	local iPick = 0;
	local iRef = null;
	local refLength = cloneRefArray.len();

	while (iPick < cardsPerCategory)
	{
		iRef = RandomInt(0, (refLength - 1) - iPick);
		pickArray[iPick] = cloneRefArray[iRef];

		cloneRefArray.remove(iRef);

		iPick++;
	}

	return pickArray;
}

function GetPickableCardsString(cardArray, cardCount, prefix, hudName, hudPlacement, hudY)
{
	local arrayLength = cardArray.len();
	local cardsString = prefix;
	local i = 0;
	local card = null;

	while (i < cardsPerCategory)
	{
		card = cardArray[i];

		if (i == cardsPerCategory - 1)
		{
			cardsString = cardsString + cardCount + ") " + GetPlayerCardName(card) + ": " + GetPlayerCardName(card, "desc");
		}
		else
		{
			cardsString = cardsString + cardCount + ") " + GetPlayerCardName(card) + ": " + GetPlayerCardName(card, "desc") + "\n";
		}

		pickableCards[cardCount - 1] = card;
		cardCount++;
		i++;
	}

	swarmHUD.Fields[hudName].dataval = cardsString;

	local hudH = swarmHudH + (swarmHudLineH * (i == 0 ? 1 : i));
	local placementHudY = 0;
	if (hudPlacement == HUD_MID_BOX)
	{
		placementHudY = 0.014;
	}
	else
	{
		placementHudY = hudY;
	}

	HUDPlace(hudPlacement, 0.5 - (swarmHudMidBoxW / 2), placementHudY, swarmHudMidBoxW, hudH);
	hudY = hudY + hudH + swarmHudGapY;
	return hudY;
}

function MapTransition(params)
{
	SaveSettingsTable();
	SavePlayerCards();

	missionsCompleted["completed"] = 0;
	SaveMissions();

	//WellRested
	local WellRested = TeamHasCard("WellRested");
	local player = null;
	if (WellRested > 0)
	{
		while ((player = Entities.FindByClassname(player, "player")) != null)
		{
			if (player.IsSurvivor())
			{
				player.SetHealth(player.GetMaxHealth());
				player.SetHealthBuffer(0);
			}
		}
	}
}

function SavePlayerCards()
{
	if (swarmMode != "vs" && swarmMode != "survival_vs")
	{
		//End of map
		printl("SAVED CARDS");

		//Save table for next map
		SaveTable("p1Cards", p1Cards);
		SaveTable("p2Cards", p2Cards);
		SaveTable("p3Cards", p3Cards);
		SaveTable("p4Cards", p4Cards);
	}
}

function SaveMissions()
{
	if (swarmMode != "vs" && swarmMode != "survival_vs")
	{
		local completed = false;
		switch(corruptionMission)
		{
			case "None":
			break;
			case "missionSpeedrun":
				if (MissionSpeedrun_Timer <= MissionSpeedrun_Goal)
				{
					completed = true;
				}
			break;

			case "missionAllAlive":
				if (GetAliveCleaners() == GetTotalCleaners())
				{
					completed = true;
				}
			break;

			case "missionGnomeAlone":
				if (MissionGnomeAlone_Status == 3)
				{
					completed = true;
				}
			break;

			case "missionGnomeAlone":
				if (MissionGnomeAlone_Status == 3)
				{
					completed = true;
				}
			break;

			case "missionSilenceIsGolden":
				if (MissionSilenceFailed == false)
				{
					completed = true;
				}
			break;

			case "missionSafetyFirst":
				if (MissionSafetyFirstIncaps <= 4)
				{
					completed = true;
				}
			break;
		}

		if (completed == true)
		{
			CompletedMission(corruptionMission);
		}
		else
		{
			//TODO: Always returns mission as null for some reason, fix
			//FailedMission(corruptionMission);
		}

		SaveTable("missionsCompleted", missionsCompleted);
	}
}

function CompletedMission(cardID)
{
	missionsCompleted["completed"] = 1;
	local cardName = GetCorruptionCardName(cardID);
	ClientPrint(null, 3, "\x01" + "Objective: " + "\x03" + cardName + "\x01" + " completed!");
}

function FailedMission(cardID)
{
	local cardName = GetCorruptionCardName(cardID);
	ClientPrint(null, 3, "\x01" + "Objective: " + "\x03" + cardName + "\x01" + " failed.");
}

function RoundFreezeEnd(params)
{
	LoadSettingsTable();
	LoadPlayerCards();
	LoadMissions();

	//Save cards so they can be loaded if a wipe occurs, as loading the tables deletes the stored tables
	SavePlayerCards();

	InitCardPicking();
	GetAllPlayerCards();
}

function LoadPlayerCards()
{
	if (swarmMode != "vs" && swarmMode != "survival_vs")
	{
		//Start of a new map
		printl("LOADED CARDS");

		//Load table from memory
		RestoreTable("p1Cards", p1Cards);
		RestoreTable("p2Cards", p2Cards);
		RestoreTable("p3Cards", p3Cards);
		RestoreTable("p4Cards", p4Cards);
	}
}

function LoadMissions()
{
	RestoreTable("missionsCompleted", missionsCompleted);
	SaveTable("missionsCompleted", missionsCompleted);
}

function RoundStartPostNav(params)
{
	//Clear saved cards on new session
	if (Director.IsSessionStartMap())
	{
		SavePlayerCards()

		missionsCompleted["completed"] = 0;
		SaveMissions();
	}
}

function GetAllPlayerCards()
{
	local survivorNameArray = [Loc("#bot_Bill"), Loc("#bot_Zoey"), Loc("#bot_Louis"), Loc("#bot_Francis")];
	if (survivorSet == 2)
	{
		survivorNameArray = [Loc("#bot_Nick"), Loc("#bot_Rochelle"), Loc("#bot_Coach"), Loc("#bot_Ellis")];
	}

	local player = null;
	local canPickString = ["","","",""];
	local survivorID = null;
	while ((player = Entities.FindByClassname(player, "player")) != null)
	{
		survivorID = GetSurvivorID(player);

		if (player.IsSurvivor() && survivorID != -1)
		{
			if (!IsPlayerABot(player))
			{
				survivorNameArray[survivorID] = player.GetPlayerName().toupper();
			}
		}
	}


	for (local i = 0; i <= 3; i++)
	{
		if (cardPickingAllowed[i] > 0)
		{
			canPickString[i] = " (" + cardPickingAllowed[i] + " remaining)";
		}
	}

	local hudY = swarmHudY;
	hudY = GetEquippedCardsString(p1Cards, survivorNameArray[0] + canPickString[0], "playerCardsP1", HUD_FAR_LEFT, hudY);
	hudY = GetEquippedCardsString(p2Cards, survivorNameArray[1] + canPickString[1], "playerCardsP2", HUD_LEFT_TOP, hudY);
	hudY = GetEquippedCardsString(p3Cards, survivorNameArray[2] + canPickString[2], "playerCardsP3", HUD_LEFT_BOT, hudY);
	hudY = GetEquippedCardsString(p4Cards, survivorNameArray[3] + canPickString[3], "playerCardsP4", HUD_MID_TOP, hudY);
}

function GetEquippedCardsString(cardTable, prefix, hudName, hudPlacement, hudY)
{
	DeepPrintTable(cardTable);

	local cardsString = prefix;
	local cardName = null;
	local lineCount = 0;
	local cardCountString = "";

	foreach(key, value in cardTable)
	{
		if (value > 0)
		{
			cardName = GetPlayerCardName(key);
			if (cardName != "None")
			{
				if (value == 1)
				{
					cardCountString = "";
				}
				else
				{
					cardCountString = " (x" + value + ")"
				}

				cardsString = cardsString + "\n" + cardName + cardCountString;
				lineCount++;
			}
		}
	}

	swarmHUD.Fields[hudName].dataval = cardsString;

	local hudH = swarmHudH + (swarmHudLineH * (lineCount == 0 ? 1 : lineCount))
	HUDPlace(hudPlacement, swarmHudX, hudY, swarmHudW, hudH);
	hudY = hudY + hudH + swarmHudGapY;
	return hudY;
}

function SurvivorSpawn(player)
{
	//Change one time properties when a player spawns/respawns
	//Some of these are preserved correctly on map transition (max health), but usually not if the player is dead
	ApplyCardEffects(player, false);
	if (PlayerHasCard(player, "Gambler") > 0)
	{
		PrintGamblerValue(player);
	}
}

function CalcMaxHealth(heal = true)
{
	local player = null;
	while ((player = Entities.FindByClassname(player, "player")) != null)
	{
		if (player.IsSurvivor())
		{
			local playerID = GetSurvivorID(player);
			local Gambler = PlayerHasCard(player, "Gambler");
			//local CombatMedic = TeamHasCard("CombatMedic");
			local TraumaResistance = 1; //+ (-0.2 * CombatMedic);
			if (Gambler > 0)
			{
				TraumaResistance += ApplyGamblerValue(playerID, 2, Gambler);
			}
			if (TraumaResistance < 0)
			{
				TraumaResistance = 0;
			}

			local PlayerIncaps = NetProps.GetPropInt(player, "m_currentReviveCount");
			local MaxIncaps = MutationOptions.SurvivorMaxIncapacitatedCount;
			local TraumaDamage = ((PlayerIncaps.tofloat() / MaxIncaps.tofloat()) * MaxTraumaDamage) * TraumaResistance;
			
			/*(if (!IsPlayerABot(player))
			{
				printl("incaps " + PlayerIncaps);
				printl("max incaps " + MaxIncaps);
				printl("trauma " + TraumaDamage);
				printl("max dmg " + MaxTraumaDamage);
			}*/

			local CannedGoods = PlayerHasCard(player, "CannedGoods");
			local SlowAndSteady = PlayerHasCard(player, "SlowAndSteady");
			local FleetOfFoot = PlayerHasCard(player, "FleetOfFoot");
			local CrossTrainers = PlayerHasCard(player, "CrossTrainers");
			local Coach = PlayerHasCard(player, "Coach");
			local SelflessPlayer = PlayerHasCard(player, "Selfless");
			local SelflessTeam = TeamHasCard("Selfless") - SelflessPlayer;
			local SelfishPlayer = PlayerHasCard(player, "Selfish");
			local SelfishTeam = TeamHasCard("Selfish") - SelfishPlayer;
			local NeedsOfTheMany = PlayerHasCard(player, "NeedsOfTheMany");
			local MeanDrunk = PlayerHasCard(player, "MeanDrunk");
			local WellFed = TeamHasCard("WellFed");
			local ExperiencedEMT = 0;
			if (playerID > -1)
			{
				ExperiencedEMT = experiencedEMT[playerID];
			}

			local currentMax = player.GetMaxHealth();
			local newMax = ((100 - TraumaDamage)
							+ (40 * CannedGoods)
							+ (50 * SlowAndSteady)
							+ (-10 * FleetOfFoot)
							+ (5 * CrossTrainers)
							+ (10 * Coach)
							+ (-15 * SelflessPlayer)
							+ (20 * SelflessTeam)
							+ (40 * SelfishPlayer)
							+ (-5 * SelfishTeam)
							+ (-10 * NeedsOfTheMany)
							+ (20 * MeanDrunk)
							+ (10 * WellFed)
							+ (25 * ExperiencedEMT));
			if (Gambler > 0)
			{
				newMax += ApplyGamblerValue(playerID, 0, Gambler);
			}
			local currentHealth = player.GetHealth();
			local healthAdjustment = newMax - currentMax;

			if (newMax < 1)
			{
				newMax = 1;
				healthAdjustment = 0;
			}

			if (newMax != currentMax)
			{
				player.SetMaxHealth(newMax);

				if ((healthAdjustment > 0 && heal) || currentHealth == currentMax)
				{
					player.SetHealth(currentHealth + healthAdjustment);
				}

				if (newMax == 1)
				{
					player.SetHealth(1);
				}
			}
		}
	}
}

function CalcSpeedMultiplier(player)
{
	local Gambler = PlayerHasCard(player, "Gambler");
	local SlowAndSteady = PlayerHasCard(player, "SlowAndSteady");
	local FleetOfFoot = PlayerHasCard(player, "FleetOfFoot");
	local CrossTrainers = PlayerHasCard(player, "CrossTrainers");
	local MethHead = PlayerHasCard(player, "MethHead");
	local Berserker = PlayerHasCard(player, "Berserker");
	local Addict = PlayerHasCard(player, "Addict");
	local AddictMultiplier = AddictGetValue(player);
	local Louis = PlayerHasCard(player, "Louis");
	local RunLikeHell = PlayerHasCard(player, "RunLikeHell");

	local speedMultiplier = (1
							+ (-0.1 * SlowAndSteady)
							+ (0.125 * FleetOfFoot)
							+ (0.07 * CrossTrainers)
							+ (0.025 * MethHead * MethHeadCounter[GetSurvivorID(player)])
							+ (0.05 * Berserker) + (AddictMultiplier * Addict)
							+ (0.1 * Louis)
							+ (0.3 * RunLikeHell));
	if (Gambler > 0)
	{
		speedMultiplier += ApplyGamblerValue(GetSurvivorID(player), 3, Gambler);
	}

	if (speedMultiplier <= 0.1)
	{
		speedMultiplier = 0.1;
	}

	if (NetProps.GetPropFloat(player, "m_flLaggedMovementValue") != speedMultiplier)
	{
		NetProps.SetPropFloat(player, "m_flLaggedMovementValue", speedMultiplier)
	}
}

function CalcUseSpeed()
{
	local fatiguePenalty = 1;
	if (corruptionPlayer == "playerFatigue")
	{
		fatiguePenalty = sluggishMultiplier;
	}
	local Multitool = TeamHasCard("Multitool");
	local MultitoolMulti = 0.5 * Multitool;
	local Screwdriver = TeamHasCard("Screwdriver");
	local ScrewdriverMulti = 0.25 * Screwdriver;
	local HelpingHand = TeamHasCard("HelpingHand");
	local HelpingHandMulti = 0.5 * HelpingHand;
	local CombatMedic = TeamHasCard("CombatMedic");
	local CombatMedicMulti = 0.15 * CombatMedic;
	local SmellingSalts = TeamHasCard("SmellingSalts");
	local SmellingSaltsMulti = 1.5 * SmellingSalts;
	local MedicalExpert = TeamHasCard("MedicalExpert");
	local MedicalExpertMulti = 0.1 * MedicalExpert;

	//Use Speed
	Convars.SetValue("ammo_pack_use_duration", (ammo_pack_use_duration * fatiguePenalty) / (1 + MultitoolMulti + ScrewdriverMulti));
	Convars.SetValue("cola_bottles_use_duration", (cola_bottles_use_duration * fatiguePenalty) / (1 + MultitoolMulti + ScrewdriverMulti));
	Convars.SetValue("first_aid_kit_use_duration", (first_aid_kit_use_duration * fatiguePenalty) / (1 + MultitoolMulti + ScrewdriverMulti));
	Convars.SetValue("gas_can_use_duration", (gas_can_use_duration * fatiguePenalty) / (1 + MultitoolMulti + ScrewdriverMulti));
	Convars.SetValue("upgrade_pack_use_duration", (upgrade_pack_use_duration * fatiguePenalty) / (1 + MultitoolMulti + ScrewdriverMulti));

	//Revive Speed
	Convars.SetValue("survivor_revive_duration", (survivor_revive_duration * fatiguePenalty) / (1 + HelpingHandMulti + CombatMedicMulti + SmellingSaltsMulti + MedicalExpertMulti));
	Convars.SetValue("defibrillator_use_duration", (defibrillator_use_duration * fatiguePenalty) / (1 + HelpingHandMulti + CombatMedicMulti + SmellingSaltsMulti + MedicalExpertMulti));
}

function CalcMaxAmmo()
{
	local ammoShortagePenalty = 1;
	if (corruptionPlayer == "playerLessAmmo")
	{
		ammoShortagePenalty = ammoShortageMultiplier;
	}
	local PackMule = TeamHasCard("PackMule");
	local PackMuleMultiplier = 0.4 * PackMule;

	Convars.SetValue("ammo_assaultrifle_max", (ammo_assaultrifle_max * ammoShortagePenalty) * (1 + PackMuleMultiplier));
	Convars.SetValue("ammo_autoshotgun_max", (ammo_autoshotgun_max * ammoShortagePenalty) * (1 + PackMuleMultiplier));
	Convars.SetValue("ammo_huntingrifle_max", (ammo_huntingrifle_max * ammoShortagePenalty) * (1 + PackMuleMultiplier));
	Convars.SetValue("ammo_shotgun_max", (ammo_shotgun_max * ammoShortagePenalty) * (1 + PackMuleMultiplier));
	Convars.SetValue("ammo_smg_max", (ammo_smg_max * ammoShortagePenalty) * (1 + PackMuleMultiplier));
	Convars.SetValue("ammo_sniperrifle_max", (ammo_sniperrifle_max * ammoShortagePenalty) * (1 + PackMuleMultiplier));
}

function CalcChainsaw()
{
	local Lumberjack = TeamHasCard("Lumberjack");
	local LumberjackMultiplier = 2 * Lumberjack;

	Convars.SetValue("chainsaw_damage", chainsaw_damage * (1 + LumberjackMultiplier));
}

function CalcGrenadeLauncher()
{
	local Cannoneer = TeamHasCard("Cannoneer");
	local CannoneerMultiplier = 2 * Cannoneer;

	Convars.SetValue("grenadelauncher_damage", grenadelauncher_damage * (1 + CannoneerMultiplier));
}

function InitOptics(params)
{
	local player = GetPlayerFromUserID(params["userid"]);

	if (player.IsValid())
	{
		if (player.IsSurvivor())
		{
			EquipOptics(player);
		}
	}
}

function EquipOptics(player)
{
	local OpticsEnthusiast = PlayerHasCard(player, "OpticsEnthusiast");

	if (OpticsEnthusiast > 0)
	{
		player.GiveUpgrade(UPGRADE_LASER_SIGHT);
	}
	else
	{
		//Doesnt work for some reason, maybe a timing issue
		player.RemoveUpgrade(UPGRADE_LASER_SIGHT);
	}
}

function ApplyLastLegs()
{
	local LastLegs = TeamHasCard("LastLegs");
	if (LastLegs > 0)
	{
		Convars.SetValue("survivor_allow_crawling", 1);
		Convars.SetValue("survivor_crawl_speed", survivorCrawlSpeed * LastLegs);
	}
	else
	{
		Convars.SetValue("survivor_allow_crawling", 0);
	}
}

function ApplyAdrenalineRush()
{
	//AdrenalineRush
	local AdrenalineRush = 0;
	local adrenalineDuration = Convars.GetFloat("adrenaline_duration");
	
	local player = null;
	while ((player = Entities.FindByClassname(player, "player")) != null)
	{
		if (player.IsSurvivor())
		{
			AdrenalineRush = PlayerHasCard(player, "AdrenalineRush");

			if (AdrenalineRush != 0)
			{
				player.UseAdrenaline(adrenalineDuration);
			}
		}
	}
}

function ApplyNeedsOfTheMany()
{
	MutationOptions.SurvivorMaxIncapacitatedCount = BaseMaxIncaps + TeamHasCard("NeedsOfTheMany");
}

function ApplyCauterized()
{
	local Cauterized = TeamHasCard("Cauterized");
	if (Cauterized > 0)
	{
		MutationOptions.TempHealthDecayRate = BaseTempHealthDecayRate * (0.5 / Cauterized);
	}
	else
	{
		MutationOptions.TempHealthDecayRate = BaseTempHealthDecayRate
	}
}

function WeaponReload(params)
{
	local player = GetPlayerFromUserID(params["userid"]);

	if (player != null)
	{
		if (player.IsPlayer())
		{
			if (player.IsSurvivor())
			{
				local weapon = player.GetActiveWeapon();
				//local weaponClass = weapon.GetClassname();
				local weaponSequence = weapon.GetSequence();
				local baseReloadSpeed = weapon.GetSequenceDuration(weaponSequence);
				local reloadModifier = GetReloadSpeedModifier(player);
				local newReloadSpeed = baseReloadSpeed / reloadModifier;

				local oldNextAttack = NetProps.GetPropFloat(weapon, "m_flNextPrimaryAttack");
				local newNextAttack = oldNextAttack - baseReloadSpeed + newReloadSpeed;
				local playbackRate = baseReloadSpeed / newReloadSpeed;

				NetProps.SetPropFloat(weapon, "m_flNextPrimaryAttack", newNextAttack);
				NetProps.SetPropFloat(player, "m_flNextAttack", newNextAttack);
				NetProps.SetPropFloat(weapon, "m_flPlaybackRate", playbackRate);
			}
		}
	}
}

function SurvivorPickupItem(params)
{
	local player = GetPlayerFromUserID(params["userid"]);
	local weaponClass = "";
	local weaponID = null;
	if (player.IsValid())
	{
		if (player.IsSurvivor())
		{
			local weapon = player.GetActiveWeapon();
			if (weapon != null)
			{
				if (weapon.IsValid())
				{
					weaponClass = weapon.GetClassname();
					weaponID = weapon.GetEntityIndex();

					if (weaponClass == "weapon_shotgun_chrome" || weaponClass == "weapon_pumpshotgun" || weaponClass == "weapon_autoshotgun" || weaponClass == "weapon_shotgun_spas")
					{
						//local shotgunThinker = SpawnEntityFromTable("info_target", { targetname = "shotgunThinker" + weaponID });
						if (weapon.ValidateScriptScope())
						{
							local entityscript = weapon.GetScriptScope();
							entityscript["player"] <- player;
							entityscript["weapon"] <- weapon;
							entityscript["weaponClass"] <- weaponClass;
							entityscript["reloadModifier"] <- 1;
							entityscript["reloadStartDuration"] <- NetProps.GetPropFloat(weapon, "m_reloadStartDuration");
							entityscript["reloadInsertDuration"] <- NetProps.GetPropFloat(weapon, "m_reloadInsertDuration");
							entityscript["reloadEndDuration"] <- NetProps.GetPropFloat(weapon, "m_reloadEndDuration");
							entityscript["weaponSequence"] <- weapon.GetSequence();

							entityscript["ShotgunReload"] <- function()
							{
								if (entityscript["player"].IsValid() && entityscript["weapon"].IsValid())
								{
									if (entityscript["player"].GetActiveWeapon() == entityscript["weapon"])
									{
										entityscript["reloadModifier"] = GetReloadSpeedModifier(entityscript["player"]);
										entityscript["reloadStartDuration"] = GetShotgunReloadDuration(entityscript["weaponClass"], 0);
										entityscript["reloadInsertDuration"] = GetShotgunReloadDuration(entityscript["weaponClass"], 1);
										entityscript["reloadEndDuration"] = GetShotgunReloadDuration(entityscript["weaponClass"], 2);

										NetProps.SetPropFloat(entityscript["weapon"], "m_reloadStartDuration", entityscript["reloadStartDuration"] / entityscript["reloadModifier"]);
										NetProps.SetPropFloat(entityscript["weapon"], "m_reloadInsertDuration", entityscript["reloadInsertDuration"] / entityscript["reloadModifier"]);
										NetProps.SetPropFloat(entityscript["weapon"], "m_reloadEndDuration", entityscript["reloadEndDuration"] / entityscript["reloadModifier"]);

										entityscript["weaponSequence"] = entityscript["weapon"].GetSequence();
										if (entityscript["weapon"].GetSequenceName(entityscript["weaponSequence"]) == "reload_end_layer")
										{
											if ((entityscript["player"].GetButtonMask() & 1) == 1)
											{
												NetProps.SetPropFloat(entityscript["weapon"], "m_flNextPrimaryAttack", Time());
												NetProps.SetPropFloat(entityscript["player"], "m_flNextAttack", Time());
											}
										}
										//printl("time " + Time() + " next " + NetProps.GetPropFloat(entityscript["weapon"], "m_flNextPrimaryAttack"));
									}
								}
							}

							AddThinkToEnt(weapon, "ShotgunReload");
						}
					}
					else if (weaponClass == "weapon_melee")
					{
						//local meleeThinker = SpawnEntityFromTable("info_target", { targetname = "meleeThinker" + weaponID });
						if (weapon.ValidateScriptScope())
						{
							local entityscript = weapon.GetScriptScope();
							entityscript["player"] <- player;
							entityscript["weapon"] <- weapon;
							entityscript["weaponSequence"] <- weapon.GetSequence();
							entityscript["baseMeleeSpeed"] <- 1;
							entityscript["meleeModifier"] <- 1;
							entityscript["newMeleeSpeed"] <- 1;
							entityscript["newNextAttack"] <- 1;
							entityscript["playbackRate"] <- 1;
							entityscript["storedLastAttack"] <- 0;
							entityscript["storedNextAttack"] <- 0;

							entityscript["MeleeThink"] <- function()
							{
								if (entityscript["player"].IsValid() && entityscript["weapon"].IsValid())
								{
									if (entityscript["player"].GetActiveWeapon() == entityscript["weapon"])
									{
										if (entityscript["storedLastAttack"] != NetProps.GetPropFloat(entityscript["weapon"], "m_flLastAttackTime"))
										{
											entityscript["storedNextAttack"] = NetProps.GetPropFloat(entityscript["weapon"], "m_flNextPrimaryAttack");
										}
										entityscript["storedLastAttack"] = NetProps.GetPropFloat(entityscript["weapon"], "m_flLastAttackTime");
										entityscript["weaponSequence"] = entityscript["weapon"].GetSequence();
										entityscript["baseMeleeSpeed"] = entityscript["weapon"].GetSequenceDuration(entityscript["weaponSequence"]);
										entityscript["meleeModifier"] = GetMeleeSpeedModifier(entityscript["player"]);
										entityscript["newMeleeSpeed"] = entityscript["baseMeleeSpeed"] / entityscript["meleeModifier"];
										entityscript["newNextAttack"] = (entityscript["storedNextAttack"] - entityscript["baseMeleeSpeed"]) + entityscript["newMeleeSpeed"];
										entityscript["playbackRate"] = entityscript["baseMeleeSpeed"] / entityscript["newMeleeSpeed"];

										if (entityscript["meleeModifier"] != 1)
										{
											NetProps.SetPropFloat(entityscript["weapon"], "m_flNextPrimaryAttack", entityscript["newNextAttack"]);
											NetProps.SetPropFloat(entityscript["weapon"], "m_flPlaybackRate", entityscript["playbackRate"]);
										}
										
										//printl("time " + Time() + " next " + NetProps.GetPropFloat(entityscript["weapon"], "m_flNextPrimaryAttack"));
									}
								}
							}

							AddThinkToEnt(weapon, "MeleeThink");
						}
					}
				}
			}
		}
	}
}

function ApplyCardsOnMutationKill(attacker, victim, headshot)
{
	//MethHead
	local MethHead = PlayerHasCard(attacker, "MethHead");
	if (MethHead > 0)
	{
		MethHeadCounter[GetSurvivorID(attacker)]++;
		CalcSpeedMultiplier(attacker);
		printl("Meth Head: " + MethHeadCounter[GetSurvivorID(attacker)]);
	}

	//HotShot
	local HotShot = PlayerHasCard(attacker, "HotShot");
	if (HotShot > 0)
	{
		//0 = UPGRADE_INCENDIARY_AMMO, 1 = UPGRADE_EXPLOSIVE_AMMO
		attacker.GiveUpgrade(RandomInt(0, 1));
	}

	//FaceYourFears
	local FaceYourFears = PlayerHasCard(attacker, "FaceYourFears");
	if (GetVectorDistance(attacker.GetOrigin(), victim.GetOrigin()) < 100)
	{
		if (FaceYourFears > 0)
		{
			Heal_TempHealth(attacker, 2 * FaceYourFears);
		}
	}

	//CleanKill
	local CleanKill = PlayerHasCard(attacker, "CleanKill");
	if (CleanKill > 0)
	{
		if (headshot == 1)
		{
			CleanKillCounter[GetSurvivorID(attacker)]++;
			printl("Clean Kill: " + CleanKillCounter[GetSurvivorID(player)]);
		}
	}

	//Overwatch
	local Overwatch = PlayerHasCard(attacker, "Overwatch");
	if (GetVectorDistance(attacker.GetOrigin(), victim.GetOrigin()) > 600)
	{
		local survivor = null;
		local victimOrigin = victim.GetOrigin();

		while ((survivor = Entities.FindByClassnameWithin(survivor, "player", victimOrigin, 600)) != null)
		{
			if (survivor.IsSurvivor())
			{
				Heal_TempHealth(survivor, 5 * Overwatch);
			}
		}
	}
}

function ApplyCardsOnWeaponFire(params)
{
	local player = GetPlayerFromUserID(params.userid);

	//HyperFocused
	local HyperFocused = PlayerHasCard(player, "HyperFocused");
	if (HyperFocused > 0)
	{
		NetProps.SetPropFloat(player, "m_flVelocityModifier", 0.8);
	}
}

function UpdateAddict(player)
{
	local AddictValue = AddictGetValue(player);
	if (AddictValue < 0)
	{
		//ScreenShake(vecCenter, flAmplitude, flFrequency, flDuration, flRadius, eCommand, bAirShake)
		local playerOrigin = player.GetOrigin();
		if (AddictValue < -0.15)
		{
			//Strong effect
			ScreenFade(player, 0, 0, 0, 140, 1, 1, 1 | 2);
			ScreenShake(Vector(playerOrigin.x, playerOrigin.y, playerOrigin.z + 34), RandomInt(4, 7), 10, 2, 5, 0, true);

			if (!addictPlaySound)
			{
				StopSoundOn("Player.Heartbeat", player);
				StopSoundOn("Player.Heartbeat", player);
				addictPlaySound = true;
			}
			else
			{
				EmitSoundOnClient("Player.Heartbeat", player);
				addictPlaySound = false;
			}
		}
		else
		{
			//Weak effect
			ScreenFade(player, 0, 0, 0, 90, 1, 1, 1 | 2);
			ScreenShake(Vector(playerOrigin.x, playerOrigin.y, playerOrigin.z + 34), RandomInt(2, 6), 10, 2, 5, 0, true);
		}
	}
	else
	{
		StopSoundOn("Player.Heartbeat", player);
	}
}

function ApplyShovePenalties(player)
{
	local survivorID = GetSurvivorID(player);
	local shovePenalty = 0;

	local MagCoupler = PlayerHasCard(player, "MagCoupler");
	if (MagCoupler > 0)
	{
		shovePenalty += 8;
	}

	local RunLikeHell = PlayerHasCard(player, "RunLikeHell");
	if (RunLikeHell > 0)
	{
		shovePenalty += 6;
	}

	local CannedGoods = PlayerHasCard(player, "CannedGoods");
	if (RunLikeHell > 0)
	{
		shovePenalty += 2;
	}

	baseShovePenalty[survivorID] = shovePenalty;
}

function UpdateShovePenalty(player)
{
	local survivorID = GetSurvivorID(player);
	local shovePenalty = NetProps.GetPropInt(player, "m_iShovePenalty");

	if (shovePenalty < baseShovePenalty[survivorID])
	{
		NetProps.SetPropInt(player, "m_iShovePenalty", baseShovePenalty[survivorID]);
	}
}

function UpdateBreakoutTimer(player)
{
	local survivorID = GetSurvivorID(player);
	local Breakout = 0;
	local startBreakoutTime = 0;

	// Check if survivor is grabbed
	local survivorSmoke = NetProps.GetPropEntity(player, "m_tongueOwner");
	local survivorPummel = NetProps.GetPropEntity(player, "m_pummelAttacker");
	local survivorCarry = NetProps.GetPropEntity(player, "m_carryAttacker");
	local survivorPounce = NetProps.GetPropEntity(player, "m_pounceAttacker");
	local survivorJockey = NetProps.GetPropEntity(player, "m_jockeyAttacker");

	Breakout = (PlayerHasCard(player, "Breakout"));

	if (Breakout > 1)
	{
		if (survivorSmoke != null || survivorPummel != null || survivorCarry != null || survivorPounce != null || survivorJockey != null)
		{
			if ((player.GetButtonMask() & IN_ATTACK2) && BreakoutTimer[survivorID] == 0 && BreakoutUsed[survivorID] < Breakout)
			{
				startBreakoutTime = Time();
				BreakoutTimer[survivorID]++;

				// Add progress bar for breakout
				NetProps.SetPropFloat(player, "m_flProgressBarStartTime", startBreakoutTime);
				NetProps.SetPropFloat(player, "m_flProgressBarDuration", BreakoutTimerDefault);
				NetProps.SetPropInt(player, "m_iCurrentUseAction", 10);
			}
			else if ((player.GetButtonMask() & IN_ATTACK2) && BreakoutTimer[survivorID] > 0)
			{
				BreakoutTimer[survivorID]++;

				if (BreakoutTimer[survivorID] > BreakoutTimerDefault && BreakoutUsed[survivorID] < Breakout)
				{
					// Free survivor from capper
					//FreeCapperVictim(player, survivorSmoke, "m_tongueOwner", "m_tongueVictim");
					//FreeCapperVictim(player, survivorPummel, "m_pummelAttacker", "m_pummelVictim");
					//FreeCapperVictim(player, survivorCarry, "m_carryAttacker", "m_carryAttacker");
					//FreeCapperVictim(player, survivorPounce, "m_pounceAttacker", "m_pounceVictim");
					//FreeCapperVictim(player, survivorJockey, "m_jockeyAttacker", "m_jockeyVictim");

					// Staggering survivor gets them out of grabs
					player.Stagger(Vector(-1, -1, -1));
					
					BreakoutUsed[survivorID]++;
					NetProps.SetPropInt(player, "m_iCurrentUseAction", 0);
				}
			}
			else
			{
				BreakoutTimer[survivorID] = 0;
				NetProps.SetPropFloat(player, "m_flProgressBarDuration", 0);
				NetProps.SetPropInt(player, "m_iCurrentUseAction", 0);
			}
		}
	}
}

function FreeCapperVictim(player, attacker, attackerProp, victimProp)
{
	if (attacker == null)
	{
		return;
	}

	if (NetProps.GetPropEntity(attacker, victimProp) == player)
	{
		NetProps.SetPropEntity(attacker, victimProp, null);
		NetProps.SetPropEntity(player, attackerProp, null);

		//Stumble the infected so they aren't right on top of the survivor
		//attacker.Stagger(Vector(-1, -1, -1));
	}
}

function BreakoutMsg(params)
{
	local player = GetPlayerFromUserID(params["victim"]);
	local survivorID = GetSurvivorID(player);

	if (PlayerHasCard(player, "Breakout"))
	{
		if (!BreakoutUsed[survivorID])
		{
			ClientPrint(player, 3,  Loc("#breakout_msg"));
		}
	}

}

function CardPickReminder()
{
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
					ClientPrint(player, 3, "\x01" + "Use " + "\x03" + "!pick [1-8]\x01" + " to choose a card (" + "\x03" + cardPickingAllowed[survivorID] + " remaining" + "\x01" + ")");

					local voteCount = 0;
					foreach(vote in cardShuffleVote)
					{
						if (vote)
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
}

function Update_PlayerCards()
{
	//Runs every second, put player card related functions in here instead of _stocks Update()

	CalcMaxHealth(false);
	CardPickReminder();

	local player = null;
	while ((player = Entities.FindByClassname(player, "player")) != null)
	{
		if (player.IsValid())
		{
			if (player.IsSurvivor())
			{
				CalcSpeedMultiplier(player);

				local HeightendSenses = PlayerHasCard(player, "HeightendSenses");
				if (HeightendSenses > 0)
				{
					HeightendSensesPing(player);
				}

				if (ValidAliveSurvivor(player))
				{
					local Addict = PlayerHasCard(player, "Addict");
					if (Addict > 0)
					{
						UpdateAddict(player);
					}
				}

				UpdateShovePenalty(player);
				UpdateBreakoutTimer(player);
			}
		}
	}
}
