//::///////////////////////////////////////////////
//:: FileName BG 1
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: David Novotny
//:: Created On: 10/20/17
//:://////////////////////////////////////////////
#include "NWNX_Creature"
#include "te_afflic_func"

void main()
{
    object oPC = GetPCSpeaker();
    int iFeat = DEITY_Red_Knight;
    /* -- Rearranged to apply at end of CharCreation: LordValinar(12/18/2023) --
    NWNX_Creature_AddFeat(oPC,iFeat);
    */
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");
    SetLocalInt(oItem,"CC3",iFeat);
    SetLocalInt(oItem,"BG_Select",4);
    ActionStartConversation(oPC,"bg_language",TRUE);
}
