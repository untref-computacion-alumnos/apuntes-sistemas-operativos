# Trabajo Práctico 4

(trabajo-practico-4-ejercicio-1)=

## Ejercicio 1

Se tiene un sistema operativo con una memoria virtual de $16 \text{ TB}$, con una memoria real de $4 \text{ GB}$ y páginas de $32 \text{ KB}$, donde cada dirección corresponde a $1 \text{ B}$.

En el mismo, la dirección virtual `3F0EEEA0377` es convertida en la dirección real `1B68377`.

1. ¿Cuál es el número de página virtual?
2. ¿Cuál es el número de página real?
3. ¿Cuál es la dirección en la página?

Expresar los resultados en binario y hexadecimal.

(trabajo-practico-4-ejercicio-2)=

## Ejercicio 2

En el mismo sistema operativo del {ref}`trabajo-practico-4-ejercicio-1` ocurre que en la dirección indicada se encuentra el último byte de un arreglo de reales de doble presición.

```c
double x[16][126];
```

donde cada componente del arreglo ocupa $8 \text{ B}$.

1. ¿Todo el arreglo se ubica en la misma página?
2. ¿En qué dirección virtual comienza?

(trabajo-practico-4-ejercicio-3)=

## Ejercicio 3

En el mismo sistema operativo del {ref}`trabajo-practico-4-ejercicio-1` se dispone de una tabla de conversiones _TLB_ de $32$ filas.

Realizar un dibujo de essa tabla indicando las cantidades de bits de cada zona y el patrón de bits correspondiente a las direcciones indicadas.

(trabajo-practico-4-ejercicio-4)=

## Ejercicio 4

En el mismo sistema operativo del {ref}`trabajo-practico-4-ejercicio-1` se dispone de una memoria cache con las siguientes características:

- Bloques de $8 \text{ B}$.
- $1024$ líneas.

1. Realizar un esquema de esa memoria indicando el tamaño en bits de cada componente.
2. Presentar el patrón de bits que corresponde a cada componente.
3. Marcar cuál es el byte al que se accederá de ocurrir un acierto.

(trabajo-practico-4-ejercicio-5)=

## Ejercicio 5

En el contexto del sistema operativo y del cache del {ref}`trabajo-practico-4-ejercicio-4` se está ejecutando un proceso que utiliza un método estático ubicado en las direcciones `0000138` a `000CF2`, un loop en el **main** entre las direcciones `0023045` y `0025803` y la tercer fila de la matriz del {ref}`trabajo-practico-4-ejercicio-2`.

¿Puede ejecutarse totalmente en el cache del {ref}`trabajo-practico-4-ejercicio-4`?

(trabajo-practico-4-ejercicio-6)=

## Ejercicio 6

En el mismo sistema operativo del {ref}`trabajo-practico-4-ejercicio-1` se tienen dos procesos que comparten una matriz de números reales de $64 \times 64$. En el **proceso 1** la matriz comienza en el primer byte de la página virtual `1AEED1BA`, y en el **proceso 2** en el primer byte de la página virtual `04CC8B20`. Dicha matriz comienza en el primer byte de la página real `346B0`. Suponiendo además que esta matriz se encuentra ubicada en páginas virtuales y reales contiguas:

1. ¿En qué dirección virtual comienza el número correspondiente al último elemento de la matriz para el **proceso 1**?
2. ¿En qué dirección virtual comienza el número correspondiente al último elemento de la matriz para el **proceso 2**?
3. ¿En qué dirección real comienza el número correspondiente al último elemento de la matriz?

(trabajo-practico-4-ejercicio-7)=

## Ejercicio 7

Considerar un sistema operativo con una memoria virtual con páginas de $4 \text{ KB}$. Cada dirección refiere a $1 \text{ B}$. En el mismo existe un proceso que posee una matriz de números reales de $8 \text{ B}$ de $60 \text{ filas} \times 180 \text{ columnas}$. Se sabe además que esa matriz comienza su almacenamiento en la dirección virtual `5AFAF788`.

1. Escribir un fragmento de programa que coloque el valor `00D0` en las celdas `[1, 5]`, `[4, 14]`, `[7, 23]`... `[58, 176]`.
2. ¿Qué distancia en bytes existe entre dos accesos sucesivos a la matriz?
3. ¿A cuántas páginas se accederá durante el lazo completo?
4. ¿Dónde termina la matriz?

(trabajo-practico-4-ejercicio-8)=

## Ejercicio 8

Considerar una computadora con un _CPU_ capaz de acceder a una memoria de $64000$ direcciones de $48 \text{ B}$ cada una. El mismo posee una unidad de expansión de direccionamiento que permite direccionar $24 \text{ MB}$. Esta unidad divide la memoria en páginas de $12 \text{ KB}$. El sistema operativo ocupa las primeras $2$ páginas reales.

En un cierto instante se encuentran alojados tres procesos, que ocupan $45 \text{ KB}$, $33 \text{ KB}$ y $53 \text{ KB}$. El **proceso 1** tiene una asignadas las páginas reales $9$, $22$, $40$ y siguientes, el **proceso 2** tiene asignadas las páginas reales $30$ y las siguientes. finalmente el **proceso 3** tiene asignada las páginas reales $12$, $6$, $7$, $57$ y siguientes.

1. ¿Cómo estarían constituidas la tabla de conversión de direcciones?
2. Dibujar un esquema que muestre la relación entre la memoria virtual de los tres procesos y la memoria real.
3. ¿Cuánta memoria real queda disponible?

(trabajo-practico-4-ejercicio-9)=

## Ejercicio 9

Se tiene un sistema operativo con memoria virtual en el que se producen los siguientes pedidos de páginas:

`2, 6, 5, 7, 6, 0, 3, 5, 5, 3, 7, 5, 2, 4, 5, 2, 3, 7, 3, 7, 2, 1, 4, 3, 2, 5, 3, 6, 7, 6, 7, 4, 5, 3, 6, 3, 4`

¿Cuál es el menor número de páginas necesarias para que se produzcan menos de 6 fallos de páginas si se utiliza el algoritmo óptimo?

(trabajo-practico-4-ejercicio-10)=

## Ejercicio 10

Con los mismos datos del {ref}`trabajo-practico-4-ejercicio-9`:

¿Cuál es el menor número de páginas necesarias para que se produzcan menos de 6 fallos de páginas si se utiliza el algoritmo **FIFO**?

(trabajo-practico-4-ejercicio-11)=

## Ejercicio 11

Con los mismos datos del {ref}`trabajo-practico-4-ejercicio-9`:

¿Cuál es el menor número de páginas necesarias para que se produzcan menos de 6 fallos de páginas si se utiliza el algoritmo **LRU**?

(trabajo-practico-4-ejercicio-12)=

## Ejercicio 12

Con los mismos datos del {ref}`trabajo-practico-4-ejercicio-9`:

¿Cuál es el menor número de páginas necesarias para que se produzcan menos de 6 fallos de páginas si se utiliza el algoritmo **clock**?
