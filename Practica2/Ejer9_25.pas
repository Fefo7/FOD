program Ejer9_25;
type
 cliente = record
    cod: Integer;
    nombre: string;
    apellido: String;
    anio:Integer;
    mes:Integer;
    dia: Integer;
    montoV: real;
 end;
 Arch= file of cliente;
procedure imprimirDatosCliente(c:cliente);
begin
  WriteLn('codigo: ',c.cod, 'nombre: ',c.nombre, 'apellido: ', c.apellido);
end;
procedure AsignarMaestro(var mae: Arch);
var 
    nombre: String;
begin
  WriteLn('ingrese el nombre del maestro');
  ReadLn(nombre);
  Assign(mae,nombre);
end;
var
    mae: Arch;
    regM: cliente;
    mesAct, codact, anio, dia: Integer;
    montoAnual,MontoMensual: real;
    totalDeVentas: Integer;
begin
  AsignarMaestro(mae);
  Reset(mae);
  totalDeVentas:= 0;
  while (not Eof(mae)) do
    begin
        Read(mae,regM);
        imprimirDatosCliente(regM);
        codact:= regM.cod;
        mesAct:= regM.mes;
        while (regM.cod = codact) do
        begin    
            anio:= regM.anio;
            montoAnual:= 0;
            while (regM.cod = codact) and (regM.anio=anio) do
            begin
                MontoMensual:= 0;
                while(regM.cod = codact) and (regM.anio=anio) and (regM.mes = mesAct) do
                begin
                    MontoMensual:= MontoMensual + regM.montoV;
                    totalDeVentas:= totalDeVentas +1;
                    Read(mae,regM);
                end;
                WriteLn('gasto de: ', codact,'mes: ', mesAct ,'monto: ', MontoMensual);
                montoAnual:= montoAnual +MontoMensual;
            end;
            WriteLn('gasto de: ', codact,'anio: ', anio ,'monto: ', montoAnual);
        end;
    end;
    WriteLn('total de ventas de la empresa: ',totalDeVentas);
   

  Close(mae);
end.