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
			case "Spanish":
				return Translation_ES(msg);
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
	if(msg in EN_TranslationTable)
	{
		return EN_TranslationTable[msg];
	}
	else
	{
		return msg;
	}
}

function Translation_RU(msg)
{
	if(msg in RU_TranslationTable)
	{
		printl(RU_TranslationTable[msg]);
		return RU_TranslationTable[msg];
	}
	else
	{
		return msg;
	}
}

function Translation_ES(msg)
{
	if(msg in ES_TranslationTable)
	{
		printl(ES_TranslationTable[msg]);
		return ES_TranslationTable[msg];
	}
	else
	{
		return msg;
	}
}

EN_TranslationTable <- {
	//CHAT MESSAGES
 	"#lang_localization": "\x04" + "English localization"
	"#giveup_msg": "\x01" + "Hold " + "\x03" + "[CROUCH]" + "\x01" + " to die..."
	"#breakout_msg": "\x01" + "Hold " + "\x03" + "[SHOVE]" + "\x01" + " to break out!"

	"#enablehardcore_msg": "\x04" + "Hardcore mode enabled"
	"#disablehardcore_msg": "\x04" + "Hardcore mode disabled"

	"#autohudoff_msg": "\x04" + "Auto hide card HUD off"
	"#autohudon_msg": "\x04" + "Auto hide card HUD on"

	"#helpping_msg": "\x04" + "!ping" + "\x01" + " - Pings enemies and world"
	"#helpcards_msg": "\x04" + "!cards" + "\x01" + " - Displays card HUD"
	"#helpshuffle_msg": "\x04" + "!shuffle" + "\x01" + " - Shuffles current cards players can pick"
	"#helppick_msg": "\x04" + "!pick" + "\x01" + " - Pick a player card [1-8]"
	"#helpbotpick_msg": "\x04" + "!botpick" + "\x01" + " - Pick a player card for bots [1-8]"
	"#helpdrop_msg": "\x04" + "!drop" + "\x01" + " - Drop current in hand item"
	"#helplives_msg": "!lives" + "\x01" + " - Shows all current players number of lives"

	//BOT NAMES
	"#bot_Nick": "NICK"
	"#bot_Rochelle": "ROCHELLE"
	"#bot_Coach": "COACH"
	"#bot_Ellis": "ELLIS"
	"#bot_Bill": "BILL"
	"#bot_Zoey": "ZOEY"
	"#bot_Louis": "LOUIS"
	"#bot_Francis": "FRANCIS"

	//PLAYER CARDS
	"#name_Nick": "Nick (+5% DMG)"
	"#desc_Nick": "+5% DMG"

	"#name_Rochelle": "Rochelle (+10% Heal EFF)"
	"#desc_Rochelle": "+10% Heal EFF"

	"#name_Coach": "Coach (+10 Max HP)"
	"#desc_Coach": "+10 Max HP"

	"#name_Ellis": "Ellis (+5% CRIT Chance)"
	"#desc_Ellis": "+5% CRIT Chance"

	"#name_Bill": "Bill (+10% Reload Speed)"
	"#desc_Bill": "+10% Reload Speed"

	"#name_Zoey": "Zoey (+10% Melee DMG)"
	"#desc_Zoey": "+10% Melee DMG"

	"#name_Louis": "Louis (+10% Move Speed)"
	"#desc_Louis": "+10% Move Speed"

	"#name_Francis": "Francis (+10% DEF)"
	"#desc_Francis": "+10% DEF"

	"#name_GlassCannon": "Glass Cannon"
	"#desc_GlassCannon": "+30% DMG, -20% DEF"

	"#name_Sharpshooter": "Sharpshooter"
	"#desc_Sharpshooter": "+25% DMG past 10m"

	"#name_Outlaw": "Outlaw"
	"#desc_Outlaw": "+100% Pistol / Magnum DMG"

	"#name_Overconfident": "Overconfident"
	"#desc_Overconfident": "+25% DEF at max lives"

	"#name_Slugger": "Slugger"
	"#desc_Slugger": "+30% Melee Speed"

	"#name_MethHead": "Meth Head"
	"#desc_MethHead": "+2.5% Move / Melee Speed per Mutation kill"

	"#name_OpticsEnthusiast": "Optics Enthusiast"
	"#desc_OpticsEnthusiast": "Gain laser sights (+60% ACC)"

	"#name_Breakout": "Breakout"
	"#desc_Breakout": "Hold [SHOVE] to escape grabs, +1 Breakout attempts"

	"#name_AdrenalineRush": "Adrenaline Rush"
	"#desc_AdrenalineRush": "Adrenaline on Team incap"

	"#name_HelpingHand": "Helping Hand"
	"#desc_HelpingHand": "+50% Team Revive Speed"

	"#name_CombatMedic": "Combat Medic"
	"#desc_CombatMedic": "+15 HP on all revives, +15% Team Revive Speed"

	"#name_AmpedUp": "Amped Up"
	"#desc_AmpedUp": "Non-event hordes heal +20 Team HP (5s CD)"

	"#name_Addict": "Addict"
	"#desc_Addict": "+50% Temp Heal EFF, perks by Temp HP level"

	"#name_FleetOfFoot": "Fleet of Foot"
	"#desc_FleetOfFoot": "+12.5% Move Speed, -10 Max HP"

	"#name_CrossTrainers": "Cross Trainers"
	"#desc_CrossTrainers": "+7% Move Speed, +5 Max HP"

	"#name_Multitool": "Multitool"
	"#desc_Multitool": "+50% Team Use Speed, -5% DEF"

	"#name_RunLikeHell": "Run Like Hell"
	"#desc_RunLikeHell": "+30% Move Speed, -15% DEF, +75% Shove CD"

	"#name_Quickdraw": "Quickdraw"
	"#desc_Quickdraw": "+50% Swap Speed"

	"#name_Broken": "Boss Killer"
	"#desc_Broken": "+20% DMG vs Bosses"

	"#name_Pyromaniac": "Pyromaniac"
	"#desc_Pyromaniac": "+150% Fire DMG"

	"#name_BombSquad": "Bomb Squad"
	"#desc_BombSquad": "+100% Team Explosive DMG"

	"#name_ConfidentKiller": "Confident Killer"
	"#desc_ConfidentKiller": "+2.5% DMG per Mutation death"

	"#name_CannedGoods": "Canned Goods"
	"#desc_CannedGoods": "+40 Max HP, +25% Shove CD"

	"#name_SlowAndSteady": "Slow and Steady"
	"#desc_SlowAndSteady": "+50 Max HP, -10% Move Speed"

	"#name_ToughSkin": "Tough Skin"
	"#desc_ToughSkin": "+40% DEF vs Commons"

	"#name_ScarTissue": "Scar Tissue"
	"#desc_ScarTissue": "+30% DEF, -50% Heal EFF"

	"#name_ChemicalBarrier": "Chemical Barrier"
	"#desc_ChemicalBarrier": "+50% Acid DEF"

	"#name_FaceYourFears": "Face Your Fears"
	"#desc_FaceYourFears": "+2 Temp HP on kill within 2.5m"

	"#name_Numb": "Numb"
	"#desc_Numb": "Temp HP gives +10% DEF"

	"#name_MeanDrunk": "Mean Drunk"
	"#desc_MeanDrunk": "+20% Melee DMG, +20 Max HP"

	"#name_BattleLust": "Battle Lust"
	"#desc_BattleLust": "+1 HP on Melee kill"

	"#name_Brawler": "Brawler"
	"#desc_Brawler": "+50 Shove DMG"

	"#name_Berserker": "Berserker"
	"#desc_Berserker": "+25% Melee DMG, +5% Move Speed"

	"#name_HeavyHitter": "Heavy Hitter"
	"#desc_HeavyHitter": "Melee stumbles Mutations"

	"#name_Rampage": "Rampage"
	"#desc_Rampage": "Charge forwards, 100 Melee DMG, REPLACES: Shove (20s CD)"

	"#name_SwanSong": "Swan Song"
	"#desc_SwanSong": "+100% CRIT chance while incapped"

	"#name_LastLegs": "Last Legs"
	"#desc_LastLegs": "Team can crawl while incapped"

	"#name_StrengthInNumbers": "Strength In Numbers"
	"#desc_StrengthInNumbers": "+2.5% Team DMG per alive Cleaner"

	"#name_BOOM": "BOOM!"
	"#desc_BOOM": "Headshot kills cause an explosion"

	"#name_FireProof": "Fire Proof"
	"#desc_FireProof": "+50% Fire DEF"

	"#name_Kneecapper": "Kneecapper"
	"#desc_Kneecapper": "Mutations you Melee move 30% slower"

	"#name_Brazen": "Brazen"
	"#desc_Brazen": "+40% Melee DMG, -25% Reload Speed"

	"#name_MarkedForDeath": "Marked for Death"
	"#desc_MarkedForDeath": "+10% Team DMG vs Pinged Mutations"

	"#name_PackMule": "Pack Mule"
	"#desc_PackMule": "+40% Team Max Ammo"

	"#name_Resupply": "Resupply"
	"#desc_Resupply": "+10% Ammo on Mutation kill"

	"#name_Suppression": "Suppression"
	"#desc_Suppression": "+100% bullet stopping power"

	"#name_EyeOfTheSwarm": "Eye of the Swarm"
	"#desc_EyeOfTheSwarm": "+50% DMG in the Swarm Circle"

	"#name_EMTBag": "EMT Bag"
	"#desc_EMTBag": "+50% Heal EFF"

	"#name_AntibioticOintment": "Antibiotic Ointment"
	"#desc_AntibioticOintment": "+25% Heal EFF, +15 Temp HP to target"

	"#name_MedicalExpert": "Medical Expert"
	"#desc_MedicalExpert": "+30% Team Heal EFF, +10% Team Revive Speed"

	"#name_Cauterized": "Cauterized"
	"#desc_Cauterized": "+50% Slower Team Temp HP Decay"

	"#name_GroupTherapy": "Group Therapy"
	"#desc_GroupTherapy": "Team shares 20% of health item uses"

	"#name_InspiringSacrifice": "Inspiring Sacrifice"
	"#desc_InspiringSacrifice": "+25 Team Temp HP after incap"

	"#name_ReloadDrills": "Reload Drills"
	"#desc_ReloadDrills": "+25% Reload Speed"

	"#name_MagCoupler": "Mag Coupler"
	"#desc_MagCoupler": "+75% Reload Speed, +100% Shove CD"

	"#name_LuckyShot": "Lucky Shot"
	"#desc_LuckyShot": "+7% Team CRIT Chance (+400% DMG)"

	"#name_Selfless": "Selfless"
	"#desc_Selfless": "-15 Max HP, +20 Team Max HP"

	"#name_Selfish": "Selfish"
	"#desc_Selfish": "+40 Max HP, -5 Team Max HP"

	"#name_OutWithABang": "Out With A Bang"
	"#desc_OutWithABang": "Drop a Pipe Bomb on incap"

	"#name_HeightendSenses": "Heightend Senses"
	"#desc_HeightendSenses": "Ping Mutations, Hazards and Items in 7.5m"

	"#name_HotShot": "Hot Shot"
	"#desc_HotShot": "Apply Ammo Upgrade on Mutation kill"

	"#name_Pinata": "Piñata"
	"#desc_Pinata": "+15% chance of item on Mutation death"

	"#name_RefundPolicy": "Refund Policy"
	"#desc_RefundPolicy": "+25% chance to not consume items"

	"#name_Stockpile": "Stockpile"
	"#desc_Stockpile": "DESC"

	"#name_LifeInsurance": "Life Insurance"
	"#desc_LifeInsurance": "+1 Team Life"

	"#name_WellRested": "Well Rested"
	"#desc_WellRested": "Team fully heals each chapter"

	"#name_BuckshotBruiser": "Buckshot Bruiser"
	"#desc_BuckshotBruiser": "+0.25 Temp HP per Shotgun pellet"

	"#name_Arsonist": "Arsonist"
	"#desc_Arsonist": "+0.1 Temp HP per Fire DMG"

	"#name_NeedsOfTheMany": "Needs of the Many"
	"#desc_NeedsOfTheMany": "+1 Team Life, -10 Max HP"

	"#name_Lumberjack": "Lumberjack"
	"#desc_Lumberjack": "+200% Team Chainsaw DMG"

	"#name_Cannoneer": "Cannoneer"
	"#desc_Cannoneer": "+200% Team Grenade Launcher DMG"

	"#name_Gambler": "Gambler"
	"#desc_Gambler": "Randomized stats each map!"

	"#name_DownInFront": "Down In Front"
	"#desc_DownInFront": "No FF DMG when crouched"

	"#name_Shredder": "Shredder"
	"#desc_Shredder": "+1% DMG per shot fired until reload"

	"#name_CleanKill": "Clean Kill"
	"#desc_CleanKill": "Precision kills give +5% DMG, Resets when DMG taken"

	"#name_ExperiencedEMT": "Experienced EMT"
	"#desc_ExperiencedEMT": "Cleaners you heal gain +25 Max HP"

	"#name_WellFed": "Well Fed"
	"#desc_WellFed": "+10 Team Max HP"

	"#name_MedicalProfessional": "Medical Professional"
	"#desc_MedicalProfessional": "Medkits and Defibs heal +10 HP and 1 Extra Life"

	"#name_Screwdriver": "Screwdriver"
	"#desc_Screwdriver": "+25% Team Use Speed"

	"#name_SmellingSalts": "Smelling Salts"
	"#desc_SmellingSalts": "+150% Team Revive Speed, Reduces Revive HP"

	"#name_Overwatch": "Overwatch"
	"#desc_Overwatch": "Kills from 10m heal cleaners within 10m of target"

	"#name_HyperFocused": "Hyper Focused"
	"#desc_HyperFocused": "100% Weakspot DMG, Movement slower while shooting"

	"#name_TriggerHappy": "Trigger Happy"
	"#desc_TriggerHappy": "+15% Firerate"

	//CORRUPTION CARDS
	"#cor_commonAcid": "Acid Commons"
	"#cor_commonFire": "Fire Commons"
	"#cor_commonExplode": "Exploding Commons"

	"#cor_hazardBirds": "The Birds"
	"#cor_hazardLockdown": "The Lockdown"
	"#cor_hazardSleepers": "Slumber Party"

	"#cor_environmentDark": "The Dark"
	"#cor_environmentFog": "The Fog"
	"#cor_environmentBiohazard": "Biohazard"
	"#cor_environmentFrozen": "Frigid Outskirts"
	"#cor_environmentSwarmStream": "Swarm Stream"

	"#cor_hordeHunted": "Hunted"
	"#cor_hordeOnslaught": "Onslaught"
	"#cor_hordeTallboy": "Tallboy Hordes"
	"#cor_hordeCrusher": "Crusher Hordes"
	"#cor_hordeBruiser": "Bruiser Hordes"
	"#cor_hordeFer_Tallboy": "Tallboy Hordes"
	"#cor_hordeFer_Crusher": "Crusher Hordes"
	"#cor_hordeFer_Bruiser": "Bruiser Hordes"
	"#cor_hordeMon_Tallboy": "Tallboy Hordes"
	"#cor_hordeMon_Crusher": "Crusher Hordes"
	"#cor_hordeMon_Bruiser": "Bruiser Hordes"
	"#cor_hordeHocker": "Hocker Hordes"
	"#cor_hordeStinger": "Stinger Hordes"
	"#cor_hordeStalker": "Stalker Hordes"
	"#cor_hordeFer_Hocker": "Hocker Hordes"
	"#cor_hordeFer_Stinger": "Stinger Hordes"
	"#cor_hordeFer_Stalker": "Stalker Hordes"
	"#cor_hordeMon_Hocker": "Hocker Hordes"
	"#cor_hordeMon_Stinger": "Stinger Hordes"
	"#cor_hordeMon_Stalker": "Stalker Hordes"
	"#cor_hordeExploder": "Exploder Hordes"
	"#cor_hordeRetch": "Retch Hordes"
	"#cor_hordeReeker": "Reeker Hordes"
	"#cor_hordeFer_Exploder": "Exploder Hordes"
	"#cor_hordeFer_Retch": "Retch Hordes"
	"#cor_hordeFer_Reeker": "Reeker Hordes"
	"#cor_hordeMon_Exploder": "Exploder Hordes"
	"#cor_hordeMon_Retch": "Retch Hordes"
	"#cor_hordeMon_Reeker": "Reeker Hordes"

	"#cor_gameplayNoGrenades": "Empty Pockets"
	"#cor_gameplayNoOutlines": "No Outlines"
	"#cor_gameplayNoSupport": "Survival of the Fittest"
	"#cor_gameplayNoRespawn": "Do or Die"

	"#cor_playerLessAmmo": "Ammo Shortage"
	"#cor_playerFatigue": "Fatigue"

	"#cor_uncommonClown": "Clown Show"
	"#cor_uncommonRiot": "Crowd Control"
	"#cor_uncommonMud": "Mud Crawlers"
	"#cor_uncommonCeda": "CEDA Operatives"
	"#cor_uncommonConstruction": "Construction Site"
	"#cor_uncommonJimmy": "Jimmy Gibbs and Cousins"
	"#cor_uncommonFallen": "Fallen Cleaners"

	"#cor_commonShamble": "Shambling Commons"
	"#cor_commonRunning": "Running Commons"
	"#cor_commonBlitzing": "Blitzing Commons"

	"#cor_Tallboy": "Tallboys"
	"#cor_Fer_Tallboy": "Ferocious Tallboys"
	"#cor_Mon_Tallboy": "Monstrous Tallboys"

	"#cor_Crusher": "Crushers"
	"#cor_Fer_Crusher": "Ferocious Crushers"
	"#cor_Mon_Crusher": "Monstrous Crushers"

	"#cor_Bruiser": "Bruisers"
	"#cor_Fer_Bruiser": "Ferocious Bruisers"
	"#cor_Mon_Bruiser": "Monstrous Bruisers"

	"#cor_Hocker": "Hockers"
	"#cor_Fer_Hocker": "Ferocious Hockers"
	"#cor_Mon_Hocker": "Monstrous Hockers"

	"#cor_Stinger": "Stingers"
	"#cor_Fer_Stinger": "Ferocious Stingers"
	"#cor_Mon_Stinger": "Monstrous Stingers"

	"#cor_Stalker": "Stalkers"
	"#cor_Fer_Stalker": "Ferocious Stalkers"
	"#cor_Mon_Stalker": "Monstrous Stalkers"

	"#cor_Retch": "Retches"
	"#cor_Fer_Retch": "Ferocious Retches"
	"#cor_Mon_Retch": "Monstrous Retches"

	"#cor_Exploder": "Exploders"
	"#cor_Fer_Exploder": "Ferocious Exploders"
	"#cor_Mon_Exploder": "Monstrous Exploders"

	"#cor_Reeker": "Reekers"
	"#cor_Fer_Reeker": "Ferocious Reekers"
	"#cor_Mon_Reeker": "Monstrous Reekers"

	"#cor_hazardSnitch": "Tattlers"
	"#cor_bossBreaker": "Breaker"
	"#cor_bossBreakerFer": "Ferocious Breaker"
	"#cor_bossBreakerMon": "Monstrous Breaker"
	"#cor_bossOgre": "Ogre"
	"#cor_bossOgreFer": "Ferocious Ogre"
	"#cor_bossOgreMon": "Monstrous Ogre"

	"#cor_missionSpeedrun": "Speedrun"
	"#cor_missionAllAlive": "No One Left Behind"
	"#cor_missionGnomeAlone": "Gnome Alone"
	"#cor_missionSilenceIsGolden": "Silence Is Golden"
	"#cor_missionSafetyFirst": "Safety First"
}

RU_TranslationTable <- {
	//CHAT MESSAGES
 	"#lang_localization": "\x04" + "Русская локализация"
 	"#giveup_msg": "\x01" + "Удерживайте " + "\x03" + "[ПРИСЕДАНИЕ]" + "\x01" + " чтобы умереть..."
 	"#breakout_msg": "\x01" + "Удерживайте " + "\x03" + "[ОТТАЛКИВАНИЕ]" + "\x01" + " чтобы вырваться!"

	"#enablehardcore_msg": "\x04" + "Хардкорный режим включен"
	"#disablehardcore_msg": "\x04" + "Хардкорный режим отключен"

	"#autohudoff_msg": "\x04" + "Auto hide card HUD off"
	"#autohudon_msg": "\x04" + "Auto hide card HUD on"

	"#helpping_msg": "\x04" + "!пинг" + "\x01" + " - Пингует врагов и мир"
	"#helpcards_msg": "\x04" + "!карты" + "\x01" + " - Отображает HUD карты"
	"#helpshuffle_msg": "\x04" + "!перетасовать" + "\x01" + "- Перетасовывает текущие карты, которые игроки могут выбрать"
	"#helppick_msg": "\x04" + "!выбирать" + "\x01" + "- Выберите карту игрока [1-8]"
	"#helpbotpick_msg": "\x04" + "!ботпик" + "\x01" + " - Выбрать карту игрока для ботов [1-8]"
	"#helpdrop_msg": "\x04" + "!уронить" + "\x01" + "- Удалить текущий предмет в руке"
	"#helplives_msg": "!жизни" + "\x01" + " - Показывает количество жизней всех текущих игроков"

 	//BOT NAMES
	"#bot_Nick": "НИК"
	"#bot_Rochelle": "РОШЕЛЛЬ"
	"#bot_Coach": "ТРЕНЕР"
	"#bot_Ellis": "ЭЛЛИС"
	"#bot_Bill": "БИЛЛ"
	"#bot_Zoey": "ЗОИ"
	"#bot_Louis": "ЛУИС"
	"#bot_Francis": "ФРЕНСИС"

	//PLAYER CARDS
 	"#name_Nick": "Ник (+5% к УРН)"
 	"#desc_Nick": "+5% к УРН"

 	"#name_Rochelle": "Рошелль (+10% к Эффективности от Лечения)"
 	"#desc_Rochelle": "+10% к Эффективности от Лечения"

 	"#name_Coach": "Тренер (+10 к МАКС ХП)"
 	"#desc_Coach": "+10 к МАКС ХП"

 	"#name_Ellis": "Эллис (+5% шанс на КРИТ)"
 	"#desc_Ellis": "+5% шанс на КРИТ"

 	"#name_Bill": "Билл (+10% к Скорости перезарядки)"
 	"#desc_Bill": "+10% к Скорости перезарядки"

 	"#name_Zoey": "Зои (+10% УРН к Рукопашному бою)"
 	"#desc_Zoey": "+10% УРН к Рукопашному бою"

 	"#name_Louis": "Луис (+10% к Скорости Передвижения)"
 	"#desc_Louis": "+10% к Скорости Передвижения"

 	"#name_Francis": "Френсис (+10% ЗЩТ)"
 	"#desc_Francis": "+10% ЗЩТ"

 	"#name_GlassCannon": "Стеклянная Пушка"
 	"#desc_GlassCannon": "+30% УРН, -20% ЗЩТ"

 	"#name_Sharpshooter": "Меткий стрелок"
 	"#desc_Sharpshooter": "+25% к УРН после 10м"

 	"#name_Outlaw": "Ковбой вне закона"
 	"#desc_Outlaw": "+100% к УРН Пистолетами / Магнумом"

 	"#name_Overconfident": "Излишне Самоуверенный"
 	"#desc_Overconfident": "+25% к ЗЩТ в состоянии всех жизней (без инкапов)"

 	"#name_Slugger": "Слаггер"
 	"#desc_Slugger": "+30% к Скорости рукопашного оружия"

 	"#name_MethHead": "Метамфетаминоголовый"
 	"#desc_MethHead": "+2.5% к Скорости Передвижения/Рукопашного оружия за каждое убийство мутанта"

 	"#name_OpticsEnthusiast": "Энтузиаст в оптике"
 	"#desc_OpticsEnthusiast": "Получить лазерный прицел (+60% Точности)"

 	"#name_Breakout": "Вырваться"
 	"#desc_Breakout": "Удерживайте [ОТТАЛКИВАНИЕ], чтобы освободиться, +1 к попыткам"

 	"#name_AdrenalineRush": "Выброс Адреналина"
 	"#desc_AdrenalineRush": "Адреналин для всей Комманды после инкапа"

 	"#name_HelpingHand": "Рука Помощи"
 	"#desc_HelpingHand": "+50% к Скорости поднятия для всей Команды"

 	"#name_CombatMedic": "Полевой Медик"
 	"#desc_CombatMedic": "+15 ХП на каждый ривайв, +15% к Командной скорости ривайвов"

 	"#name_AmpedUp": "Подзарядка"
 	"#desc_AmpedUp": "Спавн орды не на евенте лечит +20 ХП Команде (5c откат)"

 	"#name_Addict": "Накроман"
 	"#desc_Addict": "+50% к ЭФФ Лечения Быстрым Здоровьем, кратно уровню ХП Команды"

 	"#name_FleetOfFoot": "Ноги скороходы"
 	"#desc_FleetOfFoot": "+12.5% Скорости Передвижения, -10 МАКС ХП"

 	"#name_CrossTrainers": "Кроссовки"
 	"#desc_CrossTrainers": "+7% Скорости Передвижения, +5 МАКС ХП"

 	"#name_Multitool": "Мультитул"
 	"#desc_Multitool": "+50% к командной скорости использования, -5% ЗЩТ"

 	"#name_RunLikeHell": "Бежать со всех сил"
 	"#desc_RunLikeHell": "+30% Скорости Передвижения, -15% ЗЩТ, +75% к откату Отталкивания"

 	"#name_Quickdraw": "Quickdraw"
 	"#desc_Quickdraw": "+50% Swap Speed"

 	"#name_Broken": "Убийца Боссов"
 	"#desc_Broken": "+20% УРН на Боссов"

 	"#name_Pyromaniac": "Пироман"
 	"#desc_Pyromaniac": "+150% УРН Огнём"

 	"#name_BombSquad": "Отряд Подрывников"
 	"#desc_BombSquad": "+100% к УРН Взрывами Команды"

 	"#name_ConfidentKiller": "Уверенный Убийца"
 	"#desc_ConfidentKiller": "+2.5% УРН за каждого убитого Мутанта"

 	"#name_CannedGoods": "Банка здоровья"
 	"#desc_CannedGoods": "+40 МАКС ХП, +25% откат Отталкивания"

 	"#name_SlowAndSteady": "Медленно, но уверенно"
 	"#desc_SlowAndSteady": "+50 МАКС ХП, -10% к Скорости Передвижения"

 	"#name_ToughSkin": "Толстокожий"
 	"#desc_ToughSkin": "+40% ЗЩТ от обычных зараженных"

 	"#name_ScarTissue": "Рубцовая Кожа"
 	"#desc_ScarTissue": "+30% ЗЩТ, -50% к Эффективности от Лечения"

 	"#name_ChemicalBarrier": "Поверхностный барьер"
 	"#desc_ChemicalBarrier": "+50% ЗЩТ от Кислоты"

 	"#name_FaceYourFears": "Лицом к Страху"
 	"#desc_FaceYourFears": "+2 временного ХП на убийства в пределе 2.5м"

 	"#name_Numb": "Numb"
 	"#desc_Numb": "Temp HP gives +10% DEF"

 	"#name_MeanDrunk": "Злой Пьяница"
 	"#desc_MeanDrunk": "+20% Рукопашного УРН, +20 МАКС ХП"

 	"#name_BattleLust": "Battle Lust"
 	"#desc_BattleLust": "+1 HP on Melee kill"

 	"#name_Brawler": "Дебошир"
 	"#desc_Brawler": "+50 УРН Отталкиванием"

 	"#name_Berserker": "Берсерк"
 	"#desc_Berserker": "+25% УРН Рукопашным боем, +5% Скорости Передвижения"

 	"#name_HeavyHitter": "Heavy Hitter"
 	"#desc_HeavyHitter": "Melee stumbles Mutations"

 	"#name_Rampage": "Rampage"
 	"#desc_Rampage": "Charge forwards, 100 Melee DMG, REPLACES: Shove (20s CD)"

 	"#name_SwanSong": "Лебединая Песня"
 	"#desc_SwanSong": "+100% к шансу на КРИТ когда в инкапе"

 	"#name_LastLegs": "Ползунком"
 	"#desc_LastLegs": "Команда может ползти когда в инкапе"

 	"#name_StrengthInNumbers": "Сила в количестве"
 	"#desc_StrengthInNumbers": "+2.5% к УРН Команды за каждого живого Чистильщика"

 	"#name_BOOM": "БУМ!"
 	"#desc_BOOM": "Убийство в голову приводит к взрыву"

 	"#name_FireProof": "Защита от огня"
 	"#desc_FireProof": "+50% ЗЩТ от огня"

 	"#name_Kneecapper": "Kneecapper"
 	"#desc_Kneecapper": "Mutations you Melee move 30% slower"

 	"#name_Brazen": "Наглость"
 	"#desc_Brazen": "+40% УРН Рукопашным боем, -25% Скорости перезарядки"

 	"#name_MarkedForDeath": "Смертельно помечен"
 	"#desc_MarkedForDeath": "+10% к УРН Команды на Помеченных Мутантов"

 	"#name_PackMule": "Загруженный мул"
 	"#desc_PackMule": "+40% к МАКС патронам Команды"

 	"#name_Resupply": "Подзапаска"
 	"#desc_Resupply": "+10% Патронов на убийство Мутанта"

 	"#name_Suppression": "Suppression"
 	"#desc_Suppression": "+100% bullet stopping power"

 	"#name_EyeOfTheSwarm": "Под Куполом Сворма"
 	"#desc_EyeOfTheSwarm": "+50% к УРН внутри пределов купола Сворма"

 	"#name_EMTBag": "Аптечка Первой Помощи"
 	"#desc_EMTBag": "+50% к Эффективности лечения"

 	"#name_AntibioticOintment": "Антибактериальная Смазка"
 	"#desc_AntibioticOintment": "+25% к Эффективности лечения, +15 временного ХП на цель"

 	"#name_MedicalExpert": "Экспертный Медик"
 	"#desc_MedicalExpert": "+30% к Эффективности лечения Команды, +10% к Скорости ривайва Команды"

 	"#name_Cauterized": "Прижигание"
 	"#desc_Cauterized": "+50% к замедлению убывания временного ХП Команды"

 	"#name_GroupTherapy": "Групповая Терапия"
 	"#desc_GroupTherapy": "Команда делит 20% здоровья после использования предметов лечения"

 	"#name_InspiringSacrifice": "Вдохновляющая Жертва"
 	"#desc_InspiringSacrifice": "+25 к временному ХП Команды после инкапа"

 	"#name_ReloadDrills": "Навыки Перезярядки"
 	"#desc_ReloadDrills": "+25% к Скорости Перезарядки"

 	"#name_MagCoupler": "Модифицированный Магазин"
 	"#desc_MagCoupler": "+75% к Скорости Перезарядки, +100% к откату Отталкивания"

 	"#name_LuckyShot": "Удачный выстрел"
 	"#desc_LuckyShot": "+7% шанс на КРИТ у всей Команды (+400% УРН)"

 	"#name_Selfless": "Самопожертвование"
 	"#desc_Selfless": "-15 МАКС ХП, +20 МАКС ХП Команды"

 	"#name_Selfish": "Самолюбие"
 	"#desc_Selfish": "+40 МАКС ХП, -5 МАКС ХП Команды"

 	"#name_OutWithABang": "OutWithABang"
 	"#desc_OutWithABang": "Drop a Pipe Bomb on incap"

 	"#name_HeightendSenses": "Обострённые чувства"
 	"#desc_HeightendSenses": "Пометить Мутантов, Ловушки и Предметы в пределе 7.5м"

 	"#name_HotShot": "Отличный стрелок"
 	"#desc_HotShot": "Апргейд патронов за убийство Мутанта"

 	"#name_Pinata": "Пиньята"
 	"#desc_Pinata": "+15% шанс получить предмет после убийства Мутанта"

 	"#name_RefundPolicy": "Refund Policy"
 	"#desc_RefundPolicy": "+25% chance to not consume items"

 	"#name_Stockpile": "Stockpile"
 	"#desc_Stockpile": "DESC"

 	"#name_LifeInsurance": "Life Insurance"
 	"#desc_LifeInsurance": "+1 Team Life"

 	"#name_WellRested": "Хорошо отдохнувший"
 	"#desc_WellRested": "Команда полностью вылечена после каждой главы"

 	"#name_BuckshotBruiser": "Картечь"
 	"#desc_BuckshotBruiser": "+0.25 к временному ХП за каджую дробинку Дробовика"

 	"#name_Arsonist": "Поджигатель"
 	"#desc_Arsonist": "+0.1 временного ХП на каждый УРН Огнём"

 	"#name_NeedsOfTheMany": "Потребности многих"
 	"#desc_NeedsOfTheMany": "+1 к жизням Команды, -10 МАКС ХП"

 	"#name_Lumberjack": "Лесоруб"
 	"#desc_Lumberjack": "+200% к УРН бензопилой Команды"

 	"#name_Cannoneer": "Пушечник"
 	"#desc_Cannoneer": "+200% к УРН гранатомётом Команды"

 	"#name_Gambler": "Азартный Игрок"
 	"#desc_Gambler": "Рандомные статы каждую карту!"

 	"#name_DownInFront": "Отойти с пути"
 	"#desc_DownInFront": "Не наносить УРН своим когда приседаешь"

 	"#name_Shredder": "Шреддер"
 	"#desc_Shredder": "+1% УРН за выстрел вплоть до перезарядки"

 	"#name_CleanKill": "Чистое Убийство"
 	"#desc_CleanKill": "Точное добивание в голову даёт +5% к УРН, Обнуляется когда УРН был получен"

 	"#name_ExperiencedEMT": "Опытный Медэксперт"
 	"#desc_ExperiencedEMT": "Чистильщиков которых вы лечите получают +25 к МАКС ХП"

 	"#name_WellFed": "Хорошо накормлен"
 	"#desc_WellFed": "+10 к МАКС ХП Команды"

 	"#name_MedicalProfessional": "Медик Профессионал"
 	"#desc_MedicalProfessional": "Аптечки и Дефибприляторы дают +10 ХП и 1 Жизнь"

 	"#name_Screwdriver": "Отвёртка"
 	"#desc_Screwdriver": "+25% к Скорости Использования Команды"

 	"#name_SmellingSalts": "Нюхательная соль"
 	"#desc_SmellingSalts": "+150% к скорости ривайва Команды, Уменьшает кол-во ХП у поднятого"

 	"#name_Овервотч": "Овервотч"
 	"#desc_Овервотч": "Убийства с 10 м лечат уборщиков в радиусе 10 м от цели"

 	"#name_HyperFocused": "Гиперфокусированный"
 	"#desc_HyperFocused": "100% урон по слабым местам, замедление движения при стрельбе"

	"#name_TriggerHappy": "Триггер Счастливый"
	"#desc_TriggerHappy": "+15% Скорострельность"

	//CORRUPTION CARDS
 	"#cor_commonAcid": "Кислотные заражённые"
 	"#cor_commonFire": "Огненные заражённые"
 	"#cor_commonExplode": "Взрывающиеся заражённые"

 	"#cor_hazardBirds": "Вороны"
 	"#cor_hazardLockdown": "Двери с сигнализацией"
 	"#cor_hazardSleepers": "Слиперы"

 	"#cor_environmentDark": "Темнота"
 	"#cor_environmentFog": "Туман"
 	"#cor_environmentBiohazard": "Biohazard"
 	"#cor_environmentFrozen": "Холодные окраины"
 	"#cor_environmentSwarmStream": "Светящийся ручей"

 	"#cor_hordeHunted": "На Охоте"
 	"#cor_hordeOnslaught": "Натиск"
 	"#cor_hordeTallboy": "Орда Толлбоев"
 	"#cor_hordeCrusher": "Орда Крашеров"
 	"#cor_hordeBruiser": "Орда Брузеров"
 	"#cor_hordeFer_Tallboy": "Орда Толлбоев"
 	"#cor_hordeFer_Crusher": "Орда Крашеров"
 	"#cor_hordeFer_Bruiser": "Орда Брузеров"
 	"#cor_hordeFer_Tallboy": "Орда Толлбоев"
 	"#cor_hordeFer_Crusher": "Орда Крашеров"
 	"#cor_hordeFer_Bruiser": "Орда Брузеров"
 	"#cor_hordeHocker": "Орда Хокеров"
 	"#cor_hordeStinger": "Орда Стингеров"
 	"#cor_hordeStalker": "Орда Сталкеров"
 	"#cor_hordeFer_Hocker": "Орда Хокеров"
 	"#cor_hordeFer_Stinger": "Орда Стингеров"
 	"#cor_hordeFer_Stalker": "Орда Сталкеров"
 	"#cor_hordeMon_Hocker": "Орда Хокеров"
 	"#cor_hordeMon_Stinger": "Орда Стингеров"
 	"#cor_hordeMon_Stalker": "Орда Сталкеров"
 	"#cor_hordeExploder": "Орда Эксплодеров"
 	"#cor_hordeRetch": "Орда Ретчей"
 	"#cor_hordeReeker": "Орда Рикеров"
	"#cor_hordeFer_Exploder": "Орда Эксплодеров"
	"#cor_hordeFer_Retch": "Орда Ретчей"
	"#cor_hordeFer_Reeker": "Орда Рикеров"
 	"#cor_hordeFer_Exploder": "Орда Эксплодеров"
 	"#cor_hordeFer_Retch": "Орда Ретчей"
 	"#cor_hordeFer_Reeker": "Орда Рикеров"
 	"#cor_hordeMon_Exploder": "Орда Эксплодеров"
 	"#cor_hordeMon_Retch": "Орда Ретчей"
 	"#cor_hordeMon_Reeker": "Орда Рикеров"

 	"#cor_gameplayNoGrenades": "Опустевшие карманы"
 	"#cor_gameplayNoOutlines": "Без контуров"
 	"#cor_gameplayNoSupport": "Выживает наиболее приспособленный"
 	"#cor_gameplayNoRespawn": "Сделай или сдохни"

 	"#cor_playerLessAmmo": "Нехватка боеприпасов"
 	"#cor_playerFatigue": "Усталость"

 	"#cor_uncommonClown": "Шоу Клоунов"
 	"#cor_uncommonRiot": "Подавление толпы"
 	"#cor_uncommonMud": "Грязевики"
 	"#cor_uncommonCeda": "Сотрудники CEDA"
 	"#cor_uncommonConstruction": "Стройка"
 	"#cor_uncommonJimmy": "Джимми Гиббс и его двоюродные братья"
 	"#cor_uncommonFallen": "Павшие чистильщики"

 	"#cor_commonShamble": "Медленные заражённые"
 	"#cor_commonRunning": "Обычные заражённые"
 	"#cor_commonBlitzing": "Быстрые заражённые"

 	"#cor_Tallboy": "Толлбои"
 	"#cor_Fer_Tallboy": "Свирепые Толлбои"
 	"#cor_Mon_Tallboy": "Монструозные Толлбои"

 	"#cor_Crusher": "Крашеры"
 	"#cor_Fer_Crusher": "Свирепые Крашеры"
 	"#cor_Mon_Crusher": "Монструозные Крашеры"

 	"#cor_Bruiser": "Брузеры"
 	"#cor_Fer_Bruiser": "Свирепые Брузеры"
 	"#cor_Mon_Bruiser": "Монструозные Брузеры"

 	"#cor_Hocker": "Хокеры"
 	"#cor_Fer_Hocker": "Свирепые Хокеры"
 	"#cor_Mon_Hocker": "Монструозные Хокеры"

 	"#cor_Stinger": "Стингеры"
 	"#cor_Fer_Stinger": "Свирепые Стингеры"
 	"#cor_Mon_Stinger": "Монструозные Стингеры"

 	"#cor_Stalker": "Сталкеры"
 	"#cor_Fer_Stalker": "Свирепые Сталкеры"
 	"#cor_Mon_Stalker": "Монструозные Сталкеры"

 	"#cor_Retch": "Ретчи"
 	"#cor_Fer_Retch": "Свирепые Ретчи"
 	"#cor_Mon_Retch": "Монструозные Ретчи"

 	"#cor_Exploder": "Эксплодеры"
 	"#cor_Fer_Exploder": "Свирепые Эксплодеры"
 	"#cor_Mon_Exploder": "Монструозные Эксплодеры"

 	"#cor_Reeker": "Рикеры"
 	"#cor_Fer_Reeker": "Свирепые Рикеры"
 	"#cor_Mon_Reeker": "Монструозные Рикеры"

 	"#cor_hazardSnitch": "Стукачи"
 	"#cor_bossBreaker": "Брейкер"
	"#cor_bossBreakerFer": "свирепый Брейкер"
 	"#cor_bossBreakerMon": "Разгневанный Брейкер"
 	"#cor_bossOgre": "Огр"
	"#cor_bossOgreFer": "свирепый Огр"
 	"#cor_bossOgreMon": "Разгневанный Огр"

 	"#cor_missionSpeedrun": "Спидран"
 	"#cor_missionAllAlive": "Своих не оставляем"
 	"#cor_missionGnomeAlone": "Один Гнома"
 	"#cor_missionSilenceIsGolden": "Silence Is Golden"
 	"#cor_missionSafetyFirst": "Safety First"
}

ES_TranslationTable <- {
	//CHAT MESSAGES
 	"#lang_localization": "\x04" + "localización española"
	"#giveup_msg": "\x01" + "Mantener presionado " + "\x03" + "[AGACHARSE]" + "\x01" + " para morir..."
	"#breakout_msg": "\x01" + "Mantén presionado " + "\x03" + "[EMPUJAR]" + "\x01" + " para escapar!"

	"#enablehardcore_msg": "\x04" + "Modo intenso habilitado"
	"#disablehardcore_msg": "\x04" + "Modo extremo deshabilitado"

	"#autohudoff_msg": "\x04" + "Auto hide card HUD off"
	"#autohudon_msg": "\x04" + "Auto hide card HUD on"

	"#helpping_msg": "\x04" + "!ping" + "\x01" + " - Pings enemies and world"
	"#helpcards_msg": "\x04" + "!cards" + "\x01" + " - Displays card HUD"
	"#helpshuffle_msg": "\x04" + "!shuffle" + "\x01" + " - Shuffles current cards players can pick"
	"#helppick_msg": "\x04" + "!pick" + "\x01" + " - Pick a player card [1-8]"
	"#helpbotpick_msg": "\x04" + "!botpick" + "\x01" + " - Pick a player card for bots [1-8]"
	"#helpdrop_msg": "\x04" + "!drop" + "\x01" + " - Drop current in hand item"
	"#helplives_msg": "!lives" + "\x01" + " - Shows all current players number of lives"

	//BOT NAMES
	"#bot_Nick": "NICK"
	"#bot_Rochelle": "ROCHELLE"
	"#bot_Coach": "COACH"
	"#bot_Ellis": "ELLIS"
	"#bot_Bill": "BILL"
	"#bot_Zoey": "ZOEY"
	"#bot_Louis": "LOUIS"
	"#bot_Francis": "FRANCIS"

	//PLAYER CARDS
	"#name_Nick": "Nick (+5% DAÑO)"
	"#desc_Nick": "+5% DAÑO"

	"#name_Rochelle": "Rochelle (+10% de curación EFF)"
	"#desc_Rochelle": "+10% de curación EFF"

	"#name_Coach": "Coach (+10 HP máximo)"
	"#desc_Coach": "+10 HP máximos"

	"#name_Ellis": "Ellis (+5% de probabilidad de CRIT)"
	"#desc_Ellis": "+5% de probabilidad de CRIT"

	"#name_Bill": "Bill (+10% de velocidad de recarga)"
	"#desc_Bill": "+10% de velocidad de recarga"

	"#name_Zoey": "Zoey (+10% de daño cuerpo a cuerpo)"
	"#desc_Zoey": "+10 % de daño cuerpo a cuerpo"

	"#name_Louis": "Louis (+10 % de velocidad de movimiento)"
	"#desc_Louis": "+10 % de velocidad de movimiento"

	"#name_Francis": "Francis (+10% DEF)"
	"#desc_Francis": "+10% DEF"

	"#name_GlassCannon": "Cañón de vidrio"
	"#desc_GlassCannon": "+30% DAÑO, -20% DEF"

	"#name_Sharpshooter": "Tirador de primera"
	"#desc_Sharpshooter": "+25 % de daño después de 10 m"

	"#name_Outlaw": "Proscrito"
	"#desc_Outlaw": "+100 % de daño de pistola/mágnum"

	"#name_Overconfident": "Demasiado seguro"
	"#desc_Overconfident": "+25% DEF en vidas máximas"

	"#name_Slugger": "Bateador"
	"#desc_Slugger": "+30 % de velocidad cuerpo a cuerpo"

	"#name_MethHead": "Cabeza de metanfetamina"
	"#desc_MethHead": "+2,5% de velocidad de movimiento/cuerpo a cuerpo por muerte por mutación"

	"#name_OpticsEnthusiast": "Apasionado de la óptica"
	"#desc_OpticsEnthusiast": "Obtén miras láser (+60% ACC)"

	"#name_Breakout": "Fugarse"
	"#desc_Breakout": "Mantén presionado [EMPUJAR] para escapar de los agarres, +1 intentos de fuga"

	"#name_AdrenalineRush": "Subidón de adrenalina"
	"#desc_AdrenalineRush": "Adrenalina en el equipo incap"

	"#name_HelpingHand": "Mano amiga"
	"#desc_HelpingHand": "+50 % de velocidad de reanimación del equipo"

	"#name_CombatMedic": "Medico de combate"
	"#desc_CombatMedic": "+15 HP en todas las reanimaciones, +15 % de velocidad de reanimación del equipo"

	"#name_AmpedUp": "Amplificado"
	"#desc_AmpedUp": "Las hordas sin eventos curan +20 HP del equipo (5s CD)"

	"#name_Addict": "Adicto"
	"#desc_Addict": "+50 % de efecto de curación temporal, ventajas según el nivel de HP temporal"

	"#name_FleetOfFoot": "Flota de a pie"
	"#desc_FleetOfFoot": "+12,5% de velocidad de movimiento, -10 HP máximo"

	"#name_CrossTrainers": "Elípticas"
	"#desc_CrossTrainers": "+7 % de velocidad de movimiento, +5 HP máximo"

	"#name_Multitool": "Herramienta multiple"
	"#desc_Multitool": "+50 % de velocidad de uso del equipo, -5 % DEF"

	"#name_RunLikeHell": "Correr rapidamente"
	"#desc_RunLikeHell": "+30% velocidad de movimiento, -15% DEF, +75% CD de empuje"

	"#name_Quickdraw": "Dibujo rapido"
	"#desc_Quickdraw": "+50 % de velocidad de intercambio"

	"#name_Broken": "Jefe asesino"
	"#desc_Broken": "+20 % de daño contra jefes"

	"#name_Pyromaniac": "Incendiario"
	"#desc_Pyromaniac": "+150 % de daño de fuego"

	"#name_BombSquad": "Escuadrón bomba"
	"#desc_BombSquad": "+100 % de daño explosivo del equipo"

	"#name_ConfidentKiller": "Asesino confiado"
	"#desc_ConfidentKiller": "+2,5 % de daño por muerte por mutación"

	"#name_CannedGoods": "Productos enlatados"
	"#desc_CannedGoods": "+40 HP máximo, +25% CD de empuje"

	"#name_SlowAndSteady": "Lento pero seguro"
	"#desc_SlowAndSteady": "+50 HP máximo, -10 % de velocidad de movimiento"

	"#name_ToughSkin": "Piel dura"
	"#desc_ToughSkin": "+40% DEF frente a los comunes"

	"#name_ScarTissue": "Cicatriz"
	"#desc_ScarTissue": "+30% DEF, -50% Curación EFF"

	"#name_ChemicalBarrier": "Barrera química"
	"#desc_ChemicalBarrier": "+50 % DEF ácido"

	"#name_FaceYourFears": "Enfrenta tus miedos"
	"#desc_FaceYourFears": "+2 HP temporal al matar dentro de 2,5 m"

	"#name_Numb": "Adormecer"
	"#desc_Numb": "Temp HP da +10% DEF"

	"#name_MeanDrunk": "Mal borracho"
	"#desc_MeanDrunk": "+20 % de daño cuerpo a cuerpo, +20 HP máximo"

	"#name_BattleLust": "Lujuria de batalla"
	"#desc_BattleLust": "+1 HP al matar cuerpo a cuerpo"

	"#name_Brawler": "Alborotador"
	"#desc_Brawler": "+50 Daño de empujón"

	"#name_Berserker": "Frenético"
	"#desc_Berserker": "+25 % de daño cuerpo a cuerpo, +5 % de velocidad de movimiento"

	"#name_HeavyHitter": "Peso pesado"
	"#desc_HeavyHitter": "El cuerpo a cuerpo tropieza con las mutaciones"

	"#name_Rampage": "Alboroto"
	"#desc_Rampage": "Cargar hacia adelante, 100 DAÑO cuerpo a cuerpo, REEMPLAZA: Empujón (CD de los años 20)"

	"#name_SwanSong": "Canción del cisne"
	"#desc_SwanSong": "+100 % de probabilidad de CRIT mientras estás bajo el límite"

	"#name_LastLegs": "Últimas piernas"
	"#desc_LastLegs": "El equipo puede gatear mientras está incapacitado"

	"#name_StrengthInNumbers": "Fuerza en números"
	"#desc_StrengthInNumbers": "+2,5 % de daño de equipo por limpiador vivo"

	"#name_BOOM": "¡AUGE!"
	"#desc_BOOM": "Los disparos en la cabeza provocan una explosión"

	"#name_FireProof": "A prueba de fuego"
	"#desc_FireProof": "+50 % DEF de fuego"

	"#name_Kneecapper": "Rodilla"
	"#desc_Kneecapper": "Las mutaciones cuerpo a cuerpo se mueven un 30% más lento"

	"#name_Brazen": "Descarado"
	"#desc_Brazen": "+40 % de daño cuerpo a cuerpo, -25 % de velocidad de recarga"

	"#name_MarkedForDeath": "Marcado para morir"
	"#desc_MarkedForDeath": "+10 % de daño de equipo frente a mutaciones detectadas"

	"#name_PackMule": "Mula de carga"
	"#desc_PackMule": "+40 % de munición máxima del equipo"

	"#name_Resupply": "Reabastecimiento"
	"#desc_Resupply": "+10% de munición al matar por mutación"

	"#name_Suppression": "Supresión"
	"#desc_Suppression": "+100 % de poder de detención de balas"

	"#name_EyeOfTheSwarm": "Ojo del enjambre"
	"#desc_EyeOfTheSwarm": "+50 % de daño en el círculo del enjambre"

	"#name_EMTBag": "Bolsa de EMT"
	"#desc_EMTBag": "+50 % de curación EFF"

	"#name_AntibioticOintment": "Ungüento antibiótico"
	"#desc_AntibioticOintment": "+25 % de curación EFF, +15 HP temporal para el objetivo"

	"#name_MedicalExpert": "Experto médico"
	"#desc_MedicalExpert": "+30 % de EFF de curación del equipo, +10 % de velocidad de reanimación del equipo"

	"#name_Cauterized": "Cauterizado"
	"#desc_Cauterized": "Decaimiento de HP temporal del equipo +50 % más lento"

	"#name_GroupTherapy": "Terapia de grupo"
	"#desc_GroupTherapy": "El equipo comparte el 20% de los usos de los artículos de salud"

	"#name_InspiringSacrifice": "Sacrificio inspirador"
	"#desc_InspiringSacrifice": "+25 HP temporal del equipo después de la incap"

	"#name_ReloadDrills": "Taladros de recarga"
	"#desc_ReloadDrills": "+25% de velocidad de recarga"

	"#name_MagCoupler": "Acoplador magnético"
	"#desc_MagCoupler": "+75 % de velocidad de recarga, +100 % de empuje del CD"

	"#name_LuckyShot": "Tiro de suerte"
	"#desc_LuckyShot": "+7 % de probabilidad de CRIT del equipo (+400 % de daño)"

	"#name_Selfless": "Abnegado"
	"#desc_Selfless": "-15 HP máximo, +20 HP máximo del equipo"

	"#name_Selfish": "Egoísta"
	"#desc_Selfish": "+40 HP máximo, -5 HP máximo del equipo"

	"#name_OutWithABang": "Fuera con una explosión"
	"#desc_OutWithABang": "Lanza una bomba casera sobre incap"

	"#name_HeightendSenses": "Sentidos elevados"
	"#desc_HeightendSenses": "Ping mutaciones, peligros y elementos en 7,5 m"

	"#name_HotShot": "Tiro caliente"
	"#desc_HotShot": "Aplicar mejora de munición al matar por mutación"

	"#name_Pinata": "Piñata"
	"#desc_Pinata": "+15% de probabilidad de obtener un objeto al morir por mutación"

	"#name_RefundPolicy": "Politica de reembolso"
	"#desc_RefundPolicy": "+25% de probabilidad de no consumir artículos"

	"#name_Stockpile": "Reservas"
	"#desc_Stockpile": "DESC"

	"#name_LifeInsurance": "Seguro de vida"
	"#desc_LifeInsurance": "+1 vida de equipo"

	"#name_WellRested": "Bien descansado"
	"#desc_WellRested": "El equipo cura completamente cada capítulo"

	"#name_BuckshotBruiser": "Matón de perdigones"
	"#desc_BuckshotBruiser": "+0,25 HP temporal por perdigón de escopeta"

	"#name_Arsonist": "Incendiario"
	"#desc_Arsonist": "+0,1 HP temporal por daño de fuego"

	"#name_NeedsOfTheMany": "Necesidades de muchos"
	"#desc_NeedsOfTheMany": "+1 vida de equipo, -10 HP máximo"

	"#name_Lumberjack": "Leñador"
	"#desc_Lumberjack": "+200 % de daño del equipo Motosierra"

	"#name_Cannoneer": "Servidor del cañón"
	"#desc_Cannoneer": "+200 % de daño del lanzagranadas del equipo"

	"#name_Gambler": "Jugador"
	"#desc_Gambler": "¡Estadísticas aleatorias en cada mapa!"

	"#name_DownInFront": "Abajo al frente"
	"#desc_DownInFront": "No hay FF DMG cuando estás agachado"

	"#name_Shredder": "Desfibradora"
	"#desc_Shredder": "+1% de daño por disparo realizado hasta recargar"

	"#name_CleanKill": "Muerte limpia"
	"#desc_CleanKill": "Las muertes de precisión dan +5% de daño, se reinicia cuando se recibe daño"

	"#name_ExperiencedEMT": "EMT experimentado"
	"#desc_ExperiencedEMT": "Los limpiadores que curas obtienen +25 HP máximo"

	"#name_WellFed": "Bien alimentado"
	"#desc_WellFed": "+10 HP máximo del equipo"

	"#name_MedicalProfessional": "Profesional médico"
	"#desc_MedicalProfessional": "Los botiquines y desfibriladores curan +10 HP y 1 vida extra"

	"#name_Screwdriver": "Destornillador"
	"#desc_Screwdriver": "+25 % de velocidad de uso en equipo"

	"#name_SmellingSalts": "Sales aromáticas"
	"#desc_SmellingSalts": "+150% de velocidad de reanimación del equipo, reduce HP de reanimación"

	"#name_Overwatch": "Supervisión"
	"#desc_Overwatch": "Las muertes desde 10 m curan a los limpiadores dentro de 10 m del objetivo"

	"#name_HyperFocused": "Hiperconcentrado"
	"#desc_HyperFocused": "100% Daño en el punto débil, movimiento más lento al disparar"

	"#name_TriggerHappy": "Gatillo fácil"
	"#desc_TriggerHappy": "+15 % de velocidad de disparo"

	//CORRUPTION CARDS
	"#cor_commonAcid": "Bienes comunes ácidos"
	"#cor_commonFire": "Fuego común"
	"#cor_commonExplode": "Explosión de los bienes comunes"

	"#cor_hazardBirds": "Las aves"
	"#cor_hazardLockdown": "El cierre de emergencia"
	"#cor_hazardSleepers": "Pijamada"

	"#cor_environmentDark": "La oscuridad"
	"#cor_environmentFog": "La niebla"
	"#cor_environmentBiohazard": "Peligro biológico"
	"#cor_environmentFrozen": "Afueras heladas"
	"#cor_environmentSwarmStream": "Corriente de enjambre"

	"#cor_hordeHunted": "Cazado"
	"#cor_hordeOnslaught": "Embate"
	"#cor_hordeTallboy": "Hordas de tallboys"
	"#cor_hordeCrusher": "Hordas trituradoras"
	"#cor_hordeBruiser": "Hordas de matones"
	"#cor_hordeFer_Tallboy": "Hordas de tallboys"
	"#cor_hordeFer_Crusher": "Hordas trituradoras"
	"#cor_hordeFer_Bruiser": "Hordas de matones"
	"#cor_hordeMon_Tallboy": "Hordas de tallboys"
	"#cor_hordeMon_Crusher": "Hordas trituradoras"
	"#cor_hordeMon_Bruiser": "Hordas de matones"
	"#cor_hordeHocker": "Hordas de Hocker"
	"#cor_hordeStinger": "Hordas de aguijones"
	"#cor_hordeStalker": "Hordas de acosadores"
	"#cor_hordeFer_Hocker": "Hordas de Hocker"
	"#cor_hordeFer_Stinger": "Hordas de aguijones"
	"#cor_hordeFer_Stalker": "Hordas de acosadores"
	"#cor_hordeMon_Hocker": "Hordas de Hocker"
	"#cor_hordeMon_Stinger": "Hordas de aguijones"
	"#cor_hordeMon_Stalker": "Hordas de acosadores"
	"#cor_hordeExploder": "Hordas explosivas"
	"#cor_hordeRetch": "Hordas de arcadas"
	"#cor_hordeReeker": "Hordas apestosas"
	"#cor_hordeMon_Exploder": "Hordas explosivas"
	"#cor_hordeMon_Retch": "Hordas de arcadas"
	"#cor_hordeMon_Reeker": "Hordas apestosas"

	"#cor_gameplayNoGrenades": "Bolsillos vacíos"
	"#cor_gameplayNoOutlines": "Sin contornos"
	"#cor_gameplayNoSupport": "Supervivencia del más apto"
	"#cor_gameplayNoRespawn": "Haz o muere"

	"#cor_playerLessAmmo": "Escasez de munición"
	"#cor_playerFatigue": "Fatiga"

	"#cor_uncommonClown": "Espectáculo de payasos"
	"#cor_uncommonRiot": "Control de la multitud"
	"#cor_uncommonMud": "Rastreadores de barro"
	"#cor_uncommonCeda": "Operadores de la CEDA"
	"#cor_uncommonConstruction": "Sitio de construcción"
	"#cor_uncommonJimmy": "Jimmy Gibbs y primos"
	"#cor_uncommonFallen": "Limpiadores caídos"

	"#cor_commonShamble": "Comunes tambaleantes"
	"#cor_commonRunning": "Ejecución de los bienes comunes"
	"#cor_commonBlitzing": "Arrasando los bienes comunes"

	"#cor_Tallboy": "Niños altos"
	"#cor_Fer_Tallboy": "Tallboys feroces"
	"#cor_Mon_Tallboy": "Taluboys monstruosos"

	"#cor_Crusher": "Trituradoras"
	"#cor_Fer_Crusher": "Trituradores feroces"
	"#cor_Mon_Crusher": "Trituradores monstruosos"

	"#cor_Bruiser": "Guerreros"
	"#cor_Fer_Bruiser": "Matones feroces"
	"#cor_Mon_Bruiser": "Matones monstruosos"

	"#cor_Hocker": "Hockers"
	"#cor_Fer_Hocker": "Hockers feroces"
	"#cor_Mon_Hocker": "Hockers monstruosos"

	"#cor_Stinger": "Aguijones"
	"#cor_Fer_Stinger": "Aguijones feroces"
	"#cor_Mon_Stinger": "Aguijones monstruosos"

	"#cor_Stalker": "Acosadores"
	"#cor_Fer_Stalker": "Acosadores feroces"
	"#cor_Mon_Stalker": "Acosadores monstruosos"

	"#cor_Retch": "Arcadas"
	"#cor_Fer_Retch": "Arcadas feroces"
	"#cor_Mon_Retch": "Arcadas monstruosas"

	"#cor_Exploder": "Explosionadores"
	"#cor_Fer_Exploder": "Explosivos feroces"
	"#cor_Mon_Exploder": "Explosivos monstruosos"

	"#cor_Reeker": "Apestosos"
	"#cor_Fer_Reeker": "Apestosos feroces"
	"#cor_Mon_Reeker": "Apestosos monstruosos"

	"#cor_hazardSnitch": "Chismosos"
	"#cor_bossBreaker": "Rompedor"
	"#cor_bossBreakerFer": "Rompedor feroz"
	"#cor_bossBreakerMon": "Rompedor monstruoso"
	"#cor_bossOgre": "Ogro"
	"#cor_bossOgreFer": "Ogro feroz"
	"#cor_bossOgreMon": "Ogro monstruoso"

	"#cor_missionSpeedrun": "Carrera de velocidad"
	"#cor_missionAllAlive": "Nadie se queda atrás"
	"#cor_missionGnomeAlone": "Gnomo solo"
	"#cor_missionSilenceIsGolden": "El silencio es oro"
	"#cor_missionSafetyFirst": "Seguridad primero"
}