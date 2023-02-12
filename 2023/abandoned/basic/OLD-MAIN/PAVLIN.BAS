SCREEN 9
FOR x1 = 0 TO 190
x2 = 120 + 100 * SIN(x1 / 30)
x3 = 90 + 100 * COS(x1 / 30)
LINE (x1, 200)-(x2, x3), 1
NEXT

