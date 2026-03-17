//::///////////////////////////////////////////////
//::
//:: te_afflic_func.nss
//::
//:: Lands of Intrigue Affliction Function Handler
//:: //:: Function(D20) 2017
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Format Created By: Jonathan Lorentsen
//:: Email: jlorents93@hotmail.com
//:: Created On: 8Jun16
//:: Functions/Scripts By: David Novotny
//:: Email: Raetzain@gmail.com
//:: Created On: 12 Feb 2017
//:://////////////////////////////////////////////
//:: Modified By: LordValinar
//:: Modified On: Nov 03 2023
/*
    Assigned missing CLASS_* constants
    (optional): Find and modify existing scripts
     using the integer and replace with the constant
*/
//:://////////////////////////////////////////////
const int BACKGROUND_LOWER = 1150;
const int BACKGROUND_MIDDLE = 1151;
const int BACKGROUND_UPPER = 1152;
const int BACKGROUND_AFFLUENCE = 1153;
const int BACKGROUND_BRAWLER = 1154;
const int BACKGROUND_COSMOPOLITAN = 1155;
const int BACKGROUND_CRUSADER = 1156;
const int BACKGROUND_DUELIST = 1157;
const int BACKGROUND_EVANGELIST = 1158;
const int BACKGROUND_FORESTER = 1159;
const int BACKGROUND_HARD_LABORER = 1160;
const int BACKGROUND_HEALER = 1161;
const int BACKGROUND_KNIGHT = 1162;
const int BACKGROUND_HEDGEMAGE = 1163;
const int BACKGROUND_MENDICANT = 1164;
const int BACKGROUND_MERCHANT = 1165;
const int BACKGROUND_METALSMITH = 1166;
const int BACKGROUND_MINSTREL = 1167;
const int BACKGROUND_OCCULTIST = 1168;
const int BACKGROUND_SABOTEUR = 1169;
const int BACKGROUND_SCOUT = 1170;
const int BACKGROUND_SNEAK = 1171;
const int BACKGROUND_SOLDIER = 1172;
const int BACKGROUND_TRAVELER = 1173;
const int BACKGROUND_SPELLFIRE = 1174;
const int BACKGROUND_NAT_LYCAN = 1175;
const int BACKGROUND_SHADOW 	= 1176;
const int BACKGROUND_COPPER_ELF = 1177;
const int BACKGROUND_GREEN_ELF = 1178;
const int BACKGROUND_DARK_ELF = 1179;
const int BACKGROUND_SILVER_ELF = 1180;
const int BACKGROUND_GOLD_ELF = 1181;
const int BACKGROUND_GOLD_DWARF = 1182;
const int BACKGROUND_GREY_DWARF = 1183;
const int BACKGROUND_SHIELD_DWARF = 1184;
const int BACKGROUND_OUTSIDER = 1185;
const int BACKGROUND_AASIMAR = 1186;
const int BACKGROUND_TIEFLING = 1187;
const int BACKGROUND_AMN_TRAINED = 1389;
const int BACKGROUND_CALISHITE_TRAINED = 1390;
const int BACKGROUND_CHURCH_ACOLYTE = 1392;
const int BACKGROUND_CARAVANNER = 1391;
const int BACKGROUND_CIRCLE_BORN = 1393;
const int BACKGROUND_ENLIGHTENED_STUDENT = 1394;
const int BACKGROUND_HAREM_TRAINED = 1395;
const int BACKGROUND_HARPER = 1396;
const int BACKGROUND_KNIGHT_SQUIRE = 1397;
const int BACKGROUND_TALFIRIAN = 1398;
const int BACKGROUND_THEOCRAT = 1399;
const int BACKGROUND_WARD_TRIAD = 1400;
const int BACKGROUND_ZHENTARIM = 1401;
const int BACKGROUND_ELDRETH_VELUUTHRA		= 1460;
const int BACKGROUND_ELMANESSE_TRIBE		= 1461;
const int BACKGROUND_SULDUSK_TRIBE			= 1462;
const int BACKGROUND_DUKES_WARBAND			= 1463;
const int BACKGROUND_CALISHITE_SLAVE		= 1464;
const int BACKGROUND_SELDARINE_PRIEST		= 1465;
const int BACKGROUND_HIGH_MAGE				= 1466;
const int BACKGROUND_UNDERDARK_EXILE		= 1467;
const int BACKGROUND_THUNDER_TWIN			= 1468;
const int BACKGROUND_HEIR_TO_THRONE			= 1469;
const int BACKGROUND_MORDINSAMMAN_PRIEST	= 1470;
const int BACKGROUND_WARY_SWORDKNIGHT		= 1471;

const int FEAT_LANGUAGE_ABYSSAL = 1650;
const int FEAT_LANGUAGE_ALZHEDO = 1651;
const int FEAT_LANGUAGE_ANIMAL = 1652;
const int FEAT_LANGUAGE_AQUAN = 1653;
const int FEAT_LANGUAGE_ASSASSINS_CANT = 1654;
const int FEAT_LANGUAGE_AURAN = 1655;
const int FEAT_LANGUAGE_CELESTIAL = 1656;
const int FEAT_LANGUAGE_CHESSENTAN = 1657;
const int FEAT_LANGUAGE_CHONDATHAN = 1658;
const int FEAT_LANGUAGE_CHULTAN = 1659;
const int FEAT_LANGUAGE_DAMARAN = 1660;
const int FEAT_LANGUAGE_DRACONIC = 1661;
const int FEAT_LANGUAGE_DROW = 1662;
const int FEAT_LANGUAGE_DROW_HAND_CANT = 1663;
const int FEAT_LANGUAGE_DRUIDIC = 1664;
const int FEAT_LANGUAGE_DUERGAR = 1665;
const int FEAT_LANGUAGE_DWARVEN = 1666;
const int FEAT_LANGUAGE_ELVEN = 1667;
const int FEAT_LANGUAGE_GIANT = 1668;
const int FEAT_LANGUAGE_GNOMISH = 1669;
const int FEAT_LANGUAGE_GOBLIN = 1670;
const int FEAT_LANGUAGE_HALFLING = 1671;
const int FEAT_LANGUAGE_IGNAN = 1672;
const int FEAT_LANGUAGE_ILLUSKAN = 1673;
const int FEAT_LANGUAGE_IMASKARI = 1674;
const int FEAT_LANGUAGE_INFERNAL = 1675;
const int FEAT_LANGUAGE_LANTANESE = 1677;
const int FEAT_LANGUAGE_MAZTILAN = 1678;
const int FEAT_LANGUAGE_MULANESE = 1679;
const int FEAT_LANGUAGE_MULHORANDI = 1680;
const int FEAT_LANGUAGE_ORCISH = 1681;
const int FEAT_LANGUAGE_RASHEMI = 1682;
const int FEAT_LANGUAGE_SHAARAN = 1683;
const int FEAT_LANGUAGE_SYLVAN = 1684;
const int FEAT_LANGUAGE_TALFIRIC = 1685;
const int FEAT_LANGUAGE_TERRAN = 1686;
const int FEAT_LANGUAGE_THIEVES_CANT = 1687;
const int FEAT_LANGUAGE_TROGLODYTE = 1688;
const int FEAT_LANGUAGE_UNDERCOMMON = 1689;

const int CLASS_TYPE_CURSED_BLOOD = 46;
const int CLASS_TYPE_WARLOCK = 47;
const int CLASS_TYPE_SHADOW_CHANNELER = 48;
const int CLASS_TYPE_SPELLFIRE = 49;
const int CLASS_TYPE_BLIGHTER = 50;
const int CLASS_TYPE_BLACKCOAT = 51;
const int CLASS_TYPE_WARMAGE = 52;
const int CLASS_TYPE_BLADESINGER = 53;
const int CLASS_TYPE_SHADOW_ADEPT = 54;
const int CLASS_TYPE_ELDRITCH_KNIGHT = 55;
const int CLASS_TYPE_MYSTIC_KNIGHT = 56;
const int CLASS_TYPE_ARTIFICER = 57;
const int CLASS_TYPE_MAGEBREAKER = 58;

const int AGE_CATEGORY_YOUTHFUL 	= 1373;
const int AGE_CATEGORY_MIDDLE		= 1374;
const int AGE_CATEGORY_OLD			= 1375;
const int AGE_CATEGORY_VENERABLE	= 1376;

const int DEITY_Akadi = 1304;
const int DEITY_Auril = 1305;
const int DEITY_Azuth = 1306;
const int DEITY_Beshaba = 1307;
const int DEITY_Cyric = 1308;
const int DEITY_Deneir = 1309;
const int DEITY_Gond = 1310;
const int DEITY_Grumbar = 1311;
const int DEITY_Helm = 1312;
const int DEITY_Ibrandul = 1313;
const int DEITY_Ilmater = 1314;
const int DEITY_Ishtisha = 1315;
const int DEITY_Xvim = 1316;
const int DEITY_Kelemvor = 1317;
const int DEITY_Kossuth = 1318;
const int DEITY_Lathander = 1319;
const int DEITY_Leira = 1320;
const int DEITY_Lliira = 1321;
const int DEITY_Loviatar = 1322;
const int DEITY_Malar = 1323;
const int DEITY_Mask = 1324;
const int DEITY_Milil = 1325;
const int DEITY_Mystra = 1326;
const int DEITY_Oghma = 1327;
const int DEITY_Selune = 1328;
const int DEITY_Shar = 1329;
const int DEITY_Shaundakul = 1330;
const int DEITY_Sune = 1331;
const int DEITY_Talona = 1332;
const int DEITY_Talos = 1333;
const int DEITY_Tempus = 1334;
const int DEITY_Torm = 1335;
const int DEITY_Tymora = 1336;
const int DEITY_Tyr = 1337;
const int DEITY_Umberlee = 1338;
const int DEITY_Finder_Wyvernspur = 1339;
const int DEITY_Garagos = 1340;
const int DEITY_Gargauth = 1341;
const int DEITY_Gwaeron_Windstrom = 1342;
const int DEITY_Hoar = 1343;
const int DEITY_Lurue = 1344;
const int DEITY_Nobanion = 1345;
const int DEITY_Red_Knight = 1346;
const int DEITY_Savras = 1347;
const int DEITY_Sharess = 1348;
const int DEITY_Siamorphe = 1349;
const int DEITY_Valkur = 1350;
const int DEITY_Velsharoon = 1351;
const int DEITY_Chauntea = 1352;
const int DEITY_Silvanus = 1353;
const int DEITY_Mielikki = 1354;
const int DEITY_Eldath = 1355;
const int DEITY_Shiallia = 1356;
const int DEITY_Elven_Powers = 1357;
const int DEITY_Underdark_Powers = 1358;
const int DEITY_Dwarven_Powers = 1359;
const int DEITY_Halfling_Powers = 1360;
const int DEITY_Gnomish_Powers = 1361;
const int DEITY_Orcish_Powers = 1362;
const int DEITY_Amaunator = 1363;
const int DEITY_Bane = 1364;
const int DEITY_Bhaal = 1365;
const int DEITY_Jergal = 1366;
const int DEITY_Karsus = 1367;
const int DEITY_Moander = 1368;
const int DEITY_Myrkul = 1369;
const int DEITY_Ulutiu = 1370;
const int DEITY_Waukeen = 1371;

const int ETHNICITY_CALISHITE		= 1381;
const int ETHNICITY_CHONDATHAN		= 1382;
const int ETHNICITY_DAMARAN			= 1383;
const int ETHNICITY_ILLUSKAN		= 1384;
const int ETHNICITY_MULAN			= 1385;
const int ETHNICITY_RASHEMI			= 1386;
const int ETHNICITY_TETHYRIAN		= 1387;
const int ETHNICITY_OTHER			= 1388;
const int ETHNICITY_FFOLK			= 1445;
const int ETHNICITY_CHULTAN			= 1446;
const int ETHNICITY_IMASKARI		= 1447;
const int ETHNICITY_MAZTILAN		= 1448;
const int ETHNICITY_SHAARAN			= 1450;
const int ETHNICITY_SHOU			= 1451;
const int ETHNICITY_DEEP_GNOME		= 1452;
const int ETHNICITY_FOREST_GNOME	= 1453;
const int ETHNICITY_ROCK_GNOME		= 1454;
const int ETHNICITY_GHOSTWISE		= 1455;
const int ETHNICITY_LIGHTFOOT		= 1456;
const int ETHNICITY_STRONGHEART		= 1457;
const int ETHNICITY_FEYRI			= 1458;
const int ETHNICITY_ELMANESSE		= 1461;

const int PROFICIENCY_HISTORY        = 1426;
const int PROFICIENCY_ASTROLOGY      = 1427;
const int PROFICIENCY_DECIPHER       = 1428;
const int PROFICIENCY_SIEGE          = 1429;
const int PROFICIENCY_FIRE           = 1430;
const int PROFICIENCY_HERBALISM      = 1431;
const int PROFICIENCY_ARMORING       = 1432;
const int PROFICIENCY_CARPENTRY      = 1433;
const int PROFICIENCY_TAILORING      = 1434;
const int PROFICIENCY_MASONRY        = 1435;
const int PROFICIENCY_MINING         = 1436;
const int PROFICIENCY_HUNTING        = 1437;
const int PROFICIENCY_WOOD_GATHERING = 1438;
const int PROFICIENCY_TRACKING       = 1439;
const int PROFICIENCY_ANATOMY        = 1480;
const int PROFICIENCY_ALCHEMY        = 1481;
const int PROFICIENCY_DISGUISE       = 1482;
const int PROFICIENCY_GUNSMITHING    = 1483;
const int PROFICIENCY_OBSERVATION    = 1484;
const int PROFICIENCY_SMELTING       = 1485;

const int DISABILITY_ONE_ARMED		= 2000;


#include "loi_functions"
//Apply Affliction Skins/Tools
//oPC - Target PC
//  None = 0, Werewolf = 1, Vampire Thrall 2,
//  Vampire = 3, Vampire Drider = 4, Revenant = 5
//  Drider = 6, Lich = 7 Vampiric Mist = 8
void Affliction_Items(object oPC, int nAffliction);

//Checks if target is immune to vampirism.
//oPC - Target PC
int GetIfImmuneVampirism(object oPC);

//Calculates  the ECL of a target and returns.
int Calc_ECL(object oPC);

//Returns module variable associated with XP gains.
int DetermineXPRate(int iXPRate);

//Gets the XP bonus associated with being a certain class.
int GetXPBonus(object oPC);

// Returns the caster level taking into account all of a PC's
// Spellcasting levels.
// Counts: Assassin, Bard, Blackcoat, Cleric, Druid, Paladin,
//        Palemaster, Shadow Adept, Sorcerer, Warlock, Wizard
int GetAllCasterLevel(object oPC);

//Returns whether a target creature is undead or not.
int GetIsUndead(object oPC);

void Affliction_Items(object oPC, int nAffliction)
{
    object oItem, oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    DestroyObject(oSkin);

    int i; for(i=8042; i<=8049; i++)
    {
        oItem = GetItemPossessedBy(oPC,"te_item_"+IntToString(i));
        if (GetIsObjectValid(oItem)) DestroyObject(oItem);
    }
    oItem = GetItemPossessedBy(oPC, "te_crims_hide");
    if (GetIsObjectValid(oItem)) DestroyObject(oItem);
    oItem = GetItemPossessedBy(oPC, "te_driderskin");
    if (GetIsObjectValid(oItem)) DestroyObject(oItem);
    oItem = GetItemPossessedBy(oPC, "te_dridervskin");
    if (GetIsObjectValid(oItem)) DestroyObject(oItem);

    SetPCAffliction(oPC, nAffliction);
    switch (nAffliction)
    {
        case 2: oItem = CreateItemOnObject("te_item_8042",oPC);   break;
        case 3: oItem = CreateItemOnObject("te_item_8043",oPC);   break;
        case 4: oItem = CreateItemOnObject("te_dridervskin",oPC); break;
        case 5: oItem = CreateItemOnObject("te_item_8045",oPC);   break;
        case 6: oItem = CreateItemOnObject("te_driderskin",oPC);  break;
        case 7: oItem = CreateItemOnObject("te_item_8049",oPC);   break;
        case 8: oItem = CreateItemOnObject("te_crims_hide",oPC);  break;
        default: oItem = CreateItemOnObject("x3_it_pchide",oPC);  break; // default PC Skin
    }
    AssignCommand(oPC, ClearAllActions(TRUE));
    SetIdentified(oItem, TRUE);
    DelayCommand(0.2, AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_CARMOUR)));
}

int GetIfImmuneVampirism(object oPC)
{
    if (GetHasFeat(1175, oPC)) return TRUE;
    if (GetLevelByClass(CLASS_TYPE_PALADIN, oPC) >= 1) return TRUE;
    return FALSE;
}

int Calc_ECL(object oPC)
{
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");
    int iECL1 = GetLocalInt(oItem, "PC_ECL");
    int iECL2 = GetLocalInt(oItem, "PC_ECL2");

    return iECL1+iECL2;
}

int DetermineXPRate(int iXPRate)
{
    return 50;
    /* -- Disabled for now, return static value of 50 -- *
    int i;
    switch(iXPRate)
    {
        case 1: //Deserts
        {
            i = GetLocalInt(GetModule(),"iDesertXP");
            break;
        }
        case 2: //Plains
        {
            i = GetLocalInt(GetModule(),"iPlainXP");
            break;
        }
        case 3: //Hills
        {
            i = GetLocalInt(GetModule(),"iHillXP");
            break;
        }
        case 4: //Marshes
        {
            i = GetLocalInt(GetModule(),"iMarshXP" );
            break;
        }
        case 5: //Forests
        {
            i = GetLocalInt(GetModule(),"iForestXP");
            break;
        }
        case 6: //Crypts
        {
            i = GetLocalInt(GetModule(),"iCryptXP");
            break;
        }
        case 7: //Roads
        {
            i = GetLocalInt(GetModule(),"iRoadXP");
            break;
        }
        case 8: //Towns
        {
            i = GetLocalInt(GetModule(),"iTownXP");
            break;
        }
        case 9: //Temples
        {
            i = GetLocalInt(GetModule(),"iTempleXP");
            break;
        }
        case 10: //Secret Areas
        {
            i = GetLocalInt(GetModule(),"iSecretXP");
            break;
        }
        case 11: //Taverns
        {
            i = GetLocalInt(GetModule(),"iTavernXP");
            break;
        }
        case 12: //Keeps
        {
            i = GetLocalInt(GetModule(),"iKeepXP");
            break;
        }
        case 13: //Low Gain Magical
        {
            i = GetLocalInt(GetModule(),"iMagicXP");
            break;
        }
        default:
        {
            i = GetLocalInt(GetModule(),"iDefXP");
            break;
        }
   }
   return i; /**/
}

int GetXPBonus(object oPC)
{
    int returnval = 0;
    if (GetHasFeat(BACKGROUND_COSMOPOLITAN, oPC))   returnval = returnval + 5;
    if (GetHasFeat(BACKGROUND_EVANGELIST, oPC))     returnval = returnval + 5;
    if (GetHasFeat(BACKGROUND_MENDICANT,oPC))       returnval = returnval + 5;
    if (GetHasFeat(BACKGROUND_MINSTREL,oPC))        returnval = returnval + 5;
    if (GetHasFeat(BACKGROUND_OCCULTIST,oPC))       returnval = returnval + 5;
    if (GetLevelByClass(CLASS_TYPE_BARD, oPC) >= 3) returnval = returnval + 5;
    if (GetHasFeat(2000, oPC))                      returnval = returnval + 5;
    return returnval;
}

int GetAllCasterLevel(object oPC)
{
    int nCasterLevel = 0;
    nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER,oPC);
    nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_ASSASSIN,oPC);
    nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_BARD,oPC);
    nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_BLACKGUARD,oPC);
    nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_CLERIC,oPC);
    nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_DRUID,oPC);
    nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_HARPER,oPC);
    nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_PALADIN,oPC);
    nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_PALE_MASTER,oPC);
    nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_RANGER,oPC);
    nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_SORCERER,oPC);
    nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_WIZARD,oPC);
    nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_ARTIFICER,oPC);
    nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_BLACKCOAT,oPC);
    nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_BLADESINGER,oPC);
    nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_BLIGHTER,oPC);
    nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT,oPC);
    nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_SPELLFIRE,oPC);
    nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_WARMAGE,oPC);
    nCasterLevel = nCasterLevel + GetLevelByClass(CLASS_TYPE_WARLOCK,oPC);
    return nCasterLevel;
}

//Returns whether a target creature is undead or not.
int GetIsUndead(object oPC)
{
    if (GetRacialType(oPC) == RACIAL_TYPE_UNDEAD) return TRUE;
    if (GetLevelByClass(CLASS_TYPE_UNDEAD,oPC) >= 1) return TRUE;
    if (GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"), "iUndead") == 1) return TRUE;
    return FALSE;
}
