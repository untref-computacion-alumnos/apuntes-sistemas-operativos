# Trabajo Práctico 3

## Ejercicio 1

En un computador con una memoria plana de 48k direcciones de 48 bits cada una, el sistema operativo
ocupa 14k direcciones. El sistema operativo se ubica en las direcciones más bajas. En este sistema
se produjo lo siguiente:

```txt
Sistema operativo
Comienza P1 (24KB)
Comienza P2 (18KB)
Comienza P3 (48KB)
Comienza P4 (36KB)
Fin P1
Fin P3
```

En el proceso 4 se declara una variable entera:

```c
int x[100];
```

Por un error de programación, el índice `i`, también entero, adquiere el valor -16211.

Ejecutando lo siguiente:

```c
for (int k = 0; k < 100; k++) {
    x[i++] = 0;
}
```

¿Qué ocurre sabiendo que los enteros ocupan 6B y que `x` está ubicado en la dirección 09FB?

1. Si no hay compactación.
2. Si hay compactación después que termina cada proceso.

## Ejercicio 2

Considerar un computador que posee un bus con 16 líneas de direcciones y 32 líneas de datos, en el
que cada dirección se refiere a una palabra de 32 bits. El sistema operativo ocupa 36KB y se
encuentra ubicado en las direcciones más bajas. En el mismo se instaló una memoria hasta la
dirección 13FFF. La primera partición fija es de 64KB y se ubica a continuación del sistema
operativo. En el resto de la memoria se planifica crear particiones chicas de 32KB.

1. ¿Cuántas particiones chicas se pueden crear?
2. ¿Se aprovecha bien la memoria instalada?
3. ¿En qué dirección comienza y en qué dirección termina cada partición?

## Ejercicio 3

En el mismo computador que el ejercicio anterior, el compilador compila los programas para ser
ejecutados en la partición grande.

¿Qué alteración debe hacer el _loader_ cuando carga un programa en la segunda partición chica?

## Ejercicio 4

En un computador con segmentos externos, cuya última dirección real es FFFFF, se instalaron 1024KB
de memoria. Cada dirección posee 16 bits. Los segmentos se crean en direcciones y tamaños que son
múltiplos de 16KB.

¿Cuántos bits posee el registro de la MMU que almacena la dirección de comienzo del segmento?

## Ejercicio 5

En un computador con segmentos internos, donde cada dirección posee 8 bits y en el que se instaló
una memoria de 1MB, se asignaron 32KB para el segmento de código (CS), 4KB para el segmento de datos
(DS), 50KB para el segmento del Stack (SS) y 28KB para el segmento extra (ES). Se sabe además que el
segmento de código comienza en la dirección 74000, el segmento de datos comienza en la dirección
38000, el segmento de stack comienza en la dirección 50000, el segmento extra comienza en la
dirección B0000.

1. ¿Dónde finaliza cada segmento?
2. Sabiendo que los primeros 64KB de la memoria real están ocupados por el sistema operativo. ¿Cuál
   es el fragmento desocupado de mayor tamaño? ¿Qué tamaño posee?
