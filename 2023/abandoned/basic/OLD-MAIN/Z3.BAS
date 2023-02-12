FileErr1:
   CLS
   PRINT "      Неверное имя файла": PRINT
   INPUT "      Новое имя файла ввода (ENTER - для окончания): ", InputFile$
   IF InputFile$ = "" THEN END
	resume
