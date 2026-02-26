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
        nSubrace == 1180 || // Silver Elf
        nSubrace == 1182 || // Gold Dwarf
        nSubrace == 1184 || // Shield Dwarf
        nSubrace == 1186 || // Aasimar
        nSubrace == 1381 || // Calishite
        nSubrace == 1382 || // Chondathan
        nSubrace == 1383 || // Damaran
        nSubrace == 1384 || // Illuskan
        nSubrace == 1385 || // Mulan
        nSubrace == 1386 || // Rashemi
        nSubrace == 1387 || // Tethyrian
        nSubrace == 1388 || // Rashemi
        nSubrace == 1445 || // F(?) Folk
        nSubrace == 1447 || // Imaskari
        nSubrace == 1448 || // Maztican
        nSubrace == 1450 || // Shaaran
        nSubrace == 1451 || // Shou
        nSubrace == 1454 || // Rock Gnome
        nSubrace == 1455 || // Ghostwise Halfling
        nSubrace == 1456 || // Lightfoot Halfling
        nSubrace == 1457 || // Strongheart Halfling
        GetRacialType(oPC) == RACIAL_TYPE_HALFORC
    );
}

/* -- Old Code (removed - LordValinar 12/23/2023) -- *
    if(GetHasFeat(1182,oPC) ||
        GetHasFeat(1184,oPC) ||
        GetHasFeat(1180,oPC) ||
        GetHasFeat(1454,oPC) ||
        GetHasFeat(1455,oPC) ||
        GetHasFeat(1456,oPC) ||
        GetHasFeat(1457,oPC) ||
        GetHasFeat(1445,oPC) ||
        GetHasFeat(1447,oPC) ||
        GetHasFeat(1448,oPC) ||
        GetHasFeat(1450,oPC) ||
        GetHasFeat(1451,oPC) ||
        GetHasFeat(1381,oPC) ||
        GetHasFeat(1382,oPC) ||
        GetHasFeat(1383,oPC) ||
        GetHasFeat(1384,oPC) ||
        GetHasFeat(1385,oPC) ||
        GetHasFeat(1386,oPC) ||
        GetHasFeat(1387,oPC) ||
        GetHasFeat(1388,oPC) ||
        GetHasFeat(1186,oPC) ||
        GetRacialType(oPC) == RACIAL_TYPE_HALFORC)
    {
        return TRUE;
    }

    return FALSE;
}
