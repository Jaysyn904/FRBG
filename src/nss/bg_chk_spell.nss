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
        nSubrace != 1175 && // Natural Lycan
        GetRacialType(oPC) != RACIAL_TYPE_HALFORC &&
        GetAbilityScore(oPC,ABILITY_CONSTITUTION,TRUE) >= 13
    );
}

/* -- Old Code (removed - LordValinar 12/23/2023) -- *
    if(
        (GetAbilityScore(oPC,ABILITY_CONSTITUTION,TRUE) >= 13 && GetHasFeat(1175,oPC) != TRUE && GetRacialType(oPC) != RACIAL_TYPE_HALFORC)

      )
    {
        return TRUE;
    }

    return FALSE;
*/
