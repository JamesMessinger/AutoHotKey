; ========================================================================
; Utility functions for monitors
; ========================================================================


; Returns detailed information about ALL monitors
GetMonitors()
{
  Monitors := []

  ; Add the primory monitor FIRST
  PrimaryMonitor := GetPrimaryMonitor()
  Monitors.Push(PrimaryMonitor)

  ; Add all other monitors in numeric order
  SysGet, MonitorCount, MonitorCount
  Loop, %MonitorCount%
  {
    MonitorID := A_Index

    If (MonitorID != PrimaryMonitor.ID)
    {
      Monitor := GetMonitor(MonitorID)
      Monitors.Push(Monitor)
    }
  }

  Return Monitors
}



; Returns the system's primary monitor
GetPrimaryMonitor()
{
  SysGet, PrimaryMonitorID, MonitorPrimary
  Monitor := GetMonitor(PrimaryMonitorID)
  Return Monitor
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

  Monitor.Type := IsLaptopMonitor(Monitor) ? "LAPTOP" : GetOrientation(Monitor)

  Log("========== Monitor #" . Monitor.ID . " =========="
    . "`r`nName: " . Monitor.Name
    . "`r`nPrimary: " . (Monitor.IsPrimary ? "yes" : "no")
    . "`r`nType: " . Monitor.Type
    . "`r`nBounds:"
    . "`r`n  Left: " . Monitor.Bounds.Left
    . "`r`n  Right: " . Monitor.Bounds.Right
    . "`r`n  Top: " . Monitor.Bounds.Top
    . "`r`n  Bottom: " . Monitor.Bounds.Bottom
    . "`r`n  Width: " . Monitor.Bounds.Width
    . "`r`n  Height: " . Monitor.Bounds.Height
    . "`r`nWorkArea:"
    . "`r`n  Left: " . Monitor.WorkArea.Left
    . "`r`n  Right: " . Monitor.WorkArea.Right
    . "`r`n  Top: " . Monitor.WorkArea.Top
    . "`r`n  Bottom: " . Monitor.WorkArea.Bottom
    . "`r`n  Width: " . Monitor.WorkArea.Width
    . "`r`n  Height: " . Monitor.WorkArea.Height)

  Return Monitor
}



; Returns the NEXT monitor in the list, or the first monitor
GetNextMonitor(CurrentMonitor, Monitors)
{
  For Index, Monitor In Monitors
  {
    If (Monitor.ID = CurrentMonitor.ID)
    {
      NextMonitor := Monitors[Index + 1]
      If (NextMonitor)
        Return NextMonitor
      Else
        Return Monitors[1]
    }
  }

  Log("!!!!! Unable to determine the next monitor")
  Return Monitors[1]
}



; Returns the monitor that contains the majority of the specified rectangle
GetMonitorByRect(Left, Top, Width, Height, Monitors)
{
  ; Calculate the center point of the rect
  CenterX := Floor(Left + (Width / 2))
  CenterY := Floor(Top + (Height / 2))

  ; Calculate the bottom and right of the rect
  Bottom := Top + Height
  Right := Left + Width

  ; Try to find the monitor that contains the center point.
  ; If that fails, then find the first monitor that contains a corner of the rect
  Points := []
  Points.Push({ X: CenterX, Y: CenterY })
  Points.Push({ X: Left, Y: Top })
  Points.Push({ X: Right, Y: Top })
  Points.Push({ X: Left, Y: Bottom })
  Points.Push({ X: Right, Y: Bottom })

  For Index, Point in Points
  {
    Monitor := GetMonitorForPoint(Point.X, Point.Y, Monitors)
    If (Monitor)
      Return Monitor
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



; Returns the given monitor's orientation
GetOrientation(Monitor)
{
  If (Monitor.Bounds.Height > Monitor.Bounds.Width)
    Return "VERTICAL"
  Else
    Return "HORIZONTAL"
}



; Determines whether the given monitor is the built-in laptop screen
IsLaptopMonitor(Monitor)
{
  If (Monitor.Name = "\\.\DISPLAY1" and GetOrientation(Monitor) = "HORIZONTAL")
    Return True
  Else
    Return False
}



; Returns the Monitor for the built-in laptop screen
FindLaptopMonitor(Monitors)
{
  For Index, Monitor in Monitors
  {
    If (IsLaptopMonitor(Monitor))
    {
      Log("The laptop screen is monitor #" . Monitor.ID
        . " (" . Monitor.Bounds.Width . " x " . Monitor.Bounds.Height . ")")
      Return Monitor
    }
  }

  Log("The laptop screen is closed")
}



; Returns the first horizontal Monitor in the list
FindHorizontalMonitor(Monitors, Exclude := "")
{
  Exclude := Exclude ? Exclude : { ID: "" }

  For Index, Monitor in Monitors
  {
    If (Monitor.ID = Exclude.ID)
      Continue

    If (GetOrientation(Monitor) = "HORIZONTAL")
    {
      Log("The horizontal screen is monitor #" . Monitor.ID
        . " (" . Monitor.Bounds.Width . " x " . Monitor.Bounds.Height . ")")
      Return Monitor
    }
  }

  Log("There is no horizontal monitor connected")
}



; Returns the first vertical monitor in the list
FindVerticalMonitor(Monitors)
{
  For Index, Monitor in Monitors
  {
    If (GetOrientation(Monitor) = "VERTICAL")
    {
      Log("The vertical screen is monitor #" . Monitor.ID
        . " (" . Monitor.Bounds.Width . " x " . Monitor.Bounds.Height . ")")
      Return Monitor
    }
  }

  Log("There is no vertical monitor connected")
}
