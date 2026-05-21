# Trabajo Práctico 3 Resuelto

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

### Resolución Ejercicio 1

P1 hay 4k direcciones (24/6)
P2 hay 3k direcciones (18/6)
P3 hay 8k direcciones (48/6)
P4 hay 6k direcciones (36/6)

2^10 1KB, 2^20 1MB, 2^30 1GB, 2^40 1TB

0000 0000 0000 0000 a 1111 1111 1111 1111 son qué?

0000 en hexa a FFFF en hexa

14k = 8k + 4k + 2k

de 0 hexa a 8k esto requiere los 3 primeros bits en 0, luego dirección de comienza será todos los bits en 0, dirección final los 3 primeros bits en 0 y los demás en 1

0000 0000 0000 0000

0001 1111 0000 0000

o

0000H a 1FFF

0000 0FFF empiezan en la dirección 2000H a 2FFF

0000 07FF -> 3000H a 37FF

SO entonces de 0000 a 37FF es lo que ocupa el sistema operativo

el próximo proceso es 4k direcciones -> 0000 a 0FFF

P1 4000 a 4FFF

0000 03FF = 400 direcciones en hexa

P2 5000 a 53FF

P3 5400 a 73FF

P4 7400 a 8BFF

...

0 a 3FFF
0 a 7FFF 48k 0 BFFF

libre 8C00 a BFFF

3F53

5400 9FB 5DFB (x)

5DFB - 3F53

1EAA

SO + P2 + P3

## Ejercicio 2

Considerar un computador que posee un bus con 16 líneas de direcciones y 32 líneas de datos, en el
que cada dirección se refiere a una palabra de 32 bits. El sistema operativo ocupa 36KB y se
encuentra ubicado en las direcciones más bajas. En el mismo se instaló una memoria hasta la
dirección 13FFF. La primera partición fija es de 64KB y se ubica a continuación del sistema
operativo. En el resto de la memoria se planifica crear particiones chicas de 32KB.

1. ¿Cuántas particiones chicas se pueden crear?
2. ¿Se aprovecha bien la memoria instalada?
3. ¿En qué dirección comienza y en qué dirección termina cada partición?

### Resolución Ejercicio 2

cuentas en términos de 4 bits por dirección, si bien se pide esquema, c+alculo más o menos lo mismo

## Ejercicio 3

En el mismo computador que el ejercicio anterior, el compilador compila los programas para ser
ejecutados en la partición grande.

¿Qué alteración debe hacer el _loader_ cuando carga un programa en la segunda partición chica?

### Resolución Ejercicio 3

hay que calcular distancia entre particiones, compilo con part 5 y despues ejecuto en 4, verifico distancia de 5 y 4 porque eso es alteracion de direcciones que hay que saber

## Ejercicio 4

En un computador con segmentos externos, cuya última dirección real es FFFFF, se instalaron 1024KB
de memoria. Cada dirección posee 16 bits. Los segmentos se crean en direcciones y tamaños que son
múltiplos de 16KB.

¿Cuántos bits posee el registro de la MMU que almacena la dirección de comienzo del segmento?

### Resolución Ejercicio 4

ahora tiene segmentos, no hay necesidad de alterar procesos cuando se cargan, se ejecutan todos como si estuvieran en direccion 0, por lo qur anturarela de direccion distinta, pero X es la misma

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

### Resolución Ejercicio 5

ahora 4 segmentos, coddigo, datos, stack, extra, e distinstas direcciones, hacer mapa de memoria y donde fue a parar de toda la mem disoionible los segmentos que se cargaron, en el ejercicio se llega a computadorascuya direccion es de 8 bits como actuales, porque esotss elementos existiteron en procesadors de 8 bits

---

tp consiste en calcular direcciones... mandará versión corregida de cosnigna de tp, falta indicacion de proceso de donde esta vataible i

cuando indice x cae fuera de espacio asignado, el so cancela el proceso? no se entera que lo destruyen, en memoria plana el so no tiene proteccion
