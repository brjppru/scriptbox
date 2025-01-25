var f:file of integer;
    z:integer;
begin
assign(f,'d:\musmaker.set');
reset(f);
read(f,z);
close(f);
writeln(z);
end.