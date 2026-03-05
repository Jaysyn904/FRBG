// bg_deity_cv.nss  
#include "inc_dynconv"  
#include "bg_inc_p_locals"
#include "inc_alignment"
#include "te_afflic_func"
  
const int STAGE_LIST    = 0;  
const int STAGE_CONFIRM = 1;  
  
string GetDeityText(object oPC, int nChoice) {  
    return GetLocalString(oPC, "deity_dyn_text_" + IntToString(nChoice));  
}  

int _CanBeUnderdarkExile(object oPC = OBJECT_SELF)
{
    int nSubrace = GetPersistantLocalInt(oPC, "CC0");
    return (
        nSubrace == 1179 || // Dark Elf
        nSubrace == 1182 || // Gold Dwarf
        nSubrace == 1183 || // Grey Dwarf
        nSubrace == 1184 || // Shield Dwarf
        nSubrace == 1187 || // Tiefling
        nSubrace == 1447 || // Imaskari
        nSubrace == 1452 || // Deep Gnome
        GetRacialType(oPC) == RACIAL_TYPE_HALFORC
    );
}

// Ensure the PC Data Object exists; create if missing  
object EnsurePlayerDataObject(object oPC)  
{  
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");  
    if (!GetIsObjectValid(oItem))  
    {  
        oItem = CreateItemOnObject("pc_data_object", oPC);  
    }  
    return oItem;  
}  
 
void main()     
{      
    object oPC = GetPCSpeaker(); 
	SendMessageToPC(oPC, "DEBUG: bg_deity_cv main() entered");
	
	int nRacialType		= GetRacialType(oPC);
	int nAlignment		= GetCreaturesAlignment(oPC);	
    int nValue 			= GetLocalInt(oPC, DYNCONV_VARIABLE);      
    int nStage 			= GetStage(oPC);      
      
    // Required guard: abort if nValue is 0      
    if (nValue == 0) return;      
      
    if (nValue == DYNCONV_SETUP_STAGE)     
	{      
        if (!GetIsStageSetUp(nStage, oPC))     
		{      
            if (nStage == STAGE_LIST)     
			{      
				SetHeader("Select your patron deity.  You can refresh the list with the Escape key if needed.");
				
				if (nRacialType == RACIAL_TYPE_DWARF)
				{
					// 1 The Dwarven Powers  
					AddChoice("The Dwarven Powers", 1, oPC);  
					SetLocalString(oPC, "deity_dyn_text_1",  
						"The Elven Powers\n[Alias:] These deities did not sponsor specialty priests following the Time of Troubles. Their clerics were normal and had to conform to the alignment requirements for their deities, or they even simply venerated the entire pantheons worshiped by their respective race.\nThe Dwarven deities were worshiped by the Dwarves of Faerun. As these powers have not revealed specialty priests to the Realms, they function as typical clerics..\n[Status:] Pantheon\n[Alignment:] \n[Specialty Priests:] None\n[Favored Weapons:] Varies\n\nDo you wish this pantheon to be your patron?");
				}                
				if (nRacialType == RACIAL_TYPE_ELF)
				{
					// 2 The Elven Powers  
					AddChoice("The Elven Powers", 2, oPC);  
					SetLocalString(oPC, "deity_dyn_text_2",  
						"The Elven Powers\n[Alias:] These deities did not sponsor specialty priests following the Time of Troubles. Their clerics were normal and had to conform to the alignment requirements for their deities, or they even simply venerated the entire pantheons worshiped by their respective race.\nThe Seldarine were worshiped by the Elves of Faerun. As these powers have not revealed specialty priests to the Realms, they function as typical clerics.\n[Status:] Pantheon\n[Alignment:] \n[Specialty Priests:] None\n[Favored Weapons:] Varies\n\nDo you wish this pantheon to be your patron?");
				}
				if (nRacialType == RACIAL_TYPE_GNOME)
				{					
					// 3 The Gnomish Powers  
					AddChoice("The Gnomish Powers", 3, oPC);  
					SetLocalString(oPC, "deity_dyn_text_3",  
						"The Gnomish Powers\n[Alias:] These deities did not sponsor specialty priests following the Time of Troubles. Their clerics were normal and had to conform to the alignment requirements for their deities, or they even simply venerated the entire pantheons worshiped by their respective race.\nThe Gnomish deities were worshiped by the Gnomes of Faerun. As these powers have not revealed specialty priests to the Realms, they function as typical clerics.\n[Status:] Pantheon\n[Alignment:] \n[Specialty Priests:] None\n[Favored Weapons:] Varies\n\nDo you wish this pantheon to be your patron?");
				}
				if (nRacialType == RACIAL_TYPE_HALFLING)
				{					
					// 4 The Halfling Powers  
					AddChoice("The Halfling Powers", 4, oPC);  
					SetLocalString(oPC, "deity_dyn_text_4",  
						"The Halfling Powers\n[Alias:] These deities did not sponsor specialty priests following the Time of Troubles. Their clerics were normal and had to conform to the alignment requirements for their deities, or they even simply venerated the entire pantheons worshiped by their respective race.\nThe Halfling deities were worshiped by the Halflings of Faerun. As these powers have not revealed specialty priests to the Realms, they function as typical clerics.\n[Status:] Pantheon\n[Alignment:] \n[Specialty Priests:] None\n[Favored Weapons:] Varies\n\nDo you wish this pantheon to be your patron?");
				}                
				if (nRacialType == RACIAL_TYPE_HUMANOID_ORC || nRacialType == RACIAL_TYPE_HALFORC)
				{
					// 5 The Orcish Powers  
					AddChoice("The Orcish Powers", 5, oPC);  
					SetLocalString(oPC, "deity_dyn_text_5",  
						"The Orcish Powers\n[Alias:] These deities did not sponsor specialty priests following the Time of Troubles. Their clerics were normal and had to conform to the alignment requirements for their deities, or they even simply venerated the entire pantheons worshiped by their respective race.\nThe Orcish deities were worshiped by the Orcs of Faerun. As these powers have not revealed specialty priests to the Realms, they function as typical clerics.\n[Status:] Pantheon\n[Alignment:] \n[Specialty Priests:] None\n[Favored Weapons:] Varies\n\nDo you wish this pantheon to be your patron?");
				}					
				if(_CanBeUnderdarkExile(oPC))
				{
					// 6 The Underdark Powers	
					AddChoice("The Underdark Powers", 6, oPC);  
					SetLocalString(oPC, "deity_dyn_text_6",  
						"The Underdark Powers\n[Alias:] These deities did not sponsor specialty priests following the Time of Troubles. Their clerics were normal and had to conform to the alignment requirements for their deities, or they even simply venerated the entire pantheons worshiped by their respective race.\nThe Underdark deities were worshiped by the Drow of Faerun. As these powers have not revealed specialty priests to the Realms, they function as typical clerics.\n[Status:] Pantheon\n[Alignment:] \n[Specialty Priests:] None\n[Favored Weapons:] Varies\n\nDo you wish this pantheon to be your patron?");
				}					
                if(nAlignment == ALIGNMENT_CHAOTIC_GOOD || 
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL || 
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL)
				{
					// 7 Akadi  
					AddChoice("Akadi", 7, oPC);  
					SetLocalString(oPC, "deity_dyn_text_7",  
						"Akadi\n[Alias:] Akadi is the whispering wind and the blinding gale storm, her form changing from season to season. The teachings of the Akadian church amount to a doctrine of find one's own enlightenment.\n[Status:] Lesser\n[Alignment:] CN\n[Specialty Priests:] none \n[Favored Weapons:] Javelin\n\nDo you wish this deity to be your patron?");
				}
                if(nAlignment == ALIGNMENT_LAWFUL_GOOD ||
					nAlignment == ALIGNMENT_LAWFUL_EVIL ||
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL)
				{						
					// 8 Amaunator  
					AddChoice("Amaunator", 8, oPC);  
					SetLocalString(oPC, "deity_dyn_text_8",  
						"Amaunator\n[Alias:] This deity is deceased and answers no prayers to their followers anywhere in the Realms..\n[Status:] Dead\n[Alignment:] LN\n[Specialty Priests:] none \n[Favored Weapons:] n/a\n\nDo you wish this deity to be your patron?");
				}
				if(nAlignment == ALIGNMENT_NEUTRAL_EVIL || 
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_EVIL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL)
				{
					// 9 Auril  
					AddChoice("Auril", 9, oPC);  
					SetLocalString(oPC, "deity_dyn_text_9",  
						"Auril\n[Alias:] The Frostmaiden\nAuril is the goddess of cold, winter, and frost. Her faith teaches that the cold is a purifying force and that winter is a time of survival and strength.\n[Status:] Lesser\n[Alignment:] NE\n[Specialty Priests:] Frostmaidens\n[Favored Weapons:] Mace\n\nDo you wish this deity to be your patron?"); 
				}
                if(nAlignment == ALIGNMENT_LAWFUL_GOOD ||
					nAlignment == ALIGNMENT_LAWFUL_EVIL ||
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL)
				{				
					// 10 Azuth  
					AddChoice("Azuth", 10, oPC);  
					SetLocalString(oPC, "deity_dyn_text_10",  
						"Azuth\n[Alias:] The High One\nAzuth is the god of wizards and magic. His faith teaches that magic should be studied and used with discipline and reason.\n[Status:] Lesser\n[Alignment:] LN\n[Specialty Priests:] Magistrati\n[Favored Weapons:] Quarterstaff\n\nDo you wish this deity to be your patron?");					
				}
                if(nAlignment == ALIGNMENT_NEUTRAL_EVIL ||
					nAlignment == ALIGNMENT_LAWFUL_EVIL ||
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL)
				{				
					// 11 Bane  
					AddChoice("Bane", 11, oPC);  
					SetLocalString(oPC, "deity_dyn_text_11",  
						"Bane\n[Alias:] The Black Hand\nBane is the god of tyranny, hatred, and fear. His faith teaches that strength and domination are the paths to power. Followers of Bane often seek to conquer and control others.\n[Status:] Greater\n[Alignment:] LE\n[Specialty Priests:] Banesons\n[Favored Weapons:] Gauntlet\n\nDo you wish this deity to be your patron?");   
				}
                if(nAlignment == ALIGNMENT_CHAOTIC_EVIL ||
					nAlignment == ALIGNMENT_NEUTRAL_EVIL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{				
					// 12 Beshaba  
					AddChoice("Beshaba", 12, oPC);  
					SetLocalString(oPC, "deity_dyn_text_12",  
						"Beshaba\n[Alias:] Maid of Misfortune\nBeshaba is the goddess of accidents, bad luck, and misfortune. Her faith teaches that luck is fickle and that disaster can strike at any time.\n[Status:] Lesser\n[Alignment:] CE\n[Specialty Priests:] Doommaidens\n[Favored Weapons:] Heavy Mace\n\nDo you wish this deity to be your patron?"); 
				}	
				if(nAlignment == ALIGNMENT_NEUTRAL_EVIL || 
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_EVIL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL)
				{
					// 13 Bhall  
					AddChoice("Bhall", 13, oPC);  
					SetLocalString(oPC, "deity_dyn_text_13",  
						"Bhall\n[Alias:] n/a \nThis deity is deceased and answers no prayers to their followers anywhere in the Realms.\n[Status:] Dead\n[Alignment:] NE\n[Specialty Priests:] n/a \n[Favored Weapons:] n/a \n\nDo you wish this deity to be your patron?");
				}
                if(nAlignment == ALIGNMENT_CHAOTIC_GOOD || 
					nAlignment == ALIGNMENT_NEUTRAL_GOOD || 
					nAlignment == ALIGNMENT_LAWFUL_GOOD )
				{
					// 14 Chauntea  
					AddChoice("Chauntea", 14, oPC);  
					SetLocalString(oPC, "deity_dyn_text_14",  
						"Chauntea\n[Alias:] The Great Mother\nChauntea is the goddess of agriculture, life, and the earth. Her faith teaches that the land provides all things and must be nurtured.\n[Status:] Greater\n[Alignment:] NG\n[Specialty Priests:] Druids\n[Favored Weapons:] Scythe\n\nDo you wish this deity to be your patron?");
				}
                if(nAlignment == ALIGNMENT_CHAOTIC_EVIL ||
					nAlignment == ALIGNMENT_NEUTRAL_EVIL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{				
					// 15 Cyric  
					AddChoice("Cyric", 15, oPC);  
					SetLocalString(oPC, "deity_dyn_text_15",  
						"Cyric\n[Alias:] The Prince of Lies\nCyric is the god of lies, intrigue, and illusion. His faith teaches that deception and manipulation are the keys to power. Followers of Cyric often engage in deceit and intrigue to achieve their goals.\n[Status:] Greater\n[Alignment:] CE\n[Specialty Priests:] Cyricists\n[Favored Weapons:] Dagger\n\nDo you wish this deity to be your patron?"); 					
				}
                if(nAlignment == ALIGNMENT_CHAOTIC_GOOD || 
					nAlignment == ALIGNMENT_NEUTRAL_GOOD || 
					nAlignment == ALIGNMENT_LAWFUL_GOOD )
				{
					// 16 Deneir  
					AddChoice("Deneir", 16, oPC);  
					SetLocalString(oPC, "deity_dyn_text_16",  
						"Deneir\n[Alias:] Lord of All Glyphs and Images\nDeneir is the god of literature, art, and cartography. His faith teaches that knowledge must be recorded and preserved for future generations.\n[Status:] Lesser\n[Alignment:] NG\n[Specialty Priests:] Glyphscribes\n[Favored Weapons:] Dagger\n\nDo you wish this deity to be your patron?");
				}	
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD || 
					nAlignment == ALIGNMENT_NEUTRAL_GOOD || 
					nAlignment == ALIGNMENT_LAWFUL_GOOD )
				{
					// 17 Eldath  
					AddChoice("Eldath", 17, oPC);  
					SetLocalString(oPC, "deity_dyn_text_17",  
						"Eldath\n[Alias:] Goddess of the Singing Waters\nEldath is the goddess of peace, pools, and springs. Her faith teaches that peace is the highest virtue and that violence is a last resort.\n[Status:] Lesser\n[Alignment:] NG\n[Specialty Priests:] Druids\n[Favored Weapons:] Druid\n\nDo you wish this deity to be your patron?"); 					
				}	
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD || 
					nAlignment == ALIGNMENT_NEUTRAL_GOOD || 
					nAlignment == ALIGNMENT_LAWFUL_GOOD )
				{
					// 18 Finder Wyvernspur  
					AddChoice("Finder Wyvernspur", 18, oPC);  
					SetLocalString(oPC, "deity_dyn_text_18",  
						"Finder Wyvernspur\n[Alias:] The Nameless Bard\Finder Wyvernspur is fairly new god of Cycles of Life, Saurials and Transformation of Art. Finder's Church was very small, consisting primarily of younger bards, musicians, and those who sought to change and diversify the arts. \n[Status:] Lesser\n[Alignment:] NG\n[Specialty Priests:] Finders\n[Favored Weapons:] Bastard Sword\n\nDo you wish this deity to be your patron?");
				}
                if(nAlignment == ALIGNMENT_CHAOTIC_EVIL ||
					nAlignment == ALIGNMENT_NEUTRAL_EVIL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{
					// 19 Garagos  
					AddChoice("Garagos", 19, oPC);  
					SetLocalString(oPC, "deity_dyn_text_19",  
						"Garagos\n[Alias:] The Reaver\nGaragos is the god of war, destruction, and plunder. His faith teaches that strength is the only virtue and that conflict is the natural state of the world.\n[Status:] Demipower\n[Alignment:] CE\n[Specialty Priests:] Reavers\n[Favored Weapons:] Battleaxe\n\nDo you wish this deity to be your patron?");
				}
				if(nAlignment == ALIGNMENT_NEUTRAL_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL)
				{
					// 20 Gargauth  
					AddChoice("Gargauth", 20, oPC);  
					SetLocalString(oPC, "deity_dyn_text_20",  
						"Gargauth\n[Alias:] The Outcast\nGargauth is the god of betrayal, cruelty, and political corruption. His faith teaches that power is best gained through deceit and manipulation. Followers of Gargauth often engage in treachery and intrigue.\n[Status:] Demigod\n[Alignment:] LE\n[Specialty Priests:] Malefactors\n[Favored Weapons:] Dagger\n\nDo you wish this deity to be your patron?");
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{
					// 21 Gond  
					AddChoice("Gond", 21, oPC);  
					SetLocalString(oPC, "deity_dyn_text_21",  
						"Gond\n[Alias:] Wonderbringer\nGond is the god of invention, craft, and technology. His faith teaches that innovation and creation are sacred acts.\n[Status:] Lesser\n[Alignment:] N\n[Specialty Priests:] Artificers\n[Favored Weapons:] Warhammer\n\nDo you wish this deity to be your patron?"); 					
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{
					// 22 Grumbar  
					AddChoice("Grumbar", 22, oPC);  
					SetLocalString(oPC, "deity_dyn_text_22",  
						"Grumbar\n[Alias:] Earthlord\nGrumbar is the god of the earth itself.  His faith teaches that change should be resisted above all.\n[Status:] Greater\n[Alignment:] N\n[Specialty Priests:] Druids\n[Favored Weapons:] Club\n\nDo you wish this deity to be your patron?"); 
				}
                if(nAlignment == ALIGNMENT_CHAOTIC_GOOD || 
					nAlignment == ALIGNMENT_NEUTRAL_GOOD || 
					nAlignment == ALIGNMENT_LAWFUL_GOOD )
				{
					// 23  Gwaeron Windstrom  
					AddChoice("Gwaeron Windstrom", 23, oPC);  
					SetLocalString(oPC, "deity_dyn_text_23",  
						" Gwaeron Windstrom\n[Alias:] Master of Tracking\nGwaeron Windstrom is the demigod of the tracking and woodland signs. His faith teaches that nature and mankindd can live in harmony.\n[Status:] Greater\n[Alignment:] NG\n[Specialty Priests:] Druids\n[Favored Weapons:] Greatsword\n\nDo you wish this deity to be your patron?"); 					
				}				
                if(nAlignment == ALIGNMENT_LAWFUL_GOOD ||
					nAlignment == ALIGNMENT_LAWFUL_EVIL ||
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL)
				{
					// 24 Helm  
					AddChoice("Helm", 24, oPC);  
					SetLocalString(oPC, "deity_dyn_text_24",  
						"Helm\n[Alias:] The Vigilant One\nHelm is the god of guardians, protectors, and watchmen. His faith teaches vigilance and duty.\n[Status:] Greater\n[Alignment:] LN\n[Specialty Priests:] Watchers\n[Favored Weapons:] Longsword\n\nDo you wish this deity to be your patron?");
				}
                if(nAlignment == ALIGNMENT_LAWFUL_GOOD ||
					nAlignment == ALIGNMENT_LAWFUL_EVIL ||
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL)
				{
					// 25 Hoar  
					AddChoice("Hoar", 25, oPC);  
					SetLocalString(oPC, "deity_dyn_text_25",  
						"Hoar\n[Alias:] The Doombringer\nHoar is the god of revenge and poetic justice. His faith teaches that wrongs must be avenged and that justice will eventually be served. Followers of Hoar often seek to balance the scales through vengeance.\n[Status:] Demigod\n[Alignment:] LN\n[Specialty Priests:] Doombringers\n[Favored Weapons:] Spear\n\nDo you wish this deity to be your patron?");  					
				}

				if(nAlignment == ALIGNMENT_NEUTRAL_EVIL || 
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_EVIL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL)
				{
					// 26 Ibrandul  
					AddChoice("Ibrandul", 26, oPC);  
					SetLocalString(oPC, "deity_dyn_text_26",  
						"Ibrandul\n[Alias:] Lord of the Dry Depths\nIbrandul is the god of caves, darkness, and the Underdark. His faith teaches that the darkness holds secrets and that the depths are to be respected.\n[Status:] Demipower\n[Alignment:] NE\n[Specialty Priests:] Darkwalkers\n[Favored Weapons:] Club/Greatclub\n\nDo you wish this deity to be your patron?");
				}
				if(nAlignment == ALIGNMENT_LAWFUL_GOOD || 
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL || 
					nAlignment == ALIGNMENT_NEUTRAL_GOOD)
				{
					// 27 Ilmater  
					AddChoice("Ilmater", 27, oPC);  
					SetLocalString(oPC, "deity_dyn_text_27",  
						"Ilmater\n[Alias:] The Crying God\nIlmater is the god of endurance, martyrdom, perseverance & suffering. His faithful practices and encourages others to help the suffering by taking their burdens or places. Ilmater was a willing sufferer, bearing the pain of others to spare them from it.\n[Status:] Lesser\n[Alignment:] LG\n[Specialty Priests:] n/a \n[Favored Weapons:] Unarmed\n\nDo you wish this deity to be your patron?");
				}
 				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{
					// 28 Ishtishia  
					AddChoice("Ishtishia", 28, oPC);  
					SetLocalString(oPC, "deity_dyn_text_28",  
						"Ishtishia\n[Alias:] The Water Lord\nIshtishia is the primordial of elemental water. His faith was dispassionate, alien and not a worship of any specific body or state of water, but the water itself.\n[Status:] Lesser\n[Alignment:] LG\n[Specialty Priests:] n/a \n[Favored Weapons:] Warhammer\n\nDo you wish this deity to be your patron?");
				}
                if(nAlignment == ALIGNMENT_LAWFUL_GOOD ||
					nAlignment == ALIGNMENT_LAWFUL_EVIL ||
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL)
				{
					// 29 Jergal  
					AddChoice("Jergal", 29, oPC);  
					SetLocalString(oPC, "deity_dyn_text_29",  
						"Jergal\n[Alias:] The Scribe of Oaths\nThis deity is deceased and answers no prayers to their followers anywhere in the Realms.\n[Status:] Dead\n[Alignment:] LN\n[Specialty Priests:] Scribes\n[Favored Weapons:] Quarterstaff\n\nDo you wish this deity to be your patron?");
				}
				if(nAlignment == ALIGNMENT_NEUTRAL_EVIL || 
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_EVIL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL)
				{
					// 30 Karsus  
					AddChoice("Karsus", 30, oPC);  
					SetLocalString(oPC, "deity_dyn_text_30",  
						"Karsus\n[Alias:] The Karsus\nKarsus was once the greatest archwizard of Netheril who sought godhood by casting the legendary Karsus's Avatar. His ascension tore the Weave, causing the fall of the Netherese Empire and the descent of the goddess Mystryl. Now a dead power trapped in the Fugue Plane, Karsus exists as a cautionary tale of mortal hubris. He cannot grant spells or answer prayers, for his connection to the divine was severed by his own folly. Few still worship him, and those who do are mad scholars seeking the secrets of his lost magic.\n[Status:] Dead Power\n[Alignment:] N (formerly)\n[Specialty Priests:] None (cannot grant spells)\n[Favored Weapons:] Quarterstaff\n\nDo you wish this deity to be your patron?");					
				}
                if(nAlignment == ALIGNMENT_LAWFUL_GOOD ||
					nAlignment == ALIGNMENT_LAWFUL_EVIL ||
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL)
				{					
					// 31 Kelemvor  
					AddChoice("Kelemvor", 31, oPC);  
					SetLocalString(oPC, "deity_dyn_text_31",  
						"Kelemvor\n[Alias:] The Judge of the Dead\nKelemvor (pronounced KELL-em-vor) is the god of the dead and judge of the damned. He once was mortal, a paladin who served a god of the dead before ascending to divinity himself. Kelemvor?s faith teaches that the dead should be honored and that death is a natural part of life. He is a stern but fair deity who despises the undead and those who would unnaturally extend their lives.\n[Status:] Greater\n[Alignment:] LN\n[Specialty Priests:] Doomguides\n[Favored Weapons:] Heavy Mace\n\nDo you wish this deity to be your patron?"); 
				}						
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{
					// 32 Kossuth  
					AddChoice("Kossuth", 32, oPC);  
					SetLocalString(oPC, "deity_dyn_text_32",  
						"Kossuth\n[Alias:] The Firelord\nKossuth is the god of fire, elemental balance, and purification. He embodies both the creative and destructive aspects of flame, teaching that fire is the ultimate force of transformation and renewal. His followers believe that through fire, all things are purified and reborn. Kossuth's faith is popular among smiths, alchemists, and those who seek to burn away impurities in the world. The church of Kossuth maintains the eternal flames in major cities and oversees the sacred duty of fire-watching.\n[Status:] Greater\n[Alignment:] LN\n[Specialty Priests:] Firelords\n[Favored Weapons:] Heavy Mace\n\nDo you wish this deity to be your patron?");
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD || 
					nAlignment == ALIGNMENT_NEUTRAL_GOOD || 
					nAlignment == ALIGNMENT_LAWFUL_GOOD )
				{
					// 33 Lathander  
					AddChoice("Lathander", 33, oPC);  
					SetLocalString(oPC, "deity_dyn_text_33",  
						"Lathander\n[Alias:] The Morninglord\nLathander is the god of dawn, renewal, and birth. His faith teaches that each day is a new beginning and that hope is eternal.\n[Status:] Greater\n[Alignment:] NG\n[Specialty Priests:] Morninglords\n[Favored Weapons:] Morningstar\n\nDo you wish this deity to be your patron?"); 
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{
					// 34 Leira  
					AddChoice("Leira", 34, oPC);  
					SetLocalString(oPC, "deity_dyn_text_34",  
						"Leira\n[Alias:] The Lady of the Mists\nLeira is the goddess of illusion, deception, and trickery. Her faith teaches that truth is subjective and that illusion can be a shield or a weapon.\n[Status:] Intermediate\n[Alignment:] CN\n[Specialty Priests:] Tricksters\n[Favored Weapons:] Dagger\n\nDo you wish this deity to be your patron?");  
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_NEUTRAL_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{
					// 35 Lliira  
					AddChoice("Lliira", 35, oPC);  
					SetLocalString(oPC, "deity_dyn_text_35",  
						"Lliira\n[Alias:] Our Lady of Joy\nLliira is the goddess of joy, happiness, and dance. Her faith teaches that life should be celebrated and that sorrow is a poison to be avoided.\n[Status:] Lesser\n[Alignment:] CG\n[Specialty Priests:] Joydancers\n[Favored Weapons:] Dagger\n\nDo you wish this deity to be your patron?");  
				}
 				if(nAlignment == ALIGNMENT_NEUTRAL_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL)
				{
					// 36 Loviatar  
					AddChoice("Loviatar", 36, oPC);
					SetLocalString(oPC, "deity_dyn_text_36",  
						"Loviatar\n[Alias:] The Maiden of Pain\nLoviatar is the goddess of pain, hurt, and suffering. Her faith teaches that pain is a tool for discipline and control. Followers of Loviatar often endure and inflict pain as a form of devotion.\n[Status:] Lesser\n[Alignment:] LE\n[Specialty Priests:] Painbringers\n[Favored Weapons:] Whip\n\nDo you wish this deity to be your patron?");  
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_NEUTRAL_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{
					// 37 Lurue  
					AddChoice("Lurue", 37, oPC);  
					SetLocalString(oPC, "deity_dyn_text_37",  
						"Lurue\n[Alias:] The Unicorn Queen\nLurue is the goddess of intelligent beasts and rangers. Her faith teaches that all creatures deserve respect and that the wild places must be protected.\n[Status:] Intermediate\n[Alignment:] CG\n[Specialty Priests:] Horned Hunters\n[Favored Weapons:] Longbow\n\nDo you wish this deity to be your patron?");
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_EVIL ||
					nAlignment == ALIGNMENT_NEUTRAL_EVIL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{
					// 38 Malar  
					AddChoice("Malar", 38, oPC);  
					SetLocalString(oPC, "deity_dyn_text_38",  
						"Malar\n[Alias:] The Beastlord\nMalar is the god of the hunt, beasts, and savagery. His faith teaches that the hunt is the ultimate test of strength and skill. Followers of Malar often revere predatory animals and embrace their primal instincts.\n[Status:] Lesser\n[Alignment:] CE\n[Specialty Priests:] Huntsmen\n[Favored Weapons:] Spear\n\nDo you wish this deity to be your patron?"); 
				}
				if(nAlignment == ALIGNMENT_NEUTRAL_EVIL || 
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_EVIL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL)
				{
					// 39 Mask  
					AddChoice("Mask", 39, oPC);  
					SetLocalString(oPC, "deity_dyn_text_39",  
						"Mask\n[Alias:] Lord of Shadows\nMask is the god of thieves, rogues, and adventurers. His faith teaches that stealth and cunning are tools to survive and thrive in a harsh world. Followers of Mask often operate in the shadows, using their skills to outwit others.\n[Status:] Lesser\n[Alignment:] CN\n[Specialty Priests:] None\n[Favored Weapons:] Dagger\n\nDo you wish this deity to be your patron?");					
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD || 
					nAlignment == ALIGNMENT_NEUTRAL_GOOD || 
					nAlignment == ALIGNMENT_LAWFUL_GOOD )
				{
					// 40 Mielikki  
					AddChoice("Mielikki", 40, oPC);  
					SetLocalString(oPC, "deity_dyn_text_40",  
						"Mielikki\n[Alias:] Our Lady of the Forest\nMielikki is the goddess of forests, rangers, and druids. Her faith teaches that the forest is a living entity and that all creatures are part of a whole.\n[Status:] Intermediate\n[Alignment:] NG\n[Specialty Priests:] Shadoweirs\n[Favored Weapons:] Druid\n\nDo you wish this deity to be your patron?"); 
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD || 
					nAlignment == ALIGNMENT_NEUTRAL_GOOD || 
					nAlignment == ALIGNMENT_LAWFUL_GOOD )
				{
					// 41 Milil  
					AddChoice("Milil", 41, oPC);  
					SetLocalString(oPC, "deity_dyn_text_41",  
						"Milil\n[Alias:] Lord of Song\nMilil appears as a handsome human or elf with a melodic voice, revered by bards as the Guardian of Singers. He embodies creativity and inspiration, representing the complete song from idea to finish. His teachings view life as a continuing process, a song from birth until the final chord.\n[Status:] Intermediate\n[Alignment:] NG\n[Specialty Priests:] None\n[Favored Weapons:] Rapier\n\nDo you wish this deity to be your patron?");					
				}
                if(nAlignment == ALIGNMENT_CHAOTIC_EVIL ||
					nAlignment == ALIGNMENT_NEUTRAL_EVIL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{					
					// 42 Moander  
					AddChoice("Moander", 42, oPC);  
					SetLocalString(oPC, "deity_dyn_text_42",  
						"Moander\n[Alias:] The Darkbringer\nThis deity is deceased and answers no prayers to their followers anywhere in the Realms.\n[Status:] Dead\n[Alignment:] CE\n[Specialty Priests:] Rotlords\n[Favored Weapons:] Club\n\nDo you wish this deity to be your patron?");
				}
				if(nAlignment == ALIGNMENT_NEUTRAL_EVIL || 
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_EVIL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL)
				{
					// 43 Myrkul  
					AddChoice("Myrkul", 43, oPC);  
					SetLocalString(oPC, "deity_dyn_text_43",  
						"Myrkul\n[Alias:] Lord of the Dead\nThis deity is deceased and answers no prayers to their followers anywhere in the Realms. Myrkul was once the god of the dead, doom, and dread, ruling over the Fugue Plane before being slain by Mystra during the Time of Troubles. Few still venerate him, and those who do are mad cultists seeking mastery over death itself.\n[Status:] Dead\n[Alignment:] LE (formerly)\n[Specialty Priests:] None\n[Favored Weapons:] Scythe\n\nDo you wish this deity to be your patron?");				
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD || 
					nAlignment == ALIGNMENT_NEUTRAL_GOOD || 
					nAlignment == ALIGNMENT_LAWFUL_GOOD )
				{
					// 44 Mystra  
					AddChoice("Mystra", 44, oPC);  
					SetLocalString(oPC, "deity_dyn_text_44",  
						"Mystra\n[Alias:] The Mother of All Magic\nMystra is the goddess of magic and the Weave. Her faith teaches that magic is a force to be respected and used wisely. Followers of Mystra are often wizards, sorcerers, and those who study the arcane arts.\n[Status:] Greater\n[Alignment:] NG\n[Specialty Priests:] Magi\n[Favored Weapons:] Quarterstaff\n\nDo you wish this deity to be your patron?"); 					
				}
				if(nAlignment == ALIGNMENT_LAWFUL_GOOD || 
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL || 
					nAlignment == ALIGNMENT_NEUTRAL_GOOD)
				{
					// 45 Nobanion  
					AddChoice("Nobanion", 45, oPC);  
					SetLocalString(oPC, "deity_dyn_text_45",  
						"Nobanion\n[Alias:] Lord Firemane\nNobanion, the Lion God of Gulthmere, protects the woods and its natives. Drawing power from wild animals of Vilhon Reach and Dragon Coast, he teaches: hunt only when hungry, waste nothing, and lead with strength while protecting the weak.\n[StartHighlight>Status:]</Start> Demigod\n[StartHighlight>Alignment:]</Start> NG\n[StartHighlight>Specialty Priests:]</Start> None\n[StartHighlight>Favored Weapons:]</Start> Claw/Bite\n\nDo you wish this deity to be your patron?");
				}				
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{
					// 46 Oghma  
					AddChoice("Oghma", 46, oPC);  
					SetLocalString(oPC, "deity_dyn_text_46",  
						"Oghma\n[Alias:] The Binder of What is Known\nOghma is the god of knowledge, invention, and inspiration. His faith teaches that knowledge is the greatest power and that ideas can change the world.\n[Status:] Greater\n[Alignment:] N\n[Specialty Priests:] Loremasters\n[Favored Weapons:] Quarterstaff\n\nDo you wish this deity to be your patron?"); 	
				}
                if(nAlignment == ALIGNMENT_LAWFUL_GOOD ||
					nAlignment == ALIGNMENT_LAWFUL_EVIL ||
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL)
				{	
					// 47 Red Knight  
					AddChoice("Red Knight", 47, oPC);  
					SetLocalString(oPC, "deity_dyn_text_47",  
						"Red Knight\n[Alias:] The Lady of Strategy\nThe Red Knight is the goddess of strategy and tactics. Her faith teaches that victory comes from careful planning and discipline.\n[Status:] Lesser\n[Alignment:] LN\n[Specialty Priests:] Strategists\n[Favored Weapons:] Longsword\n\nDo you wish this deity to be your patron?");	
				}
                if(nAlignment == ALIGNMENT_LAWFUL_GOOD ||
					nAlignment == ALIGNMENT_LAWFUL_EVIL ||
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL)
				{	
					// 48 Savras  
					AddChoice("Savras", 48, oPC);  
					SetLocalString(oPC, "deity_dyn_text_48",  
						"Savras\n[Alias:] The All-Seeing\nSavras is the god of divination, fate, and prophecy. His faith teaches that knowledge of the future is a powerful tool, but one that must be used wisely.\n[Status:] Demipower\n[Alignment:] LN\n[Specialty Priests:] Seers\n[Favored Weapons:] Quarterstaff\n\nDo you wish this deity to be your patron?");
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_NEUTRAL_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{
					// 49 Selune  
					AddChoice("Selune", 49, oPC);  
					SetLocalString(oPC, "deity_dyn_text_49",  
						"Selune\n[Alias:] Our Lady of Silver\nGoddess of moon, stars, and navigation. Her ethos is acceptance and tolerance; all are welcome as equals. \"May Selune guide your steps in the night\" is her priests' blessing to the faithful.\n[Status:] Greater\n[Alignment:] CG\n[Specialty Priests:] None\n[Favored Weapons:] Heavy Mace\n\nDo you wish this deity to be your patron?");
				}
				if(nAlignment == ALIGNMENT_NEUTRAL_EVIL || 
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_EVIL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL)
				{
					// 50 Shar  
					AddChoice("Shar", 50, oPC);  
					SetLocalString(oPC, "deity_dyn_text_50",  
						"Shar\n[Alias:] The Night Maiden\nShar is the goddess of darkness, loss, and forgetfulness. Her faith teaches that darkness is the ultimate truth and that all things must end.\n[Status:] Greater\n[Alignment:] NE\n[Specialty Priests:] Nightbringers\n[Favored Weapons:] Dagger\n\nDo you wish this deity to be your patron?");
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{				
					// 51 Shaundakul  
					AddChoice("Shaundakul", 51, oPC);  
					SetLocalString(oPC, "deity_dyn_text_51",  
						"Shaundakul\n[Alias:] The Riding God\nShaundakul is the god of travel, exploration, and the wind. His faith teaches that the horizon is always worth chasing and that the journey is as important as the destination.\n[Status:] Intermediate\n[Alignment:] CN\n[Specialty Priests:] Windriders\n[Favored Weapons:] Scimitar\n\nDo you wish this deity to be your patron?"); 					
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_NEUTRAL_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{					
					// 52 Sharess  
					AddChoice("Sharess", 52, oPC);  
					SetLocalString(oPC, "deity_dyn_text_52",  
						"Sharess\n[Alias:] The Lady of Festivals\nSharess is the goddess of pleasure, festivals, and relaxation. Her faith teaches that life should be enjoyed and that pleasure is a divine gift. Followers of Sharess often celebrate life through festivals and indulgence.\n[Status:] Lesser\n[Alignment:] CG\n[Specialty Priests:] Festivals\n[Favored Weapons:] Dagger\n\nDo you wish this deity to be your patron?");					
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD || 
					nAlignment == ALIGNMENT_NEUTRAL_GOOD || 
					nAlignment == ALIGNMENT_LAWFUL_GOOD )
				{					
					// 53 Shiallia  
					AddChoice("Shiallia", 53, oPC);  
					SetLocalString(oPC, "deity_dyn_text_53",  
						"Shiallia\n[Alias:] Daughter of the High Forest\nShiallia is the goddess of glades, beauty, and fertility. Her faith teaches that the beauty of the natural world should be preserved and that all life is sacred.\n[Status:] Lesser\n[Alignment:] NG\n[Specialty Priests:] Lady's Handmaidens\n[Favored Weapons:] Shortbow\n\nDo you wish this deity to be your patron?");  					
				}
                if(nAlignment == ALIGNMENT_LAWFUL_GOOD ||
					nAlignment == ALIGNMENT_LAWFUL_EVIL ||
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL)
				{					
					// 54 Siamorphe  
					AddChoice("Siamorphe", 54, oPC);  
					SetLocalString(oPC, "deity_dyn_text_54",  
						"Siamorphe\n[Alias:] The Noble\nDemipower of nobility and rightful rule. Her ethos: nobles have the right and responsibility to rule justly. Worshiped mainly by Waterdeep nobles and in Tethyr. Nobles must remain fit to rule and serve their people.\n[Status:] Demigod\n[Alignment:] LN\n[Specialty Priests:] None\n[Favored Weapons:] Light Mace\n\nDo you wish this deity to be your patron?");					
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{
					// 55 Silvanus  
					AddChoice("Silvanus", 55, oPC);  
					SetLocalString(oPC, "deity_dyn_text_55",  
						"Silvanus\n[Alias:] The Old Father\nSilvanus is the god of nature, balance, and druids. His faith teaches that nature must be respected and that balance is the key to survival.\n[Status:] Greater\n[Alignment:] N\n[Specialty Priests:] Forest Masters\n[Favored Weapons:] Scimitar\n\nDo you wish this deity to be your patron?");  					
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_NEUTRAL_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{		
					// 56 Sune  
					AddChoice("Sune", 56, oPC);  
					SetLocalString(oPC, "deity_dyn_text_56",  
						"Sune\n[Alias:] Lady Firehair\nSune is the goddess of love, beauty, and passion. Her faith teaches that love and beauty are the most powerful forces in the world. Followers of Sune often seek to spread love and appreciate beauty in all its forms.\n[Status:] Greater\n[Alignment:] CG\n[Specialty Priests:] Heartwarders\n[Favored Weapons:] Dagger\n\nDo you wish this deity to be your patron?");
				}
                if(nAlignment == ALIGNMENT_CHAOTIC_EVIL ||
					nAlignment == ALIGNMENT_NEUTRAL_EVIL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{
					// 57 Talona  
					AddChoice("Talona", 57, oPC);  
					SetLocalString(oPC, "deity_dyn_text_57",  
						"Talona\n[Alias:] Lady of Poison\nTalona is the goddess of poison, disease, and death. Her faith teaches that death is the more powerful force in life's balance and should be respected. They believe that disease serves as Talona's breath, teaching humility to those who think themselves invincible through wealth or power.\n[Status:] Intermediate\n[Alignment:] CE\n[Specialty Priests:] None\n[Favored Weapons:] Dagger\n\nDo you wish this deity to be your patron?");
				}						
                if(nAlignment == ALIGNMENT_CHAOTIC_EVIL ||
					nAlignment == ALIGNMENT_NEUTRAL_EVIL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{
					// 58 Talos  
					AddChoice("Talos", 58, oPC);  
					SetLocalString(oPC, "deity_dyn_text_58",  
						"Talos\n[Alias:] The Destroyer\nTalos is the god of storms, destruction, and rebellion. His faith teaches that destruction is a creative force and that chaos brings change.\n[Status:] Greater\n[Alignment:] CE\n[Specialty Priests:] Stormlords\n[Favored Weapons:] Greatsword\n\nDo you wish this deity to be your patron?");  
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{		
					// 59 Tempus  
					AddChoice("Tempus", 59, oPC);  
					SetLocalString(oPC, "deity_dyn_text_59",  
						"Tempus\n[Alias:] Lord of Battles\nTempus is the god of war, battles, and warriors. His faith teaches that war is a natural force that should not be feared, and that all sides are treated equally in battle. They believe Tempus helps deserving warriors win battles, and that war brings both death and the opportunity for great leadership.\n[Status:] Greater\n[Alignment:] CN\n[Specialty Priests:] None\n[Favored Weapons:] Battleaxe\n\nDo you wish this deity to be your patron?");  					
				}
				if(nAlignment == ALIGNMENT_LAWFUL_GOOD || 
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL || 
					nAlignment == ALIGNMENT_NEUTRAL_GOOD)
				{
					// 60 Torm  
					AddChoice("Torm", 60, oPC);  
					SetLocalString(oPC, "deity_dyn_text_60",  
						"Torm\n[Alias:] The True\nTorm is the god of duty, loyalty, and righteousness. His faith teaches that honor and duty are the highest virtues.\n[Status:] Greater\n[Alignment:] LG\n[Specialty Priests:] Paladins\n[Favored Weapons:] Longsword\n\nDo you wish this deity to be your patron?"); 					
				}
				
				if(nAlignment == ALIGNMENT_LAWFUL_GOOD || 
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL || 
					nAlignment == ALIGNMENT_NEUTRAL_GOOD)
				{					
					// 61 Tyr  
					AddChoice("Tyr", 61, oPC);  
					SetLocalString(oPC, "deity_dyn_text_61",  
						"Tyr\n[Alias:] The Even-Handed\nTyr is the god of justice, law, and heroes. His faith teaches that justice must be blind and that the law is the foundation of civilization.\n[Status:] Greater\n[Alignment:] LG\n[Specialty Priests:] Justiciars\n[Favored Weapons:] Longsword\n\nDo you wish this deity to be your patron?"); 					
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_NEUTRAL_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{					
					// 62 Tymora  
					AddChoice("Tymora", 62, oPC);  
					SetLocalString(oPC, "deity_dyn_text_62",  
						"Tymora\n[Alias:] Lady Luck\nTymora is the goddess of good fortune, skill, and victory. Her faith teaches that fortune favors the bold and that risk is the path to reward.\n[Status:] Greater\n[Alignment:] CG\n[Specialty Priests:] Luckbringers\n[Favored Weapons:] Dagger\n\nDo you wish this deity to be your patron?"); 					
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{					
					// 63 Ulutiu  
					AddChoice("Ulutiu", 63, oPC);  
					SetLocalString(oPC, "deity_dyn_text_63",  
						"Ulutiu\n[Alias:] The Sleeping God\nUlutiu is the god of glaciers, ice, and the frozen north. His faith teaches that stillness and endurance bring wisdom, and that the frozen lands hold ancient secrets. They believe that like the glaciers, true power comes from patience and the slow accumulation of strength over time.\n[Status:] Intermediate\n[Alignment:] LN\n[Specialty Priests:] None\n[Favored Weapons:] Spear\n\nDo you wish this deity to be your patron?"); 					
				}	
                if(nAlignment == ALIGNMENT_CHAOTIC_EVIL ||
					nAlignment == ALIGNMENT_NEUTRAL_EVIL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{
					// 64 Umberlee  
					AddChoice("Umberlee", 64, oPC);  
					SetLocalString(oPC, "deity_dyn_text_64",  
						"Umberlee\n[Alias:] The Bitch Queen\nUmberlee is the goddess of the sea, storms, and sailors. Her faith teaches that the sea is a dangerous and unpredictable force that must be respected. Followers of Umberlee often make offerings to ensure safe passage.\n[Status:] Lesser\n[Alignment:] CE\n[Specialty Priests:] Sea Maidens\n[Favored Weapons:] Trident\n\nDo you wish this deity to be your patron?");  
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_NEUTRAL_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{		
					// 65 Valkur  
					AddChoice("Valkur", 65, oPC);  
					SetLocalString(oPC, "deity_dyn_text_65",  
						"Valkur\n[Alias:] The Mighty\nValkur is the god of sailors, ships, fliers, and naval combat. His faith teaches that the best way to survive a storm is to face it head-on.\n[Status:] Lesser\n[Alignment:] CG\n[Specialty Priests:] Stormriders\n[Favored Weapons:] Cutlass\n\nDo you wish this deity to be your patron?");  
				}
				if(nAlignment == ALIGNMENT_NEUTRAL_EVIL || 
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_EVIL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL)
				{
					// 66 Velsharoon  
					AddChoice("Velsharoon", 66, oPC);  
					SetLocalString(oPC, "deity_dyn_text_66",  
						"Velsharoon\n[Alias:] The Vaunted\nVelsharoon is the god of necromancy, evil liches, and undeath. His faith teaches that practitioners of necromancy are elite visionaries worthy of respect for their bold excursions to the frontiers of life and death. They believe that true power comes from mastering the arts of undeath and gathering necromantic knowledge.\n[Status:] Demigod\n[Alignment:] NE\n[Specialty Priests:] Necrophants\n[Favored Weapons:] Quarterstaff\n\nDo you wish this deity to be your patron?");					
				}
 				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{
					// 67 Waukeen  
					AddChoice("Waukeen", 67, oPC);  
					SetLocalString(oPC, "deity_dyn_text_67",  
						"Waukeen\n[Alias:] The Merchant's Friend\nWaukeen is the goddess of wealth, trade, and merchants. Her faith teaches that commerce is the lifeblood of civilization and that honest trade benefits all. They believe that wealth should be accumulated through fair exchange and that prosperity comes from embracing opportunity and taking calculated risks.\n[Status:] Greater\n[Alignment:] LN\n[Specialty Priests:] None\n[Favored Weapons:] Nunchaku\n\nDo you wish this deity to be your patron?");  
				}     
                MarkStageSetUp(nStage, oPC);      
                SetDefaultTokens();      
            }      
            else if (nStage == STAGE_CONFIRM)     
			{      
                int nDeityChoice = GetLocalInt(oPC, "deity_selected");      
                SetHeader(GetDeityText(oPC, nDeityChoice) + "\n\nIs this correct?");      
                AddChoice("Yes", 0, oPC);      
                AddChoice("No", 1, oPC);      
                MarkStageSetUp(nStage, oPC);      
                SetDefaultTokens();      
            }      
        }      
        SetupTokens();      
    }      
    else     
	{      
        int nChoice = GetChoice(oPC);      
        if (nStage == STAGE_LIST)     
		{      
            SetLocalInt(oPC, "deity_selected", nChoice);      
            nStage = STAGE_CONFIRM; // update local nStage      
        }      
        else if (nStage == STAGE_CONFIRM)     
		{      
            if (nChoice == 0) // Yes
			{     
                object oItem = EnsurePlayerDataObject(oPC);      
				int nDeityChoice = GetLocalInt(oPC, "deity_selected");
				switch (nDeityChoice)    
				{    
					case 1:  
					{  
						//sGrant = "deity_dwarven";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Dwarven_Powers);  
						SetPersistantLocalInt(oPC, "BG_Select", 1);  
						SetLocalInt(oItem,"CC3",DEITY_Dwarven_Powers);  
						SetLocalInt(oItem,"BG_Select",1);                          
						break; // Dwarven Powers                              
					}  
					case 2:  
					{  
						//sGrant = "deity_elven";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Elven_Powers);  
						SetPersistantLocalInt(oPC, "BG_Select", 2);  
						SetLocalInt(oItem,"CC3",DEITY_Elven_Powers);  
						SetLocalInt(oItem,"BG_Select",2);                          
						break; // Elven Powers                              
					}  
					case 3:  
					{  
						//sGrant = "deity_gnomish";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Gnomish_Powers);  
						SetPersistantLocalInt(oPC, "BG_Select", 3);  
						SetLocalInt(oItem,"CC3",DEITY_Gnomish_Powers);  
						SetLocalInt(oItem,"BG_Select",3);                          
						break; // Gnomish Powers                              
					}  
					case 4:  
					{  
						//sGrant = "deity_halfling";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Halfling_Powers);  
						SetPersistantLocalInt(oPC, "BG_Select", 4);  
						SetLocalInt(oItem,"CC3",DEITY_Halfling_Powers);  
						SetLocalInt(oItem,"BG_Select",4);                          
						break; // Halfling Powers                              
					}  
					case 5:  
					{  
						//sGrant = "deity_orcish";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Orcish_Powers);  
						SetPersistantLocalInt(oPC, "BG_Select", 5);  
						SetLocalInt(oItem,"CC3",DEITY_Orcish_Powers);  
						SetLocalInt(oItem,"BG_Select",5);                          
						break; // Orcish Powers                              
					}  
					case 6:  
					{  
						//sGrant = "deity_underdark";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Underdark_Powers);  
						SetPersistantLocalInt(oPC, "BG_Select", 6);  
						SetLocalInt(oItem,"CC3",DEITY_Underdark_Powers);  
						SetLocalInt(oItem,"BG_Select",6);                          
						break; // Underdark Powers                              
					}  
					case 7:  
					{  
						//sGrant = "deity_akadi";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Akadi);  
						SetPersistantLocalInt(oPC, "BG_Select", 7);  
						SetLocalInt(oItem,"CC3",DEITY_Akadi);  
						SetLocalInt(oItem,"BG_Select",7);                          
						break; // Akadi                              
					}  
					case 8:  
					{  
						//sGrant = "deity_amaunator";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Amaunator);  
						SetPersistantLocalInt(oPC, "BG_Select", 8);  
						SetLocalInt(oItem,"CC3",DEITY_Amaunator);  
						SetLocalInt(oItem,"BG_Select",8);                          
						break; // Amaunator                              
					}  
					case 9:  
					{  
						//sGrant = "deity_auril";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Auril);  
						SetPersistantLocalInt(oPC, "BG_Select", 9);  
						SetLocalInt(oItem,"CC3",DEITY_Auril);  
						SetLocalInt(oItem,"BG_Select",9);                          
						break; // Auril                              
					}  
					case 10:  
					{  
						//sGrant = "deity_azuth";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Azuth);  
						SetPersistantLocalInt(oPC, "BG_Select", 10);  
						SetLocalInt(oItem,"CC3",DEITY_Azuth);  
						SetLocalInt(oItem,"BG_Select",10);                          
						break; // Azuth                              
					}  
					case 11:  
					{  
						//sGrant = "deity_bane";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Bane);  
						SetPersistantLocalInt(oPC, "BG_Select", 11);  
						SetLocalInt(oItem,"CC3",DEITY_Bane);  
						SetLocalInt(oItem,"BG_Select",11);                          
						break; // Bane                              
					}  
					case 12:  
					{  
						//sGrant = "deity_beshaba";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Beshaba);  
						SetPersistantLocalInt(oPC, "BG_Select", 12);  
						SetLocalInt(oItem,"CC3",DEITY_Beshaba);  
						SetLocalInt(oItem,"BG_Select",12);                          
						break; // Beshaba                              
					}  
					case 13:  
					{  
						//sGrant = "deity_bhall";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Bhaal);  
						SetPersistantLocalInt(oPC, "BG_Select", 13);  
						SetLocalInt(oItem,"CC3",DEITY_Bhaal);  
						SetLocalInt(oItem,"BG_Select",13);                          
						break; // Bhall                              
					}  
					case 14:  
					{  
						//sGrant = "deity_chauntea";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Chauntea);  
						SetPersistantLocalInt(oPC, "BG_Select", 14);  
						SetLocalInt(oItem,"CC3",DEITY_Chauntea);  
						SetLocalInt(oItem,"BG_Select",14);                          
						break; // Chauntea                              
					}  
					case 15:  
					{  
						//sGrant = "deity_cyric";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Cyric);  
						SetPersistantLocalInt(oPC, "BG_Select", 15);  
						SetLocalInt(oItem,"CC3",DEITY_Cyric);  
						SetLocalInt(oItem,"BG_Select", 15);                          
						break; // Cyric                              
					}  
					case 16:  
					{  
						//sGrant = "deity_deneir";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Deneir);  
						SetPersistantLocalInt(oPC, "BG_Select", 16);  
						SetLocalInt(oItem,"CC3",DEITY_Deneir);  
						SetLocalInt(oItem,"BG_Select", 16);                          
						break; // Deneir                              
					}  
					case 17:  
					{  
						//sGrant = "deity_eldath";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Eldath);  
						SetPersistantLocalInt(oPC, "BG_Select", 17);  
						SetLocalInt(oItem,"CC3",DEITY_Eldath);  
						SetLocalInt(oItem,"BG_Select", 17);                          
						break; // Eldath                              
					}  
					case 18:  
					{  
						//sGrant = "deity_finder_wyvernspur";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Finder_Wyvernspur);  
						SetPersistantLocalInt(oPC, "BG_Select", 18);  
						SetLocalInt(oItem,"CC3",DEITY_Finder_Wyvernspur);  
						SetLocalInt(oItem,"BG_Select",18);                          
						break; // Finder Wyvernspur                              
					}  
					case 19:  
					{  
						//sGrant = "deity_garagos";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Garagos);  
						SetPersistantLocalInt(oPC, "BG_Select", 19);  
						SetLocalInt(oItem,"CC3",DEITY_Garagos);  
						SetLocalInt(oItem,"BG_Select",19);                          
						break; // Garagos                              
					}  
					case 20:  
					{  
						//sGrant = "deity_gargauth";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Gargauth);  
						SetPersistantLocalInt(oPC, "BG_Select", 20);  
						SetLocalInt(oItem,"CC3",DEITY_Gargauth);  
						SetLocalInt(oItem,"BG_Select",20);                          
						break; // Gargauth                              
					}  
					case 21:  
					{  
						//sGrant = "deity_gond";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Gond);  
						SetPersistantLocalInt(oPC, "BG_Select", 21);  
						SetLocalInt(oItem,"CC3",DEITY_Gond);  
						SetLocalInt(oItem,"BG_Select",21);                          
						break; // Gond                              
					}  
					case 22:  
					{  
						//sGrant = "deity_grumbar";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Grumbar);  
						SetPersistantLocalInt(oPC, "BG_Select", 22);  
						SetLocalInt(oItem,"CC3",DEITY_Grumbar);  
						SetLocalInt(oItem,"BG_Select",22);                          
						break; // Grumbar                              
					}  
					case 23:  
					{  
						//sGrant = "deity_gwaeron_windstrom";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Gwaeron_Windstrom);  
						SetPersistantLocalInt(oPC, "BG_Select", 23);  
						SetLocalInt(oItem,"CC3",DEITY_Gwaeron_Windstrom);  
						SetLocalInt(oItem,"BG_Select",23);                          
						break; // Gwaeron Windstrom                              
					}  
					case 24:  
					{  
						//sGrant = "deity_helm";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Helm);  
						SetPersistantLocalInt(oPC, "BG_Select", 24);  
						SetLocalInt(oItem,"CC3",DEITY_Helm);  
						SetLocalInt(oItem,"BG_Select",24);                          
						break; // Helm                              
					}  
					case 25:  
					{  
						//sGrant = "deity_hoar";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Hoar);  
						SetPersistantLocalInt(oPC, "BG_Select", 25);  
						SetLocalInt(oItem,"CC3",DEITY_Hoar);  
						SetLocalInt(oItem,"BG_Select",25);                          
						break; // Hoar                              
					}  
					case 26:  
					{  
						//sGrant = "deity_ibrandul";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Ibrandul);  
						SetPersistantLocalInt(oPC, "BG_Select", 26);  
						SetLocalInt(oItem,"CC3",DEITY_Ibrandul);  
						SetLocalInt(oItem,"BG_Select", 26);                          
						break; // Ibrandul                              
					}  
					case 27:  
					{  
						//sGrant = "deity_ilmater";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Ilmater);  
						SetPersistantLocalInt(oPC, "BG_Select", 27);  
						SetLocalInt(oItem,"CC3",DEITY_Ilmater);  
						SetLocalInt(oItem,"BG_Select", 27);                          
						break; // Ilmater                              
					}  
					case 28:  
					{  
						//sGrant = "deity_ishtishia";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Ishtisha);  
						SetPersistantLocalInt(oPC, "BG_Select", 28);  
						SetLocalInt(oItem,"CC3",DEITY_Ishtisha);  
						SetLocalInt(oItem,"BG_Select", 28);                          
						break; // Ishtishia                              
					}  
					case 29:  
					{  
						//sGrant = "deity_jergal";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Jergal);  
						SetPersistantLocalInt(oPC, "BG_Select", 29);  
						SetLocalInt(oItem,"CC3",DEITY_Jergal);  
						SetLocalInt(oItem,"BG_Select", 29);                          
						break; // Jergal                              
					}  
					case 30:  
					{  
						//sGrant = "deity_karsus";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Karsus);  
						SetPersistantLocalInt(oPC, "BG_Select", 30);  
						SetLocalInt(oItem,"CC3",DEITY_Karsus);  
						SetLocalInt(oItem,"BG_Select", 30);                          
						break; // Karsus                              
					}  
					case 31:  
					{  
						//sGrant = "deity_kelemvor";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Kelemvor);  
						SetPersistantLocalInt(oPC, "BG_Select", 31);  
						SetLocalInt(oItem,"CC3",DEITY_Kelemvor);  
						SetLocalInt(oItem,"BG_Select", 31);                          
						break; // Kelemvor                              
					}  
					case 32:  
					{  
						//sGrant = "deity_kossuth";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Kossuth);  
						SetPersistantLocalInt(oPC, "BG_Select", 32);  
						SetLocalInt(oItem,"CC3",DEITY_Kossuth);  
						SetLocalInt(oItem,"BG_Select", 32);                          
						break; // Kossuth                              
					}  
					case 33:  
					{  
						//sGrant = "deity_lathander";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Lathander);  
						SetPersistantLocalInt(oPC, "BG_Select", 33);  
						SetLocalInt(oItem,"CC3",DEITY_Lathander);  
						SetLocalInt(oItem,"BG_Select", 33);                          
						break; // Lathander                              
					}  
					case 34:  
					{  
						//sGrant = "deity_leira";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Leira);  
						SetPersistantLocalInt(oPC, "BG_Select", 34);  
						SetLocalInt(oItem,"CC3",DEITY_Leira);  
						SetLocalInt(oItem,"BG_Select", 34);                          
						break; // Leira                              
					}  
					case 35:  
					{  
						//sGrant = "deity_lliira";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Lliira);  
						SetPersistantLocalInt(oPC, "BG_Select", 35);  
						SetLocalInt(oItem,"CC3",DEITY_Lliira);  
						SetLocalInt(oItem,"BG_Select", 35);                          
						break; // Lliira                              
					}  
					case 36:  
					{  
						//sGrant = "deity_loviatar";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Loviatar);  
						SetPersistantLocalInt(oPC, "BG_Select", 36);  
						SetLocalInt(oItem,"CC3",DEITY_Loviatar);  
						SetLocalInt(oItem,"BG_Select",36);                          
						break; // Loviatar                              
					}  
					case 37:  
					{  
						//sGrant = "deity_lurue";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Lurue);  
						SetPersistantLocalInt(oPC, "BG_Select", 37);  
						SetLocalInt(oItem,"CC3",DEITY_Lurue);  
						SetLocalInt(oItem,"BG_Select", 37);                          
						break; // Lurue                              
					}  
					case 38:  
					{  
						//sGrant = "deity_malar";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Malar);  
						SetPersistantLocalInt(oPC, "BG_Select", 38);  
						SetLocalInt(oItem,"CC3",DEITY_Malar);  
						SetLocalInt(oItem,"BG_Select", 38);                          
						break; // Malar                              
					}  
					case 39:  
					{  
						//sGrant = "deity_mask";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Mask);  
						SetPersistantLocalInt(oPC, "BG_Select", 39);  
						SetLocalInt(oItem,"CC3",DEITY_Mask);  
						SetLocalInt(oItem,"BG_Select", 39);                          
						break; // Mask                              
					}  
					case 40:  
					{  
						//sGrant = "deity_mielikki";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Mielikki);  
						SetPersistantLocalInt(oPC, "BG_Select", 40);  
						SetLocalInt(oItem,"CC3",DEITY_Mielikki);  
						SetLocalInt(oItem,"BG_Select", 40);                          
						break; // Mielikki                              
					}  
					case 41:  
					{  
						//sGrant = "deity_milil";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Milil);  
						SetPersistantLocalInt(oPC, "BG_Select", 41);  
						SetLocalInt(oItem,"CC3",DEITY_Milil);  
						SetLocalInt(oItem,"BG_Select", 41);                          
						break; // Milil                              
					}  
					case 42:  
					{  
						//sGrant = "deity_moander";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Moander);  
						SetPersistantLocalInt(oPC, "BG_Select", 42);  
						SetLocalInt(oItem,"CC3",DEITY_Moander);  
						SetLocalInt(oItem,"BG_Select", 42);                          
						break; // Moander                              
					}  
					case 43:  
					{  
						//sGrant = "deity_myrkul";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Myrkul);  
						SetPersistantLocalInt(oPC, "BG_Select", 43);  
						SetLocalInt(oItem,"CC3",DEITY_Myrkul);  
						SetLocalInt(oItem,"BG_Select", 43);                          
						break; // Myrkul                              
					}  
					case 44:  
					{  
						//sGrant = "deity_mystra";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Mystra);  
						SetPersistantLocalInt(oPC, "BG_Select", 44);  
						SetLocalInt(oItem,"CC3",DEITY_Mystra);  
						SetLocalInt(oItem,"BG_Select", 44);                          
						break; // Mystra                              
					}  
					case 45:  
					{  
						//sGrant = "deity_nobanion";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Nobanion);  
						SetPersistantLocalInt(oPC, "BG_Select", 45);  
						SetLocalInt(oItem,"CC3",DEITY_Nobanion);  
						SetLocalInt(oItem,"BG_Select",45);                          
						break; // Nobanion                              
					}  
					case 46:  
					{  
						//sGrant = "deity_oghma";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Oghma);  
						SetPersistantLocalInt(oPC, "BG_Select", 46);  
						SetLocalInt(oItem,"CC3",DEITY_Oghma);  
						SetLocalInt(oItem,"BG_Select",46);                          
						break; // Oghma                              
					}  
					case 47:  
					{  
						//sGrant = "deity_red_knight";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Red_Knight);  
						SetPersistantLocalInt(oPC, "BG_Select", 47);  
						SetLocalInt(oItem,"CC3",DEITY_Red_Knight);  
						SetLocalInt(oItem,"BG_Select",47);                          
						break; // Red Knight                              
					}  
					case 48:  
					{  
						//sGrant = "deity_savras";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Savras);  
						SetPersistantLocalInt(oPC, "BG_Select", 48);  
						SetLocalInt(oItem,"CC3",DEITY_Savras);  
						SetLocalInt(oItem,"BG_Select", 48);                          
						break; // Savras                              
					}  
					case 49:  
					{  
						//sGrant = "deity_selune";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Selune);  
						SetPersistantLocalInt(oPC, "BG_Select", 49);  
						SetLocalInt(oItem,"CC3",DEITY_Selune);  
						SetLocalInt(oItem,"BG_Select", 49);                          
						break; // Selune                              
					}  
					case 50:  
					{  
						//sGrant = "deity_shar";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Shar);  
						SetPersistantLocalInt(oPC, "BG_Select", 50);  
						SetLocalInt(oItem,"CC3",DEITY_Shar);  
						SetLocalInt(oItem,"BG_Select", 50);                          
						break; // Shar                              
					}  
					case 51:  
					{  
						//sGrant = "deity_shaundakul";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Shaundakul);  
						SetPersistantLocalInt(oPC, "BG_Select", 51);  
						SetLocalInt(oItem,"CC3",DEITY_Shaundakul);  
						SetLocalInt(oItem,"BG_Select", 51);                          
						break; // Shaundakul                              
					}  
					case 52:  
					{  
						//sGrant = "deity_sharess";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Sharess);  
						SetPersistantLocalInt(oPC, "BG_Select", 52);  
						SetLocalInt(oItem,"CC3",DEITY_Sharess);  
						SetLocalInt(oItem,"BG_Select", 52);                          
						break; // Sharess                              
					}  
					case 53:  
					{  
						//sGrant = "deity_shiallia";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Shiallia);  
						SetPersistantLocalInt(oPC, "BG_Select", 53);  
						SetLocalInt(oItem,"CC3",DEITY_Shiallia);  
						SetLocalInt(oItem,"BG_Select", 53);                          
						break; // Shiallia                              
					}  
					case 54:  
					{  
						//sGrant = "deity_siamorphe";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Siamorphe);  
						SetPersistantLocalInt(oPC, "BG_Select", 54);  
						SetLocalInt(oItem,"CC3",DEITY_Siamorphe);  
						SetLocalInt(oItem,"BG_Select", 54);                          
						break; // Siamorphe                              
					}  
					case 55:  
					{  
						//sGrant = "deity_silvanus";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Silvanus);  
						SetPersistantLocalInt(oPC, "BG_Select", 55);  
						SetLocalInt(oItem,"CC3",DEITY_Silvanus);  
						SetLocalInt(oItem,"BG_Select", 55);                          
						break; // Silvanus                              
					}  
					case 56:  
					{  
						//sGrant = "deity_sune";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Sune);  
						SetPersistantLocalInt(oPC, "BG_Select", 56);  
						SetLocalInt(oItem,"CC3",DEITY_Sune);  
						SetLocalInt(oItem,"BG_Select",56);                          
						break; // Sune                              
					}  
					case 57:  
					{  
						//sGrant = "deity_talona";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Talona);  
						SetPersistantLocalInt(oPC, "BG_Select", 57);  
						SetLocalInt(oItem,"CC3",DEITY_Talona);  
						SetLocalInt(oItem,"BG_Select", 57);                          
						break; // Talona                              
					}  
					case 58:  
					{  
						//sGrant = "deity_talos";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Talos);  
						SetPersistantLocalInt(oPC, "BG_Select", 58);  
						SetLocalInt(oItem,"CC3",DEITY_Talos);  
						SetLocalInt(oItem,"BG_Select", 58);                          
						break; // Talos                              
					}  
					case 59:  
					{  
						//sGrant = "deity_tempus";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Tempus);  
						SetPersistantLocalInt(oPC, "BG_Select", 59);  
						SetLocalInt(oItem,"CC3",DEITY_Tempus);  
						SetLocalInt(oItem,"BG_Select", 59);                          
						break; // Tempus                              
					}  
					case 60:  
					{  
						//sGrant = "deity_torm";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Torm);  
						SetPersistantLocalInt(oPC, "BG_Select", 60);  
						SetLocalInt(oItem,"CC3",DEITY_Torm);  
						SetLocalInt(oItem,"BG_Select", 60);                          
						break; // Torm                              
					}  
					case 61:  
					{  
						//sGrant = "deity_tyr";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Tyr);  
						SetPersistantLocalInt(oPC, "BG_Select", 61);  
						SetLocalInt(oItem,"CC3",DEITY_Tyr);  
						SetLocalInt(oItem,"BG_Select", 61);                          
						break; // Tyr                              
					}  
					case 62:  
					{  
						//sGrant = "deity_tymora";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Tymora);  
						SetPersistantLocalInt(oPC, "BG_Select", 62);  
						SetLocalInt(oItem,"CC3",DEITY_Tymora);  
						SetLocalInt(oItem,"BG_Select", 62);                          
						break; // Tymora                              
					}  
					case 63:  
					{  
						//sGrant = "deity_ulutiu";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Ulutiu);  
						SetPersistantLocalInt(oPC, "BG_Select", 63);  
						SetLocalInt(oItem,"CC3",DEITY_Ulutiu);  
						SetLocalInt(oItem,"BG_Select", 63);                          
						break; // Ulutiu                              
					}  
					case 64:  
					{  
						//sGrant = "deity_umberlee";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Umberlee);  
						SetPersistantLocalInt(oPC, "BG_Select", 64);  
						SetLocalInt(oItem,"CC3",DEITY_Umberlee);  
						SetLocalInt(oItem,"BG_Select", 64);                          
						break; // Umberlee                              
					}  
					case 65:  
					{  
						//sGrant = "deity_valkur";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Valkur);  
						SetPersistantLocalInt(oPC, "BG_Select", 65);  
						SetLocalInt(oItem,"CC3",DEITY_Valkur);  
						SetLocalInt(oItem,"BG_Select", 65);                          
						break; // Valkur                              
					}  
					case 66:  
					{  
						//sGrant = "deity_velsharoon";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Velsharoon);  
						SetPersistantLocalInt(oPC, "BG_Select", 66);  
						SetLocalInt(oItem,"CC3",DEITY_Velsharoon);  
						SetLocalInt(oItem,"BG_Select", 66);                          
						break; // Velsharoon                              
					}  
					case 67:  
					{  
						//sGrant = "deity_waukeen";  
						SetPersistantLocalInt(oPC, "CC3", DEITY_Waukeen);  
						SetPersistantLocalInt(oPC, "BG_Select", 67);  
						SetLocalInt(oItem,"CC3",DEITY_Waukeen);  
						SetLocalInt(oItem,"BG_Select", 67);                          
						break; // Waukeen                              
					}    
				}
				AllowExit(DYNCONV_EXIT_FORCE_EXIT, TRUE, oPC);    
				SetPersistantLocalInt(oPC, "CC3_DONE", 1);    
				DelayCommand(0.1f, StartDynamicConversation("bg_language_cv", oPC));				    
            }      
            else     
			{ // No      
                MarkStageNotSetUp(STAGE_LIST, oPC);    
                MarkStageNotSetUp(STAGE_CONFIRM, oPC);
                nStage = STAGE_LIST; // update local nStage      
            }      
        }      
        SetStage(nStage, oPC);      
    }      
}
 
  
/* void main()   
{
    object oPC 		= GetPCSpeaker();  
	object oItem 	= EnsurePlayerDataObject(oPC);
	
	int nAlignment	= GetCreaturesAlignment(oPC);
	int nRacialType	= GetRacialType(oPC);
	int nValue 		= GetLocalInt(oPC, DYNCONV_VARIABLE);  
    int nStage 		= GetStage(oPC); 
  
    if(nValue == DYNCONV_SETUP_STAGE)  
    {  
        if(!GetIsStageSetUp(nStage, oPC))  
        {  
            if (nStage == STAGE_LIST) 
			{  
                SetHeader("Select your patron deity.  You can refresh the list with the Escape key if needed.");
				
				if (nRacialType == RACIAL_TYPE_DWARF)
				{
					// 1 The Dwarven Powers  
					AddChoice("The Dwarven Powers", 1, oPC);  
					SetLocalString(oPC, "deity_dyn_text_1",  
						"The Elven Powers\n[Alias:] These deities did not sponsor specialty priests following the Time of Troubles. Their clerics were normal and had to conform to the alignment requirements for their deities, or they even simply venerated the entire pantheons worshiped by their respective race.\nThe Dwarven deities were worshiped by the Dwarves of Faerun. As these powers have not revealed specialty priests to the Realms, they function as typical clerics..\n[Status:] Pantheon\n[Alignment:] \n[Specialty Priests:] None\n[Favored Weapons:] Varies\n\nDo you wish this pantheon to be your patron?");
				}                
				if (nRacialType == RACIAL_TYPE_ELF)
				{
					// 2 The Elven Powers  
					AddChoice("The Elven Powers", 2, oPC);  
					SetLocalString(oPC, "deity_dyn_text_2",  
						"The Elven Powers\n[Alias:] These deities did not sponsor specialty priests following the Time of Troubles. Their clerics were normal and had to conform to the alignment requirements for their deities, or they even simply venerated the entire pantheons worshiped by their respective race.\nThe Seldarine were worshiped by the Elves of Faerun. As these powers have not revealed specialty priests to the Realms, they function as typical clerics.\n[Status:] Pantheon\n[Alignment:] \n[Specialty Priests:] None\n[Favored Weapons:] Varies\n\nDo you wish this pantheon to be your patron?");
				}
				if (nRacialType == RACIAL_TYPE_GNOME)
				{					
					// 3 The Gnomish Powers  
					AddChoice("The Gnomish Powers", 3, oPC);  
					SetLocalString(oPC, "deity_dyn_text_3",  
						"The Gnomish Powers\n[Alias:] These deities did not sponsor specialty priests following the Time of Troubles. Their clerics were normal and had to conform to the alignment requirements for their deities, or they even simply venerated the entire pantheons worshiped by their respective race.\nThe Gnomish deities were worshiped by the Gnomes of Faerun. As these powers have not revealed specialty priests to the Realms, they function as typical clerics.\n[Status:] Pantheon\n[Alignment:] \n[Specialty Priests:] None\n[Favored Weapons:] Varies\n\nDo you wish this pantheon to be your patron?");
				}
				if (nRacialType == RACIAL_TYPE_HALFLING)
				{					
					// 4 The Halfling Powers  
					AddChoice("The Halfling Powers", 4, oPC);  
					SetLocalString(oPC, "deity_dyn_text_4",  
						"The Halfling Powers\n[Alias:] These deities did not sponsor specialty priests following the Time of Troubles. Their clerics were normal and had to conform to the alignment requirements for their deities, or they even simply venerated the entire pantheons worshiped by their respective race.\nThe Halfling deities were worshiped by the Halflings of Faerun. As these powers have not revealed specialty priests to the Realms, they function as typical clerics.\n[Status:] Pantheon\n[Alignment:] \n[Specialty Priests:] None\n[Favored Weapons:] Varies\n\nDo you wish this pantheon to be your patron?");
				}                
				if (nRacialType == RACIAL_TYPE_HUMANOID_ORC || nRacialType == RACIAL_TYPE_HALFORC)
				{
					// 5 The Orcish Powers  
					AddChoice("The Orcish Powers", 5, oPC);  
					SetLocalString(oPC, "deity_dyn_text_5",  
						"The Orcish Powers\n[Alias:] These deities did not sponsor specialty priests following the Time of Troubles. Their clerics were normal and had to conform to the alignment requirements for their deities, or they even simply venerated the entire pantheons worshiped by their respective race.\nThe Orcish deities were worshiped by the Orcs of Faerun. As these powers have not revealed specialty priests to the Realms, they function as typical clerics.\n[Status:] Pantheon\n[Alignment:] \n[Specialty Priests:] None\n[Favored Weapons:] Varies\n\nDo you wish this pantheon to be your patron?");
				}					
				if(_CanBeUnderdarkExile(oPC))
				{
					// 6 The Underdark Powers	
					AddChoice("The Underdark Powers", 6, oPC);  
					SetLocalString(oPC, "deity_dyn_text_6",  
						"The Underdark Powers\n[Alias:] These deities did not sponsor specialty priests following the Time of Troubles. Their clerics were normal and had to conform to the alignment requirements for their deities, or they even simply venerated the entire pantheons worshiped by their respective race.\nThe Underdark deities were worshiped by the Drow of Faerun. As these powers have not revealed specialty priests to the Realms, they function as typical clerics.\n[Status:] Pantheon\n[Alignment:] \n[Specialty Priests:] None\n[Favored Weapons:] Varies\n\nDo you wish this pantheon to be your patron?");
				}					
                if(nAlignment == ALIGNMENT_CHAOTIC_GOOD || 
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL || 
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL)
				{
					// 7 Akadi  
					AddChoice("Akadi", 7, oPC);  
					SetLocalString(oPC, "deity_dyn_text_7",  
						"Akadi\n[Alias:] Akadi is the whispering wind and the blinding gale storm, her form changing from season to season. The teachings of the Akadian church amount to a doctrine of find one's own enlightenment.\n[Status:] Lesser\n[Alignment:] CN\n[Specialty Priests:] none \n[Favored Weapons:] Javelin\n\nDo you wish this deity to be your patron?");
				}
                if(nAlignment == ALIGNMENT_LAWFUL_GOOD ||
					nAlignment == ALIGNMENT_LAWFUL_EVIL ||
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL)
				{						
					// 8 Amaunator  
					AddChoice("Amaunator", 8, oPC);  
					SetLocalString(oPC, "deity_dyn_text_8",  
						"Amaunator\n[Alias:] This deity is deceased and answers no prayers to their followers anywhere in the Realms..\n[Status:] Dead\n[Alignment:] LN\n[Specialty Priests:] none \n[Favored Weapons:] n/a\n\nDo you wish this deity to be your patron?");
				}
				if(nAlignment == ALIGNMENT_NEUTRAL_EVIL || 
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_EVIL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL)
				{
					// 9 Auril  
					AddChoice("Auril", 9, oPC);  
					SetLocalString(oPC, "deity_dyn_text_9",  
						"Auril\n[Alias:] The Frostmaiden\nAuril is the goddess of cold, winter, and frost. Her faith teaches that the cold is a purifying force and that winter is a time of survival and strength.\n[Status:] Lesser\n[Alignment:] NE\n[Specialty Priests:] Frostmaidens\n[Favored Weapons:] Mace\n\nDo you wish this deity to be your patron?"); 
				}
                if(nAlignment == ALIGNMENT_LAWFUL_GOOD ||
					nAlignment == ALIGNMENT_LAWFUL_EVIL ||
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL)
				{				
					// 10 Azuth  
					AddChoice("Azuth", 10, oPC);  
					SetLocalString(oPC, "deity_dyn_text_10",  
						"Azuth\n[Alias:] The High One\nAzuth is the god of wizards and magic. His faith teaches that magic should be studied and used with discipline and reason.\n[Status:] Lesser\n[Alignment:] LN\n[Specialty Priests:] Magistrati\n[Favored Weapons:] Quarterstaff\n\nDo you wish this deity to be your patron?");					
				}
                if(nAlignment == ALIGNMENT_NEUTRAL_EVIL ||
					nAlignment == ALIGNMENT_LAWFUL_EVIL ||
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL)
				{				
					// 11 Bane  
					AddChoice("Bane", 11, oPC);  
					SetLocalString(oPC, "deity_dyn_text_11",  
						"Bane\n[Alias:] The Black Hand\nBane is the god of tyranny, hatred, and fear. His faith teaches that strength and domination are the paths to power. Followers of Bane often seek to conquer and control others.\n[Status:] Greater\n[Alignment:] LE\n[Specialty Priests:] Banesons\n[Favored Weapons:] Gauntlet\n\nDo you wish this deity to be your patron?");   
				}
                if(nAlignment == ALIGNMENT_CHAOTIC_EVIL ||
					nAlignment == ALIGNMENT_NEUTRAL_EVIL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{				
					// 12 Beshaba  
					AddChoice("Beshaba", 12, oPC);  
					SetLocalString(oPC, "deity_dyn_text_12",  
						"Beshaba\n[Alias:] Maid of Misfortune\nBeshaba is the goddess of accidents, bad luck, and misfortune. Her faith teaches that luck is fickle and that disaster can strike at any time.\n[Status:] Lesser\n[Alignment:] CE\n[Specialty Priests:] Doommaidens\n[Favored Weapons:] Heavy Mace\n\nDo you wish this deity to be your patron?"); 
				}	
				if(nAlignment == ALIGNMENT_NEUTRAL_EVIL || 
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_EVIL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL)
				{
					// 13 Bhall  
					AddChoice("Bhall", 13, oPC);  
					SetLocalString(oPC, "deity_dyn_text_13",  
						"Bhall\n[Alias:] n/a \nThis deity is deceased and answers no prayers to their followers anywhere in the Realms.\n[Status:] Dead\n[Alignment:] NE\n[Specialty Priests:] n/a \n[Favored Weapons:] n/a \n\nDo you wish this deity to be your patron?");
				}
                if(nAlignment == ALIGNMENT_CHAOTIC_GOOD || 
					nAlignment == ALIGNMENT_NEUTRAL_GOOD || 
					nAlignment == ALIGNMENT_LAWFUL_GOOD )
				{
					// 14 Chauntea  
					AddChoice("Chauntea", 14, oPC);  
					SetLocalString(oPC, "deity_dyn_text_14",  
						"Chauntea\n[Alias:] The Great Mother\nChauntea is the goddess of agriculture, life, and the earth. Her faith teaches that the land provides all things and must be nurtured.\n[Status:] Greater\n[Alignment:] NG\n[Specialty Priests:] Druids\n[Favored Weapons:] Scythe\n\nDo you wish this deity to be your patron?");
				}
                if(nAlignment == ALIGNMENT_CHAOTIC_EVIL ||
					nAlignment == ALIGNMENT_NEUTRAL_EVIL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{				
					// 15 Cyric  
					AddChoice("Cyric", 15, oPC);  
					SetLocalString(oPC, "deity_dyn_text_15",  
						"Cyric\n[Alias:] The Prince of Lies\nCyric is the god of lies, intrigue, and illusion. His faith teaches that deception and manipulation are the keys to power. Followers of Cyric often engage in deceit and intrigue to achieve their goals.\n[Status:] Greater\n[Alignment:] CE\n[Specialty Priests:] Cyricists\n[Favored Weapons:] Dagger\n\nDo you wish this deity to be your patron?"); 					
				}
                if(nAlignment == ALIGNMENT_CHAOTIC_GOOD || 
					nAlignment == ALIGNMENT_NEUTRAL_GOOD || 
					nAlignment == ALIGNMENT_LAWFUL_GOOD )
				{
					// 16 Deneir  
					AddChoice("Deneir", 16, oPC);  
					SetLocalString(oPC, "deity_dyn_text_16",  
						"Deneir\n[Alias:] Lord of All Glyphs and Images\nDeneir is the god of literature, art, and cartography. His faith teaches that knowledge must be recorded and preserved for future generations.\n[Status:] Lesser\n[Alignment:] NG\n[Specialty Priests:] Glyphscribes\n[Favored Weapons:] Dagger\n\nDo you wish this deity to be your patron?");
				}	
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD || 
					nAlignment == ALIGNMENT_NEUTRAL_GOOD || 
					nAlignment == ALIGNMENT_LAWFUL_GOOD )
				{
					// 17 Eldath  
					AddChoice("Eldath", 17, oPC);  
					SetLocalString(oPC, "deity_dyn_text_17",  
						"Eldath\n[Alias:] Goddess of the Singing Waters\nEldath is the goddess of peace, pools, and springs. Her faith teaches that peace is the highest virtue and that violence is a last resort.\n[Status:] Lesser\n[Alignment:] NG\n[Specialty Priests:] Druids\n[Favored Weapons:] Druid\n\nDo you wish this deity to be your patron?"); 					
				}	
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD || 
					nAlignment == ALIGNMENT_NEUTRAL_GOOD || 
					nAlignment == ALIGNMENT_LAWFUL_GOOD )
				{
					// 18 Finder Wyvernspur  
					AddChoice("Finder Wyvernspur", 18, oPC);  
					SetLocalString(oPC, "deity_dyn_text_18",  
						"Finder Wyvernspur\n[Alias:] The Nameless Bard\Finder Wyvernspur is fairly new god of Cycles of Life, Saurials and Transformation of Art. Finder's Church was very small, consisting primarily of younger bards, musicians, and those who sought to change and diversify the arts. \n[Status:] Lesser\n[Alignment:] NG\n[Specialty Priests:] Finders\n[Favored Weapons:] Bastard Sword\n\nDo you wish this deity to be your patron?");
				}
                if(nAlignment == ALIGNMENT_CHAOTIC_EVIL ||
					nAlignment == ALIGNMENT_NEUTRAL_EVIL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{
					// 19 Garagos  
					AddChoice("Garagos", 19, oPC);  
					SetLocalString(oPC, "deity_dyn_text_19",  
						"Garagos\n[Alias:] The Reaver\nGaragos is the god of war, destruction, and plunder. His faith teaches that strength is the only virtue and that conflict is the natural state of the world.\n[Status:] Demipower\n[Alignment:] CE\n[Specialty Priests:] Reavers\n[Favored Weapons:] Battleaxe\n\nDo you wish this deity to be your patron?");
				}
				if(nAlignment == ALIGNMENT_NEUTRAL_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL)
				{
					// 20 Gargauth  
					AddChoice("Gargauth", 20, oPC);  
					SetLocalString(oPC, "deity_dyn_text_20",  
						"Gargauth\n[Alias:] The Outcast\nGargauth is the god of betrayal, cruelty, and political corruption. His faith teaches that power is best gained through deceit and manipulation. Followers of Gargauth often engage in treachery and intrigue.\n[Status:] Demigod\n[Alignment:] LE\n[Specialty Priests:] Malefactors\n[Favored Weapons:] Dagger\n\nDo you wish this deity to be your patron?");
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{
					// 21 Gond  
					AddChoice("Gond", 21, oPC);  
					SetLocalString(oPC, "deity_dyn_text_21",  
						"Gond\n[Alias:] Wonderbringer\nGond is the god of invention, craft, and technology. His faith teaches that innovation and creation are sacred acts.\n[Status:] Lesser\n[Alignment:] N\n[Specialty Priests:] Artificers\n[Favored Weapons:] Warhammer\n\nDo you wish this deity to be your patron?"); 					
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{
					// 22 Grumbar  
					AddChoice("Grumbar", 22, oPC);  
					SetLocalString(oPC, "deity_dyn_text_22",  
						"Grumbar\n[Alias:] Earthlord\nGrumbar is the god of the earth itself.  His faith teaches that change should be resisted above all.\n[Status:] Greater\n[Alignment:] N\n[Specialty Priests:] Druids\n[Favored Weapons:] Club\n\nDo you wish this deity to be your patron?"); 
				}
                if(nAlignment == ALIGNMENT_CHAOTIC_GOOD || 
					nAlignment == ALIGNMENT_NEUTRAL_GOOD || 
					nAlignment == ALIGNMENT_LAWFUL_GOOD )
				{
					// 23  Gwaeron Windstrom  
					AddChoice("Gwaeron Windstrom", 23, oPC);  
					SetLocalString(oPC, "deity_dyn_text_23",  
						" Gwaeron Windstrom\n[Alias:] Master of Tracking\nGwaeron Windstrom is the demigod of the tracking and woodland signs. His faith teaches that nature and mankindd can live in harmony.\n[Status:] Greater\n[Alignment:] NG\n[Specialty Priests:] Druids\n[Favored Weapons:] Greatsword\n\nDo you wish this deity to be your patron?"); 					
				}				
                if(nAlignment == ALIGNMENT_LAWFUL_GOOD ||
					nAlignment == ALIGNMENT_LAWFUL_EVIL ||
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL)
				{
					// 24 Helm  
					AddChoice("Helm", 24, oPC);  
					SetLocalString(oPC, "deity_dyn_text_24",  
						"Helm\n[Alias:] The Vigilant One\nHelm is the god of guardians, protectors, and watchmen. His faith teaches vigilance and duty.\n[Status:] Greater\n[Alignment:] LN\n[Specialty Priests:] Watchers\n[Favored Weapons:] Longsword\n\nDo you wish this deity to be your patron?");
				}
                if(nAlignment == ALIGNMENT_LAWFUL_GOOD ||
					nAlignment == ALIGNMENT_LAWFUL_EVIL ||
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL)
				{
					// 25 Hoar  
					AddChoice("Hoar", 25, oPC);  
					SetLocalString(oPC, "deity_dyn_text_25",  
						"Hoar\n[Alias:] The Doombringer\nHoar is the god of revenge and poetic justice. His faith teaches that wrongs must be avenged and that justice will eventually be served. Followers of Hoar often seek to balance the scales through vengeance.\n[Status:] Demigod\n[Alignment:] LN\n[Specialty Priests:] Doombringers\n[Favored Weapons:] Spear\n\nDo you wish this deity to be your patron?");  					
				}

				if(nAlignment == ALIGNMENT_NEUTRAL_EVIL || 
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_EVIL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL)
				{
					// 26 Ibrandul  
					AddChoice("Ibrandul", 26, oPC);  
					SetLocalString(oPC, "deity_dyn_text_26",  
						"Ibrandul\n[Alias:] Lord of the Dry Depths\nIbrandul is the god of caves, darkness, and the Underdark. His faith teaches that the darkness holds secrets and that the depths are to be respected.\n[Status:] Demipower\n[Alignment:] NE\n[Specialty Priests:] Darkwalkers\n[Favored Weapons:] Club/Greatclub\n\nDo you wish this deity to be your patron?");
				}
				if(nAlignment == ALIGNMENT_LAWFUL_GOOD || 
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL || 
					nAlignment == ALIGNMENT_NEUTRAL_GOOD)
				{
					// 27 Ilmater  
					AddChoice("Ilmater", 27, oPC);  
					SetLocalString(oPC, "deity_dyn_text_27",  
						"Ilmater\n[Alias:] The Crying God\nIlmater is the god of endurance, martyrdom, perseverance & suffering. His faithful practices and encourages others to help the suffering by taking their burdens or places. Ilmater was a willing sufferer, bearing the pain of others to spare them from it.\n[Status:] Lesser\n[Alignment:] LG\n[Specialty Priests:] n/a \n[Favored Weapons:] Unarmed\n\nDo you wish this deity to be your patron?");
				}
 				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{
					// 28 Ishtishia  
					AddChoice("Ishtishia", 28, oPC);  
					SetLocalString(oPC, "deity_dyn_text_28",  
						"Ishtishia\n[Alias:] The Water Lord\nIshtishia is the primordial of elemental water. His faith was dispassionate, alien and not a worship of any specific body or state of water, but the water itself.\n[Status:] Lesser\n[Alignment:] LG\n[Specialty Priests:] n/a \n[Favored Weapons:] Warhammer\n\nDo you wish this deity to be your patron?");
				}
                if(nAlignment == ALIGNMENT_LAWFUL_GOOD ||
					nAlignment == ALIGNMENT_LAWFUL_EVIL ||
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL)
				{
					// 29 Jergal  
					AddChoice("Jergal", 29, oPC);  
					SetLocalString(oPC, "deity_dyn_text_29",  
						"Jergal\n[Alias:] The Scribe of Oaths\nThis deity is deceased and answers no prayers to their followers anywhere in the Realms.\n[Status:] Dead\n[Alignment:] LN\n[Specialty Priests:] Scribes\n[Favored Weapons:] Quarterstaff\n\nDo you wish this deity to be your patron?");
				}
				if(nAlignment == ALIGNMENT_NEUTRAL_EVIL || 
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_EVIL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL)
				{
					// 30 Karsus  
					AddChoice("Karsus", 30, oPC);  
					SetLocalString(oPC, "deity_dyn_text_30",  
						"Karsus\n[Alias:] The Karsus\nKarsus was once the greatest archwizard of Netheril who sought godhood by casting the legendary Karsus's Avatar. His ascension tore the Weave, causing the fall of the Netherese Empire and the descent of the goddess Mystryl. Now a dead power trapped in the Fugue Plane, Karsus exists as a cautionary tale of mortal hubris. He cannot grant spells or answer prayers, for his connection to the divine was severed by his own folly. Few still worship him, and those who do are mad scholars seeking the secrets of his lost magic.\n[Status:] Dead Power\n[Alignment:] N (formerly)\n[Specialty Priests:] None (cannot grant spells)\n[Favored Weapons:] Quarterstaff\n\nDo you wish this deity to be your patron?");					
				}
                if(nAlignment == ALIGNMENT_LAWFUL_GOOD ||
					nAlignment == ALIGNMENT_LAWFUL_EVIL ||
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL)
				{					
					// 31 Kelemvor  
					AddChoice("Kelemvor", 31, oPC);  
					SetLocalString(oPC, "deity_dyn_text_31",  
						"Kelemvor\n[Alias:] The Judge of the Dead\nKelemvor (pronounced KELL-em-vor) is the god of the dead and judge of the damned. He once was mortal, a paladin who served a god of the dead before ascending to divinity himself. Kelemvor?s faith teaches that the dead should be honored and that death is a natural part of life. He is a stern but fair deity who despises the undead and those who would unnaturally extend their lives.\n[Status:] Greater\n[Alignment:] LN\n[Specialty Priests:] Doomguides\n[Favored Weapons:] Heavy Mace\n\nDo you wish this deity to be your patron?"); 
				}						
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{
					// 32 Kossuth  
					AddChoice("Kossuth", 32, oPC);  
					SetLocalString(oPC, "deity_dyn_text_32",  
						"Kossuth\n[Alias:] The Firelord\nKossuth is the god of fire, elemental balance, and purification. He embodies both the creative and destructive aspects of flame, teaching that fire is the ultimate force of transformation and renewal. His followers believe that through fire, all things are purified and reborn. Kossuth's faith is popular among smiths, alchemists, and those who seek to burn away impurities in the world. The church of Kossuth maintains the eternal flames in major cities and oversees the sacred duty of fire-watching.\n[Status:] Greater\n[Alignment:] LN\n[Specialty Priests:] Firelords\n[Favored Weapons:] Heavy Mace\n\nDo you wish this deity to be your patron?");
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD || 
					nAlignment == ALIGNMENT_NEUTRAL_GOOD || 
					nAlignment == ALIGNMENT_LAWFUL_GOOD )
				{
					// 33 Lathander  
					AddChoice("Lathander", 33, oPC);  
					SetLocalString(oPC, "deity_dyn_text_33",  
						"Lathander\n[Alias:] The Morninglord\nLathander is the god of dawn, renewal, and birth. His faith teaches that each day is a new beginning and that hope is eternal.\n[Status:] Greater\n[Alignment:] NG\n[Specialty Priests:] Morninglords\n[Favored Weapons:] Morningstar\n\nDo you wish this deity to be your patron?"); 
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{
					// 34 Leira  
					AddChoice("Leira", 34, oPC);  
					SetLocalString(oPC, "deity_dyn_text_34",  
						"Leira\n[Alias:] The Lady of the Mists\nLeira is the goddess of illusion, deception, and trickery. Her faith teaches that truth is subjective and that illusion can be a shield or a weapon.\n[Status:] Intermediate\n[Alignment:] CN\n[Specialty Priests:] Tricksters\n[Favored Weapons:] Dagger\n\nDo you wish this deity to be your patron?");  
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_NEUTRAL_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{
					// 35 Lliira  
					AddChoice("Lliira", 35, oPC);  
					SetLocalString(oPC, "deity_dyn_text_35",  
						"Lliira\n[Alias:] Our Lady of Joy\nLliira is the goddess of joy, happiness, and dance. Her faith teaches that life should be celebrated and that sorrow is a poison to be avoided.\n[Status:] Lesser\n[Alignment:] CG\n[Specialty Priests:] Joydancers\n[Favored Weapons:] Dagger\n\nDo you wish this deity to be your patron?");  
				}
 				if(nAlignment == ALIGNMENT_NEUTRAL_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL)
				{
					// 36 Loviatar  
					AddChoice("Loviatar", 36, oPC);
					SetLocalString(oPC, "deity_dyn_text_36",  
						"Loviatar\n[Alias:] The Maiden of Pain\nLoviatar is the goddess of pain, hurt, and suffering. Her faith teaches that pain is a tool for discipline and control. Followers of Loviatar often endure and inflict pain as a form of devotion.\n[Status:] Lesser\n[Alignment:] LE\n[Specialty Priests:] Painbringers\n[Favored Weapons:] Whip\n\nDo you wish this deity to be your patron?");  
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_NEUTRAL_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{
					// 37 Lurue  
					AddChoice("Lurue", 37, oPC);  
					SetLocalString(oPC, "deity_dyn_text_37",  
						"Lurue\n[Alias:] The Unicorn Queen\nLurue is the goddess of intelligent beasts and rangers. Her faith teaches that all creatures deserve respect and that the wild places must be protected.\n[Status:] Intermediate\n[Alignment:] CG\n[Specialty Priests:] Horned Hunters\n[Favored Weapons:] Longbow\n\nDo you wish this deity to be your patron?");
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_EVIL ||
					nAlignment == ALIGNMENT_NEUTRAL_EVIL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{
					// 38 Malar  
					AddChoice("Malar", 38, oPC);  
					SetLocalString(oPC, "deity_dyn_text_38",  
						"Malar\n[Alias:] The Beastlord\nMalar is the god of the hunt, beasts, and savagery. His faith teaches that the hunt is the ultimate test of strength and skill. Followers of Malar often revere predatory animals and embrace their primal instincts.\n[Status:] Lesser\n[Alignment:] CE\n[Specialty Priests:] Huntsmen\n[Favored Weapons:] Spear\n\nDo you wish this deity to be your patron?"); 
				}
				if(nAlignment == ALIGNMENT_NEUTRAL_EVIL || 
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_EVIL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL)
				{
					// 39 Mask  
					AddChoice("Mask", 39, oPC);  
					SetLocalString(oPC, "deity_dyn_text_39",  
						"Mask\n[Alias:] Lord of Shadows\nMask is the god of thieves, rogues, and adventurers. His faith teaches that stealth and cunning are tools to survive and thrive in a harsh world. Followers of Mask often operate in the shadows, using their skills to outwit others.\n[Status:] Lesser\n[Alignment:] CN\n[Specialty Priests:] None\n[Favored Weapons:] Dagger\n\nDo you wish this deity to be your patron?");					
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD || 
					nAlignment == ALIGNMENT_NEUTRAL_GOOD || 
					nAlignment == ALIGNMENT_LAWFUL_GOOD )
				{
					// 40 Mielikki  
					AddChoice("Mielikki", 40, oPC);  
					SetLocalString(oPC, "deity_dyn_text_40",  
						"Mielikki\n[Alias:] Our Lady of the Forest\nMielikki is the goddess of forests, rangers, and druids. Her faith teaches that the forest is a living entity and that all creatures are part of a whole.\n[Status:] Intermediate\n[Alignment:] NG\n[Specialty Priests:] Shadoweirs\n[Favored Weapons:] Druid\n\nDo you wish this deity to be your patron?"); 
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD || 
					nAlignment == ALIGNMENT_NEUTRAL_GOOD || 
					nAlignment == ALIGNMENT_LAWFUL_GOOD )
				{
					// 41 Milil  
					AddChoice("Milil", 41, oPC);  
					SetLocalString(oPC, "deity_dyn_text_41",  
						"Milil\n[Alias:] Lord of Song\nMilil appears as a handsome human or elf with a melodic voice, revered by bards as the Guardian of Singers. He embodies creativity and inspiration, representing the complete song from idea to finish. His teachings view life as a continuing process, a song from birth until the final chord.\n[Status:] Intermediate\n[Alignment:] NG\n[Specialty Priests:] None\n[Favored Weapons:] Rapier\n\nDo you wish this deity to be your patron?");					
				}
                if(nAlignment == ALIGNMENT_CHAOTIC_EVIL ||
					nAlignment == ALIGNMENT_NEUTRAL_EVIL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{					
					// 42 Moander  
					AddChoice("Moander", 42, oPC);  
					SetLocalString(oPC, "deity_dyn_text_42",  
						"Moander\n[Alias:] The Darkbringer\nThis deity is deceased and answers no prayers to their followers anywhere in the Realms.\n[Status:] Dead\n[Alignment:] CE\n[Specialty Priests:] Rotlords\n[Favored Weapons:] Club\n\nDo you wish this deity to be your patron?");
				}
				if(nAlignment == ALIGNMENT_NEUTRAL_EVIL || 
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_EVIL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL)
				{
					// 43 Myrkul  
					AddChoice("Myrkul", 43, oPC);  
					SetLocalString(oPC, "deity_dyn_text_43",  
						"Myrkul\n[Alias:] Lord of the Dead\nThis deity is deceased and answers no prayers to their followers anywhere in the Realms. Myrkul was once the god of the dead, doom, and dread, ruling over the Fugue Plane before being slain by Mystra during the Time of Troubles. Few still venerate him, and those who do are mad cultists seeking mastery over death itself.\n[Status:] Dead\n[Alignment:] LE (formerly)\n[Specialty Priests:] None\n[Favored Weapons:] Scythe\n\nDo you wish this deity to be your patron?");				
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD || 
					nAlignment == ALIGNMENT_NEUTRAL_GOOD || 
					nAlignment == ALIGNMENT_LAWFUL_GOOD )
				{
					// 44 Mystra  
					AddChoice("Mystra", 44, oPC);  
					SetLocalString(oPC, "deity_dyn_text_44",  
						"Mystra\n[Alias:] The Mother of All Magic\nMystra is the goddess of magic and the Weave. Her faith teaches that magic is a force to be respected and used wisely. Followers of Mystra are often wizards, sorcerers, and those who study the arcane arts.\n[Status:] Greater\n[Alignment:] NG\n[Specialty Priests:] Magi\n[Favored Weapons:] Quarterstaff\n\nDo you wish this deity to be your patron?"); 					
				}
				if(nAlignment == ALIGNMENT_LAWFUL_GOOD || 
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL || 
					nAlignment == ALIGNMENT_NEUTRAL_GOOD)
				{
					// 45 Nobanion  
					AddChoice("Nobanion", 45, oPC);  
					SetLocalString(oPC, "deity_dyn_text_45",  
						"Nobanion\n[Alias:] Lord Firemane\nNobanion, the Lion God of Gulthmere, protects the woods and its natives. Drawing power from wild animals of Vilhon Reach and Dragon Coast, he teaches: hunt only when hungry, waste nothing, and lead with strength while protecting the weak.\n[StartHighlight>Status:]</Start> Demigod\n[StartHighlight>Alignment:]</Start> NG\n[StartHighlight>Specialty Priests:]</Start> None\n[StartHighlight>Favored Weapons:]</Start> Claw/Bite\n\nDo you wish this deity to be your patron?");
				}				
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{
					// 46 Oghma  
					AddChoice("Oghma", 46, oPC);  
					SetLocalString(oPC, "deity_dyn_text_46",  
						"Oghma\n[Alias:] The Binder of What is Known\nOghma is the god of knowledge, invention, and inspiration. His faith teaches that knowledge is the greatest power and that ideas can change the world.\n[Status:] Greater\n[Alignment:] N\n[Specialty Priests:] Loremasters\n[Favored Weapons:] Quarterstaff\n\nDo you wish this deity to be your patron?"); 	
				}
                if(nAlignment == ALIGNMENT_LAWFUL_GOOD ||
					nAlignment == ALIGNMENT_LAWFUL_EVIL ||
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL)
				{	
					// 47 Red Knight  
					AddChoice("Red Knight", 47, oPC);  
					SetLocalString(oPC, "deity_dyn_text_47",  
						"Red Knight\n[Alias:] The Lady of Strategy\nThe Red Knight is the goddess of strategy and tactics. Her faith teaches that victory comes from careful planning and discipline.\n[Status:] Lesser\n[Alignment:] LN\n[Specialty Priests:] Strategists\n[Favored Weapons:] Longsword\n\nDo you wish this deity to be your patron?");	
				}
                if(nAlignment == ALIGNMENT_LAWFUL_GOOD ||
					nAlignment == ALIGNMENT_LAWFUL_EVIL ||
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL)
				{	
					// 48 Savras  
					AddChoice("Savras", 48, oPC);  
					SetLocalString(oPC, "deity_dyn_text_48",  
						"Savras\n[Alias:] The All-Seeing\nSavras is the god of divination, fate, and prophecy. His faith teaches that knowledge of the future is a powerful tool, but one that must be used wisely.\n[Status:] Demipower\n[Alignment:] LN\n[Specialty Priests:] Seers\n[Favored Weapons:] Quarterstaff\n\nDo you wish this deity to be your patron?");
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_NEUTRAL_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{
					// 49 Selune  
					AddChoice("Selune", 49, oPC);  
					SetLocalString(oPC, "deity_dyn_text_49",  
						"Selune\n[Alias:] Our Lady of Silver\nGoddess of moon, stars, and navigation. Her ethos is acceptance and tolerance; all are welcome as equals. \"May Selune guide your steps in the night\" is her priests' blessing to the faithful.\n[Status:] Greater\n[Alignment:] CG\n[Specialty Priests:] None\n[Favored Weapons:] Heavy Mace\n\nDo you wish this deity to be your patron?");
				}
				if(nAlignment == ALIGNMENT_NEUTRAL_EVIL || 
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_EVIL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL)
				{
					// 50 Shar  
					AddChoice("Shar", 50, oPC);  
					SetLocalString(oPC, "deity_dyn_text_50",  
						"Shar\n[Alias:] The Night Maiden\nShar is the goddess of darkness, loss, and forgetfulness. Her faith teaches that darkness is the ultimate truth and that all things must end.\n[Status:] Greater\n[Alignment:] NE\n[Specialty Priests:] Nightbringers\n[Favored Weapons:] Dagger\n\nDo you wish this deity to be your patron?");
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{				
					// 51 Shaundakul  
					AddChoice("Shaundakul", 51, oPC);  
					SetLocalString(oPC, "deity_dyn_text_51",  
						"Shaundakul\n[Alias:] The Riding God\nShaundakul is the god of travel, exploration, and the wind. His faith teaches that the horizon is always worth chasing and that the journey is as important as the destination.\n[Status:] Intermediate\n[Alignment:] CN\n[Specialty Priests:] Windriders\n[Favored Weapons:] Scimitar\n\nDo you wish this deity to be your patron?"); 					
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_NEUTRAL_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{					
					// 52 Sharess  
					AddChoice("Sharess", 52, oPC);  
					SetLocalString(oPC, "deity_dyn_text_52",  
						"Sharess\n[Alias:] The Lady of Festivals\nSharess is the goddess of pleasure, festivals, and relaxation. Her faith teaches that life should be enjoyed and that pleasure is a divine gift. Followers of Sharess often celebrate life through festivals and indulgence.\n[Status:] Lesser\n[Alignment:] CG\n[Specialty Priests:] Festivals\n[Favored Weapons:] Dagger\n\nDo you wish this deity to be your patron?");					
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD || 
					nAlignment == ALIGNMENT_NEUTRAL_GOOD || 
					nAlignment == ALIGNMENT_LAWFUL_GOOD )
				{					
					// 53 Shiallia  
					AddChoice("Shiallia", 53, oPC);  
					SetLocalString(oPC, "deity_dyn_text_53",  
						"Shiallia\n[Alias:] Daughter of the High Forest\nShiallia is the goddess of glades, beauty, and fertility. Her faith teaches that the beauty of the natural world should be preserved and that all life is sacred.\n[Status:] Lesser\n[Alignment:] NG\n[Specialty Priests:] Lady's Handmaidens\n[Favored Weapons:] Shortbow\n\nDo you wish this deity to be your patron?");  					
				}
                if(nAlignment == ALIGNMENT_LAWFUL_GOOD ||
					nAlignment == ALIGNMENT_LAWFUL_EVIL ||
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL)
				{					
					// 54 Siamorphe  
					AddChoice("Siamorphe", 54, oPC);  
					SetLocalString(oPC, "deity_dyn_text_54",  
						"Siamorphe\n[Alias:] The Noble\nDemipower of nobility and rightful rule. Her ethos: nobles have the right and responsibility to rule justly. Worshiped mainly by Waterdeep nobles and in Tethyr. Nobles must remain fit to rule and serve their people.\n[Status:] Demigod\n[Alignment:] LN\n[Specialty Priests:] None\n[Favored Weapons:] Light Mace\n\nDo you wish this deity to be your patron?");					
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{
					// 55 Silvanus  
					AddChoice("Silvanus", 55, oPC);  
					SetLocalString(oPC, "deity_dyn_text_55",  
						"Silvanus\n[Alias:] The Old Father\nSilvanus is the god of nature, balance, and druids. His faith teaches that nature must be respected and that balance is the key to survival.\n[Status:] Greater\n[Alignment:] N\n[Specialty Priests:] Forest Masters\n[Favored Weapons:] Scimitar\n\nDo you wish this deity to be your patron?");  					
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_NEUTRAL_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{		
					// 56 Sune  
					AddChoice("Sune", 56, oPC);  
					SetLocalString(oPC, "deity_dyn_text_56",  
						"Sune\n[Alias:] Lady Firehair\nSune is the goddess of love, beauty, and passion. Her faith teaches that love and beauty are the most powerful forces in the world. Followers of Sune often seek to spread love and appreciate beauty in all its forms.\n[Status:] Greater\n[Alignment:] CG\n[Specialty Priests:] Heartwarders\n[Favored Weapons:] Dagger\n\nDo you wish this deity to be your patron?");
				}
                if(nAlignment == ALIGNMENT_CHAOTIC_EVIL ||
					nAlignment == ALIGNMENT_NEUTRAL_EVIL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{
					// 57 Talona  
					AddChoice("Talona", 57, oPC);  
					SetLocalString(oPC, "deity_dyn_text_57",  
						"Talona\n[Alias:] Lady of Poison\nTalona is the goddess of poison, disease, and death. Her faith teaches that death is the more powerful force in life's balance and should be respected. They believe that disease serves as Talona's breath, teaching humility to those who think themselves invincible through wealth or power.\n[Status:] Intermediate\n[Alignment:] CE\n[Specialty Priests:] None\n[Favored Weapons:] Dagger\n\nDo you wish this deity to be your patron?");
				}						
                if(nAlignment == ALIGNMENT_CHAOTIC_EVIL ||
					nAlignment == ALIGNMENT_NEUTRAL_EVIL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{
					// 58 Talos  
					AddChoice("Talos", 58, oPC);  
					SetLocalString(oPC, "deity_dyn_text_58",  
						"Talos\n[Alias:] The Destroyer\nTalos is the god of storms, destruction, and rebellion. His faith teaches that destruction is a creative force and that chaos brings change.\n[Status:] Greater\n[Alignment:] CE\n[Specialty Priests:] Stormlords\n[Favored Weapons:] Greatsword\n\nDo you wish this deity to be your patron?");  
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{		
					// 59 Tempus  
					AddChoice("Tempus", 59, oPC);  
					SetLocalString(oPC, "deity_dyn_text_59",  
						"Tempus\n[Alias:] Lord of Battles\nTempus is the god of war, battles, and warriors. His faith teaches that war is a natural force that should not be feared, and that all sides are treated equally in battle. They believe Tempus helps deserving warriors win battles, and that war brings both death and the opportunity for great leadership.\n[Status:] Greater\n[Alignment:] CN\n[Specialty Priests:] None\n[Favored Weapons:] Battleaxe\n\nDo you wish this deity to be your patron?");  					
				}
				if(nAlignment == ALIGNMENT_LAWFUL_GOOD || 
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL || 
					nAlignment == ALIGNMENT_NEUTRAL_GOOD)
				{
					// 60 Torm  
					AddChoice("Torm", 60, oPC);  
					SetLocalString(oPC, "deity_dyn_text_60",  
						"Torm\n[Alias:] The True\nTorm is the god of duty, loyalty, and righteousness. His faith teaches that honor and duty are the highest virtues.\n[Status:] Greater\n[Alignment:] LG\n[Specialty Priests:] Paladins\n[Favored Weapons:] Longsword\n\nDo you wish this deity to be your patron?"); 					
				}
				
				if(nAlignment == ALIGNMENT_LAWFUL_GOOD || 
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL || 
					nAlignment == ALIGNMENT_NEUTRAL_GOOD)
				{					
					// 61 Tyr  
					AddChoice("Tyr", 61, oPC);  
					SetLocalString(oPC, "deity_dyn_text_61",  
						"Tyr\n[Alias:] The Even-Handed\nTyr is the god of justice, law, and heroes. His faith teaches that justice must be blind and that the law is the foundation of civilization.\n[Status:] Greater\n[Alignment:] LG\n[Specialty Priests:] Justiciars\n[Favored Weapons:] Longsword\n\nDo you wish this deity to be your patron?"); 					
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_NEUTRAL_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{					
					// 62 Tymora  
					AddChoice("Tymora", 62, oPC);  
					SetLocalString(oPC, "deity_dyn_text_62",  
						"Tymora\n[Alias:] Lady Luck\nTymora is the goddess of good fortune, skill, and victory. Her faith teaches that fortune favors the bold and that risk is the path to reward.\n[Status:] Greater\n[Alignment:] CG\n[Specialty Priests:] Luckbringers\n[Favored Weapons:] Dagger\n\nDo you wish this deity to be your patron?"); 					
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{					
					// 63 Ulutiu  
					AddChoice("Ulutiu", 63, oPC);  
					SetLocalString(oPC, "deity_dyn_text_63",  
						"Ulutiu\n[Alias:] The Sleeping God\nUlutiu is the god of glaciers, ice, and the frozen north. His faith teaches that stillness and endurance bring wisdom, and that the frozen lands hold ancient secrets. They believe that like the glaciers, true power comes from patience and the slow accumulation of strength over time.\n[Status:] Intermediate\n[Alignment:] LN\n[Specialty Priests:] None\n[Favored Weapons:] Spear\n\nDo you wish this deity to be your patron?"); 					
				}	
                if(nAlignment == ALIGNMENT_CHAOTIC_EVIL ||
					nAlignment == ALIGNMENT_NEUTRAL_EVIL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{
					// 64 Umberlee  
					AddChoice("Umberlee", 64, oPC);  
					SetLocalString(oPC, "deity_dyn_text_64",  
						"Umberlee\n[Alias:] The Bitch Queen\nUmberlee is the goddess of the sea, storms, and sailors. Her faith teaches that the sea is a dangerous and unpredictable force that must be respected. Followers of Umberlee often make offerings to ensure safe passage.\n[Status:] Lesser\n[Alignment:] CE\n[Specialty Priests:] Sea Maidens\n[Favored Weapons:] Trident\n\nDo you wish this deity to be your patron?");  
				}
				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_NEUTRAL_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{		
					// 65 Valkur  
					AddChoice("Valkur", 65, oPC);  
					SetLocalString(oPC, "deity_dyn_text_65",  
						"Valkur\n[Alias:] The Mighty\nValkur is the god of sailors, ships, fliers, and naval combat. His faith teaches that the best way to survive a storm is to face it head-on.\n[Status:] Lesser\n[Alignment:] CG\n[Specialty Priests:] Stormriders\n[Favored Weapons:] Cutlass\n\nDo you wish this deity to be your patron?");  
				}
				if(nAlignment == ALIGNMENT_NEUTRAL_EVIL || 
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_EVIL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL)
				{
					// 66 Velsharoon  
					AddChoice("Velsharoon", 66, oPC);  
					SetLocalString(oPC, "deity_dyn_text_66",  
						"Velsharoon\n[Alias:] The Vaunted\nVelsharoon is the god of necromancy, evil liches, and undeath. His faith teaches that practitioners of necromancy are elite visionaries worthy of respect for their bold excursions to the frontiers of life and death. They believe that true power comes from mastering the arts of undeath and gathering necromantic knowledge.\n[Status:] Demigod\n[Alignment:] NE\n[Specialty Priests:] Necrophants\n[Favored Weapons:] Quarterstaff\n\nDo you wish this deity to be your patron?");					
				}
 				if(nAlignment == ALIGNMENT_CHAOTIC_GOOD ||
					nAlignment == ALIGNMENT_CHAOTIC_EVIL || 
					nAlignment == ALIGNMENT_LAWFUL_NEUTRAL || 
					nAlignment == ALIGNMENT_TRUE_NEUTRAL ||
					nAlignment == ALIGNMENT_CHAOTIC_NEUTRAL)
				{
					// 67 Waukeen  
					AddChoice("Waukeen", 67, oPC);  
					SetLocalString(oPC, "deity_dyn_text_67",  
						"Waukeen\n[Alias:] The Merchant's Friend\nWaukeen is the goddess of wealth, trade, and merchants. Her faith teaches that commerce is the lifeblood of civilization and that honest trade benefits all. They believe that wealth should be accumulated through fair exchange and that prosperity comes from embracing opportunity and taking calculated risks.\n[Status:] Greater\n[Alignment:] LN\n[Specialty Priests:] None\n[Favored Weapons:] Nunchaku\n\nDo you wish this deity to be your patron?");  
				}
				
				MarkStageSetUp(nStage, oPC);  
                SetDefaultTokens(); 

			} 
            else if (nStage == STAGE_CONFIRM)   
            {   
                int nSelected = GetLocalInt(oPC, "deity_selected");    
                SetHeader(GetDeityText(oPC, nSelected));      
                AddChoice("Yes!", nSelected, oPC);     
                AddChoice("No...", -1, oPC);  
				MarkStageSetUp(nStage, oPC);      
                SetDefaultTokens();           
            }   
        }
		SetupTokens();
	}
		// End of conversation cleanup  
		else if(nValue == DYNCONV_EXITED)  
		{  
			// Start the next step in character creation - language selection  
			DelayCommand(0.1f, StartDynamicConversation("bg_language_cv", oPC));  
		}
		else if(nValue == DYNCONV_ABORTED)
		{
			// Handle aborted conversation
			SendMessageToPC(oPC, "Deity selection aborted.");
		}
        else // Handle user choices  
        {  
            int nChoice = GetChoice(oPC);  
            if(nStage == STAGE_LIST)  
            {  
                // Store the selection and move to confirm  
                SetLocalInt(oPC, "deity_selected", nChoice);  
                SetStage(STAGE_CONFIRM, oPC);  
            }  
            else if (nStage == STAGE_CONFIRM)  
            {  
                if(nChoice == -1) // "No" - return to list  
                {  
					MarkStageNotSetUp(STAGE_LIST, oPC); // Force rebuild of deity list
                    SetStage(STAGE_LIST, oPC);  
                }  
                else // "Yes" - confirm deity  
                {  
					int nDeityChoice = GetLocalInt(oPC, "deity_selected");
					switch (nDeityChoice)    
					{    
						case 1:  
						{  
							//sGrant = "deity_dwarven";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Dwarven_Powers);  
							SetPersistantLocalInt(oPC, "BG_Select", 1);  
							SetLocalInt(oItem,"CC3",DEITY_Dwarven_Powers);  
							SetLocalInt(oItem,"BG_Select",1);                          
							break; // Dwarven Powers                              
						}  
						case 2:  
						{  
							//sGrant = "deity_elven";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Elven_Powers);  
							SetPersistantLocalInt(oPC, "BG_Select", 2);  
							SetLocalInt(oItem,"CC3",DEITY_Elven_Powers);  
							SetLocalInt(oItem,"BG_Select",2);                          
							break; // Elven Powers                              
						}  
						case 3:  
						{  
							//sGrant = "deity_gnomish";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Gnomish_Powers);  
							SetPersistantLocalInt(oPC, "BG_Select", 3);  
							SetLocalInt(oItem,"CC3",DEITY_Gnomish_Powers);  
							SetLocalInt(oItem,"BG_Select",3);                          
							break; // Gnomish Powers                              
						}  
						case 4:  
						{  
							//sGrant = "deity_halfling";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Halfling_Powers);  
							SetPersistantLocalInt(oPC, "BG_Select", 4);  
							SetLocalInt(oItem,"CC3",DEITY_Halfling_Powers);  
							SetLocalInt(oItem,"BG_Select",4);                          
							break; // Halfling Powers                              
						}  
						case 5:  
						{  
							//sGrant = "deity_orcish";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Orcish_Powers);  
							SetPersistantLocalInt(oPC, "BG_Select", 5);  
							SetLocalInt(oItem,"CC3",DEITY_Orcish_Powers);  
							SetLocalInt(oItem,"BG_Select",5);                          
							break; // Orcish Powers                              
						}  
						case 6:  
						{  
							//sGrant = "deity_underdark";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Underdark_Powers);  
							SetPersistantLocalInt(oPC, "BG_Select", 6);  
							SetLocalInt(oItem,"CC3",DEITY_Underdark_Powers);  
							SetLocalInt(oItem,"BG_Select",6);                          
							break; // Underdark Powers                              
						}  
						case 7:  
						{  
							//sGrant = "deity_akadi";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Akadi);  
							SetPersistantLocalInt(oPC, "BG_Select", 7);  
							SetLocalInt(oItem,"CC3",DEITY_Akadi);  
							SetLocalInt(oItem,"BG_Select",7);                          
							break; // Akadi                              
						}  
						case 8:  
						{  
							//sGrant = "deity_amaunator";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Amaunator);  
							SetPersistantLocalInt(oPC, "BG_Select", 8);  
							SetLocalInt(oItem,"CC3",DEITY_Amaunator);  
							SetLocalInt(oItem,"BG_Select",8);                          
							break; // Amaunator                              
						}  
						case 9:  
						{  
							//sGrant = "deity_auril";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Auril);  
							SetPersistantLocalInt(oPC, "BG_Select", 9);  
							SetLocalInt(oItem,"CC3",DEITY_Auril);  
							SetLocalInt(oItem,"BG_Select",9);                          
							break; // Auril                              
						}  
						case 10:  
						{  
							//sGrant = "deity_azuth";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Azuth);  
							SetPersistantLocalInt(oPC, "BG_Select", 10);  
							SetLocalInt(oItem,"CC3",DEITY_Azuth);  
							SetLocalInt(oItem,"BG_Select",10);                          
							break; // Azuth                              
						}  
						case 11:  
						{  
							//sGrant = "deity_bane";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Bane);  
							SetPersistantLocalInt(oPC, "BG_Select", 11);  
							SetLocalInt(oItem,"CC3",DEITY_Bane);  
							SetLocalInt(oItem,"BG_Select",11);                          
							break; // Bane                              
						}  
						case 12:  
						{  
							//sGrant = "deity_beshaba";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Beshaba);  
							SetPersistantLocalInt(oPC, "BG_Select", 12);  
							SetLocalInt(oItem,"CC3",DEITY_Beshaba);  
							SetLocalInt(oItem,"BG_Select",12);                          
							break; // Beshaba                              
						}  
						case 13:  
						{  
							//sGrant = "deity_bhall";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Bhaal);  
							SetPersistantLocalInt(oPC, "BG_Select", 13);  
							SetLocalInt(oItem,"CC3",DEITY_Bhaal);  
							SetLocalInt(oItem,"BG_Select",13);                          
							break; // Bhall                              
						}  
						case 14:  
						{  
							//sGrant = "deity_chauntea";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Chauntea);  
							SetPersistantLocalInt(oPC, "BG_Select", 14);  
							SetLocalInt(oItem,"CC3",DEITY_Chauntea);  
							SetLocalInt(oItem,"BG_Select",14);                          
							break; // Chauntea                              
						}  
						case 15:  
						{  
							//sGrant = "deity_cyric";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Cyric);  
							SetPersistantLocalInt(oPC, "BG_Select", 15);  
							SetLocalInt(oItem,"CC3",DEITY_Cyric);  
							SetLocalInt(oItem,"BG_Select", 15);                          
							break; // Cyric                              
						}  
						case 16:  
						{  
							//sGrant = "deity_deneir";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Deneir);  
							SetPersistantLocalInt(oPC, "BG_Select", 16);  
							SetLocalInt(oItem,"CC3",DEITY_Deneir);  
							SetLocalInt(oItem,"BG_Select", 16);                          
							break; // Deneir                              
						}  
						case 17:  
						{  
							//sGrant = "deity_eldath";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Eldath);  
							SetPersistantLocalInt(oPC, "BG_Select", 17);  
							SetLocalInt(oItem,"CC3",DEITY_Eldath);  
							SetLocalInt(oItem,"BG_Select", 17);                          
							break; // Eldath                              
						}  
						case 18:  
						{  
							//sGrant = "deity_finder_wyvernspur";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Finder_Wyvernspur);  
							SetPersistantLocalInt(oPC, "BG_Select", 18);  
							SetLocalInt(oItem,"CC3",DEITY_Finder_Wyvernspur);  
							SetLocalInt(oItem,"BG_Select",18);                          
							break; // Finder Wyvernspur                              
						}  
						case 19:  
						{  
							//sGrant = "deity_garagos";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Garagos);  
							SetPersistantLocalInt(oPC, "BG_Select", 19);  
							SetLocalInt(oItem,"CC3",DEITY_Garagos);  
							SetLocalInt(oItem,"BG_Select",19);                          
							break; // Garagos                              
						}  
						case 20:  
						{  
							//sGrant = "deity_gargauth";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Gargauth);  
							SetPersistantLocalInt(oPC, "BG_Select", 20);  
							SetLocalInt(oItem,"CC3",DEITY_Gargauth);  
							SetLocalInt(oItem,"BG_Select",20);                          
							break; // Gargauth                              
						}  
						case 21:  
						{  
							//sGrant = "deity_gond";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Gond);  
							SetPersistantLocalInt(oPC, "BG_Select", 21);  
							SetLocalInt(oItem,"CC3",DEITY_Gond);  
							SetLocalInt(oItem,"BG_Select",21);                          
							break; // Gond                              
						}  
						case 22:  
						{  
							//sGrant = "deity_grumbar";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Grumbar);  
							SetPersistantLocalInt(oPC, "BG_Select", 22);  
							SetLocalInt(oItem,"CC3",DEITY_Grumbar);  
							SetLocalInt(oItem,"BG_Select",22);                          
							break; // Grumbar                              
						}  
						case 23:  
						{  
							//sGrant = "deity_gwaeron_windstrom";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Gwaeron_Windstrom);  
							SetPersistantLocalInt(oPC, "BG_Select", 23);  
							SetLocalInt(oItem,"CC3",DEITY_Gwaeron_Windstrom);  
							SetLocalInt(oItem,"BG_Select",23);                          
							break; // Gwaeron Windstrom                              
						}  
						case 24:  
						{  
							//sGrant = "deity_helm";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Helm);  
							SetPersistantLocalInt(oPC, "BG_Select", 24);  
							SetLocalInt(oItem,"CC3",DEITY_Helm);  
							SetLocalInt(oItem,"BG_Select",24);                          
							break; // Helm                              
						}  
						case 25:  
						{  
							//sGrant = "deity_hoar";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Hoar);  
							SetPersistantLocalInt(oPC, "BG_Select", 25);  
							SetLocalInt(oItem,"CC3",DEITY_Hoar);  
							SetLocalInt(oItem,"BG_Select",25);                          
							break; // Hoar                              
						}  
						case 26:  
						{  
							//sGrant = "deity_ibrandul";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Ibrandul);  
							SetPersistantLocalInt(oPC, "BG_Select", 26);  
							SetLocalInt(oItem,"CC3",DEITY_Ibrandul);  
							SetLocalInt(oItem,"BG_Select", 26);                          
							break; // Ibrandul                              
						}  
						case 27:  
						{  
							//sGrant = "deity_ilmater";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Ilmater);  
							SetPersistantLocalInt(oPC, "BG_Select", 27);  
							SetLocalInt(oItem,"CC3",DEITY_Ilmater);  
							SetLocalInt(oItem,"BG_Select", 27);                          
							break; // Ilmater                              
						}  
						case 28:  
						{  
							//sGrant = "deity_ishtishia";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Ishtisha);  
							SetPersistantLocalInt(oPC, "BG_Select", 28);  
							SetLocalInt(oItem,"CC3",DEITY_Ishtisha);  
							SetLocalInt(oItem,"BG_Select", 28);                          
							break; // Ishtishia                              
						}  
						case 29:  
						{  
							//sGrant = "deity_jergal";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Jergal);  
							SetPersistantLocalInt(oPC, "BG_Select", 29);  
							SetLocalInt(oItem,"CC3",DEITY_Jergal);  
							SetLocalInt(oItem,"BG_Select", 29);                          
							break; // Jergal                              
						}  
						case 30:  
						{  
							//sGrant = "deity_karsus";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Karsus);  
							SetPersistantLocalInt(oPC, "BG_Select", 30);  
							SetLocalInt(oItem,"CC3",DEITY_Karsus);  
							SetLocalInt(oItem,"BG_Select", 30);                          
							break; // Karsus                              
						}  
						case 31:  
						{  
							//sGrant = "deity_kelemvor";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Kelemvor);  
							SetPersistantLocalInt(oPC, "BG_Select", 31);  
							SetLocalInt(oItem,"CC3",DEITY_Kelemvor);  
							SetLocalInt(oItem,"BG_Select", 31);                          
							break; // Kelemvor                              
						}  
						case 32:  
						{  
							//sGrant = "deity_kossuth";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Kossuth);  
							SetPersistantLocalInt(oPC, "BG_Select", 32);  
							SetLocalInt(oItem,"CC3",DEITY_Kossuth);  
							SetLocalInt(oItem,"BG_Select", 32);                          
							break; // Kossuth                              
						}  
						case 33:  
						{  
							//sGrant = "deity_lathander";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Lathander);  
							SetPersistantLocalInt(oPC, "BG_Select", 33);  
							SetLocalInt(oItem,"CC3",DEITY_Lathander);  
							SetLocalInt(oItem,"BG_Select", 33);                          
							break; // Lathander                              
						}  
						case 34:  
						{  
							//sGrant = "deity_leira";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Leira);  
							SetPersistantLocalInt(oPC, "BG_Select", 34);  
							SetLocalInt(oItem,"CC3",DEITY_Leira);  
							SetLocalInt(oItem,"BG_Select", 34);                          
							break; // Leira                              
						}  
						case 35:  
						{  
							//sGrant = "deity_lliira";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Lliira);  
							SetPersistantLocalInt(oPC, "BG_Select", 35);  
							SetLocalInt(oItem,"CC3",DEITY_Lliira);  
							SetLocalInt(oItem,"BG_Select", 35);                          
							break; // Lliira                              
						}  
						case 36:  
						{  
							//sGrant = "deity_loviatar";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Loviatar);  
							SetPersistantLocalInt(oPC, "BG_Select", 36);  
							SetLocalInt(oItem,"CC3",DEITY_Loviatar);  
							SetLocalInt(oItem,"BG_Select",36);                          
							break; // Loviatar                              
						}  
						case 37:  
						{  
							//sGrant = "deity_lurue";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Lurue);  
							SetPersistantLocalInt(oPC, "BG_Select", 37);  
							SetLocalInt(oItem,"CC3",DEITY_Lurue);  
							SetLocalInt(oItem,"BG_Select", 37);                          
							break; // Lurue                              
						}  
						case 38:  
						{  
							//sGrant = "deity_malar";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Malar);  
							SetPersistantLocalInt(oPC, "BG_Select", 38);  
							SetLocalInt(oItem,"CC3",DEITY_Malar);  
							SetLocalInt(oItem,"BG_Select", 38);                          
							break; // Malar                              
						}  
						case 39:  
						{  
							//sGrant = "deity_mask";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Mask);  
							SetPersistantLocalInt(oPC, "BG_Select", 39);  
							SetLocalInt(oItem,"CC3",DEITY_Mask);  
							SetLocalInt(oItem,"BG_Select", 39);                          
							break; // Mask                              
						}  
						case 40:  
						{  
							//sGrant = "deity_mielikki";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Mielikki);  
							SetPersistantLocalInt(oPC, "BG_Select", 40);  
							SetLocalInt(oItem,"CC3",DEITY_Mielikki);  
							SetLocalInt(oItem,"BG_Select", 40);                          
							break; // Mielikki                              
						}  
						case 41:  
						{  
							//sGrant = "deity_milil";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Milil);  
							SetPersistantLocalInt(oPC, "BG_Select", 41);  
							SetLocalInt(oItem,"CC3",DEITY_Milil);  
							SetLocalInt(oItem,"BG_Select", 41);                          
							break; // Milil                              
						}  
						case 42:  
						{  
							//sGrant = "deity_moander";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Moander);  
							SetPersistantLocalInt(oPC, "BG_Select", 42);  
							SetLocalInt(oItem,"CC3",DEITY_Moander);  
							SetLocalInt(oItem,"BG_Select", 42);                          
							break; // Moander                              
						}  
						case 43:  
						{  
							//sGrant = "deity_myrkul";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Myrkul);  
							SetPersistantLocalInt(oPC, "BG_Select", 43);  
							SetLocalInt(oItem,"CC3",DEITY_Myrkul);  
							SetLocalInt(oItem,"BG_Select", 43);                          
							break; // Myrkul                              
						}  
						case 44:  
						{  
							//sGrant = "deity_mystra";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Mystra);  
							SetPersistantLocalInt(oPC, "BG_Select", 44);  
							SetLocalInt(oItem,"CC3",DEITY_Mystra);  
							SetLocalInt(oItem,"BG_Select", 44);                          
							break; // Mystra                              
						}  
						case 45:  
						{  
							//sGrant = "deity_nobanion";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Nobanion);  
							SetPersistantLocalInt(oPC, "BG_Select", 45);  
							SetLocalInt(oItem,"CC3",DEITY_Nobanion);  
							SetLocalInt(oItem,"BG_Select",45);                          
							break; // Nobanion                              
						}  
						case 46:  
						{  
							//sGrant = "deity_oghma";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Oghma);  
							SetPersistantLocalInt(oPC, "BG_Select", 46);  
							SetLocalInt(oItem,"CC3",DEITY_Oghma);  
							SetLocalInt(oItem,"BG_Select",46);                          
							break; // Oghma                              
						}  
						case 47:  
						{  
							//sGrant = "deity_red_knight";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Red_Knight);  
							SetPersistantLocalInt(oPC, "BG_Select", 47);  
							SetLocalInt(oItem,"CC3",DEITY_Red_Knight);  
							SetLocalInt(oItem,"BG_Select",47);                          
							break; // Red Knight                              
						}  
						case 48:  
						{  
							//sGrant = "deity_savras";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Savras);  
							SetPersistantLocalInt(oPC, "BG_Select", 48);  
							SetLocalInt(oItem,"CC3",DEITY_Savras);  
							SetLocalInt(oItem,"BG_Select", 48);                          
							break; // Savras                              
						}  
						case 49:  
						{  
							//sGrant = "deity_selune";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Selune);  
							SetPersistantLocalInt(oPC, "BG_Select", 49);  
							SetLocalInt(oItem,"CC3",DEITY_Selune);  
							SetLocalInt(oItem,"BG_Select", 49);                          
							break; // Selune                              
						}  
						case 50:  
						{  
							//sGrant = "deity_shar";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Shar);  
							SetPersistantLocalInt(oPC, "BG_Select", 50);  
							SetLocalInt(oItem,"CC3",DEITY_Shar);  
							SetLocalInt(oItem,"BG_Select", 50);                          
							break; // Shar                              
						}  
						case 51:  
						{  
							//sGrant = "deity_shaundakul";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Shaundakul);  
							SetPersistantLocalInt(oPC, "BG_Select", 51);  
							SetLocalInt(oItem,"CC3",DEITY_Shaundakul);  
							SetLocalInt(oItem,"BG_Select", 51);                          
							break; // Shaundakul                              
						}  
						case 52:  
						{  
							//sGrant = "deity_sharess";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Sharess);  
							SetPersistantLocalInt(oPC, "BG_Select", 52);  
							SetLocalInt(oItem,"CC3",DEITY_Sharess);  
							SetLocalInt(oItem,"BG_Select", 52);                          
							break; // Sharess                              
						}  
						case 53:  
						{  
							//sGrant = "deity_shiallia";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Shiallia);  
							SetPersistantLocalInt(oPC, "BG_Select", 53);  
							SetLocalInt(oItem,"CC3",DEITY_Shiallia);  
							SetLocalInt(oItem,"BG_Select", 53);                          
							break; // Shiallia                              
						}  
						case 54:  
						{  
							//sGrant = "deity_siamorphe";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Siamorphe);  
							SetPersistantLocalInt(oPC, "BG_Select", 54);  
							SetLocalInt(oItem,"CC3",DEITY_Siamorphe);  
							SetLocalInt(oItem,"BG_Select", 54);                          
							break; // Siamorphe                              
						}  
						case 55:  
						{  
							//sGrant = "deity_silvanus";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Silvanus);  
							SetPersistantLocalInt(oPC, "BG_Select", 55);  
							SetLocalInt(oItem,"CC3",DEITY_Silvanus);  
							SetLocalInt(oItem,"BG_Select", 55);                          
							break; // Silvanus                              
						}  
						case 56:  
						{  
							//sGrant = "deity_sune";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Sune);  
							SetPersistantLocalInt(oPC, "BG_Select", 56);  
							SetLocalInt(oItem,"CC3",DEITY_Sune);  
							SetLocalInt(oItem,"BG_Select",56);                          
							break; // Sune                              
						}  
						case 57:  
						{  
							//sGrant = "deity_talona";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Talona);  
							SetPersistantLocalInt(oPC, "BG_Select", 57);  
							SetLocalInt(oItem,"CC3",DEITY_Talona);  
							SetLocalInt(oItem,"BG_Select", 57);                          
							break; // Talona                              
						}  
						case 58:  
						{  
							//sGrant = "deity_talos";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Talos);  
							SetPersistantLocalInt(oPC, "BG_Select", 58);  
							SetLocalInt(oItem,"CC3",DEITY_Talos);  
							SetLocalInt(oItem,"BG_Select", 58);                          
							break; // Talos                              
						}  
						case 59:  
						{  
							//sGrant = "deity_tempus";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Tempus);  
							SetPersistantLocalInt(oPC, "BG_Select", 59);  
							SetLocalInt(oItem,"CC3",DEITY_Tempus);  
							SetLocalInt(oItem,"BG_Select", 59);                          
							break; // Tempus                              
						}  
						case 60:  
						{  
							//sGrant = "deity_torm";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Torm);  
							SetPersistantLocalInt(oPC, "BG_Select", 60);  
							SetLocalInt(oItem,"CC3",DEITY_Torm);  
							SetLocalInt(oItem,"BG_Select", 60);                          
							break; // Torm                              
						}  
						case 61:  
						{  
							//sGrant = "deity_tyr";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Tyr);  
							SetPersistantLocalInt(oPC, "BG_Select", 61);  
							SetLocalInt(oItem,"CC3",DEITY_Tyr);  
							SetLocalInt(oItem,"BG_Select", 61);                          
							break; // Tyr                              
						}  
						case 62:  
						{  
							//sGrant = "deity_tymora";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Tymora);  
							SetPersistantLocalInt(oPC, "BG_Select", 62);  
							SetLocalInt(oItem,"CC3",DEITY_Tymora);  
							SetLocalInt(oItem,"BG_Select", 62);                          
							break; // Tymora                              
						}  
						case 63:  
						{  
							//sGrant = "deity_ulutiu";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Ulutiu);  
							SetPersistantLocalInt(oPC, "BG_Select", 63);  
							SetLocalInt(oItem,"CC3",DEITY_Ulutiu);  
							SetLocalInt(oItem,"BG_Select", 63);                          
							break; // Ulutiu                              
						}  
						case 64:  
						{  
							//sGrant = "deity_umberlee";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Umberlee);  
							SetPersistantLocalInt(oPC, "BG_Select", 64);  
							SetLocalInt(oItem,"CC3",DEITY_Umberlee);  
							SetLocalInt(oItem,"BG_Select", 64);                          
							break; // Umberlee                              
						}  
						case 65:  
						{  
							//sGrant = "deity_valkur";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Valkur);  
							SetPersistantLocalInt(oPC, "BG_Select", 65);  
							SetLocalInt(oItem,"CC3",DEITY_Valkur);  
							SetLocalInt(oItem,"BG_Select", 65);                          
							break; // Valkur                              
						}  
						case 66:  
						{  
							//sGrant = "deity_velsharoon";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Velsharoon);  
							SetPersistantLocalInt(oPC, "BG_Select", 66);  
							SetLocalInt(oItem,"CC3",DEITY_Velsharoon);  
							SetLocalInt(oItem,"BG_Select", 66);                          
							break; // Velsharoon                              
						}  
						case 67:  
						{  
							//sGrant = "deity_waukeen";  
							SetPersistantLocalInt(oPC, "CC3", DEITY_Waukeen);  
							SetPersistantLocalInt(oPC, "BG_Select", 67);  
							SetLocalInt(oItem,"CC3",DEITY_Waukeen);  
							SetLocalInt(oItem,"BG_Select", 67);                          
							break; // Waukeen                              
						}  
						//default: sGrant = ""; break;  
					}  
					// Force exit the conversation after selecting deity
					AllowExit(DYNCONV_EXIT_FORCE_EXIT, TRUE, oPC);
				}  
			}  
		}  
}
 */

