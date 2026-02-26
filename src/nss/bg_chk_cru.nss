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
    return (nSubrace != 1179 && nSubrace != 1183); // Dark Elf & Grey Dwarf
}

/* -- Old Code (removed - LordValinar 12/23/2023) -- *
    if(!GetHasFeat(1183,oPC) &&
       !GetHasFeat(1179,oPC)
       )
    {
        return TRUE;
    }

    return FALSE;
*/
