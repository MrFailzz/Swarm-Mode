///////////////////////////////////////////////
//                GAME EVENTS                //
///////////////////////////////////////////////
//Put all game event functions here, if used in multiple places create function that is called inside the event here

//Tank
function OnGameEvent_player_team(params)
{
	TankKicked(params);
}

function OnGameEvent_tank_spawn(params)
{
	TankSpawn(params);
}

//Common Infected
function OnGameEvent_zombie_death(params)
{
	ZombieDeath(params);
}

//Player Cards
function OnGameEvent_map_transition(params)
{
	MapTransition(params);
	RestoreTable("savedFogSettings", savedFogSettings); //Clear saved fog settings table for next map
}

function OnGameEvent_round_freeze_end(params)
{
	RoundFreezeEnd(params);
}

function OnGameEvent_round_start_post_nav(params)
{
	RoundStartPostNav(params);
}

function OnGameEvent_player_first_spawn(params)
{
	if ("userid" in params)
	{
		local player = GetPlayerFromUserID(params["userid"]);
		if (player.IsSurvivor())
		{
			GetAllPlayerCards();
		}
	}
}

function OnGameEvent_weapon_reload(params)
{
	WeaponReload(params);
}

//Specials
function OnGameEvent_ability_use(params)
{
	local player = GetPlayerFromUserID(params["userid"]);
	local ability = params["ability"];

	switch(ability)
	{
		case "ability_throw":
			BreakerJump(player);
		break;

		case "ability_charge":
			//BruiserKnockback(player);
		break;

		case "ability_vomit":
			ExploderAbility(player);
		break;
		
		case "ability_lunge":
			SleeperLunge(player);
		break;
	}
}

function OnGameEvent_tongue_grab(params)
{
	TongueGrab(params);
	StingerProjectile(params);
	CappedAlert();
	BreakoutMsg(params);
}

function OnGameEvent_witch_harasser_set(params)
{
	SnitchAlerted(params);
}

function OnGameEvent_lunge_pounce(params)
{
	SleeperLanded(params);
	CappedAlert();
	BreakoutMsg(params);
}

function OnGameEvent_player_now_it(params)
{
	RetchVomitHit(params);
}

function OnGameEvent_jockey_ride(params)
{
	CappedAlert();
	BreakoutMsg(params);
}

function OnGameEvent_charger_carry_start(params)
{
	CappedAlert();
	BreakoutMsg(params);
}

//Stocks
function OnGameEvent_player_spawn(params)
{
	PlayerSpawn(params);
}

function OnGameEvent_player_death(params)
{
	PlayerDeath(params);
}

function OnGameEvent_player_incapacitated_start(params)
{
	ApplyAdrenalineRush();
	ApplyInspiringSacrifice();
	IncapMsg(params);
}

function OnGameEvent_round_start(params)
{
	CreateCardHud();
	SetSpeedrunTimer();
	InitCorruptionCards();
	SetDifficulty();
}

function OnGameEvent_player_activate(params)
{
	//CorruptionDropItems();
}

function OnGameEvent_player_left_safe_area(params)
{
	PlayerLeftSafeArea(params);
}

function OnGameEvent_player_hurt(params)
{
	PlayerHurt(params);
}

function OnGameEvent_heal_begin(params)
{
	HealBegin(params);
}

function OnGameEvent_heal_success(params)
{
	HealSuccess(params);
}

function OnGameEvent_pills_used(params)
{
	PillsUsed(params);
}

function OnGameEvent_adrenaline_used(params)
{
	AdrenalineUsed(params);
}

function OnGameEvent_revive_success(params)
{
	ReviveSuccess(params);
}

function OnGameEvent_defibrillator_used(params)
{
	DefibrillatorUsed(params);
}

function OnGameEvent_triggered_car_alarm(params)
{
	Heal_AmpedUp();
}

function OnGameEvent_player_shoved(params)
{
	SleeperShoved(params);
	VictimShoved(params);
}

function OnGameEvent_item_pickup(params)
{
	TallboySpawn(params);
	SurvivorPickupItem(params);
	InitOptics(params);
}

function OnGameEvent_upgrade_pack_used(params)
{
	BarbedWire(params);
	AmmoPack(params);
}

function OnGameEvent_difficulty_changed(params)
{
	SetDifficulty();
}

function OnGameEvent_weapon_fire(params)
{
	ApplyCardsOnWeaponFire(params);
	WeaponFireM60(params);
}
