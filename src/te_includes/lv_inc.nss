// LordValinar's Scripts - Main Include File (11/13/2023)
// =============================================================================
/*
    This file will include all the constants, structures, and functions
    created by me that is not immediately required in another file. Other
    systems that need to be separated (ie. Crafting) will contain their
    own include file. This is more of a generic include.

    Currently attached to [te_functions.nss] any script including that
    file does not need an additional #include "lv_inc" line.

    --- Handling Arrays ---
    Must have a format in mind and set (does not change or use variations).
    By default my array values look like: "|val01|val02|val03|";

       A more commonly seen array could be seen like: "[val01,val02,val03]",
    but this script doesn't run that way. You could run a similar variant
    without the brackets (ie "val01,val02,val03") by changing the constant
    ARRAY_DELIMETER to "," and bStartingDelimeter to FALSE.
    >> WARNING: This 2nd method is not yet fully supported however (..yet)
*/
// =============================================================================
//void main() {} // uncomment for compiling - then re-comment
// -----------------------------------------------------------------------------
//  * Constants

const int DEBUG_MODE = 0;            // 0(off) no debug messages; 1(on) see debug messages
const int MCS_TOKEN = 83590;         // MultilayeredConvoSystem - Custom Token
const int bStartingDelimeter = TRUE; // Use a starting delimeter for an array
const string ARRAY_DELIMETER = "|";  // The delimeter used in the array

const int REMOVE_REGEN_ITEMS = TRUE; // OnDeath and OnDying scripts

// check if a NWN crafting material ("x2_it_cmat_*", "x2_it_amt_*")
const int BASIC_MATS_ARE_COMMODITIES = TRUE;


// -----------------------------------------------------------------------------
//  * Prototypes

// Displays a debug message for offline testing
// * Sends message to "GetFirstPC()"
void Debug(string szMessage);

// Displays floating private text to oTarget
void Alert(object oTarget, string szMessage);

// Get a random iMetersAway (in feet) location from lTarget
location GetRandomCloseLocation(location lTarget, int iMetersAway = 5);

// When the two objects are too far apart, destroy the oListener
void DistanceCheck(object oListener, object oPC, float fDistance = 3.33f, int bSpecial = FALSE);

// Sets up a listener for various uses (renaming, passwords, etc.)
object SetupListener(object oListenFor, string sTemplate, int nListeningPattern, string sNewTag = "", float fDistance = 3.33f, int bSpecial = FALSE);

// --- Commodity Bundles -------------------------------------------------------

// Generates a bundle ID tag
string GetBundleID(object oTarget);

// Removes a selected item(s) from inventory to save the data on the bundle
void UseCommodityBundle(object oPC, object oItem);

// From bundle convo - adds additional items to existing bundle
void CommBundle_Add(object oPC);

// From bundle convo - removes all items from bundle and into oPCs inventory
void CommBundle_Remove(object oPC);

// Cleans up unnecessary variables; reduces data size
void UpdateBundleData(object oPC);

// --- Commonly Called Functions -----------------------------------------------

// Checks a string (lowercase) for sAllow'd characters
// * Returns FALSE if sString is "" or no characters found from sAllow
int GetIsValidString(string sString, string sAllow);

// Gets a true random integer between nMin and nMax
int GetRandomInt(int nMin, int nMax);

// Searches for sValue and returns the index
// - sArray: String value of "|sValue01|sValue02|" etc.
// - sValue: The string to search for
// * Returns -1 if sValue not found
int ArrayIndex(string sArray, string sValue);

// Adds sValue to the end of sArray in the string array format
// starting, separating, and ending with a "|"
// * Returns new string array with sValue added
string ArrayPush(string sArray, string sValue);

// Removes every iteration of sValue from sArray
// - sArray: String value of "|sValue01|sValue02|" etc.
// - sValue: The string to remove from sArray
// * Returns an array as-is or new depending on if sValue was found
string ArrayRemove(string sArray, string sValue);

// Counts values in between the delimeters and returns length
int ArrayLength(string sArray);

// Cycles through each iteration in sArray and returns a match
// Array indexing listed as: |0|1|2|3|  etc.
// * Returns "" if index is out of bounds
string ArrayParse(string sArray, int nIndex);

// Checks if a location is valid by its area
int GetIsLocationValid(location lLoc);

// Tacks on "0" to front of sString if under nCount length
string PadZero(string sString, int nCount);

// Clamp an Integer value between a minimum and maximum
int ClampInt(int nValue, int nMin, int nMax);

// Clamp a float value between a minimum and maximum
float ClampFloat(float fValue, float fMin, float fMax);

// Same as GetHasEffect(x0_i0_match) but localized for less includes
int GetTargetHasEffect(int nEffectType, object oTarget = OBJECT_SELF);

// Returns the 2DA value of the APPEARANCE_TYPE_* constant
int GetTrueAppearance(object oTarget);

// Returns either saved or 2DA value
// * Returns -1 if appearance is 0 but not a dwarf
int GetDefaultAppearance(object oPC);

// Returns saved value or default CREATURE_TAIL_TYPE_NONE constant
int GetDefaultTail(object oPC);

// Returns saved value or default CREATURE_WING_TYPE_NONE constant
int GetDefaultWings(object oPC);

// Performs a 'fake' polymorph of oTarget into the new nAppearance
// or back into their original form.
void ChangeShape(object oTarget, int nAppearance, int bUseVFX = TRUE);

// Gets the owner's (usually PC) data object where most variables are stored
object GetPlayerDataObject(object oOwner);

// Setup language variables
void ReApplyLanguages(object oPC);

// --- Multilayerd Conversation System -----------------------------------------

// Gets the name of the area by waypoint
string FastTravelChoice(int nChoice);

// Changes the scale (size) of oTarget
void SetCreatureScaleSize(object oTarget, int nChoice);

// Removes multimenu system variables
void CleanupVariables(object oUser = OBJECT_SELF);

// For [lv_con_sc_token.nss]
// Returns token text based on menu choice
string GetPietyChoiceText(int nChoice);

// Adds or removes the nValue from current oTarget's piety
void AdjustPiety(object oTarget, int nValue);

// Handles fast traveling and costs (possibly random encounters..)
void FastTravel(object oTarget, int nChoice);

// --- Tethyr Functions --------------------------------------------------------

// Checks caster's item slots (neck, hands) or inventory
// - Shields wielded by paladins count as having a Holy Symbol enscribed
int GetHolySymbolIsValid(object oCaster);

// Stores PCs current appearance, wing and tail on their data object
// - bFrom2DA: If TRUE, loads original appearance from 2DA regardless
//             of current appearance type
void SaveAppearance(object oPC, int bFrom2DA = FALSE);

// Loads and applies saved (if any) appearance, wing and tail from
// their data object. Usually auto-applied on certain tranformations
void RestoreAppearance(object oPC);

// Clears appearance variables from data object
// * Sets to -1 so RestoreAppearance() does nothing
void ClearApperearance(object oPC);

// Retrieve soundset data to output as text
// - bNextLine: If true adds "\n" code to display on next line
// * Returns line of string with ID: Label (Gender)
string GetSoundsetData(int nIndex, int bNextLine = TRUE);

// * Checks if oTarget is wearing metal (increases damage by electrical traps)
int GetIsWearingMetal(object oTarget);

// --- Crafting System Functions -----------------------------------------------

// Creates a number of items with nStack each
//  sNewTag : You may assign a new tag to the items created
//  sNewName : You may assign a new name to the items created
//  sNewDesc : You may assign a new description to the items created
void CreateItem(string sResref, object oTarget, int nAmount=1, int nStack=1, string sNewTag="", string sNewName="", string sNewDesc="", int bIdentified=TRUE);

// * Returns number of items including stacks
int GetItemCount(object oTarget, string sResref, int bIncludeEquipped = FALSE);

// --- Subrace System Functions ------------------------------------------------

// Compares the eEffect with the paramters
// * Returns FALSE if any mismatches were found
int GetEffectMatchesParams(effect eEffect, int nType, int nSubtype=SUBTYPE_SUPERNATURAL, int nDuration=DURATION_TYPE_PERMANENT);

// Removes a permanent supernatural effect with same nEffectType
void RemoveSubraceEffect(object oTarget, int nEffectType, string sTag = "");

// Adds a permanent supernatural effect to oTarget
void AddSubraceEffect(object oTarget, effect eEffect, string sTag = "");

// Gets current creature armor item; Generates a new one if non-existent
//  sOverride : Can manually choose a creature skin item
// * Returns OBJECT_INVALID if could not create or find one
object GetCreatureSkin(object oCreature, string sOverride = "x3_it_pchide");

// Checks for existing property with sEffectTag and removes it
// * Returns 0.0 or 0.2 if a property was found and removed
float CheckRemovePropertyDelay(object oItem, string sEffectTag);

// --- Module Event Script Functions -------------------------------------------

// Retrieves the feat name from the TLK table. Don't use this function
// in a rapid manner (ie Loops) as it makes a 2DA call
// * Returns "[Invalid Feat]" if not found
string GetFeatName(int nFeat);

// Ran on the module's OnItemActivate event script
int ModuleItemActivate();

// Wrapper method for RemoveEffects (nw_i0_plot); just cleaner code
// and included here in (lv_inc) for convenience and reduced includes
void RemoveBadEffects(object oTarget);

// Unequips and stores item data to prevent regeneration
void UnequipRegenItems(object oPC);

// Requips Regen items when stabilized
void ReEquipRegenItems(object oPC);

// Checks if specified tagged effect is already active
int GetIsEffectActive(object oTarget, effect eEffect, string sEffectTag);

// Removes specified tagged effect
void RemoveEffectsByTag(object oTarget, string sEffectTag);

// Applies one of the spell buffs to the related ability score for
// 1 in-game hour by 1 to 5 points as a supernatural effect.
void BuffAbilityScore(int nAbility, object oTarget);

// 2-Stage function call; 1st call assigns the DAMAGE_TYPE_*
// while the 2nd call applies with nSelect (then clears variables)
void BuffDamageImmunity(int nSelect, object oTarget);

// Creates a spell absorption effect
//  nSelect : Spell level (0-9)
void BuffSpellImmunity(int nSelect, object oTarget);

// Applies a misc immunity type such as vs Sneak Attacks or Critical Hits, etc.
void BuffMiscImmunity(int nSelect, object oTarget);

// Increases oTarget's Armor Class (dodge bonus) by nSelect amount
void BuffArmorClass(int nSelect, object oTarget);

// --- DMFI Supported Functions ------------------------------------------------

// Easier check function (LordValinar 01/16/2024) (dmfi_onplychat)
int GetIsListenValid(float fDist, int nListen);

// Wrapper for checking a local integer on player data object
int CheckLanguage(object oTarget, int nLanguage);


// -----------------------------------------------------------------------------
//  * Functions

void Debug(string szMessage)
{
    if (!DEBUG_MODE || szMessage == "") return;
    SendMessageToPC(GetFirstPC(), szMessage);
}

void Alert(object oTarget, string szMessage)
{
    if (!GetIsObjectValid(oTarget) || szMessage == "") return;
    FloatingTextStringOnCreature(szMessage, oTarget, FALSE);
}

location GetRandomCloseLocation(location lTarget, int iMetersAway = 5)
{
    object oArea = GetAreaFromLocation(lTarget);
    vector vPos = GetPositionFromLocation(lTarget);
    int xChange = (Random(3) * iMetersAway) - iMetersAway;
    int yChange = (Random(3) * iMetersAway) - iMetersAway;
    while (xChange == 0 && yChange == 0 && iMetersAway != 0)
    {
        xChange = (Random(3) * iMetersAway) - iMetersAway;
        yChange = (Random(3) * iMetersAway) - iMetersAway;
    }
    vPos.x += IntToFloat(xChange);
    vPos.y += IntToFloat(yChange);
    return Location(oArea, vPos, GetFacingFromLocation(lTarget));
}

void DistanceCheck(object oListener, object oPC, float fDistance = 3.33f, int bSpecial = FALSE)
{
    if (!GetIsObjectValid(oListener) || !GetIsObjectValid(oPC)) return;
    if (GetIsDead(oPC) || GetArea(oListener) != GetArea(oPC))
    {
        if (bSpecial)
        {/* -- Special Cases are handled here (if any) -- *
            if (GetTag(oListener) == "")
            {
                // Do stuff here
            }
            /**/
        }
        // Clear variables
        DestroyObject(oListener);
        return;
    }
    if (GetDistanceBetween(oListener, oPC) > fDistance)
    {
        AssignCommand(oListener, ActionForceMoveToObject(oPC, TRUE));
    }
    DelayCommand(5.0, DistanceCheck(oListener, oPC, fDistance, bSpecial));
}

object SetupListener(object oListenFor, string sTemplate, int nListeningPattern, string sNewTag = "", float fDistance = 3.33f, int bSpecial = FALSE)
{
    // failsafe: If no one to listen for - exit
    if (!GetIsObjectValid(oListenFor)) return OBJECT_INVALID;

    // failsafe: If listener already exists, return that
    object oListener = GetLocalObject(oListenFor, "Listener");
    if (GetIsObjectValid(oListener)) return oListener;

    // Create and return new listener creature
    location lSummon = GetRandomCloseLocation(GetLocation(oListenFor), 1);
    oListener = CreateObject(OBJECT_TYPE_CREATURE, sTemplate, lSummon, FALSE, sNewTag);
    if (GetIsObjectValid(oListener))
    {
        // Give it all kinds of invisibility to prevent being seen
        effect eGone = EffectLinkEffects(EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), EffectCutsceneGhost());
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eGone), oListener);
        // Setup a link between oListener and oListenFor
        SetLocalObject(oListener, "Speaker", oListenFor);
        SetLocalObject(oListenFor, "Listener", oListener);
        // Setup neutral reputation (just in case)
        SetIsTemporaryFriend(oListener, oListenFor);
        SetIsTemporaryFriend(oListenFor, oListener);
        SetStandardFactionReputation(STANDARD_FACTION_COMMONER, 50, oListener);
        SetStandardFactionReputation(STANDARD_FACTION_DEFENDER, 50, oListener);
        SetStandardFactionReputation(STANDARD_FACTION_HOSTILE, 50, oListener);
        SetStandardFactionReputation(STANDARD_FACTION_MERCHANT, 50, oListener);
        // Set to listen now
        AssignCommand(oListener, ClearAllActions(TRUE));
        SetListening(oListener, TRUE);
        SetListenPattern(oListener, "**", nListeningPattern);
        DistanceCheck(oListener, oListenFor, fDistance, bSpecial);
    }
    return oListener;
}

// --- Commodity Bundle Functions ----------------------------------------------

string GetBundleID(object oOwner)
{
    object oData = GetPlayerDataObject(oOwner);
    int nCount = GetLocalInt(oData, "Bundles");
    if (nCount == 0)
    {
        SetLocalInt(oData, "Bundles", 1); // 1st bundle
        return "Bndl_001";
    }
    // Check for empty bundles to choose first
    int i; for (i = 1; i <= nCount; i++)
    {
        // If bundle is empty - use that
        string sID = "Bndl_"+PadZero(IntToString(i), 3);
        object oBundle = GetItemPossessedBy(oOwner, sID);
        if (!GetIsObjectValid(oBundle)) return sID;
    }
    // Use new-last bundle
    SetLocalInt(oData, "Bundles", ++nCount);
    return "Bndl_"+PadZero(IntToString(nCount), 3);
}

void UseCommodityBundle(object oPC, object oItem)
{
    object oData = GetPlayerDataObject(oPC);
    string sTag = GetTag(oItem);
    string sResref = GetResRef(oItem);
    string sName = GetName(oItem);
    int i, nTotal = GetItemCount(oPC, sResref);
    int nCounter = 0;
    float fDelay = 2.0;

    // Add in things you want to be a commodity here.
    SendMessageToPC(oPC, "Attempting to fill commodity bundle with "+IntToString(nTotal)+" "+sName+".");

    // * Do we tag basic crafting items as commodities?
    if (BASIC_MATS_ARE_COMMODITIES)
    {
        // Compare item resref with basic material resrefs
        string sFind = GetStringLeft(sResref, 9);
        if (sFind == "x2_it_cma" || sFind == "x2_it_amt")
        {
            SetLocalInt(oItem, "isCommodity", TRUE);
        }
    }

    // Failsafe: if not a commodity - we exit here
    if (!GetLocalInt(oItem, "isCommodity"))
    {
        Alert(oPC, "This is not a valid commodity!");
        CreateItem("lv_commbundle", oPC);
        return;
    }

    // Get stack size
    int nStack = 1;
    switch (GetBaseItemType(oItem))
    {
        case BASE_ITEM_ARROW: case BASE_ITEM_BOLT: case BASE_ITEM_BULLET: nStack = 99; break;
        case BASE_ITEM_DART: case BASE_ITEM_SHURIKEN: nStack = 50; break;
        case BASE_ITEM_GEM: case BASE_ITEM_GRENADE: case BASE_ITEM_POTIONS:
        case BASE_ITEM_SCROLL: case BASE_ITEM_SPELLSCROLL: nStack = 10; break;
    }

    // Generate~Modify bundle
    object oBundle = CreateItemOnObject("lv_fullbundle", oPC, 1, GetBundleID(oPC));
    SetName(oBundle, "Bundle of " + sName);
    SetLocalString(oBundle, "sItemTag", sTag);
    SetLocalString(oBundle, "sItemResRef", sResref);
    SetLocalString(oBundle, "sItemName", sName);

    // Now add each item from inventory to the commodity bundle
    object oGone = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oGone))
    {
        if (GetResRef(oGone) == sResref && !GetLocalInt(oGone, "iAmCounted"))
        {
            SetLocalInt(oGone, "iAmCounted", 1);
            nCounter = nCounter + GetNumStackedItems(oGone);
            DestroyObject(oGone, fDelay);
            fDelay = fDelay + 0.2;
        }
        oGone = GetNextItemInInventory(oPC);
    }

    // Save new variables
    SetLocalInt(oBundle, "iNumberStored", nCounter);
    SetLocalInt(oBundle, "iStack", nStack);
    DelayCommand(fDelay+0.5,SendMessageToPC(oPC,"Successfully added "+IntToString(nCounter)+" "+sName+" to the bundle."));
}

void CommBundle_Add(object oPC)
{
    object oItem = GetLocalObject(oPC, "MCS_ITEM");
    string sTag = GetLocalString(oItem, "sItemTag");
    string sResref = GetLocalString(oItem, "sItemResRef");
    string sName = GetLocalString(oItem, "sItemName");
    int nTotal = GetLocalInt(oItem, "iNumberStored");
    int nTemp = GetItemCount(oPC, sResref);
    int nCounter = 0;
    float fDelay = 2.0;

    // failsafe: If nothing to add, just exit
    if (nTemp == 0)
    {
        SendMessageToPC(oPC, "There are no more "+sName+" to add.");
        return;
    }

    SendMessageToPC(oPC, "Attempting to add "+IntToString(nTemp)+" "+sName+" to this bundle.");

    object oGone = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oGone))
    {
        if (GetResRef(oGone) == sResref && !GetLocalInt(oGone,"iAmCounted"))
        {
            SetLocalInt(oGone, "iAmCounted", 1);
            nCounter = nCounter + GetNumStackedItems(oGone);
            DestroyObject(oGone, fDelay);
            fDelay = fDelay + 0.2;
        }
        oGone = GetNextItemInInventory(oPC);
    }

    nTotal = nTotal + nCounter;
    SetLocalInt(oItem, "iNumberStored", nTotal);
    DelayCommand(fDelay+0.5,SendMessageToPC(oPC,"Successfully added "+IntToString(nCounter)+" "+sName+" to the bundle."));
    DelayCommand(fDelay+0.6,SendMessageToPC(oPC,"There are now a total of "+IntToString(nTotal)+" "+sName+" in this bundle."));
}

void CommBundle_Remove(object oPC)
{
    // failsafe: Must be a bundle item
    object oItem = GetLocalObject(oPC, "MCS_ITEM");
    string sID = GetTag(oItem);
    if (GetStringLeft(sID, 5) != "Bndl_") return;

    // failsafe: Must have a valid amount from listener script
    int iAmount = GetLocalInt(oPC, "Comm_Remove_Amt"); /**/ DeleteLocalInt(oPC, "Comm_Remove_Amt");
    if (iAmount == 0)
    {
        SendMessageToPC(oPC, "Something went wrong - no amount was spoken or the Listener didn't catch it. Try again.");
        return;
    }

    // Continue
    string sTag = GetLocalString(oItem, "sItemTag");
    string sResref = GetLocalString(oItem, "sItemResRef");
    string sName = GetLocalString(oItem, "sItemName");
    int iTotal = GetLocalInt(oItem, "iNumberStored");
    int iStack = GetLocalInt(oItem, "iStack");

    // New Method (01/12/2024 LordValinar): Calculate total stacks + stackSize
    // while taking into account the amount requested vs stack size.
    // -- Step 1: Ensure we can request this number of items --
    if (iAmount > iTotal)
    {
        SendMessageToPC(oPC, "Too many! Reducing requested amount to maximum of " + IntToString(iTotal));
        iAmount = iTotal;
    }
    // -- Step 2: Divide amount by the stack size  --
    // * This gets the true number of stacks to create plus any remainders
    int iCounter = 0;
    int iCounter2 = iAmount;
    while (iCounter2 >= iStack)
    {
        iCounter++;
        iCounter2 -= iStack;
    }
    // -- Step 3: Create the items on player --
    CreateItem(sResref, oPC, iCounter, iStack);
    // -- Step 4: Check for remainders (adds a final stack of remaining) --
    if (iCounter2 > 0) CreateItem(sResref, oPC, 1, iCounter2);
    // -- Step 5: Update Total for checks and messages --
    iTotal -= iAmount;
    DelayCommand(2.0,SendMessageToPC(oPC,"You remove "+IntToString(iAmount)+" "+sName+" from the bundle."));
    if (iTotal==0)
    {
        // Return bundle to an empty state
        DestroyObject(oItem);
        CreateItem("lv_commbundle", oPC);

        // Variable Cleanup : Reduce bundles if last created or last one left
        UpdateBundleData(oPC);
    }
    else
    {
        SetLocalInt(oItem, "iNumberStored", iTotal);
        DelayCommand(2.1,SendMessageToPC(oPC,"This leaves "+IntToString(iTotal)+" "+sName+" left in the bundle."));
    }
}

void UpdateBundleData(object oPC)
{// Bndl_001, Bndl_002, Bndl_003[<]
    object oData = GetPlayerDataObject(oPC);
    int nBundles = GetLocalInt(oData, "Bundles");
    int i, nCount = 0;
    for (i = nBundles; i > 0; i--)
    {
        string sID = "Bndl_" + PadZero(IntToString(i), 3);
        object oItem = GetItemPossessedBy(oPC, sID);
        if (GetIsObjectValid(oItem)) break;
        nCount++;
    }
    if (nCount >= nBundles) {
        DeleteLocalInt(oData, "Bundles");
    } else {
        SetLocalInt(oData, "Bundles", nBundles - nCount);
    }
}

// --- Common Use Functions ----------------------------------------------------

int GetIsValidString(string sString, string sAllow)
{
    if (sString == "") return FALSE; // nothing to validate
    string sCheck = GetStringLowerCase(sString);
    int i; for(i=0; i < GetStringLength(sCheck); i++)
    {
        string sChar = GetSubString(sCheck, i, 1);
        if (FindSubString(sAllow, sChar) == -1) return FALSE;
    }
    return TRUE;
}

int GetRandomInt(int nMin, int nMax)
{
    return Random(nMax - nMin + 1) + nMin;
}

int ArrayLength(string sArray)
{
    int i, nCount = 0;
    for(i=0; i < GetStringLength(sArray); i++)
    {
        string sChar = GetSubString(sArray, i, 1);
        if (sChar == ARRAY_DELIMETER) nCount++;
    }
    return nCount - (bStartingDelimeter ? 1 : 0);
}

int ArrayIndex(string sArray, string sValue)
{
    int i; for(i=0; i < ArrayLength(sArray); i++)
    {
        if (ArrayParse(sArray, i) == sValue) return i;
    }
    return -1;
}

string ArrayPush(string sArray, string sValue)
{
    if (bStartingDelimeter)
    {
        if (sArray == "") sArray = ARRAY_DELIMETER;
        return sArray + sValue + ARRAY_DELIMETER;
    }
    return sArray + (sArray != "" ? ARRAY_DELIMETER : "") + sValue;
}

string ArrayParse(string sArray, int nIndex)
{
    // Failsafe (is nIndex within bounds?)
    if (nIndex < 0 || nIndex >= ArrayLength(sArray)) return "";

    int nPos = bStartingDelimeter ? -1 : 0;
    int i, nLength = GetStringLength(sArray);
    while (nLength > 0 && nPos <= nIndex)
    {
        string sChar = GetSubString(sArray, 0, 1);
        if (sChar == ARRAY_DELIMETER)
        { // Skip delimeters
            i = 1;
            nPos++;
        }
        else
        {
            // Return sValue found in sArray at nIndex
            i = FindSubString(sArray, ARRAY_DELIMETER);
            if (nPos == nIndex) return GetStringLeft(sArray, i);
        }
        // Update array length for while-loop
        sArray = GetStringRight(sArray, nLength - i);
        nLength = GetStringLength(sArray);
    }
    return ""; // Nothing found
}

string ArrayRemove(string sArray, string sValue)
{
    string sNewArray = "";
    int i; for (i=0; i < ArrayLength(sArray); i++)
    {
        string sParse = ArrayParse(sArray, i);
        if (sParse != sValue)
        {
            sNewArray = ArrayPush(sNewArray, sParse);
        }
    }
    return sNewArray;
}

int GetIsLocationValid(location lLoc)
{
    object oArea = GetAreaFromLocation(lLoc);
    return GetIsObjectValid(oArea);
}

string PadZero(string sString, int nCount)
{
    while (GetStringLength(sString) < nCount)
    {
        sString = "0" + sString;
    }
    return sString;
}

int ClampInt(int nValue, int nMin, int nMax)
{
    if (nValue < nMin) return nMin;
    if (nValue > nMax) return nMax;
    return nValue;
}

float ClampFloat(float fValue, float fMin, float fMax)
{
    if (fValue < fMin) return fMin;
    if (fValue > fMax) return fMax;
    return fValue;
}

int GetTargetHasEffect(int nEffectType, object oTarget = OBJECT_SELF)
{
    effect eCheck = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eCheck))
    {
        if (GetEffectType(eCheck) == nEffectType) return TRUE;
        eCheck = GetNextEffect(oTarget);
    }
    return FALSE;
}

int GetTrueAppearance(object oTarget)
{
    int nRace = GetRacialType(oTarget);
    string s2DA = Get2DAString("racialtypes", "Appearance", nRace);
    return StringToInt(s2DA);
}

int GetDefaultAppearance(object oPC)
{
    // failsafe: Return 2DA value if under Polymorph effect
    if (GetTargetHasEffect(EFFECT_TYPE_POLYMORPH, oPC)) return GetTrueAppearance(oPC);

    // failsafe: Return -1 if no recorded value
    object oItem = GetPlayerDataObject(oPC);
    int nApp = GetLocalInt(oItem, "PC_APP_MAIN");
    if (nApp == 0 && GetRacialType(oPC) != RACIAL_TYPE_DWARF) return -1;

    // * return saved value
    return nApp;
}

int GetDefaultTail(object oPC)
{
    object oItem = GetPlayerDataObject(oPC);
    return GetLocalInt(oItem, "PC_APP_TAIL");
}

int GetDefaultWings(object oPC)
{
    object oItem = GetPlayerDataObject(oPC);
    return GetLocalInt(oItem, "PC_APP_WING");
}

void ChangeShape(object oTarget, int nAppearance, int bUseVFX = TRUE)
{
    int nCurApp  = GetAppearanceType(oTarget);
    int nCurTail = GetCreatureTailType(oTarget);
    int nCurWing = GetCreatureWingType(oTarget);
    int nDefApp  = GetDefaultAppearance(oTarget);
    int nTail    = GetDefaultTail(oTarget);
    int nWings   = GetDefaultWings(oTarget);
    int nRace    = GetRacialType(oTarget);
    float fDelay = 0.0;

    if (nDefApp == nAppearance) nDefApp = GetTrueAppearance(oTarget); // Glitched
    if (nDefApp == -1)
    {
        // Need to record true self
        SaveAppearance(oTarget);

        // reload variables
        nDefApp = nCurApp;
        nTail   = nCurTail;
        nWings  = nCurWing;
    }
    // --- Revert to Original Form(s) ---------------------------
    if (nCurApp != nDefApp) nAppearance = nDefApp;

    // --- SPECIAL - CASES --------------------------------------
    //  * This section is for specific appearance adjustments like
    //    adding tails or wings to specific races or requests

    // ----------------------------------------------------------
    if (bUseVFX)
    {
        effect ePoly = EffectVisualEffect(VFX_IMP_POLYMORPH);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, ePoly, oTarget, 2.0);
        fDelay = 1.5f;
    }
    DelayCommand(fDelay, SetCreatureAppearanceType(oTarget, nAppearance));
    if (nCurTail != nTail)
    {
        DelayCommand(fDelay, SetCreatureTailType(nTail, oTarget));
    }
    if (nCurWing != nWings)
    {
        DelayCommand(fDelay, SetCreatureWingType(nWings, oTarget));
    }
}

object GetPlayerDataObject(object oOwner)
{
    object oItem = GetItemPossessedBy(oOwner, "PC_Data_Object");
    if (!GetIsObjectValid(oItem))
    {
        oItem = CreateItemOnObject("pc_data_object", oOwner);
    }
    return oItem;
}

void ReApplyLanguages(object oPC)
{
    object oItem = GetPlayerDataObject(oPC);
    switch (GetRacialType(oPC))
    {
        case RACIAL_TYPE_ELF: case RACIAL_TYPE_HALFELF: SetLocalInt(oItem,"1",1); break;
        case RACIAL_TYPE_GNOME:                         SetLocalInt(oItem,"2",1); break;
        case RACIAL_TYPE_HALFLING:                      SetLocalInt(oItem,"3",1); break;
        case RACIAL_TYPE_DWARF:                         SetLocalInt(oItem,"4",1); break;
        case RACIAL_TYPE_HALFORC:                       SetLocalInt(oItem,"5",1); break;
    }
    int nRanger = GetLevelByClass(CLASS_TYPE_RANGER,oPC);
    int nDruid = GetLevelByClass(CLASS_TYPE_DRUID,oPC);
    int nRogue = GetLevelByClass(CLASS_TYPE_ROGUE,oPC);
    int nAssn = GetLevelByClass(CLASS_TYPE_ASSASSIN,oPC);
    if (nRanger >= 8 || nDruid >= 5 || GetHasFeat(1393,oPC)) // Background: Circle Born
    {
        SetLocalInt(oItem,"8",1); // Animal
        if (nDruid >= 5) SetLocalInt(oItem,"14",1); // Druidic
    }
    if (nRogue > 0 || nAssn > 0)
    {
        SetLocalInt(oItem,"9",1); // Thieves' Cant
        if (nAssn > 0) SetLocalInt(oItem,"37",1); // Assassins' Cant
    }
    if(GetHasFeat(1390,oPC) || GetHasFeat(1381,oPC))
    {
        SetLocalInt(oItem,"23",1); // Alzhedo
    }
    if(GetHasFeat(1398,oPC) || GetHasFeat(1445,oPC))
    {
        SetLocalInt(oItem,"38",1); // Talfiric
    }
    if(GetHasFeat(1179,oPC))
    {
        SetLocalInt(oItem,"13",1); // Drow
        SetLocalInt(oItem,"81",1); // Drow Sign Language
        SetLocalInt(oItem,"46",1); // Undercommon
    }
    if(GetHasFeat(1183,oPC))
    {
        SetLocalInt(oItem,"64",1); // Duergar
        SetLocalInt(oItem,"46",1); // Undercommon
    }
    if(GetHasFeat(1382,oPC) || GetHasFeat(1387,oPC))
    {
        SetLocalInt(oItem,"53",1); // Chondathan
    }
    if(GetHasFeat(1383,oPC))
    {
        SetLocalInt(oItem,"56",1); // Damaran
    }
    if(GetHasFeat(1384,oPC))
    {
        SetLocalInt(oItem,"22",1); // Illuskan
    }
    if(GetHasFeat(1385,oPC))
    {
        SetLocalInt(oItem,"27",1); // Mulhorandi
    }
    if(GetHasFeat(1386,oPC))
    {
        SetLocalInt(oItem,"30",1); // Rashemi
    }
    if(GetHasFeat(1137,oPC))
    {
        SetLocalInt(oItem,"11",1); // Abyssal
    }
    if(GetHasFeat(1139,oPC))
    {
        SetLocalInt(oItem,"12",1); // Infernal
    }
}

// --- Multilayered Conversation System ----------------------------------------

string FastTravelChoice(int nChoice)
{
    string sTag = "wagon_" + PadZero(IntToString(nChoice), 3);
    object oWaypoint = GetWaypointByTag(sTag);
    object oArea = GetArea(oWaypoint);
    return GetIsObjectValid(oArea) ? GetName(oArea) : "";
}

// ---
float GetScaleAdjustment(float fScale, int nChoice)
{
    switch (nChoice)
    {
        case 1: return ClampFloat(fScale-0.01f, 0.8f, 1.2f); break;
        case 2: return ClampFloat(fScale+0.01f, 0.8f, 1.2f); break;
        case 3: return ClampFloat(fScale-0.05f, 0.8f, 1.2f); break;
        case 4: return ClampFloat(fScale+0.05f, 0.8f, 1.2f); break;
        case 5: return ClampFloat(fScale-0.10f, 0.8f, 1.2f); break;
        case 6: return ClampFloat(fScale+0.10f, 0.8f, 1.2f); break;
        case 7: return ClampFloat(fScale-0.25f, 0.8f, 1.2f); break;
        case 8: return ClampFloat(fScale+0.25f, 0.8f, 1.2f); break;
        case 9: return 1.0f;
    }
    return fScale;
}
void SetCreatureScaleSize(object oTarget, int nChoice)
{
    object oItem = GetPlayerDataObject(oTarget);
    float fScale = GetLocalFloat(oItem, "fScale");
    if (fScale == 0.0f) fScale = 1.0f;

    float fNewScale = GetScaleAdjustment(fScale, nChoice);
    if (fNewScale == 0.0f)
    {// can't have 0.0 scale, adjusting 1 step further
        fNewScale = GetScaleAdjustment(fNewScale, nChoice);
    }

    if (fScale != fNewScale)
    {
        SetLocalFloat(oItem, "fScale", fNewScale);
        SetObjectVisualTransform(oTarget, OBJECT_VISUAL_TRANSFORM_SCALE, fNewScale);
        SendMessageToPC(oTarget, "Size Scale changed to " + FloatToString(fNewScale));
    }
    else
    {
        SendMessageToPC(oTarget, "Size Scale same as current - no change occurred.");
    }
}

void CleanupVariables(object oUser = OBJECT_SELF)
{
    // Script Cleanup
    object oSelf = GetLocalObject(oUser, "MCS_SELF");
    DeleteLocalString(oSelf, "ConvMenuScript");
    // Cleanup User Variables
    DeleteLocalObject(oUser, "MCS_SELF");
    DeleteLocalObject(oUser, "MCS_TARGET");
    DeleteLocalObject(oUser, "MCS_ITEM");
    DeleteLocalInt(oUser, "MCS_CATEGORY");
    DeleteLocalInt(oUser, "MCS_CATEGORY2");
    DeleteLocalInt(oUser, "MCS_OPTIONS");
    DeleteLocalInt(oUser, "MCS_PAGE");
    DeleteLocalInt(oUser, "MCS_CHOICE");
    DeleteLocalInt(oUser, "MCS_TOKEN");
    DeleteLocalLocation(oUser, "MCS_LOCATION");
    // Ensures Listener is destroyed
    object oListener = GetLocalObject(oUser, "Listener");
    if (GetIsObjectValid(oListener))
    {
        DeleteLocalObject(oUser, "oTarget");
        SetPlotFlag(oListener, FALSE);
        DestroyObject(oListener, 0.2);
    }
}

string GetPietyChoiceText(int nChoice)
{
    switch (nChoice)
    {
        case 1:  return "Set Piety to 0";
        case 2:  return "Set Piety to Max";
        case 3:  return "Adjust Piety: +1";
        case 4:  return "Adjust Piety: +5";
        case 5:  return "Adjust Piety: +10";
        case 6:  return "Adjust Piety: +25";
        case 7:  return "Adjust Piety: -1";
        case 8:  return "Adjust Piety: -5";
        case 9:  return "Adjust Piety: -10";
        case 10: return "Adjust Piety: -25";
    }
    return "";
}

void AdjustPiety(object oTarget, int nValue)
{
    object oItem = GetPlayerDataObject(oTarget);
    int nMax = GetLocalInt(oItem, "iTrans") ? 20 : 100;
    int nCurrent = GetLocalInt(oTarget, "nPiety");
    int nTotal = ClampInt(nCurrent+nValue, 0, nMax);
    SetLocalInt(oTarget, "nPiety", nTotal);
}

int GetFastTravelCost(int nChoice)
{
    // Default cost; can alter with a switch-case statement
    // with each settlement choice varying up the costs
    return 100;
}

void FastTravel(object oUser, int nChoice)
{
    // PC doesn't have enough money
    object oNPC = GetLocalObject(oUser, "MCS_SELF");
    int nGold = GetGold(oUser);
    int nCost = GetFastTravelCost(nChoice);
    if (nGold < nCost)
    {
        AssignCommand(oNPC, ActionSpeakString("You don't have enough aenars."));
        return;
    }

    // Get destintation
    string sWaypoint = "wagon_" + PadZero(IntToString(nChoice), 3);
    object oWaypoint = GetWaypointByTag(sWaypoint);
    object oArea = GetArea(oWaypoint);
    location lWP = GetLocation(oWaypoint);
    if (GetIsObjectValid(oArea))
    {
        string sCustom = GetLocalString(oNPC, "MCS_MESSAGE");
        if (sCustom == "") sCustom = "Off we go!";

        AssignCommand(oNPC, TakeGoldFromCreature(nCost, oUser));
        AssignCommand(oNPC, ActionSpeakString(sCustom));
        DelayCommand(2.0, AssignCommand(oUser, ClearAllActions()));
        DelayCommand(2.1, AssignCommand(oUser, ActionJumpToLocation(lWP)));
    }
    else
    {
        AssignCommand(oNPC, ActionSpeakString("Uhh I don't know where that is."));
    }
}

// -- TE_FUNCTIONS -------------------------------------------------------------

int GetHolySymbolIsValid(object oCaster)
{
    // If the spell was cast using an item, we don't need a Holy Symbol
    object oItem = GetSpellCastItem();
    if (GetIsObjectValid(oItem)) return TRUE;

    // Otherwise, check for legit item
    return GetIsObjectValid(GetItemPossessedBy(oCaster, "HolySymbol"));
}

void SaveAppearance(object oPC, int bFrom2DA = FALSE)
{
    object oItem = GetPlayerDataObject(oPC);
    int nAppType = bFrom2DA ? GetTrueAppearance(oPC) : GetAppearanceType(oPC);
    SetLocalInt(oItem, "PC_APP_MAIN", nAppType);
    SetLocalInt(oItem, "PC_APP_WING", GetCreatureWingType(oPC));
    SetLocalInt(oItem, "PC_APP_TAIL", GetCreatureTailType(oPC));
}

void RestoreAppearance(object oPC)
{
    int nDefApp = GetTrueAppearance(oPC);
    ChangeShape(oPC, nDefApp);
}

void ClearApperearance(object oPC)
{
    object oItem = GetPlayerDataObject(oPC);
    DeleteLocalInt(oItem, "PC_APP_MAIN");
    DeleteLocalInt(oItem, "PC_APP_WING");
    DeleteLocalInt(oItem, "PC_APP_TAIL");
}

string GetSoundsetData(int nIndex, int bNextLine = TRUE)
{
    // Begin output construction
    string sOutput = IntToString(nIndex) + ": ";
    if (bNextLine) sOutput = "\n" + sOutput;

    switch (nIndex)
    {
        case 0:   return sOutput + "Aasimar (Male/None)"; break;
        case 1:   return sOutput + "Archon, Hound (Male/None)"; break;
        case 2:   return sOutput + "Archon, Lantern (Male/None)"; break;
        //case 3: Archon, Trumpet - Unused - Kept for visual representation
        case 4:   return sOutput + "Badger (Male/None)"; break;
        case 5:   return sOutput + "Badger, Dire (Male/None)"; break;
        case 6:   return sOutput + "Bat (Male/None)"; break;
        case 7:   return sOutput + "Bear (Male/None)"; break;
        case 8:   return sOutput + "Bear, Dire (Male/None)"; break;
        case 9:   return sOutput + "Beetle (Male/None)"; break;
        case 10:  return sOutput + "Boar (Male/None)"; break;
        case 11:  return sOutput + "Boar, Dire (Male/None)"; break;
        case 12:  return sOutput + "Bugbear (Male/None)"; break;
        case 13:  return sOutput + "Bugbear Chief (Male/None)"; break;
        case 14:  return sOutput + "Bugbear Shaman (Male/None)"; break;
        case 15:  return sOutput + "Cat (Male/None)"; break;
        case 16:  return sOutput + "Cat, Dire (Male/None)"; break;
        case 17:  return sOutput + "Cat, Krenshar (Male/None)"; break;
        case 18:  return sOutput + "Cat, Lion (Male/None)"; break;
        case 19:  return sOutput + "Cat, Panther (Male/None)"; break;
        case 20:  return sOutput + "Celestial (Male/None)"; break;
        case 21:  return sOutput + "Chicken (Female)"; break;
        case 22:  return sOutput + "Cow (Female)"; break;
        case 23:  return sOutput + "Curst (Male/None)"; break;
        case 24:  return sOutput + "Deer (Male/None)"; break;
        case 25:  return sOutput + "Demon (Male/None)"; break;
        case 26:  return sOutput + "Intellect Devourer (Male/None)"; break;
        case 27:  return sOutput + "Dog (Male/None)"; break;
        case 28:  return sOutput + "Doom Knight (Male/None)"; break;
        case 29:  return sOutput + "Dragon, Old (Male/None)"; break;
        case 30:  return sOutput + "Dragon, Young (Male/None)"; break;
        case 31:  return sOutput + "Dryad (Female)"; break;
        case 32:  return sOutput + "Elemental, Air (Female)"; break;
        case 33:  return sOutput + "Elemental, Earth (Male/None)"; break;
        case 34:  return sOutput + "Elemental, Fire (Male/None)"; break;
        case 35:  return sOutput + "Elemental, Water (Female)"; break;
        case 36:  return sOutput + "Ettercap (Male/None)"; break;
        case 37:  return sOutput + "Fairy (Female)"; break;
        case 38:  return sOutput + "Falcon (Male/None)"; break;
        case 39:  return sOutput + "Gargoyle (Male/None)"; break;
        case 40:  return sOutput + "Ghoul (Male/None)"; break;
        case 41:  return sOutput + "Ghoul Lord"; break;
        case 42:  return sOutput + "Giant, Common (Male/None)"; break;
        case 43:  return sOutput + "Giant, Noble (Male/None)"; break;
        case 44:  return sOutput + "Goblin (Male/None)"; break;
        case 45:  return sOutput + "Goblin Chief (Male/None)"; break;
        case 46:  return sOutput + "Goblin Shaman (Male/None)"; break;
        case 47:  return sOutput + "Golem, Bone"; break;
        case 48:  return sOutput + "Golem, Flesh"; break;
        case 49:  return sOutput + "Golem, Iron"; break;
        case 50:  return sOutput + "Golem, Stone"; break;
        case 51:  return sOutput + "Grey Render"; break;
        case 52:  return sOutput + "Hell Hound"; break;
        case 53:  return sOutput + "Hook Horror"; break;
        case 54:  return sOutput + "Helm Horror"; break;
        case 55:  return sOutput + "Invisible Stalker"; break;
        case 56:  return sOutput + "Lich (Male/None)"; break;
        case 57:  return sOutput + "Lizardfolk (Female)"; break;
        case 58:  return sOutput + "Lizardfolk Chief (Female)"; break;
        case 59:  return sOutput + "Lizardfolk Mage (Female)"; break;
        case 60:  return sOutput + "Lizardfolk (Male/None)"; break;
        case 61:  return sOutput + "Lizardfolk Chief (Male/None)"; break;
        case 62:  return sOutput + "Lizardfolk Mage (Male/None)"; break;
        case 63:  return sOutput + "Mephit (Male/None)"; break;
        case 64:  return sOutput + "Minotaur (Male/None)"; break;
        case 65:  return sOutput + "Minotaur Chief (Male/None)"; break;
        case 66:  return sOutput + "Minotaur Shaman (Male/None)"; break;
        case 67:  return sOutput + "Mohrg (Male/None)"; break;
        case 68:  return sOutput + "Mummy, Common"; break;
        case 69:  return sOutput + "Mummy, Greater"; break;
        case 70:  return sOutput + "Ogre (Male/None)"; break;
        case 71:  return sOutput + "Ogre Chief (Male/None)"; break;
        case 72:  return sOutput + "Ogre Mage (Male/None)"; break;
        case 73:  return sOutput + "Orc (Male/None)"; break;
        case 74:  return sOutput + "Orc Chief (Male/None)"; break;
        case 75:  return sOutput + "Orc Shaman (Male/None)"; break;
        case 76:  return sOutput + "Rakshasa (Male/None)"; break;
        case 77:  return sOutput + "Raven (Male/None)"; break;
        case 78:  return sOutput + "Shadow (Male/None)"; break;
        case 79:  return sOutput + "Skeleton (Male/None)"; break;
        case 80:  return sOutput + "Skeleton Chief (Male/None)"; break;
        case 81:  return sOutput + "Skeleton Mage (Male/None)"; break;
        case 82:  return sOutput + "Skeleton Warrior (Male/None)"; break;
        case 83:  return sOutput + "Slaad, Powerful"; break;
        case 84:  return sOutput + "Slaad, Weaker"; break;
        case 85:  return sOutput + "Spider (Male/None)"; break;
        case 86:  return sOutput + "Spider, Dire (Male/None)"; break;
        case 87:  return sOutput + "Spider, Phase"; break;
        case 88:  return sOutput + "Spider, Sword"; break;
        case 89:  return sOutput + "Spider, Wraith"; break;
        case 90:  return sOutput + "Succubus (Female)"; break;
        case 91:  return sOutput + "Tiefling (Female)"; break;
        case 92:  return sOutput + "Troll (Male/None)"; break;
        case 93:  return sOutput + "Troll Chief (Male/None)"; break;
        case 94:  return sOutput + "Troll Shaman (Male/None)"; break;
        case 95:  return sOutput + "Umber Hulk (Male/None)"; break;
        case 96:  return sOutput + "Vampire (Male/None)"; break;
        case 97:  return sOutput + "Vrock (Male/None)"; break;
        case 98:  return sOutput + "Werecat (Male/None)"; break;
        case 99:  return sOutput + "Wererat (Male/None)"; break;
        case 100: return sOutput + "Werewolf (Male/None)"; break;
        case 101: return sOutput + "Wight (Male/None)"; break;
        case 102: return sOutput + "Will-O-Wisp"; break;
        case 103: return sOutput + "Wolf (Male/None)"; break;
        case 104: return sOutput + "Wolf, Dire (Male/None)"; break;
        case 105: return sOutput + "Wolf, Winter"; break;
        case 106: return sOutput + "Worg (Male/None)"; break;
        case 107: return sOutput + "Wraith (Male/None)"; break;
        case 108: return sOutput + "Yuan-ti (Female)"; break;
        case 109: return sOutput + "Zombie (Male/None)"; break;
        case 110: return sOutput + "Zombie, Tyrant Fog"; break;
        case 111: return sOutput + "Zombie Warrior (Male/None)"; break;
        case 112: return sOutput + "Human, Barbarian (Female)"; break;
        case 113: return sOutput + "Human, Barbarian, Stupid (Male/None)"; break;
        case 114: return sOutput + "Half-Orc, Chieftain (Male/None)"; break;
        case 115: return sOutput + "Human, Barbarian, Warrior (Male/None)"; break;
        case 116: return sOutput + "Human, Older, Muttering Beggar (Male/None)"; break;
        case 117: return sOutput + "Human, Older, Street Prophet (Male/None)"; break;
        case 118: return sOutput + "Human, Typical Brash Scumbag (Male/None)"; break;
        case 119: return sOutput + "Human, Typical Low-Class Villain (Male/None)"; break;
        case 120: return sOutput + "Child (Female)"; break;
        case 121: return sOutput + "Child, Pleasant (Male/None)"; break;
        case 122: return sOutput + "Child, Brat (Male/None)"; break;
        case 123: return sOutput + "Human, Typical Cleric (Male/None)"; break;
        case 124: return sOutput + "Human, Older, Melancholy (Male/None)"; break;
        case 125: return sOutput + "Elf, Cleric (Male/None)"; break;
        case 126: return sOutput + "Human, Noble, Young and Arrogant (Male/None)"; break;
        case 127: return sOutput + "Human, Older, Strange Hermit (Female)"; break;
        case 128: return sOutput + "Elf, Typical (Female)"; break;
        case 129: return sOutput + "Human, Older, Confident Leader (Male/None)"; break;
        case 130: return sOutput + "Dwarf, Veteran (Male/None)"; break;
        case 131: return sOutput + "Elf, Brooding (Male/None)"; break;
        case 132: return sOutput + "Elf, Typical (Male/None)"; break;
        case 133: return sOutput + "Human, Evil Fanatic (Female)"; break;
        case 134: return sOutput + "Human, Evil Fanatic (Male/None)"; break;
        case 135: return sOutput + "Elf, Sensible (Female)"; break;
        case 136: return sOutput + "Human, Flirty Barmaid (Female)"; break;
        case 137: return sOutput + "Elf, Commoner, Pleasant (Female)"; break;
        case 138: return sOutput + "Human, Older, World-Weary (Male/None)"; break;
        case 139: return sOutput + "Human, Commoner, Uneducated (Male/None)"; break;
        case 140: return sOutput + "Human, Typical Druid (Male/None)"; break;
        case 141: return sOutput + "Dwarf, Older, Grouch (Male/None)"; break;
        case 142: return sOutput + "Gnome, Annoying (Male/None)"; break;
        case 143: return sOutput + "Gnome, Pleasant (Male/None)"; break;
        case 144: return sOutput + "Halfling, Sensible (Female)"; break;
        case 145: return sOutput + "Halfling, Typical (Male/None)"; break;
        case 146: return sOutput + "Human, Evil, Sly Assassin (Male/None)"; break;
        case 147: return sOutput + "Human, Evil, Methodical Villain (Male/None)"; break;
        case 148: return sOutput + "Human, Evil, Typical Fighter (Male/None)"; break;
        case 149: return sOutput + "Human, Middle-Age Commoner (Female)"; break;
        case 150: return sOutput + "Human, Older, Commoner (Female)"; break;
        case 151: return sOutput + "Human, Young, Pleasant (Female)"; break;
        case 152: return sOutput + "Human, Commoner (Male/None)"; break;
        case 153: return sOutput + "Elf, Upper-Class (Male/None)"; break;
        case 154: return sOutput + "Elf, Guard (Female)"; break;
        case 155: return sOutput + "Elf, Guard, Mature Officer (Male/None)"; break;
        case 156: return sOutput + "Human, Guard, Good, Rough (Male/None)"; break;
        case 157: return sOutput + "Human, Noble, Caring (Female)"; break;
        case 158: return sOutput + "Human, Noble, Snobbish (Female)"; break;
        case 159: return sOutput + "Human, Noble, Snobbish (Male/None)"; break;
        case 160: return sOutput + "Human, Noble, Older, Uncaring (Male/None)"; break;
        case 161: return sOutput + "Human, Veteran Paladin (Male/None)"; break;
        case 162: return sOutput + "Halfling, Typical (Female)"; break;
        case 163: return sOutput + "Dwarf, Typical (Male/None)"; break;
        case 164: return sOutput + "Gnome, Typical (Male/None)"; break;
        case 165: return sOutput + "Elf, Slight, Lilting (Male/None)"; break;
        case 166: return sOutput + "Human, Courtesan, Friendly (Female)"; break;
        case 167: return sOutput + "Human, Courtesan, Obvious (Female)"; break;
        case 168: return sOutput + "Human, Courtesan, Accent (Female)"; break;
        case 169: return sOutput + "Human, Gigolo, Seductive (Male/None)"; break;
        case 170: return sOutput + "Human, Gigolo, Smarmy (Male/None)"; break;
        case 171: return sOutput + "Human, Stoic Ranger (Male/None)"; break;
        case 172: return sOutput + "Human, Veteran Rogue (Male/None)"; break;
        case 173: return sOutput + "Human, Unsavory Shopkeep (Male/None)"; break;
        case 174: return sOutput + "Human, Older Shopkeep (Male/None)"; break;
        case 175: return sOutput + "Human, Retired Adventurer (Male/None)"; break;
        case 176: return sOutput + "Half-Orc, Lout (Female)"; break;
        case 177: return sOutput + "Human, Bully (Male/None)"; break;
        case 178: return sOutput + "Gnome, Older (Male/None)"; break;
        case 179: return sOutput + "Dwarf, Evil Thug (Male/None)"; break;
        case 180: return sOutput + "Elf, Wizard (Female)"; break;
        case 181: return sOutput + "Human, Wizard, Old (Male/None)"; break;
        //case 182: Empty - this is just for visual representation
        case 183: return sOutput + "Human, Older Slave (Male/None)"; break;
        case 184: return sOutput + "Human, Commoner, Toady (Male/None)"; break;
        case 185: return sOutput + "Human, Drunk (Male/None)"; break;
        case 186: return sOutput + "Human, Guard, Gruff (Male/None)"; break;
        case 187: return sOutput + "Human, Barbarian, Good (Male/None)"; break;
        case 188: return sOutput + "Human, Guard, Sedos (Female)"; break;
        case 189: return sOutput + "Human, Teen (Male/None)"; break;
        case 190: return sOutput + "Human, Guard, Arrogant (Male/None)"; break;
        case 191: return sOutput + "Human, Wizard (Male/None)"; break;
        case 192: return sOutput + "Half-Orc, Gruff Lout (Male/None)"; break;
        case 193: return sOutput + "Human, Average Joe (Male/None)"; break;
        case 194: return sOutput + "Human, Noble, Unfriendly (Female)"; break;
        case 195: return sOutput + "Human, Farmer (Male/None)"; break;
        case 196: return sOutput + "Half-Elf, Agitated (Male/None)"; break;
        case 197: return sOutput + "Nymph/Dryad/Arwyl (Female)"; break;
        case 198: return sOutput + "Minotaur, Zor (Male/None)"; break;
        case 199: return sOutput + "Celestial, Guardian (Female)"; break;
        case 200: return sOutput + "Spirit, Zelieph (Male/None)"; break;
        case 201: return sOutput + "Imp, Ebrax (Male/None)"; break;
        case 202: return sOutput + "Lich, Karlat (Male/None)"; break;
        case 203: return sOutput + "Goblin King (Male/None)"; break;
        case 204: return sOutput + "Orc, Pompous (Male/None)"; break;
        case 205: return sOutput + "Succubus, Manipulative (Female)"; break;
        case 206: return sOutput + "Dragon, Green, Akula (Female)"; break;
        case 207: return sOutput + "Dragon, Brass, Gorg (Female)"; break;
        case 208: return sOutput + "Dragon, Red, Klauth (Male/None)"; break;
        case 209: return sOutput + "Lizardfolk, Fanatical (Male/None)"; break;
        case 210: return sOutput + "NPC - Linu La'neral (Female)"; break;
        case 211: return sOutput + "NPC - Sharwyn (Female)"; break;
        case 212: return sOutput + "NPC - Daelan Red Tiger (Male/None)"; break;
        case 213: return sOutput + "NPC - Tomi Grin Undergallows (Male/None)"; break;
        case 214: return sOutput + "NPC - Grimgnaw (Male/None)"; break;
        case 215: return sOutput + "NPC - Boddyknock Glinkle (Male/None)"; break;
        case 216: return sOutput + "PC - Brash, Persistent (Male/None)"; break;
        case 217: return sOutput + "PC - Boisterous, Goodnatured (Male/None)"; break;
        case 218: return sOutput + "PC - Brooding, Dark Hero (Male/None)"; break;
        case 219: return sOutput + "PC - Violent Fighter (Male/None)"; break;
        case 220: return sOutput + "PC - Noble, Scholar (Female)"; break;
        case 221: return sOutput + "PC - Large Rowdy (Male/None)"; break;
        case 222: return sOutput + "PC - High-strung Evangelist (Male/None)"; break;
        case 223: return sOutput + "PC - Reserved Guardian (Male/None)"; break;
        case 224: return sOutput + "PC - Pious Scholar (Male/None)"; break;
        case 225: return sOutput + "PC - Noble Matron (Female)"; break;
        case 226: return sOutput + "PC - Reserved Guardian (Female)"; break;
        case 227: return sOutput + "PC - Innocent Idealist (Female)"; break;
        case 228: return sOutput + "PC - Manic Psychotic (Male/None)"; break;
        case 229: return sOutput + "PC - Mature Swashbuckler (Male/None)"; break;
        case 230: return sOutput + "NPC - Aribeth (Female)"; break;
        case 231: return sOutput + "NPC - Haedraline (Female)"; break;
        case 232: return sOutput + "NPC - Maugrim (Male/None)"; break;
        case 233: return sOutput + "NPC - Morag (Female)"; break;
        case 234: return sOutput + "NPC - Nasher (Male/None)"; break;
        case 235: return sOutput + "NPC - Fenthick (Male/None)"; break;
        case 236: return sOutput + "NPC - Desther (Male/None)"; break;
        case 237: return sOutput + "Wraith, Drawl (Male/None)"; break;
        case 238: return sOutput + "Intellect Devourer Victim (Male/None)"; break;
        case 239: return sOutput + "Dragon, White, Evil Guardian (Male/None)"; break;
        case 240: return sOutput + "NPC - Yuan-Ti, Gulnan (Female)"; break;
        case 241: return sOutput + "NPC - Aarin Gend (Male/None)"; break;
        case 242: return sOutput + "PC - Fighter (Female)"; break;
        case 243: return sOutput + "PC - Cold Killer (Female)"; break;
        case 244: return sOutput + "PC - Seductress (Female)"; break;
        case 245: return sOutput + "PC - Brutish Thug (Female)"; break;
        case 246: return sOutput + "Kobold (Male/None)"; break;
        case 247: return sOutput + "Kobold, Thug (Male/None)"; break;
        case 248: return sOutput + "Kobold, Shaman (Male/None)"; break;
        case 249: return sOutput + "Rat (Male/None)"; break;
        case 250: return sOutput + "Rat, Dire (Male/None)"; break;
        case 251: return sOutput + "Gnoll (Male/None)"; break;
        case 252: return sOutput + "Gnoll, Shaman (Male/None)"; break;
        case 253: return sOutput + "Hobgoblin (Male/None)"; break;
        case 254: return sOutput + "Hobgoblin, Wizard (Male/None)"; break;
        case 255: return sOutput + "Devil (Male/None)"; break;
        case 256: return sOutput + "NPC - Maggris the Hive Mother (Female)"; break;
        case 257: return sOutput + "Wereboar (Male/None)"; break;
        case 258: return sOutput + "Golem, Gem (Male/None)"; break;
        case 259: return sOutput + "Horse (Male/None)"; break;
        case 260: return sOutput + "Snake (Male/None)"; break;
        case 261: return sOutput + "Mechanical (Male/None)"; break;
        //case 262-305: Empty - visual representation
        case 306: return sOutput + "Giant, Frost (Female)"; break;
        case 307: return sOutput + "Giant, Fire (Female)"; break;
        case 308: return sOutput + "Medusa (Female)"; break;
        //case 309-310: Empty - visual representation
        case 311: return sOutput + "Asabi Warrior (Male/None)"; break;
        //case 312: Empty - Visual representation
        case 313: return sOutput + "Stinger Warrior (Male/None)"; break;
        //case 314-316: Empty - visual representation
        case 317: return sOutput + "Formian Warrior (Male/None)"; break;
        //case 318-319: Empty - visual representation
        case 320: return sOutput + "Sphinx (Male/None)"; break;
        //case 321-322: Empty - visual representation
        case 323: return sOutput + "Gorgon (Male/None)"; break;
        case 324: return sOutput + "Cockatrice (Male/None)"; break;
        case 325: return sOutput + "Basilisk (Male/None)"; break;
        //case 326-329: Empty - visual representation
        case 330: return sOutput + "Faerie Dragon (Male/None)"; break;
        case 331: return sOutput + "Pseudodragon (Male/None)"; break;
        case 332: return sOutput + "Wyrmling (Male/None)"; break;
        //case 333-341: Empty - visual representation
        case 342: return sOutput + "Human, Desert Warrior (Male/None)"; break;
        case 343: return sOutput + "Lich, Mage (Male/None)"; break;
        case 344: return sOutput + "Elf, Wizard (Male/None)"; break;
        case 345: return sOutput + "Medusa, Handmaid (Female)"; break;
        case 346: return sOutput + "NPC - Deekin Scalesinger (Male/None)"; break;
        case 347: return sOutput + "NPC - Dorna Trapspringer (Female)"; break;
        case 348: return sOutput + "NPC - Drogan Droganson (Male/None)"; break;
        case 349: return sOutput + "NPC - Heurodis (Female)"; break;
        case 350: return sOutput + "NPC - J'Nah (Female)"; break;
        case 351: return sOutput + "NPC - Katriana (Female)"; break;
        case 352: return sOutput + "Human, Blackguard (Male/None)"; break;
        case 353: return sOutput + "Elf, Noble (Female)"; break;
        case 354: return sOutput + "NPC - Mischa Waymeet (Female)"; break;
        case 355: return sOutput + "Half-Orc, Baroness (Female)"; break;
        case 356: return sOutput + "NPC - Xanos (Male/None)"; break;
        case 357: return sOutput + "PC - Berserker (Female)"; break;
        case 358: return sOutput + "PC - Fiesty (Female)"; break;
        case 359: return sOutput + "PC - Mature Commander (Female)"; break;
        case 360: return sOutput + "PC - Playful (Female)"; break;
        case 361: return sOutput + "PC - Quiet Leader (Female)"; break;
        //case 362: Empty - visual representation
        case 363: return sOutput + "PC - Dumb Hero (Male/None)"; break;
        case 364: return sOutput + "PC - Power Hungry (Male/None)"; break;
        case 365: return sOutput + "PC - Prankster (Male/None)"; break;
        case 366: return sOutput + "PC - Sociopath (Male/None)"; break;
        case 367: return sOutput + "PC - Stealth Specialist (Male/None)"; break;
        case 368: return sOutput + "PC - Neutral Warrior (Male/None)"; break;
        case 369: return sOutput + "NPC - Ashtara (Male/None)"; break;
        case 370: return sOutput + "Asabi Thrall (Male/None)"; break;
        case 371: return sOutput + "NPC - Ayala (Male/None)"; break;
        case 372: return sOutput + "Beholder (Male/None)"; break;
        case 373: return sOutput + "Beholder, Mage (Male/None)"; break;
        case 374: return sOutput + "Beholder, Eyeball (Male/None)"; break;
        case 375: return sOutput + "NPC - Mephistopheles, Large (Male/None)"; break;
        case 376: return sOutput + "Dracolich (Male/None)"; break;
        case 377: return sOutput + "Drider (Male/None)"; break;
        case 378: return sOutput + "Drider, Chief (Male/None)"; break;
        case 379: return sOutput + "Drow, Rebel (Male/None)"; break;
        case 380: return sOutput + "Drow, Wizard (Male/None)"; break;
        case 381: return sOutput + "Drow, Matron (Female)"; break;
        case 382: return sOutput + "Duergar, Slaver (Male/None)"; break;
        case 383: return sOutput + "Duergar, Chief (Male/None)"; break;
        case 384: return sOutput + "Mindflayer (Male/None)"; break;
        case 385: return sOutput + "Deep Rothe (Male/None)"; break;
        //case 386: Pit Fiend - Unused - kept for visual representation
        case 387: return sOutput + "Harpy (Male/None)"; break;
        case 388: return sOutput + "Golem, Mithril (Male/None)"; break;
        case 389: return sOutput + "Golem, Adamnatium (Male/None)"; break;
        case 390: return sOutput + "Demon, Bebilith (Male/None)"; break;
        case 391: return sOutput + "Golem, Organic (Male/None)"; break;
        case 392: return sOutput + "Golem, Metal (Female)"; break;
        case 393: return sOutput + "Dragon, Prismatic (Male/None)"; break;
        case 394: return sOutput + "Avariel (Male/None)"; break;
        case 395: return sOutput + "Avariel (Female)"; break;
        case 396: return sOutput + "Demilich (Male/None)"; break;
        case 397: return sOutput + "Alhoon (Male/None)"; break;
        case 398: return sOutput + "NPC - Valsharess (Female)"; break;
        case 399: return sOutput + "NPC - Quarry Boss (Male/None)"; break;
        case 400: return sOutput + "NPC - Arden Swift (Male/None)"; break;
        case 401: return sOutput + "NPC - Sensei Dharvana (Female)"; break;
        case 402: return sOutput + "NPC - Sleeping Man (Male/None)"; break;
        case 403: return sOutput + "NPC - Knower of Places (Female)"; break;
        case 404: return sOutput + "NPC - Knower of Names (Female)"; break;
        case 405: return sOutput + "NPC - Deekin(HotU) (Male/None)"; break;
        case 406: return sOutput + "NPC - Durnan (Male/None)"; break;
        case 407: return sOutput + "NPC - The GateKeeper (Male/None)"; break;
        case 408: return sOutput + "NPC - Mephistopheles (Male/None)"; break;
        case 409: return sOutput + "NPC - Daelan(HotU) (Male/None)"; break;
        case 410: return sOutput + "NPC - Linu(HotU) (Female)"; break;
        case 411: return sOutput + "NPC - Sharwyn(HotU) (Female)"; break;
        case 412: return sOutput + "NPC - Tomi(HotU) (Male/None)"; break;
        case 413: return sOutput + "NPC - Valen Shadowbreath(HotU) (Male/None)"; break;
        case 414: return sOutput + "NPC - Nathyrra(HotU) (Female)"; break;
        case 415: return sOutput + "NPC - The Genie (Male/None)"; break;
        case 416: return sOutput + "NPC - Legendary Weapon (Male/None)"; break;
        case 417: return sOutput + "NPC - Aribeth, Paladin(HotU) (Female)"; break;
        case 418: return sOutput + "PC - Good Wizard (Male/None)"; break;
        case 419: return sOutput + "PC - Typical Fighter (Male/None)"; break;
        case 420: return sOutput + "PC - Archer (Male/None)"; break;
        case 421: return sOutput + "PC - Rogue (Female)"; break;
        case 422: return sOutput + "PC - Healer (Female)"; break;
        case 423: return sOutput + "PC - Maiden (Female)"; break;
        case 424: return sOutput + "NPC - Mhaere (Female)"; break;
        case 425: return sOutput + "NPC - White Thesta (Female)"; break;
        case 426: return sOutput + "NPC - Grovel (Male/None)"; break;
        case 427: return sOutput + "NPC - The Fairy Queen (Female)"; break;
        case 428: return sOutput + "NPC - The Ogre Boss (Male/None)"; break;
        case 429: return sOutput + "NPC - Sobrey (Male/None)"; break;
        case 430: return sOutput + "NPC - Agarly (Female)"; break;
        case 431: return sOutput + "NPC - Berger (Male/None)"; break;
        case 432: return sOutput + "NPC - Halaster (Male/None)"; break;
        case 433: return sOutput + "PC - Adventurer (Female)"; break;
        case 434: return sOutput + "NPC - Armand (Male/None)"; break;
        case 435: return sOutput + "Deva (Female)"; break;
        case 436: return sOutput + "Drow, Seer (Female)"; break;
        case 437: return sOutput + "Drow, Imloth (Male/None)"; break;
        case 438: return sOutput + "Drow, Matron2 (Female)"; break;
        case 439: return sOutput + "NPC - Boatman (Male/None)"; break;
        case 440: return sOutput + "Slave Leader (Male/None)"; break;
        case 441: return sOutput + "Dragon, Shadow (Male/None)"; break;
        case 442: return sOutput + "Golem, Demonflesh (Male/None)"; break;
        case 443: return sOutput + "Gelatinous Cube (Male/None)"; break;
        case 444: return sOutput + "NPC - Aribeth, Blackguard(HotU) (Female)"; break;
        case 445: return sOutput + "Sea Hag (Female)"; break;
        case 446: return sOutput + "Bulette (Male/None)"; break;
        case 447: return sOutput + "Troglodyte (Male/None)"; break;
        case 448: return sOutput + "Troglodyte, Warrior (Male/None)"; break;
        case 449: return sOutput + "Troglodyte, Cleric (Male/None)"; break;
        //case 450: Empty - visual representation
        case 451: return sOutput + "Seagull (Female)"; break;
        case 452: return sOutput + "Parrot (Female)"; break;
        case 453: return sOutput + "Shark (Female)"; break;
        //case 454-849: Bioware Reserved - visual representation
        case 850: return sOutput + "Mechanical (Male/None)"; break;
        case 851: return sOutput + "Viper (Male/None)"; break;
        case 852: return sOutput + "Slime (Male/None)"; break;
        case 853: return sOutput + "Treant (Male/None)"; break;
        case 854: return sOutput + "Cat, House (Male/None)"; break;
        case 855: return sOutput + "Monodrone (Both)"; break;
        case 856: return sOutput + "Horse (Male/None)"; break;
        case 857: return sOutput + "Donkey (Female)"; break;
        //case 858-894: Reserved - kept for visual representation
        case 895: return sOutput + "CODI: Parai (Both)"; break;
        case 896: return sOutput + "CODI: Secundus (Both)"; break;
        case 897: return sOutput + "CODI: Primus (Both)"; break;
        case 898: return sOutput + "CODI: Marut (Both)"; break;
        case 899: return sOutput + "CODI: Mane (Male/None)"; break;
        //case 900: Empty - visual representation
    }
    return "";
}

// -----------------------------------------------------------------------------
int GetIsMetal(object oItem)
{
    int nMetal1 = GetLocalInt(oItem, "nMaterial"); // from looting
    int nMetal2 = GetLocalInt(oItem, "Material"); // from crafting
    if (nMetal1 == 1 || (nMetal2 > 0 && nMetal2 < 5))
    {// only valid items that were assigned a metal-like material
        return TRUE;
    }
    return FALSE;
}
int GetIsWearingMetal(object oTarget)
{
    // If the target is polymorphed or wild shaped, don't count them as wearing gear
    if (GetTargetHasEffect(EFFECT_TYPE_POLYMORPH, oTarget)) return FALSE;

    object oHelm = GetItemInSlot(INVENTORY_SLOT_HEAD, oTarget);
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
    object oArms = GetItemInSlot(INVENTORY_SLOT_ARMS, oTarget);
    object oBoots = GetItemInSlot(INVENTORY_SLOT_BOOTS, oTarget);
    return (
        GetIsMetal(oHelm) || GetIsMetal(oArmor) ||
        GetIsMetal(oArms) || GetIsMetal(oBoots)
    );
}

// --- Crafting System ---------------------------------------------------------

void CreateItem(string sResref, object oTarget, int nAmount=1, int nStack=1, string sNewTag="", string sNewName="", string sNewDesc="", int bIdentified=TRUE)
{
    int i; for (i=1; i <= nAmount; i++)
    {
        object oItem = CreateItemOnObject(sResref, oTarget, nStack, sNewTag);
        SetIdentified(oItem, bIdentified);
        if (sNewName != "") SetName(oItem, sNewName);
        if (sNewDesc != "") SetDescription(oItem, sNewDesc);
    }
}

int GetItemCount(object oTarget, string sResref, int bIncludeEquipped = FALSE)
{
    int i, nCount = 0;
    object oItem = GetFirstItemInInventory(oTarget);
    while (GetIsObjectValid(oItem))
    {
        if (GetResRef(oItem) == sResref)
        {
            nCount = nCount + GetNumStackedItems(oItem);
        }
        oItem = GetNextItemInInventory(oTarget);
    }
    if (bIncludeEquipped)
    {
        for (i=0; i < NUM_INVENTORY_SLOTS; i++)
        {
            oItem = GetItemInSlot(i, oTarget);
            if (!GetIsObjectValid(oItem)) continue;
            if (GetResRef(oItem) == sResref)
            {
                nCount = nCount + GetNumStackedItems(oItem);
            }
        }
    }
    return nCount;
}

// --- Subrace System ----------------------------------------------------------

int GetEffectMatchesParams(effect eEffect, int nType, int nSubtype=SUBTYPE_SUPERNATURAL, int nDuration=DURATION_TYPE_PERMANENT)
{
    return (
        GetEffectDurationType(eEffect) == nDuration &&
        GetEffectSubType(eEffect) == nSubtype &&
        GetEffectType(eEffect) == nType
    );
}

void RemoveSubraceEffect(object oTarget, int nEffectType, string sTag = "")
{
    effect eE = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eE))
    {
        if (GetEffectMatchesParams(eE, nEffectType) && GetEffectTag(eE) == sTag)
        {
            RemoveEffect(oTarget, eE);
        }
        eE = GetNextEffect(oTarget);
    }
}

void AddSubraceEffect(object oTarget, effect eEffect, string sTag = "")
{
    // TODO: Add filters and conditions (take from dss_core?)
    if (sTag != "") eEffect = TagEffect(eEffect, sTag);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eEffect), oTarget);
}

object GetCreatureSkin(object oCreature, string sOverride = "x3_it_pchide")
{
    int nSlot = INVENTORY_SLOT_CARMOUR;
    object oSkin = GetItemInSlot(nSlot, oCreature);
    if (!GetIsObjectValid(oSkin))
    {
        oSkin = GetLocalObject(oCreature, "oX3_Skin");
        if (!GetIsObjectValid(oSkin))
        {
            oSkin = CreateItemOnObject(sOverride, oCreature, 1, "x3_it_pchide");
            if (!GetIsObjectValid(oSkin)) return OBJECT_INVALID;
        }
        DelayCommand(1.0, AssignCommand(oCreature, ActionEquipItem(oSkin, nSlot)));
        SetLocalObject(oCreature, "oX3_Skin", oSkin);
        SetDroppableFlag(oSkin, FALSE);
    }
    return oSkin;
}

float CheckRemovePropertyDelay(object oItem, string sEffectTag)
{
    float fDelay = 0.0;
    itemproperty ipCheck = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ipCheck))
    {
        if (GetItemPropertyTag(ipCheck) == sEffectTag)
        {
            RemoveItemProperty(oItem, ipCheck);
            fDelay = 0.2;
        }
        ipCheck = GetNextItemProperty(oItem);
    }
    return fDelay;
}

// --- Module Event Scripts ----------------------------------------------------

string GetFeatName(int nFeat)
{
    string sName = Get2DAString("feat", "FEAT", nFeat);
    if (sName == "" || sName == "****") return "[Invalid Feat]";
    return GetStringByStrRef(StringToInt(sName));
}

int ModuleItemActivate()
{
    object oPC       = GetItemActivator();
    object oItem     = GetItemActivated();
    object oTarget   = GetItemActivatedTarget();
    object oDMToken  = GetItemPossessedBy(oPC, "DM_TOKEN");
    object oArea     = GetArea(oPC);
    string sItem     = GetTag(oItem);
    string rItem     = GetResRef(oItem);
    string sArea     = GetTag(oArea);
    string arName    = GetName(oArea);
    location lTarget;

    // Size Scaling Tool
    if (rItem == "te_tool_scale")
    {
        SetLocalInt(oItem, "MCS_CATEGORY", 5);
        AssignCommand(oPC, ActionStartConversation(oPC, "te_scale", TRUE, FALSE));
        return TRUE;
    }

    // DM Event Tool
    if (rItem == "te_tool_dmevent")
    {
        // failsafe: Must be a DM to use this
        string sMsg = "--- DM Event Tool ---\n";
        if ((!GetIsDM(oPC) && !GetIsObjectValid(oDMToken)) || GetIsDMPossessed(oPC))
        {
            SendMessageToPC(oPC, sMsg+"You must be a DM not possessing an NPC to use this!");
            if (!GetIsDMPossessed(oPC)) DestroyObject(oItem);
            return TRUE;
        }

        // failsafe: Must target something
        if (!GetIsObjectValid(oTarget))
        {
            SendMessageToPC(oPC, sMsg+"No target selected!");
            return TRUE;
        }

        // failsafe: Must target something other than yourself
        if (oTarget == oPC || GetObjectType(oTarget) != OBJECT_TYPE_CREATURE)
        {
            SendMessageToPC(oPC, sMsg+"You must target a creature other than yourself");
            return TRUE;
        }

        // failsafe: Can't target a DM
        if (GetIsDM(oTarget))
        {
            SendMessageToPC(oPC, sMsg+"You can't target a DM!");
            return TRUE;
        }

        // Setup the listener
        object oListener = SetupListener(oPC, "lv_listener", 15200, "DMEventTool");
        if (!GetIsObjectValid(oListener))
        {
            Alert(oPC, "--ALERT!--");
            SendMessageToPC(oPC, "Oops! Something went wrong - could not create the listener! Aborting..");
            return TRUE;
        }
        SetLocalObject(oPC, "MCS_TARGET", oTarget);
        SetLocalObject(oPC, "MCS_ITEM", oItem);
        SetLocalInt(oItem, "MCS_CATEGORY", 1);
        // Setup tokens
        string sValue = GetIsPC(oTarget) ? "Player"
            : GetStandardFactionReputation(STANDARD_FACTION_HOSTILE, oTarget) >= 90 ? "Monster"
            : "NPC";
        SetCustomToken(80260, GetName(oTarget));
        SetCustomToken(80261, sValue);
        AssignCommand(oPC, ActionStartConversation(oPC, "dm_event_tool", TRUE, FALSE));
        return TRUE;
    }

    // Community Bundle Handler (empty)
    if (rItem == "lv_commbundle")
    {
        string sError = "";
        // failsafe: Must be out of combat to use
        if (GetIsInCombat(oPC))
        {
            sError = "You can't use this while in combat!";
        }
        // failsafe: Must have targeted an item
        else if (!GetIsObjectValid(oTarget) || GetObjectType(oTarget) != OBJECT_TYPE_ITEM)
        {
            sError = "Target must be an item!";
        }
        // failsafe: Said item must be in your inventory
        else if (GetItemPossessor(oTarget) != oPC)
        {
            sError = "You must target a valid item within YOUR inventory!";
        }
        if (sError == "") {
            // Empty bundle - fill with oItem
            UseCommodityBundle(oPC, oTarget);
        } else {
            Alert(oPC, sError);
        }
        return TRUE;
    }

    // Commodity Bundle Handler (full)
    if (rItem == "lv_fullbundle")
    {
        // failsafe: Must be out of combat to use
        if (GetIsInCombat(oPC))
        {
            Alert(oPC, "You can't use this while in combat!");
            return TRUE;
        }

        // Filled bundle - add or remove commodities
        SetLocalObject(oPC, "MCS_ITEM", oItem);
        SetLocalInt(oItem, "MCS_CATEGORY", 2);

        // Set tokens
        string sValue = GetLocalString(oItem, "sItemName");
        int nValue = GetLocalInt(oItem, "iNumberStored");
        SetCustomToken(16210, IntToString(nValue));
        SetCustomToken(16211, sValue);

        // Start convo
        AssignCommand(oPC, ActionStartConversation(oPC, "lv_commbundle", TRUE, FALSE));
        return TRUE;
    }

    // Appearance Widget (DM convo or PC use)
    if (rItem == "lv_app_item")
    {
        int nApp = GetLocalInt(oItem, "APP_ID");
        string sValue = (nApp == -1) ? "None" : IntToString(nApp);

        if (GetIsInCombat(oPC))
        {
            Alert(oPC,"You can't use this while in combat!");
        }
        else if (GetIsDM(oPC) || GetIsDMPossessed(oPC) || GetIsObjectValid(oDMToken))
        {
            SetLocalObject(oPC, "MCS_ITEM", oItem);
            SetLocalInt(oItem, "MCS_CATEGORY", 3);
            SetCustomToken(16220, sValue);
            AssignCommand(oPC, ActionStartConversation(oPC, "lv_app_use", TRUE, FALSE));
        }
        else if (GetIsPC(oPC))
        {
            // failsafe: No Appearance ID stored
            if (nApp == -1)
            {
                Alert(oPC, "ERROR: No appearance set! Ask a DM.");
                return TRUE;
            }

            SendMessageToPC(oPC, "Appearance changed to: " + IntToString(nApp));
            ChangeShape(oPC, nApp); // with VFX
        }
        return TRUE;
    }

    return FALSE;
}

void RemoveBadEffects(object oTarget)
{
    effect eBad = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eBad))
    {
        switch (GetEffectType(eBad))
        {
            case EFFECT_TYPE_ABILITY_DECREASE:
            case EFFECT_TYPE_AC_DECREASE:
            case EFFECT_TYPE_ATTACK_DECREASE:
            case EFFECT_TYPE_DAMAGE_DECREASE:
            case EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE:
            case EFFECT_TYPE_SAVING_THROW_DECREASE:
            case EFFECT_TYPE_SPELL_RESISTANCE_DECREASE:
            case EFFECT_TYPE_SKILL_DECREASE:
            case EFFECT_TYPE_BLINDNESS:
            case EFFECT_TYPE_DEAF:
            case EFFECT_TYPE_PARALYZE:
            case EFFECT_TYPE_NEGATIVELEVEL:
            case EFFECT_TYPE_FRIGHTENED:
            case EFFECT_TYPE_DAZED:
            case EFFECT_TYPE_CONFUSED:
            case EFFECT_TYPE_POISON:
            case EFFECT_TYPE_DISEASE:
                RemoveEffect(oTarget, eBad);
                break;
        }
        eBad = GetNextEffect(oTarget);
    }
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RESTORATION, FALSE));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RESTORATION), oTarget);
}

void UnequipRegenItems(object oPC)
{
    // If existing unequipped items, exit (reset on respawn scripts)
    object oData = GetPlayerDataObject(oPC);
    if (GetLocalInt(oData, "RegenItem_Count") != 0) return;

    int i, nCount = 0;
    for (i=0; i < NUM_INVENTORY_SLOTS; i++)
    {
        object oItem = GetItemInSlot(i, oPC);
        if (!GetIsObjectValid(oItem)) continue;
        if (GetItemHasItemProperty(oItem, ITEM_PROPERTY_REGENERATION))
        {// store item temporarily
            SetLocalObject(oData, "RegenItem_Slot"+IntToString(i), oItem);
            SendMessageToPC(oPC, "Unequipping "+GetName(oItem));
            CopyItem(oItem, oPC, TRUE);
            DestroyObject(oItem);
            nCount++;
        }
    }
    SetLocalInt(oData, "RegenItem_Count", nCount);
}

void ReEquipRegenItems(object oPC)
{
    // Nothing to re-equip
    object oData = GetPlayerDataObject(oPC);
    if (!GetLocalInt(oData, "RegenItem_Count")) return;

    // Re-Equip all stored items if item is still on oPC
    int i; for(i=0; i < NUM_INVENTORY_SLOTS; i++)
    {
        object oItem = GetLocalObject(oData, "RegenItem_Slot"+IntToString(i));
        if (GetIsObjectValid(oItem) && GetItemPossessor(oItem) == oPC)
        {
            SendMessageToPC(oPC, "Equipping "+GetName(oItem));
            DelayCommand(0.2, AssignCommand(oPC, ActionEquipItem(oItem, i)));
        }
        DeleteLocalObject(oData, "RegenItem_Slot"+IntToString(i));
    }
    DeleteLocalInt(oData, "RegenItem_Count");
}

int GetIsEffectActive(object oTarget, effect eEffect, string sEffectTag)
{
    effect eE = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eE))
    {
        if (GetEffectType(eE) == GetEffectType(eEffect) &&
            GetEffectSubType(eE) == GetEffectSubType(eEffect) &&
            GetEffectDuration(eE) == GetEffectDuration(eEffect) &&
            GetEffectTag(eE) == sEffectTag)
        {
            return TRUE;
        }
        eE = GetNextEffect(oTarget);
    }
    return FALSE;
}

void RemoveEffectsByTag(object oTarget, string sEffectTag)
{
    effect eE = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eE))
    {
        if (GetEffectTag(eE) == sEffectTag)
        {
            RemoveEffect(oTarget, eE);
        }
        eE = GetNextEffect(oTarget);
    }
}

// --- Item Activation (MCS Menu) Functions ------------------------------------

void BuffAbilityScore(int nAbility, object oTarget)
{
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eAbi = EffectLinkEffects(EffectAbilityIncrease(nAbility, d4()+1), eDur);
    int nSpell = -1;

    switch (nAbility)
    {
        case ABILITY_STRENGTH:     nSpell = SPELL_BULLS_STRENGTH; break;
        case ABILITY_DEXTERITY:    nSpell = SPELL_CATS_GRACE;     break;
        case ABILITY_CONSTITUTION: nSpell = SPELL_ENDURANCE;      break;
        case ABILITY_INTELLIGENCE: nSpell = SPELL_FOXS_CUNNING;   break;
        case ABILITY_WISDOM:       nSpell = SPELL_OWLS_WISDOM;    break;
        case ABILITY_CHARISMA:     nSpell = SPELL_EAGLE_SPLEDOR;  break;
    }

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    AddSubraceEffect(oTarget, eAbi, "DMBuff");
    if (nSpell != -1) SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
}

void BuffDamageImmunity(int nSelect, object oTarget)
{
    object oUser = GetPCSpeaker();
    int nStage = GetLocalInt(oUser, "MCS_BUFF_STAGE");

    // Stage 2 : Apply choice
    if (nStage == 1)
    {
        switch (nSelect)
        {// Percentage selection
            case 1: nSelect = 5;   break;
            case 2: nSelect = 10;  break;
            case 3: nSelect = 25;  break;
            case 4: nSelect = 50;  break;
            case 5: nSelect = 75;  break;
            case 6: nSelect = 90;  break;
            case 7: nSelect = 100; break;
        }
        int nDamageType = GetLocalInt(oUser, "MCS_BUFF_CHOICE");
        if (nDamageType == 7)
        {// Unique Case (7 = Bludgeoning, Piercing, and Slashing)
            effect eDI = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, nSelect);
            eDI = EffectLinkEffects(eDI, EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, nSelect));
            eDI = EffectLinkEffects(eDI, EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, nSelect));
            AddSubraceEffect(oTarget, eDI, "DMBuff");
        }
        else
        {// Rest handled normally
            effect eDI = EffectDamageImmunityIncrease(nDamageType, nSelect);
            AddSubraceEffect(oTarget, eDI, "DMBuff");
        }
        // Clear variables
        DeleteLocalInt(oUser, "MCS_BUFF_CHOICE");
        DeleteLocalInt(oUser, "MCS_BUFF_STAGE");
        return;
    }

    // Stage 1 : Save choice
    switch (nSelect)
    {
        case 1:  nSelect = DAMAGE_TYPE_ACID;        break;
        case 2:  nSelect = DAMAGE_TYPE_COLD;        break;
        case 3:  nSelect = DAMAGE_TYPE_DIVINE;      break;
        case 4:  nSelect = DAMAGE_TYPE_ELECTRICAL;  break;
        case 5:  nSelect = DAMAGE_TYPE_FIRE;        break;
        case 6:  nSelect = DAMAGE_TYPE_MAGICAL;     break;
        case 7:  nSelect = DAMAGE_TYPE_NEGATIVE;    break;
        case 8:  nSelect = DAMAGE_TYPE_POSITIVE;    break;
        case 9:  nSelect = DAMAGE_TYPE_SONIC;       break;
        case 10: nSelect = 7; /*All Physical*/      break;
    }
    SetLocalInt(oUser, "MCS_BUFF_CHOICE", nSelect);
    SetLocalInt(oUser, "MCS_BUFF_STAGE", 1); // ready for Stage 2 call
}

void BuffSpellImmunity(int nSelect, object oTarget)
{
    effect eImm = EffectSpellLevelAbsorption(nSelect);
    AddSubraceEffect(oTarget, eImm, "DMBuff");
}

void BuffMiscImmunity(int nSelect, object oTarget)
{
    switch (nSelect)
    {
        case 1:  nSelect = IMMUNITY_TYPE_SNEAK_ATTACK;   break;
        case 2:  nSelect = IMMUNITY_TYPE_CRITICAL_HIT;   break;
        case 3:  nSelect = IMMUNITY_TYPE_DEATH;          break;
        case 4:  nSelect = IMMUNITY_TYPE_DISEASE;        break;
        case 5:  nSelect = IMMUNITY_TYPE_FEAR;           break;
        case 6:  nSelect = IMMUNITY_TYPE_KNOCKDOWN;      break;
        case 7:  nSelect = IMMUNITY_TYPE_NEGATIVE_LEVEL; break;
        case 8:  nSelect = IMMUNITY_TYPE_MIND_SPELLS;    break;
        case 9:  nSelect = IMMUNITY_TYPE_PARALYSIS;      break;
        case 10: nSelect = IMMUNITY_TYPE_POISON;         break;
    }
    effect eImm = EffectImmunity(nSelect);
    AddSubraceEffect(oTarget, eImm, "DMBuff");

    // Also add immunity to ability drain
    if (nSelect == 7)
    {
        eImm = EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE);
        AddSubraceEffect(oTarget, eImm, "DMBuff");
    }
}

void BuffArmorClass(int nSelect, object oTarget)
{
    effect eAC = EffectACIncrease(nSelect);
    AddSubraceEffect(oTarget, eAC, "DMBuff");
}

// --- DMFI Functions ----------------------------------------------------------

int GetIsListenValid(float fDist, int nListen)
{
    if (fDist > 3.0f && fDist < 3.5f && nListen >= 5)    return 2;
    if (fDist >= 3.5f && fDist < 4.5f && nListen >= 10)  return 3;
    if (fDist >= 4.5f && fDist < 5.5f && nListen >= 15)  return 4;
    if (fDist >= 5.5f && fDist < 6.5f && nListen >= 20)  return 5;
    if (fDist >= 6.5f && fDist < 7.5f && nListen >= 25)  return 6;
    if (fDist >= 7.5f && fDist < 8.5f && nListen >= 30)  return 7;
    if (fDist >= 8.5f && fDist < 9.5f && nListen >= 35)  return 8;
    if (fDist >= 9.5f && fDist < 10.0f && nListen >= 40) return 9;
    return 0;
}

int CheckLanguage(object oTarget, int nLanguage)
{
    return (GetLocalInt(oTarget, IntToString(nLanguage)) == 1);
}
