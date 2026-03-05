// inc_alignment.nss  
// Nine-alignment constants for general scripting  
const int ALIGNMENT_LAWFUL_GOOD      = 0;  
const int ALIGNMENT_LAWFUL_NEUTRAL   = 1;  
const int ALIGNMENT_LAWFUL_EVIL      = 2;  
const int ALIGNMENT_NEUTRAL_GOOD     = 3;  
const int ALIGNMENT_TRUE_NEUTRAL     = 4;  
const int ALIGNMENT_NEUTRAL_EVIL     = 5;  
const int ALIGNMENT_CHAOTIC_GOOD     = 6;  
const int ALIGNMENT_CHAOTIC_NEUTRAL  = 7;  
const int ALIGNMENT_CHAOTIC_EVIL     = 8;
  
// Get a creature’s alignment.  
int GetCreaturesAlignment(object oCreature)  
{  
    int nGE = GetAlignmentGoodEvil(oCreature);  
    int nLC = GetAlignmentLawChaos(oCreature);  
    int nBase;  
  
    switch (nGE)  
    {  
        case ALIGNMENT_GOOD:    nBase = 0; break;  
        case ALIGNMENT_NEUTRAL: nBase = 1; break;  
        case ALIGNMENT_EVIL:    nBase = 2; break;  
        default:                nBase = 1; // fallback to neutral on error  
    }  
  
    switch (nLC)  
    {  
        case ALIGNMENT_LAWFUL:   nBase += 0; break;  
        case ALIGNMENT_NEUTRAL:  nBase += 3; break;  
        case ALIGNMENT_CHAOTIC:  nBase += 6; break;  
        default:                 nBase += 3; // fallback to neutral on error  
    }  
  
    return nBase; // returns one of the nine ALIGNMENT_* constants above  
}