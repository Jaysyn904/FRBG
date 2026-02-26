//::///////////////////////////////////////////////
//:: FileName BG 1
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: David Novotny
//:: Created On: 10/20/17
//:://////////////////////////////////////////////
#include "nwnx_creature"
#include "te_afflic_func"

void main()
{
    object oPC = GetPCSpeaker();
    int iFeat = BACKGROUND_METALSMITH;
    /* CharCreation Changed - LordValinar 12/18/2023
        - Data saved as variables for the final process, in
          which the variables are then cleared
    NWNX_Creature_AddFeatByLevel(oPC,iFeat,1);
    */
    object oItem = GetItemPossessedBy(oPC,"PC_Data_Object");
    SetLocalInt(oItem,"CC3",iFeat);
    SetLocalInt(oItem,"BG_Select",3);
    ActionStartConversation(oPC,"bg_deity",TRUE);
}
