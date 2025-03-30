program Ejer5;
const
    valorAlto = -1; // un codigo no podria ser -1?
    dimf = 30;
type    
    str  =string[30];
    producto  = record
        cod:Integer;
        nombre: str;
        descripcion: string;
        stockDisponible: integer;
        stockMinimo: Integer;
        precio: real;
    end;
    ventaProdcuto = record
        cod: Integer;
        cantVendida: Integer;
    end;

    archProd = file of producto; //maestro
    archVentas= file of ventaProdcuto; //detalle
    vecVentas = array[1..dimf] of archVentas; // 30 DETALLES
    vecRegVentas =  array[1..dimf] of ventaProdcuto; // registros del detalle

var
    maestro: archProd;
    todasVentas: vecVentas;

procedure CrearDetalle(var det:archVentas);
var
    nombre: string;
begin
  WriteLn('ingrese el nombre del archivo');
  ReadLn(nombre);
  Assign(det,nombre);
  Rewrite(det);
end;
procedure CrearTodosDetalles();
var
    i: integer;
begin
    for i:= 1 to dimf do
    begin
      CrearDetalle(todasVentas[i]);
    end; 
end;
procedure LeerDetalle(var detalle: archVentas;var dato: ventaProdcuto);
begin
  if(not eof(detalle))then
    read(detalle, dato)
  else
    dato.cod:= valorAlto;
end;

procedure AbrirLosDetalles();
var
    i:integer;
begin
  for i:= 1 to dimf do
   begin
     Reset(todasVentas[i]);
   end;
end;
procedure CerrarLosDetalles();
var
    i:integer;
begin
  for i:= 1 to dimf do
   begin
     Close(todasVentas[i]);
   end;
end;

procedure LeerTodosDetalles(var regisDet: vecRegVentas);
var i: integer;
begin
    for i:= 1 to dimf do
    begin
      LeerDetalle(todasVentas[i], regisDet[i]);
    end;
end;
 procedure BuscarMinimo(var regisDet:vecRegVentas ; var  minimo: ventaProdcuto);
 var
    i:integer;
    pos: integer;
 begin
     minimo.cod:= 999;
     for i:= 1 to dimf do
     begin
       if(regisDet[i].cod < minimo.cod) then
        begin
          minimo:= regisDet[i];
          pos:= i;
        end;
     end;
     if(minimo.cod <> valorAlto)then
        LeerDetalle(regisDet[i]);
 end;

procedure CrearReporteStock(var reporte:text);
var
    p: producto;
begin
  Rewrite(reporte, 'reporte.txt');
  Reset(maestro);
  while not Eof(maestro) do
  begin
    Read(maestro, p);
    if(p.stockDisponible< p.stockMinimo)then
    begin
      with p do Write(Text,nombre, ' ',stockDisponible,' ', precio:0:2, ' ', descripcion );
    end;
  end;
  Close(reporte);
  Close(maestro);
end;

var
    regisDet: vecRegVentas;
    minimo: ventaProdcuto;
    regMae: producto;
    reporte: Text;
begin
  Assign(maestro,'maestro.dat');
  CrearTodosDetalles();
  AbrirLosDetalles();
  Reset(maestro);
  LeerTodosDetalles(regisDet);
  BuscarMinimo(regisDet, minimo);
  
  while minimo.cod <> valorAlto do
  begin
        Read(maestro, regMae);
        while regMae.cod <> minimo.cod do
        begin
          Read(maestro,regMae);
        end;
        while regMae.cod = minimo.cod do
        begin
            if (regMae.stockDisponible - minimo.cantVendida) > 0  then
                regMae.stockDisponible:= regMae.stockDisponible - minimo.cantVendida
            else
                regMae.stockDisponible:= 0;
            BuscarMinimo(regisDet, minimo);
        end;
        seek(maestro, FilePos(maestro)-1);
        Write(maestro,regisDet);
  end;
  CerrarLosDetalles();
  Close(maestro);

  CrearReporteStock(reporte);

  
end. 