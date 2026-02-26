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
        nSubrace == 1179 || // Dark Elf
        nSubrace == 1182 || // Gold Dwarf
        nSubrace == 1183 || // Grey Dwarf
        nSubrace == 1184 || // Shield Dwarf
        nSubrace == 1187 || // Tiefling
        nSubrace == 1447 || // Imaskari
        nSubrace == 1452 || // Deep Gnome
        GetRacialType(oPC) == RACIAL_TYPE_HALFORC
    );
}

/* -- Old Code (removed - LordValinar 12/23/2023) -- *
    if(GetHasFeat(1182,oPC) ||
GetHasFeat(1183,oPC) ||
GetHasFeat(1184,oPC) ||
GetHasFeat(1179,oPC) ||
GetHasFeat(1452,oPC) ||
GetHasFeat(1447,oPC) ||
GetHasFeat(1187,oPC) ||
GetRacialType(oPC) == RACIAL_TYPE_HALFORC)
    {
        return TRUE;
    }

    return FALSE;
*/
