program GeneradorArch;

type
  str= string[30];
  Registro = record
      cod: Integer;
      codMateria: Integer;
      fecha: str;
      nota: Integer;
  end;
    archivo = file of Registro;
procedure MostrarArchivo(var a: archivo);
var
    r: Registro;
begin
    reset(a);
    while (not Eof(a)) do
    begin
        read(a, r);
        with r do writeln(cod, ' ', codMateria,' ',fecha, ' ', nota); 
    end;
    close(a);
end;
var
  ArchivoTexto: Text;
  ArchivoBinario: archivo;
  Datos: Registro;

begin


  { Abrir el archivo de texto para lectura }
  assign(ArchivoTexto, 'Datos.txt');
  reset(ArchivoTexto);

  { Crear el archivo binario }
  assign(ArchivoBinario, 'Test.dat');
  rewrite(ArchivoBinario);
  
  //cod, materia, anio, resultado
  { Leer datos del archivo de texto y escribirlos en el archivo binario }
  while not eof(ArchivoTexto) do
  begin
    { Leer datos desde el archivo de texto }
    readln(ArchivoTexto, Datos.cod, Datos.codMateria,Datos.nota,Datos.fecha);
    write(ArchivoBinario, Datos);
  end;

  close(ArchivoTexto);
  close(ArchivoBinario);

  writeln('Archivo binario creado exitosamente.');
  MostrarArchivo(ArchivoBinario);
  
end.

