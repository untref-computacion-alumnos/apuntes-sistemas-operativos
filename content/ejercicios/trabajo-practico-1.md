# Trabajo Práctico 1

## Ejercicio 1

Suponer que se está ejecutando en un computador en el que la CPU trabaja a 4 GHz, el BUS a 2 GHz y
la memoria tiene un tiempo de latencia de 80 nseg. Cumplido el cual puede transferir hasta 64 bytes
a la velocidad del bus. Suponer además que todo el programa reside en el cache, de manera que el
ciclo FETCH toma un ciclo de CPU, el ciclo DECODE toma otro ciclo de CPU y ciclo EXECUTE toma un
ciclo del BUS. En ese computador se desea ejecutar el siguiente loop de transferencia a disco.

```txt
              MOV R2, 1024      ;R2 = CANTIDAD DE BYTES
              MOV R1, DATOS     ;R1 = UBICACIÓN DE LOS DATOS
OTRO          OUT #17, (R1)     ;ESCRIBIR UN BYTE AL DISCO
              INC R1            ;APUNTAR AL DATO SIGUIENTE
              DEC R2            ;CONTAR EL DATO ENVIADO
              BNZ OTRO          ;A OCUPARSE DEL SIGUIENTE
```

¿Durante cuánto tiempo está ocupada la CPU?

## Ejercicio 2

La misma CPU ejecuta el mismo loop, pero desafortunadamente, hay un inconveniente que impide la
traducción **DEC R2** resida en el cache, lo que obliga a traerla de memoria principal cada ciclo. Esta
traducción ocupa dos bytes.

¿Cuánto se ocupa ahora la CPU?

## Ejercicio 3

En la misma CPU se realiza la misma transferencia utilizando el DMA, mediante el programa:

```txt
MOV R1, 1024          ;R1 = CANTIDAD DE BYTES
OUT #45, R1           ;INDICAR AL DMA LA CANTIDAD
MOV R1, DATOS         ;R1 = UBICACIÓN DE LOS DATOS
OUT #46, R1           ;INDICAR AL DMA EL LUGAR
MOV R1, 0xFF          ;R1 = INDICACIÓN DE ESCRITURA
OUT #47, R1           ;ORDENAR LA ESCRITURA
```

Suponiendo que todo el programa reside en el cache.

¿Durante cuánto tiempo está ocupada la CPU?

## Ejercicio 4

Si la unidad de DMA transfiere ráfagas de 64 bytes y luego espera 1000 nseg.

¿Cuánto tarda la transferencia antes de la próxima ráfaga?

## Ejercicio 5

Comparar los resultados de los ejercicios 1, 2 y 4.
