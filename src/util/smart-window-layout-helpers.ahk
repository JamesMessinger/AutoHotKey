; ========================================================================
; Helper functions for the "Smart Layout" script
; ========================================================================



; Applies smart layout rules to all windows
SmartLayoutAllWindows(LayoutID)
{
  Try
  {
    ; Start a new log file for this operation
    NewLog()

    Monitors := GetMonitors()
    Windows := GetWindows(Monitors)
    SmartLayouts := GetSmartLayouts(LayoutID, Monitors, Windows)
    Log("Applying " . SmartLayouts.Length() . " smart layouts")

    For Index, SmartLayout In SmartLayouts
      ApplySmartLayout(SmartLayout, Monitors)
  }
  Catch Exception
  {
    ErrorHandler(Exception)
  }
}



; Applies smart layout rules to the active window
SmartLayoutActiveWindow(LayoutID)
{
  Try
  {
    ; Start a new log file for this operation
    NewLog()

    ; Get the active window
    Monitors := GetMonitors()
    Windows := GetWindows(Monitors)
    ActiveWindow := GetActiveWindow(Monitors)

    ; Get the smart layout for all windows
    SmartLayouts := GetSmartLayouts(LayoutID, Monitors, Windows)

    ; Find the active window in the smart layouts
    For LayoutIndex, SmartLayout In SmartLayouts
    {
      For WindowIndex, Window in SmartLayout.Windows
      {
        If (Window.ID = ActiveWindow.ID)
        {
          SmartLayout.Windows := [Window]
          ApplySmartLayout(SmartLayout, Monitors)
          Return
        }
      }
    }

    Log("There is no smart layout for the active window.  Applying default layout.")
    SnapActiveWindow({ Width: 1800, Height: 1400 })
  }
  Catch Exception
  {
    ErrorHandler(Exception)
  }
}



; Applies the given smart layout to all of its windows
ApplySmartLayout(SmartLayout, Monitors)
{
  Layout := SmartLayout.Layout
  IsPercentages := Layout.Top <= 1

  Log("Applying Smart Layout:"
    . "`r`n  Monitor: " . Layout.Monitor.ID . " (" . Layout.Monitor.Bounds.Width . " x " . Layout.Monitor.Bounds.Height . ")"
    . "`r`n  Top: " . Layout.Top
    . "`r`n  Left: " . Layout.Left
    . "`r`n  Width " . Layout.Width
    . "`r`n  Height: " . Layout.Height
    . "`r`n  State: " . Layout.State
    . "`r`n  Cascade: " . (SmartLayout.Cascade ? "yes" : "no"))

  For Index, Window In SmartLayout.Windows
  {
    If (SmartLayout.Cascade and Index > 1)
    {
      Layout.Top := Layout.Top + (IsPercentages ? .1 : 25)
      Layout.Left := Layout.Left + (IsPercentages ? .1 : 25)

      Log("Layout after cascade:"
        . "`r`n  Top: " . Layout.Top
        . "`r`n  Left: " . Layout.Left
        . "`r`n  Width: " . Layout.Width
        . "`r`n  Height: " . Layout.Height)
    }

    SetWindowLayout(Window, Layout, Monitors)
  }
}



; Normalizes the flat array of layouts from `GetSmartLayouts()`.
; The returned array is an array of SmartLayout objects, each of which has a Layout object
; and an array of window objects.
NormalizeSmartLayouts(FlatLayouts)
{
  Log("Got " . FlatLayouts.Length() . " smart layouts")
  Normalized := []

  For LayoutIndex, FlatLayout In FlatLayouts
  {
    SmartLayout := {}
    SmartLayout.Apps := 0
    SmartLayout.Windows := []
    SmartLayout.Cascade := FlatLayout.Cascade
    SmartLayout.Layout := {}
    SmartLayout.Layout.Monitor := FlatLayout.Monitor
    SmartLayout.Layout.Top := FlatLayout.Top
    SmartLayout.Layout.Left := FlatLayout.Left
    SmartLayout.Layout.Width := FlatLayout.Width
    SmartLayout.Layout.Height := FlatLayout.Height
    SmartLayout.Layout.State := FlatLayout.State

    If (SmartLayout.Layout.State = "MAXIMIZED")
    {
      SmartLayout.Layout.Top := 0
      SmartLayout.Layout.Left := 0
      SmartLayout.Layout.Width := 1
      SmartLayout.Layout.Height := 1
    }

    If (IsArrayOfApps(FlatLayout.Windows))
    {
      ; FlatLayout.Windows is an array of apps
      Apps := FlatLayout.Windows
    }
    Else If (IsArray(FlatLayout.Windows))
    {
      ; FlatLayout.Windows is an array of windows
      Apps := [FlatLayout.Windows]
    }
    Else
    {
      ; FlatLayout.Windows is a single window
      Apps := [[FlatLayout.Windows]]
    }

    SmartLayout.Apps := Apps.Length()
    Log("  Smart Layout #" . LayoutIndex . " has " . SmartLayout.Apps . " apps", False)

    For AppIndex, Windows In Apps
    {
      If (!Windows)
        Windows := []

      Log("    App #" . AppIndex . " has " . Windows.Length() . " windows", False)

      For WindowIndex, Window in Windows
      {
        Log("      Window #" . WindowIndex . " is " . WindowToString(Window), False)
        SmartLayout.Windows.Push(Window)
      }
    }

    Normalized.Push(SmartLayout)
  }

  Return Normalized
}


; Determines whether the given array is an array of apps
IsArrayOfApps(Array)
{
  Return IsArray(Array) and (Array[1] = "" or IsArray(Array[1]))
}
