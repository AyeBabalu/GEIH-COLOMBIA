***************************************************************************************
* 		Código Stata para la Construcción de la Base de Datos GEIH – Enero 2021       *
***************************************************************************************
/*
Este script en Stata procesa y estructura los datos de la GEIH para enero de 2021, con 
la opción de adaptarlo a otros meses y años modificando el mes, la carpeta de origen y 
la de destino.

El código une módulos clave de las personas: Características generales, seguridad social 
en salud y educación, Educación; Fuerza de trabajo; Migración; No ocupados; Ocupados; 
Otras formas de trabajo; Otros ingresos e impuestos; generando una base consolidada, 
teniendo en cuanta las diferentes zonas.  

Variables clave para la union de las bases de datos: directorio, secuencia_p, orden.
*/

cls // Para borrar todo el contenido de la pantalla de resultados
clear all // Limpia la memoria de Stata
set more off // Evita que Stata pause el proceso al mostrar resultados largos

***************************************************************************************
* Procesamiento del mes de Enero 2021
***************************************************************************************

* Definir ruta de origen y destino
global origen "C:\Users\Camilo Sua\OneDrive\Trabajo de grado\datos\2021\Enero"
global destino "C:\Users\Camilo Sua\OneDrive\Trabajo de grado\datos\2021"

set more off
clear all

* Cargar el primer componente: Área - Características generales (Personas)
use "${origen}\Área - Características generales (Personas).dta", clear

* Unir los demás componentes manualmente
* Para Área
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "${origen}\Área - Ocupados.dta", nogenerate force
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "${origen}\Área - Desocupados.dta", nogenerate force
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "${origen}\Área - Fuerza de Trabajo.dta", nogenerate force
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "${origen}\Área - Inactivos.dta", nogenerate force
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "${origen}\Área - Otros ingresos.dta", nogenerate force
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "${origen}\Área - Otras actividades y ayudas en la semana.dta", nogenerate force

* Para Cabecera
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "${origen}\Cabecera - Ocupados.dta", nogenerate force
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "${origen}\Cabecera - Desocupados.dta", nogenerate force
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "${origen}\Cabecera - Fuerza de Trabajo.dta", nogenerate force
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "${origen}\Cabecera - Inactivos.dta", nogenerate force
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "${origen}\Cabecera - Otros ingresos.dta", nogenerate force
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "${origen}\Cabecera - Otras actividades y ayudas en la semana.dta", nogenerate force

* Para Resto
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "${origen}\Resto - Ocupados.dta", nogenerate force
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "${origen}\Resto - Desocupados.dta", nogenerate force
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "${origen}\Resto - Fuerza de Trabajo.dta", nogenerate force
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "${origen}\Resto - Inactivos.dta", nogenerate force
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "${origen}\Resto - Otros ingresos.dta", nogenerate force
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "${origen}\Resto - Otras actividades y ayudas en la semana.dta", nogenerate force

* Estandarizar nombres y limpieza
capture rename _all, lower
drop mes p6030s1 p6030s3 p6080s1
capture destring p3054s1, replace
capture destring p3055s1, replace
capture destring p3063s1, replace
capture destring p3051, replace
capture destring p3052, replace
capture destring p3057, replace
capture destring p3059, replace
capture destring p3087s1, replace

* Agregar la variable del mes
gen mes = "Enero"

* Guardar el archivo consolidado del mes
save "${destino}\Enero.dta", replace



