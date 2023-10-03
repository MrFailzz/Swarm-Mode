///////////////////////////////////////////////
//               HEALING EVENTS              //
///////////////////////////////////////////////
function CalcHealingMultiplier(player, tempHealth = false)
{
	local Gambler = PlayerHasCard(player, "Gambler");
	local EMTBag = PlayerHasCard(player, "EMTBag");
	local AntibioticOintment = PlayerHasCard(player, "AntibioticOintment");
	local MedicalExpert = TeamHasCard("MedicalExpert");
	local Rochelle = PlayerHasCard(player, "Rochelle");
	local ScarTissue = PlayerHasCard(player, "ScarTissue");

	local Addict = 0;
	if (tempHealth == true)
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
}

function HealSuccess(params)
{
	local healer = GetPlayerFromUserID(params.userid);
	local player = GetPlayerFromUserID(params.subject);
	local healMultiplier = CalcHealingMultiplier(healer);

	local healAmount = medkitHealAmount * healMultiplier;
	Heal_PermaHealth(player, healAmount, survivorHealthBuffer[GetSurvivorID(player)]);

	local AntibioticOintment = PlayerHasCard(healer, "AntibioticOintment");
	if (AntibioticOintment > 0)
	{
		local healAmountAntibiotic = 10 * AntibioticOintment;
		Heal_TempHealth(player, healAmountAntibiotic);
		Heal_GroupTherapy(player, healAmountAntibiotic, true);
	}

	Heal_GroupTherapy(player, healAmount, false);
}

function PillsUsed(params)
{
	local player = GetPlayerFromUserID(params.subject);
	local maxHealth = player.GetMaxHealth();
	local healMultiplier = CalcHealingMultiplier(player);

	local AntibioticOintment = PlayerHasCard(player, "AntibioticOintment");
	local healAmount = (pillsHealAmount * healMultiplier) + (10 * AntibioticOintment);

	Heal_TempHealth(player, healAmount);
	Heal_GroupTherapy(player, healAmount, true);
}

function AdrenalineUsed(params)
{
	local player = GetPlayerFromUserID(params.subject);
	local maxHealth = player.GetMaxHealth();
	local healMultiplier = CalcHealingMultiplier(player);

	local AntibioticOintment = PlayerHasCard(player, "AntibioticOintment");
	local healAmount = (adrenalineHealAmount * healMultiplier) + (10 * AntibioticOintment);

	Heal_TempHealth(player, healAmount);
	Heal_GroupTherapy(player, healAmount, true);
}

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
							if (isTempHealth == false)
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

function ReviveSuccess(params)
{
	local ledgeHang = params.ledge_hang;
	if (ledgeHang == 0)
	{
		local player = GetPlayerFromUserID(params.userid);
		local subject = GetPlayerFromUserID(params.subject);
		local maxHealth = subject.GetMaxHealth();
		local reviveHealth = Convars.GetFloat("survivor_revive_health");

		local CombatMedic = TeamHasCard("CombatMedic");

		if (CombatMedic > 0)
		{
			local CombatMedicAmount = 15 * CombatMedic;
			Heal_PermaHealth(subject, CombatMedicAmount, reviveHealth);
		}
	}
}

function DefibrillatorUsed(params)
{
	local player = GetPlayerFromUserID(params.userid);
	local subject = GetPlayerFromUserID(params.subject);
	local maxHealth = subject.GetMaxHealth();

	local CombatMedic = TeamHasCard("CombatMedic");

	if (CombatMedic > 0)
	{
		local CombatMedicAmount = 15 * CombatMedic;
		Heal_PermaHealth(subject, CombatMedicAmount, reviveHealth);
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
						local currentTempHealth = player.GetHealthBuffer();
						local currentHealth = player.GetHealth();
						local maxHealth = player.GetMaxHealth();

						local healAmount = 20 * AmpedUp;

						if (healAmount + currentHealth > maxHealth)
						{
							player.SetHealth(maxHealth);
						}
						else
						{
							player.SetHealth(healAmount + currentHealth);
						}

						local currentHealth = player.GetHealth();
						if (currentHealth + currentTempHealth > maxHealth)
						{
							player.SetHealthBuffer(maxHealth - currentHealth)
						}
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