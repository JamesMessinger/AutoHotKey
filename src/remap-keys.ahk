; Map the fingerprint sensor on the Microsoft Surface keyboard to the Win key
F24::RWin

; Map the fingerprint sensor + "." key to Win+".", which shows the Emoji picker
F24 & .::Send, {RWin Down}{. Down}{. Up}{RWin Up}

; Map the context menu key to the Ctrl key
AppsKey::RControl
