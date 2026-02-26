//::///////////////////////////////////////////////
//:: FileName BG 1
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: David Novotny
//:: Created On: 10/20/17
//:://////////////////////////////////////////////
#include "NWNX_Creature"

int StartingConditional()
{
    // Make sure the player has the required feats
    object oPC = GetPCSpeaker();
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");
    int nSubrace = GetLocalInt(oItem, "CC0");
    return (
        GetRacialType(oPC) == RACIAL_TYPE_HUMAN &&
        GetLevelByClass(CLASS_TYPE_BARBARIAN, oPC) < 1 &&
        nSubrace != 1186 && // Aasimar
        nSubrace != 1187 && // Tiefling
        nSubrace != 1445 && // F(?) Folk
        nSubrace != 1446 && // Chultan
        nSubrace != 1450 && // Shaaran
        nSubrace != 1451 && // Shou
        nSubrace != 1448 && // Maztican
        nSubrace != 1175    // Natural Lycan
    );
}
/* -- Old Code (replaced with new system checks) LordValianr 12/23/2023 --
    return(
        GetRacialType(oPC) == RACIAL_TYPE_HUMAN &&
        GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC) < 1 &&
        !GetHasFeat(1186,oPC) && //Aasimar
        !GetHasFeat(1187,oPC) && //Tiefling
        !GetHasFeat(1445,oPC) && //F(?) Folk
        !GetHasFeat(1446,oPC) && //Chultan
        !GetHasFeat(1450,oPC) && //Shaaran
        !GetHasFeat(1451,oPC) && //Shou
        !GetHasFeat(1448,oPC) && //Maztican
        !GetHasFeat(1175,oPC)    //Natural Lycan
    );
*/
