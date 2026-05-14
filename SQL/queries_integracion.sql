/* =========================================================
INSTRUCCIONES DE EJECUCIÓN
=========================================================

1. Descomprimir el ZIP del proyecto.
2. Copiar la ruta de la carpeta principal del proyecto.
3. Reemplazar en los BULK INSERT la ruta:

   C:\RUTA_DEL_PROYECTO\

   por la ruta real donde está la carpeta.

4. Ejecutar todo el script.

========================================================= */

/* =========================================================
MODELO DIMENSIONAL - MODELO ESTRELLA
=========================================================

TABLA DE HECHOS:
ventas_final

DIMENSIONES:
1. calendario
2. ubicacion
3. dim_proveedor
4. dim_orden

GRANULARIDAD:
Cada fila de ventas_final representa una venta u orden
realizada en una fecha, ubicación y proveedor específicos.

CLAVES DE INTEGRACIÓN:

ventas_final.fecha_compra = calendario.fecha

ventas_final.distrito = ubicacion.distrito

ventas_final.nombre_proveedor = dim_proveedor.nombre_proveedor

ventas_final.t_orden = dim_orden.t_orden

========================================================= */


/* =========================================================
CREAR BASE DE DATOS
========================================================= */

CREATE DATABASE EmpresaVentas;
GO

USE EmpresaVentas;
GO

/* =========================================================
ELIMINAR TABLAS SI EXISTEN
========================================================= */

DROP TABLE IF EXISTS ventas_final;
DROP TABLE IF EXISTS calendario;
DROP TABLE IF EXISTS ubicacion;
GO

/* =========================================================
TABLA ventas_final
========================================================= */

CREATE TABLE ventas_final (
    t_orden NVARCHAR(MAX),
    orden_ruc NVARCHAR(MAX),
    siaf_o_compra NVARCHAR(MAX),
    fecha_o_compra NVARCHAR(MAX),
    monto NVARCHAR(MAX),
    nombre_proveedor NVARCHAR(MAX),
    descripcion NVARCHAR(MAX),
    fecha_compra NVARCHAR(MAX),
    ano_compra NVARCHAR(MAX),
    mes_compra NVARCHAR(MAX),
    departamento NVARCHAR(MAX),
    provincia NVARCHAR(MAX),
    distrito NVARCHAR(MAX)
);
GO

/* =========================================================
TABLA calendario
========================================================= */

CREATE TABLE calendario (
    fecha VARCHAR(20),
    ano INT,
    mes INT,
    mes_nombre VARCHAR(50)
);
GO

/* =========================================================
TABLA ubicacion
========================================================= */

CREATE TABLE ubicacion (
    departamento NVARCHAR(100),
    provincia NVARCHAR(100),
    distrito NVARCHAR(100)
);
GO

/* =========================================================
IMPORTAR ventas_final
========================================================= */

BULK INSERT ventas_final
FROM 'C:\RUTA_DEL_PROYECTO\ventas_final.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    KEEPNULLS,
    TABLOCK,
    MAXERRORS = 1000
);
GO

/* =========================================================
IMPORTAR calendario
========================================================= */

BULK INSERT calendario
FROM 'C:\RUTA_DEL_PROYECTO\calendario.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    KEEPNULLS,
    TABLOCK,
    MAXERRORS = 1000
);
GO

/* =========================================================
IMPORTAR ubicacion
========================================================= */

BULK INSERT ubicacion
FROM 'C:\RUTA_DEL_PROYECTO\ubicacion.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    KEEPNULLS,
    TABLOCK,
    MAXERRORS = 1000
);
GO

/* =========================================================
DIMENSIÓN PROVEEDOR
========================================================= */

DROP TABLE IF EXISTS dim_proveedor;
GO

SELECT DISTINCT
    nombre_proveedor
INTO dim_proveedor
FROM ventas_final;
GO

/* =========================================================
DIMENSIÓN ORDEN
========================================================= */

DROP TABLE IF EXISTS dim_orden;
GO

SELECT DISTINCT
    t_orden,
    orden_ruc,
    siaf_o_compra
INTO dim_orden
FROM ventas_final;
GO

/* =========================================================
VALIDAR DATOS
========================================================= */

SELECT TOP 10 * FROM ventas_final;
SELECT TOP 10 * FROM calendario;
SELECT TOP 10 * FROM ubicacion;
GO

/* =========================================================
1. TOTAL DE VENTAS
========================================================= */

SELECT 
    SUM(
    TRY_CAST(REPLACE(monto, ',', '.') AS DECIMAL(18,2))
)
FROM ventas_final;
GO

/* =========================================================
2. VENTAS POR MES
========================================================= */

SELECT 
    c.ano,
    c.mes_nombre,

    SUM(
        TRY_CAST(REPLACE(v.monto, ',', '.') AS DECIMAL(18,2))
    ) AS total_ventas

FROM ventas_final v

INNER JOIN calendario c
    ON v.fecha_compra = c.fecha

GROUP BY 
    c.ano,
    c.mes,
    c.mes_nombre

ORDER BY 
    c.ano,
    c.mes;
GO

/* =========================================================
3. TOP 5 PROVEEDORES
========================================================= */

SELECT TOP 5
    nombre_proveedor,

    SUM(
        TRY_CAST(REPLACE(monto, ',', '.') AS DECIMAL(18,2))
    ) AS total_vendido

FROM ventas_final

GROUP BY nombre_proveedor

ORDER BY total_vendido DESC;
GO

/* =========================================================
4. VENTAS POR DISTRITO
========================================================= */

SELECT 
    departamento,
    provincia,
    distrito,

    SUM(
        TRY_CAST(REPLACE(monto, ',', '.') AS DECIMAL(18,2))
    ) AS total_ventas

FROM ventas_final

GROUP BY 
    departamento,
    provincia,
    distrito

ORDER BY total_ventas DESC;
GO

/* =========================================================
5. ÓRDENES POR DEPARTAMENTO
========================================================= */

SELECT 
    departamento,
    COUNT(*) AS total_ordenes

FROM ventas_final

GROUP BY departamento

ORDER BY total_ordenes DESC;
GO