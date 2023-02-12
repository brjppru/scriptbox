CLS
PRINT "The animals (c)copyrigth 1995,bogdanov roman"
10 DIM b$(511), o$(511), P%(511, 4), P$(1): n = 1: m = 1: P = 1: o$(1) = "кот"
20 IF P = 0 THEN 120
30 i = 1: j = 1
40 IF b$(i) = "" THEN 60
50 PRINT ""; b$(i): GOSUB 130: j = P%(i, P + 3): i = P%(i, P + 1): GOTO 40
60 PRINT "Это "; o$(j): GOSUB 130
80 m = m + 1: INPUT "Кто зто :", o$(m)
90 PRINT "Чем "; o$(m); " отличается от "; o$(j): INPUT b$(i)
100 P%(i, 1) = n + 1: n = n + 2: P%(i, 2) = n: P%(i, 3) = j: P%(i, 4) = m
GOTO 20
120 END
130 IF INKEY$ = "" THEN LOCATE , , 1: GOTO 130
140 IF INKEY$ = "0" THEN P = 0
150 IF INKEY$ = "1" THEN P = 1
RETURN



