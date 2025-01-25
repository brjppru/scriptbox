10 GOSUB ZAST
30 COLOR 7, 0
50 'CLS
70 WIDTH 80
90 SCREEN 0, 0, 2
110 OPEN "sprtv.fil" FOR INPUT AS #1
130 LOCATE 1, 1: LINE INPUT #1, film$(1)
150 LOCATE 1, 1: LINE INPUT #1, film$(2)
170 LOCATE 1, 1: LINE INPUT #1, film$(3)
190 LOCATE 1, 1: LINE INPUT #1, film$(4)
210 LOCATE 1, 1: LINE INPUT #1, film$(5)
230 LOCATE 1, 1: LINE INPUT #1, film$(6)
250 COLOR 10
270 LOCATE 1, 1: PRINT "╔═══════════════╗"
290 LOCATE 2, 1: PRINT "║               ║"
310 LOCATE 3, 1: PRINT "║               ║"
330 LOCATE 4, 1: PRINT "║               ║"
350 LOCATE 5, 1: PRINT "╚═══════════════╝"
370 COLOR 15, 1
390 LOCATE 2, 2: PRINT "             "
410 LOCATE 3, 2: PRINT "  6 Канал    "
430 LOCATE 4, 2: PRINT "             "
450 COLOR 15, 0
470 LOCATE 2, 15: PRINT "▒▒"
490 LOCATE 3, 15: PRINT "  "
510 LOCATE 4, 15: PRINT "  "
530 LOCATE 1, 20: COLOR 10, 1: PRINT " Студия кабелного телевидения "; : COLOR 15, 13: PRINT " Красный Скорпио "
550 LOCATE 3, 25: COLOR 11, 12: PRINT "Программа фильмов на "; DATE$
570 LOCATE 6, 1: COLOR 15, 4: PRINT "╔": LOCATE 6, 80: PRINT "╗"
590 LOCATE 22, 1: COLOR 15, 4: PRINT "╚": LOCATE 22, 80: PRINT "╝"
610 FOR i = 2 TO 79: LOCATE 6, i: PRINT "═": LOCATE 22, i: PRINT "═"; : NEXT
630 FOR i = 7 TO 21: LOCATE i, 1: PRINT "║": LOCATE i, 80: PRINT "║"; : NEXT
650 COLOR 15, 0: COLOR 0, 1
670 FOR i = 7 TO 21: LOCATE i, 2: PRINT STRING$(78, " "); : NEXT
690 COLOR 14: GOSUB 8000: GOTO 830
710 LOCATE 7, 41 - LEN(film$(1)) / 2: PRINT film$(1)
730 LOCATE 9, 41 - LEN(film$(2)) / 2: PRINT film$(2)
750 LOCATE 11, 41 - LEN(film$(3)) / 2: PRINT film$(3)
770 LOCATE 13, 41 - LEN(film$(4)) / 2: PRINT film$(4)
790 LOCATE 15, 41 - LEN(film$(5)) / 2: PRINT film$(5)
810 LOCATE 17, 41 - LEN(film$(6)) / 2: PRINT film$(6)
830 LOCATE 19, 26.5: PRINT "П Р И Я Т Н О Г О  О Т Д Ы Х А"
850 COLOR 15, 0: COLOR 14
870 A$ = "                                                                           Принимаем плату от обонентов   с 1 октября 1000 рублей                                                                              наш адрес Мате-Залка  2 - 152 "
890 col = 14: paws = 600: GOSUB runline
910 A$ = "                                                                           Резину 8 , 40 х 15 с дисками 5 штук Тел (232) 23-72-63                      "
930 col = 3: paws = 500: GOSUB runline
950 A$ = "                                                                             Постоянно в продаже жевательная РЕЗИНКА                   тел 21-62-73        "
970 col = 10: paws = 400: GOSUB runline








4999 GOTO 870
END

runline:
5000 b$ = RIGHT$(A$, LEN(A$))
5020 i = LEN(b$)
5040 i = i - 1
5060 COLOR col: LOCATE 23, 80: PRINT MID$(RIGHT$(b$, i), 1, 79);
5080 COLOR 15: LOCATE 1, 72: PRINT " "; TIME$
5100 FOR j = 1 TO paws: NEXT j
5120 IF NOT INKEY$ = "" THEN i = 1
5140 IF i = 1 THEN RETURN
5160 GOTO 5040

ZAST:
5180 CLS
5200 LOCATE 3, 10: COLOR 10: PRINT "Sprtv Version 1.1 (C)Copyrigth 1994 ,Bogdanov Roman"
5220 LOCATE 5, 10: COLOR 14: PRINT "Edit films "; : COLOR 15: PRINT "instrykcion : "
5240 LOCATE 7, 10: COLOR 10: PRINT "You cant swap name films in file Sprtv.fil"
5260 LOCATE 9, 10: COLOR 14: PRINT "Edit Runner line "; : COLOR 15: PRINT "instrykcion : "
5280 LOCATE 11, 10: COLOR 10: PRINT "You enter a$="; CHR$(34); "82 spase and text "; CHR$(34);
5300 LOCATE 13, 10: COLOR 10: PRINT "col=number color (1-15)   and paws= pause runline "
5320 LOCATE 15, 10: COLOR 10: PRINT "Go sub runline"
5340 LOCATE 20, 10: PRINT "Press any key for continye  ......."
5360 COLOR 4, 0
5380 co = 1
5400 A$ = "*    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    "
5420 WHILE INKEY$ <> "": WEND 'Очищает буфер клавиатуры
5440 WHILE INKEY$ = ""
5460 FOR A = 1 TO 5
5480 co = co + 1: IF co = 15 THEN co = 1
5500 COLOR co
5520 LOCATE 1, 1                     'печатает горизонтальные звездочки
5540 PRINT MID$(A$, A, 80);
5560 LOCATE 22, 1
5580 PRINT MID$(A$, 6 - A, 80);
5600 FOR b = 2 TO 21                 'печатает вертикальные звездочки
5620 COLOR co
5640 c = (A + b) MOD 5
5660 IF c = 1 THEN
5680 LOCATE b, 80
5700 PRINT "*";
5720 LOCATE 23 - b, 1
5740 PRINT "*";
5760 ELSE
5780 LOCATE b, 80
5800 PRINT " ";
5820 LOCATE 23 - b, 1
5840 PRINT " ";
5860 END IF
5880 NEXT b
5900 NEXT A
5920 WEND
5940 RETURN

8000 COLOR 14
8010 FOR s = 7 TO 17 STEP 2: f = f + 1
8020 A = LEN(film$(f)) + 2
8030 FOR i = 1 TO A STEP .5
8040 A$ = INKEY$
8050 IF NOT A$ = "" THEN i = A - 1
8070 j$ = RIGHT$(film$(f) + " ", i)
8080 FOR t = 1 TO 100: NEXT t
8090 LOCATE s, 41 - LEN(j$) / 2: PRINT j$
8100 NEXT i
8110 NEXT s
8120 RETURN

