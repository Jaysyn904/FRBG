void main()
{
    object oPC = GetPCSpeaker();
    object oItem = GetItemPossessedBy(oPC,"PC_Data_Object");
    SetLocalInt(oItem,"BG_Select",8);
    ExecuteScript("bg_apply", oPC); // final task -LordValinar(12/18/2023)
}
