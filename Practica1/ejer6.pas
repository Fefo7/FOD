program ejer6;
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
procedure LeerCelular(var c:celular);
begin
    WriteLn('ingrese el codigo del celular');
    ReadLn(c.cod);
    if c.cod <> -1 then
    begin
        WriteLn('ingrese el nombre');
        ReadLn(c.nombre);
        WriteLn('ingrese el precio');
        ReadLn(c.precio);
        WriteLn('ingrese el marca');
        ReadLn(c.marca);
        WriteLn('ingrese el descripcion');
        ReadLn(c.descripcion);
        WriteLn('ingrese el stock');
        ReadLn(c.stock);
        WriteLn('ingrese el stock minimo');
        ReadLn(c.stockMin);
    end;
end;    
procedure mostrarCeluLar(c:celular);
begin
    WriteLn('--------------------------------------');
    with c do
    begin
        WriteLn ( cod,' ',precio:0:3,' ',marca);
        WriteLn ( stock,' ',stockMin,' ',descripcion);
        WriteLn ( nombre);
    end;
    WriteLn('--------------------------------------');
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
procedure AgregarNuevoCelular(var arch:archivo);
var
    c,cUlt:celular;
    opcion: integer;
begin
  repeat
       WriteLn('ingrese el codigo -1 para terminar'); 
       LeerCelular(c);
       if(c.cod <> -1) then
         begin
            Reset(arch);
            Seek(arch, FileSize(arch));
            Write (arch, c);
            Close(arch);
         end;
  until (c.cod = -1);
end;
procedure ModificarStock(var arch: archivo);
var 
    nomABuscar: string;
    c:celular;
    stock: integer;
begin
  WriteLn('ingrese el nombre del celular a buscar');
  ReadLn(nomABuscar);
  reset(arch);
  Read(arch,c);
  while ((not eof(arch)) and (c.nombre <> nomABuscar) ) do
    begin
        Read(arch,c);
    end;
   if(c.nombre = nomABuscar) then
    begin
      WriteLn('ingrese el stock nuevo');
      ReadLn(stock);
      c.stock:= stock;
      seek(arch, filepos(arch)-1);
      Write(arch,c);
    end;
  Close(arch);
end;
procedure ExportarSinstock(var arch:archivo; var sinStock: text);
var
    c:celular;
begin
    reset(arch);
    Rewrite(sinStock);
    while (not eof(arch)) do
    begin
      Read(arch,c);
      if(c.stock = 0)then
        begin
          with c do begin
            WriteLn (sinStock, cod,' ',precio,' ',marca);
            WriteLn (sinStock, stock,' ',stockMin,' ',descripcion);
            WriteLn (sinStock, nombre);
           end;
        end;
    end;
    Close(sinStock);
    Close(arch);
end;
var
    arch: archivo;
    nomArchivo: String;
    celus,sinStock: text;
    opcion: Integer;
begin
    Assign(celus, 'celulares.txt');
    Assign(sinStock, 'SinStock.txt');

    repeat
        WriteLn('Ingrese la opcion que quiera ');    
        WriteLn('1- crear archivo ');  
        WriteLn('2- listar celulares con stock menor al  stock minimo');  
        WriteLn('3- Listar en pantalla de descripcon modificada?');  
        WriteLn('4- exportar todos los celulares');  
        WriteLn('5- Agregar nuevos celulares');  
        WriteLn('6- Modificar el stock de un celular');  
        WriteLn('7- Exportar archivo celulares sin stock');  
        WriteLn('8- mostrar el archivo binario (test)');  
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
               AgregarNuevoCelular(arch);
            end;
            6:
            begin
              ModificarStock(arch);
            end;
            7:
            begin
              ExportarSinstock(arch, sinStock);
            end;
            8:
            begin
              MostrarArchivo(arch);
            end; 
        end;
    until (opcion = 0);

    

end.