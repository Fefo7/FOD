program Ejer12_25;
type
    acceso= record
        anio:integer;
        mes:Integer;
        dia:Integer;
        idUsuario: Integer;
        tiempoAcceso: Real;
    end;
    arch= file of acceso; 
procedure AsignarMaestro(var m: arch);
var 
    nombre: String;
begin
  WriteLn('ingrese el nombre del maestro');
  ReadLn(nombre);
  Assign(m,nombre);
end;
procedure ProcesarDatos(var mae:arch;anio: Integer);
begin
  
end;
var
    mae: arch;
    anio:Integer;
begin
    AsignarMaestro(mae);
    WriteLn('ingrese el anio que quiere imprimir');
    ReadLn(anio);
    ProcesarDatos(mae,anio);
end.