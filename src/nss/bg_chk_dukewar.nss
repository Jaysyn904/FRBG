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
       (nSubrace == 1175 ||  // Natural Lycan
        nSubrace == 1177 ||  // Copper Elf
        nSubrace == 1178 ||  // Green Elf
        nSubrace == 1180 ||  // Silver Elf
        nSubrace == 1387) && // Tethyrian
        GetRacialType(oPC) != RACIAL_TYPE_HALFORC &&
        GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) < 1
    );
}

/* -- Old Code (removed - LordValinar 12/23/2023) -- *
    if(
        !GetHasFeat(BACKGROUND_UPPER,oPC) &&
(
GetHasFeat(1177,oPC) ||
GetHasFeat(1178,oPC) ||
GetHasFeat(1180,oPC) ||
GetHasFeat(1387,oPC) ||
GetHasFeat(1175,oPC) ) &&
        GetRacialType(oPC) != RACIAL_TYPE_HALFORC &&
        GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) < 1
      )
    {
        return TRUE;
    }


    return FALSE;
*/
