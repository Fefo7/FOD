program ejer2;
const
    charEspecial = '@';
type
    str30 = string[30];
    asistente = record
        id: Integer;
        apellido: str30;
        nombre: str30;
        email: str30;
        telefono: Integer;
        dni: Integer;
    end;
    archivo= file of asistente;
procedure impirmirAsistente(a:asistente);
begin
  if a.nombre[1] = '@' then
        WriteLn('fue borrado')
  else
    with a do WriteLn('ID del asistente: ', a.id, ' nombre completo: ', a.nombre,' ',a.apellido,' dni: ', a.dni);

end;
procedure Imprimir1por1(var arch: archivo);
var 
    a:asistente;
begin
  WriteLn('----------Todos los empleados 1 por 1----------');  
  Reset(arch);
  while not EOF(arch) do
  begin
    Read (arch, a);
    impirmirAsistente(a);
  end;
  close(arch);
  WriteLn('--------------------------------------------');  
end;
procedure LeerAsistente(var a:asistente);
begin 
 WriteLn('ingrese el nombre del asistente');
 ReadLn(a.nombre);
 if(a.nombre<> 'ZZZ')then
 begin
   WriteLn('ingrese el id del asistente');
    ReadLn(a.id);
    WriteLn('ingrese el DNI del asistente');
    ReadLn(a.dni);
    WriteLn('ingrese el apellido del asistente');
    ReadLn(a.apellido);
    WriteLn('ingrese el email del asistente');
    ReadLn(a.email);
    WriteLn('ingrese el telefono del asistente');
    ReadLn(a.telefono);
 end;
    
end;
procedure  CrearArchivo(var arch: archivo);
var 
   nombre: String;
begin
  WriteLn('ingrese el nombre del archivo');
  ReadLn(nombre);
  Assign(arch,nombre );
  Rewrite(arch);
end;
procedure CargarArchivo(var arch:archivo);
var
    a:asistente;
begin
  Reset(arch);
  WriteLn('Para finalizar ingres ZZZ en el nombre');
  LeerAsistente(a);
  while (a.nombre<>'ZZZ') do
  begin
    Write(arch, a);
    LeerAsistente(a);
  end;
  Close(arch);
end;
procedure eliminarFormaLogica(var arch:archivo);
var
    a:asistente;
begin 
  Reset(arch);
  while (not Eof(arch)) do
  begin
    Read(arch,a);
    if(a.id < 1000)then
    begin
         a.nombre:= charEspecial+ a.nombre;
         Seek(arch, filepos(arch)-1);
         Write(arch, a);
    end;
  end;
  Close(arch);
end;
var
    arch: archivo;
begin
    CrearArchivo(arch);
    CargarArchivo(arch);
    eliminarFormaLogica(arch);
    Imprimir1por1(arch); // este es de test nada mas
end.