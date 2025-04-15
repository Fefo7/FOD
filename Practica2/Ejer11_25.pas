program Ejer11_25;
const   
    maxR = 15;
type    
    rango= 1..maxR;
    empleado = record
        dep: Integer;
        division:Integer;
        numEmp:Integer;
        categoria: rango;
        cantHs: Integer;
    end;
    precioHora = record
        cate: rango;
        precio: real;
    end;
    arch = file of empleado;
    vec = array[rango] of real;

procedure AsignarMaestro(var m: arch);
var 
    nombre: String;
begin
  WriteLn('ingrese el nombre del maestro');
  ReadLn(nombre);
  Assign(m,nombre);
end;

procedure CargarHoras(var horas: text;var precHs:vec);
var
    ph: precioHora;
begin 
    Reset(horas);
    while (not Eof(horas)) do
      begin
        readLn(horas,ph);
        precHs[ph.cate]:= ph.precio;
      end;
    Close(horas);
end;
procedure ProcesarArchivo(var mae: arch;precHs:vec);
var
  depAct, divAct:Integer;
  totHsDiv, totHsDep:Integer;
  totMontDiv,totMontDep:real; 
  regM:empleado;
begin
  Reset(mae);
  while (not Eof(mae)) do
  begin
    totHsDep:= 0;
    totMontDep:=0;
    Read(mae,regM);
    depAct:= regM.dep;
    WriteLn('departamento: ', depAct);
    while (regM.dep = depAct) do
    begin
      totHsDiv:=0;
      totMontDiv:=0;
      divAct:= regM.division;
      WriteLn('division: ', divAct);
      while (regM.division = divAct) do
      begin
        WriteLn('Numero empledo', regM.numEmp, 
        'Total de hs: ', regM.cantHs, 
        'Importe a cobrar',
        (regM.cantHs*precHs[regM.categoria]));
        totHsDiv:=totHsDiv + regM.cantHs;
        totMontDiv:= totMontDiv +(regM.cantHs*precHs[regM.categoria]);
        Read(mae,regM);
      end;
      WriteLn('Total horas division ', divAct, ':', totHsDiv);
      WriteLn('Total monto division ', divAct, ':', totMontDiv);
      totHsDep:= totHsDep + totHsDiv;
      totMontDep:= totMontDep+ totMontDiv;
    end;
     WriteLn('Total horas del departamento ', depAct, ':', totHsDep);
     WriteLn('Total monto del departamento ', depAct, ':', totMontDep);
  end;
  Close(mae);
end;
var
    mae: arch;
    horas: text;
    precHs: vec;
begin
  Assign(horas, 'horasPrecio.txt');
  AsignarMaestro(mae); //esta ordenado por departameto, division y numEmp
  CargarHoras(horas, precHs);
  ProcesarArchivo(mae,precHs);
end.


{
Se tiene información en un archivo de las horas extras realizadas por los empleados de una
empresa en un mes. Para cada empleado se tiene la siguiente información: departamento,
división, número de empleado, categoría y cantidad de horas extras realizadas por el
empleado.

Se sabe que el archivo se encuentra ordenado por departamento, luego por
división y, por último, por número de empleado.

Presentar en pantalla un listado con el siguiente formato:

Departamento
División
Número de Empleado Total de Hs. Importe a cobrar
...... .......... .........
...... .......... .........
Total de horas división: ____
Monto total por división: ____
División
.................
Total horas departamento: ____
Monto total departamento: ____

Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al
iniciar el programa con el valor de la hora extra para cada categoría. La categoría varía
de 1 a 15. En el archivo de texto debe haber una línea para cada categoría con el número
de categoría y el valor de la hora, pero el arreglo debe ser de valores de horas, con la
posición del valor coincidente con el número de categoría.
}