; ========================================================================
; Horizontal Window Snapping
; ========================================================================

; Win+Alt+Arrow snaps windows to the left/middle/right third
#!Left::SnapActiveWindow({ Left: 0, Top: 0, Width: 33, Height: 100 })
#!Right::SnapActiveWindow({ Left: 67, Top: 0, Width: 33, Height: 100 })
#!Down::SnapActiveWindow({ Left: 33, Top: 0, Width: 34, Height: 100 })

; Win+Alt+Up snaps window to the middle half
#!Up::SnapActiveWindow({ Left: 25, Top: 0, Width: 50, Height: 100 })

; Win+Shift+Arrow snaps widnows to the left/middle/right two-thirds
#+Left::SnapActiveWindow({ Left: 0, Top: 0, Width: 67, Height: 100 })
#+Right::SnapActiveWindow({ Left: 33, Top: 0, Width: 67, Height: 100 })
#+Down::SnapActiveWindow({ Left: 16, Top: 0, Width: 67, Height: 100 })
#+Up::SnapActiveWindow({ Left: 16, Top: 0, Width: 67, Height: 100 })



; ========================================================================
; Vertical Window Snapping
; ========================================================================

; Ctrl+Win+Arrow snaps windows to the top/middle/bottom half
^#Up::SnapActiveWindow({ Left: 0, Top: 0, Width: 100, Height: 50 })
^#Down::SnapActiveWindow({ Left: 0, Top: 50, Width: 100, Height: 50 })
^#Left::SnapActiveWindow({ Left: 0, Top: 25, Width: 100, Height: 50 })
^#Right::SnapActiveWindow({ Left: 0, Top: 25, Width: 100, Height: 50 })

; Ctrl+Alt+Win+Arrow snaps windows to the top/middle/bottom third
^#!Up::SnapActiveWindow({ Left: 0, Top: 0, Width: 100, Height: 33 })
^#!Down::SnapActiveWindow({ Left: 0, Top: 67, Width: 100, Height: 33 })
^#!Left::SnapActiveWindow({ Left: 0, Top: 33, Width: 100, Height: 34 })
^#!Right::SnapActiveWindow({ Left: 0, Top: 33, Width: 100, Height: 34 })

; Ctrl+Shift+Win+Arrow snaps windows to the top/bottom two-thirds
^#+Up::SnapActiveWindow({ Left: 0, Top: 0, Width: 100, Height: 67 })
^#+Down::SnapActiveWindow({ Left: 0, Top: 33, Width: 100, Height: 67 })
^#+Left::SnapActiveWindow({ Left: 0, Top: 16, Width: 100, Height: 67 })
^#+Right::SnapActiveWindow({ Left: 0, Top: 16, Width: 100, Height: 67 })



; ========================================================================
; Horizontal & Vertical Window Centering
; ========================================================================

; Win+Enter centers the window, large
#Enter::SnapActiveWindow({ Left: 25, Top: 10, Width: 50, Height: 80 })
F24 & Enter::SnapActiveWindow({ Left: 25, Top: 10, Width: 50, Height: 80 })

; Win+Alt+Enter centers the window, small
#!Enter::SnapActiveWindow({ Left: 35, Top: 25, Width: 30, Height: 50 })



; ========================================================================
; Nuber Pad Window Snapping
; ========================================================================

; Win+Numpad snaps windows in halves
#Numpad7::SnapActiveWindow({ Left: 0, Top: 0, Width: 50, Height: 50 })
#Numpad8::SnapActiveWindow({ Left: 0, Top: 0, Width: 100, Height: 50 })
#Numpad9::SnapActiveWindow({ Left: 50, Top: 0, Width: 50, Height: 50 })
#Numpad4::SnapActiveWindow({ Left: 0, Top: 0, Width: 50, Height: 100 })
#Numpad5::SnapActiveWindow({ Left: 25, Top: 0, Width: 50, Height: 100 })
#Numpad6::SnapActiveWindow({ Left: 50, Top: 0, Width: 50, Height: 100 })
#Numpad1::SnapActiveWindow({ Left: 0, Top: 50, Width: 50, Height: 50 })
#Numpad2::SnapActiveWindow({ Left: 0, Top: 50, Width: 100, Height: 50 })
#Numpad3::SnapActiveWindow({ Left: 50, Top: 50, Width: 50, Height: 50 })

; Win+Alt+Numpad snaps windows in thirds
#!Numpad7::SnapActiveWindow({ Left: 0, Top: 0, Width: 33, Height: 33 })
#!Numpad8::SnapActiveWindow({ Left: 0, Top: 0, Width: 100, Height: 33 })
#!Numpad9::SnapActiveWindow({ Left: 67, Top: 0, Width: 33, Height: 33 })
#!Numpad4::SnapActiveWindow({ Left: 0, Top: 0, Width: 33, Height: 100 })
#!Numpad5::SnapActiveWindow({ Left: 33, Top: 0, Width: 34, Height: 100 })
#!Numpad6::SnapActiveWindow({ Left: 67, Top: 0, Width: 33, Height: 100 })
#!Numpad1::SnapActiveWindow({ Left: 0, Top: 67, Width: 33, Height: 33 })
#!Numpad2::SnapActiveWindow({ Left: 0, Top: 67, Width: 100, Height: 33 })
#!Numpad3::SnapActiveWindow({ Left: 67, Top: 67, Width: 34, Height: 33 })

; Win+Shift+Numpad snaps windows in two-thirds
#NumpadHome::SnapActiveWindow({ Left: 0, Top: 0, Width: 67, Height: 67 })
#NumpadUp::SnapActiveWindow({ Left: 0, Top: 0, Width: 100, Height: 67 })
#NumpadPgUp::SnapActiveWindow({ Left: 33, Top: 0, Width: 67, Height: 67 })
#NumpadLeft::SnapActiveWindow({ Left: 0, Top: 0, Width: 67, Height: 100 })
#NumpadClear::SnapActiveWindow({ Left: 16, Top: 0, Width: 67, Height: 100 })
#NumpadRight::SnapActiveWindow({ Left: 33, Top: 0, Width: 67, Height: 100 })
#NumpadEnd::SnapActiveWindow({ Left: 0, Top: 33, Width: 67, Height: 67 })
#NumpadDown::SnapActiveWindow({ Left: 0, Top: 33, Width: 100, Height: 67 })
#NumpadPgDn::SnapActiveWindow({ Left: 33, Top: 33, Width: 67, Height: 67 })



; Resizes and moves (snaps) the active window to the specified layout
SnapActiveWindow(Layout)
{
  Try
  {
    Log("`r`nSnapping active window to "
    . Layout.Width . "% x " . Layout.Height . "% at "
    . Layout.Left . "%, " . Layout.Top . "%")

    ; Get the active window
    WinGet WindowID, ID, A
    Window := GetWindow(WindowID)
    Log("Active window is " . GetWindowDescription(Window))

    ; Don't snap system windows, such as the Desktop or Start Menu
    If IsSystemWindow(Window) {
      Log("!!!!! This is a system window, so it cannot be snapped")
      Return
    }

    ; Get all Monitors, and determine which one the window is currently on
    Monitors := GetMonitors()

    SnapWindow(Window, Layout, Monitors)
  }
  Catch Exception
  {
    ErrorHandler(Exception)
  }
}



; Resizes and moves (snaps) the given window to the specified layout
SnapWindow(Window, Layout, Monitors)
{
  ; Calculate the absolute size to snap the window to
  NewLocation := GetAbsoluteWindowBounds(Window, Layout, Monitors)

  If (NewLocation.Monitor = Window.Monitor.ID)
  {
    ; The window is already on the right monitor.
    ; Is it also already in the right spot?
    If (IsNear(Window.Left, NewLocation.Left)
    and IsNear(Window.Top, NewLocation.Top)
    and IsNear(Window.Width, NewLocation.Width)
    and IsNear(Window.Height, NewLocation.Height))
    {
      ; Move the window to the same spot on the next monitor
      Layout.Monitor := GetNextMonitor(NewLocation.Monitor, Monitors).ID
      Log("Moving the window to monitor #" . Layout.Monitor)
      SnapWindow(Window, Layout, Monitors)
      Return
    }
  }

  ; Move the window to the new layout
  SetWindowLayout(Window, Layout, Monitors)
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


