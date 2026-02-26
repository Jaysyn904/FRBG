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
    int iFeat = BACKGROUND_TIEFLING;
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");
    /* -- Section Redon by LordValinar (12/18/2023) --
        > Saved selection for finalization to apply

    SetLocalInt(oItem, "iPCSubrace", 11);
    SetLocalInt(oItem, "PC_ECL",1);
    SetSubRace(oPC, "Tiefling");

    int iCL = GetHitDice(oPC);
    int iSTR = GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE);
    int iDEX = GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE);
    int iCON = GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE);
    int iINT = GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE);
    int iWIS = GetAbilityScore(oPC, ABILITY_WISDOM, TRUE);
    int iCHA = GetAbilityScore(oPC, ABILITY_CHARISMA, TRUE);
    int iAC = GetAC(oPC);
    int iWill = GetWillSavingThrow(oPC);
    int iFort = GetFortitudeSavingThrow(oPC);
    int iRefl = GetReflexSavingThrow(oPC);
    int iSpot = GetSkillRank(SKILL_SPOT, oPC, TRUE);
    int iHide = GetSkillRank(SKILL_HIDE, oPC, TRUE);
    int iBluff = GetSkillRank(SKILL_BLUFF, oPC, TRUE);
    int iListen = GetSkillRank(SKILL_LISTEN, oPC, TRUE);

    NWNX_Creature_AddFeatByLevel(oPC,iFeat,1);
    NWNX_Creature_AddFeat(oPC,228);
    NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_INTELLIGENCE, iINT +2);
    NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_DEXTERITY, iDEX +2);
    NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CHARISMA, iCHA -2);
    NWNX_Creature_SetSkillRank(oPC, SKILL_BLUFF, iBluff +2);
    NWNX_Creature_SetSkillRank(oPC, SKILL_HIDE, iHide+2);
    */
    SetLocalInt(oItem,"CC0",iFeat);
    SetLocalInt(oItem,"BG_Select",1);
    ActionStartConversation(oPC,"bg_class",TRUE);
}
