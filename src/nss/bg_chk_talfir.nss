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
       (nSubrace == 1387 ||  // Tethyrian
        nSubrace == 1445) && // F(?) Folk
        GetAbilityScore(oPC,ABILITY_CHARISMA,TRUE) >= 13
    );
}

/* -- Old Code (removed - LordValinar 12/23/2023) -- *
    if(
    (GetHasFeat(1387,oPC) ||
    GetHasFeat(1445,oPC))&&
    GetAbilityScore(oPC,ABILITY_CHARISMA,TRUE) >= 13)
    {
        return TRUE;
    }

    return FALSE;
*/
