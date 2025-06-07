program  Ejer16_25;
const
    maxDet = 100;
    valorAlto= 999;
    FechaMinima= '';
type 
    semanarios = record
        fecha: string;
        codSem: integer;
        nombre: String;
        des: String;
        precio: real;
        totalEje: Integer;
        totalEjeVend: Integer;
    end;
    detalle= record
        fecha= string;
        codSem: Integer;
        cantEjeVend: Integer;
    end;
    archMaestro= file of semanarios;
    archDeta= file of detalle;
    vecDetalle= array[1..maxDet] of archDeta;
    vecRegDetalle = array[1..maxDet] of detalle;

procedure  CrearArchivos(var mae: archMaestro;var detalles: vecDetalle);
begin
  // se dipone
end;
procedure LeerDetalle (var archD: archDeta; var dato: detalle);
begin
  if(not Eof(archD))then
        read(archD,dato)
  else
    dato.codSem := valorAlto;
end;
procedure asignarMaestroYDetalle(var mae:archMaestro; var detalles:vecDetalle );
var
    nombre: string;
    i:integer;
begin
  WriteLn('ingrese el nombre del archivo maestro');
  ReadLn(nombre);
  Assign(mae, nombre);
  for i:=1 to maxDet do
  begin
    WriteLn('ingrese el nombre del detalle');
    ReadLn(nombre);
    Assign(detalles[i], nombre);
  end;
end;
procedure  LeerRegistrosDetalles(var detalles: vecDetalle; var regsDet:vecRegDetalle );
var
    i:Integer;
begin
    for i:= 1 to maxDet do
    begin
       LeerDetalle(detalles[I],regsDet[i]);
    end;
end;
procedure CalcularMinimoDetalles(var detalles:vecDetalle;var regsDet:vecRegDetalle;var minimo: detalle);
var
    i,pos:integer;
begin
    minimo.codSem:= valorAlto;
    minimo.fecha := FechaMinima;
    for i:=1 to maxDet do
    begin
        if (regsDet[i].fecha < minimo.fecha) or (regsDet[i].fecha = minimo.fecha) and (regsDet[i].codSem< minimo.codSem) then
        begin
          minimo:= regsDet[i];
          pos:= i;
        end;
     end;
    if(not EOf(detalles[pos]))then
    begin
        LeerDetalle(detalles[pos], regsDet[i]);
    end;
end;
procedure procesarDatos(var mae:archMaestro; var detalles:vecDetalle);
var
    regsDet: vecDetalle;
    regMae: semanarios;
    minimo: detalle;
    detMax, detMin: detalle;
    i:Integer;
begin
  Reset(mae);
  for i:=1 to maxDet do
  begin
     Reset(detalles);
  end;
  LeerRegistrosDetalles(detalles,regsDet);
  CalcularMinimoDetalles(detalles,regsDet, minimo);
  detMax.cantEjeVend:= -1;
  detMin.cantEjeVend:= 999;
  while (minimo.codSem <> valorAlto) do
  begin
    while (minimo.fecha <> regMae.fecha) and (minimo.codSem <> regMae.codSem)  do
        Read(mae, regMae);
    
    while (regMae.fecha = minimo.fecha) and (regMae.codSem =  minimo.codSem)  do
    begin
      regMae.totalEje:= regMae.totalEje  - minimo.cantEjeVend;
      regMae.totalEjeVend:= regMae.totalEjeVend +minimo.cantEjeVend;
      CalcularMinimoDetalles(detalles,regsDet, minimo);
    end;
    if(regMae.totalEjeVend > detMax.cantEjeVend)then
        detMax:= regMae;
    if(regMae.totalEjeVend < detMin.cantEjeVend)then
        detMin:= regMae;    
    Seek(regMae, FilePos(regMae)-1);
    Write(mae,regMae);
  end;

  WriteLn('Semario con mas ventas: ', detMax.codSem, 'total de: ', detMax.cantEjeVend, 'en la fecha: ', detMax.fecha);
  WriteLn('Semario con menos ventas: ', detMin.codSem, 'total de: ', detMin.cantEjeVend, 'en la fecha: ', detMin.fecha);

  Close(mae);
  for i:=1 to maxDet do
  begin
     Close(detalles);
  end;
end;
var
  mae: archMaestro;
  detalles: vecDetalle;
begin
  CrearArchivos(mae, detalles); // se dispone
  asignarMaestroYDetalle(mae, detalles);
  procesarDatos(mae, detalles);
end.