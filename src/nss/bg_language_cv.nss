// bg_language_cv.nss    
#include "inc_dynconv"    
#include "x2_inc_switches"    
#include "inc_persist_loca"    
#include "te_afflic_func"    
  
const int STAGE_LIST = 0;    
const int STAGE_CONFIRM = 1;    
  

// Ensure the PC Data Object exists; create if missing    
object EnsurePlayerDataObject(object oPC)    
{    
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");    
    if (!GetIsObjectValid(oItem))    
    {    
        oItem = CreateItemOnObject("pc_data_object", oPC);    
    }    
    return oItem;    
}    
  
// Check if PC already knows a language    
int KnowsLanguage(object oPC, int nLanguageFeat)      
{      
    object oItem = EnsurePlayerDataObject(oPC);      
      
    // Search through all LANGUAGE_* slots for this feat  
    int i = 0;  
    string sSlot;  
    while (i < 99)  
    {  
        sSlot = "LANGUAGE_" + (i < 20 ? "0" : "") + IntToString(i);  
        if (GetLocalInt(oItem, sSlot) == nLanguageFeat)  
            return TRUE;  
        i++;  
    }  
    return FALSE;  
}
  

// Function to get the next available language slot  
int GetNextLanguageSlot(object oPC)  
{  
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");  
    if (!GetIsObjectValid(oItem)) return 0;  
      
    int i = 0;  
    string sSlot;  
      
    // Find the first empty slot  
    while (i < 99) // Maximum 99 languages  
    {  
        sSlot = "LANGUAGE_" + (i < 20 ? "0" : "") + IntToString(i);  
        if (!GetLocalInt(oItem, sSlot))  
            return i;  
        i++;  
    }  
    return -1; // No slots available  
}  
  
  
// Grant a language to PC    
void GrantLanguage(object oPC, int nLanguageFeat)  
{  
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");  
    if (!GetIsObjectValid(oItem)) return;  
      
    int nSlot = GetNextLanguageSlot(oPC);  
    if (nSlot >= 0)  
    {  
        string sSlot = "LANGUAGE_" + (nSlot < 20 ? "0" : "") + IntToString(nSlot);  
        SetLocalInt(oItem, sSlot, nLanguageFeat);  
        SetPersistantLocalInt(oPC, sSlot, nLanguageFeat);  
    }  
}   
  
// Count automatic racial and class languages using slot-searching pattern  
int GetAutomaticLanguageCount(object oPC)  
{  
    int nAutomaticLanguages = 0;  
    int nRace = GetRacialType(oPC);  
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");  
    if (!GetIsObjectValid(oItem)) return 0;  
      
    // Search through all language slots  
    int i = 0;  
    string sSlot;  
    int nLanguageFeat;  
      
    while (i < 99)  
    {  
        sSlot = "LANGUAGE_" + (i < 10 ? "0" : "") + IntToString(i);  
        nLanguageFeat = GetLocalInt(oItem, sSlot);  
          
        if (nLanguageFeat > 0)  
        {  
            // Check if this is an automatic racial language  
            switch(nRace)  
            {  
                case RACIAL_TYPE_ELF: case RACIAL_TYPE_HALFELF:  
                    if (nLanguageFeat == FEAT_LANGUAGE_ELVEN) nAutomaticLanguages++;  
                    break;  
                case RACIAL_TYPE_DWARF:  
                    if (nLanguageFeat == FEAT_LANGUAGE_DWARVEN) nAutomaticLanguages++;  
                    break;  
                case RACIAL_TYPE_GNOME:  
                    if (nLanguageFeat == FEAT_LANGUAGE_GNOMISH) nAutomaticLanguages++;  
                    break;  
                case RACIAL_TYPE_HALFLING:  
                    if (nLanguageFeat == FEAT_LANGUAGE_HALFLING) nAutomaticLanguages++;  
                    break;  
                case RACIAL_TYPE_HALFORC:  
                    if (nLanguageFeat == FEAT_LANGUAGE_ORCISH) nAutomaticLanguages++;  
                    break;  
            }  
              
            // Check if this is an automatic class language  
            if (GetLevelByClass(CLASS_TYPE_ROGUE, oPC) >= 1 && nLanguageFeat == FEAT_LANGUAGE_THIEVES_CANT)  
                nAutomaticLanguages++;  
            if (GetLevelByClass(CLASS_TYPE_DRUID, oPC) >= 5 && nLanguageFeat == FEAT_LANGUAGE_DRUIDIC)  
                nAutomaticLanguages++;  
            if ((GetLevelByClass(CLASS_TYPE_RANGER, oPC) >= 8 || GetLevelByClass(CLASS_TYPE_DRUID, oPC) >= 5) && nLanguageFeat == FEAT_LANGUAGE_ANIMAL)  
                nAutomaticLanguages++;  
            if (GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC) >= 1 && nLanguageFeat == FEAT_LANGUAGE_ASSASSINS_CANT)  
                nAutomaticLanguages++;  
        }  
          
        i++;  
    }  
      
    return nAutomaticLanguages;  
}
  
// Calculate remaining bonus language picks      
int GetBonusLanguageCount(object oPC)      
{      
    object oItem = EnsurePlayerDataObject(oPC);      
      
    // Calculate total bonus languages based on Intelligence modifier      
    int nIntMod = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);      
    int nTotalBonus = 0;      
      
    if (nIntMod > 0)      
        nTotalBonus = nIntMod;      
      
    // Count languages already selected by searching LANGUAGE_* slots  
    int nSelected = 0;      
    int i = 0;  
    string sSlot;  
    while (i < 99)  
    {  
        sSlot = "LANGUAGE_" + (i < 20 ? "0" : "") + IntToString(i);  
        if (GetLocalInt(oItem, sSlot))  
            nSelected++;  
        i++;  
    }  
      
    // Subtract automatic languages (this function needs similar fix)  
    int nAutomatic = GetAutomaticLanguageCount(oPC);      
    nSelected -= nAutomatic;      
      
    // Return remaining picks (minimum 0)      
    int nRemaining = nTotalBonus - nSelected;      
    return (nRemaining > 0) ? nRemaining : 0;      
}

void GrantDefaultLanguages(object oPC)  
{  
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");  
    if (!GetIsObjectValid(oItem)) return;  
      
    // Get saved character creation choices  
    int nSubrace = GetLocalInt(oItem, "CC0");  
    int nBackground = GetLocalInt(oItem, "CC2");  
      
    // Racial Languages  
    switch (GetRacialType(oPC))  
    {  
        case RACIAL_TYPE_ELF: case RACIAL_TYPE_HALFELF:  
            GrantLanguage(oPC, FEAT_LANGUAGE_ELVEN);  
            break;  
        case RACIAL_TYPE_GNOME:  
            GrantLanguage(oPC, FEAT_LANGUAGE_GNOMISH);  
            break;  
        case RACIAL_TYPE_HALFLING:  
            GrantLanguage(oPC, FEAT_LANGUAGE_HALFLING);  
            break;  
        case RACIAL_TYPE_DWARF:  
            GrantLanguage(oPC, FEAT_LANGUAGE_DWARVEN);  
            break;  
        case RACIAL_TYPE_HALFORC:  
            GrantLanguage(oPC, FEAT_LANGUAGE_ORCISH);  
            break;  
    }  
      
    // Class Languages  
    int nRanger = GetLevelByClass(CLASS_TYPE_RANGER, oPC);  
    int nDruid = GetLevelByClass(CLASS_TYPE_DRUID, oPC);  
    int nRogue = GetLevelByClass(CLASS_TYPE_ROGUE, oPC);  
    int nAssn = GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC);  
      
    if (nRanger >= 8 || nDruid >= 5 || nBackground == BACKGROUND_CIRCLE_BORN)  
    {  
        GrantLanguage(oPC, FEAT_LANGUAGE_ANIMAL);  
        if (nDruid >= 5) GrantLanguage(oPC, FEAT_LANGUAGE_DRUIDIC);  
    }  
      
    if (nRogue > 0 || nAssn > 0)  
    {  
        GrantLanguage(oPC, FEAT_LANGUAGE_THIEVES_CANT);  
        if (nAssn > 0) GrantLanguage(oPC, FEAT_LANGUAGE_ASSASSINS_CANT);  
    }  
      
    // Ethnicity Languages  
    if (nSubrace == ETHNICITY_CALISHITE || nBackground == BACKGROUND_CALISHITE_TRAINED)  
        GrantLanguage(oPC, FEAT_LANGUAGE_ALZHEDO);  
    if (nSubrace == ETHNICITY_CHONDATHAN || nSubrace == ETHNICITY_TETHYRIAN)  
        GrantLanguage(oPC, FEAT_LANGUAGE_CHONDATHAN);  
    if (nSubrace == ETHNICITY_DAMARAN)  
        GrantLanguage(oPC, FEAT_LANGUAGE_DAMARAN);  
    if (nSubrace == ETHNICITY_ILLUSKAN)  
        GrantLanguage(oPC, FEAT_LANGUAGE_ILLUSKAN);  
    if (nSubrace == ETHNICITY_MULAN)  
        GrantLanguage(oPC, FEAT_LANGUAGE_MULANESE);  
    if (nSubrace == ETHNICITY_RASHEMI)  
        GrantLanguage(oPC, FEAT_LANGUAGE_RASHEMI);  
      
    // Special Subrace Languages  
    if (nBackground == BACKGROUND_DARK_ELF)  
    {  
        GrantLanguage(oPC, FEAT_LANGUAGE_DROW);  
        GrantLanguage(oPC, FEAT_LANGUAGE_DROW_HAND_CANT);  
        GrantLanguage(oPC, FEAT_LANGUAGE_UNDERCOMMON);  
    }  
      
    if (nBackground == BACKGROUND_GREY_DWARF)  
    {  
        GrantLanguage(oPC, FEAT_LANGUAGE_DUERGAR);  
        GrantLanguage(oPC, FEAT_LANGUAGE_UNDERCOMMON);  
    }  
      
    // Planar Languages  
    if (nBackground == 1137) // Abyssal_Pact  
        GrantLanguage(oPC, FEAT_LANGUAGE_ABYSSAL);  
    if (nBackground == 1139) // Dark_Pact  
        GrantLanguage(oPC, FEAT_LANGUAGE_INFERNAL);  
}
 
void main()    
{    
    object oPC 		= GetPCSpeaker();
	object oItem 	= EnsurePlayerDataObject(oPC);    
	
    int nValue 		= GetLocalInt(oPC, DYNCONV_VARIABLE);    
    int nStage 		= GetStage(oPC);    
    int nChoice 	= GetChoice();   

	int nBackground = GetLocalInt(oItem, "CC2"); 	
	
	int nCleric	= GetLevelByClass(CLASS_TYPE_CLERIC, oPC);
	int nDruid 	= GetLevelByClass(CLASS_TYPE_DRUID, oPC);
	int nWizard	= GetLevelByClass(CLASS_TYPE_WIZARD, oPC);

	int nAir 	= GetHasFeat(FEAT_AIR_DOMAIN_POWER, oPC);	
	int nEarth 	= GetHasFeat(FEAT_EARTH_DOMAIN_POWER, oPC);	
	int nFire 	= GetHasFeat(FEAT_FIRE_DOMAIN_POWER, oPC);
	int nWater 	= GetHasFeat(FEAT_WATER_DOMAIN_POWER, oPC);
      
    if(nValue == 0) return;    
      
    if(nValue == DYNCONV_SETUP_STAGE)    
    {    
        if(!GetIsStageSetUp(nStage, oPC))    
        {    
            if(nStage == STAGE_LIST)    
            {    
                int nRemaining = GetBonusLanguageCount(oPC);    
                string sHeader = "You have " + IntToString(nRemaining) + " bonus language picks remaining.\n\ You can refresh the list with the Escape if needed.\n\nSelect a language:";    
                SetHeader(sHeader);    
                  
                // Add all available languages that PC doesn't know and has picks for    
                if (nRemaining > 0 && nCleric && !KnowsLanguage(oPC, FEAT_LANGUAGE_ABYSSAL))
				{					
                    AddChoice("Abyssal", 1, oPC);    
				}
                if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_ALZHEDO))
				{					
                    AddChoice("Alzhedo", 2, oPC);    
				}
                if (nRemaining > 0 && nWater && !KnowsLanguage(oPC, FEAT_LANGUAGE_AQUAN))
				{					
                    AddChoice("Aquan", 3, oPC);    
				}  
				if (nRemaining > 0 && nAir && !KnowsLanguage(oPC, FEAT_LANGUAGE_AURAN))
				{					
					AddChoice("Auran", 5, oPC);  
				}					
				if (nRemaining > 0 && nCleric && !KnowsLanguage(oPC, FEAT_LANGUAGE_CELESTIAL)) 
				{					
					AddChoice("Celestial", 6, oPC);      
				}
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_CHESSENTAN))
				{					
					AddChoice("Chessentan", 7, oPC);    
				}					
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_CHONDATHAN))
				{					
					AddChoice("Chondathan", 8, oPC);
				}					
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_CHULTAN))
				{					
					AddChoice("Chultan", 9, oPC);
				}					
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_DAMARAN))
				{					
					AddChoice("Damaran", 10, oPC);      
				}
				if (nRemaining > 0 && nWizard && !KnowsLanguage(oPC, FEAT_LANGUAGE_DRACONIC))
				{					
					AddChoice("Draconic", 11, oPC);      
				}
				if (nRemaining > 0 && KnowsLanguage(oPC, FEAT_LANGUAGE_UNDERCOMMON) || 
										KnowsLanguage(oPC, FEAT_LANGUAGE_ELVEN) || 
										KnowsLanguage(oPC, FEAT_LANGUAGE_IMASKARI && 
										!KnowsLanguage(oPC, FEAT_LANGUAGE_DROW)))
				{					
					AddChoice("Drow", 12, oPC);      
				}				  
				if (nRemaining > 0 && KnowsLanguage(oPC, FEAT_LANGUAGE_UNDERCOMMON) || 
										KnowsLanguage(oPC, FEAT_LANGUAGE_DWARVEN) || 
										KnowsLanguage(oPC, FEAT_LANGUAGE_IMASKARI && 
										!KnowsLanguage(oPC, FEAT_LANGUAGE_DUERGAR)))
				{					
					AddChoice("Duergar", 13, oPC);
				}					
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_DWARVEN))
				{					
					AddChoice("Dwarven", 14, oPC); 
				}					
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_ELVEN))
				{					
					AddChoice("Elven", 15, oPC);
				}					
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_GIANT))
				{					
					AddChoice("Giant", 16, oPC);
				}					
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_GNOMISH))
				{					
					AddChoice("Gnomish", 17, oPC);
				}					
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_GOBLIN))
				{
					AddChoice("Goblin", 18, oPC);
				}					
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_HALFLING))
				{					
					AddChoice("Halfling", 19, oPC);
				}					
				if (nRemaining > 0 && nFire && !KnowsLanguage(oPC, FEAT_LANGUAGE_IGNAN))
				{      
					AddChoice("Ignan", 20, oPC); 
				}					
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_ILLUSKAN))
				{					
					AddChoice("Illuskan", 21, oPC);
				}					
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_IMASKARI))
				{					
					AddChoice("Imaskari", 22, oPC);
				}					
				if (nRemaining > 0 && nCleric && !KnowsLanguage(oPC, FEAT_LANGUAGE_INFERNAL))
				{					
					AddChoice("Infernal", 23, oPC);
				}					
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_KOBOLD))
				{					
					AddChoice("Kobold", 24, oPC);
				}					
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_LANTANESE))
				{					
					AddChoice("Lantanese", 25, oPC);
				}					
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_MULANESE))
				{					
					AddChoice("Mulanese", 26, oPC);
				}					
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_MULHORANDI))
				{					
					AddChoice("Mulhorandi", 27, oPC);
				}					
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_ORCISH))
				{					
					AddChoice("Orcish", 28, oPC);
				}					
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_RASHEMI))
				{      
					AddChoice("Rashemi", 29, oPC);
				}					
				if (nRemaining > 0 && nDruid && !KnowsLanguage(oPC, FEAT_LANGUAGE_SYLVAN))
				{					
					AddChoice("Sylvan", 30, oPC);
				}					
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_TALFIRIC))
				{					
					AddChoice("Talfiric", 31, oPC);
				}					
				if (nRemaining > 0 && nEarth && !KnowsLanguage(oPC, FEAT_LANGUAGE_TERRAN))
				{					
					AddChoice("Terran", 32, oPC);
				}				  
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_TROGLODYTE))
				{					
					AddChoice("Troglodyte", 33, oPC);
				}					
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_UNDERCOMMON))
				{					
					AddChoice("Undercommon", 34, oPC); 
				}					
                  
                // Refresh option    
                AddChoice("[Refresh Language Choices]", 99, oPC);    
                  
                // No Options Left finalizer    
                if (nRemaining == 0)    
                {    
                    AddChoice("[No Options Left]", 100, oPC);    
                }    
                  
                MarkStageSetUp(nStage, oPC);    
                SetDefaultTokens();    
            }    
            else if (nStage == STAGE_CONFIRM)    
            {    
                SetHeader("Language selection complete.");    
                AddChoice("[Finish]", 1, oPC);    
                MarkStageSetUp(nStage, oPC);    
                SetDefaultTokens();    
            }    
        }    
          
        SetupTokens();    
    }    
    // Handle PC responses    
    else    
    {    
        if(nStage == STAGE_LIST)    
        {    
            // Handle language selection    
            if (nChoice >= 1 && nChoice <= 36)    
            {    
                int nRemaining = GetBonusLanguageCount(oPC);    
                  
                if (nRemaining > 0)    
                {    
                    // Grant the selected language based on choice    
					switch (nChoice)      
					{      
						case 1:  GrantLanguage(oPC, FEAT_LANGUAGE_ABYSSAL); break;      
						case 2:  GrantLanguage(oPC, FEAT_LANGUAGE_ALZHEDO); break;      
						case 3:  GrantLanguage(oPC, FEAT_LANGUAGE_AQUAN); break;  
						case 4:  GrantLanguage(oPC, FEAT_LANGUAGE_AURAN); break;      
						case 5:  GrantLanguage(oPC, FEAT_LANGUAGE_CELESTIAL); break;      
						case 6:  GrantLanguage(oPC, FEAT_LANGUAGE_CHESSENTAN); break;      
						case 7:  GrantLanguage(oPC, FEAT_LANGUAGE_CHONDATHAN); break;      
						case 8:  GrantLanguage(oPC, FEAT_LANGUAGE_CHULTAN); break;      
						case 9:  GrantLanguage(oPC, FEAT_LANGUAGE_DAMARAN); break;      
						case 10: GrantLanguage(oPC, FEAT_LANGUAGE_DRACONIC); break;      
						case 11: GrantLanguage(oPC, FEAT_LANGUAGE_DROW); break;    
						case 12: GrantLanguage(oPC, FEAT_LANGUAGE_DUERGAR); break;      
						case 13: GrantLanguage(oPC, FEAT_LANGUAGE_DWARVEN); break;      
						case 14: GrantLanguage(oPC, FEAT_LANGUAGE_ELVEN); break;      
						case 15: GrantLanguage(oPC, FEAT_LANGUAGE_GIANT); break;      
						case 16: GrantLanguage(oPC, FEAT_LANGUAGE_GNOMISH); break;      
						case 17: GrantLanguage(oPC, FEAT_LANGUAGE_GOBLIN); break;      
						case 18: GrantLanguage(oPC, FEAT_LANGUAGE_HALFLING); break;      
						case 19: GrantLanguage(oPC, FEAT_LANGUAGE_IGNAN); break;      
						case 20: GrantLanguage(oPC, FEAT_LANGUAGE_ILLUSKAN); break;      
						case 21: GrantLanguage(oPC, FEAT_LANGUAGE_IMASKARI); break;      
						case 22: GrantLanguage(oPC, FEAT_LANGUAGE_INFERNAL); break;      
						case 23: GrantLanguage(oPC, FEAT_LANGUAGE_KOBOLD); break;      
						case 24: GrantLanguage(oPC, FEAT_LANGUAGE_LANTANESE); break;      
						case 25: GrantLanguage(oPC, FEAT_LANGUAGE_MULANESE); break;      
						case 26: GrantLanguage(oPC, FEAT_LANGUAGE_MULHORANDI); break;      
						case 27: GrantLanguage(oPC, FEAT_LANGUAGE_ORCISH); break;      
						case 28: GrantLanguage(oPC, FEAT_LANGUAGE_RASHEMI); break;      
						case 29: GrantLanguage(oPC, FEAT_LANGUAGE_SYLVAN); break;      
						case 30: GrantLanguage(oPC, FEAT_LANGUAGE_TALFIRIC); break;      
						case 31: GrantLanguage(oPC, FEAT_LANGUAGE_TERRAN); break;      
						case 32: GrantLanguage(oPC, FEAT_LANGUAGE_TROGLODYTE); break;      
						case 33: GrantLanguage(oPC, FEAT_LANGUAGE_UNDERCOMMON); break;      
					} 
                      
                    // Rebuild stage to update available options    
                    MarkStageNotSetUp(nStage, oPC);    
                    SetStage(nStage, oPC);    
                }    
            }    
            // Handle refresh    
            else if (nChoice == 99)    
            {    
                MarkStageNotSetUp(nStage, oPC);    
                SetStage(nStage, oPC);    
            }    
            // Handle no options left - move to confirm    
            else if (nChoice == 100)    
            {    
                nStage = STAGE_CONFIRM;    
                SetStage(nStage, oPC);    
            }    
        }    
        else if (nStage == STAGE_CONFIRM)  
        {  
            SetHeader("Language selection complete.");  
            AddChoice("[Finish]", 1, oPC);  
            MarkStageSetUp(nStage, oPC);  
            SetDefaultTokens();  
        }  
    }  
      
    // Setup tokens for dynamic conversation system  
    SetupTokens();  
}