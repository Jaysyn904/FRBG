//::///////////////////////////////////////////////
//:: FileName BG 1
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: David Novotny
//:: Created On: 10/20/17
//:://////////////////////////////////////////////
#include "nwnx_creature"
#include "te_afflic_func"

void main()
{
    object oPC = GetPCSpeaker();
    int iFeat = 1453;
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");
    /* -- Bonuses moved to end of CharCreation: LordValinar(12/18/2023) --
    SetLocalInt(oItem, "PC_ECL",1);
    SetSubRace(oPC, "Forest Gnome");
    NWNX_Creature_AddFeatByLevel(oPC,iFeat,1);
    SetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"8",1);
    NWNX_Creature_SetSkillRank(oPC,SKILL_HIDE,GetSkillRank(SKILL_HIDE,oPC,TRUE)+4);
    SetLocalInt(oItem,"8",1); // Animals
    */
    SetLocalInt(oItem,"CC0",iFeat);
    SetLocalInt(oItem,"BG_Select",1);
    ActionStartConversation(oPC,"bg_class",TRUE);
}
