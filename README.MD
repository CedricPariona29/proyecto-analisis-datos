## Proyecto Dashboard Analisis de Datos

## AUTOR

- Cedric Pariona

## Dashboard Analítico Multisectorial de Órdenes de Compra y Servicios

Proyecto desarrollado utilizando:
- Python
- SQL Server
- Power BI

## Vista previa del dashboard

El proyecto incluye un PDF exportado del dashboard desarrollado en Power BI para visualización de KPIs y análisis interactivo.

## Contenido del proyecto

- notebooks/: procesos ETL, perfilado y KPIs
- sql/: consultas SQL y modelo dimensional
- dashboard/: archivo Power BI
- datos/: datasets crudos y procesados

# MANUAL DE INSTALACIÓN Y EJECUCIÓN

## Requisitos

* Python 3.x
* SQL Server
* Power BI Desktop
* Google Colab o Jupyter Notebook

## Pasos de ejecución

1. Descomprimir la carpeta del proyecto.

2. Abrir la carpeta `notebooks/`.

3. Ejecutar los notebooks:

* 01_perfilado.ipynb
* 02_limpieza_etl.ipynb
* 03_analisis_kpis.ipynb

4. Abrir SQL Server y ejecutar:

* queries_integracion.sql

5. Abrir Power BI Desktop.

6. Abrir:

* dashboard_mvp.pbix

7. Verificar conexión con datasets ubicados en:

* datos/raw/
* datos/processed/

## Resultado esperado

El dashboard permitirá visualizar KPIs, análisis temporal y segmentación interactiva de órdenes de compra y servicios.
