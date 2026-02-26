//::///////////////////////////////////////////////
//:: FileName BG 1
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: David Novotny
//:: Created On: 10/20/17
//:://////////////////////////////////////////////
#include "te_functions"

int StartingConditional()
{
    // Make sure the player has the required feats
    object oPC = GetPCSpeaker();
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");
    int nSubrace = GetLocalInt(oItem, "CC0");
    int nClass = GetLocalInt(oItem, "CC1");
    return (
        nSubrace != 1179 && // Dark Elf
        nSubrace != 1183 && // Damaran
        !GetHasFeat(DEITY_Chauntea,oPC) &&
        !GetHasFeat(DEITY_Silvanus,oPC) &&
        !GetHasFeat(DEITY_Eldath,oPC) &&
        GetRacialType(oPC) != RACIAL_TYPE_HALFORC &&
        GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) < 1 &&
        GetAbilityScore(oPC,ABILITY_CHARISMA,TRUE) >= 13
    );
}

/* -- Old Code (removed - LordValinar 12/23/2023) -- *
    if(
!GetHasFeat(1183,oPC) &&
!GetHasFeat(1179,oPC) &&
!GetHasFeat(1452,oPC) &&
!GetHasFeat(1453,oPC) &&
!GetHasFeat(1455,oPC) &&
GetRacialType(oPC) != RACIAL_TYPE_HALFORC &&
GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) < 1 &&
        (GetAbilityScore(oPC,ABILITY_CHARISMA,TRUE) >= 13)
      )
    {
        return TRUE;
    }

    return FALSE;
*/
