program ejer4y5;
const
    valorAlto = 999;
type 
    reg_flor = record 
        nombre: String[45]; 
        codigo: integer; 
    end; 
    tArchFlores = file of reg_flor;
procedure Leer(var arch: tArchFlores; var f:reg_flor);
begin
  if(not Eof(arch))then
    read(arch,f)
  else
    f.codigo := valorAlto;
end;
procedure LeerFLor(var f: reg_flor);
begin
  WriteLn('ingrese el codigo');
  ReadLn(f.codigo);
  if (f.codigo<> valorAlto) then
  begin
    WriteLn('ingrese el nombre');
    ReadLn(f.nombre);
  end;
end;
procedure cargarArchivo(var arch: tArchFlores);
var 
    f: reg_flor;
begin
    Assign(arch, 'test.dat');
    Rewrite(arch);
    f.codigo:= 0; // creo el registro cabecera
    f.nombre:= 'cabecera';
    Write(arch,f);
    LeerFLor(f);
    while (f.codigo <> valorAlto) do
    begin
        Write(arch,f);
        LeerFLor(f);
    end;
    Close(arch);
end;
procedure agregarUnaflor(var arch: tArchFlores);
var
    f,regCabe,aux: reg_flor;
    
begin
   LeerFLor(f);
   Reset(arch);
   Leer(arch, regCabe); 
   if(regCabe.codigo < 0)then
   begin
     Seek(arch,(regCabe.codigo*-1));
     Leer(arch, regCabe); 
     Seek(arch, FilePos(arch)-1);
     Write(arch, f);
     Seek(arch, 0);
     Write(arch,regCabe);
   end
   else
        begin
          Seek(arch, FileSize(arch));
          Write(arch, f);
        end;
    Close(arch);
end;
procedure listarContenido(var arch:tArchFlores);
var
    f:reg_flor;
begin
  Reset(arch);
  Leer(arch, f);
  Read(arch, f); // para saltearnos la cabecera
  while f.codigo <> valorAlto do
  begin
    if(f.codigo >0 ) then
    begin
      with f do WriteLn ('nombre: ' , nombre, ' codigo: ', codigo);
    end;
    Leer(arch, f);
  end;
  Close(arch);
end;
procedure eliminarFlor(var arch: tArchFlores; f:reg_flor);
var 
    regF,regCabe: reg_flor;
begin
  Reset(arch);
  Read(arch, regCabe); // leo el cabecera
  Leer(arch, regF);
  while ((regF.codigo <> valorAlto)and (regF.codigo <> f.codigo)) do
  begin
      Leer(arch, regF);
  end;
  if(regF.codigo = f.codigo)then
  begin
    Seek(arch, FilePos(arch)-1);
    Write(arch, regCabe);
    regF.codigo:= (FilePos(arch)-1)*-1;
    Seek(arch, 0);
    Write(arch, regF);
  end;
  Close(arch);  

end;

var
    arch: tArchFlores;
    opcion: Integer;
    f: reg_flor;
begin
   cargarArchivo(arch);
   repeat
        WriteLn('1- para agregar una flor');
        WriteLn('2- Listar flores');
        WriteLn('3- Eliminar una flor');
        WriteLn('0- para salir');
        ReadLn(opcion);
      case opcion of
         1: agregarUnaflor(arch);
         2: listarContenido(arch);
         3:begin
                WriteLn('ingrese el numero de flor a eliminar');
                ReadLn(f.codigo);
                eliminarFlor(arch, f);
            end; 
         end;
   until opcion = 0;
   
  


end.