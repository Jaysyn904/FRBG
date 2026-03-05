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

    int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE,oPC);

    SetLocalInt(oItem,"nIntMod",nInt); // Is this even used? -LV
    SetLocalInt(oItem,"nLangSelect",nInt);

    // Resets the languages array
    SetLocalString(oItem, "ARR_LANGUAGES", "");
}
