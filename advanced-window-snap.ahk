
; ========================================================================
; Horizontal Window Snapping
; ========================================================================

; Win+Alt+Arrow snaps windows to the left/middle/right third
#!Left::SnapActiveWindow("left", "third", "top", "full")
#!Right::SnapActiveWindow("right", "third", "top", "full")
#!Down::SnapActiveWindow("middle", "third", "top", "full")

; Win+Alt+Up snaps window to the middle half
#!Up::SnapActiveWindow("middle", "half", "top", "full")

; Win+Alt+Shift+Arrow snaps widnows to the left/middle/right two-thirds
#+!Left::SnapActiveWindow("left", "two-thirds", "top", "full")
#+!Right::SnapActiveWindow("right", "two-thirds", "top", "full")
#+!Down::SnapActiveWindow("middlet", "two-thirds", "top", "full")
#+!Up::SnapActiveWindow("middle", "two-thirds", "top", "full")



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

; Ctrl+Alt+Shift+Win+Arrow snaps windows to the top/bottom two-thirds
^#+!Up::SnapActiveWindow("left", "full", "top", "two-thirds")
^#+!Down::SnapActiveWindow("left", "full", "bottom", "two-thirds")



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

; Win+Shift+Alt+Numpad snaps windows in two-thirds
#!NumpadHome::SnapActiveWindow("left", "two-thirds", "top", "two-thirds")
#!NumpadUp::SnapActiveWindow("left", "full", "top", "two-thirds")
#!NumpadPgUp::SnapActiveWindow("right", "two-thirds", "top", "two-thirds")
#!NumpadLeft::SnapActiveWindow("left", "two-thirds", "top", "full")
#!NumpadClear::SnapActiveWindow("middle", "two-thirds", "top", "full")
#!NumpadRight::SnapActiveWindow("right", "two-thirds", "top", "full")
#!NumpadEnd::SnapActiveWindow("left", "two-thirds", "bottom", "two-thirds")
#!NumpadDown::SnapActiveWindow("left", "full", "bottom", "two-thirds")
#!NumpadPgDn::SnapActiveWindow("right", "two-thirds", "bottom", "two-thirds")



; Resizes and moves (snaps) the active window to a specified position
SnapActiveWindow(HorizontalAlignment, HorizontalSize, VerticalAlignment, VerticalSize, MonitorNumber := 0)
{
  Try
  {
    ; Get the active window
    WinGet WindowID, ID, A

    ; Determine which monitor the window is currently on
    CurrentMonitor := GetMonitorIndexFromWindow(WindowID)

    ; Determine the target monitor number
    SysGet, MonitorCount, MonitorCount

    If (!MonitorNumber)
      MonitorNumber := CurrentMonitor
    Else If (MonitorNumber > MonitorCount)
      MonitorNumber := 1

    ; Calculate the monitor dimensions
    SysGet, Monitor, MonitorWorkArea, %MonitorNumber%
    MonitorWidth := (MonitorRight - MonitorLeft)
    MonitorHeight := (MonitorBottom - MonitorTop)

    ; Calculate the desired width and height of the window
    Width := CalculateWindowSize(HorizontalSize, MonitorWidth)
    Height := CalculateWindowSize(VerticalSize, MonitorHeight)

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
      Left := (MonitorLeft + (MonitorWidth / 2)) - (Width / 2)
    Else If (HorizontalAlignment = "right")
      Left := MonitorRight - (Width - BorderWidth)
    Else ; "left"
      Left := MonitorLeft - BorderWidth

    If (VerticalAlignment = "middle")
      Top := (MonitorTop + (MonitorHeight / 2)) - ((Height / 2) - (BorderHeight / 2))
    Else If (VerticalAlignment = "bottom")
      Top := MonitorBottom - (Height - BorderHeight)
    Else ; "top"
      Top := MonitorTop

    ; Rounding
    Left := Floor(Left)
    Top := Floor(Top)
    Width := Floor(Width)
    Height := Floor(Height)

    If (MonitorNumber = CurrentMonitor)
    {
      ; If window is already there move to same spot on next monitor
      WinGetPos, CurrentLeft, CurrentTop, CurrentWidth, CurrentHeight, A

      If ((Left = CurrentLeft) and (Top = CurrentTop) and (Width = CurrentWidth) and (Height = CurrentHeight))
      {
        MonitorNumber := MonitorNumber + 1
        SnapActiveWindow(HorizontalAlignment, HorizontalSize, VerticalAlignment, VerticalSize, MonitorNumber)
        Return
      }
    }

    ; Position and resize the window
    WinRestore, A
    WinMove, A, , %Left%, %Top%, %Width%, %Height%

    ; If we changed monitors, then resize AGAIN to account for DPI differences between monitors
    if (MonitorNumber <> CurrentMonitor)
      WinMove, A, , %Left%, %Top%, %Width%, %Height%
  }
  Catch Exception
  {
    ErrorHandler(Exception)
  }
}



/**
 * GetMonitorIndexFromWindow retrieves the HWND (unique ID) of a given window.
 *
 * @author shinywong
 * @link http://www.autohotkey.com/board/topic/69464-how-to-determine-a-window-is-in-which-monitor/?p=440355
 */
GetMonitorIndexFromWindow(WindowHandle)
{
  ; Starts with 1.
  MonitorIndex := 1

  VarSetCapacity(MonitorInfo, 40)
  NumPut(40, MonitorInfo)

  MonitorID := DllCall("MonitorFromWindow", "uint", WindowHandle, "uint", 0x2)
  If (MonitorID > 0)
  {
    DllCall("GetMonitorInfo", "uint", MonitorID, "uint", &MonitorInfo)
    MonitorLeft       := NumGet(MonitorInfo,  4, "Int")
    MonitorTop        := NumGet(MonitorInfo,  8, "Int")
    MonitorRight      := NumGet(MonitorInfo, 12, "Int")
    MonitorBottom     := NumGet(MonitorInfo, 16, "Int")
    WorkspaceLeft     := NumGet(MonitorInfo, 20, "Int")
    WorkspaceTop      := NumGet(MonitorInfo, 24, "Int")
    WorkspaceRight    := NumGet(MonitorInfo, 28, "Int")
    WorkspaceBottom   := NumGet(MonitorInfo, 32, "Int")
    isPrimary         := NumGet(MonitorInfo, 36, "Int") & 1

    SysGet, MonitorCount, MonitorCount

    Loop, %MonitorCount% {
      SysGet, TempMon, Monitor, %A_Index%

      ; Compare location to determine the monitor index.
      If ((MonitorLeft = TempMonLeft) and (MonitorTop = TempMonTop)
          and (MonitorRight = TempMonRight) and (MonitorBottom = TempMonBottom)) {
          MonitorIndex := A_Index
          Break
      }
    }
  }

  return %MonitorIndex%
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
