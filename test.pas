// este archivo tiene codigo el cual se utiliza para enteder los algoritmos
program test;
type
  
    persona = record
        dni: Integer;
        edad: integer;
        nombre: String;
        apellido: string;
    end;
      archivo = file of persona;





procedure MostrarArchivo(var arch:archivo);
var 
    p: persona;
begin
  reset(arch);
  while not Eof(arch) do
  begin
      Read(arch, p);
     with p do WriteLn (nombre, apellido, dni, edad);
  end;
  Close(arch);
end;
var
    arch:archivo;
    archT: text;
    p1: persona;
begin
    Assign(arch, 'test');
    Assign(archT, 'testText');
    Rewrite(arch);
    Reset(archT);
    while (not eof(archT)) do
    begin
        with p1 do ReadLn (archT,edad,dni,nombre,apellido); 
        write (arch, p1);
    end;
    Close(archT);
    Close(arch);
    MostrarArchivo(arch);

end.