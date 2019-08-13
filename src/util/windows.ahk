; ========================================================================
; Utility functions for app windows
; ========================================================================


; Returns detailed information about ALL windows
GetWindows(Monitors)
{
  Windows := []

  ; Add the active window FIRST
  ActiveWindow := GetActiveWindow(Monitors)
  Windows.Push(ActiveWindow)

  ; Add all other windows
  WinGet, WinIDs, List, , , Program Manager
  Loop, %WinIDs%
  {
    WindowID := WinIDs%A_Index%

    If (WindowID != ActiveWindow.ID)
    {
      Window := GetWindow(WindowID, Monitors)
      Windows.Push(Window)
    }
  }

  Return Windows
}



; Returns an object containing detailed information about the specified window
GetWindow(ID, Monitors)
{
  WinGetTitle, Title, ahk_id %ID%
  WinGetText, Text, ahk_id %ID%
  WinGetClass, Class, ahk_id %ID%
  WinGet, State, MinMax, ahk_id %ID%
  WinGet, Process, ProcessName, ahk_id %ID%
  WinGet, Transparency, Transparent, ahk_id %ID%
  WinGetPos, Left, Top, Width, Height, ahk_id %ID%

  ; Transparency is 0 (invisible) to 255 (opaque), or blank if not set (i.e. visible)
  Transparency := (Transparency = "" ? 255 : 0)

  Log("`r`nDetermining the current monitor for window #" . ID . " (" . Title . ")")
  Monitor := GetMonitorByRect(Left, Top, Width, Height, Monitors)

  Window := {}
  Window.ID := ID
  Window.Title := Title
  Window.Text := Text
  Window.Class := Class
  Window.Process := Process
  Window.Monitor := Monitor
  Window.Transparency := Transparency
  Window.Width := Width
  Window.Height := Height

  If (Monitor)
  {
    ; Calculate the window's position on its monitor
    Window.Left := Left - Monitor.Bounds.Left
    Window.Top := Top - Monitor.Bounds.Top
  }
  Else
  {
    ; The window is off of the desktop
    Window.Monitor := { ID: "" }
    Window.Left := Left
    Window.Top := Top
  }

  Window.Right := Window.Left + Width
  Window.Bottom := Window.Top + Height

  ; Convert the window's state from a number to a string, for readability
  If (State = -1)
    Window.State := "MINIMIZED"
  Else If (State = 1)
    Window.State := "MAXIMIZED"
  Else
    Window.State := "NORMAL"

  Log("========== Window #" . Window.ID . " ==========`r`n"
    . "Title: " . Window.Title . "`r`n"
    . "Text: " . Window.Text . "`r`n"
    . "Class: " . Window.Class . "`r`n"
    . "Process: " . Window.Process . "`r`n"
    . "State: " . Window.State . "`r`n"
    . "Transparency: " . Window.Transparency . "`r`n"
    . "System Window: " . (IsSystemWindow(Window) ? "yes" : "no") . "`r`n"
    . "Monitor: " . Window.Monitor.ID . "`r`n"
    . "Position:`r`n"
    . "  Left: " . Window.Left . "`r`n"
    . "  Right: " . Window.Right . "`r`n"
    . "  Top: " . Window.Top . "`r`n"
    . "  Bottom: " . Window.Bottom . "`r`n"
    . "  Width: " . Window.Width . "`r`n"
    . "  Height: " . Window.Height . "`r`n")

  Return Window
}



; Returns the currently-active window
GetActiveWindow(Monitors)
{
  WinGet WindowID, ID, A
  Window := GetWindow(WindowID, Monitors)
  Return Window
}



; Returns all windows in the list that match the specified criteria and DO NOT match the exclusion criteria.
; NOTE: If no matches are found, then the return value is null - NOT an empty array.
FindWindows(Windows, InclusionCriteria, ExclusionCriteria := "")
{
  Matches := []

  For Index, Window in Windows
  {
    If (WindowMatches(Window, InclusionCriteria) and !WindowMatches(Window, ExclusionCriteria))
    {
      Matches.Push(Window)
    }
  }

  Log("Found " . Matches.Length() . " windows that match " . WindowCriteriaToString(InclusionCriteria))

  If (Matches.Length() > 0)
    Return Matches
}



; Determines whether the given window matches the specified criteria
WindowMatches(Window, Criteria)
{
  If (Criteria == "")
    Return False

  If (Criteria.HasTitle and StrLen(Window.Title) == 0)
    Return False

  ; Title can be a string or array of strings
  If (Criteria.Title and not WindowTitleMatches(Window, Criteria.Title))
    Return False

  If (Criteria.Class and Window.Class != Criteria.Class)
    Return False

  If (Criteria.Process and Window.Process != Criteria.Process)
    Return False

  Return True
}



; Determines whether the given window matches one of the specified titles
WindowTitleMatches(Window, Titles, CaseSensitive := True)
{
  ; Normalize Titles as an array
  If (!IsArray(Titles))
    Titles := [Titles]

  For Index, Title in Titles
  {
    If (InStr(Window.Title, Title, CaseSensitive) or InStr(Window.Text, Title, CaseSensitive))
      Return True
  }

  Return False
}



; Sets a window's size and position to the specified layout
SetWindowLayout(Window, Layout, Monitors)
{
  Log("`r`nPositioning window #" . Window.ID . ": " . WindowToString(Window))

  ; Calculate the absolute size & position to move the window to
  NewLocation := GetAbsoluteLayout(Window, Layout)

  Log("Current Monitor: " . Window.Monitor.ID
     . "`r`nCurrent Dimensions:"
     . "`r`n  Monitor: " . Window.Monitor.ID
     . "`r`n  Left: " . Window.Left
     . "`r`n  Top: " . Window.Top
     . "`r`n  Width: " . Window.Width
     . "`r`n  Height: " . Window.Height
     . "`r`n  State: " . Window.State
     . "`r`n"
     . "`r`nNew Monitor: " . NewLocation.Monitor.ID
     . "`r`nNew Dimensions:"
     . "`r`n  Monitor: " . NewLocation.Monitor.ID
     . "`r`n  Left: " . NewLocation.Left
     . "`r`n  Top: " . NewLocation.Top
     . "`r`n  Width: " . NewLocation.Width
     . "`r`n  Height: " . NewLocation.Height
     . "`r`n  State: " . NewLocation.State
    . "`r`n")

  ID := "ahk_id " . Window.ID
  Monitor := NewLocation.Monitor
  State := Layout.State
  Width := NewLocation.Width
  Height := NewLocation.Height
  Left := NewLocation.Left
  Top := NewLocation.Top

  If (State = "MAXIMIZED")
  {
    Width := Floor(Width * .5)
    Height := Floor(Height * .75)
    Left := Floor(Monitor.WorkArea.Width * .25)
    Top := Floor(Monitor.WorkArea.Height * .125)

    Log("`r`nThe window will be maximized, but when un-maximized, it will be:"
      . "`r`n  Width: " . Width
      . "`r`n  Height: " . Height
      . "`r`n  Left: " . Left
      . "`r`n  Top: " . Top
      . "`r`n")
  }

  Left := Left + Monitor.Bounds.Left
  Top := Top + Monitor.Bounds.Top


  ; If the window is currently minimized or maximized, then restore it first,
  ; so we can resize and position it
  If (Window.State != "NORMAL")
  {
    WinRestore %ID%
  }

  ; If the window is moving to a new monitor, then we need to resize it TWICE
  ; to account for any change in DPI between the two monitors
  If (Monitor.ID != Window.Monitor.ID)
  {
    Log("The window has been moved to a new monitor. Adjusting for DPI differences")
    WinMove, %ID%, , Left, Top, Width, Height
  }

  If (!ApplyVerticalMonitorHack(Window, ID, Left, Top, Width, Height))
  {
    ; Position and resize the window
    WinMove, %ID%, , Left, Top, Width, Height
  }

  ; Set the window's minimized/maximized state, if necessary
  If (State = "MAXIMIZED")
    WinMaximize, %ID%
  Else If (State = "MINIMIZED")
    WinMinimize, %ID%
  Else
    State := "NORMAL"

  Window.Monitor := Monitor
  Window.Width := Width
  Window.Height := Height
  Window.Left := Left
  Window.Top := Top
  Window.Right := Left + Width
  Window.Bottom := Top + Height
  Window.State := State
}



; Calculates the window's absolute layout on the target monitor
GetAbsoluteLayout(Window, Layout)
{
  global MinimumWindowSize
  Monitor := Layout.Monitor
  Width := Layout.Width
  Height := Layout.Height
  Top := Layout.Top
  Left := Layout.Left

  ; Calculate pixel values from percentages
  If (Height <= 1)
    Height := Floor(Monitor.WorkArea.Height * Height)
  If (Width <= 1)
    Width := Floor(Monitor.WorkArea.Width * Width)
  If (Top <= 1 and Top != "")
    Top := (Monitor.WorkArea.Top - Monitor.Bounds.Top) + Floor(Monitor.WorkArea.Height * Top)
  If (Left <= 1 and Left != "")
    Left := (Monitor.WorkArea.Left - Monitor.Bounds.Left) + Floor(Monitor.WorkArea.Width * Left)

  If (Top = "")
  {
    ; Center the window vertically
    Top := (Monitor.WorkArea.Top - Monitor.Bounds.Top) + Floor((Layout.Monitor.WorkArea.Height - Height) / 2)
  }

  If (Left = "")
  {
    ; Center the window horizontally
    Left := (Monitor.WorkArea.Left - Monitor.Bounds.Left) + Floor((Layout.Monitor.WorkArea.Width - Width) / 2)
  }

  Log("Absolute Layout:" . "`r`n"
    . "  Left: " . Left . "`r`n"
    . "  Top: " . Top . "`r`n"
    . "  Width: " . Width . "`r`n"
    . "  Height: " . Height . "`r`n")

  ; Window borders (Windows 10)
  If (WindowHasBorder(Window))
  {
    SysGet, BorderWidth, 32
    SysGet, BorderHeight, 33
    NewLeft := Left - BorderWidth
    NewWidth := Width + (BorderWidth * 1.5)
    NewHeight := Height + BorderHeight

    Log("`r`nAdjusting for window borders:`r`n"
      . "Left: " . Left . " - " . BorderWidth . " = " . NewLeft . "`r`n"
      . "Width: " . Width . " + " . (BorderWidth * 1.5) . " = " . NewWidth . "`r`n"
      . "Height: " . Height . " + " . BorderHeight . " = " . NewHeight . "`r`n")

    Left := NewLeft
    Width := NewWidth
    Height := NewHeight
  }

  Absolute := {}
  Absolute.Monitor := Monitor
  Absolute.Left := Floor(Left)
  Absolute.Top := Floor(Top)
  Absolute.Width := Floor(Max(Width, MinimumWindowSize))
  Absolute.Height := Floor(Max(Height, MinimumWindowSize))
  Return Absolute
}



; Returns a user-friendly description of the window
WindowToString(Window)
{
  Title := Window.Title
  If IsEmptyString(Title)
    Title := Window.Text

  If WindowMatches(Window, { Process: "Explorer.EXE", Class: "CabinetWClass" })
    Description := "Windows Explorer"
  Else If WindowMatches(Window, { Process: "Spotify.exe", HasTitle: True })
    Description := "Spotify"
  Else If WindowMatches(Window, { Process: "Slack.exe" })
    Description := "Slack"
  Else If WindowMatches(Window, { Title: "Google Chrome" })
    Description := "Chrome (" . SubStr(Title, 1, 20) . ")"
  Else If IsEmptyString(Title)
    Description := Window.Process . ": " . Window.Class
  Else
    Description := StrReplace(Title, "`r`n", " ")

  ; ; Add the window's size
  ; If (Window.State = "MINIMIZED")
  ;   Description := Description . " (Minimized)"
  ; Else If (Window.State = "MAXIMIZED")
  ;   Description := Description . " (Maximized)"
  ; Else If (Window.Transparency = 0)
  ;   Description := Description . " (Transparent)"
  ; Else If (!Window.Monitor)
  ;   Description := Description . " (" . Window.Width . " x " . Window.Height . ")"
  ; Else
  ; {
  ;   Relative := GetRelativeWindowBounds(Window, Window.Monitor)
  ;   Description := Description . " (" . Relative.Width . " x " . Relative.Height . "`)"
  ; }

  Return Description
}



; Returns a user-friendly description of the specified window criteria
WindowCriteriaToString(Criteria)
{
  If (Criteria.Title)
  {
    If (IsArray(Criteria.Title))
      Return Criteria.Title[1]
    Else
      Return Criteria.Title
  }

  If (Criteria.Process)
    Return Criteria.Process

  If (Criteria.Class)
    Return Criteria.Class
}



; Determines whether the specified window has a Windows 10 border,
; which affects its width and height calculations
WindowHasBorder(Window)
{
  WindowsWithoutBorders := ["Microsoft Visual Studio", "Sourcetree", "Slack"]
  CaseSensitive := true

  For Index, Title in WindowsWithoutBorders
  {
    If (InStr(Window.Title, Title, CaseSensitive))
    {
      Log(Title . " does not have window borders")
      Return False
    }
  }

  Log("The window has borders, which affects its height and width calculations")
  Return True
}



; Determines whether the given window is a system window, such as the Desktop or Start Menu
IsSystemWindow(Window)
{
  ; Start Menu and Action Center
  If ((Window.Process = "ShellExperienceHost.exe")
  and ((Window.Title = "Start") or (Window.Title = "Action center")))
  {
    Return True
  }

  ; System tray
  If ((Window.Process = "Explorer.EXE")
  and ((Window.Class = "Shell_TrayWnd") or (Window.Class = "Shell_SecondaryTrayWnd")))
  {
    Return True
  }

  ; Desktop
  If ((Window.Process = "Explorer.EXE")
  and ((Window.Class = "WorkerW") or (Window.Class = "DesktopWallpaperManager")))
  {
    Return True
  }

  ; Windows input method selector
  If ((Window.Process = "Explorer.EXE") and (Window.Class = "EdgeUiInputTopWndClass"))
  {
    Return True
  }

  ; Cortana
  If ((Window.Process = "SearchUI.exe") and (Window.Title = "Cortana"))
  {
    Return True
  }

  ; These are window decorations, such as borders and drop shadows
  If ((Window.Title = "GlassPanelForm") or (Window.Title = "frmDeviceNotify"))
  {
    Return True
  }

  ; Doesn't seem to be a system window
  Return False
}



; HACK: This is a hacky workaround for a weird bug that only happens when docking a window
; to the bottom left of my vertical monitor. For some reason, WinMove adds 468 pixels to the
; window height. I've tried everything I can think of, and can't figure out why. So the only
; workaround I've found is reduce the height by 468 pixels to compensate.
ApplyVerticalMonitorHack(Window, ID, Left, Top, Width, Height)
{
  IsVerticalMonitor := Window.Monitor.Bounds.Height > Window.Monitor.Bounds.Width
  IsDockingToBottom := (Top + Height) >= Window.Monitor.WorkArea.Height
  IsDockingToLeft := Left <= (Window.Monitor.WorkArea.Left + 25)

  If (IsVerticalMonitor and IsDockingToBottom and IsDockingToLeft)
  {
    ; The hack isn't necessary for some windows
    IsException := WindowMatches(Window, { Title: "Sourcetree" })
                or WindowMatches(Window, { Process: "Slack.exe" })

    If (!IsException)
    {
      Log("HACK - The window is being docked to the bottom of a vertical monitor, "
        . "so the height was reduced by 468px to compensate for an AutoHotKey bug")

      WinMove, %ID%, , Left, Top, Width, (Height - 468)
      Return True
    }
  }

  Return False
}
