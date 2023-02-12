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
end.



