10  SCREEN 7
20 COLOR 13
30 CLS
40 LOCATE 1, 29: PRINT "The Fly (C)"; : PRINT TAB(30); "Copyrigth": PRINT TAB(32); "1994": COLOR 3: PRINT TAB(29); " Bogdanov ": PRINT TAB(31); " Roman ";
50 LOCATE 7, 30: COLOR 10: PRINT "All Rigth": PRINT TAB(30); " reserved "
60 COLOR 10
70 PLAY "mbt255o1ecd<g p32 g>dec"
80 PLAY "mbt255o2ecd<g p32 g>dec"
90 FOR j = -1 TO 250
100 COLOR 10
110 LINE (90, 221 - j)-(107, 215 - j)
120 LINE -(108, 203 - j)
130 LINE -(110, 200 - j)
140 LINE -(112, 203 - j)
150 LINE -(113, 215 - j)
160 LINE -(130, 221 - j)
170 LINE (103, 236 - j)-(108, 235 - j)
180 LINE -(112, 235 - j)
190 LINE -(117, 236 - j)
200 LINE (90, 225 - j)-(106, 226 - j), 0
210 LINE (114, 226 - j)-(130, 225 - j), 0
220 LINE (103, 240 - j)-(110, 241 - j), 0
230 LINE -(117, 240 - j), 0
240 NEXT j
250 GOTO 70

