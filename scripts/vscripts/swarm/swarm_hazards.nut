if (!IsSoundPrecached("vehicles/car_alarm/car_alarm.wav"))
{
	PrecacheSound("vehicles/car_alarm/car_alarm.wav");
}

///////////////////////////////////////////////
//                HAZARD NAVS                //
///////////////////////////////////////////////
function HazardGetNavs()
{
	local navTable = {};
	local navArray = [];
	NavMesh.GetAllAreas(navTable);
	foreach(area in navTable)
	{
		// Attributes to exclude: 4096 (stairs), 32768 (cliff), 262144 (playerclip), 131072 (mob only) 1073741824 (has elevator)
		// Spawn Attributes to exclude: 2 (empty), 128 (player start), 1024 (not clearable) 2048 (checkpoint), 4096 (obscured) 8192 (no mobs), 32768 (rescue vehicle), 65536 (rescue closet)
		if (!area.HasAttributes(4096 | 32768 | 262144 | 131072 | 1073741824) && !area.HasSpawnAttributes(2 | 128 | 1024 | 2048 | 4096 | 8192 | 32768 | 65536) && !area.IsUnderwater() && !area.IsDamaging())
		{
			navArray.append(area)

			//Debug spawnable areas
			//area.DebugDrawFilled(255, 0, 0, 128, 30, true)
		}
	}

	return navArray;
}
hazardNavArray <- HazardGetNavs();

function HazardGetRandomNavArea(navArray)
{
	local i = RandomInt(0, navArray.len() - 1);
	local randomOrigin = navArray[i].FindRandomSpot();

	return Vector(randomOrigin.x, randomOrigin.y, navArray[i].GetCenter().z);
}

///////////////////////////////////////////////
//                ALARM DOORS                //
///////////////////////////////////////////////

function InitAlarmDoors()
{
	if (!IsModelPrecached("models/props_doors/emergency_exit_sign.mdl"))
		PrecacheModel("models/props_doors/emergency_exit_sign.mdl");

	local remainingDoors = null;
	local door = null;
	local doorList = [];
	doorList.clear();

	while ((door = Entities.FindByClassname(door, "prop_door_rotating")) != null)
	{
		// Only use closed doors and doors without names
		if (NetProps.GetPropInt(door, "m_eDoorState") == 0 && door.GetName() == "")
		{
			doorList.append(door);
		}
	}

	if (corruptionHazards == "hazardLockdown")
	{
		remainingDoors = ceil(RandomInt(alarmDoorCountMin, alarmDoorCountMax) * difficultyHazardMulti * 4);
	}
	else
	{
		remainingDoors = 0;
	}

	while (remainingDoors > 0 && doorList.len() - 1 >= 0)
	{
		CreateAlarmDoor(doorList.remove(RandomInt(0, doorList.len() - 1)));
		remainingDoors--;
	}
}

function CreateAlarmDoor(door)
{
	local doorIndex = door.GetEntityIndex();
	local doorName = "__alarm_door_" + doorIndex;
	DoEntFire("!self", "AddOutput", "targetname " + doorName, 0, door, door);
	//Track door status
	alarmDoorStatus[doorIndex.tostring()] <- false;

	local doorX = door.GetOrigin().x;
	local doorY = door.GetOrigin().y;
	local doorZ = door.GetCenter().z;
	local doorAngle = door.GetAngles().y;
	local xOffsetSign2 = 0;
	local yOffsetSign2 = 0;

	// Adjust 2nd sign offset based on the angle of the door
	if (doorAngle < 1)
	{
		yOffsetSign2 = 56;
	}
	else if (doorAngle < 91)
	{
		xOffsetSign2 = -56;
	}
	else if (doorAngle < 181)
	{
		yOffsetSign2 = -56;
	}
	else if (doorAngle < 361)
	{
		xOffsetSign2 = 56;
	}

	// Spawn signs and attach them to the door
	local sign1 = SpawnEntityFromTable("prop_dynamic",
	{
		targetname = doorName + "_sign1",
		origin = Vector(doorX, doorY, doorZ),
		angles = Vector(0, doorAngle, 0),
		model = "models/props_doors/emergency_exit_sign.mdl",
		solid = 0,
		disableshadows = 1
		fadescale = 0.5,
	});
	local sign2 = SpawnEntityFromTable("prop_dynamic",
	{
		targetname = doorName + "_sign2",
		origin = Vector(doorX + xOffsetSign2, doorY + yOffsetSign2, doorZ),
		angles = Vector(0, doorAngle + 180, 0),
		model = "models/props_doors/emergency_exit_sign.mdl",
		solid = 0,
		disableshadows = 1
		fadescale = 0.5,
	});

	EntFire(doorName + "_sign1", "SetParent", doorName);
	EntFire(doorName + "_sign2", "SetParent", doorName);

	// Horde events
	EntFire(doorName, "AddOutput", "OnOpen !self:RunScriptCode:AlarmDoorActivate(" + doorIndex.tostring() + "):0:1");
	// Make doors unbreakable until opened
	//EntFire(doorName, "SetUnbreakable", "!self:0:1");
}

function AlarmDoorActivate(doorIndex)
{
	if (!alarmDoorStatus[doorIndex.tostring()])
	{
		alarmDoorStatus[doorIndex.tostring()] = true;
		
		local doorName = "__alarm_door_" + doorIndex;
		local doorEnt = Entities.FindByName(null, doorName);

		//Create target for sound
		local doorOrigin = doorEnt.GetOrigin();
		local soundTarget = SpawnEntityFromTable("info_target",
		{
			targetname = doorName + "_target",
			origin = Vector(doorOrigin.x, doorOrigin.y, doorOrigin.z + 56)
		});

		EmitSoundOn("Car.Alarm", soundTarget);
		EntFire(doorName, "SetBreakable");
		ZSpawnMob();

		EntFire(doorName + "_target", "RunScriptCode", "AlarmDoorStopSound(" + doorIndex + ")", 8);
	}
}
::AlarmDoorActivate <- AlarmDoorActivate;

function AlarmDoorStopSound(doorIndex)
{
	local soundTarget = Entities.FindByName(null, "__alarm_door_" + doorIndex + "_target");
	StopSoundOn("Car.Alarm", soundTarget);
	EntFire("__alarm_door_" + doorIndex + "_target", "Kill");
}
::AlarmDoorStopSound <- AlarmDoorStopSound;


///////////////////////////////////////////////
//                   CROWS                   //
///////////////////////////////////////////////
crowsGroupsSpawned <- 0;

function InitCrows()
{
	if (!IsModelPrecached("models/swarm/jockey_crow.mdl"))
		PrecacheModel("models/swarm/jockey_crow.mdl");

	local crowGroupsToSpawn = null;
	local crowOrigin = null;
	local crowCount = 0;
	local crowGroupName = null;

	if (corruptionHazards == "hazardBirds")
	{
		crowGroupsToSpawn = ceil(RandomInt(crowGroupCountMin, crowGroupCountMax) * difficultyHazardMulti * 3);
	}
	else
	{
		crowGroupsToSpawn = 0;
	}

	while (crowsGroupsSpawned < crowGroupsToSpawn)
	{
		crowOrigin = HazardGetRandomNavArea(hazardNavArray);
		crowCount = 0;
		crowGroupName = "__crow_group_" + crowsGroupsSpawned;

		local crowTrigger = SpawnEntityFromTable("trigger_once",
		{
			targetname = crowGroupName + "_trigger",
			origin = crowOrigin,
			spawnflags = 1,
			filtername = "__swarm_filter_survivor"

		});
		local crowMove = SpawnEntityFromTable("func_movelinear",
		{
			targetname = crowGroupName + "_move",
			origin = crowOrigin,
			movedir = Vector(-90, 0, 0),
			spawnflags = 8,
			speed = 200,
			movedistance = 1200,
			startsound = "farm.crowflock"
		});

		// Set up trigger
		DoEntFire("!self", "AddOutput", "mins -44 -44 0", 0, null, crowTrigger);
		DoEntFire("!self", "AddOutput", "maxs 44 44 28", 0, null, crowTrigger);
		DoEntFire("!self", "AddOutput", "solid 2", 0, null, crowTrigger);

		EntFire(crowGroupName + "_trigger", "AddOutput", "OnTrigger !self:RunScriptCode:CrowFlyAway(" + crowsGroupsSpawned + "):0:-1");
		EntFire(crowGroupName + "_move", "AddOutput", "OnFullyOpen !self:RunScriptCode:ZSpawnMob():0:-1");

		// Spawn crow models
		while (crowCount < 8)
		{
			SpawnCrows(crowsGroupsSpawned, crowCount, crowOrigin);
			crowCount++;
		}

		crowsGroupsSpawned++;
	}
}

function SpawnCrows(groupID, crowID, crowOrigin)
{
	local crowName = "__crow_group_" + groupID + "_" + crowID;
	local randomSpreadX = RandomInt(-32, 32);
	local randomSpreadY = RandomInt(-32, 32);

	local crow = SpawnEntityFromTable("prop_dynamic",
	{
		targetname = crowName,
		origin = Vector(crowOrigin.x + randomSpreadX, crowOrigin.y + randomSpreadY, crowOrigin.z),
		angles = Vector(0, RandomInt(0, 359), 0),
		model = "models/swarm/jockey_crow.mdl",
		solid = 2,
		disableshadows = 1,
		fadescale = 0.5,
		rendercolor = Vector(64, 64, 64),
		DefaultAnim = ChooseCrowAnim(),
		filtername = "__swarm_filter_survivor"
	});

	crow.SetModelScale(0.5, 0);
	EntFire(crowName, "SetParent", "__crow_group_" + groupID + "_move");
	EntFire(crowName, "AddOutput", "OnTakeDamage !self:RunScriptCode:CrowFlyAway(" + crowsGroupsSpawned + "):0:-1");
}

function CrowFlyAway(groupID)
{
	local crowGroupName = "__crow_group_" + groupID;

	// Animate crows flying
	local i = 0;
	while (i < 8)
	{
		local crowName = "__crow_group_" + groupID + "_" + i;
		//local crowEnt = Entities.FindByName(null, crowName);
		EntFire(crowName, "DisableCollision");
		EntFire(crowName, "SetDefaultAnimation", "Pounce");
		EntFire(crowName, "SetAnimation", "Pounce");
		//crowEnt.SetVelocity(Vector(RandomFloat(0, 20), RandomFloat(0, 20), RandomInt(150, 240)))
		i++;
	}

	// Get move object
	local moveName = "__crow_group_" + groupID + "_move";
	local moveEnt = Entities.FindByName(null, moveName);

	// Fire events
	EntFire(moveName, "Open");
	EntFire(crowGroupName + "_trigger", "Kill");
	EntFire(crowGroupName + "*", "Kill", "", 6.5);
}
::CrowFlyAway <- CrowFlyAway;

function ChooseCrowAnim()
{
	if (RandomInt(0, 1) == 0)
	{
		return "Standing_Idle";
	}
	else
	{
		return "Crouch_Idle";
	}
}

function ExplodeCrows(groupID, moveEnt)
{
	local location = moveEnt.GetOrigin();
	local particle = SpawnEntityFromTable("info_particle_system",
	{
		targetname = "__crow_particle" + groupID,
		origin = Vector(location.x, location.y, location.z),
		angles = Vector(0, 0, 0),
		effect_name = "crows_gravelpile",
		start_active = 1
	});
	local particle2 = SpawnEntityFromTable("info_particle_system",
	{
		targetname = "__crow_particle" + groupID,
		origin = Vector(location.x, location.y, location.z),
		angles = Vector(0, 180, 0),
		effect_name = "crows_gravelpile",
		start_active = 1
	});

	EntFire("__crow_particle" + groupID, "Kill", "", 5);

	if (!IsSoundPrecached("JockeyZombie.Pain"))
	{
		PrecacheSound("JockeyZombie.Pain");
	}
	EmitAmbientSoundOn("JockeyZombie.Pain", 1, 120, RandomInt(130, 150), particle);
	EmitAmbientSoundOn("JockeyZombie.Pain", 1, 120, RandomInt(130, 150), particle);
	EmitAmbientSoundOn("JockeyZombie.Pain", 1, 120, RandomInt(130, 150), particle);
	EmitAmbientSoundOn("JockeyZombie.Pain", 1, 120, RandomInt(130, 150), particle);
	EmitAmbientSoundOn("JockeyZombie.Pain", 1, 120, RandomInt(130, 150), particle);

	moveEnt.Kill();
	EntFire("__crow_group_" + groupID + "_trigger", "Kill");
}


///////////////////////////////////////////////
//                 HITTABLES                 //
///////////////////////////////////////////////
function ModifyHittables()
{
	ReplaceDumpsters();
	ReplaceCars_Explosive();
	ReplaceCars_Alarm();
}

function ReplaceDumpsters()
{
	//Convert dumpsters to dynamic props
	local dumpster = null;
	local dumpsterClassname;

	local modelTable =
	{
		model1 = "models/props_junk/dumpster.mdl"
		model2 = "models/props_junk/dumpster_2.mdl"
		model3 = "models/props/cs_assault/forklift.mdl"
		model4 = "models/props/cs_assault/forklift_brokenlift.mdl"
		model5 = "models/props_foliage/swamp_fallentree01_bare.mdl"
		model6 = "models/props_foliage/tree_trunk_fallen.mdl"
	};

	foreach(model in modelTable)
	{
		while ((dumpster = Entities.FindByModel(dumpster, model)) != null)
		{
			dumpsterClassname = dumpster.GetClassname();
			if (dumpsterClassname.find("prop_physics") != null)
			{
				ConvertDumpster(dumpster, model);
			}
		}
	}
}

function ConvertDumpster(dumpster, dumpsterModel)
{
	local dumpsterOrigin = dumpster.GetOrigin();
	local dumpsterAngles = dumpster.GetAngles();

	//Delete old dumpster
	if (dumpster.IsValid())
	{
		dumpster.Kill();
	}

	local newDumpster = SpawnEntityFromTable("prop_dynamic",
	{
		origin = dumpsterOrigin,
		angles = Vector(dumpsterAngles.x, dumpsterAngles.y, dumpsterAngles.z),
		model = dumpsterModel,
		solid = 6
	});
}

function ReplaceCars_Explosive()
{
	//Convert cars to explosive barrels
	local car = null;
	local carClassname;
	
	local modelTable =
	{
		model1 = "models/props_vehicles/cara_69sedan.mdl"
		model2 = "models/props_vehicles/cara_82hatchback.mdl"
		model3 = "models/props_vehicles/cara_82hatchback_wrecked.mdl"
		model4 = "models/props_vehicles/cara_84sedan.mdl"
		model5 = "models/props_vehicles/cara_95sedan.mdl"
		model6 = "models/props_vehicles/cara_95sedan_wrecked.mdl"
		model7 = "models/props_vehicles/utility_truck.mdl"
		model8 = "models/props_vehicles/taxi_cab.mdl"
		model9 = "models/props_vehicles/taxi_city.mdl"
		model10 = "models/props_vehicles/taxi_rural.mdl"
	};

	foreach(model in modelTable)
	{
		while ((car = Entities.FindByModel(car, model)) != null)
		{
			carClassname = car.GetClassname();
			if (carClassname.find("prop_physics") != null)
			{
				ConvertCar_Explosive(car, model);
			}
		}
	}
}

function ConvertCar_Explosive(car, carModel)
{
	local carOrigin = car.GetOrigin();
	local carAngles = car.GetAngles();
	local carIndex = car.GetEntityIndex();
	local carColor = GetColor32(NetProps.GetPropIntArray(car, "m_clrRender", 0));
	local BasePieceModel = "models/props_vehicles/car005b_physics.mdl";

	//Delete old car
	if (car.IsValid())
	{
		car.Kill();
	}

	local newCar = SpawnEntityFromTable("prop_fuel_barrel",
	{
		targetname = "__newCar" + carIndex,
		origin = carOrigin,
		angles = Vector(carAngles.x, carAngles.y, carAngles.z),
		model = carModel,
		BasePiece = BasePieceModel,
		//FlyingPiece01 = "models/props_vehicles/car001a_phy.mdl",
		FlyingParticles = "barrel_fly",
		DetonateParticles = "weapon_pipebomb",
		DetonateSound = "BaseGrenade.Explode",
		rendercolor = Vector(carColor.red, carColor.green, carColor.blue)
	});

	newCar.SetHealth(explosiveCarHealth);

	//Create attachments based on car model
	switch (carModel)
	{
		case "models/props_vehicles/cara_69sedan.mdl":
			local carGlass = SpawnEntityFromTable("prop_car_glass", {targetname = "__newCar_glass" + carIndex, origin = carOrigin, angles = Vector(carAngles.x, carAngles.y, carAngles.z), model = "models/props_vehicles/cara_69sedan_glass.mdl"});
			EntFire("__newCar_glass" + carIndex, "SetParent", "__newCar" + carIndex);
			break;
		case "models/props_vehicles/cara_82hatchback.mdl":
			local carGlass = SpawnEntityFromTable("prop_car_glass", {targetname = "__newCar_glass" + carIndex, origin = carOrigin, angles = Vector(carAngles.x, carAngles.y, carAngles.z), model = "models/props_vehicles/cara_82hatchback_glass.mdl"});
			EntFire("__newCar_glass" + carIndex, "SetParent", "__newCar" + carIndex);
			break;
		case "models/props_vehicles/cara_82hatchback_wrecked.mdl":
			local carGlass = SpawnEntityFromTable("prop_car_glass", {targetname = "__newCar_glass" + carIndex, origin = carOrigin, angles = Vector(carAngles.x, carAngles.y, carAngles.z), model = "models/props_vehicles/cara_82hatchback_wrecked_glass.mdl"});
			EntFire("__newCar_glass" + carIndex, "SetParent", "__newCar" + carIndex);
			break;
		case "models/props_vehicles/cara_84sedan.mdl":
			local carGlass = SpawnEntityFromTable("prop_car_glass", {targetname = "__newCar_glass" + carIndex, origin = carOrigin, angles = Vector(carAngles.x, carAngles.y, carAngles.z), model = "models/props_vehicles/cara_84sedan_glass.mdl"});
			EntFire("__newCar_glass" + carIndex, "SetParent", "__newCar" + carIndex);
			break;
		case "models/props_vehicles/cara_95sedan.mdl":
			local carGlass = SpawnEntityFromTable("prop_car_glass", {targetname = "__newCar_glass" + carIndex, origin = carOrigin, angles = Vector(carAngles.x, carAngles.y, carAngles.z), model = "models/props_vehicles/cara_95sedan_glass.mdl"});
			EntFire("__newCar_glass" + carIndex, "SetParent", "__newCar" + carIndex);
			break;
		case "models/props_vehicles/cara_95sedan_wrecked.mdl":
			local carGlass = SpawnEntityFromTable("prop_car_glass", {targetname = "__newCar_glass" + carIndex, origin = carOrigin, angles = Vector(carAngles.x, carAngles.y, carAngles.z), model = "models/props_vehicles/cara_95sedan_wrecked_glass.mdl"});
			EntFire("__newCar_glass" + carIndex, "SetParent", "__newCar" + carIndex);
			break;
		case "models/props_vehicles/utility_truck.mdl":
			local carGlass = SpawnEntityFromTable("prop_car_glass", {targetname = "__newCar_glass" + carIndex, origin = carOrigin, angles = Vector(carAngles.x, carAngles.y, carAngles.z), model = "models/props_vehicles/utility_truck_windows.mdl"});
			EntFire("__newCar_glass" + carIndex, "SetParent", "__newCar" + carIndex);
			break;
		case "models/props_vehicles/taxi_cab.mdl":
			local carGlass = SpawnEntityFromTable("prop_car_glass", {targetname = "__newCar_glass" + carIndex, origin = carOrigin, angles = Vector(carAngles.x, carAngles.y, carAngles.z), model = "models/props_vehicles/police_car_glass.mdl"});
			EntFire("__newCar_glass" + carIndex, "SetParent", "__newCar" + carIndex);
			break;
		case "models/props_vehicles/taxi_city.mdl":
		case "models/props_vehicles/taxi_rural.mdl":
			local carGlass = SpawnEntityFromTable("prop_car_glass", {targetname = "__newCar_glass" + carIndex, origin = carOrigin, angles = Vector(carAngles.x, carAngles.y, carAngles.z), model = "models/props_vehicles/taxi_city_glass.mdl"});
			EntFire("__newCar_glass" + carIndex, "SetParent", "__newCar" + carIndex);
			break;
		default:
			break;
	}
}

function ReplaceCars_Alarm()
{
	//Convert police cars to alarms
	local car = null;
	local carClassname;
	
	local modelTable =
	{
		model1 = "models/props_vehicles/police_car.mdl"
		model2 = "models/props_vehicles/police_car_lights_on.mdl"
		model3 = "models/props_vehicles/police_car_opentrunk.mdl"
		model4 = "models/props_vehicles/police_car_city.mdl"
		model5 = "models/props_vehicles/police_car_rural.mdl"
		model6 = "models/props_vehicles/cara_95sedan.mdl"
	};

	foreach(modelID, model in modelTable)
	{
		while ((car = Entities.FindByModel(car, model)) != null)
		{
			carClassname = car.GetClassname();

			if (modelID == "model6" && carClassname.find("prop_car_alarm") != null)
			{
				ConvertCar_Alarm(car, model);
			}

			if (modelID != "model6" && carClassname.find("prop_physics") != null)
			{
				ConvertCar_Alarm(car, model);
			}
		}
	}
}

function ConvertCar_Alarm(car, carModel = "")
{
	local carOrigin = car.GetOrigin();
	local carAngles = car.GetAngles();
	local carIndex = car.GetEntityIndex();
	local angleOffset = 0;

	//Delete old car
	if (car.IsValid())
	{
		car.Kill();
	}

	if (carModel == "models/props_vehicles/cara_95sedan.mdl")
	{
		angleOffset = 90;
	}

	local newCar = SpawnEntityFromTable("prop_car_alarm",
	{
		targetname = "__newCar" + carIndex
		origin = carOrigin,
		angles = Vector(carAngles.x, carAngles.y - angleOffset, carAngles.z),
		model = "models/props_vehicles/police_car.mdl"
	});

	EntFire("__newCar" + carIndex, "AddOutput", "OnCarAlarmStart !self:RunScriptCode:AlarmPoliceActivate(" + carIndex + "):0:1");
	EntFire("__newCar" + carIndex, "AddOutput", "OnCarAlarmStart !self:RunScriptCode:AlarmPoliceStopSound(" + carIndex + "):10:1");

	local carGlass = SpawnEntityFromTable("prop_car_glass", {targetname = "__newCar_glass" + carIndex, origin = carOrigin, angles = Vector(carAngles.x, carAngles.y - angleOffset, carAngles.z), model = "models/props_vehicles/police_car_glass.mdl"});
	local carGlassBar = SpawnEntityFromTable("prop_dynamic", {targetname = "__newCar_glass" + carIndex, origin = carOrigin, angles = Vector(carAngles.x, carAngles.y - angleOffset, carAngles.z), model = "models/props_vehicles/police_car_lightbar.mdl", skin = 1});
	EntFire("__newCar_glass" + carIndex, "SetParent", "__newCar" + carIndex);

	//Create attachments based on car model
	/*switch (carModel)
	{
		case "models/props_vehicles/police_car.mdl":
		case "models/props_vehicles/police_car_lights_on.mdl":
		case "models/props_vehicles/police_car_opentrunk.mdl":
			local carGlass = SpawnEntityFromTable("prop_car_glass", {targetname = "__newCar_glass" + carIndex, origin = carOrigin, angles = Vector(carAngles.x, carAngles.y, carAngles.z), model = "models/props_vehicles/police_car_glass.mdl"});
			local carGlassBar = SpawnEntityFromTable("prop_dynamic", {targetname = "__newCar_glass" + carIndex, origin = carOrigin, angles = Vector(carAngles.x, carAngles.y, carAngles.z), model = "models/props_vehicles/police_car_lightbar.mdl", skin = 1});
			EntFire("__newCar_glass" + carIndex, "SetParent", "__newCar" + carIndex);
			break;
		case "models/props_vehicles/police_car_city.mdl":
			local carGlass = SpawnEntityFromTable("prop_car_glass", {targetname = "__newCar_glass" + carIndex, origin = carOrigin, angles = Vector(carAngles.x, carAngles.y, carAngles.z), model = "models/props_vehicles/police_car_city_glass.mdl"});
			EntFire("__newCar_glass" + carIndex, "SetParent", "__newCar" + carIndex);
			break;
		case "models/props_vehicles/police_car_rural.mdl":
			local carGlass = SpawnEntityFromTable("prop_car_glass", {targetname = "__newCar_glass" + carIndex, origin = carOrigin, angles = Vector(carAngles.x, carAngles.y, carAngles.z), model = "models/props_vehicles/police_car_rural_trunkopen_glass.mdl"});
			EntFire("__newCar_glass" + carIndex, "SetParent", "__newCar" + carIndex);
			break;
		default:
			break;
	}*/
}

function ReplaceAlarmsWithPolice()
{
	//Convert police cars to alarms
	local car = null;
	local carClassname;
	
	local modelTable =
	{
		model1 = "models/props_vehicles/police_car.mdl"
		model2 = "models/props_vehicles/police_car_lights_on.mdl"
		model3 = "models/props_vehicles/police_car_opentrunk.mdl"
		model4 = "models/props_vehicles/police_car_city.mdl"
		model5 = "models/props_vehicles/police_car_rural.mdl"
	};

	foreach(model in modelTable)
	{
		while ((car = Entities.FindByModel(car, model)) != null)
		{
			carClassname = car.GetClassname();
			if (carClassname.find("prop_physics") != null)
			{
				ConvertAlarmsToPolice(car, model);
			}
		}
	}
}

function ConvertAlarmsToPolice(car, carModel = "")
{
	local carOrigin = car.GetOrigin();
	local carAngles = car.GetAngles();
	local carIndex = car.GetEntityIndex();

	//Delete old car
	if (car.IsValid())
	{
		car.Kill();
	}

	local newCar = SpawnEntityFromTable("prop_car_alarm",
	{
		targetname = "__newCar" + carIndex
		origin = carOrigin,
		angles = Vector(carAngles.x, carAngles.y, carAngles.z),
		model = "models/props_vehicles/police_car.mdl"
	});

	EntFire("__newCar" + carIndex, "AddOutput", "OnCarAlarmStart !self:RunScriptCode:AlarmPoliceActivate(" + carIndex + "):0:1");
	EntFire("__newCar" + carIndex, "AddOutput", "OnCarAlarmStart !self:RunScriptCode:AlarmPoliceStopSound(" + carIndex + "):10:1");

	local carGlass = SpawnEntityFromTable("prop_car_glass", {targetname = "__newCar_glass" + carIndex, origin = carOrigin, angles = Vector(carAngles.x, carAngles.y, carAngles.z), model = "models/props_vehicles/police_car_glass.mdl"});
	local carGlassBar = SpawnEntityFromTable("prop_dynamic", {targetname = "__newCar_glass" + carIndex, origin = carOrigin, angles = Vector(carAngles.x, carAngles.y, carAngles.z), model = "models/props_vehicles/police_car_lightbar.mdl", skin = 1});
	EntFire("__newCar_glass" + carIndex, "SetParent", "__newCar" + carIndex);

	//Create attachments based on car model
	/*switch (carModel)
	{
		case "models/props_vehicles/police_car.mdl":
		case "models/props_vehicles/police_car_lights_on.mdl":
		case "models/props_vehicles/police_car_opentrunk.mdl":
			local carGlass = SpawnEntityFromTable("prop_car_glass", {targetname = "__newCar_glass" + carIndex, origin = carOrigin, angles = Vector(carAngles.x, carAngles.y, carAngles.z), model = "models/props_vehicles/police_car_glass.mdl"});
			local carGlassBar = SpawnEntityFromTable("prop_dynamic", {targetname = "__newCar_glass" + carIndex, origin = carOrigin, angles = Vector(carAngles.x, carAngles.y, carAngles.z), model = "models/props_vehicles/police_car_lightbar.mdl", skin = 1});
			EntFire("__newCar_glass" + carIndex, "SetParent", "__newCar" + carIndex);
			break;
		case "models/props_vehicles/police_car_city.mdl":
			local carGlass = SpawnEntityFromTable("prop_car_glass", {targetname = "__newCar_glass" + carIndex, origin = carOrigin, angles = Vector(carAngles.x, carAngles.y, carAngles.z), model = "models/props_vehicles/police_car_city_glass.mdl"});
			EntFire("__newCar_glass" + carIndex, "SetParent", "__newCar" + carIndex);
			break;
		case "models/props_vehicles/police_car_rural.mdl":
			local carGlass = SpawnEntityFromTable("prop_car_glass", {targetname = "__newCar_glass" + carIndex, origin = carOrigin, angles = Vector(carAngles.x, carAngles.y, carAngles.z), model = "models/props_vehicles/police_car_rural_trunkopen_glass.mdl"});
			EntFire("__newCar_glass" + carIndex, "SetParent", "__newCar" + carIndex);
			break;
		default:
			break;
	}*/
}

function AlarmPoliceActivate(carIndex)
{
	local carEnt = Entities.FindByName(null, "__newCar" + carIndex);
	EmitSoundOn("Car.Alarm", carEnt);
	DelayHordeTimers();
	Heal_AmpedUp();
}
::AlarmPoliceActivate <- AlarmPoliceActivate;

function AlarmPoliceStopSound(carIndex)
{
	local carEnt = Entities.FindByName(null, "__newCar" + carIndex);
	StopSoundOn("Car.Alarm", carEnt)
}
::AlarmPoliceStopSound <- AlarmPoliceStopSound;

function SnitchSpawn(count = RandomInt(1,3), zType = 7)
{
	local i = 0;
	while (i < count)
	{
		ZSpawn({type = zType});
		i++;
	}
}

///////////////////////////////////////////////
//               SNITCH HORDE                //
///////////////////////////////////////////////
function SnitchAlerted(params)
{
	if (params.first == 1)
	{
		SpawnMob();
	}
}

///////////////////////////////////////////////
//                  SLEEPERS                 //
///////////////////////////////////////////////
function InitSleepers()
{
	local sleepersSpawned = 0;
	local sleepersToSpawn = null;
	local sleeperOrigin = null;
	local sleeperSpawnName = null;

	if (corruptionHazards == "hazardSleepers")
	{
		sleepersToSpawn = ceil(RandomInt(sleeperCountMin, sleeperCountMax) * difficultyHazardMulti * 2);
	}
	else
	{
		sleepersToSpawn = 0
	}

	while (sleepersSpawned < sleepersToSpawn)
	{
		sleeperOrigin = HazardGetRandomNavArea(hazardNavArray);
		sleeperSpawnName = "__sleeperspawn" + sleepersSpawned;

		local sleeperSpawn = SpawnEntityFromTable("info_zombie_spawn",
		{
			targetname = sleeperSpawnName,
			origin = sleeperOrigin,
			angles = Vector(0, RandomInt(0, 359), 0),
			population = "hunter"
		});
		local sleeperSpawnTrigger = SpawnEntityFromTable("trigger_once",
		{
			targetname = sleeperSpawnName + "_trigger",
			origin = sleeperOrigin,
			spawnflags = 1,
			filtername = "__swarm_filter_survivor"
		});

		// Set up trigger
		DoEntFire("!self", "AddOutput", "mins -2548 -2548 -512", 0, null, sleeperSpawnTrigger);
		DoEntFire("!self", "AddOutput", "maxs 2548 2548 512", 0, null, sleeperSpawnTrigger);
		DoEntFire("!self", "AddOutput", "solid 2", 0, null, sleeperSpawnTrigger);

		//Only spawn sleepers as you get close to keep infected limits under control
		EntFire(sleeperSpawnName + "_trigger", "AddOutput", "OnTrigger " + sleeperSpawnName + ":SpawnZombie::0:-1");

		sleepersSpawned++;
	}
}

function SleeperLunge(player)
{
	if (!IsSoundPrecached("player/jockey/voice/attack/jockey_loudattack01_wet.wav"))
		PrecacheSound("player/jockey/voice/attack/jockey_loudattack01_wet.wav");
	
	EmitSoundOn("JockeyZombie.Pounce", player);

	local sleeperThinker = SpawnEntityFromTable("info_target", { targetname = "sleeperThinker" });
	if (sleeperThinker.ValidateScriptScope())
	{
		const RETHINK_TIME_SLEEPER = 2;
		local player_entityscript = sleeperThinker.GetScriptScope();
		player_entityscript["player"] <- player;
		player_entityscript["thinkCount"] <- 0;
		player_entityscript["pounceVictim"] <- 0;
		player_entityscript["SleeperPounced"] <- function()
		{
			if (player_entityscript["thinkCount"] != 0)
			{
				if (player_entityscript["player"].IsValid())
				{
					player_entityscript["pounceVictim"] = NetProps.GetPropInt(player_entityscript["player"], "m_pounceVictim");
					if (player_entityscript["pounceVictim"] == -1)
					{
						player_entityscript["player"].TakeDamage(250, 2097152, null);
						self.Kill();
					}
				}
				else
				{
					self.Kill();
				}
			}

			player_entityscript["thinkCount"]++
			return RETHINK_TIME_SLEEPER;
		}

		AddThinkToEnt(sleeperThinker, "SleeperPounced");
	}
}

function SleeperLanded(params)
{
	local player = GetPlayerFromUserID(params.userid);
	local sleeperLandedThinker = SpawnEntityFromTable("info_target", { targetname = "sleeperLandedThinker" });
	if (sleeperLandedThinker.ValidateScriptScope())
	{
		const RETHINK_TIME_SLEEPER_LANDED = 0.75;
		local player_entityscript = sleeperLandedThinker.GetScriptScope();
		player_entityscript["player"] <- player;
		player_entityscript["thinkCount"] <- 0;
		player_entityscript["SleeperLanded"] <- function()
		{
			if (player_entityscript["thinkCount"] != 0)
			{
				if (player_entityscript["player"].IsValid())
				{
					if (player_entityscript["player"].GetHealth() > 1)
					{
						ZSpawnMob();
						self.Kill();
					}
				}
				else
				{
					self.Kill();
				}
			}

			player_entityscript["thinkCount"]++
			return RETHINK_TIME_SLEEPER_LANDED;
		}

		AddThinkToEnt(sleeperLandedThinker, "SleeperLanded");
	}
}

function SleeperShoved(params)
{
	//Kill sleeper on shove
	local hunter = GetPlayerFromUserID(params.userid);
	local survivor = GetPlayerFromUserID(params.attacker);
	if (hunter.GetZombieType() == 3)
	{
		hunter.TakeDamage(250, 2097152, survivor);
	}
}