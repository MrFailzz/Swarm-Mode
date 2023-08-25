///////////////////////////////////////////////
//                PLAYER CARDS               //
///////////////////////////////////////////////
function PickCard(player, cardID)
{
	local cardNumber = LetterToInt(cardID);
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
}

function InitCardPicking(shuffle = false)
{
	if (shuffle == true)
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

	local hudY = swarmHudY;
	hudY = GetPickableCardsString(reflexCardsPick, 1, "REFLEX\n", "cardPickReflex", HUD_MID_BOX, hudY);
	hudY = GetPickableCardsString(brawnCardsPick, 1 + cardsPerCategory, "BRAWN\n", "cardPickBrawn", HUD_MID_BOT, hudY);
	hudY = GetPickableCardsString(disciplineCardsPick, 1 + (cardsPerCategory * 2), "DISCIPLINE\n", "cardPickDiscipline", HUD_RIGHT_TOP, hudY);
	hudY = GetPickableCardsString(fortuneCardsPick, 1 + (cardsPerCategory * 3), "FORTUNE\n", "cardPickFortune", HUD_RIGHT_BOT, hudY);

	if (shuffle == false)
	{
		local cardPicks = 1 + missionsCompleted["completed"];
		cardPickingAllowed = [cardPicks, cardPicks, cardPicks, cardPicks];
		ClientPrint(null, 3, "\x01" + "Use " + "\x03" + "!pick [A-H]\x01" + " to choose a card (" + "\x03" + cardPicks + " remaining" + "\x01" + ")");
	}
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
		card = cardArray.pop();

		if (i == cardsPerCategory - 1)
		{
			cardsString = cardsString + IntToLetter(cardCount) + ") " + GetPlayerCardName(card) + ": " + GetPlayerCardName(card, "desc");
		}
		else
		{
			cardsString = cardsString + IntToLetter(cardCount) + ") " + GetPlayerCardName(card) + ": " + GetPlayerCardName(card, "desc") + "\n";
		}

		pickableCards[cardCount - 1] = card;
		cardCount++;
		i++;
	}

	swarmHUD.Fields[hudName].dataval = cardsString;

	local hudH = swarmHudH + (swarmHudLineH * (i == 0 ? 1 : i))
	HUDPlace(hudPlacement, 0.5 - (swarmHudMidBoxW / 2), hudY, swarmHudMidBoxW, hudH);
	hudY = hudY + hudH + swarmHudGapY;
	return hudY;
}

function MapTransition(params)
{
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
	switch(corruptionMission)
	{
		case "None":
			break;
		case "missionSpeedrun":
			if (MissionSpeedrun_Timer <= MissionSpeedrun_Goal)
			{
				CompletedMission(corruptionMission);
			}
			break;
		case "missionAllAlive":
			if (GetAliveCleaners() == GetTotalCleaners())
			{
				CompletedMission(corruptionMission);
			}
			break;
		case "missionGnomeAlone":
			if (MissionGnomeAlone_Status == 3)
			{
				CompletedMission(corruptionMission);
			}
			break;
	}

	SaveTable("missionsCompleted", missionsCompleted);
}

function CompletedMission(cardID)
{
	missionsCompleted["completed"] = 1;
	local cardName = GetCorruptionCardName(cardID);
	ClientPrint(null, 3, "\x01" + "Objective: " + "\x03" + cardName + "\x01" + " completed!");
}

function RoundFreezeEnd(params)
{
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
	if (Director.IsSessionStartMap() == true)
	{
		SavePlayerCards()

		missionsCompleted["completed"] = 0;
		SaveMissions();
	}
}

function GetAllPlayerCards()
{
	local survivorNameArray = ["BILL", "ZOEY", "LOUIS", "FRANCIS"];
	if (survivorSet == 2)
	{
		survivorNameArray = ["NICK", "ROCHELLE", "COACH", "ELLIS"];
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
			local Gambler = PlayerHasCard(player, "Gambler");
			local CombatMedic = TeamHasCard("CombatMedic");
			local TraumaResistance = 1 + (-0.2 * CombatMedic);
			if (Gambler > 0)
			{
				TraumaResistance += ApplyGamblerValue(GetSurvivorID(player), 2, Gambler, TraumaResistance);
			}
			if (TraumaResistance < 0)
			{
				TraumaResistance = 0;
			}

			local PlayerIncaps = NetProps.GetPropInt(player, "m_currentReviveCount");
			local MaxIncaps = DirectorOptions.SurvivorMaxIncapacitatedCount;
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

			local currentMax = player.GetMaxHealth();
			local newMax = (100 - TraumaDamage) + (30 * CannedGoods) + (50 * SlowAndSteady) + (-10 * FleetOfFoot) + (5 * CrossTrainers) + (10 * Coach) + (-15 * SelflessPlayer) + (15 * SelflessTeam) + (30 * SelfishPlayer) + (-5 * SelfishTeam) + (-10 * NeedsOfTheMany);
			if (Gambler > 0)
			{
				newMax += ApplyGamblerValue(GetSurvivorID(player), 0, Gambler, newMax);
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

				if ((healthAdjustment > 0 && heal == true) || currentHealth == currentMax)
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

	local speedMultiplier = (1
							+ (-0.1 * SlowAndSteady)
							+ (0.125 * FleetOfFoot)
							+ (0.07 * CrossTrainers)
							+ (0.025 * MethHead * MethHeadCounter[GetSurvivorID(player)])
							+ (0.05 * Berserker) + (AddictMultiplier * Addict)
							+ (0.1 * Louis));
	if (Gambler > 0)
	{
		speedMultiplier += ApplyGamblerValue(GetSurvivorID(player), 3, Gambler, speedMultiplier);
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
	local MultitoolMultiplier = 0.4 * Multitool;
	local HelpingHand = TeamHasCard("HelpingHand");
	local HelpingHandMultiplier = 0.75 * HelpingHand;

	Convars.SetValue("ammo_pack_use_duration", (ammo_pack_use_duration * fatiguePenalty) / (1 + MultitoolMultiplier));
	Convars.SetValue("cola_bottles_use_duration", (cola_bottles_use_duration * fatiguePenalty) / (1 + MultitoolMultiplier));
	Convars.SetValue("defibrillator_use_duration", (defibrillator_use_duration * fatiguePenalty) / (1 + MultitoolMultiplier));
	Convars.SetValue("first_aid_kit_use_duration", (first_aid_kit_use_duration * fatiguePenalty) / (1 + MultitoolMultiplier));
	Convars.SetValue("gas_can_use_duration", (gas_can_use_duration * fatiguePenalty) / (1 + MultitoolMultiplier));
	Convars.SetValue("upgrade_pack_use_duration", (upgrade_pack_use_duration * fatiguePenalty) / (1 + MultitoolMultiplier));
	Convars.SetValue("survivor_revive_duration", (survivor_revive_duration * fatiguePenalty) / (1 + MultitoolMultiplier + HelpingHandMultiplier));

	//Modify hold to use buttons
	/*local button = null;
	while ((button = Entities.FindByClassname(button, "func_button_timed")) != null)
	{
		//printl(NetProps.GetPropFloat(button, ""))
	}*/
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

function ApplyInspiringSacrifice()
{
	local InspiringSacrifice = TeamHasCard("InspiringSacrifice");

	local player = null;
	while ((player = Entities.FindByClassname(player, "player")) != null)
	{
		if (player.IsSurvivor())
		{
			if (!player.IsDead() && !player.IsIncapacitated() && !player.IsHangingFromLedge())
			{
				Heal_TempHealth(player, (25 * InspiringSacrifice));
			}
		}
	}
}

function ApplyNeedsOfTheMany()
{
	DirectorOptions.SurvivorMaxIncapacitatedCount = BaseMaxIncaps + TeamHasCard("NeedsOfTheMany");
}

function ApplyCauterized()
{
	local Cauterized = TeamHasCard("Cauterized") + 1;
	local IncapDecay = BaseSurvivorIncapDecayRate - Cauterized
	DirectorOptions.TempHealthDecayRate = BaseTempHealthDecayRate / (Cauterized + 1);
	Convars.SetValue("survivor_incap_decay_rate", (IncapDecay < 1 ? 1 : IncapDecay));
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
				local weaponClass = weapon.GetClassname();
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
						local shotgunThinker = SpawnEntityFromTable("info_target", { targetname = "shotgunThinker" + weaponID });
						if (shotgunThinker.ValidateScriptScope())
						{
							local entityscript = shotgunThinker.GetScriptScope();
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

							AddThinkToEnt(shotgunThinker, "ShotgunReload");
						}
					}
				}
			}
		}
	}
}

function HeightendSensesPing(player)
{
	local autoPingDuration = 2;
	local entity = null;
	while ((entity = Entities.FindInSphere(entity, player.GetOrigin(), 300)) != null)
	{
		//Ignore invalid entities
		local entityReturnName = GetEntityType(entity);
		if (entityReturnName == false)
		{
			continue;
		}

		//Ignore survivors
		if (entity.GetClassname() == "player")
		{
			if (entity.IsSurvivor())
			{
				continue;
			}
		}

		//Ignore items in inventory
		local player = null;
		local skipInventory = false;
		while ((player = Entities.FindByClassname(player, "player")) != null)
		{
			local invTable = {};
			GetInvTable(player, invTable);
			foreach(slot, weapon in invTable)
			{
				if (weapon == entity)
				{
					skipInventory = true;
				}
			}
		}
		if (skipInventory == true)
		{
			continue;
		}

		// Check if entity has a targetname
		local entityName = entity.GetName();
		local entityIndex = entity.GetEntityIndex();
		if (entityName == "")
		{
			// Give it a name
			entityName = "__pingtarget_" + entityIndex;
			DoEntFire("!self", "AddOutput", "targetname " + entityName, 0, entity, entity);
		}

		local canGlow = CanGlow(entityReturnName);
		if (canGlow == false && entity.GetClassname() != "player")
		{
			// Create fake prop for glow
			local glow_name = "__pingtarget_" + entityIndex + "_glow_";
			local entityAngles = entity.GetAngles();
			local entityAnglesY = entityAngles.y;

			local glow_target = SpawnEntityFromTable("prop_dynamic_override",
			{
				targetname = glow_name,
				origin = entity.GetOrigin(),
				angles = Vector(entityAngles.x, entityAnglesY, entityAngles.z),
				model = entity.GetModelName(),
				solid = 0,
				rendermode = 10
			});
			local entitySequence = entity.GetSequence();
			local sequenceName = entity.GetSequenceName(entitySequence);
			// Apply ping glow
			DoEntFire("!self", "SetParent", entityName, 0, null, glow_target);
			DoEntFire("!self", "StartGlowing", "", 0, null, glow_target);
			DoEntFire("!self", "SetAnimation", sequenceName, 0, null, glow_target);

			// Remove ping
			DoEntFire("!self", "StopGlowing", "", autoPingDuration, null, glow_target);
			DoEntFire("!self", "Kill", "", autoPingDuration, null, glow_target);
		}
		else if (canGlow == false && entity.GetClassname() == "player")
		{
			NetProps.SetPropInt(entity, "m_Glow.m_iGlowType", 3);

			if (entity.ValidateScriptScope())
			{
				local player_entityscript = entity.GetScriptScope();
				player_entityscript["TickCount"] <- 0;
				player_entityscript["GlowKill"] <- function()
				{
					if (player_entityscript["TickCount"] >= 12)
					{
						NetProps.SetPropInt(entity, "m_Glow.m_iGlowType", 0);
						return
					}
					player_entityscript["TickCount"]++;
					return
				}
				AddThinkToEnt(entity, "GlowKill");
			}
			else
			{
				NetProps.SetPropInt(entity, "m_Glow.m_iGlowType", 0);
			}
		}
		else if (canGlow == true)
		{
			// Apply ping glow
			DoEntFire("!self", "StartGlowing", "", 0, null, entityName);

			// Remove ping
			DoEntFire("!self", "StopGlowing", "", autoPingDuration, null, entityName);
		}
		else if (canGlow == "crows")
		{
			local nameArray = split(entityName, "_");
			local crowGroupName = "__" + nameArray[0] + "_" + nameArray[1] + "_" + nameArray[2] + "*";

			// Apply ping glow
			EntFire(crowGroupName, "StartGlowing", "", 0);

			// Remove ping
			EntFire(crowGroupName, "StopGlowing", "", autoPingDuration);
		}
	}
}

function Update_PlayerCards()
{
	//Runs every second

	CalcMaxHealth(false);

	local player = null;
	while ((player = Entities.FindByClassname(player, "player")) != null)
	{
		if (player.IsSurvivor())
		{
			CalcSpeedMultiplier(player);

			local HeightendSenses = PlayerHasCard(player, "HeightendSenses");
			if (HeightendSenses > 0)
			{
				HeightendSensesPing(player);
			}

			if (!player.IsDead() && !player.IsIncapacitated() && !player.IsHangingFromLedge())
			{
				local Addict = PlayerHasCard(player, "Addict");
				if (Addict > 0)
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

							if (addictPlaySound == false)
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
			}
		}
	}
}
