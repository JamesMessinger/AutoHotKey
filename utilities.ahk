
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
