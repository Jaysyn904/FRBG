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
        nClass == BACKGROUND_MIDDLE &&
        nSubrace != 1175 && // Natural Lycan
        nSubrace != 1179 && // Dark Elf
        nSubrace != 1182 && // Gold Dwarf
        nSubrace != 1183 && // Grey Dwarf
        nSubrace != 1184 && // Shield Dwarf
        nSubrace != 1186 && // Aasimar
        nSubrace != 1187 && // Tiefling
        nSubrace != 1445 && // F(?) Folk
        nSubrace != 1446 && // Chultan
        nSubrace != 1452 && // Deep Gnome
        nSubrace != 1453 && // Forest Gnome
        nSubrace != 1458 && // Fey'ri
        GetAbilityScore(oPC,ABILITY_CHARISMA,TRUE) >= 13 &&
        GetRacialType(oPC) != RACIAL_TYPE_HALFORC &&
        GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) < 1
    );
}

/*

*/

/* -- Old Code (removed - LordValinar 12/23/2023) -- *
    if(
        (GetHasFeat(BACKGROUND_MIDDLE,oPC) == TRUE)&&
!GetHasFeat(1182,oPC) &&
!GetHasFeat(1183,oPC) &&
!GetHasFeat(1184,oPC) &&
!GetHasFeat(1458,oPC) &&
!GetHasFeat(1179,oPC) &&
!GetHasFeat(1452,oPC) &&
!GetHasFeat(1453,oPC) &&
!GetHasFeat(1445,oPC) &&
!GetHasFeat(1446,oPC) &&
!GetHasFeat(1186,oPC) &&
!GetHasFeat(1187,oPC) &&
!GetHasFeat(1175,oPC) &&
        GetAbilityScore(oPC,ABILITY_CHARISMA,TRUE) >= 13 &&
        GetRacialType(oPC) != RACIAL_TYPE_HALFORC &&
        GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) < 1
      )
    {
        return TRUE;
    }

    return FALSE;
*/
