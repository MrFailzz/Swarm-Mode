///////////////////////////////////////////////
//               LOCALIZATION                //
///////////////////////////////////////////////
function Loc(msg)
{
	if (msg.slice(0, 1) == "#")
	{
		switch(language)
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
		case "#lang_localization":
			return "English localization";
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
		case "#lang_localization":
			return "Русский localization";
		break;

		default:
			return msg;
		break;
	}
}