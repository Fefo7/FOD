program ejer3;
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
        WriteLn('ingrese el numerod e empleado');
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
  WriteLn('inrgese el nombre del archivo');
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
    end;

until (opcion = 0);

end.