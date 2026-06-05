# Trabajo Práctico 3

(trabajo-practico-3-ejercicio-1)=

## Ejercicio 1

En un computador con una memoria plana de $48000$ direcciones de $48 \text{ b}$ cada una, el sistema operativo ocupa $14000$ direcciones. El sistema operativo se ubica en las direcciones más bajas. En este sistema se produjo lo siguiente:

```txt
Sistema operativo
Comienza P1 (24 KB)
Comienza P2 (18 KB)
Comienza P3 (48 KB)
Comienza P4 (36 KB)
Fin P1
Fin P3
```

En el proceso 4 (**P4**) se declara una variable entera:

```c
int x[100];
```

Por un error de programación, el índice `i`, también entero, adquiere el valor `-16211`.

Ejecutando lo siguiente:

```c
for (int i = 0; i < 100; i++) {
    x[i++] = 0;
}
```

¿Qué ocurre sabiendo que los enteros ocupan $6 \text{ B}$ y que `x` está ubicado en la dirección `09FB`?

1. Si no hay compactación.
2. Si hay compactación después que termina cada proceso.

(trabajo-practico-3-ejercicio-2)=

## Ejercicio 2

Considerar un computador que posee un bus con $16$ líneas de direcciones y $32$ líneas de datos, en el que cada dirección se refiere a una palabra de $32 \text{ b}$. El sistema operativo ocupa $36 \text{ KB}$ y se encuentra ubicado en las direcciones más bajas. En el mismo se instaló una memoria hasta la dirección `EFFF`. La primera partición fija es de $64 \text{ KB}$ y se ubica a continuación del sistema operativo. En el resto de la memoria se planifica crear particiones chicas de $32 \text{ KB}$.

1. ¿Cuántas particiones chicas se pueden crear?
2. ¿Se aprovecha bien la memoria instalada?
3. ¿En qué dirección comienza y en qué dirección termina cada partición?

(trabajo-practico-3-ejercicio-3)=

## Ejercicio 3

En el mismo computador que el {ref}`trabajo-practico-3-ejercicio-2`, el compilador compila los programas para ser ejecutados en la partición grande.

¿Qué alteración tiene que hacer el _loader_ cuando carga un programa en la segunda partición chica?

(trabajo-practico-3-ejercicio-4)=

## Ejercicio 4

En un computador con segmentos externos, cuya última dirección real es `FFFFF`, se instalaron $1024 \text{ KB}$ de memoria. Cada dirección posee $16 \text{ b}$. Los segmentos se crean en direcciones y tamaños que son múltiplos de $16 \text{ KB}$.

¿Cuántos bits posee el registro de la _MMU_ que almacena la dirección de comienzo del segmento?

(trabajo-practico-3-ejercicio-5)=

## Ejercicio 5

En un computador con segmentos internos, donde cada dirección posee $8 \text{ b}$ y en el que se instaló una memoria de $1 \text{ MB}$, se asignaron $32 \text{ KB}$ para el segmento de código (_CS_), $4 \text{ KB}$ para el segmento de datos (_DS_), $50 \text{ KB}$ para el segmento del _stack_ (_SS_) y $28 \text{ KB}$ para el segmento extra (_ES_). Se sabe además que el segmento de código comienza en la dirección `74000`, el segmento de datos comienza en la dirección `38000`, el segmento de _stack_ comienza en la dirección `50000`, el segmento extra comienza en la dirección `B0000`.

1. ¿Dónde finaliza cada segmento?
2. Sabiendo que los primeros $64 \text{ KB}$ de la memoria real están ocupados por el sistema operativo.
   - ¿Cuál es el fragmento desocupado de mayor tamaño?
   - ¿Qué tamaño posee?
