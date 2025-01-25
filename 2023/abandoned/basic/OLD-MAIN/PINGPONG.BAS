DEFINT A-Z
DIM pong(1000)
DIM paddle(1000)
l$ = CHR$(0) + "K"
R$ = CHR$(0) + "M"
U$ = CHR$(0) + "H"
D$ = CHR$(0) + "P"
Dl$ = CHR$(0) + "O"
UR$ = CHR$(0) + "I"
DR$ = CHR$(0) + "Q"
UL$ = CHR$(0) + "G"
DATA 60,60,66,66,60,72,54,66
CLICKS = 240
pincr = 4
tinc = 3
SCREEN 13
wx = 20
WY = 20
wx1 = 300
WY1 = 180
midy = 20 + (WY1 - WY) / 2
MIDX = 20 + (wx1 - WY) / 2
start! = TIMER
DO
CLS
BS = INT(((50 - 20) + 1) * RND + 20)
GOSUB DRAWTABLE
REDIM x(4), y(4)
RESTORE
FOR J = 1 TO 4
READ x(J)
READ y(J)
NEXT
PSET (x(1), y(1)), 1
DRAW "F6G6H6E6BD2P14,1"
GET (x(4), y(1))-(x(2), y(3)), pong
LINE (x(4), y(1))-(x(2), y(3)), 0, BF
x = x(4)
y = y(1)
cdeep = (y(3) - y(1)) + 1
cwide = (x(2) - x(4)) + 1
padx = 160
pady = 100
GOSUB makepad
GOSUB display
pingx = tinc
pincy = tinc
DO
x$ = INKEY$
IF LEN(x$) THEN IF LEN(x$) = 2 THEN GOSUB movepaddle
IF x = "P" THEN IF pincr < 20 THEN pincr = pincr + 1
IF x = "p" THEN IF pincr > 1 THEN pincr = pincr - 1
IF x = "C" THEN IF tinc < 20 THEN tinc = tinc + 1
IF x = "c" THEN IF pincr > 1 THEN tinc = tinc + 1
GOSUB display
END IF
IF x(2) > wx1 OR x(4) < wx THEN IF y(1) > midy - 15 AND y(3) < midy + 15 THEN score = score + 1: start! = start! + 15: SOUND 200, 1: SOUND 400, 1: SOUND 600, 1: SOUND 800, 1
EXIT DO
END IF
END IF
GOSUB movepong
GOSUB collide
curtime! = TIMER
etime! = curtime! - start!
IF etime! > 240 THEN exitgame = 1: EXIT DO
LOCATE 25, 30: PRINT "Time:"; 240 - INT(etime!);
LOOP
IF exitgame THEN exitgame = 0
CLS : LOCATE 12, 17: PRINT " Game over"
score = 0
click = 240
start! = TIMER
END IF
LOOP
CLS : END
movepong:
seed = INT(((5 - (-5) + 1) * RND(1) + (-5)))
IF x < wx THEN x(4) = wx: x(3) = wx + 6
x(2) = wx1: x(1) = wx1 - 6
x = wx
pingx = tinc
pingy = tinc + seed
END IF




