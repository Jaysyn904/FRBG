#include "inc_dynconv"  
  
void main()  
{  
    object oUser = GetLastUsedBy();  
    if (!GetIsObjectValid(oUser)) return;  
  
    SpeakString("I was last used by: " + GetName(oUser));  
  
    if (IsInConversation(oUser)) {  
        SpeakString("DEBUG: PC already in conversation; aborting dynconv start.");  
        return;  
    }  
  
    SpeakString("DEBUG: Starting bg_profs_cv for " + GetName(oUser));  
    StartDynamicConversation("bg_profs_cv", oUser);  
}