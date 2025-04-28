program ejer6;
const
    valorCorte = 999;
type
    str30 = string[30];
    prenda =record
        cod_prenda: Integer;
        descripcion: str30;
        colores: str30;
        tipo_prenda: str30;
        stock: Integer; // para borrado este campo en negativo
        precio_unitario: Real;
    end;

    archPrenda = file of prenda; //archivo maestro
    archDeta = file of Integer;
    // conviene recorrer el maestro y preguntar si esta el codigo en el detalle
    // en ese caso si implementar marca de borrado

procedure Leer(var arch: archPrenda; var p:prenda);
begin
  if(not Eof(arch))then
    read(arch,p)
  else
    p.cod_prenda := valorCorte;
end;
procedure LeerDetalle(var archD: archDeta; var cod_prenda:Integer);
begin
  if(not Eof(archD))then
    read(archD,cod_prenda)
  else
    cod_prenda := valorCorte;
end;
procedure AsignarArchivos(var archP: archPrenda; var archD: archDeta);
begin
  Assign(archP, 'test.dat');
  Assign(archD,'test2.dat');
end;
procedure BajaLogicasPrendas(var archP: archPrenda; var archD: archDeta);
var
    regP:prenda;
    cod_prenda: Integer;
begin
    {recorro el archivo maestro una sola vez en busca si hay algun detalle 
     ya que eventualmente el detalle va a ser mas corto para recorrelo}
    Reset(archP);
    Reset(archD);
    Leer(archP, regP);
    while (regP.cod_prenda <> valorCorte) do
    begin  
         LeerDetalle(archD, cod_prenda);
         while (regP.cod_prenda <> valorCorte) and  (cod_prenda <> valorCorte) and (regP.cod_prenda <> cod_prenda) do
         begin
            Leer(archP,regP);
            LeerDetalle(archD,cod_prenda);
         end;
        if(regP.cod_prenda = cod_prenda)then
        begin
            regP.stock:= regP.stock *-1;
            Seek(archP, FilePos(archP)-1);
            Write(archP,regP); // avanza mi puntero y no es necesario leer?
        end;
        Seek(archD, 0);// me re posiciono para recetear el indice del puntero del registro detalle
    end;
    Close(archP);
    Close(archD);
end;
procedure CrearNuevoArchivoPrendas(var  archP: archPrenda;var archPNew:archPrenda);
var
    p: prenda;
begin
    Assign(archPNew,'testNew.dat');
    Rewrite(archPNew);
    Reset(archP);
    Leer(archP,p);
    while (p.cod_prenda <> valorCorte) do
    begin
        if(p.stock >0 )then
        begin
          Write(archPNew, p);
        end;
        Leer(archP,p);
    end;
    rename(archP,'testOLD.dat');
    rename(archPNew, 'test.dat');
end;
var
    archP,archPNew: archPrenda;
    archD: archDeta;
begin
    AsignarArchivos(archP, archD);
    CargarArchivoMaestro(archP); // se diponen?
    CargarArchivoDetalle(archD); // se disponen?
    BajaLogicasPrendas(archP,archD);
    CrearNuevoArchivoPrendas(archP,archPNew);
end.