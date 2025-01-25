        SCREEN 9
1       CLS
        LINE (130, 50)-(300, 80), 7, BF
        LINE (130, 150)-(300, 180), 7, BF
        LINE (0, 150)-(130, 180), 8, BF
        LINE (0, 50)-(50, 80), 8, BF
        LINE (280, 80)-(300, 110), 6, BF
        LINE (280, 120)-(300, 150), 6, BF
        LINE (0, 81)-(50, 149), 4, BF
        FOR k = 1 TO 80
                LINE (52, k)-(122, k + 69), 1, BF
                LINE (52, 1)-(122, k), 0, BF
        NEXT
        FOR l = 50 TO 211
                LINE (50, 81)-(l, 149), 4, BF
                LINE (l, 82)-(l + 68, 149), 1, BF
        NEXT
                y1 = 149
                x = 210
                x1 = 279
                FOR y = 82 TO 149
                y1 = y1 - 1
                x = x + 1
                x1 = x1 - 1
                LINE (x, y)-(x1, y1), 3, B
                        FOR d = 1 TO 200
                                p = d
                        NEXT d
       
        NEXT

        FOR n = 200 TO 270
                LINE (n, 81)-(279, 149), 3, BF
                i = i + 4
                LINE (279, 110)-(n + 79 + i, 120), 3, BF
                LINE (200, 81)-(n, 149), 4, BF
        NEXT
        FOR r = 270 TO 50 STEP -1
                LINE (270, 81)-(r, 149), 0, BF
                 
        NEXT
'       GOTO 1

