
; Determines whether the given string is empty or entirely whitespace
IsEmptyString(String)
{
  Return RegExMatch(String, "^ *$")
}



; Displays an informational message modal
Info(Message)
{
  MsgBox, 64, AutoHotKey, %Message%
}



; Displays errors in a message box
ErrorHandler(Exception)
{
  Message := Exception.Message
  MsgBox, 16, AutoHotKey, %Message%
}



; Determines whether the given window is a system window, such as the Desktop or Start Menu
IsSystemWindow(Window)
{
  If ((Window.ProcessName = "ShellExperienceHost.exe") or (Window.ProcessName = "Explorer.EXE"))
  {
    ; Start Menu and Action Center
    If ((Window.Title = "Start") or (Window.Title = "Action center"))
    {
      Return True
    }

    ; Desktop
    If ((Window.Title = "") and (Window.Class = "WorkerW"))
    {
      Return True
    }
  }

  ; These are window decorations, such as borders and drop shadows
  If ((Window.Title = "GlassPanelForm") or (Window.Title = "frmDeviceNotify"))
  {
    Return True
  }

  ; Doesn't seem to be a system window
  Return False
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


