uses Dos,crt;
var S: PathStr;
var f:file;
var k:integer;
label 10,20;
begin
clrscr;
textcolor(15);
TEXTBACKGROUND(1);
writeln('浜様様様様様様様様様様様様様様様様�');
writeln('� (C) �キ矗 ����絎き��ムイ※Ν��� �');
writeln('�      蹍������� �．甎ョキ��     �');
writeln('�        ��キ� �錣� �祗����       �');
writeln('藩様様様様様様様様様様様様様様様様�');
TEXTBACKGROUND(0);
textcolor(7);
writeln;
writeln('CHKLIST.EXE ▲珀�� 1.00');
writeln('蹍������ か� 磴��キ�� ������ CHKLIST.MS ぎ痰祚�諷 腑爛� PATH.');
writeln('��瓣ラ�モ瘴 ��ガ� む磽� ��皰琺� �� �� �ムア�爬��モ .');
writeln('���瓷 � 磴��キ┘ ������:');
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
    writeln(' - 磴��キ !');
    goto 10;
    end;
20:
writeln;
WriteLn('������ chklist.ms °�� ���ぅ�� � 磴��キ�� :',k);
end.

