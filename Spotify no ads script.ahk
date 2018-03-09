;; Spotify mute ads
;; This script will mute your system volume when an ad is detected
;; By: Patrick Touchette
;; Date: 2018-03-09

#Persistent
#SingleInstance force
#WinActivateForce
SetTitleMatchMode, 2
SetTitleMatchMode, Slow
DetectHiddenWindows, off
sleep_interval = 100
listenToSpotify := false

;; To start playing music ad free, press F1
;; Press again to stop
F1::
{
   send, {Media_Play_Pause}
   if listenToSpotify
       listenToSpotify := false
   else
       listenToSpotify := true


   if listenToSpotify
   {
    SetTimer, mute_ads, 1000
   }
   else
   {
    SetTimer, mute_ads, off
    ;If sound is muted, turn back on
            SoundGet, is_mute, , mute
            if is_mute = on
               {
                Send, {Volume_Mute}
               }
   }
return
}

mute_ads: 
;;;; To call this function, use
;;;;SetTimer, mute_ads, 1000
{
   id := WinExist("ahk_exe Spotify.exe")
   WinGetTitle, current_title, % ahk_id %id%
   text := " - "
   IfNotInString, current_title, %text%     ;If there is no - dash sign, means its an AD
      {
         SoundGet, is_mute, , mute
         if is_mute = Off
            {
             Send, {Volume_Mute}
            }
      }

   IfInString, current_title, %text%      ;If there is a - dash sign, means its a song
      {
         SoundGet, is_mute, , mute
         if is_mute = on
            {
             Send, {Volume_Mute}
            }
      }
return
}



 ;;For testing purposes
$F13::
{
id := WinExist("ahk_exe Spotify.exe")
WinGetTitle, Title, % ahk_id %id%
If instr(Title, " - "){
   MsgBox, "%Title%" PLAYING minimized
   }
Else{
   WinGetClass, ActiveClass, A
   If (ActiveClass = "Chrome_WidgetWin_0") {
      WinGetTitle, Title, A
      MsgBox, "%Title%" PLAYING active
      }
   }
return
}