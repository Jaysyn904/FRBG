#include "prc_effect_inc"

void main()
{
    object oPC = OBJECT_SELF;
	int nSpellID = GetSpellId();
    
    if (GetHasSpellEffect(nSpellID, oPC))
	{
        PRCRemoveSpellEffects(nSpellID, oPC, oPC);
	}
    else
    {

        int nAC = 2;
        if (GetSkillRank(SKILL_TUMBLE, oPC, TRUE) >= 5) nAC++;

        effect eLink = EffectLinkEffects(EffectACIncrease(nAC, AC_DODGE_BONUS), EffectAttackDecrease(4));
        eLink = ExtraordinaryEffect(eLink);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
    }    
}