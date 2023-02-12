10 REM Ž‹…’ ‘’…‹› ‘ €„…ˆ…Œ
20 INPUT "‚‚…„ˆ’… ‚…ŒŸ Ž‹…’€ 1-23"; t
IF t > 24 THEN 20
30 SCREEN 9
40 CLS : z1 = 1
50 CIRCLE (10, 50), 20, , -1.5 * 3.14, -3.14 / 2
60 FOR I = 0 TO t STEP 1 / 10
70 X = 10 + 80 * I
80 Y = 50 + 9.8 * I ^ 2
90 LINE (X, Y)-(X + 40, Y), 5
100 LINE -(X + 37, Y - 3), 14
110 LINE (X + 37, Y + 3)-(X + 40, Y)
120 FOR Z = 1 TO 600: '§a¢¨ca­¨e
130 NEXT Z
140 LINE -(X, Y), 0
150 LINE (X + 37, Y - 3)-(X + 40, Y), 0
160 LINE -(X + 37, Y + 3), 0
170 NEXT I
180 CLS
190 END

