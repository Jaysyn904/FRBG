// bg_age_cv.nss  
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
		SendMessageToPC(oPC, "Language data object recreated");
		WriteTimestampedLogEntry("Language data object recreated"); 		
    }    
    return oItem;    
}   

  
void main() 
{  
    object oPC = GetPCSpeaker();  
    SendMessageToPC(oPC, "DEBUG: bg_age_cv main() entered"); 

	object oItem = EnsurePlayerDataObject(oPC);
	
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);  
    int nStage = GetStage(oPC);  
  
    // Required guard: abort if nValue is 0  
    if (nValue == 0) return;  
  
    if (nValue == DYNCONV_SETUP_STAGE) 
	{  
        if (!GetIsStageSetUp(nStage, oPC)) 
		{  
            if (nStage == STAGE_LIST) 
			{  
                SetHeader("Now for the finishing touches. If you would like to apply an age modifier to your character, you may do so. Aging affects are as follows:\n" +   
                          "Young Age/Opt Out: No effects\n" +   
                          "Middle Age: -1 STR, -1 DEX, -1 CON, +1 INT, +1 WIS, +1 CHA\n" +   
                          "Old Age: -2 STR, -2 DEX, -2 CON, +2 INT, +2 WIS, +2 CHA\n" +   
                          "Venerable Age: -3 STR, -3 DEX, -3 CON, +3 INT, +3 WIS, +3 CHA");  
                  
                // Store descriptive text for each age choice  
                SetLocalString(oPC, "age_text_0", "You are in the prime of your youth, with physical abilities at their peak and mental faculties still developing. This represents a character starting their adventuring career in their late teens or early twenties, with no modifiers to abilities.");  
                SetLocalString(oPC, "age_text_1", "You have reached middle age, where the physical toll of years begins to show, but experience and wisdom have sharpened your mind. Your body has begun to slow (-1 STR, -1 DEX, -1 CON) while your mental faculties have matured (+1 INT, +1 WIS, +1 CHA).");  
                SetLocalString(oPC, "age_text_2", "The weight of many decades rests upon you. Physical decline is more pronounced (-2 STR, -2 DEX, -2 CON) but your accumulated knowledge and insight have grown significantly (+2 INT, +2 WIS, +2 CHA). You are a veteran of life's trials.");  
                SetLocalString(oPC, "age_text_3", "You have lived a very long life, and your body shows the full extent of your years (-3 STR, -3 DEX, -3 CON). However, your mind is a repository of vast knowledge and profound wisdom (+3 INT, +3 WIS, +3 CHA). You are truly an elder whose experience spans generations.");  
                  
                AddChoice("Young Age / Opt Out", 0, oPC);  
                AddChoice("Middle Age", 1, oPC);  
                AddChoice("Old Age", 2, oPC);  
                AddChoice("Venerable Age", 3, oPC);  
                MarkStageSetUp(nStage, oPC);  
                SetDefaultTokens();  
            }
			else if (nStage == STAGE_CONFIRM) 
			{  
                int nSelected = GetLocalInt(oPC, "age_selected");  
                string sAgeText = GetLocalString(oPC, "age_text_" + IntToString(nSelected));  
                string sPrompt = sAgeText + "\n\nAre you sure you want to apply this age modifier?";  
                SetHeader(sPrompt);  
                AddChoice("Yes", nSelected, oPC);  
                AddChoice("No", -1, oPC);  
                MarkStageSetUp(nStage, oPC);  
                SetDefaultTokens();  
            }  
        }  
        SetupTokens();  
    } 
	else 
	{  
        int nChoice = GetChoice(oPC);  
        if (nStage == STAGE_LIST) 
		{  
            SetLocalInt(oPC, "age_selected", nChoice);  
            SetStage(STAGE_CONFIRM, oPC);  
        } 
		else if (nStage == STAGE_CONFIRM) 
		{  
            if (nChoice >= 0) 
			{  
                string sGrant;  
                switch (nChoice) 
				{  
                    default:
					case 0:
					{// youthful
						//sGrant = "te_bg_a_n";
						SetLocalInt(oItem, "BG_Select",7);
						SetPersistantLocalInt(oPC, "BG_Select", 7);
						SetLocalInt(oItem, "CC6", AGE_CATEGORY_YOUTHFUL);
						SetPersistantLocalInt(oPC, "CC6", AGE_CATEGORY_YOUTHFUL);
						break;  
					}
                    case 1:
					{// middle-aged
						//sGrant = "te_bg_a_m";
						SetLocalInt(oItem, "BG_Select",7);
						SetPersistantLocalInt(oPC, "BG_Select", 7);
						SetLocalInt(oItem, "CC6", AGE_CATEGORY_MIDDLE);
						SetPersistantLocalInt(oPC, "CC6", AGE_CATEGORY_MIDDLE);
						break;  
					}
                    case 2:
					{
						//sGrant = "te_bg_a_o";
						SetLocalInt(oItem, "BG_Select",7);
						SetPersistantLocalInt(oPC, "BG_Select", 7);
						SetLocalInt(oItem, "CC6", AGE_CATEGORY_OLD);
						SetPersistantLocalInt(oPC, "CC6", AGE_CATEGORY_OLD);
						break;  
					}
                    case 3:
					{
						//sGrant = "te_bg_a_v"; break; 
						SetLocalInt(oItem, "BG_Select",7);
						SetPersistantLocalInt(oPC, "BG_Select", 7);
						SetLocalInt(oItem, "CC6", AGE_CATEGORY_VENERABLE);
						SetPersistantLocalInt(oPC, "CC6", AGE_CATEGORY_VENERABLE);
					}
                }  
                //if (sGrant != "") ExecuteScript(sGrant, oPC);  
                // Conversation ends naturally  
            } 
			else 
			{  
                SetStage(STAGE_LIST, oPC);  
            }  
        }  
        SetStage(nStage, oPC);  
    }  
}

 
/* void main() {  
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
} */