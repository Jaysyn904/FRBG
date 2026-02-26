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
        nSubrace == 1177 || // Copper Elf
        nSubrace == 1178 || // Green Elf
        nSubrace == 1180 || // Silver Elf
        nSubrace == 1181 || // Gold Elf
        GetAbilityScore(oPC,ABILITY_INTELLIGENCE,TRUE) >= 15
    );
}

/* -- Old Code (removed - LordValinar 12/23/2023) -- *
    if(
(GetHasFeat(1458,oPC) ||
GetHasFeat(1177,oPC) ||
GetHasFeat(1178,oPC) ||
GetHasFeat(1180,oPC) ||
GetHasFeat(1181,oPC) )&&
GetAbilityScore(oPC,ABILITY_INTELLIGENCE,TRUE) >= 15
      )
    {
        return TRUE;
    }

    return FALSE;
*/
