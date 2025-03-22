program Ejer1;
const 
    valorMinimo= -1;
type
    EmpleadoDetalle= record
        cod: integer;
        nombre: string[30];
        montoComi: real;
    end;
    EmpleadoUni = record
        cod: integer;
        nombre:string;
        totalComi: real;
    end;
    
    archMaestro = file of EmpleadoUni;
    archDeta = file of EmpleadoDetalle;
procedure MostrarArchivo(var arch:archMaestro);
var 
    e: EmpleadoUni;
begin
  reset(arch);
  while not Eof(arch) do
  begin
      Read(arch, e);
      with e do WriteLn(cod, ' ', nombre, ' ', totalComi:3:2);
  end;
  Close(arch);
end;
procedure CrearArchivo(var arch: archMaestro);
begin
  Assign(arch, 'maestro1.dat');
  Rewrite(arch);
end;
procedure Leer(var arch:archDeta; var dato: EmpleadoDetalle);
begin
    if (not Eof(arch)) then
        Read(arch,dato)
    else
        dato.cod:= valorMinimo;
    
end;

procedure ProcesarDatos(var archDet: archDeta; var maestro: archMaestro);
var
    det: EmpleadoDetalle;
    newEmp: EmpleadoUni;
begin
  Reset(maestro);
  reset(archDet); 
  Leer(archDet,det);
  while (det.cod<> valorMinimo) do
  begin
    newEmp.cod:= det.cod;
    newEmp.nombre:= det.nombre;
    newEmp.totalComi:= 0.0;
    while (det.cod = newEmp.cod) do
    begin
      newEmp.totalComi:= newEmp.totalComi + det.montoComi;
      Leer(archDet, det);
    end;
    Write(maestro,newEmp);
  end;
  Close(maestro);
  Close(archDet);
end;
var
    archDet: archDeta;
    maestro: archMaestro;
    
begin
  Assign(archDet,'todosEmpelados1.dat');
  CrearArchivo(maestro);
  ProcesarDatos(archDet, maestro);
  MostrarArchivo(maestro); // test

end.