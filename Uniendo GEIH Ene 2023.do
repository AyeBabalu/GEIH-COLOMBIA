***************************************************************************************
* 		Código Stata para la Construcción de la Base de Datos GEIH – Enero 2023       *
***************************************************************************************
/*
Este script en Stata procesa y estructura los datos de la GEIH para enero de 2023, con 
la opción de adaptarlo a otros meses y años modificando el mes, la carpeta de origen y 
la de destino.

El código une módulos clave de las personas: Características generales, seguridad social 
en salud y educación, Educación; Fuerza de trabajo; Migración; No ocupados; Ocupados; 
Otras formas de trabajo; Otros ingresos e impuestos; generando una base consolidada.

Variables clave para la union de las bases de datos: directorio, secuencia_p, orden.
*/

cls // Para borrar todo el contenido de la pantalla de resultados
clear all // Limpia la memoria de Stata
set more off // Evita que Stata pause el proceso al mostrar resultados largos

* Rutas
global origen "C:\datos\2023\Enero"

* Cargar el primer componente: Características generales
use "${origen}\Características generales, seguridad social en salud y educación.DTA", clear

* Unir los demás componentes
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "${origen}\Ocupados.DTA", nogenerate force
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "${origen}\No Ocupados.DTA", nogenerate force
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "${origen}\Fuerza de Trabajo.DTA", nogenerate force
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "${origen}\Migración.DTA", nogenerate force
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "${origen}\Otros ingresos e impuestos.DTA", nogenerate force
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "${origen}\Otras formas de trabajo.DTA", nogenerate force

* Estandarizar nombres y limpieza
capture rename _all, lower
drop mes p6030s1 p6030s3 p6080s1 p3044 p6430s1 p6765s1 p6780s1 p6810s1 p6830s1 p6880s1 p6915s1 p7028s1 p1880s1 p3051s1 p3052s1 p3058s1 p3058s2 p3058s3 p3058s4 p3058s5 p3062s1 p3062s2 p3062s3 p3062s4 p3062s5 p3062s6 p3062s7 p3062s8 p3062s9 p7330 p6240s1 p6260s1a1 p6310s1 p3147s10a1 p3362s7a1 p3386s1 p3064s1 p3086s1 p3089s3
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
save "${origen}\Enero.dta", replace

