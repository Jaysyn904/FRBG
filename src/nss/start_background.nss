//::///////////////////////////////////////////////
//:: start_background.nss
//:: Start the Background selectoin process
//::///////////////////////////////////////////////

void main()
{
    object oPC = GetLastUsedBy();
    object oPlaceable = OBJECT_SELF;

    if(!GetIsObjectValid(oPC))
    {
        return;
    }

    AssignCommand(oPC, ActionStartConversation(oPlaceable));
}