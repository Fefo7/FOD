program Ejer6;
const 
    valorCorte = -1; //suponemos que no hay usuario -1
    dimf = 5;
    ruta = '/var/log/';
var
    maestro: archMaestro;
    detalles: vecLog;
type
    Date = record
        anio: Integer;
        mes: integer;
        dia:integer;
    end;
    maestro = record
        codUs: integer;
        feha: Date;
        tiempoTotalSesion: real;
    end;
    log = record
        codUs: Integer;
        fecha: Date;
        tiempoSesion: real;
    end;
    archMaestro= file of maestro;
    archlog = file of log;
    vecLog =  array[1..dimf] of archlog;
    vecRegLog = array[1..dimf] of log;
procedure CrearMaestro ();
var
    nombre: string;
begin
    WriteLn('ingrese el nombre que quiera crear el archivo');
    ReadLn(nombre);
    nombre:= ruta+nombre; 
    Assign(maestro, nombre);
    Rewrite(maestro);
end;

procedure CrearLog(var d:archlog);
var
    nombre: string;
begin
  
    WriteLn('ingrese el nombre que quiera crear el archivo');
    ReadLn(nombre);
    Assign(d,nombre);
    Rewrite(d);
end;
procedure CrearTodosLogs();
var
    i:Integer;
begin
  for i:=1 to dimf do
    begin
        CrearLog(detalles[i]);
        Reset(detalles[i]);
    end; 
end;
procedure CerrarLogs();
var
    i:Integer;
begin
  for i:=1 to dimf do
    begin
        Close(detalles[i]);
    end; 
end;
procedure LeerLog(var det: archlog; var l:log);
begin
  if (not Eof(det)) then
    read(det,l)
  else
    l.codUs:= valorCorte;
end;

procedure LeerTodosLosDetalles(var regisDet: vecRegLog);
var
    i: Integer;
begin
    for i:=1 to dimf do
      begin
        LeerLog(detalles[i],regisDet[i]);
      end;
end;
function EsFechaMenor(f: TDate; f2: TDate): Boolean;
begin
    if f.anio < f2.anio then
        EsFechaMenor := True
    else if f.anio = f2.anio then
    begin
        if f.mes < f2.mes then
            EsFechaMenor := True
        else if f.mes = f2.mes then
        begin
            if f.dia < f2.dia then
                EsFechaMenor := True
            else
                EsFechaMenor := False;
        end
        else
            EsFechaMenor := False;
    end
    else
        EsFechaMenor := False;
end;

procedure BuscarMinimos(regisDet:vecRegLog; minimo: log);
var
 i:Integer;
 pos: Integer;
 f_minimo: Date;
begin
  f_minimo.anio:= 2050;
  f_minimo.mes:= 12;
  f_minimo.dia:= 31;

  minimo.codUs:= 999;
  minimo.fecha:= f_minimo;
  for i:=1 to dimf do
  begin
    if(((regisDet[i].codUs < minimo.codUs)or (regisDet[i].codUs = minimo.codUs))
        and (EsFechaMenor(regisDet[i].fecha,minimo.fecha))) then
      minimo:= regisDet[i];
      pos:= i;
  end;
  if minimo.codUs <> valorCorte then
    LeerLog(regisDet[i]);
end;

function FechaDiferente(f1,f2:Date): Boolean;
begin
  FechaDiferente:= ((f1.anio <> f2.anio)and (f1.mes <> f2.mes) and (f1.dia <> f2.dia));
end;


var
    regM: maestro;
    regisDet: vecRegLog;
    minimo: log;
begin
 CrearTodosLogs();
 LeerTodosLosDetalles(regisDet);
 BuscarMinimos(regisDet, minimo);
 CrearMaestro();
 while minimo.codUs <> valorCorte do
 begin
   regM.codUs:= minimo.codUs;
   while (regM.codUs = minimo.codUs) do
   begin
        regM.tiempoTotalSesion:= 0.0;
        regM.feha:= minimo.fecha;
        while (regM.codUs = minimo.codUs) and (not FechaDiferente(regM.feha,minimo.fecha)) do
        begin
            regM.tiempoTotalSesion:=regM.tiempoTotalSesion + minimo.tiempoSesion;
            BuscarMinimos(regisDet,minimo);
        end;
        write(maestro, regM);
   end; 
 end;
 Close(maestro);
 CerrarLogs();
end.