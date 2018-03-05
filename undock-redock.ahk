; Win+0 to save/restore window states
#0::
  If FileExist(GetFileName("temp"))
    RestoreWindowStates("temp")
  Else
  {
    SaveWindowStates("temp")
    RestoreWindowStates("undocked")
  }
  Return



; Win+Alt+0 to save the current window states
#!0::
  SaveWindowStates("saved")
  Return


; Ctrl+Win+0 to apply a pre-defined layout for different screen setups.
#^0::
  SysGet, Count, MonitorCount

  If (Count = 1)
    RestoreWindowStates("undocked")
  Else
    RestoreWindowStates("docked-" . Count)
  Return



; Saves the current window state so we can undock.  We'll restore this state later when we re-dock
SaveWindowStates(Layout)
{
  WinCounter := 0
  WinTitles := ""
  FileName := GetFileName(Layout)
  File := FileOpen(FileName, "w")

  If !IsObject(File)
  {
    MsgBox, 16, AutoHotKey, Can't open "%FileName%" for writing.
    Return
  }

  ; Loop through all windows on the entire system
  WinGet, WinIDs, List, , , Program Manager
  Loop, %WinIDs%
  {
    ; Get the window's information
    Window := GetWindowInfo(WinIDs%A_Index%)

    ; Should we save this window's state?
    If IsValidWindowState(Window)
    {
      Line := ""

      ; Only save the Window ID for the temporary dock state file.
      ; For all other saved templates, we'll use the window's Title instead.
      If (Layout = "temp")
        Line := "ID=" . Window.ID . ","

      Line := Line . "State=" . Window.State
      Line := Line . ",X=" . Window.X
      Line := Line . ",Y=" . Window.Y
      Line := Line . ",Width=" . Window.Width
      Line := Line . ",Height=" . Window.Height
      Line := Line . ",Title=" . Window.Title
      Line := Line . "`r`n"
      file.Write(line)

      WinCounter := WinCounter + 1
      WinTitles := WinTitles . GetWindowDescription(Window) . "`r`n"
    }
  }

  ; Finish writing the file
  file.write("`r`n")
  file.Close()

  MsgBox, 64, AutoHotKey, %WinCounter% windows saved.`r`n`r`n%WinTitles%`r`nYou may now un-dock your computer

  Return
}



; Restores the previously-saved sizes and positions of all windows
RestoreWindowStates(Layout)
{
  WinCounter := 0
  WinTitles := ""
  FileName := GetFileName(Layout)

  If (!FileExist(FileName))
  {
    MsgBox, 16, AutoHotKey, There is no saved window layout for this monitor setup.`r`nSave a layout first.`r`n`r`nLooking for:`r`n%A_ScriptDir%\%FileName%
    Return
  }

  WinGetActiveTitle, SavedActiveWindow

  ; Read each line of the file
  Loop, Read, %FileName%
  {
    Window := {}

    ; Parse each comma-delimited setting
    Loop, Parse, A_LoopReadLine, CSV
    {
      ; Parse the setting key and value
      EqualPos := InStr(A_LoopField, "=")

      If (EqualPos > 1)
      {
        Key := SubStr(A_LoopField, 1, EqualPos - 1)
        Value := SubStr(A_LoopField, EqualPos + 1)

        ; Set the properties of the window object
        Window[Key] := Value
      }
    }

    ; Restore the window's state, if it exists
    If (RestoreWindowState(Window))
    {
      WinCounter := WinCounter + 1
      WinTitles := WinTitles . GetWindowDescription(Window) . "`r`n"
    }
  }

  ; Delete the temporary dock state file, since it's no longer needed
  If (Layout = "temp")
    FileDelete, %FileName%

  ; Restore window that was active at beginning of the function
  WinActivate, %SavedActiveWindow%

  MsgBox, 64, AutoHotKey, %WinCounter% windows restored.`r`n`r`n%WinTitles%

  Return
}



; Restores the state of ONE OR MORE windows, either by ID or by Title
RestoreWindowState(Window)
{
  RestoredCount := 0

  If (Window.ID)
  {
    ; Restore this specific window by ID
    RestoredCount := SetWindowState(Window)
  }
  Else
  {
    ; Restore all windows with matching titles
    WinTitle := Window.Title
    WinGet, WinIDs, List, %WinTitle%

    Loop, %WinIDs%
    {
      Window.ID := WinIDs%A_Index%
      RestoredCount := RestoredCount + SetWindowState(Window)
    }
  }

  Return RestoredCount
}



; Restores the state of a SINGLE window by its ID
SetWindowState(Window)
{
  WinTitle := "ahk_id " . Window.ID

  If WinExist(WinTitle) and IsValidWindowState(Window)
  {
    WinRestore %WinTitle%
    WinMove, %WinTitle%, , Window.X, Window.Y

    If (Window.State = "MAXIMIZED")
      WinMaximize, %WinTitle%
    Else If (Window.State = "MINIMIZED")
      WinMinimize, %WinTitle%
    Else
      WinMove, %WinTitle%, , Window.X, Window.Y, Window.Width, Window.Height

    Return 1    ; One window restored
  }
  Else
  {
    Return 0    ; No windows restored
  }
}



; Returns an object containing detailed information about the specified window
GetWindowInfo(ID)
{
  WinGetTitle, Title, ahk_id %ID%
  WinGetClass, Class, ahk_id %ID%
  WinGet, State, MinMax, ahk_id %ID%
  WinGet, ProcessName, ProcessName, ahk_id %ID%
  WinGet, Transparency, Transparent, ahk_id %ID%
  WinGetPos, X, Y, Width, Height, ahk_id %ID%

  ; Convert the window's state from a number to a string, for readability
  If (State = -1)
    State := "MINIMIZED"
  Else If (State = 1)
    State := "MAXIMIZED"
  Else
    State := "NORMAL"

  Return { ID: ID
    , Title: Title
    , Class: Class
    , ProcessName: ProcessName
    , X: X
    , Y: Y
    , Width: Width
    , Height: Height
    , State: State
    , Transparency: Transparency }
}



; Returns a user-friendly description of the window
GetWindowDescription(Window)
{
  Description := Window.Title
  If IsEmptyString(Window.Title)
    Description := Window.ProcessName . ": " . Window.Class
  Else If Instr(Window.Title, "Sublime Text")
    Description := "Sublime Text"
  Else If InStr(Window.Title, "Slack - ")
    Description := "Slack"
  Else If Instr(Window.Title, "OneNote")
    Description := "OneNote"
  Else If Instr(Window.Title, "Visual Studio Code")
    Description := "Visual Studio Code"
  Else If Instr(Window.Title, "Visual Studio")
    Description := "Visual Studio"

  ; Convert the window's state from a number to a string, for readability
  If (Window.State = "MINIMIZED")
    Description := Description . " (Minimized)"
  Else If (Window.State = "MAXIMIZED")
    Description := Description . " (Maximized)"
  Else If (Window.Transparency = 0)
    Description := Description . " (Transparent)"
  Else
    Description := Description . " (" . Window.Width . " x " . Window.Height . ")"

  Return Description
}



; Determines whether the given window's state is valid and should be saved/restored
IsValidWindowState(Window)
{
  ; Don't save windows with no title or zero width/height
  If (StrLen(Window.Title) = 0) or (Window.Width <= 0) and (Window.Height <= 0)
    Return False

  ; Don't save transparent windows
  If (Window.Transparency = 0)
    Return False

  If (Window.Title = "Start") or (Window.Title = "GlassPanelForm") or (Window.Title = "frmDeviceNotify")
  {
    Return False
  }

  Return True
}



; Returns the name of the file where the specified layout has been saved
GetFileName(Layout)
{
  Return StrReplace(A_ScriptName, ".ahk", "") . "." . Layout . ".txt"
}



; Determines whether the given string is empty or entirely whitespace
IsEmptyString(String)
{
  Return RegExMatch(String, "^ *$")
}
