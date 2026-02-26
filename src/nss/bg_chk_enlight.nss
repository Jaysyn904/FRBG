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
    int nClass = GetLocalInt(oItem, "CC1");
    return (
        nClass != BACKGROUND_LOWER &&
        GetRacialType(oPC) != RACIAL_TYPE_HALFORC &&
        GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) < 1
    );
}

/* -- Old Code (removed - LordValinar 12/23/2023) -- *
    if(
        !GetHasFeat(BACKGROUND_LOWER,oPC)&&
            GetRacialType(oPC) != RACIAL_TYPE_HALFORC &&
            GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) < 1
      )
    {
        return TRUE;
    }

    return FALSE;
*/
