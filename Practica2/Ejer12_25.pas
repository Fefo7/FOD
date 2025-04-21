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
var
    regM: acesso;
    mesAct, diaAct: Integer;
    totTiempoDia,totTiempoMes,totTiempoAnio: Real;
    condi: Boolean;
begin
  Reset(mae); // deberia estar dentro del repet asi resetea el puntero
  repeat
    while (not Eof(mae)) do
    begin
      Read(mae, regM);
      while (regM.anio<anio) do
      begin
        Read(mae, regM);
      end;
      if(regM.anio = anio)then
      begin
          condi:= True;
          while (regM.anio= anio) do
          begin
            mesAct:= regM.mes;
            totTiempoMes:= 0;
            while (regM.anio= anio) and (regM.mes = mesAct) do
            begin
              diaAct:= regM.dia;
              totTiempoDia:= 0;
              while (regM.anio= anio) and (regM.mes = mesAct) and (regM.dia = diaAct) do
              begin
                WriteLn('idUsuario: ', regM.idUsuario, 'tiempo total de acceso en el dia',
                regM.diaAct, 'mes ',regM.mesAct, 'tiempo: ',
                regM.tiempoAcceso );
                Read(mae,regM);
                totTiempoDia:= totTiempoDia + regM.tiempoAcceso;
              end;
              

            end;
          end;
      end
      else
        begin
          condi:= False;
        end;
    end;
  until condi;
  
  Close(mae);
end;
var
    mae: arch; // ordenado anio, mes, dia e idUs
    anio:Integer;
begin
    AsignarMaestro(mae);
    WriteLn('ingrese el anio que quiere imprimir');
    ReadLn(anio);
    ProcesarDatos(mae,anio);
end.