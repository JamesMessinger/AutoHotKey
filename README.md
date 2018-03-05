My Custom AutoHotKey Scripts
------------------------------------
These are my customized scripts for [AutoHotKey](https://www.autohotkey.com/).  These are highly tailored to my specific needs and preferences, but feel free to use them as a starting point for your own scripts.


### [`remap-keys.ahk`](remap-keys.ahk)
This script simply re-maps a few keyboard keys to behave the way I prefer.


### [`advanced-window-snap.ahk`](advanced-window-snap.ahk)
This script is based on [this script by Andrew Moore](https://gist.github.com/AWMooreCO/1ef708055a11862ca9dc), which extends Windows 10's built-in [window-snapping hotkeys](https://www.cnet.com/how-to/all-the-windows-10-keyboard-shortcuts-you-need-to-know/) to support additional window sizes and positions.


### [`undock-redock.ahk`](undock-redock.ahk)
This script saves and restores window positions when docking and un-docking my laptop from desktop monitors.



Installation and Usage
------------------------------------
To get these scripts working on your computer, follow these steps:

1. __Install AutoHotKey__<br>
You can [download it here](https://www.autohotkey.com/download/)

2. __Clone this repo__<br>
`git clone https://github.com/bigstickcarpet/AutoHotKey.git`

3. __Create an `AutoHotKey.ahk` file__<br>
When AutoHotKey starts up, it looks for a file named `AutoHotKey.ahk` in your Documents folder.  So create a file by that name, and point it to where you cloned this repo in Step 2.

```AutoHotKey
AutoHotKeyDir := "C:\Users\James Messinger\Code\AutoHotKey"         ; <--- Edit this to point to your path
Run, %A_AhkPath% "%AutoHotKeyDir%\AutoHotKey.ahk", %AutoHotKeyDir%
```

4. __Set AutoHotKey to run at startup__<br>
Create a shortcut to AutoHotKey (`C:\Program Files\AutoHotkey\AutoHotkey.exe`).  Then open the Windows Run utility (<kbd>Win</kbd>+<kbd>R</kbd>) and type `shell:startup` to open your Startup folder.  Then paste the AutoHotKey shortcut in this folder.
