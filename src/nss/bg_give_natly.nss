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
    int iFeat = BACKGROUND_NAT_LYCAN;
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");
    /* -- Bonuses applied at end of CharCreation: LordValinar (12/18/2023) --
    SetLocalInt(oItem, "PC_ECL",2);
    SetSubRace(oPC, "Natural Lycanthrope");
    if(GetRacialType(oPC) == RACIAL_TYPE_ELF)
    {
        SetSubRace(oPC,"Lythari");
    }
    int iWIS = GetAbilityScore(oPC, ABILITY_WISDOM, TRUE);
    NWNX_Creature_AddFeatByLevel(oPC,iFeat,1);
    NWNX_Creature_AddFeatByLevel(oPC,1175,1);
    NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_WISDOM, iWIS + 2);
    */
    SetLocalInt(oItem,"CC0",iFeat);
    SetLocalInt(oItem,"BG_Select",1);
    ActionStartConversation(oPC,"bg_class",TRUE);
}
