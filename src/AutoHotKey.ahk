#NoEnv                        ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn                         ; Enable warnings to assist with detecting common errors.
#SingleInstance, Force        ; Only allow one running instance of this script

SendMode Input                ; Recommended for new scripts due to its superior speed and reliability.
SetTitleMatchMode, 2          ; 1: starts with    2: contains
SetTitleMatchMode, Fast       ; Fast is default
DetectHiddenWindows, Off      ; Off is default

; Enable/Disable logging
LoggingEnabled := False

; The minimum width/height allowed to set a window to.
; This prevents windows from being mistakenly resized too small to see
MinimumWindowSize := 100

#Include src\remap-keys.ahk
#Include src\advanced-window-snap.ahk
#Include src\restore-window-layout.ahk
#Include src\always-on-top.ahk
#Include src\util\utilities.ahk
#Include src\util\windows.ahk
#Include src\util\monitors.ahk
