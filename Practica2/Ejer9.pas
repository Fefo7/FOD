program Ejer9;

type

    registroCliente = record
        codigo: integer;
        nombre: string;
        apellido: string;
    end;


    registroMaestro = record
        cliente: registroCliente;
        anio: integer;
        mes: integer;
        dia: integer;
        monto: real;
    end;

    archivoMaestro = file of registroMaestro;

procedure informarArchivoMaestro (var archM: archivoMaestro);
var
    regM: registroMaestro;
    totalMensual, totalAnual, totalEmpresa: real;
    codigoActual, anioActual, mesActual, cantVentas: integer;
begin
    reset (archM);
    totalEmpresa := 0;
    
    while (not EOF (archM)) do begin
        read (archM, regM);
        codigoActual := regM.cliente.codigo;
        writeln ('El cliente es ', regM.cliente.nombre , ' ', regM.cliente.apellido, '. Su codigo es: ', regM.cliente.codigo);
        while (regM.cliente.codigo = codigoActual) do begin
            anioActual := regM.cliente.anio;
            totalAnual := 0;
            while (regM.cliente.codigo = codigoActual) and (regM.cliente.anio = anioActual) do begin
                mesActual := regM.cliente.mes;
                totalMensual := 0;
                cantVentas := 0;
                while (regM.cliente.codigo = codigoActual) and (regM.cliente.anio = regM.cliente.anio)
                and (mregM.cliente.mes = mesActual) do begin
                    totalEmpresa := totalEmpresa + regM.monto;
                    totalMensual := totalMensual + regM.monto;
                    cantVentas := cantVentas + 1;
                    read (archM, regM);
                end;
                totalAnual := totalAnual + totalMensual;
                writeln ('En el mes ', mesActual, ' compro un total de : ', cantVentas);
            end;
            writeln ('En el anio ', anioActual, ' se gasto ', totalAnual);
        end;
    end;
    writeln ('El monto total de ventas obtenido por la empresa es: ', totalEmpresa);
    close (archM);
end;


var
    archM: archivoMaestro;
begin
    crearArchivoMaestro (archM); // se dispone
    informarArchivoMaestro (archM);
end.
