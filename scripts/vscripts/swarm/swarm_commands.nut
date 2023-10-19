///////////////////////////////////////////////
//                  COMMANDS                 //
///////////////////////////////////////////////
//Vote.Cast.Yes
if (!IsSoundPrecached("UI/Menu_Click01.wav"))
{
	PrecacheSound("UI/Menu_Click01.wav");
}

//Vote.Created
if (!IsSoundPrecached("UI/Beep_SynthTone01.wav"))
{
	PrecacheSound("UI/Beep_SynthTone01.wav");
}

//UI/Menu_Enter05.wav"Vote.Passed
if (!IsSoundPrecached("UI/Menu_Enter05.wav"))
{
	PrecacheSound("UI/Menu_Enter05.wav");
}

function InterceptChat(message, speaker)
{
	// Remove player name from message
	local name = speaker.GetPlayerName() + ": ";
	local text = strip(message.slice(message.find(name) + name.len()));
	local textArgs = [];
	textArgs = split(text, " ");
	if (textArgs.len() == 0)
	{
		return;
	}
	
	local command = textArgs[0].tolower().slice(1);
	local commandPrefix = textArgs[0].slice(0, 1);

	if (commandPrefix == "!" || commandPrefix == "/")
	{
		switch(command)
		{
			case "language":
				if (textArgs.len() < 2)
				{
					return;
				}
				if (GetListenServerHost() == speaker || swarmSettingsTable["debug_mode"] > 0)
				{
					local success = false;
					switch(textArgs[1].tolower())
					{
						case "english":
						case "en":
							swarmSettingsTable["language"] = "English";
							success = true;
						break;

						case "русский":
						case "russian":
						case "ru":
							swarmSettingsTable["language"] = "Russian";
							success = true;
						break;
					}

					if (success)
					{
						UpdateLanguage();
						SaveSettingsTable();
						ClientPrint(null, 3, "\x04" + Loc("#lang_localization"));
					}
				}
			break;

			case "autohidehud":
				if (swarmSettingsTable["autoHideHUD"])
				{
					swarmSettingsTable["autoHideHUD"] = false;
					ClientPrint(null, 3, "\x04" + "Auto hide card HUD off");
				}
				else if (!swarmSettingsTable["autoHideHUD"])
				{
					swarmSettingsTable["autoHideHUD"] = true;
					ClientPrint(null, 3, "\x04" + "Auto hide card HUD on");
				}
			break;

			case "пинг":
			case "ping":
				TraceEye(speaker);
			break;

			case "дроп":
			case "drop":
				local activeWeapon = speaker.GetActiveWeapon();

				if (activeWeapon != null && speaker.IsSurvivor() && activeWeapon.IsValid())
				{
					local weaponClass = activeWeapon.GetClassname();
					speaker.DropItem(weaponClass);
				}
			break;

			case "карты":
			case "cards":
				ShowCardsCommand();
			break;

			case "нарвать":
			case "pick":
				if (textArgs.len() < 2)
				{
					return;
				}

				local cardPick = textArgs[1].tointeger();
				if (cardPick <= 8 && cardPick >= 1 && speaker.IsSurvivor())
				{
					PickCard(speaker, cardPick);
				}
			break;

			case "ботнарвать":
			case "botpick":
				if (textArgs.len() < 2)
				{
					return;
				}

				local cardPick = textArgs[1].tointeger();
				if (cardPick <= 8 && cardPick >= 1 && speaker.IsSurvivor())
				{
					local player = null;
					while ((player = Entities.FindByClassname(player, "player")) != null)
					{
						if (player.IsSurvivor())
						{
							if (IsPlayerABot(player))
							{
								PickCard(player, cardPick);
							}
						}
					}
				}
			break;

			case "ливес":
			case "lives":
				local MaxIncaps = DirectorOptions.SurvivorMaxIncapacitatedCount;
				local player = null;
				while ((player = Entities.FindByClassname(player, "player")) != null)
				{
					if (player.IsSurvivor())
					{
						local PlayerIncaps = MaxIncaps - NetProps.GetPropInt(player, "m_currentReviveCount");
						if (player.IsIncapacitated() && !player.IsHangingFromLedge())
						{
							PlayerIncaps -= 1;
						}
						else if (player.IsDead() || player.IsDying())
						{
							PlayerIncaps = "Dead";
						}
						ClientPrint(speaker, 3, "\x04" + player.GetPlayerName() + "\x01" + ": " + PlayerIncaps + " / " + MaxIncaps);
					}
				}
			break;

			case "шаркать":
			case "shuffle":
				ShuffleVote(speaker);
			break;

			case "hardcore":
				if (GetListenServerHost() == speaker)
				{
					swarmSettingsTable["hardcore"] = !swarmSettingsTable["hardcore"];

					if (swarmSettingsTable["hardcore"])
					{
						ClientPrint(null, 3, Loc("#enablehardcore_msg"));
					}
					else
					{
						ClientPrint(null, 3, Loc("#disablehardcore_msg"));
					}

					SaveSettingsTable();
				}
			break;

			case "debug":
				if (GetListenServerHost() == speaker)
				{
					/* Debug Mode Levels - higher numbers include effects of the numbers below them
						0: Disabled
						1: Enable !debugpick
						2: Show debug messages, e.g. damage table
					*/


					if (textArgs.len() > 1)
					{
						swarmSettingsTable["debug_mode"] = textArgs[1].tointeger();
						//ClientPrint(speaker, 3, "\x04" + "Debug mode enabled");
					}
					else
					{
						if (swarmSettingsTable["debug_mode"] > 0)
						{
							swarmSettingsTable["debug_mode"] = 0;
						}
						else
						{
							swarmSettingsTable["debug_mode"] = 1;
						}
					}
					printl(swarmSettingsTable["debug_mode"]);

					if (swarmSettingsTable["debug_mode"] > 0)
					{
						ClientPrint(speaker, 3, "\x04" + "Debug mode enabled (" + swarmSettingsTable["debug_mode"] + ")");
					}
					else
					{
						ClientPrint(speaker, 3, "\x04" + "Debug mode disabled");
					}

					SaveSettingsTable();
				}
			break;

			case "debugpick":
				if (Convars.GetFloat("sv_cheats") == 1 || swarmSettingsTable["debug_mode"] > 0)
				{
					AddCardToTable(GetSurvivorCardTable(GetSurvivorID(speaker)), speaker, textArgs[1]);
					GetAllPlayerCards();
					ApplyCardEffects(speaker);
					if (textArgs[1] == "Gambler")
					{
						PrintGamblerValue(speaker);
					}
				}
			break;

			case "debugcorruption":
				if (Convars.GetFloat("sv_cheats") == 1 || swarmSettingsTable["debug_mode"] > 0)
				{
					if (textArgs.len() < 3)
					{
						ClientPrint(speaker, 3, "\x01" + "Forces specific corruption cards, usage: /debugcorruption [Card Array Name, e.g. cardsMission] [Forced Card Name, e.g. missionSpeedrun]");
						return;
					}
					local corruptionCardArrayName = textArgs[1];
					local newCorruptionCard = textArgs[2];
					swarmSettingsTable[corruptionCardArrayName] = newCorruptionCard;

					ClientPrint(speaker, 3, "\x04" + corruptionCardArrayName + "\x01" + " set to: " + "\x04" + newCorruptionCard);
					ClientPrint(speaker, 3, "\x01" + "Reset the map to activate, set to 'null' to use normal picking behavior");

					SaveSettingsTable();
				}
			break;
		}
		return false;
	}
}

function ShuffleVote(speaker, cardPick = false)
{
	local player = null;
	if (!shuffleVoteStarted && !cardPick)
	{
		shuffleVoteStarted = true;
		ClientPrint(null, 3, "\x04" + speaker.GetPlayerName() + " initiated a shuffle vote!");

		while ((player = Entities.FindByClassname(player, "player")) != null)
		{
			if (player.IsSurvivor())
			{
				EmitSoundOn("Vote.Created", player);
				if (IsPlayerABot(player))
				{
					cardShuffleVote[GetSurvivorID(player)] = true;
					ClientPrint(null, 3, "\x04" + player.GetPlayerName() + " voted to shuffle");
				}
			}
		}
	}

	if (!cardShuffled && shuffleVoteStarted)
	{
		local speakerID = GetSurvivorID(speaker);
		if (!cardShuffleVote[speakerID] && shuffleVoteStarted && !cardPick)
		{
			while ((player = Entities.FindByClassname(player, "player")) != null)
			{
				if (player.IsSurvivor())
				{
					EmitSoundOnClient("Vote.Cast.Yes", player);
				}
			}
			ClientPrint(null, 3, "\x04" + speaker.GetPlayerName() + " voted to shuffle");
		}

		if (cardPickingAllowed[speakerID] > 0)
		{
			cardShuffleVote[speakerID] = true;
		}

		//Check if all players that haven't picked a card have voted yes
		local voteStatus = true;
		local voteCount = 0;
		foreach(vote in cardShuffleVote)
		{
			if (!vote)
			{
				voteStatus = false;
			}
			else if (vote)
			{
				voteCount += 1;
			}
		}

		//ClientPrint(null, 3, "\x01" + "Use " + "\x03" + "!shuffle\x01" + " to vote for a new set of cards (" + "\x03" + voteCount + "/4" + "\x01" + " votes"  + ")");

		//Vote passed, shuffle cards
		if (voteStatus)
		{
			ClientPrint(null, 3, "\x04" + "Shuffle vote passed!");
			while ((player = Entities.FindByClassname(player, "player")) != null)
			{
				if (player.IsSurvivor())
				{
					EmitSoundOnClient("Vote.Passed", player);
				}
			}
			InitCardPicking(true);
			cardShuffled = true;
		}
	}
}

function IncapMsg(params)
{
	local player = GetPlayerFromUserID(params["userid"]);
	ClientPrint(player, 3,  Loc("#giveup_msg"));
}

function SaveSettingsTable()
{
	SaveTable("swarmSettingsTable", swarmSettingsTable);
	//DeepPrintTable(swarmSettingsTable);
}

function LoadSettingsTable()
{
	local language = swarmSettingsTable["language"];
	local hardcore = swarmSettingsTable["hardcore"];
	//local debug_mode = swarmSettingsTable["debug_mode"];

	RestoreTable("swarmSettingsTable", swarmSettingsTable);
	SaveSettingsTable();
	DeepPrintTable(swarmSettingsTable);

	//Compare with previous values and action setting changes
	if (language != swarmSettingsTable["language"])
	{
		UpdateLanguage();
	}

	UpdateHardcore();

	/*if (debug_mode != swarmSettingsTable["debug_mode"])
	{
		UpdateDebugMode();
	}*/
}

function UpdateLanguage()
{
	UpdateCorruptionCardHUD();
	UpdateCardPickHUD();
	GetAllPlayerCards();
}

function UpdateHardcore()
{
	//Ends the game after the third wipe
	if (swarmSettingsTable["hardcore"])
	{
		if (Director.GetMissionWipes() > 1)
		{
			Convars.SetValue("sv_permawipe", "1");
		}
		else
		{
			Convars.SetValue("sv_permawipe", "0");
		}
	}
	else
	{
		Convars.SetValue("sv_permawipe", "0");
	}
}

/*function UpdateDebugMode()
{

}*/