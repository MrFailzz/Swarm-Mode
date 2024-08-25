///////////////////////////////////////////////
//            SHARED COMMON EVENTS           //
///////////////////////////////////////////////
function CommonsUpdate()
{
	if (corruptionCommons != "None" || corruptionUncommons != "None")
	{
		BuildCommonList();
	}

	if (corruptionCommons != "None")
	{
		switch(corruptionCommons)
		{
			case "commonAcid":
				AcidCommonsCountdown();
				break;
			case "commonFire":
				FireCommonsCountdown();
				break;
			case "commonExplode":
				ExplodingCommonsFilters();
				ExplodingCommonsCountdown();
				break;
		}
	}

	Update_UncommonSpawnTimer();
}

function ZombieDeath(params)
{
	if ("victim" in params)
	{
		local common = EntIndexToHScript(params.victim);

		if (!common.IsPlayer())
		{
			local commonName = common.GetName();

			if ("attacker" in params)
			{
				local player = EntIndexToHScript(params.attacker);

				// FaceYourFears
				local FaceYourFears = PlayerHasCard(player, "FaceYourFears");
				if (GetVectorDistance(player.GetOrigin(), common.GetOrigin()) < 100)
				{
					if (FaceYourFears > 0)
					{
						Heal_TempHealth(player, 2 * FaceYourFears);
					}
				}

				//CleanKill
				local CleanKill = PlayerHasCard(player, "CleanKill");
				if (CleanKill > 0)
				{
					if (params.headshot == 1)
					{
						CleanKillCounter[GetSurvivorID(player)]++;
						printl("Clean Kill: " + CleanKillCounter[GetSurvivorID(player)]);
					}
				}

				//Overwatch
				local Overwatch = PlayerHasCard(player, "Overwatch");
				if (GetVectorDistance(player.GetOrigin(), common.GetOrigin()) > 600)
				{
					local survivor = null;
					local commonOrigin = common.GetOrigin();

					while ((survivor = Entities.FindByClassnameWithin(survivor, "player", commonOrigin, 600)) != null)
					{
						if (survivor.IsSurvivor())
						{
							Heal_TempHealth(survivor, 5 * Overwatch);
						}
					}
				}

				// Biohazard
				if (bBiohazardEnabled)
				{
					Heal_TempHealth(player, 2);
				}

				if ("weapon_id" in params)
				{
					// BattleLust
					local BattleLust = PlayerHasCard(player, "BattleLust");
					if (params.weapon_id == 19)	// 19 is the ID for all melee weapons?
					{
						Heal_PermaHealth(player, 1 * BattleLust, player.GetHealthBuffer());
					}
					// Vanguard
					local Vanguard = PlayerHasCard(player, "Vanguard");
					if (Vanguard > 0)
					{
						local survivor = null;
						local playerOrigin = player.GetOrigin();

						while ((survivor = Entities.FindByClassnameWithin(survivor, "player", playerOrigin, 600)) != null)
						{
							if (survivor.IsSurvivor())
							{
								Heal_TempHealth(survivor, 1 * Vanguard);
							}
						}
					}
				}
			}

			if (commonName.find("__acid_common") != null)
			{
				local navTable = {};
				NavMesh.GetNavAreasInRadius(common.GetOrigin(), 64, navTable);
				foreach(area in navTable)
				{
					area.MarkAsDamaging(5);
				}
				DropSpit(common.GetOrigin());
				EntFire(commonName + "spitTrail", "Kill");
			}
			else if (commonName.find("__fire_common") != null)
			{
				EntFire(commonName + "fireTrail", "Kill");
				EntFire(commonName + "fireDamage", "Kill");
			}
			else if (commonName.find("__expl_common") != null)
			{
				EntFire(commonName + "explProp", "Kill");
				EntFire(commonName + "explHitbox", "Kill");

				if (params.headshot == 1)
				{
					ExplodingCommonBoom(params.victim);
					EntFire(commonName + "explEnt", "Explode");
				}
			}
			else if (commonName.find("__uncommon_fallen_") != null)
			{
				RandomItemDrop(common.GetOrigin());
			}
		}
	}
}

function BuildCommonList()
{
	local common = null;
	local commonName = null;
	local commonActivity = null;
	local commonGender = null;

	commonVarList.clear();
	acidCommonsCount = 0;
	fireCommonsCount = 0;
	explodingCommonsCount = 0;
	uncommonsCount = 0;


	while ((common = Entities.FindByClassname(common, "infected")) != null)
	{
		if (common.IsValid())
		{
			commonName = common.GetName();
			commonGender = NetProps.GetPropInt(common, "m_Gender");

			if (commonName == "" && (commonGender == 1 || commonGender == 2 || commonGender == 21 || commonGender == 22))
			{
				commonActivity = common.GetSequenceActivityName(common.GetSequence());

				if (commonActivity.find("NEUTRAL"))
				{
					commonVarList.append(common);
				}
			}
			if (commonName.find("__acid_common") != null)
			{
				acidCommonsCount++;
			}
			else if (commonName.find("__fire_common") != null)
			{
				fireCommonsCount++;
			}
			else if (commonName.find("__expl_common") != null)
			{
				explodingCommonsCount++;
			}
			else if (commonName.find("__uncommon_") != null)
			{
				uncommonsCount++;
			}
		}
	}
}


///////////////////////////////////////////////
//                ACID COMMONS               //
///////////////////////////////////////////////
function AcidCommonsCountdown()
{
	if ((Time() - acidCommonsTimer) >= acidCommonSpawnRate)
	{
		if (acidCommonsCount < acidCommonsMax)
		{
			local remainingSpawns = acidCommonSpawnAmount;

			while (remainingSpawns > 0 && commonVarList.len() - 1 >= 0)
			{
				CreateAcidCommon(commonVarList.remove(RandomInt(0, commonVarList.len() - 1)));
				remainingSpawns--;
			}
		}

		acidCommonsTimer = Time();
	}
}

function CreateAcidCommon(common)
{
	local commonName = "__acid_common" + common.GetEntityIndex();
	DoEntFire("!self", "AddOutput", "targetname " + commonName, 0, common, common);

	local spitTrail = SpawnEntityFromTable("info_particle_system",
	{
		targetname = commonName + "spitTrail",
		origin = common.GetOrigin(),
		angles = Vector(0, 0, 0),
		effect_name = "spitter_slime_trail",
		start_active = 1
	});

	EntFire(commonName + "spitTrail", "SetParent", commonName);
	EntFire(commonName + "spitTrail", "SetParentAttachment", "mouth");
}

///////////////////////////////////////////////
//                FIRE COMMONS               //
///////////////////////////////////////////////
function FireCommonsCountdown()
{
	if ((Time() - fireCommonsTimer) >= fireCommonSpawnRate)
	{
		if (fireCommonsCount < fireCommonsMax)
		{
			local remainingSpawns = fireCommonSpawnAmount;

			while (remainingSpawns > 0 && commonVarList.len() - 1 >= 0)
			{
				CreateFireCommon(commonVarList.remove(RandomInt(0, commonVarList.len() - 1)));
				remainingSpawns--;
			}
		}

		fireCommonsTimer = Time();
	}
}

function CreateFireCommon(common)
{
	local commonName = "__fire_common" + common.GetEntityIndex();
	DoEntFire("!self", "AddOutput", "targetname " + commonName, 0, common, common);

	local spitTrail = SpawnEntityFromTable("info_particle_system",
	{
		targetname = commonName + "fireTrail",
		origin = common.GetOrigin(),
		angles = Vector(0, 0, 0),
		effect_name = "fire_small_02",
		start_active = 1
	});

	EntFire(commonName + "fireTrail", "SetParent", commonName);
	EntFire(commonName + "fireTrail", "SetParentAttachment", "mouth");

	local fireTrigger = SpawnEntityFromTable("trigger_hurt",
	{
		targetname = commonName + "fireDamage",
		origin = common.GetOrigin(),
		angles = Vector(0, 0, 0),
		spawnflags = 1,
		damage = fireCommonDamage * 2,
		damagetype = 8,
		filtername = "__swarm_filter_survivor"

	});

	DoEntFire("!self", "AddOutput", "mins " + "-" + fireCommonRange + " -" + fireCommonRange + " 0", 0, null, fireTrigger);
	DoEntFire("!self", "AddOutput", "maxs " + fireCommonRange + " " + fireCommonRange + " 64", 0, null, fireTrigger);
	DoEntFire("!self", "AddOutput", "solid 2", 0, null, fireTrigger);
	EntFire(commonName + "fireDamage", "SetParent", commonName);
}


///////////////////////////////////////////////
//             EXPLODING COMMONS             //
///////////////////////////////////////////////
if (!IsModelPrecached("models/swarm/propanecanister001a_head.mdl"))
	PrecacheModel("models/swarm/propanecanister001a_head.mdl");

function ExplodingCommonsFilters()
{
	if (!explodingCommonsFiltersExist)
	{
		SpawnEntityFromTable("filter_damage_type",
		{
			targetname = "__swarm_filter_bullets",
			Negated = "Allow entities that match criteria",
			damagetype = 2
		});
		SpawnEntityFromTable("filter_melee_damage",
		{
			targetname = "__swarm_filter_melee",
			Negated = "Allow entities that match criteria",
			damagetype = 0
		});
		SpawnEntityFromTable("filter_multi",
		{
			targetname = "__swarm_filter_explHitbox",
			Negated = "Allow entities that match criteria",
			filtertype = 1,
			damagetype = 0,
			Filter01 = "__swarm_filter_bullets",
			Filter02 = "__swarm_filter_melee"
		});

		explodingCommonsFiltersExist = true;
	}
}

function ExplodingCommonsCountdown()
{
	if ((Time() - explodingCommonsTimer) >= explodingCommonSpawnRate)
	{
		if (explodingCommonsCount < explodingCommonsMax)
		{
			local remainingSpawns = explodingCommonSpawnAmount;

			while (remainingSpawns > 0 && commonVarList.len() - 1 >= 0)
			{
				CreateExplodingCommon(commonVarList.remove(RandomInt(0, commonVarList.len() - 1)));
				remainingSpawns--;
			}
		}

		explodingCommonsTimer = Time();
	}
}

function CreateExplodingCommon(common)
{
	local commonName = "__expl_common" + common.GetEntityIndex();
	DoEntFire("!self", "AddOutput", "targetname " + commonName, 0, common, common);

	local commonOrigin = common.GetOrigin();

	local explProp = SpawnEntityFromTable("prop_dynamic_override",
	{
		targetname = commonName + "explProp",
		origin = commonOrigin,
		angles = Vector(0, 0, 0),
		model = "models/swarm/propanecanister001a_head.mdl",
		solid = 0,
		disableshadows = 1,
		rendercolor = Vector(255, 223, 0),
		health = 1
	});

	EntFire(commonName + "explProp", "SetParent", commonName);
	EntFire(commonName + "explProp", "SetParentAttachment", "mouth");

	local explHitbox = SpawnEntityFromTable("func_breakable",
	{
		targetname = commonName + "explHitbox",
		origin = commonOrigin,
		angles = Vector(0, 0, 0),
		spawnflags = 0,
		health = 10,
		BreakableType = 0,
		damagefilter = "__swarm_filter_explHitbox",
		material = 2
	});

	// Set up hitbox
	EntFire(commonName + "explHitbox", "SetParent", commonName);
	EntFire(commonName + "explHitbox", "SetParentAttachment", "mouth");
	DoEntFire("!self", "AddOutput", "mins -14 -7 -6", 0, null, explHitbox);
	DoEntFire("!self", "AddOutput", "maxs 1 8 14", 0, null, explHitbox);
	DoEntFire("!self", "AddOutput", "solid 2", 0, null, explHitbox);
	EntFire(commonName + "explHitbox", "AddOutput", "OnBreak !self:RunScriptCode:zExplodingCommonBoom(" + common.GetEntityIndex() + "):0:-1");
	EntFire(commonName + "explHitbox", "AddOutput", "OnBreak " + commonName + "explEnt:Explode::0:-1");

	local explEnt = SpawnEntityFromTable("env_explosion",
	{
		targetname = commonName + "explEnt",
		origin = commonOrigin,
		spawnflags = 6401,
		iMagnitude = 1,
		iRadiusOverride = 1,
		fireballsprite = "sprites/zerogxplode.spr"
	});

	EntFire(commonName + "explEnt", "SetParent", commonName);
	EntFire(commonName + "explEnt", "SetParentAttachment", "mouth");
}

function ExplodingCommonBoom(common)
{
	local victim = null;
	local victimOrigin = null;
	local distanceFactor = null;
	local commonHandle = EntIndexToHScript(common);
	local commonOrigin = commonHandle.GetOrigin();

	while ((victim = Entities.FindByClassnameWithin(victim, "player", commonOrigin, explodingCommonRange)) != null)
	{
		victimOrigin = victim.GetOrigin();

		if (CheckLOS(Vector(commonOrigin.x,commonOrigin.y,commonOrigin.z+48), Vector(victimOrigin.x,victimOrigin.y,victimOrigin.z+48), commonHandle) == victim)
		{
			distanceFactor = 1 - (zGetVectorDistance(victimOrigin, commonOrigin) / explodingCommonRange);
			local angle = zGetVectorAngle(victimOrigin, commonOrigin);

			victim.SetOrigin(Vector(victimOrigin.x, victimOrigin.y, victimOrigin.z + 1));
			victim.SetVelocity(Vector(sin(angle + 90) * explodingCommonKnockback * (distanceFactor + 0.25), sin(angle) * explodingCommonKnockback * (distanceFactor + 0.25), 200));
			victim.TakeDamage(distanceFactor * explodingCommonDamage, DMG_BLAST_SURFACE, null);
		}
	}

	local infected = null;

	//Instant kill range
	while ((victim = Entities.FindByClassnameWithin(victim, "infected", commonOrigin, explodingCommonRange / 2)) != null)
	{
		victim.TakeDamage(100, 0, null);
	}

	//Stumble range
	while ((victim = Entities.FindByClassnameWithin(victim, "infected", commonOrigin, explodingCommonRange)) != null)
	{
		victim.TakeDamage(25, 33554432, null);
	}
}
::zExplodingCommonBoom <- ExplodingCommonBoom;
::DMG_BLAST_SURFACE <- DMG_BLAST_SURFACE;


///////////////////////////////////////////////
//                 UNCOMMONS                 //
///////////////////////////////////////////////
function Update_UncommonSpawnTimer()
{
	if (corruptionUncommons != "None")
	{
		switch(corruptionUncommons)
		{
			case "uncommonClown":
				UncommonCountdown("models/infected/common_male_clown.mdl", 16, 120);
			break;

			case "uncommonRiot":
				UncommonCountdown("models/infected/common_male_riot.mdl", 15, 450);
			break;

			case "uncommonMud":
				UncommonCountdown("models/infected/common_male_mud.mdl", 12, 120);
			break;

			case "uncommonCeda":
				UncommonCountdown("models/infected/common_male_ceda.mdl", 11, 120);
			break;

			case "uncommonConstruction":
				UncommonCountdown("models/infected/common_male_roadcrew.mdl", 13, 120);
			break;

			case "uncommonJimmy":
				UncommonCountdown("models/infected/common_male_jimmy.mdl", 17, 450);
			break;

			case "uncommonFallen":
				UncommonCountdown("models/infected/common_male_fallen_survivor.mdl", 14, 450);
			break;
		}
	}
}

function UncommonCountdown(model, gender, health)
{
	if ((Time() - uncommonsTimer) >= uncommonSpawnRate)
	{
		if (uncommonsCount < uncommonMax)
		{
			local remainingSpawns = uncommonSpawnAmount;

			while (remainingSpawns > 0 && commonVarList.len() - 1 >= 0)
			{
				CreateUncommon(commonVarList.remove(RandomInt(0, commonVarList.len() - 1)), model, gender, health);
				remainingSpawns--;
			}
		}

		uncommonsTimer = Time();
	}
}

function CreateUncommon(common, model, gender, health)
{
	PrecacheAndSetModel(common, model);
	NetProps.SetPropInt(common, "m_Gender", gender);
	common.SetMaxHealth(health);
	common.SetHealth(health);

	local commonName = "__uncommon_" + common.GetEntityIndex();
	DoEntFire("!self", "AddOutput", "targetname " + commonName, 0, common, common);
}

///////////////////////////////////////////////
//              CORRUPTION CARDS             //
///////////////////////////////////////////////
function ApplyZSpeedCard()
{
	switch(corruptionZSpeed)
	{
		case "commonShamble":
			CorruptionCard_CommonShamble();
			break;
		case "commonRunning":
			CorruptionCard_CommonRunning();
			break;
		case "commonBlitzing":
			CorruptionCard_CommonBlitzing();
			break;
	}
}

function CorruptionCard_CommonShamble()
{
	Convars.SetValue("z_speed", 210);
}
function CorruptionCard_CommonRunning()
{
	Convars.SetValue("z_speed", 250);
}
function CorruptionCard_CommonBlitzing()
{
	Convars.SetValue("z_speed", 270);
}