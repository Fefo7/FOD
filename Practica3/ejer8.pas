program ejer8;
const   
    valorCorte = 'ZZZ';
type
    str30 = String[30];
    distribucion = record
        nombre: str30;
        anioLanz:Integer;
        numKernel: Integer;
        cantDesa: Integer;
        des: String;
    end;
    arch= file of distribucion;
procedure Leer(var archivo: arch; var d:distribucion);
begin
  if(not Eof(archivo))then
    read(archivo,d)
  else
    d.nombre := valorCorte;
end;
procedure Leerdistribucion(var d: distribucion);
begin
  WriteLn('Ingrese el nombre de la distribucion');
  Read(d.nombre);
  if (d.nombre <> valorCorte) then
  begin
    WriteLn('Ingrese el anio de lanzamiento');
    ReadLn(d.anioLanz);
    WriteLn('Ingrese el numero de kernel');
    ReadLn(d.numKernel);
    WriteLn('Ingrese la cantidad  de desarrolladores');
    ReadLn(d.cantDesa);
    WriteLn('Ingrese la descripcion');
    ReadLn(d.des);
  end;
end;
procedure AsignarArchivo(var archivo: arch);
var 
    nombre:string;
begin
   WriteLn('ingrese el nombre del archivo');
   ReadLn(nombre);
   Assign(archivo, nombre); 
end;
//procedure CargarArchivo(var archivo: arch); // se dispone
procedure ImpirmirMenu(var opc: integer);
begin
    WriteLn('1- ingrese para buscar');
    WriteLn('2- Alta de distribuciones');
    WriteLn('3- Baja de distribucion');
    WriteLn('0- Salir');
    ReadLn(opc);
end;
procedure BuscarDistribucion(var archivo: arch; nomDis: str30;var pos: Integer);
var
    d:distribucion;
begin
  Reset(archivo);
  Leer(archivo,d); // para no leer el cabecera en el while
  Leer(archivo, d);
  while (d.nombre<> nomDis)  do
  begin
        Leer(archivo,d);
  end;
  if(d.nombre = nomDis)then
     pos:= FilePos(archivo)-1
  else
    pos:= -1; 
  Close(archivo);
end;

procedure AltaDistribucion(var archivo:arch; d:distribucion);
var
    pos:Integer;
    regCabe: distribucion;
begin
    Reset(archivo);
    BuscarDistribucion(archivo, d.nombre, pos);
    if(pos > 0)then
    begin
        Seek(archivo,0);
        Leer(archivo,regCabe);
        if(regCabe.cantDesa<0)then
        begin
           Seek(archivo,regCabe.cantDesa*-1);
           Leer(archivo, regCabe);
           Seek(archivo,FilePos(archivo)-1);
           Write(archivo,d);
           Seek(archivo, 0);
           Write(archivo,d);
        end
        else
            Seek(archivo,FileSize(archivo)-1);
            Write(archivo,d);
    end
    else 
        WriteLn('ya existe esa distribucion');
    Close(archivo);
end;
procedure  BajaDistribucion(var archivo:arch;nomDes:str30); 
var
    pos:Integer;
    regCabe,disBorrar: distribucion;
begin
   Reset(archivo); 
   BuscarDistribucion(archivo, nomDes, pos);
   if(pos>0)then
   begin
      Leer(archivo,regCabe);
      Seek(archivo, pos);
      Leer(archivo,disBorrar);
      disBorrar.cantDesa:= (FilePos(archivo)-1);
      Seek(archivo, FilePos(archivo)-1);
      Write(archivo, regCabe);
      Seek(archivo, 0);
      Write(archivo, disBorrar);
   end
   else
        WriteLn('Distribucion no existe');
   Close(archivo);
end;
var
    archivo: arch;
    opcion,pos: Integer;
    nomDes: str30;
    d:distribucion;
begin
  AsignarArchivo(archivo);
  //CargarArchivo(archivo); // se dispone, podemos suponer que ya se hiso el registro cabecera?
  repeat
    ImpirmirMenu(opcion);
    case opcion of
        1:begin
          WriteLn('ingrese el nombre de distribucion');
          ReadLn(nomDes);  
          BuscarDistribucion(archivo, nomDes,pos);
         end;
        2:
        begin    
            Leerdistribucion(d);
            AltaDistribucion(archivo,d);
        end;
        3:begin
          WriteLn('ingrese el nombre de distribucion');
          ReadLn(nomDes);
          BajaDistribucion(archivo,nomDes); 
        end; 
    end;
  until (opcion = 0);
end.