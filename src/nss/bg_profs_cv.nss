// bg_proficiency_cv.nss  
#include "inc_dynconv"  
#include "x2_inc_switches"  
  
const int STAGE_LIST = 0;  
  
void main() {  
    object oPC = GetPCSpeaker();  
    SendMessageToPC(oPC, "DEBUG: bg_proficiency_cv main() entered");  
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);  
    int nStage = GetStage(oPC);  
  
    // Required guard: abort if nValue is 0  
    if (nValue == 0) return;  
  
    if (nValue == DYNCONV_SETUP_STAGE) {  
        if (!GetIsStageSetUp(nStage, oPC)) {  
            if (nStage == STAGE_LIST) {  
                SetHeader("Now you will select your proficiencies. All characters are allowed three proficiencies. Some proficiencies are only available to certain class standings.");  
  
                // Proficiency options with condition checks and grant scripts  
                if (ExecuteScriptAndReturnInt("prof_chk_alchemy", oPC)) {  
                    AddChoice("Alchemy", 1, oPC);  
                    SetLocalString(oPC, "prof_dyn_text_1", "Allows you to combine and refine natural or unnatural elements into new and exciting combinations.\nRequirements: Any Standing");  
                }  
                if (ExecuteScriptAndReturnInt("prof_chk_anatomy", oPC)) {  
                    AddChoice("Anatomy", 2, oPC);  
                    SetLocalString(oPC, "prof_dyn_text_2", "This proficiency represents the study of the anatomy of living things. It enables a character to increase their effective critical hit severity by +2, as well as increase the save DC vs. death for a critical hit effect by +2. Additionally, a character with Anatomy proficiency receives a +2 bonus to heal checks when applying a bandage, and they receive a +2 bonus to hunting checks to recover an organ or other resource.\nRequirements: Upper or Middle Class Standing");  
                }  
                if (ExecuteScriptAndReturnInt("prof_chk_armor", oPC)) {  
                    AddChoice("Armorsmithing", 3, oPC);  
                    SetLocalString(oPC, "prof_dyn_text_3", "Allows you to craft armor from base materials.\nRequirements: Lower Class Standing");  
                }  
                if (ExecuteScriptAndReturnInt("prof_chk_astro", oPC)) {  
                    AddChoice("Astronomy", 4, oPC);  
                    SetLocalString(oPC, "prof_dyn_text_4", "Allows you to study celestial bodies and navigate by the stars.\nRequirements: Middle or Upper Class Standing");  
                }  
                if (ExecuteScriptAndReturnInt("prof_chk_carp", oPC)) {  
                    AddChoice("Carpentry", 5, oPC);  
                    SetLocalString(oPC, "prof_dyn_text_5", "Allows you to work wood to create placeables or other objects.\nRequirements: Any Standing");  
                }  
                if (ExecuteScriptAndReturnInt("prof_chk_deciph", oPC)) {  
                    AddChoice("Decipher Script", 6, oPC);  
                    SetLocalString(oPC, "prof_dyn_text_6", "Allows you to decode and understand coded or arcane writings.\nRequirements: Middle or Upper Class Standing");  
                }  
                if (ExecuteScriptAndReturnInt("prof_chk_disguis", oPC)) {  
                    AddChoice("Disguise", 7, oPC);  
                    SetLocalString(oPC, "prof_dyn_text_7", "Allows you to alter your appearance and impersonate others.\nRequirements: Any Standing");  
                }  
                if (ExecuteScriptAndReturnInt("prof_chk_fire", oPC)) {  
                    AddChoice("Firemaking", 8, oPC);  
                    SetLocalString(oPC, "prof_dyn_text_8", "Allows you to create and maintain fires in various conditions.\nRequirements: Any Standing");  
                }  
                if (ExecuteScriptAndReturnInt("prof_chk_guns", oPC)) {  
                    AddChoice("Gunsmithing", 9, oPC);  
                    SetLocalString(oPC, "prof_dyn_text_9", "This proficiency enables a character to make firearms from base crafting materials, as well as make modifications to a firearm without a requiring a crafting roll.\nRequirements: None");  
                }  
                if (ExecuteScriptAndReturnInt("prof_chk_herb", oPC)) {  
                    AddChoice("Herbalism", 10, oPC);  
                    SetLocalString(oPC, "prof_dyn_text_10", "Allows you to combine and refine natural or unnatural elements into new and exciting combinations.\nRequirements: Any Standing");  
                }  
                if (ExecuteScriptAndReturnInt("prof_chk_hist", oPC)) {  
                    AddChoice("History", 11, oPC);  
                    SetLocalString(oPC, "prof_dyn_text_11", "Allows you to recall historical events and lore.\nRequirements: Middle or Upper Class Standing");  
                }  
                if (ExecuteScriptAndReturnInt("prof_chk_hunt", oPC)) {  
                    AddChoice("Hunting", 12, oPC);  
                    SetLocalString(oPC, "prof_dyn_text_12", "Allows you to track and harvest game.\nRequirements: Any Standing");  
                }  
                if (ExecuteScriptAndReturnInt("prof_chk_mason", oPC)) {  
                    AddChoice("Masonry", 13, oPC);  
                    SetLocalString(oPC, "prof_dyn_text_13", "Allows you to work stone in order to create placeables or other objects.\nRequirements: Middle or Lower Class Standing");  
                }  
                if (ExecuteScriptAndReturnInt("prof_chk_mining", oPC)) {  
                    AddChoice("Mining", 14, oPC);  
                    SetLocalString(oPC, "prof_dyn_text_14", "Allows you to gather useful ores, metals, and minerals from rock.\nRequirements: Lower Class Standing");  
                }  
                if (ExecuteScriptAndReturnInt("prof_chk_obs", oPC)) {  
                    AddChoice("Observation", 15, oPC);  
                    SetLocalString(oPC, "prof_dyn_text_15", "Allows you to notice details and perceive hidden things.\nRequirements: Any Standing");  
                }  
                if (ExecuteScriptAndReturnInt("prof_chk_siege", oPC)) {  
                    AddChoice("Siege Engineering", 16, oPC);  
                    SetLocalString(oPC, "prof_dyn_text_16", "Allows you to construct and operate siege weapons.\nRequirements: Any Standing");  
                }  
                if (ExecuteScriptAndReturnInt("prof_chk_smelt", oPC)) {  
                    AddChoice("Smelting", 17, oPC);  
                    SetLocalString(oPC, "prof_dyn_text_17", "Allows you to refine ores into usable metals.\nRequirements: Lower Class Standing");  
                }  
                if (ExecuteScriptAndReturnInt("prof_chk_tailor", oPC)) {  
                    AddChoice("Tailoring", 18, oPC);  
                    SetLocalString(oPC, "prof_dyn_text_18", "Allows you to craft clothing and leather goods.\nRequirements: Any Standing");  
                }  
                if (ExecuteScriptAndReturnInt("prof_chk_track", oPC)) {  
                    AddChoice("Tracking", 19, oPC);  
                    SetLocalString(oPC, "prof_dyn_text_19", "Allows you to follow tracks and trails.\nRequirements: Any Standing");  
                }  
                if (ExecuteScriptAndReturnInt("prof_chk_wood", oPC)) {  
                    AddChoice("Wood Gathering", 20, oPC);  
                    SetLocalString(oPC, "prof_dyn_text_20", "Allows you to gather wood from trees.\nRequirements: Any Standing");  
                }  
                // No Options Left  
                if (ExecuteScriptAndReturnInt("prof_chk_l", oPC)) {  
                    AddChoice("No Options Left", 21, oPC);  
                    SetLocalString(oPC, "prof_dyn_text_21", "You have selected all available proficiencies or have no remaining slots.");  
                }  
  
                MarkStageSetUp(nStage, oPC);  
                SetDefaultTokens();  
            }  
            SetupTokens();  
        }  
    } else {  
        // Handle PC responses  
        int nChoice = GetChoice(oPC);  
        if (nChoice == 21) {  
            // No Options Left: finalize and proceed to next step (e.g., disfigurement or final)  
            ExecuteScript("prof_give_nomore", oPC);  
            // Optionally chain to next conversation:  
            // StartDynamicConversation("bg_disfig_cv", oPC);  
        } else if (nChoice >= 1 && nChoice <= 20) {  
            // Grant the selected proficiency  
            string sGrant;  
            switch (nChoice) {  
                case 1:  sGrant = "prof_give_alchemy"; break;  
                case 2:  sGrant = "prof_give_anatomy"; break;  
                case 3:  sGrant = "prof_give_armor"; break;  
                case 4:  sGrant = "prof_give_astro"; break;  
                case 5:  sGrant = "prof_give_carp"; break;  
                case 6:  sGrant = "prof_give_deciph"; break;  
                case 7:  sGrant = "prof_give_disgui"; break;  
                case 8:  sGrant = "prof_give_fire"; break;  
                case 9:  sGrant = "prof_give_guns"; break;  
                case 10: sGrant = "prof_give_herb"; break;  
                case 11: sGrant = "prof_give_hist"; break;  
                case 12: sGrant = "prof_give_hunt"; break;  
                case 13: sGrant = "prof_give_mason"; break;  
                case 14: sGrant = "prof_give_mine"; break;  
                case 15: sGrant = "prof_give_obs"; break;  
                case 16: sGrant = "prof_give_siege"; break;  
                case 17: sGrant = "prof_give_smelt"; break;  
                case 18: sGrant = "prof_give_tailor"; break;  
                case 19: sGrant = "prof_give_track"; break;  
                case 20: sGrant = "prof_give_wood"; break;  
                default: sGrant = ""; break;  
            }  
            if (sGrant != "") ExecuteScript(sGrant, oPC);  
            // Return to list to allow further selections  
            SetStage(STAGE_LIST, oPC);  
        }  
        SetStage(nStage, oPC);  
    }  
}