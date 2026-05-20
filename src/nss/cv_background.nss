#include "bg_inc_dynconv"  
#include "bg_inc_p_locals"

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
    object oPC = GetLastUsedBy();
    object oItem = EnsurePlayerDataObject(oPC);

	int iState = GetPersistantLocalInt(oPC, "Background_Stage");	
	
	//int iState = GetLocalInt(oItem, "Background_Stage");
	
    if(iState == 0)
    {
		SendMessageToPC(oPC,"Resuming from Subrace Selection.");
		DelayCommand(0.2f, StartDynamicConversation("bg_subrace_cv", oPC, FALSE, FALSE, TRUE, OBJECT_SELF)); 
       //ActionStartConversation(oPC,"bg_class",TRUE);
    }
    else if(iState == 1)
    {
       SendMessageToPC(oPC,"Resuming from Social Class Selection.");
	   DelayCommand(0.2f, StartDynamicConversation("bg_soclass_cv", oPC, FALSE, FALSE, TRUE, OBJECT_SELF)); 
       //ActionStartConversation(oPC,"bg_class",TRUE);
    }
    else if(iState == 2)
    {
       SendMessageToPC(oPC,"Resuming from Background Selection.");
	   DelayCommand(0.2f, StartDynamicConversation("bg_background_cv", oPC, FALSE, FALSE, TRUE, OBJECT_SELF)); 
       //ActionStartConversation(oPC,"bg_background",TRUE);
    }
    else if(iState == 3)
    {
        SendMessageToPC(oPC,"Resuming from Deity Selection.");
		DelayCommand(0.2f, StartDynamicConversation("bg_deity_cv", oPC, FALSE, FALSE, TRUE, OBJECT_SELF)); 
        //ActionStartConversation(oPC,"bg_deity",TRUE);
    }
    else if(iState == 4)
    {
        SendMessageToPC(oPC,"Resuming from Language Selection.");
		DelayCommand(0.2f, StartDynamicConversation("bg_language_cv", oPC, FALSE, FALSE, TRUE, OBJECT_SELF)); 
        //ActionStartConversation(oPC,"bg_language",TRUE);
    }
    else if(iState == 5)
    {
        SendMessageToPC(oPC,"Resuming from Proficiency Selection.");
		DelayCommand(0.2f, StartDynamicConversation("bg_profs_cv", oPC, FALSE, FALSE, TRUE, OBJECT_SELF)); 
        //ActionStartConversation(oPC,"bg_proficiency",TRUE);
    }
    else if(iState == 6)
    {
        SendMessageToPC(oPC,"Resuming from Age Modifier Selection.");
		DelayCommand(0.2f, StartDynamicConversation("bg_age_cv", oPC, FALSE, FALSE, TRUE, OBJECT_SELF));
        //ActionStartConversation(oPC,"bg_final",TRUE);
    }
    else if(iState == 7)
    {
        SendMessageToPC(oPC,"Resuming from Disfigurement Selection.");
		DelayCommand(0.2f, StartDynamicConversation("bg_disfig_cv", oPC, FALSE, FALSE, TRUE, OBJECT_SELF));
        //ActionStartConversation(oPC,"bg_disfig",TRUE);
    }
    else if(iState >= 8)
    {
        SendMessageToPC(oPC,"You have completed the background selection process.");
    }
    else
    {
        SendMessageToPC(oPC,"You have not begun the selection process.");
		DelayCommand(0.2f, StartDynamicConversation("bg_subrace_cv", oPC, FALSE, FALSE, TRUE, OBJECT_SELF));
        //ActionStartConversation(oPC,"bg_subrace_cv",TRUE);
    }
}
