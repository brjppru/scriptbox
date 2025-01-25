SCREEN 2
CLS
INPUT "file name for input:", A$
CLS
A$ = A$ + ".PIC"
OPEN A$ FOR INPUT AS #1
PSET (160, 100), 1
WHILE NOT (EOF(1))
INPUT #1, A$
DRAW "X" + VARPTR$(A$)
WEND
CLOSE


