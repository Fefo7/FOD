program ejer1;
type
    archivo = file of integer;


procedure CrearArchivo(var arch:archivo; nombreArch: string); 
begin
  Assign(arch, nombreArch);
  Rewrite(arch);
end;

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
    arch: archivo;
    numero: Integer;
    nombreArch: String;
begin
  WriteLn('ingrese el nombre del archivo');
  ReadLn(nombreArch);

  CrearArchivo(arch, nombreArch);

  WriteLn('ingrese el numero que quiera ingresar');
  ReadLn(numero);
  while numero <> 3000 do
  begin
     write (arch, numero);
     WriteLn('ingrese el numero que quiera ingresar');
     ReadLn(numero);
  end;
  Close(arch);

  MostrarArchivo(arch); // solo para testear el ejecicio
end.