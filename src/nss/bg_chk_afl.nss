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
    int nRtype = GetRacialType(oPC);
    return (
        (nClass == BACKGROUND_MIDDLE || nClass == BACKGROUND_UPPER) &&
        (nRtype == RACIAL_TYPE_HALFELF || nRtype == RACIAL_TYPE_HUMAN)
    );
}
