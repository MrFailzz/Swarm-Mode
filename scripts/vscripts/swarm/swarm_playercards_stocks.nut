///////////////////////////////////////////////
//       PLAYER CARDS - STOCK FUNCTIONS      //
///////////////////////////////////////////////

reflexCards <-
[
	"GlassCannon",
	"Sharpshooter",
	"Outlaw",
	"Overconfident",
	//"Slugger",
	//"AntiSocialDistancing",
	"MethHead",
	"OpticsEnthusiast",
	//"Breakout",
	"AdrenalineRush",
	"HelpingHand",
	"CombatMedic",
	"AmpedUp",
	"Addict",
	"FleetOfFoot",
	"CrossTrainers",
	"Multitool",
	//"RunLikeHell",
	//"Quickdraw",
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
	//"FaceYourFears",
	//"BombDisposal",
	//"Numb",
	//"MeanDrunk",
	//"BattleLust",
	//"Brawler",
	"Berserker",
	//"HeavyHitter",
	//"Rampage",
	"SwanSong",
	//"Overcrowded",
	"LastLegs",
	"BuckshotBruiser",
	"Lumberjack",
];

disciplineCards <-
[
	"StrengthInNumbers",
	//"NoHead",
	"FireProof",
	//"HunkerDown",
	//"SoftenUp",
	"Brazen",
	//"MarkedForDeath",
	"PackMule",
	//"Grenadier",
	//"Resupply",
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
];

fortuneCards <-
[
	"LuckyShot",
	"Selfless",
	"Selfish",
	//"Decoy",
	"HeightendSenses",
	//"ClusterBomb",
	"HotShot",
	"Pinata",
	//"RefundPolicy",
	//"Stockpile",
	//"LifeInsurance",
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
		reloadModifier += ApplyGamblerValue(GetSurvivorID(player), 5, Gambler, reloadModifier);
	}

	if (reloadModifier <= 0)
	{
		reloadModifier = 0.01
	}

	return reloadModifier;
}
::GetReloadSpeedModifier <- GetReloadSpeedModifier;

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

function ApplyGamblerValue(player, index, Gambler, affectedValue)
{
	local gambleValue = GetGamblerValue(player, index);

	if (gambleValue != -1)
	{
		gambleValue = gambleValue.tofloat() / 100;
		return affectedValue * (Gambler * gambleValue);
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
	local maxHpString = GamblerColor(maxHp) + "Max HP: " + GamblerSign(maxHp) + ", ";

	local res = GetGamblerValue(GetSurvivorID(player), 1);
	local resString = GamblerColor(res) + "RES: " + GamblerSign(res) + ", ";

	local traumaRes = GetGamblerValue(GetSurvivorID(player), 2);
	local traumaResString = GamblerColor(traumaRes) + "Trauma RES: " + GamblerSign(traumaRes) + ", ";

	local speed = GetGamblerValue(GetSurvivorID(player), 3);
	local speedString = GamblerColor(speed) + "Speed, " + GamblerSign(speed) + ", ";

	local damage = GetGamblerValue(GetSurvivorID(player), 4);
	local damageString = GamblerColor(damage) + "DMG: " + GamblerSign(damage) + ", ";

	local reload = GetGamblerValue(GetSurvivorID(player), 5);
	local reloadString = GamblerColor(reload) + "Reload Speed: " + GamblerSign(reload) + ", ";

	local healEff = GetGamblerValue(GetSurvivorID(player), 6);
	local healEffString = GamblerColor(healEff) + "Heal EFF: " + GamblerSign(healEff);

	ClientPrint(player, 3, "\x03Gambler: " + maxHpString + resString + traumaResString + speedString + damageString + reloadString + healEffString);
}

function GamblerSign(gambleValue)
{
	if (gambleValue >= 0)
	{
		return "+" + gambleValue + "%";
	}
	else
	{
		return "" + gambleValue + "%";
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
	//Type: name = Name, desc = Description
	if (type == "name")
	{
		switch(cardID)
		{
			case "Nick":
				return "Nick (+5% DMG)";
				break;
			case "Rochelle":
				return "Rochelle (+10% Heal EFF)";
				break;
			case "Coach":
				return "Coach (+10 Max HP)";
				break;
			case "Ellis":
				return "Ellis (+5% CRIT Chance)";
				break;
			case "Bill":
				return "Bill (+10% Reload Speed)";
				break;
			case "Zoey":
				return "Zoey (+10% Melee DMG)";
				break;
			case "Louis":
				return "Louis (+10% Move Speed)";
				break;
			case "Francis":
				return "Francis (+10% RES)";
				break;
			case "GlassCannon":
				return "Glass Cannon";
				break;
			case "Sharpshooter":
				return "Sharpshooter";
				break;
			case "Outlaw":
				return "Outlaw";
				break;
			case "Overconfident":
				return "Overconfident";
				break;
			case "Slugger":
				return "Slugger";
				break;
			case "AntiSocialDistancing":
				return "Anti-Social Distancing";
				break;
			case "MethHead":
				return "Meth Head";
				break;
			case "OpticsEnthusiast":
				return "Optics Enthusiast";
				break;
			case "Breakout":
				return "Breakout";
				break;
			case "AdrenalineRush":
				return "Adrenaline Rush";
				break;
			case "HelpingHand":
				return "Helping Hand";
				break;
			case "CombatMedic":
				return "Combat Medic";
				break;
			case "AmpedUp":
				return "Amped Up";
				break;
			case "Addict":
				return "Addict";
				break;
			case "FleetOfFoot":
				return "Fleet of Foot";
				break;
			case "CrossTrainers":
				return "Cross Trainers";
				break;
			case "Multitool":
				return "Multitool";
				break;
			case "RunLikeHell":
				return "Run Like Hell";
				break;
			case "Quickdraw":
				return "Quickdraw";
				break;
			case "Broken":
				return "Boss Killer";
				break;
			case "Pyromaniac":
				return "Pyromaniac";
				break;
			case "BombSquad":
				return "Bomb Squad";
				break;
			case "ConfidentKiller":
				return "Confident Killer";
				break;
			case "CannedGoods":
				return "Canned Goods";
				break;
			case "SlowAndSteady":
				return "Slow and Steady";
				break;
			case "ToughSkin":
				return "Tough Skin";
				break;
			case "ScarTissue":
				return "Scar Tissue";
				break;
			case "ChemicalBarrier":
				return "Chemical Barrier";
				break;
			case "FaceYourFears":
				return "Face Your Fears";
				break;
			case "BombDisposal":
				return "Bomb Disposal";
				break;
			case "Numb":
				return "Numb";
				break;
			case "MeanDrunk":
				return "Mean Drunk";
				break;
			case "BattleLust":
				return "Battle Lust";
				break;
			case "Brawler":
				return "Brawler";
				break;
			case "Berserker":
				return "Berserker";
				break;
			case "HeavyHitter":
				return "Heavy Hitter";
				break;
			case "Rampage":
				return "Rampage";
				break;
			case "SwanSong":
				return "Swan Song";
				break;
			case "Overcrowded":
				return "Overcrowded";
				break;
			case "LastLegs":
				return "Last Legs";
				break;
			case "StrengthInNumbers":
				return "Strength In Numbers";
				break;
			case "NoHead":
				return "So No Head?";
				break;
			case "FireProof":
				return "Fire Proof";
				break;
			case "HunkerDown":
				return "Hunker Down";
				break;
			case "SoftenUp":
				return "Soften Up";
				break;
			case "Brazen":
				return "Brazen";
				break;
			case "MarkedForDeath":
				return "Marked for Death";
				break;
			case "PackMule":
				return "Pack Mule";
				break;
			case "Grenadier":
				return "Grenadier";
				break;
			case "Resupply":
				return "Resupply";
				break;
			case "Suppression":
				return "Suppression";
				break;
			case "EyeOfTheSwarm":
				return "Eye of the Swarm";
				break;
			case "EMTBag":
				return "EMT Bag";
				break;
			case "AntibioticOintment":
				return "Antibiotic Ointment";
				break;
			case "MedicalExpert":
				return "Medical Expert";
				break;
			case "Cauterized":
				return "Cauterized";
				break;
			case "GroupTherapy":
				return "Group Therapy";
				break;
			case "InspiringSacrifice":
				return "Inspiring Sacrifice";
				break;
			case "ReloadDrills":
				return "Reload Drills";
				break;
			case "MagCoupler":
				return "Mag Coupler";
				break;
			case "LuckyShot":
				return "Lucky Shot";
				break;
			case "Selfless":
				return "Selfless";
				break;
			case "Selfish":
				return "Selfish";
				break;
			case "Decoy":
				return "Decoy";
				break;
			case "HeightendSenses":
				return "Heightend Senses";
				break;
			case "ClusterBomb":
				return "Cluster Bomb";
				break;
			case "HotShot":
				return "Hot Shot";
				break;
			case "Pinata":
				return "Piñata";
				break;
			case "RefundPolicy":
				return "Refund Policy";
				break;
			case "Stockpile":
				return "Stockpile";
				break;
			case "LifeInsurance":
				return "Life Insurance";
				break;
			case "WellRested":
				return "Well Rested";
				break;
			case "BuckshotBruiser":
				return "Buckshot Bruiser";
				break;
			case "Arsonist":
				return "Arsonist";
				break;
			case "NeedsOfTheMany":
				return "Needs of the Many";
				break;
			case "Lumberjack":
				return "Lumberjack";
				break;
			case "Cannoneer":
				return "Cannoneer"
				break;
			case "Gambler":
				return "Gambler";
				break;
			default:
				return cardID;
				break;
		}
	}
	else if (type == "desc")
	{
		switch(cardID)
		{
			case "Nick":
				return "+5% DMG";
				break;
			case "Rochelle":
				return "+10% Heal EFF";
				break;
			case "Coach":
				return "+10 Max HP";
				break;
			case "Ellis":
				return "+5% CRIT Chance";
				break;
			case "Bill":
				return "+10% Reload Speed";
				break;
			case "Zoey":
				return "+10% Melee DMG";
				break;
			case "Louis":
				return "+10% Move Speed";
				break;
			case "Francis":
				return "+10% RES";
				break;
			case "GlassCannon":
				return "+30% DMG, -20% RES";
				break;
			case "Sharpshooter":
				return "+25% DMG past 10m";
				break;
			case "Outlaw":
				return "+100% Pistol / Magnum DMG";
				break;
			case "Overconfident":
				return "+25% RES at max lives";
				break;
			case "Slugger":
				return "+25% Melee / Shove Rate";
				break;
			case "AntiSocialDistancing":
				return "+30% Melee / Shove Range";
				break;
			case "MethHead":
				return "+2.5% Move Speed per Mutation kill";
				break;
			case "OpticsEnthusiast":
				return "Gain laser sights (+60% ACC)";
				break;
			case "Breakout":
				return "Escape Grabs (60s CD) [+use]";
				break;
			case "AdrenalineRush":
				return "Adrenaline on Team incap";
				break;
			case "HelpingHand":
				return "+75% Team Revive Speed";
				break;
			case "CombatMedic":
				return "+30 Temp HP on revive, +20% Team Trauma RES";
				break;
			case "AmpedUp":
				return "Non-event hordes heal +20 Team HP (5s CD)";
				break;
			case "Addict":
				return "+50% Temp Heal EFF, perks by Temp HP level";
				break;
			case "FleetOfFoot":
				return "+12.5% Move Speed, -10 Max HP";
				break;
			case "CrossTrainers":
				return "+7% Move Speed, +5 Max HP";
				break;
			case "Multitool":
				return "+40% Team Use Speed";
				break;
			case "RunLikeHell":
				return "+30% Move Speed, DISABLES: All Items";
				break;
			case "Quickdraw":
				return "+50% Swap Speed";
				break;
			case "Broken":
				return "+20% DMG vs Bosses";
				break;
			case "Pyromaniac":
				return "+150% Fire DMG";
				break;
			case "BombSquad":
				return "+150% Explosive DMG";
				break;
			case "ConfidentKiller":
				return "+2.5% DMG per Mutation death";
				break;
			case "CannedGoods":
				return "+30 Max HP";
				break;
			case "SlowAndSteady":
				return "+50 Max HP, -10% Move Speed";
				break;
			case "ToughSkin":
				return "+40% RES vs Commons";
				break;
			case "ScarTissue":
				return "+30% RES, -50% Heal EFF";
				break;
			case "ChemicalBarrier":
				return "+50% Acid RES";
				break;
			case "FaceYourFears":
				return "+2 Temp HP on kill";
				break;
			case "BombDisposal":
				return "+75% Explosive / Knockback RES";
				break;
			case "Numb":
				return "Temp HP gives +10% RES";
				break;
			case "MeanDrunk":
				return "+3 Shoves";
				break;
			case "BattleLust":
				return "+1 HP on Melee kill";
				break;
			case "Brawler":
				return "Shove deals 50 Melee DMG";
				break;
			case "Berserker":
				return "+25% Melee DMG, +5% Move Speed";
				break;
			case "HeavyHitter":
				return "Melee stumbles Mutations";
				break;
			case "Rampage":
				return "Charge forwards, 100 Melee DMG, REPLACES: Shove (20s CD)";
				break;
			case "SwanSong":
				return "+100% CRIT chance while incapped";
				break;
			case "Overcrowded":
				return "+0.5% DMG / +1% RES per Ridden in 5m";
				break;
			case "LastLegs":
				return "Team can crawl while incapped";
				break;
			case "StrengthInNumbers":
				return "+2.5% Team DMG per alive Cleaner";
				break;
			case "NoHead":
				return "Headshot kills cause an explosion";
				break;
			case "FireProof":
				return "+50% Fire RES";
				break;
			case "HunkerDown":
				return "+30% RES when crouching";
				break;
			case "SoftenUp":
				return "Mutations you Melee do -25% DMG";
				break;
			case "Brazen":
				return "+40% Melee DMG, -25% Reload Speed";
				break;
			case "MarkedForDeath":
				return "+10% Team DMG vs Pinged Mutations";
				break;
			case "PackMule":
				return "+40% Team Max Ammo";
				break;
			case "Grenadier":
				return "+50% Throwable duration";
				break;
			case "Resupply":
				return "+10% Ammo on Mutation kill";
				break;
			case "Suppression":
				return "+100% bullet stopping power";
				break;
			case "EyeOfTheSwarm":
				return "+50% DMG in the Swarm Circle";
				break;
			case "EMTBag":
				return "+50% Heal EFF";
				break;
			case "AntibioticOintment":
				return "+25% Heal EFF, +10 Temp HP to target";
				break;
			case "MedicalExpert":
				return "+30% Team Heal EFF";
				break;
			case "Cauterized":
				return "+50% Slower Team HP Decay";
				break;
			case "GroupTherapy":
				return "Team shares 20% of health item uses";
				break;
			case "InspiringSacrifice":
				return "+25 Team Temp HP after incap";
				break;
			case "ReloadDrills":
				return "+25% Reload Speed";
				break;
			case "MagCoupler":
				return "+75% Reload Speed, DISABLES: Shove";
				break;
			case "LuckyShot":
				return "+7% Team CRIT Chance (+400% DMG)";
				break;
			case "Selfless":
				return "-15 Max HP, +15 Team Max HP";
				break;
			case "Selfish":
				return "+30 Max HP, -5 Team Max HP";
				break;
			case "Decoy":
				return "Drop a Pipe Bomb on incap";
				break;
			case "HeightendSenses":
				return "Ping Mutations, Hazards and Items in 7.5m";
				break;
			case "ClusterBomb":
				return "Pipe Bombs explode twice";
				break;
			case "HotShot":
				return "+15% chance of Ammo Upgrade on Mutation death";
				break;
			case "Pinata":
				return "+15% chance of item on Mutation death";
				break;
			case "RefundPolicy":
				return "+25% chance to not consume items";
				break;
			case "Stockpile":
				return "Stockpile";
				break;
			case "LifeInsurance":
				return "+1 Team Life";
				break;
			case "WellRested":
				return "Team fully heals each chapter";
				break;
			case "BuckshotBruiser":
				return "+0.25 Temp HP per Shotgun pellet";
				break;
			case "Arsonist":
				return "+0.1 Temp HP per Fire DMG";
				break;
			case "NeedsOfTheMany":
				return "+1 Team Life, -10 Max HP";
				break;
			case "Lumberjack":
				return "+200% Team Chainsaw DMG"
				break;
			case "Cannoneer":
				return "+200% Team Grenade Launcher DMG"
				break;
			case "Gambler":
				return "Randomize stats each map!"
			default:
				return cardID;
				break;
		}
	}
	
	return cardID;
}

//TrollDespair - There is no chr/ord function
function IntToLetter(ID)
{
	switch(ID)
	{
		case 1:
			return "A";
			break;
		case 2:
			return "B";
			break;
		case 3:
			return "C";
			break;
		case 4:
			return "D";
			break;
		case 5:
			return "E";
			break;
		case 6:
			return "F";
			break;
		case 7:
			return "G";
			break;
		case 8:
			return "H";
			break;
		case 9:
			return "I";
			break;
		case 10:
			return "J";
			break;
		case 11:
			return "K";
			break;
		case 12:
			return "L";
			break;
		case 13:
			return "M";
			break;
		case 14:
			return "N";
			break;
		case 15:
			return "O";
			break;
		case 16:
			return "P";
			break;
		case 17:
			return "Q";
			break;
		case 18:
			return "R";
			break;
		case 19:
			return "S";
			break;
		case 20:
			return "T";
			break;
		case 21:
			return "U";
			break;
		case 22:
			return "V";
			break;
		case 23:
			return "W";
			break;
		case 24:
			return "X";
			break;
		case 25:
			return "Y";
			break;
		case 26:
			return "Z";
			break;
		default:
			return "";
			break;
	}
	
	return "";
}

function LetterToInt(ID)
{
	switch(ID)
	{
		case "A":
			return 1;
			break;
		case "B":
			return 2;
			break;
		case "C":
			return 3;
			break;
		case "D":
			return 4;
			break;
		case "E":
			return 5;
			break;
		case "F":
			return 6;
			break;
		case "G":
			return 7;
			break;
		case "H":
			return 8;
			break;
		case "I":
			return 9;
			break;
		case "J":
			return 10;
			break;
		case "K":
			return 11;
			break;
		case "L":
			return 12;
			break;
		case "M":
			return 13;
			break;
		case "N":
			return 14;
			break;
		case "O":
			return 15;
			break;
		case "P":
			return 16;
			break;
		case "Q":
			return 17;
			break;
		case "R":
			return 18;
			break;
		case "S":
			return 19;
			break;
		case "T":
			return 20;
			break;
		case "U":
			return 21;
			break;
		case "V":
			return 22;
			break;
		case "W":
			return 23;
			break;
		case "X":
			return 24;
			break;
		case "Y":
			return 25;
			break;
		case "Z":
			return 26;
			break;
		default:
			return "";
			break;
	}
	
	return "";
}
