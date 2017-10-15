// notecard announcement script by George Black  2017-10-15

integer currentLine = 0;
integer defaultDelay = 120;
string soundName = "Bing - Bong  Announcement Chime";
string notecardName = "Announcements";
key announcementNotecard;
key notecardQueryId;

playLine() {
     notecardQueryId = llGetNotecardLine(notecardName, currentLine);
}

default
{
    on_rez(integer param) {
        llResetScript();
    }

    state_entry()
    {
       llOwnerSay("Hello!");
       string desc = llGetObjectDesc();
       integer delay = (integer) desc;
       if (delay == 0) {
           delay = defaultDelay;
           llOwnerSay("Setting delay to "+(string)delay+" seconds as default. Override with object description and reset me.");
        } else {
           llOwnerSay("Setting delay to "+(string)delay+" seconds from object description.");
        }

       llPreloadSound(soundName);
       currentLine = 0;
       announcementNotecard = llGetInventoryKey(notecardName);
       if (announcementNotecard == NULL_KEY) {
           llOwnerSay("Sorry, couldn't find '"+notecardName+"' notecard in my inventory.");
       } else {
           llSetTimerEvent((float)delay);
       }
    }

    changed(integer change) {
        if (change & CHANGED_INVENTORY) {
            llResetScript();
        }
    }

    timer() {
        playLine();
    }

    dataserver(key query_id, string data)
    {
        if (query_id == notecardQueryId) {
            if (data == EOF) {
                currentLine = 0;
                playLine();
            } else {
                currentLine++;
                llPlaySound(soundName,1.0);
                llSay(0,data);
            }
        }
    }

    touch_start(integer total_number)
    {
        playLine();
    }
}
