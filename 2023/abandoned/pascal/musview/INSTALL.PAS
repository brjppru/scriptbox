uses crt,dos;

procedure copyscreen;
 external;
{$l copy.obj}
const
  j:pointer=addr(copyscreen);

function Ir(i: Longint): string;
var s: string[11];
begin
  {$I-}
  Str(i, s);
  Ir := s;
end;

procedure color(X1, Y1: integer);
begin
  {$I-}
  textcolor(X1);
  TextBackground(y1);
end;

procedure text(X, Y: integer; S: string);
begin
  {$I-}
  GotoXY(X, Y);
  Write(S);
end;

PROCEDURE space(a:integer);
var c:integer;
begin
  {$I-}
for c:=1 to a do write(' ');
end;

PROCEDURE box(c1,r1,c2,r2:integer);
var
a,b: Integer;
begin
  {$I-}
gotoxy(c1,r1);
write('╔');
for a:=(c1+1) to (c2-1) do write('═');
write('╗');
gotoxy(c1,r2);
write('╚');
for a:=(c1+1) to (c2-1) do write('═');
write('╝');

for a:=(r1+1) to (r2-1) do
begin
gotoxy(c1,a);
write('║');
space(c2-c1-1);
write('║');
end;
end;

procedure cf(file1,file2:string);
var
  FromF, ToF: file;
  NumRead, NumWritten: Word;
  buf: array[1..2048] of Char;
begin
  Assign(FromF, file1);
  { Record size = 1 }
  Reset(FromF, 1);
  { Open output file }
  Assign(ToF, file2);
  { Record size = 1 }
  Rewrite(ToF, 1);
  WriteLn('Копирую ', file1,' в ',file2,' размер ', FileSize(FromF),' байт...');
  repeat
    BlockRead(FromF,buf,SizeOf(buf),NumRead);
    BlockWrite(ToF,buf,NumRead,NumWritten);
  until (NumRead = 0) or (NumWritten <> NumRead);
  Close(FromF);
  Close(ToF);
end;


var a,b,c,d:integer;
    s,s1,s2,s3,s4,s5,s6,s7,s8,s9:string;
  var f:file of integer;
    z:integer;
     u:array[1..8] of word;

label 1,2,3,4,5,6,1000;
begin
  {$I-}

textcolor(15);
TextBackground(0);
clrscr;
move(j^,mem[$b800:0],4000);

text(2,2,'MUSWIEV версия 3.00 (C)Copyrigth Bogdanov Roman');
text(2,3,'───────────────────────────────────────────────');


text(25,17,'П Р Е Д С Т А В Л Я Е Т ');
text(7,19,'Программу для прослушивания музыкальных файлов программы MUSMAKER');
textcolor(15);
color(7,0);
text(30,25,'Нажмите ENTER <┘');
repeat
until  KEYPRESSED;
1:
color(15,9);
clrscr;
text(2,2,'MUSWIEV версия 3.00 (C)Copyrigth Bogdanov Roman');
text(2,3,'───────────────────────────────────────────────');

text(3,10,'Введите диск на который вы хотите инсталлировать программу MUSMAKER :');


2:
gotoxy(40,11);
write('Введите букву диска (C-E):');

readln(s);
 for a := 1 to Length(s) do
  s[a] := UpCase(s[a]);

if s='C' then d:=3;
if s='D' then d:=4;
if s='E' then d:=5;
if s='' then goto 1;
if diskfree(d)=-1 then begin color(31,4); writeln('В Вашей системе нет диска ',s,' !'); end else goto 3;
goto 1;

3:
color(15,9);
clrscr;
text(2,2,'MUSWIEV версия 3.00 (C)Copyrigth Bogdanov Roman');
text(2,3,'───────────────────────────────────────────────');
gotoxy(2,9);
if d=3 then s:='C';
if d=4 then s:='D';
if d=5 then s:='E';

s1:=s+':\mus30';

  {$I-}

  mkdir(s1);
  if IORESULT<>0 then writeln;

  s5:=s1+'\musview.exe';
  getdir(0,s6);
  s7:=s6+'\musview.exe';
  cf(s7,s5);
  if IORESULT<>0 then writeln;

    s5:=s1+'\musview.me';
  getdir(0,s6);
  s7:=s6+'\musview.me';
  cf(s7,s5);
  if IORESULT<>0 then writeln;

z:=0;
u[1]:=mem[61440:65525];
u[2]:=mem[61440:65526];
u[3]:=mem[61440:65527];
u[4]:=mem[61440:65528];
u[5]:=mem[61440:65529];
u[6]:=mem[61440:65530];
u[7]:=mem[61440:65531];
u[8]:=mem[61440:65532];

for a:=1 to 8 do
begin
z:=z+u[a];
end;

  s9:=s1+'\musview.set';
  assign(f,s9);
  rewrite(f);
  write(f,z);
  close(f);
  if IORESULT<>0 then writeln;


color(7,0);
clrscr;
writeln('MUSVIEW установлен .');
goto 5;


1000:
color(31,4);
text(30,12,'     Ошибка !      ');
text(30,13,'  Инсталл прерван  ');
5:

end.