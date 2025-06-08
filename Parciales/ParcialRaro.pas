program ParcialRaro;
const
    valorAlto  = 999;
type
    profesional = record
        dni: Integer;
        nombre: String;
        apellido: String;
        sueldo: real;   
    end;
    tArchivo =  File of profesional;

procedure leer (var arch: tArchivo; dato: profesional);
begin
  if(not Eof(arch))then
    Read(arch,dato)
  else 
    dato.dni := valorAlto;
end;

procedure crear(var arch: tArchivo; var info: text);
var
    p:profesional;
begin
  Reset(info);
  Rewrite(arch);
  p.dni:= 0; p.nombre:= 'cabecera'; p.apellido:= 'cabecera';
  p.sueldo:= 0;
  Write(arch,p);
  while (not eof(info)) do
  begin
    with p do begin 
        Read (info, dni, sueldo, nombre);
        Read (info, apellido);
        end;
    Write(arch, p);
  end;
  Close(arch);
  Close(info);
end;

procedure agregar(var arch:tArchivo; p: profesional);
var
    regCabe: profesional;
begin
    Reset(arch);
    Read(arch,regCabe);
    if(regCabe.dni = 0)then
    begin
      Seek(arch, FileSize(arch));
      Write (arch, p);
    end
    else begin
      Seek(arch, (regCabe.dni*-1));
      read(arch, regCabe);
      Seek(arch, FilePos(arch)-1);
      Write(arch, p);
      Seek(arch, 0);
      Write(arch,regCabe);
    end;      
    Close(arch);
end;
procedure eliminar(var arch: tArchivo; dni:Integer; var bajas: text);
var
    p:profesional;
    regCabe: profesional;
begin
   reset(arch);
   Rewrite(bajas);
   Read(arch, regCabe);
   leer(arch,p);
    while (p.dni <> valorAlto) and (p.dni<> dni)  do
        leer(arch,p);
    if(p.dni = dni)then
    begin
      with p do begin
        WriteLn(bajas, dni, ' ', sueldo,' ', nombre);
        WriteLn(bajas, apellido);
      end;
      Seek(arch, FilePos(arch)-1);
      write(arch, regCabe);
      p.dni:= ((FilePos(arch)-1)*-1);
      Seek(arch, 0);
      Write(arch, p);
    end
    else
       begin
         WriteLn('la persona no existe');
       end;
   Close(bajas);
   Close(arch);
end;

begin
  Assign(arch, 'maestro.dat');
  Assign(info, 'info.txt');
   Assign(bajas, 'bajas.txt');
end.