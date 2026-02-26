// Modified by LordValinar
// - 11/03/2023 : included new functions
// - 01/16/2024 : code cleanup on various functions

// Using 3.x XP system, determines the XP amount to get to nLevel
// - Returns the XP amount for nLevel
int GetXPToLevel(int nLevel);
int GetXPToLevel(int nLevel)
{
    return ((nLevel * (nLevel - 1)) / 2) * 1000;
}

// Removes just enough XP from oTarget
// - bCanLoseLevel: If TRUE, nXP loss can de-level oTarget
void TakeXPFromCreature(int nXP, object oTarget, int bCanLoseLevel = FALSE);
void TakeXPFromCreature(int nXP, object oTarget, int bCanLoseLevel = FALSE)
{
    if (nXP > 0)
    {
        int nMin = GetXPToLevel(GetHitDice(oTarget));
        int nNewXP = GetXP(oTarget) - nXP;
        if (!bCanLoseLevel && nNewXP < nMin) nNewXP = nMin;
        SetXP(oTarget, nNewXP);
    }
}

// Returns timestamp in days
// * Standard NWN days is 336 per year, 28 per month
int To_Days();
int To_Days()
{
    return (GetCalendarYear()*336) + (GetCalendarMonth()*28) + GetCalendarDay();
}

//::///////////////////////////////////////////////
//:: Lands of Intrigue Function Handler
//:: //:: Function(D20) 2016
//:://////////////////////////////////////////////
/*
    Instructions: Add below string at beginning of script for functions
        #include "loi_functions"

    Table of Contents
    2. CONSTANTS LIST
        1.1
        1.2 SubRace & Affliction Constants

        2.1 Regular Commands
                GetWaypointLocation
                TeleportObjectToObject
                TeleportObjectToLocation
        2.2 PCData Commands
                GetPCAffliction
                GetPCDeadStatus
                GetPCSubRace
                SetPCAffliction
                SetPCDeadStatus
                SetPCSubRace
        2.3 Death/Respawn Commands
                CreatePCBody
                DestroyPCBody
                EventRevivePCBody
                GetPCBodyOwner
        2.4 Placeable Commands
                GetIsPickable
                GetIsPlaceable
                GetIsTurnable
                GetPlaceableType
                EventPlacePlaceable
                EventTakePlaceable
                EventUsePlaceable
                SetIsPickable - Not Done
                SetIsTurnable - Not Done
                SetPlaceableType - Not Done
    3. FUNCTION LIST
        3.1 Regular Functions
                GetWaypointLocation
                TeleportObject
        3.2 PCData Functions
                GetPCAffliction
                GetPCDeadStatus
                GetPCSubRace
                SetPCAffliction
                SetPCDeadStatus
                SetPCSubRace
        3.3 Death/Respawn Functions
                CreatePCBody
                GetPCBodyOwner
*/
//:://////////////////////////////////////////////
//:: Created By: Jonathan Lorentsen
//:: Email: jlorents93@hotmail.com
//:: Created On: 8Jun16
//:://////////////////////////////////////////////

//:://////////////////////////////////////////////
/*
1. CONSTANTS
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//::1.1 Placeholder
//:://////////////////////////////////////////////

//:://////////////////////////////////////////////
//::1.2 Affliction & SubRace Constants
//:://////////////////////////////////////////////
//AFFLICTION
const int PC_AFFLICTION_NONE = 0;
const int PC_AFFLICTION_WEREWOLF = 1;
const int PC_AFFLICTION_VAMPIRE_THRALL= 2;
const int PC_AFFLICTION_VAMPIRE = 3;
const int PC_AFFLICTION_VAMPIRE_DRIDER = 4;
const int PC_AFFLICTION_REVENANT = 5;
const int PC_AFFLICTION_DRIDER = 6;
const int PC_AFFLICTION_LICH = 7;

//SUBRACE
const int PC_SUBRACE_NONE = 0;
const int PC_SUBRACE_LYCAN = 1;
const int PC_SUBRACE_COPPER_ELF = 2;
const int PC_SUBRACE_GREEN_ELF = 3;
const int PC_SUBRACE_DARK_ELF = 4;
const int PC_SUBRACE_SILVER_ELF = 5;
const int PC_SUBRACE_GOLD_ELF = 6;
const int PC_SUBRACE_GOLD_DWARF = 7;
const int PC_SUBRACE_GREY_DWARF = 8;
const int PC_SUBRACE_SHIELD_DWARF = 9;
const int PC_SUBRACE_AASIMAR = 10;
const int PC_SUBRACE_TIEFLING = 11;

//:://////////////////////////////////////////////
//::1.3 Placeable Constants
//:://////////////////////////////////////////////
const int PLACEABLE_TYPE_NORMAL = 0;
const int PLACEABLE_TYPE_CHAIR = 1;
const int PLACEABLE_TYPE_LIGHTSOURCE = 2;
const int PLACEABLE_TYPE_SIGN = 3;
const int PLACEABLE_TYPE_CONTAINER = 4;
const int PLACEABLE_TYPE_SIEGE = 5;

#include "gs_inc_fixture"

//:://////////////////////////////////////////////
/*
2. COMMAND LIST
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//::2.1 Regular Commands
//:://////////////////////////////////////////////

//Get Waypoint Location
//sTag - Waypoint Tag
//Returns Location of Waypoint by Tag
location GetWaypointLocation(string sTag);

//Teleport Object to Location
//oTarget - Target Object
//ldestination - Target Destination
void TeleportObjectToLocation(object oTarget, location lDestination);

//Teleport Object to Object
//oTarget - Target Object
//ldestination - Target Destination
void TeleportObjectToObject(object oTarget, object oObject);

//:://////////////////////////////////////////////
//::2.2 PCData Commands
//:://////////////////////////////////////////////

//Get PC Affliction Status
//oPC - oTargetPC
//Returns int
//  None = 0, Werewolf = 1, Vampire Thrall 2,
//  Vampire = 3, Vampire Drider = 4, Revenant = 5
//  Drider = 6, Lich = 7 Vampiric Mist = 8
//*PC_Data_Object - int iPCAffliction
int GetPCAffliction(object oPC);

//Get PC Dead Status
//oTargetPC - Target PC
//ReturnsDeadStatus
//  0 = Alive
//  1 = Dead
//  2 = ???
//*PC_Data_Object - int iPCDead
int GetPCDeadStatus(object oTargetPC);

//Get PC SubRace Status
//oPC - oTargetPC
//Returns int
//  None = 0, Natual Lycan = 1, Copper Elf = 2,
//  Green Elf = 3, Dark Elf = 4, Silver Elf = 5,
//  Gold Elf = 6, Gold Dwarf = 7, Grey Dwarf = 8,
//  Shield Dwarf = 9, Aasimar = 10, Tiefling = 11
//*PC_Data_Object - int iPCSubRace
int GetPCSubRace(object oPC);

//Set PC Affliction Status
//oTargetPC - Target PC
//nType - Status
//  None = 0, Werewolf = 1, Vampire Thrall 2,
//  Vampire = 3, Vampire Drider = 4, Revenant = 5
//  Drider = 6, Lich = 7, Vampiric Mist = 8
//*PC_Data_Object - int iPCAffliction
void SetPCAffliction(object oTargetPC, int nType);

//Set PC Dead Status
//oTargetPC - Target PC
//nType - Status
//  0 = Alive
//  1 = Dead
//*PC_Data_Object - int iPCDead
void SetPCDeadStatus(object oTargetPC, int nType);

//Set PC SubRace Status
//oTargetPC - Target PC
//nType - Status
//  None = 0, Natual Lycan = 1, Copper Elf = 2,
//  Green Elf = 3, Dark Elf = 4, Silver Elf = 5,
//  Gold Elf = 6, Gold Dwarf = 7, Grey Dwarf = 8,
//  Shield Dwarf = 9, Aasimar = 10, Tiefling = 11
//*PC_Data_Object - int iPCSubRace
void SetPCSubRace(object oTargetPC, int nType);

//:://////////////////////////////////////////////
//::2.3 Death/Respawn Commands
//:://////////////////////////////////////////////

//Create PC Corpse
//oPC - Target PC
//Places PC Corpse at PC Location
void CreatePCBody(object oPC, int nGoldPenalty=FALSE);


//Destroy PC Corpse
//oPC - Target PC
void DestroyPCBody(object oPC);

//Revive PC Corpse
//oTarget - Target Object
//oReviver - Sends Message to Reviver
void EventRevivePCBody(object oTarget, object oReviver=OBJECT_INVALID);

//Get PC Corpse Owner
//oPC - Target PC
//Returns object
object GetPCBodyOwner(object oTarget);

//:://////////////////////////////////////////////
//::2.4 Placeable Commands
//:://////////////////////////////////////////////

//Returns 1 if Pickable
//* "iPick" Variable from Object
int GetIsPickable(object oObject);

//Returns 1 if Placeable
//* "iDrop" Variable from Item
int GetIsPlaceable(object oItem);

//Returns 1 if Turnable
//* "iTurn" Variable from Object
int GetIsTurnable(object oObject);

//Return Placeable Type
//PLACEABLE_TYPE_NORMAL = 0, PLACEABLE_TYPE_CHAIR = 1
//PLACEABLE_TYPE_LIGHTSOURCE = 2, PLACEABLE_TYPE_SIGN = 3
//PLACEABLE_TYPE_CONTAINER = 4, PLACEABLE_TYPE_SIEGE = 5
//* "iType" Variable from Object
int GetPlaceableType(object oObject);

//Fires Place Event
//Instructions: Add to OnPlayerUnaq Module Script
//Ensure Item (TAG) & Placeable (Blueprint Resref) is same
//Add Variable "iDrop = 1" into the Item
//Note: Refrain using with Stackable Items, buggy/won't fire or consume all stacks.
void EventPlacePlaceable(object oPC, object oItem);

//Fires Take Event
//Instructions: Ensure Item (TAG) & Placeable (Blueprint Resref) is same
void EventTakePlaceable(object oPC);

//Fires Conversation from Object
//Instructions: Add to Placeable's OnUsedscript to Use Object.
//oPC - Target PC
//oObject - Conversating Object
//sDialogResRef - Conversationg Dialogue ResRef
void EventUsePlaceable(object oPC, object oObject, string sDialogResRef="");

//Create PC Corpse
//oPC - Target PC
//Places PC Corpse at DM Location
void DM_CreatePCBody(object oPC, location lDM);

//Gets the first free placeable slot in the area "array" of 20 values. Will return first free slot.
int GetFreePlaceableSlot(object oArea);

//Respawn as normal in Maus.
void EventRespawnSafePCBody(object oTarget, object oReviver=OBJECT_INVALID);

//Respawn if no body found.
void EventRespawnSafeNoBody(object oPC);
//:://////////////////////////////////////////////
/*
3. COMMAND FUNCTION
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//::3.1 Regular Functions
//:://////////////////////////////////////////////

//Get Nearest PC

//Get Waypoint Location
location GetWaypointLocation(string sTag)
{
    //Declare major variables
    object oTarget = GetWaypointByTag(sTag);

    //Function
    return GetLocation(oTarget);
}

//Teleport Object to Location
void TeleportObjectToLocation(object oTarget, location lDestination)
{
    //Function
    AssignCommand(oTarget, ClearAllActions());
    AssignCommand(oTarget, JumpToLocation(lDestination));
}

//Teleport Object to Object
void TeleportObjectToObject(object oTarget, object oObject)
{
    //Function
    location lDestination = GetLocation(oObject);
    TeleportObjectToLocation(oTarget, lDestination);
}

//:://////////////////////////////////////////////
//::3.2 PCData Functions
//:://////////////////////////////////////////////

//Get PC SubRace Status
int GetPCAffliction(object oPC)
{
    //Declare major variables
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");

    //Function
    return GetLocalInt(oItem, "iPCAffliction");
}

//Get PC Dead Status
int GetPCDeadStatus(object oTargetPC)
{
    //Declare major variables
    object oItem = GetItemPossessedBy(oTargetPC, "PC_Data_Object");

    //Function
    return GetLocalInt(oItem, "iPCDead");
}

//Get PC SubRace Status
int GetPCSubRace(object oPC)
{
    //Declare major variables
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");

    //Function
    return GetLocalInt(oItem, "iPCSubrace");
}
//Set PC Affliction Status
void SetPCAffliction(object oTargetPC, int nType)
{
    // Code cleanup (LordValinar 01/16/2024)
    object oItem = GetItemPossessedBy(oTargetPC, "PC_Data_Object");
    SetLocalInt(oItem, "iPCAffliction", nType);
    switch (nType)
    {
        case 3: SetLocalInt(oItem,"iUndead", 1); SetLocalInt(oItem,"PC_ECL2",4); break;
        case 4: SetLocalInt(oItem, "iUndead", 1); SetLocalInt(oItem,"PC_ECL2",8); break;
        case 5: SetLocalInt(oItem, "iUndead", 1); SetLocalInt(oItem,"PC_ECL2",4); break;
        case 6: SetLocalInt(oItem, "iUndead", 0); SetLocalInt(oItem,"PC_ECL2",4); break;
        case 7: SetLocalInt(oItem, "iUndead", 1); SetLocalInt(oItem,"PC_ECL2",4); break;
        case 8: SetLocalInt(oItem, "iUndead", 1); SetLocalInt(oItem,"PC_ECL2",13); break;
        default: SetLocalInt(oItem,"iUndead",0); SetLocalInt(oItem,"PC_ECL2", 0); break;
    }
}

//Set PC Dead Status
void SetPCDeadStatus(object oTargetPC, int nType)
{
    //Declare major variables
    object oItem = GetItemPossessedBy(oTargetPC, "PC_Data_Object");

    //Function
    SetLocalInt(oItem, "iPCDead", nType);
}

//Set PC SubRace Status
void SetPCSubRace(object oTargetPC, int nType)
{
    //Declare major variables
    object oItem = GetItemPossessedBy(oTargetPC, "PC_Data_Object");

    //Function
    SetLocalInt(oItem, "iPCSubrace", nType);
}

//:://////////////////////////////////////////////
//::3.3 Death/Respawn Functions
//:://////////////////////////////////////////////

//Create PC Corpse
void CreatePCBody(object oPC, int nGoldPenalty=FALSE)
{
    //Declare major variables
    string sPCName = GetName(oPC);
    string sBodyID = ObjectToString(oPC)+"BODY";
    object oDupe = GetObjectByTag(sBodyID);
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");
    location lPC = GetLocation(oPC);

    //Function
    //Destroy Duplicate, Create Body, Change Name, Store Owner, Drop Gold
    DestroyObject(oDupe);
    object oBody = CreateObject(OBJECT_TYPE_PLACEABLE, "PCBody", lPC, FALSE, sBodyID);
    SetName(oBody, sPCName+"'s Body");
    SetLocalObject(oBody, "oOwner", oPC);
    SetLocalObject(oItem, "oCorpse", oBody);

    if (GetObjectType(oBody) == OBJECT_TYPE_PLACEABLE)
    {
        gsFXSaveFixture(GetTag(GetArea(oBody)),oBody);
    }

    //Gold Penalty Switch
    if (nGoldPenalty == TRUE)
    {
        AssignCommand(oBody, TakeGoldFromCreature(GetGold(oPC), oPC));
        int nSlot = Random(11);
        object oCopy, oDrop = GetItemInSlot(nSlot, oPC);
        if (GetIsObjectValid(oDrop))
        {
            AssignCommand(oPC, ActionUnequipItem(oDrop));
            DelayCommand(0.2, AssignCommand(oBody, ActionTakeItem(oDrop, oPC)));
//            oCopy = CopyItem(oDrop, oBody, TRUE);
//            DestroyObject(oDrop, 0.1);
        }
    }

    object oStain = CreateObject(OBJECT_TYPE_PLACEABLE, "te_deathstain", lPC, FALSE);
    SetLocalObject(oStain, "oOwner", oPC);
    SetLocalString(oStain, "sName", sPCName);

    // Timestamp corpse (for any resuscitation attempts)
    int nTimestamp = (To_Days() * 24) + GetTimeHour();
    SetLocalInt(oBody, "nTimeOfDeath", nTimestamp);
}

//Create PC Corpse
void CreateUndeadPCBody(object oPC, int nGoldPenalty)
{
    //Declare major variables
    string sPCName = GetName(oPC);
    string sBodyID = ObjectToString(oPC)+"BODY";
    object oDupe = GetObjectByTag(sBodyID);
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");
    location lPC = GetLocation(oPC);

    //Function
    //Destroy Duplicate, Create Body, Change Name, Store Owner, Drop Gold
    DestroyObject(oDupe);
    object oBody = CreateObject(OBJECT_TYPE_PLACEABLE, "UNDBody", lPC, FALSE, sBodyID);
    SetName(oBody, sPCName+"'s Ashes");
    SetLocalObject(oBody, "oOwner", oPC);
    SetLocalObject(oItem, "oCorpse", oBody);
    SetLocalInt(oBody, "iUndead", 1);

    if (GetObjectType(oBody) == OBJECT_TYPE_PLACEABLE)
    {
        gsFXSaveFixture(GetTag(GetArea(oBody)),oBody);
    }

    //Gold Penalty Switch
    if (nGoldPenalty == TRUE)
    {
        AssignCommand(oBody, TakeGoldFromCreature(GetGold(oPC), oPC));
        int nSlot = Random(11);
        object oCopy, oDrop = GetItemInSlot(nSlot,oPC);
        if (GetIsObjectValid(oDrop))
        {
            AssignCommand(oPC, ActionUnequipItem(oDrop));
            DelayCommand(0.2, AssignCommand(oBody, ActionTakeItem(oDrop, oPC)));
//            oCopy = CopyItem(oDrop, oBody, TRUE);
//            DestroyObject(oDrop, 0.1);
        }
    }
}


//Destroy PC Corpse
void DestroyPCBody(object oPC)
{
    //Declare major variables
    string sBodyID = ObjectToString(oPC)+"BODY";
    object oBody = GetObjectByTag(sBodyID);
    gsFXDeleteFixture(GetTag(GetArea(oBody)),oBody);
    DestroyObject(oBody);
}

//Revive living PC Body
void EventRevivePCBody(object oTarget, object oReviver=OBJECT_INVALID)
{
    //Declare major variables
    effect eEffect = EffectVisualEffect(VFX_IMP_RAISE_DEAD);
    location lTarget = GetLocation(oTarget);
    object oTargetPC = GetPCBodyOwner(oTarget);
    object oItem = GetItemPossessedBy(oTargetPC, "PC_Data_Object");

    //Functions
    if (GetLocalInt(oTarget, "PCBody") == 1 && GetIsObjectValid(oTargetPC) && GetLocalInt(oTarget,"iUndead") != 1)
    {
        if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
        {
            gsFXDeleteFixture(GetTag(GetArea(oTarget)),oTarget);
        }
        if (GetAreaFromLocation(lTarget) == OBJECT_INVALID)
        {
            lTarget = GetLocation(GetItemPossessor(oTarget));
        }
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEffect, lTarget);
        DestroyObject(oTarget);
        SetPCDeadStatus(oTargetPC, 0);
        SetLocalInt(oItem, "ShoonAfflic", 0);
        int iHD = GetHitDice(oTargetPC);
        int iXP = GetXP(oTargetPC);
        int iXPPen = iHD*50; // original: iHD*500
        if ( GetHasFeat(1158,oTargetPC) || // Background: Evangelist
             GetHasFeat(1156,oTargetPC) || // Background: Crusader
             GetHasFeat(1168,oTargetPC) || // Background: Occultist
             GetHasFeat(1392,oTargetPC) || // Background: Church Acolyte
             GetHasFeat(1399,oTargetPC) || // Background: Theocrat
             GetHasFeat(1400,oTargetPC) || // Background: Ward Triad
             GetHasFeat(1465,oTargetPC) || // Background: Seldarine Priest
             GetHasFeat(1468,oTargetPC) || // Background: Thunder Twin
             GetHasFeat(1469,oTargetPC) || // Background: Heir to Throne
             GetHasFeat(1470,oTargetPC) || // Background: Mordinsanman Priest
             GetHasFeat(1471,oTargetPC))   // Background: Wary Swordknight
        {
            iXPPen = iHD*25; // original: iHD*250
        }

        if (GetHitDice(oTargetPC) <= 5)
        {
            iXPPen = 0;
        }

        /* New method (LordValinar 11/03/2023): Prevents de-leveling
        Removed :: SetXP(oTargetPC, iXP - iXPPen); */
        TakeXPFromCreature(iXPPen, oTargetPC);
        TeleportObjectToLocation(oTargetPC, lTarget);
    }
    else
    {
        SendMessageToPC(oReviver, "Invalid Object or Player Unavailable");
    }
}

//Revive living PC Body
void EventResurrectPCBody(object oTarget, object oReviver=OBJECT_INVALID)
{
    //Declare major variables
    effect eEffect = EffectVisualEffect(VFX_IMP_RAISE_DEAD);
    location lTarget = GetLocation(oTarget);
    object oTargetPC = GetPCBodyOwner(oTarget);
    object oItem = GetItemPossessedBy(oTargetPC, "PC_Data_Object");

    //Functions
    if (GetLocalInt(oTarget, "PCBody") == 1 && GetIsObjectValid(oTargetPC) && GetLocalInt(oTarget,"iUndead") != 1)
    {
        if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
        {
            gsFXDeleteFixture(GetTag(GetArea(oTarget)),oTarget);
        }
        if (GetAreaFromLocation(lTarget) == OBJECT_INVALID)
        {
            lTarget = GetLocation(GetItemPossessor(oTarget));
        }
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEffect, lTarget);
        DestroyObject(oTarget);
        SetLocalInt(oItem, "ShoonAfflic", 0);
        SetPCDeadStatus(oTargetPC, 0);
        int iHD = GetHitDice(oTargetPC);
        int iXP = GetXP(oTargetPC);
        int iXPPen = 0; // original: iHD*1000
        /* -- Old Code -- *
        if ( GetHasFeat(1158,oTargetPC) || // Background: Evangelist
             GetHasFeat(1156,oTargetPC) || // Background: Crusader
             GetHasFeat(1168,oTargetPC) || // Background: Occultist
             GetHasFeat(1392,oTargetPC) || // Background: Church Acolyte
             GetHasFeat(1399,oTargetPC) || // Background: Theocrat
             GetHasFeat(1400,oTargetPC) || // Background: Ward Triad
             GetHasFeat(1465,oTargetPC) || // Background: Seldarine Priest
             GetHasFeat(1468,oTargetPC) || // Background: Thunder Twin
             GetHasFeat(1469,oTargetPC) || // Background: Heir to Throne
             GetHasFeat(1470,oTargetPC) || // Background: Mordinsanman Priest
             GetHasFeat(1471,oTargetPC))   // Background: Wary Swordknight
        {
            iXPPen = iHD*50; // original: iHD*500
        }

        if (GetHitDice(oTargetPC) <= 5)
        {
            iXPPen = 0;
        }/**/

        /* New method (LordValinar 11/03/2023): Prevents de-leveling
        Removed :: SetXP(oTargetPC, iXP - iXPPen); */
        TakeXPFromCreature(iXPPen, oTargetPC);
        TeleportObjectToLocation(oTargetPC, lTarget);
    }
    else
    {
        SendMessageToPC(oReviver, "Invalid Object or Player Unavailable");
    }
}

//Revive undead PC Body
void EventReviveUndPCBody(object oTarget, object oReviver=OBJECT_INVALID)
{
    //Declare major variables
    effect eEffect = EffectVisualEffect(VFX_IMP_RAISE_DEAD);
    location lTarget = GetLocation(oTarget);
    object oTargetPC = GetPCBodyOwner(oTarget);

    //Functions
    if (GetLocalInt(oTarget, "PCBody") == 1 && GetIsObjectValid(oTargetPC) && GetLocalInt(oTarget,"iUndead") == 1)
    {
        if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
        {
            gsFXDeleteFixture(GetTag(GetArea(oTarget)),oTarget);
        }
        if (GetAreaFromLocation(lTarget) == OBJECT_INVALID)
        {
            lTarget = GetLocation(GetItemPossessor(oTarget));
        }
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEffect, lTarget);
        DestroyObject(oTarget);
        SetPCDeadStatus(oTargetPC, 0);
        TeleportObjectToLocation(oTargetPC, lTarget);
    }
    else
    {
        SendMessageToPC(oReviver, "Invalid Object or Player Unavailable");
    }
}

//Get PC Corpse Owner
object GetPCBodyOwner(object oTarget)
{
    //Function
    return GetLocalObject(oTarget, "oOwner");
}

//:://////////////////////////////////////////////
//::3.4 Placeable Functions
//:://////////////////////////////////////////////

//Returns 1 if Pickable
int GetIsPickable(object oObject)
{
    //Function
    return GetLocalInt(oObject, "iPick");
}

//Returns 1 if Placeable
int GetIsPlaceable(object oItem)
{
    //Function
    return GetLocalInt(oItem, "iDrop");
}

//Returns 1 if Turnable
int GetIsTurnable(object oObject)
{
    //Function
    return GetLocalInt(oObject, "iTurn");
}

//Return Placeable Type
int GetPlaceableType(object oObject)
{
    //Function
    return GetLocalInt(oObject, "iType");
}

//Place Placeable
void EventPlacePlaceable(object oPC, object oItem)
{
    if (GetIsPlaceable(oItem) == 1)
    {
        //Declare Variables
        object oPlaceable, oBody, oOwner = GetPCBodyOwner(oItem);
        location lTarget = GetLocation(oItem);
        string sTag;

        //Functions
        if (GetLocalInt(oItem, "PCBody") == 0)
        {
            sTag = GetTag(oItem);
            oPlaceable = CreateObject(OBJECT_TYPE_PLACEABLE, sTag, lTarget, TRUE);
            if (GetAreaFromLocation(lTarget) != OBJECT_INVALID)
            {
                int nSaved = gsFXSaveFixture(GetTag(GetArea(oPlaceable)), oPlaceable);
                DestroyObject(oItem);
                if(nSaved = TRUE) { SendMessageToPC(oPC,"Placeable persistently saved to area.");}
                else{SendMessageToPC(oPC,"Placeable limit for the area reached! Placeable NOT saved to area.");}
            }
        }
        else if (GetLocalInt(oItem, "PCBody") == 1)
        {
            sTag = GetResRef(oItem);
            string sBodyID = GetTag(oItem);
            string sName = GetName(oItem);
            oBody = CreateObject(OBJECT_TYPE_PLACEABLE, sTag, lTarget, TRUE, sBodyID);
            if (GetAreaFromLocation(lTarget) != OBJECT_INVALID)
            {
                gsFXSaveFixture(GetTag(GetArea(oPlaceable)), oPlaceable);
                DestroyObject(oItem);
            }
            SetName(oBody, sName);
            SetLocalObject(oBody, "oOwner", oOwner);
        }
    }
}

//Take Placeable
void EventTakePlaceable(object oPC)
{
    //Major Variables
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object"); //Fetch PC Data Item
    object oTarget = GetLocalObject(oItem, "oPick"); //Get Temp Var
    object oOwner = GetPCBodyOwner(oTarget);
    object oBody;
    string sTag = GetResRef(oTarget); //Set Tag String by ResRef Name
    string sName = GetName(oTarget);
    string sBody = GetTag(oTarget);

    object oArea = GetArea(oPC);
    string sArea = GetTag(oArea);

    //Functions
    if (GetLocalInt(oTarget, "PCBody") == 0)
    {
        gsFXDeleteFixture(sArea, oTarget);
        AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 3.0));
        CreateItemOnObject(sTag, oPC, 1);
        DestroyObject(oTarget);
        DeleteLocalObject(oItem, "oPick");
    }
    else if (GetLocalInt(oTarget, "PCBody") == 1)
    {
        gsFXDeleteFixture(sArea, oTarget);
        AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 3.0));
        oBody = CreateItemOnObject(sTag, oPC, 1, sBody);
        SetName(oBody, sName);
        SetLocalObject(oBody, "oOwner", oOwner);
        DestroyObject(oTarget);
        DeleteLocalObject(oItem, "oPick");
    }
}

//Use Placeable
void EventUsePlaceable(object oPC, object oObject, string sDialogResRef="")
{
    //Deckare Variables
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");

    //Functions
    AssignCommand(oPC, ActionStartConversation(oObject, sDialogResRef, TRUE, FALSE));
    SetLocalObject(oItem, "oPick", oObject); //Set Temp Var to Call
}

// NOTE(LordValinar): Not sure if this function is even used anymore..?
// - Left alone just in case
void DM_CreatePCBody(object oPC, location lDM)
{
    //Declare major variables
    string sPCName = GetName(oPC);
    string sBodyID = ObjectToString(oPC)+"BODY";
    object oDupe = GetObjectByTag(sBodyID);
    object oItem = GetItemPossessedBy(oPC, "PC_Data_Object");

    //Function
    //Destroy Duplicate, Create Body, Change Name, Store Owner, Drop Gold
    DestroyObject(oDupe);
    object oBody = CreateObject(OBJECT_TYPE_PLACEABLE, "PCBody", lDM, FALSE, sBodyID);
    SetName(oBody, sPCName+"'s Body");
    SetLocalObject(oBody, "oOwner", oPC);
    SetLocalObject(oItem, "oCorpse", oBody);

    //Timestamp (to resuscitate)
    int nTimestamp = (To_Days()*24) + GetTimeHour();
    SetLocalInt(oBody, "nTimeOfDeath", nTimestamp);
}

void EventRespawnSafePCBody(object oTarget, object oReviver=OBJECT_INVALID)
{
    //Declare major variables
    effect eEffect = EffectVisualEffect(VFX_IMP_RAISE_DEAD);
    location lTarget = GetWaypointLocation("wp_mausrespawn");
    object oTargetPC = GetPCBodyOwner(oTarget);

    //Functions
    if (GetLocalInt(oTarget, "PCBody") == 1 && GetIsObjectValid(oTargetPC) && GetLocalInt(oTarget,"iUndead") != 1)
    {
        if (GetHitDice(oTargetPC) <= 5)
        {
            // Put in Masoleum in Tejarn
            lTarget = GetWaypointLocation("wp_tejarnmaus");
        }
        if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
        {
            gsFXDeleteFixture(GetTag(GetArea(oTarget)),oTarget);
        }
        if (GetAreaFromLocation(lTarget) == OBJECT_INVALID)
        {
            lTarget = GetLocation(GetItemPossessor(oTarget));
        }
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEffect, lTarget);
        DestroyObject(oTarget);
        SetPCDeadStatus(oTargetPC, 0);
        int iHD = GetHitDice(oTargetPC);
        int iXP = GetXP(oTargetPC);
        int iXPPen = iHD*100; // original: iHD*500

        if ( GetHasFeat(1158,oTargetPC) || // Background: Evangelist
             GetHasFeat(1156,oTargetPC) || // Background: Crusader
             GetHasFeat(1168,oTargetPC) || // Background: Occultist
             GetHasFeat(1392,oTargetPC) || // Background: Church Acolyte
             GetHasFeat(1399,oTargetPC) || // Background: Theocrat
             GetHasFeat(1400,oTargetPC) || // Background: Ward Triad
             GetHasFeat(1465,oTargetPC) || // Background: Seldarine Priest
             GetHasFeat(1468,oTargetPC) || // Background: Thunder Twin
             GetHasFeat(1469,oTargetPC) || // Background: Heir to Throne
             GetHasFeat(1470,oTargetPC) || // Background: Mordinsanman Priest
             GetHasFeat(1471,oTargetPC))   // Background: Wary Swordknight
        {
            iXPPen = iHD*25; // original: iHD*250
        }

        if (GetHitDice(oTargetPC) <= 3) iXPPen = 0;

        /* New method (LordValinar 11/04/2023): Prevents de-leveling
        Removed :: SetXP(oTargetPC, iXP - iXPPen); */
        TakeXPFromCreature(iXPPen, oTargetPC);
        TeleportObjectToLocation(oTargetPC, lTarget);
    }
    else
    {
        SendMessageToPC(oReviver, "Invalid Object or Player Unavailable");
    }
}

//Respawn if no body found.
void EventRespawnSafeNoBody(object oPC)
{
    //Declare major variables
    effect eEffect = EffectVisualEffect(VFX_IMP_RAISE_DEAD);
    location lTarget = GetWaypointLocation("wp_mausrespawn");

    //Functions
    if (GetIsObjectValid(oPC) && GetLocalInt(oPC,"iUndead") != 1)
    {
        if (GetHitDice(oPC) <= 5)
        {
            // Put in Masoleum in Tejarn
            lTarget = GetWaypointLocation("wp_tejarnmaus");
        }
        SetPCDeadStatus(oPC, 0);
        int iHD = GetHitDice(oPC);
        int iXP = GetXP(oPC);
        int iXPPen = iHD*100; // original: iHD*500

        if ( GetHasFeat(1158,oPC) || // Background: Evangelist
             GetHasFeat(1156,oPC) || // Background: Crusader
             GetHasFeat(1168,oPC) || // Background: Occultist
             GetHasFeat(1392,oPC) || // Background: Church Acolyte
             GetHasFeat(1399,oPC) || // Background: Theocrat
             GetHasFeat(1400,oPC) || // Background: Ward Triad
             GetHasFeat(1465,oPC) || // Background: Seldarine Priest
             GetHasFeat(1468,oPC) || // Background: Thunder Twin
             GetHasFeat(1469,oPC) || // Background: Heir to Throne
             GetHasFeat(1470,oPC) || // Background: Mordinsanman Priest
             GetHasFeat(1471,oPC))   // Background: Wary Swordknight
        {
            iXPPen = iHD*25; // original: iHD*250
        }

        if (GetHitDice(oPC) <= 3) iXPPen = 0;

        /* New method (LordValinar 11/04/2023): Prevents de-leveling
        Removed :: SetXP(oTargetPC, iXP - iXPPen); */
        TakeXPFromCreature(iXPPen, oPC);
        TeleportObjectToLocation(oPC, lTarget);
    }
}
