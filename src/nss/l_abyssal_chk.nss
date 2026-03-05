#include "lv_inc"
/*
    Modified by: LordValinar (12/18/2023)
    Switched method to arrays (stored until applied at the
     Character Creation's finale)
*/
int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");
    string sArr = GetLocalString(oItem, "ARR_LANGUAGES");
    // Make sure the player has the required feats
    return (
        GetLocalInt(oItem,"nLangSelect") > 0 &&  // Points to spend
        ArrayLength(sArr) < 3 &&                 // Array not full
        ArrayIndex(sArr, "11") == -1             // This lang not already picked
    );
/* -- Original Code --
    if(GetLocalInt(oItem,"11") != 1 && GetLocalInt(oItem,"nLangSelect") >= 1)
    {
        return TRUE;
    }
    return FALSE;
*/
}

