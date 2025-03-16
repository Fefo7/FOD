program ejer5;
type
    celular = record
        cod: Integer;
        precio: real;
        stockMin: integer;
        stock: Integer;
        nombre: String;
        marca: string;
        descripcion: String;
    end;
    archivo = file of celular;
procedure mostrarCeluLar(c:celular);
begin
    with c do
    begin
        WriteLn ( cod,' ',precio:0:3,' ',marca);
        WriteLn ( stock,' ',stockMin,' ',descripcion);
        WriteLn ( nombre);
    end; 
end;

procedure MostrarArchivo(var arch:archivo);
var 
    c: celular;
begin
  reset(arch);
  while not Eof(arch) do
  begin
      Read(arch, c);
      mostrarCeluLar(c);
  end;
  Close(arch);
end;
procedure ListarCelularesStockMenor(var arch: archivo);
var
    c:celular;
begin
  Reset(arch);
  WriteLn('---------------------------------------');
  while (not Eof(arch)) do
  begin
    Read(arch,c);
    if (c.stock<c.stockMin) then
    begin
      mostrarCeluLar(c);
    end;
  end;
  Close(arch);
  WriteLn('---------------------------------------');

end;
procedure CrearArchivo(var celus: text;var arch:archivo);
var
    c:celular;
    nomArchivo: string;
begin
  Reset(celus);
  WriteLn('ingrese el nombre del archivo');
  ReadLn(nomArchivo);
  Assign(arch,nomArchivo);
  Rewrite(arch);
  while (not Eof(celus))do
  begin
     with c do ReadLn (celus,cod,precio,marca);
     with c do ReadLn (celus,stock,stockMin,descripcion);
     with c do ReadLn (celus,nombre);
     Write(arch,c); 
  end;
  Close(arch);
  Close(celus);
end;
function includeWord(texto,palabraBuscar:string): Boolean;
var
    i:integer;
    encontre: Boolean;
    auxt:String;
begin
    i:= 1;
    encontre:= false;
    auxt:= '';
    while (i<= Length(texto)) and (not encontre) do
    begin
      if(texto[i] <> ' ') then
        auxt:= auxt + texto[i]
      else
        begin
          if(palabraBuscar=auxt) then
            encontre:= true
          else
             auxt:= '';
        end;
        i := i + 1;
    end;
    if not encontre and (palabraBuscar = auxt) then
        encontre := True;
    includeWord:= encontre;
end;
procedure BuscarDescripcion(var arch: archivo);
var 
    c:celular;
    cadena: String;
begin
    WriteLn('ingrese la palabra a buscar: ');
    ReadLn(cadena);
    Reset(arch);
    while (not Eof(arch)) do
    begin
      Read(arch,c);
      if(includeWord(c.descripcion,cadena))then
      begin
          mostrarCeluLar(c);
      end;
        
    end;
    close(arch);
end;
procedure  ExportarArchivo(var arch:archivo; var archT:text);
var
    c:celular;
begin
    Reset(arch);
    Rewrite(archT);
    while (not eof(arch)) do
    begin
      Read(arch,c);
      with c do begin
        WriteLn (archT, cod,' ',precio,' ',marca);
        WriteLn (archT, stock,' ',stockMin,' ',descripcion);
        WriteLn (archT, nombre);
      end;
    end;
    close(archT);
    Close(arch);
end;
var
    arch: archivo;
    nomArchivo: String;
    celus: text;
    opcion: Integer;
begin
    Assign(celus, 'celulares.txt');

    repeat
        WriteLn('Ingrese la opcion que quiera ');    
        WriteLn('1- crear archivo ');  
        WriteLn('2- listar celulares con stock menor al  stock minimo');  
        WriteLn('3- Listar en pantalla de descripcon modificada?');  
        WriteLn('4- exportar todos los celulares');  
        WriteLn('5- mostrar el archivo binario (test)');  
        WriteLn('0- salir ');    
        ReadLn(opcion);

        case opcion of
            1:
            begin
                CrearArchivo(celus,arch);
            end;
            2: 
            begin
              ListarCelularesStockMenor(arch);
            end;
            3:
            begin
               BuscarDescripcion(arch);
            end;
            4:
            begin
               ExportarArchivo(arch,celus);
            end;
            5:
            begin
              MostrarArchivo(arch);
            end; 
        end;
    until (opcion = 0);

    

end.