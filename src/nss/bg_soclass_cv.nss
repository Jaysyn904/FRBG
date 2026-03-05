// bg_soclass_cv.nss  
#include "inc_dynconv"  
#include "x2_inc_switches"  
#include "inc_persist_loca"
#include "te_afflic_func"
  
const int STAGE_LIST    = 0;  
const int STAGE_CONFIRM = 1;  
  
string GetClassText(object oPC, int nChoice) {  
    return GetLocalString(oPC, "cs_dyn_text_" + IntToString(nChoice));  
}  
  
// TODO: See if "!GetHasFeat(BACKGROUND_AASIMAR, oPC)	&&  "  would be better.
int NobiltyCheck(object oPC = OBJECT_SELF)
{
    // Make sure the player has the required feats
    object oPC = GetPCSpeaker();
    //int nSubrace = GetLocalInt(oItem, "CC0");
	int nSubrace = GetPersistantLocalInt(oPC,"CC0");
    return (
        GetRacialType(oPC) == RACIAL_TYPE_HUMAN &&
        GetLevelByClass(CLASS_TYPE_BARBARIAN, oPC) < 1 &&
        nSubrace != 1186 && // Aasimar
        nSubrace != 1187 && // Tiefling
        nSubrace != 1445 && // F(?) Folk
        nSubrace != 1446 && // Chultan
        nSubrace != 1450 && // Shaaran
        nSubrace != 1451 && // Shou
        nSubrace != 1448 && // Maztican
        nSubrace != 1175    // Natural Lycan
    );
}

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

void main()     
{      
    object oPC = GetPCSpeaker();      
    SendMessageToPC(oPC, "DEBUG: bg_soclass_cv main() entered");      
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
                SetHeader("Class Standing is your place in Tethyrian society and will affect what Backgrounds or Subraces you can select. Some races only have access to certain Class Standings due to the political and social stigmas on certain races in the region.\n\nSelect the Class Standing that best represents your character.\nYou can refresh the list with the Escape key if needed.");      
                // 1 Lower Class      
                AddChoice("Lower Class", 1, oPC);      
                SetLocalString(oPC, "cs_dyn_text_1",      
                    "You are a commoner, a peasant, or a laborer. You have little wealth or influence, but you are hardworking and resilient. Many in Tethyr view you with pity or contempt, but you know the value of a day's work.\n\nDoes this describe you?");      
                // 2 Middle Class      
                AddChoice("Middle Class", 2, oPC);      
                SetLocalString(oPC, "cs_dyn_text_2",      
                    "You are a tradesperson, a merchant, or a skilled artisan. You have some wealth and influence, but you are not nobility. You are respected for your craft and your contributions to Tethyr's economy.\n\nDoes this describe you?");      
                // 3 Upper Class (requires Nobility 1+ and Human)      
                if (NobiltyCheck(oPC))     
				{      
                    AddChoice("Upper Class", 3, oPC);      
                    SetLocalString(oPC, "cs_dyn_text_3",      
                        "You are a noble, a landowner, or a person of high birth. You have great wealth and influence, but you are also burdened by the responsibilities and expectations of your station. Many in Tethyr admire you, but some envy or resent you.\n\nDoes this describe you?");      
                }      
                MarkStageSetUp(nStage, oPC);      
                SetDefaultTokens();      
            }      
            else if (nStage == STAGE_CONFIRM)     
			{      
                int nSelected = GetLocalInt(oPC, "cs_selected");      
                SetHeader(GetClassText(oPC, nSelected) + "\n\nIs this correct?");      
                AddChoice("Yes", 0, oPC);      
                AddChoice("No", 1, oPC);      
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
            SetLocalInt(oPC, "cs_selected", nChoice);      
            nStage = STAGE_CONFIRM; // update local nStage      
        }      
        else if (nStage == STAGE_CONFIRM)     
		{      
            if (nChoice == 0) { // Yes      
                int nSelected = GetLocalInt(oPC, "cs_selected");      
                object oItem = EnsurePlayerDataObject(oPC);      
                switch (nSelected) {      
                    case 1:     
					{      
                        SetPersistantLocalInt(oPC,"CC1",BACKGROUND_LOWER);      
                        SetPersistantLocalInt(oPC,"BG_Select",1);      
                        SetLocalInt(oItem, "CC1", BACKGROUND_LOWER);      
                        SetLocalInt(oItem, "BG_Select", 1);      
                        break;  // Lower Class      
                    }      
                    case 2:     
					{      
                        SetPersistantLocalInt(oPC,"CC1",BACKGROUND_MIDDLE);      
                        SetPersistantLocalInt(oPC,"BG_Select",2);      
                        SetLocalInt(oItem, "CC1", BACKGROUND_MIDDLE);      
                        SetLocalInt(oItem, "BG_Select", 2);      
                        break;  // Middle Class      
                    }      
                    case 3:     
					{      
                        SetPersistantLocalInt(oPC,"CC1",BACKGROUND_UPPER);      
                        SetPersistantLocalInt(oPC,"BG_Select",3);      
                        SetLocalInt(oItem, "CC1", BACKGROUND_UPPER);      
                        SetLocalInt(oItem, "BG_Select", 3);      
                        break;  // Upper Class      
                    }      
                }      
				AllowExit(DYNCONV_EXIT_FORCE_EXIT, TRUE, oPC);    
				SetPersistantLocalInt(oPC, "CC1_DONE", 1);    
				DelayCommand(0.1f, StartDynamicConversation("bg_background_cv", oPC));				    
            }      
            else     
			{ // No      
                MarkStageNotSetUp(STAGE_LIST, oPC);    
                MarkStageNotSetUp(STAGE_CONFIRM, oPC);
                nStage = STAGE_LIST; // update local nStage      
            }      
        }      
        SetStage(nStage, oPC);      
    }      
}

/* void main() 
{  
    object oPC = GetPCSpeaker();  
	object oItem = EnsurePlayerDataObject(oPC);
    SendMessageToPC(oPC, "DEBUG: bg_soclass_cv main() entered");  
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
                SetHeader("Class Standing is your place in Tethyrian society and will affect what Backgrounds or Subraces you can select. Some races only have access to certain Class Standings due to the political and social stigmas on certain races in the region.\n\nSelect the Class Standing that best represents your character.");  
                // 1 Lower Class  
                if (GetIsPC(oPC)) 
				{  
                    AddChoice("Lower Class", 1, oPC);  
                    SetLocalString(oPC, "cs_dyn_text_1",  
                        "You are from the dredges of society and are considered a peasant at best. You have worked hard your entire life - when you could find it. Whether you are from the city or a rural farm, you never had much to your name. You likely do not have a surname and claiming one is considered purgery in many counties. This is Tethyr however, so an individual can rise above their current station through deeds and valor. You could be moving upwards soon.\n\nDoes this describe you?");  
                }  
                // 2 Middle Class  
                if((GetRacialType(oPC) != RACIAL_TYPE_HALFORC) && (GetLevelByClass(CLASS_TYPE_BARBARIAN, oPC) < 1)) 
				{  
                    AddChoice("Middle Class", 2, oPC);  
                    SetLocalString(oPC, "cs_dyn_text_2",  
                        "You are from the middling classes of society. Your family may have been merchants, craftsmen, knights or small landowners. Your upbringing has provided you with skills that you can put to good use, even if you lack the inheritance that more fortunate members of society might have. Whether you will take up the sword or continue the family business is now up to you.\n\nDoes this describe you?");  
                }  
                // 3 Upper Class  
                if (NobiltyCheck(oPC)) 
				{  
                    AddChoice("Upper Class", 3, oPC);  
                    SetLocalString(oPC, "cs_dyn_text_3",  
                        "You are from the upper classes of society. Your family may have been landowners, merchants, knights, or landed nobles with titles to their name. While not all nobles fit the same mold or are necessarily Tethyrian in descent, they are distinguished easily by their fealty and unending service to the crown. Your upbringing has left you with many opportunities and advantages that others may not have had - how you use them is now entirely up to you.\n\nDoes this describe you?");  
                }  
                MarkStageSetUp(nStage, oPC);  
                SetDefaultTokens();  
            }  
            else if (nStage == STAGE_CONFIRM) 
			{  
                int nSelected = GetLocalInt(oPC, "cs_selected");  
                SetHeader(GetClassText(oPC, nSelected));  
                AddChoice("Yes!", nSelected, oPC);  
                AddChoice("No...", -1, oPC);  
                MarkStageSetUp(nStage, oPC);  
                SetDefaultTokens();  
            }  
            SetupTokens();  
        }  
    }  
    else 
	{  
        int nChoice = GetChoice(oPC);  
        if (nStage == STAGE_LIST) 
		{  
            SetLocalInt(oPC, "cs_selected", nChoice);  
            SetStage(STAGE_CONFIRM, oPC);  
        }  
        else if (nStage == STAGE_CONFIRM) 
		{  
            if (nChoice >= 0) 
			{ // "Yes!" - grant the standing  
                string sGrant;  
                switch (GetLocalInt(oPC, "cs_selected")) 
				{  
                    case 1:
					{
						//sGrant = "bg_give_low";
						SetPersistantLocalInt(oPC,"CC1",BACKGROUND_LOWER);
						SetPersistantLocalInt(oPC,"BG_Select",2);							
						SetLocalInt(oItem,"CC1",BACKGROUND_LOWER);
						SetLocalInt(oItem,"BG_Select",2);
						break;  // Lower Class
					}						
                    case 2:
					{
						//sGrant = "bg_give_mid";
						SetPersistantLocalInt(oPC,"CC1",BACKGROUND_MIDDLE);
						SetPersistantLocalInt(oPC,"BG_Select",2);
						SetLocalInt(oItem,"CC1",BACKGROUND_MIDDLE);
						SetLocalInt(oItem,"BG_Select",2);						 
						break;  // Middle Class  
					}
                    case 3:
					{
						//sGrant = "bg_give_up";
						SetPersistantLocalInt(oPC,"CC1",BACKGROUND_UPPER);
						SetPersistantLocalInt(oPC,"BG_Select",2);						
						SetLocalInt(oItem, "CC1", BACKGROUND_UPPER);  
						SetLocalInt(oItem, "BG_Select", 2); 
						break;  // Upper Class  
                    //default: sGrant = ""; break;  
					}  
					//if (sGrant != "") ExecuteScript(sGrant, oPC);  
					// Conversation ends naturally; no explicit end call needed  
				}
			}				
			else 
			{ // "No..." - return to list  
			SetStage(STAGE_LIST, oPC);  
			}  
		}  
		SetStage(nStage, oPC);  
	}  
}
 */