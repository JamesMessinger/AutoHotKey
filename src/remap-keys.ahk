; Map the PrintScreen and ScrollLock keys to volume down and up
PrintScreen::Volume_Down
ScrollLock::Volume_Up

; Map the Puase/Break key to the Play/Pause toggle
Pause::Media_Play_Pause

; Map the AppsKey to the Ctrl key, since there's not a right Ctrl key on the Surface Book
AppsKey::RControl

; Map the AppsKey + "." key to Win+".", which shows the Emoji picker
#if GetKeyState("AppsKey", "P")
  .::Send {RWin Down}{. Down}{. Up}{RWin Up}
#if
