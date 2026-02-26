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
        nClass != BACKGROUND_UPPER &&
        nSubrace != 1458 && // Fey'ri
        nSubrace != 1177 && // Copper Elf
        nSubrace != 1178 && // Green Elf
        nSubrace != 1179 && // Dark Elf
        nSubrace != 1180 && // Silver Elf
        nSubrace != 1181 && // Gold Elf
        nSubrace != 1452 && // Deep Gnome
        nSubrace != 1453 && // Forest Gnome
        nSubrace != 1454 && // Rock Gnome
        GetAbilityScore(oPC,ABILITY_STRENGTH,TRUE) >= 13
    );
}

/* -- Old Code (removed - LordValinar 12/23/2023) -- *
    if(
        !GetHasFeat(BACKGROUND_UPPER,oPC)&&
        !GetHasFeat(1458,oPC) &&
        !GetHasFeat(1177,oPC) &&
        !GetHasFeat(1178,oPC) &&
        !GetHasFeat(1179,oPC) &&
        !GetHasFeat(1180,oPC) &&
        !GetHasFeat(1181,oPC) &&
        !GetHasFeat(1452,oPC) &&
        !GetHasFeat(1453,oPC) &&
        !GetHasFeat(1454,oPC)&&
        GetAbilityScore(oPC,ABILITY_STRENGTH,TRUE) >= 13
      )
    {
        return TRUE;
    }

    return FALSE;
*/
