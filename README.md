My Custom AutoHotKey Scripts
------------------------------------
These are my customized scripts for [AutoHotKey](https://www.autohotkey.com/).  These are highly tailored to my specific needs and preferences, but feel free to use them as a starting point for your own scripts.


### [`remap-keys.ahk`](src/remap-keys.ahk)
This script simply re-maps a few keyboard keys to behave the way I prefer.


### [`restore-window-layout.ahk`](src/restore-window-layout.ahk)
This script allows you to save and restore window layouts for different monitor setups.  This is useful when undocking/re-docking a laptop to a docking station, or when connecting/disconnecting external monitors, projectors, etc.

Hotkey | Behavior
:------|:-------------------
<kbd>Alt</kbd>+<kbd>Win</kbd>+<kbd>0</kbd> | Save the current window layout for the current monitor configuration.<br><br>Depending on how many monitors are connected, the window layout will be saved in the `config` directory as `1-monitor-layout.txt`, `2-monitor-layout.txt`, etc.
<kbd>Ctrl</kbd>+<kbd>Win</kbd>+<kbd>0</kbd> | Restore the layout of the **active window** for the current monitor configuration.
<kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>Win</kbd>+<kbd>0</kbd> | Restore the layout of **all windows** for the current monitor configuration.<br><br>The window layout file is deleted afterward. You can create a `config\#-monitor-layout.default.txt` file for each monitor configuration, which will be applied if there is no saved layout file.


### [`advanced-window-snap.ahk`](src/advanced-window-snap.ahk)
This script is based on [this script by Andrew Moore](https://gist.github.com/AWMooreCO/1ef708055a11862ca9dc), which extends Windows 10's built-in [window-snapping hotkeys](https://www.cnet.com/how-to/all-the-windows-10-keyboard-shortcuts-you-need-to-know/) to support additional window sizes and positions.

##### Default Windows Hotkeys
Hotkey | Behavior
:------|:-------------------
<kbd>Win</kbd>+<kbd>&larr;</kbd> | Snap to the left **half** of the screen
<kbd>Win</kbd>+<kbd>&rarr;</kbd> | Snap to the right **half** of the screen
<kbd>Win</kbd>+<kbd>&uarr;</kbd> | Maximize the window
<kbd>Win</kbd>+<kbd>&darr;</kbd> | Restore/minimize the window

##### Advanced Hotkeys (horizontal)
Hotkey | Behavior
:------|:-------------------
<kbd>Alt</kbd>+<kbd>Win</kbd>+<kbd>&larr;</kbd> | Snap to the left **third** of the screen
<kbd>Alt</kbd>+<kbd>Win</kbd>+<kbd>&rarr;</kbd> | Snap to the right **third** of the screen
<kbd>Alt</kbd>+<kbd>Win</kbd>+<kbd>&darr;</kbd> | Snap to the middle **third** of the screen
<kbd>Alt</kbd>+<kbd>Win</kbd>+<kbd>&uarr;</kbd> | Snap to the middle **half** of the screen
<kbd>Shift</kbd>+<kbd>Win</kbd>+<kbd>&larr;</kbd> | Snap to the left **two-thirds** of the screen
<kbd>Shift</kbd>+<kbd>Win</kbd>+<kbd>&rarr;</kbd> | Snap to the right **two-thirds** of the screen
<kbd>Shift</kbd>+<kbd>Win</kbd>+<kbd>&darr;</kbd> | Snap to the middle **two-thirds** of the screen
<kbd>Shift</kbd>+<kbd>Win</kbd>+<kbd>&uarr;</kbd> | Snap to the middle **two-thirds** of the screen

##### Advanced Hotkeys (vertical)
Hotkey | Behavior
:------|:-------------------
<kbd>Ctrl</kbd>+<kbd>Win</kbd>+<kbd>&uarr;</kbd> | Snap to the top **half** of the screen
<kbd>Ctrl</kbd>+<kbd>Win</kbd>+<kbd>&darr;</kbd> | Snap to the bottom **half** of the screen
<kbd>Ctrl</kbd>+<kbd>Win</kbd>+<kbd>&larr;</kbd> | Snap to the middle **half** of the screen
<kbd>Ctrl</kbd>+<kbd>Win</kbd>+<kbd>&rarr;</kbd> | Snap to the middle **half** of the screen
<kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>Win</kbd>+<kbd>&uarr;</kbd> | Snap to the top **third** of the screen
<kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>Win</kbd>+<kbd>&darr;</kbd> | Snap to the bottom **third** of the screen
<kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>Win</kbd>+<kbd>&larr;</kbd> | Snap to the middle **third** of the screen
<kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>Win</kbd>+<kbd>&rarr;</kbd> | Snap to the middle **third** of the screen
<kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>Win</kbd>+<kbd>&uarr;</kbd> | Snap to the top **two-thirds** of the screen
<kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>Win</kbd>+<kbd>&darr;</kbd> | Snap to the bottom **two-thirds** of the screen
<kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>Win</kbd>+<kbd>&larr;</kbd> | Snap to the middle **two-thirds** of the screen
<kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>Win</kbd>+<kbd>&rarr;</kbd> | Snap to the middle **two-thirds** of the screen

##### Advanced Hotkeys (centering)
Hotkey | Behavior
:------|:-------------------
<kbd>Win</kbd>+<kbd>Enter</kbd> | Center the window on screen (big)
<kbd>Alt</kbd>+<kbd>Win</kbd>+<kbd>Enter</kbd> | Center the window on screen (small)

##### Advanced Hotkeys (using the number pad)
Hotkey | Behavior
:------|:-------------------
<kbd>Win</kbd>+<kbd>Numpad 7</kbd> | Snap to the top-left **half** of the screen
<kbd>Win</kbd>+<kbd>Numpad 8</kbd> | Snap to the top **half** of the screen
<kbd>Win</kbd>+<kbd>Numpad 9</kbd> | Snap to the top-right **half** of the screen
<kbd>Win</kbd>+<kbd>Numpad 4</kbd> | Snap to the left **half** of the screen
<kbd>Win</kbd>+<kbd>Numpad 5</kbd> | Snap to the middle **half** of the screen
<kbd>Win</kbd>+<kbd>Numpad 6</kbd> | Snap to the right **half** of the screen
<kbd>Win</kbd>+<kbd>Numpad 1</kbd> | Snap to the bottom-left **half** of the screen
<kbd>Win</kbd>+<kbd>Numpad 2</kbd> | Snap to the bottom **half** of the screen
<kbd>Win</kbd>+<kbd>Numpad 3</kbd> | Snap to the bottom-right **half** of the screen
<kbd>Alt</kbd>+<kbd>Win</kbd>+<kbd>Numpad 7</kbd> | Snap to the top-left **third** of the screen
<kbd>Alt</kbd>+<kbd>Win</kbd>+<kbd>Numpad 8</kbd> | Snap to the top **third** of the screen
<kbd>Alt</kbd>+<kbd>Win</kbd>+<kbd>Numpad 9</kbd> | Snap to the top-right **third** of the screen
<kbd>Alt</kbd>+<kbd>Win</kbd>+<kbd>Numpad 4</kbd> | Snap to the left **third** of the screen
<kbd>Alt</kbd>+<kbd>Win</kbd>+<kbd>Numpad 5</kbd> | Snap to the middle **third** of the screen
<kbd>Alt</kbd>+<kbd>Win</kbd>+<kbd>Numpad 6</kbd> | Snap to the right **third** of the screen
<kbd>Alt</kbd>+<kbd>Win</kbd>+<kbd>Numpad 1</kbd> | Snap to the bottom-left **third** of the screen
<kbd>Alt</kbd>+<kbd>Win</kbd>+<kbd>Numpad 2</kbd> | Snap to the bottom **third** of the screen
<kbd>Alt</kbd>+<kbd>Win</kbd>+<kbd>Numpad 3</kbd> | Snap to the bottom-right **third** of the screen
<kbd>Shift</kbd>+<kbd>Win</kbd>+<kbd>Numpad 7</kbd> | Snap to the top-left **two-thirds** of the screen
<kbd>Shift</kbd>+<kbd>Win</kbd>+<kbd>Numpad 8</kbd> | Snap to the top **two-thirds** of the screen
<kbd>Shift</kbd>+<kbd>Win</kbd>+<kbd>Numpad 9</kbd> | Snap to the top-right **two-thirds** of the screen
<kbd>Shift</kbd>+<kbd>Win</kbd>+<kbd>Numpad 4</kbd> | Snap to the left **two-thirds** of the screen
<kbd>Shift</kbd>+<kbd>Win</kbd>+<kbd>Numpad 5</kbd> | Snap to the middle **two-thirds** of the screen
<kbd>Shift</kbd>+<kbd>Win</kbd>+<kbd>Numpad 6</kbd> | Snap to the right **two-thirds** of the screen
<kbd>Shift</kbd>+<kbd>Win</kbd>+<kbd>Numpad 1</kbd> | Snap to the bottom-left **two-thirds** of the screen
<kbd>Shift</kbd>+<kbd>Win</kbd>+<kbd>Numpad 2</kbd> | Snap to the bottom **two-thirds** of the screen
<kbd>Shift</kbd>+<kbd>Win</kbd>+<kbd>Numpad 3</kbd> | Snap to the bottom-right **two-thirds** of the screen



Installation and Usage
------------------------------------
To get these scripts working on your computer, follow these steps:

1. __Install AutoHotKey__<br>
You can [download it here](https://www.autohotkey.com/download/)

2. __Clone this repo__<br>
`git clone https://github.com/JamesMessinger/AutoHotKey.git`

3. __Create an `AutoHotKey.ahk` file__<br>
When AutoHotKey starts up, it looks for a file named `AutoHotKey.ahk` in your Documents folder.  So create a file by that name, and point it to where you cloned this repo in Step 2.

```AutoHotKey
AutoHotKeyDir := "C:\Users\James Messinger\Code\AutoHotKey"         ; <--- Edit this to point to your path
Run, %A_AhkPath% "%AutoHotKeyDir%\src\AutoHotKey.ahk", %AutoHotKeyDir%
```

4. __Set AutoHotKey to run at startup__<br>
Create a shortcut to AutoHotKey (`C:\Program Files\AutoHotkey\AutoHotkey.exe`).  Then open the Windows Run utility (<kbd>Win</kbd>+<kbd>R</kbd>) and type `shell:startup` to open your Startup folder.  Then paste the AutoHotKey shortcut in this folder.



License
------------------------------------
All of these scripts are [MIT licensed](http://opensource.org/licenses/MIT) and can be used however you want.  [AutoHotKey](https://www.autohotkey.com/) is [open-source](https://github.com/Lexikos/AutoHotkey_L) too!
