///////////////////////////////////////////////
//             GENERAL FUNCTIONS             //
///////////////////////////////////////////////
function SpawnMob(count = 1, zType = 10, hazardTrigger = true)
{
	//count = Number of groups to spawn
	//zType = Infected type to spawn, defaults to MOB if zType is not specified
	/*ZOMBIE_NORMAL = 0
	ZOMBIE_SMOKER = 1
	ZOMBIE_BOOMER = 2
	ZOMBIE_HUNTER = 3
	ZOMBIE_SPITTER = 4
	ZOMBIE_JOCKEY = 5
	ZOMBIE_CHARGER = 6
	ZOMBIE_WITCH = 7
	ZOMBIE_TANK = 8
	ZSPAWN_MOB = 10
	ZSPAWN_MUDMEN = 12
	ZSPAWN_WITCHBRIDE = 11*/

	local i = 0;
	while (i < count)
	{
		ZSpawn({type = zType, pos = Vector(0,0,0)});
		i++;
	}

	DelayHordeTimers();

	Heal_AmpedUp();
	Director.PlayMegaMobWarningSounds();

	if (hazardTrigger == true)
	{
		MissionSilenceFailed = true;
	}
}
::ZSpawnMob <- SpawnMob;

function DelayHordeTimers()
{
	if (HuntedTimer != null)
	{
		HuntedTimer += 20;
	}
	if (OnslaughtTimer != null)
	{
		OnslaughtTimer += 20;
	}
	if (SpecialHordeTimer != null)
	{
		SpecialHordeTimer += 20;
	}
}
::DelayHordeTimers <- DelayHordeTimers;

function DegToRad(angle)
{
	return angle * (PI / 180);
}

function GetVectorDistance(vec1, vec2)
{
	return sqrt(pow(vec1.x - vec2.x,2) + pow(vec1.y - vec2.y,2) + pow(vec1.z - vec2.z,2));
}
::zGetVectorDistance <- GetVectorDistance;

function GetVectorAngle(vec1, vec2)
{
	return atan2(vec1.y - vec2.y, vec1.x - vec2.x);
}
::zGetVectorAngle <- GetVectorAngle;

function CheckLOS(vec1, vec2, originEntity)
{
	local traceTable =
	{
		start = vec1
		end = vec2
		mask = TRACE_MASK_VISION
		ignore = originEntity
	};

	if(TraceLine(traceTable))
	{
		if(traceTable.hit)
		{
			return traceTable.enthit;
		}
	}
}
::CheckLOS <- CheckLOS;
::TRACE_MASK_VISION <- TRACE_MASK_VISION;

function Clamp(angle, clampTo)
{
	if (angle > clampTo)
	{
		return clampTo;
	}
	else
	{
		return angle;
	}
}

function Sign(x)
{
	if (x >= 0)
	{
		return 1;
	}
	else
	{
		return -1;
	}
}

// From Rocketdude
function GetColorInt(col)
{
	if(typeof(col) == "Vector")
	{
		local color = col.x;
		color += 256 * col.y;
		color += 65536 * col.z;
		return color;
	}
	else if(typeof(col) == "string")
	{
		local colorArray = split(col, " ");
		local r = colorArray[0].tointeger();
		local g = colorArray[1].tointeger();
		local b = colorArray[2].tointeger();
		local color = r;
		color += 256 * g;
		color += 65536 * b;
		return color;
	}
}

// From VSLib - Get rendercolor of a prop
/**
 * Gets a table of RGBA colors from 32 bit format to 8 bit.
 */
function GetColor32( color32 )
{
	local t = {};
	local readColor = color32;
	
	// Reads the 8 bit color values by rightshifting and masking the lowest byte out with bitwise AND.
	// The >>> makes it consider the input value unsigned.
	t.red <- (readColor & 0xFF);
	t.green <- ((readColor >>> 8) & 0xFF);
	t.blue <- ((readColor >>> 16) & 0xFF);
	t.alpha <- ((readColor >>> 24) & 0xFF);
	return t;
}

function CreateSurvivorFilter()
{
	SpawnEntityFromTable("filter_activator_team",
	{
		targetname = "__swarm_filter_survivor",
		Negated = "Allow entities that match criteria",
		filterteam = 2
	});
}
CreateSurvivorFilter();

function CreateInfectedFilter()
{
	SpawnEntityFromTable("filter_activator_team",
	{
		targetname = "__swarm_filter_infected",
		Negated = "Allow entities that match criteria",
		filterteam = 3
	});
}
CreateInfectedFilter();

function IntToTime(integer)
{
	local minutes = floor(integer / 60);
	minutes = format("%02i", minutes);
	local seconds = integer % 60;
	seconds = format("%02i", seconds);
	return minutes + ":" + seconds;
}

function PrecacheAndSetModel(entity, model)
{
	if (!IsModelPrecached(model))
	{
		PrecacheModel(model);
	}

	entity.SetModel(model);
}

function ValidAliveSurvivor(player)
{
	if (player.IsSurvivor())
	{
		return !player.IsDead() && !player.IsDying() && !player.IsIncapacitated() && !player.IsHangingFromLedge();
	}
}