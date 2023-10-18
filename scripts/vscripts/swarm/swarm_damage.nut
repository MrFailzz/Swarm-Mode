///////////////////////////////////////////////
//            DAMAGE INTERACTIONS            //
///////////////////////////////////////////////
function AllowBash(basher, bashee)
{
	//Shove damage
	if (bashee.IsValid())
	{
		if (bashee.IsPlayer())
		{
			if (!bashee.IsSurvivor())
			{
				CalcBashDamage(basher, bashee);
			}
		}
		else
		{
			local modelName = bashee.GetModelName();
			if (modelName != "models/props_junk/propanecanister001a.mdl"
				&& modelName != "models/props_junk/gascan001a.mdl"
				&& modelName != "models/props_equipment/oxygentank01.mdl"
				&& modelName != "models/props_junk/explosive_box001.mdl")
			{
				CalcBashDamage(basher, bashee);
			}
		}
	}

	//Ignore shoves on boomer-types
	if (bashee.IsPlayer())
	{
		if (bashee.GetZombieType() == 2)
		{
			return ALLOW_BASH_NONE;
		}
	}

	return ALLOW_BASH_ALL;
}

function CalcBashDamage(basher, bashee)
{
	local finalShoveDamage = shove_damage;
	local Brawler = PlayerHasCard(basher, "Brawler");

	finalShoveDamage += (50 * Brawler);

	bashee.TakeDamageEx(basher, basher, null, Vector(0,0,0), bashee.GetOrigin(), finalShoveDamage, DMG_MELEE);
}

function AllowTakeDamage(damageTable)
{
	//Table values
	local damageDone = damageTable.DamageDone;
	local originalDamageDone = damageTable.DamageDone;
	local attacker = damageTable.Attacker;
	local victim = damageTable.Victim;
	local attackerPlayer = null;
	local attackerClass = null;
	local attackerType = null;
	local victimPlayer = null;
	local victimType = null;
	local weapon = damageTable.Weapon;
	local weaponClass = null;
	if (weapon != null)
	{
		weaponClass = weapon.GetClassname();
	}
	local damageType = damageTable.DamageType;

	//Modifiers
	local damageModifier = 1.00;
	local GlassCannonAttacker = 0;
	local GlassCannonVictim = 0;
	local Sharpshooter = 0;
	local Outlaw = 0;
	local Overconfident = 0;
	local OverconfidentMultiplier = 0;
	local Broken = 0;
	local Pyromaniac = 0;
	local BombSquad = 0;
	local LuckyShot = 0;
	local LuckyShotRoll = 0;
	local FireProof = 0;
	local EyeOfTheSwarmAttacker = 0;
	local Brazen = 0;
	local StrengthInNumbers = 0;
	local StrengthInNumbersSurvivors = 0;
	local ConfidentKiller = 0;
	local ChemicalBarrier = 0;
	local Berserker = 0;
	local AddictAttacker = 0;
	local AddictAttackerMultiplier = 0;
	local AddictVictim = 0;
	local AddictVictimMultiplier = 0;
	local BuckshotBruiser = 0;
	local Nick = 0;
	local Ellis = 0;
	local Zoey = 0;
	local Francis = 0;
	local ScarTissue = 0;
	local Arsonist = 0;
	local SwanSong = 0;
	local ToughSkin = 0;
	local GamblerAttacker = 0;
	local GamblerVictim = 0;
	local AcidMultiplier = 0;
	local HeadMultiplier = 0;
	local Shredder = 0;
	local ShredderMultiplier = 0;
	local RunLikeHell = 0;
	local MeanDrunk = 0;
	local CleanKill = 0;
	local MarkedForDeath = 0;
	local Multitool = 0;
	local HyperFocused = 0;
	local HyperFocusedMultiplier = 0;

	//Modify Attacker damage
	if (attacker.IsValid())
	{
		if (attacker.IsPlayer())
		{
			//Survivor dealing damage
			if (attacker.IsSurvivor())
			{
				//Attack Specific Variables
				if (victim.IsValid())
				{
					victimPlayer = victim.IsPlayer();
					victimType = victim.GetClassname();
				}

				//Override melee weapon damage
				if (weaponClass == "weapon_melee")
				{
					if (originalDamageDone != 0)
					{
						damageTable.DamageDone *= (melee_damage.tofloat() / damageTable.DamageDone.tofloat());
						if (victimPlayer)
						{
							if (victim.IsSurvivor())
							{
								damageTable.DamageDone /= 100;
							}
						}
					}
				}

				// Headshot DMG
				if ((damageType & DMG_HEADSHOT) == DMG_HEADSHOT)
				{
					if (victimPlayer)
					{
						if (specialRetchType == "Reeker" && victim.GetZombieType() == 2 && (weaponClass != "weapon_melee"))
						{
							//Remove headshot damage vs Reekers
							HeadMultiplier = -0.75;
						}
						else if (victim.GetZombieType() == 8)
						{
							//Add headshot multiplier for tanks
							HeadMultiplier = 1.5;
						}
						else if (weaponClass == "weapon_melee")
						{
							//2x DMG for melee headshots
							HeadMultiplier = 1;
						}
						else
						{
							//Reduce headshot damage to 2x (default: 4x)
							HeadMultiplier = -0.5;
						}
					}
					//HyperFocused
					HyperFocused = PlayerHasCard(attacker, "HyperFocused");
				}

				//DownInFront
				if (victimPlayer)
				{
					if (victim.IsSurvivor())
					{
						if ((attacker.GetButtonMask() & IN_DUCK) && PlayerHasCard(attacker, "DownInFront"))
						{
							return false;
						}
					}
				}

				//Shredder
				Shredder = PlayerHasCard(attacker, "Shredder");
				if (Shredder > 0)
				{
					local shotsfired = NetProps.GetPropInt(attacker, "m_iShotsFired");
					ShredderMultiplier = 0.01 * shotsfired;
				}

				//Gambler
				GamblerAttacker = PlayerHasCard(attacker, "Gambler");

				//Nick Perk
				Nick = PlayerHasCard(attacker, "Nick");

				//Glass Cannon
				GlassCannonAttacker = PlayerHasCard(attacker, "GlassCannon");

				//Sharpshooter
				if (GetVectorDistance(attacker.GetOrigin(), victim.GetOrigin()) > 400)
				{
					Sharpshooter = PlayerHasCard(attacker, "Sharpshooter");
				}

				//Outlaw
				if (weaponClass == "weapon_pistol" || weaponClass == "weapon_pistol_magnum")
				{
					Outlaw = PlayerHasCard(attacker, "Outlaw");
				}

				//Broken
				if (victimPlayer)
				{
					if (victim.GetZombieType() == 8)
					{
						Broken = PlayerHasCard(attacker, "Broken");
					}

					//MarkedForDeath
					if (NetProps.GetPropInt(victim, "m_Glow.m_iGlowType") == 3 && !victim.IsSurvivor())
					{
						MarkedForDeath = TeamHasCard("MarkedForDeath");
					}
				}
				else if (victimType == "witch")
				{
					Broken = PlayerHasCard(attacker, "Broken");

					//MarkedForDeath
					if (NetProps.GetPropInt(victim, "m_Glow.m_iGlowType") == 3)
					{
						MarkedForDeath = TeamHasCard("MarkedForDeath");
					}
				}
				
				//Pyromaniac
				//Arsonist
				if ((damageType & DMG_BURN) == DMG_BURN)
				{
					Pyromaniac = PlayerHasCard(attacker, "Pyromaniac");
					Arsonist = PlayerHasCard(attacker, "Arsonist");
					if (Arsonist > 0)
					{
						Heal_TempHealth(attacker, 0.1 * Arsonist);
					}
				}

				//BombSquad
				if ((damageType & DMG_BLAST) == DMG_BLAST || (damageType & DMG_BLAST_SURFACE) == DMG_BLAST_SURFACE)
				{
					BombSquad = TeamHasCard("BombSquad");
				}

				//LuckyShot
				//Ellis Perk
				LuckyShot = TeamHasCard("LuckyShot");
				Ellis = PlayerHasCard(attacker, "Ellis");
				SwanSong = PlayerHasCard(attacker, "SwanSong");
				local SwanSongMultiplier = (attacker.IsIncapacitated() ? 1 : 0);
				local critChance = (7 * LuckyShot) + (5 * Ellis) + (100 * SwanSongMultiplier * SwanSong);

				if (RandomInt(1, 100) <= critChance)
				{
					LuckyShotRoll = 1;
					CriticalHit(attacker, damageTable.Location);
				}

				//EyeOfTheSwarm
				if (safeSurvivors.find(attacker) != null)
				{
					EyeOfTheSwarmAttacker = PlayerHasCard(attacker, "EyeOfTheSwarm");
				}

				//Brazen
				//Berserker
				//Zoey Perk
				if ((damageType & DMG_MELEE) == DMG_MELEE)
				{
					if (victimPlayer)
					{
						if (!victim.IsSurvivor())
						{
							Brazen = PlayerHasCard(attacker, "Brazen");
							Berserker = PlayerHasCard(attacker, "Berserker");
							Zoey = PlayerHasCard(attacker, "Zoey");
							MeanDrunk = PlayerHasCard(attacker, "MeanDrunk");
						}
					}
				}

				//StrengthInNumbers
				local survivorSIN = null;
				while ((survivorSIN = Entities.FindByClassname(survivorSIN, "player")) != null)
				{
					if (survivorSIN.IsSurvivor() && !survivorSIN.IsDead())
					{
						StrengthInNumbersSurvivors++
					}
				}
				StrengthInNumbers = TeamHasCard("StrengthInNumbers");

				//ConfidentKiller
				ConfidentKiller = PlayerHasCard(attacker, "ConfidentKiller");

				//Addict
				AddictAttacker = PlayerHasCard(attacker, "Addict");
				AddictAttackerMultiplier = AddictGetValue(attacker);

				//BuckshotBruiser
				if (weaponClass == "weapon_shotgun_chrome" || weaponClass == "weapon_pumpshotgun" || weaponClass == "weapon_autoshotgun" || weaponClass == "weapon_shotgun_spas")
				{
					BuckshotBruiser = PlayerHasCard(attacker, "BuckshotBruiser");
					Heal_TempHealth(attacker, 0.25 * BuckshotBruiser);
				}

				//CleanKill
				CleanKill = PlayerHasCard(attacker, "CleanKill");

				damageModifier = (damageModifier
								 + (0.3 * GlassCannonAttacker)
								 + (0.25 * Sharpshooter)
								 + (1 * Outlaw)
								 + (0.2 * Broken)
								 + (1.5 * Pyromaniac)
								 + (1 * BombSquad)
								 + (3 * LuckyShotRoll)
								 + (0.5 * EyeOfTheSwarmAttacker)
								 + (0.4 * Brazen)
								 + (0.025 * StrengthInNumbers * StrengthInNumbersSurvivors)
								 + (0.025 * ConfidentKiller * ConfidentKillerCounter)
								 + (0.25 * Berserker)
								 + (AddictAttackerMultiplier * AddictAttacker)
								 + (0.1 * Zoey)
								 + (0.05 * Nick)
								 + (ShredderMultiplier * Shredder)
								 + (0.2 * MeanDrunk)
								 + (0.025 * CleanKill * CleanKillCounter[GetSurvivorID(attacker)])
								 + (0.1 * MarkedForDeath)
								 + (1 * HyperFocused)
								 + (HeadMultiplier));
				if (GamblerAttacker > 0)
				{
					damageModifier += ApplyGamblerValue(GetSurvivorID(attacker), 4, GamblerAttacker);
				}
				damageDone = damageTable.DamageDone * damageModifier;
			}
		}
	}


	//Modify Victim damage
	if (victim.IsValid())
	{
		if (victim.IsPlayer())
		{
			if (victim.IsSurvivor())
			{
				//Victim Specific Variables
				if (attacker.IsValid())
				{
					attackerPlayer = attacker.IsPlayer();
					attackerType = attacker.GetClassname();
				}

				/*if (victim.GetHealth() == 1 && victim.GetHealthBuffer() > 0)
				{
					victimOnTempHP = true
				}*/

				//Prevent witch damage
				if (attackerType == "witch")
				{
					return false;
				}

				// Rework common infected DMG
				if (attackerType == "infected")
				{
					damageTable.DamageDone = commonClawDmg * CommonDmgMulti * difficulty_CommonDmgMulti;
				}

				// Rework infected claw DMG
				if (attackerPlayer)
				{
					if ((damageType & 128) == 128)
					{
						local zombieType = attacker.GetZombieType();
						local baseDamage = -1;

						if (weaponClass == "weapon_boomer_claw" || weaponClass == "weapon_charger_claw" || weaponClass == "weapon_jockey_claw" || weaponClass == "weapon_smoker_claw")
						{
							switch(zombieType)
							{
								case 1:
									switch(specialHockerType)
									{
										case "Hocker":
											baseDamage = hockerClawDmg * HockerDmgMulti;
										break;
										case "Stinger":
											baseDamage = stingerClawDmg * HockerDmgMulti;
										break;
									}
								break;
								case 2:
									switch(specialRetchType)
									{
										case "Retch":
											baseDamage = retchClawDmg * RetchDmgMulti;
										break;
										case "Exploder":
											baseDamage = exploderClawDmg * RetchDmgMulti;
										break;
										case "Reeker":
											baseDamage = reekerClawDmg * RetchDmgMulti;
										break;
									}
								break;
								case 5:
									switch (specialHockerType)
									{
										case "Stalker":
											baseDamage = stalkerClawDmg * HockerDmgMulti;
										break;
									}
								break;
								case 6:
									switch(specialTallboyType)
									{
										case "Tallboy":
											baseDamage = tallboyClawDmg * TallboyDmgMulti;
										break;
										case "Crusher":
											baseDamage = crusherClawDmg * TallboyDmgMulti;
										break;
										case "Bruiser":
											baseDamage = bruiserClawDmg * TallboyDmgMulti;
										break;
									}
								break;
							}
						}
						else if (zombieType == 8)
						{
							switch(corruptionBoss)
							{
								case "bossBreaker":
								case "bossBreakerFer":
								case "bossBreakerMon":
									baseDamage = bossClawDmg * BossDmgMulti;
								break;
								case "bossOgre":
								case "bossOgreFer":
								case "bossOgreMon":
									baseDamage = bossClawDmg * BossDmgMulti;
								break;
							}
						}

						//Only change damage when we specifically want to
						if (baseDamage != -1)
						{
							damageTable.DamageDone = baseDamage * difficulty_SpecialDmgMulti;
						}
					}
				}

				//DownInFront
				if (attackerPlayer)
				{
					if (attacker.IsSurvivor())
					{
						if ((victim.GetButtonMask() & IN_DUCK) && PlayerHasCard(victim, "DownInFront"))
						{
							return false;
						}
					}
				}

				//Gambler
				GamblerVictim = PlayerHasCard(victim, "Gambler");

				//Francis Perk
				Francis = PlayerHasCard(victim, "Francis");

				//Glass Cannon
				GlassCannonVictim = PlayerHasCard(victim, "GlassCannon");

				//Overconfident
				Overconfident = PlayerHasCard(victim, "Overconfident");
				if (Overconfident > 0)
				{
					if (NetProps.GetPropInt(victim, "m_currentReviveCount") == 0)
					{
						OverconfidentMultiplier = -0.25;
					}
					else
					{
						OverconfidentMultiplier = 0;
					}
				}

				if ((damageType & DMG_BURN) == DMG_BURN)
				{
					FireProof = PlayerHasCard(victim, "FireProof");
				}

				//Spitter Acid damage modifiers
				//ChemicalBarrier
				//DMG_RADIATION + DMG_ENERGYBEAM = Spitter Acid
				if ((damageType & 262144) == 262144 && (damageType & 1024) == 1024)
				{
					//Reduce acid damage globally
					damageTable.DamageDone = 1 * difficulty_SpecialDmgMulti;
					ChemicalBarrier = PlayerHasCard(victim, "ChemicalBarrier");
				}

				//Addict
				AddictVictim = PlayerHasCard(victim, "Addict");
				AddictVictimMultiplier = AddictGetValue(victim);

				//ScarTissue
				ScarTissue = PlayerHasCard(victim, "ScarTissue");

				//ToughSkin
				if (attacker.IsValid())
				{
					local attackerClass = attacker.GetClassname();
					if (attackerClass == "infected")
					{
						ToughSkin = PlayerHasCard(victim, "ToughSkin");
					}
				}

				//RunLikeHell
				RunLikeHell = PlayerHasCard(victim, "RunLikeHell");

				//CleanKill
				CleanKill = PlayerHasCard(victim, "CleanKill");
				if (CleanKill > 0)
				{
					if (attacker.IsValid())
					{
						CleanKillCounter[GetSurvivorID(victim)] = 0;
					}
				}

				//Multitool
				Multitool = PlayerHasCard(victim, "Multitool");

				damageModifier = (damageModifier
								+ (0.2 * GlassCannonVictim)
								+ (OverconfidentMultiplier * Overconfident)
								+ (-0.5 * FireProof)
								+ (-0.5 * ChemicalBarrier)
								+ (-1 * AddictVictimMultiplier * AddictVictim)
								+ (-0.1 * Francis)
								+ (-0.3 * ScarTissue)
								+ (-0.4 * ToughSkin)
								+ (0.15 * RunLikeHell)
								+ (0.05 * Multitool)
								+ (AcidMultiplier));
				if (GamblerVictim > 0)
				{
					damageModifier -= ApplyGamblerValue(GetSurvivorID(victim), 1, GamblerVictim);
				}
				damageDone = damageTable.DamageDone * damageModifier;
			}
		}
		else
		{
			local victimName = victim.GetName();
			if (victimName.find("__crow_group_") != null)
			{
				//Hit a crow
				if ((damageType & DMG_BLAST) == DMG_BLAST || (damageType & DMG_BLAST_SURFACE) == DMG_BLAST_SURFACE || (damageType & DMG_BURN) == DMG_BURN)
				{
					local nameArray = split(victimName, "_");
					local moveEnt = Entities.FindByName(null, "__crow_group_" + nameArray[2] + "_move");
					if (moveEnt != null)
					{
						if (moveEnt.IsValid())
						{
							ExplodeCrows(nameArray[2], moveEnt);
						}
					}
				}
			}
			else if (victimName.find("__alarm_door_") != null)
			{
				//Hit an alarm door
				if (attacker.IsValid())
				{
					if (attacker.IsPlayer())
					{
						if (attacker.IsSurvivor())
						{
							if (damageTable.DamageDone > 0)
							{
								local nameArray = split(victimName, "_");
								AlarmDoorActivate(nameArray[2]);
							}
						}
					}
				}
			}
		}
	}

	if (damageDone < 1 && originalDamageDone >= 1)
	{
		damageDone = 1;
	}
	damageTable.DamageDone = damageDone;

	if (swarmSettingsTable["debug_mode"] >= 2)
	{
		printl("Attacker: " + attacker);
		printl("Victim: " + victim);
		printl("Weapon: " + weaponClass);
		printl("Original DMG: " + originalDamageDone);
		printl("New DMG: " + damageTable.DamageDone);
		printl("DMG Modifier: " + damageModifier);
		printl("DMG Type: " + damageType);
		printl("");
	}

	return true;
}

function CriticalHit(player, location)
{
	local id = location.Length();

	local target = SpawnEntityFromTable("info_particle_target",
	{
		targetname = "__critical_particle_target" + id,
		origin = Vector(location.x, location.y, location.z + 16)
	});
	local particle = SpawnEntityFromTable("info_particle_system",
	{
		targetname = "__critical_particle" + id,
		origin = Vector(location.x, location.y, location.z - 16),
		cpoint1 = "__critical_particle_target" + id,
		effect_name = "electrical_arc_01",
		start_active = 1
	});

	EntFire("__critical_particle_target" + id, "Kill", "", 2);
	EntFire("__critical_particle" + id, "Kill", "", 2);

	local random = RandomInt(1, 3);
	if (random == 1)
	{
		EmitAmbientSoundOn("ambient.electrical_zap_1", 0.75, RandomInt(95, 105), RandomInt(90, 110), target);
	}
	else if (random == 2)
	{
		EmitAmbientSoundOn("ambient.electrical_zap_2", 0.75, RandomInt(95, 105), RandomInt(90, 110), target);
	}
	else
	{
		EmitAmbientSoundOn("ambient.electrical_zap_2", 0.75, RandomInt(95, 105), RandomInt(90, 110), target);
	}
}
