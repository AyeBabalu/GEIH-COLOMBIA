***************************************************************************************
* 		 Código Stata para la Construcción de la Base de Datos GEIH – Año 2023        *
***************************************************************************************
/*
Este script en Stata procesa y estructura los datos de la GEIH para todo el año 2023, 
permitiendo su adaptación a otros años con mínimos cambios en rutas y parámetros.

El código integra módulos clave de las personas: Características generales, Seguridad 
social en salud y Educación; Fuerza de trabajo; Migración; No ocupados; Ocupados; 
Otras formas de trabajo; Otros ingresos e impuestos, consolidando una única base anual.

Variables clave para la unión de las bases de datos: directorio, secuencia_p, orden.
*/

cls // Para borrar todo el contenido de la pantalla de resultados
clear all // Limpia la memoria de Stata
set more off // Evita que Stata pause el proceso al mostrar resultados largos

* Definir ruta de origen
global origen "C:\datos\2023\"

* Loop para recorrer todos los meses
forvalues i = 1/12 {

    * Definir nombre del mes
    local mes
    if `i' == 1 local mes "Enero"
    if `i' == 2 local mes "Febrero"
    if `i' == 3 local mes "Marzo"
    if `i' == 4 local mes "Abril"
    if `i' == 5 local mes "Mayo"
    if `i' == 6 local mes "Junio"
    if `i' == 7 local mes "Julio"
    if `i' == 8 local mes "Agosto"
    if `i' == 9 local mes "Septiembre"
    if `i' == 10 local mes "Octubre"
    if `i' == 11 local mes "Noviembre"
    if `i' == 12 local mes "Diciembre"

    * Definir la ruta para cada mes
    global mes_origen "${origen}\`mes'"

    * Cargar el primer componente: Características generales
    use "${mes_origen}\Características generales, seguridad social en salud y educación.DTA", clear

    * Unir los demás componentes
    merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "${mes_origen}\Ocupados.DTA", nogenerate force
    merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "${mes_origen}\No ocupados.DTA", nogenerate force
    merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "${mes_origen}\Fuerza de trabajo.DTA", nogenerate force
    merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "${mes_origen}\Migración.DTA", nogenerate force
    merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "${mes_origen}\Otros ingresos e impuestos.DTA", nogenerate force
    merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "${mes_origen}\Otras formas de trabajo.DTA", nogenerate force

    * Estandarizar nombres y limpieza
    capture rename _all, lower
    drop mes p6030s1 p6030s3 p6080s1 p3044 p6430s1 p6765s1 p6780s1 p6810s1 p6830s1 p6880s1 p6915s1 p7028s1 p1880s1 p3051s1 p3052s1 p3058s1 p3058s2 p3058s3 p3058s4 p3058s5 p3062s1 p3062s2 p3062s3 p3062s4 p3062s5 p3062s6 p3062s7 p3062s8 p3062s9 p6240s1 p6260s1a1 p6310s1 p3147s10a1 p3362s7a1 p3386s1 p3064s1 p3086s1 p3089s3
    capture destring p3054s1, replace
    capture destring p3055s1, replace
    capture destring p3063s1, replace
    capture destring p3051, replace
    capture destring p3052, replace
    capture destring p3057, replace
    capture destring p3059, replace
    capture destring p3087s1, replace

    * Agregar la variable del mes
    gen mes = "`mes'"

    * Guardar el archivo consolidado del mes
    save "${mes_origen}\`mes'.dta", replace
}

clear all

***************************************************************************************
* Consolidar todos los meses del año 2023
***************************************************************************************

* Rutas
global origen "C:\datos\2023\"
global destino "C:\datos"

set more off

* Crear una base consolidada de todos los meses
clear
local meses "Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre"

foreach mes in `meses' {
    append using "${origen}\`mes'.dta", force
}

* Guardar la base consolidada
save "${destino}\2023.dta", replace






