; ========================================================================
; My custom window layout algorithm
; ========================================================================


; Win + Enter applies smart layout 0 to the active window
#Enter::SmartLayoutActiveWindow(0)

; Ctrl + Win + Enter applies smart layout 1 to the active window
^#Enter::SmartLayoutActiveWindow(1)

; Win + Alt + Enter applies smart layout 2 to the active window
#!Enter::SmartLayoutActiveWindow(2)

; Win + Shift + Enter applies smart layout 0 to all windows
#+Enter::SmartLayoutAllWindows(0)
#if GetKeyState("AppsKey", "P")
  +Enter::SmartLayoutAllWindows(0)
#if

; Ctrl + Win + Shift + Enter applies smart layout 1 to all windows
^#+Enter::SmartLayoutAllWindows(1)

; Win + Shift + Alt + Enter applies smart layout 2 to all windows
#!+Enter::SmartLayoutAllWindows(2)



; Returns the smart layouts for all windows
GetSmartLayouts(LayoutID, Monitors, Windows)
{
  SmartLayouts := []

  LaptopScreen := FindLaptopMonitor(Monitors)
  HorizontalMonitor := FindHorizontalMonitor(Monitors, LaptopScreen)
  VerticalMonitor := FindVerticalMonitor(Monitors)

  Log("", False) ; blank line
  Explorer := FindWindows(Windows, { Process: "Explorer.EXE", Class: "CabinetWClass" })
  Browser := FindWindows(Windows, { Title: ["Google Chrome", "Firefox"]})
  Gmail := FindWindows(Windows, { Title: ["Gmail", " Mail", "Inbox"]})
  Gcal := FindWindows(Windows, { Title: "Calendar"})
  WebPage := FindWindows(Windows, { Title: ["Google Chrome", "Firefox"]}, { Title: ["Gmail", "Mail", "Calendar"]})
  Sublime := FindWindows(Windows, { Title: "Sublime Text" })
  Slack := FindWindows(Windows, { Process: "Slack.exe" })
  Twitter := FindWindows(Windows, { Title: "Twitter" })
  Chat := FindWindows(Windows, { Title: ["Messenger", "Messages"]})
  VideoChat := FindWindows(Windows, { Title: ["Zoom "]})
  MusicPlayer := FindWindows(Windows, { Title: ["Spotify", "iTunes"] })
  OneNote := FindWindows(Windows, { Title: "OneNote" })
  StickyNote := FindWindows(Windows, { Title: "Sticky Notes" })
  Calculator := FindWindows(Windows, { Title: "Calculator" })
  VSCode := FindWindows(Windows, { Title: "Visual Studio"})
  Git := FindWindows(Windows, { Title: ["Sourcetree", "GitKraken"]})
  Postman := FindWindows(Windows, { Title: "Postman"})
  Cmd := FindWindows(Windows, { Title: "Command Prompt"})

  If (LaptopScreen and HorizontalMonitor and VerticalMonitor)
  {
    ;-------------------------------------------------------------------------
    ;                         THREE SCREEN LAYOUTS
    ;
    ;  Laptop screen plus two external monitors (one horizontal, one vertical)
    ;-------------------------------------------------------------------------
    Log("Applying three-screen smart layout #" . LayoutID)

    SmartLayouts.Push({ Windows: StickyNote, Monitor: VerticalMonitor, Top: .5, Left: .7, Width: .27, Height: .14 })
    SmartLayouts.Push({ Windows: Calculator, Monitor: LaptopScreen, Top: .5, Left: .8, Width: .2, Height: .5 })
    SmartLayouts.Push({ Windows: Twitter, Monitor: LaptopScreen, Top: 0, Left: .75, Width: .25, Height: 1 })
    SmartLayouts.Push({ Windows: Chat, Monitor: LaptopScreen, Top: .15, Left: .25, Width: .5, Height: .7 })
    SmartLayouts.Push({ Windows: [OneNote, MusicPlayer, Git], Monitor: VerticalMonitor, Top: .6, Left: 0, Width: 1, Height: .4 })

    If (VSCode)
    {
      SmartLayouts.Push({ Windows: VSCode, Monitor: HorizontalMonitor, State: "MAXIMIZED" })
      SmartLayouts.Push({ Windows: Browser, Monitor: VerticalMonitor, Top: 0, Left: 0, Width: 1, Height: .6 })
    }
    Else If ((Gmail or Gcal) and WebPage)
    {
      SmartLayouts.Push({ Windows: Gmail, Monitor: VerticalMonitor, Top: 0, Left: 0, Width: 1, Height: .6 })
      SmartLayouts.Push({ Windows: Gcal, Monitor: VerticalMonitor, Top: .6, Left: 0, Width: 1, Height: .4 })
      SmartLayouts.Push({ Windows: WebPage, Monitor: HorizontalMonitor, Top: 0, Left: .17, Width: .66, Height: 1 })
    }
    Else
    {
      If (LayoutID = 1)
        SmartLayouts.Push({ Windows: Browser, Monitor: VerticalMonitor, Top: 0, Left: 0, Width: 1, Height: .6 })
      Else If (LayoutID = 2)
        SmartLayouts.Push({ Windows: Browser, Monitor: LaptopScreen, State: "MAXIMIZED" })
      Else
        SmartLayouts.Push({ Windows: Browser, Monitor: HorizontalMonitor, Top: 0, Left: .17, Width: .66, Height: 1 })
    }

    If (Slack and VideoChat)
    {
      SmartLayouts.Push({ Windows: VideoChat, Monitor: LaptopScreen, Top: 0, Left: 0, Width: 1, Height: .25 })
      SmartLayouts.Push({ Windows: Slack, Monitor: LaptopScreen, Top: .25, Left: 0, Width: 1, Height: .75 })
    }
    Else
    {
      SmartLayouts.Push({ Windows: VideoChat, Monitor: LaptopScreen, Top: 0, Left: 0, Width: 1, Height: .25 })
      SmartLayouts.Push({ Windows: Slack, Monitor: LaptopScreen, State: "MAXIMIZED" })
    }

    If (LayoutID = 1)
      SmartLayouts.Push({ Windows: Sublime, Monitor: LaptopScreen, Width: .5, Height: .7 })
    Else If (LayoutID = 2)
      SmartLayouts.Push({ Windows: Sublime, Monitor: VerticalMonitor, Width: .4, Height: .6 })
    Else
      SmartLayouts.Push({ Windows: Sublime, Monitor: HorizontalMonitor, Width: .4, Height: .6 })

    If (Explorer and Explorer.Length() = 2)
    {
      SmartLayouts.Push({ Windows: Explorer[1], Monitor: LaptopScreen, Top: 0, Left: 0, Width: .5, Height: 1 })
      SmartLayouts.Push({ Windows: Explorer[2], Monitor: LaptopScreen, Top: 0, Left: .5, Width: .5, Height: 1 })
    }
    Else
      SmartLayouts.Push({ Windows: Explorer, Monitor: VerticalMonitor, Top: .7, Left: .3, Width: .7, Height: .3, Cascade: True })

    If (Cmd and Cmd.Length() = 1)
      SmartLayouts.Push({ Windows: Cmd, Monitor: HorizontalMonitor, Top: 0, Left: .8, Width: .2, Height: 1 })
    Else If (Cmd and Cmd.Length() = 2)
    {
      SmartLayouts.Push({ Windows: Cmd[1], Monitor: LaptopScreen, Top: 1, Left: 0, Width: .5, Height: 1 })
      SmartLayouts.Push({ Windows: Cmd[2], Monitor: LaptopScreen, Top: 1, Left: .5, Width: .5, Height: 1 })
    }
    Else
      SmartLayouts.Push({ Windows: Cmd, Monitor: HorizontalMonitor, Top: .1, Left: .1, Width: .3, Height: .3, Cascade: True })
  }
  Else If (LaptopScreen and HorizontalMonitor)
  {
    ;-------------------------------------------------------------------------
    ;                           TWO SCREEN LAYOUTS
    ;
    ;          Laptop screen plus one external monitor (horizontal)
    ;-------------------------------------------------------------------------
    Log("Applying two-screen smart layout #" . LayoutID)

    SmartLayouts.Push({ Windows: StickyNote, Monitor: LaptopScreen, Top: .7, Left: .8, Width: .2, Height: .3 })
    SmartLayouts.Push({ Windows: Calculator, Monitor: LaptopScreen, Top: .5, Left: .8, Width: .2, Height: .5 })
    SmartLayouts.Push({ Windows: Twitter, Monitor: LaptopScreen, Top: 0, Left: .75, Width: .25, Height: 1 })
    SmartLayouts.Push({ Windows: Chat, Monitor: LaptopScreen, Top: .15, Left: .25, Width: .5, Height: .7 })
    SmartLayouts.Push({ Windows: [MusicPlayer, OneNote, Git, Postman], Monitor: LaptopScreen, State: "MAXIMIZED" })

    If (VSCode)
    {
      SmartLayouts.Push({ Windows: VSCode, Monitor: HorizontalMonitor, State: "MAXIMIZED" })
      SmartLayouts.Push({ Windows: Browser, Monitor: LaptopScreen, State: "MAXIMIZED" })
    }
    Else If (Gmail and Gcal)
    {
      SmartLayouts.Push({ Windows: Gmail, Monitor: HorizontalMonitor, Top: 0, Left: 0, Width: .5, Height: 1 })
      SmartLayouts.Push({ Windows: Gcal, Monitor: HorizontalMonitor, Top: 0, Left: .5, Width: .5, Height: 1 })
      SmartLayouts.Push({ Windows: WebPage, Monitor: HorizontalMonitor, Width: .5, Height: 1 })
    }
    Else If ((Gmail or Gcal) and WebPage)
    {
      SmartLayouts.Push({ Windows: [Gmail, Gcal], Monitor: HorizontalMonitor, Top: 0, Left: 0, Width: .5, Height: 1 })
      SmartLayouts.Push({ Windows: WebPage, Monitor: HorizontalMonitor, Top: 0, Left: .5, Width: .5, Height: 1 })
    }
    Else If (WebPage and WebPage.Length() = 2)
    {
      SmartLayouts.Push({ Windows: WebPage[1], Monitor: HorizontalMonitor, Top: 0, Left: 0, Width: .5, Height: 1 })
      SmartLayouts.Push({ Windows: WebPage[2], Monitor: HorizontalMonitor, Top: 0, Left: .5, Width: .5, Height: 1 })
    }
    Else
      SmartLayouts.Push({ Windows: Browser, Monitor: HorizontalMonitor, Width: .66, Height: 1 })

    If (Slack and VideoChat)
    {
      SmartLayouts.Push({ Windows: VideoChat, Monitor: LaptopScreen, Top: 0, Left: 0, Width: 1, Height: .25 })
      SmartLayouts.Push({ Windows: Slack, Monitor: LaptopScreen, Top: .25, Left: 0, Width: 1, Height: .75 })
    }
    Else
    {
      SmartLayouts.Push({ Windows: VideoChat, Monitor: LaptopScreen, Top: 0, Left: 0, Width: 1, Height: .25 })
      SmartLayouts.Push({ Windows: Slack, Monitor: LaptopScreen, State: "MAXIMIZED" })
    }

    If (LayoutID = 0)
      SmartLayouts.Push({ Windows: Sublime, Monitor: HorizontalMonitor, Width: .4, Height: .6 })
    Else
      SmartLayouts.Push({ Windows: Sublime, Monitor: LaptopScreen, Width: .5, Height: .7 })

    If (Explorer and Explorer.Length() = 2)
    {
      SmartLayouts.Push({ Windows: Explorer[1], Monitor: LaptopScreen, Top: 0, Left: 0, Width: .5, Height: 1 })
      SmartLayouts.Push({ Windows: Explorer[2], Monitor: LaptopScreen, Top: 0, Left: .5, Width: .5, Height: 1 })
    }
    Else
      SmartLayouts.Push({ Windows: Explorer, Monitor: HorizontalMonitor, Top: .2, Left: .05, Width: .4, Height: .5, Cascade: True })

    If (Cmd and Cmd.Length() = 1)
      SmartLayouts.Push({ Windows: Cmd, Monitor: HorizontalMonitor, Top: 0, Left: .8, Width: .2, Height: 1 })
    Else If (Cmd and Cmd.Length() = 2)
    {
      SmartLayouts.Push({ Windows: Cmd[1], Monitor: LaptopScreen, Top: 1, Left: 0, Width: .5, Height: 1 })
      SmartLayouts.Push({ Windows: Cmd[2], Monitor: LaptopScreen, Top: 1, Left: .5, Width: .5, Height: 1 })
    }
    Else
      SmartLayouts.Push({ Windows: Cmd, Monitor: HorizontalMonitor, Top: .1, Left: .1, Width: .3, Height: .3, Cascade: True })
  }
  Else
  {
    ;-------------------------------------------------------------------------
    ;                         SINGLE SCREEN LAYOUTS
    ;
    ;           Just the laptop screen, or just external monitor(s)
    ;-------------------------------------------------------------------------
    Log("Applying single-screen smart layout #" . LayoutID)

    If (LaptopScreen)
    {
      SmartLayouts.Push({ Windows: [Browser, MusicPlayer, OneNote, VSCode, Git, Postman], Monitor: LaptopScreen, State: "MAXIMIZED" })
      SmartLayouts.Push({ Windows: Chat, Monitor: LaptopScreen, Top: .15, Left: .25, Width: .5, Height: .7 })
      SmartLayouts.Push({ Windows: VideoChat, Monitor: LaptopScreen, Top: 0, Left: 0, Width: 1, Height: .25 })
      SmartLayouts.Push({ Windows: StickyNote, Monitor: LaptopScreen, Top: .7, Left: .8, Width: .2, Height: .3 })
      SmartLayouts.Push({ Windows: Calculator, Monitor: LaptopScreen, Top: .5, Left: .8, Width: .2, Height: .5 })
      SmartLayouts.Push({ Windows: Sublime, Monitor: LaptopScreen, Width: .5, Height: .7 })
      SmartLayouts.Push({ Windows: Twitter, Monitor: LaptopScreen, Top: 0, Left: .75, Width: .25, Height: 1 })
      SmartLayouts.Push({ Windows: Cmd, Monitor: LaptopScreen, Top: .1, Left: .1, Width: .5, Height: .5, Cascade: True })

      If (Slack and VideoChat)
      {
        SmartLayouts.Push({ Windows: VideoChat, Monitor: LaptopScreen, Top: 0, Left: 0, Width: 1, Height: .25 })
        SmartLayouts.Push({ Windows: Slack, Monitor: LaptopScreen, Top: .25, Left: 0, Width: 1, Height: .75 })
      }
      Else
      {
        SmartLayouts.Push({ Windows: VideoChat, Monitor: LaptopScreen, Top: 0, Left: 0, Width: 1, Height: .25 })
        SmartLayouts.Push({ Windows: Slack, Monitor: LaptopScreen, State: "MAXIMIZED" })
      }

      If (Explorer and Explorer.Length() = 2)
      {
        SmartLayouts.Push({ Windows: Explorer[1], Monitor: LaptopScreen, Top: 0, Left: 0, Width: .5, Height: 1 })
        SmartLayouts.Push({ Windows: Explorer[2], Monitor: LaptopScreen, Top: 0, Left: .5, Width: .5, Height: 1 })
      }
      Else
        SmartLayouts.Push({ Windows: Explorer, Monitor: LaptopScreen, Top: .4, Left: .6, Width: .5, Height: .5, Cascade: True })
    }
    Else
    {
      SmartLayouts.Push({ Windows: VSCode, Monitor: HorizontalMonitor, State: "MAXIMIZED" })
      SmartLayouts.Push({ Windows: Browser, Monitor: HorizontalMonitor, Width: .66, Height: 1 })
      SmartLayouts.Push({ Windows: Slack, Monitor: HorizontalMonitor, Top: .5, Left: 0, Width: .66, Height: .5 })
      SmartLayouts.Push({ Windows: [MusicPlayer, OneNote, Git, Postman], Monitor: HorizontalMonitor, Top: .5, Left: .34, Width: .66, Height: .5 })
      SmartLayouts.Push({ Windows: Chat, Monitor: HorizontalMonitor, Top: .5, Left: .6, Width: .35, Height: .45 })
      SmartLayouts.Push({ Windows: VideoChat, Monitor: HorizontalMonitor, Top: .25, Left: .3, Width: .4, Height: .5 })
      SmartLayouts.Push({ Windows: StickyNote, Monitor: HorizontalMonitor, Top: .8, Left: .9, Width: .1, Height: .2 })
      SmartLayouts.Push({ Windows: Calculator, Monitor: HorizontalMonitor, Top: .8, Left: .9, Width: .1, Height: .2 })
      SmartLayouts.Push({ Windows: Sublime, Monitor: HorizontalMonitor, Width: .4, Height: .6 })
      SmartLayouts.Push({ Windows: Twitter, Monitor: HorizontalMonitor, Top: 0, Left: .85, Width: .15, Height: 1 })
      SmartLayouts.Push({ Windows: Explorer, Monitor: HorizontalMonitor, Top: .2, Left: .05, Width: .4, Height: .5, Cascade: True })

      If (Cmd and Cmd.Length() = 1)
        SmartLayouts.Push({ Windows: Cmd, Monitor: HorizontalMonitor, Top: 0, Left: .8, Width: .2, Height: 1 })
      Else
        SmartLayouts.Push({ Windows: Cmd, Monitor: HorizontalMonitor, Top: .1, Left: .1, Width: .3, Height: .3, Cascade: True })
    }
  }

  Return NormalizeSmartLayouts(SmartLayouts)
}
