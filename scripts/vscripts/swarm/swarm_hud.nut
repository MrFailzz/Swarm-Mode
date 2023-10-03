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

/*
Free HUD Panels:
	- HUD_FAR_RIGHT
	- HUD_SCORE_TITLE
*/

swarmHUD <-
{
	Fields = 
	{
		corruptionCards = {name = "corruptionCards", slot = HUD_SCORE_4, dataval = "", flags = HUD_FLAG_ALIGN_LEFT},
		corruptionCardsInfected = {name = "corruptionCardsInfected", slot = HUD_SCORE_1, dataval = "", flags = HUD_FLAG_ALIGN_LEFT},
		corruptionCardsMission = {name = "corruptionCardsMission", slot = HUD_SCORE_2, dataval = "", flags = HUD_FLAG_ALIGN_LEFT},
		corruptionCardsHorde = {name = "corruptionCardsHorde", slot = HUD_SCORE_3, dataval = "", flags = HUD_FLAG_ALIGN_LEFT},
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
//            CORRUPTION CARD HUD            //
///////////////////////////////////////////////
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
	HUDPlace(HUD_SCORE_4, 1 - swarmHudW - swarmHudX, hudY, swarmHudW, hudH);
	hudY = hudY + hudH + swarmHudGapY;
	hudH = swarmHudH + (swarmHudLineH * (iInf == 0 ? 1 : iInf))
	HUDPlace(HUD_SCORE_1, 1 - swarmHudW - swarmHudX, hudY, swarmHudW, hudH);
}

///////////////////////////////////////////////
//              CARD HUD CONTROL             //
///////////////////////////////////////////////
function CardHudUpdate()
{
	if (cardPickingAllowed[0] == 0 && cardPickingAllowed[1] == 0 && cardPickingAllowed[2] == 0 && cardPickingAllowed[3] == 0)
	{
		if (cardHudTimeout == 0)
		{
			if (IsHudElementVisible("corruptionCards"))
			{
				ToggleHudElement("corruptionCards");
			}
			if (IsHudElementVisible("corruptionCardsInfected"))
			{
				ToggleHudElement("corruptionCardsInfected");
			}
			if (corruptionMission == "None")
			{
				if (IsHudElementVisible("corruptionCardsMission"))
				{
					ToggleHudElement("corruptionCardsMission");
				}
			}
			if (corruptionHordes == "None")
			{
				if (IsHudElementVisible("corruptionCardsHorde"))
				{
					ToggleHudElement("corruptionCardsHorde");
				}
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
		if (cardHudTimeout >= 0)
		{
			cardHudTimeout--;
		}
	}

	if (corruptionMission == "missionSpeedrun")
	{
		MissionSpeedrun_Timer++;
	}
	UpdateCorruptionCardHUD();
}

function ShowCardsCommand()
{
	if (!IsHudElementVisible("corruptionCards"))
	{
		ToggleHudElement("corruptionCards");
	}
	if (!IsHudElementVisible("corruptionCardsInfected"))
	{
		ToggleHudElement("corruptionCardsInfected");
	}
	if (corruptionMission == "None")
	{
		if (!IsHudElementVisible("corruptionCardsMission"))
		{
			ToggleHudElement("corruptionCardsMission");
		}
	}
	if (corruptionHordes == "None")
	{
		if (!IsHudElementVisible("corruptionCardsHorde"))
		{
			ToggleHudElement("corruptionCardsHorde");
		}
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
	if (cardPickingAllowed[0] > 0 || cardPickingAllowed[1] > 0 || cardPickingAllowed[2] > 0 || cardPickingAllowed[3] > 0)
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
	cardHudTimeout = 8;
}


///////////////////////////////////////////////
//              TANK HEALTH HUD              //
///////////////////////////////////////////////
function CreateTankHealthHud(startStr = "FROM THE CREATORS OF BACK 4 BLOOD")
{
   Ticker_AddToHud(swarmHUD, startStr);
   HUDSetLayout(swarmHUD);
   HUDPlace(HUD_TICKER, 0.25, 0.05, 0.5, 0.04);

   bTankHudExists = true;
}

function CalculateTankHudString()
{
	if (tankHudTankID == null || bTankHudExists == false)
	{
		Ticker_NewStr("");
	}
	else
	{
		local healthCur = tankHudTankID.GetHealth();
		local healthMax = tankHudTankID.GetMaxHealth();
		local maxBlocks = 40;
		local healthPerBlock = healthMax / maxBlocks;
		local fullBlocks = ceil(healthCur / healthPerBlock);
		local emptyBlocks = maxBlocks - fullBlocks;
		local hudString = "";

		local i = 0;
		for (i = 0; i < fullBlocks; i++)
		{
			hudString = hudString + "■";
		}
		for (i = 0; i < emptyBlocks; i++)
		{
			hudString = hudString + "□";
		}
		Ticker_NewStr(hudString);
	}
}

function DestroyTankHud()
{
	if (bTankHudExists == true)
	{
		bTankHudExists = false;
		tankHudTankID = null;
		Ticker_Hide();
	}
}