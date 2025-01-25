  COLOR 4, 0
  A$ = "*    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    "
  WHILE INKEY$ <> "": WEND 'Очищает буфер клавиатуры

  WHILE INKEY$ = ""
    FOR A = 1 TO 5
      LOCATE 1, 1                     'печатает горизонтальные звездочки
      PRINT MID$(A$, A, 80);
      LOCATE 22, 1
      PRINT MID$(A$, 6 - A, 80);

      FOR b = 2 TO 21                 'печатает вертикальные звездочки
        c = (A + b) MOD 5
        IF c = 1 THEN
          LOCATE b, 80
          PRINT "*";
          LOCATE 23 - b, 1
          PRINT "*";
        ELSE
          LOCATE b, 80
          PRINT " ";
          LOCATE 23 - b, 1
          PRINT " ";
        END IF
      NEXT b
    NEXT A
  WEND

