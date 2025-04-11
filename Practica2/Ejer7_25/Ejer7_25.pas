program Ejer7_25;
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
begin
  
end.