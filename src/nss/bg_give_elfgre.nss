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
    int iFeat = BACKGROUND_GREEN_ELF;
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");
    /* -- Bonsues moved to end of CharCreation: LordValinar (12/18/2023) --
    SetLocalInt(oItem, "PC_ECL",0);
    SetSubRace(oPC, "Green Elf");
    int iCON = GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE);
    int iINT = GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE);
    NWNX_Creature_AddFeatByLevel(oPC,iFeat,1);
    NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CONSTITUTION, iCON +4); //-2 Racial Modifier applied afterwards
    NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_INTELLIGENCE, iINT -2);
    */
    SetLocalInt(oItem,"CC0",iFeat);
    SetLocalInt(oItem,"BG_Select",1);
    ActionStartConversation(oPC,"bg_class",TRUE);
}
