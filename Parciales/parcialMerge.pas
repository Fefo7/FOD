program parcialMerge;
const
    maxDet= 5;
    valorAlto= 999;
type
    carrera = record
        dni: Integer;
        nombre: String;
        apellido: String;
        kms: real;
        gano: byte; // 1 gano / 0 perdio
    end;
    maestro = record
        dni: Integer;
        nombre: String;
        apellido: String;
        kmsTotales: real;
        carrerasGanadas: Integer;
    end;
    archDetalle = file of carrera;
    archMaestro = file of maestro;
    vecDet= array[1..maxDet] of archDetalle;
    vecRegDet = array[1..maxDet] of carrera;
var
    mae: archMaestro;
    vecDetalles: vecDet;

procedure CrearMaestro();
begin
  Assign(mae, 'maestro.dat');
  Rewrite(mae);
  Close(mae);  //lo cierro porque queda abierto luego del rewrite    
end;
procedure CrearDetalles();
var
    i:Integer;
    nombre: String;
begin
    for i:= 1 to maxDet do
    begin
      WriteLn('ingrese el nombre');
      ReadLn(nombre);
      Assign(vecDetalles[i],nombre);
    end;
end;
procedure leer(var arch:archDetalle; var dato: carrera);
begin
  if(not eof(arch)) then
    Read(arch, dato)
  else
    dato.dni:= valorAlto;
end;
procedure  LeerDetalles(var regsDetalles:vecRegDet);
var
    i:Integer;
begin
  for i:=1 to maxDet do
    begin
      leer(vecDetalles[i], regsDetalles[i]);
    end;
end;
procedure CalcularMinimo(var regsDetalles: vecRegDet; var minimo: carrera);
var
   i,pos:integer;
begin
  minimo.dni:= valorAlto;
  for i:=1 to maxDet do
  begin
     if regsDetalles[i].dni < minimo then
     begin
       minimo:= regsDetalles[i].dni;
       pos:= i;
     end;
  end;
  if(minimo.dni<> valorAlto)then
    leer(vecDetalles[pos], regsDetalles[i]);
    
end;
procedure ProcesarDatos(var regsDetalles:vecRegDet);
var
    i:Integer;
    minimo: carrera;
    regMae:maestro;
begin
    for i:=1 to maxDet do
        Reset(vecDetalles[i]);
    Reset(mae);
    LeerDetalles(regsDetalles);
    CalcularMinimo(regsDetalles, minimo);
    while (minimo.dni <> valorAlto) do
    begin
        regMae.dni:= minimo.dni;
        regMae.nombre:= minimo.nombre;
        regMae.apellido:= minimo.apellido;
        regMae.kmsTotales:= 0;
        regMae.carrerasGanadas:= 0;
        while (minimo.dni = regMae.dni) do
        begin
            regMae.kmsTotales:= regMae.kmsTotales+ minimo.kms;
            if(minimo.gano = 1)then
                regMae.carrerasGanadas:= regMae.carrerasGanadas+1;
            CalcularMinimo(regsDetalles, minimo); 
        end;
        Write (mae, regMae);
    end;
    for i:=1 to maxDet do
        Close(vecDetalles[i]);
    Close(mae);

end;

var
    regsDetalles: vecRegDet;
begin
  CrearDetalles();
  CrearMaestro();
  ProcesarDatos(regsDetalles);

end.