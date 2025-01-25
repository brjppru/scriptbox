10 DIM PR(4015)
20 CLS
30 ON ERROR GOTO 70
40 OPEN "ibm.pic" FOR INPUT AS #1: CLOSE
50 OPEN "fon.pic" FOR INPUT AS #2: CLOSE
60 OPEN "prugun.pic" FOR INPUT AS #3: CLOSE : GOTO 120
70 IF ERL = 40 THEN 100
80 IF ERL = 40 THEN 100
90 IF ERL = 40 THEN 100
100 PRINT "Dos:errror file not found .run undelete.com": END
110 RESUME
120 SCREEN 2
130 ON ERROR GOTO 220
140 OPEN "ibm.pic" FOR INPUT AS #1
150 PSET (160, 100), 1
160 WHILE NOT (EOF(1))
170 INPUT #1, A$
180 DRAW "X" + VARPTR$(A$)
190 WEND: LOCATE 20, 1: PRINT "Press a key for continye "
200 SOUND 37, .1
210 A$ = INKEY$: IF A$ = "" THEN 200
220 CLOSE : GOTO 250
230 IF ERR = ERR THEN PRINT "Dos:errror ": END
240 RESUME
250 CLS : SCREEN 2
260 ON ERROR GOTO 220
270 OPEN "prugun.pic" FOR INPUT AS #1
280 PSET (160, 100), 1
290 WHILE NOT (EOF(1))
300 INPUT #1, A$
310 DRAW "X" + VARPTR$(A$)
320 WEND:                                             
330 CLOSE : GOTO 360
340 IF ERR = ERR THEN PRINT "Dos:errror ": END
350 RESUME
360 GET (155, 88)-(222, 133), PR
370 CLS
380 ON ERROR GOTO 0
390 OPEN "fon.pic" FOR INPUT AS #1
400 PSET (160, 100), 1
410 WHILE NOT (EOF(1))
420 INPUT #1, A$
430 DRAW "X" + VARPTR$(A$)
440 WEND:                                            
450 CLOSE : PSET (160, 100), 0: GOTO 470
460 RESUME
470 X = 10: Y = 140: S = 140
480 PUT (X, Y), PR, XOR
490 B = 2 * INT(RND(1) * 10) + 1: LOCATE 25, 1: PRINT "Сила ветра ="; B; "см в сек";
500 LOCATE 1, 1: INPUT "  Высота :", A
510  A = A * (RND / .5)
520 FOR I = 1 TO A STEP .5: S = S - 1
530 IF S = 1 THEN 580 ELSE PUT (I, S), PR, PSET
540 NEXT I
550 LOCATE 25, 1: PRINT "Вы прыгнули на "; A; "Метров            ";
560 A$ = INKEY$: IF A$ = "" THEN 560
570 GOTO 370
580 LOCATE 25, 1: PRINT "Вы прыгнули на "; A; "Метров и сильно стукнулись бошкой";
590 PLAY "mbl64t255o1ba#ag#gf#fed#dc#cc#dd#eff#gg#aa#b"
600 PLAY "mbl64t255o2ba#ag#gf#fed#dc#cc#dd#eff#gg#aa#b"
610 PLAY "mbl64t255o3ba#ag#gf#fed#dc#cc#dd#eff#gg#aa#b"
620 PLAY "mbl64t255o4ba#ag#gf#fed#dc#cc#dd#eff#gg#aa#b"
630 PLAY "mbl64t255o5ba#ag#gf#fed#dc#cc#dd#eff#gg#aa#b"
640 PLAY "mbl64t255o6ba#ag#gf#fed#dc#cc#dd#eff#gg#aa#b"
650 A$ = INKEY$: IF A$ = "" THEN 650
660 GOTO 370
