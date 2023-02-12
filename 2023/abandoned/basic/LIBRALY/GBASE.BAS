SCREEN 2
DIM cur(5)
DATA 1,1,1,1,0
DATA 1,0,1,1,0
DATA 1,1,1,0,0
DATA 0,0,0,1,0
DATA 0,0,0,0,1
x = 100
y = 100
FOR i = 1 TO 5
FOR j = 1 TO 5
READ c
PSET (x, y), c
x = x + 1
NEXT
x = 100
y = y + 1
NEXT
GET (100, 100)-(105, 105), cur
CLS
INPUT "file name for input:", A$
CLS
A$ = A$ + ".PIC"
OPEN A$ FOR INPUT AS #1
PSET (160, 100), 1
WHILE NOT (EOF(1))
INPUT #1, b$
DRAW "X" + VARPTR$(b$)
WEND
CLOSE #1
OPEN A$ FOR append AS #1
XCUR = 160
YCUR = 100
x = 160
y = 100
P = 1
S$ = ""
315 PUT (XCUR, YCUR), cur
320 q$ = INKEY$: LOCATE 25, 71: PRINT TIME$; : IF q$ = "" THEN 320
321 LOCATE 25, 1: PRINT "x="; XCUR; "y="; YCUR;
330 IF q$ = CHR$(13) THEN 1800
340 IF q$ = "+" THEN 2000
350 IF q$ = "-" THEN P = 0: GOTO 320
370 q$ = RIGHT$(q$, 1)
380 IF q$ = "H" THEN y = y - 1: k = 1: GOTO 470
390 IF q$ = "P" THEN y = y + 1: k = 2: GOTO 470
400 IF q$ = "M" THEN x = x + 1: k = 3: GOTO 470
410 IF q$ = "K" THEN x = x - 1: k = 4: GOTO 470

420 IF q$ = "G" THEN y = y - 1: x = x - 1: k = 5: GOTO 470
430 IF q$ = "I" THEN y = y - 1: x = x + 1: k = 6: GOTO 470
440 IF q$ = "O" THEN y = y + 1: x = x - 1: k = 7: GOTO 470
450 IF q$ = "Q" THEN y = y + 1: x = x + 1: k = 8: GOTO 470
460 GOTO 320
470 IF (x > 0) AND (x <= 630) AND (y >= 0) AND (y <= 190) THEN 490
471 IF x = 0 THEN x = 1
472 IF x = 359 THEN x = x - 1
473 IF y = 0 THEN y = 1
474 IF y = 169 THEN y = y - 1


480 LOCATE 25, 1: PRINT STRING$(79, " "); : LOCATE 25, 1: PRINT "out of screen "; : x = XCUR: y = YCUR: GOTO 320
490 PUT (XCUR, YCUR), cur
500 IF P = 0 THEN 540
510 ON k GOSUB 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700
520 IF LEN(S$) > 240 THEN PRINT #1, S$: S$ = ""
540 XCUR = x: YCUR = y: PUT (XCUR, YCUR), cur: GOTO 320
1000 DRAW "u1": S$ = S$ + "u1": RETURN
1100 DRAW "d1": S$ = S$ + "d1": RETURN
1200 DRAW "r1": S$ = S$ + "r1": RETURN
1300 DRAW "l1": S$ = S$ + "l1": RETURN
1400 DRAW "h1": S$ = S$ + "h1": RETURN
1500 DRAW "e1": S$ = S$ + "e1": RETURN
1600 DRAW "g1": S$ = S$ + "g1": RETURN
1700 DRAW "f1": S$ = S$ + "f1": RETURN
1800 IF LEN(S$) > 0 THEN PRINT #1, S$
1820 END
2000 IF P = 1 THEN GOTO 320
2010 P = 1
2020 A$ = "BM" + STR$(XCUR) + "," + STR$(YCUR)
2030 DRAW "X" + VARPTR$(A$)
2040 IF LEN(S$) > 0 THEN PRINT #1, S$
2050 S$ = CHR$(34) + A$ + CHR$(34)
2060 PRINT #1, S$: S$ = ""
2070 GOTO 320



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


