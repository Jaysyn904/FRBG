// bg_age_cv.nss  
#include "inc_dynconv"  
#include "x2_inc_switches"  
  
const int STAGE_LIST    = 0;  
const int STAGE_CONFIRM = 1;  
  
void main() {  
    object oPC = GetPCSpeaker();  
    SendMessageToPC(oPC, "DEBUG: bg_age_cv main() entered");  
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);  
    int nStage = GetStage(oPC);  
  
    // Required guard: abort if nValue is 0  
    if (nValue == 0) return;  
  
    if (nValue == DYNCONV_SETUP_STAGE) {  
        if (!GetIsStageSetUp(nStage, oPC)) {  
            if (nStage == STAGE_LIST) {  
                SetHeader("Now for the finishing touches. If you would like to apply an age modifier to your character, you may do so. Aging affects are as follows:\n" +  
                          "Young Age/Opt Out: No effects\n" +  
                          "Middle Age: -1 STR, -1 DEX, -1 CON, +1 INT, +1 WIS, +1 CHA\n" +  
                          "Old Age: -2 STR, -2 DEX, -2 CON, +2 INT, +2 WIS, +2 CHA\n" +  
                          "Venerable Age: -3 STR, -3 DEX, -3 CON, +3 INT, +3 WIS, +3 CHA");  
                AddChoice("Young Age / Opt Out", 0, oPC);  
                AddChoice("Middle Age", 1, oPC);  
                AddChoice("Old Age", 2, oPC);  
                AddChoice("Venerable Age", 3, oPC);  
                MarkStageSetUp(nStage, oPC);  
                SetDefaultTokens();  
            } else if (nStage == STAGE_CONFIRM) {  
                int nSelected = GetLocalInt(oPC, "age_selected");  
                string sPrompt = "Are you sure you want to apply this age modifier?";  
                SetHeader(sPrompt);  
                AddChoice("Yes", nSelected, oPC);  
                AddChoice("No", -1, oPC);  
                MarkStageSetUp(nStage, oPC);  
                SetDefaultTokens();  
            }  
        }  
        SetupTokens();  
    } else {  
        int nChoice = GetChoice(oPC);  
        if (nStage == STAGE_LIST) {  
            SetLocalInt(oPC, "age_selected", nChoice);  
            SetStage(STAGE_CONFIRM, oPC);  
        } else if (nStage == STAGE_CONFIRM) {  
            if (nChoice >= 0) {  
                string sGrant;  
                switch (nChoice) {  
                    case 0: sGrant = "te_bg_a_n"; break;  
                    case 1: sGrant = "te_bg_a_m"; break;  
                    case 2: sGrant = "te_bg_a_o"; break;  
                    case 3: sGrant = "te_bg_a_v"; break;  
                    default: sGrant = ""; break;  
                }  
                if (sGrant != "") ExecuteScript(sGrant, oPC);  
                // Conversation ends naturally  
            } else {  
                SetStage(STAGE_LIST, oPC);  
            }  
        }  
        SetStage(nStage, oPC);  
    }  
}