///////////////////////////////////////////////
//       PLAYER CARDS - STOCK FUNCTIONS      //
///////////////////////////////////////////////

reflexCards <-
[
	"GlassCannon",
	"Sharpshooter",
	"Outlaw",
	"Overconfident",
	"Slugger",
	"MethHead",
	"OpticsEnthusiast",
	"Breakout",
	"AdrenalineRush",
	"HelpingHand",
	"CombatMedic",
	"AmpedUp",
	"Addict",
	"FleetOfFoot",
	"CrossTrainers",
	"Multitool",
	"RunLikeHell",
	//"Quickdraw",
	"Shredder",
	"Screwdriver",
	"SmellingSalts",
	"HyperFocused",
	"TriggerHappy",
];

brawnCards <-
[
	"Broken",
	"Pyromaniac",
	"BombSquad",
	"ConfidentKiller",
	"CannedGoods",
	"SlowAndSteady",
	"ToughSkin",
	"ScarTissue",
	"ChemicalBarrier",
	"FaceYourFears",
	//"Numb",
	"MeanDrunk",
	//"BattleLust",
	"Brawler",
	"Berserker",
	//"HeavyHitter",
	//"Rampage",
	"SwanSong",
	"LastLegs",
	"BuckshotBruiser",
	"Lumberjack",
	//"Kneecapper",
	"WellFed",
	"Overwatch",
];

disciplineCards <-
[
	"StrengthInNumbers",
	//"BOOM",
	"FireProof",
	"Brazen",
	"MarkedForDeath",
	"PackMule",
	//"Suppression",
	"EyeOfTheSwarm",
	"EMTBag",
	"AntibioticOintment",
	"MedicalExpert",
	"Cauterized",
	"GroupTherapy",
	"InspiringSacrifice",
	"ReloadDrills",
	"MagCoupler",
	"Arsonist",
	"NeedsOfTheMany",
	"Cannoneer",
	"DownInFront",
	"CleanKill",
	"ExperiencedEMT",
	"MedicalProfessional",
];

fortuneCards <-
[
	"LuckyShot",
	"Selfless",
	"Selfish",
	//"OutWithABang",
	"HeightendSenses",
	"HotShot",
	"Pinata",
	//"RefundPolicy",
	//"Stockpile",
	//"LifeInsurance",
	//"Resupply",
	"WellRested",
	"Gambler",
];


function PlayerHasCard(player, card)
{
	local cardTable = GetSurvivorCardTable(GetSurvivorID(player));

	if (card in cardTable)
	{
		return cardTable[card];
	}
	else
	{
		return 0;
	}
}
::PlayerHasCard <- PlayerHasCard;

function TeamHasCard(card)
{
	local val1 = 0;
	local val2 = 0;
	local val3 = 0;
	local val4 = 0;

	if (card in p1Cards)
	{
		val1 = p1Cards[card];
	}

	if (card in p2Cards)
	{
		val2 = p2Cards[card];
	}

	if (card in p3Cards)
	{
		val3 = p3Cards[card];
	}

	if (card in p4Cards)
	{
		val4 = p4Cards[card];
	}

	return val1 + val2 + val3 + val4;
}
::TeamHasCard <- TeamHasCard;

function AddictGetValue(player)
{
	local healthBuffer = player.GetHealthBuffer();

	if (healthBuffer <= 0)
	{
		return -0.15;
	}
	else
	{
		return floor(healthBuffer / 10) / 20;
	}
}
::AddictGetValue <- AddictGetValue;

function GetShotgunReloadDuration(classname, stage)
{
	if (classname == "weapon_shotgun_chrome" || classname == "weapon_pumpshotgun")
	{
		switch(stage)
		{
			case 0:
				return 0.475;
				break;
			case 1:
				return 0.5;
				break;
			case 2:
				return 0.6;
				break;
		}
	}
	else if (classname == "weapon_autoshotgun")
	{
		switch(stage)
		{
			case 0:
				return 0.633333;
				break;
			case 1:
				return 0.38;
				break;
			case 2:
				return 0.675;
				break;
		}
	}
	else if (classname == "weapon_shotgun_spas")
	{
		switch(stage)
		{
			case 0:
				return 0.475;
				break;
			case 1:
				return 0.375;
				break;
			case 2:
				return 0.7;
				break;
		}
	}
}
::GetShotgunReloadDuration <- GetShotgunReloadDuration;

function GetSurvivorID(player)
{
	switch(player.GetModelName())
	{
		case "models/survivors/survivor_gambler.mdl":
			return 0;
			break;
		case "models/survivors/survivor_producer.mdl":
			return 1;
			break;
		case "models/survivors/survivor_coach.mdl":
			return 2;
			break;
		case "models/survivors/survivor_mechanic.mdl":
			return 3;
			break;
		case "models/survivors/survivor_namvet.mdl":
			return 0;
			break;
		case "models/survivors/survivor_teenangst.mdl":
			return 1;
			break;
		case "models/survivors/survivor_manager.mdl":
			return 2;
			break;
		case "models/survivors/survivor_biker.mdl":
			return 3;
			break;
		default:
			return -1;
			break;
	}
}
::GetSurvivorID <- GetSurvivorID;

function GetSurvivorCardTable(player)
{
	switch(player)
	{
		case 0:
			return p1Cards;
			break;
		case 1:
			return p2Cards;
			break;
		case 2:
			return p3Cards;
			break;
		case 3:
			return p4Cards;
			break;
		default:
			return -1;
			break;
	}
}
::GetSurvivorCardTable <- GetSurvivorCardTable;

function GetReloadSpeedModifier(player)
{
	//Modifiers
	local Gambler = PlayerHasCard(player, "Gambler");
	local ReloadDrills = PlayerHasCard(player, "ReloadDrills");
	local Addict = PlayerHasCard(player, "Addict");
	local AddictMultiplier = AddictGetValue(player);
	local Bill = PlayerHasCard(player, "Bill");
	local Brazen = PlayerHasCard(player, "Brazen");
	local MagCoupler = PlayerHasCard(player, "MagCoupler");

	local reloadModifier = 1 + (0.25 * ReloadDrills) + (AddictMultiplier * Addict) + (0.1 * Bill) + (-0.25 * Brazen) + (0.75 * MagCoupler);

	if (Gambler > 0)
	{
		reloadModifier += ApplyGamblerValue(GetSurvivorID(player), 5, Gambler);
	}

	if (reloadModifier <= 0)
	{
		reloadModifier = 0.01;
	}

	return reloadModifier;
}
::GetReloadSpeedModifier <- GetReloadSpeedModifier;

function GetFirerateModifier(player)
{
	//Modifiers
	local TriggerHappy = PlayerHasCard(player, "TriggerHappy");

	local firerateModifier = 1 + (0.15 * TriggerHappy);

	if (firerateModifier <= 0)
	{
		firerateModifier = 0.01;
	}

	return firerateModifier;
}
::GetFirerateModifier <- GetFirerateModifier;

function GetMeleeSpeedModifier(player)
{
	local Slugger = PlayerHasCard(player, "Slugger");
	local MethHead = PlayerHasCard(player, "MethHead");

	local meleeModifier = (1 
						+ (0.30 * Slugger)
						+ (0.025 * MethHead * MethHeadCounter[GetSurvivorID(player)]));

	local Gambler = PlayerHasCard(player, "Gambler");
	if (Gambler > 0)
	{
		meleeModifier += ApplyGamblerValue(GetSurvivorID(player), 7, Gambler);
	}

	if (meleeModifier <= 0)
	{
		meleeModifier = 0.01;
	}

	return meleeModifier;
}
::GetMeleeSpeedModifier <- GetMeleeSpeedModifier;

function GetGamblerValue(player, index)
{
	switch(player)
	{
		case 0:
			return p1Gambler[index];
			break;
		case 1:
			return p2Gambler[index];
			break;
		case 2:
			return p3Gambler[index];
			break;
		case 3:
			return p4Gambler[index];
			break;
		default:
			return -1;
			break;
	}
}
::GetGamblerValue <- GetGamblerValue;

function ApplyGamblerValue(player, index, Gambler)
{
	local gambleValue = GetGamblerValue(player, index);

	if (gambleValue != -1)
	{
		if (index != 0)
		{
			gambleValue = gambleValue.tofloat() / 100;
		}
		return Gambler * gambleValue;
	}
	else
	{
		return 1;
	}
}
::ApplyGamblerValue <- ApplyGamblerValue;

function PrintGamblerValue(player)
{
	local maxHp = GetGamblerValue(GetSurvivorID(player), 0);
	local maxHpString = GamblerColor(maxHp) + "Max HP: " + GamblerSign(maxHp, "") + ", ";

	local res = GetGamblerValue(GetSurvivorID(player), 1);
	local resString = GamblerColor(res) + "DEF: " + GamblerSign(res) + ", ";

	local traumaRes = GetGamblerValue(GetSurvivorID(player), 2);
	local traumaResString = GamblerColor(traumaRes) + "Trauma RES: " + GamblerSign(traumaRes) + ", ";

	local speed = GetGamblerValue(GetSurvivorID(player), 3);
	local speedString = GamblerColor(speed) + "Speed, " + GamblerSign(speed) + ", ";

	local damage = GetGamblerValue(GetSurvivorID(player), 4);
	local damageString = GamblerColor(damage) + "DMG: " + GamblerSign(damage) + ", ";

	local reload = GetGamblerValue(GetSurvivorID(player), 5);
	local reloadString = GamblerColor(reload) + "Reload Speed: " + GamblerSign(reload) + ", ";

	local healEff = GetGamblerValue(GetSurvivorID(player), 6);
	local healEffString = GamblerColor(healEff) + "Heal EFF: " + GamblerSign(healEff) + ", ";;

	local meleeSpeed = GetGamblerValue(GetSurvivorID(player), 7);
	local meleeSpeedString = GamblerColor(meleeSpeed) + "Melee Speed: " + GamblerSign(meleeSpeed);

	ClientPrint(player, 3, "\x03Gambler: " + maxHpString + resString + traumaResString + speedString + damageString + reloadString + healEffString + meleeSpeedString);
}

function GamblerSign(gambleValue, suffix = "%")
{
	if (gambleValue >= 0)
	{
		return "+" + gambleValue + suffix;
	}
	else
	{
		return "" + gambleValue + suffix;
	}
}

function GamblerColor(gambleValue)
{
	if (gambleValue >= 0)
	{
		return "\x03";
	}
	else
	{
		return "\x04";
	}
}

function GetPlayerCardName(cardID, type = "name")
{
	//Returns the card name or description from localization file
	return Loc("#" + type + "_" + cardID);
}