program test;
type
    archivo = file of integer;


procedure MostrarArchivo(var arch:archivo);
var 
    num: Integer;
begin
  reset(arch);
  while not Eof(arch) do
  begin
      Read(arch, num);
      WriteLn(num);
  end;
  Close(arch);
end;

var
    arch:archivo;
    i,count:integer;
begin
    Assign(arch, 'test');
    Rewrite(arch);
    write (arch, 1);
    write (arch, 1);
    write (arch, 2);
    close(arch);

    Reset(arch);
    Read(arch,i);
    while (not eof(arch) ) and (i <> 2) do
    begin
      Read(arch,i);
      count:=filePos(arch);
    end;
    WriteLn(count);
    seek(arch, count);
    write(arch,12);
    close(arch);    
    MostrarArchivo(arch);
end.