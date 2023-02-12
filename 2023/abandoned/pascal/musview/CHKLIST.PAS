uses Dos,crt;
var S: PathStr;
var f:file;
var k:integer;
label 10,20;
begin
clrscr;
textcolor(15);
TEXTBACKGROUND(1);
writeln('╔═════════════════════════════════╗');
writeln('║ (C) Центр Самоходнопередвижного ║');
writeln('║      Програмого обеспечения     ║');
writeln('║        Имени Дяди Вункиса       ║');
writeln('╚═════════════════════════════════╝');
TEXTBACKGROUND(0);
textcolor(7);
writeln;
writeln('CHKLIST.EXE версия 1.00');
writeln('Программа для удаления файлов CHKLIST.MS доступных через PATH.');
writeln('Посвещается моему другу который их не переваривает .');
writeln('Поиск и удаление файлов:');
writeln;
k:=0;
10:

  S := FSearch('chklist.ms',GetEnv('PATH'));
  if S = '' then
    begin
    goto 20;
    end

    else
    k:=k+1;
    begin
    Write(FExpand(S));
    assign(f,FExpand(S));
    Erase(f);
    writeln(' - удален !');
    goto 10;
    end;
20:
writeln;
WriteLn('Файлов chklist.ms было найдено и удаленно :',k);
end.

