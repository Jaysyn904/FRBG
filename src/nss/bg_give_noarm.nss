void main()
{
    object oPC = GetPCSpeaker();
    object oItem = GetItemPossessedBy(oPC,"PC_Data_Object");
    SetLocalInt(oItem,"CC7",1); // One-Armed
    SetLocalInt(oItem,"BG_Select",8);
    ExecuteScript("bg_apply", oPC);

/* -- Moved to final script for CharCreation: LordValinar (12/18/2023) --
    NWNX_Creature_AddFeatByLevel(oPC, 2000, 1);//One-Armed
    //Set Arm to be nonexistent. I set the non-models to be all model number 200.

    SetCreatureBodyPart(CREATURE_PART_LEFT_BICEP, 200, oPC);
    SetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM, 200, oPC);
    SetCreatureBodyPart(CREATURE_PART_LEFT_HAND, 200, oPC);
*/
}
