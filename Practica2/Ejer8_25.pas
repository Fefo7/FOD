program Ejer8_25;
const
    dimf = 16;
    valorAlto=999;
type
    maestro = record
        codProv: Integer;
        nombre: string;
        cantHabi: Integer;
        cantYerba: real;
    end;
    relevamiento = record
        codProv: Integer;
        cantYerba:Real;
    end;
    archDetalle = file of relevamiento;
    archMaestro = file of maestro;
    vecDetalle= array [1..dimf] of archDetalle;
    vecRegDeta =array [1..dimf] of relevamiento;
var
    mae: archMaestro;
    detalles: vecDetalle;

procedure AsignarArchivos();
var
    i:Integer;
    nombre:String;
begin
  WriteLn('ingrese el nombre del archivo maestro');
  ReadLn(nombre);
  Assign(mae,nombre);
  for i:=1 to dimf do
  begin
    WriteLn('ingrese el nombre del archivos detalles');
    ReadLn(nombre);
    Assign(detalles[i], nombre);
  end;
end;
procedure Leer(var arch:archDetalle; var regD:relevamiento); 
begin
  if (not Eof(arch)) then
    Read(arch,regD)
  else
    regD.codProv:= valorAlto; 
end;
procedure LeerRegDetalles(var regsDetalles: vecRegDeta);
var
    i:Integer;
begin
    for i:= 1 to dimf do
    begin
        Leer(detalles[i],regsDetalles[i]);  
    end;
end;
procedure CalcularMinimo(var regsDetalles:vecRegDeta; var min:relevamiento );
var
    i:integer;
    posicion: integer;
begin
    for i:=1 to dimf do
    begin
      if(regsDetalles[i].codProv < min.codProv)then
      begin
            min:= regsDetalles[i];
            posicion:= i;
      end;
    end;
    Leer(detalles[posicion],regsDetalles[posicion]);
end;
procedure ProcesarArchivos();
var
    i:Integer;
    regM: maestro;
    min: relevamiento;
    regsDetalles: vecRegDeta;
begin
  Reset(mae);
  for i:=1 to dimf do  //abro los archivos detalles
  begin
    Reset(detalles[i]);
  end;
  LeerRegDetalles(regsDetalles);
  while (not eof(mae)) do
  begin
    Read(mae, regM);
    CalcularMinimo(regsDetalles,min);
    while (min.codProv = regM.codProv) do
    begin
      regM.cantYerba:= regM.cantYerba + min.cantYerba;
      CalcularMinimo(regsDetalles,min);
    end;
    if(regM.cantYerba > 10000)then
    begin
        WriteLn('provincias que superan los 10.000 kilos de yerba: ', regM.codProv, ' ', regM.nombre);
        WriteLn('promedio de kilos x habitantes: ', regM.cantYerba/regM.cantHabi);
    end;
    Read(mae, regM);
  end;
  for i:=1 to dimf do  //cierro los archivos detalles
  begin
    Close(detalles[i]);
  end;
  Close(mae);


end;
begin
  AsignarArchivos();
  ProcesarArchivos();
end.