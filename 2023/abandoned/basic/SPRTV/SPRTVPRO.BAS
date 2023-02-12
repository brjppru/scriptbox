CLS
110 OPEN "sprtv.fil" FOR INPUT AS #1
130 LOCATE 1, 1: LINE INPUT #1, film$(1)
150 LOCATE 1, 1: LINE INPUT #1, f$
690 COLOR 14
j$ = f$ + " "
A = LEN(j$)
FOR i = 1 TO A STEP .5
j$ = RIGHT$(f$ + " ", i)
FOR t = 1 TO 100: NEXT t
730 LOCATE 9, 41 - LEN(j$) / 2: PRINT j$
NEXT

