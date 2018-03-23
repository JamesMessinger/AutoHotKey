; ========================================================================
; Miscellaneous utility functions
; ========================================================================

; Determines whether the given string is empty or entirely whitespace
IsEmptyString(String)
{
  Return RegExMatch(String, "^ *$")
}



; Calculates the percentage that one value is of another
Percentage(Part, Whole)
{
  Percent := (Part / Whole) * 100
  If (Percent >= 0)
    Return Floor(Percent)
  Else
    Return Ceil(Percent)
}



; Returns the specified percentage of a number
PercentageOf(Percent, Whole)
{
  Return Whole * (Percent / 100)
}



; Returns the array item with the specified ID
FindByID(Array, ID)
{
  For Index, Item in Array
  {
    If (Item.ID = ID)
      Return Item
  }
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
  Log("========== ERROR ==========`r`n" . Message)
  MsgBox, 16, AutoHotKey, %Message%
}



Log(Text)
{
  global LoggingEnabled

  If (LoggingEnabled)
  {
    Text := Text . "`r`n"
    FileCreateDir, logs
    FileAppend, %Text%, logs\log_%A_Hour%%A_Min%.txt
  }
}

