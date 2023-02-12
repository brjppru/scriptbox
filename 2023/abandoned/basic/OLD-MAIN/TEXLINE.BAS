CLS
FILES
10 INPUT " ”€‰‹€ ¤«ο ηβ¥­¨ο :", a$
11 IF LEN(a$) = 0 THEN 10
20 INPUT " ”€‰‹€ ¤«ο § ―¨α¨:", b$
21 IF LEN(b$) = 0 THEN 20
30 INPUT "€—€‹€ ‘’€:", b
31 IF LEN(b) = 0 THEN 30
40 INPUT "€—€‹€ ‘’€ ‹‘ *** αβΰ®ª:", c
41 IF LEN(c) = 0 THEN 40
42 INPUT "„ ‘’:", e
43 IF LEN(e) = 0 THEN 42
50 CLOSE
CLS
80 PRINT "Working "; : COLOR 30: PRINT "..."; : COLOR 7
71 OPEN "zx" FOR OUTPUT AS #3
72 PRINT : PRINT : PRINT : FOR i = b TO e STEP c: PRINT #3, i: LOCATE CSRLIN - 1, 1: PRINT "Writing "; i; " line": NEXT
CLOSE #3
CLS : PRINT : PRINT : PRINT
60 OPEN a$ FOR INPUT AS #1
70 OPEN b$ FOR OUTPUT AS #2
73 OPEN "zx" FOR INPUT AS #3
90 IF EOF(1) THEN 140
81 LOCATE CSRLIN - 1, 1: PRINT "Writing "; z$; " line"
100 INPUT #3, z$
110 LINE INPUT #1, text$
120 PRINT #2, z$ + " " + text$
130 GOTO 90
140 CLOSE : KILL "ZX": SYSTEM
























