// bg_disfig_cv.nss  
#include "bg_inc_dynconv"   
#include "x2_inc_switches"  
#include "bg_inc_p_locals"
  
const int STAGE_LIST    = 0;  
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
    //SendMessageToPC(oPC, "DEBUG: bg_disfig_cv main() entered");  
	
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
                SetHeader(  
                    "Some players wish to have intentional disfigurements such as lost limbs or lingering injuries. " +  
                    "These are rare among those who still wish to adventure, but not unique. Many keep these as " +  
                    "scars of what has come before, and a warning to those left.\n\n" +  
                    "[These aren't going to be updated too often unless a player asks for something for a " +  
                    "specific character. However, when someone does, we'll do our best to add it. These additions " +  
                    "will stay on the server for all to use. You will also gain a small RPXP bonus. This is not " +  
                    "recommended for new players.]"  
                );  
                AddChoice("One-Armed", 1, oPC);  
                AddChoice("No Disfigurement", 2, oPC);  
                MarkStageSetUp(nStage, oPC);  
                SetDefaultTokens();  
            }  
            else if (nStage == STAGE_CONFIRM) 
			{  
                int nSelected = GetLocalInt(oPC, "disfig_selected");  
                string sPrompt = (nSelected == 1)  
                    ? "You lost an arm. At some point, you lost one. Maybe it was a woodcutting accident, " +  
                      "maybe it was a punishment for theft. In any case, you're down an appendage.\n\n" +  
                      "You can't use your left arm. This means one-handed weapons only, no shields, " +  
                      "no left hand rings.\n\nAre you sure?"  
                    : "Are you sure you want to continue without a disfigurement?";  
                SetHeader(sPrompt);  
                AddChoice("Yes!", nSelected, oPC);  
                AddChoice("No...", -1, oPC);  
                MarkStageSetUp(nStage, oPC);  
                SetDefaultTokens();  
            }  
            SetupTokens();  
        }  
    }  
    else if (nValue == DYNCONV_EXITED)    
    {    
        SetPersistantLocalInt(oPC, "Background_Stage", 8);
		DelayCommand(0.1f, ExecuteScript("bg_apply_cv", oPC));     
    } 
	else 
	{  
        int nChoice = GetChoice(oPC);  
        if (nStage == STAGE_LIST) 
		{  
            SetLocalInt(oPC, "disfig_selected", nChoice);  
            SetStage(STAGE_CONFIRM, oPC);  
        }  
        else if (nStage == STAGE_CONFIRM) 
		{  
            if (nChoice >= 0) 
			{  
                //string sGrant = (nChoice == 1) ? "bg_give_noarm" : "bg_give_nodisfig";  
                //ExecuteScript(sGrant, oPC);  
                // Chain to next step, e.g., final touches  
				if (nChoice == 1)
				{
					SetLocalInt(oItem,"CC7",1); 		// One-Armed
					SetPersistantLocalInt(oPC,"CC7",1); // One-Armed
					SetLocalInt(oItem,"BG_Select",8);
				}
				else
				{
					SetLocalInt(oItem,"BG_Select",8);
				}					
				AllowExit(DYNCONV_EXIT_FORCE_EXIT, TRUE, oPC);  								 	
            } 
			else 
			{  
                SetStage(STAGE_LIST, oPC);  
            }  
        }  
        SetStage(nStage, oPC);  
    }  
}