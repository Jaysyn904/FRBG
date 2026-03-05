#include "lv_inc"
/*
    Modified by: LordValinar (12/18/2023)
    Switched method to arrays (stored until applied at the
     Character Creation's finale)
*/
void main()
{
    object oPC = GetPCSpeaker();
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");
    SetLocalInt(oItem,"BG_Select",5);
    string sArr = GetLocalString(oItem, "ARR_LANGUAGES");
    sArr = ArrayPush(sArr, "64");
    SetLocalString(oItem, "ARR_LANGUAGES", sArr);
//    SetLocalInt(oItem,"64",1); // Duergar
    int nInt = GetLocalInt(oItem,"nLangSelect") - 1;
    SetLocalInt(oItem,"nLangSelect", nInt);
}
