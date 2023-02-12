10 ON ERROR GOTO 30
20 OPEN "z.tmp" FOR OUTPUT AS #1
30 IF ERL = 20 THEN END
40 FOR i = 1 TO 25
50 FOR j = 1 TO 80
60 x = SCREEN(i, j)
70 PRINT #1, x
80 IF i > 1 THEN LOCATE 1, 1: PRINT i; " "; j;
90 NEXT j
100 NEXT i
110 CLOSE
120 CLS

SCREEN 7
 CIRCLE (190, 140), 7, 6, , , 1.5
 CIRCLE (188, 137), 1, 14
 CIRCLE (192, 137), 1, 14
 LINE (190, 137)-(190, 141), 1
 LINE (188, 143)-(192, 143), 3
 LINE (205, 145)-(175, 145), 14
 LINE -(205, 175), 14
 LINE (205, 145)-(175, 175), 14
 LINE (175, 145)-(170, 150), 4
 LINE (205, 145)-(210, 150), 4
 PAINT (190, 150), 14









PLAY "mbl64t255o1ba#ag#gf#fed#dc#cc#dd#eff#gg#aa#b"
PLAY "mbl64t255o2ba#ag#gf#fed#dc#cc#dd#eff#gg#aa#b"
PLAY "mbl64t255o3ba#ag#gf#fed#dc#cc#dd#eff#gg#aa#b"
PLAY "mbl64t255o4ba#ag#gf#fed#dc#cc#dd#eff#gg#aa#b"
PLAY "mbl64t255o5ba#ag#gf#fed#dc#cc#dd#eff#gg#aa#b"
PLAY "mbl64t255o6ba#ag#gf#fed#dc#cc#dd#eff#gg#aa#b"

PLAY "mbl64t255o6ba#ag#gf#fed#dc#cc#dd#eff#gg#aa#b"
PLAY "mbl64t255o5ba#ag#gf#fed#dc#cc#dd#eff#gg#aa#b"
PLAY "mbl64t255o4ba#ag#gf#fed#dc#cc#dd#eff#gg#aa#b"
PLAY "mbl64t255o3ba#ag#gf#fed#dc#cc#dd#eff#gg#aa#b"
PLAY "mbl64t255o2ba#ag#gf#fed#dc#cc#dd#eff#gg#aa#b"
PLAY "mbl64t255o1ba#ag#gf#fed#dc#cc#dd#eff#gg#aa#b"
PLAY "mbl64t255o0ba#ag#gf#fed#dc#cc#dd#eff#gg#aa#b"

    Music$ = "MBT180o0P2P8L8GGGL2E-P24P8L8FFFL2D"
    PLAY Music$
    Music$ = "MBT180o1P2P8L8GGGL2E-P24P8L8FFFL2D"
    PLAY Music$
    Music$ = "MBT180o2P2P8L8GGGL2E-P24P8L8FFFL2D"
    PLAY Music$
    Music$ = "MBT180o3P2P8L8GGGL2E-P24P8L8FFFL2D"
    PLAY Music$
    Music$ = "MBT180o4P2P8L8GGGL2E-P24P8L8FFFL2D"
    PLAY Music$
    Music$ = "MBT180o3P2P8L8GGGL2E-P24P8L8FFFL2D"
    PLAY Music$
    Music$ = "MBT180o2P2P8L8GGGL2E-P24P8L8FFFL2D"
    PLAY Music$



1000 ON ERROR GOTO 3000
2000 OPEN "z.tmp" FOR INPUT AS #1
3000 IF ERL = 2000 THEN END
4000 FOR i = 1 TO 25
5000 FOR j = 1 TO 80
6000 INPUT #1, x
7000 LOCATE i, j: PRINT CHR$(x);
8000 NEXT j
9000 NEXT i
CLOSE
KILL "z.tmp"









































