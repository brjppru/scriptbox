DATA "Bogdanov Roman","Present ...","Game ","Special","All Right reserved"
DATA "Graphics","Bogdanov Roman","Sound","Bogdanov Roman","Special effect "
DATA "(C)Copyrigth 1994","Pusic&Bogdanov Roman","If you wont have new version"
DATA "This Game call me","All call Confidencal"
SCREEN 13
k = 0
1 k = k + 1
IF k = 16 THEN COLOR 7: GOTO 10
READ a$
FOR i = 16 TO 31
COLOR i
'FOR j = 1 TO 500: NEXT j
LOCATE 13, INT(20 - LEN(a$) / 2): PRINT a$
NEXT
FOR i = 31 TO 16 STEP -1
COLOR i
'FOR j = 1 TO 500: NEXT j
LOCATE 13, INT(20 - LEN(a$) / 2): PRINT a$
NEXT
GOTO 1
10 CLS

