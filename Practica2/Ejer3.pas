program ejer3;
const
    valorAlto = 999;
type
    producto= record
        cod:integer;
        nombre:string;
        precio: real;
        stockAct: Integer;
        stockMin: Integer;
    end;
    venta =record
        cod: Integer;
        cantVendidas: Integer;
    end;

    archProducto = file of producto;
    archVenta = file of venta;

procedure Leer(var det: archVenta; var v:venta);
begin
  if(not eof(det))then
    Read(det,v)
  else
    v.cod:= valorAlto;
end;
procedure imprimirMenu(opcion: integer);
begin
  WriteLn('ingrese la opcion que quiera');
  WriteLn('1- actualizar los datos del maestro');
  WriteLn('2- Exportar a una archivo txt prodcutos sin stock');
  WriteLn('0- salir');
  ReadLn(opcion);

end;
procedure actualizarDatos(var maestro: archProducto;var det:archVenta);
var
    v:venta;
    p:producto;
    
begin
    Reset(maestro);
    Reset(det);
    Leer(det,v);
    while v.cod<>valorAlto do
    begin
      Read(maestro,p);
      while p.cod<> v.cod  do
      begin
        Read(maestro,p);
      end;
       
      while p.cod = v.cod do
      begin
        if(v.cantVendidas >= p.stockAct) then
          p.stockAct:= 0
        else
          p.stockAct:= p.stockAct - v.cantVendidas;
        Leer(det,v);
      end;
      Seek(maestro, FilePos(maestro)-1);
      Write(maestro, p);
    end;
    close(maestro);
    close(det);
end;
procedure exportarATexto(var maestro:archProducto;var  reportStock:text);
var
    p:producto;
begin
    Rewrite(reportStock);
    Reset(maestro);
    while (not Eof(maestro)) do
    begin
      Read(maestro, p);
      if(p.stockAct<p.stockMin)then
        begin
          with p do Write(reportStock, ' ', cod, ' ', precio:0:2,'',stockAct,' ',stockMin ,' ', nombre);
        end;
    end;
    Close(maestro);
    Close(reportStock);
end; 
var
    maestro: archProducto;
    detalle: archVenta;
    reportStock: text;
    opcion: Integer;
begin
  Assign(maestro, 'maestro.dat');
  Assign(detalle, 'detalles.dat');
repeat
  imprimirMenu(opcion);
  case opcion of
    1: actualizarDatos(maestro, detalle);
    2: exportarATexto(maestro,reportStock); 
  end;
until(opcion = 0);

end.