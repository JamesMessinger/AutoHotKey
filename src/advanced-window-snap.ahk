; ========================================================================
; Horizontal Window Snapping
; ========================================================================

; Win+Alt+Arrow snaps windows to the left/middle/right third
#!Left::SnapActiveWindow("left", "third", "top", "full")
#!Right::SnapActiveWindow("right", "third", "top", "full")
#!Down::SnapActiveWindow("middle", "third", "top", "full")

; Win+Alt+Up snaps window to the middle half
#!Up::SnapActiveWindow("middle", "half", "top", "full")

; Win+Shift+Arrow snaps widnows to the left/middle/right two-thirds
#+Left::SnapActiveWindow("left", "two-thirds", "top", "full")
#+Right::SnapActiveWindow("right", "two-thirds", "top", "full")
#+Down::SnapActiveWindow("middle", "two-thirds", "top", "full")
#+Up::SnapActiveWindow("middle", "two-thirds", "top", "full")



; ========================================================================
; Vertical Window Snapping
; ========================================================================

; Ctrl+Win+Arrow snaps windows to the top/middle/bottom half
^#Up::SnapActiveWindow("left", "full", "top", "half")
^#Down::SnapActiveWindow("left", "full", "bottom", "half")
^#Left::SnapActiveWindow("left", "full", "middle", "half")
^#Right::SnapActiveWindow("left", "full", "middle", "half")

; Ctrl+Alt+Win+Arrow snaps windows to the top/middle/bottom third
^#!Up::SnapActiveWindow("left", "full", "top", "third")
^#!Down::SnapActiveWindow("left", "full", "bottom", "third")
^#!Left::SnapActiveWindow("left", "full", "middle", "third")
^#!Right::SnapActiveWindow("left", "full", "middle", "third")

; Ctrl+Shift+Win+Arrow snaps windows to the top/bottom two-thirds
^#+Up::SnapActiveWindow("left", "full", "top", "two-thirds")
^#+Down::SnapActiveWindow("left", "full", "bottom", "two-thirds")
^#+Left::SnapActiveWindow("left", "full", "middle", "two-thirds")
^#+Right::SnapActiveWindow("left", "full", "middle", "two-thirds")



; ========================================================================
; Horizontal & Vertical Window Centering
; ========================================================================
#Enter::SnapActiveWindow("middle", "center-big", "middle", "center-big")
F24 & Enter::SnapActiveWindow("middle", "center-big", "middle", "center-big")
#!Enter::SnapActiveWindow("middle", "center-small", "middle", "center-small")



; ========================================================================
; Nuber Pad Window Snapping
; ========================================================================

; Win+Numpad snaps windows in halves
#Numpad7::SnapActiveWindow("left", "half", "top", "half")
#Numpad8::SnapActiveWindow("left", "full", "top", "half")
#Numpad9::SnapActiveWindow("right", "half", "top", "half")
#Numpad4::SnapActiveWindow("left", "half", "top", "full")
#Numpad5::SnapActiveWindow("middle", "half", "middle", "full")
#Numpad6::SnapActiveWindow("right", "half", "top", "full")
#Numpad1::SnapActiveWindow("left", "half", "bottom", "half")
#Numpad2::SnapActiveWindow("left", "full", "bottom", "half")
#Numpad3::SnapActiveWindow("right", "half", "bottom", "half")

; Win+Alt+Numpad snaps windows in thirds
#!Numpad7::SnapActiveWindow("left", "third", "top", "third")
#!Numpad8::SnapActiveWindow("left", "full", "top", "third")
#!Numpad9::SnapActiveWindow("right", "third", "top", "third")
#!Numpad4::SnapActiveWindow("left", "third", "top", "full")
#!Numpad5::SnapActiveWindow("middle", "third", "top", "full")
#!Numpad6::SnapActiveWindow("right", "third", "top", "full")
#!Numpad1::SnapActiveWindow("left", "third", "bottom", "third")
#!Numpad2::SnapActiveWindow("left", "full", "bottom", "third")
#!Numpad3::SnapActiveWindow("right", "third", "bottom", "third")

; Win+Shift+Numpad snaps windows in two-thirds
#NumpadHome::SnapActiveWindow("left", "two-thirds", "top", "two-thirds")
#NumpadUp::SnapActiveWindow("left", "full", "top", "two-thirds")
#NumpadPgUp::SnapActiveWindow("right", "two-thirds", "top", "two-thirds")
#NumpadLeft::SnapActiveWindow("left", "two-thirds", "top", "full")
#NumpadClear::SnapActiveWindow("middle", "two-thirds", "top", "full")
#NumpadRight::SnapActiveWindow("right", "two-thirds", "top", "full")
#NumpadEnd::SnapActiveWindow("left", "two-thirds", "bottom", "two-thirds")
#NumpadDown::SnapActiveWindow("left", "full", "bottom", "two-thirds")
#NumpadPgDn::SnapActiveWindow("right", "two-thirds", "bottom", "two-thirds")



; Resizes and moves (snaps) the active window to the specified position
SnapActiveWindow(HorizontalAlignment, HorizontalSize, VerticalAlignment, VerticalSize)
{
  Try
  {
    Log("Snapping active window to " . HorizontalAlignment . " " . HorizontalSize . ", " . VerticalAlignment . " " . VerticalSize)

    ; Get the active window
    WinGet WindowID, ID, A
    Window := GetWindow(WindowID)

    ; Don't snap system windows, such as the Desktop or Start Menu
    If IsSystemWindow(Window) {
      Return
    }

    ; Get all Monitors, and determine which one the window is currently on
    Monitors := GetMonitors()

    SnapWindow(Window, Monitors, 0, HorizontalAlignment, HorizontalSize, VerticalAlignment, VerticalSize)
  }
  Catch Exception
  {
    ErrorHandler(Exception)
  }
}



; Resizes and moves (snaps) the given window to the specified position
SnapWindow(Window, Monitors, TargetMonitor, HorizontalAlignment, HorizontalSize, VerticalAlignment, VerticalSize)
{
  Log("Snapping window: " . GetWindowDescription(Window))

  ; Determine which monitor the window is currently on
  Window.Monitor := GetMonitorForWindow(Window, Monitors)

  ; Determine the target monitor
  If (!TargetMonitor)
    TargetMonitor := Window.Monitor

  ; Calculate the desired width and height of the window
  global MinimumWindowSize
  Width := Max(CalculateWindowSize(HorizontalSize, TargetMonitor.WorkArea.Width), MinimumWindowSize)
  Height := Max(CalculateWindowSize(VerticalSize, TargetMonitor.WorkArea.Height), MinimumWindowSize)

  ; Borders (Windows 10)
  SysGet, BorderWidth, 32
  SysGet, BorderHeight, 33
  If (BorderWidth) {
    Width := Width + (BorderWidth * 2)
  }
  If (BorderHeight) {
    Height := Height + BorderHeight
  }

  ; Calculate the desired top and left positions
  If (HorizontalAlignment = "middle")
    Left := (TargetMonitor.WorkArea.Left + (TargetMonitor.WorkArea.Width / 2)) - (Width / 2)
  Else If (HorizontalAlignment = "right")
    Left := TargetMonitor.WorkArea.Right - (Width - BorderWidth)
  Else ; "left"
    Left := TargetMonitor.WorkArea.Left - BorderWidth

  If (VerticalAlignment = "middle")
    Top := (TargetMonitor.WorkArea.Top + (TargetMonitor.WorkArea.Height / 2)) - ((Height / 2) - (BorderHeight / 2))
  Else If (VerticalAlignment = "bottom")
    Top := TargetMonitor.WorkArea.Bottom - (Height - BorderHeight)
  Else ; "top"
    Top := TargetMonitor.WorkArea.Top

  ; Rounding
  Left := Floor(Left)
  Top := Floor(Top)
  Width := Floor(Width)
  Height := Floor(Height)

  Log("Current Monitor: " . Window.Monitor.ID . "`r`n"
    . "Current Dimensions:" . "`r`n"
    . "  Left: " . Window.Left . "`r`n"
    . "  Top: " . Window.Top . "`r`n"
    . "  Width: " . Window.Width . "`r`n"
    . "  Height: " . Window.Height . "`r`n"
    . "`r`n"
    . "New Monitor: " . TargetMonitor.ID . "`r`n"
    . "New Dimensions:" . "`r`n"
    . "  Left: " . Left . "`r`n"
    . "  Top: " . Top . "`r`n"
    . "  Width: " . Width . "`r`n"
    . "  Height: " . Height . "`r`n")

  If (TargetMonitor.ID = Window.Monitor.ID)
  {
    ; The window is already on the right monitor.  Is it also already in the right spot?
    WinGetPos, CurrentLeft, CurrentTop, CurrentWidth, CurrentHeight, A
    If (IsNear(Left, CurrentLeft) and IsNear(Top, CurrentTop) and IsNear(Width, CurrentWidth) and IsNear(Height, CurrentHeight))
    {
      ; Move the window to the same spot on the next monitor
      TargetMonitor := GetNextMonitor(TargetMonitor, Monitors)
      SnapWindow(Window, Monitors, TargetMonitor, HorizontalAlignment, HorizontalSize, VerticalAlignment, VerticalSize)
      Return
    }
  }

  ; Position and resize the window
  WinRestore, A
  WinMove, A, , %Left%, %Top%, %Width%, %Height%

  ; If we changed monitors, then resize AGAIN to account for DPI differences between monitors
  if (TargetMonitor.ID <> Window.Monitor.ID)
    WinMove, A, , %Left%, %Top%, %Width%, %Height%
}



; Calculates the desired window size from the available size, using measurements like "half", "two-thirds", "full", etc.
CalculateWindowSize(Size, AvailableSize)
{
  If (Size = "half")
    Return AvailableSize / 2
  Else If (Size = "third")
    Return AvailableSize / 3
  Else If (Size = "two-thirds")
    Return (AvailableSize / 3) * 2
  Else If (Size = "center-big") and (AvailableSize > 3000)
    Return AvailableSize * .5
  Else If (Size = "center-big")
    Return AvailableSize * .8
  Else If (Size = "center-small") and (AvailableSize > 3000)
    Return AvailableSize * .3
  Else If (Size = "center-small")
    Return AvailableSize * .5
  Else ; "full"
    Return AvailableSize
}



; Determines whether two position values (height, width, top, or left) are near each other,
; within a few pixels
IsNear(x, y)
{
  Tolerance := 25

  If ((x >= y) and (x - y < Tolerance))
  {
    Return True
  }
  Else If ((y > x) and (y - x < Tolerance))
  {
    Return True
  }
  Else
  {
    Return False
  }
}


