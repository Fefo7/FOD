program parcialCorteControl;
const
    valorAlto= 999;
type
    tVta = record
        codSuc: Integer;
        idAutor: Integer;
        isbn: Integer;
        idEj:Integer;
    end;
     tArchVta = file of tVta;

procedure leer(var arch: tArchVta;var  dato:tVta);
begin
  if(not eof(arch))then 
    Read(arch,dato)
  else
    dato.codSuc:= valorAlto;
end;

procedure totalizar(var arch: tArchVta; nombre: String);
var
    texto: Text;
    v: tVta;
    codSucAct, idAutorAct, isbnAct,idEjAct: Integer;
    totalEjem,totalEjemXAutor, totalVendidosSuc, totalGeneral: integer;
begin
  Assign(texto, nombre);
  Rewrite(texto);
  Reset(arch); 
  leer(arch, v);
  totalGeneral:= 0;
  while (v.codSuc <> valorAlto) do
  begin
    totalVendidosSuc:= 0;
    codSucAct:= v.codSuc;
    WriteLn(texto,'Codigo de sucursal', codSucAct);
    while (v.codSuc = codSucAct) do
    begin
        idAutorAct:= v.idAutor;
        totalEjemXAutor:= 0;
        WriteLn(texto,'Identificardor de autor', idAutorAct);
        while (v.codSuc = codSucAct) and (v.idAutor=idAutorAct) do
        begin
          isbnAct:= v.isbn;
          totalEjem:= 0;
          while (v.codSuc = codSucAct) and (v.idAutor=idAutorAct) and (v.isbn=isbnAct) do
          begin
                totalEjem:= totalEjem +1;
                leer(arch, v);
          end;
          totalEjemXAutor:= totalEjemXAutor + totalEjem;
          WriteLn(texto,'isbn: ',isbnAct,'.Total de ejemplares vendidos del libro: ', totalEjem);
        end;       
        totalVendidosSuc:= totalVendidosSuc + totalEjemXAutor;
        WriteLn(texto,'Total de ejemplares vendidos del autor: ', totalEjemXAutor);   
    end;
    totalGeneral:= totalGeneral+totalVendidosSuc;
    WriteLn(texto,'Total de ejemplares vendidos en sucursal: ',totalVendidosSuc);
  end;
  WriteLn(texto,'Total general de ejemplares vendidos en la cadena: ', totalGeneral);
  Close(arch);
  Close(texto);
end;
var 
    arch: tArchVta;
    nombre:String;
begin
  Assign(arch, 'archivo.dat');
  WriteLn('ingrese el nombre para totalizar');
  ReadLn(nombre);
  totalizar(arch, nombre);
end.