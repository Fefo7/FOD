program Ejer8;

const
    dF = 10;
    valorAlto = 9999;

type
    subrango = 1 .. dF;

    registroMaestro = record
        codigoLocalidad: integer;
        nombreLocalidad: string;
        codigoCepa: integer;
        cantCasosActivos: integer;
        cantCasosNuevos: integer;
        cantCasosRecuperados: integer;
        cantCasosFallecidos: integer;
    end;

    registroDetalle = record
        codigoLocalidad: integer;
        codigoCepa: integer;
        cantCasosActivos: integer;
        cantCasosNuevos: integer;
        cantCasosRecuperados: integer;
        cantCasosFallecidos: integer;
    end;

    archivoMaestro = file of registroMaestro;
    archivoDetalle = file of registroDetalle;

    vectorDetalles = array [subrango] of archivoDetalle;
    vectorRegistros = array [subrango] of registroDetalle;

procedure crearArchivoMaestro(var archM: archivoMaestro); // se dispone
begin
    // Implementar aquí si es necesario
end;

procedure crearArchivoDetalle(var archD: archivoDetalle); // se dispone
begin
    // Implementar aquí si es necesario
end;

procedure crearArchivosDetalles(var vectorD: vectorDetalles);
var
    i: subrango;
begin
    for i := 1 to dF do
        crearArchivoDetalle(vectorD[i]); // se dispone
end;

procedure leer(var archD: archivoDetalle; var regD: registroDetalle);
begin
    if (not EOF(archD)) then
        read(archD, regD)
    else
        regD.codigoLocalidad := valorAlto; // valor de corte
end;

procedure buscarMinimo(var vectorD: vectorDetalles; var vectorR: vectorRegistros; var minimo: registroDetalle);
var
    i, pos: subrango;
begin
    minimo.codigoLocalidad := valorAlto;
    minimo.codigoCepa := valorAlto;
    for i := 1 to dF do
    begin
        if (vectorR[i].codigoLocalidad < minimo.codigoLocalidad) or
           ((vectorR[i].codigoLocalidad = minimo.codigoLocalidad) and (vectorR[i].codigoCepa < minimo.codigoCepa)) then
        begin
            minimo := vectorR[i];
            pos := i;
        end;
    end;
    if (minimo.codigoLocalidad <> valorAlto) then
        leer(vectorD[pos], vectorR[pos]);
end;

procedure actualizarArchivoMaestro(var archM: archivoMaestro; var vectorD: vectorDetalles);
var
    i: subrango;
    cantLocalidades: integer;
    cantTotalPositivos: integer;
    minimo: registroDetalle;
    regM: registroMaestro;
    vectorR: vectorRegistros;
begin
    reset(archM);
    for i := 1 to dF do
    begin
        reset(vectorD[i]);
        leer(vectorD[i], vectorR[i]);
    end;
    cantLocalidades := 0;

    buscarMinimo(vectorD, vectorR, minimo);
    while (minimo.codigoLocalidad <> valorAlto) do
    begin
        cantTotalPositivos := 0; // reiniciar contador
        read(archM, regM);
        while (minimo.codigoLocalidad <> regM.codigoLocalidad) do
            read(archM, regM);
        while (minimo.codigoLocalidad = regM.codigoLocalidad) do
        begin
            while (minimo.codigoCepa <> regM.codigoCepa) do
                read(archM, regM);
            while (minimo.codigoLocalidad = regM.codigoLocalidad) and (minimo.codigoCepa = regM.codigoCepa) do
            begin
                regM.cantCasosFallecidos := regM.cantCasosFallecidos + minimo.cantCasosFallecidos;
                regM.cantCasosRecuperados := regM.cantCasosRecuperados + minimo.cantCasosRecuperados;
                regM.cantCasosActivos := minimo.cantCasosActivos;
                regM.cantCasosNuevos := minimo.cantCasosNuevos;

                // Acumular casos activos por localidad
                cantTotalPositivos := cantTotalPositivos + minimo.cantCasosActivos;
                buscarMinimo(vectorD, vectorR, minimo);
            end;
            seek(archM, filePos(archM) - 1);
            write(archM, regM);
        end;
        if (cantTotalPositivos > 50) then
            cantLocalidades := cantLocalidades + 1;
    end;

    writeln('La cantidad de localidades con más de 50 casos activos es: ', cantLocalidades);
    close(archM);
    for i := 1 to dF do
        close(vectorD[i]);
end;

var
    archM: archivoMaestro;
    vectorD: vectorDetalles;
begin
    crearArchivoMaestro(archM); // se dispone
    crearArchivosDetalles(vectorD);
    actualizarArchivoMaestro(archM, vectorD);
end.
