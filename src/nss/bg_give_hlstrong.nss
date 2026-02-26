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
    int iFeat = 1457; // Strongheart Halfling
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");
    /* -- Bonuses applied at end of CharCreation: LordValinar (12/18/2023) --
    SetLocalInt(oItem, "PC_ECL",0);
    SetSubRace(oPC, "Strongheart Halfling");
    NWNX_Creature_AddFeatByLevel(oPC,iFeat,1);
    */
    SetLocalInt(oItem,"CC0",iFeat);
    SetLocalInt(oItem,"BG_Select",1);
    ActionStartConversation(oPC,"bg_class",TRUE);
}
