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


procedure LeerCursada(var c:archCursada; regC: cursada);
begin
  if (not eof(c) )then
    Read(c,regC)
  else
    regC.cod := valorAlto;
end;
procedure LeerExamenes(var e:archExamen; regE: cursada);
begin
  if (not eof(e) )then
    Read(e,regE)
  else
    regE.cod := valorAlto;
end;
procedure AsignarArchivos(var m: archMaestro; var c:archCursada; var e:archExamen);
begin
  Assign(a,'maestro.dat');
  Assign(c,'materiasCursadas.dat');
  Assign(e,'examenes.dat');
end;
procedure BuscarMnimoDetalles(var c:archCursada; var e:archExamen;);
begin
    
end;
begin
    AsignarArchivos(maestro,cursadas,examenes);
    
end.