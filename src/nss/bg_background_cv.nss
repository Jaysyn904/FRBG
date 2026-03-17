// bg_background_cv.nss  
#include "inc_dynconv"  
#include "x2_inc_switches"  
#include "inc_persist_loca"
#include "te_afflic_func"


const int STAGE_LIST    = 0;  
const int STAGE_CONFIRM = 1;  
  
string GetBackgroundText(object oPC, int nChoice) 
{  
    return GetLocalString(oPC, "bg_dyn_text_" + IntToString(nChoice));  
}  

// Ensure the PC Data Object exists; create if missing    
object EnsurePlayerDataObject(object oPC)    
{   
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");    
    if (!GetIsObjectValid(oItem))    
    {    
        oItem = CreateItemOnObject("pc_data_object", oPC);
		SendMessageToPC(oPC, "Language data object recreated");
		WriteTimestampedLogEntry("Language data object recreated"); 		
    }    
    return oItem;    
}   
int _CanBeAffluent(object oPC = OBJECT_SELF)
{

    int nClass = GetPersistantLocalInt(oPC, "CC1");
    int nRtype = GetRacialType(oPC);
    return (
        (nClass == BACKGROUND_MIDDLE || nClass == BACKGROUND_UPPER) &&
        (nRtype == RACIAL_TYPE_HALFELF || nRtype == RACIAL_TYPE_HUMAN)
    );
}

int _CanBeBrawler(object oPC = OBJECT_SELF)
{
    int nSubrace = GetPersistantLocalInt(oPC, "CC0");
    int nClass = GetPersistantLocalInt(oPC, "CC1");
    return (
        nClass != BACKGROUND_UPPER &&
        nSubrace != 1458 && // Fey'ri
        nSubrace != 1177 && // Copper Elf
        nSubrace != 1178 && // Green Elf
        nSubrace != 1179 && // Dark Elf
        nSubrace != 1180 && // Silver Elf
        nSubrace != 1181 && // Gold Elf
        nSubrace != 1452 && // Deep Gnome
        nSubrace != 1453 && // Forest Gnome
        nSubrace != 1454 && // Rock Gnome
        GetAbilityScore(oPC,ABILITY_STRENGTH,TRUE) >= 13
    );
}

int _CanBeCircleBorn(object oPC = OBJECT_SELF)
{
    int nSubrace = GetPersistantLocalInt(oPC, "CC0");
    int nClass = GetPersistantLocalInt(oPC, "CC1");
    return (
        nClass == BACKGROUND_LOWER &&
        nSubrace != 1182 && // Gold Dwarf
        nSubrace != 1183 && // Grey Dwarf
        nSubrace != 1184 && // Shield Dwarf
        nSubrace != 1458 && // Fey'ri
        nSubrace != 1179 && // Dark Elf
        nSubrace != 1181 && // Gold Elf
        nSubrace != 1452 && // Deep Gnome
        nSubrace != 1454 && // Rock Gnome
        nSubrace != 1455 && // Ghostwise Halfling
        nSubrace != 1456 && // Lightfoot Halfling
        nSubrace != 1457 && // Strongheart Halfling
        nSubrace != 1186 && // Aasimar
        nSubrace != 1187 && // Tiefling
        GetRacialType(oPC) != RACIAL_TYPE_HALFORC
    );
}

int _CanBeCosmopolitan(object oPC = OBJECT_SELF)
{
    int nSubrace = GetPersistantLocalInt(oPC, "CC0");
    int nClass = GetPersistantLocalInt(oPC, "CC1");
    return (
        nClass == BACKGROUND_MIDDLE &&
        nSubrace != 1175 && // Natural Lycan
        nSubrace != 1179 && // Dark Elf
        nSubrace != 1182 && // Gold Dwarf
        nSubrace != 1183 && // Grey Dwarf
        nSubrace != 1184 && // Shield Dwarf
        nSubrace != 1186 && // Aasimar
        nSubrace != 1187 && // Tiefling
        nSubrace != 1445 && // F(?) Folk
        nSubrace != 1446 && // Chultan
        nSubrace != 1452 && // Deep Gnome
        nSubrace != 1453 && // Forest Gnome
        nSubrace != 1458 && // Fey'ri
        GetAbilityScore(oPC,ABILITY_CHARISMA, TRUE) >= 13 &&
        GetRacialType(oPC) != RACIAL_TYPE_HALFORC &&
        GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) < 1
    );
}

int _CanBeDukesWarband(object oPC = OBJECT_SELF)
{
    int nSubrace = GetPersistantLocalInt(oPC, "CC0");
    int nClass = GetPersistantLocalInt(oPC, "CC1");
    return (
        nClass != BACKGROUND_UPPER &&
       (nSubrace == 1175 ||  // Natural Lycan
        nSubrace == 1177 ||  // Copper Elf
        nSubrace == 1178 ||  // Green Elf
        nSubrace == 1180 ||  // Silver Elf
        nSubrace == 1387) && // Tethyrian
        GetRacialType(oPC) != RACIAL_TYPE_HALFORC &&
        GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) < 1
    );
}

int _CanBeElmanesse(object oPC = OBJECT_SELF)
{
    int nSubrace = GetPersistantLocalInt(oPC, "CC0");
    int nClass = GetPersistantLocalInt(oPC, "CC1");
	
    return (
        nSubrace == 1177 || // Copper Elf
        nSubrace == 1178 || // Green Elf
        nSubrace == 1180 || // Silver Elf
        nSubrace == 1181 || // Gold Elf
        GetRacialType(oPC) == RACIAL_TYPE_HALFELF
    );
}

int _CanBeEnlightened(object oPC = OBJECT_SELF)
{
    int nSubrace = GetPersistantLocalInt(oPC, "CC0");
    int nClass = GetPersistantLocalInt(oPC, "CC1");
    return (
        nClass != BACKGROUND_LOWER &&
        GetRacialType(oPC) != RACIAL_TYPE_HALFORC &&
        GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) < 1
    );
}

int _CanBeEvangelist(object oPC = OBJECT_SELF)
{
    int nSubrace = GetPersistantLocalInt(oPC, "CC0");
    int nClass = GetPersistantLocalInt(oPC, "CC1");
    return (
        nSubrace != 1179 && // Dark Elf
        nSubrace != 1183 && // Grey Dwarf
        nSubrace != 1452 && // Deep Gnome
        nSubrace != 1453 && // Forest Gnome
        GetAbilityScore(oPC,ABILITY_CHARISMA,TRUE) >= 13
    );
}

int _CanBeForester(object oPC = OBJECT_SELF)
{
    int nSubrace = GetPersistantLocalInt(oPC, "CC0");
    int nClass = GetPersistantLocalInt(oPC, "CC1");
    return (
        nClass == BACKGROUND_LOWER &&
        nSubrace != 1179 && // Dark Elf
        nSubrace != 1182 && // Gold Dwarf
        nSubrace != 1183 && // Grey Dwarf
        nSubrace != 1184 && // Shield Dwarf
        GetAbilityScore(oPC,ABILITY_CONSTITUTION,TRUE) >= 11
    );
}

int _CanBeHardLaborer(object oPC = OBJECT_SELF)
{
	int nClass = GetPersistantLocalInt(oPC, "CC1");
	
    return (
        nClass == BACKGROUND_LOWER &&
        GetAbilityScore(oPC,ABILITY_CONSTITUTION,TRUE) >= 11
    );
}

int _CanBeInHarem(object oPC = OBJECT_SELF)
{
    int nSubrace = GetPersistantLocalInt(oPC, "CC0");
    int nClass = GetPersistantLocalInt(oPC, "CC1");
    return (
        (nClass == BACKGROUND_LOWER || nClass == BACKGROUND_MIDDLE) &&
        nSubrace != 1182 && // Gold Dwarf
        nSubrace != 1183 && // Grey Dwarf
        nSubrace != 1184 && // Shield Dwarf
        nSubrace != 1452 && // Deep Gnome
        nSubrace != 1453 && // Forest Gnome
        nSubrace != 1454 && // Rock Gnome
        nSubrace != 1455 && // Ghostwise Halfling
        nSubrace != 1456 && // Lightfoot Halfling
        nSubrace != 1457 && // Strongheart Halfling
        GetRacialType(oPC) != RACIAL_TYPE_HALFORC &&
        GetAbilityScore(oPC,ABILITY_CHARISMA,TRUE) >= 13
    );
}

int _CanBeHighMage(object oPC = OBJECT_SELF)
{
    int nSubrace = GetPersistantLocalInt(oPC, "CC0");
    return (
        nSubrace == 1177 || // Copper Elf
        nSubrace == 1178 || // Green Elf
        nSubrace == 1180 || // Silver Elf
        nSubrace == 1181 || // Gold Elf
        GetAbilityScore(oPC,ABILITY_INTELLIGENCE,TRUE) >= 15
    );
}

int _CanBeAmnianTrained(object oPC = OBJECT_SELF)
{
    object oPC = GetPCSpeaker();
    // Make sure the player has the required feats
    if(
        (!GetHasFeat(BACKGROUND_LOWER,oPC)&&
        GetAbilityScore(oPC,ABILITY_INTELLIGENCE,TRUE) >= 13) &&
        GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) < 1 &&
        (GetHasFeat(1381,oPC) ||
        GetHasFeat(1382,oPC) ||
        GetHasFeat(1387,oPC))
      )
    {
        return TRUE;
    }

    return FALSE;
}

int _CanBeCalishiteTrained(object oPC = OBJECT_SELF)
{
    object oPC = GetPCSpeaker();
    // Make sure the player has the required feats
    if((GetHasFeat(BACKGROUND_UPPER,oPC) == TRUE)&&
		!GetHasFeat(1182,oPC) &&
		!GetHasFeat(1183,oPC) &&
		!GetHasFeat(1184,oPC) &&
		!GetHasFeat(1458,oPC) &&
		!GetHasFeat(1177,oPC) &&
		!GetHasFeat(1178,oPC) &&
		!GetHasFeat(1179,oPC) &&
		!GetHasFeat(1180,oPC) &&
		!GetHasFeat(1181,oPC) &&
		!GetHasFeat(1452,oPC) &&
		!GetHasFeat(1453,oPC) &&
		!GetHasFeat(1454,oPC) &&
		!GetHasFeat(1455,oPC) &&
		!GetHasFeat(1456,oPC) &&
		!GetHasFeat(1457,oPC) &&
		!GetHasFeat(1186,oPC) &&
		!GetHasFeat(1187,oPC) &&
		!GetHasFeat(1175,oPC) &&
		GetRacialType(oPC) != RACIAL_TYPE_HALFORC &&
		GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) < 1 &&
        GetAbilityScore(oPC,ABILITY_INTELLIGENCE,TRUE) >= 13 && 
        GetAbilityScore(oPC,ABILITY_CHARISMA,TRUE) >= 11)
      
    {
        return TRUE;
    }
	else
	{
		return FALSE;
	}
}

int _CanBeDuelist(object oPC = OBJECT_SELF)
{
    int nSubrace = GetPersistantLocalInt(oPC, "CC0");
    int nClass = GetPersistantLocalInt(oPC, "CC1");
    return (
        nClass != BACKGROUND_LOWER &&
        nSubrace != 1177 && // Copper Elf
        nSubrace != 1178 && // Green Elf
        nSubrace != 1179 && // Dark Elf
        nSubrace != 1182 && // Gold Dwarf
        nSubrace != 1183 && // Grey Dwarf
        nSubrace != 1184 && // Shield Dwarf
        nSubrace != 1446 && // Chultan
        nSubrace != 1448 && // Maztican
        nSubrace != 1450 && // Shaaran
        nSubrace != 1452 && // Deep Gnome
        nSubrace != 1453 && // Forest Gnome
        nSubrace != 1454 && // Rock Gnome
        nSubrace != 1455 && // Ghostwise Halfling
        nSubrace != 1456 && // Lightfoot Halfling
        nSubrace != 1457 && // Strongheart Halfling
        nSubrace != 1458 && // Fey'ri
        GetRacialType(oPC) != RACIAL_TYPE_HALFORC &&
        GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) < 1 &&
        GetAbilityScore(oPC,ABILITY_DEXTERITY,TRUE) >= 13
    );
}

int _CanBeKnight(object oPC = OBJECT_SELF)
{
    int nSubrace = GetPersistantLocalInt(oPC, "CC0");
    int nClass = GetPersistantLocalInt(oPC, "CC1");
    return (
        (nClass == BACKGROUND_MIDDLE || nClass == BACKGROUND_UPPER) &&
        (nSubrace == 1456 ||  // Lightfoot Halfling
         nSubrace == 1381 ||  // Calishite
         nSubrace == 1382 ||  // Chondathan
         nSubrace == 1383 ||  // Damaran
         nSubrace == 1384 ||  // Illuskan
         nSubrace == 1385 ||  // Mulan
         nSubrace == 1387) && // Tethyrian
         GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) < 1 &&
         GetRacialType(oPC) != RACIAL_TYPE_HALFELF
    );
}

int _CanBeMinstrel(object oPC = OBJECT_SELF)
{
    int nSubrace = GetPersistantLocalInt(oPC, "CC0");
    return (
        nSubrace != 1179 && // Dark Elf
        nSubrace != 1183 && // Damaran
        !GetHasFeat(DEITY_Chauntea,oPC) &&
        !GetHasFeat(DEITY_Silvanus,oPC) &&
        !GetHasFeat(DEITY_Eldath,oPC) &&
        GetRacialType(oPC) != RACIAL_TYPE_HALFORC &&
        GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) < 1 &&
        GetAbilityScore(oPC,ABILITY_CHARISMA,TRUE) >= 13
    );
}

int _CanBeMetalsmith(object oPC = OBJECT_SELF)
{
    if((GetHasFeat(BACKGROUND_MIDDLE,oPC) == TRUE)&&
		(GetRacialType(oPC) == RACIAL_TYPE_HALFELF||
		 GetRacialType(oPC) == RACIAL_TYPE_HALFLING||
		 GetRacialType(oPC) == RACIAL_TYPE_GNOME||
		 GetRacialType(oPC) == RACIAL_TYPE_HUMAN)&&
		(GetAbilityScore(oPC,ABILITY_CONSTITUTION,TRUE) >= 13))
    {
        return TRUE;
    }
	else
	{
		return FALSE;
	}
}

int _CanBeMordinsamman(object oPC = OBJECT_SELF)
{
    int nSubrace = GetPersistantLocalInt(oPC, "CC0");
    int nClass = GetPersistantLocalInt(oPC, "CC1");
    return (
        nClass == BACKGROUND_MIDDLE &&
       (nSubrace == 1182 ||  // Gold Dwarf
        nSubrace == 1183 ||  // Grey Dwarf
        nSubrace == 1184) && // Shield Dwarf
        GetLevelByClass(CLASS_TYPE_CLERIC,oPC) > 1
    );
}

int _CanBeSeldarinePriest(object oPC = OBJECT_SELF)
{
    int nSubrace = GetPersistantLocalInt(oPC, "CC0");
    return (
        (nSubrace == 1177 ||  // Copper Elf
         nSubrace == 1178 ||  // Green Elf
         nSubrace == 1180 ||  // Silver Elf
         nSubrace == 1181) && // Gold Elf
         GetLevelByClass(CLASS_TYPE_CLERIC,oPC) > 1
    );
}

int _CanBeSoldier(object oPC = OBJECT_SELF)
{
	int nClass = GetPersistantLocalInt(oPC, "CC1");
    return (nClass == BACKGROUND_LOWER || nClass == BACKGROUND_MIDDLE);
}

int _CanHaveSpellfire(object oPC = OBJECT_SELF)
{
    int nSubrace = GetPersistantLocalInt(oPC, "CC0");
    int nClass = GetPersistantLocalInt(oPC, "CC1");
    return (
        nSubrace != 1175 && // Natural Lycan
        GetRacialType(oPC) != RACIAL_TYPE_HALFORC &&
        GetAbilityScore(oPC,ABILITY_CONSTITUTION,TRUE) >= 13
    );
}

int _CanBeSuldusk(object oPC = OBJECT_SELF)
{
    int nSubrace = GetPersistantLocalInt(oPC, "CC0");
    return (
        nSubrace == 1177 ||  // Copper Elf
        nSubrace == 1178 ||  // Green Elf
        nSubrace == 1180 ||  // Silver Elf
        nSubrace == 1181 ||  // Gold Elf
        GetRacialType(oPC) == RACIAL_TYPE_HALFELF
    );
}

int _CanBeTalfirian(object oPC = OBJECT_SELF)
{
    int nSubrace = GetPersistantLocalInt(oPC, "CC0");
    return (
       (nSubrace == 1387 ||  // Tethyrian
        nSubrace == 1445) && // F(?) Folk
        GetAbilityScore(oPC,ABILITY_CHARISMA,TRUE) >= 13
    );
}

int _CanBeTheocrat(object oPC = OBJECT_SELF)
{
    int nSubrace = GetPersistantLocalInt(oPC, "CC0");
    int nClass = GetPersistantLocalInt(oPC, "CC1");
    return (
        (nClass == BACKGROUND_MIDDLE || nClass == BACKGROUND_UPPER) &&
         nSubrace == 1179 && // Dark Elf
         nSubrace == 1183 && // Grey Dwarf
         nSubrace == 1386 && // Rashemi
         nSubrace == 1445 && // F(?) Folk
         nSubrace == 1446 && // Chultan
         nSubrace == 1448 && // Maztican
         nSubrace == 1450 && // Shaaran
         nSubrace == 1452 && // Deep Gnome
         nSubrace == 1453 && // Forest Gnome
        GetRacialType(oPC) != RACIAL_TYPE_HALFORC &&
        GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) < 1 &&
        GetAbilityScore(oPC,ABILITY_WISDOM,TRUE) >= 13 &&
        GetAbilityScore(oPC,ABILITY_CHARISMA,TRUE) >= 13
    );
}

int _CanBeThunderTwin(object oPC = OBJECT_SELF)
{
    int nSubrace = GetPersistantLocalInt(oPC, "CC0");
    return (
        nSubrace == 1182 || // Gold Dwarf
        nSubrace == 1183 || // Grey Dwarf
        nSubrace == 1184    // Shield Dwarf
    );
}

int _CanBeUnderdarkExile(object oPC = OBJECT_SELF)
{
    int nSubrace = GetPersistantLocalInt(oPC, "CC0");
    return (
        nSubrace == 1179 || // Dark Elf
        nSubrace == 1182 || // Gold Dwarf
        nSubrace == 1183 || // Grey Dwarf
        nSubrace == 1184 || // Shield Dwarf
        nSubrace == 1187 || // Tiefling
        nSubrace == 1447 || // Imaskari
        nSubrace == 1452 || // Deep Gnome
        GetRacialType(oPC) == RACIAL_TYPE_HALFORC
    );
}

int _CanBeTriadWard(object oPC = OBJECT_SELF)
{
    int nSubrace = GetPersistantLocalInt(oPC, "CC0");;
    return (
        nSubrace == 1180 || // Silver Elf
        nSubrace == 1182 || // Gold Dwarf
        nSubrace == 1184 || // Shield Dwarf
        nSubrace == 1186 || // Aasimar
        nSubrace == 1381 || // Calishite
        nSubrace == 1382 || // Chondathan
        nSubrace == 1383 || // Damaran
        nSubrace == 1384 || // Illuskan
        nSubrace == 1385 || // Mulan
        nSubrace == 1386 || // Rashemi
        nSubrace == 1387 || // Tethyrian
        nSubrace == 1388 || // Rashemi
        nSubrace == 1445 || // F(?) Folk
        nSubrace == 1447 || // Imaskari
        nSubrace == 1448 || // Maztican
        nSubrace == 1450 || // Shaaran
        nSubrace == 1451 || // Shou
        nSubrace == 1454 || // Rock Gnome
        nSubrace == 1455 || // Ghostwise Halfling
        nSubrace == 1456 || // Lightfoot Halfling
        nSubrace == 1457 || // Strongheart Halfling
        GetRacialType(oPC) == RACIAL_TYPE_HALFORC
    );
}


void main()           
{            
    object oPC = GetPCSpeaker();           
    object oItem = EnsurePlayerDataObject(oPC);	          
    SendMessageToPC(oPC, "DEBUG: bg_background_cv main() entered");            
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);            
    int nStage = GetStage(oPC);         
        
    int nClass 		= GetPersistantLocalInt(oPC, "CC1");        
    int nSubrace 	= GetPersistantLocalInt(oPC, "CC0");        
    int nRacial		= GetRacialType(oPC);	        
              
    if (nValue == 0) return;            
              
    if (nValue == DYNCONV_SETUP_STAGE)           
    {            
        if (!GetIsStageSetUp(nStage, oPC))           
        {            
            if (nStage == STAGE_LIST)           
            {            
                SetHeader("Select your background.  You can refresh the list with the Escape key if needed.");            
               // 1 Affluent   
                if (_CanBeAffluent(oPC))   
                {    
                    AddChoice("Affluence", 1, oPC);    
                    SetLocalString(oPC, "bg_dyn_text_1",    
                        "You were born to a life of ease and indulgence. Only the harsh reality of war has jarred your insulated lifestyle. You must now step outside the comfort of your family's protection, although they will support your campaign from afar. You are tasked with establishing the next great familial holdings with your name and influence as your only tools..\n\nDoes this describe you?");    
                }  
				// 2 Amnian Trained
                if (_CanBeAmnianTrained(oPC)) 
				{  
                    AddChoice("Amnian Trained", 2, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_2",  
                        "You may have previously trained at the School of Wonder in Northern Tethyr along with most of the Cowled Wizards, or you may have been apprenticed to a member of that organization. While one was allowed to share their identity, most Cowled Wizards do so sparingly..\n\nDoes this describe you?");  
                }				
                // 3 Brawler  
                if (_CanBeBrawler(oPC)) 
				{  
                    AddChoice("Brawler", 3, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_3",  
                        "Your hands are calloused from battles that began in your youth. Whether you are still a fighter or have moved on to another station, your tendency to resolve things 'The Old Fashioned Way' remains..\n\nDoes this describe you?");  
                }  
                // 4 Calishite Slave  
				if(nClass != BACKGROUND_UPPER)
				{  
                    AddChoice("Calishite Slave", 4, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_4",  
                        "You may have a talent for story telling or entertainment, or have exotic looks that are considered a commodity. Either way, your talents are favored by Calishite nobles who brag to each other about how much you were bought and paid for. Escaping from Calimshan into Tethyr means that you can no longer be enslaved, and so there was no other path to take..\n\nDoes this describe you?");  
                }
                // 5 Calishite Trained  
				if(_CanBeCalishiteTrained(oPC))
				{  
                    AddChoice("Calishite Trained", 5, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_5",  
                        "Calishite trained mages have been tutored in academic environments by the most qualified of the profession. They favor spells from specialties they refer to as Fire and Air paths, where evocations are their mainstay..\n\nDoes this describe you?");  
                }  				
                // 6 Caravaner  
				if(nClass != BACKGROUND_UPPER)
				{  
                    AddChoice("Caravaner", 6, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_6",  
                        "You have the calloused hands of a hard worker and probably a tan to match. You've traveled the trade roads most of your life and seen various kingdoms over that time. Everywhere you go you can find work, until your back gives out.\n\nDoes this describe you?");  
                }  
                // 7 Church Acolyte 				
				if(GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) >= 1 && GetRacialType(oPC) != RACIAL_TYPE_HALFORC)
				{  
                    AddChoice("Church Orphan", 7, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_7",  
                        "For years, you have studied the dogma of your chosen deity, hoping to someday become ordained as a real priest or priestess. Because of your many years of dedication to this path, you expect to advance more quickly than others who are just starting out..\n\nDoes this describe you?");  
                }  
                // 8 Circle Born  
                if (_CanBeCircleBorn(oPC)) 
				{  
                    AddChoice("Circle Born", 8, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_8",  
                        "An orphan, you were found by or given to a Druidic grove to be raised. As a result, the grove and its creatures are like your family, and you are woefully out of touch with society for the most part..\n\nDoes this describe you?");  
                }  
                // 9 Cosmopolitan  
                if (_CanBeCosmopolitan(oPC)) 
				{  
                    AddChoice("Cosmopolitan", 9, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_9",  
                        "You have lived in many cities and know many cultures...\n\nDoes this describe you?");  
                }  
                // 10 Crusader  
				if((nSubrace != 1179 && nSubrace != 1183)) // No Dark Elf or Grey Dwarf
				{  
                    AddChoice("Crusader", 10, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_10",  
                        "Whether you have traveled a great distance or a short one, your church has sent you on a critical mission. The spiritual well-being of the people of Tethyr is at stake. Although not a knight, crusaders find many honors in their service to their faith and are the first to be considered for knighthood..\n\nDoes this describe you?");  
                } 
                // 11 Duelist  
				if(_CanBeDuelist(oPC))
				{  
                    AddChoice("Duelist", 11, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_11",  
                        "Undoubtedly drawing some influence from nearby Amn, you cannot turn down the excitement of the duel. Whether to defend your honor or simply for the fame, your skills have been honed in the art of single combat..\n\nDoes this describe you?");  
                }
			    // 12 Duke’s Warband  
                if (_CanBeDukesWarband(oPC)) 
				{  
                    AddChoice("Duke’s Warband", 12, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_12",  
                        "You are recognized in the duchy of Noromath as a lower ranking member of Duke Allain Kevanarial's warband. Instead of occupying a castle, the elven duke prefers to range through the woods of northern Tethyr, coordinating information and resources between several allied groups such as the Tethyrian Army, the Druidic Circle, and the elves of the Wealdath..\n\nDoes this describe you?");  
                }  
			    // 13  Eldreth Veluuthra  
                if (nRacial == RACIAL_TYPE_ELF) 
				{  
                    AddChoice(" Eldreth Veluuthra", 13, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_13",  
                        "You believe that elves are the superior race, and that they have a right as well as a duty to reclaim the Wealdath forest. You are angered or disgusted by the very existence of half elves and will strive to drive these abominations out of the unspoiled woods that remain..\n\nDoes this describe you?");  
                }
                // 14 Elmanesse  
                if (_CanBeElmanesse(oPC)) 
				{  
                    AddChoice("Elmanesse Tribe", 14, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_14",  
                        "You are a member of one of the last tribes of wild Green Elves, also known as Sy'Tel'Quessir. Some members of the Elmanesse have settled in Tethyr after they departed from Myth Drannor, and the Elmanesse are the most accepting of elven outsiders who might try to make a life in the Wealdath. They have even been known to accept half elves into their way of life..\n\nDoes this describe you?");  
                }  
                // 15 Enlightened Student
                if (_CanBeEnlightened(oPC)) 
				{  
                    AddChoice("Enlightened Student", 15, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_15",  
                        "You have been extensively trained in philosophy, mathematics and other contemporary subjects that the denizens of rural places consider to be as mysterious and otherworldly as magic.\n\nDoes this describe you?"); 
                }  
                // 16 Evangelist  
                if (_CanBeEvangelist(oPC)) 
				{  
                    AddChoice("Evangelist", 16, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_16",  
                        "Even more so than the crusader, the Evangelist has taken the spiritual welfare of others and placed it over his own physical well-being. Taking to the streets, the Evangelist chooses to spread the message of his faith to any who will hear it and can often be found in the company of their church's brave crusaders.\n\nDoes this describe you?");  
                }  
                // 17 Forester  
                if (_CanBeForester(oPC)) 
				{  
                    AddChoice("Forester", 17, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_17",  
                        "You grew up among the trees where a rugged lifestyle required knowledge of the woods and the animals that inhabit it. You are resourceful in situations requiring a worldly body of knowledge because of this experience.\n\nDoes this describe you?");   
                }  
                // 18 Hard Laborer 
                if (_CanBeHardLaborer(oPC)) 
				{  
                    AddChoice("Hard Laborer", 18, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_18",  
                        "For one reason or another, you ended up serving a sentence of forced hard labor - the most popular punishment in the land of Tethyr. Due to poor record keeping and a civil war, the reason has been lost to time and you are now free. \n\nDoes this describe you?");  
                }  
                // 19 Harem Trained
                if (_CanBeInHarem(oPC)) 
				{  
                    AddChoice("Harem Trained", 19, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_19",  
                        "Whether you were considered beautiful or particularly talented early on, your lack of pedigree and social status designated you as someone who would best serve your betters with your talents. You were given additional training and invested in, even if you are basically the property of someone else.\n\nDoes this describe you?");   
                }
                // 20 Harper Protégé
                if (GetIsPC(oPC)) 
				{  
                    AddChoice("Harper Protégé", 20, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_20",  
                        "You are an apprentice or the direct descendant of a Harper who at some point in time made you known to the organization. Whether you actually have an interest in furthering their goals, the Harpers usually have an interest in furthering yours, it seems.\n\nDoes this describe you?");   
                }				
                // 21 Healer  
                if ((GetAbilityScore(oPC,ABILITY_WISDOM,TRUE) >= 13)) 
				{  
                    AddChoice("Healer", 21, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_21",  
                        "You have always had the gift of caring for others. In your care, babies have been delivered and the pain of death has been eased. You found your abilities lacking in a larger world and seek the esoteric methods that would enhance your craft..\n\nDoes this describe you?");  
                }
				// 22 Hedge Mage  
                if ((GetAbilityScore(oPC,ABILITY_INTELLIGENCE,TRUE) >= 11 || GetAbilityScore(oPC,ABILITY_CHARISMA,TRUE) >= 11)) 
				{  
                    AddChoice("Hedge Mage", 22, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_22",  
                        "Fearing the discovery of your magical training, your lessons were limited to the time after your chores were completed. Although you were only given a most basic understanding of the laws governing magic, it is more than enough to cause trouble in nearby Amn - where the Art is strongly regulated..\n\nDoes this describe you?");  
                }  
                // 23 Heir to the Throne  
                if (nRacial == RACIAL_TYPE_DWARF) 
				{  
                    AddChoice(" Heir to the Throne", 23, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_23",  
                        "You were raised on tales of your ancestors and their heroism and bravery. You were nourished by the story that you were born to be a king and lead your people back to the former glory of Shanatar. The Wyrmskull Throne is said to belong to you and no one else, and you have never doubted this birth right..\n\nDoes this describe you?");  
                }  
                // 24 High Mage  
                if (_CanBeHighMage(oPC)) 
				{  
                    AddChoice("High Mage", 24, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_24",  
                        "You have studied the ancient secrets of Elven High Magic and Mythals. Although the complete formulas for Mythal creation are poorly understood in the current day and age, you received your training from aging elves to understand these essential secrets before they are lost forever.\n\nDoes this describe you?");  
                }
				// 25 Knight  
                if (_CanBeKnight(oPC)) 
				{  
                    AddChoice("Knight", 25, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_25",  
                        "Honor, chivalry, and duty to the crown are all that define you as a Tethyrian Knight. You may be bound to a particular lord, keep or temple but you live and die by the word of Queen-Monarch Zaranda Star, and the Tethyrian Knightly Code that she has decreed. Those who speak against the crown are your enemies and they must have their views challenged in a contest of steel. The Knights are arguably Tethyr's most influential class - assuming positions of power throughout the realm.\n\nDoes this describe you?");  
                }  
				// 26 Knight Squire
                if (_CanBeKnight(oPC)) 
				{  
                    AddChoice("Knight Squire", 26, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_26",  
                        "Not having the noble pedigree that most knights have put you at a disadvantage, and it seemed like every opportunity for knighthood during the Interregnum passed you over. Your best course now is to find a knight to train under and try to win recommendations that will better your odds when it comes time for Knighthoods to be granted again.\n\nDoes this describe you?");  
                }
				// 27 Mendicant  
				if((nClass == BACKGROUND_MIDDLE || nClass == BACKGROUND_UPPER) && GetRacialType(oPC) != RACIAL_TYPE_HALFORC && GetAbilityScore(oPC,ABILITY_INTELLIGENCE,TRUE) >= 11)
				{  
                    AddChoice("Mendicant", 27, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_27",  
                        "You have cast away the burden of all worldly belongings and enriched your spiritual being by doing so. You now travel the land, learning what it means to receive mercy from strangers as your vows force you to beg for your meals. This strange devotion earns you confusion from some and compassion from others..\n\nDoes this describe you?");  
                } 
                // 28 Merchant  
				if((nClass == BACKGROUND_MIDDLE || nClass == BACKGROUND_UPPER) && GetRacialType(oPC) != RACIAL_TYPE_HALFORC && GetAbilityScore(oPC,ABILITY_INTELLIGENCE,TRUE) >= 11)
				{  
                    AddChoice("Merchant", 28, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_28",  
                        "Whether it was the family trade or your very own enterprise, you have developed the skills to barter with even the shrewdest of Calishite traders. You hope to one day retire in wealth, yet enjoy the travel afforded by your profession..\n\nDoes this describe you?");  
                } 
				// 29 Metalsmith  
                if (_CanBeMetalsmith(oPC)) 
				{  
                    AddChoice("Metalsmith", 29, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_29",  
                        "The metalsmith holds an honored place among the society of Knights, where his craft is highly respected. Your short apprenticeship ended when the civil war began, as your mentor was called to service. You understand the process required to work iron, yet you hope to someday master the secret of steel.\n\nDoes this describe you?");  
                }  
                // 30 Minstrel  
                if (_CanBeMinstrel(oPC)) 
				{  
                    AddChoice("Minstrel", 30, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_30",  
                        "You have apprenticed under a skilled composer and learned the traditions of music, dance, and prose. It is your hope that Tethyr's noble, beleaguered people will inspire you to write your greatest work yet. Thus, you have set out in order to find the necessary subject of your inspiration.\n\nDoes this describe you?");  
                }  
                // 31 Mordinsamman Priest  
                if (_CanBeMordinsamman(oPC)) 
				{  
                    AddChoice("Mordinsamman Priest", 31, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_31",  
                        "You are the keeper of the dwarven pantheon of gods, and a last vestige of dwarven stories and folklore. You must be a champion for the place of dwarves in the world, which has been diminishing for generations. Although your gods are fading, they live within your feet that hammer the stone, your hands that mend dwarven bones, and your steel that cleaves the enemies of all dwarves..\n\nDoes this describe you?");  
                }
                // 32 Natural Lycanthrope  
                if (GetAbilityScore(oPC,ABILITY_WISDOM,TRUE) >= 11) 
				{  
                    AddChoice("Natural Lycanthrope", 32, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_32",  
                        "Perhaps unknown to even yourself, you have some dark secret running in your bloodline, a heritage you may have been running from all your life. By embracing it finally you may unlock some aspect of yourself you never imagined..\n\nDoes this describe you?");  
                } 				
                // 33 Occultist  
                if (GetAbilityScore(oPC,ABILITY_CHARISMA,TRUE) >= 11) 
				{  
                    AddChoice("Occultist", 33, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_33",  
                        " You have sacrificed everything near and dear to you for power. Ever since you were young you have studied ancient, dark grimoires for the unsavory and even macabre learnings they offered. Still, you seek something more...\n\nDoes this describe you?");  
                }  
                // 34 Saboteur  
                if (GetAbilityScore(oPC,ABILITY_INTELLIGENCE,TRUE) >= 13) 
				{  
                    AddChoice("Saboteur", 34, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_34",  
                        "Whether it's for the money or for the thrill, you started your path with small pranks that led to increasingly sophisticated scams, staged accidents and a variety of risky and unscrupulous work. It's not your problem if someone is standing under that portcullis, you have a job to do..\n\nDoes this describe you?");  
                }
				// 35 Scout  
                if (GetAbilityScore(oPC,ABILITY_WISDOM,TRUE) >= 11) 
				{  
                    AddChoice("Scout", 35, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_35",  
                        "You have honed your skills in forward reconnaissance and have a knack for picking out silhouettes in the dark. Your skills have made you invaluable to hunting parties, adventurers, and even armies..\n\nDoes this describe you?");  
                }  
                // 36 Seldarine Priest  
                if (_CanBeSeldarinePriest(oPC)) 
				{  
                    AddChoice("Seldarine Priest", 36, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_36",  
                        "You are versed in the stories and folklore of the Elven people. Dedicated to the whimsical and aloof gods of the Elven Pantheon, you are tasked with caring for the spiritual needs of your people, and representing your gods to those who wonder about the deities of the Wealdath. You must preserve the culture of the Elves, because otherwise their beliefs could fade into obscurity..\n\nDoes this describe you?");  
                }				
                // 37 Shadow Weaver  
                if((GetAbilityScore(oPC,ABILITY_INTELLIGENCE,TRUE) > 12 || GetAbilityScore(oPC,ABILITY_CHARISMA,TRUE) > 12))  
				{  
                    AddChoice("Shadow Weaver", 37, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_37",  
                        "Since the beginning of your studies, you have craved more magical power than your masters could ever teach you. Your search for this power inevitably led towards the knowledge of the Shadow Weave and the blessed numbness of Her gift.\n\nDoes this describe you?");  
                }
				// 38 Sneak  
                if (GetAbilityScore(oPC,ABILITY_DEXTERITY,TRUE) >= 13) 
				{  
                    AddChoice("Sneak", 38, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_38",  
                        "You used to sneak into the kitchens of your favorite tavern for fun and a free meal - although you were caught more than once. Fortunately, you were young and the offense was overlooked, but you realized early on that you had an advantage in being light-footed.\n\nDoes this describe you?");  
                }  
                // 39 Soldier  
                if (_CanBeSoldier(oPC)) 
				{  
                    AddChoice("Soldier", 39, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_39",  
                        "Lacking the privilege that knights come with, you still aspired to become a great warrior in your youth. Since then, you have learned the cost of war as a footsoldier on the front lines. You hope to distinguish yourself further since being discharged, and this time maybe you'll be lucky enough to get a horse and some properly fitted armor.\n\nDoes this describe you?");  
                }  
                // 40  Spellfire Lineage  
                if (_CanHaveSpellfire(oPC)) 
				{  
                    AddChoice("Spellfire Lineage", 40, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_40",  
                        "he supernatural ability that is spellfire is thought by many to be unique to a single person each generation, but recent information indicates this is not the case. You know of this misconception firsthand, spellfire runs in your family and is a closely guarded secret. You were discouraged from even attempting to use this coveted ability and wouldn't know where to start even if you wished..\n\nDoes this describe you?");  
                }  
                // 41 Suldusk  
                if (_CanBeSuldusk(oPC)) 
				{  
                    AddChoice("Suldusk", 41, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_41",  
                        "You are a member of the reclusive elven tribe of wild Copper Elves, who are also referred to as Sy'Tel'Quessir. Named for the Sulduskoon River in the southern Wealdath, these elves reject arcane magic in any form and the only divine power they trust comes from the druidic circle. Isolated as they are, the Suldusk elves take a dim view of those who would settle the Wealdath by changing it.\n\nDoes this describe you?");  
                }  
                // 42 Talfirian  
                if (_CanBeTalfirian(oPC)) 
				{  
                    AddChoice("Talfirian", 42, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_42",  
                        "You come from an ancient Tethyrian bloodline that has been as often associated with nobility as it has been with the use of shadow magic, however discreet.\n\nDoes this describe you?");  
                }  
                // 43 Theocrat  
                if (_CanBeTheocrat(oPC)) 
				{  
                    AddChoice("Theocrat", 43, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_43",  
                        "Where courtly intrigues and ecclesiastical authority meet, you excel. You seem to have a knack for navigating the seas of intrigue and advising the people of influence around you of just what would please the gods most of all.\n\nDoes this describe you?");   
                }  
                // 44 Thunder Twin  
                if (_CanBeThunderTwin(oPC)) 
				{  
                    AddChoice("Thunder Twin", 44, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_44",  
                        "The Thunder Blessing or 'Thundering' took place in the Year of Thunder in the year 1306 DR, after Moradin called a council of the dwarven gods to find a way to increase the number of dwarves. All dwarven souls born in that year were split and placed in two bodies, so Thunder Twins share the same spirit between two individuals.\n\nDoes this describe you?");   
                }
                // 45 Traveller  
                if (GetIsPC(oPC)) 
				{  
                    AddChoice("Traveller", 45, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_45",  
                        "You have benefited from seeing much of the realm, whether it was circumstance or your own intention. You have a general knowledge of the Tethyrian duchies and have traveled the Tethir Road and the Trade Way.\n\nDoes this describe you?");  
                }
                // 46 Underdark Exile  
                if (_CanBeUnderdarkExile(oPC)) 
				{  
                    AddChoice("Underdark Exile", 46, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_46",  
                        "You were rejected from the society of the Underdark at one point in your past. You may bear a mark signifying this to others, or your escape might be more or less unknown to the cruel races that exiled you..\n\nDoes this describe you?");  
                }  
                // 47 Ward of the Triad 
                if (_CanBeTriadWard(oPC)) 
				{  
                    AddChoice("Ward of the Triad", 47, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_47",  
                        " You were an orphan entrusted to one of the faiths of the Triad to raise. As a result, you inherited the moral fiber of this organization and have known little else in your life. Your temple is your family and you feel raised by your deity and their clergy.\n\nDoes this describe you?");  
                }  
                // 48 Wary Swordknight  
                if (GetRacialType(oPC) == RACIAL_TYPE_HALFLING) 
				{  
                    AddChoice("Wary Swordknight", 48, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_48",  
                        "Wary Swordknights earned their place in Tethyr by protecting the people during the long civil war. These are halfing paladins within the ranks of Arvoreen's Marchers and their knighthood is assumed to carry all the merits afforded to their human counterparts. Commoners typically respond to these diminutive champions of Tethyr as if they were celebrities.\n\nDoes this describe you?");   
                }  
                // 49 Zhentarim
				if(GetIsPC(oPC))
				{
					AddChoice("Zhentarim", 49, oPC);  
					SetLocalString(oPC, "bg_dyn_text_49",  
						"The Black Network extended its reach across all of Faerun and even into the south. In Tethyr, Black Network merchants had to operate under special permits they had secured under fictitious names, but they still found a way to earn a piece of southern commerce even as they stuck their nose in other intrigues.\n\nDoes this describe you?");
				}      
                          
                MarkStageSetUp(nStage, oPC);            
                SetDefaultTokens();            
            }          
            else if (nStage == STAGE_CONFIRM)          
            {          
                int nSelected = GetLocalInt(oPC, "bg_selected");            
                SetHeader(GetBackgroundText(oPC, nSelected));                
                AddChoice("Yes!", nSelected, oPC);                 
                AddChoice("No...", -1, oPC);                     
                MarkStageSetUp(nStage, oPC);                
                SetDefaultTokens();                
            }          
        }            
        SetupTokens();            
    }          
    else if(nValue == DYNCONV_EXITED)          
    {          
        DelayCommand(0.1f, StartDynamicConversation("bg_deity_cv", oPC));          
    }          
    else if(nValue == DYNCONV_ABORTED)          
    {          
        // Handle abort if needed          
    }          
    else           
    {            
        int nChoice = GetChoice(oPC);            
        if (nStage == STAGE_LIST)           
        {            
            SetLocalInt(oPC, "bg_selected", nChoice);            
            SetStage(STAGE_CONFIRM, oPC);            
        }            
        else if (nStage == STAGE_CONFIRM)           
        {            
            if (nChoice >= 0)           
            {            
                // Handle background confirmation            
                switch (nChoice)        
                {				        
                    case 1:    
                    {    
                        SetPersistantLocalInt(oPC, "CC2", BACKGROUND_AFFLUENCE);    
                        SetPersistantLocalInt(oPC, "BG_Select", 1);    
                        SetLocalInt(oItem,"CC2",BACKGROUND_AFFLUENCE);    
                        SetLocalInt(oItem,"BG_Select",1);                            
                        break; // Affluence                                
                    }    
					case 2:
					{
						//sGrant = "bg_give_amn";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_AMN_TRAINED);
						SetPersistantLocalInt(oPC, "BG_Select", 2);
						SetLocalInt(oItem,"CC2",BACKGROUND_AMN_TRAINED);
						SetLocalInt(oItem,"BG_Select",2);						
						break;  // Amnian Trained						
					}
					case 3:
					{
						//sGrant = "bg_give_bra";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_BRAWLER);
						SetPersistantLocalInt(oPC, "BG_Select", 3);
						SetLocalInt(oItem,"CC2",BACKGROUND_BRAWLER);
						SetLocalInt(oItem,"BG_Select",3);						
						break;  // Brawler						
					}
					case 4:
					{
						//sGrant = "bg_give_calslave";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_CALISHITE_SLAVE);
						SetPersistantLocalInt(oPC, "BG_Select", 4);
						SetLocalInt(oItem,"CC2",BACKGROUND_CALISHITE_SLAVE);
						SetLocalInt(oItem,"BG_Select",4);						
						break;  // Calishite Slave						
					}
					case 5:
					{
						//sGrant = "bg_give_calish";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_CALISHITE_TRAINED);
						SetPersistantLocalInt(oPC, "BG_Select", 5);
						SetLocalInt(oItem,"CC2",BACKGROUND_CALISHITE_TRAINED);
						SetLocalInt(oItem,"BG_Select",5);						
						break;  // Calishite Trained						
					}					
					case 6:
					{
						//sGrant = "bg_give_carav";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_CARAVANNER);
						SetPersistantLocalInt(oPC, "BG_Select", 6);
						SetLocalInt(oItem,"CC2",BACKGROUND_CARAVANNER);
						SetLocalInt(oItem,"BG_Select",6);
						break;  // Caravaner
						
					}
					case 7:
					{
						//sGrant = "bg_give_church";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_CHURCH_ACOLYTE);
						SetPersistantLocalInt(oPC, "BG_Select", 7);
						SetLocalInt(oItem,"CC2",BACKGROUND_CHURCH_ACOLYTE);
						SetLocalInt(oItem,"BG_Select",7);
						break;  // Church Acolyte
						
					}
					case 8:
					{
						//sGrant = "bg_give_circle";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_CIRCLE_BORN);
						SetPersistantLocalInt(oPC, "BG_Select", 8);
						SetLocalInt(oItem,"CC2",BACKGROUND_CIRCLE_BORN);
						SetLocalInt(oItem,"BG_Select",8);
						break;	// Circle Born					
					}
					case 9:
					{					
						//sGrant = "bg_give_cosmo";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_COSMOPOLITAN);
						SetPersistantLocalInt(oPC, "BG_Select",9);
						SetLocalInt(oItem,"CC2",BACKGROUND_COSMOPOLITAN);
						SetLocalInt(oItem,"BG_Select",9);						
						break;  // Cosmopolitan
					}					
					case 10:
					{
						//sGrant = "bg_give_cru";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_CRUSADER);
						SetPersistantLocalInt(oPC, "BG_Select",10);
						SetLocalInt(oItem,"CC2",BACKGROUND_CRUSADER);
						SetLocalInt(oItem,"BG_Select",10);	
						break;  // Crusader						
					}
					case 11:
					{
						//sGrant = "bg_give_duelist";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_DUELIST);
						SetPersistantLocalInt(oPC, "BG_Select",11);
						SetLocalInt(oItem,"CC2",BACKGROUND_DUELIST);
						SetLocalInt(oItem,"BG_Select",11);	
						break;  // Duke's Warband						
					}					
					case 12:
					{
						//sGrant = "bg_give_dukewar";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_DUKES_WARBAND);
						SetPersistantLocalInt(oPC, "BG_Select",12);
						SetLocalInt(oItem,"CC2",BACKGROUND_DUKES_WARBAND);
						SetLocalInt(oItem,"BG_Select",12);	
						break;  // Duke's Warband						
					}
					case 13:
					{
						//sGrant = "bg_give_eldreth";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_ELDRETH_VELUUTHRA);
						SetPersistantLocalInt(oPC, "BG_Select",13);
						SetLocalInt(oItem,"CC2",BACKGROUND_ELDRETH_VELUUTHRA);
						SetLocalInt(oItem,"BG_Select",13);	
						break;  // Duke's Warband						
					}					

					case 14:
					{
						//sGrant = "bg_give_elmanesse";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_ELMANESSE_TRIBE);
						SetPersistantLocalInt(oPC, "BG_Select",14);
						SetLocalInt(oItem,"CC2",BACKGROUND_ELMANESSE_TRIBE);
						SetLocalInt(oItem,"BG_Select",14);
						break;  // Elmanesse Tribe
					}					
					case 15:
					{
						//sGrant = "bg_give_enlight";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_ENLIGHTENED_STUDENT);
						SetPersistantLocalInt(oPC, "BG_Select",15);
						SetLocalInt(oItem,"CC2",BACKGROUND_ENLIGHTENED_STUDENT);
						SetLocalInt(oItem,"BG_Select",15);
						break;  // Enlightened Student
					}
					
					case 16:
					{
						//sGrant = "bg_give_evang";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_EVANGELIST);
						SetPersistantLocalInt(oPC, "BG_Select",16);
						SetLocalInt(oItem,"CC2",BACKGROUND_EVANGELIST);
						SetLocalInt(oItem,"BG_Select",16);
						break;  // Evangelist
					}
					case 17:
					{
						//sGrant = "bg_give_forest";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_FORESTER);
						SetPersistantLocalInt(oPC, "BG_Select",17);
						SetLocalInt(oItem,"CC2",BACKGROUND_FORESTER);
						SetLocalInt(oItem,"BG_Select",17);
						break;  // Forester
					
					}
					case 18:
					{
						//sGrant = "bg_give_hardlabo";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_HARD_LABORER);
						SetPersistantLocalInt(oPC, "BG_Select",18);
						SetLocalInt(oItem,"CC2",BACKGROUND_HARD_LABORER);
						SetLocalInt(oItem,"BG_Select",18);
						break;  // Hard Laborer
					}
					case 19:
					{
						//sGrant = "bg_give_harem";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_HAREM_TRAINED);
						SetPersistantLocalInt(oPC, "BG_Select",19);
						SetLocalInt(oItem,"CC2",BACKGROUND_HAREM_TRAINED);
						SetLocalInt(oItem,"BG_Select",19);
						break;  // Harem-trained
					}					
					case 20:
					{
						//sGrant = "bg_give_harper";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_HARPER);
						SetPersistantLocalInt(oPC, "BG_Select",20);
						SetLocalInt(oItem,"CC2",BACKGROUND_HARPER);
						SetLocalInt(oItem,"BG_Select",20);
						break; // Harper Protégé 
					}
					case 21:
					{
						//sGrant = "bg_give_healer";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_HEALER);
						SetPersistantLocalInt(oPC, "BG_Select",21);
						SetLocalInt(oItem,"CC2",BACKGROUND_HEALER);
						SetLocalInt(oItem,"BG_Select",21);
						break; // Healer 
					}					
					case 22:
					{
						//sGrant = "bg_give_hedgem";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_HEDGEMAGE);
						SetPersistantLocalInt(oPC, "BG_Select",22);
						SetLocalInt(oItem,"CC2",BACKGROUND_HEDGEMAGE);
						SetLocalInt(oItem,"BG_Select",22);
						break; // Hedge Mage 
					}					
					case 23:
					{
						//sGrant = "bg_give_heir";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_HEIR_TO_THRONE);
						SetPersistantLocalInt(oPC, "BG_Select",23);
						SetLocalInt(oItem,"CC2",BACKGROUND_HEIR_TO_THRONE);
						SetLocalInt(oItem,"BG_Select",23);
						break;	// Heir to the Thone						
					}					
					case 24:
					{
						//sGrant = "bg_give_hmage";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_HIGH_MAGE);
						SetPersistantLocalInt(oPC, "BG_Select",24);
						SetLocalInt(oItem,"CC2",BACKGROUND_HIGH_MAGE);
						SetLocalInt(oItem,"BG_Select",24);
						break;  // High Mage
					}
					case 25:
					{
						//sGrant = "bg_give_knight";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_KNIGHT);
						SetPersistantLocalInt(oPC, "BG_Select",25);
						SetLocalInt(oItem,"CC2",BACKGROUND_KNIGHT);
						SetLocalInt(oItem,"BG_Select",25);
						break;  // Knight
					}
					case 26:
					{
						//sGrant = "bg_give_knightsq";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_KNIGHT_SQUIRE);
						SetPersistantLocalInt(oPC, "BG_Select",26);
						SetLocalInt(oItem,"CC2",BACKGROUND_KNIGHT_SQUIRE);
						SetLocalInt(oItem,"BG_Select",26);
						break;  // Knight Squire
					}
					case 27:
					{
						//sGrant = "bg_give_mendi";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_MENDICANT);
						SetPersistantLocalInt(oPC, "BG_Select",27);
						SetLocalInt(oItem,"CC2",BACKGROUND_MENDICANT);
						SetLocalInt(oItem,"BG_Select",27);
						break;  // Mendicant
					}
					case 28:
					{
						//sGrant = "bg_give_merch";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_MERCHANT);
						SetPersistantLocalInt(oPC, "BG_Select",28);
						SetLocalInt(oItem,"CC2",BACKGROUND_MERCHANT);
						SetLocalInt(oItem,"BG_Select",28);
						break;	// Merchant					
					}
					case 29:
					{
						//sGrant = "bg_give_metal";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_METALSMITH);
						SetPersistantLocalInt(oPC, "BG_Select",29);
						SetLocalInt(oItem,"CC2",BACKGROUND_METALSMITH);
						SetLocalInt(oItem,"BG_Select",29);
						break;	// Merchant					
					}
					
					case 30:
					{
						//sGrant = "bg_give_minstrel";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_MINSTREL);
						SetPersistantLocalInt(oPC, "BG_Select",30);
						SetLocalInt(oItem,"CC2",BACKGROUND_MINSTREL);
						SetLocalInt(oItem,"BG_Select",30);
						break;  // Minstrel
					}					
					case 31:
					{
						//sGrant = "bg_give_mordins";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_MORDINSAMMAN_PRIEST);
						SetPersistantLocalInt(oPC, "BG_Select",31);
						SetLocalInt(oItem,"CC2",BACKGROUND_MORDINSAMMAN_PRIEST);
						SetLocalInt(oItem,"BG_Select",31);
						break;  // Mordinsamman Priest
						
					}
					case 32:
					{
						//sGrant = "bg_give_natly";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_NAT_LYCAN);
						SetPersistantLocalInt(oPC, "BG_Select",32);
						SetLocalInt(oItem,"CC2",BACKGROUND_NAT_LYCAN);
						SetLocalInt(oItem,"BG_Select",32);
						break;  // Natural Lycanthrope
						
					}					
					case 33:
					{
						//sGrant = "bg_give_occult";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_NAT_LYCAN);
						SetPersistantLocalInt(oPC, "BG_Select",33);
						SetLocalInt(oItem,"CC2",BACKGROUND_NAT_LYCAN);
						SetLocalInt(oItem,"BG_Select",33);
						break;  // Occultist
					}					
					case 34:
					{
						//sGrant = "bg_give_saboteur";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_SABOTEUR);
						SetPersistantLocalInt(oPC, "BG_Select",34);
						SetLocalInt(oItem,"CC2",BACKGROUND_SABOTEUR);
						SetLocalInt(oItem,"BG_Select",34);
						break;  // Saboteur						
					}
					case 35:
					{
						//sGrant = "bg_give_scout";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_SCOUT);
						SetPersistantLocalInt(oPC, "BG_Select",35);
						SetLocalInt(oItem,"CC2",BACKGROUND_SCOUT);
						SetLocalInt(oItem,"BG_Select",35);
						break;						
					}
					case 36:
					{
						//sGrant = "bg_give_seldarine";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_SELDARINE_PRIEST);
						SetPersistantLocalInt(oPC, "BG_Select",36);
						SetLocalInt(oItem,"CC2",BACKGROUND_SELDARINE_PRIEST);
						SetLocalInt(oItem,"BG_Select",36);
						break;						
					}
 					case 37:
					{
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_SHADOW);
						SetPersistantLocalInt(oPC, "BG_Select",37);
						SetLocalInt(oItem,"CC2",BACKGROUND_SHADOW);
						SetLocalInt(oItem,"BG_Select",37);
						break;  // Shadow Weaver						
					}
 					case 38:
					{
						//sGrant = "bg_give_sneak";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_SNEAK);
						SetPersistantLocalInt(oPC, "BG_Select",38);
						SetLocalInt(oItem,"CC2",BACKGROUND_SNEAK);
						SetLocalInt(oItem,"BG_Select",38);
						break;  // Sneak						
					}
					case 39:
					{
						//sGrant = "bg_give_soldier";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_SOLDIER);
						SetPersistantLocalInt(oPC, "BG_Select",39);
						SetLocalInt(oItem,"CC2",BACKGROUND_SOLDIER);
						SetLocalInt(oItem,"BG_Select",39);
						break;  // Soldier
					}
					
					case 40:
					{
						//sGrant = "bg_give_spell";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_SPELLFIRE);
						SetPersistantLocalInt(oPC, "BG_Select",40);
						SetLocalInt(oItem,"CC2",BACKGROUND_SPELLFIRE);
						SetLocalInt(oItem,"BG_Select",40);
						break;  // Spellfire Lineage
					}					
					case 41:
					{
						//sGrant = "bg_give_suldusk";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_SULDUSK_TRIBE);
						SetPersistantLocalInt(oPC, "BG_Select",41);
						SetLocalInt(oItem,"CC2",BACKGROUND_SULDUSK_TRIBE);
						SetLocalInt(oItem,"BG_Select",41);
						break;  // Suldusk Tribe						
					}
					case 42:
					{
						//sGrant = "bg_give_talf";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_TALFIRIAN);
						SetPersistantLocalInt(oPC, "BG_Select",42);
						SetLocalInt(oItem,"CC2",BACKGROUND_TALFIRIAN);
						SetLocalInt(oItem,"BG_Select",42);
						break;  // Talfiran Lineage
					}					
					case 43:
					{
						//sGrant = "bg_give_theo";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_THEOCRAT);
						SetPersistantLocalInt(oPC, "BG_Select",43);
						SetLocalInt(oItem,"CC2",BACKGROUND_THEOCRAT);
						SetLocalInt(oItem,"BG_Select",43);
						break;  // Theocrat
					} 
					case 44:
					{
						//sGrant = "bg_give_thunder";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_THUNDER_TWIN);
						SetPersistantLocalInt(oPC, "BG_Select",44);
						SetLocalInt(oItem,"CC2",BACKGROUND_THUNDER_TWIN);
						SetLocalInt(oItem,"BG_Select",44);
						break;  // Thunder-twin
					}
					case 45:
					{
						//sGrant = "bg_give_travel";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_TRAVELER);
						SetPersistantLocalInt(oPC, "BG_Select",45);
						SetLocalInt(oItem,"CC2",BACKGROUND_TRAVELER);
						SetLocalInt(oItem,"BG_Select",45);
						break;  // Traveler
					}
					
					case 46:
					{
						//sGrant = "bg_give_udexile";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_UNDERDARK_EXILE);
						SetPersistantLocalInt(oPC, "BG_Select",46);
						SetLocalInt(oItem,"CC2",BACKGROUND_UNDERDARK_EXILE);
						SetLocalInt(oItem,"BG_Select",46);
						break;  // Underdark Exile
					}
					case 47:
					{
						//sGrant = "bg_give_ward";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_WARD_TRIAD);
						SetPersistantLocalInt(oPC, "BG_Select",47);
						SetLocalInt(oItem,"CC2",BACKGROUND_WARD_TRIAD);
						SetLocalInt(oItem,"BG_Select",47);
						break;  // Ward of the Triad
					}
					case 48:
					{
						//sGrant = "bg_give_warysk";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_WARY_SWORDKNIGHT);
						SetPersistantLocalInt(oPC, "BG_Select",48);
						SetLocalInt(oItem,"CC2",BACKGROUND_WARY_SWORDKNIGHT);
						SetLocalInt(oItem,"BG_Select",48);
						break;  // Wary Swordknight
					}
					case 49:
					{
						//sGrant = "bg_give_zhent";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_ZHENTARIM);
						SetPersistantLocalInt(oPC, "BG_Select",49);
						SetLocalInt(oItem,"CC2",BACKGROUND_ZHENTARIM);
						SetLocalInt(oItem,"BG_Select",49);
						break;  
					}         
                }					        
                SetPersistantLocalInt(oPC, "CC2_DONE", 1);              
                AllowExit(DYNCONV_EXIT_FORCE_EXIT, TRUE, oPC);             
            } 
			else 
			{              
                MarkStageNotSetUp(STAGE_LIST, oPC);    
                MarkStageNotSetUp(STAGE_CONFIRM, oPC);  // Add this line  
                SetStage(STAGE_LIST, oPC);              
            }              
        }            
    }            
}





/* void main()   
{    
    object oPC = GetPCSpeaker(); 
	object oItem = EnsurePlayerDataObject(oPC);	
    SendMessageToPC(oPC, "DEBUG: bg_background_cv main() entered");  
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);  
    int nStage = GetStage(oPC);  
	
	int nClass 		= GetPersistantLocalInt(oPC, "CC1");
	int nSubrace 	= GetPersistantLocalInt(oPC, "CC0");
	int nRacial		= GetRacialType(oPC);
      
    if (nValue == 0) return;    
      
    if (nValue == DYNCONV_SETUP_STAGE)   
    {    
        if (!GetIsStageSetUp(nStage, oPC))   
        {    
            if (nStage == STAGE_LIST)   
            {    
                SetHeader("Select your background:");    
                // 1 Affluent   
                if (_CanBeAffluent(oPC))   
                {    
                    AddChoice("Affluence", 1, oPC);    
                    SetLocalString(oPC, "bg_dyn_text_1",    
                        "You were born to a life of ease and indulgence. Only the harsh reality of war has jarred your insulated lifestyle. You must now step outside the comfort of your family's protection, although they will support your campaign from afar. You are tasked with establishing the next great familial holdings with your name and influence as your only tools..\n\nDoes this describe you?");    
                }  
				// 2 Amnian Trained
                if (_CanBeAmnianTrained(oPC)) 
				{  
                    AddChoice("Amnian Trained", 2, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_2",  
                        "You may have previously trained at the School of Wonder in Northern Tethyr along with most of the Cowled Wizards, or you may have been apprenticed to a member of that organization. While one was allowed to share their identity, most Cowled Wizards do so sparingly..\n\nDoes this describe you?");  
                }				
                // 3 Brawler  
                if (_CanBeBrawler(oPC)) 
				{  
                    AddChoice("Brawler", 3, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_3",  
                        "Your hands are calloused from battles that began in your youth. Whether you are still a fighter or have moved on to another station, your tendency to resolve things 'The Old Fashioned Way' remains..\n\nDoes this describe you?");  
                }  
                // 4 Calishite Slave  
				if(nClass != BACKGROUND_UPPER)
				{  
                    AddChoice("Calishite Slave", 4, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_4",  
                        "You may have a talent for story telling or entertainment, or have exotic looks that are considered a commodity. Either way, your talents are favored by Calishite nobles who brag to each other about how much you were bought and paid for. Escaping from Calimshan into Tethyr means that you can no longer be enslaved, and so there was no other path to take..\n\nDoes this describe you?");  
                }
                // 5 Calishite Trained  
				if(_CanBeCalishiteTrained(oPC))
				{  
                    AddChoice("Calishite Trained", 5, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_5",  
                        "Calishite trained mages have been tutored in academic environments by the most qualified of the profession. They favor spells from specialties they refer to as Fire and Air paths, where evocations are their mainstay..\n\nDoes this describe you?");  
                }  				
                // 6 Caravaner  
				if(nClass != BACKGROUND_UPPER)
				{  
                    AddChoice("Caravaner", 6, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_6",  
                        "You have the calloused hands of a hard worker and probably a tan to match. You've traveled the trade roads most of your life and seen various kingdoms over that time. Everywhere you go you can find work, until your back gives out.\n\nDoes this describe you?");  
                }  
                // 7 Church Acolyte 				
				if(GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) >= 1 && GetRacialType(oPC) != RACIAL_TYPE_HALFORC)
				{  
                    AddChoice("Church Orphan", 7, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_7",  
                        "For years, you have studied the dogma of your chosen deity, hoping to someday become ordained as a real priest or priestess. Because of your many years of dedication to this path, you expect to advance more quickly than others who are just starting out..\n\nDoes this describe you?");  
                }  
                // 8 Circle Born  
                if (_CanBeCircleBorn(oPC)) 
				{  
                    AddChoice("Circle Born", 8, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_6",  
                        "An orphan, you were found by or given to a Druidic grove to be raised. As a result, the grove and its creatures are like your family, and you are woefully out of touch with society for the most part..\n\nDoes this describe you?");  
                }  
                // 9 Cosmopolitan  
                if (_CanBeCosmopolitan(oPC)) 
				{  
                    AddChoice("Cosmopolitan", 9, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_9",  
                        "You have lived in many cities and know many cultures...\n\nDoes this describe you?");  
                }  
                // 10 Crusader  
				if((nSubrace != 1179 && nSubrace != 1183)) // No Dark Elf or Grey Dwarf
				{  
                    AddChoice("Crusader", 10, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_10",  
                        "Whether you have traveled a great distance or a short one, your church has sent you on a critical mission. The spiritual well-being of the people of Tethyr is at stake. Although not a knight, crusaders find many honors in their service to their faith and are the first to be considered for knighthood..\n\nDoes this describe you?");  
                } 
                // 11 Duelist  
				if(_CanBeDuelist(oPC))
				{  
                    AddChoice("Duelist", 11, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_11",  
                        "Undoubtedly drawing some influence from nearby Amn, you cannot turn down the excitement of the duel. Whether to defend your honor or simply for the fame, your skills have been honed in the art of single combat..\n\nDoes this describe you?");  
                }
			    // 12 Duke’s Warband  
                if (_CanBeDukesWarband(oPC)) 
				{  
                    AddChoice("Duke’s Warband", 12, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_12",  
                        "You are recognized in the duchy of Noromath as a lower ranking member of Duke Allain Kevanarial's warband. Instead of occupying a castle, the elven duke prefers to range through the woods of northern Tethyr, coordinating information and resources between several allied groups such as the Tethyrian Army, the Druidic Circle, and the elves of the Wealdath..\n\nDoes this describe you?");  
                }  
			    // 13  Eldreth Veluuthra  
                if (nRacial == RACIAL_TYPE_ELF) 
				{  
                    AddChoice(" Eldreth Veluuthra", 13, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_13",  
                        "You believe that elves are the superior race, and that they have a right as well as a duty to reclaim the Wealdath forest. You are angered or disgusted by the very existence of half elves and will strive to drive these abominations out of the unspoiled woods that remain..\n\nDoes this describe you?");  
                }
                // 14 Elmanesse  
                if (_CanBeElmanesse(oPC)) 
				{  
                    AddChoice("Elmanesse Tribe", 14, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_14",  
                        "You are a member of one of the last tribes of wild Green Elves, also known as Sy'Tel'Quessir. Some members of the Elmanesse have settled in Tethyr after they departed from Myth Drannor, and the Elmanesse are the most accepting of elven outsiders who might try to make a life in the Wealdath. They have even been known to accept half elves into their way of life..\n\nDoes this describe you?");  
                }  
                // 15 Enlightened Student
                if (_CanBeEnlightened(oPC)) 
				{  
                    AddChoice("Enlightened Student", 15, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_15",  
                        "You have been extensively trained in philosophy, mathematics and other contemporary subjects that the denizens of rural places consider to be as mysterious and otherworldly as magic.\n\nDoes this describe you?"); 
                }  
                // 16 Evangelist  
                if (_CanBeEvangelist(oPC)) 
				{  
                    AddChoice("Evangelist", 16, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_16",  
                        "You are adept at evading danger...\n\nDoes this describe you?");  
                }  
                // 17 Forester  
                if (_CanBeForester(oPC)) 
				{  
                    AddChoice("Forester", 17, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_17",  
                        "You grew up among the trees where a rugged lifestyle required knowledge of the woods and the animals that inhabit it. You are resourceful in situations requiring a worldly body of knowledge because of this experience.\n\nDoes this describe you?");   
                }  
                // 18 Hard Laborer 
                if (_CanBeHardLaborer(oPC)) 
				{  
                    AddChoice("Hard Laborer", 18, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_188",  
                        "For one reason or another, you ended up serving a sentence of forced hard labor - the most popular punishment in the land of Tethyr. Due to poor record keeping and a civil war, the reason has been lost to time and you are now free. \n\nDoes this describe you?");  
                }  
                // 19 Harem Trained
                if (_CanBeInHarem(oPC)) 
				{  
                    AddChoice("Harem Trained", 19, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_19",  
                        "Whether you were considered beautiful or particularly talented early on, your lack of pedigree and social status designated you as someone who would best serve your betters with your talents. You were given additional training and invested in, even if you are basically the property of someone else.\n\nDoes this describe you?");   
                }
                // 20 Harper Protégé
                if (GetIsPC(oPC)) 
				{  
                    AddChoice("Harper Protégé", 20, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_19",  
                        "You are an apprentice or the direct descendant of a Harper who at some point in time made you known to the organization. Whether you actually have an interest in furthering their goals, the Harpers usually have an interest in furthering yours, it seems.\n\nDoes this describe you?");   
                }				
                // 21 Healer  
                if ((GetAbilityScore(oPC,ABILITY_WISDOM,TRUE) >= 13)) 
				{  
                    AddChoice("Healer", 21, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_21",  
                        "You have always had the gift of caring for others. In your care, babies have been delivered and the pain of death has been eased. You found your abilities lacking in a larger world and seek the esoteric methods that would enhance your craft..\n\nDoes this describe you?");  
                }
				// 22 Hedge Mage  
                if ((GetAbilityScore(oPC,ABILITY_INTELLIGENCE,TRUE) >= 11 || GetAbilityScore(oPC,ABILITY_CHARISMA,TRUE) >= 11)) 
				{  
                    AddChoice("Hedge Mage", 22, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_22",  
                        "Fearing the discovery of your magical training, your lessons were limited to the time after your chores were completed. Although you were only given a most basic understanding of the laws governing magic, it is more than enough to cause trouble in nearby Amn - where the Art is strongly regulated..\n\nDoes this describe you?");  
                }  
                // 23 Heir to the Throne  
                if (nRacial == RACIAL_TYPE_DWARF) 
				{  
                    AddChoice(" Heir to the Throne", 23, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_23",  
                        "You were raised on tales of your ancestors and their heroism and bravery. You were nourished by the story that you were born to be a king and lead your people back to the former glory of Shanatar. The Wyrmskull Throne is said to belong to you and no one else, and you have never doubted this birth right..\n\nDoes this describe you?");  
                }  
                // 24 High Mage  
                if (_CanBeHighMage(oPC)) 
				{  
                    AddChoice("High Mage", 24, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_24",  
                        "You have studied the ancient secrets of Elven High Magic and Mythals. Although the complete formulas for Mythal creation are poorly understood in the current day and age, you received your training from aging elves to understand these essential secrets before they are lost forever.\n\nDoes this describe you?");  
                }
				// 25 Knight  
                if (_CanBeKnight(oPC)) 
				{  
                    AddChoice("Knight", 25, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_25",  
                        "Honor, chivalry, and duty to the crown are all that define you as a Tethyrian Knight. You may be bound to a particular lord, keep or temple but you live and die by the word of Queen-Monarch Zaranda Star, and the Tethyrian Knightly Code that she has decreed. Those who speak against the crown are your enemies and they must have their views challenged in a contest of steel. The Knights are arguably Tethyr's most influential class - assuming positions of power throughout the realm.\n\nDoes this describe you?");  
                }  
				// 26 Knight Squire
                if (_CanBeKnight(oPC)) 
				{  
                    AddChoice("Knight Squire", 26, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_26",  
                        "Not having the noble pedigree that most knights have put you at a disadvantage, and it seemed like every opportunity for knighthood during the Interregnum passed you over. Your best course now is to find a knight to train under and try to win recommendations that will better your odds when it comes time for Knighthoods to be granted again.\n\nDoes this describe you?");  
                }
				// 27 Mendicant  
				if((nClass == BACKGROUND_MIDDLE || nClass == BACKGROUND_UPPER) && GetRacialType(oPC) != RACIAL_TYPE_HALFORC && GetAbilityScore(oPC,ABILITY_INTELLIGENCE,TRUE) >= 11)
				{  
                    AddChoice("Mendicant", 27, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_27",  
                        "You have cast away the burden of all worldly belongings and enriched your spiritual being by doing so. You now travel the land, learning what it means to receive mercy from strangers as your vows force you to beg for your meals. This strange devotion earns you confusion from some and compassion from others..\n\nDoes this describe you?");  
                } 
                // 28 Merchant  
				if((nClass == BACKGROUND_MIDDLE || nClass == BACKGROUND_UPPER) && GetRacialType(oPC) != RACIAL_TYPE_HALFORC && GetAbilityScore(oPC,ABILITY_INTELLIGENCE,TRUE) >= 11)
				{  
                    AddChoice("Merchant", 28, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_28",  
                        "Whether it was the family trade or your very own enterprise, you have developed the skills to barter with even the shrewdest of Calishite traders. You hope to one day retire in wealth, yet enjoy the travel afforded by your profession..\n\nDoes this describe you?");  
                } 
				// 29 Metalsmith  
                if (_CanBeMetalsmith(oPC)) 
				{  
                    AddChoice("Metalsmith", 29, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_29",  
                        "The metalsmith holds an honored place among the society of Knights, where his craft is highly respected. Your short apprenticeship ended when the civil war began, as your mentor was called to service. You understand the process required to work iron, yet you hope to someday master the secret of steel.\n\nDoes this describe you?");  
                }  
                // 30 Minstrel  
                if (_CanBeMinstrel(oPC)) 
				{  
                    AddChoice("Minstrel", 30, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_30",  
                        "You have apprenticed under a skilled composer and learned the traditions of music, dance, and prose. It is your hope that Tethyr's noble, beleaguered people will inspire you to write your greatest work yet. Thus, you have set out in order to find the necessary subject of your inspiration.\n\nDoes this describe you?");  
                }  
                // 31 Mordinsamman Priest  
                if (_CanBeMordinsamman(oPC)) 
				{  
                    AddChoice("Mordinsamman Priest", 31, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_31",  
                        "You are the keeper of the dwarven pantheon of gods, and a last vestige of dwarven stories and folklore. You must be a champion for the place of dwarves in the world, which has been diminishing for generations. Although your gods are fading, they live within your feet that hammer the stone, your hands that mend dwarven bones, and your steel that cleaves the enemies of all dwarves..\n\nDoes this describe you?");  
                }
                // 32 Natural Lycanthrope  
                if (GetAbilityScore(oPC,ABILITY_WISDOM,TRUE) >= 11) 
				{  
                    AddChoice("Natural Lycanthrope", 32, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_32",  
                        "Perhaps unknown to even yourself, you have some dark secret running in your bloodline, a heritage you may have been running from all your life. By embracing it finally you may unlock some aspect of yourself you never imagined..\n\nDoes this describe you?");  
                } 				
                // 33 Occultist  
                if (GetAbilityScore(oPC,ABILITY_CHARISMA,TRUE) >= 11) 
				{  
                    AddChoice("Occultist", 33, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_33",  
                        " You have sacrificed everything near and dear to you for power. Ever since you were young you have studied ancient, dark grimoires for the unsavory and even macabre learnings they offered. Still, you seek something more...\n\nDoes this describe you?");  
                }  
                // 34 Saboteur  
                if (GetAbilityScore(oPC,ABILITY_INTELLIGENCE,TRUE) >= 13) 
				{  
                    AddChoice("Saboteur", 34, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_34",  
                        "Whether it's for the money or for the thrill, you started your path with small pranks that led to increasingly sophisticated scams, staged accidents and a variety of risky and unscrupulous work. It's not your problem if someone is standing under that portcullis, you have a job to do..\n\nDoes this describe you?");  
                }
				// 35 Scout  
                if (GetAbilityScore(oPC,ABILITY_WISDOM,TRUE) >= 11) 
				{  
                    AddChoice("Scout", 35, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_35",  
                        "You have honed your skills in forward reconnaissance and have a knack for picking out silhouettes in the dark. Your skills have made you invaluable to hunting parties, adventurers, and even armies..\n\nDoes this describe you?");  
                }  
                // 36 Seldarine Priest  
                if (_CanBeSeldarinePriest(oPC)) 
				{  
                    AddChoice("Seldarine Priest", 36, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_36",  
                        "You are versed in the stories and folklore of the Elven people. Dedicated to the whimsical and aloof gods of the Elven Pantheon, you are tasked with caring for the spiritual needs of your people, and representing your gods to those who wonder about the deities of the Wealdath. You must preserve the culture of the Elves, because otherwise their beliefs could fade into obscurity..\n\nDoes this describe you?");  
                }				
                // 37 Shadow Weaver  
                if((GetAbilityScore(oPC,ABILITY_INTELLIGENCE,TRUE) > 12 || GetAbilityScore(oPC,ABILITY_CHARISMA,TRUE) > 12))  
				{  
                    AddChoice("Shadow Weaver", 37, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_37",  
                        "Since the beginning of your studies, you have craved more magical power than your masters could ever teach you. Your search for this power inevitably led towards the knowledge of the Shadow Weave and the blessed numbness of Her gift.\n\nDoes this describe you?");  
                }
				// 38 Sneak  
                if (GetAbilityScore(oPC,ABILITY_DEXTERITY,TRUE) >= 13) 
				{  
                    AddChoice("Sneak", 38, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_38",  
                        "You used to sneak into the kitchens of your favorite tavern for fun and a free meal - although you were caught more than once. Fortunately, you were young and the offense was overlooked, but you realized early on that you had an advantage in being light-footed.\n\nDoes this describe you?");  
                }  
                // 39 Soldier  
                if (_CanBeSoldier(oPC)) 
				{  
                    AddChoice("Soldier", 39, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_39",  
                        "Lacking the privilege that knights come with, you still aspired to become a great warrior in your youth. Since then, you have learned the cost of war as a footsoldier on the front lines. You hope to distinguish yourself further since being discharged, and this time maybe you'll be lucky enough to get a horse and some properly fitted armor.\n\nDoes this describe you?");  
                }  
                // 40  Spellfire Lineage  
                if (_CanHaveSpellfire(oPC)) 
				{  
                    AddChoice("Spellfire Lineage", 40, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_40",  
                        "he supernatural ability that is spellfire is thought by many to be unique to a single person each generation, but recent information indicates this is not the case. You know of this misconception firsthand, spellfire runs in your family and is a closely guarded secret. You were discouraged from even attempting to use this coveted ability and wouldn't know where to start even if you wished..\n\nDoes this describe you?");  
                }  
                // 41 Suldusk  
                if (_CanBeSuldusk(oPC)) 
				{  
                    AddChoice("Suldusk", 41, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_41",  
                        "You are a member of the reclusive elven tribe of wild Copper Elves, who are also referred to as Sy'Tel'Quessir. Named for the Sulduskoon River in the southern Wealdath, these elves reject arcane magic in any form and the only divine power they trust comes from the druidic circle. Isolated as they are, the Suldusk elves take a dim view of those who would settle the Wealdath by changing it.\n\nDoes this describe you?");  
                }  
                // 42 Talfirian  
                if (_CanBeTalfirian(oPC)) 
				{  
                    AddChoice("Talfirian", 42, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_42",  
                        "You come from an ancient Tethyrian bloodline that has been as often associated with nobility as it has been with the use of shadow magic, however discreet.\n\nDoes this describe you?");  
                }  
                // 43 Theocrat  
                if (_CanBeTheocrat(oPC)) 
				{  
                    AddChoice("Theocrat", 43, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_43",  
                        "Where courtly intrigues and ecclesiastical authority meet, you excel. You seem to have a knack for navigating the seas of intrigue and advising the people of influence around you of just what would please the gods most of all.\n\nDoes this describe you?");   
                }  
                // 44 Thunder Twin  
                if (_CanBeThunderTwin(oPC)) 
				{  
                    AddChoice("Thunder Twin", 44, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_44",  
                        "The Thunder Blessing or 'Thundering' took place in the Year of Thunder in the year 1306 DR, after Moradin called a council of the dwarven gods to find a way to increase the number of dwarves. All dwarven souls born in that year were split and placed in two bodies, so Thunder Twins share the same spirit between two individuals.\n\nDoes this describe you?");   
                }
                // 45 Traveller  
                if (GetIsPC(oPC)) 
				{  
                    AddChoice("Traveller", 45, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_45",  
                        "You have benefited from seeing much of the realm, whether it was circumstance or your own intention. You have a general knowledge of the Tethyrian duchies and have traveled the Tethir Road and the Trade Way.\n\nDoes this describe you?");  
                }
                // 46 Underdark Exile  
                if (_CanBeUnderdarkExile(oPC)) 
				{  
                    AddChoice("Underdark Exile", 46, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_46",  
                        "You were rejected from the society of the Underdark at one point in your past. You may bear a mark signifying this to others, or your escape might be more or less unknown to the cruel races that exiled you..\n\nDoes this describe you?");  
                }  
                // 47 Ward of the Triad 
                if (_CanBeTriadWard(oPC)) 
				{  
                    AddChoice("Ward of the Triad", 47, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_47",  
                        " You were an orphan entrusted to one of the faiths of the Triad to raise. As a result, you inherited the moral fiber of this organization and have known little else in your life. Your temple is your family and you feel raised by your deity and their clergy.\n\nDoes this describe you?");  
                }  
                // 48 Wary Swordknight  
                if (GetRacialType(oPC) == RACIAL_TYPE_HALFLING) 
				{  
                    AddChoice("Wary Swordknight", 48, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_48",  
                        "Wary Swordknights earned their place in Tethyr by protecting the people during the long civil war. These are halfing paladins within the ranks of Arvoreen's Marchers and their knighthood is assumed to carry all the merits afforded to their human counterparts. Commoners typically respond to these diminutive champions of Tethyr as if they were celebrities.\n\nDoes this describe you?");   
                }  
                // 49 Zhentarim
				if(GetIsPC(oPC))
				{
					AddChoice("Zhentarim", 49, oPC);  
					SetLocalString(oPC, "bg_dyn_text_49",  
						"The Black Network extended its reach across all of Faerun and even into the south. In Tethyr, Black Network merchants had to operate under special permits they had secured under fictitious names, but they still found a way to earn a piece of southern commerce even as they stuck their nose in other intrigues.\n\nDoes this describe you?");
				} 
                  
                MarkStageSetUp(nStage, oPC);    
                SetDefaultTokens();    
            }  
            else if (nStage == STAGE_CONFIRM)  
            {  
                int nSelected = GetLocalInt(oPC, "bg_selected");    
                SetHeader(GetBackgroundText(oPC, nSelected));    
                AddChoice("Yes!", nSelected, oPC);    
                AddChoice("No...", -1, oPC);    
                MarkStageSetUp(nStage, oPC);    
                SetDefaultTokens();    
            }  
        }    
        SetupTokens();    
    }  
    else if (nValue == DYNCONV_EXITED)  
    {  
        // Start deity selection after background is complete  
        DelayCommand(0.1f, StartDynamicConversation("bg_deity_cv", oPC));  
    }  
    else   
    {    
        int nChoice = GetChoice(oPC);    
        if (nStage == STAGE_LIST)   
        {    
            SetLocalInt(oPC, "bg_selected", nChoice);    
            SetStage(STAGE_CONFIRM, oPC);    
        }    
        else if (nStage == STAGE_CONFIRM)   
        {    
            if (nChoice == -1) // "No" - return to list    
            {    
                SetStage(STAGE_LIST, oPC);    
            }    
            else // "Yes" - confirm background    
            {    
                string sGrant;    
                switch (nChoice)   
                {    
                    case 1:    
                    {    
                        SetPersistantLocalInt(oPC, "CC2", BACKGROUND_AFFLUENCE);    
                        SetPersistantLocalInt(oPC, "BG_Select", 1);    
                        SetLocalInt(oItem,"CC2",BACKGROUND_AFFLUENCE);    
                        SetLocalInt(oItem,"BG_Select",1);                            
                        break; // Affluence                                
                    }    
					case 2:
					{
						//sGrant = "bg_give_amn";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_AMN_TRAINED);
						SetPersistantLocalInt(oPC, "BG_Select", 2);
						SetLocalInt(oItem,"CC2",BACKGROUND_AMN_TRAINED);
						SetLocalInt(oItem,"BG_Select",2);						
						break;  // Amnian Trained						
					}
					case 3:
					{
						//sGrant = "bg_give_bra";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_BRAWLER);
						SetPersistantLocalInt(oPC, "BG_Select", 3);
						SetLocalInt(oItem,"CC2",BACKGROUND_BRAWLER);
						SetLocalInt(oItem,"BG_Select",3);						
						break;  // Brawler						
					}
					case 4:
					{
						//sGrant = "bg_give_calslave";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_CALISHITE_SLAVE);
						SetPersistantLocalInt(oPC, "BG_Select", 4);
						SetLocalInt(oItem,"CC2",BACKGROUND_CALISHITE_SLAVE);
						SetLocalInt(oItem,"BG_Select",4);						
						break;  // Calishite Slave						
					}
					case 5:
					{
						//sGrant = "bg_give_calish";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_CALISHITE_TRAINED);
						SetPersistantLocalInt(oPC, "BG_Select", 5);
						SetLocalInt(oItem,"CC2",BACKGROUND_CALISHITE_TRAINED);
						SetLocalInt(oItem,"BG_Select",5);						
						break;  // Calishite Trained						
					}					
					case 6:
					{
						//sGrant = "bg_give_carav";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_CARAVANNER);
						SetPersistantLocalInt(oPC, "BG_Select", 6);
						SetLocalInt(oItem,"CC2",BACKGROUND_CARAVANNER);
						SetLocalInt(oItem,"BG_Select",6);
						break;  // Caravaner
						
					}
					case 7:
					{
						//sGrant = "bg_give_church";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_CHURCH_ACOLYTE);
						SetPersistantLocalInt(oPC, "BG_Select", 7);
						SetLocalInt(oItem,"CC2",BACKGROUND_CHURCH_ACOLYTE);
						SetLocalInt(oItem,"BG_Select",7);
						break;  // Church Acolyte
						
					}
					case 8:
					{
						//sGrant = "bg_give_circle";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_CIRCLE_BORN);
						SetPersistantLocalInt(oPC, "BG_Select", 8);
						SetLocalInt(oItem,"CC2",BACKGROUND_CIRCLE_BORN);
						SetLocalInt(oItem,"BG_Select",8);
						break;	// Circle Born					
					}
					case 9:
					{					
						//sGrant = "bg_give_cosmo";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_COSMOPOLITAN);
						SetPersistantLocalInt(oPC, "BG_Select",9);
						SetLocalInt(oItem,"CC2",BACKGROUND_COSMOPOLITAN);
						SetLocalInt(oItem,"BG_Select",9);						
						break;  // Cosmopolitan
					}					
					case 10:
					{
						//sGrant = "bg_give_cru";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_CRUSADER);
						SetPersistantLocalInt(oPC, "BG_Select",10);
						SetLocalInt(oItem,"CC2",BACKGROUND_CRUSADER);
						SetLocalInt(oItem,"BG_Select",10);	
						break;  // Crusader						
					}
					case 11:
					{
						//sGrant = "bg_give_duelist";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_DUELIST);
						SetPersistantLocalInt(oPC, "BG_Select",11);
						SetLocalInt(oItem,"CC2",BACKGROUND_DUELIST);
						SetLocalInt(oItem,"BG_Select",11);	
						break;  // Duke's Warband						
					}					
					case 12:
					{
						//sGrant = "bg_give_dukewar";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_DUKES_WARBAND);
						SetPersistantLocalInt(oPC, "BG_Select",12);
						SetLocalInt(oItem,"CC2",BACKGROUND_DUKES_WARBAND);
						SetLocalInt(oItem,"BG_Select",12);	
						break;  // Duke's Warband						
					}
					case 13:
					{
						//sGrant = "bg_give_eldreth";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_ELDRETH_VELUUTHRA);
						SetPersistantLocalInt(oPC, "BG_Select",13);
						SetLocalInt(oItem,"CC2",BACKGROUND_ELDRETH_VELUUTHRA);
						SetLocalInt(oItem,"BG_Select",13);	
						break;  // Duke's Warband						
					}					

					case 14:
					{
						//sGrant = "bg_give_elmanesse";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_ELMANESSE_TRIBE);
						SetPersistantLocalInt(oPC, "BG_Select",14);
						SetLocalInt(oItem,"CC2",BACKGROUND_ELMANESSE_TRIBE);
						SetLocalInt(oItem,"BG_Select",14);
						break;  // Elmanesse Tribe
					}					
					case 15:
					{
						//sGrant = "bg_give_enlight";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_ENLIGHTENED_STUDENT);
						SetPersistantLocalInt(oPC, "BG_Select",15);
						SetLocalInt(oItem,"CC2",BACKGROUND_ENLIGHTENED_STUDENT);
						SetLocalInt(oItem,"BG_Select",15);
						break;  // Enlightened Student
					}
					
					case 16:
					{
						//sGrant = "bg_give_evang";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_EVANGELIST);
						SetPersistantLocalInt(oPC, "BG_Select",16);
						SetLocalInt(oItem,"CC2",BACKGROUND_EVANGELIST);
						SetLocalInt(oItem,"BG_Select",16);
						break;  // Evangelist
					}
					case 17:
					{
						//sGrant = "bg_give_forest";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_FORESTER);
						SetPersistantLocalInt(oPC, "BG_Select",17);
						SetLocalInt(oItem,"CC2",BACKGROUND_FORESTER);
						SetLocalInt(oItem,"BG_Select",17);
						break;  // Forester
					
					}
					case 18:
					{
						//sGrant = "bg_give_hardlabo";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_HARD_LABORER);
						SetPersistantLocalInt(oPC, "BG_Select",18);
						SetLocalInt(oItem,"CC2",BACKGROUND_HARD_LABORER);
						SetLocalInt(oItem,"BG_Select",18);
						break;  // Hard Laborer
					}
					case 19:
					{
						//sGrant = "bg_give_harem";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_HAREM_TRAINED);
						SetPersistantLocalInt(oPC, "BG_Select",19);
						SetLocalInt(oItem,"CC2",BACKGROUND_HAREM_TRAINED);
						SetLocalInt(oItem,"BG_Select",19);
						break;  // Harem-trained
					}					
					case 20:
					{
						//sGrant = "bg_give_harper";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_HARPER);
						SetPersistantLocalInt(oPC, "BG_Select",20);
						SetLocalInt(oItem,"CC2",BACKGROUND_HARPER);
						SetLocalInt(oItem,"BG_Select",20);
						break; // Harper Protégé 
					}
					case 21:
					{
						//sGrant = "bg_give_healer";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_HEALER);
						SetPersistantLocalInt(oPC, "BG_Select",21);
						SetLocalInt(oItem,"CC2",BACKGROUND_HEALER);
						SetLocalInt(oItem,"BG_Select",21);
						break; // Healer 
					}					
					case 22:
					{
						//sGrant = "bg_give_hedgem";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_HEDGEMAGE);
						SetPersistantLocalInt(oPC, "BG_Select",22);
						SetLocalInt(oItem,"CC2",BACKGROUND_HEDGEMAGE);
						SetLocalInt(oItem,"BG_Select",22);
						break; // Hedge Mage 
					}					
					case 23:
					{
						//sGrant = "bg_give_heir";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_HEIR_TO_THRONE);
						SetPersistantLocalInt(oPC, "BG_Select",23);
						SetLocalInt(oItem,"CC2",BACKGROUND_HEIR_TO_THRONE);
						SetLocalInt(oItem,"BG_Select",23);
						break;	// Heir to the Thone						
					}					
					case 24:
					{
						//sGrant = "bg_give_hmage";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_HIGH_MAGE);
						SetPersistantLocalInt(oPC, "BG_Select",24);
						SetLocalInt(oItem,"CC2",BACKGROUND_HIGH_MAGE);
						SetLocalInt(oItem,"BG_Select",24);
						break;  // High Mage
					}
					case 25:
					{
						//sGrant = "bg_give_knight";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_KNIGHT);
						SetPersistantLocalInt(oPC, "BG_Select",25);
						SetLocalInt(oItem,"CC2",BACKGROUND_KNIGHT);
						SetLocalInt(oItem,"BG_Select",25);
						break;  // Knight
					}
					case 26:
					{
						//sGrant = "bg_give_knightsq";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_KNIGHT_SQUIRE);
						SetPersistantLocalInt(oPC, "BG_Select",26);
						SetLocalInt(oItem,"CC2",BACKGROUND_KNIGHT_SQUIRE);
						SetLocalInt(oItem,"BG_Select",26);
						break;  // Knight Squire
					}
					case 27:
					{
						//sGrant = "bg_give_mendi";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_MENDICANT);
						SetPersistantLocalInt(oPC, "BG_Select",27);
						SetLocalInt(oItem,"CC2",BACKGROUND_MENDICANT);
						SetLocalInt(oItem,"BG_Select",27);
						break;  // Mendicant
					}
					case 28:
					{
						//sGrant = "bg_give_merch";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_MERCHANT);
						SetPersistantLocalInt(oPC, "BG_Select",28);
						SetLocalInt(oItem,"CC2",BACKGROUND_MERCHANT);
						SetLocalInt(oItem,"BG_Select",28);
						break;	// Merchant					
					}
					case 29:
					{
						//sGrant = "bg_give_metal";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_METALSMITH);
						SetPersistantLocalInt(oPC, "BG_Select",29);
						SetLocalInt(oItem,"CC2",BACKGROUND_METALSMITH);
						SetLocalInt(oItem,"BG_Select",29);
						break;	// Merchant					
					}
					
					case 30:
					{
						//sGrant = "bg_give_minstrel";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_MINSTREL);
						SetPersistantLocalInt(oPC, "BG_Select",30);
						SetLocalInt(oItem,"CC2",BACKGROUND_MINSTREL);
						SetLocalInt(oItem,"BG_Select",30);
						break;  // Minstrel
					}					
					case 31:
					{
						//sGrant = "bg_give_mordins";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_MORDINSAMMAN_PRIEST);
						SetPersistantLocalInt(oPC, "BG_Select",31);
						SetLocalInt(oItem,"CC2",BACKGROUND_MORDINSAMMAN_PRIEST);
						SetLocalInt(oItem,"BG_Select",31);
						break;  // Mordinsamman Priest
						
					}
					case 32:
					{
						//sGrant = "bg_give_natly";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_NAT_LYCAN);
						SetPersistantLocalInt(oPC, "BG_Select",32);
						SetLocalInt(oItem,"CC2",BACKGROUND_NAT_LYCAN);
						SetLocalInt(oItem,"BG_Select",32);
						break;  // Natural Lycanthrope
						
					}					
					case 33:
					{
						//sGrant = "bg_give_occult";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_NAT_LYCAN);
						SetPersistantLocalInt(oPC, "BG_Select",33);
						SetLocalInt(oItem,"CC2",BACKGROUND_NAT_LYCAN);
						SetLocalInt(oItem,"BG_Select",33);
						break;  // Occultist
					}					
					case 34:
					{
						//sGrant = "bg_give_saboteur";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_SABOTEUR);
						SetPersistantLocalInt(oPC, "BG_Select",34);
						SetLocalInt(oItem,"CC2",BACKGROUND_SABOTEUR);
						SetLocalInt(oItem,"BG_Select",34);
						break;  // Saboteur						
					}
					case 35:
					{
						sGrant = "bg_give_scout";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_SCOUT);
						SetPersistantLocalInt(oPC, "BG_Select",35);
						SetLocalInt(oItem,"CC2",BACKGROUND_SCOUT);
						SetLocalInt(oItem,"BG_Select",35);
						break;						
					}
					case 36:
					{
						//sGrant = "bg_give_seldarine";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_SELDARINE_PRIEST);
						SetPersistantLocalInt(oPC, "BG_Select",36);
						SetLocalInt(oItem,"CC2",BACKGROUND_SELDARINE_PRIEST);
						SetLocalInt(oItem,"BG_Select",36);
						break;						
					}
 					case 37:
					{
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_SHADOW);
						SetPersistantLocalInt(oPC, "BG_Select",37);
						SetLocalInt(oItem,"CC2",BACKGROUND_SHADOW);
						SetLocalInt(oItem,"BG_Select",37);
						break;  // Shadow Weaver						
					}
 					case 38:
					{
						//sGrant = "bg_give_sneak";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_SNEAK);
						SetPersistantLocalInt(oPC, "BG_Select",38);
						SetLocalInt(oItem,"CC2",BACKGROUND_SNEAK);
						SetLocalInt(oItem,"BG_Select",38);
						break;  // Sneak						
					}
					case 39:
					{
						//sGrant = "bg_give_soldier";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_SOLDIER);
						SetPersistantLocalInt(oPC, "BG_Select",39);
						SetLocalInt(oItem,"CC2",BACKGROUND_SOLDIER);
						SetLocalInt(oItem,"BG_Select",39);
						break;  // Soldier
					}
					
					case 40:
					{
						//sGrant = "bg_give_spell";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_SPELLFIRE);
						SetPersistantLocalInt(oPC, "BG_Select",40);
						SetLocalInt(oItem,"CC2",BACKGROUND_SPELLFIRE);
						SetLocalInt(oItem,"BG_Select",40);
						break;  // Spellfire Lineage
					}					
					case 41:
					{
						//sGrant = "bg_give_suldusk";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_SULDUSK_TRIBE);
						SetPersistantLocalInt(oPC, "BG_Select",41);
						SetLocalInt(oItem,"CC2",BACKGROUND_SULDUSK_TRIBE);
						SetLocalInt(oItem,"BG_Select",41);
						break;  // Suldusk Tribe						
					}
					case 42:
					{
						//sGrant = "bg_give_talf";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_TALFIRIAN);
						SetPersistantLocalInt(oPC, "BG_Select",42);
						SetLocalInt(oItem,"CC2",BACKGROUND_TALFIRIAN);
						SetLocalInt(oItem,"BG_Select",42);
						break;  // Talfiran Lineage
					}					
					case 43:
					{
						//sGrant = "bg_give_theo";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_THEOCRAT);
						SetPersistantLocalInt(oPC, "BG_Select",43);
						SetLocalInt(oItem,"CC2",BACKGROUND_THEOCRAT);
						SetLocalInt(oItem,"BG_Select",43);
						break;  // Theocrat
					} 
					case 44:
					{
						//sGrant = "bg_give_thunder";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_THUNDER_TWIN);
						SetPersistantLocalInt(oPC, "BG_Select",44);
						SetLocalInt(oItem,"CC2",BACKGROUND_THUNDER_TWIN);
						SetLocalInt(oItem,"BG_Select",44);
						break;  // Thunder-twin
					}
					case 45:
					{
						//sGrant = "bg_give_travel";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_TRAVELER);
						SetPersistantLocalInt(oPC, "BG_Select",45);
						SetLocalInt(oItem,"CC2",BACKGROUND_TRAVELER);
						SetLocalInt(oItem,"BG_Select",45);
						break;  // Traveler
					}
					
					case 46:
					{
						//sGrant = "bg_give_udexile";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_UNDERDARK_EXILE);
						SetPersistantLocalInt(oPC, "BG_Select",46);
						SetLocalInt(oItem,"CC2",BACKGROUND_UNDERDARK_EXILE);
						SetLocalInt(oItem,"BG_Select",46);
						break;  // Underdark Exile
					}
					case 47:
					{
						//sGrant = "bg_give_ward";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_WARD_TRIAD);
						SetPersistantLocalInt(oPC, "BG_Select",47);
						SetLocalInt(oItem,"CC2",BACKGROUND_WARD_TRIAD);
						SetLocalInt(oItem,"BG_Select",47);
						break;  // Ward of the Triad
					}
					case 48:
					{
						//sGrant = "bg_give_warysk";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_WARY_SWORDKNIGHT);
						SetPersistantLocalInt(oPC, "BG_Select",48);
						SetLocalInt(oItem,"CC2",BACKGROUND_WARY_SWORDKNIGHT);
						SetLocalInt(oItem,"BG_Select",48);
						break;  // Wary Swordknight
					}
					case 49:
					{
						//sGrant = "bg_give_zhent";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_ZHENTARIM);
						SetPersistantLocalInt(oPC, "BG_Select",49);
						SetLocalInt(oItem,"CC2",BACKGROUND_ZHENTARIM);
						SetLocalInt(oItem,"BG_Select",49);
						break;  
					}  
                }    
                SetPersistantLocalInt(oPC, "CC2_DONE", 1);  
                AllowExit(DYNCONV_EXIT_FORCE_EXIT, TRUE, oPC);				  
            }    
        }    
        SetStage(nStage, oPC);    
    }    
}
 */


/* void main() 
{  
    object oPC = GetPCSpeaker(); 
	object oItem = EnsurePlayerDataObject(oPC);	
    SendMessageToPC(oPC, "DEBUG: bg_background_cv main() entered");  
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);  
    int nStage = GetStage(oPC);  
	
	int nClass 		= GetPersistantLocalInt(oPC, "CC1");
	int nSubrace 	= GetPersistantLocalInt(oPC, "CC0");
	int nRacial		= GetRacialType(oPC);
  
    // Required guard: abort if nValue is 0 (error/invalid call)  
    if (nValue == 0) return;  
  
    if (nValue == DYNCONV_SETUP_STAGE) 
	{  
        if (!GetIsStageSetUp(nStage, oPC)) 
		{  
            if (nStage == STAGE_LIST) 
			{  
                SetHeader("Select your background:");  
                // 1 Affluent 
                if (_CanBeAffluent(oPC)) 
				{  
                    AddChoice("Affluence", 1, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_1",  
                        "You were born to a life of ease and indulgence. Only the harsh reality of war has jarred your insulated lifestyle. You must now step outside the comfort of your family's protection, although they will support your campaign from afar. You are tasked with establishing the next great familial holdings with your name and influence as your only tools..\n\nDoes this describe you?");  
                }
				// 2 Amnian Trained
                if (_CanBeAmnianTrained(oPC)) 
				{  
                    AddChoice("Amnian Trained", 2, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_2",  
                        "You may have previously trained at the School of Wonder in Northern Tethyr along with most of the Cowled Wizards, or you may have been apprenticed to a member of that organization. While one was allowed to share their identity, most Cowled Wizards do so sparingly..\n\nDoes this describe you?");  
                }				
                // 3 Brawler  
                if (_CanBeBrawler(oPC)) 
				{  
                    AddChoice("Brawler", 3, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_3",  
                        "Your hands are calloused from battles that began in your youth. Whether you are still a fighter or have moved on to another station, your tendency to resolve things 'The Old Fashioned Way' remains..\n\nDoes this describe you?");  
                }  
                // 4 Calishite Slave  
				if(nClass != BACKGROUND_UPPER)
				{  
                    AddChoice("Calishite Slave", 4, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_4",  
                        "You may have a talent for story telling or entertainment, or have exotic looks that are considered a commodity. Either way, your talents are favored by Calishite nobles who brag to each other about how much you were bought and paid for. Escaping from Calimshan into Tethyr means that you can no longer be enslaved, and so there was no other path to take..\n\nDoes this describe you?");  
                }
                // 5 Calishite Trained  
				if(_CanBeCalishiteTrained(oPC))
				{  
                    AddChoice("Calishite Trained", 5, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_5",  
                        "Calishite trained mages have been tutored in academic environments by the most qualified of the profession. They favor spells from specialties they refer to as Fire and Air paths, where evocations are their mainstay..\n\nDoes this describe you?");  
                }  				
                // 6 Caravaner  
				if(nClass != BACKGROUND_UPPER)
				{  
                    AddChoice("Caravaner", 6, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_6",  
                        "You have the calloused hands of a hard worker and probably a tan to match. You've traveled the trade roads most of your life and seen various kingdoms over that time. Everywhere you go you can find work, until your back gives out.\n\nDoes this describe you?");  
                }  
                // 7 Church Acolyte 				
				if(GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) >= 1 && GetRacialType(oPC) != RACIAL_TYPE_HALFORC)
				{  
                    AddChoice("Church Orphan", 7, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_7",  
                        "For years, you have studied the dogma of your chosen deity, hoping to someday become ordained as a real priest or priestess. Because of your many years of dedication to this path, you expect to advance more quickly than others who are just starting out..\n\nDoes this describe you?");  
                }  
                // 8 Circle Born  
                if (_CanBeCircleBorn(oPC)) 
				{  
                    AddChoice("Circle Born", 8, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_6",  
                        "An orphan, you were found by or given to a Druidic grove to be raised. As a result, the grove and its creatures are like your family, and you are woefully out of touch with society for the most part..\n\nDoes this describe you?");  
                }  
                // 9 Cosmopolitan  
                if (_CanBeCosmopolitan(oPC)) 
				{  
                    AddChoice("Cosmopolitan", 9, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_9",  
                        "You have lived in many cities and know many cultures...\n\nDoes this describe you?");  
                }  
                // 10 Crusader  
				if((nSubrace != 1179 && nSubrace != 1183)) // No Dark Elf or Grey Dwarf
				{  
                    AddChoice("Crusader", 10, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_10",  
                        "Whether you have traveled a great distance or a short one, your church has sent you on a critical mission. The spiritual well-being of the people of Tethyr is at stake. Although not a knight, crusaders find many honors in their service to their faith and are the first to be considered for knighthood..\n\nDoes this describe you?");  
                } 
                // 11 Duelist  
				if(_CanBeDuelist(oPC))
				{  
                    AddChoice("Duelist", 11, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_11",  
                        "Undoubtedly drawing some influence from nearby Amn, you cannot turn down the excitement of the duel. Whether to defend your honor or simply for the fame, your skills have been honed in the art of single combat..\n\nDoes this describe you?");  
                }
			    // 12 Duke’s Warband  
                if (_CanBeDukesWarband(oPC)) 
				{  
                    AddChoice("Duke’s Warband", 12, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_12",  
                        "You are recognized in the duchy of Noromath as a lower ranking member of Duke Allain Kevanarial's warband. Instead of occupying a castle, the elven duke prefers to range through the woods of northern Tethyr, coordinating information and resources between several allied groups such as the Tethyrian Army, the Druidic Circle, and the elves of the Wealdath..\n\nDoes this describe you?");  
                }  
			    // 13  Eldreth Veluuthra  
                if (nRacial == RACIAL_TYPE_ELF) 
				{  
                    AddChoice(" Eldreth Veluuthra", 13, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_13",  
                        "You believe that elves are the superior race, and that they have a right as well as a duty to reclaim the Wealdath forest. You are angered or disgusted by the very existence of half elves and will strive to drive these abominations out of the unspoiled woods that remain..\n\nDoes this describe you?");  
                }
                // 14 Elmanesse  
                if (_CanBeElmanesse(oPC)) 
				{  
                    AddChoice("Elmanesse Tribe", 14, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_14",  
                        "You are a member of one of the last tribes of wild Green Elves, also known as Sy'Tel'Quessir. Some members of the Elmanesse have settled in Tethyr after they departed from Myth Drannor, and the Elmanesse are the most accepting of elven outsiders who might try to make a life in the Wealdath. They have even been known to accept half elves into their way of life..\n\nDoes this describe you?");  
                }  
                // 15 Enlightened Student
                if (_CanBeEnlightened(oPC)) 
				{  
                    AddChoice("Enlightened Student", 15, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_15",  
                        "You have been extensively trained in philosophy, mathematics and other contemporary subjects that the denizens of rural places consider to be as mysterious and otherworldly as magic.\n\nDoes this describe you?"); 
                }  
                // 16 Evangelist  
                if (_CanBeEvangelist(oPC)) 
				{  
                    AddChoice("Evangelist", 16, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_16",  
                        "You are adept at evading danger...\n\nDoes this describe you?");  
                }  
                // 17 Forester  
                if (_CanBeForester(oPC)) 
				{  
                    AddChoice("Forester", 17, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_17",  
                        "You grew up among the trees where a rugged lifestyle required knowledge of the woods and the animals that inhabit it. You are resourceful in situations requiring a worldly body of knowledge because of this experience.\n\nDoes this describe you?");   
                }  
                // 18 Hard Laborer 
                if (_CanBeHardLaborer(oPC)) 
				{  
                    AddChoice("Hard Laborer", 18, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_188",  
                        "For one reason or another, you ended up serving a sentence of forced hard labor - the most popular punishment in the land of Tethyr. Due to poor record keeping and a civil war, the reason has been lost to time and you are now free. \n\nDoes this describe you?");  
                }  
                // 19 Harem Trained
                if (_CanBeInHarem(oPC)) 
				{  
                    AddChoice("Harem Trained", 19, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_19",  
                        "Whether you were considered beautiful or particularly talented early on, your lack of pedigree and social status designated you as someone who would best serve your betters with your talents. You were given additional training and invested in, even if you are basically the property of someone else.\n\nDoes this describe you?");   
                }
                // 20 Harper Protégé
                if (GetIsPC(oPC)) 
				{  
                    AddChoice("Harper Protégé", 20, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_19",  
                        "You are an apprentice or the direct descendant of a Harper who at some point in time made you known to the organization. Whether you actually have an interest in furthering their goals, the Harpers usually have an interest in furthering yours, it seems.\n\nDoes this describe you?");   
                }				
                // 21 Healer  
                if ((GetAbilityScore(oPC,ABILITY_WISDOM,TRUE) >= 13)) 
				{  
                    AddChoice("Healer", 21, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_21",  
                        "You have always had the gift of caring for others. In your care, babies have been delivered and the pain of death has been eased. You found your abilities lacking in a larger world and seek the esoteric methods that would enhance your craft..\n\nDoes this describe you?");  
                }
				// 22 Hedge Mage  
                if ((GetAbilityScore(oPC,ABILITY_INTELLIGENCE,TRUE) >= 11 || GetAbilityScore(oPC,ABILITY_CHARISMA,TRUE) >= 11)) 
				{  
                    AddChoice("Hedge Mage", 22, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_22",  
                        "Fearing the discovery of your magical training, your lessons were limited to the time after your chores were completed. Although you were only given a most basic understanding of the laws governing magic, it is more than enough to cause trouble in nearby Amn - where the Art is strongly regulated..\n\nDoes this describe you?");  
                }  
                // 23 Heir to the Throne  
                if (nRacial == RACIAL_TYPE_DWARF) 
				{  
                    AddChoice(" Heir to the Throne", 23, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_23",  
                        "You were raised on tales of your ancestors and their heroism and bravery. You were nourished by the story that you were born to be a king and lead your people back to the former glory of Shanatar. The Wyrmskull Throne is said to belong to you and no one else, and you have never doubted this birth right..\n\nDoes this describe you?");  
                }  
                // 24 High Mage  
                if (_CanBeHighMage(oPC)) 
				{  
                    AddChoice("High Mage", 24, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_24",  
                        "You have studied the ancient secrets of Elven High Magic and Mythals. Although the complete formulas for Mythal creation are poorly understood in the current day and age, you received your training from aging elves to understand these essential secrets before they are lost forever.\n\nDoes this describe you?");  
                }
				// 25 Knight  
                if (_CanBeKnight(oPC)) 
				{  
                    AddChoice("Knight", 25, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_25",  
                        "Honor, chivalry, and duty to the crown are all that define you as a Tethyrian Knight. You may be bound to a particular lord, keep or temple but you live and die by the word of Queen-Monarch Zaranda Star, and the Tethyrian Knightly Code that she has decreed. Those who speak against the crown are your enemies and they must have their views challenged in a contest of steel. The Knights are arguably Tethyr's most influential class - assuming positions of power throughout the realm.\n\nDoes this describe you?");  
                }  
				// 26 Knight Squire
                if (_CanBeKnight(oPC)) 
				{  
                    AddChoice("Knight Squire", 26, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_26",  
                        "Not having the noble pedigree that most knights have put you at a disadvantage, and it seemed like every opportunity for knighthood during the Interregnum passed you over. Your best course now is to find a knight to train under and try to win recommendations that will better your odds when it comes time for Knighthoods to be granted again.\n\nDoes this describe you?");  
                }
				// 27 Mendicant  
				if((nClass == BACKGROUND_MIDDLE || nClass == BACKGROUND_UPPER) && GetRacialType(oPC) != RACIAL_TYPE_HALFORC && GetAbilityScore(oPC,ABILITY_INTELLIGENCE,TRUE) >= 11)
				{  
                    AddChoice("Mendicant", 27, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_27",  
                        "You have cast away the burden of all worldly belongings and enriched your spiritual being by doing so. You now travel the land, learning what it means to receive mercy from strangers as your vows force you to beg for your meals. This strange devotion earns you confusion from some and compassion from others..\n\nDoes this describe you?");  
                } 
                // 28 Merchant  
				if((nClass == BACKGROUND_MIDDLE || nClass == BACKGROUND_UPPER) && GetRacialType(oPC) != RACIAL_TYPE_HALFORC && GetAbilityScore(oPC,ABILITY_INTELLIGENCE,TRUE) >= 11)
				{  
                    AddChoice("Merchant", 28, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_28",  
                        "Whether it was the family trade or your very own enterprise, you have developed the skills to barter with even the shrewdest of Calishite traders. You hope to one day retire in wealth, yet enjoy the travel afforded by your profession..\n\nDoes this describe you?");  
                } 
				// 29 Metalsmith  
                if (_CanBeMetalsmith(oPC)) 
				{  
                    AddChoice("Metalsmith", 29, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_29",  
                        "The metalsmith holds an honored place among the society of Knights, where his craft is highly respected. Your short apprenticeship ended when the civil war began, as your mentor was called to service. You understand the process required to work iron, yet you hope to someday master the secret of steel.\n\nDoes this describe you?");  
                }  
                // 30 Minstrel  
                if (_CanBeMinstrel(oPC)) 
				{  
                    AddChoice("Minstrel", 30, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_30",  
                        "You have apprenticed under a skilled composer and learned the traditions of music, dance, and prose. It is your hope that Tethyr's noble, beleaguered people will inspire you to write your greatest work yet. Thus, you have set out in order to find the necessary subject of your inspiration.\n\nDoes this describe you?");  
                }  
                // 31 Mordinsamman Priest  
                if (_CanBeMordinsamman(oPC)) 
				{  
                    AddChoice("Mordinsamman Priest", 31, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_31",  
                        "You are the keeper of the dwarven pantheon of gods, and a last vestige of dwarven stories and folklore. You must be a champion for the place of dwarves in the world, which has been diminishing for generations. Although your gods are fading, they live within your feet that hammer the stone, your hands that mend dwarven bones, and your steel that cleaves the enemies of all dwarves..\n\nDoes this describe you?");  
                }
                // 32 Natural Lycanthrope  
                if (GetAbilityScore(oPC,ABILITY_WISDOM,TRUE) >= 11) 
				{  
                    AddChoice("Natural Lycanthrope", 32, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_32",  
                        "Perhaps unknown to even yourself, you have some dark secret running in your bloodline, a heritage you may have been running from all your life. By embracing it finally you may unlock some aspect of yourself you never imagined..\n\nDoes this describe you?");  
                } 				
                // 33 Occultist  
                if (GetAbilityScore(oPC,ABILITY_CHARISMA,TRUE) >= 11) 
				{  
                    AddChoice("Occultist", 33, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_33",  
                        " You have sacrificed everything near and dear to you for power. Ever since you were young you have studied ancient, dark grimoires for the unsavory and even macabre learnings they offered. Still, you seek something more...\n\nDoes this describe you?");  
                }  
                // 34 Saboteur  
                if (GetAbilityScore(oPC,ABILITY_INTELLIGENCE,TRUE) >= 13) 
				{  
                    AddChoice("Saboteur", 34, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_34",  
                        "Whether it's for the money or for the thrill, you started your path with small pranks that led to increasingly sophisticated scams, staged accidents and a variety of risky and unscrupulous work. It's not your problem if someone is standing under that portcullis, you have a job to do..\n\nDoes this describe you?");  
                }
				// 35 Scout  
                if (GetAbilityScore(oPC,ABILITY_WISDOM,TRUE) >= 11) 
				{  
                    AddChoice("Scout", 35, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_35",  
                        "You have honed your skills in forward reconnaissance and have a knack for picking out silhouettes in the dark. Your skills have made you invaluable to hunting parties, adventurers, and even armies..\n\nDoes this describe you?");  
                }  
                // 36 Seldarine Priest  
                if (_CanBeSeldarinePriest(oPC)) 
				{  
                    AddChoice("Seldarine Priest", 36, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_36",  
                        "You are versed in the stories and folklore of the Elven people. Dedicated to the whimsical and aloof gods of the Elven Pantheon, you are tasked with caring for the spiritual needs of your people, and representing your gods to those who wonder about the deities of the Wealdath. You must preserve the culture of the Elves, because otherwise their beliefs could fade into obscurity..\n\nDoes this describe you?");  
                }				
                // 37 Shadow Weaver  
                if((GetAbilityScore(oPC,ABILITY_INTELLIGENCE,TRUE) > 12 || GetAbilityScore(oPC,ABILITY_CHARISMA,TRUE) > 12))  
				{  
                    AddChoice("Shadow Weaver", 37, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_37",  
                        "Since the beginning of your studies, you have craved more magical power than your masters could ever teach you. Your search for this power inevitably led towards the knowledge of the Shadow Weave and the blessed numbness of Her gift.\n\nDoes this describe you?");  
                }
				// 38 Sneak  
                if (GetAbilityScore(oPC,ABILITY_DEXTERITY,TRUE) >= 13) 
				{  
                    AddChoice("Sneak", 38, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_38",  
                        "You used to sneak into the kitchens of your favorite tavern for fun and a free meal - although you were caught more than once. Fortunately, you were young and the offense was overlooked, but you realized early on that you had an advantage in being light-footed.\n\nDoes this describe you?");  
                }  
                // 39 Soldier  
                if (_CanBeSoldier(oPC)) 
				{  
                    AddChoice("Soldier", 39, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_39",  
                        "Lacking the privilege that knights come with, you still aspired to become a great warrior in your youth. Since then, you have learned the cost of war as a footsoldier on the front lines. You hope to distinguish yourself further since being discharged, and this time maybe you'll be lucky enough to get a horse and some properly fitted armor.\n\nDoes this describe you?");  
                }  
                // 40  Spellfire Lineage  
                if (_CanHaveSpellfire(oPC)) 
				{  
                    AddChoice("Spellfire Lineage", 40, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_40",  
                        "he supernatural ability that is spellfire is thought by many to be unique to a single person each generation, but recent information indicates this is not the case. You know of this misconception firsthand, spellfire runs in your family and is a closely guarded secret. You were discouraged from even attempting to use this coveted ability and wouldn't know where to start even if you wished..\n\nDoes this describe you?");  
                }  
                // 41 Suldusk  
                if (_CanBeSuldusk(oPC)) 
				{  
                    AddChoice("Suldusk", 41, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_41",  
                        "You are a member of the reclusive elven tribe of wild Copper Elves, who are also referred to as Sy'Tel'Quessir. Named for the Sulduskoon River in the southern Wealdath, these elves reject arcane magic in any form and the only divine power they trust comes from the druidic circle. Isolated as they are, the Suldusk elves take a dim view of those who would settle the Wealdath by changing it.\n\nDoes this describe you?");  
                }  
                // 42 Talfirian  
                if (_CanBeTalfirian(oPC)) 
				{  
                    AddChoice("Talfirian", 42, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_42",  
                        "You come from an ancient Tethyrian bloodline that has been as often associated with nobility as it has been with the use of shadow magic, however discreet.\n\nDoes this describe you?");  
                }  
                // 43 Theocrat  
                if (_CanBeTheocrat(oPC)) 
				{  
                    AddChoice("Theocrat", 43, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_43",  
                        "Where courtly intrigues and ecclesiastical authority meet, you excel. You seem to have a knack for navigating the seas of intrigue and advising the people of influence around you of just what would please the gods most of all.\n\nDoes this describe you?");   
                }  
                // 44 Thunder Twin  
                if (_CanBeThunderTwin(oPC)) 
				{  
                    AddChoice("Thunder Twin", 44, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_44",  
                        "The Thunder Blessing or 'Thundering' took place in the Year of Thunder in the year 1306 DR, after Moradin called a council of the dwarven gods to find a way to increase the number of dwarves. All dwarven souls born in that year were split and placed in two bodies, so Thunder Twins share the same spirit between two individuals.\n\nDoes this describe you?");   
                }
                // 45 Traveller  
                if (GetIsPC(oPC)) 
				{  
                    AddChoice("Traveller", 45, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_45",  
                        "You have benefited from seeing much of the realm, whether it was circumstance or your own intention. You have a general knowledge of the Tethyrian duchies and have traveled the Tethir Road and the Trade Way.\n\nDoes this describe you?");  
                }
                // 46 Underdark Exile  
                if (_CanBeUnderdarkExile(oPC)) 
				{  
                    AddChoice("Underdark Exile", 46, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_46",  
                        "You were rejected from the society of the Underdark at one point in your past. You may bear a mark signifying this to others, or your escape might be more or less unknown to the cruel races that exiled you..\n\nDoes this describe you?");  
                }  
                // 47 Ward of the Triad 
                if (_CanBeTriadWard(oPC)) 
				{  
                    AddChoice("Ward of the Triad", 47, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_47",  
                        " You were an orphan entrusted to one of the faiths of the Triad to raise. As a result, you inherited the moral fiber of this organization and have known little else in your life. Your temple is your family and you feel raised by your deity and their clergy.\n\nDoes this describe you?");  
                }  
                // 48 Wary Swordknight  
                if (GetRacialType(oPC) == RACIAL_TYPE_HALFLING) 
				{  
                    AddChoice("Wary Swordknight", 48, oPC);  
                    SetLocalString(oPC, "bg_dyn_text_48",  
                        "Wary Swordknights earned their place in Tethyr by protecting the people during the long civil war. These are halfing paladins within the ranks of Arvoreen's Marchers and their knighthood is assumed to carry all the merits afforded to their human counterparts. Commoners typically respond to these diminutive champions of Tethyr as if they were celebrities.\n\nDoes this describe you?");   
                }  
                // 49 Zhentarim
				if(GetIsPC(oPC))
				{
					AddChoice("Zhentarim", 49, oPC);  
					SetLocalString(oPC, "bg_dyn_text_49",  
						"The Black Network extended its reach across all of Faerun and even into the south. In Tethyr, Black Network merchants had to operate under special permits they had secured under fictitious names, but they still found a way to earn a piece of southern commerce even as they stuck their nose in other intrigues.\n\nDoes this describe you?");
				}
                MarkStageSetUp(nStage, oPC);  
                SetDefaultTokens();  
            }
		}  
        else if (nStage == STAGE_CONFIRM)  
        {  
            int nSelected = GetLocalInt(oPC, "bg_selected");  
            string sText = GetLocalString(oPC, "bg_dyn_text_" + IntToString(nSelected));  
            SetHeader(sText);  
            AddChoice("Yes!", nSelected, oPC);  
            AddChoice("No...", -1, oPC);  
            MarkStageSetUp(nStage, oPC);  
            SetDefaultTokens();  
        }  
        // Do token setup once per SETUP_STAGE  
        SetupTokens();  
    }  
    else 
	{  
        int nChoice = GetChoice(oPC);  
        if (nStage == STAGE_LIST) 
		{  
            SetLocalInt(oPC, "bg_selected", nChoice);  
            SetStage(STAGE_CONFIRM, oPC);  
        }  
        else if (nStage == STAGE_CONFIRM) 
		{  
            if (nChoice >= 0) {  
                string sGrant;  
                switch (nChoice) 
				{  
					case 1:
					{
						//sGrant = "bg_give_afl";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_AFFLUENCE);
						SetPersistantLocalInt(oPC, "BG_Select", 1);
						SetLocalInt(oItem,"CC2",BACKGROUND_AFFLUENCE);
						SetLocalInt(oItem,"BG_Select",1);						
						break; // Affluence
					}
					case 2:
					{
						//sGrant = "bg_give_amn";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_AMN_TRAINED);
						SetPersistantLocalInt(oPC, "BG_Select", 2);
						SetLocalInt(oItem,"CC2",BACKGROUND_AMN_TRAINED);
						SetLocalInt(oItem,"BG_Select",2);						
						break;  // Amnian Trained						
					}
					case 3:
					{
						//sGrant = "bg_give_bra";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_BRAWLER);
						SetPersistantLocalInt(oPC, "BG_Select", 3);
						SetLocalInt(oItem,"CC2",BACKGROUND_BRAWLER);
						SetLocalInt(oItem,"BG_Select",3);						
						break;  // Brawler						
					}
					case 4:
					{
						//sGrant = "bg_give_calslave";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_CALISHITE_SLAVE);
						SetPersistantLocalInt(oPC, "BG_Select", 4);
						SetLocalInt(oItem,"CC2",BACKGROUND_CALISHITE_SLAVE);
						SetLocalInt(oItem,"BG_Select",4);						
						break;  // Calishite Slave						
					}
					case 5:
					{
						//sGrant = "bg_give_calish";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_CALISHITE_TRAINED);
						SetPersistantLocalInt(oPC, "BG_Select", 5);
						SetLocalInt(oItem,"CC2",BACKGROUND_CALISHITE_TRAINED);
						SetLocalInt(oItem,"BG_Select",5);						
						break;  // Calishite Trained						
					}					
					case 6:
					{
						//sGrant = "bg_give_carav";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_CARAVANNER);
						SetPersistantLocalInt(oPC, "BG_Select", 6);
						SetLocalInt(oItem,"CC2",BACKGROUND_CARAVANNER);
						SetLocalInt(oItem,"BG_Select",6);
						break;  // Caravaner
						
					}
					case 7:
					{
						//sGrant = "bg_give_church";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_CHURCH_ACOLYTE);
						SetPersistantLocalInt(oPC, "BG_Select", 7);
						SetLocalInt(oItem,"CC2",BACKGROUND_CHURCH_ACOLYTE);
						SetLocalInt(oItem,"BG_Select",7);
						break;  // Church Acolyte
						
					}
					case 8:
					{
						//sGrant = "bg_give_circle";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_CIRCLE_BORN);
						SetPersistantLocalInt(oPC, "BG_Select", 8);
						SetLocalInt(oItem,"CC2",BACKGROUND_CIRCLE_BORN);
						SetLocalInt(oItem,"BG_Select",8);
						break;	// Circle Born					
					}
					case 9:
					{					
						//sGrant = "bg_give_cosmo";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_COSMOPOLITAN);
						SetPersistantLocalInt(oPC, "BG_Select",9);
						SetLocalInt(oItem,"CC2",BACKGROUND_COSMOPOLITAN);
						SetLocalInt(oItem,"BG_Select",9);						
						break;  // Cosmopolitan
					}					
					case 10:
					{
						//sGrant = "bg_give_cru";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_CRUSADER);
						SetPersistantLocalInt(oPC, "BG_Select",10);
						SetLocalInt(oItem,"CC2",BACKGROUND_CRUSADER);
						SetLocalInt(oItem,"BG_Select",10);	
						break;  // Crusader						
					}
					case 11:
					{
						//sGrant = "bg_give_duelist";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_DUELIST);
						SetPersistantLocalInt(oPC, "BG_Select",11);
						SetLocalInt(oItem,"CC2",BACKGROUND_DUELIST);
						SetLocalInt(oItem,"BG_Select",11);	
						break;  // Duke's Warband						
					}					
					case 12:
					{
						//sGrant = "bg_give_dukewar";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_DUKES_WARBAND);
						SetPersistantLocalInt(oPC, "BG_Select",12);
						SetLocalInt(oItem,"CC2",BACKGROUND_DUKES_WARBAND);
						SetLocalInt(oItem,"BG_Select",12);	
						break;  // Duke's Warband						
					}
					case 13:
					{
						//sGrant = "bg_give_eldreth";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_ELDRETH_VELUUTHRA);
						SetPersistantLocalInt(oPC, "BG_Select",13);
						SetLocalInt(oItem,"CC2",BACKGROUND_ELDRETH_VELUUTHRA);
						SetLocalInt(oItem,"BG_Select",13);	
						break;  // Duke's Warband						
					}					

					case 14:
					{
						//sGrant = "bg_give_elmanesse";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_ELMANESSE_TRIBE);
						SetPersistantLocalInt(oPC, "BG_Select",14);
						SetLocalInt(oItem,"CC2",BACKGROUND_ELMANESSE_TRIBE);
						SetLocalInt(oItem,"BG_Select",14);
						break;  // Elmanesse Tribe
					}					
					case 15:
					{
						//sGrant = "bg_give_enlight";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_ENLIGHTENED_STUDENT);
						SetPersistantLocalInt(oPC, "BG_Select",15);
						SetLocalInt(oItem,"CC2",BACKGROUND_ENLIGHTENED_STUDENT);
						SetLocalInt(oItem,"BG_Select",15);
						break;  // Enlightened Student
					}
					
					case 16:
					{
						//sGrant = "bg_give_evang";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_EVANGELIST);
						SetPersistantLocalInt(oPC, "BG_Select",16);
						SetLocalInt(oItem,"CC2",BACKGROUND_EVANGELIST);
						SetLocalInt(oItem,"BG_Select",16);
						break;  // Evangelist
					}
					case 17:
					{
						//sGrant = "bg_give_forest";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_FORESTER);
						SetPersistantLocalInt(oPC, "BG_Select",17);
						SetLocalInt(oItem,"CC2",BACKGROUND_FORESTER);
						SetLocalInt(oItem,"BG_Select",17);
						break;  // Forester
					
					}
					case 18:
					{
						//sGrant = "bg_give_hardlabo";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_HARD_LABORER);
						SetPersistantLocalInt(oPC, "BG_Select",18);
						SetLocalInt(oItem,"CC2",BACKGROUND_HARD_LABORER);
						SetLocalInt(oItem,"BG_Select",18);
						break;  // Hard Laborer
					}
					case 19:
					{
						//sGrant = "bg_give_harem";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_HAREM_TRAINED);
						SetPersistantLocalInt(oPC, "BG_Select",19);
						SetLocalInt(oItem,"CC2",BACKGROUND_HAREM_TRAINED);
						SetLocalInt(oItem,"BG_Select",19);
						break;  // Harem-trained
					}					
					case 20:
					{
						//sGrant = "bg_give_harper";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_HARPER);
						SetPersistantLocalInt(oPC, "BG_Select",20);
						SetLocalInt(oItem,"CC2",BACKGROUND_HARPER);
						SetLocalInt(oItem,"BG_Select",20);
						break; // Harper Protégé 
					}
					case 21:
					{
						//sGrant = "bg_give_healer";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_HEALER);
						SetPersistantLocalInt(oPC, "BG_Select",21);
						SetLocalInt(oItem,"CC2",BACKGROUND_HEALER);
						SetLocalInt(oItem,"BG_Select",21);
						break; // Healer 
					}					
					case 22:
					{
						//sGrant = "bg_give_hedgem";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_HEDGEMAGE);
						SetPersistantLocalInt(oPC, "BG_Select",22);
						SetLocalInt(oItem,"CC2",BACKGROUND_HEDGEMAGE);
						SetLocalInt(oItem,"BG_Select",22);
						break; // Hedge Mage 
					}					
					case 23:
					{
						//sGrant = "bg_give_heir";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_HEIR_TO_THRONE);
						SetPersistantLocalInt(oPC, "BG_Select",23);
						SetLocalInt(oItem,"CC2",BACKGROUND_HEIR_TO_THRONE);
						SetLocalInt(oItem,"BG_Select",23);
						break;	// Heir to the Thone						
					}					
					case 24:
					{
						//sGrant = "bg_give_hmage";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_HIGH_MAGE);
						SetPersistantLocalInt(oPC, "BG_Select",24);
						SetLocalInt(oItem,"CC2",BACKGROUND_HIGH_MAGE);
						SetLocalInt(oItem,"BG_Select",24);
						break;  // High Mage
					}
					case 25:
					{
						//sGrant = "bg_give_knight";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_KNIGHT);
						SetPersistantLocalInt(oPC, "BG_Select",25);
						SetLocalInt(oItem,"CC2",BACKGROUND_KNIGHT);
						SetLocalInt(oItem,"BG_Select",25);
						break;  // Knight
					}
					case 26:
					{
						//sGrant = "bg_give_knightsq";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_KNIGHT_SQUIRE);
						SetPersistantLocalInt(oPC, "BG_Select",26);
						SetLocalInt(oItem,"CC2",BACKGROUND_KNIGHT_SQUIRE);
						SetLocalInt(oItem,"BG_Select",26);
						break;  // Knight Squire
					}
					case 27:
					{
						//sGrant = "bg_give_mendi";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_MENDICANT);
						SetPersistantLocalInt(oPC, "BG_Select",27);
						SetLocalInt(oItem,"CC2",BACKGROUND_MENDICANT);
						SetLocalInt(oItem,"BG_Select",27);
						break;  // Mendicant
					}
					case 28:
					{
						//sGrant = "bg_give_merch";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_MERCHANT);
						SetPersistantLocalInt(oPC, "BG_Select",28);
						SetLocalInt(oItem,"CC2",BACKGROUND_MERCHANT);
						SetLocalInt(oItem,"BG_Select",28);
						break;	// Merchant					
					}
					case 29:
					{
						//sGrant = "bg_give_metal";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_METALSMITH);
						SetPersistantLocalInt(oPC, "BG_Select",29);
						SetLocalInt(oItem,"CC2",BACKGROUND_METALSMITH);
						SetLocalInt(oItem,"BG_Select",29);
						break;	// Merchant					
					}
					
					case 30:
					{
						//sGrant = "bg_give_minstrel";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_MINSTREL);
						SetPersistantLocalInt(oPC, "BG_Select",30);
						SetLocalInt(oItem,"CC2",BACKGROUND_MINSTREL);
						SetLocalInt(oItem,"BG_Select",30);
						break;  // Minstrel
					}					
					case 31:
					{
						//sGrant = "bg_give_mordins";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_MORDINSAMMAN_PRIEST);
						SetPersistantLocalInt(oPC, "BG_Select",31);
						SetLocalInt(oItem,"CC2",BACKGROUND_MORDINSAMMAN_PRIEST);
						SetLocalInt(oItem,"BG_Select",31);
						break;  // Mordinsamman Priest
						
					}
					case 32:
					{
						//sGrant = "bg_give_natly";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_NAT_LYCAN);
						SetPersistantLocalInt(oPC, "BG_Select",32);
						SetLocalInt(oItem,"CC2",BACKGROUND_NAT_LYCAN);
						SetLocalInt(oItem,"BG_Select",32);
						break;  // Natural Lycanthrope
						
					}					
					case 33:
					{
						//sGrant = "bg_give_occult";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_NAT_LYCAN);
						SetPersistantLocalInt(oPC, "BG_Select",33);
						SetLocalInt(oItem,"CC2",BACKGROUND_NAT_LYCAN);
						SetLocalInt(oItem,"BG_Select",33);
						break;  // Occultist
					}					
					case 34:
					{
						//sGrant = "bg_give_saboteur";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_SABOTEUR);
						SetPersistantLocalInt(oPC, "BG_Select",34);
						SetLocalInt(oItem,"CC2",BACKGROUND_SABOTEUR);
						SetLocalInt(oItem,"BG_Select",34);
						break;  // Saboteur						
					}
					case 35:
					{
						sGrant = "bg_give_scout";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_SCOUT);
						SetPersistantLocalInt(oPC, "BG_Select",35);
						SetLocalInt(oItem,"CC2",BACKGROUND_SCOUT);
						SetLocalInt(oItem,"BG_Select",35);
						break;						
					}
					case 36:
					{
						//sGrant = "bg_give_seldarine";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_SELDARINE_PRIEST);
						SetPersistantLocalInt(oPC, "BG_Select",36);
						SetLocalInt(oItem,"CC2",BACKGROUND_SELDARINE_PRIEST);
						SetLocalInt(oItem,"BG_Select",36);
						break;						
					}
 					case 37:
					{
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_SHADOW);
						SetPersistantLocalInt(oPC, "BG_Select",37);
						SetLocalInt(oItem,"CC2",BACKGROUND_SHADOW);
						SetLocalInt(oItem,"BG_Select",37);
						break;  // Shadow Weaver						
					}
 					case 38:
					{
						//sGrant = "bg_give_sneak";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_SNEAK);
						SetPersistantLocalInt(oPC, "BG_Select",38);
						SetLocalInt(oItem,"CC2",BACKGROUND_SNEAK);
						SetLocalInt(oItem,"BG_Select",38);
						break;  // Sneak						
					}
					case 39:
					{
						//sGrant = "bg_give_soldier";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_SOLDIER);
						SetPersistantLocalInt(oPC, "BG_Select",39);
						SetLocalInt(oItem,"CC2",BACKGROUND_SOLDIER);
						SetLocalInt(oItem,"BG_Select",39);
						break;  // Soldier
					}
					
					case 40:
					{
						//sGrant = "bg_give_spell";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_SPELLFIRE);
						SetPersistantLocalInt(oPC, "BG_Select",40);
						SetLocalInt(oItem,"CC2",BACKGROUND_SPELLFIRE);
						SetLocalInt(oItem,"BG_Select",40);
						break;  // Spellfire Lineage
					}					
					case 41:
					{
						//sGrant = "bg_give_suldusk";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_SULDUSK_TRIBE);
						SetPersistantLocalInt(oPC, "BG_Select",41);
						SetLocalInt(oItem,"CC2",BACKGROUND_SULDUSK_TRIBE);
						SetLocalInt(oItem,"BG_Select",41);
						break;  // Suldusk Tribe						
					}
					case 42:
					{
						//sGrant = "bg_give_talf";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_TALFIRIAN);
						SetPersistantLocalInt(oPC, "BG_Select",42);
						SetLocalInt(oItem,"CC2",BACKGROUND_TALFIRIAN);
						SetLocalInt(oItem,"BG_Select",42);
						break;  // Talfiran Lineage
					}					
					case 43:
					{
						//sGrant = "bg_give_theo";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_THEOCRAT);
						SetPersistantLocalInt(oPC, "BG_Select",43);
						SetLocalInt(oItem,"CC2",BACKGROUND_THEOCRAT);
						SetLocalInt(oItem,"BG_Select",43);
						break;  // Theocrat
					} 
					case 44:
					{
						//sGrant = "bg_give_thunder";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_THUNDER_TWIN);
						SetPersistantLocalInt(oPC, "BG_Select",44);
						SetLocalInt(oItem,"CC2",BACKGROUND_THUNDER_TWIN);
						SetLocalInt(oItem,"BG_Select",44);
						break;  // Thunder-twin
					}
					case 45:
					{
						//sGrant = "bg_give_travel";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_TRAVELER);
						SetPersistantLocalInt(oPC, "BG_Select",45);
						SetLocalInt(oItem,"CC2",BACKGROUND_TRAVELER);
						SetLocalInt(oItem,"BG_Select",45);
						break;  // Traveler
					}
					
					case 46:
					{
						//sGrant = "bg_give_udexile";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_UNDERDARK_EXILE);
						SetPersistantLocalInt(oPC, "BG_Select",46);
						SetLocalInt(oItem,"CC2",BACKGROUND_UNDERDARK_EXILE);
						SetLocalInt(oItem,"BG_Select",46);
						break;  // Underdark Exile
					}
					case 47:
					{
						//sGrant = "bg_give_ward";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_WARD_TRIAD);
						SetPersistantLocalInt(oPC, "BG_Select",47);
						SetLocalInt(oItem,"CC2",BACKGROUND_WARD_TRIAD);
						SetLocalInt(oItem,"BG_Select",47);
						break;  // Ward of the Triad
					}
					case 48:
					{
						//sGrant = "bg_give_warysk";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_WARY_SWORDKNIGHT);
						SetPersistantLocalInt(oPC, "BG_Select",48);
						SetLocalInt(oItem,"CC2",BACKGROUND_WARY_SWORDKNIGHT);
						SetLocalInt(oItem,"BG_Select",48);
						break;  // Wary Swordknight
					}
					case 49:
					{
						//sGrant = "bg_give_zhent";
						SetPersistantLocalInt(oPC, "CC2", BACKGROUND_ZHENTARIM);
						SetPersistantLocalInt(oPC, "BG_Select",49);
						SetLocalInt(oItem,"CC2",BACKGROUND_ZHENTARIM);
						SetLocalInt(oItem,"BG_Select",49);
						break;  
					}					
					//default: sGrant = "";                 break;
					SetPersistantLocalInt(oPC, "CC2_DONE", 1);
					AllowExit(DYNCONV_EXIT_FORCE_EXIT, TRUE, oPC);				
					DelayCommand(0.1f, StartDynamicConversation("bg_deity_cv", oPC));				
                }
                //if (sGrant != "") ExecuteScript(sGrant, oPC);  
            } else 
			{  
                SetStage(STAGE_LIST, oPC);  
            }  
        }  
        SetStage(nStage, oPC);  
    }  
}*/