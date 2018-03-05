; Win+Alt+0 to save the current window states
#!0::
  SaveWindowStates()
  Return


; Ctrl+Win+0 to restore previously-saved window states
#^0::
  RestoreWindowStates()
  Return



; Saves the current window state for the current monitor configuration
SaveWindowStates()
{
  Try {
    WinCounter := 0
    WinTitles := ""
    File := OpenStateFileForWriting()

    ; Loop through all windows on the entire system
    WinGet, WinIDs, List, , , Program Manager
    Loop, %WinIDs%
    {
      ; Get the window's information
      Window := GetWindowInfo(WinIDs%A_Index%)

      ; Should we save this window's state?
      If IsValidWindowState(Window)
      {
        Line := "ID=" . Window.ID
        Line := Line . ",State=" . Window.State
        Line := Line . ",X=" . Window.X
        Line := Line . ",Y=" . Window.Y
        Line := Line . ",Width=" . Window.Width
        Line := Line . ",Height=" . Window.Height
        Line := Line . ",Title=" . Window.Title
        Line := Line . "`r`n"
        File.Write(line)

        WinCounter := WinCounter + 1
        WinTitles := WinTitles . GetWindowDescription(Window) . "`r`n"
      }
    }

    ; Finish writing the file
    File.Write("`r`n")
    File.Close()

    Info(WinCounter . " windows saved.`r`n`r`n" . WinTitles)
  }
  Catch Exception
  {
    ErrorHandler(Exception)
  }
}



; Restores the previously-saved sizes and positions of all windows
RestoreWindowStates()
{
  Try
  {
    WinCounter := 0
    WinTitles := ""
    FileName := OpenStateFileForReading()

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

    ; Delete the saved state file, since it's no longer needed
    ; UNLESS it's the default file for this monitor setup
    If (!InStr(FileName, ".default"))
      FileDelete, %FileName%

    ; Restore window that was active at beginning of the function
    WinActivate, %SavedActiveWindow%

    Info(WinCounter . " windows restored.`r`n`r`n" . WinTitles)
  }
  Catch Exception
  {
    ErrorHandler(Exception)
  }
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
  Else If InStr(Window.Title, "Sublime Text")
    Description := "Sublime Text"
  Else If InStr(Window.Title, "Slack - ")
    Description := "Slack"
  Else If InStr(Window.Title, "OneNote")
    Description := "OneNote"
  Else If InStr(Window.Title, "Visual Studio Code")
    Description := "Visual Studio Code"
  Else If InStr(Window.Title, "Visual Studio")
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



; Opens the saved window state file for the current monitor configuration
OpenStateFileForWriting()
{
  FileName := GetStateFileBaseName() . ".txt"
  File := FileOpen(FileName, "w")

  If !IsObject(File)
    Throw Exception("Can't open " . FileName . " for writing")

  Return File
}



; Opens the saved window state file for the current monitor configuration.
OpenStateFileForReading()
{
  FileName := GetStateFileBaseName() . ".txt"

  If (!FileExist(FileName))
  {
    ; No window state was saved, so see if there's a default layout we can use instead
    FileName := GetStateFileBaseName() . ".default.txt"

    If (!FileExist(FileName))
      Throw Exception("There is no saved window layout for this monitor setup.`r`n"
        . "Save a layout first.`r`n`r`n"
        . "Looking for:`r`n" . A_ScriptDir . "\" . FileName)
  }

  Return FileName
}



; Returns the name of the window state file for the current monitor configuration
GetStateFileBaseName()
{
  SysGet, MonitorCount, MonitorCount
  Return "WindowLayout." . MonitorCount
}
