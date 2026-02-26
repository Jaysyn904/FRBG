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
        (nClass == BACKGROUND_LOWER || nClass == BACKGROUND_MIDDLE) &&
        nSubrace != 1182 && // Gold Dwarf
        nSubrace != 1183 && // Grey Dwarf
        nSubrace != 1184 && // Shield Dwarf
        nSubrace != 1452 && // Deep Gnome
        nSubrace != 1453 && // Forest Gnome
        nSubrace != 1454 && // Rock Gnome
        nSubrace != 1455 && // Ghostwise Halfling
        nSubrace != 1456 && // Lightfoot Halfling
        nSubrace != 1457 && // Strongheart Halfling
        GetRacialType(oPC) != RACIAL_TYPE_HALFORC &&
        GetAbilityScore(oPC,ABILITY_CHARISMA,TRUE) >= 13
    );
}

/* -- Old Code (removed - LordValinar 12/23/2023) -- *
    if(
        (GetHasFeat(BACKGROUND_LOWER,oPC) == TRUE || GetHasFeat(BACKGROUND_MIDDLE,oPC) == TRUE)&&
        !GetHasFeat(1182,oPC) &&
        !GetHasFeat(1183,oPC) &&
        !GetHasFeat(1184,oPC) &&
        !GetHasFeat(1452,oPC) &&
        !GetHasFeat(1453,oPC) &&
        !GetHasFeat(1454,oPC) &&
        !GetHasFeat(1455,oPC) &&
        !GetHasFeat(1456,oPC) &&
        !GetHasFeat(1457,oPC) &&
        GetRacialType(oPC) != RACIAL_TYPE_HALFORC &&
        (GetAbilityScore(oPC,ABILITY_CHARISMA,TRUE) >= 13)

      )
    {
        return TRUE;
    }

    return FALSE;
*/
