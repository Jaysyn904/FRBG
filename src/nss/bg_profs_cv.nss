// bg_proficiency_cv.nss  
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

// Check if PC already knows a proficiency
int KnowsProficiency(object oPC, int nProficiencyFeat)  
{  
    object oItem = EnsurePlayerDataObject(oPC);  
  
    int i = 0;  
    string sSlot;  
  
    while (i < 10)  
    {  
        sSlot = "PROFICIENCY_" + (i < 10 ? "0" : "") + IntToString(i);  
  
        // Check BOTH storage locations where GrantnProficiency saves data  
        if (GetPersistantLocalInt(oPC, sSlot) == nProficiencyFeat)  
            return TRUE;  
  
        if (GetIsObjectValid(oItem))  
        {  
            if (GetLocalInt(oItem, sSlot) == nProficiencyFeat)  
                return TRUE;  
        }  
  
        i++;  
    }  
  
    return FALSE;  
}

// Function to get the next available proficiency slot     
int GetNextProficiencySlot(object oPC)    
{    
    object oItem = EnsurePlayerDataObject(oPC);    
    if (!GetIsObjectValid(oItem)) return 0;    
        
    int i = 0;    
    string sSlot;    
        
    // Find the first empty slot    
    while (i < 99) 
    {    
        sSlot = "PROFICIENCY_" + (i < 10 ? "0" : "") + IntToString(i);    
        if (!GetLocalInt(oItem, sSlot))    
            return i;    
        i++;    
    }    
    return -1; // No slots available    
}
 
  // Grant a proficiency to PC 
 void GrantProficiency(object oPC, int nProficiencyFeat)
{
    object oItem = EnsurePlayerDataObject(oPC);
    if (!GetIsObjectValid(oItem)) return;

    if (KnowsProficiency(oPC, nProficiencyFeat))
        return;

    int nSlot = GetNextProficiencySlot(oPC);
    if (nSlot >= 0)
    {
        string sSlot = "PROFICIENCY_" + (nSlot < 10 ? "0" : "") + IntToString(nSlot);
        SetLocalInt(oItem, sSlot, nProficiencyFeat);
        SetPersistantLocalInt(oPC, sSlot, nProficiencyFeat);
    }

    // mark as selected for the conversation list
    SetLocalInt(oPC, IntToString(nProficiencyFeat), TRUE);
}
 
 

// prof_chk_alchemy  
// Requirements: Any Standing  
int CheckAlchemyProficiency(object oPC = OBJECT_SELF)  
{  
    return TRUE; // Always available  
}  
  
// prof_chk_anatomy    
// Requirements: Upper or Middle Class Standing  
int CheckAnatomyProficiency(object oPC = OBJECT_SELF)  
{  
    int nClass 	= BACKGROUND_LOWER;
	nClass 		= GetPersistantLocalInt(oPC, "CC1"); 
	
    return (nClass == BACKGROUND_MIDDLE || nClass == BACKGROUND_UPPER);  
}  
  
// prof_chk_armor  
// Requirements: Lower Class Standing  
int CheckArmorsmithingProficiency(object oPC = OBJECT_SELF)  
{  
    int nClass 	= BACKGROUND_LOWER;
	nClass 		= GetPersistantLocalInt(oPC, "CC1");
    return (nClass == BACKGROUND_LOWER);  
}  
  
// prof_chk_astro  
// Requirements: Middle or Upper Class Standing  
int CheckAstronomyProficiency(object oPC = OBJECT_SELF)  
{  
    int nClass 	= BACKGROUND_LOWER;
	nClass 		= GetPersistantLocalInt(oPC, "CC1"); 
    return (nClass == BACKGROUND_MIDDLE || nClass == BACKGROUND_UPPER);  
}  
  
// prof_chk_carp  
// Requirements: Any Standing  
int CheckCarpentryProficiency(object oPC = OBJECT_SELF)  
{  
    return TRUE; // Always available  
}  
  
// prof_chk_deciph  
// Requirements: Middle or Upper Class Standing  
int CheckDecipherScriptProficiency(object oPC = OBJECT_SELF)  
{  
    int nClass 	= BACKGROUND_LOWER;
	nClass 		= GetPersistantLocalInt(oPC, "CC1");  
    return (nClass == BACKGROUND_MIDDLE || nClass == BACKGROUND_UPPER);  
}  
  
// prof_chk_disguis  
// Requirements: Any Standing  
int CheckDisguiseProficiency(object oPC = OBJECT_SELF)  
{  
    return TRUE; // Always available  
}  
  
// prof_chk_fire  
// Requirements: Any Standing  
int CheckFiremakingProficiency(object oPC = OBJECT_SELF)  
{  
    return TRUE; // Always available  
}  
  
// prof_chk_guns  
// Requirements: None  
int CheckGunsmithingProficiency(object oPC = OBJECT_SELF)  
{  
    return TRUE; // Always available  
}  
  
// prof_chk_herb  
// Requirements: Any Standing  
int CheckHerbalismProficiency(object oPC = OBJECT_SELF)  
{  
    return TRUE; // Always available  
}  
  
// prof_chk_hist  
// Requirements: Middle or Upper Class Standing  
int CheckHistoryProficiency(object oPC = OBJECT_SELF)  
{  
    int nClass 	= BACKGROUND_LOWER;
	nClass 		= GetPersistantLocalInt(oPC, "CC1"); 
    return (nClass == BACKGROUND_MIDDLE || nClass == BACKGROUND_UPPER);  
}  
  
// prof_chk_hunt  
// Requirements: Any Standing  
int CheckHuntingProficiency(object oPC = OBJECT_SELF)  
{  
    return TRUE; // Always available  
}  
  
// prof_chk_mason  
// Requirements: Middle or Lower Class Standing  
int CheckMasonryProficiency(object oPC = OBJECT_SELF)  
{  
    int nClass 	= BACKGROUND_LOWER;
	nClass 		= GetPersistantLocalInt(oPC, "CC1"); 
    return (nClass == BACKGROUND_LOWER || nClass == BACKGROUND_MIDDLE);  
}  
  
// prof_chk_mining  
// Requirements: Lower Class Standing  
int CheckMiningProficiency(object oPC = OBJECT_SELF)  
{  
    int nClass 	= BACKGROUND_LOWER;
	nClass 		= GetPersistantLocalInt(oPC, "CC1"); 
    return (nClass == BACKGROUND_LOWER);  
}  
  
// prof_chk_obs  
// Requirements: Any Standing  
int CheckObservationProficiency(object oPC = OBJECT_SELF)  
{  
    return TRUE; // Always available  
}  
  
// prof_chk_siege  
// Requirements: Any Standing  
int CheckSiegeEngineeringProficiency(object oPC = OBJECT_SELF)  
{  
    return TRUE; // Always available  
}  
  
// prof_chk_smelt  
// Requirements: Lower Class Standing  
int CheckSmeltingProficiency(object oPC = OBJECT_SELF)  
{  
    int nClass 	= BACKGROUND_LOWER;
	nClass 		= GetPersistantLocalInt(oPC, "CC1");
    return (nClass == BACKGROUND_LOWER);  
}  
  
// prof_chk_tailor  
// Requirements: Any Standing  
int CheckTailoringProficiency(object oPC = OBJECT_SELF)  
{  
    return TRUE; // Always available  
}  
  
// prof_chk_track  
// Requirements: Any Standing  
int CheckTrackingProficiency(object oPC = OBJECT_SELF)  
{  
    return TRUE; // Always available  
}  
  
// prof_chk_wood  
// Requirements: Any Standing  
int CheckWoodGatheringProficiency(object oPC = OBJECT_SELF)  
{  
    return TRUE; // Always available  
}  
  
// prof_chk_l  
// No Options Left - shows when player has selected all proficiencies or has no slots  
int CheckNoOptionsLeft(object oPC = OBJECT_SELF)  
{  
    int nProfCount = GetLocalInt(oPC, "PROFICIENCY_COUNT");  
    int nMaxProfs = GetLocalInt(oPC, "MAX_PROFICIENCIES");  
    return (nProfCount >= nMaxProfs);  
}  

// Constants for stages  
const int STAGE_LIST = 0;  
const int STAGE_CONFIRM = 1;  
  
// Constants for choices  
const int CHOICE_CONFIRM_YES = 100;  
const int CHOICE_CONFIRM_NO = 101;    
  
void main() {    
    object oPC = GetPCSpeaker();    
    SendMessageToPC(oPC, "DEBUG: bg_prof_cv main() entered"); 

	object oItem = EnsurePlayerDataObject(oPC);
	
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);    
    int nStage = GetStage(oPC);    
    
    // Required guard: abort if nValue is 0    
    if (nValue == 0) return;    
    
    if (nValue == DYNCONV_SETUP_STAGE) {  
        if (!GetIsStageSetUp(nStage, oPC)) {    
            if (nStage == STAGE_LIST) {    
                // Initialize proficiency count if not set  
                if (!GetLocalInt(oPC, "PROFICIENCY_COUNT")) {  
                    SetLocalInt(oPC, "PROFICIENCY_COUNT", 0);  
                }  
                if (!GetLocalInt(oPC, "MAX_PROFICIENCIES")) {  
                    SetLocalInt(oPC, "MAX_PROFICIENCIES", 3);  
                }  
                  
                int nProfCount = GetLocalInt(oPC, "PROFICIENCY_COUNT");  
                string sHeader = "Now you will select your proficiencies. All characters are allowed three proficiencies. ";  
                sHeader += "Some proficiencies are only available to certain class standing.\n\n";  
                sHeader += "Proficiencies selected: " + IntToString(nProfCount) + "/3";  
                SetHeader(sHeader);    
    
                // Check if proficiency is already selected  
                if (!GetLocalInt(oPC, "PROF_SELECTED_ALCHEMY") && CheckAlchemyProficiency()) {      
                    AddChoice("Alchemy", 1, oPC);      
                    SetLocalString(oPC, "prof_dyn_text_1", "Allows you to combine and refine natural or unnatural elements into new and exciting combinations.\nRequirements: Any Standing");      
                }      
                if (!GetLocalInt(oPC, "PROF_SELECTED_ANATOMY") && CheckAnatomyProficiency()) {      
                    AddChoice("Anatomy", 2, oPC);      
                    SetLocalString(oPC, "prof_dyn_text_2", "This proficiency represents the study of the anatomy of living things. It enables a character to increase their effective critical hit severity by +2, as well as increase the save DC vs. death for a critical hit effect by +2. Additionally, a character with Anatomy proficiency receives a +2 bonus to heal checks when applying a bandage, and they receive a +2 bonus to hunting checks to recover an organ or other resource.\nRequirements: Upper or Middle Class Standing");      
                }      
                if (!GetLocalInt(oPC, "PROF_SELECTED_ARMOR") && CheckArmorsmithingProficiency()) {      
                    AddChoice("Armorsmithing", 3, oPC);      
                    SetLocalString(oPC, "prof_dyn_text_3", "Allows you to craft armor from base materials.\nRequirements: Lower Class Standing");      
                }      
                if (!GetLocalInt(oPC, "PROF_SELECTED_ASTRO") && CheckAstronomyProficiency()) {      
                    AddChoice("Astronomy", 4, oPC);      
                    SetLocalString(oPC, "prof_dyn_text_4", "Allows you to study celestial bodies and navigate by the stars.\nRequirements: Middle or Upper Class Standing");      
                }      
                if (!GetLocalInt(oPC, "PROF_SELECTED_CARP") && CheckCarpentryProficiency()) {      
                    AddChoice("Carpentry", 5, oPC);      
                    SetLocalString(oPC, "prof_dyn_text_5", "Allows you to work wood to create placeables or other objects.\nRequirements: Any Standing");      
                }      
                if (!GetLocalInt(oPC, "PROF_SELECTED_DECIPH") && CheckDecipherScriptProficiency()) {      
                    AddChoice("Decipher Script", 6, oPC);      
                    SetLocalString(oPC, "prof_dyn_text_6", "Allows you to decode and understand coded or arcane writings.\nRequirements: Middle or Upper Class Standing");      
                }      
                if (!GetLocalInt(oPC, "PROF_SELECTED_DISGUISE") && CheckDisguiseProficiency()) {      
                    AddChoice("Disguise", 7, oPC);      
                    SetLocalString(oPC, "prof_dyn_text_7", "Allows you to alter your appearance and impersonate others.\nRequirements: Any Standing");      
                }      
                if (!GetLocalInt(oPC, "PROF_SELECTED_FIRE") && CheckFiremakingProficiency()) {      
                    AddChoice("Firemaking", 8, oPC);      
                    SetLocalString(oPC, "prof_dyn_text_8", "Allows you to create and maintain fires in various conditions.\nRequirements: Any Standing");      
                }      
                if (!GetLocalInt(oPC, "PROF_SELECTED_GUNS") && CheckGunsmithingProficiency()) {      
                    AddChoice("Gunsmithing", 9, oPC);      
                    SetLocalString(oPC, "prof_dyn_text_9", "This proficiency enables a character to make firearms from base crafting materials, as well as make modifications to a firearm without a requiring a crafting roll.\nRequirements: None");      
                }      
                if (!GetLocalInt(oPC, "PROF_SELECTED_HERB") && CheckHerbalismProficiency()) {      
                    AddChoice("Herbalism", 10, oPC);      
                    SetLocalString(oPC, "prof_dyn_text_10", "Allows you to combine and refine natural or unnatural elements into new and exciting combinations.\nRequirements: Any Standing");      
                }      
                if (!GetLocalInt(oPC, "PROF_SELECTED_HIST") && CheckHistoryProficiency()) {      
                    AddChoice("History", 11, oPC);      
                    SetLocalString(oPC, "prof_dyn_text_11", "Allows you to recall historical events and lore.\nRequirements: Middle or Upper Class Standing");      
                }      
                if (!GetLocalInt(oPC, "PROF_SELECTED_HUNT") && CheckHuntingProficiency()) {      
                    AddChoice("Hunting", 12, oPC);      
                    SetLocalString(oPC, "prof_dyn_text_12", "Allows you to track and harvest game.\nRequirements: Any Standing");      
                }      
                if (!GetLocalInt(oPC, "PROF_SELECTED_MASON") && CheckMasonryProficiency()) {      
                    AddChoice("Masonry", 13, oPC);      
                    SetLocalString(oPC, "prof_dyn_text_13", "Allows you to work stone in order to create placeables or other objects.\nRequirements: Middle or Lower Class Standing");      
                }      
                if (!GetLocalInt(oPC, "PROF_SELECTED_MINING") && CheckMiningProficiency()) {      
                    AddChoice("Mining", 14, oPC);      
                    SetLocalString(oPC, "prof_dyn_text_14", "Allows you to gather useful ores, metals, and minerals from rock.\nRequirements: Lower Class Standing");      
                }      
                if (!GetLocalInt(oPC, "PROF_SELECTED_OBS") && CheckObservationProficiency()) {      
                    AddChoice("Observation", 15, oPC);      
                    SetLocalString(oPC, "prof_dyn_text_15", "Allows you to notice details and perceive hidden things.\nRequirements: Any Standing");      
                }      
                if (!GetLocalInt(oPC, "PROF_SELECTED_SIEGE") && CheckSiegeEngineeringProficiency()) {      
                    AddChoice("Siege Engineering", 16, oPC);      
                    SetLocalString(oPC, "prof_dyn_text_16", "Allows you to construct and operate siege weapons.\nRequirements: Any Standing");      
                }      
                if (!GetLocalInt(oPC, "PROF_SELECTED_SMELT") && CheckSmeltingProficiency()) {      
                    AddChoice("Smelting", 17, oPC);      
                    SetLocalString(oPC, "prof_dyn_text_17", "Allows you to refine ores into usable metals.\nRequirements: Lower Class Standing");      
                }      
                if (!GetLocalInt(oPC, "PROF_SELECTED_TAILOR") && CheckTailoringProficiency()) {      
                    AddChoice("Tailoring", 18, oPC);      
                    SetLocalString(oPC, "prof_dyn_text_18", "Allows you to craft clothing and leather goods.\nRequirements: Any Standing");      
                }      
                if (!GetLocalInt(oPC, "PROF_SELECTED_TRACK") && CheckTrackingProficiency()) {      
                    AddChoice("Tracking", 19, oPC);      
                    SetLocalString(oPC, "prof_dyn_text_19", "Allows you to follow tracks and trails.\nRequirements: Any Standing");      
                }      
                if (!GetLocalInt(oPC, "PROF_SELECTED_WOOD") && CheckWoodGatheringProficiency()) {      
                    AddChoice("Wood Gathering", 20, oPC);      
                    SetLocalString(oPC, "prof_dyn_text_20", "Allows you to gather wood from trees.\nRequirements: Any Standing");      
                }      
                  
                // Show Done option if at least one proficiency selected  
                if (nProfCount > 0) {  
                    AddChoice("Done - I have selected enough proficiencies", 21, oPC);  
                    SetLocalString(oPC, "prof_dyn_text_21", "Finish proficiency selection and continue to the next step.");  
                }  
                  
                MarkStageSetUp(nStage, oPC);    
                SetDefaultTokens();    
            }    
            else if (nStage == STAGE_CONFIRM) {  
                string sProfName = GetLocalString(oPC, "TEMP_PROF_NAME");  
                string sProfDesc = GetLocalString(oPC, "TEMP_PROF_DESC");  
                  
                string sHeader = "Are you sure you want to select " + sProfName + "?\n\n";  
                sHeader += sProfDesc;  
                SetHeader(sHeader);  
                  
                AddChoice("Yes, select this proficiency", CHOICE_CONFIRM_YES, oPC);  
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
            if (nChoice == 21) 
			{    
                // Done - finalize and proceed to next step  
                ExecuteScript("prof_give_nomore", oPC);    
            } 
			else if (nChoice >= 1 && nChoice <= 20) 
			{    
                // Store proficiency info for confirmation  
                string sProfName;  
                string sProfVar;  
                string sGrant;  
                  
                switch (nChoice) 
				{    
                    case 1:
					{
						sProfName = "Alchemy"; 
						sProfVar = "ALCHEMY"; 
						//sGrant = "prof_give_alchem"; 
						GrantProficiency(oPC, PROFICIENCY_ALCHEMY);						
						break; 
					}						
                    case 2:
					{
						sProfName = "Anatomy"; 
						sProfVar = "ANATOMY"; 
						//sGrant = "prof_give_anatomy"; 
						GrantProficiency(oPC, PROFICIENCY_ANATOMY);	
						break;    
					}					
                    case 3:
					{
						sProfName = "Armorsmithing"; 
						sProfVar = "ARMOR"; 
						//sGrant = "prof_give_armor"; 
						GrantProficiency(oPC, PROFICIENCY_ARMORING);
						break;    
					}
                    case 4:
					{
						sProfName = "Astrology"; 
						sProfVar = "ASTRO"; 
						//sGrant = "prof_give_astro"; 
						GrantProficiency(oPC, PROFICIENCY_ASTROLOGY);
						break;
					}						
                    case 5:
					{
						sProfName = "Carpentry"; 
						sProfVar = "CARP"; 
						//sGrant = "prof_give_carp"; 
						GrantProficiency(oPC, PROFICIENCY_CARPENTRY);
						break;    
					}
                    case 6:
					{
						sProfName = "Decipher Script"; 
						sProfVar = "DECIPH"; 
						//sGrant = "prof_give_deciph"; 
						GrantProficiency(oPC, PROFICIENCY_DECIPHER);
						break;    
					}
                    case 7:
					{
						sProfName = "Disguise"; 
						sProfVar = "DISGUISE"; 
						//sGrant = "prof_give_disgui"; 
						GrantProficiency(oPC, PROFICIENCY_DISGUISE);
						break;    
					}
                    case 8:
					{
						sProfName = "Firemaking"; 
						sProfVar = "FIRE"; 
						//sGrant = "prof_give_fire"; 
						GrantProficiency(oPC, PROFICIENCY_FIRE);
						break;    
					}
                    case 9:
					{
						sProfName = "Gunsmithing"; 
						sProfVar = "GUNS"; 
						//sGrant = "prof_give_guns"; 
						GrantProficiency(oPC, PROFICIENCY_GUNSMITHING);
						break;
					}						
                    case 10: 
					{
						sProfName = "Herbalism"; 
						sProfVar = "HERB"; 
						//sGrant = "prof_give_herb"; 
						GrantProficiency(oPC, PROFICIENCY_HERBALISM);
						break;    
					}
                    case 11:
					{
						sProfName = "History"; 
						sProfVar = "HIST"; 
						//sGrant = "prof_give_hist"; 
						GrantProficiency(oPC, PROFICIENCY_HISTORY);
						break;
					}						
                    case 12:
					{
						sProfName = "Hunting"; 
						sProfVar = "HUNT"; 
						//sGrant = "prof_give_hunt";
						GrantProficiency(oPC, PROFICIENCY_HUNTING);
						break;    
					}
                    case 13:
					{
						sProfName = "Masonry"; 
						sProfVar = "MASON"; 
						//sGrant = "prof_give_mason";
						GrantProficiency(oPC, PROFICIENCY_MASONRY);
						break;    
					}
                    case 14:
					{
						sProfName = "Mining"; 
						sProfVar = "MINING"; 
						//sGrant = "prof_give_mine"; 
						GrantProficiency(oPC, PROFICIENCY_MINING);
						break;    
					}
                    case 15: 
					{
						sProfName = "Observation"; 
						sProfVar = "OBS"; 
						//sGrant = "prof_give_obs"; 
						GrantProficiency(oPC, PROFICIENCY_OBSERVATION);
						break;    
					}
                    case 16:
					{
						sProfName = "Siege Engineering"; 
						sProfVar = "SIEGE"; 
						//sGrant = "prof_give_siege"; 
						GrantProficiency(oPC, PROFICIENCY_SIEGE);
						break;    
					}
                    case 17:
					{
						sProfName = "Smelting"; 
						sProfVar = "SMELT"; 
						//sGrant = "prof_give_smelt"; 
						GrantProficiency(oPC, PROFICIENCY_SMELTING);
						break;    
					}
                    case 18:
					{
						sProfName = "Tailoring"; 
						sProfVar = "TAILOR"; 
						//sGrant = "prof_give_tailor"; 
						GrantProficiency(oPC, PROFICIENCY_TAILORING);
						break;
					}						
                    case 19:
					{
						sProfName = "Tracking"; 
						sProfVar = "TRACK"; 
						//sGrant = "prof_give_track";
						GrantProficiency(oPC, PROFICIENCY_TRACKING);
						break;    
					}
                    case 20:
					{
						sProfName = "Wood Gathering"; 
						sProfVar = "WOOD"; 
						//sGrant = "prof_give_wood"; 
						GrantProficiency(oPC, PROFICIENCY_WOOD_GATHERING);
						break;
					}						
                }  
                  
                SetLocalString(oPC, "TEMP_PROF_NAME", sProfName);  
                SetLocalString(oPC, "TEMP_PROF_VAR", sProfVar);  
                SetLocalString(oPC, "TEMP_PROF_GRANT", sGrant);  
                SetLocalString(oPC, "TEMP_PROF_DESC", GetLocalString(oPC, "prof_dyn_text_" + IntToString(nChoice)));  
                  
                // Move to confirmation stage  
                SetStage(STAGE_CONFIRM, oPC);  
            }  
        }  
        else if (nStage == STAGE_CONFIRM) 
		{  
            if (nChoice == CHOICE_CONFIRM_YES) 
			{  
				// Confirm selection - grant proficiency  
				string sProfVar = GetLocalString(oPC, "TEMP_PROF_VAR");  
				string sGrant = GetLocalString(oPC, "TEMP_PROF_GRANT");  
				  
				// Mark as selected  
				SetLocalInt(oPC, "PROF_SELECTED_" + sProfVar, TRUE);  
				  
				// Increment count  
				int nCount = GetLocalInt(oPC, "PROFICIENCY_COUNT") + 1;  
				SetLocalInt(oPC, "PROFICIENCY_COUNT", nCount);  
				  
				// Grant the proficiency  
				ExecuteScript(sGrant, oPC);  
				  
				// Clean up temp vars  
				DeleteLocalString(oPC, "TEMP_PROF_NAME");  
				DeleteLocalString(oPC, "TEMP_PROF_VAR");  
				DeleteLocalString(oPC, "TEMP_PROF_GRANT");  
				DeleteLocalString(oPC, "TEMP_PROF_DESC");  
				  
				// Check if player has selected 3 proficiencies  
				if (nCount >= 3) 
				{  
					// Auto-finish  
					SetLocalInt(oItem,"BG_Select",6);
					ActionStartConversation(oPC,"bg_final",TRUE); 
				} 
				else 
				{  
					// Return to list, force refresh  
					MarkStageNotSetUp(STAGE_CONFIRM, oPC);  
					MarkStageNotSetUp(STAGE_LIST, oPC);  
					nStage = STAGE_LIST; // Add this line  
				}  
			} 
            else if (nChoice == CHOICE_CONFIRM_NO)   
			{      
				// Clean up temp vars before going back    
				DeleteLocalString(oPC, "TEMP_PROF_NAME");      
				DeleteLocalString(oPC, "TEMP_PROF_VAR");      
				DeleteLocalString(oPC, "TEMP_PROF_GRANT");      
				DeleteLocalString(oPC, "TEMP_PROF_DESC");    
				
				// Go back to list - update local nStage variable    
				MarkStageNotSetUp(STAGE_CONFIRM, oPC);    
				MarkStageNotSetUp(STAGE_LIST, oPC); 				    
				nStage = STAGE_LIST; // update local nStage        
			}
			
			SetStage(nStage, oPC);			
        }  
    }    
}

