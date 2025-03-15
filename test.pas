// este archivo tiene codigo el cual se utiliza para enteder los algoritmos
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
    i:integer;
begin
    Assign(arch, 'test');
    Rewrite(arch);
    write (arch, 1);
    write (arch, 2);
    write (arch, 1);
    close(arch);

    Reset(arch);
    Read(arch,i);
    while (not eof(arch) ) and (i <> 2) do
    begin
      Read(arch,i);
    end;
    seek(arch, filepos(arch) -1);
    write (arch, 10);
    close(arch);    
    MostrarArchivo(arch);
end.