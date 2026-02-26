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
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");
    int iFeat = BACKGROUND_OCCULTIST;
    /* CharCreation Changed - LordValinar 12/18/2023
        - Data saved as variables for the final process, in
          which the variables are then cleared

    int iLore = GetSkillRank(SKILL_LORE, oPC, TRUE);
    int iSpellcraft = GetSkillRank(SKILL_SPELLCRAFT, oPC, TRUE);
    NWNX_Creature_AddFeatByLevel(oPC,iFeat,1);
    NWNX_Creature_AddFeatByLevel(oPC,PROFICIENCY_ASTROLOGY,1);
    NWNX_Creature_SetSkillRank(oPC, SKILL_LORE, iLore +2);
    NWNX_Creature_SetSkillRank(oPC, SKILL_SPELLCRAFT, iSpellcraft +2);
    */
    SetLocalInt(oItem,"CC2",iFeat); // applies above bonuses on finalization
    SetLocalInt(oItem,"BG_Select",3);
    ActionStartConversation(oPC,"bg_deity",TRUE);
}
