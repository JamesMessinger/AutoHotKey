
; Win+T to toggle a window being always on top
#T::WinSet, AlwaysOnTop, Toggle, A


; SetTimer KeepCertainAppsOnTop, 5000
; Return

; KeepCertainAppsOnTop:
;   AppsToKeepOnTop := ["Microsoft Visual Studio", "Sourcetree", "Slack"]

;   For Index, Item in AppsToKeepOnTop
;   {
;     WinGet, ID, ID, Item
;     WinSet, AlwaysOnTop, , ahk_id %ID%
;   }

;   Return
