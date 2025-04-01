Program Ejer7;
const
    valorcorte= -1;
    dimf= 10;
type
    str = String[50];
    detalle = record
        codLocalidad: integer;
        codigoCepa: Integer;
        cantActivo: Integer;
        cantNue: Integer;
        cantRecu: Integer;
        cantMuerto:Integer;
    end;
    maestro = record
        codLocalidad: integer;
        nombreLocalidad: str;
        codigoCepa: Integer;
        nomCepa: str;
        cantActivo: Integer;
        cantNue: Integer;
        cantRecu: Integer;
        cantMuerto:Integer;
    end;
    archDet = file  of detalle;
    archMae = file of maestro;
    vecDeta= array[1..dimf] of archDet;
    vecRegDet =  array[1..dimf] of detalle;
var
    mae: archMae;
    detalles: vecDeta;

procedure Leer(var arch: archDet; var d:detalle);
begin
  if(not Eof(arch))then
    read(arch,d)
  else
    d.codLocalidad := valorcorte;
end;
procedure CargarRegistrosDetalles(var vec: vecRegDet);
var
    i:Integer;
begin
    for i:=1 to dimf do
    begin
       Leer(detalles[i],vec[i]);
    end;
end;
procedure BuscarMinimo(var regisDets:vecRegDet; var minimo:detalle);
var
    i:Integer;
    pos: Integer;
begin   
    minimo.codLocalidad:= 999;
    minimo.codigoCepa:= 999;
    for i:=1 to dimf do
    begin
        if((regisDets[i].codLocalidad<minimo.codLocalidad) and (regisDets[i].codigoCepa < minimo.codigoCepa))then
        begin
          minimo:= regisDets[i];
          pos:= i;
        end;
    end;
    Leer(detalles[pos],regisDets[pos]);
end;
var
    maeReg : maestro;
    regisDets : vecRegDet;
    minimo: detalle;
    cantMasActivos: integer;
    i:Integer;
begin
  cantMasActivos:= 0;
  Reset(mae);
  for i:= 1 to dimf do
  begin
    Reset(detalles[i]);
  end;
  BuscarMinimo(regisDets, minimo);
  while (minimo.codLocalidad <> valorcorte) do
  begin
    Read(mae,maeReg);
    while maeReg.codLocalidad <> minimo.codLocalidad do
    begin
      if maeReg.cantActivo > 50 then
        cantMasActivos:= cantMasActivos+1; // lo hago aca por que si entra aca no se va a volver a procesar la misma localidad
      Read(mae,maeReg);
    end;
    while (maeReg.codigoCepa = minimo.codigoCepa) do
    begin
       maeReg.cantMuerto:= maeReg.cantMuerto+ minimo.cantMuerto;
       maeReg.cantRecu:=maeReg.cantRecu + minimo.cantRecu;
       maeReg.cantActivo:= maeReg.cantActivo + minimo.cantActivo;
       maeReg.cantNue:= maeReg.cantNue + minimo.cantNue;
       BuscarMinimo(regisDets,minimo);
    end;
    if maeReg.cantActivo > 50 then
        cantMasActivos:= cantMasActivos+1;
    Seek(mae, FilePos(mae)-1);
    Write(mae, maeReg);

  end;
   for i:= 1 to dimf do
  begin
    Close(detalles[i]);
  end; 
  Close(mae);
  WriteLn('cantidad de localidades con mas de 50 activos: ', cantMasActivos);

end.