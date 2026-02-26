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
        nClass != BACKGROUND_LOWER &&
        nSubrace != 1177 && // Copper Elf
        nSubrace != 1178 && // Green Elf
        nSubrace != 1179 && // Dark Elf
        nSubrace != 1182 && // Gold Dwarf
        nSubrace != 1183 && // Grey Dwarf
        nSubrace != 1184 && // Shield Dwarf
        nSubrace != 1446 && // Chultan
        nSubrace != 1448 && // Maztican
        nSubrace != 1450 && // Shaaran
        nSubrace != 1452 && // Deep Gnome
        nSubrace != 1453 && // Forest Gnome
        nSubrace != 1454 && // Rock Gnome
        nSubrace != 1455 && // Ghostwise Halfling
        nSubrace != 1456 && // Lightfoot Halfling
        nSubrace != 1457 && // Strongheart Halfling
        nSubrace != 1458 && // Fey'ri
        GetRacialType(oPC) != RACIAL_TYPE_HALFORC &&
        GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) < 1 &&
        GetAbilityScore(oPC,ABILITY_DEXTERITY,TRUE) >= 13
    );
}
/* -- Old Code (removed - LordValinar 12/23/2023) -- *
    if(
        !GetHasFeat(BACKGROUND_LOWER,oPC) &&
        !GetHasFeat(1182,oPC) &&
        !GetHasFeat(1183,oPC) &&
        !GetHasFeat(1184,oPC) &&
        !GetHasFeat(1458,oPC) &&
        !GetHasFeat(1177,oPC) &&
        !GetHasFeat(1178,oPC) &&
        !GetHasFeat(1179,oPC) &&
        !GetHasFeat(1452,oPC) &&
        !GetHasFeat(1453,oPC) &&
        !GetHasFeat(1454,oPC) &&
        !GetHasFeat(1455,oPC) &&
        !GetHasFeat(1456,oPC) &&
        !GetHasFeat(1457,oPC) &&
        !GetHasFeat(1445,oPC) &&
        !GetHasFeat(1446,oPC) &&
        !GetHasFeat(1448,oPC) &&
        !GetHasFeat(1450,oPC) &&
        GetRacialType(oPC) != RACIAL_TYPE_HALFORC &&
        GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) < 1 &&
        GetAbilityScore(oPC,ABILITY_DEXTERITY,TRUE) >= 13
      )
    {
        return TRUE;
    }

    return FALSE;
*/
