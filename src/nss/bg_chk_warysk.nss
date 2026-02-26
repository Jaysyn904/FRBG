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
    return (
        nSubrace == 1455 || // Ghostwise Halfling
        nSubrace == 1456 || // Lightfoot Halfling
        nSubrace == 1457    // Strongheart Halfling
    );
}

/* -- Old Code (removed - LordValinar 12/23/2023) -- *
    if(GetHasFeat(1455,oPC) ||
GetHasFeat(1456,oPC) ||
GetHasFeat(1457,oPC))
    {
        return TRUE;
    }

    return FALSE;
*/
