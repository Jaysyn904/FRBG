#include "nwnx_creature"

void main()
{
    object oPC = GetPCSpeaker();
    object oItem = GetItemPossessedBy(oPC,"PC_Data_Object");
    SetLocalInt(oItem,"CC6",1); // middle-aged
    SetLocalInt(oItem,"BG_Select",7);
    ActionStartConversation(oPC, "bg_disfig", TRUE);
}
/* -- Moved to end of CharCreation: LordValinar (12/18/2023) --
    int iCHA = GetAbilityScore(oPC, ABILITY_CHARISMA, TRUE);
    int iCON = GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE);
    int iDEX = GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE);
    int iINT = GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE);
    int iSTR = GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE);
    int iWIS = GetAbilityScore(oPC, ABILITY_WISDOM, TRUE);

    NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_STRENGTH, iSTR-1);
    NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CONSTITUTION, iCON-1);
    NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_DEXTERITY, iDEX-1);
    NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_INTELLIGENCE, iINT+1);
    NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CHARISMA, iCHA+1);
    NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_WISDOM, iWIS+1);
*/
