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
			return "\x01" + "Hold " + "\x03" + "[CROUCH]" + "\x01" + " to die...";
		break;

		case "#breakout_msg":
			return "\x01" + "Hold " + "\x03" + "[SHOVE]" + "\x01" + " to break out!";
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
			return "Hold [SHOVE] to escape grabs, +1 Breakout attempts"
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
			return "+50% Team Revive Speed"
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
			return "+50% Team Use Speed, -5% DEF"
		break;

		case "#name_RunLikeHell":
			return "Run Like Hell"
		break;

		case "#desc_RunLikeHell":
			return "+30% Move Speed, -15% DEF, +75% Shove CD"
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
			return "+100% Team Explosive DMG"
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
			return "+40 Max HP, +25% Shove CD"
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
			return "+50 Shove DMG"
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
			return "+25% Heal EFF, +15 Temp HP to target"
		break;

		case "#name_MedicalExpert":
			return "Medical Expert"
		break;

		case "#desc_MedicalExpert":
			return "+30% Team Heal EFF, +10% Team Revive Speed"
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
			return "+75% Reload Speed, +100% Shove CD"
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

		case "#name_CleanKill":
			return "Clean Kill"
		break;

		case "#desc_CleanKill":
			return "Precision kills give +5% DMG, Resets when DMG taken"
		break;

		case "#name_ExperiencedEMT":
			return "Experienced EMT"
		break;

		case "#desc_ExperiencedEMT":
			return "Cleaners you heal gain +25 Max HP"
		break;

		case "#name_WellFed":
			return "Well Fed"
		break;

		case "#desc_WellFed":
			return "+10 Team Max HP"
		break;

		case "#name_MedicalProfessional":
			return "Medical Professional"
		break;

		case "#desc_MedicalProfessional":
			return "Medkits and Defibs heal +10 HP and 1 Extra Life"
		break;

		case "#name_Screwdriver":
			return "Screwdriver"
		break;

		case "#desc_Screwdriver":
			return "+25% Team Use Speed"
		break;

		case "#name_SmellingSalts":
			return "Smelling Salts"
		break;

		case "#desc_SmellingSalts":
			return "+150% Team Revive Speed, Reduces Revive HP"
		break;

		//CORRUPTION CARDS
		case "#cor_commonAcid":
			return "Acid Commons"
		break;

		case "#cor_commonFire":
			return "Fire Commons"
		break;

		case "#cor_commonExplode":
			return "Exploding Commons"
		break;

		case "#cor_hazardBirds":
			return "The Birds"
		break;

		case "#cor_hazardLockdown":
			return "The Lockdown"
		break;

		case "#cor_hazardSleepers":
			return "Slumber Party"
		break;

		case "#cor_environmentDark":
			return "The Dark"
		break;

		case "#cor_environmentFog":
			return "The Fog"
		break;

		case "#cor_environmentBiohazard":
			return "Biohazard"
		break;

		case "#cor_environmentFrozen":
			return "Frigid Outskirts"
		break;

		case "#cor_environmentSwarmStream":
			return "Swarm Stream"
		break;

		case "#cor_hordeHunted":
			return "Hunted"
		break;

		case "#cor_hordeOnslaught":
			return "Onslaught"
		break;

		case "#cor_hordeTallboy":
			return "Tallboy Hordes"
		break;

		case "#cor_hordeCrusher":
			return "Crusher Hordes"
		break;

		case "#cor_hordeBruiser":
			return "Bruiser Hordes"
		break;

		case "#cor_hordeHocker":
			return "Hocker Hordes"
		break;

		case "#cor_hordeStinger":
			return "Stinger Hordes"
		break;

		case "#cor_hordeStalker":
			return "Stalker Hordes"
		break;

		case "#cor_hordeExploder":
			return "Exploder Hordes"
		break;

		case "#cor_hordeRetch":
			return "Retch Hordes"
		break;

		case "#cor_hordeReeker":
			return "Reeker Hordes"
		break;

		case "#cor_gameplayNoGrenades":
			return "Empty Pockets"
		break;

		case "#cor_gameplayNoOutlines":
			return "No Outlines"
		break;

		case "#cor_gameplayNoSupport":
			return "Survival of the Fittest"
		break;

		case "#cor_gameplayNoRespawn":
			return "Do or Die"
		break;

		case "#cor_playerLessAmmo":
			return "Ammo Shortage"
		break;

		case "#cor_playerFatigue":
			return "Fatigue"
		break;

		case "#cor_uncommonClown":
			return "Clown Show"
		break;

		case "#cor_uncommonRiot":
			return "Crowd Control"
		break;

		case "#cor_uncommonMud":
			return "Mud Crawlers"
		break;

		case "#cor_uncommonCeda":
			return "CEDA Operatives"
		break;

		case "#cor_uncommonConstruction":
			return "Construction Site"
		break;

		case "#cor_uncommonJimmy":
			return "Jimmy Gibbs and Cousins"
		break;

		case "#cor_uncommonFallen":
			return "Fallen Cleaners"
		break;

		case "#cor_commonShamble":
			return "Shambling Commons"
		break;

		case "#cor_commonRunning":
			return "Running Commons"
		break;

		case "#cor_commonBlitzing":
			return "Blitzing Commons"
		break;

		case "#cor_Tallboy":
			return "Tallboys"
		break;

		case "#cor_Fer_Tallboy":
			return "Ferocious Tallboys"
		break;

		case "#cor_Mon_Tallboy":
			return "Monstrous Tallboys"
		break;

		case "#cor_Crusher":
			return "Crushers"
		break;

		case "#cor_Fer_Crusher":
			return "Ferocious Crushers"
		break;

		case "#cor_Mon_Crusher":
			return "Monstrous Crushers"
		break;

		case "#cor_Bruiser":
			return "Bruisers"
		break;

		case "#cor_Fer_Bruiser":
			return "Ferocious Bruisers"
		break;

		case "#cor_Mon_Bruiser":
			return "Monstrous Bruisers"
		break;

		case "#cor_Hocker":
			return "Hockers"
		break;

		case "#cor_Fer_Hocker":
			return "Ferocious Hockers"
		break;

		case "#cor_Mon_Hocker":
			return "Monstrous Hockers"
		break;

		case "#cor_Stinger":
			return "Stingers"
		break;

		case "#cor_Fer_Stinger":
			return "Ferocious Stingers"
		break;

		case "#cor_Mon_Stinger":
			return "Monstrous Stingers"
		break;

		case "#cor_Stalker":
			return "Stalkers"
		break;

		case "#cor_Fer_Stalker":
			return "Ferocious Stalkers"
		break;

		case "#cor_Mon_Stalker":
			return "Monstrous Stalkers"
		break;

		case "#cor_Retch":
			return "Retches"
		break;

		case "#cor_Fer_Retch":
			return "Ferocious Retches"
		break;

		case "#cor_Mon_Retch":
			return "Monstrous Retches"
		break;

		case "#cor_Exploder":
			return "Exploders"
		break;

		case "#cor_Fer_Exploder":
			return "Ferocious Exploders"
		break;

		case "#cor_Mon_Exploder":
			return "Monstrous Exploders"
		break;

		case "#cor_Reeker":
			return "Reekers"
		break;

		case "#cor_Fer_Reeker":
			return "Ferocious Reekers"
		break;

		case "#cor_Mon_Reeker":
			return "Monstrous Reekers"
		break;

		case "#cor_hazardSnitch":
			return "Tattlers"
		break;

		case "#cor_hazardBreaker":
			return "Breaker"
		break;

		case "#cor_hazardBreakerRaging":
			return "Raging Breaker"
		break;

		case "#cor_hazardOgre":
			return "Ogre"
		break;

		case "#cor_hazardOgreRaging":
			return "Raging Ogre"
		break;

		case "#cor_missionSpeedrun":
			return "Speedrun"
		break;

		case "#cor_missionAllAlive":
			return "No One Left Behind"
		break;

		case "#cor_missionGnomeAlone":
			return "Gnome Alone"
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
			return "Русская локализация";
		break;

		case "#giveup_msg":
			return "\x01" + "Удерживайте " + "\x03" + "[ПРИСЕДАНИЕ]" + "\x01" + " чтобы умереть...";
		break;

		case "#breakout_msg":
			return "\x01" + "Удерживайте " + "\x03" + "[ОТТАЛКИВАНИЕ]" + "\x01" + " чтобы вырваться!";
		break;

		//PLAYER CARDS
		case "#name_Nick":
			return "Ник (+5% к УРН)"
		break;

		case "#desc_Nick":
			return "+5% к УРН"
		break;

		case "#name_Rochelle":
			return "Рошелль (+10% к Эффективности от Лечения)"
		break;

		case "#desc_Rochelle":
			return "+10% к Эффективности от Лечения"
		break;

		case "#name_Coach":
			return "Тренер (+10 к МАКС ХП)"
		break;

		case "#desc_Coach":
			return "+10 к МАКС ХП"
		break;

		case "#name_Ellis":
			return "Эллис (+5% шанс на КРИТ)"
		break;

		case "#desc_Ellis":
			return "+5% шанс на КРИТ"
		break;

		case "#name_Bill":
			return "Билл (+10% к Скорости перезарядки)"
		break;

		case "#desc_Bill":
			return "+10% к Скорости перезарядки"
		break;

		case "#name_Zoey":
			return "Зои (+10% УРН к Рукопашному бою)"
		break;

		case "#desc_Zoey":
			return "+10% УРН к Рукопашному бою"
		break;

		case "#name_Louis":
			return "Луис (+10% к Скорости Передвижения)"
		break;

		case "#desc_Louis":
			return "+10% к Скорости Передвижения"
		break;

		case "#name_Francis":
			return "Френсис (+10% ЗЩТ)"
		break;

		case "#desc_Francis":
			return "+10% ЗЩТ"
		break;

		case "#name_GlassCannon":
			return "Стеклянная Пушка"
		break;

		case "#desc_GlassCannon":
			return "+30% УРН, -20% ЗЩТ"
		break;

		case "#name_Sharpshooter":
			return "Меткий стрелок"
		break;

		case "#desc_Sharpshooter":
			return "+25% к УРН после 10м"
		break;

		case "#name_Outlaw":
			return "Ковбой вне закона"
		break;

		case "#desc_Outlaw":
			return "+100% к УРН Пистолетами / Магнумом"
		break;

		case "#name_Overconfident":
			return "Излишне Самоуверенный"
		break;

		case "#desc_Overconfident":
			return "+25% к ЗЩТ в состоянии всех жизней (без инкапов)"
		break;

		case "#name_Slugger":
			return "Слаггер"
		break;

		case "#desc_Slugger":
			return "+30% к Скорости рукопашного оружия"
		break;

		case "#name_MethHead":
			return "Метамфетаминоголовый"
		break;

		case "#desc_MethHead":
			return "+2.5% к Скорости Передвижения/Рукопашного оружия за каждое убийство мутанта"
		break;

		case "#name_OpticsEnthusiast":
			return "Энтузиаст в оптике"
		break;

		case "#desc_OpticsEnthusiast":
			return "Получить лазерный прицел (+60% Точности)"
		break;

		case "#name_Breakout":
			return "Вырваться"
		break;

		case "#desc_Breakout":
			return "Удерживайте [ОТТАЛКИВАНИЕ], чтобы освободиться, +1 к попыткам"
		break;

		case "#name_AdrenalineRush":
			return "Выброс Адреналина"
		break;

		case "#desc_AdrenalineRush":
			return "Адреналин для всей Комманды после инкапа"
		break;

		case "#name_HelpingHand":
			return "Рука Помощи"
		break;

		case "#desc_HelpingHand":
			return "+50% к Скорости поднятия для всей Команды"
		break;

		case "#name_CombatMedic":
			return "Полевой Медик"
		break;

		case "#desc_CombatMedic":
			return "+15 ХП на каждый ривайв, +15% к Командной скорости ривайвов"
		break;

		case "#name_AmpedUp":
			return "Подзарядка"
		break;

		case "#desc_AmpedUp":
			return "Спавн орды не на евенте лечит +20 ХП Команде (5c откат)"
		break;

		case "#name_Addict":
			return "Накроман"
		break;

		case "#desc_Addict":
			return "+50% к ЭФФ Лечения Быстрым Здоровьем, кратно уровню ХП Команды"
		break;

		case "#name_FleetOfFoot":
			return "Ноги скороходы"
		break;

		case "#desc_FleetOfFoot":
			return "+12.5% Скорости Передвижения, -10 МАКС ХП"
		break;

		case "#name_CrossTrainers":
			return "Кроссовки"
		break;

		case "#desc_CrossTrainers":
			return "+7% Скорости Передвижения, +5 МАКС ХП"
		break;

		case "#name_Multitool":
			return "Мультитул"
		break;

		case "#desc_Multitool":
			return "+50% к командной скорости использования, -5% ЗЩТ"
		break;

		case "#name_RunLikeHell":
			return "Бежать со всех сил"
		break;

		case "#desc_RunLikeHell":
			return "+30% Скорости Передвижения, -15% ЗЩТ, +75% к откату Отталкивания"
		break;

		case "#name_Quickdraw":
			return "Quickdraw"
		break;

		case "#desc_Quickdraw":
			return "+50% Swap Speed"
		break;

		case "#name_Broken":
			return "Убийца Боссов"
		break;

		case "#desc_Broken":
			return "+20% УРН на Боссов"
		break;

		case "#name_Pyromaniac":
			return "Пироман"
		break;

		case "#desc_Pyromaniac":
			return "+150% УРН Огнём"
		break;

		case "#name_BombSquad":
			return "Отряд Подрывников"
		break;

		case "#desc_BombSquad":
			return "+100% к УРН Взрывами Команды"
		break;

		case "#name_ConfidentKiller":
			return "Уверенный Убийца"
		break;

		case "#desc_ConfidentKiller":
			return "+2.5% УРН за каждого убитого Мутанта"
		break;

		case "#name_CannedGoods":
			return "Банка здоровья"
		break;

		case "#desc_CannedGoods":
			return "+40 МАКС ХП, +25% откат Отталкивания"
		break;

		case "#name_SlowAndSteady":
			return "Медленно, но уверенно"
		break;

		case "#desc_SlowAndSteady":
			return "+50 МАКС ХП, -10% к Скорости Передвижения"
		break;

		case "#name_ToughSkin":
			return "Толстокожий"
		break;

		case "#desc_ToughSkin":
			return "+40% ЗЩТ от обычных зараженных"
		break;

		case "#name_ScarTissue":
			return "Рубцовая Кожа"
		break;

		case "#desc_ScarTissue":
			return "+30% ЗЩТ, -50% к Эффективности от Лечения"
		break;

		case "#name_ChemicalBarrier":
			return "Поверхностный барьер"
		break;

		case "#desc_ChemicalBarrier":
			return "+50% ЗЩТ от Кислоты"
		break;

		case "#name_FaceYourFears":
			return "Лицом к Страху"
		break;

		case "#desc_FaceYourFears":
			return "+2 временного ХП на убийства в пределе 2.5м"
		break;

		case "#name_Numb":
			return "Numb"
		break;

		case "#desc_Numb":
			return "Temp HP gives +10% DEF"
		break;

		case "#name_MeanDrunk":
			return "Злой Пьяница"
		break;

		case "#desc_MeanDrunk":
			return "+20% Рукопашного УРН, +20 МАКС ХП"
		break;

		case "#name_BattleLust":
			return "Battle Lust"
		break;

		case "#desc_BattleLust":
			return "+1 HP on Melee kill"
		break;

		case "#name_Brawler":
			return "Дебошир"
		break;

		case "#desc_Brawler":
			return "+50 УРН Отталкиванием"
		break;

		case "#name_Berserker":
			return "Берсерк"
		break;

		case "#desc_Berserker":
			return "+25% УРН Рукопашным боем, +5% Скорости Передвижения"
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
			return "Лебединая Песня"
		break;

		case "#desc_SwanSong":
			return "+100% к шансу на КРИТ когда в инкапе"
		break;

		case "#name_LastLegs":
			return "Ползунком"
		break;

		case "#desc_LastLegs":
			return "Команда может ползти когда в инкапе"
		break;

		case "#name_StrengthInNumbers":
			return "Сила в количестве"
		break;

		case "#desc_StrengthInNumbers":
			return "+2.5% к УРН Команды за каждого живого Чистильщика"
		break;

		case "#name_BOOM":
			return "БУМ!"
		break;

		case "#desc_BOOM":
			return "Убийство в голову приводит к взрыву"
		break;

		case "#name_FireProof":
			return "Защита от огня"
		break;

		case "#desc_FireProof":
			return "+50% ЗЩТ от огня"
		break;

		case "#name_Kneecapper":
			return "Kneecapper"
		break;

		case "#desc_Kneecapper":
			return "Mutations you Melee move 30% slower"
		break;

		case "#name_Brazen":
			return "Наглость"
		break;

		case "#desc_Brazen":
			return "+40% УРН Рукопашным боем, -25% Скорости перезарядки"
		break;

		case "#name_MarkedForDeath":
			return "Смертельно помечен"
		break;

		case "#desc_MarkedForDeath":
			return "+10% к УРН Команды на Помеченных Мутантов"
		break;

		case "#name_PackMule":
			return "Загруженный мул"
		break;

		case "#desc_PackMule":
			return "+40% к МАКС патронам Команды"
		break;

		case "#name_Resupply":
			return "Подзапаска"
		break;

		case "#desc_Resupply":
			return "+10% Патронов на убийство Мутанта"
		break;

		case "#name_Suppression":
			return "Suppression"
		break;

		case "#desc_Suppression":
			return "+100% bullet stopping power"
		break;

		case "#name_EyeOfTheSwarm":
			return "Под Куполом Сворма"
		break;

		case "#desc_EyeOfTheSwarm":
			return "+50% к УРН внутри пределов купола Сворма"
		break;

		case "#name_EMTBag":
			return "Аптечка Первой Помощи"
		break;

		case "#desc_EMTBag":
			return "+50% к Эффективности лечения"
		break;

		case "#name_AntibioticOintment":
			return "Антибактериальная Смазка"
		break;

		case "#desc_AntibioticOintment":
			return "+25% к Эффективности лечения, +15 временного ХП на цель"
		break;

		case "#name_MedicalExpert":
			return "Экспертный Медик"
		break;

		case "#desc_MedicalExpert":
			return "+30% к Эффективности лечения Команды, +10% к Скорости ривайва Команды"
		break;

		case "#name_Cauterized":
			return "Прижигание"
		break;

		case "#desc_Cauterized":
			return "+50% к замедлению убывания временного ХП Команды"
		break;

		case "#name_GroupTherapy":
			return "Групповая Терапия"
		break;

		case "#desc_GroupTherapy":
			return "Команда делит 20% здоровья после использования предметов лечения"
		break;

		case "#name_InspiringSacrifice":
			return "Вдохновляющая Жертва"
		break;

		case "#desc_InspiringSacrifice":
			return "+25 к временному ХП Команды после инкапа"
		break;

		case "#name_ReloadDrills":
			return "Навыки Перезярядки"
		break;

		case "#desc_ReloadDrills":
			return "+25% к Скорости Перезарядки"
		break;

		case "#name_MagCoupler":
			return "Модифицированный Магазин"
		break;

		case "#desc_MagCoupler":
			return "+75% к Скорости Перезарядки, +100% к откату Отталкивания"
		break;

		case "#name_LuckyShot":
			return "Удачный выстрел"
		break;

		case "#desc_LuckyShot":
			return "+7% шанс на КРИТ у всей Команды (+400% УРН)"
		break;

		case "#name_Selfless":
			return "Самопожертвование"
		break;

		case "#desc_Selfless":
			return "-15 МАКС ХП, +20 МАКС ХП Команды"
		break;

		case "#name_Selfish":
			return "Самолюбие"
		break;

		case "#desc_Selfish":
			return "+40 МАКС ХП, -5 МАКС ХП Команды"
		break;

		case "#name_OutWithABang":
			return "OutWithABang"
		break;

		case "#desc_OutWithABang":
			return "Drop a Pipe Bomb on incap"
		break;

		case "#name_HeightendSenses":
			return "Обострённые чувства"
		break;

		case "#desc_HeightendSenses":
			return "Пометить Мутантов, Ловушки и Предметы в пределе 7.5м"
		break;

		case "#name_HotShot":
			return "Отличный стрелок"
		break;

		case "#desc_HotShot":
			return "Апргейд патронов за убийство Мутанта"
		break;

		case "#name_Pinata":
			return "Пиньята"
		break;

		case "#desc_Pinata":
			return "+15% шанс получить предмет после убийства Мутанта"
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
			return "Хорошо отдохнувший"
		break;

		case "#desc_WellRested":
			return "Команда полностью вылечена после каждой главы"
		break;

		case "#name_BuckshotBruiser":
			return "Картечь"
		break;

		case "#desc_BuckshotBruiser":
			return "+0.25 к временному ХП за каджую дробинку Дробовика"
		break;

		case "#name_Arsonist":
			return "Поджигатель"
		break;

		case "#desc_Arsonist":
			return "+0.1 временного ХП на каждый УРН Огнём"
		break;

		case "#name_NeedsOfTheMany":
			return "Потребности многих"
		break;

		case "#desc_NeedsOfTheMany":
			return "+1 к жизням Команды, -10 МАКС ХП"
		break;

		case "#name_Lumberjack":
			return "Лесоруб"
		break;

		case "#desc_Lumberjack":
			return "+200% к УРН бензопилой Команды"
		break;

		case "#name_Cannoneer":
			return "Пушечник"
		break;

		case "#desc_Cannoneer":
			return "+200% к УРН гранатомётом Команды"
		break;

		case "#name_Gambler":
			return "Азартный Игрок"
		break;

		case "#desc_Gambler":
			return "Рандомные статы каждую карту!"
		break;

		case "#name_DownInFront":
			return "Отойти с пути"
		break;

		case "#desc_DownInFront":
			return "Не наносить УРН своим когда приседаешь"
		break;

		case "#name_Shredder":
			return "Шреддер"
		break;

		case "#desc_Shredder":
			return "+1% УРН за выстрел вплоть до перезарядки"
		break;

		case "#name_CleanKill":
			return "Чистое Убийство"
		break;

		case "#desc_CleanKill":
			return "Точное добивание в голову даёт +5% к УРН, Обнуляется когда УРН был получен"
		break;

		case "#name_ExperiencedEMT":
			return "Опытный Медэксперт"
		break;

		case "#desc_ExperiencedEMT":
			return "Чистильщиков которых вы лечите получают +25 к МАКС ХП"
		break;

		case "#name_WellFed":
			return "Хорошо накормлен"
		break;

		case "#desc_WellFed":
			return "+10 к МАКС ХП Команды"
		break;

		case "#name_MedicalProfessional":
			return "Медик Профессионал"
		break;

		case "#desc_MedicalProfessional":
			return "Аптечки и Дефибприляторы дают +10 ХП и 1 Жизнь"
		break;

		case "#name_Screwdriver":
			return "Отвёртка"
		break;

		case "#desc_Screwdriver":
			return "+25% к Скорости Использования Команды"
		break;

		case "#name_SmellingSalts":
			return "Нюхательная соль"
		break;

		case "#desc_SmellingSalts":
			return "+150% к скорости ривайва Команды, Уменьшает кол-во ХП у поднятого"
		break;

		//CORRUPTION CARDS
		case "#cor_commonAcid":
			return "Кислотные заражённые"
		break;

		case "#cor_commonFire":
			return "Огненные заражённые"
		break;

		case "#cor_commonExplode":
			return "Взрывающиеся заражённые"
		break;

		case "#cor_hazardBirds":
			return "Вороны"
		break;

		case "#cor_hazardLockdown":
			return "Двери с сигнализацией"
		break;

		case "#cor_hazardSleepers":
			return "Слиперы"
		break;

		case "#cor_environmentDark":
			return "Темнота"
		break;

		case "#cor_environmentFog":
			return "Туман"
		break;

		case "#cor_environmentBiohazard":
			return "Biohazard"
		break;

		case "#cor_environmentFrozen":
			return "Холодные окраины"
		break;

		case "#cor_environmentSwarmStream":
			return "Светящийся ручей"
		break;

		case "#cor_hordeHunted":
			return "На Охоте"
		break;

		case "#cor_hordeOnslaught":
			return "Натиск"
		break;

		case "#cor_hordeTallboy":
			return "Орда Толлбоев"
		break;

		case "#cor_hordeCrusher":
			return "Орда Крашеров"
		break;

		case "#cor_hordeBruiser":
			return "Орда Брузеров"
		break;

		case "#cor_hordeHocker":
			return "Орда Хокеров"
		break;

		case "#cor_hordeStinger":
			return "Орда Стингеров"
		break;

		case "#cor_hordeStalker":
			return "Орда Сталкеров"
		break;

		case "#cor_hordeExploder":
			return "Орда Эксплодеров"
		break;

		case "#cor_hordeRetch":
			return "Орда Ретчей"
		break;

		case "#cor_hordeReeker":
			return "Орда Рикеров"
		break;

		case "#cor_gameplayNoGrenades":
			return "Опустевшие карманы"
		break;

		case "#cor_gameplayNoOutlines":
			return "Без контуров"
		break;

		case "#cor_gameplayNoSupport":
			return "Выживает наиболее приспособленный"
		break;

		case "#cor_gameplayNoRespawn":
			return "Сделай или сдохни"
		break;

		case "#cor_playerLessAmmo":
			return "Нехватка боеприпасов"
		break;

		case "#cor_playerFatigue":
			return "Усталость"
		break;

		case "#cor_uncommonClown":
			return "Шоу Клоунов"
		break;

		case "#cor_uncommonRiot":
			return "Подавление толпы"
		break;

		case "#cor_uncommonMud":
			return "Грязевики"
		break;

		case "#cor_uncommonCeda":
			return "Сотрудники CEDA"
		break;

		case "#cor_uncommonConstruction":
			return "Стройка"
		break;

		case "#cor_uncommonJimmy":
			return "Джимми Гиббс и его двоюродные братья"
		break;

		case "#cor_uncommonFallen":
			return "Павшие чистильщики"
		break;

		case "#cor_commonShamble":
			return "Медленные заражённые"
		break;

		case "#cor_commonRunning":
			return "Обычные заражённые"
		break;

		case "#cor_commonBlitzing":
			return "Быстрые заражённые"
		break;

		case "#cor_Tallboy":
			return "Толлбои"
		break;

		case "#cor_Fer_Tallboy":
			return "Свирепые Толлбои"
		break;

		case "#cor_Mon_Tallboy":
			return "Монструозные Толлбои"
		break;

		case "#cor_Crusher":
			return "Крашеры"
		break;

		case "#cor_Fer_Crusher":
			return "Свирепые Крашеры"
		break;

		case "#cor_Mon_Crusher":
			return "Монструозные Крашеры"
		break;

		case "#cor_Bruiser":
			return "Брузеры"
		break;

		case "#cor_Fer_Bruiser":
			return "Свирепые Брузеры"
		break;

		case "#cor_Mon_Bruiser":
			return "Монструозные Брузеры"
		break;

		case "#cor_Hocker":
			return "Хокеры"
		break;

		case "#cor_Fer_Hocker":
			return "Свирепые Хокеры"
		break;

		case "#cor_Mon_Hocker":
			return "Монструозные Хокеры"
		break;

		case "#cor_Stinger":
			return "Стингеры"
		break;

		case "#cor_Fer_Stinger":
			return "Свирепые Стингеры"
		break;

		case "#cor_Mon_Stinger":
			return "Монструозные Стингеры"
		break;

		case "#cor_Stalker":
			return "Сталкеры"
		break;

		case "#cor_Fer_Stalker":
			return "Свирепые Сталкеры"
		break;

		case "#cor_Mon_Stalker":
			return "Монструозные Сталкеры"
		break;

		case "#cor_Retch":
			return "Ретчи"
		break;

		case "#cor_Fer_Retch":
			return "Свирепые Ретчи"
		break;

		case "#cor_Mon_Retch":
			return "Монструозные Ретчи"
		break;

		case "#cor_Exploder":
			return "Эксплодеры"
		break;

		case "#cor_Fer_Exploder":
			return "Свирепые Эксплодеры"
		break;

		case "#cor_Mon_Exploder":
			return "Монструозные Эксплодеры"
		break;

		case "#cor_Reeker":
			return "Рикеры"
		break;

		case "#cor_Fer_Reeker":
			return "Свирепые Рикеры"
		break;

		case "#cor_Mon_Reeker":
			return "Монструозные Рикеры"
		break;

		case "#cor_hazardSnitch":
			return "Стукачи"
		break;

		case "#cor_hazardBreaker":
			return "Брейкер"
		break;

		case "#cor_hazardBreakerRaging":
			return "Разгневанный Брейкер"
		break;

		case "#cor_hazardOgre":
			return "Огр"
		break;

		case "#cor_hazardOgreRaging":
			return "Разгневанный Огр"
		break;

		case "#cor_missionSpeedrun":
			return "Спидран"
		break;

		case "#cor_missionAllAlive":
			return "Своих не оставляем"
		break;

		case "#cor_missionGnomeAlone":
			return "Один Гнома"
		break;

		default:
			return msg;
		break;
	}
}
