//::///////////////////////////////////////////////
//:: FileName bg_give_mid.nss
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: David Novotny
//:: Created On: 10/20/17
//:://////////////////////////////////////////////
#include "nwnx_creature"
#include "te_afflic_func"

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
    if (!GetIsObjectValid(oPC) || !GetIsPC(oPC)) return;  
  
    object oItem = EnsurePlayerDataObject(oPC);  
    if (!GetIsObjectValid(oItem)) return; // Safety fallback  
  
    int iFeat = BACKGROUND_MIDDLE;  
    SetLocalInt(oItem, "CC1", iFeat);  
    SetLocalInt(oItem, "BG_Select", 2);  
  
    // Start the background selection conversation  
    if (GetIsObjectValid(oPC))  
        ActionStartConversation(oPC, "bg_background", TRUE);  
}

/* void main()
{
    object oPC = GetPCSpeaker();
    int iFeat = BACKGROUND_MIDDLE;
    // CharCreation Changed - LordValinar 12/18/2023
        // - Data saved as variables for the final process, in
          // which the variables are then cleared
    // NWNX_Creature_AddFeatByLevel(oPC,iFeat,1);
   
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");
    SetLocalInt(oItem,"CC1",iFeat);
    SetLocalInt(oItem,"BG_Select",2);
    ActionStartConversation(oPC,"bg_background",TRUE);
} */
