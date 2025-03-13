program ejer2;
type
    archivo = file of integer;


procedure CrearArchivo(var arch:archivo; nombreArch: string); 
begin
  Assign(arch, nombreArch);
  Rewrite(arch);
end;
procedure InformarDatos(var arch:archivo);
var 
    num,todoNum,cantNumMenores: Integer;
begin
   cantNumMenores:= 0;
   todoNum:= 0;
  reset(arch);
  while not Eof(arch) do
  begin
      Read(arch, num);
      if(num < 1500) then
        cantNumMenores:= cantNumMenores +1;
      todoNum:= todoNum + num;
      WriteLn(num);
  end;
  WriteLn('promedio de todos los numeros: ', todoNum div FileSize(arch));
  Close(arch);
  WriteLn('Cantidad de numeros menores a 1500: ', cantNumMenores);
 

end;
procedure  CargarArchivo(var arch: archivo);
var 
    numero: integer;
begin
  WriteLn('ingrese el numero que quiera ingresar');
  ReadLn(numero);
  reset(arch);
  while numero <> 3000 do
  begin
     write (arch, numero);
     WriteLn('ingrese el numero que quiera ingresar');
     ReadLn(numero);
  end;
  Close(arch);
end;

var
    arch: archivo;
    nombreArch: String;
begin
  WriteLn('ingrese el nombre del archivo');
  ReadLn(nombreArch);
  CrearArchivo(arch,nombreArch);
  CargarArchivo(arch);
  InformarDatos(arch);
end.