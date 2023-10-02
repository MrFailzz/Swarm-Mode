///////////////////////////////////////////////
//               LOCALIZATION                //
///////////////////////////////////////////////
function Loc(msg)
{
	if (msg.slice(0, 1) == "#")
	{
		switch(swarmSettingsTable["language"])
		{
			case "English":
				return Translation_EN(msg);
			break;
			case "Russian":
				return Translation_RU(msg);
			break;
		}
	}
	else
	{
		return msg;
	}
}

function Translation_EN(msg)
{
	switch(msg)
	{
		//CHAT MESSAGES
		case "#lang_localization":
			return "English localization";
		break;

		case "#giveup_msg":
			return "\x01" + "Type " + "\x03" + "!giveup" + "\x01" + " to die...";
		break;

		//PLAYER CARDS
		case "#name_Nick":
			return "Nick (+5% DMG)"
		break;

		case "#desc_Nick":
			return "+5% DMG"
		break;

		case "#name_Rochelle":
			return "Rochelle (+10% Heal EFF)"
		break;

		case "#desc_Rochelle":
			return "+10% Heal EFF"
		break;

		case "#name_Coach":
			return "Coach (+10 Max HP)"
		break;

		case "#desc_Coach":
			return "+10 Max HP"
		break;

		case "#name_Ellis":
			return "Ellis (+5% CRIT Chance)"
		break;

		case "#desc_Ellis":
			return "+5% CRIT Chance"
		break;

		case "#name_Bill":
			return "Bill (+10% Reload Speed)"
		break;

		case "#desc_Bill":
			return "+10% Reload Speed"
		break;

		case "#name_Zoey":
			return "Zoey (+10% Melee DMG)"
		break;

		case "#desc_Zoey":
			return "+10% Melee DMG"
		break;

		case "#name_Louis":
			return "Louis (+10% Move Speed)"
		break;

		case "#desc_Louis":
			return "+10% Move Speed"
		break;

		case "#name_Francis":
			return "Francis (+10% DEF)"
		break;

		case "#desc_Francis":
			return "+10% DEF"
		break;

		case "#name_GlassCannon":
			return "Glass Cannon"
		break;

		case "#desc_GlassCannon":
			return "+30% DMG, -20% DEF"
		break;

		case "#name_Sharpshooter":
			return "Sharpshooter"
		break;

		case "#desc_Sharpshooter":
			return "+25% DMG past 10m"
		break;

		case "#name_Outlaw":
			return "Outlaw"
		break;

		case "#desc_Outlaw":
			return "+100% Pistol / Magnum DMG"
		break;

		case "#name_Overconfident":
			return "Overconfident"
		break;

		case "#desc_Overconfident":
			return "+25% DEF at max lives"
		break;

		case "#name_Slugger":
			return "Slugger"
		break;

		case "#desc_Slugger":
			return "+30% Melee Speed"
		break;

		case "#name_MethHead":
			return "Meth Head"
		break;

		case "#desc_MethHead":
			return "+2.5% Move / Melee Speed per Mutation kill"
		break;

		case "#name_OpticsEnthusiast":
			return "Optics Enthusiast"
		break;

		case "#desc_OpticsEnthusiast":
			return "Gain laser sights (+60% ACC)"
		break;

		case "#name_Breakout":
			return "Breakout"
		break;

		case "#desc_Breakout":
			return "Escape Grabs (60s CD) [+use]"
		break;

		case "#name_AdrenalineRush":
			return "Adrenaline Rush"
		break;

		case "#desc_AdrenalineRush":
			return "Adrenaline on Team incap"
		break;

		case "#name_HelpingHand":
			return "Helping Hand"
		break;

		case "#desc_HelpingHand":
			return "+75% Team Revive Speed"
		break;

		case "#name_CombatMedic":
			return "Combat Medic"
		break;

		case "#desc_CombatMedic":
			return "+15 HP on all revives, +15% Team Revive Speed"
		break;

		case "#name_AmpedUp":
			return "Amped Up"
		break;

		case "#desc_AmpedUp":
			return "Non-event hordes heal +20 Team HP (5s CD)"
		break;

		case "#name_Addict":
			return "Addict"
		break;

		case "#desc_Addict":
			return "+50% Temp Heal EFF, perks by Temp HP level"
		break;

		case "#name_FleetOfFoot":
			return "Fleet of Foot"
		break;

		case "#desc_FleetOfFoot":
			return "+12.5% Move Speed, -10 Max HP"
		break;

		case "#name_CrossTrainers":
			return "Cross Trainers"
		break;

		case "#desc_CrossTrainers":
			return "+7% Move Speed, +5 Max HP"
		break;

		case "#name_Multitool":
			return "Multitool"
		break;

		case "#desc_Multitool":
			return "+40% Team Use Speed"
		break;

		case "#name_RunLikeHell":
			return "Run Like Hell"
		break;

		case "#desc_RunLikeHell":
			return "+30% Move Speed, -15% DEF, Increases Shove CD"
		break;

		case "#name_Quickdraw":
			return "Quickdraw"
		break;

		case "#desc_Quickdraw":
			return "+50% Swap Speed"
		break;

		case "#name_Broken":
			return "Boss Killer"
		break;

		case "#desc_Broken":
			return "+20% DMG vs Bosses"
		break;

		case "#name_Pyromaniac":
			return "Pyromaniac"
		break;

		case "#desc_Pyromaniac":
			return "+150% Fire DMG"
		break;

		case "#name_BombSquad":
			return "Bomb Squad"
		break;

		case "#desc_BombSquad":
			return "+150% Explosive DMG"
		break;

		case "#name_ConfidentKiller":
			return "Confident Killer"
		break;

		case "#desc_ConfidentKiller":
			return "+2.5% DMG per Mutation death"
		break;

		case "#name_CannedGoods":
			return "Canned Goods"
		break;

		case "#desc_CannedGoods":
			return "+35 Max HP"
		break;

		case "#name_SlowAndSteady":
			return "Slow and Steady"
		break;

		case "#desc_SlowAndSteady":
			return "+50 Max HP, -10% Move Speed"
		break;

		case "#name_ToughSkin":
			return "Tough Skin"
		break;

		case "#desc_ToughSkin":
			return "+40% DEF vs Commons"
		break;

		case "#name_ScarTissue":
			return "Scar Tissue"
		break;

		case "#desc_ScarTissue":
			return "+30% DEF, -50% Heal EFF"
		break;

		case "#name_ChemicalBarrier":
			return "Chemical Barrier"
		break;

		case "#desc_ChemicalBarrier":
			return "+50% Acid DEF"
		break;

		case "#name_FaceYourFears":
			return "Face Your Fears"
		break;

		case "#desc_FaceYourFears":
			return "+2 Temp HP on kill within 2.5m"
		break;

		case "#name_Numb":
			return "Numb"
		break;

		case "#desc_Numb":
			return "Temp HP gives +10% DEF"
		break;

		case "#name_MeanDrunk":
			return "Mean Drunk"
		break;

		case "#desc_MeanDrunk":
			return "+20% Melee DMG, +20 Max HP"
		break;

		case "#name_BattleLust":
			return "Battle Lust"
		break;

		case "#desc_BattleLust":
			return "+1 HP on Melee kill"
		break;

		case "#name_Brawler":
			return "Brawler"
		break;

		case "#desc_Brawler":
			return "Shove deals +50 Melee DMG"
		break;

		case "#name_Berserker":
			return "Berserker"
		break;

		case "#desc_Berserker":
			return "+25% Melee DMG, +5% Move Speed"
		break;

		case "#name_HeavyHitter":
			return "Heavy Hitter"
		break;

		case "#desc_HeavyHitter":
			return "Melee stumbles Mutations"
		break;

		case "#name_Rampage":
			return "Rampage"
		break;

		case "#desc_Rampage":
			return "Charge forwards, 100 Melee DMG, REPLACES: Shove (20s CD)"
		break;

		case "#name_SwanSong":
			return "Swan Song"
		break;

		case "#desc_SwanSong":
			return "+100% CRIT chance while incapped"
		break;

		case "#name_Overcrowded":
			return "Overcrowded"
		break;

		case "#desc_Overcrowded":
			return "+0.5% DMG / +1% DEF per Ridden in 5m"
		break;

		case "#name_LastLegs":
			return "Last Legs"
		break;

		case "#desc_LastLegs":
			return "Team can crawl while incapped"
		break;

		case "#name_StrengthInNumbers":
			return "Strength In Numbers"
		break;

		case "#desc_StrengthInNumbers":
			return "+2.5% Team DMG per alive Cleaner"
		break;

		case "#name_BOOM":
			return "BOOM!"
		break;

		case "#desc_BOOM":
			return "Headshot kills cause an explosion"
		break;

		case "#name_FireProof":
			return "Fire Proof"
		break;

		case "#desc_FireProof":
			return "+50% Fire DEF"
		break;

		case "#name_Kneecapper":
			return "Kneecapper"
		break;

		case "#desc_Kneecapper":
			return "Mutations you Melee move 30% slower"
		break;

		case "#name_Brazen":
			return "Brazen"
		break;

		case "#desc_Brazen":
			return "+40% Melee DMG, -25% Reload Speed"
		break;

		case "#name_MarkedForDeath":
			return "Marked for Death"
		break;

		case "#desc_MarkedForDeath":
			return "+10% Team DMG vs Pinged Mutations"
		break;

		case "#name_PackMule":
			return "Pack Mule"
		break;

		case "#desc_PackMule":
			return "+40% Team Max Ammo"
		break;

		case "#name_Resupply":
			return "Resupply"
		break;

		case "#desc_Resupply":
			return "+10% Ammo on Mutation kill"
		break;

		case "#name_Suppression":
			return "Suppression"
		break;

		case "#desc_Suppression":
			return "+100% bullet stopping power"
		break;

		case "#name_EyeOfTheSwarm":
			return "Eye of the Swarm"
		break;

		case "#desc_EyeOfTheSwarm":
			return "+50% DMG in the Swarm Circle"
		break;

		case "#name_EMTBag":
			return "EMT Bag"
		break;

		case "#desc_EMTBag":
			return "+50% Heal EFF"
		break;

		case "#name_AntibioticOintment":
			return "Antibiotic Ointment"
		break;

		case "#desc_AntibioticOintment":
			return "+25% Heal EFF, +10 Temp HP to target"
		break;

		case "#name_MedicalExpert":
			return "Medical Expert"
		break;

		case "#desc_MedicalExpert":
			return "+30% Team Heal EFF"
		break;

		case "#name_Cauterized":
			return "Cauterized"
		break;

		case "#desc_Cauterized":
			return "+50% Slower Team Temp HP Decay"
		break;

		case "#name_GroupTherapy":
			return "Group Therapy"
		break;

		case "#desc_GroupTherapy":
			return "Team shares 20% of health item uses"
		break;

		case "#name_InspiringSacrifice":
			return "Inspiring Sacrifice"
		break;

		case "#desc_InspiringSacrifice":
			return "+25 Team Temp HP after incap"
		break;

		case "#name_ReloadDrills":
			return "Reload Drills"
		break;

		case "#desc_ReloadDrills":
			return "+25% Reload Speed"
		break;

		case "#name_MagCoupler":
			return "Mag Coupler"
		break;

		case "#desc_MagCoupler":
			return "+75% Reload Speed, Increases Shove CD"
		break;

		case "#name_LuckyShot":
			return "Lucky Shot"
		break;

		case "#desc_LuckyShot":
			return "+7% Team CRIT Chance (+400% DMG)"
		break;

		case "#name_Selfless":
			return "Selfless"
		break;

		case "#desc_Selfless":
			return "-15 Max HP, +20 Team Max HP"
		break;

		case "#name_Selfish":
			return "Selfish"
		break;

		case "#desc_Selfish":
			return "+40 Max HP, -5 Team Max HP"
		break;

		case "#name_OutWithABang":
			return "Out With A Bang"
		break;

		case "#desc_OutWithABang":
			return "Drop a Pipe Bomb on incap"
		break;

		case "#name_HeightendSenses":
			return "Heightend Senses"
		break;

		case "#desc_HeightendSenses":
			return "Ping Mutations, Hazards and Items in 7.5m"
		break;

		case "#name_HotShot":
			return "Hot Shot"
		break;

		case "#desc_HotShot":
			return "Apply Ammo Upgrade on Mutation kill"
		break;

		case "#name_Pinata":
			return "Piñata"
		break;

		case "#desc_Pinata":
			return "+15% chance of item on Mutation death"
		break;

		case "#name_RefundPolicy":
			return "Refund Policy"
		break;

		case "#desc_RefundPolicy":
			return "+25% chance to not consume items"
		break;

		case "#name_Stockpile":
			return "Stockpile"
		break;

		case "#desc_Stockpile":
			return "DESC"
		break;

		case "#name_LifeInsurance":
			return "Life Insurance"
		break;

		case "#desc_LifeInsurance":
			return "+1 Team Life"
		break;

		case "#name_WellRested":
			return "Well Rested"
		break;

		case "#desc_WellRested":
			return "Team fully heals each chapter"
		break;

		case "#name_BuckshotBruiser":
			return "Buckshot Bruiser"
		break;

		case "#desc_BuckshotBruiser":
			return "+0.25 Temp HP per Shotgun pellet"
		break;

		case "#name_Arsonist":
			return "Arsonist"
		break;

		case "#desc_Arsonist":
			return "+0.1 Temp HP per Fire DMG"
		break;

		case "#name_NeedsOfTheMany":
			return "Needs of the Many"
		break;

		case "#desc_NeedsOfTheMany":
			return "+1 Team Life, -10 Max HP"
		break;

		case "#name_Lumberjack":
			return "Lumberjack"
		break;

		case "#desc_Lumberjack":
			return "+200% Team Chainsaw DMG"
		break;

		case "#name_Cannoneer":
			return "Cannoneer"
		break;

		case "#desc_Cannoneer":
			return "+200% Team Grenade Launcher DMG"
		break;

		case "#name_Gambler":
			return "Gambler"
		break;

		case "#desc_Gambler":
			return "Randomized stats each map!"
		break;

		case "#name_DownInFront":
			return "Down In Front"
		break;

		case "#desc_DownInFront":
			return "No FF DMG when crouched"
		break;

		case "#name_Shredder":
			return "Shredder"
		break;

		case "#desc_Shredder":
			return "+1% DMG per shot fired until reload"
		break;

		default:
			return msg;
		break;
	}
}

function Translation_RU(msg)
{
	switch(msg)
	{
		//CHAT MESSAGES
		case "#lang_localization":
			return "Русский localization";
		break;

		case "#giveup_msg":
			return "\x01" + "Type " + "\x03" + "!giveup" + "\x01" + " to die...";
		break;

		//PLAYER CARDS
		case "#name_Nick":
			return "Nick (+5% DMG)"
		break;

		case "#desc_Nick":
			return "+5% DMG"
		break;

		case "#name_Rochelle":
			return "Rochelle (+10% Heal EFF)"
		break;

		case "#desc_Rochelle":
			return "+10% Heal EFF"
		break;

		case "#name_Coach":
			return "Coach (+10 Max HP)"
		break;

		case "#desc_Coach":
			return "+10 Max HP"
		break;

		case "#name_Ellis":
			return "Ellis (+5% CRIT Chance)"
		break;

		case "#desc_Ellis":
			return "+5% CRIT Chance"
		break;

		case "#name_Bill":
			return "Bill (+10% Reload Speed)"
		break;

		case "#desc_Bill":
			return "+10% Reload Speed"
		break;

		case "#name_Zoey":
			return "Zoey (+10% Melee DMG)"
		break;

		case "#desc_Zoey":
			return "+10% Melee DMG"
		break;

		case "#name_Louis":
			return "Louis (+10% Move Speed)"
		break;

		case "#desc_Louis":
			return "+10% Move Speed"
		break;

		case "#name_Francis":
			return "Francis (+10% DEF)"
		break;

		case "#desc_Francis":
			return "+10% DEF"
		break;

		case "#name_GlassCannon":
			return "Glass Cannon"
		break;

		case "#desc_GlassCannon":
			return "+30% DMG, -20% DEF"
		break;

		case "#name_Sharpshooter":
			return "Sharpshooter"
		break;

		case "#desc_Sharpshooter":
			return "+25% DMG past 10m"
		break;

		case "#name_Outlaw":
			return "Outlaw"
		break;

		case "#desc_Outlaw":
			return "+100% Pistol / Magnum DMG"
		break;

		case "#name_Overconfident":
			return "Overconfident"
		break;

		case "#desc_Overconfident":
			return "+25% DEF at max lives"
		break;

		case "#name_Slugger":
			return "Slugger"
		break;

		case "#desc_Slugger":
			return "+30% Melee Speed"
		break;

		case "#name_MethHead":
			return "Meth Head"
		break;

		case "#desc_MethHead":
			return "+2.5% Move / Melee Speed per Mutation kill"
		break;

		case "#name_OpticsEnthusiast":
			return "Optics Enthusiast"
		break;

		case "#desc_OpticsEnthusiast":
			return "Gain laser sights (+60% ACC)"
		break;

		case "#name_Breakout":
			return "Breakout"
		break;

		case "#desc_Breakout":
			return "Escape Grabs (60s CD) [+use]"
		break;

		case "#name_AdrenalineRush":
			return "Adrenaline Rush"
		break;

		case "#desc_AdrenalineRush":
			return "Adrenaline on Team incap"
		break;

		case "#name_HelpingHand":
			return "Helping Hand"
		break;

		case "#desc_HelpingHand":
			return "+75% Team Revive Speed"
		break;

		case "#name_CombatMedic":
			return "Combat Medic"
		break;

		case "#desc_CombatMedic":
			return "+15 HP on all revives, +15% Team Revive Speed"
		break;

		case "#name_AmpedUp":
			return "Amped Up"
		break;

		case "#desc_AmpedUp":
			return "Non-event hordes heal +20 Team HP (5s CD)"
		break;

		case "#name_Addict":
			return "Addict"
		break;

		case "#desc_Addict":
			return "+50% Temp Heal EFF, perks by Temp HP level"
		break;

		case "#name_FleetOfFoot":
			return "Fleet of Foot"
		break;

		case "#desc_FleetOfFoot":
			return "+12.5% Move Speed, -10 Max HP"
		break;

		case "#name_CrossTrainers":
			return "Cross Trainers"
		break;

		case "#desc_CrossTrainers":
			return "+7% Move Speed, +5 Max HP"
		break;

		case "#name_Multitool":
			return "Multitool"
		break;

		case "#desc_Multitool":
			return "+40% Team Use Speed"
		break;

		case "#name_RunLikeHell":
			return "Run Like Hell"
		break;

		case "#desc_RunLikeHell":
			return "+30% Move Speed, -15% DEF, Increases Shove CD"
		break;

		case "#name_Quickdraw":
			return "Quickdraw"
		break;

		case "#desc_Quickdraw":
			return "+50% Swap Speed"
		break;

		case "#name_Broken":
			return "Boss Killer"
		break;

		case "#desc_Broken":
			return "+20% DMG vs Bosses"
		break;

		case "#name_Pyromaniac":
			return "Pyromaniac"
		break;

		case "#desc_Pyromaniac":
			return "+150% Fire DMG"
		break;

		case "#name_BombSquad":
			return "Bomb Squad"
		break;

		case "#desc_BombSquad":
			return "+150% Explosive DMG"
		break;

		case "#name_ConfidentKiller":
			return "Confident Killer"
		break;

		case "#desc_ConfidentKiller":
			return "+2.5% DMG per Mutation death"
		break;

		case "#name_CannedGoods":
			return "Canned Goods"
		break;

		case "#desc_CannedGoods":
			return "+35 Max HP"
		break;

		case "#name_SlowAndSteady":
			return "Slow and Steady"
		break;

		case "#desc_SlowAndSteady":
			return "+50 Max HP, -10% Move Speed"
		break;

		case "#name_ToughSkin":
			return "Tough Skin"
		break;

		case "#desc_ToughSkin":
			return "+40% DEF vs Commons"
		break;

		case "#name_ScarTissue":
			return "Scar Tissue"
		break;

		case "#desc_ScarTissue":
			return "+30% DEF, -50% Heal EFF"
		break;

		case "#name_ChemicalBarrier":
			return "Chemical Barrier"
		break;

		case "#desc_ChemicalBarrier":
			return "+50% Acid DEF"
		break;

		case "#name_FaceYourFears":
			return "Face Your Fears"
		break;

		case "#desc_FaceYourFears":
			return "+2 Temp HP on kill within 2.5m"
		break;

		case "#name_Numb":
			return "Numb"
		break;

		case "#desc_Numb":
			return "Temp HP gives +10% DEF"
		break;

		case "#name_MeanDrunk":
			return "Mean Drunk"
		break;

		case "#desc_MeanDrunk":
			return "+20% Melee DMG, +20 Max HP"
		break;

		case "#name_BattleLust":
			return "Battle Lust"
		break;

		case "#desc_BattleLust":
			return "+1 HP on Melee kill"
		break;

		case "#name_Brawler":
			return "Brawler"
		break;

		case "#desc_Brawler":
			return "Shove deals +50 Melee DMG"
		break;

		case "#name_Berserker":
			return "Berserker"
		break;

		case "#desc_Berserker":
			return "+25% Melee DMG, +5% Move Speed"
		break;

		case "#name_HeavyHitter":
			return "Heavy Hitter"
		break;

		case "#desc_HeavyHitter":
			return "Melee stumbles Mutations"
		break;

		case "#name_Rampage":
			return "Rampage"
		break;

		case "#desc_Rampage":
			return "Charge forwards, 100 Melee DMG, REPLACES: Shove (20s CD)"
		break;

		case "#name_SwanSong":
			return "Swan Song"
		break;

		case "#desc_SwanSong":
			return "+100% CRIT chance while incapped"
		break;

		case "#name_Overcrowded":
			return "Overcrowded"
		break;

		case "#desc_Overcrowded":
			return "+0.5% DMG / +1% DEF per Ridden in 5m"
		break;

		case "#name_LastLegs":
			return "Last Legs"
		break;

		case "#desc_LastLegs":
			return "Team can crawl while incapped"
		break;

		case "#name_StrengthInNumbers":
			return "Strength In Numbers"
		break;

		case "#desc_StrengthInNumbers":
			return "+2.5% Team DMG per alive Cleaner"
		break;

		case "#name_BOOM":
			return "BOOM!"
		break;

		case "#desc_BOOM":
			return "Headshot kills cause an explosion"
		break;

		case "#name_FireProof":
			return "Fire Proof"
		break;

		case "#desc_FireProof":
			return "+50% Fire DEF"
		break;

		case "#name_Kneecapper":
			return "Kneecapper"
		break;

		case "#desc_Kneecapper":
			return "Mutations you Melee move 30% slower"
		break;

		case "#name_Brazen":
			return "Brazen"
		break;

		case "#desc_Brazen":
			return "+40% Melee DMG, -25% Reload Speed"
		break;

		case "#name_MarkedForDeath":
			return "Marked for Death"
		break;

		case "#desc_MarkedForDeath":
			return "+10% Team DMG vs Pinged Mutations"
		break;

		case "#name_PackMule":
			return "Pack Mule"
		break;

		case "#desc_PackMule":
			return "+40% Team Max Ammo"
		break;

		case "#name_Resupply":
			return "Resupply"
		break;

		case "#desc_Resupply":
			return "+10% Ammo on Mutation kill"
		break;

		case "#name_Suppression":
			return "Suppression"
		break;

		case "#desc_Suppression":
			return "+100% bullet stopping power"
		break;

		case "#name_EyeOfTheSwarm":
			return "Eye of the Swarm"
		break;

		case "#desc_EyeOfTheSwarm":
			return "+50% DMG in the Swarm Circle"
		break;

		case "#name_EMTBag":
			return "EMT Bag"
		break;

		case "#desc_EMTBag":
			return "+50% Heal EFF"
		break;

		case "#name_AntibioticOintment":
			return "Antibiotic Ointment"
		break;

		case "#desc_AntibioticOintment":
			return "+25% Heal EFF, +10 Temp HP to target"
		break;

		case "#name_MedicalExpert":
			return "Medical Expert"
		break;

		case "#desc_MedicalExpert":
			return "+30% Team Heal EFF"
		break;

		case "#name_Cauterized":
			return "Cauterized"
		break;

		case "#desc_Cauterized":
			return "+50% Slower Team Temp HP Decay"
		break;

		case "#name_GroupTherapy":
			return "Group Therapy"
		break;

		case "#desc_GroupTherapy":
			return "Team shares 20% of health item uses"
		break;

		case "#name_InspiringSacrifice":
			return "Inspiring Sacrifice"
		break;

		case "#desc_InspiringSacrifice":
			return "+25 Team Temp HP after incap"
		break;

		case "#name_ReloadDrills":
			return "Reload Drills"
		break;

		case "#desc_ReloadDrills":
			return "+25% Reload Speed"
		break;

		case "#name_MagCoupler":
			return "Mag Coupler"
		break;

		case "#desc_MagCoupler":
			return "+75% Reload Speed, Increases Shove CD"
		break;

		case "#name_LuckyShot":
			return "Lucky Shot"
		break;

		case "#desc_LuckyShot":
			return "+7% Team CRIT Chance (+400% DMG)"
		break;

		case "#name_Selfless":
			return "Selfless"
		break;

		case "#desc_Selfless":
			return "-15 Max HP, +20 Team Max HP"
		break;

		case "#name_Selfish":
			return "Selfish"
		break;

		case "#desc_Selfish":
			return "+40 Max HP, -5 Team Max HP"
		break;

		case "#name_OutWithABang":
			return "OutWithABang"
		break;

		case "#desc_OutWithABang":
			return "Drop a Pipe Bomb on incap"
		break;

		case "#name_HeightendSenses":
			return "Heightend Senses"
		break;

		case "#desc_HeightendSenses":
			return "Ping Mutations, Hazards and Items in 7.5m"
		break;

		case "#name_HotShot":
			return "Hot Shot"
		break;

		case "#desc_HotShot":
			return "Apply Ammo Upgrade on Mutation kill"
		break;

		case "#name_Pinata":
			return "Piñata"
		break;

		case "#desc_Pinata":
			return "+15% chance of item on Mutation death"
		break;

		case "#name_RefundPolicy":
			return "Refund Policy"
		break;

		case "#desc_RefundPolicy":
			return "+25% chance to not consume items"
		break;

		case "#name_Stockpile":
			return "Stockpile"
		break;

		case "#desc_Stockpile":
			return "DESC"
		break;

		case "#name_LifeInsurance":
			return "Life Insurance"
		break;

		case "#desc_LifeInsurance":
			return "+1 Team Life"
		break;

		case "#name_WellRested":
			return "Well Rested"
		break;

		case "#desc_WellRested":
			return "Team fully heals each chapter"
		break;

		case "#name_BuckshotBruiser":
			return "Buckshot Bruiser"
		break;

		case "#desc_BuckshotBruiser":
			return "+0.25 Temp HP per Shotgun pellet"
		break;

		case "#name_Arsonist":
			return "Arsonist"
		break;

		case "#desc_Arsonist":
			return "+0.1 Temp HP per Fire DMG"
		break;

		case "#name_NeedsOfTheMany":
			return "Needs of the Many"
		break;

		case "#desc_NeedsOfTheMany":
			return "+1 Team Life, -10 Max HP"
		break;

		case "#name_Lumberjack":
			return "Lumberjack"
		break;

		case "#desc_Lumberjack":
			return "+200% Team Chainsaw DMG"
		break;

		case "#name_Cannoneer":
			return "Cannoneer"
		break;

		case "#desc_Cannoneer":
			return "+200% Team Grenade Launcher DMG"
		break;

		case "#name_Gambler":
			return "Gambler"
		break;

		case "#desc_Gambler":
			return "Randomized stats each map!"
		break;

		case "#name_DownInFront":
			return "Down In Front"
		break;

		case "#desc_DownInFront":
			return "No FF DMG when crouched"
		break;

		case "#name_Shredder":
			return "Shredder"
		break;

		case "#desc_Shredder":
			return "+1% DMG per shot fired until reload"
		break;

		default:
			return msg;
		break;
	}
}