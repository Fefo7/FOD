program ejer1;
const
  nomArchT1='todos_empleados';
  nomArchT2 = 'faltaDNIEmpleado';
type
    empleado = record
    numEmp: Integer;
    apellido: string;
    nombre: string;
    edad:Integer;
    dni: integer;
  end;
  archivo = file of empleado;

procedure InicializarArchivo(var arch:archivo; nombre:String);
begin
  Assign(arch,nombre);
  Rewrite(arch);
end;
procedure InicializarArchivoTexto(var archT: text; nombre: String);
begin
  Assign(archT,nombre);
  Rewrite(archT);
end;
procedure impirmirEmpleado(e:empleado);
begin
  WriteLn('Numero de empleado: ', e.numEmp, ' nombre completo: ',
        e.nombre,' ',e.apellido, ' edad: ', e.edad, ' dni: ', e.dni);
end;

procedure cargarEmpleado(var e:empleado;var notEnd: boolean);
begin
  WriteLn('ingrese el apellido');
  ReadLn(e.apellido);
  if(e.apellido <> 'fin') then
    begin
        WriteLn('ingrese el numero de empleado');
        ReadLn(e.numEmp);
        WriteLn('ingrese el nombre');
        ReadLn(e.nombre);
        WriteLn('ingrese la edad');
        ReadLn(e.edad);
        WriteLn('ingrese el dni');
        ReadLn(e.dni);
        notEnd:= true;
    end
   else
        notEnd:= false;
end;

procedure CargarArchivo(var arch:archivo);
var
    e:empleado;
    nombre: string;
    notEnd: Boolean;
begin
  WriteLn('ingrese el nombre del archivo');
  ReadLn(nombre);
  InicializarArchivo(arch, nombre); 
  cargarEmpleado(e,notEnd);
  while notEnd do
  begin
    write(arch, e);
    cargarEmpleado(e,notEnd);
  end;
  Close(arch);
end;
procedure ImprimirEmpleadosDete(var arch: archivo);
var
    buscar: string;
    e:empleado;
begin
  WriteLn('----------Empleados determinados----------');
  WriteLn('ingrese el nombre o apellido que quiera buscar');
  ReadLn(buscar);
  Reset(arch);
  while not EOF(arch) do
  begin
    Read (arch, e);
    if((e.nombre= buscar) or (e.apellido = buscar))then
      impirmirEmpleado(e);
  end;
  Close(arch);
  WriteLn('--------------------------------------------');  
end;

procedure Imprimir1por1(var arch: archivo);
var 
    e:empleado;
begin
  WriteLn('----------Todos los empleados 1 por 1----------');  
  Reset(arch);
  while not EOF(arch) do
  begin
    Read (arch, e);
    impirmirEmpleado(e);
  end;
  close(arch);
  WriteLn('--------------------------------------------');  
end;
procedure ImprimirJubilados(var arch:archivo);
var 
    e:empleado;
begin
  WriteLn('----------Todos los empleados pronto a jubilarse----------');    
  Reset(arch);
  while not EOF(arch) do
  begin
    Read (arch, e);
    if(e.edad> 70) then
        impirmirEmpleado(e);
  end;
  close(arch);
  WriteLn('--------------------------------------------');
end;

procedure BuscarCoincidente(var arch:archivo; var coincidente:Boolean ;e:empleado );
var 
  emp:empleado;
begin
  reset(arch);
  while (not Eof(arch)) and  (not coincidente) do
  begin
    read(arch, emp);
    if(emp.numEmp = e.numEmp) then
      coincidente:= true;
  end;
  Close(arch);

end;
procedure AgregarEmpleadoNuevo(var arch:archivo; newE:empleado);
begin
  Reset(arch);
  Seek(arch, FileSize(arch));
  Write(arch, newE);
  Close(arch);
end;
procedure AddEmpleado(var arch: archivo);
var
  e:empleado;
  notEnd,coincidente:Boolean;
  
begin
  repeat
      WriteLn('Para volver atras ingrese fin como apellido');
      coincidente:= false;
      cargarEmpleado(e, notEnd);
      BuscarCoincidente(arch, coincidente, e);
      if(not coincidente and notEnd) then
        AgregarEmpleadoNuevo(arch, e)
      else
        begin
          If(coincidente)then
            WriteLn('no se puede cargar un empleado con el mismo numero');
        end;
  until (not notEnd) ;
end;
procedure ModificarEdadEmpleado(var arch:archivo);
var
  empAbuscar:empleado;
  edadAcambiar: Integer;
  numEmp: integer;
begin
  WriteLn('Ingrese el numero de empleado que quiera cambiar');
  ReadLn(numEmp);
  Reset(arch);
  read(arch,empAbuscar);
  while (not eof(arch) ) and (empAbuscar.numEmp <> numEmp) do
  begin
      Read(arch,empAbuscar);
  end;
  if(empAbuscar.numEmp = numEmp)then
  begin
      WriteLn('ingrese la edad que quiera modificar');
      ReadLn(edadAcambiar);
      empAbuscar.edad:= edadAcambiar;
      seek(arch, filepos(arch)-1);
      write (arch, empAbuscar);
  end;
  Close(arch);
end;
procedure ExportarAtxt(var arch:archivo);
var
  archT: text;
  e:empleado;
begin
  InicializarArchivoTexto(archT, nomArchT1);
  reset(arch);
  while not Eof(arch) do
    begin
      Read(arch,e);
      with e do WriteLn(archT,' ', numEmp, ' ', apellido, ' ', nombre, ' ',edad,' ', dni);
    end;  
  Close(archT);
  Close(arch);
 
end;
procedure ExportarAtxtDNI(var arch:archivo);
var
  archT: text;
  e:empleado;
begin
  InicializarArchivoTexto(archT, nomArchT2);
  reset(arch);
  while(not Eof(arch)) do
    begin
      Read(arch,e);
      if(e.dni = 00)then
          with e do WriteLn(archT,' ', numEmp, ' ', apellido, ' ', nombre, ' ',edad,' ', dni);
        
    end;
  close(archT);
  close(arch);
end;

procedure RealizarBajas(var arch: archivo);
var
  e,empAux:empleado;
  pos:Integer;
  condi: Boolean;
begin
  Reset(arch);
  WriteLn('ingrese el numero de empleado a dar de baja');
  ReadLn(empAux.numEmp);
  pos:= 01;
  condi:= False;
  while (not Eof(arch)and (not condi)) do
  begin
    Read(arch,e);
    if(e.numEmp = empAux.numEmp)then  
    begin
      condi:= true;
      empAux:= e;
    end
    else
      pos:= pos +1;
  end;

  Seek(arch, FileSize(arch)-1);
  Read(arch, e);
  Seek(arch, pos);
  Write(arch, e);
  Seek(arch,  FileSize(arch)-1);
  Truncate(arch);
  Close(arch);
end;

var
    arch:archivo;
    opcion: integer;
begin
  
  repeat
    WriteLn('Ingrese la opcion que requiera');
    WriteLn('1- Crear un archivo con empleados');
    WriteLn('2- Busqueda de empleados segun el nombre o apellido');
    WriteLn('3- Todos los empleados de a una linea');
    WriteLn('4- Empleados pronto a jubilar');
    WriteLn('5- Agregar 1 o mas empeleados');
    WriteLn('6- Modificar la edad de un empelado');
    WriteLn('7- Exportar a texto');
    WriteLn('8- Exportar a texto sin dni');
    WriteLn('9- Realizar bajas');
    WriteLn('0- Salir');
    ReadLn(opcion);
    
    case opcion of
        1: begin
            CargarArchivo(arch);
        end;
        2: begin
            ImprimirEmpleadosDete(arch);
        end;
        3: begin
            Imprimir1por1(arch);
        end;
        4: begin
            ImprimirJubilados(arch);
        end;
        5: begin
            AddEmpleado(arch);
        end;
        6: begin
            ModificarEdadEmpleado(arch);
        end;
        7: begin
            ExportarAtxt(arch);
        end;
        8: begin
            ExportarAtxtDNI(arch);
        end;
        9: begin
            RealizarBajas(arch);
        end;
    end;

until (opcion = 0);

end.