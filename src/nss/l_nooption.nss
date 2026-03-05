void main()
{
    object oPC = GetPCSpeaker();
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");
    SetLocalInt(oItem,"BG_Select",5);
    SetLocalInt(oItem,"Prof",3);
    ActionStartConversation(oPC,"bg_proficiency",TRUE);
}
