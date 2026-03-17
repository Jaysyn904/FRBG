// bg_subrace_cv.nss  
#include "inc_dynconv"  
#include "x2_inc_switches" 
#include "inc_persist_loca"
#include "te_afflic_func"


const int STAGE_LIST    = 0;  
const int STAGE_CONFIRM = 1;  
  
string GetSubraceText(object oPC, int nChoice) {  
    return GetLocalString(oPC, "sub_dyn_text_" + IntToString(nChoice));  
}  
  
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

void main()     
{      
    object oPC = GetPCSpeaker();      
    SendMessageToPC(oPC, "DEBUG: bg_subrace_cv main() entered");      
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);      
    int nStage = GetStage(oPC);      
      
    // Required guard: abort if nValue is 0      
    if (nValue == 0) return;      
      
    if (nValue == DYNCONV_SETUP_STAGE)     
	{      
        if (!GetIsStageSetUp(nStage, oPC))     
		{      
            if (nStage == STAGE_LIST)     
			{      
               SetHeader("You will now choose your Subrace or Ethnicity. Subraces will affect what class standings you may be able to choose.\nYou can refresh the list with the Escape key if needed.");      
      
                // 1 Other (unlisted)  
                AddChoice("[Other]", 1, oPC);  
                SetLocalString(oPC, "sub_dyn_text_1",  
                    "My ethnicity or subrace is not listed. I realize that I am likely about to play a concept that is unsupported and not recommended, but I will select this anyway.\n\nDoes this describe you?");  
  
                // 2 Human ethnicities (inline bg_chk_hum logic)  
                if (GetRacialType(oPC) == RACIAL_TYPE_HUMAN || GetRacialType(oPC) == RACIAL_TYPE_HALFELF) 
				{			
                    AddChoice("Tethyrian", 2, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_2",  
                        "The Tethyrian culture is a melting pot of Calishite, Chondathan, Illuskan, and Low Netherese elements. This unique background makes Tethyrians among the most tolerant, though fiercely independent, ethnic groups in Faerun. They inhabit a vast territory stretching from Calimshan to Silverymoon, and from the Sea of Swords to the Sea of Fallen Stars. Tethyrians are of medium build and height, with dusky skin that grows fairer the farther north they dwell. Their hair and eye color vary widely, but brown hair and blue eyes are the most common. Tethyrians are proud of their diverse heritage and protective of their freedom, so they tend to distrust powerful kingdoms and empires.\n\nTethyrians receive Alzhedo as a bonus language automatically.\n\nDoes this describe you?");  
                    
					AddChoice("Calishite", 3, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_3",  
                        "These humans are descended from the slaves of Calimshan's ancient genie lords, form the primary racial stock of the Border Kingdoms, the Lake of Steam cities, the Nelanther Isles, and Calimshan. Shorter and slighter in build than most other humans, Calishites have dusky brown skin, hair, and eyes. they regard themselves as the rightful rulers of all lands south and west of the Sea of Fallen Stars and look upon northern cultures as short-lived barbarian kingdoms barely worthy of notice. Most Calishites seek nothing more than a lifestyle of comfort and the respect of their peers.\n\nCalishites receive Alzhedo as a bonus language automatically.\n\nDoes this describe you?");  
                    
					AddChoice("Illuskan", 4, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_4",  
                        "The seagoing, warlike people of the Sword Coast North, the Trackless Sea, and the Dessarin river valley, Illuskans are fall, fair-skinned folk with blue or steely gray eyes. Among the islands of the Trackless Sea and Icewind Dale, their hair color tends towards blond, red, or light brown. On the mainland south of the Spine of the World, however, raven-black hair is most common. Illuskans are proud, particularly of their ability to survive in the harsh environment of their northern homelands, and they regard most southerners as weak and decadent. Illuskans make their living as farmers, fishers, miners, sailors, raiders, skalds, and runecasters.\n\nThe Illuskans receive Illuskan as a bonus language automatically.\n\nDoes this describe you?");  
                    
					AddChoice("Rashemi", 5, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_5",  
                        "These humans are tough, sturdy, and well adapted to life in the harsh and dangerous northeastern reaches of Faerun. They are descended from the nomadic tribes that won the Orcgate Wars and built the empire of Raumathar. Not only do the Rashemis dominate Rashemen and Thay, they also form significant minorities in Aglarond, the Endless Wastes, Thesk, and the Wizards' Reach region. Rashemis tend to be short, stout, and muscular, and they usually have dusky skin, dark eyes, and thick, black hair. They cherish their strong ties to their land, appreciating its beauty while respecting its harshness. They display little of the arrogance that marks other groups whose ancestors once ruled empires.\n\nRashemi receive Rashemi as a bonus language.\n\nDoes this describe you?");  
                    
					AddChoice("Shou", 6, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_6",  
                        "Little is known of the Shou - and in western Faerun it is assumed that they are the only racial group of the far-distant Kara-Tur. It is rare to see a Shou outside of the far east. Shou have a bronzed-yellow skin tones and typically have black hair with broad, flat features.\n\nShou do not receive any bonus language.\n\nDoes this describe you?");                    
					
					AddChoice("Maztican", 7, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_7",  
                        "After the Helmite conquest in Maztica, many people of the differing tribes lumped together by the Easterners began to immigrate to the old world and see what wonders lied across the Trackless Sea. Truely a people displaced, Mazticans are unfamiliar with the customs of the Tethyrians or the Chondathans. Rumors of Helmite abuse and exploitation in Maztica are common, much more common than the sight of a simple Maztican.  Mazticans receive Maztilan as a bonus language automatically.\n\nDoes this describe you?");  
  
					AddChoice("Chultan", 8, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_8",  
                        "The jungles of Chult are a harsh and unforgiving land that forged together the many disparate tribes of the peninsula into one single culture more than a millennia ago. Most Chultans distrust power and wealth, believing that things that they cannot take with them are ultimately worthless. It is rare to see a Chultan separated from their clan. Tall and ebony-skinned, Chultans receive Chultan as a bonus language automatically.\n\nDoes this describe you?"); 
                    
					AddChoice("Chondathan", 9, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_9",  
                        "Descended from the natives of the Vilhon Reach, these hardy folk have spread to settle most of the western and central Inner Sea region and much of the Western Heartlands. Chondathans form the primary racial stock of Altumbel, Cormyr, the southern Dalelands, the Dragon Coast, the Great Dale, Hlondeth and both shores of the Vilhon Reach, the Pirate Isles of the Inner Sea, Sembia, and Sespech. They are slender, tawny-skinned folk with brown hair that ranges from almost blond to almost black. Most are tall and have green or brown eyes, but these traits are hardly universal. \n\nDoes this describe you?"); 						
                    
					AddChoice("Damaran", 10, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_10",  
                        "Proud and stubborn, these humans were born from some scattered remnants of Narfell's fall - primarily groups of Nars, Rashemis, and Sossrims who struggled to survive while waves of Chondathan emigrants settled in the lands of the Easting Reach. These four populations gradually coalesced into a new ethnic group that now makes up the primary racial stock of Damara, Impiltur, Thesk, and the Vast. Damarans are of moderate height and build, with skin hues ranging from tawny to fair. Their hair is usually brown or black, and their eye color varies widely, though brown is most common. Damarans see the world in stark contrasts - unspeakable evil opposed by indomitable and uncompromising good.  \n\nDoes this describe you?");
						
                    AddChoice("Mulan", 11, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_11",  
                        "Members of this ethnic group have dominated the eastern shores of the Sea of Fallen stars since the fall of ancient Ilmaskar. At various times in their long history, they have made up at least the ruling elite of Ashanath, Chessenta, the Eastern Shaar, Murghom, Rashemen, Semphar, Thay, Thesk, and the Wizards' Reach cities south of the Yuirwood. Mulan are generally tall, slim, and sallow-skinned with eyes of hazel or brown. Their hair ranges from black to dark brown, but all nobles and many other Mulan routinely shave off all of their hair. As a race, Mulan are arrogant, conservative, and convinced of their cultural superiority over the rest of Faerun.\n\nMulan receive Mulanese as a bonus language.\n\nDoes this describe you?");
						
					AddChoice("Ffolk", 12, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_12",  
                        "These humans are descended from Tethyrians who migrated from the Western Heartlands to the Moonshae Isles. They are generally hostile to the Illuskans who are seen as invaders to the Moonshae Isles, though, most of the Ffolk speak Illuskan and use the Thorass script. More so than many other cultural groups, the Ffolk are governed by a strong druidical tradition that permeates their society. Due to their Tethyrian heritage, the ffolk tend to have darker skin and hair when compared to Illuskans or Chondathans.\n\nThe Ffolk receive Talfiric as a bonus language automatically.\n\nDoes this describe you?");  
 
                     AddChoice("Imaskari", 13, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_13",  
                        "Before the rise of the Mulan in the great deserts, the Imaskari ruled in a great empire rumored to stretch across the east. But that is all that remains of the Imaskari - rumors and what little of their culture has been preserved by the Mulan.\n\nDoes this describe you?");						
						
                    AddChoice("Shaaran", 14, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_14",  
                        "The Shaarans are the group of humans native to the steepes of the Shaar region. A simple, nomadic culture based on clan loyalty, they were once considered part of the Shoon Imperium before the ancient empire allowed them to rebel in the fifth century. Shaarans are long-faced with a yellow-tanned skin. They speak Shaaran and most do not read or write.\n\nDoes this describe you?");						 
                }
  
                // 3 Elf subraces (bg_chk_elf logic)  
                if (GetRacialType(oPC) == RACIAL_TYPE_ELF)
				{  
                    AddChoice("Moon Elf", 15, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_15",  
                        "Silver Elves are the most common sort of elves in Faerun, also called Moon Elves they have fair skin and hair of silver-white, black or blue. Their eyes are blue or green with gold flecks. They are the elven subrace most tolerant of human kind, and most half-elves are descended from Silver Elves. These elves are a minority in Tethyr and might be regarded as soft or alien by the Copper and Green elves that inhabit the Wealdath.\n\nDoes this describe you?");  
                    
					AddChoice("Sun Elf", 16, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_16",  
                        "Gold Elves are less common across Faerun than Silver Elves, because most live on Evermeet, where non-elves are not allowed. Also called Sun Elves, they have bronze skin, golden-blond, copper or black hair and green or gold eyes. These are seen as the most civilized and haughty elves, preferring to remain separate from non-elven races. Seeing a Gold Elf is typically more rare than a Dark Elf in the Lands of Intrigue.\n\nDoes this describe you?");  
                   
				   AddChoice("Wild Elf", 17, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_17",  
                        "The very rare Green Elves, also called Wild Elves, are rarely seen by others because they live in the heart of the Wealdath Forest. They possess incredible skill at keeping hidden. Their skin tends to be dark brown and their hair ranges from black to light brown, lightening to silvery-white with age. Although less numerous than Copper Elves, they are the second most populous type of elf in the region of Old Noromath.\n\nDoes this describe you?");  
                    
					AddChoice("Wood Elf", 18, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_18",  
                        "Wood Elves, also called Copper Elves, are reclusive but less so than their cousins - the almost feral Wild Elves. They have copper colored skin tinged with green. They have brown, green or hazel colored eyes. Their hair is usually brown or black with blond and coppery red occasionally found. Copper Elves are the most numerous type of elf in Northern Tethyr.\n\nDoes this describe you?");  
                    
					AddChoice("Dark Elf (Drow)", 19, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_19",  
                        "Descended from the original dark-skinned elven subrace known as Illythiiri, the Dark Elves were cursed into their present appearance by the good elven deities for following the goddess Lolth down the path to evil and corruption. Also called the Drow, they have black skin that resembles polished obsidian and stark white or pale yellow hair. Dark Elves found in Tethyr have likely been forced from their subterranean home of the Underdark, unable to return for many varied reasons.\n\nECL +2\n\nDoes this describe you?");  
                    
					AddChoice("Fey'ri", 20, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_20",  
                        "NOT FULLY IMPLEMENTED\n\nThe result of four noble Sun Elf houses breeding with demons in an attempt to strengthen the Dlardrageth bloodline, the Fey'ri are type of planetouched that breeds only amongst themselves. Once a prominent Elven House in Cormanthyr, the Fey'ri have been involved in various schemes and remain reviled throughout the realms since these times.\n\nECL +3\n\nDoes this describe you?");  
                }
  
				// 4 Dwarf subraces (bg_chk_dwarf logic)  
                if (GetRacialType(oPC) == RACIAL_TYPE_DWARF) 
				{  
                    AddChoice("Shield Dwarf - Default/Recommended", 21, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_21",  
                        "The sculpted halls and echoing chambers of Dwarven Kingdoms are scattered through the Underdark like forgotten necklaces of semiprecious stones. Dwarven Kingdoms such as Xonathanur, Oghrann, and Gharraghaur taught the less civilized races of Faerun what it meant to hold and wield power. Unlike the ancient human empires, the Dwarves distrusted magic - so they were never seduced to the heights of magical folly that toppled Netheril and Imaskar. Instead, the Dwarves became locked in eternal wars with goblin kind and the other dwellers of the Underdark. One by one, the empires of the North failed - leaving only scattered survivors in the mountains or unconquered sections of the Underdark.\n\nDoes this describe you?");  
                    
					AddChoice("Gold Dwarf", 22, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_22",  
                        "Unlike the Shield Dwarves, the Gold Dwarves maintained their Great Kingdom in the Rift and did not decline in terrible wars against evil humanoids. While they practiced some magic, they never acquired the hubris that caused the downfall of some human nations. Confident and secure in their remote home the Gold Dwarves gained a reputation for haughtiness and pride.\n\nDoes this describe you?");  
                    
					AddChoice("Gray Dwarf (Duergar)", 23, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_23",  
                        "Long ago, mindflayers conquered the strongholds of Clan Duergar of the Dwarven Kingdom of Shanatar. After generations of enslavement and cruel experimentation at the hands of the Illithids, the Duergar rose against their masters and regained their freedom. They emerged as a new subrace of Dwarf with limited magical powers. Many Grey Dwarves have escaped the Underdark for the promise of a better life on the surface - only to be met with extreme prejudice. Their only hope is now to reclaim their ancient Kingdom of Shanatar and the Wyrmskull Throne - located beneath Tethyr. \n\nECL +2\n\nDoes this describe you?");  
                }
  
				// 5 Gnome subraces (bg_chk_gnome logic)  
                if (GetRacialType(oPC) == RACIAL_TYPE_GNOME) 
				{  
                    AddChoice("Rock Gnome", 24, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_24",  
                        "Rock gnomes are the gnomes that most people are familiar with. When someone refers to a \"gnome\", they are almost certainly refering to a Rock Gnome. Unlike their cousins, Rock Gnomes are found across Faerun and integrate well into the rolling countryside towns found across Tethyr and the Heartlands. Most rock gnomes are friendly and fond of jokes or pranks and find work as technicians, alchemists, and inventors when not found as exceptional Illusionist Wizards.\n\nDoes this describe you?");  
                    AddChoice("Forest Gnome", 25, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_25",  
                        "Forest gnomes are exceptionally shy in comparison to the well-known Rock Gnomes. Often times, Forest Gnomes can live side by side with civilizations without ever being discovered or uncovered. Forest gnomes have a great love for nature and are extremely private, prefering to be left alone whenever possible.\n\nECL +1\n\nDoes this describe you?");  
                    AddChoice("Deep Gnome (Svirfneblin)", 26, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_26",  
                        "The Deep Gnomes are often counted among the evil creatures within the Underdark, however they are no more evil than any other rock gnome common on the surface. Centuries of dealing with the threats and poor conditions of the Underdarked have made them extremely distrustful of outsiders and make their appearance outside of their small communities exceptionally rare.\n\nECL +3\n\nDoes this describe you?");  
                }
  
                // 6 Halfling subraces (bg_chk_halfling logic)  
                if (GetRacialType(oPC) == RACIAL_TYPE_HALFLING) 
				{  
                    AddChoice("Lightfoot Halfling", 27, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_27",  
                        "Most of the halflings encountered in Faerun are the Lightfoot halflings. They are the most numerous and widely traveled group across Faerun. Their behavior is highly varied, and adaptable to whatever society they find themselves in. No lightfoot can be compared with another, because of these widely diverse view points about the world, leadingto a roaming lifestyle where entire families may decide to simply leave on a whim when their minds change.\n\nDoes this describe you?");  
                    AddChoice("Strongheart Halfling", 28, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_28",  
                        "The Strongheart halflings are the clans that decided to remain in their homeland of Luiren. Most Stronghearts will form communities but maintain and nomadic lifestyle within these communities. It is not uncommon for a Strongheart halfling to travel between communities to satisfy some form of wanderlust.\n\nDoes this describe you?");  
                    AddChoice("Ghostwise Halfling", 29, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_29",  
                        "The ghostwise are some of the most uncommon halflings one might encounter in Faerun. Most make their home in the Chondalwood and prefer to pursue a nomadic lifestyle in the forests. Clan loyalty is of the outmost importance to a Ghostwise Halfling, and the most likely reason for seeing a Ghostwise halfling outside of the Chondalwood is expulsion and exile.\n\nDoes this describe you?");  
                }  
                // 8 Other (bg_chk_oth logic)  
                if ((GetRacialType(oPC) == RACIAL_TYPE_HUMAN || GetRacialType(oPC) == RACIAL_TYPE_HALFELF || GetRacialType(oPC) == RACIAL_TYPE_HALFORC) && GetAbilityScore(oPC,ABILITY_CHARISMA, TRUE) >= 11)
				{  
					AddChoice("Tiefling", 30, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_30",  
                        "Because they are descended from evil outsiders, those who know of their ancestry must immediately consider most Tieflings evil and untrustworthy, although this is not always the case. Some tieflings have a minor physical trait suggesting their heritage, such as pointed teeth, red eyes, small horns, the odor of brimstone, cloven feet, or just an unnatural aura of wrongness. Tieflings, like Aasimar, are feared and considered outcasts by most of Tethyrian society.\n\nDoes this describe you?"); 
					
					AddChoice("Aasimar", 31, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_31",  
                        "Carrying the blood of a Celestial, an Aasimar is usually good-aligned and fights against evil in the world. Some have a minor physical trait suggesting their heritage, such as silver hair, golden eyes, or an unnaturally intense stare. Aasimar, like Tieflings, are feared and considered outcasts by most of Tethyrian society.\n\nDoes this describe you?");						
                }    
                MarkStageSetUp(nStage, oPC);      
                SetDefaultTokens();      
            }      
            else if (nStage == STAGE_CONFIRM)     
			{      
                int nSelected = GetLocalInt(oPC, "sub_selected");      
                SetHeader(GetSubraceText(oPC, nSelected) + "\n\nIs this correct?");      
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
            SetLocalInt(oPC, "sub_selected", nChoice);      
            nStage = STAGE_CONFIRM; // update local nStage      
        }      
        else if (nStage == STAGE_CONFIRM)     
		{      
            if (nChoice == 0) { // Yes      sub_selected");
				int nSelected = GetLocalInt(oPC, "sub_selected");		
                object oItem = EnsurePlayerDataObject(oPC);      
                switch (nSelected) 
				{      
                    // Ethnicities  
                    case 1:
					{
						//sGrant = "bg_ethn_other";
						SetLocalInt(oItem,"CC0",ETHNICITY_OTHER);
						SetLocalInt(oItem,"BG_Select",1);
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_OTHER);
						SetPersistantLocalInt(oPC,"BG_Select",1);						
						break;  // Other 					
					}					
                    case 2:
					{
						//sGrant = "bg_ethn_tethyr";
						SetLocalInt(oItem,"CC0",ETHNICITY_TETHYRIAN);
						SetLocalInt(oItem,"BG_Select",2);						
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_TETHYRIAN);
						SetPersistantLocalInt(oPC,"BG_Select",2);						
						break; // Tethyrian 
					}						
                    case 3:
					{
						//sGrant = "bg_ethn_calish";
						SetLocalInt(oItem,"CC0",ETHNICITY_CALISHITE);
						SetLocalInt(oItem,"BG_Select",3);						
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_CALISHITE);
						SetPersistantLocalInt(oPC,"BG_Select",3);						
						break;  // Calishite
					}						
                    case 4:
					{
						//sGrant = "bg_ethn_illusk";
						SetLocalInt(oItem,"CC0",ETHNICITY_ILLUSKAN);
						SetLocalInt(oItem,"BG_Select",4);						
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_ILLUSKAN);
						SetPersistantLocalInt(oPC,"BG_Select",4);
						break;  // Illuskan							
					}
                    case 5:
					{
						//sGrant = "bg_ethn_rashemi";
						SetLocalInt(oItem,"CC0",ETHNICITY_RASHEMI);
						SetLocalInt(oItem,"BG_Select",5);
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_RASHEMI);
						SetPersistantLocalInt(oPC,"BG_Select",5);
						break;  // Rashemi 
					}						
                    case 6:
					{
						//sGrant = "bg_ethn_shou";
						SetLocalInt(oItem,"CC0",ETHNICITY_SHOU);
						SetLocalInt(oItem,"BG_Select",6);						
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_SHOU);
						SetPersistantLocalInt(oPC,"BG_Select",6);
						break;  // Shou  						
					}
                    case 7:
					{
						//sGrant = "bg_ethn_mazti";
						SetLocalInt(oItem,"CC0",ETHNICITY_MAZTILAN);
						SetLocalInt(oItem,"BG_Select",7);
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_MAZTILAN);
						SetPersistantLocalInt(oPC,"BG_Select",7);
						break;  // Maztilan  
					}
                    case 8:
					{
						//sGrant = "bg_ethn_chult";
						SetLocalInt(oItem,"CC0",ETHNICITY_CHULTAN);
						SetLocalInt(oItem,"BG_Select",8);						
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_CHULTAN);
						SetPersistantLocalInt(oPC,"BG_Select",8);
						break;  // Chultan  						
					}
                    case 9:
					{
						//sGrant = "bg_ethn_chond";
						SetLocalInt(oItem,"CC0",ETHNICITY_CHONDATHAN);
						SetLocalInt(oItem,"BG_Select",9);						
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_CHONDATHAN);
						SetPersistantLocalInt(oPC,"BG_Select",9);
						break;  // Chondathan 
					}						
                    case 10:
					{
						//sGrant = "bg_ethn_damar";
						SetLocalInt(oItem,"CC0",ETHNICITY_DAMARAN);
						SetLocalInt(oItem,"BG_Select",10);
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_DAMARAN);
						SetPersistantLocalInt(oPC,"BG_Select",10);
						break;  // Damaran						
					}
                    case 11:
					{
						//sGrant = "bg_ethn_mulan";
						SetLocalInt(oItem,"CC0",ETHNICITY_MULAN);
						SetLocalInt(oItem,"BG_Select",11);						
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_MULAN);
						SetPersistantLocalInt(oPC,"BG_Select",11);
						break;  // Mulan (duplicate)
					}						
                    case 12:
					{
						//sGrant = "bg_ethn_ffolk";
						SetLocalInt(oItem,"CC0",ETHNICITY_FFOLK);
						SetLocalInt(oItem,"BG_Select",12);
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_FFOLK);
						SetPersistantLocalInt(oPC,"BG_Select",12);
						break;  // Ffolk
					}	
                    case 13:
					{
						//sGrant = "bg_ethn_imask";
						SetLocalInt(oItem,"CC0",ETHNICITY_IMASKARI);
						SetLocalInt(oItem,"BG_Select",13);
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_IMASKARI);
						SetPersistantLocalInt(oPC,"BG_Select",13);
						break;  // Imaskari
					}
                    case 14:
					{
						//sGrant = "bg_ethn_mazti";
						SetLocalInt(oItem,"CC0",ETHNICITY_SHAARAN);
						SetLocalInt(oItem,"BG_Select",14);
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_SHAARAN);
						SetPersistantLocalInt(oPC,"BG_Select",14);
						break;  // Shaaran
					}						
  
                    // Elves
                    case 15:
					{
						//sGrant = "bg_give_elfsilv";
						SetLocalInt(oItem,"CC0",BACKGROUND_SILVER_ELF);
						SetLocalInt(oItem,"BG_Select",15);						
						SetPersistantLocalInt(oPC,"CC0",BACKGROUND_SILVER_ELF);
						SetPersistantLocalInt(oPC,"BG_Select",15);
						break;  // Moon Elf						
					}
                    case 16:
					{
						//sGrant = "bg_give_elfgold";
						SetLocalInt(oItem,"CC0",BACKGROUND_GOLD_ELF);
						SetLocalInt(oItem,"BG_Select",16);
						SetPersistantLocalInt(oPC,"CC0",BACKGROUND_GOLD_ELF);
						SetPersistantLocalInt(oPC,"BG_Select",16);
						break;  // Sun Elf 
					}						
                    case 17:
					{
						//sGrant = "bg_give_elfgre";
						SetLocalInt(oItem,"CC0",BACKGROUND_GREEN_ELF);
						SetLocalInt(oItem,"BG_Select",17);
						SetPersistantLocalInt(oPC,"CC0",BACKGROUND_GREEN_ELF);
						SetPersistantLocalInt(oPC,"BG_Select",71);
						break;  // Wild Elf  
					}
                    case 18:
					{
						//sGrant = "bg_give_elfcop";
						SetLocalInt(oItem,"CC0",BACKGROUND_COPPER_ELF);
						SetLocalInt(oItem,"BG_Select",18);
						SetPersistantLocalInt(oPC,"CC0",BACKGROUND_COPPER_ELF);
						SetPersistantLocalInt(oPC,"BG_Select",18);
						break;  // Wood Elf
					}						
                    case 19:
					{
						//sGrant = "bg_give_elfdark";
						SetLocalInt(oItem,"CC0",BACKGROUND_DARK_ELF);
						SetLocalInt(oItem,"BG_Select",19);
						SetPersistantLocalInt(oPC,"CC0",BACKGROUND_DARK_ELF);
						SetPersistantLocalInt(oPC,"BG_Select",19);
						break;  // Dark Elf (Drow)
					}						
                    case 20:
					{
						//sGrant = "bg_give_elffeyri";
						SetLocalInt(oItem,"CC0",ETHNICITY_FEYRI);
						SetLocalInt(oItem,"BG_Select",20);
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_FEYRI);
						SetPersistantLocalInt(oPC,"BG_Select",20);
						break;  // Fey'ri					
					}
					// Dwarves  
                    case 21:
					{
						//sGrant = "bg_give_dwashiel";  
						SetLocalInt(oItem,"CC0",BACKGROUND_SHIELD_DWARF);
						SetLocalInt(oItem,"BG_Select",21);
						SetPersistantLocalInt(oPC,"CC0",BACKGROUND_SHIELD_DWARF);
						SetPersistantLocalInt(oPC,"BG_Select",21);
						break;  // Shield Dwarf  
					}
                    case 22: 
					{
						//sGrant = "bg_give_dwagold";
						SetLocalInt(oItem,"CC0",BACKGROUND_GOLD_DWARF);
						SetLocalInt(oItem,"BG_Select",22);
						SetPersistantLocalInt(oPC,"CC0",BACKGROUND_GOLD_DWARF);
						SetPersistantLocalInt(oPC,"BG_Select",22);
						break;  // Gold Dwarf  
					}
                    case 23:
					{
						//sGrant = "bg_give_dwagrey";
						SetLocalInt(oItem,"CC0",BACKGROUND_GREY_DWARF);
						SetLocalInt(oItem,"BG_Select",23);
						SetPersistantLocalInt(oPC,"CC0",BACKGROUND_GREY_DWARF);
						SetPersistantLocalInt(oPC,"BG_Select",23);
						break;  // Gray Dwarf (Duergar)
					}
                    // Gnomes  
                    case 24:
					{
						//sGrant = "bg_give_gnrock"; 
						SetLocalInt(oItem,"CC0",ETHNICITY_ROCK_GNOME);
						SetLocalInt(oItem,"BG_Select",24);						
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_ROCK_GNOME);
						SetPersistantLocalInt(oPC,"BG_Select",24);
						break;  // Rock Gnome  
					}
                    case 25:
					{
						//sGrant = "bg_give_gnfor";
						SetLocalInt(oItem,"CC0",ETHNICITY_FOREST_GNOME);
						SetLocalInt(oItem,"BG_Select",25);
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_FOREST_GNOME);
						SetPersistantLocalInt(oPC,"BG_Select",25);
						break;  // Forest Gnome
					}						
                    case 26:
					{
						//sGrant = "bg_give_gndeep";  
						SetLocalInt(oItem,"CC0",ETHNICITY_DEEP_GNOME);
						SetLocalInt(oItem,"BG_Select",26);					
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_DEEP_GNOME);
						SetPersistantLocalInt(oPC,"BG_Select",26);
						break;  // Deep Gnome 
					}
					// Halflings  
                    case 27:
					{
						//sGrant = "bg_give_hllight";  
						SetLocalInt(oItem,"CC0",ETHNICITY_LIGHTFOOT);
						SetLocalInt(oItem,"BG_Select",27);						
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_LIGHTFOOT);
						SetPersistantLocalInt(oPC,"BG_Select",27);						
						break;  // Lightfoot 
					}						
                    case 28:
					{
						//sGrant = "bg_give_hlstrong";
						SetLocalInt(oItem,"CC0",ETHNICITY_STRONGHEART);
						SetLocalInt(oItem,"BG_Select",28);						
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_STRONGHEART);
						SetPersistantLocalInt(oPC,"BG_Select",28);
						break;  // Strongheart  
					}
                    case 29: 
					{
						//sGrant = "bg_give_hlghost";
						SetLocalInt(oItem,"CC0",ETHNICITY_GHOSTWISE);
						SetLocalInt(oItem,"BG_Select",29);							
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_GHOSTWISE);
						SetPersistantLocalInt(oPC,"BG_Select",29);
						break;  // Ghostwise  
					}
					// Other races  
                    case 30:
					{
						//sGrant = "bg_give_tiefling";
						SetLocalInt(oItem,"CC0",BACKGROUND_TIEFLING);
						SetLocalInt(oItem,"BG_Select",30);						
						SetPersistantLocalInt(oPC,"CC0",BACKGROUND_TIEFLING);
						SetPersistantLocalInt(oPC,"BG_Select",30);
						break;  // Tiefling
					}						
                    case 31:
					{
						//sGrant = "bg_give_aasimar";
						SetLocalInt(oItem,"CC0",BACKGROUND_AASIMAR);
						SetLocalInt(oItem,"BG_Select",31);						
						SetPersistantLocalInt(oPC,"CC0",BACKGROUND_AASIMAR);
						SetPersistantLocalInt(oPC,"BG_Select",31);
						break;  // Aasimar 
						
					}   
                }      
				AllowExit(DYNCONV_EXIT_FORCE_EXIT, TRUE, oPC);    
				SetPersistantLocalInt(oPC, "CC0_DONE", 1);    
				DelayCommand(0.1f, StartDynamicConversation("bg_soclass_cv", oPC));				    
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


/* 
void main() {    
    object oPC = GetPCSpeaker();   
    object oItem = EnsurePlayerDataObject(oPC); 	  
    SendMessageToPC(oPC, "DEBUG: bg_subrace_cv main() entered");    
    WriteTimestampedLogEntry("DEBUG: bg_subrace_cv main() entered");   
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);    
    int nStage = GetStage(oPC);    
    
    // Required guard: abort if nValue is 0    
    if (nValue == 0) return;    
    
    if (nValue == DYNCONV_SETUP_STAGE)   
    {    
        if (!GetIsStageSetUp(nStage, oPC))   
        {    
            if (nStage == STAGE_LIST)   
            {    
                SetHeader("You will now choose your Subrace or Ethnicity. Subraces will affect what class standings you may be able to choose.\nYou can refresh the list with the Escape key if needed.");    
    
                // 1 Other (unlisted)  
                AddChoice("[Other]", 1, oPC);  
                SetLocalString(oPC, "sub_dyn_text_1",  
                    "My ethnicity or subrace is not listed. I realize that I am likely about to play a concept that is unsupported and not recommended, but I will select this anyway.\n\nDoes this describe you?");  
  
                // 2 Human ethnicities (inline bg_chk_hum logic)  
                if (GetRacialType(oPC) == RACIAL_TYPE_HUMAN || GetRacialType(oPC) == RACIAL_TYPE_HALFELF) 
				{			
                    AddChoice("Tethyrian", 2, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_2",  
                        "The Tethyrian culture is a melting pot of Calishite, Chondathan, Illuskan, and Low Netherese elements. This unique background makes Tethyrians among the most tolerant, though fiercely independent, ethnic groups in Faerun. They inhabit a vast territory stretching from Calimshan to Silverymoon, and from the Sea of Swords to the Sea of Fallen Stars. Tethyrians are of medium build and height, with dusky skin that grows fairer the farther north they dwell. Their hair and eye color vary widely, but brown hair and blue eyes are the most common. Tethyrians are proud of their diverse heritage and protective of their freedom, so they tend to distrust powerful kingdoms and empires.\n\nTethyrians receive Alzhedo as a bonus language automatically.\n\nDoes this describe you?");  
                    
					AddChoice("Calishite", 3, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_3",  
                        "These humans are descended from the slaves of Calimshan's ancient genie lords, form the primary racial stock of the Border Kingdoms, the Lake of Steam cities, the Nelanther Isles, and Calimshan. Shorter and slighter in build than most other humans, Calishites have dusky brown skin, hair, and eyes. they regard themselves as the rightful rulers of all lands south and west of the Sea of Fallen Stars and look upon northern cultures as short-lived barbarian kingdoms barely worthy of notice. Most Calishites seek nothing more than a lifestyle of comfort and the respect of their peers.\n\nCalishites receive Alzhedo as a bonus language automatically.\n\nDoes this describe you?");  
                    
					AddChoice("Illuskan", 4, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_4",  
                        "The seagoing, warlike people of the Sword Coast North, the Trackless Sea, and the Dessarin river valley, Illuskans are fall, fair-skinned folk with blue or steely gray eyes. Among the islands of the Trackless Sea and Icewind Dale, their hair color tends towards blond, red, or light brown. On the mainland south of the Spine of the World, however, raven-black hair is most common. Illuskans are proud, particularly of their ability to survive in the harsh environment of their northern homelands, and they regard most southerners as weak and decadent. Illuskans make their living as farmers, fishers, miners, sailors, raiders, skalds, and runecasters.\n\nThe Illuskans receive Illuskan as a bonus language automatically.\n\nDoes this describe you?");  
                    
					AddChoice("Rashemi", 5, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_5",  
                        "These humans are tough, sturdy, and well adapted to life in the harsh and dangerous northeastern reaches of Faerun. They are descended from the nomadic tribes that won the Orcgate Wars and built the empire of Raumathar. Not only do the Rashemis dominate Rashemen and Thay, they also form significant minorities in Aglarond, the Endless Wastes, Thesk, and the Wizards' Reach region. Rashemis tend to be short, stout, and muscular, and they usually have dusky skin, dark eyes, and thick, black hair. They cherish their strong ties to their land, appreciating its beauty while respecting its harshness. They display little of the arrogance that marks other groups whose ancestors once ruled empires.\n\nRashemi receive Rashemi as a bonus language.\n\nDoes this describe you?");  
                    
					AddChoice("Shou", 6, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_6",  
                        "Little is known of the Shou - and in western Faerun it is assumed that they are the only racial group of the far-distant Kara-Tur. It is rare to see a Shou outside of the far east. Shou have a bronzed-yellow skin tones and typically have black hair with broad, flat features.\n\nShou do not receive any bonus language.\n\nDoes this describe you?");                    
					
					AddChoice("Tashalarran", 7, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_7",  
                        "Members of this ethnic group have dominated the eastern shores of the Sea of Fallen stars since the fall of ancient Ilmaskar. At various times in their long history, they have made up at least the ruling elite of Ashanath, Chessenta, the Eastern Shaar, Murghom, Rashemen, Semphar, Thay, Thesk, and the Wizards' Reach cities south of the Yuirwood. Mulan are generally tall, slim, and sallow-skinned with eyes of hazel or brown. Their hair ranges from black to dark brown, but all nobles and many other Mulan routinely shave off all of their hair. As a race, Mulan are arrogant, conservative, and convinced of their cultural superiority over the rest of Faerun.\n\nMulan receive Mulanese as a bonus language.\n\nDoes this describe you?");  
  
					AddChoice("Chultan", 8, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_8",  
                        "The jungles of Chult are a harsh and unforgiving land that forged together the many disparate tribes of the peninsula into one single culture more than a millennia ago. Most Chultans distrust power and wealth, believing that things that they cannot take with them are ultimately worthless. It is rare to see a Chultan separated from their clan. Chultans are tall and ebony-skinned.\n\nDoes this describe you?"); 
                    
					AddChoice("Chondathan", 9, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_9",  
                        "Descended from the natives of the Vilhon Reach, these hardy folk have spread to settle most of the western and central Inner Sea region and much of the Western Heartlands. Chondathans form the primary racial stock of Altumbel, Cormyr, the southern Dalelands, the Dragon Coast, the Great Dale, Hlondeth and both shores of the Vilhon Reach, the Pirate Isles of the Inner Sea, Sembia, and Sespech. They are slender, tawny-skinned folk with brown hair that ranges from almost blond to almost black. Most are tall and have green or brown eyes, but these traits are hardly universal. \n\nDoes this describe you?"); 						
                    
					AddChoice("Damaran", 10, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_10",  
                        "Proud and stubborn, these humans were born from some scattered remnants of Narfell's fall - primarily groups of Nars, Rashemis, and Sossrims who struggled to survive while waves of Chondathan emigrants settled in the lands of the Easting Reach. These four populations gradually coalesced into a new ethnic group that now makes up the primary racial stock of Damara, Impiltur, Thesk, and the Vast. Damarans are of moderate height and build, with skin hues ranging from tawny to fair. Their hair is usually brown or black, and their eye color varies widely, though brown is most common. Damarans see the world in stark contrasts - unspeakable evil opposed by indomitable and uncompromising good.  \n\nDoes this describe you?");
						
                    AddChoice("Mulan", 11, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_11",  
                        "Members of this ethnic group have dominated the eastern shores of the Sea of Fallen stars since the fall of ancient Ilmaskar. At various times in their long history, they have made up at least the ruling elite of Ashanath, Chessenta, the Eastern Shaar, Murghom, Rashemen, Semphar, Thay, Thesk, and the Wizards' Reach cities south of the Yuirwood. Mulan are generally tall, slim, and sallow-skinned with eyes of hazel or brown. Their hair ranges from black to dark brown, but all nobles and many other Mulan routinely shave off all of their hair. As a race, Mulan are arrogant, conservative, and convinced of their cultural superiority over the rest of Faerun.\n\nMulan receive Mulanese as a bonus language.\n\nDoes this describe you?");
						
					AddChoice("Ffolk", 12, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_12",  
                        "These humans are descended from Tethyrians who migrated from the Western Heartlands to the Moonshae Isles. They are generally hostile to the Illuskans who are seen as invaders to the Moonshae Isles, though, most of the Ffolk speak Illuskan and use the Thorass script. More so than many other cultural groups, the Ffolk are governed by a strong druidical tradition that permeates their society. Due to their Tethyrian heritage, the ffolk tend to have darker skin and hair when compared to Illuskans or Chondathans.\n\nThe Ffolk receive Talfiric as a bonus language automatically.\n\nDoes this describe you?");  
 
                     AddChoice("Imaskari", 13, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_13",  
                        "Before the rise of the Mulan in the great deserts, the Imaskari ruled in a great empire rumored to stretch across the east. But that is all that remains of the Imaskari - rumors and what little of their culture has been preserved by the Mulan.\n\nDoes this describe you?");						
						
                    AddChoice("Shaaran", 14, oPC);  
                    SetLocalString(oPC, "sub_dyn_text_14",  
                        "The Shaarans are the group of humans native to the steepes of the Shaar region. A simple, nomadic culture based on clan loyalty, they were once considered part of the Shoon Imperium before the ancient empire allowed them to rebel in the fifth century. Shaarans are long-faced with a yellow-tanned skin. They speak Shaaran and most do not read or write.\n\nDoes this describe you?");						 
                }
    
                MarkStageSetUp(nStage, oPC);    
                SetDefaultTokens();    
            }   
            else if (nStage == STAGE_CONFIRM)   
            {    
                int nSelected = GetLocalInt(oPC, "sub_selected");    
                SetHeader(GetSubraceText(oPC, nSelected));    
                AddChoice("Yes!", nSelected, oPC);    
                AddChoice("No...", -1, oPC);    
                MarkStageSetUp(nStage, oPC);    
                SetDefaultTokens();    
            }    
            SetupTokens();    
        }    
    }   
    else   
    {  
        SendMessageToPC(oPC, "DEBUG: Handling response, nStage=" + IntToString(nStage) + ", nChoice=" + IntToString(GetChoice(oPC)));	  
        WriteTimestampedLogEntry("DEBUG: Handling response, nStage=" + IntToString(nStage) + ", nChoice=" + IntToString(GetChoice(oPC)));		  
        int nChoice = GetChoice(oPC);    
        if (nStage == STAGE_LIST)   
        {    
            SendMessageToPC(oPC, "DEBUG: STAGE_LIST choice=" + IntToString(nChoice));  
            WriteTimestampedLogEntry("DEBUG: STAGE_LIST choice=" + IntToString(nChoice));  
            SetLocalInt(oPC, "sub_selected", nChoice);   
            nStage = STAGE_CONFIRM; 			  
            SetStage(STAGE_CONFIRM, oPC);    
        }   
        else if (nStage == STAGE_CONFIRM)   
        {  
            SendMessageToPC(oPC, "DEBUG: STAGE_CONFIRM choice=" + IntToString(nChoice));  
            WriteTimestampedLogEntry("DEBUG: STAGE_CONFIRM choice=" + IntToString(nChoice));  
            if (nChoice >= 0)   
            { // "Yes!" - grant the subrace/ethnicity    
                SendMessageToPC(oPC, "DEBUG: STAGE_CONFIRM Yes, sub_selected=" + IntToString(GetLocalInt(oPC, "sub_selected")));  
                WriteTimestampedLogEntry("DEBUG: STAGE_CONFIRM Yes, sub_selected=" + IntToString(GetLocalInt(oPC, "sub_selected")));  
                string sGrant;    
                switch (GetLocalInt(oPC, "sub_selected"))    
                {    
                    // Ethnicities  
                    case 1:
					{
						//sGrant = "bg_ethn_other";
						SetLocalInt(oItem,"CC0",ETHNICITY_OTHER);
						SetLocalInt(oItem,"BG_Select",1);
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_OTHER);
						SetPersistantLocalInt(oPC,"BG_Select",1);						
						break;  // Other 					
					}					
                    case 2:
					{
						//sGrant = "bg_ethn_tethyr";
						SetLocalInt(oItem,"CC0",ETHNICITY_TETHYRIAN);
						SetLocalInt(oItem,"BG_Select",2);						
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_TETHYRIAN);
						SetPersistantLocalInt(oPC,"BG_Select",2);						
						break; // Tethyrian 
					}						
                    case 3:
					{
						//sGrant = "bg_ethn_calish";
						SetLocalInt(oItem,"CC0",ETHNICITY_CALISHITE);
						SetLocalInt(oItem,"BG_Select",3);						
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_CALISHITE);
						SetPersistantLocalInt(oPC,"BG_Select",3);						
						break;  // Calishite
					}						
                    case 4:
					{
						//sGrant = "bg_ethn_illusk";
						SetLocalInt(oItem,"CC0",ETHNICITY_ILLUSKAN);
						SetLocalInt(oItem,"BG_Select",4);						
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_ILLUSKAN);
						SetPersistantLocalInt(oPC,"BG_Select",4);
						break;  // Illuskan							
					}
                    case 5:
					{
						//sGrant = "bg_ethn_rashemi";
						SetLocalInt(oItem,"CC0",ETHNICITY_RASHEMI);
						SetLocalInt(oItem,"BG_Select",5);
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_RASHEMI);
						SetPersistantLocalInt(oPC,"BG_Select",5);
						break;  // Rashemi 
					}						
                    case 6:
					{
						//sGrant = "bg_ethn_shou";
						SetLocalInt(oItem,"CC0",ETHNICITY_SHOU);
						SetLocalInt(oItem,"BG_Select",6);						
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_SHOU);
						SetPersistantLocalInt(oPC,"BG_Select",6);
						break;  // Shou  						
					}
                    case 7:
					{
						//sGrant = "bg_ethn_mulan ";
						SetLocalInt(oItem,"CC0",ETHNICITY_MULAN);
						SetLocalInt(oItem,"BG_Select",7);
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_MULAN);
						SetPersistantLocalInt(oPC,"BG_Select",7);
						break;  // Tashalarran (Mulan)  
					}
                    case 8:
					{
						//sGrant = "bg_ethn_chult";
						SetLocalInt(oItem,"CC0",ETHNICITY_CHULTAN);
						SetLocalInt(oItem,"BG_Select",8);						
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_CHULTAN);
						SetPersistantLocalInt(oPC,"BG_Select",8);
						break;  // Chultan  						
					}
                    case 9:
					{
						//sGrant = "bg_ethn_chond";
						SetLocalInt(oItem,"CC0",ETHNICITY_CHONDATHAN);
						SetLocalInt(oItem,"BG_Select",9);						
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_CHONDATHAN);
						SetPersistantLocalInt(oPC,"BG_Select",9);
						break;  // Chondathan 
					}						
                    case 10:
					{
						//sGrant = "bg_ethn_damar";
						SetLocalInt(oItem,"CC0",ETHNICITY_DAMARAN);
						SetLocalInt(oItem,"BG_Select",10);
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_DAMARAN);
						SetPersistantLocalInt(oPC,"BG_Select",10);
						break;  // Damaran						
					}
                    case 11:
					{
						//sGrant = "bg_ethn_mulan";
						SetLocalInt(oItem,"CC0",ETHNICITY_MULAN);
						SetLocalInt(oItem,"BG_Select",11);						
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_MULAN);
						SetPersistantLocalInt(oPC,"BG_Select",11);
						break;  // Mulan (duplicate)
					}						
                    case 12:
					{
						//sGrant = "bg_ethn_ffolk";
						SetLocalInt(oItem,"CC0",ETHNICITY_FFOLK);
						SetLocalInt(oItem,"BG_Select",12);
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_FFOLK);
						SetPersistantLocalInt(oPC,"BG_Select",12);
						break;  // Ffolk
					}	
                    case 13:
					{
						//sGrant = "bg_ethn_imask";
						SetLocalInt(oItem,"CC0",ETHNICITY_IMASKARI);
						SetLocalInt(oItem,"BG_Select",13);
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_IMASKARI);
						SetPersistantLocalInt(oPC,"BG_Select",13);
						break;  // Imaskari
					}
                    case 14:
					{
						SetLocalInt(oItem,"CC0",ETHNICITY_SHAARAN);
						SetLocalInt(oItem,"BG_Select",14);
						SetPersistantLocalInt(oPC,"CC0",ETHNICITY_SHAARAN);
						SetPersistantLocalInt(oPC,"BG_Select",14);
						break;  // Shaaran
					}							  
  
                    //default: sGrant = ""; break;    
                }  
                //f (sGrant != "") ExecuteScript(sGrant, oPC);    
    
                SetPersistantLocalInt(oPC, "CC0_DONE", 1);  
                AllowExit(DYNCONV_EXIT_FORCE_EXIT, TRUE, oPC);				  
                DelayCommand(0.1f, StartDynamicConversation("bg_soclass_cv", oPC));  
                  
            }   
            else   
            { // "No..." - return to list    
                SendMessageToPC(oPC, "DEBUG: STAGE_CONFIRM No");  
                WriteTimestampedLogEntry("DEBUG: STAGE_CONFIRM No");  
                MarkStageNotSetUp(STAGE_LIST, oPC);    // Mark list stage for rebuilding  
                MarkStageNotSetUp(STAGE_CONFIRM, oPC); // Mark confirm stage for rebuilding  
                SetStage(STAGE_LIST, oPC);    
            }    
        }    
    }    
}
 */