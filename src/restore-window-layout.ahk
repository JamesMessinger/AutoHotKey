; ========================================================================
; Save/Restore window layouts
; ========================================================================

; Win+Alt+0 to save the current window layouts
#!0::SaveWindowLayouts()


; Ctrl+Win+0 to restore previously-saved window layout for the current window
#^0::RestoreWindowLayouts("ACTIVE")


; Ctrl+Shift+Win+0 to restore previously-saved layouts for ALL windows
#+^0::RestoreWindowLayouts("ALL")



; Saves the current window layout for the current monitor configuration
SaveWindowLayouts()
{
  Try {
    Log("Saving window layouts...")

    Monitors := GetMonitors()
    Windows := GetWindows()
    GroupedText := []
    TotalCount := 0

    ; Loop through all windows on the entire system
    For Index, Window in Windows
    {
      Log("`r`nSaving layout of window #" . Window.ID . ": " . GetWindowDescription(Window))

      ; Should we save this window's layout?
      If IsValidWindowLayout(Window)
      {
        ; Get the window's size & position as percentages of the monitor
        Window.Monitor := GetMonitorForWindow(Window, Monitors)
        Relative := GetRelativeWindowBounds(Window, Window.Monitor)

        If (!GroupedText[Window.Monitor.ID])
        {
          ; Create a new group for this monitor
          Text := GroupedText[Window.Monitor.ID] := {}

          ; Add a comment with information about this monitor
          Text.Description := "Monitor #" . Window.Monitor.ID . ":`r`n"
          Text.Data := "#`r`n"
            . "# Monitor #" . Window.Monitor.ID . ": "
            . Window.Monitor.Bounds.Width . " x " . Window.Monitor.Bounds.Height
            . " (" . Window.Monitor.WorkArea.Width . " x " . Window.Monitor.WorkArea.Height . " working area)`r`n"
            . "#`r`n"
        }

        ; Append text to this monitor's group
        Text := GroupedText[Window.Monitor.ID]

        If (Window.Title)
          Text.Description := Text.Description . "  " . GetWindowDescription(Window) . "`r`n"

        Text.Data := Text.Data
          . "Monitor=" . Window.Monitor.ID
          . ",State=" . Window.State
          . ",Left=" . Relative.Left
          . ",Top=" . Relative.Top
          . ",Width=" . Relative.Width
          . ",Height=" . Relative.Height
          . ",ID=" . Window.ID
          . ",Process=" . Window.Process
          . ",Class=" . Window.Class
          . ",Title=" . Window.Title
          . "`r`n"

        TotalCount := TotalCount + 1
        Log("Successfully saved")
      }
      Else {
        Log("Unable to save")
      }
    }

    ; Write the text data to the file
    File := OpenLayoutFileForWriting()
    For Index, Text in GroupedText
    {
      File.WriteLine(Text.Data)
    }
    File.Close()

    ; Display the text descriptions to the user
    AllDescriptions := ""
    For Index, Text in GroupedText
    {
      AllDescriptions := AllDescriptions . Text.Description . "`r`n"
    }
    Info(TotalCount . " windows saved.`r`n`r`n" . AllDescriptions)
  }
  Catch Exception
  {
    ErrorHandler(Exception)
  }
}



; Restores the previously-saved sizes and positions of the specified windows
RestoreWindowLayouts(WindowsToRestore)
{
  Try
  {
    WinGet, ActiveWindowID, ID, A
    Monitors := GetMonitors()
    GroupedText := []
    TotalCount := 0

    ; Get the saved window layouts
    Layouts := ParseWindowLayouts()

    ; Apply each layout to the corresponding windows
    Log("`r`nRestoring window layouts...")
    For Index, Layout in Layouts
    {
      Log("`r`n")

      ; Get the window(s) that this layout applies to
      Windows := GetWindowsForLayout(Layout)

      Log("Restoring " . Windows.Length() . " windows...")
      For Index, Window in Windows
      {
        If ((WindowsToRestore = "ACTIVE") and (Window.ID != ActiveWindowID))
        {
          Log("Skipping inactive window #" . Window.ID . ": " . GetWindowDescription(Window))
          Continue
        }

        ; Restore the window's size and position
        SetWindowLayout(Window, Layout, Monitors)

        If (!GroupedText[Window.Monitor.ID])
        {
          ; Create a new group for this monitor
          GroupedText[Window.Monitor.ID] := "Monitor #" . Window.Monitor.ID . ":`r`n"
        }

        ; Append text to this monitor's group
        GroupedText[Window.Monitor.ID] := GroupedText[Window.Monitor.ID]
          . "  " . GetWindowDescription(Window) . "`r`n"
        TotalCount := TotalCount + 1
      }
    }

    ; Restore window that was active at begining of the function
    ActiveWindowTitle := "ahk_id " . ActiveWindowID
    WinActivate, %ActiveWindowTitle%

    If (WindowsToRestore = "ALL")
    {
      ; Display a list of all windows that were restored
      AllText := ""
      For Index, Text in GroupedText
      {
        AllText := AllText . Text . "`r`n"
      }
      Info(TotalCount . " windows restored.`r`n`r`n" . AllText)
    }
  }
  Catch Exception
  {
    ErrorHandler(Exception)
  }
}



; Reads and parses the file containing the saved window layouts
ParseWindowLayouts()
{
  FileName := OpenLayoutFileForReading()
  Log("Parsing window layouts in " . FileName)

  Layouts := []

  ; Read each line of the file
  Loop, Read, %FileName%
  {
    ; Skip blank lines and comments
    If (IsEmptyString(A_LoopReadLine) or (SubStr(Trim(A_LoopReadLine), 1, 1) = "#"))
      Continue

    Layout := {}
    Log("`r`nParsing next line...")

    ; Parse each comma-delimited setting
    Loop, Parse, A_LoopReadLine, CSV
    {
      ; Parse the setting key and value
      EqualPos := InStr(A_LoopField, "=")

      If (EqualPos > 1)
      {
        Key := SubStr(A_LoopField, 1, EqualPos - 1)
        Value := SubStr(A_LoopField, EqualPos + 1)

        ; Set the properties of the window object
        Layout[Key] := Value
        Log("  " . Key . " = " . Value)
      }
      Else
      {
        Log("!!!!! Unable to parse line: " . A_LoopReadLine)
      }
    }

    Layouts.Push(Layout)
  }

  ; Delete the saved layout file, since it's no longer needed
  ; UNLESS it's the default file for this monitor setup
  If (!InStr(FileName, ".default"))
    FileDelete, %FileName%

  ; Return the parsed window layouts
  Return Layouts
}



; Returns ONE OR MORE windows that the specified layout applies to
GetWindowsForLayout(Layout)
{
  Windows := []

  ; If the layout has a winodw ID, then try to find that specific window
  If (Layout.ID)
  {
    If (WinExist("ahk_id " . Layout.ID))
    {
      Window := GetWindow(Layout.ID)
      Windows.Push(Window)
      Log("Layout #" . Layout.ID . " will be applied to " . GetWindowDescription(Window))
    }
    Else
      Log("!!!!! No windows have HWND #" . Layout.ID)
  }

  If (Layout.Title)
  {
    TitleWindows := GetWindowsByTitle(Layout.Title)
    Windows := SubsetOf(Windows, TitleWindows)
  }

  If (Layout.Process)
  {
    ProcessWindows := GetWindowsByTitle("ahk_exe " . Layout.Process)
    Windows := SubsetOf(Windows, ProcessWindows)
  }

  If (Layout.Class)
  {
    ClassWindows := GetWindowsByTitle("ahk_class " . Layout.Class)
    Windows := SubsetOf(Windows, ClassWindows)
  }

  Return Windows
}



; Determines whether the given window's layout is valid and should be saved/restored
IsValidWindowLayout(Window)
{
  global MinimumWindowSize

  ; Don't save windows that are too small
  If ((Window.Width < MinimumWindowSize) and (Window.Height < MinimumWindowSize))
  {
    Log("!!!!! Window #" . Window.ID . " is too small (" . Window.Width . " x " . Window.Height . ")")
    Return False
  }

  ; Don't save windows that are entirely off-screen
  If ((Window.Bottom <= 0) and (Window.Right <= 0))
  {
    Log("!!!!! Window #" . Window.ID . " is off-screen")
    Return False
  }

  ; Don't save transparent windows
  If (Window.Transparency = 0)
  {
    Log("!!!!! Window #" . Window.ID . " is transparent")
    Return False
  }

  Return !IsSystemWindow(Window)
}



; Opens the saved window layout file for the current monitor configuration
OpenLayoutFileForWriting()
{
  FileName := GetLayoutFileBaseName() . ".txt"
  File := FileOpen(FileName, "w")

  If !IsObject(File)
    Throw Exception("Can't open " . FileName . " for writing")

  Return File
}



; Opens the saved window layout file for the current monitor configuration.
OpenLayoutFileForReading()
{
  FileName := GetLayoutFileBaseName() . ".txt"

  If (!FileExist(FileName))
  {
    ; No window layout was saved, so see if there's a default layout we can use instead
    FileName := GetLayoutFileBaseName() . ".default.txt"

    If (!FileExist(FileName))
      Throw Exception("There is no saved window layout for this monitor setup.`r`n"
        . "Save a layout first.`r`n`r`n"
        . "Looking for:`r`n" . A_WorkingDir . "\" . FileName)
  }

  Return FileName
}



; Returns the name of the window layout file for the current monitor configuration
GetLayoutFileBaseName()
{
  SysGet, MonitorCount, MonitorCount
  Return "config\" . MonitorCount . "-monitor-layout"
}
