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
//                  CARD HUD                 //
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