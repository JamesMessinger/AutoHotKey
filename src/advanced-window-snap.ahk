; ========================================================================
; Horizontal Window Snapping
; ========================================================================

; Win+Arrow snaps windows to the left/right half
#Left::SnapActiveWindow({ Left: 0, Top: 0, Width: .5, Height: 1 })
#Right::SnapActiveWindow({ Left: .5, Top: 0, Width: .5, Height: 1 })
#Down::SnapActiveWindow({ Left: .25, Top: 0, Width: .5, Height: 1 })

; Win+Up maximizes the window
#Up::SnapActiveWindow({ State: "MAXIMIZED", Left: 0, Top: 0, Width: 1, Height: 1 })

; Win+Alt+Arrow snaps windows to the left/middle/right third
#!Left::SnapActiveWindow({ Left: 0, Top: 0, Width: .33, Height: 1 })
#!Right::SnapActiveWindow({ Left: .67, Top: 0, Width: .33, Height: 1 })
#!Down::SnapActiveWindow({ Left: .33, Top: 0, Width: .34, Height: 1 })

; Win+Alt+Up snaps window to the middle half
#!Up::SnapActiveWindow({ Left: .25, Top: 0, Width: .5, Height: 1 })

; Win+Shift+Arrow snaps widnows to the left/middle/right two-thirds
#+Left::SnapActiveWindow({ Left: 0, Top: 0, Width: .67, Height: 1 })
#+Right::SnapActiveWindow({ Left: .33, Top: 0, Width: .67, Height: 1 })
#+Down::SnapActiveWindow({ Left: .16, Top: 0, Width: .67, Height: 1 })
#+Up::SnapActiveWindow({ Left: .16, Top: 0, Width: .67, Height: 1 })



; ========================================================================
; Vertical Window Snapping
; ========================================================================

; Ctrl+Win+Arrow snaps windows to the top/middle/bottom half
^#Up::SnapActiveWindow({ Left: 0, Top: 0, Width: 1, Height: .5 })
^#Down::SnapActiveWindow({ Left: 0, Top: .5, Width: 1, Height: .5 })
^#Left::SnapActiveWindow({ Left: 0, Top: .25, Width: 1, Height: .5 })
^#Right::SnapActiveWindow({ Left: 0, Top: .25, Width: 1, Height: .5 })

; Ctrl+Alt+Win+Arrow snaps windows to the top/middle/bottom third
^#!Up::SnapActiveWindow({ Left: 0, Top: 0, Width: 1, Height: .33 })
^#!Down::SnapActiveWindow({ Left: 0, Top: .67, Width: 1, Height: .33 })
^#!Left::SnapActiveWindow({ Left: 0, Top: .33, Width: 1, Height: .34 })
^#!Right::SnapActiveWindow({ Left: 0, Top: .33, Width: 1, Height: .34 })

; Ctrl+Shift+Win+Arrow snaps windows to the top/bottom two-thirds
^#+Up::SnapActiveWindow({ Left: 0, Top: 0, Width: 1, Height: .67 })
^#+Down::SnapActiveWindow({ Left: 0, Top: .33, Width: 1, Height: .67 })
^#+Left::SnapActiveWindow({ Left: 0, Top: .16, Width: 1, Height: .67 })
^#+Right::SnapActiveWindow({ Left: 0, Top: .16, Width: 1, Height: .67 })



; ========================================================================
; Nuber Pad Window Snapping
; ========================================================================

; Win+Numpad snaps windows in halves
#Numpad7::SnapActiveWindow({ Left: 0, Top: 0, Width: .5, Height: .5 })
#Numpad8::SnapActiveWindow({ Left: 0, Top: 0, Width: 1, Height: .5 })
#Numpad9::SnapActiveWindow({ Left: .5, Top: 0, Width: .5, Height: .5 })
#Numpad4::SnapActiveWindow({ Left: 0, Top: 0, Width: .5, Height: 1 })
#Numpad5::SnapActiveWindow({ Width: 1300, Height: 1100 })
#Numpad6::SnapActiveWindow({ Left: .5, Top: 0, Width: .5, Height: 1 })
#Numpad1::SnapActiveWindow({ Left: 0, Top: .5, Width: .5, Height: .5 })
#Numpad2::SnapActiveWindow({ Left: 0, Top: .5, Width: 1, Height: .5 })
#Numpad3::SnapActiveWindow({ Left: .5, Top: .5, Width: .5, Height: .5 })

; Win+Alt+Numpad snaps windows in thirds
#!Numpad7::SnapActiveWindow({ Left: 0, Top: 0, Width: .33, Height: .33 })
#!Numpad8::SnapActiveWindow({ Left: 0, Top: 0, Width: 1, Height: .33 })
#!Numpad9::SnapActiveWindow({ Left: .67, Top: 0, Width: .33, Height: .33 })
#!Numpad4::SnapActiveWindow({ Left: 0, Top: 0, Width: .33, Height: 1 })
#!Numpad5::SnapActiveWindow({ Width: 1000, Height: 900 })
#!Numpad6::SnapActiveWindow({ Left: .67, Top: 0, Width: .33, Height: 1 })
#!Numpad1::SnapActiveWindow({ Left: 0, Top: .67, Width: .33, Height: .33 })
#!Numpad2::SnapActiveWindow({ Left: 0, Top: .67, Width: 1, Height: .33 })
#!Numpad3::SnapActiveWindow({ Left: .67, Top: .67, Width: .34, Height: .33 })

; Win+Shift+Numpad snaps windows in two-thirds
#NumpadHome::SnapActiveWindow({ Left: 0, Top: 0, Width: .67, Height: .67 })
#NumpadUp::SnapActiveWindow({ Left: 0, Top: 0, Width: 1, Height: .67 })
#NumpadPgUp::SnapActiveWindow({ Left: .33, Top: 0, Width: .67, Height: .67 })
#NumpadLeft::SnapActiveWindow({ Left: 0, Top: 0, Width: .67, Height: 1 })
#NumpadClear::SnapActiveWindow({ Width: 1800, Height: 1400 })
#NumpadRight::SnapActiveWindow({ Left: .33, Top: 0, Width: .67, Height: 1 })
#NumpadEnd::SnapActiveWindow({ Left: 0, Top: .33, Width: .67, Height: .67 })
#NumpadDown::SnapActiveWindow({ Left: 0, Top: .33, Width: 1, Height: .67 })
#NumpadPgDn::SnapActiveWindow({ Left: .33, Top: .33, Width: .67, Height: .67 })



; Resizes and moves (snaps) the active window to the specified layout
SnapActiveWindow(Layout)
{
  Try
  {
    ; Start a new log file for this operation
    NewLog()

    Log("`r`nSnapping active window to "
    . Layout.Width . " x " . Layout.Height . " at "
    . Layout.Left . ", " . Layout.Top)

    ; Get the active window
    Monitors := GetMonitors()
    Window := GetActiveWindow(Monitors)
    Log("Active window is " . WindowToString(Window))

    Layout.Monitor := Window.Monitor
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
  ; Don't snap system windows, such as the Desktop or Start Menu
  If IsSystemWindow(Window) {
    Log("!!!!! This is a system window, so it cannot be snapped")
    Return
  }

  If (Layout.Monitor.ID = Window.Monitor.ID)
  {
    ; The window is already on the right monitor.
    ; Is it also already in the right spot?
    AbsLayout := GetAbsoluteLayout(Window, Layout)

    If (IsNear(Window.Left, AbsLayout.Left)
    and IsNear(Window.Top, AbsLayout.Top)
    and IsNear(Window.Width, AbsLayout.Width)
    and IsNear(Window.Height, AbsLayout.Height))
    {
      ; Move the window to the same spot on the next monitor
      Layout.Monitor := GetNextMonitor(AbsLayout.Monitor, Monitors)
      Log("Moving the window to monitor #" . Layout.Monitor.ID)
      SnapWindow(Window, Layout, Monitors)
      Return
    }
  }

  ; Move the window to the new layout
  SetWindowLayout(Window, Layout, Monitors)
}
