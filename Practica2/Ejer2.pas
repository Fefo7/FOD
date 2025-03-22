program Ejer2;
const 
    valorMinimo= -1;
type  
    str30 = String[30];
    alumno =record
        cod: integer;
        apellido: str30;
        nombre: str30; 
        cantCursada: Integer;
        cantAprobada:Integer;
    end;
    materia = record
        codAlumno: integer;
        Aprobada: Boolean;
        AprobadaC: Boolean;
    end;

    archMaestro= file of alumno;
    archDetalle = file of materia;
procedure VistaMenu(var opcion: integer);
begin
    WriteLn('ingrese la opcion que quiera');
    WriteLn('1- Para actualizar los alumnos');    
    WriteLn('2- Exportar archivo de texto');
    WriteLn('0- para salir');   
    ReadLn(opcion);
end;
procedure Leer(var det:archDetalle; var m:materia);
begin
  if(not Eof(det)) then
    Read(det,m)
else
    m.codAlumno:= valorMinimo;
end;
procedure ActulizarAlumnos(var maestro:archMaestro;var detalle:archDetalle);
var
    m:materia;
    a:alumno;
    codActAlum: Integer;
begin
    Reset(maestro);
    Reset(detalle);
    Leer(detalle, m);
    while (m.codAlumno <> valorMinimo) do
    begin
        Read(maestro,a);
        codActAlum:= m.codAlumno;
        while (codActAlum <> a.cod) do // aca evaluo si hay por lo menos 1 alumno
        begin
            Read(maestro, a);
        end;
        while (codActAlum = m.cod) do
        begin
            if(m.Aprobada)then
                a.cantAprobada:=  a.cantAprobada +1;
            if(m.AprobadaC)then
              a.cantCursada:= a.cantCursada +1;
            Leer(detalle,m);
           // avanzar en el detalle
        end;
        seek(maestro, FilePos(maestro)-1);
        WriteLn(maestro, a);
    end;
    Close(maestro);
    Close(detalle);
end;
procedure ExportarTexto(var maestro:archivo);
var
    archT:text;
    a:alumno;
begin
    Assign(archT, 'exportarAlumnos.txt');
    Rewrite(archT);
    Reset(maestro);
    while (not eof(maestro)) do
    begin
        Read(maestro, a);
        if(a.cantAprobada> a.cantCursada)then
        begin
          with a do Write(archT,'codigo alumno: ', cod, 'nombre: ', nombre, ' apellido: ', apellido, 
                          'cantidad aprobada final: ', cantAprobada, 'cantidad cursada aprobada: ', cantCursada );
        end;
          
    end;
    Close(archT);
    Close(maestro);
    
end;
var
    opcion: Integer;
    maestro: archMaestro; //se dispone
    detalle: archDetalle;
begin
    Assign(maestro, 'maestro.dat');
    Assign(detalle, 'detalle.dat');
repeat
    VistaMenu(opcion);
    case opcion of
        1: ActulizarAlumnos(maestro,detalle);
        2: ExportarTexto(maestro,detalle);
    end;
until (opcion = 0);

end.