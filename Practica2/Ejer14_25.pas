program Ejer14_25;
const
    valorAlto = '999';

type
    str = String[40];
    maestro = record
        destino: str;
        fecha: str;
        horaSalida: integer;
        cantAsientosDispo: Integer;
    end;
    detalle = record
        destino: str;
        fecha: str;
        horaSalida: integer;
        cantAsientosComp: Integer;
    end;
    listVuelos = ^nodo;
    nodo =  record
        dato: maestro;
        sig: listVuelos;
    end;
    archMaestro = File of maestro;
    archDetalle = File of detalle;
var
    mae: archMaestro;
    det1, det2: archDetalle;
procedure CrearArchivoMaestro(var mae:archMaestro);
begin
  // se dispone
end;
procedure LeerDetalle(var det: archDetalle; var dato: detalle);
begin
  if (not Eof(det)) then
    read(det, dato)
 else
    dato.destino:= valorAlto;
end;
procedure  BuscarMinimo(var regDet1,regDet2 ,regDetMin : detalle);
begin
  if ( (regDet1.destino < regDet2.destino) and (regDet1.fecha < regDet2.fecha)
	 and (regDet1.horaSalida < regDet2.horaSalida) )  then begin
			regDetMin:= regDet1; 
			LeerDetalle(det1,regDet1); 
	end
	else begin
		regDetMin:= regDet2; 
		LeerDetalle(det2,regDet2); 
	end; 
end;
procedure AgregarListaVuelos(var lista: listVuelos; regMae: maestro);
var
    aux:listVuelos;
begin
  new(aux);
  aux^.dato:= regMae;
  aux^.sig:= lista;
  lista:= aux;
end;
procedure ProcesarDatos(var mae: archMaestro;var det1, de2:archDetalle);
var
    regDetMin,regDet1,regDet2: detalle;
    regMae:maestro;
    cantAsientos: Integer;
    lista: listVuelos;
begin
  lista:= nil;
  WriteLn('ingrese la cantidad de asientos disponibles');
  ReadLn(cantAsientos);
  LeerDetalle(det1, regDet1);
  LeerDetalle(det2, regDet2);
  BuscarMinimo(regDet1,regDet2, regDetMin);
 while (regDetMin <> valorAlto) do
 begin
    Read(mae, regMae);
    while (regMae.destino = regDetMin.destino) and (regMae.fecha = regDetMin.fecha)and (regMae.horaSalida = regDetMin.horaSalida) do
    begin
        if(regMae.cantAsientosDispo-regDetMin.cantAsientosComp >= 0)then
            regMae.cantAsientosDispo:=regMae.cantAsientosDispo-regDetMin.cantAsientosComp;
        BuscarMinimo(regDet1,regDet2, regDetMin);
    end;
    if( regMae.cantAsientosDispo < cantAsientos)then
        AgregarListaVuelos(lista,regMae);
    Seek(mae, FilePos(mae)-1);
    Write(mae, regMae);     
 end;

end;

begin
  Assign(det1, 'det1.dat');
  Assign(det2, 'det2.dat');
  CrearArchivoMaestro(mae); // se dispone
  ProcesarDatos(mae, det1, de2);

end.