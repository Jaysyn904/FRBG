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
       (nSubrace == 1182 ||  // Gold Dwarf
        nSubrace == 1183 ||  // Grey Dwarf
        nSubrace == 1184) && // Shield Dwarf
        GetLevelByClass(CLASS_TYPE_CLERIC,oPC) > 1
    );
}

/* -- Old Code (removed - LordValinar 12/23/2023) -- *
    if(
    GetHasFeat(BACKGROUND_MIDDLE,oPC) &&
    GetLevelByClass(CLASS_TYPE_CLERIC,oPC) > 1 &&
    (GetHasFeat(1182,oPC) ||
    GetHasFeat(1183,oPC) ||
    GetHasFeat(1184,oPC))
      )
    {
        return TRUE;
    }

    return FALSE;
*/
