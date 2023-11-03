///////////////////////////////////////////////
//               HEALING EVENTS              //
///////////////////////////////////////////////
function Heal_PermaHealth(player, healAmount, currentTempHealth)
{
	local currentHealth = player.GetHealth();
	local maxHealth = player.GetMaxHealth();

	if (currentHealth + healAmount > maxHealth)
	{
		player.SetHealth(maxHealth);
		player.SetHealthBuffer(0);
	}
	else
	{
		player.SetHealth(currentHealth + healAmount);

		if (currentTempHealth + (currentHealth + healAmount) > maxHealth)
		{
			player.SetHealthBuffer(maxHealth - (currentHealth + healAmount));
		}
		else
		{
			player.SetHealthBuffer(currentTempHealth);
		}
	}
}

function Heal_TempHealth(player, healAmount)
{
	local currentHealth = player.GetHealth();
	local currentTempHealth = player.GetHealthBuffer();
	local maxHealth = player.GetMaxHealth();

	if (currentHealth + currentTempHealth + healAmount > maxHealth)
	{
		player.SetHealthBuffer(maxHealth - currentHealth);
	}
	else
	{
		player.SetHealthBuffer(healAmount + currentTempHealth);
	}
}

function Set_PermaHealth(player, healthAmount)
{
	local currentTempHealth = player.GetHealthBuffer();
	local maxHealth = player.GetMaxHealth();

	if (healthAmount > maxHealth)
	{
		player.SetHealth(maxHealth);
		player.SetHealthBuffer(0);
	}
	else
	{
		player.SetHealth(healthAmount);

		if (currentTempHealth + healthAmount > maxHealth)
		{
			player.SetHealthBuffer(maxHealth - healthAmount);
		}
		else
		{
			player.SetHealthBuffer(currentTempHealth);
		}
	}
}

function Set_TempHealth(player, healthAmount)
{
	local currentHealth = player.GetHealth();
	local maxHealth = player.GetMaxHealth();

	if (currentHealth + healthAmount > maxHealth)
	{
		player.SetHealthBuffer(maxHealth - currentHealth);
	}
	else
	{
		player.SetHealthBuffer(healthAmount);
	}
}

function CalcHealingMultiplier(player, tempHealth = false)
{
	local Gambler = PlayerHasCard(player, "Gambler");
	local EMTBag = PlayerHasCard(player, "EMTBag");
	local AntibioticOintment = PlayerHasCard(player, "AntibioticOintment");
	local MedicalExpert = TeamHasCard("MedicalExpert");
	local Rochelle = PlayerHasCard(player, "Rochelle");
	local ScarTissue = PlayerHasCard(player, "ScarTissue");

	local Addict = 0;
	if (tempHealth)
	{
		Addict = PlayerHasCard(player, "Addict");
	}

	local healMultiplier = (1
							+ (0.5 * EMTBag)
							+ (0.25 * AntibioticOintment)
							+ (0.30 * MedicalExpert)
							+ (0.1 * Rochelle)
							+ (-0.5 * ScarTissue)
							+ (0.5 * Addict));

	if (Gambler > 0)
	{
		healMultiplier += ApplyGamblerValue(GetSurvivorID(player), 6, Gambler);
	}

	return healMultiplier;
}

//Use heal begin because heal end is bugged, so restored temp health may not be accurate
function HealBegin(params)
{
	local player = GetPlayerFromUserID(params.subject);
	local currentTempHealth = player.GetHealthBuffer();
	survivorHealthBuffer[GetSurvivorID(player)] = currentTempHealth; //Store temp health at time of heal
	survivorReviveCount[GetSurvivorID(player)] = NetProps.GetPropInt(player, "m_currentReviveCount");
}

function HealSuccess(params)
{
	local healer = GetPlayerFromUserID(params.userid);
	local player = GetPlayerFromUserID(params.subject);
	local playerID = GetSurvivorID(player);
	local healMultiplier = CalcHealingMultiplier(healer);
	local MedicalProfessional = PlayerHasCard(healer, "MedicalProfessional");

	local healAmount = (medkitHealAmount + (10 * MedicalProfessional)) * healMultiplier;
	Heal_PermaHealth(player, healAmount, survivorHealthBuffer[playerID]);

	local AntibioticOintment = PlayerHasCard(healer, "AntibioticOintment");
	if (AntibioticOintment > 0)
	{
		local healAmountAntibiotic = antibioticHealAmount * AntibioticOintment;
		Heal_TempHealth(player, healAmountAntibiotic);
		Heal_GroupTherapy(player, healAmountAntibiotic, true);
	}

	Heal_GroupTherapy(player, healAmount, false);

	local ExperiencedEMT = PlayerHasCard(healer, "ExperiencedEMT");
	if (ExperiencedEMT > 0)
	{
		if (experiencedEMT[playerID] < ExperiencedEMT)
		{
			experiencedEMT[playerID] = ExperiencedEMT;
		}
	}

	//Restore lives
	if (survivorReviveCount[playerID] != 0)
	{
		local lifeRestoreAmount = survivorReviveCount[playerID] - (1 + MedicalProfessional);
		if (lifeRestoreAmount < 0)
		{
			lifeRestoreAmount = 0;
		}

		NetProps.SetPropInt(player, "m_currentReviveCount", lifeRestoreAmount);
	}
}

function PillsUsed(params)
{
	local player = GetPlayerFromUserID(params.subject);
	local maxHealth = player.GetMaxHealth();
	local healMultiplier = CalcHealingMultiplier(player, true);

	local AntibioticOintment = PlayerHasCard(player, "AntibioticOintment");
	local healAmount = (pillsHealAmount * healMultiplier) + (antibioticHealAmount * AntibioticOintment);

	Heal_TempHealth(player, healAmount);
	Heal_GroupTherapy(player, healAmount, true);
}

function AdrenalineUsed(params)
{
	local player = GetPlayerFromUserID(params.subject);
	local maxHealth = player.GetMaxHealth();
	local healMultiplier = CalcHealingMultiplier(player, true);

	local AntibioticOintment = PlayerHasCard(player, "AntibioticOintment");
	local healAmount = (adrenalineHealAmount * healMultiplier) + (antibioticHealAmount * AntibioticOintment);

	Heal_TempHealth(player, healAmount);
	Heal_GroupTherapy(player, healAmount, true);
}

function ReviveSuccess(params)
{
	local ledgeHang = params.ledge_hang;
	if (ledgeHang == 0)
	{
		local player = GetPlayerFromUserID(params.userid);
		local subject = GetPlayerFromUserID(params.subject);
		local maxHealth = subject.GetMaxHealth();
		local reviveHealth = Convars.GetFloat("survivor_revive_health");
		local SmellingSalts = TeamHasCard("SmellingSalts");
		if (SmellingSalts > 0)
		{
			reviveHealth /= (2 + SmellingSalts);
		}

		Set_TempHealth(subject, reviveHealth);

		local CombatMedic = TeamHasCard("CombatMedic");

		if (CombatMedic > 0)
		{
			Heal_PermaHealth(subject, 15 * CombatMedic, reviveHealth);
		}
	}
}

function DefibrillatorUsed(params)
{
	local player = GetPlayerFromUserID(params.userid);
	local subject = GetPlayerFromUserID(params.subject);
	local maxHealth = subject.GetMaxHealth();
	local reviveHealth = Convars.GetFloat("survivor_revive_health");
	local SmellingSalts = TeamHasCard("SmellingSalts");
	if (SmellingSalts > 0)
	{
		reviveHealth /= (2 + SmellingSalts);
	}

	Set_PermaHealth(subject, reviveHealth);

	local MedicalProfessional = PlayerHasCard(player, "MedicalProfessional");
	if (MedicalProfessional > 0)
	{
		Heal_PermaHealth(subject, 10 * MedicalProfessional, 0);
	}

	local CombatMedic = TeamHasCard("CombatMedic");

	if (CombatMedic > 0)
	{
		Heal_PermaHealth(subject, 15 * CombatMedic, 0);
	}

	//Set lives
	local lifeRestoreAmount = MutationOptions.SurvivorMaxIncapacitatedCount - MedicalProfessional;
	if (lifeRestoreAmount < 0)
	{
		lifeRestoreAmount = 0;
	}

	NetProps.SetPropInt(subject, "m_currentReviveCount", lifeRestoreAmount);

	if (lifeRestoreAmount == MutationOptions.SurvivorMaxIncapacitatedCount)
	{
		NetProps.SetPropInt(subject, "m_bIsOnThirdStrike", 1);
		NetProps.SetPropInt(subject, "m_isGoingToDie", 1);
	}
}

function Heal_GroupTherapy(healTarget, healAmount, isTempHealth)
{
	local GroupTherapy = TeamHasCard("GroupTherapy");

	if (GroupTherapy > 0)
	{
		healAmount = healAmount * (0.2 * GroupTherapy);
		
		local player = null;
		while ((player = Entities.FindByClassname(player, "player")) != null)
		{
			if (player.IsValid())
			{
				if (player.IsSurvivor())
				{
					if (ValidAliveSurvivor(player))
					{
						if (player != healTarget)
						{
							if (!isTempHealth)
							{
								Heal_PermaHealth(player, healAmount, player.GetHealthBuffer());
							}
							else
							{
								Heal_TempHealth(player, healAmount);
							}
						}
					}
				}
			}
		}
	}
}

function Heal_AmpedUp()
{
	local AmpedUp = TeamHasCard("AmpedUp");
	if (AmpedUp > 0)
	{
		if (AmpedUpCooldown <= 0)
		{
			local player = null;
			while ((player = Entities.FindByClassname(player, "player")) != null)
			{
				if (player.IsSurvivor())
				{
					if (ValidAliveSurvivor(player))
					{
						Heal_PermaHealth(player, 20 * AmpedUp, player.GetHealthBuffer());
					}
				}
			}

			AmpedUpCooldown = 5;
		}
	}
}
::Heal_AmpedUp <- Heal_AmpedUp;

function ApplyInspiringSacrifice()
{
	local InspiringSacrifice = TeamHasCard("InspiringSacrifice");

	local player = null;
	while ((player = Entities.FindByClassname(player, "player")) != null)
	{
		if (player.IsSurvivor())
		{
			if (ValidAliveSurvivor(player))
			{
				Heal_TempHealth(player, (25 * InspiringSacrifice));
			}
		}
	}
}