program Ejer10_25;
type
    maestro = record
        codProv: Integer;
        codLoc: integer;
        numeroMesa: Integer;
        cantVotos: Integer;
    end;
    arch = file of maestro;
procedure AsignarMaestro(var m: arch);
var 
    nombre: String;
begin
  WriteLn('ingrese el nombre del maestro');
  ReadLn(nombre);
  Assign(m,nombre);
end;

procedure  procesarDatos(var mae: arch);
var 
    regM: maestro;
    codAct,codLoc:Integer;
    totGenVoto, totVotProv,totMesasVot: Integer;
begin
  // preguntar por el enunciado esta raro, no se si lo interprete bien
  Reset(mae);
  totGenVoto:= 0;
  while (not Eof(mae)) do
  begin
        Read(mae,regM); 
        codAct:= regM.codProv;
        totVotProv:=0;
        while (regM.codProv = codAct) do
        begin
          WriteLn('codigo de provincia: ', codAct);
          codLoc:= regM.codLoc;
          totMesasVot:= 0;
          while (regM.codProv = codAct) and (regM.codLoc=codLoc ) do // la condicion de eof se tiene que repetir? o usamos el valor alto?
          begin
            totMesasVot:= totMesasVot + regM.cantVotos;
            Read(mae,regM);
          end;
          WriteLn('Codigo localidad: ', codLoc, 'total de votos: ', totMesasVot);
          totVotProv:= totVotProv + totMesasVot;
        end;
        WriteLn('total de votos provincia: ', totVotProv);
        totGenVoto:= totGenVoto +totVotProv ;
  end;
    WriteLn('total general de votos: ', totGenVoto);
  Close(mae);
end;    
var
    mae: arch;
begin
  AsignarMaestro(mae);
  procesarDatos(mae);
end.