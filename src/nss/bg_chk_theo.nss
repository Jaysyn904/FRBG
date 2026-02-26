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
        (nClass == BACKGROUND_MIDDLE || nClass == BACKGROUND_UPPER) &&
         nSubrace == 1179 && // Dark Elf
         nSubrace == 1183 && // Grey Dwarf
         nSubrace == 1386 && // Rashemi
         nSubrace == 1445 && // F(?) Folk
         nSubrace == 1446 && // Chultan
         nSubrace == 1448 && // Maztican
         nSubrace == 1450 && // Shaaran
         nSubrace == 1452 && // Deep Gnome
         nSubrace == 1453 && // Forest Gnome
        GetRacialType(oPC) != RACIAL_TYPE_HALFORC &&
        GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) < 1 &&
        GetAbilityScore(oPC,ABILITY_WISDOM,TRUE) >= 13 &&
        GetAbilityScore(oPC,ABILITY_CHARISMA,TRUE) >= 13
    );
}

/* -- Old Code (removed - LordValinar 12/23/2023) -- *
    if((GetHasFeat(BACKGROUND_MIDDLE,oPC) == TRUE || GetHasFeat(BACKGROUND_UPPER,oPC) == TRUE)&&
!GetHasFeat(1183,oPC) &&
!GetHasFeat(1179,oPC) &&
!GetHasFeat(1452,oPC) &&
!GetHasFeat(1453,oPC) &&
!GetHasFeat(1445,oPC) &&
!GetHasFeat(1446,oPC) &&
!GetHasFeat(1448,oPC) &&
!GetHasFeat(1450,oPC) &&
!GetHasFeat(1386,oPC) &&
GetRacialType(oPC) != RACIAL_TYPE_HALFORC &&
GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) < 1 &&
GetAbilityScore(oPC,ABILITY_WISDOM,TRUE) >= 13 && GetAbilityScore(oPC,ABILITY_CHARISMA) >= 13)

    {
        return TRUE;
    }

    return FALSE;
*/
