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



; Returns the items from Subset that are also in Superset
SubsetOf(Superset, Subset)
{
  ; Special case: If there is no superset, then the entire subset is returned
  If (Superset.Length() = 0)
    Return Subset

  Intersection := []

  For Index, SubItem in Subset
  {
    For Index, SuperItem in Superset
    {
      If (SuperItem.ID = SubItem.ID)
      {
        Intersection.Push(SubItem)
        Break
      }
    }
  }

  Return Intersection
}



; Determines whether two position values (height, width, top, or left) are near each other,
; within a few pixels
IsNear(a, b)
{
  Tolerance := 50

  If ((a >= b) and (a - b < Tolerance))
  {
    Return True
  }
  Else If ((b > a) and (b - a < Tolerance))
  {
    Return True
  }
  Else
  {
    Return False
  }
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
