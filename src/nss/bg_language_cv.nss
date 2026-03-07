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
	SendMessageToPC(oPC, "Language data object recreated");
	WriteTimestampedLogEntry("Language data object recreated");    
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

    int i = 0;
    string sSlot;

    while (i < 20)
    {
        sSlot = "LANGUAGE_" + (i < 10 ? "0" : "") + IntToString(i);

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
    while (i < 99) // Maximum 99 languages  
    {  
        sSlot = "LANGUAGE_" + (i < 10 ? "0" : "") + IntToString(i);  
        if (!GetLocalInt(oItem, sSlot))  
            return i;  
        i++;  
    }  
    return -1; // No slots available  
}  
 
void GrantLanguage(object oPC, int nLanguageFeat)    
{    
    object oItem = EnsurePlayerDataObject(oPC);    
    if (!GetIsObjectValid(oItem)) return;    
      
    // Debug: Check if language already exists  
    if (KnowsLanguage(oPC, nLanguageFeat)) {  
        string sMsg = "Language " + IntToString(nLanguageFeat) + " already exists, skipping grant";  
        SendMessageToPC(oPC, sMsg);  
        WriteTimestampedLogEntry(sMsg);  
        return;  
    }  
      
    string sMsg = "Granting language " + IntToString(nLanguageFeat);  
    SendMessageToPC(oPC, sMsg);  
    WriteTimestampedLogEntry(sMsg);  
        
    int nSlot = GetNextLanguageSlot(oPC);    
    if (nSlot >= 0)    
    {    
        string sSlot = "LANGUAGE_" + (nSlot < 20 ? "0" : "") + IntToString(nSlot);    
        SetLocalInt(oItem, sSlot, nLanguageFeat);    
        SetPersistantLocalInt(oPC, sSlot, nLanguageFeat);    
          
        sMsg = "Stored in slot " + sSlot;  
        SendMessageToPC(oPC, sMsg);  
        WriteTimestampedLogEntry(sMsg);  
    }    
} 
  
/* // Grant a language to PC    
void GrantLanguage(object oPC, int nLanguageFeat)    
{    
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");    
    if (!GetIsObjectValid(oItem)) return;    
      
    // Check if language already exists  
    if (KnowsLanguage(oPC, nLanguageFeat)) return;  
        
    int nSlot = GetNextLanguageSlot(oPC);    
    if (nSlot >= 0)    
    {    
        string sSlot = "LANGUAGE_" + (nSlot < 20 ? "0" : "") + IntToString(nSlot);    
        SetLocalInt(oItem, sSlot, nLanguageFeat);    
        SetPersistantLocalInt(oPC, sSlot, nLanguageFeat);    
    }    
} */

/* void GrantLanguage(object oPC, int nLanguageFeat)  
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
  */
  
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
        
    while (i < 20)    
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
    while (i < 99)  
    {  
        sSlot = "LANGUAGE_" + (i < 10 ? "0" : "") + IntToString(i);  
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
 
 
 void main()      
{      
    object oPC = GetPCSpeaker();  
    object oItem = EnsurePlayerDataObject(oPC);

	GrantDefaultLanguages(oPC);

	int nTotal = 0;  
	int i = 0;  
	string sSlot;  
	while (i < 20) {  
		sSlot = "LANGUAGE_" + (i < 10 ? "0" : "") + IntToString(i);  
		if (GetLocalInt(oItem, sSlot)) {  
			nTotal++;
			SendMessageToPC(oPC, "***************LANGUAGE*TEST********************"); 
			WriteTimestampedLogEntry("***************LANGUAGE*TEST********************");			
			SendMessageToPC(oPC, "Found language in slot " + sSlot + ": " + IntToString(GetLocalInt(oItem, sSlot))); 
			WriteTimestampedLogEntry("Found language in slot " + sSlot + ": " + IntToString(GetLocalInt(oItem, sSlot))); 			
		}  
		i++;  
	}  

	SendMessageToPC(oPC, "Total languages: " + IntToString(nTotal));  
	WriteTimestampedLogEntry("Total languages: " + IntToString(nTotal));
	SendMessageToPC(oPC, "Automatic count: " + IntToString(GetAutomaticLanguageCount(oPC)));  
	WriteTimestampedLogEntry("Automatic count: " + IntToString(GetAutomaticLanguageCount(oPC)));  
	SendMessageToPC(oPC, "Bonus remaining: " + IntToString(GetBonusLanguageCount(oPC)));
	WriteTimestampedLogEntry("Bonus remaining: " + IntToString(GetBonusLanguageCount(oPC)));	
      
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);      
    int nStage = GetStage(oPC);      
    int nChoice = GetChoice();     
  
    int nBackground = GetLocalInt(oItem, "CC2");      
      
    int nCleric 	= GetLevelByClass(CLASS_TYPE_CLERIC, oPC);  
    int nDruid 		= GetLevelByClass(CLASS_TYPE_DRUID, oPC);  
    int nWizard 	= GetLevelByClass(CLASS_TYPE_WIZARD, oPC);
	int nDragDisc 	= GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE, oPC);
  
    int nAir = GetHasFeat(FEAT_AIR_DOMAIN_POWER, oPC);      
    int nEarth = GetHasFeat(FEAT_EARTH_DOMAIN_POWER, oPC);      
    int nFire = GetHasFeat(FEAT_FIRE_DOMAIN_POWER, oPC);  
    int nWater = GetHasFeat(FEAT_WATER_DOMAIN_POWER, oPC);  
        
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
				if (nRemaining > 0 && nCleric) {  
					AddChoiceIfNotKnown("Abyssal", 1, oPC, FEAT_LANGUAGE_ABYSSAL);  
				}  
				if (nRemaining > 0) {  
					AddChoiceIfNotKnown("Alzhedo", 2, oPC, FEAT_LANGUAGE_ALZHEDO);  
				}  
				if (nRemaining > 0 && nWater) {  
					AddChoiceIfNotKnown("Aquan", 3, oPC, FEAT_LANGUAGE_AQUAN);  
				}  
				if (nRemaining > 0 && nAir) {  
					AddChoiceIfNotKnown("Auran", 5, oPC, FEAT_LANGUAGE_AURAN);  
				}  
				if (nRemaining > 0 && nCleric) {  
					AddChoiceIfNotKnown("Celestial", 6, oPC, FEAT_LANGUAGE_CELESTIAL);  
				}  
				if (nRemaining > 0) {  
					AddChoiceIfNotKnown("Chessentan", 7, oPC, FEAT_LANGUAGE_CHESSENTAN);  
				}  
				if (nRemaining > 0) {  
					AddChoiceIfNotKnown("Chondathan", 8, oPC, FEAT_LANGUAGE_CHONDATHAN);  
				}  
				if (nRemaining > 0) {  
					AddChoiceIfNotKnown("Chultan", 9, oPC, FEAT_LANGUAGE_CHULTAN);  
				}  
				if (nRemaining > 0) {  
					AddChoiceIfNotKnown("Damaran", 10, oPC, FEAT_LANGUAGE_DAMARAN);  
				}  
				if (nRemaining > 0 && (nWizard || nDragDisc)) {  
					AddChoiceIfNotKnown("Draconic", 11, oPC, FEAT_LANGUAGE_DRACONIC);  
				}  
				if (nRemaining > 0 && (KnowsLanguage(oPC, FEAT_LANGUAGE_UNDERCOMMON) ||   
									  KnowsLanguage(oPC, FEAT_LANGUAGE_ELVEN) ||   
									  KnowsLanguage(oPC, FEAT_LANGUAGE_IMASKARI))) {  
					AddChoiceIfNotKnown("Drow", 12, oPC, FEAT_LANGUAGE_DROW);  
				}  
				if (nRemaining > 0 && (KnowsLanguage(oPC, FEAT_LANGUAGE_UNDERCOMMON) ||   
									  KnowsLanguage(oPC, FEAT_LANGUAGE_DWARVEN) ||   
									  KnowsLanguage(oPC, FEAT_LANGUAGE_IMASKARI))) {  
					AddChoiceIfNotKnown("Duergar", 13, oPC, FEAT_LANGUAGE_DUERGAR);  
				}  
				if (nRemaining > 0) {  
					AddChoiceIfNotKnown("Dwarven", 14, oPC, FEAT_LANGUAGE_DWARVEN);  
				}  
				if (nRemaining > 0) {  
					AddChoiceIfNotKnown("Elven", 15, oPC, FEAT_LANGUAGE_ELVEN);  
				}  
				if (nRemaining > 0) {  
					AddChoiceIfNotKnown("Giant", 16, oPC, FEAT_LANGUAGE_GIANT);  
				}  
				if (nRemaining > 0) {  
					AddChoiceIfNotKnown("Gnomish", 17, oPC, FEAT_LANGUAGE_GNOMISH);  
				}  
				if (nRemaining > 0) {  
					AddChoiceIfNotKnown("Goblin", 18, oPC, FEAT_LANGUAGE_GOBLIN);  
				}  
				if (nRemaining > 0) {  
					AddChoiceIfNotKnown("Halfling", 19, oPC, FEAT_LANGUAGE_HALFLING);  
				}  
				if (nRemaining > 0 && nFire) {  
					AddChoiceIfNotKnown("Ignan", 20, oPC, FEAT_LANGUAGE_IGNAN);  
				}  
				if (nRemaining > 0) {  
					AddChoiceIfNotKnown("Illuskan", 21, oPC, FEAT_LANGUAGE_ILLUSKAN);  
				}  
				if (nRemaining > 0) {  
					AddChoiceIfNotKnown("Imaskari", 22, oPC, FEAT_LANGUAGE_IMASKARI);  
				}  
				if (nRemaining > 0 && nCleric) {  
					AddChoiceIfNotKnown("Infernal", 23, oPC, FEAT_LANGUAGE_INFERNAL);  
				}  
				if (nRemaining > 0) {  
					AddChoiceIfNotKnown("Lantanese", 24, oPC, FEAT_LANGUAGE_LANTANESE);  
				}  
				if (nRemaining > 0) {  
					AddChoiceIfNotKnown("Mulanese", 25, oPC, FEAT_LANGUAGE_MAZTILAN);  
				}  
				if (nRemaining > 0) {  
					AddChoiceIfNotKnown("Mulanese", 26, oPC, FEAT_LANGUAGE_MULANESE);  
				}  
				if (nRemaining > 0) {  
					AddChoiceIfNotKnown("Mulhorandi", 27, oPC, FEAT_LANGUAGE_MULHORANDI);  
				}  
				if (nRemaining > 0) {  
					AddChoiceIfNotKnown("Orcish", 28, oPC, FEAT_LANGUAGE_ORCISH);  
				}  
				if (nRemaining > 0) {  
					AddChoiceIfNotKnown("Rashemi", 29, oPC, FEAT_LANGUAGE_RASHEMI);  
				}  
				if (nRemaining > 0 && nDruid) {  
					AddChoiceIfNotKnown("Sylvan", 30, oPC, FEAT_LANGUAGE_SYLVAN);  
				}  
				if (nRemaining > 0) {  
					AddChoiceIfNotKnown("Talfiric", 31, oPC, FEAT_LANGUAGE_TALFIRIC);  
				}  
				if (nRemaining > 0 && nEarth) {  
					AddChoiceIfNotKnown("Terran", 32, oPC, FEAT_LANGUAGE_TERRAN);  
				}  
				if (nRemaining > 0) {  
					AddChoiceIfNotKnown("Troglodyte", 33, oPC, FEAT_LANGUAGE_TROGLODYTE);  
				}  
				if (nRemaining > 0) {  
					AddChoiceIfNotKnown("Undercommon", 34, oPC, FEAT_LANGUAGE_UNDERCOMMON);  
				}

  				
 /*                if (nRemaining > 0 && nCleric && !KnowsLanguage(oPC, FEAT_LANGUAGE_ABYSSAL))
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
				if (nRemaining > 0 && ( nWizard || nDragDisc) && !KnowsLanguage(oPC, FEAT_LANGUAGE_DRACONIC))
				{					
					AddChoice("Draconic", 11, oPC);      
				}
				if (nRemaining > 0 && (KnowsLanguage(oPC, FEAT_LANGUAGE_UNDERCOMMON) || 
										KnowsLanguage(oPC, FEAT_LANGUAGE_ELVEN) || 
										KnowsLanguage(oPC, FEAT_LANGUAGE_IMASKARI)) && 
										!KnowsLanguage(oPC, FEAT_LANGUAGE_DROW))
				{					
					AddChoice("Drow", 12, oPC);      
				}				  
				if (nRemaining > 0 && (KnowsLanguage(oPC, FEAT_LANGUAGE_UNDERCOMMON) || 
										KnowsLanguage(oPC, FEAT_LANGUAGE_DWARVEN) || 
										KnowsLanguage(oPC, FEAT_LANGUAGE_IMASKARI)) && 
										!KnowsLanguage(oPC, FEAT_LANGUAGE_DUERGAR))
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
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_LANTANESE))
				{					
					AddChoice("Lantanese", 24, oPC);
				}
				if (nRemaining > 0 && !KnowsLanguage(oPC, FEAT_LANGUAGE_MAZTILAN))
				{					
					AddChoice("Mulanese", 25, oPC);
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
				}	  */  
                    
                // Refresh option      
                AddChoice("[Refresh Language Choices]", 99, oPC);      
                    
                MarkStageSetUp(nStage, oPC);      
                SetDefaultTokens();      
            }      
        }      
        SetupTokens();      
    }    
	// Add exit handler to start next conversation  
	else if(nValue == DYNCONV_EXITED)  
	{  
		DelayCommand(0.1f, StartDynamicConversation("bg_proficiency_cv", oPC));  
	}	
	// Handle PC responses      
    else      
    {      
        if(nStage == STAGE_LIST)      
        {      
            // Handle language selection      
            if (nChoice >= 1 && nChoice <= 34)      
            {      
                int nRemaining = GetBonusLanguageCount(oPC);      
                    
                if (nRemaining > 0)      
                {      
                    // Grant the selected language based on choice      
                    switch (nChoice)        
                    {        
                        case 1:
						{
							GrantLanguage(oPC, FEAT_LANGUAGE_ABYSSAL);      
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_ABYSSAL), TRUE); 
							break;  
						}
                        case 2:
						{
							GrantLanguage(oPC, FEAT_LANGUAGE_ALZHEDO); 
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_ALZHEDO), TRUE);
							break;        
						}
                        case 3:
						{
							GrantLanguage(oPC, FEAT_LANGUAGE_AQUAN); 
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_AQUAN), TRUE);
							break;    
						}
                        case 4:
						{
							GrantLanguage(oPC, FEAT_LANGUAGE_AURAN); 
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_AURAN), TRUE);
							break;        
						}
                        case 6:
						{
							GrantLanguage(oPC, FEAT_LANGUAGE_CELESTIAL); 
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_CELESTIAL), TRUE);
							break;        
						}
                        case 7:
						{
							GrantLanguage(oPC, FEAT_LANGUAGE_CHESSENTAN); 
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_CHESSENTAN), TRUE);
							break;        
						}
                        case 8:
						{
							GrantLanguage(oPC, FEAT_LANGUAGE_CHONDATHAN); 
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_CHONDATHAN), TRUE);
							break;        
						}
                        case 9:
						{
							GrantLanguage(oPC, FEAT_LANGUAGE_CHULTAN); 
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_CHULTAN), TRUE);
							break;        
						}
                        case 10:
						{
							GrantLanguage(oPC, FEAT_LANGUAGE_DAMARAN); 
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_DAMARAN), TRUE);
							break;        
						}
                        case 11:
						{
							GrantLanguage(oPC, FEAT_LANGUAGE_DRACONIC); 
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_DRACONIC), TRUE);
							break;        
						}
                        case 12:
						{
							GrantLanguage(oPC, FEAT_LANGUAGE_DROW); 
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_DROW), TRUE);
							break;      
						}
                        case 13:
						{
							GrantLanguage(oPC, FEAT_LANGUAGE_DUERGAR);
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_DUERGAR), TRUE);
							break;
						}					        
                        case 14:
						{
							GrantLanguage(oPC, FEAT_LANGUAGE_DWARVEN); 
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_DWARVEN), TRUE);
							break;        
						}
                        case 15:
						{
							GrantLanguage(oPC, FEAT_LANGUAGE_ELVEN); 
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_ELVEN), TRUE);
							break;        
						}
                        case 16:
						{	
							GrantLanguage(oPC, FEAT_LANGUAGE_GIANT); 
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_GIANT), TRUE);
							break;        
						}
                        case 17:
						{	
							GrantLanguage(oPC, FEAT_LANGUAGE_GNOMISH); 
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_GNOMISH), TRUE);
							break;        
						}
                        case 18:
						{
							GrantLanguage(oPC, FEAT_LANGUAGE_GOBLIN); 
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_GOBLIN), TRUE);
							break;        
						}
                        case 19:
						{
							GrantLanguage(oPC, FEAT_LANGUAGE_HALFLING); 
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_HALFLING), TRUE);
							break;        
						}
                        case 20:
						{
							GrantLanguage(oPC, FEAT_LANGUAGE_IGNAN); 
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_IGNAN), TRUE);
							break;        
						}
                        case 21:
						{
							GrantLanguage(oPC, FEAT_LANGUAGE_ILLUSKAN); 
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_ILLUSKAN), TRUE);
							break;        
						}
                        case 22:
						{
							GrantLanguage(oPC, FEAT_LANGUAGE_IMASKARI); 
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_IMASKARI), TRUE);
							break;        
						}
                        case 23: 
						{
							GrantLanguage(oPC, FEAT_LANGUAGE_INFERNAL); 
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_INFERNAL), TRUE);
							break; 
						}
                        case 24:
						{
							GrantLanguage(oPC, FEAT_LANGUAGE_LANTANESE); 
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_LANTANESE), TRUE);
							break;       
						}
                        case 25:
						{
							GrantLanguage(oPC, FEAT_LANGUAGE_MAZTILAN); 
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_MAZTILAN), TRUE);
							break;  						
						}							
                        case 26:
						{
							GrantLanguage(oPC, FEAT_LANGUAGE_MULANESE); 
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_MULANESE), TRUE);
							break;        
						}
                        case 27:
						{
							GrantLanguage(oPC, FEAT_LANGUAGE_MULHORANDI);
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_MULHORANDI), TRUE);
							break;        
						}
                        case 28:
						{
							GrantLanguage(oPC, FEAT_LANGUAGE_ORCISH);
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_ORCISH), TRUE);
							break;        
						}
                        case 29:
						{
							GrantLanguage(oPC, FEAT_LANGUAGE_RASHEMI);
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_RASHEMI), TRUE);
							break;        
						}
                        case 30:
						{
							GrantLanguage(oPC, FEAT_LANGUAGE_SYLVAN);
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_SYLVAN), TRUE);
							break;        
						}
                        case 31:
						{
							GrantLanguage(oPC, FEAT_LANGUAGE_TALFIRIC);
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_TALFIRIC), TRUE);
							break;        
						}
                        case 32:
						{
							GrantLanguage(oPC, FEAT_LANGUAGE_TERRAN);
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_TERRAN), TRUE);
							break;        
						}
                        case 33:
						{
							GrantLanguage(oPC, FEAT_LANGUAGE_TROGLODYTE);
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_TROGLODYTE), TRUE);
							break;        
						}
                        case 34:
						{
							GrantLanguage(oPC, FEAT_LANGUAGE_UNDERCOMMON);
							SetLocalInt(oPC, IntToString(FEAT_LANGUAGE_UNDERCOMMON), TRUE);
							break;        
						}
                    }   
                        
                    // Check if player is out of languages after granting this one  
                    if (GetBonusLanguageCount(oPC) == 0)  
                    {  
                        SetPersistantLocalInt(oPC, "CC4_DONE", 1);
						DelayCommand(0.1f, StartDynamicConversation("bg_profs_cv", oPC));		
                        AllowExit(DYNCONV_EXIT_FORCE_EXIT, TRUE, oPC);  
                    }  
                    else  
                    {  
                        // Rebuild stage to update available options      
                        MarkStageNotSetUp(nStage, oPC);      
                        SetStage(nStage, oPC);
  
                    }  
                }      
            }      
            // Handle refresh      
            else if (nChoice == 99)      
            {      
                MarkStageNotSetUp(nStage, oPC);      
                SetStage(nStage, oPC);      
            }      
        }      
    }      
        
    // Setup tokens for dynamic conversation system    
    SetupTokens();    
}  
  



/* void main()    
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
} */