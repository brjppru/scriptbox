 Program Muson;
 Uses Music,crt;
 var f:file;
     s:string;
     p:pointer;
     l:longint;
     i:integer;
 begin
 if paramstr(1)='' then begin write('File name? '); readln(s);end
 else s:=paramstr(1);
 assign(f,s);
 reset(f,1);
 l:=FileSize(f);
 GetMem(p,word(l));
 BlockRead(f,p^,word(l));
 Close(f);
 SetMusic(p^);
 RunMusic(1,SizeMusic);
 repeat
 until (WhereMusic=0) or keypressed;
 HaltMusic;
 end.