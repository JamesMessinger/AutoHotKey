; ========================================================================
; Utility functions for app windows
; ========================================================================


; Returns detailed information about ALL windows
GetWindows()
{
  Windows := []

  ; Add the active window FIRST
  WinGet ActiveWindowID, ID, A
  Window := GetWindow(ActiveWindowID)
  Windows.Push(Window)

  ; Add all other windows
  WinGet, WinIDs, List, , , Program Manager
  Loop, %WinIDs%
  {
    WindowID := WinIDs%A_Index%

    If (WindowID != ActiveWindowID)
    {
      Window := GetWindow(WindowID)
      Windows.Push(Window)
    }
  }

  Return Windows
}



; Returns all windows that match the specified title
GetWindowsByTitle(Title)
{
  Windows := []

  WinGet, WinIDs, List, %Title%

  If (WinIDs = 0)
    Log("!!!!! No windows match the title: " . Title)
  Else
  {
    Log(WinIDs . " windows match title: " . Title)

    Loop, %WinIDs%
    {
      Window := GetWindow(WinIDs%A_Index%)
      Windows.Push(Window)
    }
  }

  Return Windows
}



; Returns an object containing detailed information about the specified window
GetWindow(ID)
{
  WinGetTitle, Title, ahk_id %ID%
  WinGetClass, Class, ahk_id %ID%
  WinGet, State, MinMax, ahk_id %ID%
  WinGet, Process, ProcessName, ahk_id %ID%
  WinGet, Transparency, Transparent, ahk_id %ID%
  WinGetPos, Left, Top, Width, Height, ahk_id %ID%

  Window := {}
  Window.ID := ID
  Window.Title := Title
  Window.Class := Class
  Window.Process := Process
  Window.Left := Left
  Window.Right := Left + Width
  Window.Top := Top
  Window.Bottom := Top + Height
  Window.Width := Width
  Window.Height := Height

  ; Transparency is 0 (invisible) to 255 (opaque), or blank if not set (i.e. visible)
  Window.Transparency := (Transparency = "" ? 255 : 0)

  ; Convert the window's state from a number to a string, for readability
  If (State = -1)
    Window.State := "MINIMIZED"
  Else If (State = 1)
    Window.State := "MAXIMIZED"
  Else
    Window.State := "NORMAL"

  Log("========== " . "Window #" . Window.ID . " ==========`r`n"
    . "Title: " . Window.Title . "`r`n"
    . "Class: " . Window.Class . "`r`n"
    . "Process: " . Window.Process . "`r`n"
    . "State: " . Window.State . "`r`n"
    . "Transparency: " . Window.Transparency . "`r`n"
    . "System Window: " . (IsSystemWindow(Window) ? "yes" : "no") . "`r`n"
    . "Bounds:`r`n"
    . "  Left: " . Window.Left . "`r`n"
    . "  Right: " . Window.Right . "`r`n"
    . "  Top: " . Window.Top . "`r`n"
    . "  Bottom: " . Window.Bottom . "`r`n"
    . "  Width: " . Window.Width . "`r`n"
    . "  Height: " . Window.Height . "`r`n")

  Return Window
}



; Returns a user-friendly description of the window
GetWindowDescription(Window)
{
  Description := Window.Title
  If IsEmptyString(Window.Title)
    Description := Window.Process . ": " . Window.Class
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
  Else If InStr(Window.Title, "Google Chrome")
    Description := "Chrome (" . SubStr(Window.Title, 1, 20) . ")"

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
  ;   Description := Description . " (" . Relative.Width . "% x " . Relative.Height . "%)"
  ; }

  Return Description
}



; Calculates the window's bounds (top, left, width, height, etc.), relative to the monitor
GetRelativeWindowBounds(Window, Monitor)
{
  global MinimumWindowSize

  Width := Max(Window.Width, MinimumWindowSize)
  Height := Max(Window.Height, MinimumWindowSize)
  Left := Window.Left - Monitor.Bounds.Left
  Top := Window.Top - Monitor.Bounds.Top

  Relative := {}
  Relative.Left := Percentage(Left, Monitor.WorkArea.Width)
  Relative.Right := Percentage(Left + Width, Monitor.WorkArea.Width)
  Relative.Top := Percentage(Top, Monitor.WorkArea.Height)
  Relative.Bottom := Percentage(Top + Height, Monitor.WorkArea.Height)
  Relative.Width := Percentage(Width, Monitor.WorkArea.Width)
  Relative.Height := Percentage(Height, Monitor.WorkArea.Height)

  Return Relative
}



; Calculates the window's absolute bounds (top, left, width, height, etc.),
; given an absolute or percentage layout
GetAbsoluteWindowBounds(Window, Layout, Monitors)
{
  global MinimumWindowSize

  ; Determine which monitor the window is currently on
  If (!Window.Monitor)
    Window.Monitor := GetMonitorForWindow(Window, Monitors)

  ; Determine the new monitor
  If (Layout.Monitor > 0)
    Monitor := FindByID(Monitors, Layout.Monitor)
  Else
    Monitor := Window.Monitor

  If (Layout.Height > 100 and Layout.Width > 100)
  {
    If (Monitor.ID != Window.Monitor)
    {
      ; Use the layout's absolute dimensions, but adjust the position to the new monitor
      ; Log("BEFORE =================>>> "
      ; . Layout.Width . " x " . Layout.Height . " at "
      ; . Layout.Left . ", " . Layout.Top . " on monitor #" . Window.Monitor.ID)

      ; The layout has absolute dimensions, so convert them to percentages
      ; of the window's CURRENT monitor
      Width := Layout.Width
      Height := Layout.Height

      CenterY := (Layout.Top + (Layout.Height / 2)) - Window.Monitor.WorkArea.Top
      CenterY := Percentage(CenterY, Window.Monitor.WorkArea.Height)
      Top := Monitor.WorkArea.Top + (PercentageOf(CenterY, Monitor.WorkArea.Height) - (Height / 2))

      CenterX := (Layout.Left + (Layout.Width / 2)) - Window.Monitor.WorkArea.Left
      CenterX := Percentage(CenterX, Window.Monitor.WorkArea.Width)
      Left := Monitor.WorkArea.Left + (PercentageOf(CenterX, Monitor.WorkArea.Width) - (Width / 2))

      ; Log("AFTER =================>>> "
      ; . Width . " x " . Height . " at " . Left . ", " . Top)
    }
  }
  Else
  {
    ; Calculate the window postion on the monitor
    Left := Monitor.Bounds.Left + PercentageOf(Layout.Left, Monitor.WorkArea.Width)
    Top := Monitor.Bounds.Top + PercentageOf(Layout.Top, Monitor.WorkArea.Height)

    ; Calculate the window size on this monitor
    Width := PercentageOf(Layout.Width, Monitor.WorkArea.Width)
    Height := PercentageOf(Layout.Height, Monitor.WorkArea.Height)

    ; Window borders (Windows 10)
    If (WindowHasBorder(Window))
    {
      SysGet, BorderWidth, 32
      SysGet, BorderHeight, 33
      NewLeft := Floor(Left - BorderWidth)
      NewWidth := Floor(Width + (BorderWidth * 1.5))
      NewHeight := Floor(Height + BorderHeight)

      Log("Adjusting for window borders:`r`n"
        . "Left: " . Floor(Left) . " - " . BorderWidth . " = " . NewLeft . "`r`n"
        . "Width: " . Floor(Width) . " + " . (BorderWidth * 1.5) . " = " . NewWidth . "`r`n"
        . "Height: " . Floor(Height) . " + " . BorderHeight . " = " . NewHeight . "`r`n")

      Left := NewLeft
      Width := NewWidth
      Height := NewHeight
    }
  }

  Absolute := {}
  Absolute.Monitor := Monitor.ID
  Absolute.Left := Floor(Left)
  Absolute.Top := Floor(Top)
  Absolute.Width := Floor(Max(Width, MinimumWindowSize))
  Absolute.Height := Floor(Max(Height, MinimumWindowSize))
  Return Absolute
}



; Sets a window's size and position to the specified layout
SetWindowLayout(Window, Layout, Monitors)
{
  Log("`r`nRestoring window #" . Window.ID . ": " . GetWindowDescription(Window))

  ; Calculate the absolute size & position to move the window to
  NewLocation := GetAbsoluteWindowBounds(Window, Layout, Monitors)

  Log("Current Monitor: " . Window.Monitor.ID . "`r`n"
    . "Current Dimensions:" . "`r`n"
    . "  Left: " . Window.Left . "`r`n"
    . "  Top: " . Window.Top . "`r`n"
    . "  Width: " . Window.Width . "`r`n"
    . "  Height: " . Window.Height . "`r`n"
    . "`r`n"
    . "New Monitor: " . NewLocation.Monitor . "`r`n"
    . "New Dimensions:" . "`r`n"
    . "  Left: " . NewLocation.Left . "`r`n"
    . "  Top: " . NewLocation.Top . "`r`n"
    . "  Width: " . NewLocation.Width . "`r`n"
    . "  Height: " . NewLocation.Height . "`r`n")

  ; Restore the window position
  Title := "ahk_id " . Window.ID

  ; If the window is currently minimized or maximized, then restore it first,
  ; so we can resize and position it
  If (Window.State != "NORMAL")
  {
    WinRestore %Title%
  }

  ; If the window is moving to a new monitor, then we need to resize it TWICE
  ; to account for any change in DPI between the two monitors
  If (NewLocation.Monitor != Window.Monitor.ID)
  {
    Log("The window has been moved to a new monitor. Adjusting for DPI differences")
    WinMove, %Title%, , NewLocation.Left, NewLocation.Top, NewLocation.Width, NewLocation.Height
    Window.Monitor := FindByID(Monitors, NewLocation.Monitor)
  }

  IsVerticalMonitor := Window.Monitor.WorkArea.Height > Window.Monitor.WorkArea.Width
  IsDockingToBottom := (NewLocation.Top + NewLocation.Height) >= Window.Monitor.WorkArea.Height
  IsDockingToLeft := NewLocation.Left <= (Window.Monitor.WorkArea.Left + 25)

  If (IsVerticalMonitor and IsDockingToBottom and IsDockingToLeft)
  {
    ; HACK: This is a hacky workaround for a weird bug that only happens when docking a window
    ; to the bottom left of my vertical monitor. For some reason, WinMove adds 468 pixels to the
    ; window height. I've tried everything I can think of, and can't figure out why. So the only
    ; workaround I've found is reduce the height by 468 pixels to compensate.
    Log("HACK - The window is being docked to the bottom of a vertical monitor, "
      . "so the height was reduced by 468px to compensate for an AutoHotKey bug")

    WinMove, %Title%, , NewLocation.Left, NewLocation.Top, NewLocation.Width, (NewLocation.Height - 468)
  }
  Else
  {
    ; Position and resize the window
    WinMove, %Title%, , NewLocation.Left, NewLocation.Top, NewLocation.Width, NewLocation.Height
  }

  ; Set the window's minimized/maximized state, if necessary
  If (Layout.State = "MAXIMIZED")
    WinMaximize, %Title%
  Else If (Layout.State = "MINIMIZED")
    WinMinimize, %Title%
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



; Determines whether the specified window has a Windows 10 border,
; which affects its width and height calculations
WindowHasBorder(Window)
{
  WindowsWithoutBorders := ["Microsoft Visual Studio", "Sourcetree", "Slack"]

  For Index, Title in WindowsWithoutBorders
  {
    If (InStr(Window.Title, Title))
    {
      Log(Title . " does not have window borders")
      Return False
    }
  }

  Log("The window has borders, which affects its height and width calculations")
  Return True
}
