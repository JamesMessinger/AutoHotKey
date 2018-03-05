#NoEnv                        ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn                         ; Enable warnings to assist with detecting common errors.
#SingleInstance, Force        ; Only allow one running instance of this script

SendMode Input                ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%   ; Ensures a consistent starting directory.
SetTitleMatchMode, 2          ; 1: starts with    2: contains
SetTitleMatchMode, Fast       ; Fast is default
DetectHiddenWindows, off      ; Off is default

#Include remap-keys.ahk
#Include advanced-window-snap.ahk
#Include undock-redock.ahk
#Include utilities.ahk
