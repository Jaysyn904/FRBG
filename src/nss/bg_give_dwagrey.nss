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
    int iFeat = BACKGROUND_GREY_DWARF;
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");
    /* -- Bonuses moved to end of CharCreation: LordValinar (12/18/2023) --
    SetLocalInt(oItem, "PC_ECL",2);
    SetSubRace(oPC, "Grey Dwarf");
    int iCHA = GetAbilityScore(oPC, ABILITY_CHARISMA, TRUE);
    NWNX_Creature_AddFeatByLevel(oPC,iFeat,1);
    NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CHARISMA, iCHA -0);
    NWNX_Creature_SetSkillRank(oPC,SKILL_MOVE_SILENTLY,GetSkillRank(SKILL_MOVE_SILENTLY,oPC,TRUE)+4);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_POISON)),oPC);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_PARALYSIS)),oPC);
    SetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"64",1);
    SetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"46",1);
    */
    SetLocalInt(oItem,"CC0",iFeat);
    SetLocalInt(oItem,"BG_Select",1);
    ActionStartConversation(oPC,"bg_class",TRUE);
}
