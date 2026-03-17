// LordValinar's Scripts - Background Application (12/18/2023)
// =============================================================================
/*
    The final process, to take all of the saved settings from character
    creation and apply them here. (This was to prevent exploits)
*/
// =============================================================================
#include "nwnx_creature"
#include "te_afflic_func"
#include "lv_inc"
#include "inc_persist_loca"
#include "te_lang"  

// Ensure the PC Data Object exists; create if missing    
object EnsurePlayerDataObject(object oPC)    
{   
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");    
    if (!GetIsObjectValid(oItem))    
    {    
        oItem = CreateItemOnObject("pc_data_object", oPC);
		SendMessageToPC(oPC, "Language data object recreated");
		WriteTimestampedLogEntry("Language data object recreated"); 		
    }    
    return oItem;    
}   

void ApplyProficiencies(object oPC)    
{    
    object oItem = EnsurePlayerDataObject(oPC);   
    if (!GetIsObjectValid(oItem)) {  
        SendMessageToPC(oPC, "DEBUG: Invalid player data object");  
        return;   
    }  
  
    int iLore       = GetSkillRank(SKILL_LORE, oPC, TRUE);  
    int iSpellCraft = GetSkillRank(SKILL_SPELLCRAFT, oPC, TRUE);	  
        
    int i = 0;    
    string sSlot;    
    int nFound = 0;  
        
    while (i < 99)    
    {    
        sSlot = "PROFICIENCY_" + (i < 10 ? "0" : "") + IntToString(i);    
            
        int nProficiencyFeat = GetPersistantLocalInt(oPC, sSlot);    
        if (nProficiencyFeat == 0)    
            nProficiencyFeat = GetLocalInt(oItem, sSlot);    
            
        if (nProficiencyFeat > 0)    
        {    
            SendMessageToPC(oPC, "DEBUG: Applying feat " + IntToString(nProficiencyFeat) + " from slot " + sSlot);  
            NWNX_Creature_AddFeatByLevel(oPC, nProficiencyFeat, 1);  
            nFound++;  
  
            if (nProficiencyFeat == PROFICIENCY_ASTROLOGY)  
            {  
                NWNX_Creature_SetSkillRank(oPC, SKILL_LORE, iLore +2);  
                NWNX_Creature_SetSkillRank(oPC, SKILL_SPELLCRAFT, iSpellCraft +2);  
            }  
        }    
            
        i++;    
    }  
      
    SendMessageToPC(oPC, "DEBUG: Applied " + IntToString(nFound) + " proficiencies");  
}

/* void ApplyProficiencies(object oPC)  
{  
    object oItem = EnsurePlayerDataObject(oPC); 
    if (!GetIsObjectValid(oItem)) return; 

    int iLore       = GetSkillRank(SKILL_LORE, oPC, TRUE);
    int iSpellCraft = GetSkillRank(SKILL_SPELLCRAFT, oPC, TRUE);	
      
    int i = 0;  
    string sSlot;  
      
    // Check all PROFICIENCY_* slots  
    while (i < 99)  
    {  
        sSlot = "PROFICIENCY_" + (i < 10 ? "0" : "") + IntToString(i);  
          
        // Check both persistent and item local variables  
        int nProficiencyFeat = GetPersistantLocalInt(oPC, sSlot);  
        if (nProficiencyFeat == 0)  
            nProficiencyFeat = GetLocalInt(oItem, sSlot);  
          
        // Apply the feat if found  
        if (nProficiencyFeat > 0)  
        {  
            NWNX_Creature_AddFeatByLevel(oPC, nProficiencyFeat, 1);

			if (nProficiencyFeat == PROFICIENCY_ASTROLOGY)
			{
				NWNX_Creature_SetSkillRank(oPC, SKILL_LORE, iLore +2);
				NWNX_Creature_SetSkillRank(oPC, SKILL_SPELLCRAFT, iSpellCraft +2);
			}
        }  
          
        i++;  
    }  
}
 */
void ApplyBonusLanguages(object oPC)  
{  
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");  
    if (!GetIsObjectValid(oItem)) return; 

    int i = 0;  
    string sSlot;  
      
    // Check all LANGUAGE_* slots 
    while (i < 99)  
    {  
        sSlot = "LANGUAGE_" + (i < 10 ? "0" : "") + IntToString(i);  
          
        // Check both persistent and item local variables  
        int nLanguageFeat = GetPersistantLocalInt(oPC, sSlot);  
        if (nLanguageFeat == 0)  
            nLanguageFeat = GetLocalInt(oItem, sSlot);  
          
        // Apply the feat if found  
        if (nLanguageFeat > 0)  
        {  
            NWNX_Creature_AddFeatByLevel(oPC, nLanguageFeat, 1);
			
			//:: For legacy DMFI
			SetLocalInt(oItem, IntToString(LangFeatToLangID(nLanguageFeat)), 1);			
        }  
          
        i++;  
    }  
}

void main()
{
    object oPC      = OBJECT_SELF; // from ExecuteScript()
    object oItem    = GetItemPossessedBy(oPC, "PC_Data_Object");
    int nSubrace    = GetLocalInt(oItem, "CC0"); /**/ DeleteLocalInt(oItem, "CC0");
    int nClass      = GetLocalInt(oItem, "CC1"); /**/ DeleteLocalInt(oItem, "CC1");
    int nBackground = GetLocalInt(oItem, "CC2"); /**/ DeleteLocalInt(oItem, "CC2");
    int nDeity      = GetLocalInt(oItem, "CC3"); /**/ DeleteLocalInt(oItem, "CC3");
    int nAge        = GetLocalInt(oItem, "CC6"); /**/ DeleteLocalInt(oItem, "CC6");
    int bDisfigured = GetLocalInt(oItem, "CC7"); /**/ DeleteLocalInt(oItem, "CC7");
    // Stats
    int iCL         = GetHitDice(oPC);
    int iSTR        = GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE);
    int iDEX        = GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE);
    int iCON        = GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE);
    int iINT        = GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE);
    int iWIS        = GetAbilityScore(oPC, ABILITY_WISDOM, TRUE);
    int iCHA        = GetAbilityScore(oPC, ABILITY_CHARISMA, TRUE);
    // Skills
    int iHide       = GetSkillRank(SKILL_HIDE, oPC, TRUE);
    int iBluff      = GetSkillRank(SKILL_BLUFF, oPC, TRUE);
    int iSpot       = GetSkillRank(SKILL_SPOT, oPC, TRUE);
    int iListen     = GetSkillRank(SKILL_LISTEN, oPC, TRUE);
    int iLore       = GetSkillRank(SKILL_LORE, oPC, TRUE);
    int iMoveSil    = GetSkillRank(SKILL_MOVE_SILENTLY, oPC, TRUE);
    int iSpellCraft = GetSkillRank(SKILL_SPELLCRAFT, oPC, TRUE);
    // Effects
    effect eSpellResist = EffectSpellResistanceIncrease(11+iCL);


    // Step 0: Subrace/Ethnicity (some of this might be redundant now)
    if (nSubrace > 0) NWNX_Creature_AddFeatByLevel(oPC, nSubrace, 1);
    switch (nSubrace)
    {
        case ETHNICITY_TETHYRIAN: case ETHNICITY_CALISHITE: 
		{            
			//SetLocalInt(oItem, "23", 1); // Language: Alzhedo
			SetPersistantLocalInt(oPC, "23", 1);
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_ALZHEDO, 1);

			//:: For legacy DMFI
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_ALZHEDO)), 1);			
        } 
		break;
        case ETHNICITY_CHONDATHAN: 
		{
            //SetLocalInt(oItem, "53", 1); // Language: Chondathan
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_CHONDATHAN, 1);

			//:: For legacy DMFI
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_CHONDATHAN)), 1);			
        } 
		break;
        case ETHNICITY_DAMARAN: 
		{
            //SetLocalInt(oItem, "56", 1); // Language: Damaran
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_DAMARAN, 1);
			
			//:: For legacy DMFI
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_DAMARAN)), 1);
        } 
		break;
        case ETHNICITY_FFOLK: 
		{ // Talfiric
            //SetLocalInt(oItem, "38", 1); // Language: Talfiric
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_TALFIRIC, 1);

			//:: For legacy DMFI
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_DAMARAN)), 1);			
        } 
		break;
        case ETHNICITY_ILLUSKAN: 
		{
            //SetLocalInt(oItem, "22", 1); // Language: Illuskan
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_ILLUSKAN, 1);

			//:: For legacy DMFI
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_ILLUSKAN)), 1);			
        } 
		break;
        case ETHNICITY_IMASKARI: 
		{ // Imaskari
            //SetLocalInt(oItem, "24", 1); // Language: Imaskari
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_IMASKARI, 1);	
			//SetLocalInt(oItem, "46", 1); // Language: Undercommon			
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_UNDERCOMMON, 1);

			//:: For legacy DMFI
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_IMASKARI)), 1);
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_UNDERCOMMON)), 1);			
        } 
		break;
        case ETHNICITY_MULAN: 
		{
            //SetLocalInt(oItem, "27", 1); // Language: Mulanese
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_MULANESE, 1);
	
			//:: For legacy DMFI
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_MULANESE)), 1);			
        } 
		break;
        case ETHNICITY_RASHEMI: 
		{
            //SetLocalInt(oItem, "30", 1); // Langauge: Rashemi
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_RASHEMI, 1);

			//:: For legacy DMFI
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_RASHEMI)), 1);			
        }
		break;
        case ETHNICITY_SHAARAN: 
		{
            //SetLocalInt(oItem, "34", 1); // Language: Shaaran
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_SHAARAN, 1);

			//:: For legacy DMFI
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_SHAARAN)), 1);			
        } 	
		break;
        case ETHNICITY_SHOU: 
		{
            SetLocalInt(oItem, "35", 1); // Language: Shou  (no feat for this one)
			//NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_SHAARAN, 1);

			//:: For legacy DMFI
			//SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_SHAARAN)), 1);			
        } 	
		break;		
		case ETHNICITY_CHULTAN: 
		{
            //SetLocalInt(oItem, "31", 1); // Langauge: Chultan
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_CHULTAN, 1);

			//:: For legacy DMFI
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_CHULTAN)), 1);			
        } 
		break;
		case ETHNICITY_MAZTILAN: 
		{
            //SetLocalInt(oItem, "32", 1); // Langauge: Maztilan
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_MAZTILAN, 1);

			//:: For legacy DMFI
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_MAZTILAN)), 1);			
        }		
		break;
        case BACKGROUND_TIEFLING: 
		{
            SetLocalInt(oItem, "iPCSubrace", 11);
            SetLocalInt(oItem, "PC_ECL", 1);
            SetSubRace(oPC, "Tiefling");
            NWNX_Creature_AddFeatByLevel(oPC, FEAT_DARKVISION,1);
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_INTELLIGENCE, iINT +2);
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_DEXTERITY, iDEX +2);
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CHARISMA, iCHA -2);
            NWNX_Creature_SetSkillRank(oPC, SKILL_BLUFF, iBluff +2);
            NWNX_Creature_SetSkillRank(oPC, SKILL_HIDE, iHide+2);
        } 
		break;
        case BACKGROUND_NAT_LYCAN: 
		{
            SetLocalInt(oItem, "PC_ECL", 2);
            if (GetRacialType(oPC) == RACIAL_TYPE_ELF) {
                SetSubRace(oPC, "Lythari");
            } else {
                SetSubRace(oPC, "Natural Lycanthrope");
            }
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_WISDOM, iWIS + 2);
        } 
		break;
        case BACKGROUND_AASIMAR: 
		{
            SetLocalInt(oItem, "iPCSubrace", 10);
            SetLocalInt(oItem, "PC_ECL",1);
            SetSubRace(oPC, "Aasimar");
            NWNX_Creature_AddFeatByLevel(oPC,228,1); // Darkvision
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_WISDOM, iWIS +2);
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CHARISMA, iCHA +2);
            NWNX_Creature_SetSkillRank(oPC, SKILL_SPOT, iSpot +2);
            NWNX_Creature_SetSkillRank(oPC, SKILL_LISTEN, iListen+2);
        } 
		break;
        case BACKGROUND_GOLD_DWARF: 
		{
            SetLocalInt(oItem, "PC_ECL", 0);
            SetSubRace(oPC, "Gold Dwarf");
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CHARISMA, iCHA +4);
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_DEXTERITY, iDEX -2);
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_DWARVEN, 1);
			
			//:: For legacy DMFI
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_DWARVEN)), 1);			
        } 
		break;
        case BACKGROUND_GREY_DWARF: 
		{
            SetLocalInt(oItem, "PC_ECL", 2);
            SetSubRace(oPC, "Grey Dwarf");
            NWNX_Creature_SetSkillRank(oPC, SKILL_MOVE_SILENTLY, iMoveSil +4);
            AddSubraceEffect(oPC, EffectImmunity(IMMUNITY_TYPE_POISON));
            AddSubraceEffect(oPC, EffectImmunity(IMMUNITY_TYPE_PARALYSIS));
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_DUERGAR, 1);
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_UNDERCOMMON, 1);
			
			//:: For legacy DMFI
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_DUERGAR)), 1);			
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_UNDERCOMMON)), 1);
			
            //SetLocalInt(oItem, "64", 1); // Language: Duergar
            //SetLocalInt(oItem, "46", 1); // Language: Undercommon
        } 
		break;
        case BACKGROUND_SHIELD_DWARF: 
		{
            SetLocalInt(oItem, "PC_ECL", 0);
            SetSubRace(oPC, "Shield Dwarf");
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_DWARVEN, 1);
			
			//:: For legacy DMFI
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_DWARVEN)), 1);			
        } 
		break;
        case BACKGROUND_COPPER_ELF: 
		{
            SetLocalInt(oItem, "PC_ECL", 0);
            SetSubRace(oPC, "Copper Elf");
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_STRENGTH, iSTR +2);
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_INTELLIGENCE, iINT -2);
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CHARISMA, iCHA -2);
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_ELVEN, 1);
			
			//:: For legacy DMFI
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_ELVEN)), 1);			
        } 
		break;
        case BACKGROUND_DARK_ELF: 
		{
            SetLocalInt(oItem, "PC_ECL", 2);
            SetSubRace(oPC, "Dark Elf");
            NWNX_Creature_AddFeatByLevel(oPC, 228, 1); // Darkvision
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_INTELLIGENCE, iINT +2);
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CHARISMA, iCHA +2);
            AddSubraceEffect(oPC, eSpellResist);
            //SetLocalInt(oItem, "81", 1); // Language: Drow
            //SetLocalInt(oItem, "46", 1); // Language: Undercommon
            //SetLocalInt(oItem, "13", 1); // Language: Drow Sign
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_DROW, 1);
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_UNDERCOMMON, 1);
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_DROW_HAND_CANT, 1);
			
			//:: For legacy DMFI
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_DROW)), 1);
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_UNDERCOMMON)), 1);	
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_DROW_HAND_CANT)), 1);				
        } 
		break;
        case ETHNICITY_FEYRI: 
		{ // BACKGROUND_ELF_FEYRI
            SetLocalInt(oItem, "PC_ECL", 3);
            SetSubRace(oPC, "Fey'ri");
            NWNX_Creature_AddFeatByLevel(oPC, FEAT_DARKVISION, 1); // Darkvision
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_DEXTERITY, iDEX +2);
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CONSTITUTION, iCON -2);
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_INTELLIGENCE, iINT +2);
            NWNX_Creature_SetSkillRank(oPC, SKILL_BLUFF, iBluff +2);
            NWNX_Creature_SetSkillRank(oPC, SKILL_HIDE, iHide +2);
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_ELVEN, 1);
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_ABYSSAL, 1);
			
			//:: For legacy DMFI
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_ELVEN)), 1);	
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_ABYSSAL)), 1);			
        } 
		break;
        case BACKGROUND_GREEN_ELF: 
		{
            SetLocalInt(oItem, "PC_ECL", 0);
            SetSubRace(oPC, "Green Elf");
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CONSTITUTION, iCON +4);
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_INTELLIGENCE, iINT -2);
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_ELVEN, 1);
			
			//:: For legacy DMFI
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_ELVEN)), 1);
        } 
		break;
        case BACKGROUND_GOLD_ELF: 
		{
            SetLocalInt(oItem, "PC_ECL", 0);
            SetSubRace(oPC, "Gold Elf");
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_DEXTERITY, iDEX -2);
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_INTELLIGENCE, iINT +2);
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_ELVEN, 1);
			
			//:: For legacy DMFI
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_ELVEN)), 1);
        } 
		break;
        case BACKGROUND_SILVER_ELF: 
		{
            SetLocalInt(oItem, "PC_ECL", 0);
            SetSubRace(oPC, "Silver Elf");
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_ELVEN, 1);
			
			//:: For legacy DMFI
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_ELVEN)), 1);
        } 
		break;
        case ETHNICITY_DEEP_GNOME: 
		{ // BACKGROUND_GNOME_DEEP
            SetLocalInt(oItem, "PC_ECL", 2);
            SetSubRace(oPC, "Deep Gnome");
            NWNX_Creature_AddFeatByLevel(oPC,nSubrace,1);
            NWNX_Creature_AddFeatByLevel(oPC, FEAT_DARKVISION, 1); // Darkvision
            NWNX_Creature_AddFeatByLevel(oPC, FEAT_STONECUNNING, 1); // Stonecunning
            AddSubraceEffect(oPC, eSpellResist);
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_DEXTERITY, iDEX +2);
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CONSTITUTION, iCON -4);
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_WISDOM, iWIS +2);
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CHARISMA, iCHA -4);
            NWNX_Creature_SetSkillRank(oPC, SKILL_HIDE, iHide +2);
            //SetLocalInt(oItem,"46",1); // Language: Undercommon
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_UNDERCOMMON, 1);
			
			//:: For legacy DMFI
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_UNDERCOMMON)), 1);
        } 
		break;
        case ETHNICITY_FOREST_GNOME: 
		{ // BACKGROUND_GNOME_FOREST
            SetLocalInt(oItem, "PC_ECL", 1);
            SetSubRace(oPC, "Forest Gnome");
            NWNX_Creature_SetSkillRank(oPC, SKILL_HIDE, iHide + 4);
            //SetLocalInt(oItem, "8", 1); // Language: Animals
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_GNOMISH, 1);
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_ANIMAL, 1);
			
			//:: For legacy DMFI
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_GNOMISH)), 1);
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_ANIMAL)), 1);			
        } 
		break;
        case ETHNICITY_ROCK_GNOME: 
		{ // BACKGROUND_GNOME_ROCK
            SetLocalInt(oItem, "PC_ECL", 0);
            SetSubRace(oPC, "Rock Gnome");
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_GNOMISH, 1);
			
			//:: For legacy DMFI
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_GNOMISH)), 1);
        } 
		break;
        case ETHNICITY_GHOSTWISE: 
		{ // BACKGROUND_HALFLING_GHOSTWISE
            SetLocalInt(oItem, "PC_ECL", 0);
            SetSubRace(oPC, "Ghostwise Halfling");
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_HALFLING, 1);
			
			//:: For legacy DMFI
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_HALFLING)), 1);
        } 
		break;
        case ETHNICITY_LIGHTFOOT: 
		{ // BACKGROUND_HALFLING_LIGHTFOOT
            SetLocalInt(oItem, "PC_ECL", 0);
            SetSubRace(oPC, "Lightfoot Halfling");
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_HALFLING, 1);
			
			//:: For legacy DMFI
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_HALFLING)), 1);
        } 
		break;
        case ETHNICITY_STRONGHEART: 
		{ // BACKGROUND_HALFLING_STRONGHEART
            SetLocalInt(oItem, "PC_ECL", 0);
            SetSubRace(oPC, "Strongheart Halfling");
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_HALFLING, 1);
			
			//:: For legacy DMFI
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_HALFLING)), 1);
        } 
		break;
    }

    // Step 1: Class Adjustments
    if (nClass > 0) NWNX_Creature_AddFeatByLevel(oPC, nClass, 1);

    // Step 2: Background Adjustments
    if (nBackground > 0) NWNX_Creature_AddFeatByLevel(oPC, nBackground, 1);
    switch (nBackground)
    {
        case BACKGROUND_CALISHITE_TRAINED:
		{
            //SetLocalInt(oItem, "23", 1); // Language: Alzhedo
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_ALZHEDO, 1);
						
			//:: For legacy DMFI
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_ALZHEDO)), 1);
		}
		break;
        case BACKGROUND_CIRCLE_BORN:
		{
            //SetLocalInt(oItem, "8", 1); // Language: Animals
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_ANIMAL, 1);
			
			//:: For legacy DMFI
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_ANIMAL)), 1);
		}
		break;
        case BACKGROUND_OCCULTIST: 
		{
            NWNX_Creature_AddFeatByLevel(oPC, PROFICIENCY_ASTROLOGY, 1);
            NWNX_Creature_SetSkillRank(oPC, SKILL_LORE, iLore +2);
            NWNX_Creature_SetSkillRank(oPC, SKILL_SPELLCRAFT, iSpellCraft +2);
        } 
		break;
        case BACKGROUND_TALFIRIAN:
		{
            //SetLocalInt(oItem, "38", 1); // Language: Talfirian
			NWNX_Creature_AddFeatByLevel(oPC, FEAT_LANGUAGE_TALFIRIC, 1); 
	
			//:: For legacy DMFI
			SetLocalInt(oItem, IntToString(LangFeatToLangID(FEAT_LANGUAGE_TALFIRIC)), 1);			
		}
		break;
    }

    // Step 4: Deity Adjustments
    if (nDeity > 0) NWNX_Creature_AddFeat(oPC, nDeity);

    // Step 5: Languages	
	ApplyBonusLanguages(oPC);
	
/*     string sArr = GetLocalString(oItem, "ARR_LANGUAGES");
    int i; for (i = 0; i < ArrayLength(sArr); i++)
    {
        string lang = ArrayParse(sArr, i);
        SetLocalInt(oItem, lang, 1);
    }
    DeleteLocalString(oItem, "ARR_LANGUAGES"); */

    // Step 6: Proficiencies
	ApplyProficiencies(oPC);
	
/*     sArr = GetLocalString(oItem, "ARR_PROF");
    for (i = 0; i < ArrayLength(sArr); i++)
    {
        int nFeat = StringToInt(ArrayParse(sArr, i));
        if (nFeat > 0) NWNX_Creature_AddFeatByLevel(oPC, nFeat, 1);
        if (nFeat == PROFICIENCY_ASTROLOGY)
        {
            NWNX_Creature_SetSkillRank(oPC, SKILL_LORE, iLore +2);
            NWNX_Creature_SetSkillRank(oPC, SKILL_SPELLCRAFT, iSpellCraft +2);
        }
    }
    DeleteLocalString(oItem, "ARR_PROF"); */

    // Step 7: Age Settings
    switch (nAge)
    {
		case AGE_CATEGORY_YOUTHFUL:
		{
			NWNX_Creature_AddFeatByLevel(oPC, AGE_CATEGORY_YOUTHFUL, 1);
			break;
		}		
        case AGE_CATEGORY_MIDDLE:
		{
            NWNX_Creature_AddFeatByLevel(oPC, AGE_CATEGORY_MIDDLE, 1);
			NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_STRENGTH, iSTR-1);
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CONSTITUTION, iCON-1);
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_DEXTERITY, iDEX-1);
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_INTELLIGENCE, iINT+1);
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CHARISMA, iCHA+1);
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_WISDOM, iWIS+1);
            break;
		}
        case AGE_CATEGORY_OLD:
		{
            NWNX_Creature_AddFeatByLevel(oPC, AGE_CATEGORY_OLD, 1);
			NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_STRENGTH, iSTR-2);
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CONSTITUTION, iCON-2);
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_DEXTERITY, iDEX-2);
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_INTELLIGENCE, iINT+2);
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CHARISMA, iCHA+2);
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_WISDOM, iWIS+2);
            break;
		}
        case AGE_CATEGORY_VENERABLE:
		{
            NWNX_Creature_AddFeatByLevel(oPC, AGE_CATEGORY_VENERABLE, 1);
			NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_STRENGTH, iSTR-3);
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CONSTITUTION, iCON-3);
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_DEXTERITY, iDEX-3);
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_INTELLIGENCE, iINT+3);
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CHARISMA, iCHA+3);
            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_WISDOM, iWIS+3);
            break;
		}
    }

    // Step 8: One-Armed?
    if (bDisfigured)
    {
        NWNX_Creature_AddFeatByLevel(oPC, DISABILITY_ONE_ARMED, 1);//One-Armed
        //Set Arm to be nonexistent. I set the non-models to be all model number 200.

        SetCreatureBodyPart(CREATURE_PART_LEFT_BICEP, 200, oPC);
        SetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM, 200, oPC);
        SetCreatureBodyPart(CREATURE_PART_LEFT_HAND, 200, oPC);
    }
}
