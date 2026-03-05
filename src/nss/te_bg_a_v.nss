#include "nwnx_creature"

void main()
{
    object oPC = GetPCSpeaker();
    object oItem = GetItemPossessedBy(oPC,"PC_Data_Object");
    SetLocalInt(oItem,"CC6",3); // venerable
    SetLocalInt(oItem,"BG_Select",7);
    ActionStartConversation(oPC, "bg_disfig", TRUE);
}
/* -- Moved to end of CharCreation: LordValinar (12/18/2023) --
    NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_STRENGTH, iSTR-2);
    NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CONSTITUTION, iCON-3);
    NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_DEXTERITY, iDEX-3);
    NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_INTELLIGENCE, iINT+3);
    NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CHARISMA, iCHA+3);
    NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_WISDOM, iWIS+3);
*/
