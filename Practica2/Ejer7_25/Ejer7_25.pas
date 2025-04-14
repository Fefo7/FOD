program Ejer7_25;
const
    valorAlto = 999;
type
    str =string[30];
    alumno = record 
        cod: integer;
        apellido: str;
        nombre: str;
        cantCursadas: Integer;
        cantMateriasFAprob: Integer;
    end;
    cursada = record
        cod: integer;
        codMateria: Integer;
        anio: Integer;
        resultado: Boolean;
    end;
    examen = record
        cod: Integer;
        codMateria: Integer;
        fecha: str;
        nota: Integer;
    end;

    archMaestro = file of alumno;  // ordenado por codigo de alumno
    archCursada = file of cursada;
    archExamen = file of examen;

var
    maestro = archMaestro;
    cursadas  = archCursada;
    examenes = archExamen;

procedure LeerMaestro(var regM: alumno);
begin
  if (not eof(maestro) )then
    Read(maestro,regM)
  else
    regM.cod := valorAlto;
end;
procedure LeerCursada(var regC: cursada);
begin
  if (not eof(cursadas) )then
    Read(cursadas,regC)
  else
    regC.cod := valorAlto;
end;
procedure LeerExamenes(var regE: examen);
begin
  if (not eof(examenes) )then
    Read(examenes,regE)
  else
    regE.cod := valorAlto;
end;
procedure AsignarArchivos();
begin
  Assign(maestro,'maestro.dat');
  Assign(cursadas,'materiasCursadas.dat');
  Assign(examenes,'examenes.dat');
end;
procedure BuscarMinimoDetalles(var minE:examen; var minC:cursada);
var
   exa: examen;
   cur: cursada;
begin
    Reset(cursadas);
    Reset(examenes);
    if (exa.cod<= cur.cod ) then
    begin
        if exa.cod < minE.cod then
        begin
            minE:= exa;
            minC:= cur;
            LeerExamenes(examenes,exa);
        end;
    end
    else
    begin
         if cur.cod < minE.cod then
        begin
            minC:= cur;
            minE:= exa;
            LeerCursada(cursadas,cur);
        end;
    end;
   Close(cursadas);
   Close(examenes);
end;
procedure ProcesarArchivos();
var
  minExa: examen;
  mincur: cursada;
  exa: examen;
  cur: cursada;
  regM: alumno;
begin
  Reset(cursadas);
  Reset(examenes);
  Reset(maestro);
  minExa.cod:= 999;
  mincur:=999;
  LeerExamenes(exa);  
  LeerCursada(cur);
  LeerMaestro(regM);
   
  while regM.cod <> valorAlto do
  begin
      // preguntar en clase como hacer cuando tenes dos archivos detalles de diferentes datos
      
  end;

  Close(cursadas);
  Close(examenes);
  Close(maestro);
end;



begin
    AsignarArchivos();
    ProcesarArchivos();
end.