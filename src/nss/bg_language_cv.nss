// bg_language_cv.nss    
#include "inc_dynconv"    
#include "x2_inc_switches"    
#include "inc_persist_loca"    
#include "te_afflic_func"   
  
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
 
// Check if PC already knows a language
int KnowsLanguage(object oPC, int nLanguageFeat)  
{  
    object oItem = EnsurePlayerDataObject(oPC);  
  
    int i = 0;  
    string sSlot;  
  
    while (i < 99)  
    {  
        sSlot = "LANGUAGE_" + (i < 10 ? "0" : "") + IntToString(i);  
  
        // Check BOTH storage locations where GrantLanguage saves data  
        if (GetPersistantLocalInt(oPC, sSlot) == nLanguageFeat)  
            return TRUE;  
  
        if (GetIsObjectValid(oItem))  
        {  
            if (GetLocalInt(oItem, sSlot) == nLanguageFeat)  
                return TRUE;  
        }  
  
        i++;  
    }  
  
    return FALSE;  
}

void AddChoiceIfNotKnown(string sText, int nValue, object oPC, int nLanguageFeat)   
{    
    if (!GetLocalInt(oPC, IntToString(nLanguageFeat)) &&  
        !KnowsLanguage(oPC, nLanguageFeat))   
    {    
        AddChoice(sText, nValue, oPC);    
    }    
}

// Function to get the next available language slot     
int GetNextLanguageSlot(object oPC)    
{    
    object oItem = EnsurePlayerDataObject(oPC);    
    if (!GetIsObjectValid(oItem)) return 0;    
        
    int i = 0;    
    string sSlot;    
        
    // Find the first empty slot    
    while (i < 99) // Maximum 99 languages for consistency  
    {    
        sSlot = "LANGUAGE_" + (i < 10 ? "0" : "") + IntToString(i);    
        if (!GetLocalInt(oItem, sSlot))    
            return i;    
        i++;    
    }    
    return -1; // No slots available    
}
 
 // Grant a language to PC 
 void GrantLanguage(object oPC, int nLanguageFeat)
{
    object oItem = EnsurePlayerDataObject(oPC);
    if (!GetIsObjectValid(oItem)) return;

    if (KnowsLanguage(oPC, nLanguageFeat))
        return;

    int nSlot = GetNextLanguageSlot(oPC);
    if (nSlot >= 0)
    {
        string sSlot = "LANGUAGE_" + (nSlot < 10 ? "0" : "") + IntToString(nSlot);
        SetLocalInt(oItem, sSlot, nLanguageFeat);
        SetPersistantLocalInt(oPC, sSlot, nLanguageFeat);
    }

    // mark as selected for the conversation list
    SetLocalInt(oPC, IntToString(nLanguageFeat), TRUE);
}
 
 
// Count automatic racial and class languages using slot-searching pattern      
int GetAutomaticLanguageCount(object oPC)      
{      
    int nAutomaticLanguages = 0;      
    int nRace = GetRacialType(oPC);      
    object oItem = EnsurePlayerDataObject(oPC);      
    if (!GetIsObjectValid(oItem)) return 0;      
          
    // Get saved character creation choices      
    int nSubrace = GetLocalInt(oItem, "CC0");      
    int nBackground = GetLocalInt(oItem, "CC2");      
          
    // Search through all language slots      
    int i = 0;      
    string sSlot;      
    int nLanguageFeat;      
          
    while (i < 99)  // Check up to 99 slots  
    {      
        sSlot = "LANGUAGE_" + (i < 10 ? "0" : "") + IntToString(i);      
        nLanguageFeat = GetPersistantLocalInt(oPC, sSlot);     
              
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
            int nRanger = GetLevelByClass(CLASS_TYPE_RANGER, oPC);      
            int nDruid = GetLevelByClass(CLASS_TYPE_DRUID, oPC);      
            int nRogue = GetLevelByClass(CLASS_TYPE_ROGUE, oPC);      
            int nAssn = GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC);      
                  
            if ((nRanger >= 8 || nDruid >= 5 || nBackground == BACKGROUND_CIRCLE_BORN) && nLanguageFeat == FEAT_LANGUAGE_ANIMAL)      
                nAutomaticLanguages++;      
            if (nDruid >= 5 && nLanguageFeat == FEAT_LANGUAGE_DRUIDIC)      
                nAutomaticLanguages++;      
            if ((nRogue > 0 || nAssn > 0) && nLanguageFeat == FEAT_LANGUAGE_THIEVES_CANT)      
                nAutomaticLanguages++;      
            if (nAssn > 0 && nLanguageFeat == FEAT_LANGUAGE_ASSASSINS_CANT)      
                nAutomaticLanguages++;      
                  
            // Check if this is an automatic ethnicity language      
            if ((nSubrace == ETHNICITY_CALISHITE || nBackground == BACKGROUND_CALISHITE_TRAINED) && nLanguageFeat == FEAT_LANGUAGE_ALZHEDO)      
                nAutomaticLanguages++;      
            if (nSubrace == ETHNICITY_CHONDATHAN && nLanguageFeat == FEAT_LANGUAGE_CHONDATHAN)      
                nAutomaticLanguages++;      
            if (nSubrace == ETHNICITY_DAMARAN && nLanguageFeat == FEAT_LANGUAGE_DAMARAN)      
                nAutomaticLanguages++;      
            if (nSubrace == ETHNICITY_ILLUSKAN && nLanguageFeat == FEAT_LANGUAGE_ILLUSKAN)      
                nAutomaticLanguages++;      
            if (nSubrace == ETHNICITY_MULAN && nLanguageFeat == FEAT_LANGUAGE_MULANESE)      
                nAutomaticLanguages++;      
            if (nSubrace == ETHNICITY_RASHEMI && nLanguageFeat == FEAT_LANGUAGE_RASHEMI)      
                nAutomaticLanguages++;      
            if (nSubrace == ETHNICITY_CHULTAN && nLanguageFeat == FEAT_LANGUAGE_CHULTAN)      
                nAutomaticLanguages++;      
            if (nSubrace == ETHNICITY_TETHYRIAN && nLanguageFeat == FEAT_LANGUAGE_ALZHEDO)      
                nAutomaticLanguages++;      
            if (nSubrace == ETHNICITY_FFOLK && nLanguageFeat == FEAT_LANGUAGE_TALFIRIC)      
                nAutomaticLanguages++;      
            if (nSubrace == ETHNICITY_SHAARAN && nLanguageFeat == FEAT_LANGUAGE_SHAARAN)      
                nAutomaticLanguages++;      
            if (nSubrace == ETHNICITY_IMASKARI && nLanguageFeat == FEAT_LANGUAGE_IMASKARI)      
                nAutomaticLanguages++;      
                  
            // Check if this is an automatic special subrace language      
            if (nBackground == BACKGROUND_DARK_ELF)      
            {      
                if (nLanguageFeat == FEAT_LANGUAGE_DROW) nAutomaticLanguages++;      
                if (nLanguageFeat == FEAT_LANGUAGE_DROW_HAND_CANT) nAutomaticLanguages++;      
                if (nLanguageFeat == FEAT_LANGUAGE_UNDERCOMMON) nAutomaticLanguages++;      
            }      
            if (nBackground == BACKGROUND_GREY_DWARF)      
            {      
                if (nLanguageFeat == FEAT_LANGUAGE_DUERGAR) nAutomaticLanguages++;      
                if (nLanguageFeat == FEAT_LANGUAGE_UNDERCOMMON) nAutomaticLanguages++;      
            }      
                  
            // Check if this is an automatic planar language      
            if (nBackground == 1137 && nLanguageFeat == FEAT_LANGUAGE_ABYSSAL) // Abyssal_Pact      
                nAutomaticLanguages++;      
            if (nBackground == 1139 && nLanguageFeat == FEAT_LANGUAGE_INFERNAL) // Dark_Pact      
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
    while (i < 99)  // Check up to 99 slots  
    {  
        sSlot = "LANGUAGE_" + (i < 10 ? "0" : "") + IntToString(i);  
  
        if (GetPersistantLocalInt(oPC, sSlot))  
            nSelected++;  
  
        i++;  
    }   
        
    // Subtract automatic languages    
    int nAutomatic = GetAutomaticLanguageCount(oPC);        
    nSelected -= nAutomatic;        
        
    // Return remaining picks (minimum 0)        
    int nRemaining = nTotalBonus - nSelected;        
    return (nRemaining > 0) ? nRemaining : 0;        
}
      
void GrantDefaultLanguages(object oPC)  
{  
    object oItem = EnsurePlayerDataObject(oPC);  
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
    if (nSubrace == ETHNICITY_CHONDATHAN)  
        GrantLanguage(oPC, FEAT_LANGUAGE_CHONDATHAN);  
    if (nSubrace == ETHNICITY_DAMARAN)  
        GrantLanguage(oPC, FEAT_LANGUAGE_DAMARAN);  
    if (nSubrace == ETHNICITY_ILLUSKAN)  
        GrantLanguage(oPC, FEAT_LANGUAGE_ILLUSKAN);  
    if (nSubrace == ETHNICITY_MULAN)  
        GrantLanguage(oPC, FEAT_LANGUAGE_MULANESE);  
    if (nSubrace == ETHNICITY_RASHEMI)  
        GrantLanguage(oPC, FEAT_LANGUAGE_RASHEMI); 
    if (nSubrace == ETHNICITY_CHULTAN)  
        GrantLanguage(oPC, FEAT_LANGUAGE_CHULTAN);
    if (nSubrace == ETHNICITY_TETHYRIAN)  
        GrantLanguage(oPC, FEAT_LANGUAGE_ALZHEDO);
    if (nSubrace == ETHNICITY_FFOLK)  
        GrantLanguage(oPC, FEAT_LANGUAGE_TALFIRIC);
    if (nSubrace == ETHNICITY_SHAARAN)  
        GrantLanguage(oPC, FEAT_LANGUAGE_SHAARAN);	
    if (nSubrace == ETHNICITY_IMASKARI)  
        GrantLanguage(oPC, FEAT_LANGUAGE_IMASKARI);	
      
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


// Constants for stages    
const int STAGE_LIST = 0;    
const int STAGE_CONFIRM = 1;    
    
// Constants for choices    
const int CHOICE_CONFIRM_YES = 100;    
const int CHOICE_CONFIRM_NO = 101;    
  
void main() {      
    object oPC = GetPCSpeaker();      
    object oItem = EnsurePlayerDataObject(oPC);  
	
    // Grant automatic languages before starting conversation  
    GrantDefaultLanguages(oPC);  
	
    SendMessageToPC(oPC, "DEBUG: bg_language_cv main() entered");      
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);      
    int nStage = GetStage(oPC); 

    int nBackground = GetLocalInt(oItem, "CC2");      
      
    int nCleric 	= GetLevelByClass(CLASS_TYPE_CLERIC, oPC);  
    int nDruid 		= GetLevelByClass(CLASS_TYPE_DRUID, oPC);  
    int nWizard 	= GetLevelByClass(CLASS_TYPE_WIZARD, oPC);
	int nDragDisc 	= GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE, oPC);
  
    int nAir = GetHasFeat(FEAT_AIR_DOMAIN_POWER, oPC);      
    int nEarth = GetHasFeat(FEAT_EARTH_DOMAIN_POWER, oPC);      
    int nFire = GetHasFeat(FEAT_FIRE_DOMAIN_POWER, oPC);  
    int nWater = GetHasFeat(FEAT_WATER_DOMAIN_POWER, oPC);  	
      
    // Required guard: abort if nValue is 0      
    if (nValue == 0) return;      
      
    if (nValue == DYNCONV_SETUP_STAGE) {    
        if (!GetIsStageSetUp(nStage, oPC)) {      
            if (nStage == STAGE_LIST) {      
                // Initialize language count if not set    
                if (!GetLocalInt(oPC, "LANGUAGE_COUNT")) {    
                    SetLocalInt(oPC, "LANGUAGE_COUNT", 0);    
                }    
                    
                int nLangCount = GetLocalInt(oPC, "LANGUAGE_COUNT");    
                int nRemaining = GetBonusLanguageCount(oPC);  
                string sHeader = "You have " + IntToString(nRemaining) + " bonus language picks remaining.\n\n";    
                sHeader += "Languages selected: " + IntToString(nLangCount);    
                SetHeader(sHeader);      
      
				// Add all available languages that PC doesn't know and has picks for   
				if (nRemaining > 0 && nCleric && !KnowsLanguage(oPC, FEAT_LANGUAGE_ABYSSAL)) {    
					AddChoice("Abyssal", 1, oPC);    
				}    
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_ALZHEDO)) {    
					AddChoice("Alzhedo", 2, oPC);    
				}    
				if (nRemaining > 0 && nWater && !KnowsLanguage(oPC, FEAT_LANGUAGE_AQUAN)) {    
					AddChoice("Aquan", 3, oPC);    
				}    
				if (nRemaining > 0 && nAir && !KnowsLanguage(oPC, FEAT_LANGUAGE_AURAN)) {    
					AddChoice("Auran", 5, oPC);    
				}    
				if (nRemaining > 0 && nCleric && !KnowsLanguage(oPC, FEAT_LANGUAGE_CELESTIAL)) {    
					AddChoice("Celestial", 6, oPC);    
				}    
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_CHESSENTAN)) {    
					AddChoice("Chessentan", 7, oPC);    
				}    
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_CHONDATHAN)) {    
					AddChoice("Chondathan", 8, oPC);    
				}    
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_CHULTAN)) {    
					AddChoice("Chultan", 9, oPC);    
				}    
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_DAMARAN)) {    
					AddChoice("Damaran", 10, oPC);    
				}    
				if (nRemaining > 0 && (nWizard || nDragDisc) && !KnowsLanguage(oPC, FEAT_LANGUAGE_DRACONIC)) {    
					AddChoice("Draconic", 11, oPC);    
				}    
				if (nRemaining > 0 && (KnowsLanguage(oPC, FEAT_LANGUAGE_UNDERCOMMON) ||     
									  KnowsLanguage(oPC, FEAT_LANGUAGE_ELVEN) ||     
									  KnowsLanguage(oPC, FEAT_LANGUAGE_IMASKARI)) &&     
									  !KnowsLanguage(oPC, FEAT_LANGUAGE_DROW)) {    
					AddChoice("Drow", 12, oPC);    
				}    
				if (nRemaining > 0 && (KnowsLanguage(oPC, FEAT_LANGUAGE_UNDERCOMMON) ||     
									  KnowsLanguage(oPC, FEAT_LANGUAGE_DWARVEN) ||     
									  KnowsLanguage(oPC, FEAT_LANGUAGE_IMASKARI)) &&     
									  !KnowsLanguage(oPC, FEAT_LANGUAGE_DUERGAR)) {    
					AddChoice("Duergar", 13, oPC);    
				}    
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_DWARVEN)) {    
					AddChoice("Dwarven", 14, oPC);    
				}    
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_ELVEN)) {    
					AddChoice("Elven", 15, oPC);    
				}    
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_GIANT)) {    
					AddChoice("Giant", 16, oPC);    
				}    
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_GNOMISH)) {    
					AddChoice("Gnomish", 17, oPC);    
				}    
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_GOBLIN)) {    
					AddChoice("Goblin", 18, oPC);    
				}    
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_HALFLING)) {    
					AddChoice("Halfling", 19, oPC);    
				}    
				if (nRemaining > 0 && nFire && !KnowsLanguage(oPC, FEAT_LANGUAGE_IGNAN)) {    
					AddChoice("Ignan", 20, oPC);    
				}    
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_ILLUSKAN)) {    
					AddChoice("Illuskan", 21, oPC);    
				}    
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_IMASKARI)) {    
					AddChoice("Imaskari", 22, oPC);    
				}    
				if (nRemaining > 0 && nCleric && !KnowsLanguage(oPC, FEAT_LANGUAGE_INFERNAL)) {    
					AddChoice("Infernal", 23, oPC);    
				}    
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_LANTANESE)) {    
					AddChoice("Lantanese", 24, oPC);    
				}    
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_MAZTILAN)) {    
					AddChoice("Mulanese", 25, oPC);    
				}    
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_MULANESE)) {    
					AddChoice("Mulanese", 26, oPC);    
				}    
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_MULHORANDI)) {    
					AddChoice("Mulhorandi", 27, oPC);    
				}    
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_ORCISH)) {    
					AddChoice("Orcish", 28, oPC);    
				}    
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_RASHEMI)) {    
					AddChoice("Rashemi", 29, oPC);    
				}    
				if (nRemaining > 0 && nDruid && !KnowsLanguage(oPC, FEAT_LANGUAGE_SYLVAN)) {    
					AddChoice("Sylvan", 30, oPC);    
				}    
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_TALFIRIC)) {    
					AddChoice("Talfiric", 31, oPC);    
				}    
				if (nRemaining > 0 && nEarth && !KnowsLanguage(oPC, FEAT_LANGUAGE_TERRAN)) {    
					AddChoice("Terran", 32, oPC);    
				}    
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_TROGLODYTE)) {    
					AddChoice("Troglodyte", 33, oPC);    
				}    
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_UNDERCOMMON)) {    
					AddChoice("Undercommon", 34, oPC);    
				}
                    
                // Show Done option if at least one language selected    
                if (nLangCount > 0) {    
                    AddChoice("Done - I have selected enough languages", 99, oPC);    
                    SetLocalString(oPC, "lang_dyn_text_99", "Finish language selection and continue to the next step.");    
                }    
                    
                MarkStageSetUp(nStage, oPC);      
                SetDefaultTokens();      
            }      
            else if (nStage == STAGE_CONFIRM) {    
                string sLangName = GetLocalString(oPC, "TEMP_LANG_NAME");    
                string sLangDesc = GetLocalString(oPC, "TEMP_LANG_DESC");    
                    
                string sHeader = "Are you sure you want to select " + sLangName + "?\n\n";    
                sHeader += sLangDesc;    
                SetHeader(sHeader);    
                    
                AddChoice("Yes, select this language", CHOICE_CONFIRM_YES, oPC);    
                AddChoice("No, go back", CHOICE_CONFIRM_NO, oPC);    
                    
                MarkStageSetUp(nStage, oPC);    
                SetDefaultTokens();    
            }    
        }      
        SetupTokens();      
    } else {      
        // Handle PC responses      
        int nChoice = GetChoice(oPC);      
            
		if (nStage == STAGE_LIST) 
		{      
			if (nChoice == 99) 
			{        
				// Done - finalize and proceed to next step      
				SetPersistantLocalInt(oPC, "CC4_DONE", 1);    
				DelayCommand(0.1f, StartDynamicConversation("bg_profs_cv", oPC));        
			} 
			else if (nChoice >= 1 && nChoice <= 34) 
			{        
				// Store language info for confirmation 
				string sLangName;      
				string sLangVar;      
				int nLanguageFeat;      
					  
				switch (nChoice) 
				{            
					case 1:    
						sLangName = "Abyssal"; sLangVar = "ABYSSAL"; nLanguageFeat = FEAT_LANGUAGE_ABYSSAL;          
						break;      
					case 2:    
						sLangName = "Alzhedo"; sLangVar = "ALZHEDO"; nLanguageFeat = FEAT_LANGUAGE_ALZHEDO;     
						break;            
					case 3:    
						sLangName = "Aquan"; sLangVar = "AQUAN"; nLanguageFeat = FEAT_LANGUAGE_AQUAN;     
						break;        
					case 4:    
						sLangName = "Auran"; sLangVar = "AURAN"; nLanguageFeat = FEAT_LANGUAGE_AURAN;     
						break;            
					case 6:    
						sLangName = "Celestial"; sLangVar = "CELESTIAL"; nLanguageFeat = FEAT_LANGUAGE_CELESTIAL;     
						break;            
					case 7:    
						sLangName = "Chessentan"; sLangVar = "CHESSENTAN"; nLanguageFeat = FEAT_LANGUAGE_CHESSENTAN;     
						break;            
					case 8:    
						sLangName = "Chondathan"; sLangVar = "CHONDATHAN"; nLanguageFeat = FEAT_LANGUAGE_CHONDATHAN;     
						break;            
					case 9:    
						sLangName = "Chultan"; sLangVar = "CHULTAN"; nLanguageFeat = FEAT_LANGUAGE_CHULTAN;     
						break;            
					case 10:    
						sLangName = "Damaran"; sLangVar = "DAMARAN"; nLanguageFeat = FEAT_LANGUAGE_DAMARAN;     
						break;            
					case 11:    
						sLangName = "Draconic"; sLangVar = "DRACONIC"; nLanguageFeat = FEAT_LANGUAGE_DRACONIC;     
						break;            
					case 12:    
						sLangName = "Drow"; sLangVar = "DROW"; nLanguageFeat = FEAT_LANGUAGE_DROW;     
						break;          
					case 13:    
						sLangName = "Duergar"; sLangVar = "DUERGAR"; nLanguageFeat = FEAT_LANGUAGE_DUERGAR;    
						break;					            
					case 14:    
						sLangName = "Dwarven"; sLangVar = "DWARVEN"; nLanguageFeat = FEAT_LANGUAGE_DWARVEN;     
						break;            
					case 15:    
						sLangName = "Elven"; sLangVar = "ELVEN"; nLanguageFeat = FEAT_LANGUAGE_ELVEN;     
						break;            
					case 16:    
						sLangName = "Giant"; sLangVar = "GIANT"; nLanguageFeat = FEAT_LANGUAGE_GIANT;     
						break;            
					case 17:    
						sLangName = "Gnomish"; sLangVar = "GNOMISH"; nLanguageFeat = FEAT_LANGUAGE_GNOMISH;     
						break;            
					case 18:    
						sLangName = "Goblin"; sLangVar = "GOBLIN"; nLanguageFeat = FEAT_LANGUAGE_GOBLIN;     
						break;            
					case 19:    
						sLangName = "Halfling"; sLangVar = "HALFLING"; nLanguageFeat = FEAT_LANGUAGE_HALFLING;     
						break;            
					case 20:    
						sLangName = "Ignan"; sLangVar = "IGNAN"; nLanguageFeat = FEAT_LANGUAGE_IGNAN;     
						break;            
					case 21:    
						sLangName = "Illuskan"; sLangVar = "ILLUSKAN"; nLanguageFeat = FEAT_LANGUAGE_ILLUSKAN;     
						break;            
					case 22:    
						sLangName = "Imaskari"; sLangVar = "IMASKARI"; nLanguageFeat = FEAT_LANGUAGE_IMASKARI;     
						break;            
					case 23:     
						sLangName = "Infernal"; sLangVar = "INFERNAL"; nLanguageFeat = FEAT_LANGUAGE_INFERNAL;     
						break;     
					case 24:    
						sLangName = "Lantanese"; sLangVar = "LANTANESE"; nLanguageFeat = FEAT_LANGUAGE_LANTANESE;     
						break;           
					case 25:    
						sLangName = "Mulanese"; sLangVar = "MAZTILAN"; nLanguageFeat = FEAT_LANGUAGE_MAZTILAN;     
						break;  						    
					case 26:    
						sLangName = "Mulanese"; sLangVar = "MULANESE"; nLanguageFeat = FEAT_LANGUAGE_MULANESE;     
						break;            
					case 27:    
						sLangName = "Mulhorandi"; sLangVar = "MULHORANDI"; nLanguageFeat = FEAT_LANGUAGE_MULHORANDI;    
						break;            
					case 28:    
						sLangName = "Orcish"; sLangVar = "ORCISH"; nLanguageFeat = FEAT_LANGUAGE_ORCISH;    
						break;            
					case 29:    
						sLangName = "Rashemi"; sLangVar = "RASHEMI"; nLanguageFeat = FEAT_LANGUAGE_RASHEMI;    
						break;            
					case 30:    
						sLangName = "Sylvan"; sLangVar = "SYLVAN"; nLanguageFeat = FEAT_LANGUAGE_SYLVAN;    
						break;            
					case 31:    
						sLangName = "Talfiric"; sLangVar = "TALFIRIC"; nLanguageFeat = FEAT_LANGUAGE_TALFIRIC;    
						break;            
					case 32:    
						sLangName = "Terran"; sLangVar = "TERRAN"; nLanguageFeat = FEAT_LANGUAGE_TERRAN;    
						break;            
					case 33:    
						sLangName = "Troglodyte"; sLangVar = "TROGLODYTE"; nLanguageFeat = FEAT_LANGUAGE_TROGLODYTE;    
						break;            
					case 34:    
						sLangName = "Undercommon"; sLangVar = "UNDERCOMMON"; nLanguageFeat = FEAT_LANGUAGE_UNDERCOMMON;    
						break;                
				}  
					  
				SetLocalString(oPC, "TEMP_LANG_NAME", sLangName);      
				SetLocalString(oPC, "TEMP_LANG_VAR", sLangVar);      
				SetLocalInt(oPC, "TEMP_LANG_FEAT", nLanguageFeat);      
				SetLocalString(oPC, "TEMP_LANG_DESC", GetLocalString(oPC, "lang_dyn_text_" + IntToString(nChoice)));      
					  
				// Move to confirmation stage      
				SetStage(STAGE_CONFIRM, oPC);      
			}      
		}    
		else if (nStage == STAGE_CONFIRM) {      
			if (nChoice == CHOICE_CONFIRM_YES) {      
				// Confirm selection - grant language      
				string sLangVar = GetLocalString(oPC, "TEMP_LANG_VAR");      
				int nLanguageFeat = GetLocalInt(oPC, "TEMP_LANG_FEAT");      
					  
				// Mark as selected using simple tracking      
				SetLocalInt(oPC, "LANG_SELECTED_" + sLangVar, TRUE);      
					  
				// Increment count      
				int nCount = GetLocalInt(oPC, "LANGUAGE_COUNT") + 1;      
				SetLocalInt(oPC, "LANGUAGE_COUNT", nCount);      
					  
				// Grant the language using existing function      
				GrantLanguage(oPC, nLanguageFeat);      
					  
				// Clean up temp vars      
				DeleteLocalString(oPC, "TEMP_LANG_NAME");      
				DeleteLocalString(oPC, "TEMP_LANG_VAR");      
				DeleteLocalInt(oPC, "TEMP_LANG_FEAT");      
				DeleteLocalString(oPC, "TEMP_LANG_DESC");      
					  
				// Check if player has used all language picks    
				int nIntMod = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);      
				if (nIntMod <= 0) nIntMod = 0;      
						
				if (nCount >= nIntMod) {      
					SetPersistantLocalInt(oPC, "CC4_DONE", 1);      
					AllowExit(DYNCONV_EXIT_FORCE_EXIT, TRUE, oPC);  
					DelayCommand(0.1f, StartDynamicConversation("bg_profs_cv", oPC));      
				} 
				else 
				{      
					// Return to list, force refresh      
					MarkStageNotSetUp(STAGE_CONFIRM, oPC);      
					MarkStageNotSetUp(STAGE_LIST, oPC);      
					SetStage(STAGE_LIST, oPC);       
				}      
			}      
			else if (nChoice == CHOICE_CONFIRM_NO) 
			{        
				// Clean up temp vars before going back  
				DeleteLocalString(oPC, "TEMP_LANG_NAME");        
				DeleteLocalString(oPC, "TEMP_LANG_VAR");        
				DeleteLocalInt(oPC, "TEMP_LANG_FEAT");        
				DeleteLocalString(oPC, "TEMP_LANG_DESC");  
				  
				// Go back to list      
				MarkStageNotSetUp(STAGE_CONFIRM, oPC);
				MarkStageNotSetUp(STAGE_LIST, oPC); 				
				SetStage(STAGE_LIST, oPC);     
			}    
		}      
	}
}



