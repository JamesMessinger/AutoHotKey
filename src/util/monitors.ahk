; ========================================================================
; Utility functions for monitors
; ========================================================================

; Returns detailed information about ALL monitors
GetMonitors()
{
  Monitors := []

  ; Add the primory monitor FIRST
  SysGet, PrimaryMonitorID, MonitorPrimary
  Monitor := GetMonitor(PrimaryMonitorID)
  Monitors.Push(Monitor)

  ; Add all other monitors in numeric order
  SysGet, MonitorCount, MonitorCount
  Loop, %MonitorCount%
  {
    MonitorID := A_Index

    If (MonitorID != PrimaryMonitorID)
    {
      Monitor := GetMonitor(MonitorID)
      Monitors.Push(Monitor)
    }
  }

  Return Monitors
}



; Returns an object containing detailed information about the specified monitor
GetMonitor(ID)
{
  SysGet, Name, MonitorName, %ID%
  SysGet, Bounds, Monitor, %ID%
  SysGet, WorkArea, MonitorWorkArea, %ID%
  SysGet, PrimaryMonitorID, MonitorPrimary

  Monitor := {}
  Monitor.ID := ID
  Monitor.Name := Name
  Monitor.IsPrimary := (ID = PrimaryMonitorID)

  Monitor.Bounds := {}
  Monitor.Bounds.Left := BoundsLeft
  Monitor.Bounds.Right := BoundsRight
  Monitor.Bounds.Top := BoundsTop
  Monitor.Bounds.Bottom := BoundsBottom
  Monitor.Bounds.Width := BoundsRight - BoundsLeft
  Monitor.Bounds.Height := BoundsBottom - BoundsTop

  Monitor.WorkArea := {}
  Monitor.WorkArea.Left := WorkAreaLeft
  Monitor.WorkArea.Right := WorkAreaRight
  Monitor.WorkArea.Top := WorkAreaTop
  Monitor.WorkArea.Bottom := WorkAreaBottom
  Monitor.WorkArea.Width := WorkAreaRight - WorkAreaLeft
  Monitor.WorkArea.Height := WorkAreaBottom - WorkAreaTop

  Log("========== " . "Monitor #" . Monitor.ID . " ==========`r`n"
    . "Name: " . Monitor.Name . "`r`n"
    . "Primary: " . (Monitor.IsPrimary ? "yes" : "no") . "`r`n"
    . "Bounds:`r`n"
    . "  Left: " . Monitor.Bounds.Left . "`r`n"
    . "  Right: " . Monitor.Bounds.Right . "`r`n"
    . "  Top: " . Monitor.Bounds.Top . "`r`n"
    . "  Bottom: " . Monitor.Bounds.Bottom . "`r`n"
    . "  Width: " . Monitor.Bounds.Width . "`r`n"
    . "  Height: " . Monitor.Bounds.Height . "`r`n"
    . "WorkArea:`r`n"
    . "  Left: " . Monitor.WorkArea.Left . "`r`n"
    . "  Right: " . Monitor.WorkArea.Right . "`r`n"
    . "  Top: " . Monitor.WorkArea.Top . "`r`n"
    . "  Bottom: " . Monitor.WorkArea.Bottom . "`r`n"
    . "  Width: " . Monitor.WorkArea.Width . "`r`n"
    . "  Height: " . Monitor.WorkArea.Height . "`r`n")

  Return Monitor
}



; Returns the monitor that the specified window is on
GetMonitorForWindow(Window, Monitors)
{
  Log("`r`nDetermining the current monitor for window #" . Window.ID)

  ; Calculate the center point of the window
  CenterX := Floor(Window.Left + (Window.Width / 2))
  CenterY := Floor(Window.Top + (Window.Height / 2))

  ; Try to find the monitor that contains the center point.
  ; If that fails, then find the first monitor that contains a corner of the window
  Points := []
  Points.Push({ X: CenterX, Y: CenterY })
  Points.Push({ X: Window.Left, Y: Window.Top })
  Points.Push({ X: Window.Right, Y: Window.Top })
  Points.Push({ X: Window.Left, Y: Window.Bottom })
  Points.Push({ X: Window.Right, Y: Window.Bottom })

  For Index, Point in Points
  {
    Monitor := GetMonitorForPoint(Point.X, Point.Y, Monitors)
    If (Monitor)
    {
      Log("The window is on monitor #" . Monitor.ID)
      Return Monitor
    }
  }

  Log("!!!!! Unable to find the window's monitor")
  Return Monitors[1]
}



; Returns the monitor that contains the specified X, Y point
GetMonitorForPoint(X, Y, Monitors)
{
  For Index, Monitor in Monitors
  {
    If ((X >= Monitor.Bounds.Left) and (Y >= Monitor.Bounds.Top)
    and (X <= Monitor.Bounds.Right) and (Y <= Monitor.Bounds.Bottom))
    {
      Log("Point " . X . ", " . Y . " is on monitor #" . Monitor.ID
        . " (" . Monitor.Bounds.Left . ", " . Monitor.Bounds.Top
        . " to " . Monitor.Bounds.Right . ", " . Monitor.Bounds.Bottom . ")")
      Return Monitor
    }
  }

  Log("No monitor contains the point " . X . ", " . Y)
}



; Returns the NEXT monitor in the list, or the first monitor
GetNextMonitor(CurrentMonitor, Monitors)
{
  If (CurrentMonitor.ID)
    CurrentMonitor := CurrentMonitor.ID

  For Index, Monitor In Monitors
  {
    If (Monitor.ID = CurrentMonitor)
    {
      NextMonitor := Monitors[Index + 1]
      If (NextMonitor)
        Return NextMonitor
      Else
        Return Monitors[1]
    }
  }
}
