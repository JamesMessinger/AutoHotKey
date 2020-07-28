; ========================================================================
; Miscellaneous utility functions
; ========================================================================


; Determines whether the given string is empty or entirely whitespace
IsEmptyString(String)
{
  Return RegExMatch(String, "^ *$")
}


; Determines whether the given value is an Array
IsArray(Value)
{
  Return IsObject(Value) and Value.MaxIndex() != ""
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



; Returns the items from Subset that are also in Superset
SubsetOf(Superset, Subset)
{
  ; Special case: If there is no superset, then the entire subset is returned
  If (Superset.Length() = 0)
    Return Subset

  Intersection := []

  For Index, SubItem in Subset
  {
    For Index2, SuperItem in Superset
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



; Determines whether two position values are near each other, within a few pixels
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



; Displays an informational message modal
Info(Message)
{
  MsgBox, 64, AutoHotKey, %Message%
}



; Writes the given text to a log file, if logging is enabled
Log(Text, PrependBlankLine := True)
{
  Try
  {
    global LoggingEnabled

    If (LoggingEnabled)
    {
      Text := Text . "`r`n"

      If (PrependBlankLine)
        Text := "`r`n" . Text

      FileCreateDir, logs
      FileAppend, %Text%, logs\log.txt
    }
  }
  Catch Exception
  {
    Message := "Error while writing to the log file: " . Exception.Message
    MsgBox, 16, AutoHotKey, %Message%
  }
}



; Creates a new log file
NewLog()
{
  Try
  {
    FileMove, logs\log.txt, logs\log_%A_Hour%%A_Min%.txt, 1
  }
  Catch Exception
  {
    Message := "Error while creating a new log file: " . Exception.Message
    MsgBox, 16, AutoHotKey, %Message%
  }
}



; Displays errors in a message box
ErrorHandler(Exception)
{
  Message := Exception.Message
  Log("========== ERROR ==========`r`n" . Message)
  ; MsgBox, 16, AutoHotKey, %Message%
}
