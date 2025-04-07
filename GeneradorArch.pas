program GeneradorArch;

type
    maestro = record
        cod: Integer;
        codMat: Integer;
        resultado: Boolean;
        anio: String;
    end;
    arch = file of maestro;

procedure MostrarArchivo(var a: arch);
var
    r: maestro;
begin
    reset(a);
    while (not Eof(a)) do
    begin
        read(a, r);
        with r do
            writeln(cod, ' ', codMat, ' ', anio, ' ', resultado);
    end;
    close(a);
end;

var
    archTex: text;
    archivo2: arch;
    reg: maestro;
begin
    assign(archTex, 'Datos.txt');
    reset(archTex);
    assign(archivo2, 'Test1.dat');
    rewrite(archivo2);
    while (not Eof(archTex)) do
    begin
       with reg do
        begin
            ReadLn(archTex, cod, codMat, resultado);
            ReadLn(archTex, anio);
            write (archivo2, reg); 
        end;
       
    end;

    close(archivo2);
    close(archTex);
    MostrarArchivo(archivo2);
end.
