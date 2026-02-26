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
        (nSubrace == 1456 ||  // Lightfoot Halfling
         nSubrace == 1381 ||  // Calishite
         nSubrace == 1382 ||  // Chondathan
         nSubrace == 1383 ||  // Damaran
         nSubrace == 1384 ||  // Illuskan
         nSubrace == 1385 ||  // Mulan
         nSubrace == 1387) && // Tethyrian
         GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) < 1 &&
         GetRacialType(oPC) != RACIAL_TYPE_HALFELF
    );
}
/* -- Old Code (removed - LordValinar 12/23/2023) -- *
    if(
        (GetHasFeat(BACKGROUND_MIDDLE,oPC) == TRUE || GetHasFeat(BACKGROUND_UPPER,oPC) == TRUE)&&
        (GetHasFeat(1456,oPC) ||
        GetHasFeat(1381,oPC) ||
        GetHasFeat(1382,oPC) ||
        GetHasFeat(1383,oPC) ||
        GetHasFeat(1384,oPC) ||
        GetHasFeat(1385,oPC) ||
        GetHasFeat(1387,oPC))&&
        GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) < 1 &&
        GetRacialType(oPC) != RACIAL_TYPE_HALFELF
      )
    {
        return TRUE;
    }

    return FALSE;
*/
