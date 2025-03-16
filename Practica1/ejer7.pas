program ejer7;
type
    novela = record
        cod: Integer;
        precio: real;
        genero: string;
        nombre:string;
        
    end;
    archivo = file of novela;

procedure LeerNovela(var n:novela);
begin
    WriteLn('ingresa el codigo de la novela');
    ReadLn(n.cod);    
    WriteLn('ingresa el precio de al novela');
    ReadLn(n.precio);    
    WriteLn('ingresa el nombre de la novela');
    ReadLn(n.nombre);    
    WriteLn('ingresa el genero de la novela');
    ReadLn(n.genero);    
end;

procedure MostrarArchivo(var arch:archivo);
var 
    n: novela;
begin
  reset(arch);
  while not Eof(arch) do
  begin
      Read(arch, n);
     WriteLn('--------------------------------------');
    with n do
    begin
        WriteLn ( cod,' ',precio:0:3,' ',genero);
        WriteLn ( nombre);
    end;
    WriteLn('--------------------------------------');
  end;
  Close(arch);
end;

procedure CrearArchivo(var arch: archivo;var  archT:text);
var
    n:novela;
    nombreArch:String;
begin
    WriteLn('ingrese el nombre del archivo');
    ReadLn(nombreArch);
    Assign(arch,nombreArch);
    Rewrite(arch);
    Reset(archT);
    while (not Eof(archT))do
      begin 
         with n do ReadLn(archT,cod,precio,genero);
         with n do ReadLn(archT,nombre);
         Write(arch,n);
      end;
    Close(arch);
    Close(archT);
end;
procedure  AgregarNovela(var arch:archivo);
var 
    n:novela;
begin
  LeerNovela(n);
  reset(arch);
  seek(arch, FileSize(arch));
  Write(arch, n);
  Close(arch);
end;
procedure ModificarNovela(var arch:archivo);
var 
    codN: Integer;
    n:novela;
begin
    WriteLn('ingrese el codigo de la novela que quiera modificar');
    ReadLn(codN);
    Reset(arch);
    Read(arch,n);
    while ((not eof(arch)) and (n.cod <> codN)) do
    begin
      Read(arch,n);
    end;
    LeerNovela(n);
    Seek(arch, FilePos(arch)-1);
    Write(arch, n);
    Close(arch);
end;
var
    arch: archivo;
    archT: text;
    opcion:integer;
begin
  Assign(archT,'novelas.txt');
  repeat
    WriteLn('ingrese la opcion que requiera');
    WriteLn('1- crear archivo binario');
    WriteLn('2- Agregar novela');
    WriteLn('3- modificar novela');
    WriteLn('4- mostrar el binario (test)');
    WriteLn('0- para salir');
    ReadLn(opcion);

    case opcion of
     1: 
     begin
       CrearArchivo(arch, archT);
     end;
     2:
     begin
       AgregarNovela(arch);
     end;
     3:
     begin
       ModificarNovela(arch);
     end;
     4: 
     begin
       MostrarArchivo(arch);
     end;
    end;
  until (opcion = 0);
end.