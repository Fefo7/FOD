program Ejer4;
const
    valorAlto = 'zzz';
var
    maestro: archRegistro;
    censo1, censo2 : archDetalle;
type
    str = String[30];
    registro = record
        nomProvincia: str;
        cantAlfa: integer;
        totalEncuestados: Integer;
    end;
    censo = record
        nomProvincia:str;
        codLocalidad: Integer;
        cantAlfa: integer;
        cantEncuestrados: integer;
    end;

    archRegistro = file of registro;
    archDetalle = file of censo;
procedure CrearArchivos(var maestro: archRegistro; var censo1,censo2: archDetalle);
begin
    Assign(maestro,'maestro.dat');
    Assign(censo1,'detalle1.dat');
    Assign(censo2,'detalle2.dat');
    Rewrite(maestro);
    Rewrite(censo1);
    Rewrite(censo2);

end;

procedure Leer (var arch: censo; var dato:censo);
begin
    if (not eof(arch)) then
        read(arch,dato)
    else
        dato.nomProvincia:= valorAlto;
end;
procedure calcularMinimo(var c1,c2: censo; var minimo:censo);
begin
  if(c1.nomProvincia < c2.nomProvincia)then
    begin
      minimo:= c1;
      Leer(censo1,c1);
    end
    else
        begin
          minimo:=c2;
          Leer(censo2,c2);
        end;
end;
var
    maestro: archRegistro;
    censo1, censo2 : archDetalle;
    det1,det2,minimo: censo;
    Rmae: registro;
    
begin

CrearArchivos(maestro,censo1,censo2);

CargarMaestro(maestro); // se dispone
CargarDetalle(censo1);  // se dispone
CargarDetalle(censo2);  // se dispone

Reset(maestro);
Reset(censo1);
Reset(censo2);

Leer(censo1,det1);
Leer(censo2, det2);
calcularMinimo(det1,det2,minimo);

while minimo.nomProvincia <> valorAlto do
begin
    Read(maestro,Rmae);
    while Rmae.nomProvincia<> minimo.nomProvincia do
    begin
        Read(maestro,Rmae);
    end;

    while (Rmae.nomProvincia = minimo.nomProvincia) do
    begin
        Rmae.cantAlfa:= Rmae.cantAlfa + minimo.cantAlfa;
        Rmae.totalEncuestados:= Rmae.totalEncuestados + minimo.cantEncuestrados;
        calcularMinimo(det1,det2,minimo);
    end;

    Seek(maestro, FilePos(maestro)-1);
    Write(maestro,Rmae);
end;
Close(maestro);
Close(det1);
Close(det2);

end.