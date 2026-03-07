// clear_bg_vars.nss    
#include "inc_persist_loca"    
    
void main()    
{    
    object oPC = OBJECT_SELF;    
        
    object oDataObject = GetItemPossessedBy(oPC, "PC_Data_Object");    
    if (!GetIsObjectValid(oDataObject))    
    {    
        SendMessageToPC(oPC, "No PC_Data_Object found on this character.");    
        return;    
    }    
        
    SendMessageToPC(oPC, "Clearing character creation variables...");    
        
    // Clear regular local variables from PC_Data_Object    
    DeleteLocalInt(oDataObject, "CC0");  // Subrace    
    DeleteLocalInt(oDataObject, "CC1");  // Social class    
    DeleteLocalInt(oDataObject, "CC2");  // Background    
    DeleteLocalInt(oDataObject, "CC3");  // Deity    
    DeleteLocalInt(oDataObject, "CC4");  // Language 
    DeleteLocalInt(oDataObject, "CC5");  // Future     	
    DeleteLocalInt(oDataObject, "CC6");  // Age    
    DeleteLocalInt(oDataObject, "CC7");  // Disfigured    
        
    // Clear persistent variables from PC    
    DeletePersistantLocalInt(oPC, "CC0");    
    DeletePersistantLocalInt(oPC, "CC1");    
    DeletePersistantLocalInt(oPC, "CC2");    
    DeletePersistantLocalInt(oPC, "CC3");
    DeletePersistantLocalInt(oPC, "CC4");  
	DeletePersistantLocalInt(oPC, "CC5");
    DeletePersistantLocalInt(oPC, "CC6");    
    DeletePersistantLocalInt(oPC, "CC7");    
        
    // Clear completion flags
    DeleteLocalInt(oDataObject, "CC0_DONE");    
    DeleteLocalInt(oDataObject, "CC1_DONE");    
    DeleteLocalInt(oDataObject, "CC2_DONE");    
    DeleteLocalInt(oDataObject, "CC3_DONE");
    DeleteLocalInt(oDataObject, "CC4_DONE");    
    DeleteLocalInt(oDataObject, "CC5_DONE");
    DeleteLocalInt(oDataObject, "CC6_DONE");
    DeleteLocalInt(oDataObject, "CC7_DONE");	

    DeletePersistantLocalInt(oPC, "CC0_DONE");    
    DeletePersistantLocalInt(oPC, "CC1_DONE");	
    DeletePersistantLocalInt(oPC, "CC2_DONE");    
    DeletePersistantLocalInt(oPC, "CC3_DONE");    
    DeletePersistantLocalInt(oPC, "CC4_DONE");    
    DeletePersistantLocalInt(oPC, "CC5_DONE");  
	DeletePersistantLocalInt(oPC, "CC6_DONE");    
    DeletePersistantLocalInt(oPC, "CC7_DONE"); 
	
    // Clear BG_Select variable    
    DeletePersistantLocalInt(oPC, "BG_Select");    
    DeleteLocalInt(oDataObject, "BG_Select"); 

	DeleteLocalString(oPC, "TEMP_PROF_NAME");  
	DeleteLocalString(oPC, "TEMP_PROF_VAR");  
	DeleteLocalString(oPC, "TEMP_PROF_GRANT");  
	DeleteLocalString(oPC, "TEMP_PROF_DESC"); 
	DeleteLocalString(oPC, "ARR_PROF"); 
	DeletePersistantLocalString(oPC, "ARR_PROF"); 
	DeleteLocalInt(oPC, "PROFICIENCY_COUNT");
	DeletePersistantLocalInt(oPC, "PROFICIENCY_COUNT");  	
        
    // Clear LANGUAGE_XX variables (new system)    
    int i;    
    for (i = 0; i < 20; i++)    
    {    
        string sSlot = "LANGUAGE_" + (i < 10 ? "0" : "") + IntToString(i);    
        DeleteLocalInt(oDataObject, sSlot);    
        DeletePersistantLocalInt(oPC, sSlot);    
    }    
        
    SendMessageToPC(oPC, "Character creation variables cleared.");    
}