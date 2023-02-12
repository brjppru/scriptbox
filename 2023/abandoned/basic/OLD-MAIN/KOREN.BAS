SCREEN 9
FOR x1 = 0 TO 150
x2 = 120 + 100 * SIN(x1 / 30)
x3 = 90 + 100 * COS(x1 / 30)
LINE (x1, x2)-(x1, x2), 1
NEXT x1

