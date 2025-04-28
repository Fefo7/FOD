program ejer7;
const 
    valorCorte= 999;
type
    str30 = String[30];
    aves = record
        cod: Integer;
        nomEspecie: str30;
        familiaAve: str30;
        des: string;
        zonageografica: string;
    end;

    arch = file of aves;
procedure Leer(var a: arch; var ave:aves);
begin
  if(not Eof(a))then
    read(a,ave)
  else
    ave.cod := valorCorte;
end;
procedure BorrarUnAve(var archAves: arch);
var
    code: Integer;
    ave: aves;
begin
  WriteLn('ingrese el codigo que quiera borrar');
  ReadLn(code);
  Reset(archAves);
  Leer(archAves,ave );
  while (ave.cod <> valorCorte) and (ave.cod<> code) do
  begin
   Leer(archAves,ave);
  end;
 if(ave.cod = code)then
 begin
    ave.cod:= ave.cod *-1;
    Seek(archAves, FilePos(archAves)-1);
    Write(archAves,ave);
 end;
  Close(archAves);
end;
procedure CompactarArchivo(var archAves:arch);
var
    ave,aux:aves;
    pos:Integer;
begin
  Reset(archAves);
  Leer(archAves,ave);
  while (ave.cod <> valorCorte) do
  begin
    if(ave.cod<0)then
    begin
        pos:= FilePos(archAves)-1;
        Seek(archAves, FileSize(archAves)-1);
        Read(archAves, aux);
        Seek(archAves, pos);
        Write(archAves,aux);
        Seek(archAves, FileSize(archAves)-1);
        Truncate(archAves);
    end;
    Leer(archAves,ave);
  end;
  Close(archAves);
end;
procedure CompactarArchivoFiscio(var archAves: arch);
var
    ave,aux:aves;
    pos,cont:Integer;
begin
  Reset(archAves);
  Leer(archAves,ave);
  cont:=1; // este contador me va decir el inicio de los borrados
  while (ave.cod <> valorCorte) do
  begin
    if(ave.cod<0)then
    begin
        pos:= FilePos(archAves)-1; //posicion del que quiero borrar
        Seek(archAves, FileSize(archAves)-cont);
        Read(archAves, aux);
        Seek(archAves, pos);
        Write(archAves,aux);
        cont:= cont +1;
        
    end;
    Leer(archAves,ave);
  end;
  Seek(archAves, FileSize(archAves)-cont);  // uso el contador para obtener el inicio de los borrados
  Truncate(archAves);
  Close(archAves);
end;
var
  archAves: arch;
begin
  Assign(archAves,'test.dat');
  BorrarUnAve(archAves);
  CompactarArchivo(archAves);
  CompactarArchivoFiscio(archAves);
end.