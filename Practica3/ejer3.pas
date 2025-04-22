program ejer3;
const
    nombreTxt= 'novelas.txt';
type
    str= String[30];
    novela = record
        cod: Integer;
        genero: str;
        nombre: str;
        duracion: Real;
        director: str;
        precio:Real;
    end;
    archNovela = file of novela;

procedure  impirmirNovela(n: novela);
begin
  with n do WriteLn ('codigo: ', cod, ' nombre: ', nombre, ' precio: ', precio:2:0);
end;
procedure Imprimir1por1(var arch: archNovela);
var 
    n:novela;
begin
  WriteLn('----------Todos los empleados 1 por 1----------');  
  Reset(arch);
  while not EOF(arch) do
  begin
    Read (arch, n);
    impirmirNovela(n);
  end;
  close(arch);
  WriteLn('--------------------------------------------');  
end;

procedure ImprimirMenu(var opcion: integer);
begin
  WriteLn('1- crear el archivo');
  WriteLn('2- alta de una novela');
  WriteLn('3- actulizar datos de novela');
  WriteLn('4- baja de novela');
  WriteLn('5- crear el archivo de texto');
  WriteLn('9- test del archivo de novelas');
  WriteLn('0- para salir');
  ReadLn(opcion);
end;
procedure  LeerNovela(var n: novela);
begin
  WriteLn('ingrese el nombre de la novela');
  ReadLn(n.nombre);
  if( n.nombre  <> 'zzz' )then
  begin
    WriteLn('ingrese el codigo de la novela');
    ReadLn(n.cod);
    WriteLn('ingrese el genero de la novela');
    ReadLn(n.genero);
    WriteLn('ingrese el duracion de la novela');
    ReadLn(n.duracion);
    WriteLn('ingrese el director de la novela');
    ReadLn(n.director);
    WriteLn('ingrese el precio de la novela');
    ReadLn(n.precio);
  end;
end;
procedure CrearArchivo(var arch: archNovela);
var
    n:novela;
    nombre: str;
begin
    WriteLn('ingrese el nombre del archivo');
    ReadLn(nombre);
    Assign(arch,nombre);
    WriteLn('ingrese zzz en el nombre de la novela para terminar la carga');
    Rewrite(arch);
    n.cod:= 0; n.genero:= '0';n.nombre:= 'lista invertida'; n.duracion:= 0; n.director:= '0'; n.precio:=0;
    Write(arch, n); // el archivo ficticio para  la lista invertida
    LeerNovela(n);
    while (n.nombre<>'zzz') do
    begin
        Write(arch, n);
        LeerNovela(n);
    end;
    Close(arch);
end;
// ---------------------------ABM de novela---------------------------
procedure AltaNovela(var arch:archNovela);
var
    n,regCa,auxN:novela;
    posIni: Integer;
begin
  Reset(arch);
  Read(arch, regCa);
  posIni:= FilePos(arch);
  LeerNovela(n);
  if(n.nombre<> 'zzz') and(regCa.cod < 0) then
  begin
    Seek(arch, (regCa.cod*-1));
    Read(arch, auxN);
    Seek(arch, FilePos(arch)-1);
    Write(arch,n);
    Seek(arch, 0);
    Write(arch, auxN);
  end
  else
  begin
    Seek(arch, FileSize(arch));
    Write(arch,n);
  end;
  Close(arch);
end;
procedure ModificarNovela(var arch: archNovela);
var 
    n,auxN:novela;
    condi: Boolean;
begin
  LeerNovela(n);
  Reset(arch);
  condi := False;
  Read(arch,n);
  while (not Eof(arch)and (not condi)) do 
  begin
        Read(arch,auxN);
        condi:= n.cod =auxN.cod;
  end;
  if(condi)then // si condi en true es por que lo encontre
  begin
    auxN.genero:= n.genero; auxN.nombre:= n.nombre; auxN.duracion:= n.duracion; auxN.director:= n.director; auxN.precio:= n.precio;
    Seek(arch, FilePos(arch)-1);
    Write(arch,auxN);
  end
  else
      WriteLn('Registro no encontrado.');
  Close(arch);
end;
procedure BajaNovela(var arch: archNovela);
var
    cod,posIni: Integer;
    n,auxN,regCa:novela;
    condi:Boolean;
begin   
    WriteLn('ingrese el codigo a eliminar');
    ReadLn(cod);
    condi:= false;
    Reset(arch);
    Read(arch,regCa);
    posIni:= FilePos(arch); // eliminar
    //suponemos que existe el codigo a eliminar o hay que verificar primero si existe el codigo dentro del archivo?
   while (not Eof(arch)and (not condi)) do
   begin
        Read(arch,n);
        condi:= (n.cod=cod);
   end;
   if condi then // en  n = registro eliminar
   begin
     auxN:= n;
     n := regCa;
     Seek(arch, FilePos(arch)-1);
     Write(arch, n);
     regCa.cod:= ((FilePos(arch)-1)*-1);
     Seek(arch,0);
     Write(arch,regCa);
   end
   else
     WriteLn('Registro no encontrado.');
   Close(arch);
end;


//-------------------------------------------------------------------
procedure CrearArchivoTexto(var arch: archNovela; var  archText:Text);
begin
  Assign(archText, nombreTxt);
  Rewrite(archText);
  Close(archText);

end;




var
    arch: archNovela;
    archText: Text;
    opcion:Integer;
begin
  repeat
     ImprimirMenu(opcion); 
     case opcion of
     1: CrearArchivo(arch);
     2: AltaNovela(arch);
     3:ModificarNovela(arch);
     4:BajaNovela(arch);
     5: CrearArchivoTexto(arch, archText);
     9:Imprimir1por1(arch);
     end;

  until (opcion = 0);
end.