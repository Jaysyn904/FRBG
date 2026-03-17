//::///////////////////////////////////////////////
//:: DMFI - OnPlayerChat event handler
//:: dmfi_onplychat
//:://////////////////////////////////////////////
/*
  Event handler for the module-level OnPlayerChat event. Manages scripter-added
  event scripts.
*/
//:://////////////////////////////////////////////
//:: Created By: Merle, with help from mykael22000 and tsunami282
//:: Created On: 2007.12.12
//:://////////////////////////////////////////////
//:: 2007.12.27 tsunami282 - implemented hooking tree

#include "dmfi_plychat_inc"
#include "mk_inc_editor"
#include "te_lang"
#include "tf_handler"
#include "dmfi_dmwx_inc"
#include "sp_weather"
#include "nwnx_rename"
#include "nwnx_player"
#include "nwnx_chat"
#include "nwnx_creature"
#include "nwnx_admin"
#include "nwnx_webhook_rch"
#include "sfpb_config"
#include "spawn_functions"
#include "ceb_featcheck"
#include "nwnx_inc_const"
#include "te_afflic_func"
//#include "saad_hider"
#include "inc_persist_loca"

const string DMFI_PLAYERCHAT_SCRIPTNAME = "dmfi_plychat_exe";

////////////////////////////////////////////////////////////////////////
void main()
{
    object oItem = OBJECT_INVALID;
    object oMod = GetModule();
    object oPC = GetPCChatSpeaker();
    object oArea = GetArea(oPC);
    string sArea = GetName(oArea);
    string sName = GetName(oPC);
    string sChatMessage = GetPCChatMessage();
    int nVolume = GetPCChatVolume();

////////////////////////////////////////////////////////////////////////
// MK Crafting System -- CCOH
////////////////////////////////////////////////////////////////////////

    int bEditorRunning = GetLocalInt(oPC, g_varEditorRunning);
    if (bEditorRunning) // the editor is running
    {
        int bUseOnPlayerChatEvent =
            GetLocalInt(oPC, g_varEditorUseOnPlayerChatEvent);

        if (bUseOnPlayerChatEvent)
        {
            SetLocalString(oPC, g_varEditorChatMessageString, sChatMessage);

            // the following line is not required but will make everything
            // look much better.
            SetPCChatMessage(""); // delete the message so it does not
                                  // appear above the player's head
        }
        return;
    }


/////////////////////////////////////////////////////////////////////
//Writing System by Bongo, December 2008. OnPlayerChat Script.///////
/////////////////////////////////////////////////////////////////////
//This script stores players chat messages as string when the commands are used.
  /*
  if(GetStringLeft(sChatMessage, 1)=="#")
  {
    string sCommand = GetStringLeft(sChatMessage, 3);
    if((sCommand=="#T#")||(sCommand=="#W#")||(sCommand=="#S#")||(sCommand=="#C#"))
      {
        string sIdentity = GetStringLeft(sChatMessage, 3);
        DeleteLocalString(oPC, sIdentity);
        DeleteLocalString(oPC, "#E#");
        DelayCommand(0.5, SetLocalString(oPC, sIdentity, sChatMessage));
        SendMessageToPC(oPC, sChatMessage);
        SetPCChatMessage("");
        return;
      }
    else if((sCommand=="#E#")||(sCommand=="#R#")||(sCommand=="#F#"))
      {
        DeleteLocalString(oPC, "#E#");
        DelayCommand(0.5, SetLocalString(oPC, "#E#", sChatMessage));
        SendMessageToPC(oPC, sChatMessage);
        SetPCChatMessage("");
        return;
      }
  }
  */
/////////////////////////////////////////////////////////////////////
//Default DMFI Lines. ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
    if (GetIsDM(oPC) || GetIsDMPossessed(oPC))
    {
        int maskChannels, bInvoke, bAutoRemove, iHook, bDirtyList = FALSE;
        string sChatHandlerScript;
        // int bListenAll;
        object oRunner;
        // SendMessageToPC(GetFirstPC(), "OnPlayerChat - process hooks");
        int nHooks = GetLocalArrayUpperBound(oMod, DMFI_CHATHOOK_HANDLE_ARRAYNAME);
        for (iHook = nHooks; iHook > 0; iHook--) // reverse-order execution, last hook gets first dibs
        {
            // SendMessageToPC(GetFirstPC(), "OnPlayerChat -- process hook #" + IntToString(iHook));
            maskChannels = GetLocalArrayInt(oMod, DMFI_CHATHOOK_CHANNELS_ARRAYNAME, iHook);
            // SendMessageToPC(GetFirstPC(), "OnPlayerChat -- channel heard=" + IntToString(nVolume) + ", soughtmask=" + IntToString(maskChannels));
            if (((1 << nVolume) & maskChannels) != 0) // right channel
            {
                // SendMessageToPC(GetFirstPC(), "OnPlayerChat --- channel matched");

                bInvoke = FALSE;
                if (GetLocalArrayInt(oMod, DMFI_CHATHOOK_LISTENALL_ARRAYNAME, iHook) != FALSE)
                {
                    bInvoke = TRUE;
                }
                else
                {
                    object oDesiredSpeaker = GetLocalArrayObject(oMod, DMFI_CHATHOOK_SPEAKER_ARRAYNAME, iHook);
                    if (oPC == oDesiredSpeaker) bInvoke = TRUE;
                }
                if (bInvoke) // right speaker
                {
                    // SendMessageToPC(GetFirstPC(), "OnPlayerChat --- speaker matched");
                    sChatHandlerScript = GetLocalArrayString(oMod, DMFI_CHATHOOK_SCRIPT_ARRAYNAME, iHook);
                    oRunner = GetLocalArrayObject(oMod, DMFI_CHATHOOK_RUNNER_ARRAYNAME, iHook);
                    // SendMessageToPC(GetFirstPC(), "OnPlayerChat --- executing script '" + sChatHandlerScript + "' on object '" + GetName(oRunner) +"'");
                    ExecuteScript(sChatHandlerScript, oRunner);
                    bAutoRemove = GetLocalArrayInt(oMod, DMFI_CHATHOOK_AUTOREMOVE_ARRAYNAME, iHook);
                    if (bAutoRemove)
                    {
                        // SendMessageToPC(GetFirstPC(), "OnPlayerChat --- scheduling autoremove");
                        bDirtyList = TRUE;
                        SetLocalArrayInt(oMod, DMFI_CHATHOOK_HANDLE_ARRAYNAME, iHook, 0);
                    }
                }
            }
        }

        if (bDirtyList) DMFI_ChatHookRemove(0);

        // always execute the DMFI parser
        ExecuteScript(DMFI_PLAYERCHAT_SCRIPTNAME, OBJECT_SELF);
    }


    if (nVolume == TALKVOLUME_TALK || nVolume == TALKVOLUME_WHISPER || nVolume == TALKVOLUME_PARTY)
    {
        string sMessage, sOriginal = GetPCChatMessage();
        location lWhisSource = GetLocation(oPC);
        object oWhisp;

        if (GetStringLeft(sOriginal,1) != "-")
        {
            if (GetIsPC(oPC) && GetStringLength(sOriginal) > 35)
            {
                SetLocalInt(oPC, "nXPReward", TRUE);
            }

            if (GetLocalInt(oPC,"LangOn") == 1)
            {
                //int iLangSpoken = GetLocalInt(oPC,"LangSpoken");
				int iLangSpoken = GetPersistantLocalInt(oPC, "LangSpoken");
                string LANGCOLOR = "<cEþ>";

                if (GetLocalInt(oPC,"nDisguiseName") == 1)
                {
                    sName = NWNX_Rename_GetPCNameOverride(oPC);
                }

                string sSpeaking = GetLanguageName(iLangSpoken);

                NWNX_WebHook_SendWebHookHTTPS("discordapp.com", WEBHOOK_CHAT_CHANNEL, "Translated ("+sSpeaking+"): "+sOriginal, GetName(oPC));

                string sTranslate = LANGCOLOR+sName+" ("+sSpeaking+"): "+sOriginal+"</c>";
                string sColorOut = GetColorForLanguage(iLangSpoken);
                string sOutput=sColorOut+TranslateCommonToLanguage(iLangSpoken,sOriginal)+COLOR_END;

                object oPCs = GetFirstPC();
                while (GetIsObjectValid(oPCs))
                {
                    if (GetIsDM(oPCs)||GetIsDMPossessed(oPCs))
                    {
                        DelayCommand(0.3,SendMessageToPC(oPCs,sTranslate));
                    }
                    oPCs = GetNextPC();
                }

                object oListener = GetFirstObjectInArea(oArea);
                if (nVolume == TALKVOLUME_TALK)
                {
                    while (GetIsObjectValid(oListener))
                    {
                        if (GetIsPC(oListener) && GetObjectHeard(oPC,oListener) && !GetIsDM(oListener))
                        {
                            oItem = GetPlayerDataObject(oListener);
                            if (GetLocalInt(oItem,IntToString(iLangSpoken)) == 1)
                            {
                                DelayCommand(0.3,SendMessageToPC(oListener,sTranslate));
                            }
                        }
                        oListener = GetNextObjectInArea(oArea);
                    }
                }
                else if (nVolume == TALKVOLUME_WHISPER)
                {
                    oWhisp = GetFirstObjectInShape(SHAPE_SPHERE,10.0f,lWhisSource,FALSE,OBJECT_TYPE_CREATURE);
                    while (GetIsObjectValid(oWhisp))
                    {
                        oItem = GetPlayerDataObject(oWhisp);
                        float fDist = GetDistanceBetween(oPC, oWhisp);
                        int nListen = GetSkillRank(SKILL_LISTEN, oWhisp, FALSE);
                        int bValid = GetIsListenValid(fDist, nListen);

                        if (GetObjectHeard(oPC,oWhisp) || fDist <= 3.0f) bValid = 1;
                        if (bValid != 0 && !GetIsDM(oWhisp) && CheckLanguage(oItem, iLangSpoken))
                        {
                            if (bValid >= 2)
                            {
                                NWNX_Chat_SendMessage(NWNX_CHAT_CHANNEL_PLAYER_WHISPER,sOutput,oPC,oWhisp);
                            }
                            DelayCommand(0.3,SendMessageToPC(oWhisp,sTranslate));
                        }
                        oWhisp = GetNextObjectInShape(SHAPE_SPHERE,10.0f,lWhisSource,FALSE,OBJECT_TYPE_CREATURE);
                    }
                }
                SetPCChatMessage(sOutput);
            }
            else if (GetStringLeft(sOriginal,1) == "!")
            {
                object oAnimal = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION,oPC,1);
                if (GetIsObjectValid(oAnimal))
                {
                    sMessage = GetStringRight(sOriginal,GetStringLength(sOriginal)-1);
                    AssignCommand(oAnimal,ActionSpeakString(sMessage,nVolume));
                    SetPCChatMessage("");

                    struct NWNX_WebHook_Message chatMessage;
                    chatMessage.sUsername = "On Player Chat Event";
                    chatMessage.sTitle = "Animal Companion";
                    chatMessage.sColor = "#FFFFFF";
                    chatMessage.sAuthorName = GetName(oPC);
                    chatMessage.sDescription = "Possessing Animal Companion ("+GetName(oAnimal)+")";
                    chatMessage.sField1Name = "Playername";
                    chatMessage.sField1Value = GetPCPlayerName(oPC);
                    chatMessage.iField1Inline = TRUE;
                    chatMessage.sField2Name = "IP";
                    chatMessage.sField2Value = GetPCIPAddress(oPC);
                    chatMessage.iField2Inline = TRUE;
                    chatMessage.sField3Name = "CDKey";
                    chatMessage.sField3Value = GetPCPublicCDKey(oPC);
                    chatMessage.iField3Inline = TRUE;
                    chatMessage.sFooterText = "Knights of Noromath Player Event";
                    chatMessage.iTimestamp = NWNX_Time_GetTimeStamp();
                    string sConstructedMsg = NWNX_WebHook_BuildMessageForWebHook("discordapp.com", WEBHOOK_EVENT_CHANNEL, chatMessage);
                    NWNX_WebHook_SendWebHookHTTPS("discordapp.com", WEBHOOK_EVENT_CHANNEL, sConstructedMsg);
                    //NWNX_WebHook_SendWebHookHTTPS("discordapp.com", WEBHOOK_CHAT_CHANNEL, "Possessing Animal Companion ("+GetName(oAnimal)+"): "+sMessage, GetName(oPC));
                }
            }
            else if (GetStringLeft(sOriginal,1) == "@")
            {
                object oFamiliar = GetAssociate(ASSOCIATE_TYPE_FAMILIAR,oPC,1);
                if (GetIsObjectValid(oFamiliar))
                {
                    sMessage = GetStringRight(sOriginal,GetStringLength(sOriginal)-1);
                    AssignCommand(oFamiliar,ActionSpeakString(sMessage,nVolume));
                    SetPCChatMessage("");

                    struct NWNX_WebHook_Message chatMessage;
                    chatMessage.sUsername = "On Player Chat Event";
                    chatMessage.sTitle = "Familiar";
                    chatMessage.sColor = "#FFFFFF";
                    chatMessage.sAuthorName = GetName(oPC);
                    chatMessage.sDescription = "Possessing Familiar ("+GetName(oFamiliar)+")";
                    chatMessage.sField1Name = "Playername";
                    chatMessage.sField1Value = GetPCPlayerName(oPC);
                    chatMessage.iField1Inline = TRUE;
                    chatMessage.sField2Name = "IP";
                    chatMessage.sField2Value = GetPCIPAddress(oPC);
                    chatMessage.iField2Inline = TRUE;
                    chatMessage.sField3Name = "CDKey";
                    chatMessage.sField3Value = GetPCPublicCDKey(oPC);
                    chatMessage.iField3Inline = TRUE;
                    chatMessage.sFooterText = "Knights of Noromath Player Event";
                    chatMessage.iTimestamp = NWNX_Time_GetTimeStamp();
                    string sConstructedMsg = NWNX_WebHook_BuildMessageForWebHook("discordapp.com", WEBHOOK_EVENT_CHANNEL, chatMessage);
                    NWNX_WebHook_SendWebHookHTTPS("discordapp.com", WEBHOOK_EVENT_CHANNEL, sConstructedMsg);
                    //NWNX_WebHook_SendWebHookHTTPS("discordapp.com", WEBHOOK_CHAT_CHANNEL, "Possessing Familiar ("+GetName(oFamiliar)+"): "+sMessage, GetName(oPC));
                }
            }
            else if (GetStringLeft(sOriginal,1) == "^")
            {
                object oSummoned = GetAssociate(ASSOCIATE_TYPE_SUMMONED,oPC,1);
                if (GetIsObjectValid(oSummoned))
                {
                    sMessage = GetStringRight(sOriginal,GetStringLength(sOriginal)-1);
                    AssignCommand(oSummoned,ActionSpeakString(sMessage,nVolume));
                    SetPCChatMessage("");

                    struct NWNX_WebHook_Message chatMessage;
                    chatMessage.sUsername = "On Player Chat Event";
                    chatMessage.sTitle = "Summoned Creature";
                    chatMessage.sColor = "#FFFFFF";
                    chatMessage.sAuthorName = GetName(oPC);
                    chatMessage.sDescription = "Possessing Summon ("+GetName(oSummoned)+")";
                    chatMessage.sField1Name = "Playername";
                    chatMessage.sField1Value = GetPCPlayerName(oPC);
                    chatMessage.iField1Inline = TRUE;
                    chatMessage.sField2Name = "IP";
                    chatMessage.sField2Value = GetPCIPAddress(oPC);
                    chatMessage.iField2Inline = TRUE;
                    chatMessage.sField3Name = "CDKey";
                    chatMessage.sField3Value = GetPCPublicCDKey(oPC);
                    chatMessage.iField3Inline = TRUE;
                    chatMessage.sFooterText = "Knights of Noromath Player Event";
                    chatMessage.iTimestamp = NWNX_Time_GetTimeStamp();
                    string sConstructedMsg = NWNX_WebHook_BuildMessageForWebHook("discordapp.com", WEBHOOK_EVENT_CHANNEL, chatMessage);
                    NWNX_WebHook_SendWebHookHTTPS("discordapp.com", WEBHOOK_EVENT_CHANNEL, sConstructedMsg);
                    //NWNX_WebHook_SendWebHookHTTPS("discordapp.com", WEBHOOK_CHAT_CHANNEL, "Possessing Summon ("+GetName(oSummoned)+"): "+sMessage, GetName(oPC));
                }
            }
            else if (GetStringLeft(sOriginal,1) == "%")
            {
                object oDominate = GetAssociate(ASSOCIATE_TYPE_DOMINATED,oPC,1);
                if (GetIsObjectValid(oDominate))
                {
                    sMessage = GetStringRight(sOriginal,GetStringLength(sOriginal)-1);
                    AssignCommand(oDominate,ActionSpeakString(sMessage,nVolume));
                    SetPCChatMessage("");

                    struct NWNX_WebHook_Message chatMessage;
                    chatMessage.sUsername = "On Player Chat Event";
                    chatMessage.sTitle = "Dominated Creature";
                    chatMessage.sColor = "#FFFFFF";
                    chatMessage.sAuthorName = GetName(oPC);
                    chatMessage.sDescription = "Possessing Dominated ("+GetName(oDominate)+")";
                    chatMessage.sField1Name = "Playername";
                    chatMessage.sField1Value = GetPCPlayerName(oPC);
                    chatMessage.iField1Inline = TRUE;
                    chatMessage.sField2Name = "IP";
                    chatMessage.sField2Value = GetPCIPAddress(oPC);
                    chatMessage.iField2Inline = TRUE;
                    chatMessage.sField3Name = "CDKey";
                    chatMessage.sField3Value = GetPCPublicCDKey(oPC);
                    chatMessage.iField3Inline = TRUE;
                    chatMessage.sFooterText = "Knights of Noromath Player Event";
                    chatMessage.iTimestamp = NWNX_Time_GetTimeStamp();
                    string sConstructedMsg = NWNX_WebHook_BuildMessageForWebHook("discordapp.com", WEBHOOK_EVENT_CHANNEL, chatMessage);
                    NWNX_WebHook_SendWebHookHTTPS("discordapp.com", WEBHOOK_EVENT_CHANNEL, sConstructedMsg);
                    //NWNX_WebHook_SendWebHookHTTPS("discordapp.com", WEBHOOK_CHAT_CHANNEL, "Possessing Dominated ("+GetName(oDominate)+"): "+sMessage, GetName(oPC));
                }
            }
            else if (GetStringLeft(sOriginal,1) == "$")
            {
                object oHenchman = GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oPC,1);
                if (GetIsObjectValid(oHenchman))
                {
                    sMessage = GetStringRight(sOriginal,GetStringLength(sOriginal)-1);
                    AssignCommand(oHenchman,ActionSpeakString(sMessage,nVolume));
                    SetPCChatMessage("");

                    struct NWNX_WebHook_Message chatMessage;
                    chatMessage.sUsername = "On Player Chat Event";
                    chatMessage.sTitle = "Henchman";
                    chatMessage.sColor = "#FFFFFF";
                    chatMessage.sAuthorName = GetName(oPC);
                    chatMessage.sDescription = "Possessing Henchman ("+GetName(oHenchman)+")";
                    chatMessage.sField1Name = "Playername";
                    chatMessage.sField1Value = GetPCPlayerName(oPC);
                    chatMessage.iField1Inline = TRUE;
                    chatMessage.sField2Name = "IP";
                    chatMessage.sField2Value = GetPCIPAddress(oPC);
                    chatMessage.iField2Inline = TRUE;
                    chatMessage.sField3Name = "CDKey";
                    chatMessage.sField3Value = GetPCPublicCDKey(oPC);
                    chatMessage.iField3Inline = TRUE;
                    chatMessage.sFooterText = "Knights of Noromath Player Event";
                    chatMessage.iTimestamp = NWNX_Time_GetTimeStamp();
                    string sConstructedMsg = NWNX_WebHook_BuildMessageForWebHook("discordapp.com", WEBHOOK_EVENT_CHANNEL, chatMessage);
                    NWNX_WebHook_SendWebHookHTTPS("discordapp.com", WEBHOOK_EVENT_CHANNEL, sConstructedMsg);
                    //NWNX_WebHook_SendWebHookHTTPS("discordapp.com", WEBHOOK_CHAT_CHANNEL, "Possessing Henchman ("+GetName(oHenchman)+"): "+sMessage, GetName(oPC));
                }
            }
            else if (nVolume == TALKVOLUME_WHISPER)
            {
                oWhisp = GetFirstObjectInShape(SHAPE_SPHERE,10.0f,lWhisSource,FALSE,OBJECT_TYPE_CREATURE);
                while (GetIsObjectValid(oWhisp))
                {
                    float fDist = GetDistanceBetween(oPC, oWhisp);
                    int nListen = GetSkillRank(SKILL_LISTEN, oWhisp, FALSE);
                    if (GetIsListenValid(fDist, nListen) >= 2)
                    {
                        NWNX_Chat_SendMessage(NWNX_CHAT_CHANNEL_PLAYER_WHISPER,sOriginal,oPC,oWhisp);
                    }
                    oWhisp = GetNextObjectInShape(SHAPE_SPHERE,10.0f,lWhisSource,FALSE,OBJECT_TYPE_CREATURE);
                }
            }
            // I am going to attempt my performance system checks in here, and then continue past this with the rest of the script, so don't use returns at the end: Saadow -7/28/24
            else if(GetLocalInt(GetPlayerDataObject(oPC),"PcIsPerforming")>=1)
            {
                int SaadPerformCheck = GetSkillRank(SKILL_PERFORM,oPC,FALSE)+d20(1);
                if  (SaadPerformCheck == (GetSkillRank(SKILL_PERFORM,oPC,FALSE)+1))
                {
                    SetPCChatMessage("<cüL@>(CRITICAL FAILURE)</c>"+"<cýáý>"+sOriginal+"</c>");
                    SetLocalInt(GetPlayerDataObject(oPC),"PcIsPerforming",0);
                    SetLocalInt(GetPlayerDataObject(oPC),"SaadPerformanceAccumulator",0);
                    SetLocalInt(oPC,"walk", 0);
                    NWNX_Player_SetAlwaysWalk(oPC,FALSE);
                    //RemoveEffect(oPC,saadMusicVis);
                    effect eLoop = GetFirstEffect(oPC);
                    while(GetIsEffectValid(eLoop))
                    {
                        if(GetEffectSpellId(eLoop) == 544003)
                            {
                            RemoveEffect(oPC, eLoop);
                            eLoop = GetNextEffect(oPC);
                            //return;
                            //eLoop = GetFirstEffect(oPC);
                            }
                        else
                            {
                            eLoop = GetNextEffect(oPC);
                            }
                    }
                }
                else
                {
                    //Rodor wuz heer
                    SetPCChatMessage("<cOüO>("+IntToString(SaadPerformCheck)+")</c>"+"<cýáý>"+sOriginal+"</c>");
                    SetLocalInt(GetPlayerDataObject(oPC),"PcIsPerforming",1);
                    SetLocalInt(GetPlayerDataObject(oPC),"SaadPerformanceAccumulator",GetLocalInt(GetPlayerDataObject(oPC),"SaadPerformanceAccumulator")+1);
                }
            }
            // this should continue as normal past here
        }
        else
        {
            sChatMessage = GetStringRight(sChatMessage,GetStringLength(sOriginal)-1);
            string sDisguiseName = GetStringRight(sChatMessage,GetStringLength(sOriginal)-6);
            SetPCChatMessage("");
            object oDataObject = GetPlayerDataObject(oPC);

            string sCurrCommandArg = parseArgs(sChatMessage,0);
            sCurrCommandArg = GetStringLowerCase(sCurrCommandArg);
            string sCommandArg2 = parseArgs(sChatMessage,1);
            sCommandArg2 = GetStringLowerCase(sCommandArg2);
            string sCommandArg3 = parseArgs(sChatMessage,2);
            sCommandArg3 = GetStringLowerCase(sCommandArg3);

            int nD20 = d20(1);
            string sCrit = "";
            string sRollString = CYAN;
            if (nD20 == 1)  {sCrit = DARKRED+"\nCritical Failure!"+COLOR_END;}

            if (sCurrCommandArg == "help")
            {
                string sHelpCommand ="SP Console Command List: \n";
                sHelpCommand += "-help : Gives Command List \n";
                sHelpCommand += "! : Allows you to speak as a valid animal companion. Syntax: !<text>\n";
                sHelpCommand += "@ : Allows you to speak as a valid familiar. Syntax: @<text>\n";
                sHelpCommand += "^ : Allows you to speak as a valid summoned creature. (Use Henchman command if not working) Syntax: ^<text>\n";
                sHelpCommand += "% : Allows you to speak as a valid dominated creature. Syntax: %<text>\n";
                sHelpCommand += "$ : Allows you to speak as a valid henchman. (Use this command if summoned creatures not working) Syntax: $<text>\n";
                sHelpCommand += "-afk : Toggles your status indicated by a flashing glow or whether you're back.\n";
                sHelpCommand += "-animation : Allows you to change your animation style for combat. Does not work while mounted. Certain styles are gated. To see styles available, use \"-animation list\".\n";
                sHelpCommand += "-app : Allows you to save your current appearance (if not polymorphed) or fix it. Syntax: -app \"Save\", -app \"Fix\", or -app \"Set\"(DMs only)\n";
                sHelpCommand += "-debuff : Allows you to completely remove all spells you have cast on yourself. Syntax: -debuff \n";
                sHelpCommand += "-decloak : Allows you to remove only the invisibility effect you have cast on yourself. Syntax: -decloak \n";
                sHelpCommand += "-delete : Allows you to delete a character from your vault. Syntax: -delete \n";
                sHelpCommand += "-disguise : Allows you to disguise yourself using the various toggles on the examine system. (Class Standing, Strength, Dexterity, and Constitution) Syntax: -disguise \"Command\" Use -disguise help for full list.\n";
                sHelpCommand += "-door : Allows you to manage and interact with a nearby settlement door/rentable room. To use properly, stand next the door you wish to modify before typing this command. Syntax: -door \n";
                sHelpCommand += "-emote : Allows you to emote doing a particular action. For a full list of available emotes, use \"-emote list\". Syntax: -emote \"Action\" Ex: -emote sit \n";
                sHelpCommand += "-enchant : Allows enchanters to check the number of enchantments on an item. You must have the item's required feat. \n";
                sHelpCommand += "-helmet : Toggles helmet visibility \n";
                sHelpCommand += "-cloak : Toggles cloak visibility \n";
                sHelpCommand += "-findus : Allows players to locate other players, use findus 1 to allow locating, and findus 0 to disable locating. \n";
                if (GetLevelByClass(CLASS_TYPE_WARLOCK,oPC)>=1)
                {
                    sHelpCommand += "-essence : Allows you to change your Eldritch Blast's essence. Syntax: -essence \"essence\" Ex: -ess frightful \n";
                }
                sHelpCommand += "-joust : Allows you to use the Jousting animation instead of standard riding animation. Syntax: -joust \"on/off\" \n";
                if (GetLevelByClass(CLASS_TYPE_MONK,oPC)>=1)
                {
                    sHelpCommand += "-ki : Returns your current ki level.\n";
                }
                sHelpCommand += "-lang / -speak : Sets new language to speak. Normal speech going forward will be in that language. To no longer speak a language, use \"-lang common\" Syntax: -lang \"language\" Ex: -lang Alzhedo \n";
                sHelpCommand += "-lockinplace : Makes your character locked in place (uncommandable) until \"-unlock\" command is used.\n";
                sHelpCommand += "-mythic : Allows you to view your current mythic xp stats \n";
                sHelpCommand += "-name : If disguise is on, this will allow you to change your displayed name. This will not persist across reset or log-out/crash. Syntax: - name \"Disguise Name\" Ex: -name Malcolm Reed \n";
                if (GetHasFeat(1203,oPC) || GetLevelByClass(CLASS_TYPE_DRUID,oPC) >= 13 || GetHasFeat(1458,oPC))
                {
                    sHelpCommand += "-pheno : Allows you to toggle your phenotype on the fly, switching between large and normal. Syntax: -pheno. \n";
                }
                sHelpCommand += "-place : Allows you to update the name or description of a placeable. Functions similarly to the writing system. Type \"-place help\" for all available commands. Syntax: -place. \n";
                sHelpCommand += "-pic : Change your portrait. Use \"-pic set\" for something specific or custom. Type \"-pic help\" for more info.\n";
                sHelpCommand += "-piety : Returns your current divine standing in the form of piety (0-100)\n";
                sHelpCommand += "-proficiency : Allows you to select a proficiency if the conversation does not appear for you the first time.\n";
                sHelpCommand += "-rest : Gives next rest time. \n";
                sHelpCommand += "-rename : Allows you to change the name and description of an object in your inventory. Type \"-rename help\" for all available commands. Syntax: -rename.\n";
                sHelpCommand += "-roll : Privately rolls a desired skill or ability. For full list of available rolls, use \"-roll list\" Syntax: -roll \"Ability/Skill/Save\" Ex: -roll will \n";
                sHelpCommand += "-rollp : Experimental public roll function, use \"-rollp list\" Syntax: -rollp \"Ability/Skill/Save\" Ex: -rollp will \n";
                sHelpCommand += "-scale : Adjust your size using a range of -3.0 to 3.0 with 1.0 being Normal sized. Example \"-scale 0.5\" to be 50% of normal size. Value of 0 or \"reset\" return 1.0\n";
                sHelpCommand += "-spellfire : Displays the number of charges in your spellfire mana pool. Syntax: -spellfire\n";
                if (GetLevelByClass(CLASS_TYPE_MONK,oPC)>1)
                {
                    sHelpCommand += "-style : Allows you to cycle through the available styles for your monk order, use \"-style list\" to display all available styles. Use \"-style <type>\" to activate a particular style. \n";
                    sHelpCommand += "Use \"-style off\" to turn off your monk style and stop draining ki.\n";
                }
                if (GetLevelByClass(CLASS_TYPE_BARD,oPC)>1)
                {
                    sHelpCommand += "-performing : A bard may begin a performance, which will cause the bard to begin walking only. As the bard plays, they may type posts which will automatically roll a performance check. \n";
                    sHelpCommand += "As long as they don't critically fail, they can continue performing until they type the command again. Once they type the command a second time, non-hostile NPC's in a colossal area \n";
                    sHelpCommand += "will make a will save based on your bard levels, every failed save will result in some small amount of gold earned and experience. \n";
                }
                sHelpCommand += "-subdual : Tells you whether Subdual mode is on or off. Type \"-subdual on\" to turn subdual mode on. Type \"-subdual off\" to turn subdual mode off.\n";
                sHelpCommand += "-stuck : Cancels any actions and attempts to 'fix' your character being .. well .. stuck.\n";
                sHelpCommand += "-tournament : Tells you whether Tournament mode is on or off. Type \"-tournament on\" to turn Tournament mode on. Type \"-tournament off\" to turn Tournament mode off.\n";
                sHelpCommand += "-time : Tells you the precise time IG when Timepiece item is in inventory. \n";
                if (GetHasFeat(1439,oPC))
                {
                    sHelpCommand += "-track : Tracks creatures down within a given area and populates their location if you successfully find their tracks. Type \"-track\" to use this proficiency. Ex: -track \n";
                }
                sHelpCommand += "-unlock : Unlocks your character (commandable again). Used after \"-lockinplace\" was used.\n";
                sHelpCommand += "-walk : Sets your character to ALWAYS walk when you travel. Useful for elves. Syntax: -walk. \n";
                sHelpCommand += "-weather : Gives the standard weather feedback message that displays on entry. Syntax: -weather.\n";
                sHelpCommand += "-write : Access to the writing menu for editing pieces of paper in game. Type \"-write help\" for all available commands. Syntax: -write.\n";
                sHelpCommand += "-voice : Assign yourself a voiceset by ID. Example: \"-voice 433\" which is Female, Adventurer. Type \"-voice help #\" for ID list where # is page number starting with 1.\n";
                sHelpCommand += "-xpgp : Toggle the gaining of XP or GP (updates per round). Use 0(off) or 1(on) values. Example: \"-xpgp 1\" will gain GP instead of XP.\n";
                if (GetHasFeat(1599,oPC))
                {
                    sHelpCommand +="-weave : Gives the general state of the weave in the area.\n";
                }
                if (GetIsDM(oPC) || GetIsDMPossessed(oPC))
                {
                    sHelpCommand +="-setdeadmagic : sets dead magic to the given number (Higher dead magic increases the chance of spell failure).\n";
                    sHelpCommand +="-setwildmagic : sets wild magic to the given number (Higher wild magic increases the chance of RANDOMNESS).\n";
                    sHelpCommand +="-shopset : sets the price for the given shop unique string., ARG2 = UNIQUE STRING, ARG3 = PRICE\n";
                    sHelpCommand +="-ness : resets NESS spawned creatures.\n";
                    sHelpCommand +="-copyarea : may copy an area, maybe -Saadow. (still not working)\n";
                }
                sHelpCommand +="-bug : Gives a bug report to the DMs";
                SendMessageToPC(oPC,sHelpCommand);
            }
            else if (sCurrCommandArg == "shout")
            {
                string sNewOriginal = GetStringRight(sChatMessage,GetStringLength(sOriginal)-7);
                //int iLangShout = GetLocalInt(oPC,"LangSpoken");
				int iLangShout = GetPersistantLocalInt(oPC, "LangSpoken");
                object oShoutArea = GetArea(oPC);
                string sShoutName = GetName(oPC);

                if (GetLocalInt(oPC,"nDisguiseName") == 1)
                {
                    sShoutName = NWNX_Rename_GetPCNameOverride(oPC);
                }

                string sShouting = GetLanguageName(iLangShout);

                if (GetLocalInt(oPC,"LangOn") == 1)
                {
                    NWNX_WebHook_SendWebHookHTTPS("discordapp.com", WEBHOOK_CHAT_CHANNEL, "Translated ("+sShouting+"): "+sNewOriginal, GetName(oPC));
                }

                string sTranslateShout = "<cEþ>"+sShoutName+" ("+sShouting+"): "+sNewOriginal+"</c>";
                string sColorShout = GetColorForLanguage(iLangShout);
                string sShoutOutput=sColorShout+TranslateCommonToLanguage(iLangShout,sNewOriginal)+COLOR_END;

                object oShout = GetFirstPC();
                object oShoutData;

                while (GetIsObjectValid(oShout))
                {
                    if (GetIsDM(oShout) || GetIsDMPossessed(oShout))
                    {
                        DelayCommand(0.3,SendMessageToPC(oShout,sTranslateShout));
                    }

                    if (GetArea(oShout) == oShoutArea)
                    {
                        oShoutData = GetItemPossessedBy(oShout,"PC_Data_Object");
                        NWNX_Chat_SendMessage(NWNX_CHAT_CHANNEL_PLAYER_TALK,sShoutOutput,oPC,oShout);
                        if (GetLocalInt(oShoutData,IntToString(iLangShout)) == 1)
                        {
                            DelayCommand(0.3,SendMessageToPC(oShout,sTranslateShout));
                        }
                    }
                }
            }
            else if (sCurrCommandArg == "essence" || sCurrCommandArg =="ess" || sCurrCommandArg =="warlock" || sCurrCommandArg == "war")
            {
                if (GetLevelByClass(CLASS_TYPE_WARLOCK,oPC) >= 1)
                {
                    int nEssence = GetLocalInt(oPC,"nEssence");

                    if ((sCommandArg2 == "frightful" || sCommandArg2 == "fright") && GetHasFeat(1575,oPC))
                    {
                        if (GetLocalInt(oPC,"nEssence") == 1055) {SetLocalInt(oPC,"nEssence",0); SendMessageToPC(oPC,"You are no longer using an essence.");}
                        else {SetLocalInt(oPC,"nEssence",1055);  SendMessageToPC(oPC,"You are now using Frightful Blast essence.");}
                    }
                    else if ((sCommandArg2 == "sickening" || sCommandArg2 == "sick") && GetHasFeat(1576,oPC))
                    {
                        if (GetLocalInt(oPC,"nEssence") == 1056) {SetLocalInt(oPC,"nEssence",0); SendMessageToPC(oPC,"You are no longer using an essence.");}
                        else {SetLocalInt(oPC,"nEssence",1056);  SendMessageToPC(oPC,"You are now using Sickening Blast essence.");}
                    }
                    else if ((sCommandArg2 == "brimstone" || sCommandArg2 == "brim"|| sCommandArg2 == "fire") && GetHasFeat(1577,oPC))
                    {
                        if (GetLocalInt(oPC,"nEssence") == 1057) {SetLocalInt(oPC,"nEssence",0); SendMessageToPC(oPC,"You are no longer using an essence.");}
                        else {SetLocalInt(oPC,"nEssence",1057);  SendMessageToPC(oPC,"You are now using Brimstone Blast essence.");}
                    }
                    else if ((sCommandArg2 == "hellrime" || sCommandArg2 == "hell"|| sCommandArg2 == "cold") && GetHasFeat(1578,oPC))
                    {
                        if (GetLocalInt(oPC,"nEssence") == 1058) {SetLocalInt(oPC,"nEssence",0); SendMessageToPC(oPC,"You are no longer using an essence.");}
                        else {SetLocalInt(oPC,"nEssence",1058);  SendMessageToPC(oPC,"You are now using Hellrime Blast essence.");}
                    }
                    else if ((sCommandArg2 == "vitriolic" || sCommandArg2 == "vitr"|| sCommandArg2 == "acid") && GetHasFeat(1579,oPC))
                    {
                        if (GetLocalInt(oPC,"nEssence") == 1059) {SetLocalInt(oPC,"nEssence",0); SendMessageToPC(oPC,"You are no longer using an essence.");}
                        else {SetLocalInt(oPC,"nEssence",1059);  SendMessageToPC(oPC,"You are now using Vitriolic Blast essence.");}
                    }
                    else if ((sCommandArg2 == "bewitching" || sCommandArg2 == "bewitch") && GetHasFeat(1580,oPC))
                    {
                        if (GetLocalInt(oPC,"nEssence") == 1060) {SetLocalInt(oPC,"nEssence",0); SendMessageToPC(oPC,"You are no longer using an essence.");}
                        else {SetLocalInt(oPC,"nEssence",1060);  SendMessageToPC(oPC,"You are now using Bewitching Blast essence.");}
                    }
                    else if ((sCommandArg2 == "utterdark" || sCommandArg2 == "utter"|| sCommandArg2 == "neg") && GetHasFeat(1581,oPC))
                    {
                        if (GetLocalInt(oPC,"nEssence") == 1061) {SetLocalInt(oPC,"nEssence",0); SendMessageToPC(oPC,"You are no longer using an essence.");}
                        else {SetLocalInt(oPC,"nEssence",1061);  SendMessageToPC(oPC,"You are now using Utterdark Blast essence.");}
                    }
                    else if ((sCommandArg2 == "repelling" || sCommandArg2 == "repel") && GetHasFeat(1582,oPC))
                    {
                        if (GetLocalInt(oPC,"nEssence") == 1062) {SetLocalInt(oPC,"nEssence",0); SendMessageToPC(oPC,"You are no longer using an essence.");}
                        else {SetLocalInt(oPC,"nEssence",1062);  SendMessageToPC(oPC,"You are now using Repelling Blast essence.");}
                    }
                    else if (sCommandArg2 == "none" || sCommandArg2 == "off")
                    {
                        SendMessageToPC(oPC,"Essence type set to none.");
                        SetLocalInt(oPC,"nEssence",0);
                    }
                    else
                    {
                        SendMessageToPC(oPC,"Essence type not recognized - Essence set to None.");
                        SetLocalInt(oPC,"nEssence",0);
                    }
                }
                else
                {
                    SendMessageToPC(oPC,"Command not available to non-warlocks.");
                }
            }
            else if (sCurrCommandArg == "enchant")
            {
                object oEnchantItem = GetLocalObject(oPC,"ObjectEdit");
                string sFeat;
                switch (GetBaseItemType(oEnchantItem))
                {
                    case BASE_ITEM_AMULET:
                    case BASE_ITEM_BELT:
                    case BASE_ITEM_BOOTS:
                    case BASE_ITEM_CLOAK:
                    case BASE_ITEM_GLOVES:
                    case BASE_ITEM_BRACER:
                    case BASE_ITEM_HELMET:
                    sFeat = "Craft_Wonderous_Item";
                    break;
                    case BASE_ITEM_RING:
                    sFeat = "Forge_Ring";
                    break;
                    case BASE_ITEM_ARMOR:
                    case BASE_ITEM_BASTARDSWORD:
                    case BASE_ITEM_BATTLEAXE:
                    case BASE_ITEM_CLUB:
                    case BASE_ITEM_DAGGER:
                    case BASE_ITEM_DART:
                    case BASE_ITEM_DIREMACE:
                    case BASE_ITEM_DOUBLEAXE:
                    case BASE_ITEM_DWARVENWARAXE:
                    case BASE_ITEM_GREATAXE:
                    case BASE_ITEM_GREATSWORD:
                    case BASE_ITEM_HALBERD:
                    case BASE_ITEM_HEAVYCROSSBOW:
                    case BASE_ITEM_HEAVYFLAIL:
                    case BASE_ITEM_KAMA:
                    case BASE_ITEM_KATANA:
                    case BASE_ITEM_KUKRI:
                    case BASE_ITEM_LARGESHIELD:
                    case BASE_ITEM_LIGHTCROSSBOW:
                    case BASE_ITEM_LIGHTFLAIL:
                    case BASE_ITEM_LIGHTHAMMER:
                    case BASE_ITEM_LIGHTMACE:
                    case BASE_ITEM_LONGBOW:
                    case BASE_ITEM_LONGSWORD:
                    case BASE_ITEM_MORNINGSTAR:
                    case BASE_ITEM_QUARTERSTAFF:
                    case BASE_ITEM_RAPIER:
                    case BASE_ITEM_SCIMITAR:
                    case BASE_ITEM_SCYTHE:
                    case BASE_ITEM_SHORTBOW:
                    case BASE_ITEM_SHORTSPEAR:
                    case BASE_ITEM_SHORTSWORD:
                    case BASE_ITEM_SHURIKEN:
                    case BASE_ITEM_SICKLE:
                    case BASE_ITEM_SLING:
                    case BASE_ITEM_SMALLSHIELD:
                    case BASE_ITEM_THROWINGAXE:
                    case BASE_ITEM_TOWERSHIELD:
                    case BASE_ITEM_TRIDENT:
                    case BASE_ITEM_TWOBLADEDSWORD:
                    case BASE_ITEM_WARHAMMER:
                    case BASE_ITEM_WHIP:
                    sFeat = "Craft_Magic_Arms_And_Armor";
                    break;
                }
                if (FeatCheck(sFeat, oPC))
                {
                    string sEnchantReturn = "";
                    sEnchantReturn += "Enchantments Used: ";
                    if (sFeat == "Craft_Magic_Arms_And_Armor")
                    {
                        sEnchantReturn += IntToString(GetLocalInt(oEnchantItem, "ArmorCap") + GetLocalInt(oEnchantItem, "WeaponCap"));
                    }
                    if (sFeat == "Forge_Ring")
                    {
                        sEnchantReturn += IntToString(GetLocalInt(oEnchantItem, "AccessoryCap"));
                    }
                    if (sFeat == "Craft_Magic_Arms_And_Armor")
                    {
                        sEnchantReturn += IntToString(GetLocalInt(oEnchantItem, "AccessoryCap"));
                    }
                    SendMessageToPC(oPC, sEnchantReturn);
                    return;
                }
                else
                {
                    SendMessageToPC(oPC, "You do not have the feat used to enchant this item, and as such cannot tell its enchantments");
                }
            }
            else if (sCurrCommandArg == "copyarea")
            {
                if (GetIsDM(oPC) || GetIsDMPossessed(oPC))
                {
                    SendMessageToPC(oPC,"This command is not working yet, sorry. -Saadow");//CreateArea(GetArea(oPC),"",0,0);//GetArea(oPC),(ObjectToString(oPC)+GetArea(oPC)),GetName(GetArea(oPC))+"_"+ObjectToString(oPC));
                    return;
                }
                else
                {
                    SendMessageToPC(oPC,"This command is available only to Dungeonmasters or Questmasters.");
                    return;
                }
            }
            else if (sCurrCommandArg == "rename")
            {
                object oRenameObject = GetLocalObject(oPC,"ObjectEdit");
                string sObjText;
                string sItemDesc;
                if (!GetIsObjectValid(oRenameObject) && GetItemPossessor(oRenameObject) != oPC)
                {
                    SendMessageToPC(oPC,"You must select an object with the Combiner (silver star) tool to be able to edit the name or description of an object.");
                    return;
                }

                if (sCommandArg2 == "help")
                {
                    SendMessageToPC(oPC,"The Rename Command allows you to edit the title and description of any valid item in your inventory.\nThe following commands are available:\nhelp - gives this help message\ntitle - changes the title of an item\nadd - adds your text in addition to the text already on the item\nnew - overwrites all text on the item as your text\nline - starts your added text on new line.");
                }
                else if (sCommandArg2 == "title")
                {
                    sObjText = GetStringRight(sChatMessage,GetStringLength(sOriginal)-14);
                    SetName(oRenameObject,sObjText);
                    SendMessageToPC(oPC,"Title of item set as: "+sObjText);
                }
                else if (sCommandArg2 == "add")
                {
                    sObjText = GetStringRight(sChatMessage,GetStringLength(sOriginal)-12);
                    sItemDesc = GetDescription(oRenameObject,FALSE,TRUE);
                    SetDescription(oRenameObject,sItemDesc+" "+sObjText,TRUE);
                    SendMessageToPC(oPC,"Text added to item as: "+sObjText);
                }
                else if (sCommandArg2 == "line")
                {
                    sObjText = GetStringRight(sChatMessage,GetStringLength(sOriginal)-13);
                    sItemDesc = GetDescription(oRenameObject,FALSE,TRUE);
                    SetDescription(oRenameObject,sItemDesc+"\n"+sObjText,TRUE);
                    SendMessageToPC(oPC,"Text added to new line of item description as: "+sObjText);
                }
                else if (sCommandArg2 == "new")
                {
                    sObjText = GetStringRight(sChatMessage,GetStringLength(sOriginal)-12);
                    sItemDesc = GetDescription(oRenameObject,FALSE,TRUE);
                    SetDescription(oRenameObject,sObjText,TRUE);
                    SendMessageToPC(oPC,"New description given to line of item description as: "+sObjText);
                }
            }
            else if (sCurrCommandArg == "proficiency"|| sCurrCommandArg == "prof")
            {
                if (GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"Prof") >= 1)
                {
                    SendMessageToPC(oPC,"Please choose an additional proficiency. Proficiencies cannot be banked, and will become void if you do not choose an additional proficiency.");
                    AssignCommand(oPC,ActionStartConversation(oPC,"te_prof_lvl",TRUE,FALSE));
                }
                else
                {
                    SendMessageToPC(oPC,"You do not have any proficiencies that may be selected.");
                }
            }
            else if (sCurrCommandArg == "mastery")
            {
                if (     sCommandArg2 == "necromancy"    || sCommandArg2 == "nec" ) SendMessageToPC(oPC,IntToString(GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"Necromancy"))+" spellmastery in necromancy.");
                else if (sCommandArg2 == "transmutation" || sCommandArg2 == "tra" ) SendMessageToPC(oPC,IntToString(GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"Transmutation"))+" spellmastery in transmutation.");
                else if (sCommandArg2 == "abjuration"    || sCommandArg2 == "abj" ) SendMessageToPC(oPC,IntToString(GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"Abjuration"))+" spellmastery in abjuration.");
                else if (sCommandArg2 == "divination"    || sCommandArg2 == "div" ) SendMessageToPC(oPC,IntToString(GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"Divination"))+" spellmastery in divination.");
                else if (sCommandArg2 == "conjuration"   || sCommandArg2 == "con" ) SendMessageToPC(oPC,IntToString(GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"Conjuration"))+" spellmastery in conjuration.");
                else if (sCommandArg2 == "enchantment"   || sCommandArg2 == "enc" ) SendMessageToPC(oPC,IntToString(GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"Enchantment"))+" spellmastery in enchantment.");
                else if (sCommandArg2 == "evocation"     || sCommandArg2 == "evo" ) SendMessageToPC(oPC,IntToString(GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"Evocation"))+" spellmastery in evocation.");
                else if (sCommandArg2 == "illusion"      || sCommandArg2 == "ill" ) SendMessageToPC(oPC,IntToString(GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"Illusion"))+" spellmastery in illusion.");
            }
            else if (sCurrCommandArg == "mythic")
            {
                object oData = GetPlayerDataObject(oPC);
                SendMessageToPC(oPC,"A new point in each skill is achieved at 1000, 2000, 4000, and 8000 Mythic Points.");
                SendMessageToPC(oPC,IntToString(GetLocalInt(oData,"MythicSTR"))+" Mythic Strength Points");
                SendMessageToPC(oPC,IntToString(GetLocalInt(oData,"MythicDEX"))+" Mythic Dexterity Points");
                SendMessageToPC(oPC,IntToString(GetLocalInt(oData,"MythicCON"))+" Mythic Constitution Points");
                SendMessageToPC(oPC,IntToString(GetLocalInt(oData,"MythicINT"))+" Mythic Intelligence Points");
                SendMessageToPC(oPC,IntToString(GetLocalInt(oData,"MythicWIS"))+" Mythic Wisdom Points");
                SendMessageToPC(oPC,IntToString(GetLocalInt(oData,"MythicCHA"))+" Mythic Charisma Points");
            }
            else if (sCurrCommandArg == "afk")
            {
                object oData = GetPlayerDataObject(oPC);
                if (GetLocalInt(oData,"isAFK"))
                {
                    // Remove AFK status
                    SetCommandable(TRUE, oPC);
                    FloatingTextStringOnCreature("Is back from being AFK", oPC);
                    RemoveEffectsByTag(oPC, "AFK");

                    SetLocalInt(oData, "isAFK", FALSE);
                }
                else
                {
                    // Apply visual effect, display message, and lock character in place
                    SetCommandable(FALSE, oPC);
                    FloatingTextStringOnCreature("Is now AFK", oPC);
                    effect eAFK = EffectVisualEffect(VFX_DUR_AURA_PULSE_RED_WHITE);
                    AddSubraceEffect(oPC, eAFK, "AFK");

                    SetLocalInt(oData, "isAFK", TRUE);
                }
            }
            // SAADOW NEW COMMAND IN HERE, CLOAK AND HELMET, HIDE EITHER
            else if (sCurrCommandArg == "cloak")
            {
            // Determine item slot of the item to hide/show
            int nSlot = INVENTORY_SLOT_CLOAK;
            // Determine the item to hide/show
            oItem = GetItemInSlot(nSlot, oPC);
            // If there's no item in the slot, then exit
            if (!GetIsObjectValid(oItem))
            {
            return;
            }

            // Determine if currently shown
            int nShown = GetHiddenWhenEquipped(oItem);
            // Toggle the state
            SetHiddenWhenEquipped(oItem, (nShown == TRUE ? FALSE : TRUE));
            // Send feedback
            SendMessageToPC(oPC, "Cloak toggled!");
            // Exit
            }
            else if (sCurrCommandArg == "helmet")
            {
            // Determine item slot of the item to hide/show
            int nSlot = INVENTORY_SLOT_HEAD;
            // Determine the item to hide/show
            oItem = GetItemInSlot(nSlot, oPC);
            // If there's no item in the slot, then exit
            if (!GetIsObjectValid(oItem))
            {
            return;
            }

            // Determine if currently shown
            int nShown = GetHiddenWhenEquipped(oItem);

            // Toggle the state
            SetHiddenWhenEquipped(oItem, (nShown == TRUE ? FALSE : TRUE));

            // Send feedback
            SendMessageToPC(oPC, "Helmet toggled!");

            // Exit


            }
            //End new command, 6/9/24
            else if (sCurrCommandArg == "animation" || sCurrCommandArg == "anim" || sCurrCommandArg == "anime")
            {
                if (sCommandArg2 == "list")
                {
                    string sAnimList = "You are able to use the following combat styles:\n";

                    if (GetLevelByClass(CLASS_TYPE_DRUID,oPC)   >= 1 ||
                       GetLevelByClass(CLASS_TYPE_FIGHTER,oPC) >= 1 ||
                       GetLevelByClass(CLASS_TYPE_RANGER,oPC)  >= 1 ||
                       GetLevelByClass(CLASS_TYPE_PALADIN,oPC) >= 1 ||
                       GetLevelByClass(CLASS_TYPE_CLERIC,oPC)  >= 1)
                    {
                        sAnimList += "- Sword Master\n";
                    }
                    if (GetLevelByClass(CLASS_TYPE_DRUID,oPC)   >= 1 ||
                       GetLevelByClass(CLASS_TYPE_FIGHTER,oPC) >= 1 ||
                       GetLevelByClass(CLASS_TYPE_RANGER,oPC)  >= 1 ||
                       GetLevelByClass(CLASS_TYPE_PALADIN,oPC) >= 1 ||
                       GetLevelByClass(CLASS_TYPE_CLERIC,oPC)  >= 1)
                    {
                        sAnimList += "- Brute\n";
                    }
                    if (GetLevelByClass(CLASS_TYPE_DRUID,oPC)   >= 1 ||
                       GetLevelByClass(CLASS_TYPE_FIGHTER,oPC) >= 1 ||
                       GetLevelByClass(CLASS_TYPE_RANGER,oPC)  >= 1 ||
                       GetLevelByClass(CLASS_TYPE_PALADIN,oPC) >= 1)
                    {
                        sAnimList += "- Soldier's Stance\n";
                    }
                    if (GetLevelByClass(CLASS_TYPE_ASSASSIN,oPC) >= 1 ||
                       GetLevelByClass(CLASS_TYPE_RANGER,oPC)   >= 1 ||
                       GetLevelByClass(CLASS_TYPE_ROGUE,oPC)    >= 1 )
                    {
                        sAnimList += "- Twin Jambiyas\n";
                    }
                    if (GetLevelByClass(CLASS_TYPE_FIGHTER,oPC)   >= 1 ||
                       GetLevelByClass(CLASS_TYPE_BARD,oPC)      >= 1 ||
                       GetLevelByClass(CLASS_TYPE_RANGER,oPC)    >= 1 ||
                       GetLevelByClass(CLASS_TYPE_BLACKCOAT,oPC) >= 1 ||
                       GetLevelByClass(CLASS_TYPE_ROGUE,oPC)     >= 1 )
                    {
                        sAnimList += "- Duelist\n";
                    }
                    if (GetLevelByClass(CLASS_TYPE_CLERIC,oPC)    >= 1 ||
                       GetLevelByClass(CLASS_TYPE_WIZARD,oPC)    >= 1 ||
                       GetLevelByClass(CLASS_TYPE_SORCERER,oPC)  >= 1 ||
                       GetLevelByClass(CLASS_TYPE_SPELLFIRE,oPC) >= 1 ||
                       GetLevelByClass(CLASS_TYPE_DRUID,oPC)     >= 1 ||
                       GetLevelByClass(CLASS_TYPE_WARLOCK,oPC)   >= 1 )
                    {
                        sAnimList += "- Arcane\n";
                    }
                    sAnimList += "To activate a fighting style, type \"-animation <style>\", EX: \"-style duelist\" activates Duelist animations.\n";
                    sAnimList += "To deactivate a fighting style, type \"-animation none\".";
                    SendMessageToPC(oPC,sAnimList);
                }
                else if (sCommandArg2 == "none")
                {
                    if (HorseGetIsMounted(oPC) != TRUE &&
                      (GetPhenoType(oPC) == 50|| GetPhenoType(oPC) == 51||GetPhenoType(oPC) == 52||GetPhenoType(oPC) == 53||GetPhenoType(oPC) == 54||
                       GetPhenoType(oPC) == 55||GetPhenoType(oPC) == 56)
                      )
                    {
                        SetPhenoType(0,oPC);
                    }
                    else{SendMessageToPC(oPC,"Command is unavailable while mounted.");}
                }
                else if (sCommandArg2 == "sword" || sCommandArg2 == "master"|| sCommandArg2 == "kensei")
                {
                    if (GetLevelByClass(CLASS_TYPE_DRUID,oPC)   >= 1 ||
                       GetLevelByClass(CLASS_TYPE_FIGHTER,oPC) >= 1 ||
                       GetLevelByClass(CLASS_TYPE_RANGER,oPC)  >= 1 ||
                       GetLevelByClass(CLASS_TYPE_PALADIN,oPC) >= 1 ||
                       GetLevelByClass(CLASS_TYPE_CLERIC,oPC)  >= 1)
                    {
                        if (HorseGetIsMounted(oPC) != TRUE)
                        {
                            SetPhenoType(50,oPC);
                            SendMessageToPC(oPC,"Fighting Style: Sword Master.");
                        }
                        else{SendMessageToPC(oPC,"Command is unavailable while mounted.");}
                    }
                }
                else if (sCommandArg2 == "brute" || sCommandArg2 == "heavy")
                {
                    if (GetLevelByClass(CLASS_TYPE_DRUID,oPC)   >= 1 ||
                       GetLevelByClass(CLASS_TYPE_FIGHTER,oPC) >= 1 ||
                       GetLevelByClass(CLASS_TYPE_RANGER,oPC)  >= 1 ||
                       GetLevelByClass(CLASS_TYPE_PALADIN,oPC) >= 1)
                    {
                        if (HorseGetIsMounted(oPC) != TRUE)
                        {
                            SetPhenoType(52,oPC);
                            SendMessageToPC(oPC,"Fighting Style: Brute.");
                        }
                        else{SendMessageToPC(oPC,"Command is unavailable while mounted.");}
                    }
                }
                else if (sCommandArg2 == "fence" || sCommandArg2 == "duelist" || sCommandArg2 == "duel")
                {
                    if (GetLevelByClass(CLASS_TYPE_FIGHTER,oPC)   >= 1 ||
                       GetLevelByClass(CLASS_TYPE_BARD,oPC)      >= 1 ||
                       GetLevelByClass(CLASS_TYPE_RANGER,oPC)    >= 1 ||
                       GetLevelByClass(CLASS_TYPE_BLACKCOAT,oPC) >= 1 ||
                       GetLevelByClass(CLASS_TYPE_ROGUE,oPC)     >= 1 )
                    {
                        if (HorseGetIsMounted(oPC) != TRUE)
                        {
                            SetPhenoType(53,oPC);
                            SendMessageToPC(oPC,"Fighting Style: Duelist.");
                        }
                        else{SendMessageToPC(oPC,"Command is unavailable while mounted.");}
                    }
                }
                else if (sCommandArg2 == "warrior" || sCommandArg2 == "soldier"|| sCommandArg2 == "phalanx" || sCommandArg2 == "soldier's")
                {
                    if (GetLevelByClass(CLASS_TYPE_DRUID,oPC)   >= 1 ||
                       GetLevelByClass(CLASS_TYPE_FIGHTER,oPC) >= 1 ||
                       GetLevelByClass(CLASS_TYPE_RANGER,oPC)  >= 1 ||
                       GetLevelByClass(CLASS_TYPE_PALADIN,oPC) >= 1 ||
                       GetLevelByClass(CLASS_TYPE_CLERIC,oPC)  >= 1)
                    {
                        if (HorseGetIsMounted(oPC) != TRUE)
                        {
                            SetPhenoType(56,oPC);
                            SendMessageToPC(oPC,"Fighting Style: Soldier's Stance.");
                        }
                        else{SendMessageToPC(oPC,"Command is unavailable while mounted.");}
                    }
                }
                else if (sCommandArg2 == "assassin" || sCommandArg2 == "jambiya"|| sCommandArg2 == "twin"|| sCommandArg2 == "jambiyas")
                {
                    if (GetLevelByClass(CLASS_TYPE_ASSASSIN,oPC) >= 1 ||
                       GetLevelByClass(CLASS_TYPE_RANGER,oPC)   >= 1 ||
                       GetLevelByClass(CLASS_TYPE_ROGUE,oPC)    >= 1 )
                    {
                        if (HorseGetIsMounted(oPC) != TRUE)
                        {
                            SetPhenoType(51,oPC);
                            SendMessageToPC(oPC,"Fighting Style: Twin Jambiyas.");
                        }
                        else{SendMessageToPC(oPC,"Command is unavailable while mounted.");}
                    }
                }
                else if (sCommandArg2 == "arcane" || sCommandArg2 == "levitation"|| sCommandArg2 == "magic")
                {
                    if (GetLevelByClass(CLASS_TYPE_CLERIC,oPC)    >= 1 ||
                       GetLevelByClass(CLASS_TYPE_WIZARD,oPC)    >= 1 ||
                       GetLevelByClass(CLASS_TYPE_SORCERER,oPC)  >= 1 ||
                       GetLevelByClass(CLASS_TYPE_SPELLFIRE,oPC) >= 1 ||
                       GetLevelByClass(CLASS_TYPE_DRUID,oPC)     >= 1 ||
                       GetLevelByClass(CLASS_TYPE_WARLOCK,oPC)   >= 1 )
                    {
                        if (HorseGetIsMounted(oPC) != TRUE)
                        {
                            SetPhenoType(54,oPC);
                            SendMessageToPC(oPC,"Fighting Style: Arcane.");
                        }
                        else{SendMessageToPC(oPC,"Command is unavailable while mounted.");}
                    }
                }
                else
                {
                    SendMessageToPC(oPC,"Command not recognized. Self destruct activated. Type \"-animation list\" for a list of available animations.");
                }
            }
            else if (sCurrCommandArg == "app")
            {
                // This command will save their current appearance
                // * Will not save if polymorphed
                if (sCommandArg2 == "save")
                {
                    string sMsg = "Your appearance";
                    if (GetHasEffect(EFFECT_TYPE_POLYMORPH, oPC)) {
                        sMsg += " was not saved under a polymorph effect!";
                    } else {
                        sMsg += " including wings and tail(if any), are saved.";
                        SaveAppearance(oPC);
                    }
                    SendMessageToPC(oPC, sMsg);
                }
                // This command will revert their original appearance
                else if (sCommandArg2 == "fix")
                {
                    // First clear and retrieve original apeparance
                    ClearApperearance(oPC);
                    int nDefApp = GetTrueAppearance(oPC);

                    // Take afflictions into account
                    switch (GetPCAffliction(oPC))
                    {
                        case 8: nDefApp = 1099; break;
                        case 6: case 4:
                            nDefApp = GetGender(oPC) == GENDER_MALE ? 3548 : 3531;
                            break;
                    }

                    // Perform change
                    ChangeShape(oPC, nDefApp, FALSE);
                    SendMessageToPC(oPC, "--Appearance Restored--");
                }
                // This command clears appearance data from their data object
                // * Also helpful to debug and fix appearances if completely boinked
                else if (sCommandArg2 == "clear")
                {
                    ClearApperearance(oPC);
                    SendMessageToPC(oPC, "--Appearance Data Cleared--");
                }
                // DMs Only - Can set their own appearances if they know the number
                else if (sCommandArg2 == "set" && (GetIsDM(oPC) || GetIsDMPossessed(oPC)))
                {
                    if (!GetIsValidString(sCommandArg3, "0123456789"))
                    {
                        SendMessageToPC(oPC, "You must enter a valid appearance ID (numbers only)");
                    }
                    else
                    {
                        int nAppearance = StringToInt(sCommandArg3);
                        ChangeShape(oPC, nAppearance); // uses polymorph VFX
                    }
                }
            }
            else if (sCurrCommandArg == "ki")
            {
                SendMessageToPC(oPC,"Your ki level is currently "+IntToString(GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"KiLevel"))+".");
            }
            else if (sCurrCommandArg == "pheno")
            {
                if (sCommandArg2 == "fix")
                {
                    if (!HorseGetIsMounted(oPC)) {SetPhenoType(0,oPC);}
                }

                int nPheno = StringToInt(sCommandArg2);
                if (!HorseGetIsMounted(oPC) && GetIsDM(oPC))
                {
                    SetPhenoType(nPheno,oPC);
                    return;
                }

                if (!HorseGetIsMounted(oPC))
                {
                    if (GetHasFeat(1203,oPC) || GetLevelByClass(CLASS_TYPE_DRUID,oPC) >= 13 || GetHasFeat(1458,oPC))
                    {
                        if (GetPhenoType(oPC) == PHENOTYPE_NORMAL)
                        {
                            SetPhenoType(PHENOTYPE_BIG,oPC);
                            SendMessageToPC(oPC,"Phenotype set to large.");
                        }
                        else
                        {
                            SetPhenoType(PHENOTYPE_NORMAL,oPC);
                            SendMessageToPC(oPC,"Phenotype set to normal.");
                        }
                    }
                }
            }
            else if (sCurrCommandArg == "style")
            {
                if ((GetLevelByClass(CLASS_TYPE_MONK,oPC) >= 1 && !HorseGetIsMounted(oPC))|| GetIsDM(oPC))
                {
                    SendMessageToPC(oPC,"Your ki level is currently "+IntToString(GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"KiLevel"))+".");
                    if (sCommandArg2 == "list"||sCommandArg2 == "help")
                    {
                        string MonkList = "Your deity has revealed the following martial arts styles:\n";
                        if (GetHasFeat(DEITY_Sune,oPC) || GetHasFeat(DEITY_Selune,oPC) || GetHasFeat(DEITY_Lathander,oPC) || GetHasFeat(DEITY_Kossuth,oPC))
                        {
                            MonkList += "- Flaming Fist\n";
                        }
                        if (GetHasFeat(DEITY_Sune,oPC) || GetHasFeat(DEITY_Selune,oPC) || GetHasFeat(DEITY_Lathander,oPC) || GetHasFeat(DEITY_Shar,oPC))
                        {
                            MonkList += "- Eclipse\n";
                        }
                        if (GetHasFeat(DEITY_Shar,oPC))
                        {
                            MonkList += "- Cobra\n";
                        }
                        if (GetHasFeat(DEITY_Mystra,oPC))
                        {
                            MonkList += "- Deva\n";
                        }
                        if (GetHasFeat(DEITY_Ilmater,oPC))
                        {
                            MonkList += "- Eagle\n";
                        }
                        if (GetHasFeat(DEITY_Akadi,oPC))
                        {
                            MonkList += "- Step of the Wind\n";
                        }
                        if (GetHasFeat(DEITY_Ishtisha,oPC))
                        {
                            MonkList += "- Shapeless Flow\n";
                        }
                        if (GetHasFeat(DEITY_Kelemvor,oPC))
                        {
                            MonkList += "- Call of the Grave\n";
                        }
                        if (GetHasFeat(DEITY_Azuth,oPC))
                        {
                            MonkList += "- Hellfire\n";
                        }
                        if (GetHasFeat(DEITY_Grumbar,oPC))
                        {
                            MonkList += "- Stubburn Stone\n";
                        }
                        if (GetHasFeat(DEITY_Halfling_Powers,oPC))
                        {
                            MonkList += "- Careful Step\n";
                        }
                        if (GetHasFeat(DEITY_Underdark_Powers,oPC))
                        {
                            MonkList += "- Silence of the Night\n";
                        }
                        if (GetHasFeat(DEITY_Talos,oPC))
                        {
                            MonkList += "-Call of Battle\n";
                        }
                        if (GetHasFeat(DEITY_Chauntea,oPC))
                        {
                            MonkList += "-Flower of Life\n";
                        }
                        if (GetHasFeat(DEITY_Dwarven_Powers,oPC))
                        {
                            MonkList += "-Stonedragon\n";
                        }
                        if (GetHasFeat(DEITY_Bane,oPC))
                        {
                            MonkList += "-Vengeful Responce\n";
                        }
                        if ((GetHasFeat(DEITY_Akadi,oPC) || GetHasFeat(DEITY_Silvanus,oPC) || GetHasFeat(DEITY_Chauntea,oPC) || GetHasFeat(DEITY_Ishtisha,oPC)) && (GetCalendarMonth() == 3 || GetCalendarMonth() == 4 || GetCalendarMonth() == 5))
                        {
                            MonkList += "-Spring's Wrath\n";
                        }
                        if ((GetHasFeat(DEITY_Akadi,oPC) || GetHasFeat(DEITY_Silvanus,oPC) || GetHasFeat(DEITY_Chauntea,oPC) || GetHasFeat(DEITY_Ishtisha,oPC)) && (GetCalendarMonth() == 6 || GetCalendarMonth() == 7 || GetCalendarMonth() == 8))
                        {
                            MonkList += "-Summer's Wrath\n";
                        }
                        if ((GetHasFeat(DEITY_Akadi,oPC) || GetHasFeat(DEITY_Silvanus,oPC) || GetHasFeat(DEITY_Chauntea,oPC) || GetHasFeat(DEITY_Ishtisha,oPC)) && (GetCalendarMonth() == 9 || GetCalendarMonth() == 10 || GetCalendarMonth() == 11))
                        {
                            MonkList += "-Autumn's Wrath\n";
                        }
                        if ((GetHasFeat(DEITY_Akadi,oPC) || GetHasFeat(DEITY_Silvanus,oPC) || GetHasFeat(DEITY_Chauntea,oPC) || GetHasFeat(DEITY_Ishtisha,oPC)) && (GetCalendarMonth() == 12 || GetCalendarMonth() == 1 || GetCalendarMonth() == 2))
                        {
                            MonkList += "-Winter's Wrath\n";
                        }

                        MonkList += "To activate a fighting style, type \"-style <style>\", EX: \"-style flaming\" activates Flaming Fist.\n";
                        MonkList += "To deactivate a fighting style, type \"-style none\".";
                        SendMessageToPC(oPC,MonkList);
                    }
                    else if (sCommandArg2 == "flame" || sCommandArg2 == "flaming" || sCommandArg2 == "sun"|| sCommandArg2 == "soul")
                    {
                        if (GetHasFeat(DEITY_Sune,oPC) || GetHasFeat(DEITY_Selune,oPC) || GetHasFeat(DEITY_Lathander,oPC) || GetHasFeat(DEITY_Kossuth,oPC))
                        {
                            if (GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"KiLevel")>=5 || GetIsDM(oPC))
                            {
                                SetLocalInt(oPC,"MonkStyle",1);
                                if (GetPhenoType(oPC) == 0){SetPhenoType(58,oPC);}
                                SendMessageToPC(oPC,"You are now using Flaming Fist style martial arts. You will consume ki while in this stance.");
                            }
                            else {SendMessageToPC(oPC,"Your ki is too low to begin using this style.");}
                        }
                        else {SendMessageToPC(oPC,"You are not trained in this style.");}
                    }
                    else if (sCommandArg2 == "eclipse" || sCommandArg2 == "moon")
                    {
                        if (GetHasFeat(DEITY_Sune,oPC) || GetHasFeat(DEITY_Selune,oPC) || GetHasFeat(DEITY_Lathander,oPC) || GetHasFeat(DEITY_Shar,oPC))
                        {
                            if (GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"KiLevel")>=5 || GetIsDM(oPC))
                            {
                                SetLocalInt(oPC,"MonkStyle",2);
                                if (GetPhenoType(oPC) == 0){SetPhenoType(59,oPC);}
                                SendMessageToPC(oPC,"You are now using Eclipse style martial arts. You will consume ki while in this stance.");
                            }
                            else {SendMessageToPC(oPC,"Your ki is too low to begin using this style.");}
                        }
                    }
                    else if (sCommandArg2 == "cobra" || sCommandArg2 == "snake" || sCommandArg2 == "shar")
                    {
                        if (GetHasFeat(DEITY_Shar,oPC))
                        {
                            if (GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"KiLevel")>=5 || GetIsDM(oPC))
                            {
                                SetLocalInt(oPC,"MonkStyle",3);
                                if (GetPhenoType(oPC) == 0){SetPhenoType(57,oPC);}
                                SendMessageToPC(oPC,"You are now using Cobra style martial arts. You will consume ki while in this stance.");
                            }
                            else {SendMessageToPC(oPC,"Your ki is too low to begin using this style.");}
                        }
                        else {SendMessageToPC(oPC,"You are not trained in this style.");}
                    }
                    else if (sCommandArg2 == "deva" || sCommandArg2 == "divine" || sCommandArg2 == "azuth" || sCommandArg2 == "magic")
                    {
                        if (GetHasFeat(DEITY_Mystra,oPC))
                        {
                            if (GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"KiLevel")>=5 || GetIsDM(oPC))
                            {
                                SetLocalInt(oPC,"MonkStyle",4);
                                if (GetPhenoType(oPC) == 0){SetPhenoType(58,oPC);}
                                SendMessageToPC(oPC,"You are now using Deva style martial arts. You will consume ki while in this stance.");
                            }
                            else {SendMessageToPC(oPC,"Your ki is too low to begin using this style.");}
                        }
                        else {SendMessageToPC(oPC,"You are not trained in this style.");}
                    }
                    else if (sCommandArg2 == "step of the wind" || sCommandArg2 == "step" || sCommandArg2 == "wind" || sCommandArg2 == "go fast" || sCommandArg2 == "zoom" || sCommandArg2 == "akadi")
                    {
                        if (GetHasFeat(DEITY_Akadi,oPC) || GetHasFeat(DEITY_Ishtisha,oPC))
                        {
                            if (GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"KiLevel")>=5 || GetIsDM(oPC))
                            {
                                SetLocalInt(oPC,"MonkStyle",6);
                                if (GetPhenoType(oPC) == 0){SetPhenoType(58,oPC);}
                                SendMessageToPC(oPC,"You are now using Step of the Wind style martial arts. You will consume ki while in this stance.");
                            }
                            else {SendMessageToPC(oPC,"Your ki is too low to begin using this style.");}
                        }
                        else {SendMessageToPC(oPC,"You are not trained in this style.");}
                    }
                    else if (sCommandArg2 == "shapeless flow" || sCommandArg2 == "flow" || sCommandArg2 == "shapeless" || sCommandArg2 == "poof" || sCommandArg2 == "missed me" || sCommandArg2 == "istishia")
                    {
                        if (GetHasFeat(DEITY_Ishtisha,oPC))
                        {
                            if (GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"KiLevel")>=5 || GetIsDM(oPC))
                            {
                                SetLocalInt(oPC,"MonkStyle",7);
                                if (GetPhenoType(oPC) == 0){SetPhenoType(58,oPC);}
                                SendMessageToPC(oPC,"You are now using Shapeless Flow style martial arts. You will consume ki while in this stance.");
                            }
                            else {SendMessageToPC(oPC,"Your ki is too low to begin using this style.");}
                        }
                        else {SendMessageToPC(oPC,"You are not trained in this style.");}
                    }
                    else if (sCommandArg2 == "call of the grave" || sCommandArg2 == "grave" || sCommandArg2 == "call" || sCommandArg2 == "kelemvor")
                    {
                        if (GetHasFeat(DEITY_Kelemvor,oPC))
                        {
                            if (GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"KiLevel")>=5 || GetIsDM(oPC))
                            {
                                SetLocalInt(oPC,"MonkStyle",9);
                                if (GetPhenoType(oPC) == 0){SetPhenoType(58,oPC);}
                                SendMessageToPC(oPC,"You are now using Call of the Grave style martial arts. You will consume ki while in this stance.");
                            }
                            else {SendMessageToPC(oPC,"Your ki is too low to begin using this style.");}
                        }
                        else {SendMessageToPC(oPC,"You are not trained in this style.");}
                    }
                    else if (sCommandArg2 == "hellfire" || sCommandArg2 == "hell" || sCommandArg2 == "azuth")
                    {
                        if (GetHasFeat(DEITY_Azuth,oPC))
                        {
                            if (GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"KiLevel")>=5 || GetIsDM(oPC))
                            {
                                SetLocalInt(oPC,"MonkStyle",8);
                                if (GetPhenoType(oPC) == 0){SetPhenoType(58,oPC);}
                                SendMessageToPC(oPC,"You are now using Hellfire style martial arts. You will consume ki while in this stance.");
                            }
                            else {SendMessageToPC(oPC,"Your ki is too low to begin using this style.");}
                        }
                        else {SendMessageToPC(oPC,"You are not trained in this style.");}
                    }
                    else if (sCommandArg2 == "stubburn stone" || sCommandArg2 == "stubburn" || sCommandArg2 == "grumbar")
                    {
                        if (GetHasFeat(DEITY_Grumbar,oPC))
                        {
                            if (GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"KiLevel")>=5 || GetIsDM(oPC))
                            {
                                SetLocalInt(oPC,"MonkStyle",10);
                                if (GetPhenoType(oPC) == 0){SetPhenoType(58,oPC);}
                                SendMessageToPC(oPC,"You are now using the Stubburn Stone style martial arts. You will consume ki while in this stance.");
                            }
                            else {SendMessageToPC(oPC,"Your ki is too low to begin using this style.");}
                        }
                        else {SendMessageToPC(oPC,"You are not trained in this style.");}
                    }
                    else if (sCommandArg2 == "careful step" || sCommandArg2 == "careful" || sCommandArg2 == "halfling")
                    {
                        if (GetHasFeat(DEITY_Halfling_Powers,oPC))
                        {
                            if (GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"KiLevel")>=5 || GetIsDM(oPC))
                            {
                                SetLocalInt(oPC,"MonkStyle",11);
                                if (GetPhenoType(oPC) == 0){SetPhenoType(58,oPC);}
                                SendMessageToPC(oPC,"You are now using the Careful Step style martial arts. You will consume ki while in this stance.");
                            }
                            else {SendMessageToPC(oPC,"Your ki is too low to begin using this style.");}
                        }
                        else {SendMessageToPC(oPC,"You are not trained in this style.");}
                    }
                    else if (sCommandArg2 == "call of battle" || sCommandArg2 == "battle" || sCommandArg2 == "call" || sCommandArg2 == "talos")
                    {
                        if (GetHasFeat(DEITY_Talos,oPC))
                        {
                            if (GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"KiLevel")>=5 || GetIsDM(oPC))
                            {
                                SetLocalInt(oPC,"MonkStyle",12);
                                if (GetPhenoType(oPC) == 0){SetPhenoType(58,oPC);}
                                SendMessageToPC(oPC,"You are now using Call of Battle style martial arts. You will consume ki while in this stance.");
                            }
                            else {SendMessageToPC(oPC,"Your ki is too low to begin using this style.");}
                        }
                        else {SendMessageToPC(oPC,"You are not trained in this style.");}
                    }
                    else if (sCommandArg2 == "silence of the night" || sCommandArg2 == "silence" || sCommandArg2 == "night" || sCommandArg2 == "underdark")
                    {
                        if (GetHasFeat(DEITY_Underdark_Powers,oPC))
                        {
                            if (GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"KiLevel")>=5 || GetIsDM(oPC))
                            {
                                SetLocalInt(oPC,"MonkStyle",13);
                                if (GetPhenoType(oPC) == 0){SetPhenoType(58,oPC);}
                                SendMessageToPC(oPC,"You are now using the Silence of the Night style martial arts. You will consume ki while in this stance.");
                            }
                            else {SendMessageToPC(oPC,"Your ki is too low to begin using this style.");}
                        }
                        else {SendMessageToPC(oPC,"You are not trained in this style.");}
                    }
                    else if (sCommandArg2 == "flower of life" || sCommandArg2 == "life" || sCommandArg2 == "flower" || sCommandArg2 == "chauntea")
                    {
                        if (GetHasFeat(DEITY_Chauntea,oPC))
                        {
                            if (GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"KiLevel")>=5 || GetIsDM(oPC))
                            {
                                SetLocalInt(oPC,"MonkStyle",14);
                                if (GetPhenoType(oPC) == 0){SetPhenoType(58,oPC);}
                                SendMessageToPC(oPC,"You are now using the Flower of Life style martial arts. You will consume ki while in this stance.");
                            }
                            else {SendMessageToPC(oPC,"Your ki is too low to begin using this style.");}
                        }
                        else {SendMessageToPC(oPC,"You are not trained in this style.");}
                    }
                    else if (sCommandArg2 == "stonedragon" || sCommandArg2 == "stone" || sCommandArg2 == "dragon" || sCommandArg2 == "moradin")
                    {
                        if (GetHasFeat(DEITY_Dwarven_Powers,oPC))
                        {
                            if (GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"KiLevel")>=5 || GetIsDM(oPC))
                            {
                                SetLocalInt(oPC,"MonkStyle",15);
                                if (GetPhenoType(oPC) == 0){SetPhenoType(58,oPC);}
                                SendMessageToPC(oPC,"You are now using Stonedragon style martial arts. You will consume ki while in this stance.");
                            }
                            else {SendMessageToPC(oPC,"Your ki is too low to begin using this style.");}
                        }
                        else {SendMessageToPC(oPC,"You are not trained in this style.");}
                    }
                    else if (sCommandArg2 == "vengeful responce" || sCommandArg2 == "vengeful" || sCommandArg2 == "responce" || sCommandArg2 == "bane")
                    {
                        if (GetHasFeat(DEITY_Bane,oPC))
                        {
                            if (GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"KiLevel")>=5 || GetIsDM(oPC))
                            {
                                SetLocalInt(oPC,"MonkStyle",16);
                                if (GetPhenoType(oPC) == 0){SetPhenoType(58,oPC);}
                                SendMessageToPC(oPC,"You are now using Vengeful Responce style martial arts. You will consume ki while in this stance.");
                            }
                            else {SendMessageToPC(oPC,"Your ki is too low to begin using this style.");}
                        }
                        else {SendMessageToPC(oPC,"You are not trained in this style.");}
                    }
                    else if (sCommandArg2 == "spring's wrath" || sCommandArg2 == "spring" || sCommandArg2 == "wrath" || sCommandArg2 == "springs wrath")
                    {
                        if ((GetHasFeat(DEITY_Akadi,oPC) || GetHasFeat(DEITY_Silvanus,oPC) || GetHasFeat(DEITY_Chauntea,oPC) || GetHasFeat(DEITY_Ishtisha,oPC)) && (GetCalendarMonth() == 3 || GetCalendarMonth() == 4 || GetCalendarMonth() == 5))
                        {
                            if (GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"KiLevel")>=5 || GetIsDM(oPC))
                            {
                                SetLocalInt(oPC,"MonkStyle",17);
                                if (GetPhenoType(oPC) == 0){SetPhenoType(58,oPC);}
                                SendMessageToPC(oPC,"You are now using Spring's Wrath style martial arts. You will consume ki while in this stance.");
                            }
                            else {SendMessageToPC(oPC,"Your ki is too low to begin using this style.");}
                        }
                        else {SendMessageToPC(oPC,"You are not trained in this style.");}
                    }
                    else if (sCommandArg2 == "summer's wrath" || sCommandArg2 == "summer" || sCommandArg2 == "wrath" || sCommandArg2 == "summers wrath")
                    {
                        if ((GetHasFeat(DEITY_Akadi,oPC) || GetHasFeat(DEITY_Silvanus,oPC) || GetHasFeat(DEITY_Chauntea,oPC) || GetHasFeat(DEITY_Ishtisha,oPC)) && (GetCalendarMonth() == 6 || GetCalendarMonth() == 7 || GetCalendarMonth() == 8))
                        {
                            if (GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"KiLevel")>=5 || GetIsDM(oPC))
                            {
                                SetLocalInt(oPC,"MonkStyle",18);
                                if (GetPhenoType(oPC) == 0){SetPhenoType(58,oPC);}
                                SendMessageToPC(oPC,"You are now using Winter's Wrath style martial arts. You will consume ki while in this stance.");
                            }
                            else {SendMessageToPC(oPC,"Your ki is too low to begin using this style.");}
                        }
                        else {SendMessageToPC(oPC,"You are not trained in this style.");}
                    }
                    else if (sCommandArg2 == "autumn's wrath" || sCommandArg2 == "autumn" || sCommandArg2 == "wrath" || sCommandArg2 == "autumns wrath")
                    {
                        if ((GetHasFeat(DEITY_Akadi,oPC) || GetHasFeat(DEITY_Silvanus,oPC) || GetHasFeat(DEITY_Chauntea,oPC) || GetHasFeat(DEITY_Ishtisha,oPC)) && (GetCalendarMonth() == 9 || GetCalendarMonth() == 10 || GetCalendarMonth() ==11))
                        {
                            if (GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"KiLevel")>=5 || GetIsDM(oPC))
                            {
                                SetLocalInt(oPC,"MonkStyle",19);
                                if (GetPhenoType(oPC) == 0){SetPhenoType(58,oPC);}
                                SendMessageToPC(oPC,"You are now using Autumn's Wrath style martial arts. You will consume ki while in this stance.");
                            }
                            else {SendMessageToPC(oPC,"Your ki is too low to begin using this style.");}
                        }
                        else {SendMessageToPC(oPC,"You are not trained in this style.");}
                    }
                    else if (sCommandArg2 == "winter's wrath" || sCommandArg2 == "winter" || sCommandArg2 == "wrath" || sCommandArg2 == "winters wrath")
                    {
                        if ((GetHasFeat(DEITY_Akadi,oPC) || GetHasFeat(DEITY_Silvanus,oPC) || GetHasFeat(DEITY_Chauntea,oPC) || GetHasFeat(DEITY_Ishtisha,oPC)) && (GetCalendarMonth() == 12 || GetCalendarMonth() == 1 || GetCalendarMonth() == 2))
                        {
                            if (GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"KiLevel")>=5 || GetIsDM(oPC))
                            {
                                SetLocalInt(oPC,"MonkStyle",20);
                                if (GetPhenoType(oPC) == 0){SetPhenoType(58,oPC);}
                                SendMessageToPC(oPC,"You are now using Winter's Wrath style martial arts. You will consume ki while in this stance.");
                            }
                            else {SendMessageToPC(oPC,"Your ki is too low to begin using this style.");}
                        }
                        else {SendMessageToPC(oPC,"You are not trained in this style.");}
                    }
                    else if (sCommandArg2 == "eagle" || sCommandArg2 == "bird")
                    {
                        if (GetHasFeat(DEITY_Ilmater,oPC))
                        {
                            if (GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"KiLevel")>=5 || GetIsDM(oPC))
                            {
                                SetLocalInt(oPC,"MonkStyle",5);
                                if (GetPhenoType(oPC) == 0){SetPhenoType(60,oPC);}
                                SendMessageToPC(oPC,"You are now using Eagle style martial arts. You will consume ki while in this stance.");
                            }
                            else {SendMessageToPC(oPC,"Your ki is too low to begin using this style.");}
                        }
                        else {SendMessageToPC(oPC,"You are not trained in this style.");}
                    }
                    else if (sCommandArg2 == "none" || sCommandArg2 == "off")
                    {
                        SetLocalInt(oPC,"MonkStyle",0);
                        if (GetPhenoType(oPC) == 50||GetPhenoType(oPC) == 57||GetPhenoType(oPC) == 58||GetPhenoType(oPC) == 59||GetPhenoType(oPC) == 60){SetPhenoType(0,oPC);}
                        SendMessageToPC(oPC,"You are no longer using a martial arts style. You will no longer consume ki.");
                    }
                    else
                    {
                        SendMessageToPC(oPC,"I'm sorry Dave, I can't do that. Type \"-style list\" for a list of all available styles.");
                    }
                }
                else
                {
                    SendMessageToPC(oPC,"Command is unavailable while mounted or untrained in martial arts.");
                }
            }
            else if (sCurrCommandArg == "place")
            {
                string sDoctext;
                object oPaper = GetLocalObject(oPC,"Placeable");
                string sDescription;

                if (GetIsObjectValid(oPaper) == FALSE)
                {
                    SendMessageToPC(oPC,"You must select a valid persistent placeable.");
                    return;
                }

                if (GetDistanceToObject(oPaper) > 5.0f)
                {
                    SendMessageToPC(oPC,"You are too far away from the placeable you are attempting to edit.");
                    return;
                }

                if (sCommandArg2 == "help")
                {
                    SendMessageToPC(oPC,"The Place Command allows you to edit the title and description of any valid persistent placeable.\nThe following commands are available:\nhelp - gives this help message\ntitle - changes the title of a placeable\nadd - adds your text in addition to the text already on the placeable\nnew - overwrites all text on the placeable as your text\nline - starts your added text on new line.");
                }
                else if (sCommandArg2 == "title") //-write title : 13 characters
                {
                    gsFXDeleteFixture(GetTag(GetArea(oPC)),oPaper);
                    sDoctext = GetStringRight(sChatMessage,GetStringLength(sOriginal)-13);
                    SetName(oPaper,sDoctext);
                    SendMessageToPC(oPC,"Title of placeable set as: "+sDoctext);
                    gsFXSaveFixture(GetTag(GetArea(oPC)),oPaper);
                }
                else if (sCommandArg2 == "add") //-write add : 11 characters
                {
                    gsFXDeleteFixture(GetTag(GetArea(oPC)),oPaper);
                    sDoctext = GetStringRight(sChatMessage,GetStringLength(sOriginal)-11);
                    sDescription = GetDescription(oPaper,FALSE,TRUE);
                    SetDescription(oPaper,sDescription+" "+sDoctext,TRUE);
                    SendMessageToPC(oPC,"Text added to placeable as: "+sDoctext);
                    gsFXSaveFixture(GetTag(GetArea(oPC)),oPaper);
                }
                else if (sCommandArg2 == "line") //-write new : 12 characters
                {
                    gsFXDeleteFixture(GetTag(GetArea(oPC)),oPaper);
                    sDoctext = GetStringRight(sChatMessage,GetStringLength(sOriginal)-12);
                    sDescription = GetDescription(oPaper,FALSE,TRUE);
                    SetDescription(oPaper,sDescription+"\n"+sDoctext,TRUE);
                    SendMessageToPC(oPC,"Text added to new line of placeable description as: "+sDoctext);
                    gsFXSaveFixture(GetTag(GetArea(oPC)),oPaper);
                }
                else if (sCommandArg2 == "new") //-write new : 11 characters
                {
                    gsFXDeleteFixture(GetTag(GetArea(oPC)),oPaper);
                    sDoctext = GetStringRight(sChatMessage,GetStringLength(sOriginal)-11);
                    sDescription = GetDescription(oPaper,FALSE,TRUE);
                    SetDescription(oPaper,sDoctext,TRUE);
                    SendMessageToPC(oPC,"New description given to line of placeable description as: "+sDoctext);
                    gsFXSaveFixture(GetTag(GetArea(oPC)),oPaper);
                }
            }
            else if (sCurrCommandArg == "delete")
            {
                if (abs(GetLocalInt(oPC,"DeleteStamp") - NWNX_Time_GetTimeStamp()) > 60)
                {
                    SendMessageToPC(oPC,"WARNING! You are about to delete your character from your vault. If you are sure you want to proceed, type \"-delete\" again to confirm that this is your desire.");
                    SetLocalInt(oPC,"DeleteStamp",NWNX_Time_GetTimeStamp());
                }
                else
                {
                    string sID     = SF_GetPlayerID(oPC);
                    //Brost
                    string sBank   = GetCampaignString("Settlement","sBrost_sBank");
                    string sBank_Coffer = sBank+"Coffers";
                    int nBanked    = GetCampaignInt(GetName(GetModule()), DATABASE_GOLD + sID + sBank);

                    if (nBanked > 0)
                    {
                        DeleteCampaignVariable(GetName(GetModule()), DATABASE_GOLD + sID + sBank);
                        SetCampaignInt(GetName(GetModule()),sBank_Coffer,nBanked);
                    }
                    else {DeleteCampaignVariable(GetName(GetModule()), DATABASE_GOLD + sID + sBank);}

                    //South Spire
                    sBank   = GetCampaignString("Settlement","sSpire_sBank");
                    sBank_Coffer = sBank+"Coffers";
                    nBanked    = GetCampaignInt(GetName(GetModule()), DATABASE_GOLD + sID + sBank);

                    if (nBanked > 0)
                    {
                        DeleteCampaignVariable(GetName(GetModule()), DATABASE_GOLD + sID + sBank);
                        SetCampaignInt(GetName(GetModule()),sBank_Coffer,nBanked);
                    }
                    else {DeleteCampaignVariable(GetName(GetModule()), DATABASE_GOLD + sID + sBank);}

                    //Tejarn Gate
                    sBank = GetCampaignString("Settlement","sTejarn_sBank");
                    sBank_Coffer = sBank+"Coffers";
                    nBanked    = GetCampaignInt(GetName(GetModule()), DATABASE_GOLD + sID + sBank);
                    if (nBanked > 0)
                    {
                        DeleteCampaignVariable(GetName(GetModule()), DATABASE_GOLD + sID + sBank);
                        SetCampaignInt(GetName(GetModule()),sBank_Coffer,nBanked);
                    }
                    else {DeleteCampaignVariable(GetName(GetModule()), DATABASE_GOLD + sID + sBank);}

                    //Swamprise
                    sBank = GetCampaignString("Settlement","sSwamp_sBank");
                    sBank_Coffer = sBank+"Coffers";
                    nBanked    = GetCampaignInt(GetName(GetModule()), DATABASE_GOLD + sID + sBank);
                    if (nBanked > 0)
                    {
                        DeleteCampaignVariable(GetName(GetModule()), DATABASE_GOLD + sID + sBank);
                        SetCampaignInt(GetName(GetModule()),sBank_Coffer,nBanked);
                    }
                    else {DeleteCampaignVariable(GetName(GetModule()), DATABASE_GOLD + sID + sBank);}

                    //Lockwood Falls
                    sBank = GetCampaignString("Settlement","sLock_sBank");
                    sBank_Coffer = sBank+"Coffers";
                    nBanked    = GetCampaignInt(GetName(GetModule()), DATABASE_GOLD + sID + sBank);
                    if (nBanked > 0)
                    {
                        DeleteCampaignVariable(GetName(GetModule()), DATABASE_GOLD + sID + sBank);
                        SetCampaignInt(GetName(GetModule()),sBank_Coffer,nBanked);
                    }
                    else {DeleteCampaignVariable(GetName(GetModule()), DATABASE_GOLD + sID + sBank);}

                    //Golden Lion Company
                    sBank = GetCampaignString("Settlement","sMerc1_sBank");
                    sBank_Coffer = sBank+"Coffers";
                    nBanked    = GetCampaignInt(GetName(GetModule()), DATABASE_GOLD + sID + sBank);
                    if (nBanked > 0)
                    {
                        DeleteCampaignVariable(GetName(GetModule()), DATABASE_GOLD + sID + sBank);
                        SetCampaignInt(GetName(GetModule()),sBank_Coffer,nBanked);
                    }
                    else {DeleteCampaignVariable(GetName(GetModule()), DATABASE_GOLD + sID + sBank);}

                    //Undead
                    sBank = GetCampaignString("Settlement","sUndead_sBank");
                    sBank_Coffer = sBank+"Coffers";
                    nBanked    = GetCampaignInt(GetName(GetModule()), DATABASE_GOLD + sID + sBank);
                    if (nBanked > 0)
                    {
                        DeleteCampaignVariable(GetName(GetModule()), DATABASE_GOLD + sID + sBank);
                        SetCampaignInt(GetName(GetModule()),sBank_Coffer,nBanked);
                    }
                    else {DeleteCampaignVariable(GetName(GetModule()), DATABASE_GOLD + sID + sBank);}

                    //Outlaw
                    sBank = GetCampaignString("Settlement","sOutlaw1_sBank");
                    sBank_Coffer = sBank+"Coffers";
                    nBanked    = GetCampaignInt(GetName(GetModule()), DATABASE_GOLD + sID + sBank);
                    if (nBanked > 0)
                    {
                        DeleteCampaignVariable(GetName(GetModule()), DATABASE_GOLD + sID + sBank);
                        SetCampaignInt(GetName(GetModule()),sBank_Coffer,nBanked);
                    }
                    else {DeleteCampaignVariable(GetName(GetModule()), DATABASE_GOLD + sID + sBank);}

                    //Outlaw
                    sBank = GetCampaignString("Settlement","sOutlaw2_sBank");
                    sBank_Coffer = sBank+"Coffers";
                    nBanked    = GetCampaignInt(GetName(GetModule()), DATABASE_GOLD + sID + sBank);
                    if (nBanked > 0)
                    {
                        DeleteCampaignVariable(GetName(GetModule()), DATABASE_GOLD + sID + sBank);
                        SetCampaignInt(GetName(GetModule()),sBank_Coffer,nBanked);
                    }
                    else {DeleteCampaignVariable(GetName(GetModule()), DATABASE_GOLD + sID + sBank);}

                    NWNX_Administration_DeletePlayerCharacter(oPC,TRUE);
                }
            }
            else if (sCurrCommandArg == "piety")
            {
                string sPiety = IntToString(GetLocalInt(GetItemPossessedBy(oPC,"PC_Data_Object"),"nPiety"));
                SendMessageToPC(oPC,"Your Piety is currently "+sPiety+".");
            }
            else if (sCurrCommandArg == "write")
            {
                string sDoctext;
                object oPaper = GetLocalObject(oPC,"oPaper");
                string sDescription;
                object oQuill = GetItemPossessedBy(oPC,"bv_oai_quill");
                object oInk = GetItemPossessedBy(oPC,"InkWell");
                object oSeal = GetItemPossessedBy(oPC,"HouseRing");;
                object oSealWax = GetItemPossessedBy(oPC,"SealingWax");

                int nUniqueMessageNumber = GetLocalInt(oPaper,"nUnique");
                int nGetUniqueNumber = GetCampaignInt("MessageDatabase","MessageUnique");
                if (nGetUniqueNumber == 0)
                {
                    SetCampaignInt("MessageDatabase","MessageUnique",1000000000000000);
                    nGetUniqueNumber = GetCampaignInt("MessageDatabase","MessageUnique");
                }
                else
                {
                    SetCampaignInt("MessageDatabase","MessageUnique",nGetUniqueNumber+1);
                }

                if (nUniqueMessageNumber == 0)
                {
                    nUniqueMessageNumber = nGetUniqueNumber;
                    SetLocalInt(oPaper,"MessageUnique",nUniqueMessageNumber);
                }

                if (GetIsObjectValid(oQuill) == FALSE)
                {
                    SendMessageToPC(oPC,"You must have a quill in order to modify any document.");
                    return;
                }

                if (GetIsObjectValid(oInk) == FALSE)
                {
                    SendMessageToPC(oPC,"You must have ink in order to modify any document.");
                    return;
                }

                if (GetIsObjectValid(oPaper) == FALSE || GetItemPossessor(oPaper) != oPC)
                {
                    SendMessageToPC(oPC,"No valid paper found...Select valid paper by using a valid paper/document object on yourself.");
                    return;
                }
                else
                {
                    if (GetLocalInt(oPaper,"Sealed") == 1)
                    {
                        SendMessageToPC(oPC,"You cannot edit or doctor a document after it has been sealed.");
                        return;
                    }

                    if (sCommandArg2 == "help")
                    {
                        SendMessageToPC(oPC,"The Write Command allows you to edit the title and description of any valid paper documents.\nThe following commands are available:\nhelp - gives this help message\ntitle - changes the title of a document\nadd - adds your text in addition to the text already on the document\nnew - overwrites all text on the document as your text\nline - starts your added text on new line.");
                    }
                    else if (sCommandArg2 == "title") //-write title : 13 characters
                    {
                        sDoctext = GetStringRight(sChatMessage,GetStringLength(sOriginal)-13);
                        SetName(oPaper,sDoctext);
                        SetItemCharges(oInk,GetItemCharges(oInk)-1);
                        SendMessageToPC(oPC,"Title of document set as: "+sDoctext);
                    }
                    else if (sCommandArg2 == "add") //-write add : 11 characters
                    {
                        sDoctext = GetStringRight(sChatMessage,GetStringLength(sOriginal)-11);
                        sDescription = GetDescription(oPaper,FALSE,TRUE);
                        SetDescription(oPaper,sDescription+" "+sDoctext,TRUE);
                        SetItemCharges(oInk,GetItemCharges(oInk)-1);
                        SendMessageToPC(oPC,"Text added to document as: "+sDoctext);
                    }
                    else if (sCommandArg2 == "line") //-write new : 12 characters
                    {
                        sDoctext = GetStringRight(sChatMessage,GetStringLength(sOriginal)-12);
                        sDescription = GetDescription(oPaper,FALSE,TRUE);
                        SetDescription(oPaper,sDescription+"\n"+sDoctext,TRUE);
                        SetItemCharges(oInk,GetItemCharges(oInk)-1);
                        SendMessageToPC(oPC,"Text added to new line of document as: "+sDoctext);
                    }
                    else if (sCommandArg2 == "new") //-write new : 11 characters
                    {
                        sDoctext = GetStringRight(sChatMessage,GetStringLength(sOriginal)-11);
                        sDescription = GetDescription(oPaper,FALSE,TRUE);
                        SetDescription(oPaper,sDoctext,TRUE);
                        SetItemCharges(oInk,GetItemCharges(oInk)-1);
                        SendMessageToPC(oPC,"New description given to line of document as: "+sDoctext);
                    }
                    else if (sCommandArg2 == "seal") //oSealWax
                    {
                        if (GetItemPossessedBy(oPC,"te_writknight") == OBJECT_INVALID && GetHasFeat(BACKGROUND_MIDDLE,oPC) != TRUE && GetHasFeat(BACKGROUND_UPPER,oPC) != TRUE)
                        {
                            SendMessageToPC(oPC,"You do not possess the expertise required to seal this document.");
                            return;
                        }

                        if (GetIsObjectValid(oSeal) == FALSE)
                        {
                            SendMessageToPC(oPC,"You must have a seal in order to seal this document.");
                            return;
                        }
                        if (GetIsObjectValid(oSealWax) == FALSE)
                        {
                            SendMessageToPC(oPC,"You must have a sealing wax in order to seal this document.");
                            return;
                        }

                        string sSignName = GetName(oPC);

                        if (GetLocalInt(oPC,"nDisguiseName") == 1 && GetIsDM(oPC) != TRUE)
                        {
                            sSignName = GetLocalString(oPC,"sOriginalName");
                        }

                        SetLocalInt(oPaper,"Sealed",1);
                        SetLocalString(oPaper,"SealName",sSignName);
                        sDoctext = "This document bears the seal of "+sSignName+".";
                        sDescription = GetDescription(oPaper,FALSE,TRUE);
                        SetDescription(oPaper,sDescription+"\n"+sDoctext,TRUE);
                        SetItemCharges(oSealWax,GetItemCharges(oSealWax)-1);
                        SendMessageToPC(oPC,"You have sealed your document.");
                    }
                }
            }
            else if (sCurrCommandArg == "joust")
            {
                if (HorseGetIsMounted(oPC))
                {
                    if (sCommandArg2 == "on")
                    {
                        HorseSetPhenotype(oPC,TRUE);
                    }
                    else
                    {
                        HorseSetPhenotype(oPC,FALSE);
                    }
                }
            }
            else if (sCurrCommandArg == "spellfire")
            {
                if (GetLevelByClass(49,oPC) >= 1 || GetLevelByClass(48,oPC)>=1)
                {
                    SendMessageToPC(oPC,"You have "+IntToString(GetLocalInt(GetItemPossessedBy(oPC, "PC_Data_Object"),"nMana"))+" charges of Spellfire.");
                }
            }
            else if (sCurrCommandArg == "time")
            {
                SendMessageToPC(oPC,"You must have a valid time keeping device to use this command.");
            }
            else if (sCurrCommandArg == "manage" || sCurrCommandArg == "door")
            {
                object oDoor = GetNearestObject(OBJECT_TYPE_DOOR,oPC,1);
                if (GetDistanceBetween(oPC,oDoor) > 5.0f)
                {
                    SendMessageToPC(oPC,"You are too far away from an interactable door.");
                }
                else
                {
                    if (GetLocalString(oDoor,"sUnique") != "")
                    {
                        AssignCommand(oDoor,ActionStartConversation(oPC,"te_door",TRUE)); //Start conversation with options to rent/open lock/break down door.
                    }
                    else
                    {
                        SendMessageToPC(oPC,"There is no nearby door that is configured for the Keep Management System.");
                    }
                }
            }
            else if (sCurrCommandArg == "look")
            {
                int nLastTrack = GetLocalInt(oPC,"nTrackLast");
                int nTimeNow = (GetTimeHour()*100+GetTimeMinute());
                int nTimeDiff = abs(nLastTrack-nTimeNow);
                if (nTimeDiff <= 2)
                {
                    SendMessageToPC(oPC,"You may only track something once per minute.");
                }
                else
                {
                    if (HorseGetIsMounted(oPC))
                    {
                        SendMessageToPC(oPC,"You may not track while mounted.");
                    }
                    else
                    {
                        AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_GET_LOW, 6.0));
                        DelayCommand(6.5,TF_Looking(oPC));
                        SetLocalInt(oPC,"nTrackLast",nTimeNow);
                    }
                }
            }
            else if (sCurrCommandArg == "track")
            {
                if (GetHasFeat(1439,oPC))
                {
                    int nLastTrack = GetLocalInt(oPC,"nTrackLast");
                    int nTimeNow = (GetTimeHour()*100+GetTimeMinute());
                    int nTimeDiff = abs(nLastTrack-nTimeNow);
                    if (nTimeDiff <= 2)
                    {
                        SendMessageToPC(oPC,"You may only track something once per minute.");
                    }
                    else
                    {
                        if (HorseGetIsMounted(oPC))
                        {
                            SendMessageToPC(oPC,"You may not track while mounted.");
                        }
                        else
                        {
                            AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_GET_LOW, 6.0));
                            DelayCommand(6.5,TF_TrackRun(oPC));
                            SetLocalInt(oPC,"nTrackLast",nTimeNow);
                        }
                    }
                }
                else{SendMessageToPC(oPC,"You do not have the tracking proficiency.");}
            }
            else if (sCurrCommandArg == "name")
            {
                if (GetLocalInt(oPC,"iDisguise") == 1)
                {
                   if (GetLocalInt(oPC,"nDisguiseName") == 0)
                   {
                        SetLocalInt(oPC,"nDisguiseName",1);
                        SetLocalString(oPC,"sOriginalName",GetName(oPC));
                        SendMessageToPC(oPC,"You are now disguising your name as "+sDisguiseName+".");
                        NWNX_Rename_SetPCNameOverride(oPC,sDisguiseName,"","");

                   }
                   else
                   {
                        SetLocalInt(oPC,"nDisguiseName",0);
                        SendMessageToPC(oPC,"You are no longer disguising your name!");
                        NWNX_Rename_SetPCNameOverride(oPC,GetLocalString(oPC,"sOriginalName"),"","");
                   }
                }
                else
                {
                    SendMessageToPC(oPC,"You may not disguise your name unless you are disguising yourself using the -disguise command");
                }
            }
            else if (sCurrCommandArg == "disguise")
            {
                if (sCommandArg2 == "help")
                {
                    string sDisHelp = "Disguise on T:AOTM currently supports the following commands: \n";
                    sDisHelp += "- on/off - Turns your disguise on or off. If this setting is off, you are not disguised. Syntax: -disguise on \n";
                    sDisHelp += "- class <off/low/mid/up> - Sets your disguise to be of a certain class standing. Syntax: -disguise class up \n";
                    sDisHelp += "- str <0/1/2/3/4> - Sets your disguise for your apparent strength. THIS CANNOT EXCEED YOUR CAPABILITY. Syntax: -diguise str 1 \n";
                    sDisHelp += "- con <0/1/2/3/4> - Sets your disguise for your apparent constitution. THIS CANNOT EXCEED YOUR CAPABILITY. Syntax: -diguise con 1 \n";
                    sDisHelp += "- dex <0/1/2/3/4> - Sets your disguise for your apparent dexterity. THIS CANNOT EXCEED YOUR CAPABILITY. Syntax: -diguise dex 1 \n";
                    sDisHelp += "- name <DisguiseName> - Sets your disguise name. Syntax: -name Malcolm Reed";
                    SendMessageToPC(oPC,sDisHelp);
                }
                else if (sCommandArg2 == "on")
                {
                    SendMessageToPC(oPC,"Disguise on.");
                    SetLocalInt(oPC,"iDisguise",1);
                }
                else if (sCommandArg2 == "off")
                {
                    SendMessageToPC(oPC,"Disguise off. All disguise values set to return accurate results.");
                    SetLocalInt(oPC,"nDisguiseName",0);
                    SetLocalInt(oPC,"nDisSTR",0);
                    SetLocalInt(oPC,"nDisCON",0);
                    SetLocalInt(oPC,"nDisDEX",0);
                    SetLocalInt(oPC,"iDisguise",0);
                    NWNX_Rename_SetPCNameOverride(oPC,GetLocalString(oPC,"sOriginalName"),"","");
                }
                else if (sCommandArg2 == "class")
                {
                    if (sCommandArg3 == "off"){SetLocalInt(oPC,"nDisStand",0); SendMessageToPC(oPC,"Class Standing Disguise off.");}
                    else if (sCommandArg3 == "low"){SetLocalInt(oPC,"nDisStand",1); SendMessageToPC(oPC,"Class Standing Disguise Lower Class.");}
                    else if (sCommandArg3 == "mid"){SetLocalInt(oPC,"nDisStand",2); SendMessageToPC(oPC,"Class Standing Disguise Middle Class.");}
                    else if (sCommandArg3 == "up") {SetLocalInt(oPC,"nDisStand",3); SendMessageToPC(oPC,"Class Standing Disguise Upper Class.");}
                }
                else if (sCommandArg2 == "str")
                {
                    if (sCommandArg3 == "0") {SetLocalInt(oPC,"nDisSTR",0); SendMessageToPC(oPC,"Disguising Strength off.");}
                    else if (sCommandArg3 == "1") {SetLocalInt(oPC,"nDisSTR",1); SendMessageToPC(oPC,"Disguising Strength low.");}
                    else if (sCommandArg3 == "2") {SetLocalInt(oPC,"nDisSTR",2); SendMessageToPC(oPC,"Disguising Strength mid.");}
                    else if (sCommandArg3 == "3") {SetLocalInt(oPC,"nDisSTR",3); SendMessageToPC(oPC,"Disguising Strength high.");}
                    else if (sCommandArg3 == "4") {SetLocalInt(oPC,"nDisSTR",4); SendMessageToPC(oPC,"Disguising Strength extreme.");}
                }
                else if (sCommandArg2 == "con")
                {
                    if (sCommandArg3 == "0") {SetLocalInt(oPC,"nDisCON",0); SendMessageToPC(oPC,"Disguising Constitution off.");}
                    else if (sCommandArg3 == "1") {SetLocalInt(oPC,"nDisCON",1); SendMessageToPC(oPC,"Disguising Constitution low.");}
                    else if (sCommandArg3 == "2") {SetLocalInt(oPC,"nDisCON",2); SendMessageToPC(oPC,"Disguising Constitution mid.");}
                    else if (sCommandArg3 == "3") {SetLocalInt(oPC,"nDisCON",3); SendMessageToPC(oPC,"Disguising Constitution high.");}
                    else if (sCommandArg3 == "4") {SetLocalInt(oPC,"nDisCON",4); SendMessageToPC(oPC,"Disguising Constitution extreme.");}
                }
                else if (sCommandArg2 == "dex")
                {
                    if (sCommandArg3 == "0") {SetLocalInt(oPC,"nDisDEX",0);    SendMessageToPC(oPC,"Disguising Dexterity off.");}
                    else if (sCommandArg3 == "1") {SetLocalInt(oPC,"nDisDEX",1); SendMessageToPC(oPC,"Disguising Dexterity low.");}
                    else if (sCommandArg3 == "2") {SetLocalInt(oPC,"nDisDEX",2);  SendMessageToPC(oPC,"Disguising Dexterity mid.");}
                    else if (sCommandArg3 == "3") {SetLocalInt(oPC,"nDisDEX",3);  SendMessageToPC(oPC,"Disguising Dexterity high.");}
                    else if (sCommandArg3 == "4") {SetLocalInt(oPC,"nDisDEX",4);  SendMessageToPC(oPC,"Disguising Dexterity extreme.");}
                }
                else
                {
                    string sDisguiseReturn;
                    if (GetLocalInt(oPC,"iDisguise") == 1)       {sDisguiseReturn+= "You are disguising yourself.\n";}
                    else                                        {sDisguiseReturn+= "You are not disguising yourself.\n";}
                    if (GetLocalInt(oPC,"nDisStand") == 0)       {sDisguiseReturn+= "You are not disguising your class standing.\n";}
                    else if (GetLocalInt(oPC,"nDisStand") == 1)  {sDisguiseReturn+= "You are disguising yourself as lower class standing.\n";}
                    else if (GetLocalInt(oPC,"nDisStand") == 2)  {sDisguiseReturn+= "You are disguising yourself as middle class standing.\n";}
                    else if (GetLocalInt(oPC,"nDisStand") == 3)  {sDisguiseReturn+= "You are disguising yourself as upper class standing.\n";}
                    if (GetLocalInt(oPC,"nDisSTR") == 0)        {sDisguiseReturn+= "You are disguising not your Strength.\n";}
                    else if (GetLocalInt(oPC,"nDisSTR") == 1)   {sDisguiseReturn+= "You are disguising your Strength as low.\n";}
                    else if (GetLocalInt(oPC,"nDisSTR") == 2)   {sDisguiseReturn+= "You are disguising your Strength as middle.\n";}
                    else if (GetLocalInt(oPC,"nDisSTR") == 3)   {sDisguiseReturn+= "You are disguising your Strength as high.\n";}
                    else if (GetLocalInt(oPC,"nDisSTR") == 4)   {sDisguiseReturn+= "You are disguising your Strength as extreme.\n";}
                    if (GetLocalInt(oPC,"nDisCON") == 0)        {sDisguiseReturn+= "You are disguising not your Constitution.\n";}
                    else if (GetLocalInt(oPC,"nDisCON") == 1)   {sDisguiseReturn+= "You are disguising your Constitution as low.\n";}
                    else if (GetLocalInt(oPC,"nDisCON") == 2)   {sDisguiseReturn+= "You are disguising your Constitution as middle.\n";}
                    else if (GetLocalInt(oPC,"nDisCON") == 3)   {sDisguiseReturn+= "You are disguising your Constitution as high.\n";}
                    else if (GetLocalInt(oPC,"nDisCON") == 4)   {sDisguiseReturn+= "You are disguising your Constitution as extreme.\n";}
                    if (GetLocalInt(oPC,"nDisDEX") == 0)        {sDisguiseReturn+= "You are disguising not your Dexterity.\n";}
                    else if (GetLocalInt(oPC,"nDisDEX") == 1)   {sDisguiseReturn+= "You are disguising your Dexterity as low.\n";}
                    else if (GetLocalInt(oPC,"nDisDEX") == 1)   {sDisguiseReturn+= "You are disguising your Dexterity as middle.\n";}
                    else if (GetLocalInt(oPC,"nDisDEX") == 1)   {sDisguiseReturn+= "You are disguising your Dexterity as high.\n";}
                    else if (GetLocalInt(oPC,"nDisDEX") == 1)   {sDisguiseReturn+= "You are disguising your Dexterity as extreme.\n";}
                    SendMessageToPC(oPC,sDisguiseReturn);
                }
            }
            else if (sCurrCommandArg == "rest")
            {
                string REST_IN_SHIFTS = "You cannot rest while another party member is resting, sleep in shifts.";
                string NOT_TIRED = " is not tired enough.";
                string TOO_SOON = "Its Too Soon in the Game to Rest please wait ";
                string NO_REST_TOWN = "The local authorities require you to rest in an inn-room or other suitable location.";
                string BUY_A_ROOM = "You need to buy a room at the Inn or find some other accommodations.";
                string BED_REST_LATER = " You can rest in a comfortable bed at ";
                string WILD_REST_LATER = " or you can rest in the wilds at ";
                string BED_REST_ONLY = " You can rest in a comfortable bed ";
                string NO_REST_HERE = "You cannot rest here.";
                string REST_MONSTERS = "You cannot rest, there are monsters nearby!";
                string REST_POORLY = "Your rest was poor or uncomfortable, you did not recover completely.";

                int bREST_BED = CheckDateStringExpired(oPC, "REST_BED");
                int bREST_ROUGH = CheckDateStringExpired(oPC, "REST_ROUGH");
                string sRestedText = GetName(oPC) + NOT_TIRED;

                if (GetIsObjectValid(oPC) && bREST_BED == TRUE && bREST_ROUGH == FALSE)
                {
                AssignCommand(oPC, ClearAllActions());
                sRestedText += BED_REST_ONLY;
                sRestedText += WILD_REST_LATER;
                sRestedText = sRestedText + ConvertDateString(oPC, "REST_ROUGH");
                SendMessageToPC(oPC,sRestedText);
                }
                else if (GetIsObjectValid(oPC) && bREST_BED == FALSE && bREST_ROUGH == FALSE)
                {
                AssignCommand(oPC, ClearAllActions());
                sRestedText += BED_REST_LATER;
                sRestedText = sRestedText + ConvertDateString(oPC, "REST_BED");
                sRestedText += WILD_REST_LATER;
                sRestedText = sRestedText + ConvertDateString(oPC, "REST_ROUGH");
                SendMessageToPC(oPC,sRestedText);
                }
                else
                {
                    SendMessageToPC(oPC,"You are able to rest in a bed or in the wild.");
                }

            }
            else if (sCurrCommandArg == "walk")
            {
                if (GetLocalInt(oPC,"walk") == 0)
                {
                    NWNX_Player_SetAlwaysWalk(oPC,TRUE);
                    SetLocalInt(oPC,"walk", 1);
                }
                else
                {
                    NWNX_Player_SetAlwaysWalk(oPC,FALSE);
                    SetLocalInt(oPC,"walk", 0);
                }
            }
            else if (sCurrCommandArg == "weather")
            {
                SendMessageToPC(oPC,GetAreaReadout(oPC));
            }
            else if (sCurrCommandArg == "debuff")
            {
                effect eSpell = GetFirstEffect(oPC);
                while (GetIsEffectValid(eSpell))
                {
                    if (GetEffectCreator(eSpell) == oPC)
                    {
                        RemoveEffect(oPC, eSpell);
                    }
                    eSpell = GetNextEffect(oPC);
                }
            }
            else if (sCurrCommandArg == "decloak")
            {
                effect eSpell = GetFirstEffect(oPC);
                while (GetIsEffectValid(eSpell))
                {
                    if (GetEffectType(eSpell) == EFFECT_TYPE_INVISIBILITY)
                    {
                        RemoveEffect(oPC, eSpell);
                    }
                    eSpell = GetNextEffect(oPC);
                }
            }
            else if (sCurrCommandArg == "emote")
            {
                if (sCommandArg2 == "list")
                {
                    SendMessageToPC(oPC,"Available Emotes: \n attention\n bite\n bored\n bow\n cast\n celebrate\n conjure\n cower\n cross\n crouch\n dance\n dance2\n drink\n drink2\n drunk\n fall backward\n fall forward\n gather\n grapple\n greet\n headscratch\n honor\n laugh\n laydown1\n laydown2\n laydown3\n listen\n look\n meditate\n pickup ground\n pickup waist\n plead\n point\n pushup\n read\n salute\n shock\n sit\n sit2\n smoke\n spasm\n stop\n taunt\n think\n tired\n worship");
                }
                else if (sCommandArg2 == "bow")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_BOW, 1.0));
                else if (sCommandArg2 == "smoke")
                    SmokePipe(oPC);
                else if (sCommandArg2 == "dance2")
                    EmoteDance(oPC);
                else if (sCommandArg2 == "drink")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_DRINK, 1.0));
                else if (sCommandArg2 == "cast")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_CONJURE1, 1.0, 10000.0));
                else if (sCommandArg2 == "conjure")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_CONJURE2, 1.0, 10000.0));
                else if (sCommandArg2 == "greet")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_GREETING, 1.0));
                else if (sCommandArg2 == "bored")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_PAUSE_BORED, 1.0));
                else if (sCommandArg2 == "headscratch" || sCommandArg2 == "confused")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD, 1.0));
                else if (sCommandArg2 == "read")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_READ, 1.0));
                else if (sCommandArg2 == "salute")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_SALUTE, 1.0));
                else if (sCommandArg2 == "spasm")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_SPASM, 1.0, 10000.0));
                else if (sCommandArg2 == "taunt")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_TAUNT, 1.0));
                else if (sCommandArg2 == "celebrate")
                    AssignCommand(oPC, PlayAnimation(111-Random(3), 1.0));  //ANIMATION_FIREFORGET_VICTORY1(2)(3)
                else if (sCommandArg2 == "fall")
                {
                    if (sCommandArg3 == "forward" || sCommandArg3 == "front" || sCommandArg3 == "down")
                        AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, 10000.0));
                    else if (sCommandArg3 == "backward" || sCommandArg3 == "back")
                        AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, 10000.0));
                    else
                        SendMessageToPC(oPC,"I'm sorry Dave, I can't do that. Type \"-emote list\" for a list of all available emotes.");
                }
                else if (sCommandArg2 == "pickup" || sCommandArg2 == "get")
                {
                    sCurrCommandArg = parseArgs(sChatMessage, 2); //Get where to pickup at

                    if (sCommandArg3 == "ground" || sCommandArg2 == "low")
                        AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 10000.0));
                    else if (sCommandArg3 == "waist" || sCommandArg2 == "mid")
                        AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 10000.0));
                    else
                         SendMessageToPC(oPC,"I'm sorry Dave, I can't do that. Type \"-emote list\" for a list of all available emotes.");
                }
                else if (sCommandArg2 == "laydown")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, 10000.0));
                else if (sCommandArg2 == "falldown")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, 10000.0));
                else if (sCommandArg2 == "listen")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_LISTEN, 1.0, 10000.0));
                else if (sCommandArg2 == "look")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_LOOK_FAR, 1.0, 10000.0));
                else if (sCommandArg2 == "meditate"||sCommandArg2 == "pray")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, 10000.0));
                else if (sCommandArg2 == "stop")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_PAUSE, 1.0, 10000.0));
                else if (sCommandArg2 == "drunk")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK, 1.0, 10000.0));
                else if (sCommandArg2 == "tired")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_PAUSE_TIRED, 1.0, 10000.0));
                else if (sCommandArg2 == "laugh")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING, 1.0, 10000.0));
                else if (sCommandArg2 == "plead")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0, 10000.0));
                else if (sCommandArg2 == "worship")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_WORSHIP, 1.0, 10000.0));
                else if (sCommandArg2 == "sit")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_SIT_CROSS, 1.0, 10000.0));
                else if (sCommandArg2 == "shock")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_CUSTOM1, 1.0, 10000.0));
               // else if (sCommandArg2 == "guitar")
               //     AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_CUSTOM2, 1.0, 10000.0));
                else if (sCommandArg2 == "drink")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_CUSTOM3, 1.0, 10.0));
                else if (sCommandArg2 == "honor")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_CUSTOM4, 1.0, 10000.0));
                else if (sCommandArg2 == "pushup")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_CUSTOM5, 1.0, 10000.0));
                else if (sCommandArg2 == "dance")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_CUSTOM6, 1.0, 10000.0));
                else if (sCommandArg2 == "attention")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_CUSTOM7, 1.0, 10000.0));
                else if (sCommandArg2 == "sit2")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_CUSTOM8, 1.0, 10000.0));
                else if (sCommandArg2 == "grapple")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_CUSTOM9, 1.0, 10000.0));
                else if (sCommandArg2 == "bite")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_CUSTOM10, 1.0, 10000.0));
                else if (sCommandArg2 == "point")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_CUSTOM11, 1.0, 10000.0));
                else if (sCommandArg2 == "think")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_CUSTOM12, 1.0, 10000.0));
                else if (sCommandArg2 == "cower")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_CUSTOM13, 1.0, 10000.0));
                else if (sCommandArg2 == "cross")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_CUSTOM14, 1.0, 10000.0));
                else if (sCommandArg2 == "laydown1")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_CUSTOM15, 1.0, 10000.0));
                else if (sCommandArg2 == "laydown2")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_CUSTOM16, 1.0, 10000.0));
                else if (sCommandArg2 == "crouch")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_CUSTOM17, 1.0, 10000.0));
               // else if (sCommandArg2 == "c18")
               //     AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_CUSTOM18, 1.0, 10000.0));
                else if (sCommandArg2 == "gather")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_CUSTOM19, 1.0, 10000.0));
                else if (sCommandArg2 == "laydown3")
                    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_CUSTOM20, 1.0, 10000.0));
                else
                {
                    SendMessageToPC(oPC,"I'm sorry Dave, I can't do that. Type \"-emote list\" for a list of all available emotes.");
                }
            }
            else if (sCurrCommandArg == "roll")
            {
                sRollString = GetName(oPC)+" ("+GetPCPlayerName(oPC)+"):\n";
                int nDiceConvert = StringToInt(sCommandArg3);
                if (sCommandArg2 == "d2" || sCommandArg2 == "D2")
                {
                    sRollString += "Dice Roll - "+sCommandArg3+"D2 Result: "+IntToString(d2(StringToInt(sCommandArg3)));
                }
                else if (sCommandArg2 == "d3" || sCommandArg2 == "D3")
                {
                    sRollString += "Dice Roll - "+sCommandArg3+"D3 Result: "+IntToString(d3(StringToInt(sCommandArg3)));
                }
                else if (sCommandArg2 == "d4" || sCommandArg2 == "D4")
                {
                    sRollString += "Dice Roll - "+sCommandArg3+"D4 Result: "+IntToString(d4(StringToInt(sCommandArg3)));
                }
                else if (sCommandArg2 == "d6" || sCommandArg2 == "D6")
                {
                    sRollString += "Dice Roll - "+sCommandArg3+"D6 Result: "+IntToString(d6(StringToInt(sCommandArg3)));
                }
                else if (sCommandArg2 == "d8" || sCommandArg2 == "D8")
                {
                    sRollString += "Dice Roll - "+sCommandArg3+"D8 Result: "+IntToString(d8(StringToInt(sCommandArg3)));
                }
                else if (sCommandArg2 == "d10" || sCommandArg2 == "D10")
                {
                    sRollString += "Dice Roll - "+sCommandArg3+"D10 Result: "+IntToString(d10(StringToInt(sCommandArg3)));
                }
                else if (sCommandArg2 == "d12" || sCommandArg2 == "D12")
                {
                    sRollString += "Dice Roll - "+sCommandArg3+"D12 Result: "+IntToString(d12(StringToInt(sCommandArg3)));
                }
                else if (sCommandArg2 == "d20" || sCommandArg2 == "D20")
                {
                    sRollString += "Dice Roll - "+sCommandArg3+"D20 Result: "+IntToString(d20(StringToInt(sCommandArg3)));
                }
                else if (sCommandArg2 == "d100" || sCommandArg2 == "D100")
                {
                    sRollString += "Dice Roll - "+sCommandArg3+"D100 Result: "+IntToString(d100(StringToInt(sCommandArg3)));
                }
                else if (sCommandArg2 == "will")
                {
                    sRollString += "Will Save  - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetWillSavingThrow(oPC))+" Total: "+IntToString(nD20+GetWillSavingThrow(oPC));
                }
                else if (sCommandArg2 == "reflex" || sCommandArg2 == "ref")
                {
                    sRollString += "Reflex Save - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetReflexSavingThrow(oPC))+" Total: "+IntToString(nD20+GetReflexSavingThrow(oPC));
                }
                else if (sCommandArg2 == "fort" || sCommandArg2 == "fortitude")
                {
                    sRollString += "Fortitude Save - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetFortitudeSavingThrow(oPC))+" Total: "+IntToString(nD20+GetFortitudeSavingThrow(oPC));
                }
                else if (sCommandArg2 == "animal" || sCommandArg2 == "ani")
                {
                    sRollString += "Animal Empathy Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_ANIMAL_EMPATHY, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_ANIMAL_EMPATHY, oPC));
                }
                else if (sCommandArg2 == "appraise")
                {
                    sRollString += "Appraise Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_APPRAISE, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_APPRAISE, oPC));
                }
                else if (sCommandArg2 == "bluff")
                {
                    sRollString += "Bluff Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_BLUFF, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_BLUFF, oPC));
                }
                else if (sCommandArg2 == "concentration")
                {
                    sRollString += "Concentration Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_CONCENTRATION, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_CONCENTRATION, oPC));
                }
                else if (sCommandArg2 == "disable")
                {
                    sRollString += "Disable Trap Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_DISABLE_TRAP, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_DISABLE_TRAP, oPC));
                }
                else if (sCommandArg2 == "discipline")
                {
                    sRollString += "Discipline Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_DISCIPLINE, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_DISCIPLINE, oPC));
                }
                else if (sCommandArg2 == "heal")
                {
                    sRollString += "Heal Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_HEAL, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_HEAL, oPC));
                }
                else if (sCommandArg2 == "hide")
                {
                    sRollString += "Hide Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_HIDE, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_HIDE, oPC));
                }
                else if (sCommandArg2 == "intimidate")
                {
                    sRollString += "Intimidate Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_INTIMIDATE, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_INTIMIDATE, oPC));
                }
                else if (sCommandArg2 == "listen")
                {
                    sRollString += "Listen Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_LISTEN, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_LISTEN, oPC));
                }
                else if (sCommandArg2 == "lore"||sCommandArg2 == "know"||sCommandArg2 == "knowledge")
                {
                    sRollString += "Lore / Knowledge Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_LORE, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_LORE, oPC));
                }
                else if (sCommandArg2 == "move")
                {
                    sRollString += "Move Silently Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_MOVE_SILENTLY, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_MOVE_SILENTLY, oPC));
                }
                else if (sCommandArg2 == "open")
                {
                    sRollString += "Open Lock Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_OPEN_LOCK, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_OPEN_LOCK, oPC));
                }
                else if (sCommandArg2 == "parry")
                {
                    sRollString += "Parry Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_PARRY, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_PARRY, oPC));
                }
                else if (sCommandArg2 == "perform")
                {
                    sRollString += "Perform Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_PERFORM, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_PERFORM, oPC));
                }
                else if (sCommandArg2 == "persuade" || sCommandArg2 == "diplomacy"|| sCommandArg2 == "diplo")
                {
                    sRollString += "Diplomacy Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_PERSUADE, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_PERSUADE, oPC));
                }
                else if (sCommandArg2 == "pick" || sCommandArg2 == "sleight" )
                {
                    sRollString += "Sleight of Hand / Pick Pocket Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_PICK_POCKET, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_PICK_POCKET, oPC));
                }
                else if (sCommandArg2 == "ride")
                {
                    sRollString += "Ride Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_RIDE, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_RIDE, oPC));
                }
                else if (sCommandArg2 == "search")
                {
                    sRollString += "Search Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_SEARCH, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_SEARCH, oPC));
                }
                else if (sCommandArg2 == "spot")
                {
                    sRollString += "Spot Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_SPOT, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_SPOT, oPC));
                }
                else if (sCommandArg2 == "set")
                {
                    sRollString += "Set Trap Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_SET_TRAP, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_SET_TRAP, oPC));
                }
                else if (sCommandArg2 == "spellcraft")
                {
                    sRollString += "Spellcraft Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_SPELLCRAFT, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_SPELLCRAFT, oPC));
                }
                else if (sCommandArg2 == "taunt")
                {
                    sRollString += "Taunt Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_TAUNT, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_TAUNT, oPC));
                }
                else if (sCommandArg2 == "umd")
                {
                    sRollString += "Use Magical Device Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_USE_MAGIC_DEVICE, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_USE_MAGIC_DEVICE, oPC));
                }
                else if (sCommandArg2 == "tumble")
                {
                    sRollString += "Tumble  - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_TUMBLE, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_TUMBLE, oPC));
                }
                else if (sCommandArg2 == "str" || sCommandArg2 == "strength")
                {
                    sRollString += "Strength  - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetAbilityModifier(ABILITY_STRENGTH, oPC))+" Total: "+IntToString(nD20+GetAbilityModifier(ABILITY_STRENGTH, oPC));
                }
                else if (sCommandArg2 == "dex" || sCommandArg2 == "dexterity")
                {
                    sRollString += "Dexterity  - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetAbilityModifier(ABILITY_DEXTERITY, oPC))+" Total: "+IntToString(nD20+GetAbilityModifier(ABILITY_DEXTERITY, oPC));
                }
                else if (sCommandArg2 == "int" || sCommandArg2 == "intelligence")
                {
                    sRollString += "Intelligence  - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetAbilityModifier(ABILITY_INTELLIGENCE, oPC))+" Total: "+IntToString(nD20+GetAbilityModifier(ABILITY_INTELLIGENCE, oPC));
                }
                else if (sCommandArg2 == "con" || sCommandArg2 == "constitution")
                {
                    sRollString += "Constitution  - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetAbilityModifier(ABILITY_CONSTITUTION, oPC))+" Total: "+IntToString(nD20+GetAbilityModifier(ABILITY_CONSTITUTION, oPC));
                }
                else if (sCommandArg2 == "wis" || sCommandArg2 == "wisdom")
                {
                    sRollString += "Wisdom  - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetAbilityModifier(ABILITY_WISDOM, oPC))+" Total: "+IntToString(nD20+GetAbilityModifier(ABILITY_WISDOM, oPC));
                }
                else if (sCommandArg2 == "cha" || sCommandArg2 == "charisma")
                {
                    sRollString += "Charisma  - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetAbilityModifier(ABILITY_CHARISMA, oPC))+" Total: "+IntToString(nD20+GetAbilityModifier(ABILITY_CHARISMA, oPC));
                }
                else
                {
                    sRollString += "Error processing. Try again.";
                }

                sRollString += sCrit+COLOR_END;
                SendMessageToPC(oPC,sRollString);
                SpeakString(sRollString,TALKVOLUME_TALK);
                SendMessageToAllDMs("Name: "+GetName(oPC)+" rolling! \n"+sRollString);
                NWNX_Chat_SendMessage(1,GetName(oPC)+" rolling! \n"+sRollString);

                object oDicePC = GetFirstPC();
                while (GetIsObjectValid(oDicePC))
                {
                    if (GetIsDM(oDicePC)||GetIsDMPossessed(oDicePC))
                    {
                        DelayCommand(0.3,SendMessageToPC(oDicePC,sRollString));
                    }
                    oDicePC = GetNextPC();
                }

            }
            else if (sCurrCommandArg == "rollp")  // Making an attempt: Saadow, 7/27/24
            {
                sRollString = GetName(oPC)+" ("+GetPCPlayerName(oPC)+"):\n";
                int nDiceConvert = StringToInt(sCommandArg3);
                if (sCommandArg2 == "d2" || sCommandArg2 == "D2")
                {
                    sRollString += "Dice Roll - "+sCommandArg3+"D2 Result: "+IntToString(d2(StringToInt(sCommandArg3)));
                }
                else if (sCommandArg2 == "d3" || sCommandArg2 == "D3")
                {
                    sRollString += "Dice Roll - "+sCommandArg3+"D3 Result: "+IntToString(d3(StringToInt(sCommandArg3)));
                }
                else if (sCommandArg2 == "d4" || sCommandArg2 == "D4")
                {
                    sRollString += "Dice Roll - "+sCommandArg3+"D4 Result: "+IntToString(d4(StringToInt(sCommandArg3)));
                }
                else if (sCommandArg2 == "d6" || sCommandArg2 == "D6")
                {
                    sRollString += "Dice Roll - "+sCommandArg3+"D6 Result: "+IntToString(d6(StringToInt(sCommandArg3)));
                }
                else if (sCommandArg2 == "d8" || sCommandArg2 == "D8")
                {
                    sRollString += "Dice Roll - "+sCommandArg3+"D8 Result: "+IntToString(d8(StringToInt(sCommandArg3)));
                }
                else if (sCommandArg2 == "d10" || sCommandArg2 == "D10")
                {
                    sRollString += "Dice Roll - "+sCommandArg3+"D10 Result: "+IntToString(d10(StringToInt(sCommandArg3)));
                }
                else if (sCommandArg2 == "d12" || sCommandArg2 == "D12")
                {
                    sRollString += "Dice Roll - "+sCommandArg3+"D12 Result: "+IntToString(d12(StringToInt(sCommandArg3)));
                }
                else if (sCommandArg2 == "d20" || sCommandArg2 == "D20")
                {
                    sRollString += "Dice Roll - "+sCommandArg3+"D20 Result: "+IntToString(d20(StringToInt(sCommandArg3)));
                }
                else if (sCommandArg2 == "d100" || sCommandArg2 == "D100")
                {
                    sRollString += "Dice Roll - "+sCommandArg3+"D100 Result: "+IntToString(d100(StringToInt(sCommandArg3)));
                }
                else if (sCommandArg2 == "will")
                {
                    sRollString += "Will Save  - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetWillSavingThrow(oPC))+" Total: "+IntToString(nD20+GetWillSavingThrow(oPC));
                }
                else if (sCommandArg2 == "reflex" || sCommandArg2 == "ref")
                {
                    sRollString += "Reflex Save - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetReflexSavingThrow(oPC))+" Total: "+IntToString(nD20+GetReflexSavingThrow(oPC));
                }
                else if (sCommandArg2 == "fort" || sCommandArg2 == "fortitude")
                {
                    sRollString += "Fortitude Save - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetFortitudeSavingThrow(oPC))+" Total: "+IntToString(nD20+GetFortitudeSavingThrow(oPC));
                }
                else if (sCommandArg2 == "animal" || sCommandArg2 == "ani")
                {
                    sRollString += "Animal Empathy Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_ANIMAL_EMPATHY, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_ANIMAL_EMPATHY, oPC));
                }
                else if (sCommandArg2 == "appraise")
                {
                    sRollString += "Appraise Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_APPRAISE, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_APPRAISE, oPC));
                }
                else if (sCommandArg2 == "bluff")
                {
                    sRollString += "Bluff Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_BLUFF, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_BLUFF, oPC));
                }
                else if (sCommandArg2 == "concentration")
                {
                    sRollString += "Concentration Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_CONCENTRATION, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_CONCENTRATION, oPC));
                }
                else if (sCommandArg2 == "disable")
                {
                    sRollString += "Disable Trap Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_DISABLE_TRAP, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_DISABLE_TRAP, oPC));
                }
                else if (sCommandArg2 == "discipline")
                {
                    sRollString += "Discipline Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_DISCIPLINE, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_DISCIPLINE, oPC));
                }
                else if (sCommandArg2 == "heal")
                {
                    sRollString += "Heal Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_HEAL, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_HEAL, oPC));
                }
                else if (sCommandArg2 == "hide")
                {
                    sRollString += "Hide Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_HIDE, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_HIDE, oPC));
                }
                else if (sCommandArg2 == "intimidate")
                {
                    sRollString += "Intimidate Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_INTIMIDATE, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_INTIMIDATE, oPC));
                }
                else if (sCommandArg2 == "listen")
                {
                    sRollString += "Listen Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_LISTEN, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_LISTEN, oPC));
                }
                else if (sCommandArg2 == "lore"||sCommandArg2 == "know"||sCommandArg2 == "knowledge")
                {
                    sRollString += "Lore / Knowledge Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_LORE, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_LORE, oPC));
                }
                else if (sCommandArg2 == "move")
                {
                    sRollString += "Move Silently Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_MOVE_SILENTLY, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_MOVE_SILENTLY, oPC));
                }
                else if (sCommandArg2 == "open")
                {
                    sRollString += "Open Lock Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_OPEN_LOCK, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_OPEN_LOCK, oPC));
                }
                else if (sCommandArg2 == "parry")
                {
                    sRollString += "Parry Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_PARRY, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_PARRY, oPC));
                }
                else if (sCommandArg2 == "perform")
                {
                    sRollString += "Perform Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_PERFORM, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_PERFORM, oPC));
                }
                else if (sCommandArg2 == "persuade" || sCommandArg2 == "diplomacy"|| sCommandArg2 == "diplo")
                {
                    sRollString += "Diplomacy Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_PERSUADE, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_PERSUADE, oPC));
                }
                else if (sCommandArg2 == "pick" || sCommandArg2 == "sleight" )
                {
                    sRollString += "Sleight of Hand / Pick Pocket Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_PICK_POCKET, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_PICK_POCKET, oPC));
                }
                else if (sCommandArg2 == "ride")
                {
                    sRollString += "Ride Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_RIDE, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_RIDE, oPC));
                }
                else if (sCommandArg2 == "search")
                {
                    sRollString += "Search Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_SEARCH, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_SEARCH, oPC));
                }
                else if (sCommandArg2 == "spot")
                {
                    sRollString += "Spot Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_SPOT, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_SPOT, oPC));
                }
                else if (sCommandArg2 == "set")
                {
                    sRollString += "Set Trap Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_SET_TRAP, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_SET_TRAP, oPC));
                }
                else if (sCommandArg2 == "spellcraft")
                {
                    sRollString += "Spellcraft Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_SPELLCRAFT, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_SPELLCRAFT, oPC));
                }
                else if (sCommandArg2 == "taunt")
                {
                    sRollString += "Taunt Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_TAUNT, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_TAUNT, oPC));
                }
                else if (sCommandArg2 == "umd")
                {
                    sRollString += "Use Magical Device Check - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_USE_MAGIC_DEVICE, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_USE_MAGIC_DEVICE, oPC));
                }
                else if (sCommandArg2 == "tumble")
                {
                    sRollString += "Tumble  - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetSkillRank(SKILL_TUMBLE, oPC))+" Total: "+IntToString(nD20+GetSkillRank(SKILL_TUMBLE, oPC));
                }
                else if (sCommandArg2 == "str" || sCommandArg2 == "strength")
                {
                    sRollString += "Strength  - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetAbilityModifier(ABILITY_STRENGTH, oPC))+" Total: "+IntToString(nD20+GetAbilityModifier(ABILITY_STRENGTH, oPC));
                }
                else if (sCommandArg2 == "dex" || sCommandArg2 == "dexterity")
                {
                    sRollString += "Dexterity  - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetAbilityModifier(ABILITY_DEXTERITY, oPC))+" Total: "+IntToString(nD20+GetAbilityModifier(ABILITY_DEXTERITY, oPC));
                }
                else if (sCommandArg2 == "int" || sCommandArg2 == "intelligence")
                {
                    sRollString += "Intelligence  - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetAbilityModifier(ABILITY_INTELLIGENCE, oPC))+" Total: "+IntToString(nD20+GetAbilityModifier(ABILITY_INTELLIGENCE, oPC));
                }
                else if (sCommandArg2 == "con" || sCommandArg2 == "constitution")
                {
                    sRollString += "Constitution  - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetAbilityModifier(ABILITY_CONSTITUTION, oPC))+" Total: "+IntToString(nD20+GetAbilityModifier(ABILITY_CONSTITUTION, oPC));
                }
                else if (sCommandArg2 == "wis" || sCommandArg2 == "wisdom")
                {
                    sRollString += "Wisdom  - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetAbilityModifier(ABILITY_WISDOM, oPC))+" Total: "+IntToString(nD20+GetAbilityModifier(ABILITY_WISDOM, oPC));
                }
                else if (sCommandArg2 == "cha" || sCommandArg2 == "charisma")
                {
                    sRollString += "Charisma  - 1d20:"+IntToString(nD20)+" + Modifier: "+IntToString(GetAbilityModifier(ABILITY_CHARISMA, oPC))+" Total: "+IntToString(nD20+GetAbilityModifier(ABILITY_CHARISMA, oPC));
                }
                else
                {
                    sRollString += "Error processing. Try again.";
                }

                sRollString += sCrit+COLOR_END;
                SendMessageToPC(oPC,sRollString);
                SpeakString(sRollString,TALKVOLUME_TALK);
                SendMessageToAllDMs("Name: "+GetName(oPC)+" rolling! \n"+sRollString);
                SetPCChatMessage("(OOC)rolling dice: \n"+sRollString);

                object oDicePC = GetFirstPC();
                while (GetIsObjectValid(oDicePC))
                {
                    if (GetIsDM(oDicePC)||GetIsDMPossessed(oDicePC))
                    {
                        DelayCommand(0.3,SendMessageToPC(oDicePC,sRollString));
                    }
                    oDicePC = GetNextPC();
                }
            }
            else if (sCurrCommandArg == "scale")
            {
                // Get current scale
                oItem = GetItemPossessedBy(oPC, "PC_Data_Object");
                float fScale = GetLocalFloat(oItem, "fScale");
                if (fScale == 0.0) fScale = 1.0f;

                // Assign adjustments
                if (sCommandArg2 == "reset" || sCommandArg2 == "0" || sCommandArg2 == "0.0")
                {
                    SetLocalFloat(oItem, "fScale", 1.0f);
                    SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE, 1.0f);
                    SendMessageToPC(oPC, "Size Scale returned to default (1.0)");
                }
                else if (FindSubString(sCommandArg2, ".") == -1)
                {
                    SendMessageToPC(oPC, "Value must be a float (example: 0.5)!");
                }
                else
                {
                    float fValue = ClampFloat(StringToFloat(sCommandArg2), -3.0, 3.0);
                    if (fValue != fScale)
                    {
                        SetLocalFloat(oItem, "fScale", fValue);
                        SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE, fValue);
                        SendMessageToPC(oPC, "Size Scale changed to " + FloatToString(fValue));
                    }
                    else
                    {
                        SendMessageToPC(oPC, "Size Scale same as current - no change occurred.");
                    }
                }
            }
            else if (sCurrCommandArg == "subdual")
            {
                int nSub = GetLocalInt(oPC,"SUBDUAL");

                if (sCommandArg2 == "on")
                {
                    SetLocalInt(oPC,"SUBDUAL",1);
                    SendMessageToPC(oPC,"Subdual Mode is now ON.");
                }
                else if (sCommandArg2 == "off")
                {
                    SetLocalInt(oPC,"SUBDUAL",0);
                    SendMessageToPC(oPC,"Subdual Mode is now OFF.");
                }
                else
                {
                    if (nSub == 1){SendMessageToPC(oPC,"Subdual Mode is ON.");}
                    if (nSub == 0){SendMessageToPC(oPC,"Subdual Mode is OFF.");}
                }
            }
            else if (sCurrCommandArg == "tournament" || sCurrCommandArg == "tour")
            {
                int nSub = GetLocalInt(oPC,"TOURNAMENT");

                if (sCommandArg2 == "on")
                {
                    SetLocalInt(oPC,"TOURNAMENT",1);
                    SendMessageToPC(oPC,"Tournament Mode is now ON.");
                }
                else if (sCommandArg2 == "off")
                {
                    SetLocalInt(oPC,"TOURNAMENT",0);
                    SendMessageToPC(oPC,"Tournament Mode is now OFF.");
                }
                else
                {
                    if (nSub == 1){SendMessageToPC(oPC,"Tournament Mode is ON.");}
                    if (nSub == 0){SendMessageToPC(oPC,"Tournament Mode is OFF.");}
                }
            }
            else if (sCurrCommandArg == "dice")
            {
                SendMessageToPC(oPC,"Coming Soon.");
            }
            else if (sCurrCommandArg == "disguise")
            {
                SendMessageToPC(oPC,"Coming Soon.");
            }
            else if (sCurrCommandArg == "emote")
            {
                SendMessageToPC(oPC,"Coming Soon.");
            }
            else if (sCurrCommandArg == "lang" || sCurrCommandArg == "language" || sCurrCommandArg == "speak")
            {
                if (sCommandArg2 == "list")
                {
                    string sList = "You are able to speak the following languages:\n";
                    int i; for (i=1; i <= 83; i++)
                    {
                        if (GetLocalInt(oDataObject,IntToString(i)))
                        {
                            sList += ("- "+GetLanguageName(i)+"\n");
                        }
                    }
                    SendMessageToPC(oPC,sList);
                }
                else if (sCommandArg2 == "com" || sCommandArg2 == "common")
                {
                    SetLocalInt(oPC,"LangOn",0);
                    SetLocalInt(oPC,"LangSpoken",0);
                    SendMessageToPC(oPC,"You are now speaking Common.");
                }
                /////////////////////////////////////////////////////
                //Planar Languages
                /////////////////////////////////////////////////////
                else if (sCommandArg2 == "aby" || sCommandArg2 == "abyssal")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_ABYSSAL, oPC)) || (GetLocalInt(oDataObject,"11") == 1) || (GetLocalInt(oPC,"Tongues") == 1) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
                        {
                            SetLocalInt(oPC,"LangOn",1);
                            SetLocalInt(oPC,"LangSpoken",11);
                            SendMessageToPC(oPC,"You are now speaking Abyssal.");
                        }
                        else
                        {
                            SendMessageToPC(oPC,"You cannot speak this language");
                        }
                }
                else if (sCommandArg2 == "inf" || sCommandArg2 == "infernal")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_INFERNAL, oPC)) || (GetLocalInt(oDataObject,"12") == 1) || (GetLocalInt(oPC,"Tongues") == 1) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
                        {
                            SetLocalInt(oPC,"LangOn",1);
                            SetLocalInt(oPC,"LangSpoken",12);
                            SendMessageToPC(oPC,"You are now speaking Infernal.");
                        }
                        else
                        {
                            SendMessageToPC(oPC,"You cannot speak this language");
                        }
                }
                else if (sCommandArg2 == "cel" || sCommandArg2 == "celestial")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_CELESTIAL, oPC)) || (GetLocalInt(oDataObject,"10") == 1) || (GetLocalInt(oPC,"Tongues") == 1) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
                        {
                            SetLocalInt(oPC,"LangOn",1);
                            SetLocalInt(oPC,"LangSpoken",10);
                            SendMessageToPC(oPC,"You are now speaking Celestial.");
                        }
                        else
                        {
                            SendMessageToPC(oPC,"You cannot speak this language");
                        }
                }
                /////////////////////////////////////////////////////
                //Class Languages
                /////////////////////////////////////////////////////
                else if (sCommandArg2 == "ass" || sCommandArg2 == "assassin")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_ASSASSINS_CANT, oPC)) || (GetLocalInt(oDataObject,"37") == 1) || (GetLocalInt(oPC,"Tongues") == 1) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
					{
						SetLocalInt(oPC,"LangOn",1);
						SetLocalInt(oPC,"LangSpoken",37);
						SendMessageToPC(oPC,"You are now using Assassins' Cant.");
					}
					else
					{
						SendMessageToPC(oPC,"You cannot speak this language");
					}
                }				
                else if (sCommandArg2 == "dru" || sCommandArg2 == "druidic")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_DRUIDIC, oPC)) || (GetLocalInt(oDataObject,"14") == 1) || (GetLocalInt(oPC,"Tongues") == 1) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
					{
						SetLocalInt(oPC,"LangOn",1);
						SetLocalInt(oPC,"LangSpoken",14);
						SendMessageToPC(oPC,"You are now speaking Druidic.");
					}
					else
					{
						SendMessageToPC(oPC,"You cannot speak this language");
					}
                }
                else if (sCommandArg2 == "ani" || sCommandArg2 == "animal")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_ANIMAL, oPC)) || (GetLocalInt(oDataObject,"8") == 1) || (GetLocalInt(oPC,"Tongues") == 1) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
					{
						SetLocalInt(oPC,"LangOn",1);
						SetLocalInt(oPC,"LangSpoken",8);
						SendMessageToPC(oPC,"You are now grunting and growling like an Animal.");
					}
					else
					{
						SendMessageToPC(oPC,"You cannot speak this language");
					}
                }
                else if (sCommandArg2 == "thi" || sCommandArg2 == "thieves")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_THIEVES_CANT, oPC)) || (GetLocalInt(oDataObject,"9") == 1) || (GetLocalInt(oPC,"Tongues") == 1) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
                        {
                            SetLocalInt(oPC,"LangOn",1);
                            SetLocalInt(oPC,"LangSpoken",9);
                            SendMessageToPC(oPC,"You are now signing in Thieves Cant.");
                        }
                        else
                        {
                            SendMessageToPC(oPC,"You do not know Thieves Cant.");
                        }
                }
                /////////////////////////////////////////////////////
                //Racial Languages
                /////////////////////////////////////////////////////
                else if (sCommandArg2 == "elv" || sCommandArg2 == "elven")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_ELVEN, oPC)) || (GetLocalInt(oDataObject,"1") == 1) || (GetLocalInt(oPC,"Tongues") == 1) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
					{
						SetLocalInt(oPC,"LangOn",1);
						SetLocalInt(oPC,"LangSpoken",1);
						SendMessageToPC(oPC,"You are now speaking Elven.");
					}
					else
					{
						SendMessageToPC(oPC,"You cannot speak this language");
					}
                }
                else if (sCommandArg2 == "gno" || sCommandArg2 == "gnomish")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_GNOMISH, oPC)) || (GetLocalInt(oDataObject,"2") == 1) || (GetLocalInt(oPC,"Tongues") == 1) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
					{
						SetLocalInt(oPC,"LangOn",1);
						SetLocalInt(oPC,"LangSpoken",2);
						SendMessageToPC(oPC,"You are now speaking Gnomish.");
					}
					else
					{
						SendMessageToPC(oPC,"You cannot speak this language");
					}
                }
                else if (sCommandArg2 == "hal" || sCommandArg2 == "halfling")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_HALFLING, oPC)) || (GetLocalInt(oDataObject,"3") == 1) || (GetLocalInt(oPC,"Tongues") == 1) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
					{
						SetLocalInt(oPC,"LangOn",1);
						SetLocalInt(oPC,"LangSpoken",3);
						SendMessageToPC(oPC,"You are now speaking Halfling.");
					}
					else
					{
						SendMessageToPC(oPC,"You cannot speak this language");
					}
                }
                else if (sCommandArg2 == "dwa" || sCommandArg2 == "dwarven")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_DWARVEN, oPC)) || (GetLocalInt(oDataObject,"4") == 1)||(GetLocalInt(oPC,"Tongues") == 1)|| GetIsDM(oPC) || GetIsDMPossessed(oPC))
					{
						SetLocalInt(oPC,"LangOn",1);
						SetLocalInt(oPC,"LangSpoken",4);
						SendMessageToPC(oPC,"You are now speaking Dwarven.");
					}
					else
					{
						SendMessageToPC(oPC,"You cannot speak this language");
					}
                }
                else if (sCommandArg2 == "orc" || sCommandArg2 == "orcish")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_ORCISH, oPC)) || (GetLocalInt(oDataObject,"5") == 1) || (GetLocalInt(oPC,"Tongues") == 1) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
					{
						SetLocalInt(oPC,"LangOn",1);
						SetLocalInt(oPC,"LangSpoken",5);
						SendMessageToPC(oPC,"You are now speaking Orcish.");
					}
					else
					{
						SendMessageToPC(oPC,"You cannot speak this language");
					}
                }
                else if (sCommandArg2 == "gob" || sCommandArg2 == "goblin")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_GOBLIN, oPC)) || (GetLocalInt(oDataObject,"6") == 1) || (GetLocalInt(oPC,"Tongues") == 1) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
					{
						SetLocalInt(oPC,"LangOn",1);
						SetLocalInt(oPC,"LangSpoken",6);
						SendMessageToPC(oPC,"You are now speaking Goblin.");
					}
					else
					{
						SendMessageToPC(oPC,"You cannot speak this language");
					}
                }
                else if (sCommandArg2 == "xanalress" || sCommandArg2 == "xan" || sCommandArg2 == "drow" || sCommandArg2 == "dro")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_DROW, oPC)) || (GetLocalInt(oDataObject,"13") == 1) || (GetLocalInt(oPC,"Tongues") == 1) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
					{
						SetLocalInt(oPC,"LangOn",1);
						SetLocalInt(oPC,"LangSpoken",13);
						SendMessageToPC(oPC,"You are now speaking Xanalress.");
					}
					else
					{
						SendMessageToPC(oPC,"You cannot speak this language");
					}
                }
                else if (sCommandArg2 == "sign" || sCommandArg2 == "drowsign")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_DROW_HAND_CANT, oPC)) || (GetLocalInt(oDataObject,"81") == 1)||(GetLocalInt(oPC,"Tongues") == 1)|| GetIsDM(oPC) || GetIsDMPossessed(oPC))
					{
						SetLocalInt(oPC,"LangOn",1);
						SetLocalInt(oPC,"LangSpoken",81);
						SendMessageToPC(oPC,"You are now using Drow Sign Language.");
					}
					else
					{
						SendMessageToPC(oPC,"You do not know Drow Sign Language.");
					}
                }
                else if (sCommandArg2 == "und" || sCommandArg2 == "undercommon")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_UNDERCOMMON, oPC)) || (GetLocalInt(oDataObject,"46") == 1) || (GetLocalInt(oPC,"Tongues") == 1) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
					{
						SetLocalInt(oPC,"LangOn",1);
						SetLocalInt(oPC,"LangSpoken",46);
						SendMessageToPC(oPC,"You are now speaking Undercommon.");
					}
					else
					{
						SendMessageToPC(oPC,"You cannot speak this language");
					}
                }
                else if (sCommandArg2 == "aqu" || sCommandArg2 == "aquan")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_AQUAN, oPC)) || (GetLocalInt(oDataObject,"70") == 1) || (GetLocalInt(oPC,"Tongues") == 1) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
					{
						SetLocalInt(oPC,"LangOn",1);
						SetLocalInt(oPC,"LangSpoken",70);
						SendMessageToPC(oPC,"You are now speaking Aquan.");
					}
					else
					{
						SendMessageToPC(oPC,"You cannot speak this language");
					}
                }
				else if (sCommandArg2 == "aur" || sCommandArg2 == "auran")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_AURAN, oPC)) || (GetLocalInt(oDataObject,"71") == 1) || (GetLocalInt(oPC,"Tongues") == 1) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
					{
						SetLocalInt(oPC,"LangOn",1);
						SetLocalInt(oPC,"LangSpoken",71);
						SendMessageToPC(oPC,"You are now speaking Auran.");
					}
					else
					{
						SendMessageToPC(oPC,"You cannot speak this language");
					}
                }
				else if (sCommandArg2 == "dra" || sCommandArg2 == "draconic")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_AURAN, oPC)) || (GetLocalInt(oDataObject,"7") == 1) || (GetLocalInt(oPC,"Tongues") == 1) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
					{
						SetLocalInt(oPC,"LangOn",1);
						SetLocalInt(oPC,"LangSpoken",7);
						SendMessageToPC(oPC,"You are now speaking Draconic.");
					}
					else
					{
						SendMessageToPC(oPC,"You cannot speak this language");
					}
                }
				else if (sCommandArg2 == "gia" || sCommandArg2 == "giant")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_GIANT, oPC)) || (GetLocalInt(oDataObject,"72") == 1) || (GetLocalInt(oPC,"Tongues") == 1) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
					{
						SetLocalInt(oPC,"LangOn",1);
						SetLocalInt(oPC,"LangSpoken",72);
						SendMessageToPC(oPC,"You are now speaking Giantish.");
					}
					else
					{
						SendMessageToPC(oPC,"You cannot speak this language");
					}
                }
				else if (sCommandArg2 == "ign" || sCommandArg2 == "ignan")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_IGNAN, oPC)) || (GetLocalInt(oDataObject,"73") == 1) || (GetLocalInt(oPC,"Tongues") == 1) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
					{
						SetLocalInt(oPC,"LangOn",1);
						SetLocalInt(oPC,"LangSpoken",73);
						SendMessageToPC(oPC,"You are now speaking Ignan.");
					}
					else
					{
						SendMessageToPC(oPC,"You cannot speak this language");
					}
                }
				else if (sCommandArg2 == "syl" || sCommandArg2 == "sylvan")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_SYLVAN, oPC)) || (GetLocalInt(oDataObject,"74") == 1) || (GetLocalInt(oPC,"Tongues") == 1) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
					{
						SetLocalInt(oPC,"LangOn",1);
						SetLocalInt(oPC,"LangSpoken",74);
						SendMessageToPC(oPC,"You are now speaking Sylvan.");
					}
					else
					{
						SendMessageToPC(oPC,"You cannot speak this language");
					}
                }
				else if (sCommandArg2 == "ter" || sCommandArg2 == "terran")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_TERRAN, oPC)) || (GetLocalInt(oDataObject,"75") == 1) || (GetLocalInt(oPC,"Tongues") == 1) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
					{
						SetLocalInt(oPC,"LangOn",1);
						SetLocalInt(oPC,"LangSpoken",75);
						SendMessageToPC(oPC,"You are now speaking Ignan.");
					}
					else
					{
						SendMessageToPC(oPC,"You cannot speak this language");
					}
                }
				else if (sCommandArg2 == "tro" || sCommandArg2 == "troglodyte")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_TROGLODYTE, oPC)) || (GetLocalInt(oDataObject,"76") == 1) || (GetLocalInt(oPC,"Tongues") == 1) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
					{
						SetLocalInt(oPC,"LangOn",1);
						SetLocalInt(oPC,"LangSpoken",76);
						SendMessageToPC(oPC,"You are now speaking Ignan.");
					}
					else
					{
						SendMessageToPC(oPC,"You cannot speak this language");
					}
                }				
                else if (sCommandArg2 == "due" || sCommandArg2 == "duergar")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_DUERGAR, oPC)) || (GetLocalInt(oDataObject,"64") == 1) || (GetLocalInt(oPC,"Tongues") == 1) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
					{
						SetLocalInt(oPC,"LangOn",1);
						SetLocalInt(oPC,"LangSpoken",64);
						SendMessageToPC(oPC,"You are now speaking Duergar.");
					}
					else
					{
						SendMessageToPC(oPC,"You cannot speak this language");
					}

                    /////////////////////////////////////////////////////
                    //Human Languages
                    /////////////////////////////////////////////////////
                }
                else if (sCommandArg2 == "illuskan" || sCommandArg2 == "ill")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_ILLUSKAN, oPC)) || (GetLocalInt(oDataObject,"22") == 1)||(GetLocalInt(oPC,"Tongues") == 1)|| GetIsDM(oPC) || GetIsDMPossessed(oPC))
					{
						SetLocalInt(oPC,"LangOn",1);
						SetLocalInt(oPC,"LangSpoken",22);
						SendMessageToPC(oPC,"You are now speaking Illuskan.");
					}
					else
					{
						SendMessageToPC(oPC,"You cannot speak this language");
					}
                }
                else if (sCommandArg2 == "alzhedo" || sCommandArg2 == "alz" || sCommandArg2 == "calishite")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_ALZHEDO, oPC)) || (GetLocalInt(oDataObject,"23") == 1) || (GetLocalInt(oPC,"Tongues") == 1) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
					{
						SetLocalInt(oPC,"LangOn",1);
						SetLocalInt(oPC,"LangSpoken",23);
						SendMessageToPC(oPC,"You are now speaking Alzhedo.");
					}
					else
					{
						SendMessageToPC(oPC,"You cannot speak this language");
					}
                }
                else if (sCommandArg2 == "ima" || sCommandArg2 == "imaskar")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_IMASKARI, oPC)) || (GetLocalInt(oDataObject,"24") == 1) || (GetLocalInt(oPC,"Tongues") == 1) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
					{
						SetLocalInt(oPC,"LangOn",1);
						SetLocalInt(oPC,"LangSpoken",24);
						SendMessageToPC(oPC,"You are now speaking Imaskar.");
					}
					else
					{
						SendMessageToPC(oPC,"You cannot speak this language");
					}
                }
                else if (sCommandArg2 == "lantanese" || sCommandArg2 == "lan")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_LANTANESE, oPC)) || (GetLocalInt(oDataObject,"25") == 1) || (GetLocalInt(oPC,"Tongues") == 1) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
					{
						SetLocalInt(oPC,"LangOn",1);
						SetLocalInt(oPC,"LangSpoken",25);
						SendMessageToPC(oPC,"You are now speaking Lantanese.");
					}
					else
					{
						SendMessageToPC(oPC,"You cannot speak this language");
					}
                }
                else if (sCommandArg2 == "mulhorandi" || sCommandArg2 == "mul")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_MULHORANDI, oPC)) || (GetLocalInt(oDataObject,"27") == 1) || (GetLocalInt(oPC,"Tongues") == 1) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
					{
						SetLocalInt(oPC,"LangOn",1);
						SetLocalInt(oPC,"LangSpoken",27);
						SendMessageToPC(oPC,"You are now speaking Mulhorandi.");
					}
					else
					{
						SendMessageToPC(oPC,"You cannot speak this language");
					}
                }
                else if (sCommandArg2 == "ras" || sCommandArg2 == "rashemi")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_RASHEMI, oPC)) || (GetLocalInt(oDataObject,"30") == 1)||(GetLocalInt(oPC,"Tongues") == 1)|| GetIsDM(oPC) || GetIsDMPossessed(oPC))
					{
						SetLocalInt(oPC,"LangOn",1);
						SetLocalInt(oPC,"LangSpoken",30);
						SendMessageToPC(oPC,"You are now speaking Rashemi.");
					}
					else
					{
						SendMessageToPC(oPC,"You cannot speak this language");
					}
                }
                else if (sCommandArg2 == "talfiric" || sCommandArg2 == "tal")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_TALFIRIC, oPC)) || (GetLocalInt(oDataObject,"38") == 1)||(GetLocalInt(oPC,"Tongues") == 1)|| GetIsDM(oPC) || GetIsDMPossessed(oPC))
					{
						SetLocalInt(oPC,"LangOn",1);
						SetLocalInt(oPC,"LangSpoken",38);
						SendMessageToPC(oPC,"You are now speaking Talfiric.");
					}
					else
					{
						SendMessageToPC(oPC,"You cannot speak this language");
					}
                }
                else if (sCommandArg2 == "che" || sCommandArg2 == "chessentan")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_CHESSENTAN, oPC)) || (GetLocalInt(oDataObject,"44") == 1)||(GetLocalInt(oPC,"Tongues") == 1)|| GetIsDM(oPC) || GetIsDMPossessed(oPC))
					{
						SetLocalInt(oPC,"LangOn",1);
						SetLocalInt(oPC,"LangSpoken",44);
						SendMessageToPC(oPC,"You are now speaking Chessentan.");
					}
					else
					{
						SendMessageToPC(oPC,"You cannot speak this language");
					}
                }
                else if (sCommandArg2 == "cho" || sCommandArg2 == "chondathan")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_CHONDATHAN, oPC)) || (GetLocalInt(oDataObject,"53") == 1) || (GetLocalInt(oPC,"Tongues") == 1) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
					{
						SetLocalInt(oPC,"LangOn",1);
						SetLocalInt(oPC,"LangSpoken",53);
						SendMessageToPC(oPC,"You are now speaking Chondathan.");
					}
					else
					{
						SendMessageToPC(oPC,"You cannot speak this language");
					}
                }
                else if (sCommandArg2 == "chu" || sCommandArg2 == "chultan")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_CHULTAN, oPC)) || (GetLocalInt(oDataObject,"55") == 1) || (GetLocalInt(oPC,"Tongues") == 1) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
                        {
                            SetLocalInt(oPC,"LangOn",1);
                            SetLocalInt(oPC,"LangSpoken",55);
                            SendMessageToPC(oPC,"You are now speaking Chultan.");
                        }
                        else
                        {
                            SendMessageToPC(oPC,"You cannot speak this language");
                        }
                }
                else if (sCommandArg2 == "dam" || sCommandArg2 == "damaran")
                {
                    if ((GetHasFeat(FEAT_LANGUAGE_DAMARAN, oPC)) || (GetLocalInt(oDataObject,"56") == 1) || (GetLocalInt(oPC,"Tongues") == 1) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
					{
						SetLocalInt(oPC,"LangOn",1);
						SetLocalInt(oPC,"LangSpoken",56);
						SendMessageToPC(oPC,"You are now speaking Damaran.");
					}
					else
					{
						SendMessageToPC(oPC,"You cannot speak this language");
					}
                }
                else
                {
                    SendMessageToPC(oPC, "Command not recognized. Use \"-help\" for a complete list of commands and syntax.");
                }

            }
            else if (sCurrCommandArg == "weave")
            {
                int oDead = GetCampaignInt("Deadmagic",GetTag(oArea));
                if (GetIsDM(oPC) || GetIsDMPossessed(oPC))
                {
                    SendMessageToPC(oPC, "Exact value is: " + IntToString(oDead));
                }
                if (GetHasFeat(1599, oPC) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
                {
                    if (oDead >=95)
                    {
                        SendMessageToPC(oPC,"The weave here is damaged enough that you sense nothing.");
                    }
                    else if (oDead >=66)
                    {
                        SendMessageToPC(oPC,"The weave here is extremely damaged.");
                    }
                    else if (oDead >=33)
                    {
                        SendMessageToPC(oPC,"The weave here is moderately damaged.");
                    }
                    else
                    {
                        SendMessageToPC(oPC,"The weave here is fairly healthy.");
                    }
                }
            }
            else if (sCurrCommandArg == "setdeadmagic" && GetIsDM(oPC))
            {
                SetCampaignInt("Deadmagic",GetTag(oArea),StringToInt(sCommandArg2));
                SendMessageToPC(oPC, "New Dead Magic: " + IntToString(StringToInt(sCommandArg2)));
            }

            else if (sCurrCommandArg == "setwildmagic" && GetIsDM(oPC))
            {
                SetCampaignInt("Wildmagic",GetTag(oArea),StringToInt(sCommandArg2));
                SendMessageToPC(oPC, "New Wild Magic: " + IntToString(StringToInt(sCommandArg2)));
            }
            else if (sCurrCommandArg == "shopset" && GetIsDM(oPC))
            {
                string sUnique = sCommandArg2;
                int nPrice = StringToInt(sCommandArg3);
                SetCampaignInt("GS_SHOP", "PRICE_"+sUnique, nPrice);
            }
            else if (sCurrCommandArg == "ness" && GetIsDM(oPC))
            {
                // get every spawn controller
                int i; for (i = 1; i <= GetLocalInt(oArea, "Spawns"); i++)
                {
                    // Remove every 'child' creature from controller
                    object oSpawn = GetLocalObject(oArea, "Spawn"+PadIntToString(i, 2));
                    if (GetIsObjectValid(oSpawn))
                    {
                        // Despawn Children
                        DespawnChildren(oSpawn);

                        // Reset Spawn
                        int nTimeNow = GetCurrentRealSeconds();
                        ResetSpawn(oSpawn, nTimeNow);
                    }
                }

                // Send webhook message of which DM activated this command
                struct NWNX_WebHook_Message sResetNESS;
                sResetNESS.sUsername = "DM Command Called";
                sResetNESS.sTitle = "NESS Reset!";
                sResetNESS.sColor = "#FF2200";
                sResetNESS.sAuthorName = GetName(oPC);
                sResetNESS.sDescription = "DM " + GetName(oPC) + " has called for NESS Reset in the area.";
                sResetNESS.sField1Name = "Playername";
                sResetNESS.sField1Value = GetPCPlayerName(oPC);
                sResetNESS.iField1Inline = TRUE;
                sResetNESS.sField2Name = "IP";
                sResetNESS.sField2Value = GetPCIPAddress(oPC);
                sResetNESS.iField2Inline = TRUE;
                sResetNESS.sField3Name = "CDKey";
                sResetNESS.sField3Value = GetPCPublicCDKey(oPC);
                sResetNESS.iField3Inline = TRUE;
                sResetNESS.sField4Name = "Area";
                sResetNESS.sField4Value = GetName(oArea);
                sResetNESS.iField4Inline = FALSE;
                sResetNESS.sFooterText = "DM Called Event";
                sResetNESS.iTimestamp = NWNX_Time_GetTimeStamp();
                string sConstructedMsg = NWNX_WebHook_BuildMessageForWebHook("discordapp.com", WEBHOOK_EVENT_CHANNEL, sResetNESS);
                NWNX_WebHook_SendWebHookHTTPS("discordapp.com", WEBHOOK_EVENT_CHANNEL, sConstructedMsg);
            }
            else if (sCurrCommandArg == "bug")
            {
                 NWNX_WebHook_SendWebHookHTTPS("discordapp.com", WEBHOOK_BUG_CHANNEL, "Bug Message: " + sChatMessage, GetName(oPC));
                 SendMessageToPC(oPC,"Bug report sent, hope to hear back soon");
            }
            else if (sCurrCommandArg == "voice")
            {
                oItem = GetItemPossessedBy(oPC, "PC_Data_Object");
                string sEmpty = GetLocalString(oMod, "ARRAY_SOUNDSETS_NULL");
                string sBanned = GetLocalString(oMod, "ARRAY_SOUNDSETS_BAN");
                int isDM = (GetIsDM(oPC) || GetIsDMPossessed(oPC));

                if (sCommandArg2 == "help")
                {
                    // Only lists 20 IDs at a time to reduce clutter
                    string sOutput = "Soundset Data - ID: Name (gender)";
                    int nPage = StringToInt(sCommandArg3);
                    if (nPage <= 0)
                    {
                        SendMessageToPC(oPC, "Page must be 1+. Use \"-help\" for a complete list of commands and syntax.");
                        return;
                    }
                    int nMaxRows = Get2DARowCount("soundset");
                    int nSkip = nPage == 1 ? 0 : GetLocalInt(oItem, "nSkipped");
                    int nStart = ((nPage - 1) * 20) + nSkip;
                    int i, nCount = 0;

                    for (i = nStart; nCount < 20; i++)
                    {
                        if (i > nMaxRows) break; // No more entries;
                        string sFind = PadZero(IntToString(i), 3);

                        // Invalid, Empty or Reserved
                        if (ArrayIndex(sEmpty, sFind) != -1)           { nSkip++; continue; }
                        // Player-Banned Soundsets; Skip
                        if (ArrayIndex(sBanned, sFind) != -1 && !isDM) { nSkip++; continue; }

                        nCount++;
                        sOutput += GetSoundsetData(i);
                    }
                    SendMessageToPC(oPC, sOutput);

                    // Update trackers
                    int nLast = GetLocalInt(oItem, "nLastPage");
                    if (nPage != nLast)
                    {
                        SetLocalInt(oItem, "nLastPage", nPage);
                        SetLocalInt(oItem, "nSkipped", nSkip);
                    }
                }
                else
                {
                    string sReason, sFind = PadZero(sCommandArg2, 3);
                    int nSoundset = StringToInt(sCommandArg2);

                    // Checking validity
                    if (GetSoundsetData(nSoundset, FALSE) == "")
                    {
                        sReason = "Invalid, Empty, or Reserved";
                        nSoundset = -1;
                    }
                    if (ArrayIndex(sBanned, sFind) != -1 && !isDM)
                    {
                        sReason = "Banned Soundset - Not a DM";
                        nSoundset = -1;
                    }

                    // Display output
                    if (nSoundset >= 0)
                    {
                        string sVoice = IntToString(GetSoundset(oPC));
                        SendMessageToPC(oPC, "Previous Voice: " + sVoice);
                        SetSoundset(oPC, nSoundset);
                        SendMessageToPC(oPC, "Current Voice: " + IntToString(nSoundset));
                    }
                    else
                    {
                        SendMessageToPC(oPC, sFind+": Invalid Soundset (" + sReason + ")");
                    }
                }
            }
            else if (sCurrCommandArg == "xpgp")
            {
                oItem = GetItemPossessedBy(oPC, "PC_Data_Object");
                if (sCommandArg2 == "0" || sCommandArg2 == "1")
                {
                    // Save the setting and reset value
                    SetLocalInt(oItem, "XPtoGP", StringToInt(sCommandArg2));
                    SetLocalInt(oItem, "SavedXP", 0);

                    string sMsg = "";
                    if (sCommandArg2 == "1")
                    {
                        sMsg = "Every round will convert newly gained XP into GP.";
                    }
                    else
                    {
                        sMsg = "XP gain is normal.";
                    }
                    SendMessageToPC(oPC, sMsg);
                }
                else
                {
                    SendMessageToPC(oPC, "Invalid value. \"-xpgp 1\" to convert XP to GP or \"-xpgp 0\" for regular XP gains.");
                }
            }
            else if (sCurrCommandArg == "stuck")
            {
                AssignCommand(oPC, ClearAllActions(TRUE));
                location lNew = GetLocalLocation(oPC, "PC_LOCATION");
                if (!GetIsLocationValid(lNew))
                {
                    lNew = GetRandomLocation(oArea, oPC, 5.0);
                    AssignCommand(oPC, ActionForceMoveToLocation(lNew, TRUE, 3.0));
                }
                int bBlackout = GetArea(oPC) == GetAreaFromLocation(lNew);
                if (bBlackout)
                {
                    AssignCommand(oPC, ActionDoCommand(FadeToBlack(oPC, FADE_SPEED_FASTEST)));
                    AssignCommand(oPC, ActionWait(0.5));
                }
                AssignCommand(oPC, ActionJumpToLocation(lNew));
                if (bBlackout)
                {
                    AssignCommand(oPC, ActionDoCommand(FadeFromBlack(oPC, FADE_SPEED_FASTEST)));
                }
            }
            else if (sCurrCommandArg == "lockinplace")
            {
                effect eLock = SupernaturalEffect(EffectCutsceneImmobilize());
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLock, oPC);
                SetCommandable(FALSE, oPC);
            }
            else if (sCurrCommandArg == "unlock")
            {
                effect eE = GetFirstEffect(oPC);
                while (GetIsEffectValid(eE))
                {
                    if (GetEffectDurationType(eE) == DURATION_TYPE_PERMANENT &&
                        GetEffectSubType(eE) == SUBTYPE_SUPERNATURAL &&
                        GetEffectType(eE) == EFFECT_TYPE_CUTSCENEIMMOBILIZE)
                    {
                        RemoveEffect(oPC, eE);
                    }
                    eE = GetNextEffect(oPC);
                }
                SetCommandable(TRUE, oPC);
            }
            else if (sCurrCommandArg == "pic")
            {
                string szMessage = "";
                if (sCommandArg2 == "help")
                {
                    szMessage = "Type \"-pic set RR\" replacing RR with the resref " +
                        "of the portrait you wish to use. The resref should " +
                        "not include any trailing size letter.\n" +
                        "( e.g. po_el_f_09_ )";
                }
                else if (sCommandArg2 == "set")
                {
                    szMessage = "Portrait changed! ( resref: " + sCommandArg3 + " )";
                    SetPortraitResRef(oPC, sCommandArg3);
                }
                else
                {
                    szMessage = "Invalid argument. Type \"-help\" for a complete list of commands and syntax.";
                }
                SendMessageToPC(oPC, szMessage);
            }
            else if (sCurrCommandArg == "findus")
            {
                object oFM = GetFirstPC();
                // Step through the party members.
                if (sCommandArg2 == "1")
                    {
                        SetLocalInt(oDataObject,"SaadFind", 1);
                        SendMessageToPC(oPC, "You may now be located.");
                    }
                else if (sCommandArg2 == "0")
                    {
                        SetLocalInt(oDataObject,"SaadFind", 0);
                        SendMessageToPC(oPC, "You may not be located.");
                    }
                else
                {
                    while(GetIsObjectValid(oFM) && GetLocalInt(oDataObject,"SaadFind")>0)
                    {
                        if (GetIsDM(oFM) || GetIsDMPossessed(oFM) || GetLocalInt(GetPlayerDataObject(oFM),"SaadFind")<=0)
                        {
                            oFM = GetNextPC();
                        }
                        else
                        {
                            SendMessageToPC(oPC, GetName(oFM, FALSE) + " can be found in the area named " + GetName(GetArea(oFM),FALSE));
                            oFM = GetNextPC();
                        }
                    }
                }
            }
            /*else if (sCurrCommandArg == "findus 1")
            {
            SetLocalInt(oDataObject,"SaadFind", 0);
            SendMessageToPC(oPC, "You may now be located.");
            }
            else if (sCurrCommandArg == "findus 0")
            {
            SetLocalInt(oDataObject,"SaadFind", 1);
            SendMessageToPC(oPC, "You may not be located.");
            }*/
            else if (sCurrCommandArg == "performing" && GetLevelByClass(CLASS_TYPE_BARD,oPC)>0)
            /* New command - Saadow, 7/27/24 Performance checking, allow a player to make a performance as a bard,
            each message checks if they're still performing, rolls a perform check, and accumulates the number of
            turns they take performing based on posts. If they roll a 1, the performance ends with a failure,
            but if they end the performance on their own, based on how many turns they took performing, nearby
            npc's will need to make a save in a colossal area. Every failed save will yield gold and experience
            for the bard. It won't be much, however, each successful performance will earn a number of points of
            mythic charisma based on if they succeed or fail. */
            {
                if (GetLocalInt(oDataObject,"PcIsPerforming") <= 0)
                {
                    effect saadMusicVis = EffectVisualEffect(VFX_DUR_BARD_SONG);
                    saadMusicVis = SetEffectSpellId(saadMusicVis, 544003);
                    SendMessageToPC(oPC, "You begin a performance, may it be a good one!");
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, saadMusicVis, oPC);
                    NWNX_Player_SetAlwaysWalk(oPC,TRUE);
                    SetLocalInt(oPC,"walk", 1);
                    SetLocalInt(oDataObject,"PcIsPerforming",1);
                    SetLocalInt(oDataObject,"SaadPerformanceAccumulator",0);
                    return;
                }
                else if (GetLocalInt(oDataObject,"PcIsPerforming")>=1 && GetLocalInt(oDataObject,"SaadPerformanceAccumulator")>0)
                {
                    object saadTarget;
                    object saadItem;
                    effect saadMusicVis = EffectVisualEffect(VFX_DUR_BARD_SONG);
                    effect saadVis = EffectVisualEffect(VFX_COM_BLOOD_CRT_WIMP);
                    int nDC = GetLevelByClass(CLASS_TYPE_BARD,oPC)+GetAbilityModifier(ABILITY_CHARISMA,oPC);
                    //RemoveEffect(oPC,saadMusicVis);
                    effect eLoop = GetFirstEffect(oPC);
                    while(GetIsEffectValid(eLoop))
                    {
                        if(GetEffectSpellId(eLoop) == 544003)
                            {
                            RemoveEffect(oPC, eLoop);
                            eLoop = GetNextEffect(oPC);
                            //return;
                            }
                        else
                            {
                            eLoop = GetNextEffect(oPC);
                            }
                    }
                    SendMessageToPC(oPC, "You end your performance with a flourish, lets see how you did!");
                    SendMessageToPC(oPC, "You performed successfully for "+IntToString(GetLocalInt(oDataObject,"SaadPerformanceAccumulator"))+" full round actions.");
                    SetLocalInt(oDataObject,"MythicCHA",GetLocalInt(oDataObject,"MythicCHA")+GetLocalInt(oDataObject,"SaadPerformanceAccumulator"));
                    //Mythic charisma testing
                    int iCha = GetLocalInt(oDataObject, "MythicCHA");
                    SetLocalInt(oDataObject, "MythicCHA", iCha);
                    if (iCha==1000 || iCha==2000 || iCha==4000 || iCha==8000)
                        {
                            int nRAS = NWNX_Creature_GetRawAbilityScore(oPC, ABILITY_CHARISMA) + 1;
                            NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CHARISMA, nRAS);
                        }

                    // This will do more when I figure out how to do the area of effect check
                    //Get first target in spell area
                    saadTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oPC), FALSE, OBJECT_TYPE_CREATURE );
                    while(GetIsObjectValid(saadTarget))
                    {
                        if (GetIsPC(saadTarget) == TRUE || saadTarget == oPC)
                        {
                        }
                        else
                        {
                        if(WillSave(saadTarget,nDC,SAVING_THROW_TYPE_MIND_SPELLS,oPC) == 0)
                            {
                                ApplyEffectToObject(DURATION_TYPE_INSTANT, saadVis, saadTarget );
                                int SaadChatCheck = d3(1);
                                //SendMessageToPC(oPC,"DEBUG: "+IntToString(SaadChatCheck)+" was the roll for what the NPC says.");
                                if(SaadChatCheck==1)
                                {
                                AssignCommand(saadTarget,SpeakString("*claps!*",TALKVOLUME_TALK));
                                }
                                else if(SaadChatCheck==2)
                                {
                                AssignCommand(saadTarget,SpeakString("*cheers!!*",TALKVOLUME_TALK));
                                }
                                else if(SaadChatCheck==3)
                                {
                                AssignCommand(saadTarget,SpeakString("YEAH!!",TALKVOLUME_TALK));
                                }
                                //AssignCommand(saadTarget, PlayAnimation(111-Random(3), 6.5));
                                GiveGoldToCreature(oPC,d4(1));
                                GiveXPToCreature(oPC,(d6(1)-1));
                            }
                        else
                            {
                                int SaadChatCheck = d20(1);
                                //SendMessageToPC(oPC,"DEBUG: "+IntToString(SaadChatCheck)+" was the roll for what the NPC says, BUT ONLY IF THEY PASSED THE SAVE.");
                                if(SaadChatCheck==1)
                                {
                                AssignCommand(saadTarget,SpeakString("*waves the performer off*",TALKVOLUME_TALK));
                                }
                                else if(SaadChatCheck==2)
                                {
                                AssignCommand(saadTarget,SpeakString("boo!",TALKVOLUME_TALK));
                                }
                                else if(SaadChatCheck==3)
                                {
                                AssignCommand(saadTarget,SpeakString("Don't quit your day job!",TALKVOLUME_TALK));
                                }

                            }
                        }
                        //Get next target in spell area
                        saadTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oPC));
                    }
                    // end of special segment for effect
                    NWNX_Player_SetAlwaysWalk(oPC,FALSE);
                    SetLocalInt(oDataObject,"PcIsPerforming",0);
                    SetLocalInt(oPC,"walk", 0);
                    return;
                }
                else if (GetLocalInt(oDataObject,"PcIsPerforming")>=1 && GetLocalInt(oDataObject,"SaadPerformanceAccumulator")<=0)
                {
                    //RemoveEffect(oPC,saadMusicVis);
                    effect eLoop = GetFirstEffect(oPC);
                    while(GetIsEffectValid(eLoop))
                    {
                        if(GetEffectSpellId(eLoop) == 544003)
                            {
                            RemoveEffect(oPC, eLoop);
                            eLoop = GetNextEffect(oPC);
                            //eLoop = GetFirstEffect(oPC);
                            //return;
                            }
                        else
                            {
                            eLoop = GetNextEffect(oPC);
                            }
                    }
                    SendMessageToPC(oPC, "You decide not to perform, instead!");
                    NWNX_Player_SetAlwaysWalk(oPC,FALSE);
                    SetLocalInt(oDataObject,"PcIsPerforming",0);
                    SetLocalInt(oPC,"walk", 0);
                    return;
                }
            }
            else
            {
                SendMessageToPC(oPC, "Command not recognized. Use \"-help\" for a complete list of commands and syntax.");
            }
        }
    }
    else if (nVolume == TALKVOLUME_PARTY)
    {
        /*if (!GetIsDM(oPC)) -bugsbunnyno.png -saadow 5/13/24
        {
            SetPCChatMessage("");
        } */
    }
}

