# Trabajo Práctico 1

(trabajo-practico-1-ejercicio-1)=

## Ejercicio 1

Suponer que se está ejecutando en un computador en el que la _CPU_ trabaja a $4 \text{ GHz}$, el BUS a $2 \text{ GHz}$ y la memoria tiene un tiempo de latencia de $80 \text{ ns}$. Cumplido el cual puede transferir hasta $64 \text{ B}$ a la velocidad del BUS. Suponer además que todo el programa reside en el caché, de manera que el ciclo **FETCH** toma un ciclo de _CPU_, el ciclo **DECODE** toma otro ciclo de _CPU_ y ciclo **EXECUTE** toma un ciclo del BUS. En ese computador se desea ejecutar el siguiente loop de transferencia a disco.

```txt
              MOV R2, 1024      ;R2 = CANTIDAD DE BYTES
              MOV R1, DATOS     ;R1 = UBICACIÓN DE LOS DATOS
OTRO          OUT #17, (R1)     ;ESCRIBIR UN BYTE AL DISCO
              INC R1            ;APUNTAR AL DATO SIGUIENTE
              DEC R2            ;CONTAR EL DATO ENVIADO
              BNZ OTRO          ;A OCUPARSE DEL SIGUIENTE
```

¿Durante cuánto tiempo está ocupada la _CPU_?

(trabajo-practico-1-ejercicio-2)=

## Ejercicio 2

La misma _CPU_ ejecuta el mismo loop, pero desafortunadamente, hay un inconveniente que impide la traducción `DEC R2` resida en el caché, lo que obliga a traerla de memoria principal cada ciclo. Esta traducción ocupa $2 \text{ B}$.

¿Cuánto se ocupa ahora la _CPU_?

(trabajo-practico-1-ejercicio-3)=

## Ejercicio 3

En la misma _CPU_ se realiza la misma transferencia utilizando el _DMA_, mediante el programa:

```txt
MOV R1, 1024          ;R1 = CANTIDAD DE BYTES
OUT #45, R1           ;INDICAR AL DMA LA CANTIDAD
MOV R1, DATOS         ;R1 = UBICACIÓN DE LOS DATOS
OUT #46, R1           ;INDICAR AL DMA EL LUGAR
MOV R1, 0xFF          ;R1 = INDICACIÓN DE ESCRITURA
OUT #47, R1           ;ORDENAR LA ESCRITURA
```

Suponiendo que todo el programa reside en el caché.

¿Durante cuánto tiempo está ocupada la _CPU_?

(trabajo-practico-1-ejercicio-4)=

## Ejercicio 4

Si la unidad de _DMA_ transfiere ráfagas de $64 \text{ B}$ y luego espera $1000 \text{ ns}$.

¿Cuánto tarda la transferencia antes de la próxima ráfaga?

## Ejercicio 5

Comparar los resultados del {ref}`trabajo-practico-1-ejercicio-1`, {ref}`trabajo-practico-1-ejercicio-2` y {ref}`trabajo-practico-1-ejercicio-4`.
