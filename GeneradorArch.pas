program GeneradorArch;

type
  Registro = record
    cod: Integer;
    codMat: Integer;
    resultado: String[2];
    anio: string[4];
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
        with r do writeln(cod, ' ', codMat,' ',resultado, ' ',anio );  
    end;
    close(a);
end;
var
  ArchivoTexto: Text;
  ArchivoBinario: archivo;
  Datos: Registro;
  NombreArchivoTexto, NombreArchivoBinario: string;

begin


  { Abrir el archivo de texto para lectura }
  assign(ArchivoTexto, 'Datos.txt');
  reset(ArchivoTexto);

  { Crear el archivo binario }
  assign(ArchivoBinario, 'test.dat');
  rewrite(ArchivoBinario);

  { Leer datos del archivo de texto y escribirlos en el archivo binario }
  while not eof(ArchivoTexto) do
  begin
    { Leer datos desde el archivo de texto }
    readln(ArchivoTexto, Datos.cod, Datos.codMat, Datos.resultado);
    readln(ArchivoTexto,  Datos.anio);


    { Escribir el registro en el archivo binario }
    write(ArchivoBinario, Datos);
  end;

  { Cerrar los archivos }
  close(ArchivoTexto);
  close(ArchivoBinario);

  writeln('Archivo binario creado exitosamente.');
  MostrarArchivo(ArchivoBinario);
end.

